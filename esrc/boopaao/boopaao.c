#include <setjmp.h>
#include "boopaao.h"

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

void boop(void) __naked {
    // $FD,$00, $BA,$00, $8E,$00,  $00,  $38,  $10,$10,$10,  $A1,$07,  $09,  $00,$00
    __asm
        push af
        ld a, #16
        out (129), a

        ld a, #0xFD
        out (129), a
        
        ld a, #0
        out (129), a
 
        ld a, #0xBA
        out (129), a
 
        ld a, #0
        out (129), a

        ld a, #0x8E
        out (129), a

        ld a, #0
        out (129), a

        ld a, #0
        out (129), a

        ld a, #0x38
        out (129), a

        ld a, #0x10
        out (129), a

        ld a, #0x10
        out (129), a

        ld a, #0x10
        out (129), a

        ld a, #0xA1
        out (129), a

        ld a, #0x07
        out (129), a

        ld a, #0x09
        out (129), a

        ld a, #0
        out (129), a

        ld a, #0
        out (129), a

        pop af
        ret
    __endasm;
}

int main() { // (int argc, char ** argv) {
    int argc;
    char **argv;

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    printf("Boop!\n");
    boop();

    return 0;
}

