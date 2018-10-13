#include "ymr.h"
#include <setjmp.h>
#include "../../src/hw/common/hw_common.h"

#define printf cprintf

/*
//  DOESN'T WORK!!!  Why?  SDCC is stupid.
void ym_reg(uint8_t i, uint8_t r) { //__naked {
    i;  r;
    __asm
      // Too bad sdcc sucks and doesn't support the ED prefix, or this might actually work...
      //out (129), l
      //out (129), h
      // ... oh well.  We'll do it the slow way.
      ld a, l
      out (129), a
      ld a, h
      out (129), a
    __endasm;
}
*/

char *bufferloc;

static int get_sector(FILE *fp, unsigned short sector)
{
    int rval;
    cpm_setDMAAddr((uint16_t)fp->sector);
    fp->fcb.rrec = sector;
    rval = cpm_performFileOp(fop_readRandRecord, &fp->fcb);
    return rval;
}

FILE *fopen(const char* filename, const char* mode)
{
    uint8_t rval;
    FILE *fp;
    static char file_base[9];
    static char file_ext[4];
    const char *p;
    char *fb, *fb_last;
    char *fe, *fe_last;

    mode; // XXX should probably not ignore "mode"...

    fp = malloc(sizeof(FILE));
    if(fp == NULL) {
        /* XXX */ printf("failed to malloc\n");
        return NULL;
    }
    memset(fp, 0, sizeof(FILE));

    p = filename; 
    memset(file_base, 0, sizeof(file_base));
    memset(file_ext, 0, sizeof(file_ext));

    /* copy base part */
    fb = file_base;
    fb_last = file_base + sizeof(file_base) - 1;
    while((fb < fb_last) && *p && (*p != '.'))
         *fb++ = *p++;
    *fb = '\0';

    /* find . or end of name */
    for(;*p && (*p != '.'); p++);

    /* copy ext part */
    if(!*p)
        file_ext[0] = 0;
    else {
        fe = file_ext;
        fe_last = file_ext + sizeof(file_ext) - 1;
        p++;
        while((fe < fe_last) && *p)
             *fe++ = *p++;
        *fe = '\0';
    }

    cpm_setFCBname(file_base, file_ext, &fp->fcb);

    rval = cpm_performFileOp(fop_open, &fp->fcb);
    if(rval == 0xFF) {
        free(fp);
        /* XXX */ printf("failed to open \"%s\".\"%s\"\n", file_base, file_ext);
        return NULL;
    }

    cpm_performFileOp(fop_calcFileSize, &fp->fcb);
    fp->sector_count = fp->fcb.rrec;

    fp->current_sector = -1;
    fp->previous_within_sector = SECTOR_SIZE - 1;

    return fp;
}

int fgetc(FILE *fp)
{
    int rval;

    fp->previous_within_sector++;

    if(fp->previous_within_sector >= SECTOR_SIZE) {

        fp->current_sector ++;
        if(fp->current_sector >= fp->sector_count)
            return -1;

        fp->previous_within_sector = 0;
        rval = get_sector(fp, fp->current_sector);
        if(rval != 0) 
            return -1;
    }

    return fp->sector[fp->previous_within_sector];
}

int feof(FILE *fp)
{
    return fp->current_sector >= fp->sector_count;
}

int fclose(FILE *fp)
{
    uint8_t rval = cpm_performFileOp(fop_close, &fp->fcb);
    free(fp);
    return rval == 0; // XXX
}

char sys_argv0[12];
char *sys_argv[8];
void sys_init(int *argc, char ***argv)
{
    char *p;
    unsigned char count;

    cpm_sysfunc_init();

    p = (char*)0x81; // CCP Command Tail
    count = *(unsigned char*)0x80; // CCP Command Tail Length

    *argc = 1;
    sys_argv[0] = strcpy(sys_argv0, "ym.com");

    p[count] = '\0'; // XXX count < 128!
    do {
        while(*p == ' ')
            p++;
        if(!*p)
            break;
        sys_argv[(*argc)++] = p;
        while(*p && (*p != ' '))
            p++;
        if(!*p)
            break;
        *p++ = '\0';
    } while(*p && (*argc < 8));

    *argv = sys_argv;
}

int exit_value;
jmp_buf exit_jmp;

void exit(int value)
{
    exit_value = value;
    longjmp(exit_jmp, 1);
}

void writeym(char * registers) {
    registers;
    __asm
        ld      hl, #2+0
        add     hl, sp
        ld b, #16
        ld c, #129
        otir
    __endasm;
}


