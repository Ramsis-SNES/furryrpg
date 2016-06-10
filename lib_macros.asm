;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** GLOBAL MACROS ***
;
;==========================================================================================



; ******************************* Macros *******************************

; -------------------------- A/X/Y register control
.MACRO Accu8
	sep	#$20
.ENDM



.MACRO Accu16
	rep	#$20
.ENDM



.MACRO AccuIndex8
	sep	#$30
.ENDM



.MACRO AccuIndex16
	rep	#$30
.ENDM



.MACRO Index8
	sep	#$10
.ENDM



.MACRO Index16
	rep	#$10
.ENDM



; -------------------------- pseudo-opcode macros
.ACCU 8
.INDEX 16

; Macro bsr by ManuLöwe
;
; Usage: bsr <subroutine>
; Effect: Branch-relative to subroutine (useful for relocatable code).

.MACRO bsr
	per	__ReturnAdress\@ - 1					; push relative return address minus 1 (RTS adds 1) onto stack
	brl	\1							; branch-relative to subroutine

__ReturnAdress\@:

.ENDM



; Macro ldb by ManuLöwe
;
; Usage: ldb <value>
; Effect: Loads an 8-bit value/address into the B accumulator (high byte of 16-bit accu) without destroying the contents of the A accumulator.
;
; Expects: A 8 bit

.MACRO ldb
	xba
	lda	\1
	xba
.ENDM



; Macro ldc by ManuLöwe
;
; Usage: ldc <value>
; Effect: Loads a 16-bit value/address into the accumulator. Useful whenever it's important to set the contents of the B accu without having to worry about the current accu size.

.MACRO ldc
	php

	Accu16

	lda.w	\1

	plp
.ENDM



; -------------------------- frequently-used "code snippet" macros
.ACCU 8

; Macro DisableIRQs by ManuLöwe
;
; Usage: DisableIRQs
; Effect: Disables NMI & IRQ.
;
; Expects: A 8 bit

.MACRO DisableIRQs
	sei
	lda.b	#$00							; reminder: stz doesn't support 24-bit addressing
	sta.l	REG_NMITIMEN
.ENDM



; DMA macro by ManuLöwe
;
; Usage: DMA_CH0 mode[8bit], A_bus_bank[8bit], A_bus_src[16bit], B_bus_register[8bit], length[16bit]
; Effect: Transfers data via DMA channel 0.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO DMA_CH0
	lda	#\1							; DMA mode (8 bit)
 	sta	$4300
	lda	#\4							; B bus register (8 bit)
	sta	$4301
	ldx	#(\3 & $FFFF)						; get low word of data offset (16 bit)
	stx	$4302
	lda	#\2							; data bank (8 bit)
	sta	$4304
	ldx	#\5							; data length (16 bit)
	stx	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN
.ENDM



; Macro DrawFrame by ManuLöwe
;
; Usage: DrawFrame <x start>, <y start>, <width>, <height>
; Effect: Draws a frame using the BG3 text buffer.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO DrawFrame

; -------------------------- draw upper border
	ldx	#32*\2 + \1
	lda	#$10							; upper left corner
	sta	TileMapBG3, x
	lda	#$11							; horizontal line

__DrawUpperBorder\@:
	inx
	sta	TileMapBG3, x
	cpx	#32*\2 + \1 + \3
	bne	__DrawUpperBorder\@

	lda	#$12							; upper right corner
	sta	TileMapBG3, x
	bra	__GoToNextLine\@



; -------------------------- draw left & right border
__DrawLRBorder\@:
	lda	#$13							; left vertical line
	sta	TileMapBG3, x

	Accu16

	txa
	clc
	adc	#\3							; go to right border
	tax

	Accu8

	lda	#$14							; right vertical line
	sta	TileMapBG3, x

__GoToNextLine\@:
	Accu16

	txa
	clc
	adc	#32 - \3						; go to next line
	tax

	Accu8

	cpx	#32*(\2+\4) + \1
	bne	__DrawLRBorder\@



; -------------------------- draw lower border
	lda	#$15							; lower left corner
	sta	TileMapBG3, x
	inx
	lda	#$16							; horizontal line

__DrawLowerBorder\@:
	sta	TileMapBG3, x
	inx
	cpx	#32*(\2+\4) + \1 + \3
	bne	__DrawLowerBorder\@

	lda	#$17							; lower right corner
	sta	TileMapBG3, x
.ENDM



; Set Data Bank macro by ManuLöwe
;
; Usage: SetDBR $XX
; Effect: Sets the Data Bank register to $XX.
;
; Expects: A 8 bit

