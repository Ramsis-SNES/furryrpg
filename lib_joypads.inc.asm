;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** JOYPAD & INPUT HANDLER ***
;
;==========================================================================================



;------------------------------------------------------------------------
;-  Written by: Neviksti
;-     If you use my code, please share your creations with me
;-     as I am always curious :)
;------------------------------------------------------------------------

JoyInit:
	lda	#$C0							; have the automatic read of the SNES read the first pair of JoyPads
	sta	REG_WRIO
	ldx	#$0000
	stx	Joy1Press
	stx	Joy2Press
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN						; enable JoyPad Read and NMI
	cli								; clear interrupt disable bit
	wai								; wait for NMI to fill the variables with real JoyPad data
	rts



GetInput:
	php

	Accu8

	lda	#$01

_W1:	bit	REG_HVBJOY
	bne	_W1							; wait till automatic JoyPort read is complete

	AccuIndex16

; ********** get Joypads 1, 2

	lda	Joy1
	sta	Joy1Old

	lda	REG_JOY1L						; get JoyPad1
	tax
	eor	Joy1							; A = A xor JoyState = (changes in joy state)
	stx	Joy1							; update JoyState
	ora	Joy1Press						; A = (joy changes) or (buttons pressed)
	and	Joy1							; A = ((joy changes) or (buttons pressed)) and (current joy state)
	sta	Joy1Press						; store A = (buttons pressed since last clearing reg) and (button is still down)

	lda	REG_JOY2L						; get JoyPad2
	tax
	eor	Joy2							; A = A xor JoyState = (changes in joy state)
	stx	Joy2							; update JoyState
	ora	Joy2Press						; A = (joy changes) or (buttons pressed)
	and	Joy2							; A = ((joy changes) or (buttons pressed)) and (current joy state)
	sta	Joy2Press						; store A = (buttons pressed since last clearing reg) and (button is still down)

	lda	Joy1Old
	eor	#$FFFF
	and	Joy1
	sta	Joy1New

; ********** make sure Joypads 1, 2 are valid

	AccuIndex8

	lda	REG_JOYA
	eor	#$01
	and	#$01							; A = -bit0 of JOYA
	ora	Joy1
	sta	Joy1							; joy state = (joy state) or A.... so bit0 of Joy1State = 0 only if it is a valid joypad

	lda	REG_JOYB
	eor	#$01
	and	#$01							; A = -bit0 of JOYB
	ora	Joy2
	sta	Joy2							; joy state = (joy state) or A.... so bit0 of Joy1State = 0 only if it is a valid joypad

; ********** change all invalid joypads to have a state of no button presses

	AccuIndex16

	ldx	#$0001
	lda	#$000F
	bit	Joy1							; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	_joy2							; into the joy port, or it is not a joypad
	stx	Joy1							; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	Joy1Press

_joy2:
	bit	Joy2							; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	_done							; into the joy port, or it is not a joypad
	stx	Joy2							; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	Joy2Press

_done:
	plp
	rts



; ******************************** EOF *********************************
