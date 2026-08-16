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



.MACRO shl ARGS Parameter

.IF NARGS == 0

	asl	a

.ELSE

.REPEAT Parameter
	asl	a
.ENDR

.ENDIF

.ENDM



.MACRO shr ARGS Parameter

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



; ar_name
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: maps area name string with appropriate string label
; Implemented Language: see .ENUMID with Language constants
;
; Examples:
;	ar_name kLangENG, "Here<END>"					; create English dialogue string label and map area name

.MACRO ar_name ARGS Language, String

.IF NARGS != 2

.FAIL "The '\.' macro takes exactly two arguments."

.ELIF Language == kLangENG

STR_AreaNameENG{%.3d{COUNT}}:						; create label for current English area name
	.DB String.length_utf8-5					; write string length, remove "<END>"
	.STRINGMAP HUD, String

	incr	&COUNT							; increment string number for next label

.ELIF Language == kLangDEU

STR_AreaNameDEU{%.3d{COUNT}}:						; create label for current German area name
	.DB String.length_utf8-5					; write string length, remove "<END>"
	.STRINGMAP HUD, String

	incr	&COUNT							; increment string number for next label

.ENDIF

	rtl								; rtl from PrintSpriteText ends up here, return to caller
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



; d_init
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: initializes dialogue string with label
; Implemented Language: see .ENUMID with Language constants
;
; Examples:
;	d_init kLangENG, kPortrait_NONE, kBG_Blue			; create English dialogue string label, init text box with no portrait and blue background

.MACRO d_init ARGS Language, Portrait, Background ;, Speed

.IF NARGS != 3

.FAIL "The '\.' macro takes exactly three arguments."

.ELIF Language == kLangENG

STR_DialogueENG{%.4d{COUNT}}:						; create label for current English dialogue string

.ELIF Language == kLangDEU

STR_DialogueDEU{%.4d{COUNT}}:						; create label for current German dialogue string

;.ELIF Language == (add more as needed)

.ENDIF

	.STRINGMAP dialogue, "<PORTRAIT>"				; set portrait and background
	.DW Portrait|$8000						; also set "change portrait" bit
	.STRINGMAP dialogue, "<BG>"
	.DB Background|$80						; also set "change background" bit

	incr	&COUNT							; increment string number for next label
.ENDM



; d_string
; --------------------------------------------------------------------------------------------------
;
; Author: Ramsis
; Usage: see examples
; Effect: maps dialogue string, optionally with (new) portrait and/or text box background
;
; Examples:
;	d_string kPortrait_NONE, kBG_Blue, "Hello!"			; remove portrait, set blue background, map dialogue string
;	d_string kBG_Blue, "Hello!"					; set blue background and map dialogue string
;	d_string "Goodbye!"						; only map dialogue string

.MACRO d_string ARGS Portrait, Background, String

.IF NARGS == 0

.FAIL "The '\.' macro takes at least a string as an argument."

.ELIF \?1 == ARG_STRING

	.STRINGMAP dialogue, \1						; if only string given as argument, map string

.ELIF NARGS == 2

	.STRINGMAP dialogue, "<BG>"					; set background, map string
	.DB \1|$80							; 1st argument = background (also set "change portrait" bit)
	.STRINGMAP dialogue, \2						; 2nd argument = string

.ELSE

	.STRINGMAP dialogue, "<PORTRAIT>"				; set portrait and background, map string
	.DW Portrait|$8000						; also set "change portrait" bit
	.STRINGMAP dialogue, "<BG>"
	.DB Background|$80						; also set "change background" bit
	.STRINGMAP dialogue, String

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
; Effect: sets specified Target (e.g. a hardware register, but could be anything implemented here) to given parameter
; Implemented Target(s): see .ELIF statements below
;
; Examples:
;	set	"Data_Bank", $00					; set DBR $00
;	set	"Direct_Page", $0200					; set DP $0200
;	set	"VRAM_Tiles", kAddrBG1, kAddrBG2, kAddrBG3, kAddrBG4	; set RAM mirror registers as desired

