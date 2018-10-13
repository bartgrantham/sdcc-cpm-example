;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module cpm_sysfunc
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cpmbdos_extn
	.globl _cpm_sysfunc_init
	.globl _cpm_gets
	.globl _cpm_getchar
	.globl _cpm_putchar
	.globl _cpm_setDMAAddr
	.globl _cpm_getCurDrive
	.globl _cpm_resetDrives
	.globl _cpm_setCurDrive
	.globl _cpm_setFCBname
	.globl _cpm_performFileOp
	.globl _cpm_reset
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_bdos_readstr:
	.ds 3
_rs_buf:
	.ds 82
_ret_ba:
	.ds 2
_ret_hl:
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;../../src/syslib/cpm_sysfunc.c:20: void cpm_sysfunc_init(void) {
;	---------------------------------
; Function cpm_sysfunc_init
; ---------------------------------
_cpm_sysfunc_init::
;../../src/syslib/cpm_sysfunc.c:22: bdos_readstr.func8 = C_READSTR;
	ld	hl,#_bdos_readstr
	ld	(hl),#0x0a
;../../src/syslib/cpm_sysfunc.c:23: bdos_readstr.parm16 = (uint16_t)&rs_buf;
	ld	bc,#_rs_buf+0
	ld	((_bdos_readstr + 0x0001)), bc
	ret
;../../src/syslib/cpm_sysfunc.c:26: char *cpm_gets(char *p) {
;	---------------------------------
; Function cpm_gets
; ---------------------------------
_cpm_gets::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../src/syslib/cpm_sysfunc.c:27: memset(rs_buf.bytes, 0, sizeof(rs_buf.bytes));
	ld	bc,#_rs_buf+0
	push	bc
	ld	hl,#(_rs_buf + 0x0002)
	ld	b, #0x50
00103$:
	ld	(hl), #0x00
	inc	hl
	djnz	00103$
	pop	bc
;../../src/syslib/cpm_sysfunc.c:28: rs_buf.size = sizeof(rs_buf.bytes);
	ld	a,#0x50
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:29: rs_buf.len = 0;
	inc	bc
	xor	a, a
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:31: cpmbdos_extn(&bdos_readstr, &ret_ba, &ret_hl);
	push	bc
	ld	hl,#_ret_hl
	push	hl
	ld	hl,#_ret_ba
	push	hl
	ld	hl,#_bdos_readstr
	push	hl
	call	_cpmbdos_extn
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	pop	bc
;../../src/syslib/cpm_sysfunc.c:33: rs_buf.bytes[rs_buf.len] = '\n';
	ld	a,(bc)
	ld	c,a
	ld	hl,#(_rs_buf + 0x0002)
	ld	b,#0x00
	add	hl, bc
	ld	(hl),#0x0a
;../../src/syslib/cpm_sysfunc.c:34: strcpy(p, rs_buf.bytes);
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	hl,#(_rs_buf + 0x0002)
	xor	a, a
00105$:
	cp	a, (hl)
	ldi
	jr	NZ, 00105$
;../../src/syslib/cpm_sysfunc.c:36: return p;
	ld	l,4 (ix)
	ld	h,5 (ix)
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:39: char cpm_getchar(void) {
;	---------------------------------
; Function cpm_getchar
; ---------------------------------
_cpm_getchar::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:40: BDOSCALL cread = { C_READ, { (uint16_t)0 } };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x01
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;../../src/syslib/cpm_sysfunc.c:41: return cpmbdos_extn(&cread, &ret_ba, &ret_hl);
	ld	hl,#_ret_hl
	push	hl
	ld	hl,#_ret_ba
	push	hl
	push	bc
	call	_cpmbdos_extn
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:44: void cpm_putchar(char c) {
;	---------------------------------
; Function cpm_putchar
; ---------------------------------
_cpm_putchar::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:45: BDOSCALL cwrite = { C_WRITE, { (uint16_t)c } };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x02
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	e,4 (ix)
	ld	d,#0x00
	ld	(hl),e
	inc	hl
	ld	(hl),d
;../../src/syslib/cpm_sysfunc.c:46: cpmbdos_extn(&cwrite, &ret_ba, &ret_hl);
	ld	de,#_ret_ba+0
	ld	hl,#_ret_hl
	push	hl
	push	de
	push	bc
	call	_cpmbdos_extn
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	ld	sp, ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:49: void cpm_setDMAAddr(uint16_t addr) {
;	---------------------------------
; Function cpm_setDMAAddr
; ---------------------------------
_cpm_setDMAAddr::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:50: BDOSCALL fdma = { F_DMAOFF, {addr} };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x1a
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	e, c
	ld	d, b
	inc	de
	ld	a,4 (ix)
	ld	(de),a
	inc	de
	ld	a,5 (ix)
	ld	(de),a
;../../src/syslib/cpm_sysfunc.c:52: cpmbdos_extn(&fdma, &ret_ba, &ret_hl);
	ld	de,#_ret_ba+0
	ld	hl,#_ret_hl
	push	hl
	push	de
	push	bc
	call	_cpmbdos_extn
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	ld	sp, ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:55: uint8_t cpm_getCurDrive(void) {
;	---------------------------------
; Function cpm_getCurDrive
; ---------------------------------
_cpm_getCurDrive::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:56: BDOSCALL drv = { DRV_GET, { 0 } };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x19
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;../../src/syslib/cpm_sysfunc.c:58: return cpmbdos_extn(&drv, &ret_ba, &ret_hl);	
	ld	hl,#_ret_hl
	push	hl
	ld	hl,#_ret_ba
	push	hl
	push	bc
	call	_cpmbdos_extn
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:61: uint8_t cpm_resetDrives(void) {
;	---------------------------------
; Function cpm_resetDrives
; ---------------------------------
_cpm_resetDrives::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:62: BDOSCALL drv = { DRV_ALLRESET, { 0 } };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x0d
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;../../src/syslib/cpm_sysfunc.c:64: return cpmbdos_extn(&drv, &ret_ba, &ret_hl);	
	ld	hl,#_ret_hl
	push	hl
	ld	hl,#_ret_ba
	push	hl
	push	bc
	call	_cpmbdos_extn
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:67: uint8_t cpm_setCurDrive(uint8_t drive) {
;	---------------------------------
; Function cpm_setCurDrive
; ---------------------------------
_cpm_setCurDrive::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:68: BDOSCALL drv = { DRV_SET, { drive } };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x0e
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	e,4 (ix)
	ld	d,#0x00
	ld	(hl),e
	inc	hl
	ld	(hl),d
;../../src/syslib/cpm_sysfunc.c:70: return cpmbdos_extn(&drv, &ret_ba, &ret_hl);
	ld	hl,#_ret_hl
	push	hl
	ld	hl,#_ret_ba
	push	hl
	push	bc
	call	_cpmbdos_extn
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:73: void cpm_setFCBname(char *fname, char *ftype, FCB *cb) {
;	---------------------------------
; Function cpm_setFCBname
; ---------------------------------
_cpm_setFCBname::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;../../src/syslib/cpm_sysfunc.c:77: for (idx = 0; (idx < 8) && (fname[idx] != '\0'); idx++) {
	ld	c,8 (ix)
	ld	b,9 (ix)
	ld	hl,#0x0001
	add	hl,bc
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	de,#0x0000
00117$:
	ld	a,e
	sub	a, #0x08
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00131$
	ld	l,4 (ix)
	ld	h,5 (ix)
	add	hl,de
	ld	l,(hl)
	ld	a,l
	or	a, a
	jr	Z,00131$
;../../src/syslib/cpm_sysfunc.c:78: c = fname[idx] & 0x7F;
	res	7, l
;../../src/syslib/cpm_sysfunc.c:79: if (c >= 0x61 && c <= 0x7a)
	ld	a,l
	sub	a, #0x61
	jr	C,00102$
	ld	a,#0x7a
	sub	a, l
	jr	C,00102$
;../../src/syslib/cpm_sysfunc.c:80: c -= 0x20; 
	ld	a,l
	add	a,#0xe0
	ld	l,a
00102$:
;../../src/syslib/cpm_sysfunc.c:82: cb->filename[idx] = c;
	push	hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	pop	iy
	pop	hl
	add	iy, de
	ld	0 (iy), l
;../../src/syslib/cpm_sysfunc.c:77: for (idx = 0; (idx < 8) && (fname[idx] != '\0'); idx++) {
	inc	de
	jr	00117$
;../../src/syslib/cpm_sysfunc.c:85: while (idx < 8) {
00131$:
00105$:
	ld	a,e
	sub	a, #0x08
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00107$
;../../src/syslib/cpm_sysfunc.c:86: cb->filename[idx] = ' '; // Pad the filename
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	add	hl,de
	ld	(hl),#0x20
;../../src/syslib/cpm_sysfunc.c:87: idx++;
	inc	de
	jr	00105$
00107$:
;../../src/syslib/cpm_sysfunc.c:90: for (idx = 0; (idx < 3) && (ftype[idx] != '\0'); idx++) {
	ld	hl,#0x0009
	add	hl,bc
	ld	c,l
	ld	b,h
	ld	hl,#0x0000
	ex	(sp), hl
00121$:
	ld	a,-4 (ix)
	sub	a, #0x03
	ld	a,-3 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00138$
	ld	a,6 (ix)
	add	a, -4 (ix)
	ld	l,a
	ld	a,7 (ix)
	adc	a, -3 (ix)
	ld	h,a
	ld	e,(hl)
	ld	a,e
	or	a, a
	jr	Z,00138$
;../../src/syslib/cpm_sysfunc.c:91: c = ftype[idx] & 0x7F;
	res	7, e
;../../src/syslib/cpm_sysfunc.c:92: if (c >= 0x61 && c <= 0x7a)
	ld	a,e
	sub	a, #0x61
	jr	C,00109$
	ld	a,#0x7a
	sub	a, e
	jr	C,00109$
;../../src/syslib/cpm_sysfunc.c:93: c -= 0x20; 
	ld	a,e
	add	a,#0xe0
	ld	e,a
00109$:
;../../src/syslib/cpm_sysfunc.c:95: cb->filetype[idx] = c;
	pop	hl
	push	hl
	add	hl,bc
	ld	(hl),e
;../../src/syslib/cpm_sysfunc.c:90: for (idx = 0; (idx < 3) && (ftype[idx] != '\0'); idx++) {
	inc	-4 (ix)
	jr	NZ,00121$
	inc	-3 (ix)
	jr	00121$
;../../src/syslib/cpm_sysfunc.c:98: while (idx < 3) {
00138$:
	pop	de
	push	de
00112$:
	ld	a,e
	sub	a, #0x03
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00123$
;../../src/syslib/cpm_sysfunc.c:99: cb->filetype[idx] = ' '; // Pad the filetype
	ld	l, c
	ld	h, b
	add	hl,de
	ld	(hl),#0x20
;../../src/syslib/cpm_sysfunc.c:100: idx++;
	inc	de
	jr	00112$
00123$:
	ld	sp, ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:104: uint8_t cpm_performFileOp(FileOperation fop, FCB *cb) {
;	---------------------------------
; Function cpm_performFileOp
; ---------------------------------
_cpm_performFileOp::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:105: BDOSCALL call = { 0, {(uint16_t)cb} };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	e,5 (ix)
	ld	d,6 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;../../src/syslib/cpm_sysfunc.c:107: switch (fop) {
	ld	a,#0x0c
	sub	a, 4 (ix)
	jr	C,00114$
	ld	e,4 (ix)
	ld	d,#0x00
	ld	hl,#00122$
	add	hl,de
	add	hl,de
	add	hl,de
	jp	(hl)
00122$:
	jp	00101$
	jp	00102$
	jp	00103$
	jp	00104$
	jp	00105$
	jp	00106$
	jp	00107$
	jp	00108$
	jp	00109$
	jp	00110$
	jp	00111$
	jp	00112$
	jp	00113$
;../../src/syslib/cpm_sysfunc.c:108: case fop_open:
00101$:
;../../src/syslib/cpm_sysfunc.c:109: call.func8 = F_OPEN;
	ld	a,#0x0f
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:110: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:111: case fop_close:
00102$:
;../../src/syslib/cpm_sysfunc.c:112: call.func8 = F_CLOSE;
	ld	a,#0x10
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:113: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:114: case fop_firstNameMatch:
00103$:
;../../src/syslib/cpm_sysfunc.c:115: call.func8 = F_SMATCH;
	ld	a,#0x11
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:116: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:117: case fop_nextMatch:
00104$:
;../../src/syslib/cpm_sysfunc.c:118: call.func8 = F_NMATCH;
	ld	a,#0x12
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:119: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:120: case fop_makeFile:
00105$:
;../../src/syslib/cpm_sysfunc.c:121: call.func8 = F_MAKE;
	ld	a,#0x16
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:122: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:123: case fop_delFile:
00106$:
;../../src/syslib/cpm_sysfunc.c:124: call.func8 = F_DELETE;
	ld	a,#0x13
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:125: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:126: case fop_setFileAttr:
00107$:
;../../src/syslib/cpm_sysfunc.c:127: call.func8 = F_ATTRIB;
	ld	a,#0x1e
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:128: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:129: case fop_readSeqRecord:
00108$:
;../../src/syslib/cpm_sysfunc.c:130: call.func8 = F_READ;
	ld	a,#0x14
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:131: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:132: case fop_writeSeqRecord:
00109$:
;../../src/syslib/cpm_sysfunc.c:133: call.func8 = F_WRITE;
	ld	a,#0x15
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:134: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:135: case fop_readRandRecord:
00110$:
;../../src/syslib/cpm_sysfunc.c:136: call.func8 = F_READRAND;
	ld	a,#0x21
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:137: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:138: case fop_writeRandRecord:
00111$:
;../../src/syslib/cpm_sysfunc.c:139: call.func8 = F_WRITERAND;
	ld	a,#0x22
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:140: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:141: case fop_updRandRecPtr:
00112$:
;../../src/syslib/cpm_sysfunc.c:142: call.func8 = F_RANDREC;
	ld	a,#0x24
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:143: break;
	jr	00115$
;../../src/syslib/cpm_sysfunc.c:144: case fop_calcFileSize:
00113$:
;../../src/syslib/cpm_sysfunc.c:145: default:
00114$:
;../../src/syslib/cpm_sysfunc.c:146: call.func8 = F_SIZE;
	ld	a,#0x23
	ld	(bc),a
;../../src/syslib/cpm_sysfunc.c:148: }
00115$:
;../../src/syslib/cpm_sysfunc.c:150: return cpmbdos_extn(&call, &ret_ba, &ret_hl);
	ld	hl,#_ret_hl
	push	hl
	ld	hl,#_ret_ba
	push	hl
	push	bc
	call	_cpmbdos_extn
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/cpm_sysfunc.c:154: void cpm_reset(void) {
;	---------------------------------
; Function cpm_reset
; ---------------------------------
_cpm_reset::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/cpm_sysfunc.c:155: BDOSCALL sreset = { S_RESET, { (uint16_t)0 } };
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;../../src/syslib/cpm_sysfunc.c:156: cpmbdos_extn(&sreset, &ret_ba, &ret_hl);
	ld	de,#_ret_ba+0
	ld	hl,#_ret_hl
	push	hl
	push	de
	push	bc
	call	_cpmbdos_extn
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
