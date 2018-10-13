;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module hw_modprn02
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hw_addInterruptHandler
	.globl _hw_inp
	.globl _hw_outp
	.globl _setup_modprn
	.globl _ctc_init
	.globl _sio_init
	.globl _modprn_setupInterrupts
	.globl _modprn_outch
	.globl _modprn_getch
	.globl _modprn_getchBuf
	.globl _modprn_getBreakStatus
	.globl _modprn_sendBreak
	.globl _modprn_int_getch
	.globl _chA_intHandler_rx_specialCond
	.globl _chA_intHandler_rx_charAvail
	.globl _chA_intHandler_statChng
	.globl _chB_intHandler_rx_specialCond
	.globl _chB_intHandler_rx_charAvail
	.globl _chB_intHandler_statChng
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ch_buf:
	.ds 36
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_reg5_status:
	.ds 2
_reg3_status:
	.ds 2
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
;../../src/hw/modprn02/hw_modprn02.c:61: void setup_modprn(MPRN_Channel chan, MPRN_BaudRate brate, MPRN_BPC bpc, MPRN_Stop sbit, MPRN_Parity parity) {
;	---------------------------------
; Function setup_modprn
; ---------------------------------
_setup_modprn::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../src/hw/modprn02/hw_modprn02.c:62: ctc_init(chan, brate);
	ld	h,5 (ix)
	ld	l,4 (ix)
	push	hl
	call	_ctc_init
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:63: sio_init(chan, bpc, sbit, parity);
	ld	h,8 (ix)
	ld	l,7 (ix)
	push	hl
	ld	h,6 (ix)
	ld	l,4 (ix)
	push	hl
	call	_sio_init
	pop	af
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:65: ch_buf[chan].avail = 0;
	ld	bc,#_ch_buf+0
	ld	e,4 (ix)
	ld	d,#0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl,bc
	ld	(hl),#0x00
	pop	ix
	ret
;../../src/hw/modprn02/hw_modprn02.c:68: void ctc_init(MPRN_Channel chan, MPRN_BaudRate brate) {
;	---------------------------------
; Function ctc_init
; ---------------------------------
_ctc_init::
;../../src/hw/modprn02/hw_modprn02.c:71: hw_outp(MODPRN02_CTC_CHAN_0 + chan, ctc_command); // Send the channel command
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x4c
	ld	b,a
	push	bc
	ld	a,#0x57
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:72: hw_outp(MODPRN02_CTC_CHAN_0 + chan, (uint8_t)brate); // Send the time constant. This will divide our input clock.
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	ret
;../../src/hw/modprn02/hw_modprn02.c:75: void sio_init(MPRN_Channel chan, MPRN_BPC bpc, MPRN_Stop sbit, MPRN_Parity parity) {
;	---------------------------------
; Function sio_init
; ---------------------------------
_sio_init::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../src/hw/modprn02/hw_modprn02.c:77: hw_outp(MODPRN02_SIO_A_CTRL + chan, SIO_BASIC_CMD_RST_CHN); // Reset the channel
	ld	a,4 (ix)
	add	a, #0x4a
	ld	b,a
	push	bc
	ld	a,#0x18
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:84: __endasm;
	nop
	nop
	nop
;../../src/hw/modprn02/hw_modprn02.c:87: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x04); // Select register 4
	push	bc
	ld	a,#0x04
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:88: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x40 |sbit | parity); // Set parity, stop bits and x16 clock mode
	ld	a,6 (ix)
	set	6, a
	or	a, 7 (ix)
	ld	d,a
	push	bc
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:91: reg5_status[chan] = 0x08 | (bpc >> 1); // Enable Tx, set Tx bits, RTS off
	ld	a,4 (ix)
	add	a, #<(_reg5_status)
	ld	e,a
	ld	a,#0x00
	adc	a, #>(_reg5_status)
	ld	d,a
	ld	a,5 (ix)
	srl	a
	set	3, a
	ld	(de),a
;../../src/hw/modprn02/hw_modprn02.c:92: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	push	de
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:93: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan]);
	ld	a,(de)
	ld	h,a
	push	bc
	push	de
	push	hl
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:96: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x01); // Select register 1
	push	bc
	push	de
	ld	a,#0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:97: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Disable interrupts
	push	bc
	push	de
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:100: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x03); // Select register 3
	push	bc
	push	de
	ld	a,#0x03
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:101: hw_outp(MODPRN02_SIO_A_CTRL + chan, (0x01|bpc)); // Set rx bits and enable RX
	ld	a,5 (ix)
	set	0, a
	ld	h,a
	push	bc
	push	de
	push	hl
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:104: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	push	de
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:105: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan] | SIO_REG5_RTS_FLAG);
	ld	a,(de)
	set	1, a
	ld	d,a
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	ix
	ret
