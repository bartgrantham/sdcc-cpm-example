#include <setjmp.h>
#include "asmtest.h"

#define printf cprintf

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

    // XXX should probably not ignore "mode"...
    mode;

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

void whatasm(char * outstring) {
    printf(outstring);
}

unsigned char output = 'B';

extern char foo[5] = { 'q', 'u', 'u', 'x', '\0' };
void asmtest(char * string, int len) {  // __naked
    string;
    len;
    __asm
        pop hl
        pop bc
        //ld b, #3
        ld c, #128
        outi // why doesn't this work?
        push bc
        push hl
        //ld a, #98
        //out (128), a
        //ret
    __endasm;
}

//void direct_video_char() __preserves_regs(a, f, b, c, d, e, h, l, ixl, ixy, iyl, iyh);

void direct_video_char(void) __naked {
    __asm
        push af
        ld a, #98
        out (128), a
        pop af
        ret
    __endasm;
}

void ay_envelope(void) __naked {
    __asm
        push af
        ld a, #9
        out (129), a
        pop af
        ret
    __endasm;
}

int main() { // (int argc, char ** argv) {
    int argc;
    char **argv;
    char greet[6] = "Hello";

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    printf("Before...\n");
    //whatasm(greet);
    asmtest("FOO", 4);
    //ay_envelope();

    printf("\n...After\n");

    return 0;
}

