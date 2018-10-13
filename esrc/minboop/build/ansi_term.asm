;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module ansi_term
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cpm_putchar
	.globl _term_ANSIMode
	.globl _term_ANSILineMode
	.globl _term_ANSIDirectCursorAddr
	.globl _term_ANSICursorMove
	.globl _term_ANSIClrLine
	.globl _term_ANSIClrScrn
	.globl _term_ANSISetParam
	.globl _term_ANSISaveCursor
	.globl _term_ANSIRestoreCursor
	.globl _term_ANSIIndex
	.globl _term_ANSIReverseIndex
	.globl _term_sendCommand
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
;../../src/syslib/ansi_term.c:25: void term_ANSIMode(void) {
;	---------------------------------
; Function term_ANSIMode
; ---------------------------------
_term_ANSIMode::
;../../src/syslib/ansi_term.c:26: term_sendCommand(VT100_ANSI_CMD);
	ld	hl,#___str_0
	push	hl
	call	_term_sendCommand
	pop	af
	ret
___str_0:
	.ascii "<"
	.db 0x00
;../../src/syslib/ansi_term.c:29: void term_ANSILineMode(LineMode lm) {
;	---------------------------------
; Function term_ANSILineMode
; ---------------------------------
_term_ANSILineMode::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;../../src/syslib/ansi_term.c:30: char cmd[] = ANSI_LM;
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x23
	ld	e, c
	ld	d, b
	inc	de
	ld	a,#0x5f
	ld	(de),a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:32: switch (lm) {
	ld	a,#0x03
	sub	a, 4 (ix)
	jr	C,00105$
	push	de
	ld	e,4 (ix)
	ld	d,#0x00
	ld	hl,#00113$
	add	hl,de
	add	hl,de
;../../src/syslib/ansi_term.c:33: case lm_doubleh_top:
	pop	de
	jp	(hl)
00113$:
	jr	00101$
	jr	00102$
	jr	00103$
	jr	00104$
00101$:
;../../src/syslib/ansi_term.c:34: cmd[1] = '3';
	ld	a,#0x33
	ld	(de),a
;../../src/syslib/ansi_term.c:35: break;
	jr	00106$
;../../src/syslib/ansi_term.c:36: case lm_doubleh_bottom:
00102$:
;../../src/syslib/ansi_term.c:37: cmd[1] = '4';
	ld	a,#0x34
	ld	(de),a
;../../src/syslib/ansi_term.c:38: break;
	jr	00106$
;../../src/syslib/ansi_term.c:39: case lm_singlew_singleh:
00103$:
;../../src/syslib/ansi_term.c:40: cmd[1] = '5';
	ld	a,#0x35
	ld	(de),a
;../../src/syslib/ansi_term.c:41: break;
	jr	00106$
;../../src/syslib/ansi_term.c:42: case lm_doublew_singleh:
00104$:
;../../src/syslib/ansi_term.c:43: default:
00105$:
;../../src/syslib/ansi_term.c:44: cmd[1] = '6';
	ld	a,#0x36
	ld	(de),a
;../../src/syslib/ansi_term.c:46: }
00106$:
;../../src/syslib/ansi_term.c:48: term_sendCommand(cmd);
	push	bc
	call	_term_sendCommand
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/ansi_term.c:51: void term_ANSIDirectCursorAddr(uint8_t column, uint8_t line) {
;	---------------------------------
; Function term_ANSIDirectCursorAddr
; ---------------------------------
_term_ANSIDirectCursorAddr::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-21
	add	hl,sp
	ld	sp,hl
;../../src/syslib/ansi_term.c:52: char cmd[] = ANSI_CURDIRADR;
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x5b
	ld	hl,#0x0001
	add	hl,bc
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0002
	add	hl,bc
	ld	-4 (ix),l
	ld	-3 (ix),h
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0003
	add	hl,bc
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0004
	add	hl,bc
	ld	(hl),#0x3b
	ld	hl,#0x0005
	add	hl,bc
	ex	de,hl
	ld	a,#0x5f
	ld	(de),a
	ld	hl,#0x0006
	add	hl,bc
	ld	-8 (ix),l
	ld	-7 (ix),h
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0007
	add	hl,bc
	ld	-10 (ix),l
	ld	-9 (ix),h
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0008
	add	hl,bc
	ld	(hl),#0x48
	ld	hl,#0x0009
	add	hl,bc
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:55: cmd[5] = (column / 100) + 0x30;
	push	bc
	push	de
	ld	a,#0x64
	push	af
	inc	sp
	ld	a,4 (ix)
	push	af
	inc	sp
	call	__divuchar
	pop	af
	ld	-11 (ix),l
	pop	de
	pop	bc
	ld	a,-11 (ix)
	add	a, #0x30
	ld	(de),a
;../../src/syslib/ansi_term.c:56: column -= (100 * (column / 100));
	ld	l,-11 (ix)
	ld	e,l
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	ld	a,4 (ix)
	sub	a, l
	ld	4 (ix),a
;../../src/syslib/ansi_term.c:57: cmd[6] = (column / 10) + 0x30;
	push	bc
	ld	a,#0x0a
	push	af
	inc	sp
	ld	a,4 (ix)
	push	af
	inc	sp
	call	__divuchar
	pop	af
	ld	e,l
	pop	bc
	ld	a,e
	add	a, #0x30
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:58: column -= (10 * (column / 10));
	ld	l,e
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	a,4 (ix)
	sub	a, l
;../../src/syslib/ansi_term.c:59: cmd[7] = column + 0x30;
	ld	4 (ix), a
	add	a, #0x30
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:61: cmd[1] = (line / 100) + 0x30;
	push	bc
	ld	a,#0x64
	push	af
	inc	sp
	ld	a,5 (ix)
	push	af
	inc	sp
	call	__divuchar
	pop	af
	ld	e,l
	pop	bc
	ld	a,e
	add	a, #0x30
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:62: line -= (100 * (line / 100));
	ld	l,e
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	ld	a,5 (ix)
	sub	a, l
	ld	5 (ix),a
;../../src/syslib/ansi_term.c:63: cmd[2] = (line / 10) + 0x30;
	push	bc
	ld	a,#0x0a
	push	af
	inc	sp
	ld	a,5 (ix)
	push	af
	inc	sp
	call	__divuchar
	pop	af
	ld	e,l
	pop	bc
	ld	a,e
	add	a, #0x30
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:64: line -= (10 * (line / 10));
	ld	l,e
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	a,5 (ix)
	sub	a, l
;../../src/syslib/ansi_term.c:65: cmd[3] = line + 0x30;
	ld	5 (ix), a
	add	a, #0x30
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:67: term_sendCommand(cmd);
	push	bc
	call	_term_sendCommand
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/ansi_term.c:70: void term_ANSICursorMove(uint8_t spaces, ModeDir dir) {
;	---------------------------------
; Function term_ANSICursorMove
; ---------------------------------
_term_ANSICursorMove::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-12
	add	hl,sp
	ld	sp,hl
;../../src/syslib/ansi_term.c:71: char cmd[] = ANSI_CURMOVE;
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x5b
	ld	hl,#0x0001
	add	hl,bc
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0002
	add	hl,bc
	ld	-4 (ix),l
	ld	-3 (ix),h
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0003
	add	hl,bc
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),#0x5f
	ld	hl,#0x0004
	add	hl,bc
	ex	de,hl
	ld	a,#0x58
	ld	(de),a
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:73: switch (dir) {
	ld	a,#0x03
	sub	a, 5 (ix)
	jr	C,00105$
	push	de
	ld	e,5 (ix)
	ld	d,#0x00
	ld	hl,#00113$
	add	hl,de
	add	hl,de
;../../src/syslib/ansi_term.c:74: case md_move_up:
	pop	de
	jp	(hl)
00113$:
	jr	00101$
	jr	00102$
	jr	00104$
	jr	00103$
00101$:
;../../src/syslib/ansi_term.c:75: cmd[4] = 'A';
	ld	a,#0x41
	ld	(de),a
;../../src/syslib/ansi_term.c:76: break;
	jr	00106$
;../../src/syslib/ansi_term.c:77: case md_move_down:
00102$:
;../../src/syslib/ansi_term.c:78: cmd[4] = 'B';
	ld	a,#0x42
	ld	(de),a
;../../src/syslib/ansi_term.c:79: break;
	jr	00106$
;../../src/syslib/ansi_term.c:80: case md_move_right:
00103$:
;../../src/syslib/ansi_term.c:81: cmd[4] = 'C';
	ld	a,#0x43
	ld	(de),a
;../../src/syslib/ansi_term.c:82: break;
	jr	00106$
;../../src/syslib/ansi_term.c:83: case md_move_left:
00104$:
;../../src/syslib/ansi_term.c:84: default:
00105$:
;../../src/syslib/ansi_term.c:85: cmd[4] = 'D';
	ld	a,#0x44
	ld	(de),a
;../../src/syslib/ansi_term.c:87: }
00106$:
;../../src/syslib/ansi_term.c:90: cmd[1] = (spaces / 100) + 0x30;
	push	bc
	ld	a,#0x64
	push	af
	inc	sp
	ld	a,4 (ix)
	push	af
	inc	sp
	call	__divuchar
	pop	af
	ld	e,l
	pop	bc
	ld	a,e
	add	a, #0x30
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:91: spaces -= (100 * (spaces / 100));
	ld	l,e
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	ld	a,4 (ix)
	sub	a, l
	ld	4 (ix),a
;../../src/syslib/ansi_term.c:92: cmd[2] = (spaces / 10) + 0x30;
	push	bc
	ld	a,#0x0a
	push	af
	inc	sp
	ld	a,4 (ix)
	push	af
	inc	sp
	call	__divuchar
	pop	af
	ld	e,l
	pop	bc
	ld	a,e
	add	a, #0x30
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:93: spaces -= (10 * (spaces / 10));
	ld	l,e
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	a,4 (ix)
	sub	a, l
;../../src/syslib/ansi_term.c:94: cmd[3] = spaces + 0x30;
	ld	4 (ix), a
	add	a, #0x30
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),a
;../../src/syslib/ansi_term.c:96: term_sendCommand(cmd);
	push	bc
	call	_term_sendCommand
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/ansi_term.c:99: void term_ANSIClrLine(EraseDir dir) {
;	---------------------------------
; Function term_ANSIClrLine
; ---------------------------------
_term_ANSIClrLine::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;../../src/syslib/ansi_term.c:100: char cmd[] = ANSI_CLRLINE;
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x5b
	ld	e, c
	ld	d, b
	inc	de
	ld	a,#0x5f
	ld	(de),a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl),#0x4b
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:102: switch(dir) {
	ld	a,#0x02
	sub	a, 4 (ix)
	jr	C,00104$
	push	de
	ld	e,4 (ix)
	ld	d,#0x00
	ld	hl,#00112$
	add	hl,de
	add	hl,de
;../../src/syslib/ansi_term.c:103: case ed_erase_after:
	pop	de
	jp	(hl)
00112$:
	jr	00102$
	jr	00101$
	jr	00103$
00101$:
;../../src/syslib/ansi_term.c:104: cmd[1] = '0';
	ld	a,#0x30
	ld	(de),a
;../../src/syslib/ansi_term.c:105: break;
	jr	00105$
;../../src/syslib/ansi_term.c:106: case ed_erase_before:
00102$:
;../../src/syslib/ansi_term.c:107: cmd[1] = '1';
	ld	a,#0x31
	ld	(de),a
;../../src/syslib/ansi_term.c:108: break;
	jr	00105$
;../../src/syslib/ansi_term.c:109: case ed_erase_all:
00103$:
;../../src/syslib/ansi_term.c:110: default:
00104$:
;../../src/syslib/ansi_term.c:111: cmd[1] = '2';
	ld	a,#0x32
	ld	(de),a
;../../src/syslib/ansi_term.c:113: }
00105$:
;../../src/syslib/ansi_term.c:115: term_sendCommand(cmd);
	push	bc
	call	_term_sendCommand
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/ansi_term.c:118: void term_ANSIClrScrn(EraseDir dir) {
;	---------------------------------
; Function term_ANSIClrScrn
; ---------------------------------
_term_ANSIClrScrn::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;../../src/syslib/ansi_term.c:119: char cmd[] = ANSI_CLRSCRN;
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x5b
	ld	e, c
	ld	d, b
	inc	de
	ld	a,#0x5f
	ld	(de),a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl),#0x4a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:121: switch(dir) {
	ld	a,#0x02
	sub	a, 4 (ix)
	jr	C,00104$
	push	de
	ld	e,4 (ix)
	ld	d,#0x00
	ld	hl,#00112$
	add	hl,de
	add	hl,de
;../../src/syslib/ansi_term.c:122: case ed_erase_after:
	pop	de
	jp	(hl)
00112$:
	jr	00102$
	jr	00101$
	jr	00103$
00101$:
;../../src/syslib/ansi_term.c:123: case ed_erase_before:
00102$:
;../../src/syslib/ansi_term.c:124: cmd[1] = '0';
	ld	a,#0x30
	ld	(de),a
;../../src/syslib/ansi_term.c:125: break;
	jr	00105$
;../../src/syslib/ansi_term.c:126: case ed_erase_all:
00103$:
;../../src/syslib/ansi_term.c:127: default:
00104$:
;../../src/syslib/ansi_term.c:128: cmd[1] = '2';
	ld	a,#0x32
	ld	(de),a
;../../src/syslib/ansi_term.c:130: }
00105$:
;../../src/syslib/ansi_term.c:132: term_sendCommand(cmd);
	push	bc
	call	_term_sendCommand
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/ansi_term.c:135: void term_ANSISetParam(uint8_t prm) {
;	---------------------------------
; Function term_ANSISetParam
; ---------------------------------
_term_ANSISetParam::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-14
	add	hl,sp
	ld	sp,hl
;../../src/syslib/ansi_term.c:136: char cmd[] = "[_;_;_;_;_m";
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x5b
	ld	hl,#0x0001
	add	hl,bc
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x5f
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl),#0x3b
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x5f
	ld	hl,#0x0004
	add	hl,bc
	ld	(hl),#0x3b
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x5f
	ld	hl,#0x0006
	add	hl,bc
	ld	(hl),#0x3b
	ld	hl,#0x0007
	add	hl,bc
	ld	(hl),#0x5f
	ld	hl,#0x0008
	add	hl,bc
	ld	(hl),#0x3b
	ld	hl,#0x0009
	add	hl,bc
	ld	(hl),#0x5f
	ld	hl,#0x000a
	add	hl,bc
	ld	(hl),#0x6d
	ld	hl,#0x000b
	add	hl,bc
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:137: int idx = 1;
	ld	de,#0x0001
;../../src/syslib/ansi_term.c:139: if (ANSI_P_CHK_AOFF(prm)) {
	bit	0, 4 (ix)
	jr	Z,00102$
;../../src/syslib/ansi_term.c:140: cmd[idx] = '0';
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x30
;../../src/syslib/ansi_term.c:141: idx += 2;
	ld	de,#0x0003
00102$:
;../../src/syslib/ansi_term.c:144: if (ANSI_P_CHK_BOLD(prm)) {
	bit	1, 4 (ix)
	jr	Z,00104$
;../../src/syslib/ansi_term.c:145: cmd[idx] = '1';
	ld	l, e
	ld	h, d
	add	hl,bc
	ld	(hl),#0x31
;../../src/syslib/ansi_term.c:146: idx += 2;
	inc	de
	inc	de
00104$:
;../../src/syslib/ansi_term.c:149: if (ANSI_P_CHK_UNDR(prm)) {
	bit	2, 4 (ix)
	jr	Z,00106$
;../../src/syslib/ansi_term.c:150: cmd[idx] = '4';
	ld	l, e
	ld	h, d
	add	hl,bc
	ld	(hl),#0x34
;../../src/syslib/ansi_term.c:151: idx += 2;
	inc	de
	inc	de
00106$:
;../../src/syslib/ansi_term.c:154: if (ANSI_P_CHK_BLNK(prm)) {
	bit	3, 4 (ix)
	jr	Z,00108$
;../../src/syslib/ansi_term.c:155: cmd[idx] = '5';
	ld	l, e
	ld	h, d
	add	hl,bc
	ld	(hl),#0x35
;../../src/syslib/ansi_term.c:156: idx += 2;
	inc	de
	inc	de
00108$:
;../../src/syslib/ansi_term.c:159: if (ANSI_P_CHK_REVR(prm)) {
	bit	4, 4 (ix)
	jr	Z,00110$
;../../src/syslib/ansi_term.c:160: cmd[idx] = '7';
	ld	l, e
	ld	h, d
	add	hl,bc
	ld	(hl),#0x37
;../../src/syslib/ansi_term.c:161: idx += 2;
	inc	de
	inc	de
00110$:
;../../src/syslib/ansi_term.c:164: cmd[idx - 1] = 'm';
	ld	l,e
	dec	l
	ld	h,#0x00
	add	hl,bc
	ld	(hl),#0x6d
;../../src/syslib/ansi_term.c:165: cmd[idx] = '\0';
	ex	de,hl
	add	hl,bc
	ld	(hl),#0x00
;../../src/syslib/ansi_term.c:167: term_sendCommand(cmd);
	push	bc
	call	_term_sendCommand
	ld	sp,ix
	pop	ix
	ret
;../../src/syslib/ansi_term.c:170: void term_ANSISaveCursor(void) {
;	---------------------------------
; Function term_ANSISaveCursor
; ---------------------------------
_term_ANSISaveCursor::
;../../src/syslib/ansi_term.c:171: term_sendCommand(ANSI_SAVECUR);
	ld	hl,#___str_7
	push	hl
	call	_term_sendCommand
	pop	af
	ret
___str_7:
	.ascii "7"
	.db 0x00
;../../src/syslib/ansi_term.c:174: void term_ANSIRestoreCursor(void) {
;	---------------------------------
; Function term_ANSIRestoreCursor
; ---------------------------------
_term_ANSIRestoreCursor::
;../../src/syslib/ansi_term.c:175: term_sendCommand(ANSI_RESTCUR);
	ld	hl,#___str_8
	push	hl
	call	_term_sendCommand
	pop	af
	ret
___str_8:
	.ascii "8"
	.db 0x00
;../../src/syslib/ansi_term.c:178: void term_ANSIIndex(void) {
;	---------------------------------
; Function term_ANSIIndex
; ---------------------------------
_term_ANSIIndex::
;../../src/syslib/ansi_term.c:179: term_sendCommand(ANSI_IDX);
	ld	hl,#___str_9
	push	hl
	call	_term_sendCommand
	pop	af
	ret
___str_9:
	.ascii "D"
	.db 0x00
;../../src/syslib/ansi_term.c:182: void term_ANSIReverseIndex(void) {
;	---------------------------------
; Function term_ANSIReverseIndex
; ---------------------------------
_term_ANSIReverseIndex::
;../../src/syslib/ansi_term.c:183: term_sendCommand(ANSI_REVIDX);	
	ld	hl,#___str_10
	push	hl
	call	_term_sendCommand
	pop	af
	ret
___str_10:
	.ascii "M"
	.db 0x00
;../../src/syslib/ansi_term.c:186: void term_sendCommand(char *cmd) {
;	---------------------------------
; Function term_sendCommand
; ---------------------------------
_term_sendCommand::
;../../src/syslib/ansi_term.c:189: cpm_putchar(ESC_CHR);
	ld	a,#0x1b
	push	af
	inc	sp
	call	_cpm_putchar
	inc	sp
;../../src/syslib/ansi_term.c:190: while (cmd[idx] != '\0') {
	ld	bc,#0x0000
00101$:
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	add	hl,bc
	ld	d,(hl)
	ld	a,d
	or	a, a
	ret	Z
;../../src/syslib/ansi_term.c:191: cpm_putchar(cmd[idx]);
	push	bc
	push	de
	inc	sp
	call	_cpm_putchar
	inc	sp
	pop	bc
;../../src/syslib/ansi_term.c:192: idx++;
	inc	bc
	jr	00101$
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
