;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module minboop
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _ym_reg
	.globl _exit
	.globl _sys_init
	.globl _cpm_sysfunc_init
	.globl _cprintf
	.globl _longjmp
	.globl ___setjmp
	.globl _exit_jmp
	.globl _exit_value
	.globl _sys_argv
	.globl _sys_argv0
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_sys_argv0::
	.ds 12
_sys_argv::
	.ds 16
_exit_value::
	.ds 2
_exit_jmp::
	.ds 6
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
;minboop.c:8: void sys_init(int *argc, char ***argv)
;	---------------------------------
; Function sys_init
; ---------------------------------
_sys_init::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-7
	add	hl,sp
	ld	sp,hl
;minboop.c:13: cpm_sysfunc_init();
	call	_cpm_sysfunc_init
;minboop.c:15: p = (char*)0x81; // CCP Command Tail
	ld	-6 (ix),#0x81
	ld	-5 (ix),#0x00
;minboop.c:16: count = *(unsigned char*)0x80; // CCP Command Tail Length
	ld	a,(#0x0080)
	ld	-7 (ix),a
;minboop.c:18: *argc = 1;
	ld	a,4 (ix)
	ld	-2 (ix),a
	ld	a,5 (ix)
	ld	-1 (ix),a
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x01
	inc	hl
	ld	(hl),#0x00
;minboop.c:19: sys_argv[0] = strcpy(sys_argv0, "ym.com");
	ld	de,#_sys_argv0
	ld	hl,#___str_0
	xor	a, a
	push	de
00151$:
	cp	a, (hl)
	ldi
	jr	NZ, 00151$
	pop	bc
	ld	(_sys_argv), bc
;minboop.c:21: p[count] = '\0'; // XXX count < 128!
	ld	a,-7 (ix)
	add	a, #0x81
	ld	c,a
	ld	a,#0x00
	adc	a, #0x00
	ld	b,a
	xor	a, a
	ld	(bc),a
;minboop.c:23: while(*p == ' ')
00101$:
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	c,(hl)
	ld	a,c
	sub	a, #0x20
	jr	NZ,00103$
;minboop.c:24: p++;
	inc	-6 (ix)
	jr	NZ,00101$
	inc	-5 (ix)
	jr	00101$
00103$:
;minboop.c:25: if(!*p)
	ld	a,c
	or	a, a
	jp	Z,00115$
;minboop.c:27: sys_argv[(*argc)++] = p;
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	e, c
	ld	d, b
	inc	de
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ld	l, c
	ld	h, b
	add	hl, hl
	ld	de,#_sys_argv
	add	hl,de
	ld	a,-6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,-5 (ix)
	ld	(hl),a
;minboop.c:28: while(*p && (*p != ' '))
	ld	e,-6 (ix)
	ld	d,-5 (ix)
00107$:
	ld	a,(de)
	ld	c,a
;minboop.c:29: p++;
	ld	hl,#0x0001
	add	hl,de
	ld	-4 (ix),l
	ld	-3 (ix),h
;minboop.c:28: while(*p && (*p != ' '))
	ld	a,c
	or	a, a
	jr	Z,00109$
	ld	a,c
	sub	a, #0x20
	jr	Z,00109$
;minboop.c:29: p++;
	ld	e,-4 (ix)
	ld	d,-3 (ix)
	jr	00107$
00109$:
;minboop.c:30: if(!*p)
	ld	a,c
	or	a, a
	jr	Z,00115$
;minboop.c:32: *p++ = '\0';
	xor	a, a
	ld	(de),a
	ld	a,-4 (ix)
	ld	-6 (ix),a
	ld	a,-3 (ix)
	ld	-5 (ix),a
;minboop.c:33: } while(*p && (*argc < 8));
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	a,(hl)
	or	a, a
	jr	Z,00115$
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,c
	sub	a, #0x08
	ld	a,b
	rla
	ccf
	rra
	sbc	a, #0x80
	jp	C,00101$
00115$:
;minboop.c:35: *argv = sys_argv;
	ld	l,6 (ix)
	ld	h,7 (ix)
	ld	(hl),#<(_sys_argv)
	inc	hl
	ld	(hl),#>(_sys_argv)
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "ym.com"
	.db 0x00
