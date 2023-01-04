;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** GLOBAL MACROS ***
;
;==========================================================================================



; ******************************* Macros *******************************

; A/X/Y register control

.MACRO Accu8
	sep	#kA8
.ENDM



.MACRO Accu16
	rep	#kA8
.ENDM



.MACRO AccuIndex8
	sep	#kAX8
.ENDM



.MACRO AccuIndex16
	rep	#kAX8
.ENDM



.MACRO Index8
	sep	#kX8
.ENDM



.MACRO Index16
	rep	#kX8
.ENDM



; Pseudo-opcode macros

; Macro bsr by Ramsis
;
; Usage: bsr <subroutine>
; Effect: Branch-relative to subroutine (useful for relocatable code).

.MACRO bsr ISOLATED
	per	ReturnAdress\@-1					; push relative return address minus 1 (RTS adds 1) onto stack
	brl	\1							; branch-relative to subroutine

ReturnAdress\@:

.ENDM



.MACRO dea
	dec	a
.ENDM



.MACRO ina
	inc	a
.ENDM



; Macro sev by Ramsis
;
; Usage: sev
; Effect: Set the overflow flag (just because we can).

.MACRO sev
	sep	#$40							; set overflow flag
.ENDM



; SNESGSS/SPC700-related macros

.MACRO SNESGSS_Command							; \1 = kGSS_* (16 bit), \2 = parameter(s) (16 bit)
	Accu16

	lda	#\1							; load command
	sta	<DP2.GSS_command
	lda	#\2							; load parameter
	sta	<DP2.GSS_param

	Accu8

	jsl	spc_command_asm						; send command
.ENDM



.MACRO SPC700_WaitA ISOLATED
	.ACCU 8

	pha								; preserve 8-bit Accu

	Accu16

	lda	LO8.TimeoutCounter
	inc	a
	sta	LO8.TimeoutCounter
	cmp	#kWaitSPC700
	bcc	+

	Accu8

	lda	#kErrorSPC700
	sta	<DP2.ErrorCode
	jml	ErrorHandler

+	Accu8

	pla								; restore  8-bit Accu
.ENDM



.MACRO SPC700_WaitAB ISOLATED
	.ACCU 16

	pha								; preserve 16-bit Accu
	lda	LO8.TimeoutCounter
	inc	a
	sta	LO8.TimeoutCounter
	cmp	#kWaitSPC700
	bcc	+

	Accu8

	lda	#kErrorSPC700
	sta	<DP2.ErrorCode
	jml	ErrorHandler

	.ACCU 16

+	pla								; restore 16-bit Accu
.ENDM



; General/random macros

; Macro DisableIRQs by Ramsis
;
; Usage: DisableIRQs
; Effect: Disables NMI & IRQ.
;
; Expects: A 8 bit

.MACRO DisableIRQs
	sei
	lda	#$00
	sta.l	NMITIMEN						; use 24-bit addressing just in case
	; FIXME add mirror var here?
.ENDM



; DMA macro by Ramsis
;
; Usage: DMA_CH0 mode [8bit], A_bus_src [24bit], B_bus_register [8bit], length [16bit]
; Effect: Transfers data via DMA channel 0.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO DMA_CH0
	lda	#\1							; DMA mode
 	sta	DMAP0
	lda	#lobyte(\3)						; B bus register
	sta	BBAD0
	ldx	#loword(\2)						; source data address
	stx	A1T0L
	lda	#bankbyte(\2)						; source data bank
	sta	A1B0
	ldx	#\4							; transfer length
	stx	DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	MDMAEN
.ENDM



; Macro DrawFrame by Ramsis
;
; Usage: DrawFrame <x start>, <y start>, <width>, <height>
; Effect: Draws a frame using the BG3 text buffer.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO DrawFrame ISOLATED

; Draw upper border
	ldx	#32*\2 + \1
	lda	#$10							; upper left corner
	sta	RAM.BG3Tilemap, x
	lda	#$11							; horizontal line

DrawUpperBorder\@:
	inx
	sta	RAM.BG3Tilemap, x
	cpx	#32*\2 + \1 + \3
	bne	DrawUpperBorder\@

	lda	#$12							; upper right corner
	sta	RAM.BG3Tilemap, x
	bra	GoToNextLine\@



