; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	TEXT ENGINE
;
; ==================================================================================================



; DIALOGUE TEST SECTION
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

DialogueTest:
	lda	#kForcedBlank
	sta	RAM_INIDISP

	jsr	ResetSprites

	wai
	jsl	DisableInterrupts

;.IFNDEF NOMUSIC

;	jsl	music_stop						; stop music in case it's playing

;	stz	MSU_CONTROL						; stop MSU1 track in case it's playing
;	stz	MSU_VOLUME

;.ENDIF

	stz	<DP2.HDMA_Channels					; disable HDMA
	stz	HDMAEN

	set	"WRAM_port", RAM.BG3Tilemap				; clear BG3 text
	dma_0	$08, SRC_0000, WMDATA, _sizeof_RAM.BG3Tilemap

;	jsr	SetBG3TilesPriority					; not needed for now

	set	"WRAM_port", RAM.HDMA_BG_Playfield			; clear HDMA table in case it was used before
	dma_0	$08, SRC_0000, WMDATA, _sizeof_RAM.HDMA_BG_Playfield

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	jsr	LoadTextBoxBorderTiles					; prepare text box
	jsr	MakeTextBoxTilemapBG1
	jsr	MakeTextBoxTilemapBG2

; Make text box background black in case it was used in area before (otherwise, the previous BG
; gradient will be briefly visible)
	set	"WRAM_port", RAM.HDMA_BG_TextBox
	dma_0	$08, SRC_0000, WMDATA, _sizeof_RAM.HDMA_BG_TextBox

; Reload BG scrolling HDMA table (aka restore known values)
	set	"WRAM_port", LO8.HDMA_BG_Scroll
	dma_0	$00, SRC_HDMA_BG_Scroll, WMDATA, _sizeof_SRC_HDMA_BG_Scroll



; HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> COLDATA register)
	sta	DMAP3
	lda	#<COLDATA
	sta	BBAD3
	ldx	#loword(RAM.HDMA_ColorMath)
	stx	A1T3L
	lda	#bankbyte(RAM.HDMA_ColorMath)				; table in WRAM expected
	sta	A1B3



; HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> BG1HOFS, 2 bytes --> BG1VOFS)
	sta	DMAP4
	lda	#<BG1HOFS
	sta	BBAD4
	ldx	#LO8.HDMA_BG_Scroll
	stx	A1T4L
	lda	#$7E
	sta	A1B4



; HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> BG2HOFS, 2 bytes --> BG2VOFS)
	sta	DMAP5
	lda	#<BG2HOFS
	sta	BBAD5
	ldx	#LO8.HDMA_BG_Scroll
	stx	A1T5L
	lda	#$7E
	sta	A1B5



; Set up RAM mirror registers
	lda	#kBGMODE_1|kBG3priority
	sta	RAM_BGMODE
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	RAM_OBSEL

	set	"VRAM_tiles", kVRAM_BG1_Tiles, kVRAM_BG2_Tiles, kVRAM_BG3_Tiles, $00
	set	"VRAM_tilemaps", kVRAM_BG1_Tilemap1, $00, kVRAM_BG2_Tilemap1, $00, kVRAM_BG3_Tilemap1, $00, $00, $00



; Misc. settings
	lda	#kTM_BG3|kTM_OBJ					; turn on BG3 + sprites on mainscreen only (this only affects the upper, non-text box portion of the screen)
	sta	RAM_TM
	lda	#$00
	sta	RAM_TS

	lda	#%00110000						; enable HDMA ch. 4, 5 (BG1/2 scrolling)
	sta	<DP2.HDMA_Channels

	set	"NMI", Vblank_Area					; use area NMI handler

	Accu16

	lda	#228		;FIXME readjust				; dot number for interrupt (256 = too late, 204 = too early)
	sta	HTIMEL
	lda	#kTextBoxVIRQScanlineMax				; scanline number for interrupt
	sta	VTIMEL

	Accu8

	sta	<DP2.TextBoxVIRQ					; save scanline no.

	set	"IRQ", VIRQ_Area					; use area IRQ handler

	jsl	ReenableNMI

	PrintString	2, 2, kTextBG3, "DIALOGUE TEST"			; print some on-screen help
	PrintString	4, 2, kTextBG3, "Dpad r/l: next/prev string"
	PrintString	5, 12, kTextBG3, "(hold Y for speed)"
	PrintString	6, 2, kTextBG3, "Dpad up/dn: change language"
	PrintString	7, 2, kTextBG3, "R/L: +/-50 strings"
	PrintString	8, 2, kTextBG3, "A: cont./make selection"

	lda	#kBG1Tilemap1|kBG2Tilemap1|kBG3Tilemap			; update BG1/2/3 tilemaps
	tsb	<DP2.DMA_Updates

	wait	"frames", 4						; give some time for screen refresh

	lda	#kINIDISP_15						; turn screen back on
	sta	RAM_INIDISP
	jsr	InitTextBox						; initialize text box

@DialogueTestLoop:
	PrintString	10, 2, kTextBG3, "GameLanguage  = $"		; print some text-box-related variables
	PrintHexNum	<DP2.GameLanguage

	PrintString	11, 2, kTextBG3, "TextPointerNo = $"
	PrintHexNum	<DP2.TextPointerNo+1
	PrintHexNum	<DP2.TextPointerNo

	PrintString	12, 2, kTextBG3, "TextBoxSelection = %%"
	PrintBinary	<DP2.TextBoxSelection

	lda	#kBG3Tilemap						; update BG3 tilemap
	tsb	<DP2.DMA_Updates

	wait	"frames", 1

	lda	LO8.NMITIMEN						; copy interrupt variable to register
	sta	NMITIMEN

	bit	<DP2.TextBoxStatus					; check if text box is active (MSB set)
	bpl	@NoTextBox
	jsr	ProcDialogTextBox

@NoTextBox:



; Check for dpad up = next language
	lda	<DP2.Joy1New+1
	and	#kDpadUp
	beq	@DpadUpDone
	lda	<DP2.TextBoxSelection
	and	#$0F
	bne	@DpadUpDone
	lda	#kLangDEU
	sta	<DP2.GameLanguage
	jsr	InitTextBox@NextDialogue

@DpadUpDone:



; Check for dpad down = previous language
	lda	<DP2.Joy1New+1
	and	#kDpadDown
	beq	@DpadDownDone
	lda	<DP2.TextBoxSelection
	and	#$0F
	bne	@DpadUpDone
	lda	#kLangENG
	sta	<DP2.GameLanguage
	jsr	InitTextBox@NextDialogue

@DpadDownDone:



; Check for Y + dpad right = fast forward text pointers
	lda	<DP2.Joy1Press+1					; Y pressed, check for dpad right
	and	#kButtonY|kDpadRight
	cmp	#kButtonY|kDpadRight
	beq	@NextTextPointer



; Check for Y + dpad left = fast rewind text pointers
	lda	<DP2.Joy1Press+1					; Y pressed, check for dpad left
	and	#kButtonY|kDpadLeft
	cmp	#kButtonY|kDpadLeft
	beq	@PrevTextPointer



; Check for dpad left = previous text pointer
	lda	<DP2.Joy1New+1
	and	#kDpadLeft
	beq	@DpadLeftDone

@PrevTextPointer:
	Accu16

	lda	<DP2.TextPointerNo					; decrement text pointer
	sec
	sbc	#1
	bpl	+
	lda	#0
+	sta	<DP2.TextPointerNo

	Accu8

	jsr	InitTextBox@NextDialogue

@DpadLeftDone:



; Check for dpad right = next text pointer
	lda	<DP2.Joy1New+1
	and	#kDpadRight
	beq	@DpadRightDone

@NextTextPointer:
	Accu16

	lda	<DP2.TextPointerNo					; increment text pointer
	clc
	adc	#1
	cmp	#_sizeof_SRC_DialoguePointerTableENG/2
	bcc	+
	lda	#_sizeof_SRC_DialoguePointerTableENG/2-1
+	sta	<DP2.TextPointerNo

	Accu8

	jsr	InitTextBox@NextDialogue

@DpadRightDone:



; Check for A button
	bit	<DP2.Joy1New
	bpl	@AButtonDone
	bit	<DP2.TextBoxStatus					; check if text box is active (MSB set)
	bmi	@AButtonDone
	jsr	InitTextBox@NextDialogue

@AButtonDone:



; Check for L button = text pointers -= 50
	lda	<DP2.Joy1New
	and	#kButtonL
	beq	@LButtonDone

	Accu16

	lda	<DP2.TextPointerNo					; decrement text pointer
	cmp	#50
	bcs	+
	lda	#0
	bra	++
+;	sec								; never mind, carry is already set
	sbc	#50