;minboop.c:41: void exit(int value)
;	---------------------------------
; Function exit
; ---------------------------------
_exit::
;minboop.c:43: exit_value = value;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	ld	(#_exit_value + 0),a
	ld	hl, #2+1
	add	hl, sp
	ld	a, (hl)
	ld	(#_exit_value + 1),a
;minboop.c:44: longjmp(exit_jmp, 1);
	ld	hl,#0x0001
	push	hl
	ld	hl,#_exit_jmp
	push	hl
	call	_longjmp
	ret
;minboop.c:47: void ym_reg(uint8_t i, uint8_t r) { //__naked {
;	---------------------------------
; Function ym_reg
; ---------------------------------
_ym_reg::
;minboop.c:58: __endasm;
	ld	a, l
	out	(129), a
	ld	a, h
	out	(129), a
	ret
;minboop.c:60: int main() { // (int argc, char ** argv) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;minboop.c:64: sys_init(&argc, &argv);
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	hl,#0x0002
	add	hl,sp
	push	bc
	push	hl
	call	_sys_init
	pop	af
;minboop.c:65: if(setjmp(exit_jmp) != 0)
	ld	hl, #_exit_jmp
	ex	(sp),hl
	call	___setjmp
	pop	af
	ld	a,h
	or	a,l
	jr	Z,00102$
;minboop.c:66: return exit_value;
	ld	hl,(_exit_value)
	jr	00103$
00102$:
;minboop.c:68: printf("Boopo!\n");
	ld	hl,#___str_1
	push	hl
	call	_cprintf
;minboop.c:71: ym_reg(0, 0xFD);   // channel A 0:7
	ld	hl, #0xfd00
	ex	(sp),hl
	call	_ym_reg
;minboop.c:72: ym_reg(1, 0);      // channel A 8:11 (bottom nybble)
	ld	hl, #0x0001
	ex	(sp),hl
	call	_ym_reg
;minboop.c:73: ym_reg(2, 0xBA);   // channel B 0:7
	ld	hl, #0xba02
	ex	(sp),hl
	call	_ym_reg
;minboop.c:74: ym_reg(3, 0);      // channel B 8:11 (bottom nybble)
	ld	hl, #0x0003
	ex	(sp),hl
	call	_ym_reg
;minboop.c:75: ym_reg(4, 0x8E);   // channel C 0:7
	ld	hl, #0x8e04
	ex	(sp),hl
	call	_ym_reg
;minboop.c:76: ym_reg(5, 0);      // channel C 8:11 (bottom nybble)
	ld	hl, #0x0005
	ex	(sp),hl
	call	_ym_reg
;minboop.c:77: ym_reg(6, 0);      // noise period
	ld	hl, #0x0006
	ex	(sp),hl
	call	_ym_reg
;minboop.c:78: ym_reg(7, 0x38);   // tone/noise enable
	ld	hl, #0x3807
	ex	(sp),hl
	call	_ym_reg
;minboop.c:79: ym_reg(8, 0x10);   // channel A volume
	ld	hl, #0x1008
	ex	(sp),hl
	call	_ym_reg
;minboop.c:80: ym_reg(9, 0x10);   // channel B volume
	ld	hl, #0x1009
	ex	(sp),hl
	call	_ym_reg
;minboop.c:81: ym_reg(10, 0x10);  // channel C volume
	ld	hl, #0x100a
	ex	(sp),hl
	call	_ym_reg
;minboop.c:82: ym_reg(11, 0xA1);  // envelope period 0:7
	ld	hl, #0xa10b
	ex	(sp),hl
	call	_ym_reg
;minboop.c:83: ym_reg(12, 0x07);  // envelope period 8:15
	ld	hl, #0x070c
	ex	(sp),hl
	call	_ym_reg
;minboop.c:84: ym_reg(13, 0x09);  // envelope shape 0:3 (bottom nybble)
	ld	hl, #0x090d
	ex	(sp),hl
	call	_ym_reg
;minboop.c:85: ym_reg(14, 0x00);  // port A (unused)
	ld	hl, #0x000e
	ex	(sp),hl
	call	_ym_reg
;minboop.c:86: ym_reg(15, 0x00);  // port B (unused)
	ld	hl, #0x000f
	ex	(sp),hl
	call	_ym_reg
	pop	af
;minboop.c:88: return 0;
	ld	hl,#0x0000
00103$:
	ld	sp, ix
	pop	ix
	ret
___str_1:
	.ascii "Boopo!"
	.db 0x0a
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