; Draw left & right border
DrawLRBorder\@:
	lda	#$13							; left vertical line
	sta	RAM.BG3Tilemap, x

	Accu16

	txa
	clc
	adc	#\3							; go to right border
	tax

	Accu8

	lda	#$14							; right vertical line
	sta	RAM.BG3Tilemap, x

GoToNextLine\@:
	Accu16

	txa
	clc
	adc	#32 - \3						; go to next line
	tax

	Accu8

	cpx	#32*(\2+\4) + \1
	bne	DrawLRBorder\@



; Draw lower border
	lda	#$15							; lower left corner
	sta	RAM.BG3Tilemap, x
	inx
	lda	#$16							; horizontal line

DrawLowerBorder\@:
	sta	RAM.BG3Tilemap, x
	inx
	cpx	#32*(\2+\4) + \1 + \3
	bne	DrawLowerBorder\@

	lda	#$17							; lower right corner
	sta	RAM.BG3Tilemap, x
.ENDM



; ResetSprites macro by Ramsis
;
; Usage: ResetSprites
; Effect: Initializes sprite data, and stores it in the standard buffer
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO ResetSprites
	jsr	SpriteDataInit						; purge sprite data buffer

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer
.ENDM



; Set Data Bank macro by Ramsis
;
; Usage: SetDBR $XX
; Effect: Sets the Data Bank register to $XX.
;
; Expects: A 8 bit

.MACRO SetDBR
	lda	#\1
	pha
	plb
.ENDM



; Set Direct Page macro by Ramsis
;
; Usage: SetDP $XXXX
; Effect: Sets the Direct Page register to $XXXX.
;
; Expects: A 16 bit

.MACRO SetDP
	lda	#\1
	tcd
.ENDM



; Macro SetIRQ by Ramsis
;
; Usage: SetIRQ <Name of IRQ routine>
; Effect: Writes the desired jumping instruction to the RAM location the IRQ vector points to. Caveat: IRQ has to be disabled when macro is called!
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO SetIRQ
	Accu16

	ldx	#\1
	lda.l	SRC_IRQJumpTable, x					; holds a 4-byte instruction like jml SomeIRQRoutine
	sta.w	P00.JmpIRQ						; IRQ vector points here // caveat: .w or .l operand hints needed as JmpVblank is not in any Direct Page any more (otherwise, it looks to WLA DX like a DP address)
	inx
	inx
	lda.l	SRC_IRQJumpTable, x
	sta.w	P00.JmpIRQ+2

	Accu8
.ENDM



; Macro SetNMI by Ramsis
;
; Usage: SetNMI <Name of Vblank routine>
; Effect: Writes the desired jumping instruction to the RAM location the NMI vector points to. Caveat: NMI has to be disabled when macro is called!
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO SetNMI
	Accu16

	ldx	#\1
	lda.l	SRC_VblankJumpTable, x					; holds a 4-byte instruction like jml SomeVblankRoutine
	sta.w	P00.JmpVblank						; NMI vector points here  // cf. SetIRQ for operand hints
	inx
	inx
	lda.l	SRC_VblankJumpTable, x
	sta.w	P00.JmpVblank+2

	Accu8
.ENDM



; Macro WaitFrames by Ramsis
;
; Usage: WaitFrames <number of frames>
; Effect: Waits for the given amount of Vblanks to pass. Works even when NMI is disabled.
;
; Expects: X/Y 16 bit

.MACRO WaitFrames ISOLATED
	ldx	#\1

NextFrame\@:
-	bit	HVBJOY							; wait for Vblank
	bpl	-

-	bit	HVBJOY							; wait for end of Vblank
	bmi	-

	dex
	bne	NextFrame\@
.ENDM



; Macro WaitUserInput by Ramsis
;
; Usage: WaitUserInput
; Effect: Waits for the user to press any button (d-pad is ignored).
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO WaitUserInput ISOLATED
	Accu16

-	wai
	lda	<DP2.Joy1New
	and	#$F0F0							; B, Y, Select, Start (no d-pad), A, X, L, R
	beq	-

	Accu8
.ENDM



; Dialogue/text box macros