int main() { // (int argc, char ** argv) {
    int argc;
    char **argv;
    FILE *ymfile;
    char *ymfilename, *songname, *authorname, *comment, buffer[16];
    struct ymheader header;
    int  i;
    uint8_t r, z;

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    if ( argc < 2 ) {
        printf("Usage: ymr ymrawsng.ymr\n");
        return 1;
    }

    ymfilename = argv[1];

    ymfile = fopen(ymfilename, "rb");
    
    if ( ! ymfile ) {
        printf("Could not find ym file: %s\n", ymfilename);
        return 2;
    }

    read_header(ymfile, &header);

    printf("Number of frames: %lu\n", header.frames);
    printf("Attributes      : %lu\n", header.attr);
    printf("Digidrums       : %u\n", header.digidrums);
    printf("AY Clock        : %lu ", header.ymclock);
    if      ( header.ymclock == 2000000 ) {  printf("(Atari ST)\n");  }
    else if ( header.ymclock == 1773400 ) {  printf("(ZX Spectrum)\n");  }
                                     else {  printf("(Unknown)\n");  }
    printf("Frame Hz        : %u\n", header.framehz);
    printf("Loop Frame      : %lu ", header.loopframe);
    printf(header.loopframe == 0 ? "(Beginning)\n" : "\n");
    printf("\"Future\" bytes  : %lu\n", header.future);

    songname = ztstr(ymfile, BUFSZ, "songname");
    printf("Song Name       : \"%s\"\n", songname);

    authorname = ztstr(ymfile, BUFSZ, "authorname");
    printf("Author Name     : \"%s\"\n", authorname);

    comment = ztstr(ymfile, BUFSZ, "comment");
    printf("Comment         : \"%s\"\n", comment);

    printf("AY-3-8910 register data follows:\n");

    printf("    ...\n");
    for(i=0; i < header.frames; i++) {
        // fill buffer
        for(r=0; r<16; r++) {
            buffer[r] = fgetc(ymfile);
        }
        // wait here
        z = hw_inp(130);
        while( z == hw_inp(130) ) {  }
        // write buffer

        bufferloc = buffer;
        __asm
            push bc
            push hl
            ld      hl, (_bufferloc)
            ld b, #16
            ld c, #129
            out (c), b
            otir
            pop hl
            pop bc
        __endasm;
//        for(r=0; r<16; r++) {
//            hw_outp(129, r);
//            hw_outp(129, buffer[r]);
//        }
    }

    for(i=0; i<4; i++) {
        if ( fgetc(ymfile) != "End!"[i] ) {
            printf("Warning: End-of-YM6 was not \"End!\"\n");
        }
    }

    printf("After \"End!\"    : %.2X\n", fgetc(ymfile));

    for(r=0; r<16; r++) {
        buffer[r] = 0;
    }
    bufferloc = buffer;

    __asm
        push bc
        push hl
        ld      hl, (_bufferloc)
        ld b, #16
        ld c, #129
        out (c), b
        otir
        pop hl
        pop bc
    __endasm;

    return 0;
}

char * ztstr(FILE * ymfile, int limit, char * errctx) {
    char buffer[BUFSZ], *str;
    int i;
    for(i=0; (i <= limit) && (i < BUFSZ); i++) {
        if ( feof(ymfile) ) {
            printf("Error reading %s: unexpected end-of-file\n", errctx);
            exit(3);
        }
        buffer[i] = fgetc(ymfile);
        if ( buffer[i] == '\0' ) {
            break;
        }
    }
    if ( (i > limit) || (i>= BUFSZ) || (buffer[i] != '\0') ) {
        printf("Error reading %s: buffer overrun\n", errctx);
        exit(3);
    }
    str = malloc(i+1);
    strncpy(str, buffer, i+1);
    return str;
}

uint32_t beu32(FILE * ymfile, char * errctx) {
    uint32_t num=0;
    int32_t i;
    for(i=3; i >= 0; i--) {
        if ( feof(ymfile) ) {
            printf("Error reading %s: buffer overrun\n", errctx);
        }
        num = num | ((uint32_t)fgetc(ymfile) << (i*8));
    }
    return num;
}

uint16_t beu16(FILE * ymfile, char * errctx) {
    uint16_t num=0;
    int32_t i;
    for(i=1; i >= 0; i--) {
        if ( feof(ymfile) ) {
            printf("Error reading %s: buffer overrun\n", errctx);
        }
        num = num | ((uint16_t)fgetc(ymfile) << (i*8));
    }
    return num;
}


/* why not just "fread(&header, sizeof(header), 1, ymfile)"?  I have no idea
 * what kind of struct packing pragmas exist in the 1980's Z80 C compiler
 * we're using.  This also gives me a chance to byte-swap and verify things.
 */
void read_header(FILE * ymfile, struct ymheader *header) {
    int i;
    for(i=0; i<4; i++) {
        header->id[i] = fgetc(ymfile);
    }
    for(i=0; i<8; i++) {
        header->check[i] = fgetc(ymfile);
    }

    if ( (strncmp(header->id, "YM6!", 4) != 0) ||
         (strncmp(header->check, "LeOnArD!", 8) != 0) ) {
        printf("Not a YM6 file!\n");
        exit(3);
    }

    header->frames = beu32(ymfile, "header/frames");
    header->attr = beu32(ymfile, "header->attr");
    header->digidrums = beu16(ymfile, "header->digidrums");
    header->ymclock = beu32(ymfile, "header->ymclock");
    header->framehz = beu16(ymfile, "header->framehz");
    header->loopframe = beu32(ymfile, "header->loopframe");
    header->future = beu16(ymfile, "header->future");
}
