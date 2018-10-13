#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cpmbdos.h"
#include "cprintf.h"
#include "syslib/cpm_sysfunc.h"
#include "syslib/ansi_term.h"
#include <setjmp.h>
#include "../../src/hw/common/hw_common.h"

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

int main() { // (int argc, char ** argv) {
    int argc;
    char **argv;
    int i, j;

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    for(i=0; i<40; i++) {
        hw_outp(131, 0);   // x=0
        hw_outp(131, i);   // y=0..15
        hw_outp(131, 80);  // count
        for(j=0; j<16; j++) {
            hw_outp(131, ((i%16)*16)+j);
        }
        for(j=0; j<16; j++) {  hw_outp(131, 0x15);  }
        for(j=0; j<16; j++) {  hw_outp(131, 0x16);  }
        for(j=0; j<16; j++) {  hw_outp(131, 0x17);  }
        for(j=0; j<16; j++) {  hw_outp(131, 0x18);  }
        //for(j=0; j<16; j++) {  hw_outp(131, 0x20);  }
    }
    for(i=0; i<40; i++) {
    
        hw_outp(132, i);  // set color on row i
        hw_outp(132, 0x80 | i);
    }

    return 0;
}