++	sta	<DP2.TextPointerNo

	Accu8

	jsr	InitTextBox@NextDialogue

@LButtonDone:



; Check for R button = text pointers += 50
	lda	<DP2.Joy1New
	and	#kButtonR
	beq	@RButtonDone

	Accu16

	lda	<DP2.TextPointerNo					; increment text pointer
	cmp	#_sizeof_SRC_DialoguePointerTableENG/2-50
	bcc	+
	lda	#_sizeof_SRC_DialoguePointerTableENG/2-1
	bra	++
+;	clc								; never mind, carry is already clear
	adc	#50
++	sta	<DP2.TextPointerNo

	Accu8

	jsr	InitTextBox@NextDialogue

@RButtonDone:



; Check for Start button = return to debug menu
	lda	<DP2.Joy1Press+1
	and	#kButtonStart
	beq	@StartButtonDone
	stz	<DP2.TextBoxStatus					; reset text box status
	lda	#kForcedBlank
	sta	RAM_INIDISP
	lda	#kHVIRQ							; clear IRQ enable bits
	trb	LO8.NMITIMEN

	wait	"frames", 1

	jmp	DebugMenu

@StartButtonDone:

	jmp	@DialogueTestLoop



; DIALOGUE TEXT ENGINE
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

LoadTextBoxBorderTiles:
	ldx	#kVRAM_BG2_Tiles + $80					; set VRAM address for BG2 font tiles (+ 16 empty tiles)
	stx	VMADDL

	dma_0	$01, SRC_FontMode5+$0010, VMDATAL, 16			; upper left corner (1) (see font GFX for tile numbers, whereby 1 tile = $10 bytes)

; DMA parameters except source address (A1T0L) & data length (DAS0L) remain set, this adds up to be
; more than 8 scanlines faster than the previous method (jsr & manually copying each tile)
	ldx	#loword(SRC_FontMode5+$0020)				; upper left corner (2) / upper border (1)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0020)				; upper border (2) / upper right corner (1)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0030)				; upper right corner (2)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0040)				; left border (1)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0200)				; left border (2) / right border (1) (can be any empty tile, using space tile for now)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0050)				; right border (2)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0060)				; lower left corner (1)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0070)				; lower left corner (2) / lower border (1)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0070)				; lower border (2) / lower right corner (1)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0080)				; lower right corner (2)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0000)				; black tile (1) (for left and right screen edges)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN
	ldx	#loword(SRC_FontMode5+$0000)				; black tile (2)
	stx	A1T0L
	ldx	#16
	stx	DAS0L
	sta	MDMAEN

	rts



InitTextBox:

; Prepare selection bar & set up RAM mirror regs/misc. parameters
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathDialogSel, x
	sta	RAM.HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathDialogSel
	bne	-

	lda	#%00010000						; set color math enable bits (4-5) to "MathWindow"
	sta	RAM_CGWSEL
	lda	#%00100011						; enable color math on BG1/2 & mainscreen backdrop
	sta	RAM_CGADSUB
	lda	#50							; color "window" left pos
	sta	RAM_WH0
	lda	#244							; color "window" right pos
	sta	RAM_WH1
	lda	#%00100000						; color math window 1 area = outside (why does this work??)
	sta	RAM_WOBJSEL
	lda	#kTM_BG1|kTM_BG2					; turn on BG1/2 only (i.e., disable BG3 and sprites) for text box
	sta	LO8.TextBox_TSTM
	sta	LO8.TextBox_TSTM+1

@NextDialogue:
	lda	<DP2.HDMA_Channels
	and	#%11110111						; disable HDMA channel 3 (color math) in case of previously active selection // FIXME for CM on playfield!!
	ora	#%00000100						; (re)enable HDMA ch. 2 (backdrop color)
	sta	<DP2.HDMA_Channels
	lda	#kHVIRQ							; (re)enable IRQ at H=HTIMEL and V=VTIMEL
	tsb	LO8.NMITIMEN
	lda	#kTextBoxStatusClear					; clear text box in case it was used before
	sta	<DP2.TextBoxStatus

	wait	"frames", 1

	jsr	ResetTextBox

	lda	#:SRC_DialoguePointerTableENG
	clc								; add language constant to get the correct text bank
	adc	<DP2.GameLanguage
	sta	<DP2.DiagStringBank

	Accu16

	lda	<DP2.GameLanguage					; use game language as index into correct pointer loading routine
	and	#$00FF							
	asl	a
	tax
	jmp	(@LoadPointer, x)

@LoadPointer:								; order of these has to match order of language constants
	.DW @LoadPointerENG
	.DW @LoadPointerDEU
	; add more as needed

@LoadPointerENG:
	lda	<DP2.TextPointerNo
	asl	a
	tax
	lda.l	SRC_DialoguePointerTableENG, x				; DP2.GameLanguage is 0 --> English
	bra	@PointerLoaded

@LoadPointerDEU:
	lda	<DP2.TextPointerNo
	asl	a
	tax
	lda.l	SRC_DialoguePointerTableDEU, x				; DP2.GameLanguage is 1 --> German
	bra	@PointerLoaded

; add more as needed

@PointerLoaded:
	sta	<DP2.DiagStringAddress
	stz	<DP2.DiagStringPos					; reset string position/index

	Accu8

	lda	#kTextBoxStatusActive					; make text box active, no other bits set
	sta	<DP2.TextBoxStatus

	rts



ProcDialogTextBox:							; if the text box is active, then this routine must be called once per frame
;	lda	<DP2.TextBoxVIRQ
;	sta	VTIMEL
;	stz	VTIMEH

	bit	<DP2.TextBoxStatus					; check status
	bvs	@Wait							; "wait" flag set?
	lda	<DP2.TextBoxStatus					; check status again
	bit	#kTextBoxStatusKill					; "kill text box" flag set?
	bne	@KillTextBox

@CurrentString:
	lda	<DP2.DiagStringPos+1					; text box opening animation should only kick in after portrait and BG control codes have been processed, so check string position
	bne	+							; if high byte <> 0, don't bother, and continue processing string
	lda	<DP2.DiagStringPos
	cmp	#6							; string pointer variable (16-bit) must be >=6
	bcc	+
	lda	<DP2.TextBoxVIRQ					; before printing the string, make sure the opening animation has completed
	cmp	#kTextBoxVIRQScanline
	beq	+
	jsr	TextBoxAnimationOpen
	bra	@TextBoxDone						; if text box wasn't fully visible, jump out

+	jsr	ProcessNextText
	bra	@TextBoxDone

@Wait:									; wait for some player input
	lda	<DP2.TextBoxSelection					; check if any selection bit is set
	bit	#%00001111
	beq	@WaitForButtonA
	jsr	TextBoxHandleSelection

	bra	@TextBoxDone

@WaitForButtonA:							; usual wait condition: wait for player confirmation
	bit	<DP2.Joy1New						; wait for player to press the A button (MSB)
	bpl	@TextBoxDone
	lda	#kTextBoxStatusWait					; A pressed, clear flag
	trb	<DP2.TextBoxStatus
	bra	@TextBoxDone

@KillTextBox:
	lda	<DP2.TextBoxVIRQ
	cmp	#kTextBoxVIRQScanlineMax
	beq	+
	jsr	TextBoxAnimationClose
	bra	@TextBoxDone

+	lda	#kHVIRQ							; text box completely removed, clear IRQ enable bits
	trb	LO8.NMITIMEN
	lda	#%00000100						; disable used HDMA channel
	trb	<DP2.HDMA_Channels
	lda	#kTextBoxStatusClear					; set "clear text box" flag only
	sta	<DP2.TextBoxStatus

@TextBoxDone:

	rts



ResetTextBox:
	Accu16

	lda	#0							; FIXME use DMA instead (ch. 1?)
	ldy	#0
-	sta	LO8.VWF_TileBuffer, y					; clear VWF tile buffer
	iny
	iny
	cpy	#64							; 4 tiles, 16 bytes per tile
	bne	-

	stz	<DP2.VWF_BitsUsed					; reset used bits counter
	stz	<DP2.VWF_BufferIndex					; reset VWF buffer index

	Accu8

	lda	#kTextBoxTileLine1					; reset tile counter
	sta	<DP2.VWF_TileCounter
	stz	<DP2.DiagTextEffect					; clear text effect bits
	stz	<DP2.TextBoxSelection					; clear selection bits

	rts



TextBoxHandleSelection:
	lda	<DP2.HDMA_Channels					; check if HDMA channel 3 (color math) is already enabled
	and	#%00001000
	bne	@WaitForInput



; Determine text box line the selection starts on, and pre-load Accu with appropriate multiple
; of 8, i.e. Accu = (sel_start_line - 1) * 8, using a bit-manipulating loop
	lda	#kTextBoxColMath1st					; load value of first possible colored scanline, use bit shifting to find the actual start value for the color bar
	xba								; preserve inital value
	lda	<DP2.TextBoxSelection
