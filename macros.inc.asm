; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	GLOBAL MACROS
;
; ==================================================================================================



; ACCUMULATOR/INDEX REGISTER CONTROL
; --------------------------------------------------------------------------------------------------

.MACRO Accu8
	sep	#kA8
.ENDM



.MACRO Accu16
	rep	#kA8
.ENDM



.MACRO AccuIndex8
	sep	#kAI8
.ENDM



.MACRO AccuIndex16
	rep	#kAI8
.ENDM



.MACRO Index8
	sep	#kI8
.ENDM



.MACRO Index16
	rep	#kI8
.ENDM



; PSEUDO-OPCODES
; --------------------------------------------------------------------------------------------------

.MACRO bsr ISOLATED ARGS Label

.IF NARGS != 1

.FAIL "The '\.' macro takes exactly one argument."

.ENDIF

	per	ReturnAdress\@-1					; push relative return address minus 1 (RTS adds 1) onto stack
	brl	Label							; branch-relative to subroutine

ReturnAdress\@:

.ENDM



.MACRO dea
	dec	a
.ENDM



.MACRO ina
	inc	a
.ENDM



.MACRO lsh ARGS Parameter

.IF NARGS == 0

	asl	a

.ELSE

.REPEAT Parameter
	asl	a
.ENDR

.ENDIF

.ENDM



.MACRO rsh ARGS Parameter

.IF NARGS == 0

	lsr	a

.ELSE

.REPEAT Parameter
	lsr	a
.ENDR

.ENDIF

.ENDM



.MACRO sev
	sep	#$40							; set overflow flag
.ENDM



; GENERAL/RANDOM MACROS
; --------------------------------------------------------------------------------------------------

; (template for new macro)
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: sets specified XYZ
; Implemented XYZ: ABC, DEF
;
; Examples:
;	template	"", $00					; 
;	template	"", $0000					; 

.MACRO template ISOLATED ARGS XYZ, ...

.IF NARGS == 0

.FAIL "The '\.' macro takes at least one argument."

.ELIF XYZ == ""

.ELIF XYZ == ""

.ELSE

.FAIL "Unknown '\.' macro argument."

.ENDIF

.ENDM



; decr
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis (based on the WLA DX documentation by Ville Helin)
; Usage: decr &<definition>
; Effect: decrements .DEFINEd number

.MACRO decr ARGS Definition

.IF NARGS != 1 | \?1 != ARG_LABEL

.FAIL "The '\.' macro takes a .DEFINEd number as an argument."

.ENDIF

