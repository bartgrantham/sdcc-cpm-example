#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include <stdint.h>
//
// typedef unsigned long int uint32_t;
// typedef long int int32_t;

#include "cpmbdos.h"
#include "cprintf.h"
#include "syslib/cpm_sysfunc.h"
#include "syslib/ansi_term.h"

#define SECTOR_SIZE     128

typedef struct FILE {
    FCB fcb;
    long int sector_count;
    unsigned char sector[SECTOR_SIZE];
    long int current_sector;
    unsigned char previous_within_sector;
} FILE;

FILE *fopen(const char* filename, const char* mode);
int fclose(FILE *stream);