;../../src/hw/modprn02/hw_modprn02.c:108: void modprn_setupInterrupts(uint8_t ivect_start) {
;	---------------------------------
; Function modprn_setupInterrupts
; ---------------------------------
_modprn_setupInterrupts::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../src/hw/modprn02/hw_modprn02.c:109: ivect_start &= SIO_VECT_LOC_MASK;
	ld	a,4 (ix)
	and	a, #0xf1
	ld	4 (ix),a
;../../src/hw/modprn02/hw_modprn02.c:113: hw_addInterruptHandler(ivect_start | 0x02, (uint16_t)chB_intHandler_statChng);
	ld	bc,#_chB_intHandler_statChng
	ld	a,4 (ix)
	set	1, a
	ld	d,a
	push	bc
	push	de
	inc	sp
	call	_hw_addInterruptHandler
	pop	af
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:114: hw_addInterruptHandler(ivect_start | 0x04, (uint16_t)chB_intHandler_rx_charAvail);
	ld	bc,#_chB_intHandler_rx_charAvail
	ld	a,4 (ix)
	set	2, a
	ld	d,a
	push	bc
	push	de
	inc	sp
	call	_hw_addInterruptHandler
	pop	af
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:115: hw_addInterruptHandler(ivect_start | 0x06, (uint16_t)chB_intHandler_rx_specialCond);
	ld	bc,#_chB_intHandler_rx_specialCond
	ld	a,4 (ix)
	or	a, #0x06
	ld	d,a
	push	bc
	push	de
	inc	sp
	call	_hw_addInterruptHandler
	pop	af
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:119: hw_addInterruptHandler(ivect_start | 0x0A, (uint16_t)chA_intHandler_statChng);
	ld	bc,#_chA_intHandler_statChng
	ld	a,4 (ix)
	or	a, #0x0a
	ld	d,a
	push	bc
	push	de
	inc	sp
	call	_hw_addInterruptHandler
	pop	af
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:120: hw_addInterruptHandler(ivect_start | 0x0C, (uint16_t)chA_intHandler_rx_charAvail);
	ld	bc,#_chA_intHandler_rx_charAvail
	ld	a,4 (ix)
	or	a, #0x0c
	ld	d,a
	push	bc
	push	de
	inc	sp
	call	_hw_addInterruptHandler
	pop	af
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:121: hw_addInterruptHandler(ivect_start | 0x0E, (uint16_t)chA_intHandler_rx_specialCond);
	ld	bc,#_chA_intHandler_rx_specialCond
	ld	a,4 (ix)
	or	a, #0x0e
	ld	d,a
	push	bc
	push	de
	inc	sp
	call	_hw_addInterruptHandler
;../../src/hw/modprn02/hw_modprn02.c:123: hw_outp(MODPRN02_SIO_B_CTRL, 0x02); // Select register 2
	inc	sp
	ld	hl,#0x024b
	ex	(sp),hl
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:124: hw_outp(MODPRN02_SIO_B_CTRL, ivect_start); // Interrupt vector 0
	ld	a,4 (ix)
	ld	d,a
	ld	e,#0x4b
	push	de
	call	_hw_outp
;../../src/hw/modprn02/hw_modprn02.c:127: hw_outp(MODPRN02_SIO_A_CTRL, 0x01); // Select register 1
	ld	hl, #0x014a
	ex	(sp),hl
	call	_hw_outp
;../../src/hw/modprn02/hw_modprn02.c:128: hw_outp(MODPRN02_SIO_A_CTRL, 0x1C); // Enable interrupts for received chars, TX and status affect vector
	ld	hl, #0x1c4a
	ex	(sp),hl
	call	_hw_outp
;../../src/hw/modprn02/hw_modprn02.c:130: hw_outp(MODPRN02_SIO_B_CTRL, 0x01); // Select register 1
	ld	hl, #0x014b
	ex	(sp),hl
	call	_hw_outp
;../../src/hw/modprn02/hw_modprn02.c:131: hw_outp(MODPRN02_SIO_B_CTRL, 0x1C); // Enable interrupts for received chars, TX and status affect vector
	ld	hl, #0x1c4b
	ex	(sp),hl
	call	_hw_outp
	pop	af
	pop	ix
	ret
;../../src/hw/modprn02/hw_modprn02.c:134: void modprn_outch(MPRN_Channel chan, uint8_t ch) {
;	---------------------------------
; Function modprn_outch
; ---------------------------------
_modprn_outch::
;../../src/hw/modprn02/hw_modprn02.c:137: do {
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x4a
	ld	b,a
00102$:
;../../src/hw/modprn02/hw_modprn02.c:138: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:139: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL + chan);
	push	bc
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:140: } while(!(reg_0 & SIO_REG0_TXEMPTY_FLAG) || !(reg_0 & SIO_REG0_CTS_FLAG));
	bit	2, l
	jr	Z,00102$
	bit	5, l
	jr	Z,00102$
;../../src/hw/modprn02/hw_modprn02.c:142: hw_outp(MODPRN02_SIO_A_DATA + chan, ch);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x48
	ld	b,a
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	ret
;../../src/hw/modprn02/hw_modprn02.c:146: uint8_t modprn_getch(MPRN_Channel chan) {
;	---------------------------------
; Function modprn_getch
; ---------------------------------
_modprn_getch::
;../../src/hw/modprn02/hw_modprn02.c:149: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x4a
	ld	b,a
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:150: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL + chan);
	push	bc
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:152: if (!(reg_0 & SIO_REG0_RXAVAIL_FLAG)) { // If we already have a char waiting, raising the RTS line could cause overrun!
	bit	0, l
	jr	NZ,00105$
;../../src/hw/modprn02/hw_modprn02.c:153: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:154: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan] | SIO_REG5_RTS_FLAG);
	ld	a,#<(_reg5_status)
	ld	hl,#2
	add	hl,sp
	add	a, (hl)
	ld	e,a
	ld	a,#>(_reg5_status)
	adc	a, #0x00
	ld	d,a
	ld	a,(de)
	set	1, a
	ld	h,a
	push	bc
	push	de
	push	hl
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:156: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0
	push	bc
	push	de
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:157: do {
00101$:
;../../src/hw/modprn02/hw_modprn02.c:158: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL + chan);
	push	bc
	push	de
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:159: } while (!(reg_0 & SIO_REG0_RXAVAIL_FLAG));
	bit	0, l
	jr	Z,00101$