-	lsr	a							; test DP2.TextBoxSelection bits from LSB onwards
	xba								; switch back to target Accu value
	bcs	+							; jump out as soon as first set bit found
	adc	#8							; bit was clear --> no selection on this line, so add 8 to target Accu value // carry always clear at this point, so no need for clc before the adc
	xba								; switch back to next-higher selection bit
	bra	-							; rinse and repeat until first set bit found

+	sta	RAM.HDMA_ColorMath+3					; save target value in RAM table
	sta	<DP2.TextBoxSelMin					; and in variable for user control
	lda	<DP2.TextBoxSelection					; preserve selection variable (destroyed in upcoming calculation)
	pha
	lda	#$00							; count no. of selection options available (max. 4, i.e. the lower nibble bits of <DP2.TextBoxSelection)
	lsr	<DP2.TextBoxSelection					; add 'em up via carry bit
	adc	#$00
	lsr	<DP2.TextBoxSelection
	adc	#$00
	lsr	<DP2.TextBoxSelection
	adc	#$00
	lsr	<DP2.TextBoxSelection
	adc	#$00							; no. of selection options in Accu now
	dea								; (no. of options - 1) * 8 + DP2.TextBoxSelMin = DP2.TextBoxSelMax
	shl	3
	clc
	adc	<DP2.TextBoxSelMin
	sta	<DP2.TextBoxSelMax
	pla								; restore selection variable
	sta	<DP2.TextBoxSelection
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	<DP2.HDMA_Channels
	bra	@JumpOut						; wait for selection bar to appear before checking buttons on next iteration



@WaitForInput:

; Check for dpad up
	lda	<DP2.Joy1New+1
	and	#%00001000
	beq	@DpadUpDone

	lda	RAM.HDMA_ColorMath+3					; move selection bar 8 scanlines up
	sec
	sbc	#8
	cmp	<DP2.TextBoxSelMin
	bcs	+
	lda	<DP2.TextBoxSelMin
+	sta	RAM.HDMA_ColorMath+3

@DpadUpDone:



; Check for dpad down
	lda	<DP2.Joy1New+1
	and	#%00000100
	beq	@DpadDownDone

	lda	RAM.HDMA_ColorMath+3					; move selection bar 8 scanlines down
	clc
	adc	#8
	cmp	<DP2.TextBoxSelMax
	bcc	+
	lda	<DP2.TextBoxSelMax
+	sta	RAM.HDMA_ColorMath+3

@DpadDownDone:



; Check for A button = make selection
	lda	<DP2.Joy1New
	bpl	@JumpOut
	lda	RAM.HDMA_ColorMath+3					; determine selection made by checking position of selection bar
	sec
	sbc	#kTextBoxColMath1st					; subtract start of 1st line

; now in Accu	| make bit in <DP2.TextBoxSelection
; -------------------------------------------------
; $00 (line 1)	| $10
; $08 (line 2)	| $20 (value << 2)
; $10 (line 3)	| $40 (value << 2)
; $18 (line 4)	| $80

	bne	+
	lda	#$10							; $00 (line 1) --> $10
	bra	@SelectionMade

+	cmp	#$18
	bne	+
	lda	#$80							; $18 (line 4) --> $80
	bra	@SelectionMade

+	shl	2							; line 2 or 3

@SelectionMade:
	sta	<DP2.TextBoxSelection					; store user selection (bits 0-3 clear)
	lda	#%00001000						; disable HDMA channel 3 (color math) // FIXME for CM on playfield!!
	trb	<DP2.HDMA_Channels

@JumpOut:

	rts



ProcessNextText:
	Accu16

@NextStringByte:
	lda	<DP2.DiagStringPos
	tay								; transfer string position to Y index
	ina								; increment string position index
	sta	<DP2.DiagStringPos					; (N.B.: inc a, sta dp is 1 cycle faster than inc dp)

	Accu8

	lda	[<DP2.DiagStringAddress], y				; read current byte of string
	bne	@CheckCC
	jmp	@EndOfString						; if zero (NUL terminator), end of string reached

@CheckCC:
	cmp	#kDiagControlCode					; check for control code
	bne	@CheckSpeakerName

	ldy	<DP2.DiagStringPos
	lda	[<DP2.DiagStringAddress], y				; read control code
	iny								; increment string position index

	Accu16

	and	#$00FF							; clear high byte
	asl	a							; use control code as jump index
	tax
	jmp	(ProcessDialogueCC, x)					; control codes do rts, where applicable

.ACCU 8

@CheckSpeakerName:
	cmp	#kDiagSpeakerName					; check for speaker character name
	bne	@CheckInlineName

; Get speaker name from WRAM array and make it a sub-string
	ldy	<DP2.DiagStringPos
	lda	[<DP2.DiagStringAddress], y				; read character name byte
	iny								; increment string position index
	sty	LO8.DiagStringPos					; save current string position index

	Accu16

	and	#$00FF							; clear high byte
	jsl	MULT10							; byte value * 10 for corresponding name in array

	clc								; add array start address
	adc	#loword(RAM.CharacterNames)
	pha								; treat as sub-string, push address

	Accu8

	lda	#bankbyte(RAM.CharacterNames)
	pha								; push sub-string bank
	jmp	Process_CC_SUBSTR@JumpIn

@CheckInlineName:
	cmp	#kDiagInlineName					; check for in-line character name
	bne	@NormalText

; Get speaker name from WRAM array, convert to lowercase (e.g., "ALEC" --> "Alec") into TempString,
; and make that a sub-string
	ldy	<DP2.DiagStringPos
	lda	[<DP2.DiagStringAddress], y				; read character name byte
	iny								; increment string position index
	sty	LO8.DiagStringPos					; save current string position index

	Accu16

	and	#$00FF							; clear high byte
	jsl	MULT10							; byte value * 10 for corresponding name in array

	clc								; add array start address
	adc	#loword(RAM.CharacterNames)
	sta	WMADDL							; set WRAM port for character name

	Accu8

	lda	#bankbyte(RAM.CharacterNames) & $01
	sta	WMADDH

	ldx	#$0000
	lda	WMDATA							; load first character, leave it alone
;	beq	+							; not needed, shouldn't ever be zero
	sta	LO8.TempString, x
	inx
-	lda	WMDATA							; load remaining characters
	beq	@@Done
	clc								; add offset for lowercase
	adc	#$20
	sta	LO8.TempString, x
	inx
	bra	-

@@Done:
	sta	LO8.TempString, x					; store NUL terminator
	ldx	#loword(LO8.TempString)					; make TempString a sub-string
	phx								; push address
	lda	#bankbyte(LO8.TempString)
	pha								; push bank
	jmp	Process_CC_SUBSTR@JumpIn

@NormalText:								; process normal text
	Accu16

	and	#$00FF							; clear high byte
	sta	<DP2.DiagASCIIChar					; save ASCII char no.
	bit	<DP2.DiagTextEffect-1					; put MSB of DP2.DiagTextEffect (an 8-bit variable) into MSB of (currently 16-bit) accumulator
	bmi	+							; MSB set --> use routine for bold font
	jsr	ProcessVWFTiles						; otherwise, use normal font routine
	bra	++

+	jsr	ProcessVWFTilesBold

++

.ACCU 8

	lda	<DP2.VWF_BufferIndex					; check if 2 buffer tiles full
	cmp	#32							; 2 tiles × 16 = buffer index
	bcs	@JumpOut
	jmp	ProcessNextText 					; buffer not full yet, continue reading string // ADDME/ADDFEATURE @JumpOut instead for slower text speed

@EndOfString:
	bit	<DP2.DiagTextEffect					; check sub-string flag
	bvc	@StringFinished
	lda	LO8.DiagStringBank					; sub-string finished, restore current string bank
	sta	<DP2.DiagStringBank

	Accu16

	lda	LO8.DiagStringAddress					; restore string address and offset/pointer
	sta	<DP2.DiagStringAddress
	lda	LO8.DiagStringPos
	sta	<DP2.DiagStringPos

	Accu8

	lda	#%01000000						; clear sub-string flag
	trb	<DP2.DiagTextEffect
	bra	@JumpOut

@StringFinished:							; string completely finished
	lda	#kTextBoxStatusWait|kTextBoxStatusFlush|kTextBoxStatusKill	; set status flags
	tsb	<DP2.TextBoxStatus

	wait	"frames", 1						; wait for last tile to write

	lda	#kTextBoxTileLine1					; reset tile counter
	sta	<DP2.VWF_TileCounter

@JumpOut:

	rts



