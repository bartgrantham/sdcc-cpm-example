#include <setjmp.h>
#include "cpuspeed.h"
#include "../../src/hw/common/hw_common.h"

#define printf cprintf

#define MAXARGS 17

char sys_argv0[13];
char *sys_argv[MAXARGS];
void sys_init(int *argc, char ***argv)
{
    char *p;
    unsigned char count;

    cpm_sysfunc_init();

    p = (char*)0x81; // CCP Command Tail
    count = *(unsigned char*)0x80; // CCP Command Tail Length

    *argc = 1;
    sys_argv[0] = strcpy(sys_argv0, "cpmenv.com");

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
    } while(*p && (*argc < MAXARGS));

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
    long long int speed = 123456;

    sys_init(&argc, &argv);
    if(setjmp(exit_jmp) != 0)
        return exit_value;

    speed = atol(argv[1]);
    printf("Setting clock to %ll fps", speed);
    //for(i=0; i<argc; i++) {
    //    printf("%s\n", argv[i]);
    //}

    return 0;
}

