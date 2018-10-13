;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module hw_common
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hw_outp
	.globl _hw_inp
	.globl _hw_smallDelay
	.globl _hw_setupInterrupts
	.globl _hw_enableInterrupts
	.globl _hw_addInterruptHandler
	.globl _empty_ISR
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
;../../src/hw/common/hw_common.c:7: void hw_outp(uint8_t port, uint8_t data) __naked {
;	---------------------------------
; Function hw_outp
; ---------------------------------
_hw_outp::
;../../src/hw/common/hw_common.c:26: __endasm;
	ld	hl, #3
	add	hl, sp
	ld	a, (hl)
	ld	hl, #2
	add	hl, sp
	push	bc
	ld	c, (hl)
	out	(c), a
	pop	bc
	ret
;../../src/hw/common/hw_common.c:29: uint8_t hw_inp(uint8_t port) __naked {
;	---------------------------------
; Function hw_inp
; ---------------------------------
_hw_inp::
;../../src/hw/common/hw_common.c:44: __endasm;
	ld	hl, #2
	add	hl, sp
	push	bc
	ld	c, (hl)
	in	l,(c)
	pop	bc
	ret
;../../src/hw/common/hw_common.c:47: void hw_smallDelay(uint8_t delay) {
;	---------------------------------
; Function hw_smallDelay
; ---------------------------------
_hw_smallDelay::
;../../src/hw/common/hw_common.c:48: while(delay--) {
	ld	iy,#2
	add	iy,sp
	ld	c,0 (iy)
00101$:
	ld	b,c
	dec	c
	ld	a,b
	or	a, a
	ret	Z
;../../src/hw/common/hw_common.c:51: __endasm;
	nop
	jr	00101$
;../../src/hw/common/hw_common.c:55: void hw_setupInterrupts(void) {
;	---------------------------------
; Function hw_setupInterrupts
; ---------------------------------
_hw_setupInterrupts::
;../../src/hw/common/hw_common.c:68: __endasm;
	di
	push	af
	ld	a,#0x7F
	ld	I,a
	pop	af
;../../src/hw/common/hw_common.c:71: for(idx = 0; idx < 128; idx++) vec_table[idx] = (uint16_t)empty_ISR;
	ld	c,#0x00
00102$:
	ld	l,c
	ld	h,#0x00
	add	hl, hl
	ld	de,#0x7f00
	add	hl,de
	ld	de,#_empty_ISR
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	c
	ld	a,c
	sub	a, #0x80
	jr	C,00102$
	ret
;../../src/hw/common/hw_common.c:74: void hw_enableInterrupts(void) {
;	---------------------------------
; Function hw_enableInterrupts
; ---------------------------------
_hw_enableInterrupts::
;../../src/hw/common/hw_common.c:78: __endasm;
	im	2
	ei
	ret
;../../src/hw/common/hw_common.c:81: void hw_addInterruptHandler(uint8_t handNo, uint16_t addr) {
;	---------------------------------
; Function hw_addInterruptHandler
; ---------------------------------
_hw_addInterruptHandler::
;../../src/hw/common/hw_common.c:84: vec_table[handNo >> 1] = addr;
	ld	iy,#2
	add	iy,sp
	ld	l,0 (iy)
	srl	l
	ld	h,#0x00
	add	hl, hl
	ld	bc,#0x7f00
	add	hl,bc
	ld	iy,#3
	add	iy,sp
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
	ret
;../../src/hw/common/hw_common.c:87: void empty_ISR(void) __naked {
;	---------------------------------
; Function empty_ISR
; ---------------------------------
_empty_ISR::
;../../src/hw/common/hw_common.c:90: __endasm;
	halt
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