;../../src/hw/modprn02/hw_modprn02.c:161: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	push	de
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:162: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan]);
	ld	a,(de)
	ld	d,a
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
00105$:
;../../src/hw/modprn02/hw_modprn02.c:165: return hw_inp(MODPRN02_SIO_A_DATA + chan);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x48
	ld	b,a
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	ret
;../../src/hw/modprn02/hw_modprn02.c:168: uint8_t modprn_getchBuf(MPRN_Channel chan, uint8_t *buf, uint8_t bufSize) {
;	---------------------------------
; Function modprn_getchBuf
; ---------------------------------
_modprn_getchBuf::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../src/hw/modprn02/hw_modprn02.c:172: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0
	ld	a,4 (ix)
	add	a, #0x4a
	ld	b,a
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:173: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL + chan);
	push	bc
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:175: if (!(reg_0 & SIO_REG0_RXAVAIL_FLAG)) { // If we already have a char waiting, raising the RTS line could cause overrun!
	bit	0, l
	jr	NZ,00105$
;../../src/hw/modprn02/hw_modprn02.c:176: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:177: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan] | SIO_REG5_RTS_FLAG);
	ld	a,4 (ix)
	add	a, #<(_reg5_status)
	ld	e,a
	ld	a,#0x00
	adc	a, #>(_reg5_status)
	ld	d,a
	ld	a,(de)
	set	1, a
	ld	h,a
	push	bc
	push	de
	push	hl
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:179: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0
	push	bc
	push	de
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:180: do {
00101$:
;../../src/hw/modprn02/hw_modprn02.c:181: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL + chan);
	push	bc
	push	de
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:182: } while (!(reg_0 & SIO_REG0_RXAVAIL_FLAG));
	bit	0, l
	jr	Z,00101$