.MACRO SetDBR
	lda.b	#\1
	pha
	plb
.ENDM



; Set Direct Page macro by ManuLöwe
;
; Usage: SetDPag $XXXX
; Effect: Sets the Direct Page register to $XXXX.
;
; Expects: A 16 bit

.MACRO SetDPag
	lda.w	#\1
	tcd
.ENDM



; Macro SetIRQ by ManuLöwe
;
; Usage: SetIRQ <Name of IRQ routine>
; Effect: Writes the desired jumping instruction to the RAM location the IRQ vector points to. Caveat: IRQ has to be disabled before the macro is called!
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO SetIRQ
	Accu16

	lda	#\1
	asl	a							; value × 4 (the table consists of 4-byte entries)
	asl	a
	tax
	lda.l	SRC_IRQJumpTable, x					; holds a 4-byte instruction like jml SomeVblankRoutine
	sta	DP_IRQJump						; IRQ vector points here
	inx
	inx
	lda.l	SRC_IRQJumpTable, x
	sta	DP_IRQJump+2

	Accu8
.ENDM



; Macro SetNMI by ManuLöwe
;
; Usage: SetNMI <Name of Vblank routine>
; Effect: Writes the desired jumping instruction to the RAM location the NMI vector points to. Caveat: NMI has to be disabled before the macro is called!
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO SetNMI
	Accu16

	lda	#\1
	asl	a							; value × 4 (the table consists of 4-byte entries)
	asl	a
	tax
	lda.l	SRC_VblankJumpTable, x					; holds a 4-byte instruction like jml SomeVblankRoutine
	sta	DP_VblankJump						; NMI vector points here
	inx
	inx
	lda.l	SRC_VblankJumpTable, x
	sta	DP_VblankJump+2

	Accu8
.ENDM



; Macro WaitFrames by ManuLöwe
;
; Usage: WaitFrames <number of frames>
; Effect: Waits for the given amount of Vblanks to pass. Works even when NMI is disabled.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO WaitFrames
	ldx	#\1

__FrameDelay\@:

__WaitForVblankStart\@:
	lda	REG_HVBJOY
	bpl	__WaitForVblankStart\@

__WaitForVblankEnd\@:
	lda	REG_HVBJOY
	bmi	__WaitForVblankEnd\@
	dex
	bne	__FrameDelay\@
.ENDM



; Macro WaitUserInput by ManuLöwe
;
; Usage: WaitUserInput
; Effect: Waits for the user to press any button (d-pad is ignored).
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO WaitUserInput
	Accu16

__CheckJoypad\@:
	wai
	lda	Joy1New
	and	#$F0F0							; B, Y, Select, Start (no d-pad), A, X, L, R
	beq	__CheckJoypad\@

	Accu8
.ENDM



; PrintString modified by ManuLöwe: PrintString y, x, "String"

.MACRO PrintString
	ldx	#32*\1 + \2
	stx	Cursor
	jsr	PrintF

	.DB \3, 0							; instead of a return address (-1), the string address (-1) is on the stack
.ENDM



.MACRO SetTextPos
	ldx	#32*\1 + \2
	stx	Cursor
.ENDM



;here's a macro for printing a number (a byte)
;
; ex:  PrintNum $2103 	;print value of reg $2103
;      PrintNum #9	;print 9

.MACRO PrintNum
	lda	\1
	jsr	PrintInt8_noload
.ENDM



.MACRO PrintHexNum
	lda	\1
	jsr	PrintHex8_noload
.ENDM



; Macro PrintSpriteText by ManuLöwe
;
; Usage: PrintSpriteText <y-pos>, <x-pos>, "Lorem ipsum ...", <font color>
; Effect: Prints a sprite-based 8×8 VWF text string (max length: 32 characters). Pos values work as with SetTextPos. Valid font colors are palette numbers 3 (white), 4 (red), 5 (green), 6 (blue), or 7 (yellow).
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO PrintSpriteText
	ldx	#((8*\1)-2)<<8 + 8*\2
	stx	Cursor
	lda	#\4
	sta	SprTextPalette
	ldx	#STR_SpriteText_Start\@
	stx	strPtr
	stz.b	strBank
	stz.b	strBank+1
	lda.b	#:STR_SpriteText_Start\@
	sta.b	strBank+2
	jsr	PrintSpriteText
	bra	STR_SpriteText_End\@

STR_SpriteText_Start\@:
	.DB \3, 0

STR_SpriteText_End\@:

.ENDM



.MACRO PrintSpriteHexNum
	lda	\1
	jsr	PrintSpriteHex8
.ENDM



; ******************************** EOF *********************************
