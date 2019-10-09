;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
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
; Macro bsr by Ramsis
;
; Usage: bsr <subroutine>
; Effect: Branch-relative to subroutine (useful for relocatable code).

.MACRO bsr
	per	@ReturnAdress\@ - 1					; push relative return address minus 1 (RTS adds 1) onto stack
	brl	\1							; branch-relative to subroutine

@ReturnAdress\@:

.ENDM



; Macro sev by Ramsis
;
; Usage: sev
; Effect: Set the overflow flag (just because we can).

.MACRO sev
	sep	#$40							; set overflow flag
.ENDM



; -------------------------- general/random macros
.MACRO CheckErrorSPC700a
	pha								; preserve 8-bit Accu

	Accu16

	lda	VAR_TimeoutCounter
	inc	a
	sta	VAR_TimeoutCounter
	cmp	#PARAM_ErrWaitSPC700
	bcc	@Continue\@

	Accu8

	lda	#ERR_SPC700
	jml	ErrorHandler

@Continue\@:
	Accu8

	pla								; restore  8-bit Accu
.ENDM



.MACRO CheckErrorSPC700ab
	pha								; preserve 16-bit Accu
	lda	VAR_TimeoutCounter
	inc	a
	sta	VAR_TimeoutCounter
	cmp	#PARAM_ErrWaitSPC700
	bcc	@Continue\@

	Accu8

	lda	#ERR_SPC700
	jml	ErrorHandler

@Continue\@:
	pla								; restore  16-bit Accu
.ENDM



; Macro DisableIRQs by Ramsis
;
; Usage: DisableIRQs
; Effect: Disables NMI & IRQ.
;
; Expects: A 8 bit

.MACRO DisableIRQs
	sei
	lda	#$00							; reminder: stz doesn't support 24-bit addressing
	sta.l	REG_NMITIMEN
.ENDM



; DMA macro by Ramsis
;
; Usage: DMA_CH0 mode[8bit], A_bus_bank[8bit], A_bus_src[16bit], B_bus_register[8bit], length[16bit]
; Effect: Transfers data via DMA channel 0.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO DMA_CH0
	lda	#\1							; DMA mode (8 bit)
 	sta	REG_DMAP0
	lda	#\4							; B bus register (8 bit)
	sta	REG_BBAD0
	ldx	#(\3 & $FFFF)						; get low word of data offset (16 bit)
	stx	REG_A1T0L
	lda	#\2							; data bank (8 bit)
	sta	REG_A1B0
	ldx	#\5							; data length (16 bit)
	stx	REG_DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN
.ENDM



; Macro DrawFrame by Ramsis
;
; Usage: DrawFrame <x start>, <y start>, <width>, <height>
; Effect: Draws a frame using the BG3 text buffer.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO DrawFrame

; -------------------------- draw upper border
	ldx	#32*\2 + \1
	lda	#$10							; upper left corner
	sta	ARRAY_BG3TileMap, x
	lda	#$11							; horizontal line

__DrawUpperBorder\@:
	inx
	sta	ARRAY_BG3TileMap, x
	cpx	#32*\2 + \1 + \3
	bne	__DrawUpperBorder\@

	lda	#$12							; upper right corner
	sta	ARRAY_BG3TileMap, x
	bra	__GoToNextLine\@



; -------------------------- draw left & right border
__DrawLRBorder\@:
	lda	#$13							; left vertical line
	sta	ARRAY_BG3TileMap, x

	Accu16

	txa
	clc
	adc	#\3							; go to right border
	tax

	Accu8

	lda	#$14							; right vertical line
	sta	ARRAY_BG3TileMap, x

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
	sta	ARRAY_BG3TileMap, x
	inx
	lda	#$16							; horizontal line

__DrawLowerBorder\@:
	sta	ARRAY_BG3TileMap, x
	inx
	cpx	#32*(\2+\4) + \1 + \3
	bne	__DrawLowerBorder\@

	lda	#$17							; lower right corner
	sta	ARRAY_BG3TileMap, x
.ENDM



; Freeze macro by Ramsis
;
; Usage: Freeze
; Effect: CPU enters trap loop (useful e.g. for debugging)
;
; Expects: nothing

.MACRO Freeze

@Freeze\@:
	bra	@Freeze\@
.ENDM



.MACRO JoyInit								; based on a subroutine by Neviksti. Expects A = 8 bit and XY = 16 bit
	lda	#$C0							; have the automatic read of the SNES read the first pair of JoyPads
	sta	REG_WRIO
	ldx	#$0000
	stx	DP_Joy1Press
	stx	DP_Joy2Press
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81
	sta	REG_NMITIMEN						; enable JoyPad Read and NMI
	cli								; enable interrupts
	wai								; wait for NMI to fill the variables with real JoyPad data