.MACRO FlushVWFTileBuffer2						; expects 16-bit Accu
	.ACCU 16

	ldy	#0
-	lda	LO8.VWF_TileBuffer2, y					; copy font tiles from upper buffer to lower buffer
	sta	LO8.VWF_TileBuffer, y
	iny
	iny
	cpy	#32							; 2 tiles
	bne	-

	lda	#0
-	sta	LO8.VWF_TileBuffer, y					; clear upper buffer (sic, as Y index wasn't reset to zero)
	iny
	iny
	cpy	#64
	bne	-

	stz	<DP2.VWF_BufferIndex					; reset buffer index
.ENDM



.MACRO HexNibbleToTempString ISOLATED					; expects 8-bit Accu
	.ACCU 8

	cmp	#$0A
	bcs	nletter\@
	clc
	adc	#'0'
	sta	LO8.TempString, x					; write current nibble to temp string array
	bra	HexNibbleDone\@

nletter\@:
	clc
	adc	#'A'-10		
	sta	LO8.TempString, x

HexNibbleDone\@:

.ENDM



.MACRO IncDiagTileDataCounter						; expects 16-bit Accu
	.ACCU 16

	lda	<DP2.DiagTileDataCounter				; increment VRAM tile counter by 2 (8×8) tiles
	clc
	adc	#16							; not 32 because of VRAM word addressing
	sta	<DP2.DiagTileDataCounter
.ENDM



; Text string macros

.MACRO PrintBinary ISOLATED
	.ACCU 8

	ldx	#8							; 8 bits to print

PrintBinLoop\@:
	phx								; preserve bit counter
	asl	\1							; put highest bit into carry
	bcs	+

	lda	#0							; carry was clear --> print "0"
	jsr	PrintInt8

	bra	++ ;BitDone\@:

+	lda	#1							; carry was set --> print "1"
	jsr	PrintInt8

;BitDone\@:
++	plx								; restore bit counter
	dex
	bne	PrintBinLoop\@
.ENDM



.MACRO PrintHexNum
	lda	\1
	jsr	PrintHex8
.ENDM



.MACRO PrintNum
	lda	\1
	jsr	PrintInt8
.ENDM



.MACRO PrintSpriteHexNum
	lda	\1
	jsr	PrintSpriteHex8
.ENDM



; Macro PrintSpriteText by Ramsis
;
; Usage: PrintSpriteText <y-pos>, <x-pos>, "Lorem ipsum ...", <font color>
; Effect: Prints a sprite-based 8×8 VWF text string (max length: 32 characters). Pos values work as with SetTextPos. Valid font colors are palette numbers 3 (white), 4 (red), 5 (green), 6 (blue), or 7 (yellow).
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO PrintSpriteText ISOLATED
	ldx	#((8*\1-2)<<8) + 8*\2
	stx	<DP2.TextCursor
	lda	#\4
	sta	<DP2.SpriteTextPalette
	ldx	#STR_SpriteText_Start\@
	stx	<DP2.TextStringPtr
	lda	#:STR_SpriteText_Start\@
	sta	<DP2.TextStringBank
	jsr	PrintSpriteText

	bra	STR_SpriteText_End\@

STR_SpriteText_Start\@:
	.STRINGMAP HUD, \3
	.DB 0

STR_SpriteText_End\@:

.ENDM



.MACRO PrintString ISOLATED						; modified by Ramsis: PrintString y, x, kTextBuffer*, "String"
	ldx	#32*\1 + \2
	stx	<DP2.TextCursor
	stz	<DP2.HiResPrintMon					; reset BG monitor value
	ldx	#\3
	stx	LO8.Routine_FillTextBuffer
	stz	<DP2.TextStringPtr
	stz	<DP2.TextStringPtr+1
	lda	#:STR_Start\@
	sta	<DP2.TextStringBank
	jsl	PrintF

STR_Start\@:
	.DB \4, 0							; instead of a return address (-1), the string address (-1) is on the stack
.ENDM



.MACRO SetTextPos
	ldx	#32*\1 + \2
	stx	<DP2.TextCursor
	stz	<DP2.HiResPrintMon					; reset BG monitor value
.ENDM

; ******************************** EOF *********************************