; Self-reminder: Order of table entries has to match lower byte of the two-byte entries starting
; from $FF00 in tbl_dialogue.tbl. Some control codes expect argument bytes as outlined in the
; comments below.

ProcessDialogueCC:
	.DW Process_CC_BG						; <BG> set text box background + no. of color gradient (8-bit, though bit 7 must always be clear; 0 = black/narration, 1 = blue/normal mood, 2 = red/enemy mood, 3 = pink/love/affection, 4 = evil mood, 5 = alert)
	.DW Process_CC_CLR						; <CLR> clear the text box
	.DW Process_CC_IND						; <IND> indent text
	.DW Process_CC_JMP						; <JMP> jump to next string + 24-bit address
	.DW Process_CC_NL						; <NL> begin a new line
	.DW Process_CC_PORTRAIT						; <PORTRAIT> set speaker portrait + no. of portrait (8-bit)
	.DW Process_CC_SEL						; <SEL> make this line a selection
	.DW Process_CC_SUBHEX						; <SUBHEX> print a byte in hex + 24-bit address
	.DW Process_CC_SUBINT8						; <SUBINT8> print a byte in decimal (0-255) + 24-bit address
	.DW Process_CC_SUBINT16						; <SUBINT16> print a byte in decimal (0-65535) + 24-bit address
	.DW Process_CC_SUBSTR						; <SUBSTR> print a sub-string + 24-bit address
	.DW Process_CC_B						; <B> toggle bold text



.ACCU 16

Process_CC_BG:
	Accu8

	lda	[<DP2.DiagStringAddress], y				; read BG color gradient number (with "change text box background" bit set)
	sta	<DP2.TextBoxBG
	iny								; increment string position index
	sty	<DP2.DiagStringPos

; Pre-calculate displacement for last segment in HDMA color gradient table based on current IRQ
; scanline, e.g. when text box has fully "scrolled in": 224 - 176 = 48; 48 * 4 = 192 bytes;
; 192 + RAM.HDMA_BG_Playfield + kPlayfieldHeight * 4 = RAM.HDMA_BG_TextBox
@CalcGradientDisplacement:
	lda	#224							; get max. number of scanlines for text box
	sec
	sbc	<DP2.TextBoxVIRQ

	Accu16

	and	#$00FF							; clear high byte
	shl	2							; 4 bytes per scanline in table
	clc
	adc	#loword(RAM.HDMA_BG_Playfield)+kPlayfieldHeight*4
	sta	LO8.HDMA_ColorGradient+7

	Accu8

	rts								; aka bra/jmp ProcessNextText@JumpOut



.ACCU 16

Process_CC_CLR:
	sty	<DP2.DiagStringPos					; store string position index

	Accu8

	lda	#kTextBoxStatusWait|kTextBoxStatusFlush|kTextBoxStatusClear	; set status flags
	tsb	<DP2.TextBoxStatus

	wait	"frames", 1						; wait for text box status update

	jsr	ResetTextBox

	rts



.ACCU 16

Process_CC_IND:
	sty	<DP2.DiagStringPos					; store string position index

	Accu8

	inc	<DP2.VWF_TileCounter					; skip one 16×8 tile

	rts



.ACCU 16

Process_CC_JMP:
	lda	[<DP2.DiagStringAddress], y				; read 16-bit jump address
	tax								; store temporarily in X (we still need to read the bank byte from [DiagStringAddress] so we can't overwrite it just yet)

	Accu8

	iny								; increment index to bank of new string
	iny
	lda	[<DP2.DiagStringAddress], y				; read bank
	sta	<DP2.DiagStringBank					; store bank
	stx	<DP2.DiagStringAddress					; store address
	stz	<DP2.DiagStringPos					; reset string position index
	stz	<DP2.DiagStringPos+1

	rts



.ACCU 16

Process_CC_NL:								; 23 16×8 tiles = 46 8×8 characters per line

; Caveat: Edge case "23 full 16×8 tiles written on a line + <NL> wanted" cannot easily be accounted
; for, but would a) be very rare/stupid and b) cause visible glitching anyway ...
	sty	<DP2.DiagStringPos					; store string position index

	Accu8

;@UnfinishedVWFTile:
	lda	#kTextBoxStatusFlush					; force-flush VWF buffer (very short strings like "!" should still appear on current line)
	tsb	<DP2.TextBoxStatus

	wait	"frames", 1						; wait for last tile on current line to write