.ENDM



; ResetSprites macro by Ramsis
;
; Usage: ResetSprites
; Effect: Initializes sprite data, and stores it in the standard buffer
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO ResetSprites
	jsr	SpriteDataInit						; purge sprite data buffer

	ldx	#ARRAY_SpriteDataArea & $FFFF				; set WRAM address for area sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
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
; Usage: SetDPag $XXXX
; Effect: Sets the Direct Page register to $XXXX.
;
; Expects: A 16 bit

.MACRO SetDPag
	lda	#\1
	tcd
.ENDM



; Macro SetIRQ by Ramsis
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
	lda.l	SRC_IRQJumpTable, x					; holds a 4-byte instruction like jml SomeIRQRoutine
	sta	TWO_JumpIRQ						; IRQ vector points here
	inx
	inx
	lda.l	SRC_IRQJumpTable, x
	sta	TWO_JumpIRQ+2

	Accu8
.ENDM



; Macro SetNMI by Ramsis
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
	sta	ONE_JumpVblank						; NMI vector points here
	inx
	inx
	lda.l	SRC_VblankJumpTable, x
	sta	ONE_JumpVblank+2

	Accu8
.ENDM



; Macro WaitFrames by Ramsis
;
; Usage: WaitFrames <number of frames>
; Effect: Waits for the given amount of Vblanks to pass. Works even when NMI is disabled.
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO WaitFrames
	ldx	#\1

@FrameDelay\@:

@WaitForVblankStart\@:
	lda	REG_HVBJOY
	bpl	@WaitForVblankStart\@

@WaitForVblankEnd\@:
	lda	REG_HVBJOY
	bmi	@WaitForVblankEnd\@
	dex
	bne	@FrameDelay\@
.ENDM



; Macro WaitUserInput by Ramsis
;
; Usage: WaitUserInput
; Effect: Waits for the user to press any button (d-pad is ignored).
;
; Expects: A 8 bit, X/Y 16 bit

.MACRO WaitUserInput
	Accu16

@CheckJoypad\@:
	wai
	lda	DP_Joy1New
	and	#$F0F0							; B, Y, Select, Start (no d-pad), A, X, L, R
	beq	@CheckJoypad\@

	Accu8
.ENDM



; -------------------------- dialogue/text box macros
.MACRO HexNibbleToTempString						; expects 8-bit Accu
	cmp	#$0A
	bcs	@nletter\@
	clc
	adc	#'0'
	sta	ARRAY_TempString, x					; write current nibble to temp string array
	bra	@HexNibbleDone\@

@nletter\@:
	clc
	adc	#'A'-10		
	sta	ARRAY_TempString, x

@HexNibbleDone\@:

.ENDM



.MACRO IncDiagTileDataCounter						; expects 16-bit Accu
	lda	DP_DiagTileDataCounter					; increment VRAM tile counter by 2 (8×8) tiles
	clc
	adc	#16							; not 32 because of VRAM word addressing
	sta	DP_DiagTileDataCounter
.ENDM



; -------------------------- text string macros
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

.MACRO PrintSpriteText
	ldx	#(8*\1-2)<<8 + 8*\2
	stx	DP_TextCursor
	lda	#\4
	sta	DP_SpriteTextPalette
	ldx	#@STR_SpriteText_Start\@
	stx	DP_TextStringPtr
	lda	#:@STR_SpriteText_Start\@
	sta	DP_TextStringBank
	jsr	PrintSpriteText

	bra	@STR_SpriteText_End\@

@STR_SpriteText_Start\@:
	.DB \3, 0

@STR_SpriteText_End\@:

.ENDM



.MACRO PrintString							; modified by Ramsis: PrintString y, x, "String"
	stz	DP_TextStringPtr
	stz	DP_TextStringPtr+1
	lda	#:@StringOffset\@
	sta	DP_TextStringBank
	ldx	#32*\1 + \2
	stx	DP_TextCursor
	jsr	PrintF

@StringOffset\@:
	.DB \3, 0							; instead of a return address (-1), the string address (-1) is on the stack
.ENDM



.MACRO SetTextPos
	ldx	#32*\1 + \2
	stx	DP_TextCursor
	stz	DP_HiResPrintMon					; reset BG monitor value
.ENDM

; ******************************** EOF *********************************