;../../src/hw/modprn02/hw_modprn02.c:184: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	push	de
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:185: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan]);
	ld	a,(de)
	ld	d,a
	push	bc
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
00105$:
;../../src/hw/modprn02/hw_modprn02.c:188: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0	
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:189: do {
	ld	a,4 (ix)
	add	a, #0x48
	ld	c,a
	ld	e,#0x00
00107$:
;../../src/hw/modprn02/hw_modprn02.c:190: buf[buf_used] = hw_inp(MODPRN02_SIO_A_DATA + chan);
	ld	l,5 (ix)
	ld	h,6 (ix)
	ld	d,#0x00
	add	hl, de
	push	hl
	push	bc
	push	de
	ld	a,c
	push	af
	inc	sp
	call	_hw_inp
	inc	sp
	ld	a,l
	pop	de
	pop	bc
	pop	hl
	ld	(hl),a
;../../src/hw/modprn02/hw_modprn02.c:191: buf_used++;
	inc	e
;../../src/hw/modprn02/hw_modprn02.c:193: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL + chan);
	push	bc
	push	de
	push	bc
	inc	sp
	call	_hw_inp
	inc	sp
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:194: } while ((reg_0 & SIO_REG0_RXAVAIL_FLAG) && (buf_used < bufSize));
	bit	0, l
	jr	Z,00109$
	ld	a,e
	sub	a, 7 (ix)
	jr	C,00107$
00109$:
;../../src/hw/modprn02/hw_modprn02.c:196: return buf_used;
	ld	l,e
	pop	ix
	ret
;../../src/hw/modprn02/hw_modprn02.c:199: uint8_t modprn_getBreakStatus(MPRN_Channel chan) {
;	---------------------------------
; Function modprn_getBreakStatus
; ---------------------------------
_modprn_getBreakStatus::
;../../src/hw/modprn02/hw_modprn02.c:200: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x00); // Select register 0
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x4a
	ld	b,a
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	inc	sp
	call	_hw_inp
	inc	sp
	ld	a,l
	and	a, #0x80
	ld	l,a
	ret
;../../src/hw/modprn02/hw_modprn02.c:204: void modprn_sendBreak(MPRN_Channel chan) {
;	---------------------------------
; Function modprn_sendBreak
; ---------------------------------
_modprn_sendBreak::
;../../src/hw/modprn02/hw_modprn02.c:205: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x4a
	ld	b,a
	push	bc
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:206: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan] | SIO_REG5_BREAK_FLAG); // Send the break signal
	ld	a,#<(_reg5_status)
	ld	hl,#2
	add	hl,sp
	add	a, (hl)
	ld	e,a
	ld	a,#>(_reg5_status)
	adc	a, #0x00
	ld	d,a
	ld	a,(de)
	set	4, a
	ld	h,a
	push	bc
	push	de
	push	hl
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:210: __endasm;
	nop
;../../src/hw/modprn02/hw_modprn02.c:212: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	push	bc
	push	de
	ld	a,#0x05
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	pop	de
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:213: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan]); // Disable break signal
	ld	a,(de)
	ld	d,a
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_hw_outp
	pop	af
	ret