;@VWFTileFinished:							; VWF tile buffer clean and DP2.DiagTileCounter already pointing to the next tile
	lda	<DP2.VWF_TileCounter					; check what line we're on
	cmp	#kTextBoxTileLine4					; line 4?
	bcs	@Done							; always stay on line 4 (might still cause a tab-like whitespace, depending on content of previous tile)

	cmp	#kTextBoxTileLine3					; line 3?
	beq	@Done							; (edge case: We're already at the start of a line because a string has filled the previous line with more than 22 but less than exactly 23 16×8 tiles)
	bcc	+
	lda	#kTextBoxTileLine4					; yes, go to line 4
	bra	@Done

+	cmp	#kTextBoxTileLine2					; line 2?
	beq	@Done							; (edge case)
	bcc	+
	lda	#kTextBoxTileLine3					; yes, go to line 3
	bra	@Done

+	lda	#kTextBoxTileLine2					; else, go to line 2

@Done:
	sta	<DP2.VWF_TileCounter					; store new line counter value
	stz	<DP2.VWF_BitsUsed					; reset VWF bit counter
	stz	<DP2.VWF_BitsUsed+1

@JumpOut:

	rts



.ACCU 16

Process_CC_PORTRAIT:
	lda	[<DP2.DiagStringAddress], y				; read portrait no. (with "change portrait" bit set)
	sta	<DP2.TextBoxPortrait					; save to "change portrait" request variable
	iny								; advance string position index
	iny
	sty	<DP2.DiagStringPos

	Accu8

	rts



.ACCU 16

Process_CC_SEL:
	sty	<DP2.DiagStringPos					; store string position index

	Accu8

	lda	<DP2.VWF_TileCounter					; selection wanted, check current line
	cmp	#kTextBoxTileLine2
	bcs	+
	lda	#kTextBoxSelLine1
	bra	@SaveSelectionBit

+	cmp	#kTextBoxTileLine3
	bcs	+
	lda	#kTextBoxSelLine2
	bra	@SaveSelectionBit

+	cmp	#kTextBoxTileLine4
	bcs	+
	lda	#kTextBoxSelLine3
	bra	@SaveSelectionBit

+	lda	#kTextBoxSelLine4

@SaveSelectionBit:
	tsb	<DP2.TextBoxSelection

	rts



.ACCU 16

Process_CC_SUBHEX:
	lda	[<DP2.DiagStringAddress], y				; read address
	sta	<DP2.DataAddress
	iny
	iny

	Accu8

	lda	[<DP2.DiagStringAddress], y				; bank
	sta	<DP2.DataBank
	iny								; increment string position index
	sty	LO8.DiagStringPos					; save current string position index



; Process actual hex byte, i.e. make it into a WRAM sub-string
	lda	[<DP2.DataAddress]					; load byte to print in hex
	pha
	shr	4							; do upper nibble first
	ldx	#0

	HexNibbleToTempString

	inx
	pla
	and	#$0F							; do lower nibble

	HexNibbleToTempString

	inx
	stz	LO8.TempString, x					; add NUL terminator

	Accu16

	stz	<DP2.DiagStringPos					; reset string offset so it starts reading the sub-string from the beginning
	lda	<DP2.DiagStringAddress					; save current string address
	sta	LO8.DiagStringAddress
	lda	#LO8.TempString						; load address of temp string array
	sta	<DP2.DiagStringAddress

	Accu8

	lda	<DP2.DiagStringBank					; save current string bank
	sta	LO8.DiagStringBank
	lda	#$7E							; set lower WRAM bank
	sta	<DP2.DiagStringBank
	lda	#%01000000						; set sub-string flag
	tsb	<DP2.DiagTextEffect

	rts



.ACCU 16

Process_CC_SUBINT8:
	lda	[<DP2.DiagStringAddress], y				; read address
	sta	<DP2.DataAddress
	iny
	iny

	Accu8

	lda	[<DP2.DiagStringAddress], y				; bank
	sta	<DP2.DataBank
	iny								; increment string position index
	sty	LO8.DiagStringPos					; save current string position index



; Process actual byte, i.e. make dec number(s) into a WRAM sub-string
	lda	[<DP2.DataAddress]					; read byte
	sta	WRDIVL
	lda	#$00
	sta	WRDIVH
	PHA
	ldx	#0
	BRA	Process_CC_SUBINT16@DivLoop



.ACCU 16

Process_CC_SUBINT16:
	lda	[<DP2.DiagStringAddress], y				; read address
	sta	<DP2.DataAddress
	iny
	iny

	Accu8

	lda	[<DP2.DiagStringAddress], y				; bank
	sta	<DP2.DataBank
	iny								; increment string position index
	sty	LO8.DiagStringPos					; save current string position index



; Process actual bytes, i.e. make dec number(s) into a WRAM sub-string
	lda	#$00
	pha								; push $00
	ldy	#0
	lda	[<DP2.DataAddress], y					; read low byte
	sta	WRDIVL							; DIVC.l
	iny
	lda	[<DP2.DataAddress], y					; read high byte
	sta	WRDIVH							; DIVC.h  ... DIVC = [Y]
	ldx	#0

@DivLoop:
	lda	#$0A	
	sta	WRDIVB							; DIVB = 10 --- division starts here (need to wait 16 cycles)
	NOP								; 2 cycles
	NOP								; 2 cycles
	NOP								; 2 cycles
	PHA								; 3 cycles
	PLA								; 4 cycles
	lda	#'0'							; 2 cycles
	CLC								; 2 cycles
	adc	RDMPYL							; A = '0' + DIVC % DIVB
	PHA								; push character
	lda	RDDIVL							; Result.l -> DIVC.l
	sta	WRDIVL
	beq	@Low_0
	lda	RDDIVH							; Result.h -> DIVC.h
	sta	WRDIVH
	BRA	@DivLoop

@Low_0:
	lda	RDDIVH							; Result.h -> DIVC.h
	sta	WRDIVH
	beq	@IntPrintLoop						; if ((Result.l==$00) and (Result.h==$00)) then we're done, so print
	BRA	@DivLoop

@IntPrintLoop:								; until we get to the end of the string...
	PLA								; keep pulling characters and printing them
	beq	@EndOfInt
	sta	LO8.TempString, x
	inx
	BRA	@IntPrintLoop

@EndOfInt:
	stz	LO8.TempString, x					; add NUL terminator

	Accu16

	stz	<DP2.DiagStringPos					; reset string offset so it starts reading the sub-string from the beginning
	lda	<DP2.DiagStringAddress					; save current string address
	sta	LO8.DiagStringAddress
	lda	#LO8.TempString						; load address of temp string array
	sta	<DP2.DiagStringAddress

	Accu8

	lda	<DP2.DiagStringBank					; save current string bank
	sta	LO8.DiagStringBank
	lda	#$7E							; set lower WRAM bank
	sta	<DP2.DiagStringBank
	lda	#%01000000						; set sub-string flag
	tsb	<DP2.DiagTextEffect

	rts



.ACCU 16

Process_CC_SUBSTR:
	lda	[<DP2.DiagStringAddress], y				; read and push sub-string address
	pha
	iny
	iny

	Accu8

	lda	[<DP2.DiagStringAddress], y				; same for sub-string bank
	pha
	iny								; increment string position index
	sty	LO8.DiagStringPos					; save current string position index

@JumpIn:
	lda	<DP2.DiagStringBank					; save current string bank
	sta	LO8.DiagStringBank
	pla								; pull and store sub-string bank
	sta	<DP2.DiagStringBank

	Accu16

	lda	<DP2.DiagStringAddress					; save current string address
	sta	LO8.DiagStringAddress
	pla								; pull and store sub-string address
	sta	<DP2.DiagStringAddress
	stz	<DP2.DiagStringPos					; reset string index position for sub-string

	Accu8

	lda	#%01000000						; set sub-string flag
	tsb	<DP2.DiagTextEffect

	rts



.ACCU 16

Process_CC_B:
	Accu8

	lda	<DP2.DiagTextEffect
	eor	#%10000000						; toggle "bold text" bit
	sta	<DP2.DiagTextEffect
	sty	<DP2.DiagStringPos					; store string position index

	rts



; For the text box, we use fixed tilemaps and generate Mode 5-compatible tile data based on any
; given text string on-the-fly in VRAM.

MakeTextBoxTilemapBG1:
	ldx	#kVRAM_BG1_Tilemap3+kTextBox				; set VRAM address within new BG1 tilemap
	stx	VMADDL

	dma_0	$01, SRC_TextBoxTilemapBG1, VMDATAL, _sizeof_SRC_TextBoxTilemapBG1

	rts

; The above DMA just sends the raw result of below clumsy calculations to VRAM (faster for now).

	ldx	#kVRAM_BG1_Tilemap3+kTextBox				; set VRAM address within new BG1 tilemap
	stx	VMADDL

	Accu16



; Line 1 of text box area
	lda	#0|$400							; patch up first tile ($00 = blank tile), palette no. 1
	sta	VMDATAL

	lda	#kVRAM_Portrait/16|$400					; get tile no. for start of portrait
-	sta	VMDATAL
	ina
	ina
	cmp	#kVRAM_Portrait/16+10|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+33						; end of line 1 + first tile of line 2
	bne	-



; Line 2 of text box area
	lda	#kVRAM_Portrait/16+10|$400				; get next tile no.
-	sta	VMDATAL
	ina
	ina
	cmp	#kVRAM_Portrait/16+20|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+32+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+65						; end of line 2 + first tile of line 3
	bne	-



; Line 3 of text box area
	lda	#kVRAM_Portrait/16+20|$400				; get next tile no.
-	sta	VMDATAL
	ina
	ina
	cmp	#kVRAM_Portrait/16+30|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+64+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+97						; end of line 3 + first tile of line 4
	bne	-



; Line 4 of text box area
	lda	#kVRAM_Portrait/16+30|$400				; get next tile no.
-	sta	VMDATAL
	ina
	ina
	cmp	#kVRAM_Portrait/16+40|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+96+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+129						; end of line 4 + first tile of line 5
	bne	-



; Line 5 of text box area
	lda	#kVRAM_Portrait/16+40|$400				; get next tile no.
-	sta	VMDATAL
	ina
	ina
	cmp	#kVRAM_Portrait/16+50|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+128+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+161						; end of line 5 + first tile of line 6
	bne	-



; Line 6 of text box area
	lda	#kVRAM_Portrait/16+50|$400				; get next tile no.
-	sta	VMDATAL
	ina
	ina
	cmp	#kVRAM_Portrait/16+60|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+160+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+192						; end of line 6
	bne	-

	Accu8

	rts



MakeTextBoxTilemapBG2:
	ldx	#kVRAM_BG2_Tilemap3+kTextBox				; set VRAM address within new BG2 tilemap
	stx	VMADDL

	dma_0	$01, SRC_TextBoxTilemapBG2, VMDATAL, _sizeof_SRC_TextBoxTilemapBG2

	rts

; The above DMA just sends the raw result of below clumsy calculations to VRAM (faster for now).

	ldx	#kVRAM_BG2_Tilemap3+kTextBox				; set VRAM address within new BG2 tilemap
	stx	VMADDL

	Accu16



; Line 1 of text box area
	lda	#27|$400						; tile no. of black tile, palette no. 1
	sta	VMDATAL

	ldx	#kTextBox+1
	lda	#0							; no. of blank tile
-	sta	VMDATAL							; 1st tile row of portrait
	inx
	cpx	#kTextBox+6						; 5 tiles done?
	bne	-

	lda	#16							; upper left corner tiles
	sta	VMDATAL
	inx
	lda	#17							; upper border tiles
-	sta	VMDATAL
	inx
	cpx	#kTextBoxUL+kTextBoxWidth				; position: upper right corner
	bne	-

	lda	#18							; upper right corner tiles
	sta	VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL



; Line 2 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL

	ldx	#kTextBox+33
	lda	#0							; no. of blank tile
-	sta	VMDATAL							; 2nd tile row of portrait
	inx
	cpx	#kTextBox+32+6						; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	VMDATAL
	inx
	lda	#$20							; $20 = no. of 1st text string tile in VRAM, $22 = second tile etc.
-	sta	VMDATAL
	ina								; tile no. += 2 (Mode 5 always shows two 8×8 tiles at once, resulting in a single 16×8 tile)
	ina
	inx
	cpx	#kTextBoxLine1+kTextBoxWidth-1
	bne	-

	pha								; preserve no. of text string tile
	lda	#21							; right border tiles
	sta	VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL



; Line 3 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL

	ldx	#kTextBox+65
	lda	#0							; no. of blank tile
-	sta	VMDATAL							; 3rd tile row of portrait
	inx
	cpx	#kTextBox+64+6						; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	VMDATAL
	inx

	pla								; restore no. of text string tile
-	sta	VMDATAL
	ina								; tile no. += 2
	ina
	inx								; position in tilemap += 1
	cpx	#kTextBoxLine2+kTextBoxWidth-1
	bne	-

	pha								; preserve no. of text string tile
	lda	#21							; right border tiles
	sta	VMDATAL
	inx
	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL
	inx



; Line 4 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL

	ldx	#kTextBox+97
	lda	#0							; no. of blank tile
-	sta	VMDATAL							; 4th tile row of portrait
	inx
	cpx	#kTextBox+96+6						; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	VMDATAL
	inx

	pla								; restore no. of text string tile
-	sta	VMDATAL
	ina								; tile no. += 2
	ina
	inx								; position in tilemap += 1
	cpx	#kTextBoxLine3+kTextBoxWidth-1
	bne	-

	pha								; preserve no. of text string tile
	lda	#21							; right border tiles
	sta	VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL



; Line 5 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL

	ldx	#kTextBox+129
	lda	#0							; no. of blank tile
-	sta	VMDATAL							; 5th tile row of portrait
	inx
	cpx	#kTextBox+128+6						; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	VMDATAL
	inx

	pla								; restore no. of text string tile
-	sta	VMDATAL
	ina								; tile no. += 2
	ina
	inx								; position in tilemap += 1
	cpx	#kTextBoxLine4+kTextBoxWidth-1
	bne	-

	lda	#21							; right border tiles
	sta	VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL



; Line 6 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL

	ldx	#kTextBox+161
	lda	#0							; no. of blank tile
-	sta	VMDATAL							; 6th tile row of portrait
	inx
	cpx	#kTextBox+160+6						; 5 tiles done?
	bne	-

	lda	#23							; lower left corner tiles
	sta	VMDATAL
	inx
	lda	#24							; lower border tiles
-	sta	VMDATAL
	inx
	cpx	#kTextBoxUL+kTextBoxWidth+160				; lower right corner reached?
	bne	-

	lda	#25							; lower right corner tiles
	sta	VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	VMDATAL

	Accu8

	rts



MakeMode5FontBG1:							; Expects VRAM address set to BG1 tile base
	Accu16

	ldx	#0

@BuildFontBG1:
	ldy	#8							; 8 iterations = 16 bytes per tile
-	lda.l	SRC_Font8x8, x						; copy font tile (BG1 8×8 font tiles sit on the "left side" of forced-16×8 Mode 5 tiles)
	sta	VMDATAL
	inx
	inx
	dey
	bne	-

	ldy	#24							; 24 iterations = 3 blank tiles (when viewed in 2bpp mode, though in reality, BG1 is 4bpp)
-	stz	VMDATAL
	dey
	bne	-

	cpx	#_sizeof_SRC_Font8x8					; 2 KiB font done?
	bne	@BuildFontBG1

	Accu8

	rts



MakeMode5FontBG2:							; Expects VRAM address set to BG2 tile base
	Accu16

	ldx	#0

@BuildFontBG2:
	ldy	#8							; 8 iterations = 1 blank tile (this is enough as BG2 is 2bpp anyway)
-	stz	VMDATAL
	dey
	bne	-

	ldy	#8							; 8 iterations = 16 bytes per tile
-	lda.l	SRC_Font8x8, x						; copy font tile (BG2 8×8 font tiles sit on the "right side" of forced-16×8 Mode 5 tiles)
	sta	VMDATAL
	inx
	inx
	dey
	bne	-

	cpx	#_sizeof_SRC_Font8x8					; 2 KiB font done?
	bne	@BuildFontBG2

	Accu8

	rts



.ACCU 16

ProcessVWFTiles:
	lda	<DP2.DiagASCIIChar					; ASCII char no. --> font tile no.
	shl	4							; value * 16 as 1 font tile = 16 bytes
	tax

	Accu8

	ldy	<DP2.VWF_BufferIndex
	lda	#16							; loop through 16 bytes per tile
	sta	<DP2.VWF_Loop

@VWFTilesLoop:
	lda.l	SRC_FontMode5, x
	xba								; move to high byte
	lda	#$00							; clear low byte
	jsr	VWFShiftBits						; shift tile data if necessary

	ora	LO8.VWF_TileBuffer+16, y				; store upper 8 bit
	sta	LO8.VWF_TileBuffer+16, y
	xba
	ora	LO8.VWF_TileBuffer, y					; store lower 8 bit
	sta	LO8.VWF_TileBuffer, y
	inx
	iny
	dec	<DP2.VWF_Loop
	bne	@VWFTilesLoop

	ldx	<DP2.DiagASCIIChar					; ASCII char no. --> font width table index
	lda.l	SRC_FWT_Dialog, x
	clc
	adc	<DP2.VWF_BitsUsed
	cmp	#8
	bcs	+
	sta	<DP2.VWF_BitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	<DP2.VWF_BufferIndex

	Accu8

	bra	@VWFTilesDone

+	sec
	sbc	#8
	sta	<DP2.VWF_BitsUsed
	sty	<DP2.VWF_BufferIndex

@VWFTilesDone:

	rts



.ACCU 16

ProcessVWFTilesBold:							; FIXME this whole mess
	lda	<DP2.DiagASCIIChar					; ASCII char no. --> font tile no.
	shl	5							; value * 32 as 1 font tile = 16 bytes, and each character uses 2 tiles
	tax

	Accu8

	lda	#16							; loop through 16 bytes per tile
	sta	<DP2.VWF_Loop
	ldy	<DP2.VWF_BufferIndex

@VWFTilesLoop1:
	lda.l	SRC_FontMode5Bold, x
	xba								; move to high byte
	lda	#$00							; clear low byte
	jsr	VWFShiftBits						; shift tile data if necessary

	ora	LO8.VWF_TileBuffer+16, y				; store upper 8 bit
	sta	LO8.VWF_TileBuffer+16, y
	xba
	ora	LO8.VWF_TileBuffer, y					; store lower 8 bit
	sta	LO8.VWF_TileBuffer, y
	inx
	iny
	dec	<DP2.VWF_Loop
	bne	@VWFTilesLoop1

	Accu16

	lda	<DP2.DiagASCIIChar					; get correct ASCII char no. font width table index
	asl	a							; the table consists of 2 entries per character, so double the value
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x					; ASCII char graphics (right half) --> font width table index
	clc
	adc	<DP2.VWF_BitsUsed
	cmp	#8
	bcs	+
	sta	<DP2.VWF_BitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	<DP2.VWF_BufferIndex

	Accu8

	bra	@VWFTilesDone1

+	sec
	sbc	#8
	sta	<DP2.VWF_BitsUsed
	sty	<DP2.VWF_BufferIndex

@VWFTilesDone1:
	Accu16

	lda	<DP2.DiagASCIIChar					; check if there is a right half of character graphics
	asl	a							; 2 entries per character, so make up for that
	ina								; move table index to the right of current char
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x
	bne	+
	jmp	@VWFTilesDone2						; if entry is zero, jump out

+	lda	<DP2.VWF_BufferIndex					; second half exists, check if 2 buffer tiles full
	cmp	#32							; 2 tiles × 16 = buffer index
	bcc	+

	wait	"frames", 1						; yes, wait for first half to write

+	Accu16								; process right half of char graphics

	lda	<DP2.DiagASCIIChar					; ASCII char no. --> font tile no.
	shl	5							; value * 32 as 1 font tile = 16 bytes, and each character uses 2 tiles
	clc								; add 16 bytes (one 8×8 tile) for right half of char graphics
	adc	#16
	tax

	Accu8

	lda	#16							; loop through 16 bytes per tile
	sta	<DP2.VWF_Loop
	ldy	<DP2.VWF_BufferIndex

@VWFTilesLoop2:
	lda.l	SRC_FontMode5Bold, x
	xba								; move to high byte
	lda	#$00							; clear low byte
	jsr	VWFShiftBits						; shift tile data if necessary

	ora	LO8.VWF_TileBuffer+16, y				; store upper 8 bit
	sta	LO8.VWF_TileBuffer+16, y
	xba
	ora	LO8.VWF_TileBuffer, y					; store lower 8 bit
	sta	LO8.VWF_TileBuffer, y
	inx
	iny
	dec	<DP2.VWF_Loop
	bne	@VWFTilesLoop2

	Accu16

	lda	<DP2.DiagASCIIChar					; get correct ASCII char no. font width table index
	asl	a							; the table consists of 2 entries per character, so double the value
	ina								; move table index to right half of current char
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x					; ASCII char graphics (right half) --> font width table index
	clc
	adc	<DP2.VWF_BitsUsed
	cmp	#8
	bcs	+
	sta	<DP2.VWF_BitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	<DP2.VWF_BufferIndex

	Accu8

	bra	@VWFTilesDone2

+	sec
	sbc	#8
	sta	<DP2.VWF_BitsUsed
	sty	<DP2.VWF_BufferIndex

@VWFTilesDone2:

	rts



VWFShiftBits:
	phx

	Accu16

	pha
	lda	<DP2.VWF_BitsUsed
	bne	+
	pla
	bra	@VWFShiftBitsDone

+	dec	a
	asl	a
	tax
	pla
	jmp	(@VWFShiftAmount, x)

@VWFShiftAmount:
	.DW @R1, @R2, @R3, @R4, @R5, @R6, @R7

@R7:
	lsr	a

@R6:
	lsr	a

@R5:
	lsr	a

@R4:
	lsr	a

@R3:
	lsr	a

@R2:
	lsr	a

@R1:
	lsr	a

@VWFShiftBitsDone:
	Accu8

	plx

	rts



TextBoxAnimationClose:							; closing animation (scroll text box content out vertically below the screen)
	lda	<DP2.TextBoxVIRQ
	clc								; increase value to create the illusion that the text box "scrolls out" below the screen
	adc	#kTextBoxAnimSpd
	sta	<DP2.TextBoxVIRQ					; write new scanline for IRQ to fire
	sta	VTIMEL
	stz	VTIMEH

	jsr	Process_CC_BG@CalcGradientDisplacement

	Accu16

	lda	LO8.HDMA_BG_Scroll+13					; subtract speed value from vertical BG scroll data, i.e. scroll BG down
	sec
	sbc	#kTextBoxAnimSpd
	sta	LO8.HDMA_BG_Scroll+13

	Accu8

	lda	LO8.HDMA_BG_Scroll+5					; increase playfield BG size by speed value
	clc
	adc	#kTextBoxAnimSpd
	sta	LO8.HDMA_BG_Scroll+5
	lda	LO8.HDMA_BG_Scroll+10					; reduce text box BG size by speed value
	sec
	sbc	#kTextBoxAnimSpd
	sta	LO8.HDMA_BG_Scroll+10

	rts



TextBoxAnimationOpen:							; opening animation (scroll text box content in vertically from below)
	lda	<DP2.TextBoxVIRQ
	sec								; reduce value so the text box "scrolls" in from below the screen
	sbc	#kTextBoxAnimSpd
	sta	<DP2.TextBoxVIRQ
	sta	VTIMEL
	stz	VTIMEH

	jsr	Process_CC_BG@CalcGradientDisplacement

	Accu16

	lda	LO8.HDMA_BG_Scroll+13					; add speed value to vertical BG scroll data, i.e. scroll BG up
	clc
	adc	#kTextBoxAnimSpd
	sta	LO8.HDMA_BG_Scroll+13

	Accu8

	lda	LO8.HDMA_BG_Scroll+5					; reduce playfield BG size by speed value
	sec
	sbc	#kTextBoxAnimSpd
	sta	LO8.HDMA_BG_Scroll+5
	lda	LO8.HDMA_BG_Scroll+10					; increase text box BG size by speed value
	clc
	adc	#kTextBoxAnimSpd
	sta	LO8.HDMA_BG_Scroll+10

	rts



; STRING PROCESSING FUNCTIONS
; --------------------------------------------------------------------------------------------------
;
; Code in this section based on code written by neviksti, (c) 2002

;PrintF -- Print a formatted, NUL-terminated string to Stdout
;Notes:
;     Supported Format characters:
;       %s -- sub-string (reads NUL-terminated data from [DP2.DataAddress])
;       %d -- 16-bit Integer (reads 16-bit data from [DP2.DataAddress])
;       %b -- 8-bit Integer (reads 8-bit data from [DP2.DataAddress])
;       %x -- 8-bit hex Integer (reads 8-bit data from [DP2.DataAddress])
;       %% -- normal %
;       \n -- Newline
;       \t -- Tab
;       \\ -- normal slash
;     String pointers all refer to current Data Bank (DB)

.ACCU 8
.INDEX 16

PrintF:
	ply								; pull return address from stack, which is actually the start of our string (minus one)
	iny								; make y = start of string
	php

	Accu8
	Index16

PrintFLoop:
	lda	[<DP2.TextStringPtr], y					; read next character in string
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
	cmp	#'%'
	beq	PrintFFormat						; handle format character
	cmp	#'\'
	beq	PrintFControl						; handle control character

NormalPrint:
	ldx	LO8.Routine_FillTextBuffer
	jsr	(FillTextBuffer, x)					; write character to text buffer

	bra	PrintFLoop

PrintFDone:
	plp
	phy								; push return address (-1) onto stack

	rtl



PrintFControl:
	lda	[<DP2.TextStringPtr], y					; read control character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer

@cn:	cmp	#'n'
	bne	@ct

	AccuIndex16

	lda	<DP2.TextCursor						; get current position
	clc
;	adc	#$0020							; move to the next line (8-bit tilemaps)
;	and	#$FFE0
	adc	#$0040							; move to the next line (16-bit tilemaps)
	and	#$FFC0
	sta	<DP2.TextCursor						; save new position

	Accu8

	stz	<DP2.HiResPrintMon					; reset BG monitor value
	bra	PrintFLoop

@ct:
	cmp	#'t'
	bne	@defaultC

	AccuIndex16

	lda	<DP2.TextCursor						; get current position
	clc
	adc	#$0008							; move to the next tab
	and	#$FFF8
;	adc	#$0004							; smaller tab size (4 tiles = 8 hi-res characters)
;	and	#$FFFC
;	adc	#$0002							; use this instead for even smaller tabs
;	and	#$FFFE
	sta	<DP2.TextCursor						; save new position

	Accu8

	stz	<DP2.HiResPrintMon					; reset BG monitor value
	bra	PrintFLoop

@defaultC:
	lda	#'\'							; normal backslash
	bra	NormalPrint



PrintFFormat:
	lda	[<DP2.TextStringPtr], y					; read format character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
	phy								; preserve current format string pointer

@sf:
	cmp	#'s'
	bne	@df
	ldy	#0
-	lda	[<DP2.DataAddress], y					; read sub string character
	beq	@sfDone							; check for NUL terminator
	iny								; increment input pointer
	ldx	LO8.Routine_FillTextBuffer
	jsr	(FillTextBuffer, x)					; write sub string character to text buffer

	bra	-

@sfDone:
	ply								; restore original string pointer
	bra	PrintFLoop

@df:
	cmp	#'d'
	bne	@bf
	jsl	PrintInt16						; print 16-bit integer

	ply								; restore original string pointer
	bra	PrintFLoop

@bf:
	cmp	#'b'
	bne	@xf
	ldy	#0
	lda	[<DP2.DataAddress], y					; read byte to print
	jsl	PrintInt8						; print 8-bit integer

	ply								; restore original string pointer
	jmp	PrintFLoop

@xf:
	cmp	#'x'
	bne	@defaultF
	ldy	#0
	lda	[<DP2.DataAddress], y					; read hex byte to print
	jsl	PrintHex8						; print 8-bit hex integer

	ply								; restore original string pointer
	jmp	PrintFLoop

@defaultF:
	ply								; restore original string pointer
	lda	#'%'
	jmp	NormalPrint



;PrintFtemp:
;	ldx	#LO8.TempString
;	stx	<DP2.TextStringPtr
;	lda	#$7E
;	sta	<DP2.TextStringBank

SimplePrintF:								; expects 24-bit pointer to string in DP2.TextStringPtr
	ldy	#0

@Loop:
	lda	[<DP2.TextStringPtr], y					; read next string character
	beq	@Done							; check for NUL terminator
	iny								; increment input pointer
	ldx	LO8.Routine_FillTextBuffer
	jsr	(FillTextBuffer, x)					; write character to text buffer

	bra	@Loop

@Done:

	rts



FillTextBufferBG3:							; expectations: A = 8 bit, X/Y = 16 bit
	ldx	<DP2.TextCursor
	sta	RAM.BG3Tilemap, x					; write character to the BG3 text buffer
	inx								; advance text cursor position
	inx
	stx	<DP2.TextCursor

	rts



; Mode-5-based fixed-width, fixed-length printing (unused yet, possibly for menu items)
PrintHiResFixedLenFWF:
	php

	Accu8
	Index16

	ldy	#0

PrintHiResFixedLenLoop:
	lda	[<DP2.TextStringPtr], y					; read next format string character
	iny								; increment input pointer
	jsr	FillTextBufferMode5					; write character to text buffer

	dec	<DP2.HiResPrintLen
	bne	PrintHiResFixedLenLoop

PrintHiResFixedLenDone:
	plp

	rts



; This alternately writes doubled values of ASCII characters to the
; BG1/BG2 text buffer while keeping track of which BG to use next via
; the BGPrintMon variable (start = $00 = BG1, $01 = BG2).

; The ASCII values need to be doubled because both fonts have empty 8x8
; tiles before or after each character. By not advancing the text cursor
; position when using BG1, all of this makes it possible to work around
; Mode 5's 16×8 tile size limitation, with the main drawback that the
; text engine uses up both available BG layers.

; In: A -- ASCII code to print
; Out: none
; Modifies: P

FillTextBufferMode5:							; expectations: A = 8 bit, X/Y = 16 bit
	asl	a							; character code × 2 so it matches hi-res font tile location
	xba								; preserve character code
	ldx	<DP2.TextCursor
	lda	<DP2.HiResPrintMon
	bne	@BG2							; if BG monitor value is not zero, use BG2

@BG1:
	inc	<DP2.HiResPrintMon					; otherwise, change value and use BG1
	xba								; restore character code
	sta	RAM.BG1Tilemap1, x					; write it to the BG1 text buffer
	bra	@Done							; ... and done

@BG2:
	stz	<DP2.HiResPrintMon					; reset BG monitor value
	xba								; restore character code
	sta	RAM.BG2Tilemap1, x					; write it to the BG2 text buffer
	inx								; ... and advance text cursor position
	inx
	stx	<DP2.TextCursor

@Done:

	rts



FillTextBuffer:
	.DW FillTextBufferBG3
	.DW FillTextBufferMode5



; SPRITE-BASED PRINTING
; --------------------------------------------------------------------------------------------------

; Sprite-based "VWF" text printing by Ramsis.
; Caveat #1: Max. length of message(s) is 32 characters at a time.
; Caveat #2: No support for control characters.

PrintSpriteText:
	ply								; pull string start address (minus one) from stack
	iny								; make y = start of string
	php

	Accu8
	Index16

	ldx	<DP2.SpriteTextMon					; start where there is some unused sprite text buffer

@PrintSpriteTextLoop:
	lda	[<DP2.TextStringPtr], y					; read next string character
	beq	@PrintSpriteTextDone					; check for NUL terminator
	iny								; increment input pointer
	phy
	pha

	Accu16

	and	#$00FF							; clear high byte
	tay

	Accu8

	lda	<DP2.TextCursor
	sta	RAM.SpriteDataArea.Text, x				; X
	phx								; preserve text buffer index
	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	SRC_FWT_HUD, x						; advance cursor position as per font width table entry
	sta	<DP2.TextCursor
	plx								; restore text buffer index
	inx
	inx								; skip 9th bit of X coordinate and sprite size
	lda	<DP2.TextCursor+1
	sta	RAM.SpriteDataArea.Text, x				; Y
	inx
	pla
	ply
	sta	RAM.SpriteDataArea.Text, x				; tile num
	inx
	lda	<DP2.SpriteTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	RAM.SpriteDataArea.Text, x				; tile attributes
	inx
	cpx	#$0080							; if sprite buffer is full, reset
	bcc	+
	ldx	#$0000
+	stx	<DP2.SpriteTextMon					; keep track of sprite text buffer filling level
	bra	@PrintSpriteTextLoop

@PrintSpriteTextDone:
	plp
	phy								; push return address (-1) onto stack

	rtl



; NUMBER PRINTING FUNCTIONS
; --------------------------------------------------------------------------------------------------

;PrintHex8 -- Read an 8-bit value from Accu and print it in hex on the screen

PrintHex8:								; assumes 8b mem, 16b index
	pha
	shr	4
	jsr	PrintHexNibble

	pla
	and	#$0F
	jsr	PrintHexNibble

	rtl	

PrintHexNibble:								; assumes 8b mem, 16b index
	cmp	#$0A
	bcs	@nletter
	clc
	adc	#'0'
	ldx	LO8.Routine_FillTextBuffer
	jsr	(FillTextBuffer, x)					; write it to the text buffer

	rts

@nletter:
	clc
	adc	#'A'-10		
	ldx	LO8.Routine_FillTextBuffer
	jsr	(FillTextBuffer, x)					; write it to the text buffer

	rts



;PrintInt8 -- Read an 8-bit value from Accu and print it in decimal on the screen

PrintInt8:								; assumes 8b mem, 16b index
	sta	WRDIVL
	lda	#$00
	sta	WRDIVH
	PHA
	BRA	DivLoop							; within PrintInt16



;PrintInt16 -- Read a 16-bit value in DP2.DataAddress and print it to the screen

PrintInt16:								; assumes 8b mem, 16b index
	lda	#$00
	pha								; push $00
	ldy	#0
	lda	[<DP2.DataAddress], y					; read low byte
	sta	WRDIVL							; DIVC.l
	iny
	lda	[<DP2.DataAddress], y					; read high byte
	sta	WRDIVH							; DIVC.h  ... DIVC = [Y]

DivLoop:
	lda	#$0A	
	sta	WRDIVB							; DIVB = 10 --- division starts here (need to wait 16 cycles)
	NOP								; 2 cycles
	NOP								; 2 cycles
	NOP								; 2 cycles
	PHA								; 3 cycles
	PLA								; 4 cycles
	lda	#'0'							; 2 cycles
	CLC								; 2 cycles
	adc	RDMPYL							; A = '0' + DIVC % DIVB
	PHA								; push character
	lda	RDDIVL							; Result.l -> DIVC.l
	sta	WRDIVL
	beq	_Low_0
	lda	RDDIVH							; Result.h -> DIVC.h
	sta	WRDIVH
	BRA	DivLoop

_Low_0:
	lda	RDDIVH							; Result.h -> DIVC.h
	sta	WRDIVH
	beq	IntPrintLoop						; if ((Result.l==$00) and (Result.h==$00)) then we're done, so print
	BRA	DivLoop

IntPrintLoop:								; until we get to the end of the string...
	PLA								; keep pulling characters and printing them
	beq	_EndOfInt
	ldx	LO8.Routine_FillTextBuffer
	jsr	(FillTextBuffer, x)					; write them to the text buffer

	BRA	IntPrintLoop

_EndOfInt:

	rtl



; SPRITE-BASED NUMBERS
; --------------------------------------------------------------------------------------------------

PrintSpriteHex8:
	pha
	shr	4
	jsr	PrintSpriteHexNibble

	pla
	and	#$0F
	jsr	PrintSpriteHexNibble

	rtl



PrintSpriteHexNibble:							; assumes 8b mem, 16b index
	cmp	#$0A
	bcs	@nletter
	clc
	adc	#'0'
	jsr	FillSpriteTextBuf					; write it to the text buffer

	rts

@nletter:
	clc
	adc	#'A'-10		
	jsr	FillSpriteTextBuf					; write it to the text buffer

	rts



FillSpriteTextBuf:
	php
	ldx	<DP2.SpriteTextMon					; start where there is some unused sprite text buffer
	pha

	Accu16

	and	#$00FF							; clear high byte
	tay

	Accu8

	lda	<DP2.TextCursor
	sta	RAM.SpriteDataArea.Text, x				; X
	phx								; preserve tilemap index
	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	SRC_FWT_HUD, x						; advance cursor position as per font width table entry
	sta	<DP2.TextCursor
	plx								; restore tilemap index
	inx
	inx								; skip 9th bit of X coordinate and sprite size
	lda	<DP2.TextCursor+1
	sta	RAM.SpriteDataArea.Text, x				; Y
	inx
	pla
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	RAM.SpriteDataArea.Text, x				; tile num
	inx
	lda	<DP2.SpriteTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	RAM.SpriteDataArea.Text, x				; tile attributes
	inx
	cpx	#$0080							; if sprite buffer is full, reset
	bcc	+
	ldx	#$0000
+	stx	<DP2.SpriteTextMon					; keep track of sprite text buffer filling level

	plp

	rts



; CLEARING FUNCTIONS
; --------------------------------------------------------------------------------------------------

ClearHUD:
	Accu16

	ldx	#0
-	lda	#$00F0
	sta	RAM.SpriteDataArea.HUD_TextBox, x			; X (9 bits), sprite size
	inx
	inx

	Accu8

	lda	#$F0
	sta	RAM.SpriteDataArea.HUD_TextBox, x			; Y
	inx

	Accu16

	lda	#0
	sta	RAM.SpriteDataArea.HUD_TextBox, x			; tile no. = 0 (empty), attributes
	inx
	inx
	cpx	#180							; 180 / 5 = 36 tiles
	bne	-

	ldx	#0
-	lda	#$00F0
	sta	RAM.SpriteDataArea.Text, x				; X (9 bits), sprite size
	inx
	inx

	Accu8

	lda	#$F0
	sta	RAM.SpriteDataArea.Text, x				; Y
	inx

	Accu16

	lda	#0
	sta	RAM.SpriteDataArea.Text, x				; tile no. = 0 (empty), attributes
	inx
	inx
	cpx	#160							; 160 / 5 = 32 tiles
	bne	-

	stz	<DP2.SpriteTextMon					; reset buffer monitor

	Accu8

	rts



; EOF
