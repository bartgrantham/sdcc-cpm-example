#include <setjmp.h>
#include "cttestb.h"
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

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    printf("Clock set to: ");
    hw_outp(130, 0);
    hw_outp(130, 0x93);   // little endian first!
    hw_outp(130, 0x18);
    hw_outp(130, 0x04);
    hw_outp(130, 0);

    printf("10000Hz");

    return 0;
}