.REDEFINE \1 = ?1 - 1
;.REDEFINE Definition = ?Definition - 1					; no work :-(

.ENDM



; dma_0
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: transfers data via DMA channel 0
; Expects: A 8 bit, X/Y 16 bit
;
; Examples:
;	dma_0	$09, SRC_0000, VMDATAL, 0

.MACRO dma_0 ARGS DMA_Mode, SourceAddress, B_Register, DMA_Length

.IF NARGS != 4

.FAIL "The '\.' macro takes exactly four arguments."

.ENDIF

	lda	#DMA_Mode
 	sta	DMAP0
	lda	#lobyte(B_Register)
	sta	BBAD0
	ldx	#loword(SourceAddress)
	stx	A1T0L
	lda	#bankbyte(SourceAddress)
	sta	A1B0
	ldx	#DMA_Length
	stx	DAS0L
	lda	#kDMA_Channel0						; initiate DMA transfer
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
	ldx	#(32*\2 + \1) * 2
	lda	#$10							; upper left corner
	sta	RAM.BG3Tilemap, x
	lda	#$11							; horizontal line

DrawUpperBorder\@:
	inx
	inx
	sta	RAM.BG3Tilemap, x
	cpx	#(32*\2 + \1 + \3) * 2
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
	adc	#\3 * 2							; go to right border
	tax

	Accu8

	lda	#$14							; right vertical line
	sta	RAM.BG3Tilemap, x

GoToNextLine\@:
	Accu16

	txa
	clc
	adc	#(32 - \3) * 2						; go to next line
	tax

	Accu8

	cpx	#(32*(\2+\4) + \1) * 2
	bne	DrawLRBorder\@



; Draw lower border
	lda	#$15							; lower left corner
	sta	RAM.BG3Tilemap, x
	inx
	inx
	lda	#$16							; horizontal line

DrawLowerBorder\@:
	sta	RAM.BG3Tilemap, x
	inx
	inx
	cpx	#(32*(\2+\4) + \1 + \3) * 2
	bne	DrawLowerBorder\@

	lda	#$17							; lower right corner
	sta	RAM.BG3Tilemap, x
.ENDM



.MACRO ev_ctrl ARGS EventControlCode

.IF NARGS != 1

.FAIL "The '\.' macro takes exactly one argument."

.ENDIF

	.DB EventControlCode

.ENDM



; d_string
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: maps dialogue string, optionally with appropriate string label
; Implemented Language: see .ENUMID with Language constants
;
; Examples:
;	d_string kLangENG, "Hello!"					; create English dialogue string label and map dialogue string
;	d_string "Goodbye!"						; only map dialogue string

.MACRO d_string ARGS Language, String

.IF NARGS == 0

.FAIL "The '\.' macro takes at least a string as an argument."

.ELIF \?1 == ARG_STRING

	.STRINGMAP dialogue, \1						; if only string given as argument, map string without a label

.ELIF Language == kLangENG

STR_DialogueENG{%.4d{COUNT}}:						; create label for current English dialogue string
	.STRINGMAP dialogue, String

	incr	&COUNT							; increment string number for next label

.ELIF Language == kLangDEU

STR_DialogueDEU{%.4d{COUNT}}:						; create label for current German dialogue string
	.STRINGMAP dialogue, String

	incr	&COUNT							; increment string number for next label

.ENDIF

.ENDM



; incr
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis (based on the WLA DX documentation by Ville Helin)
; Usage: incr &<definition>
; Effect: increments .DEFINEd number

.MACRO incr ARGS Definition

.IF NARGS != 1 | \?1 != ARG_LABEL

.FAIL "The '\.' macro takes a .DEFINEd number as an argument."

.ENDIF

.REDEFINE \1 = ?1 + 1
;.REDEFINE Definition = ?Definition + 1					; no work :-(

.ENDM



; set
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: sets specified Target (e.g. a hardware register, but could be anything implemented here) to given Parameter
; Implemented Target: Data_Bank, Direct_Page
;
; Examples:
;	set	"Data_Bank", $00					; set DBR $00
;	set	"Direct_Page", $0200					; set DP $0200

.MACRO set ISOLATED ARGS Target, Parameter

.IF NARGS == 0

.FAIL "The '\.' macro takes at least one argument."

.ELIF Target == "Data_Bank"

	lda	#Parameter
	pha
	plb

.ELIF Target == "Direct_Page"

	lda	#Parameter
	tcd

.ELIF Target == "IRQ"

	ldx	#Parameter
	stx	LO8.JumpIRQ

.ELIF Target == "NMI"

	ldx	#Parameter
	stx	LO8.JumpNMI

.ELIF Target == "Stack_Pointer"

	lda	#Parameter
	tcs

.ELSE

.FAIL "Unknown '\.' macro argument."

.ENDIF

.ENDM



; wait
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: waits for specified EventType
; Implemented EventType: frames, user_input, Vblank, Vblank_end
;
; Examples:
;	wait	"frames", 20						; wait for 20 frames to pass
;	wait	"user_input", $F0F0					; wait for player to press any button
;	wait	"Vblank"						; wait for Vblank flag to get set

.MACRO wait ISOLATED ARGS EventType, Parameter

.IF NARGS == 0

.FAIL "The '\.' macro takes at least one argument."

.ELIF EventType == "frames"

	ldx	#\2

NextFrame\@:
-	bit	HVBJOY							; wait for Vblank
	bpl	-

-	bit	HVBJOY							; wait for end of Vblank
	bmi	-

;	wait	"Vblank"						; don't call this macro recursively, as that messes up WLA's label stack (FIX_REFERENCES: Reference to an unknown label "NextFrame2".)
;	wait	"Vblank_end"

	dex
	bne	NextFrame\@

.ELIF EventType == "MSU_ready"

-	bit	MSU_STATUS						; wait for Audio Busy bit to clear
	bvs	-

.ELIF EventType == "user_input"

	Accu16

-	wai
	lda	<DP2.Joy1New
	and	#$F0F0							; B, Y, Select, Start (no d-pad), A, X, L, R
	beq	-

	Accu8

.ELIF EventType == "Vblank"

-	bit	HVBJOY							; wait for Vblank
	bpl	-

.ELIF EventType == "Vblank_end"

-	bit	HVBJOY							; wait for end of Vblank
	bmi	-

.ELSE

.FAIL "Unknown '\.' macro argument."

.ENDIF

.ENDM



; OTHER DIALOGUE/TEXT BOX/STRING MACROS
; --------------------------------------------------------------------------------------------------

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
	ldx	#(32*\1 + \2) * 2
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
	ldx	#(32*\1 + \2) * 2
	stx	<DP2.TextCursor
	stz	<DP2.HiResPrintMon					; reset BG monitor value
.ENDM



; SNESGSS/SPC700 MACROS
; --------------------------------------------------------------------------------------------------

.MACRO SNESGSS_Command ARGS Command, Parameter				; \1 = kGSS_* (16 bit), \2 = parameter(s) (16 bit)
	Accu16

	lda	#Command
	sta	<DP2.GSS_command
	lda	#Parameter
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
	brk	kErrorSPC700

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
	brk	kErrorSPC700

+	pla								; restore 16-bit Accu
.ENDM



; EOF