.MACRO set ISOLATED ARGS Target, Param1, Param2, Param3, Param4, Param5, Param6, Param7, Param8

.IF NARGS == 0

.FAIL "The '\.' macro takes at least one argument."

.ELIF Target == "Data_Bank"

	lda	#Param1
	pha
	plb

.ELIF Target == "Direct_Page"

	lda	#Param1
	tcd

.ELIF Target == "IRQ"

	ldx	#Param1
	stx	LO8.JumpIRQ

.ELIF Target == "NMI"

	ldx	#Param1
	stx	LO8.JumpNMI

.ELIF Target == "Stack_Pointer"

	lda	#Param1
	tcs

.ELIF Target == "VRAM_tilemaps"

; VRAM addresses in 1K-word steps, screen size: %00=32×32, %01=64×32, %10=32×64, %11=64×64)
	lda	#hibyte(Param1) | Param2					; VRAM address for BG1 tilemap | screen size
	sta	RAM_BG1SC
	lda	#hibyte(Param3) | Param4					; VRAM address for BG2 tilemap | screen size
	sta	RAM_BG2SC
	lda	#hibyte(Param5) | Param6					; VRAM address for BG3 tilemap | screen size
	sta	RAM_BG3SC
	lda	#hibyte(Param7) | Param8					; VRAM address for BG4 tilemap | screen size
	sta	RAM_BG4SC

.ELIF Target == "VRAM_tiles"

; VRAM addresses in 4K-word steps
	lda	#hibyte(Param1)>>4 | hibyte(Param2)				; VRAM address for BG1/BG2 character data
	sta	RAM_BG12NBA
	lda	#hibyte(Param3)>>4 | hibyte(Param4)				; VRAM address for BG3/BG4 character data
	sta	RAM_BG34NBA

.ELIF Target == "WRAM_port"

	lda	#lobyte(Param1)
	sta	WMADDL
	lda	#hibyte(Param1)
	sta	WMADDM
;	ldx	#loword(Param1)
;	stx	WMADDL
	lda	#bankbyte(Param1)
	and	#%00000001							; only keep bank bit
	sta	WMADDH

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

	lda	\1
	ldx	#8							; 8 bits to print

PrintBinLoop\@:
	phx								; preserve bit counter
	shl								; put highest bit into carry
	pha								; preserve value for next iteration
	bcs	+

	lda	#0							; carry clear --> print "0"
	bra	PrintBit\@

+	lda	#1							; carry set --> print "1"

PrintBit\@:
	jsl	PrintInt8

	pla								; restore value to print
	plx								; restore bit counter
	dex
	bne	PrintBinLoop\@
.ENDM



.MACRO PrintHexNum
	lda	\1
	jsl	PrintHex8
.ENDM



.MACRO PrintNum
	lda	\1
	jsl	PrintInt8
.ENDM



.MACRO PrintSpriteHexNum
	lda	\1
	jsl	PrintSpriteHex8
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
	stz	<DP2.TextStringPtr
	stz	<DP2.TextStringPtr+1
	lda	#:STR_Sprite_Start\@
	sta	<DP2.TextStringBank
	jsl	PrintSpriteText

STR_Sprite_Start\@:							; string start address (minus one) is on the stack
	.STRINGMAP HUD, \3
	.DB $00

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

STR_Start\@:								; string start address (minus one) is on the stack
	.DB \4, $00
.ENDM



.MACRO SetTextPos
	ldx	#(32*\1 + \2) * 2
	stx	<DP2.TextCursor
	stz	<DP2.HiResPrintMon					; reset BG monitor value
.ENDM



; SNESGSS/SPC700 MACROS
; --------------------------------------------------------------------------------------------------

.MACRO GSS_cmd ARGS Command, Parameter					; Command = kGSS_* (16 bit), Parameter = either #<immediate> or <variable> (16 bit)
	Accu16

	lda	#Command
	sta	<DP2.GSS_command

.IF \?2 == ARG_IMMEDIATE

	lda	#Parameter

.ELIF \?2 == ARG_NUMBER							; "number" here includes variable names as well, ARG_LABEL recognizes code labels only

	lda	Parameter

.ENDIF

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
