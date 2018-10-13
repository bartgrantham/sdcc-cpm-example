;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module cpmbdos
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cpmbdos
	.globl _cpmbdos_extn
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
;../../src/cpm/cpmbdos.c:4: uint8_t cpmbdos(BDOSCALL *p) __naked {
;	---------------------------------
; Function cpmbdos
; ---------------------------------
_cpmbdos::
;../../src/cpm/cpmbdos.c:21: __endasm;
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	l,4(ix)
	ld	h,5(ix)
	ld	c,(hl) ; Load function
	inc	hl
	ld	e,(hl) ; Prepare parameter in E ...
	inc	hl
	ld	d,(hl) ; And prepare parameter in D
	call	5 ; Make BDOS call!
	pop	ix
	ret
;../../src/cpm/cpmbdos.c:25: uint8_t cpmbdos_extn(BDOSCALL *p, uint16_t* ret_ba, uint16_t *ret_hl) __naked {
;	---------------------------------
; Function cpmbdos_extn
; ---------------------------------
_cpmbdos_extn::
;../../src/cpm/cpmbdos.c:72: __endasm;
	push	ix
	ld	ix,#0x00
	add	ix,sp
	ld	l,4(ix) ; Load the pointer to BDOSCALL p into HL
	ld	h,5(ix) ; Prepare HL to contain the parameter address
	ld	c,(hl) ; Load p->func8 in register C
	inc	hl ; Inrease the address so we point to first byte of p->parm16
	ld	e,(hl) ; Read first byte...
	inc	hl
	ld	d,(hl) ; Read second byte. We have p->parm16 in DE
	call	5 ; Execute BDOS call!
;	We now have the return values in BA and HL
	push	bc
	push	hl
	ld	ix,#0x00
	add	ix,sp
	ld	l,10(ix)
	ld	h,11(ix) ; Load pointer to ret_ba
	ld	(hl),b
	inc	hl
	ld	(hl),a
	ld	l,12(ix)
	ld	h,13(ix)
	pop	bc ; Recover the HL we have pushed
	ld	(hl),b
	inc	hl
	ld	(hl),c
	push	bc; Put HL back where it belongs
	pop	hl;
	pop	bc ; Restore BC
	pop	ix ; Restore IX
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