;../../src/hw/modprn02/hw_modprn02.c:216: uint8_t modprn_int_getch(MPRN_Channel chan) {
;	---------------------------------
; Function modprn_int_getch
; ---------------------------------
_modprn_int_getch::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;../../src/hw/modprn02/hw_modprn02.c:219: while(!ch_buf[chan].avail);
	ld	bc,#_ch_buf+0
	ld	e,4 (ix)
	ld	d,#0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl,bc
	ld	c,l
	ld	b,h
00101$:
	ld	a,(hl)
	or	a, a
	jr	Z,00101$
;../../src/hw/modprn02/hw_modprn02.c:221: ch_buf[chan].avail--;
	ld	e,(hl)
	dec	e
	ld	(hl),e
;../../src/hw/modprn02/hw_modprn02.c:222: chbuf = ch_buf[chan].buf[ch_buf[chan].idx];
	ld	e, c
	ld	d, b
	inc	de
	ld	iy,#0x0011
	add	iy, bc
	ld	l, 0 (iy)
	ld	h,#0x00
	add	hl,de
	ld	a,(hl)
	ld	-1 (ix),a
;../../src/hw/modprn02/hw_modprn02.c:223: ch_buf[chan].idx++;
	inc	0 (iy)
;../../src/hw/modprn02/hw_modprn02.c:225: if (!ch_buf[chan].avail) {
	ld	a,(bc)
	or	a, a
	jr	NZ,00105$
;../../src/hw/modprn02/hw_modprn02.c:226: hw_outp(MODPRN02_SIO_A_CTRL + chan, 0x05); // Select register 5
	ld	a,4 (ix)
	add	a, #0x4a
	ld	c,a
	push	bc
	ld	a,#0x05
	push	af
	inc	sp
	ld	a,c
	push	af
	inc	sp
	call	_hw_outp
	pop	af
	pop	bc
;../../src/hw/modprn02/hw_modprn02.c:227: hw_outp(MODPRN02_SIO_A_CTRL + chan, reg5_status[chan] | SIO_REG5_RTS_FLAG); // Raise RTS
	ld	de,#_reg5_status+0
	ld	l,4 (ix)
	ld	h,#0x00
	add	hl,de
	ld	a,(hl)
	set	1, a
	push	af
	inc	sp
	ld	a,c
	push	af
	inc	sp
	call	_hw_outp
	pop	af
00105$:
;../../src/hw/modprn02/hw_modprn02.c:230: return chbuf;
	ld	l,-1 (ix)
	inc	sp
	pop	ix
	ret
;../../src/hw/modprn02/hw_modprn02.c:235: void chA_intHandler_rx_specialCond(void) __naked {
;	---------------------------------
; Function chA_intHandler_rx_specialCond
; ---------------------------------
_chA_intHandler_rx_specialCond::
;../../src/hw/modprn02/hw_modprn02.c:247: __endasm;
	push	af
	ld	a,#0x30
	out	(#(0x48 + 0x02)),a
	ei
	pop	af
	reti
;../../src/hw/modprn02/hw_modprn02.c:250: void chA_intHandler_rx_charAvail(void) __interrupt {
;	---------------------------------
; Function chA_intHandler_rx_charAvail
; ---------------------------------
_chA_intHandler_rx_charAvail::
	ei
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;../../src/hw/modprn02/hw_modprn02.c:253: hw_outp(MODPRN02_SIO_A_CTRL, 0x05); // Select register 5
	ld	hl,#0x054a
	push	hl
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:254: hw_outp(MODPRN02_SIO_A_CTRL, reg5_status[Channel_A]); // Lower RTS
	ld	hl,#_reg5_status+0
	ld	b,(hl)
	push	bc
	inc	sp
	ld	a,#0x4a
	push	af
	inc	sp
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:256: ch_buf[Channel_A].idx = 0;
	ld	hl,#(_ch_buf + 0x0011)
	ld	(hl),#0x00
;../../src/hw/modprn02/hw_modprn02.c:258: hw_outp(MODPRN02_SIO_A_CTRL, 0x00); // Select register 0
	ld	hl,#0x004a
	push	hl
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:259: do {
00101$:
;../../src/hw/modprn02/hw_modprn02.c:260: ch_buf[Channel_A].buf[ch_buf[Channel_A].avail] = hw_inp(MODPRN02_SIO_A_DATA);
	ld	bc,#_ch_buf + 1
	ld	hl, #_ch_buf + 0
	ld	l, (hl)
	ld	h,#0x00
	add	hl,bc
	push	hl
	ld	a,#0x48
	push	af
	inc	sp
	call	_hw_inp
	inc	sp
	ld	c,l
	pop	hl
	ld	(hl),c
;../../src/hw/modprn02/hw_modprn02.c:261: ch_buf[Channel_A].avail++;
	ld	a, (#_ch_buf + 0)
	inc	a
	ld	(#_ch_buf),a
;../../src/hw/modprn02/hw_modprn02.c:263: reg_0 = hw_inp(MODPRN02_SIO_A_CTRL);
	ld	a,#0x4a
	push	af
	inc	sp
	call	_hw_inp
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:264: } while (reg_0 & SIO_REG0_RXAVAIL_FLAG);
	bit	0, l
	jr	NZ,00101$
;../../src/hw/modprn02/hw_modprn02.c:268: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;../../src/hw/modprn02/hw_modprn02.c:279: void chA_intHandler_statChng(void) __naked {
;	---------------------------------
; Function chA_intHandler_statChng
; ---------------------------------
_chA_intHandler_statChng::
;../../src/hw/modprn02/hw_modprn02.c:291: __endasm;
	push	af
	ld	a,#0x30
	out	(#(0x48 + 0x02)),a
	ei
	pop	af
	reti
;../../src/hw/modprn02/hw_modprn02.c:295: void chB_intHandler_rx_specialCond(void) __naked {
;	---------------------------------
; Function chB_intHandler_rx_specialCond
; ---------------------------------
_chB_intHandler_rx_specialCond::
;../../src/hw/modprn02/hw_modprn02.c:307: __endasm;
	push	af
	ld	a,#0x30
	out	(#(0x48 + 0x03)),a
	ei
	pop	af
	reti
;../../src/hw/modprn02/hw_modprn02.c:310: void chB_intHandler_rx_charAvail(void) __interrupt {
;	---------------------------------
; Function chB_intHandler_rx_charAvail
; ---------------------------------
_chB_intHandler_rx_charAvail::
	ei
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;../../src/hw/modprn02/hw_modprn02.c:313: hw_outp(MODPRN02_SIO_B_CTRL, 0x05); // Select register 5
	ld	hl,#0x054b
	push	hl
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:314: hw_outp(MODPRN02_SIO_B_CTRL, reg5_status[Channel_B]); // Lower RTS
	ld	hl,#_reg5_status+1
	ld	b,(hl)
	push	bc
	inc	sp
	ld	a,#0x4b
	push	af
	inc	sp
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:316: ch_buf[Channel_B].idx = 0;
	ld	hl,#(_ch_buf + 0x0023)
	ld	(hl),#0x00
;../../src/hw/modprn02/hw_modprn02.c:318: hw_outp(MODPRN02_SIO_B_CTRL, 0x00); // Select register 0
	ld	hl,#0x004b
	push	hl
	call	_hw_outp
	pop	af
;../../src/hw/modprn02/hw_modprn02.c:319: do {
00101$:
;../../src/hw/modprn02/hw_modprn02.c:320: ch_buf[Channel_B].buf[ch_buf[Channel_B].avail] = hw_inp(MODPRN02_SIO_B_DATA);
	ld	bc,#_ch_buf + 19
	ld	hl, #(_ch_buf + 0x0012) + 0
	ld	l, (hl)
	ld	h,#0x00
	add	hl,bc
	push	hl
	ld	a,#0x49
	push	af
	inc	sp
	call	_hw_inp
	inc	sp
	ld	c,l
	pop	hl
	ld	(hl),c
;../../src/hw/modprn02/hw_modprn02.c:321: ch_buf[Channel_B].avail++;
	ld	a, (#(_ch_buf + 0x0012) + 0)
	inc	a
	ld	(#(_ch_buf + 0x0012)),a
;../../src/hw/modprn02/hw_modprn02.c:323: reg_0 = hw_inp(MODPRN02_SIO_B_CTRL);
	ld	a,#0x4b
	push	af
	inc	sp
	call	_hw_inp
	inc	sp
;../../src/hw/modprn02/hw_modprn02.c:324: } while (reg_0 & SIO_REG0_RXAVAIL_FLAG);
	bit	0, l
	jr	NZ,00101$
;../../src/hw/modprn02/hw_modprn02.c:328: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;../../src/hw/modprn02/hw_modprn02.c:339: void chB_intHandler_statChng(void) __naked {
;	---------------------------------
; Function chB_intHandler_statChng
; ---------------------------------
_chB_intHandler_statChng::
;../../src/hw/modprn02/hw_modprn02.c:351: __endasm;
	push	af
	ld	a,#0x30
	out	(#(0x48 + 0x03)),a
	ei
	pop	af
	reti
	.area _CODE
	.area _INITIALIZER
__xinit__reg5_status:
	.db #0x00	; 0
	.db #0x00	; 0
__xinit__reg3_status:
	.db #0x00	; 0
	.db #0x00	; 0
	.area _CABS (ABS)
