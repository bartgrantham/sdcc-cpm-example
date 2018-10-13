;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module cprintf
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cprintf
	.globl _strlen
	.globl _cpm_putchar
	.globl _nstring
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
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
;../../src/syslib/cprintf.c:36: int cprintf(const char *fmt, ...) {
;	---------------------------------
; Function cprintf
; ---------------------------------
_cprintf::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-38
	add	hl,sp
	ld	sp,hl
;../../src/syslib/cprintf.c:38: int count = 0;
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
;../../src/syslib/cprintf.c:47: va_start(ap, fmt);
	ld	hl,#0x002a+1+1
	add	hl,sp
	ex	(sp), hl
;../../src/syslib/cprintf.c:49: while (c = *fmt++) {
	ld	hl,#0x0002
	add	hl,sp
	ld	-4 (ix),l
	ld	-3 (ix),h
00171$:
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	c,(hl)
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
	ld	d,#0x00
	ld	-6 (ix),c
	ld	-5 (ix),d
	ld	a,d
	or	a,c
	jp	Z,00173$
;../../src/syslib/cprintf.c:50: count++;
	inc	-2 (ix)
	jr	NZ,00323$
	inc	-1 (ix)
00323$:
;../../src/syslib/cprintf.c:51: if (c != '%') {
	ld	a,-6 (ix)
	sub	a, #0x25
	jr	NZ,00324$
	ld	a,-5 (ix)
	or	a, a
	jr	Z,00169$
00324$:
;../../src/syslib/cprintf.c:52: if (c == '\n') putch('\r');
	ld	a,-6 (ix)
	sub	a, #0x0a
	jr	NZ,00102$
	ld	a,-5 (ix)
	or	a, a
	jr	NZ,00102$
	ld	a,#0x0d
	push	af
	inc	sp
	call	_cpm_putchar
	inc	sp
00102$:
;../../src/syslib/cprintf.c:53: putch(c);
	ld	b,-6 (ix)
	push	bc
	inc	sp
	call	_cpm_putchar
	inc	sp
	jr	00171$
00169$:
;../../src/syslib/cprintf.c:55: type = 1;
	ld	-21 (ix),#0x01
	ld	-20 (ix),#0x00
;../../src/syslib/cprintf.c:56: padch = *fmt;
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	a,(bc)
	ld	-24 (ix),a
;../../src/syslib/cprintf.c:57: maxsize = minsize = 0;
	ld	-6 (ix),#0x00
	ld	-5 (ix),#0x00
	ld	-8 (ix),#0x00
	ld	-7 (ix),#0x00
;../../src/syslib/cprintf.c:58: if (padch == '-') fmt++;
	ld	a,-24 (ix)
	sub	a, #0x2d
	jr	NZ,00327$
	ld	a,#0x01
	jr	00328$
00327$:
	xor	a,a
00328$:
	ld	-9 (ix), a
	or	a, a
	jr	Z,00187$
	inc	bc
	ld	4 (ix),c
	ld	5 (ix),b
00187$:
	ld	a,4 (ix)
	ld	-11 (ix),a
	ld	a,5 (ix)
	ld	-10 (ix),a
00174$:
;../../src/syslib/cprintf.c:61: c = *fmt++;
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	c,(hl)
	inc	-11 (ix)
	jr	NZ,00329$
	inc	-10 (ix)
00329$:
	ld	a,-11 (ix)
	ld	4 (ix),a
	ld	a,-10 (ix)
	ld	5 (ix),a
	ld	-17 (ix),c
	ld	-16 (ix),#0x00
;../../src/syslib/cprintf.c:62: if (c < '0' || c > '9') break;
	ld	a,-17 (ix)
	sub	a, #0x30
	ld	a,-16 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00214$
	ld	a,#0x39
	cp	a, -17 (ix)
	ld	a,#0x00
	sbc	a, -16 (ix)
	jp	PO, 00330$
	xor	a, #0x80
00330$:
	jp	M,00214$
;../../src/syslib/cprintf.c:63: minsize *= 10;
	ld	c,-6 (ix)
	ld	b,-5 (ix)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
;../../src/syslib/cprintf.c:64: minsize += c - '0';
	ld	a,-17 (ix)
	add	a,#0xd0
	ld	c,a
	ld	a,-16 (ix)
	adc	a,#0xff
	ld	b,a
	add	hl,bc
	ld	-6 (ix),l
	ld	-5 (ix),h
	jr	00174$
00214$:
	ld	a,-11 (ix)
	ld	4 (ix),a
	ld	a,-10 (ix)
	ld	5 (ix),a
;../../src/syslib/cprintf.c:67: if (c == '.')
	ld	a,-17 (ix)
	sub	a, #0x2e
	jr	NZ,00114$
	ld	a,-16 (ix)
	or	a, a
	jr	NZ,00114$
00176$:
;../../src/syslib/cprintf.c:69: c = *fmt++;
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	c,(hl)
	inc	-11 (ix)
	jr	NZ,00333$
	inc	-10 (ix)
00333$:
	ld	a,-11 (ix)
	ld	4 (ix),a
	ld	a,-10 (ix)
	ld	5 (ix),a
	ld	-17 (ix),c
	ld	-16 (ix),#0x00
;../../src/syslib/cprintf.c:70: if (c < '0' || c > '9') break;
	ld	a,-17 (ix)
	sub	a, #0x30
	ld	a,-16 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00215$
	ld	a,#0x39
	cp	a, -17 (ix)
	ld	a,#0x00
	sbc	a, -16 (ix)
	jp	PO, 00334$
	xor	a, #0x80
00334$:
	jp	M,00215$
;../../src/syslib/cprintf.c:71: maxsize *= 10;
	ld	c,-8 (ix)
	ld	b,-7 (ix)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
;../../src/syslib/cprintf.c:72: maxsize += c - '0';
	ld	a,-17 (ix)
	add	a,#0xd0
	ld	c,a
	ld	a,-16 (ix)
	adc	a,#0xff
	ld	b,a
	add	hl,bc
	ld	-8 (ix),l
	ld	-7 (ix),h
	jr	00176$
00215$:
	ld	a,-11 (ix)
	ld	4 (ix),a
	ld	a,-10 (ix)
	ld	5 (ix),a
00114$:
;../../src/syslib/cprintf.c:75: if (padch == '-') minsize = -minsize;
	ld	a,-9 (ix)
	or	a, a
	jr	Z,00118$
	xor	a, a
	sub	a, -6 (ix)
	ld	-6 (ix),a
	ld	a, #0x00
	sbc	a, -5 (ix)
	ld	-5 (ix),a
	jr	00119$
00118$:
;../../src/syslib/cprintf.c:76: else if (padch != '0') padch = ' ';
	ld	a,-24 (ix)
	sub	a, #0x30
	jr	Z,00119$
	ld	-24 (ix),#0x20
00119$:
;../../src/syslib/cprintf.c:78: if (c == 0) break;
	ld	a,-16 (ix)
	or	a,-17 (ix)
	jp	Z,00173$
;../../src/syslib/cprintf.c:49: while (c = *fmt++) {
	ld	c,4 (ix)
	ld	b,5 (ix)
;../../src/syslib/cprintf.c:80: c = *fmt++;
	ld	hl,#0x0001
	add	hl,bc
	ld	-11 (ix),l
	ld	-10 (ix),h
;../../src/syslib/cprintf.c:79: if (c == 'h') {
	ld	a,-17 (ix)
	sub	a, #0x68
	jr	NZ,00125$
	ld	a,-16 (ix)
	or	a, a
	jr	NZ,00125$
;../../src/syslib/cprintf.c:80: c = *fmt++;
	ld	a,(bc)
	ld	c,a
	ld	a,-11 (ix)
	ld	4 (ix),a
	ld	a,-10 (ix)
	ld	5 (ix),a
	ld	-17 (ix),c
	ld	-16 (ix),#0x00
;../../src/syslib/cprintf.c:81: type = 0;
	ld	-21 (ix),#0x00
	ld	-20 (ix),#0x00
	jr	00126$
00125$:
;../../src/syslib/cprintf.c:82: } else if (c == 'l') {
	ld	a,-17 (ix)
	sub	a, #0x6c
	jr	NZ,00126$
	ld	a,-16 (ix)
	or	a, a
	jr	NZ,00126$
;../../src/syslib/cprintf.c:83: c = *fmt++;
	ld	a,(bc)
	ld	c,a
	ld	a,-11 (ix)
	ld	4 (ix),a
	ld	a,-10 (ix)
	ld	5 (ix),a
	ld	-17 (ix),c
	ld	-16 (ix),#0x00
;../../src/syslib/cprintf.c:84: type = 2;
	ld	-21 (ix),#0x02
	ld	-20 (ix),#0x00
00126$:
;../../src/syslib/cprintf.c:91: type |= 4;
	ld	a,-21 (ix)
	set	2, a
	ld	-11 (ix),a
	ld	a,-20 (ix)
	ld	-10 (ix),a
;../../src/syslib/cprintf.c:108: val = va_arg(ap, short);
	pop	bc
	push	bc
	inc	bc
	inc	bc
	ld	e,c
	ld	d,b
	dec	de
	dec	de
	ld	-13 (ix),e
	ld	-12 (ix),d
;../../src/syslib/cprintf.c:87: switch (c) {
	ld	a,-17 (ix)
	sub	a, #0x58
	jr	NZ,00340$
	ld	a,-16 (ix)
	or	a, a
	jr	Z,00128$
00340$:
	ld	a,-17 (ix)
	sub	a, #0x63
	jr	NZ,00341$
	ld	a,-16 (ix)
	or	a, a
	jp	Z,00165$
00341$:
	ld	a,-17 (ix)
	sub	a, #0x64
	jr	NZ,00342$
	ld	a,-16 (ix)
	or	a, a
	jp	Z,00135$
00342$:
	ld	a,-17 (ix)
	sub	a, #0x6f
	jr	NZ,00343$
	ld	a,-16 (ix)
	or	a, a
	jr	Z,00129$
00343$:
	ld	a,-17 (ix)
	sub	a, #0x73
	jr	NZ,00344$
	ld	a,-16 (ix)
	or	a, a
	jp	Z,00146$
00344$:
	ld	a,-17 (ix)
	sub	a, #0x75
	jr	NZ,00345$
	ld	a,-16 (ix)
	or	a, a
	jr	Z,00132$
00345$:
	ld	a,-17 (ix)
	sub	a, #0x78
	jp	NZ,00166$
	ld	a,-16 (ix)
	or	a, a
	jp	NZ,00166$
;../../src/syslib/cprintf.c:89: case 'x':
00128$:
;../../src/syslib/cprintf.c:90: base = 16;
	ld	-23 (ix),#0x10
	ld	-22 (ix),#0x00
;../../src/syslib/cprintf.c:91: type |= 4;
	ld	a,-11 (ix)
	ld	-21 (ix),a
	ld	a,-10 (ix)
	ld	-20 (ix),a
;../../src/syslib/cprintf.c:92: if (0) {
	jr	00137$
;../../src/syslib/cprintf.c:93: case 'o':
00129$:
;../../src/syslib/cprintf.c:94: base = 8;
	ld	-23 (ix),#0x08
	ld	-22 (ix),#0x00
;../../src/syslib/cprintf.c:95: type |= 4;
	ld	a,-11 (ix)
	ld	-21 (ix),a
	ld	a,-10 (ix)
	ld	-20 (ix),a
;../../src/syslib/cprintf.c:97: if (0) {
	jr	00137$
;../../src/syslib/cprintf.c:98: case 'u':
00132$:
;../../src/syslib/cprintf.c:99: base = 10;
	ld	-23 (ix),#0x0a
	ld	-22 (ix),#0x00
;../../src/syslib/cprintf.c:100: type |= 4;
	ld	a,-11 (ix)
	ld	-21 (ix),a
	ld	a,-10 (ix)
	ld	-20 (ix),a
;../../src/syslib/cprintf.c:102: if (0) {
	jr	00137$
;../../src/syslib/cprintf.c:103: case 'd':
00135$:
;../../src/syslib/cprintf.c:104: base = -10;
	ld	-23 (ix),#0xf6
	ld	-22 (ix),#0xff
00137$:
;../../src/syslib/cprintf.c:106: switch (type) {
	bit	7, -20 (ix)
	jp	NZ,00144$
	ld	a,#0x06
	cp	a, -21 (ix)
	ld	a,#0x00
	sbc	a, -20 (ix)
	jp	PO, 00348$
	xor	a, #0x80
00348$:
	jp	M,00144$
;../../src/syslib/cprintf.c:114: val = va_arg(ap, long);
	ld	a,-38 (ix)
	add	a, #0x04
	ld	-11 (ix),a
	ld	a,-37 (ix)
	adc	a, #0x00
	ld	-10 (ix),a
	ld	a,-11 (ix)
	add	a,#0xfc
	ld	-15 (ix),a
	ld	a,-10 (ix)
	adc	a,#0xff
	ld	-14 (ix),a
;../../src/syslib/cprintf.c:117: val = va_arg(ap, unsigned short);
;../../src/syslib/cprintf.c:106: switch (type) {
	push	de
	ld	e,-21 (ix)
	ld	d,#0x00
	ld	hl,#00349$
	add	hl,de
	add	hl,de
	add	hl,de
	pop	de
	jp	(hl)
00349$:
	jp	00138$
	jp	00139$
	jp	00140$
	jp	00144$
	jp	00141$
	jp	00142$
	jp	00143$
;../../src/syslib/cprintf.c:107: case 0:
00138$:
;../../src/syslib/cprintf.c:108: val = va_arg(ap, short);
	inc	sp
	inc	sp
	push	bc
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,b
	rla
	sbc	a, a
	ld	e,a
	ld	d,a
;../../src/syslib/cprintf.c:109: break;
	jr	00145$
;../../src/syslib/cprintf.c:110: case 1:
00139$:
;../../src/syslib/cprintf.c:111: val = va_arg(ap, int);
	inc	sp
	inc	sp
	push	bc
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,b
	rla
	sbc	a, a
	ld	e,a
	ld	d,a
;../../src/syslib/cprintf.c:112: break;
	jr	00145$
;../../src/syslib/cprintf.c:113: case 2:
00140$:
;../../src/syslib/cprintf.c:114: val = va_arg(ap, long);
	ld	a,-11 (ix)
	ld	-38 (ix),a
	ld	a,-10 (ix)
	ld	-37 (ix),a
	ld	l,-15 (ix)
	ld	h,-14 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;../../src/syslib/cprintf.c:115: break;
	jr	00145$
;../../src/syslib/cprintf.c:116: case 4:
00141$:
;../../src/syslib/cprintf.c:117: val = va_arg(ap, unsigned short);
	inc	sp
	inc	sp
	push	bc
	ex	de,hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	de,#0x0000
;../../src/syslib/cprintf.c:118: break;
	jr	00145$
;../../src/syslib/cprintf.c:119: case 5:
00142$:
;../../src/syslib/cprintf.c:120: val = va_arg(ap, unsigned int);
	inc	sp
	inc	sp
	push	bc
	ex	de,hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	de,#0x0000
;../../src/syslib/cprintf.c:121: break;
	jr	00145$
;../../src/syslib/cprintf.c:122: case 6:
00143$:
;../../src/syslib/cprintf.c:123: val = va_arg(ap, unsigned long);
	ld	a,-11 (ix)
	ld	-38 (ix),a
	ld	a,-10 (ix)
	ld	-37 (ix),a
	ld	l,-15 (ix)
	ld	h,-14 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;../../src/syslib/cprintf.c:124: break;
	jr	00145$
;../../src/syslib/cprintf.c:125: default:
00144$:
;../../src/syslib/cprintf.c:126: val = 0;
	ld	bc,#0x0000
	ld	de,#0x0000
;../../src/syslib/cprintf.c:128: }
00145$:
;../../src/syslib/cprintf.c:129: cp = __numout(val, base, out);
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	ld	l,-23 (ix)
	ld	h,-22 (ix)
	push	hl
	push	de
	push	bc
	call	___numout
	pop	af
	pop	af
	pop	af
	pop	af
	ex	de,hl
;../../src/syslib/cprintf.c:130: if (0) {
	jr	00148$
;../../src/syslib/cprintf.c:131: case 's':
00146$:
;../../src/syslib/cprintf.c:132: cp = va_arg(ap, char *);
	inc	sp
	inc	sp
	push	bc
	ex	de,hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
00148$:
;../../src/syslib/cprintf.c:134: count--;
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	dec	hl
;../../src/syslib/cprintf.c:135: c = strlen(cp);
	push	hl
	push	de
	push	de
	call	_strlen
	pop	af
	ld	c,l
	ld	b,h
	pop	de
	pop	hl
	ld	-15 (ix),c
	ld	-14 (ix),b
;../../src/syslib/cprintf.c:136: if (!maxsize) maxsize = c;
	ld	a,-7 (ix)
	or	a,-8 (ix)
	jr	NZ,00150$
	ld	a,-15 (ix)
	ld	-8 (ix),a
	ld	a,-14 (ix)
	ld	-7 (ix),a
00150$:
;../../src/syslib/cprintf.c:137: if (minsize > 0) {
	xor	a, a
	cp	a, -6 (ix)
	sbc	a, -5 (ix)
	jp	PO, 00350$
	xor	a, #0x80
00350$:
	jp	P,00155$
;../../src/syslib/cprintf.c:138: minsize -= c;
	ld	a,-6 (ix)
	sub	a, -15 (ix)
	ld	c,a
	ld	a,-5 (ix)
	sbc	a, -14 (ix)
	ld	b,a
;../../src/syslib/cprintf.c:139: while (minsize > 0) {
	ld	-11 (ix),l
	ld	-10 (ix),h
00151$:
	xor	a, a
	cp	a, c
	sbc	a, b
	jp	PO, 00351$
	xor	a, #0x80
00351$:
	jp	P,00216$
;../../src/syslib/cprintf.c:140: putch(padch);
	push	bc
	push	de
	ld	a,-24 (ix)
	push	af
	inc	sp
	call	_cpm_putchar
	inc	sp
	pop	de
	pop	bc
;../../src/syslib/cprintf.c:141: count++;
	inc	-11 (ix)
	jr	NZ,00352$
	inc	-10 (ix)
00352$:
;../../src/syslib/cprintf.c:142: minsize--;
	dec	bc
	jr	00151$
00216$:
	ld	l,-11 (ix)
	ld	h,-10 (ix)
;../../src/syslib/cprintf.c:144: minsize = 0;
	ld	-6 (ix),#0x00
	ld	-5 (ix),#0x00
00155$:
;../../src/syslib/cprintf.c:146: if (minsize < 0) minsize = -minsize - c;
	bit	7, -5 (ix)
	jr	Z,00211$
	xor	a, a
	sub	a, -6 (ix)
	ld	c,a
	ld	a, #0x00
	sbc	a, -5 (ix)
	ld	b,a
	ld	a,c
	sub	a, -15 (ix)
	ld	-6 (ix),a
	ld	a,b
	sbc	a, -14 (ix)
	ld	-5 (ix),a
;../../src/syslib/cprintf.c:147: while (*cp && maxsize-- > 0) {
00211$:
	ld	a,-8 (ix)
	ld	-15 (ix),a
	ld	a,-7 (ix)
	ld	-14 (ix),a
	ld	-11 (ix),e
	ld	-10 (ix),d
	ld	c, l
	ld	b, h
00159$:
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	d,(hl)
	ld	a,d
	or	a, a
	jr	Z,00217$
	ld	e,-15 (ix)
	ld	l,-14 (ix)
	ld	a,-15 (ix)
	add	a,#0xff
	ld	-15 (ix),a
	ld	a,-14 (ix)
	adc	a,#0xff
	ld	-14 (ix),a
	xor	a, a
	cp	a, e
	sbc	a, l
	jp	PO, 00353$
	xor	a, #0x80
00353$:
	jp	P,00217$
;../../src/syslib/cprintf.c:148: putch(*cp++);
	inc	-11 (ix)
	jr	NZ,00354$
	inc	-10 (ix)
00354$:
	push	bc
	push	de
	inc	sp
	call	_cpm_putchar
	inc	sp
	pop	bc
;../../src/syslib/cprintf.c:149: count++;
	inc	bc
	jr	00159$
;../../src/syslib/cprintf.c:151: while (minsize > 0) {
00217$:
	ld	-2 (ix),c
	ld	-1 (ix),b
	ld	-19 (ix),c
	ld	-18 (ix),b
	ld	c,-6 (ix)
	ld	b,-5 (ix)
00162$:
	xor	a, a
	cp	a, c
	sbc	a, b
	jp	PO, 00355$
	xor	a, #0x80
00355$:
	jp	P,00171$
;../../src/syslib/cprintf.c:152: putch(' ');
	push	bc
	ld	a,#0x20
	push	af
	inc	sp
	call	_cpm_putchar
	inc	sp
	pop	bc
;../../src/syslib/cprintf.c:153: count++;
	inc	-19 (ix)
	jr	NZ,00356$
	inc	-18 (ix)
00356$:
	ld	a,-19 (ix)
	ld	-2 (ix),a
	ld	a,-18 (ix)
	ld	-1 (ix),a
;../../src/syslib/cprintf.c:154: minsize--;
	dec	bc
	jr	00162$
;../../src/syslib/cprintf.c:157: case 'c':
00165$:
;../../src/syslib/cprintf.c:158: putch(va_arg(ap, int));
	inc	sp
	inc	sp
	push	bc
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	b,c
	push	bc
	inc	sp
	call	_cpm_putchar
	inc	sp
;../../src/syslib/cprintf.c:159: break;
	jp	00171$
;../../src/syslib/cprintf.c:160: default:
00166$:
;../../src/syslib/cprintf.c:161: putch(c);
	ld	b,-17 (ix)
	push	bc
	inc	sp
	call	_cpm_putchar
	inc	sp
;../../src/syslib/cprintf.c:163: }
	jp	00171$
00173$:
;../../src/syslib/cprintf.c:167: return count;
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	sp, ix
	pop	ix
	ret
;../../src/syslib/cprintf.c:176: __numout(long i, int base, unsigned char *out) {
;	---------------------------------
; Function __numout
; ---------------------------------
___numout:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-12
	add	hl,sp
	ld	sp,hl
;../../src/syslib/cprintf.c:178: int flg = 0;
	ld	hl,#0x0000
	ex	(sp), hl
;../../src/syslib/cprintf.c:181: if (base < 0) {
	bit	7, 9 (ix)
	jr	Z,00104$
;../../src/syslib/cprintf.c:182: base = -base;
	xor	a, a
	sub	a, 8 (ix)
	ld	8 (ix),a
	ld	a, #0x00
	sbc	a, 9 (ix)
	ld	9 (ix),a
;../../src/syslib/cprintf.c:183: if (i < 0) {
	bit	7, 7 (ix)
	jr	Z,00104$
;../../src/syslib/cprintf.c:184: flg = 1;
	ld	hl,#0x0001
	ex	(sp), hl
;../../src/syslib/cprintf.c:185: i = -i;
	xor	a, a
	sub	a, 4 (ix)
	ld	4 (ix),a
	ld	a, #0x00
	sbc	a, 5 (ix)
	ld	5 (ix),a
	ld	a, #0x00
	sbc	a, 6 (ix)
	ld	6 (ix),a
	ld	a, #0x00
	sbc	a, 7 (ix)
	ld	7 (ix),a
00104$:
;../../src/syslib/cprintf.c:188: val = i;
	ld	hl, #2
	add	hl, sp
	ex	de, hl
	ld	hl, #16
	add	hl, sp
	ld	bc, #4
	ldir
;../../src/syslib/cprintf.c:190: out[NUMLTH] = '\0';
	ld	a,10 (ix)
	add	a, #0x0b
	ld	c,a
	ld	a,11 (ix)
	adc	a, #0x00
	ld	b,a
	xor	a, a
	ld	(bc),a
;../../src/syslib/cprintf.c:192: do {
	ld	bc,#0x000a
00105$:
;../../src/syslib/cprintf.c:194: out[n] = nstring[val % base];
	ld	a,10 (ix)
	add	a, c
	ld	-2 (ix),a
	ld	a,11 (ix)
	adc	a, b
	ld	-1 (ix),a
	ld	a,8 (ix)
	ld	-6 (ix),a
	ld	a,9 (ix)
	ld	-5 (ix),a
	ld	a,9 (ix)
	rla
	sbc	a, a
	ld	-4 (ix),a
	ld	-3 (ix),a
	push	bc
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	push	hl
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	push	hl
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	push	hl
	call	__modulong
	pop	af
	pop	af
	pop	af
	pop	af
	ex	de, hl
	pop	bc
	ld	iy,#_nstring
	add	iy, de
	ld	e, 0 (iy)
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),e
;../../src/syslib/cprintf.c:195: val /= base;
	push	bc
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	push	hl
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	push	hl
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	push	hl
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	pop	bc
	ld	-10 (ix),l
	ld	-9 (ix),h
	ld	-8 (ix),e
	ld	-7 (ix),d
;../../src/syslib/cprintf.c:196: --n;
	dec	bc
;../../src/syslib/cprintf.c:201: } while (val);
	ld	a,-7 (ix)
	or	a, -8 (ix)
	or	a, -9 (ix)
	or	a,-10 (ix)
	jp	NZ,00105$
;../../src/syslib/cprintf.c:202: if (flg) out[n--] = '-';
	ld	e, c
	ld	d, b
	ld	a,-11 (ix)
	or	a,-12 (ix)
	jr	Z,00109$
	ld	e,c
	ld	d,b
	dec	de
	ld	l,10 (ix)
	ld	h,11 (ix)
	add	hl,bc
	ld	(hl),#0x2d
00109$:
;../../src/syslib/cprintf.c:204: return &out[n + 1];
	inc	de
	ld	l,10 (ix)
	ld	h,11 (ix)
	add	hl,de
	ld	sp, ix
	pop	ix
	ret
_nstring:
	.ascii "0123456789ABCDEF"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
