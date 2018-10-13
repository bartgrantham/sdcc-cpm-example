#include <setjmp.h>
#include "minboop.h"

#define printf cprintf

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
int main() { // (int argc, char ** argv) {
    int argc;
    char **argv;

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    printf("Boopo!\n");
    // $FD,$00, $BA,$00, $8E,$00,  $00,  $38,  $10,$10,$10,  $A1,$07,  $09,  $00,$00
    //
    ym_reg(0, 0xFD);   // channel A 0:7
    ym_reg(1, 0);      // channel A 8:11 (bottom nybble)
    ym_reg(2, 0xBA);   // channel B 0:7
    ym_reg(3, 0);      // channel B 8:11 (bottom nybble)
    ym_reg(4, 0x8E);   // channel C 0:7
    ym_reg(5, 0);      // channel C 8:11 (bottom nybble)
    ym_reg(6, 0);      // noise period
    ym_reg(7, 0x38);   // tone/noise enable
    ym_reg(8, 0x10);   // channel A volume
    ym_reg(9, 0x10);   // channel B volume
    ym_reg(10, 0x10);  // channel C volume
    ym_reg(11, 0xA1);  // envelope period 0:7
    ym_reg(12, 0x07);  // envelope period 8:15
    ym_reg(13, 0x09);  // envelope shape 0:3 (bottom nybble)
    ym_reg(14, 0x00);  // port A (unused)
    ym_reg(15, 0x00);  // port B (unused)

    return 0;
}

