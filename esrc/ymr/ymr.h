#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include <stdint.h>

typedef unsigned long int uint32_t;
typedef long int int32_t;

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

#define BUFSZ 128

// Before you fread() directly into this, what kind of
// struct packing does your arch/compiler do?
struct ymheader {
    char id[4];
    char check[8];
    uint32_t frames;
    uint32_t attr;
    uint16_t digidrums;
    uint32_t ymclock;
    uint16_t framehz;
    uint32_t loopframe;
    uint16_t future;
};

uint32_t swap32(uint32_t num) {
    return ((num>>24)&0xff) | ((num<<8)&0xff0000) | \
           ((num>>8)&0xff00) | ((num<<24)&0xff000000);
}

uint16_t swap16(uint16_t num) {
    return ((num>>8)&0xff) | ((num<<8)&0xff00);
}

void read_header(FILE * ymfile, struct ymheader *header);

char * ztstr(FILE * ymfile, int limit, char * errctx);

uint32_t beu32(FILE * ymfile, char * errctx);

uint16_t beu16(FILE * ymfile, char * errctx);
