#include "sysfunc.h"

#include "include/common_datatypes.h"
#include "include/cpmbdos.h"

#include <stdlib.h>
#include <string.h>

typedef struct {
	uint8_t size;
	uint8_t len;
	char bytes[80];
} RS_BUFFER;

static BDOSCALL bdos_readstr;
static RS_BUFFER rs_buf;

char getchar(void);
void outchar(char c);

void cpm_sysfunc_init(void) {
	// Initialize READSTR BDOS call
	bdos_readstr.func8 = C_READSTR;
	bdos_readstr.parm16 = (uint16_t)&rs_buf;

}

char *cpm_gets(char *p) {
	memset(rs_buf.bytes, 0, sizeof(rs_buf.bytes));
	rs_buf.size = sizeof(rs_buf.bytes);
	rs_buf.len = 0;

	cpmbdos(&bdos_readstr);

	rs_buf.bytes[rs_buf.len] = '\n';
	strcpy(p, rs_buf.bytes);

	return p;
}

/* THESE ARE USED BY THE LIBRARY ROUTINES */
#ifndef __GNUC__
char getchar(void) {
	BDOSCALL cread = { C_READ, { (unsigned int)0 } };
	return cpmbdos(&cread);
}
void outchar(char c) {
	BDOSCALL cwrite = { C_WRITE, { (unsigned int)c } };
	cpmbdos(&cwrite);
}
#endif
