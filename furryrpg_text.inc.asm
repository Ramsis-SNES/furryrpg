;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** TEXT ENGINE ***
;
;==========================================================================================



; *********************** Dialogue test section ************************

DialogueTest:
	.ACCU 8
	.INDEX 16

	lda	#$80							; enter forced blank
	sta	RAM_INIDISP

	ResetSprites

	wai

	DisableIRQs

;	.IFNDEF NOMUSIC
;		jsl	music_stop					; stop music in case it's playing

;		stz	MSU_CONTROL					; stop MSU1 track in case it's playing
;	.ENDIF

	stz	<DP2.HDMA_Channels					; disable HDMA
	stz	HDMAEN
	ldx	#loword(RAM.BG3Tilemap)					; clear BG3 text
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 1024

	ldx	#loword(RAM.HDMA_BackgrPlayfield)			; set WRAM address to playfield HDMA background
	stx	WMADDL
	stz	WMADDH							; array is in bank $7E

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 704				; clear HDMA table in case it was used before

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	jsr	LoadTextBoxBorderTiles					; prepare text box
	jsr	MakeTextBoxTilemapBG1
	jsr	MakeTextBoxTilemapBG2

	Accu16

;	lda	#0							; make text box background black in case it was used before
;	ldx	#0
;-	sta	RAM.HDMA_BackgrTextBox, x
;	inx
;	inx
;	cpx	#192
;	bne	-

	ldx	#0							; put HDMA table into WRAM
-	lda.l	SRC_HDMA_ResetBGScroll, x
	sta	LO8.HDMA_BG_Scroll, x
	inx
	inx
	cpx	#16
	bne	-

	Accu8



; HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	DMAP3
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	BBAD3
	ldx	#LO8.HDMA_ColorMath
	stx	A1T3L
	lda	#$7E							; table in WRAM expected
	sta	A1B3



; HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	DMAP4
	lda	#$0D							; PPU reg. $210D
	sta	BBAD4
	ldx	#LO8.HDMA_BG_Scroll
	stx	A1T4L
	lda	#$7E
	sta	A1B4



; HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210F, 2 bytes --> $2110)
	sta	DMAP5
	lda	#$0F							; PPU reg. $210F
	sta	BBAD5
	ldx	#LO8.HDMA_BG_Scroll
	stx	A1T5L
	lda	#$7E
	sta	A1B5



; Set up RAM mirror registers
	lda	#$01|$08						; set BG Mode 1, BG3 priority
	sta	RAM_BGMODE
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	RAM_OBSEL
	lda	#$50							; VRAM address for BG1 tilemap: $5000, size: 32×32 tiles
	sta	RAM_BG1SC
	lda	#$58							; VRAM address for BG2 tilemap: $5800, size: 32×32 tiles
	sta	RAM_BG2SC
	lda	#$48							; VRAM address for BG3 tilemap: $4800
	sta	RAM_BG3SC
	lda	#$00							; VRAM address for BG1 and BG2 character data: $0000
	sta	RAM_BG12NBA
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA



; Misc. settings
	lda	#%00010111						; turn on BG1/2/3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TM

	SetNMI	kNMI_Area						; use area NMI handler

	Accu16

	lda	#228							; dot number for interrupt (256 = too late, 204 = too early)
	sta	HTIMEL
	lda	#224							; scanline number for interrupt (last scanline for now)
	sta	VTIMEL

	Accu8

	sta	<DP2.TextBoxVIRQ					; save scanline no.

	SetIRQ	kVIRQ_Area						; use area IRQ handler

	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable Vblank NMI + Auto Joypad Read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli								; re-enable interrupts

	PrintString	2, 2, kTextBG3, "DIALOGUE TEST"			; print some on-screen help
	PrintString	4, 2, kTextBG3, "Dpad r/l: next/prev string"
	PrintString	5, 12, kTextBG3, "(hold Y for speed)"
	PrintString	6, 2, kTextBG3, "Dpad up/dn: change language"
	PrintString	7, 2, kTextBG3, "R/L: +/-50 strings"
	PrintString	8, 2, kTextBG3, "A: make selection"

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	<DP2.DMA_Updates
	tsb	<DP2.DMA_Updates+1

	WaitFrames	4						; give some time for screen refresh

	lda	#$0F							; turn screen back on
	sta	RAM_INIDISP
	jsr	InitDialogTextBox					; initialize text box

@DialogueTestLoop:
	PrintString	10, 2, kTextBG3, "GameLanguage  = $"		; print some text-box-related variables
	PrintHexNum	<DP2.GameLanguage

	PrintString	11, 2, kTextBG3, "TextPointerNo = $"
	PrintHexNum	<DP2.TextPointerNo+1
	PrintHexNum	<DP2.TextPointerNo

	lda	#%00010000						; make sure BG3 lo/hi tilemaps get updated
	tsb	<DP2.DMA_Updates
	tsb	<DP2.DMA_Updates+1

	WaitFrames	1

	lda	LO8.NMITIMEN
	sta	NMITIMEN

	bit	<DP2.TextBoxStatus					; check if text box is active (MSB set)
	bpl	@NoTextBox
	jsr	ProcDialogTextBox

@NoTextBox:



; Check for dpad up = next language
	lda	<DP2.Joy1New+1
	and	#%00001000
	beq	@DpadUpDone
	lda	<DP2.TextBoxSelection
	and	#$0F
	bne	@DpadUpDone
	lda	#kLang_Ger
	sta	<DP2.GameLanguage
	jsr	InitDialogTextBox@NextDialog

@DpadUpDone:



; Check for dpad down = previous language
	lda	<DP2.Joy1New+1
	and	#%00000100
	beq	@DpadDownDone
	lda	<DP2.TextBoxSelection
	and	#$0F
	bne	@DpadUpDone
	lda	#kLang_Eng
	sta	<DP2.GameLanguage
	jsr	InitDialogTextBox@NextDialog

@DpadDownDone:



; Check for Y + dpad right = fast forward text pointers
	lda	<DP2.Joy1Press+1					; Y pressed, check for dpad right
	and	#%01000001
	cmp	#%01000001
	beq	@NextTextPointer



; Check for Y + dpad left = fast rewind text pointers
	lda	<DP2.Joy1Press+1					; Y pressed, check for dpad right
	and	#%01000010
	cmp	#%01000010
	beq	@PrevTextPointer



; Check for dpad left = previous text pointer
	lda	<DP2.Joy1New+1
	and	#%00000010
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

	jsr	InitDialogTextBox@NextDialog

@DpadLeftDone:



; Check for dpad right = next text pointer
	lda	<DP2.Joy1New+1
	and	#%00000001
	beq	@DpadRightDone

@NextTextPointer:
	Accu16

	lda	<DP2.TextPointerNo					; increment text pointer
	clc
	adc	#1
	cmp	#_sizeof_PTR_DialogEng/2
	bcc	+
	lda	#_sizeof_PTR_DialogEng/2-1
+	sta	<DP2.TextPointerNo

	Accu8

	jsr	InitDialogTextBox@NextDialog

@DpadRightDone:



; Check for A button
	bit	<DP2.Joy1New
	bpl	@AButtonDone
	bit	<DP2.TextBoxStatus					; check if text box is active (MSB set)
	bmi	@AButtonDone
	jsr	InitDialogTextBox@NextDialog

@AButtonDone:



; Check for L button = text pointers -= 50
	lda	<DP2.Joy1New
	and	#%00100000
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

	jsr	InitDialogTextBox@NextDialog

@LButtonDone:



; Check for R button = text pointers += 50
	lda	<DP2.Joy1New
	and	#%00010000
	beq	@RButtonDone

	Accu16

	lda	<DP2.TextPointerNo					; increment text pointer
	cmp	#_sizeof_PTR_DialogEng/2-50
	bcc	+
	lda	#_sizeof_PTR_DialogEng/2-1
	bra	++
+;	clc								; never mind, carry is already clear
	adc	#50
++	sta	<DP2.TextPointerNo

	Accu8

	jsr	InitDialogTextBox@NextDialog

@RButtonDone:



; Check for Start button = return to debug menu
	lda	<DP2.Joy1Press+1
	and	#%00010000
	beq	@StartButtonDone
	stz	<DP2.TextBoxStatus					; reset text box status
	lda	#$80							; enter forced blank
	sta	RAM_INIDISP
	lda	#%00110000						; clear IRQ enable bits
	trb	LO8.NMITIMEN

	WaitFrames	1

	jmp	DebugMenu

@StartButtonDone:

	jmp	@DialogueTestLoop



; ************************ Dialogue text engine ************************

LoadTextBoxBorderTiles:
	.ACCU 8
	.INDEX 16

	ldx	#VRAM_BG2_Tiles + $80					; set VRAM address for BG2 font tiles (+ 16 empty tiles)
	stx	VMADDL
	ldx	#$0010							; upper left corner (1) (see font GFX for tile numbers, whereby 1 tile = $10 bytes)
	jsr	WriteFontTileToVRAM

	ldx	#$0020							; upper left corner (2) / upper border (1)
	jsr	WriteFontTileToVRAM

	ldx	#$0020							; upper border (2) / upper right corner (1)
	jsr	WriteFontTileToVRAM

	ldx	#$0030							; upper right corner (2)
	jsr	WriteFontTileToVRAM

	ldx	#$0040							; left border (1)
	jsr	WriteFontTileToVRAM

	ldx	#$0200							; left border (2) / right border (1) (can be any empty tile, using space tile for now)
	jsr	WriteFontTileToVRAM

	ldx	#$0050							; right border (2)
	jsr	WriteFontTileToVRAM

	ldx	#$0060							; lower left corner (1)
	jsr	WriteFontTileToVRAM

	ldx	#$0070							; lower left corner (2) / lower border (1)
	jsr	WriteFontTileToVRAM

	ldx	#$0070							; lower border (2) / lower right corner (1)
	jsr	WriteFontTileToVRAM

	ldx	#$0080							; lower right corner (2)
	jsr	WriteFontTileToVRAM

	ldx	#$0000							; black tile (1) (for left and right screen edges)
	jsr	WriteFontTileToVRAM

	ldx	#$0000							; black tile (2)
	jsr	WriteFontTileToVRAM

	rts



InitDialogTextBox:

; Prepare selection bar & set shadow PPU regs/misc. parameters
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathDialogSel, x
	sta	LO8.HDMA_ColorMath, x
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

	Accu16

	lda	#%0000001100000011					; turn on BG1/2 only (i.e., disable BG3 and sprites) for text box
	sta	LO8.TextBox_TSTM
	lda	LO8.HDMA_BG_Scroll+1					; copy BG scroll reg values to second half of playfield
	sta	LO8.HDMA_BG_Scroll+6
	lda	LO8.HDMA_BG_Scroll+3
	sta	LO8.HDMA_BG_Scroll+8
;	stz	LO8.HDMA_BG_Scroll+11					; reset scrolling parameters for text box area
;	lda	#$00FF
;	sta	LO8.HDMA_BG_Scroll+13

	Accu8

	lda	#97							; set initial size of playfield BG to fill the whole screen (127 + 97 = 224)
	sta	LO8.HDMA_BG_Scroll+5
	stz	LO8.HDMA_BG_Scroll+10

@NextDialog:
;	lda	#%00110100						; (re)activate HDMA ch. 2 (backdrop color), 4, 5 (BG scrolling regs)
;	tsb	<DP2.HDMA_Channels
	lda	<DP2.HDMA_Channels
	and	#%11110111						; disable HDMA channel 3 (color math) in case of previously active selection // FIXME for CM on playfield!!
	ora	#%00110100						; (re)activate HDMA ch. 2 (backdrop color), 4, 5 (BG scrolling regs)
	sta	<DP2.HDMA_Channels
	lda	#%00110000						; (re)enable IRQ at H=$4207 and V=$4209
	tsb	LO8.NMITIMEN
	lda	#%00000010						; set "clear text box" flag in case it was used before
	sta	<DP2.TextBoxStatus
	stz	<DP2.TextBoxSelection					; reset selection bits

	WaitFrames	1

	lda	#:PTR_DialogEng
	clc								; add language constant to get the correct text bank
	adc	<DP2.GameLanguage
	sta	<DP2.DiagStringBank
	lda	<DP2.GameLanguage					; check language again for the right pointer table
	bne	+

	Accu16

	lda	<DP2.TextPointerNo
	asl	a
	tax
	lda.l	PTR_DialogEng, x					; DP2.GameLanguage is 0 --> English
	bra	++

+	;cmp	#kLang_Ger						; German language selected?
;	bne	Somewhere						; for even more languages/text banks

	Accu16

	lda	<DP2.TextPointerNo
	asl	a
	tax
	lda.l	PTR_DialogGer, x					; DP2.GameLanguage is 1 --> German
++	sta	<DP2.DiagStringAddress
	stz	<DP2.DiagStringPos					; reset string position/index

	Accu8

	lda	#%10000000						; set "text box active" flag
	sta	<DP2.TextBoxStatus

	rts



ProcDialogTextBox:							; if the text box is active, then this routine must be called once per frame
	bit	<DP2.TextBoxStatus					; check status
	bvs	@Wait							; "wait" flag set or not?
	lda	<DP2.TextBoxStatus					; check status again
	bit	#%00000100						; "kill text box" flag set?
	bne	@KillTextBox

@CurrentString:
	lda	<DP2.DiagStringPos+1					; text box opening animation should only kick in after portrait and BG control codes have been processed, so check string position
	bne	+							; if high byte <> 0, don't bother, and continue processing string
	lda	<DP2.DiagStringPos
	cmp	#6							; string pointer variable (16-bit) must be >=6
	bcc	+
	lda	<DP2.TextBoxVIRQ					; before printing the string, make sure the opening animation has completed
	cmp	#176
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
	lda	#%01000000						; A pressed, clear "wait" flag
	trb	<DP2.TextBoxStatus
	bra	@TextBoxDone

@KillTextBox:
	lda	<DP2.TextBoxVIRQ
	cmp	#224
	beq	+
	jsr	TextBoxAnimationClose
	bra	@TextBoxDone

+	lda	#%00110000						; text box completely removed, clear IRQ enable bits
	trb	LO8.NMITIMEN
	lda	#%00110100						; deactivate used HDMA channels
	trb	<DP2.HDMA_Channels
	lda	#%00000010						; set "clear text box" flag only
	sta	<DP2.TextBoxStatus

;	Accu16

;	lda	LO8.HDMA_BG_Scroll+1					; restore scrolling parameters // possibly needed on areas with vertical scrolling
;	sta	LO8.HDMA_BG_Scroll+11
;	lda	LO8.HDMA_BG_Scroll+3
;	sta	LO8.HDMA_BG_Scroll+13

;	Accu8

@TextBoxDone:

	rts



TextBoxHandleSelection:
	lda	<DP2.HDMA_Channels					; check if HDMA channel 3 (color math) is already enabled
	and	#%00001000
	bne	@WaitForInput



; Determine text box line the selection starts on, and pre-load Accu with appropriate multiple of 8, i.e. Accu = (sel_start_line - 1) * 8, using a bit-manipulating loop
	lda	#0							; pre-load Accu with 0, use RSH to find the line the selection starts on
	xba								; preserve inital value
	lda	<DP2.TextBoxSelection
-	lsr	a							; test DP2.TextBoxSelection bits from LSB onwards
	xba								; switch back to target Accu value
	bcs	+							; jump out as soon as first set bit found
	adc	#8							; bit was clear, add 8 to target Accu value // carry always clear at this point, so no need for clc before the adc
	xba								; switch back to next-higher selection bit
	bra	-							; rinse and repeat until first set bit found

+	clc
	adc	#kTextBoxColMath1st
	sta	LO8.HDMA_ColorMath+3
	sta	<DP2.TextBoxSelMin
	stz	<DP2.TextBoxSelMax
	lda	<DP2.TextBoxSelection
	lsr	a							; count no. of selection options available (4 max.)
	bcc	+
	inc	<DP2.TextBoxSelMax
+	lsr	a
	bcc	+
	inc	<DP2.TextBoxSelMax
+	lsr	a
	bcc	+
	inc	<DP2.TextBoxSelMax
+	lsr	a
	bcc	+
	inc	<DP2.TextBoxSelMax
+	lda	<DP2.TextBoxSelMax					; DP2.TextBoxSelMax = (no. of options - 1) * 8 + DP2.TextBoxSelMin
	dec	a
	asl	a
	asl	a
	asl	a
	clc
	adc	<DP2.TextBoxSelMin
	sta	<DP2.TextBoxSelMax
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	<DP2.HDMA_Channels
	bra	@JumpOut						; wait for selection bar to appear before checking buttons on next iteration



@WaitForInput:

; Check for dpad up
	lda	<DP2.Joy1New+1
	and	#%00001000
	beq	@DpadUpDone

	lda	LO8.HDMA_ColorMath+3					; move selection bar 8 scanlines up
	sec
	sbc	#8
	cmp	<DP2.TextBoxSelMin
	bcs	+
	lda	<DP2.TextBoxSelMin
+	sta	LO8.HDMA_ColorMath+3

@DpadUpDone:



; Check for dpad down
	lda	<DP2.Joy1New+1
	and	#%00000100
	beq	@DpadDownDone

	lda	LO8.HDMA_ColorMath+3					; move selection bar 8 scanlines down
	clc
	adc	#8
	cmp	<DP2.TextBoxSelMax
	bcc	+
	lda	<DP2.TextBoxSelMax
+	sta	LO8.HDMA_ColorMath+3

@DpadDownDone:



; Check for A button = make selection
	lda	<DP2.Joy1New
	bpl	@JumpOut
	lda	LO8.HDMA_ColorMath+3					; determine selection made by checking position of selection bar
	sec
	sbc	#kTextBoxColMath1st					; subtract start of 1st line
	lsr	a							; divide by 8 as each line is 8 pixels high
	lsr	a
	lsr	a

	Accu16								; Accu A contains a value of $00, $01, $02, or $03 at this point

	and	#$00FF							; clear garbage in high byte
	tax								; and use as a counter

	Accu8

	lda	#%00010000						; assume selection made on line 1 for now = set bit 4 (a)
-	dex								; decrement counter
	bmi	+							; counter was zero --> don't shift bit (any more)
	asl	a							; shift selection bit as many times as needed
	bra	-

+	sta	<DP2.TextBoxSelection					; store user selection bit in upper nibble (bits 0-3 clear)
	lda	#%00001000						; disable HDMA channel 3 (color math) // FIXME for CM on playfield!!
	trb	<DP2.HDMA_Channels

@JumpOut:

	rts



ProcessNextText:
	Accu16

@NextStringByte:
	lda	<DP2.DiagStringPos
	tay								; transfer string position to Y index
	inc	a							; increment to next ASCII string character
	sta	<DP2.DiagStringPos					; (N.B.: inc a, sta dp is 1 cycle faster than inc dp)

	Accu8

	lda	[<DP2.DiagStringAddress], y				; read current byte of string
	beq	@EndOfString						; NUL terminator, stop processing string
	cmp	#$FF							; check for control code, this hex value has to match the upper byte of the two-byte entries starting from $FF00 in tbl_dialog_*.inc.asm
	beq	@ControlCode

@NormalText:								; process normal text
	Accu16

	and	#$00FF							; remove garbage in high byte
	sta	<DP2.DiagASCIIChar					; save ASCII char no.
	bit	<DP2.DiagTextEffect-1					; put MSB of DP2.DiagTextEffect (an 8-bit variable) into MSB of (currently 16-bit) accumulator
	bmi	+							; MSB set --> use routine for bold font
	jsr	ProcessVWFTiles						; otherwise, use normal font routine
	bra	++

+	jsr	ProcessVWFTilesBold

++	Accu16

	lda	<DP2.VWF_BufferIndex					; check if 2 buffer tiles full
	cmp	#32							; 2 tiles × 16 = buffer index
	bcc	@NextStringByte						; buffer not full yet, continue reading string // ADDME/ADDFEATURE @JumpOut instead for slower text speed

	Accu8

	lda	#%00000001						; set "VWF buffer full" bit
	tsb	<DP2.TextBoxStatus

	WaitFrames	1

	Accu16

	FlushVWFTileBuffer2

	IncDiagTileDataCounter						; increment tile data counter to next 16×8 tile

	Accu8

	bra	@JumpOut

@ControlCode:
	Accu16

	lda	<DP2.DiagStringPos					; increment string position to actual control code byte
	tay
	inc	a
	sta	<DP2.DiagStringPos
	lda	[<DP2.DiagStringAddress], y				; read control code
	and	#$00FF							; clear garbage in high byte
	asl	a							; use control code as jump index
	tax

	Accu8

	jmp	(PTR_ProcessDiagCC, x)					; control codes do rts, where applicable

@EndOfString:								; CC_End encountered
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
	Accu16								; flush buffer and reset status parameters

	lda	<DP2.VWF_BitsUsed					; check two variables for a non-zero value
	ora	<DP2.VWF_BufferIndex
	beq	+

	Accu8								; if either (bit counter <> 0) or (VWF buffer index <> 0) ...

	lda	#%00000001						; ... set "VWF buffer full" bit
	tsb	<DP2.TextBoxStatus

	WaitFrames	1

	Accu16

	FlushVWFTileBuffer2

+	Accu8

	lda	#%01000100						; set "wait" and "kill text box" status flags
	tsb	<DP2.TextBoxStatus
	stz	<DP2.DiagTileDataCounter				; clear tile data counter
	stz	<DP2.DiagTileDataCounter+1

@JumpOut:

	rts



PTR_ProcessDiagCC:							; self-reminder: Order of table entries has to match lower byte of the two-byte entries starting from $FF00 in tbl_dialog_*.inc.asm
	.DW Process_CC_BoxBG
	.DW Process_CC_ClearTextBox
	.DW Process_CC_Indent
	.DW Process_CC_Jump
	.DW Process_CC_NewLine
	.DW Process_CC_Portrait
	.DW Process_CC_Selection
	.DW Process_CC_SubHex
	.DW Process_CC_SubInt8
	.DW Process_CC_SubInt16
	.DW Process_CC_SubString
	.DW Process_CC_ToggleBold



Process_CC_BoxBG:
	Accu16

	lda	<DP2.DiagStringPos					; increment string position to number of BG color gradient
	tay
	inc	a
	sta	<DP2.DiagStringPos

	Accu8

	lda	[<DP2.DiagStringAddress], y				; read BG color gradient number
	ora	#$80							; set "change text box background" bit
	sta	<DP2.TextBoxBG

	rts								; aka bra/jmp ProcessNextText@JumpOut



Process_CC_ClearTextBox:
	Accu16

	lda	<DP2.VWF_BitsUsed					; check two variables for a non-zero value
	ora	<DP2.VWF_BufferIndex
	beq	+

	Accu8								; if either (bit counter <> 0) or (VWF buffer index <> 0) ...

	lda	#%00000001						; ... set "VWF buffer full" bit
	tsb	<DP2.TextBoxStatus

	WaitFrames	1

	Accu16

	FlushVWFTileBuffer2

+	Accu8

	lda	#%01000010						; set "wait", "clear text box" status flags
	tsb	<DP2.TextBoxStatus
	stz	<DP2.DiagTileDataCounter				; reset tile counter
	stz	<DP2.DiagTileDataCounter+1

	rts



Process_CC_Indent:
	Accu16

	IncDiagTileDataCounter						; skip one 16×8 tile

	Accu8

	rts



Process_CC_Jump:
	iny								; increment string pointer to address of new string

	Accu16

	lda	[<DP2.DiagStringAddress], y				; read 16-bit address
	tax								; store temporarily in X (we still need to read the bank byte from [DiagStringAddress] so we can't overwrite it just yet)

	Accu8

	iny								; increment string pointer to bank of new string
	iny
	lda	[<DP2.DiagStringAddress], y				; read bank
	sta	<DP2.DiagStringBank					; store bank
	stx	<DP2.DiagStringAddress					; store address

	stz	<DP2.DiagStringPos					; reset string position/index
	stz	<DP2.DiagStringPos+1

	rts



Process_CC_NewLine:
	lda	#%00000001						; set "VWF buffer full" bit
	tsb	<DP2.TextBoxStatus

	WaitFrames	1

	Accu16

	FlushVWFTileBuffer2

	IncDiagTileDataCounter						; increment tile data counter before checking for current text box line, this ensures that very short strings (using less than a full 16×8 tile) on lines 2 or 3 won't get simply overwritten by succeeding dialogue

	lda	#46*8							; check what line we've been on: line 1?
	cmp	<DP2.DiagTileDataCounter				; (line 2 starts at 46*8)
	bcs	+
	lda	#92*8							; line 2?
	cmp	<DP2.DiagTileDataCounter				; (line 3 starts at 92*8)
	bcs	+
	lda	#138*8							; otherwise, go to line 4
+	sta	<DP2.DiagTileDataCounter
	stz	<DP2.VWF_BitsUsed					; lastly, reset VWF bit counter

	Accu8

	rts								; do nothing if carriage return requested after exactly 23 (16×8) tiles



Process_CC_Portrait:
	iny								; increment string pointer to portrait no.
	lda	[<DP2.DiagStringAddress], y				; read portrait no. (0-127)
	ora	#$80							; set "change portrait" bit
	sta	<DP2.TextBoxCharPortrait				; save to "change portrait" request variable

	Accu16

	inc	<DP2.DiagStringPos					; advance ASCII string position/index

	Accu8

	rts



Process_CC_Selection:
	Accu16

	lda	<DP2.DiagTileDataCounter				; selection required, check what line we've been on
	cmp	#46*8							; line 1?
	bcs	+
	lda	#%0000000000000001
	bra	++

+	cmp	#92*8							; line 2?
	bcs	+
	lda	#%0000000000000010
	bra	++

+	cmp	#138*8							; line 3?
	bcs	+
	lda	#%0000000000000100
	bra	++

+	lda	#%0000000000001000					; else, line 4

++	Accu8

	tsb	<DP2.TextBoxSelection

	rts



Process_CC_SubHex:
	iny								; increment string pointer to address of byte to print in hex
	lda	[<DP2.DiagStringAddress], y				; read address (low byte)
	sta	<DP2.DataAddress
	iny
	lda	[<DP2.DiagStringAddress], y				; high byte
	sta	<DP2.DataAddress+1
	iny
	lda	[<DP2.DiagStringAddress], y				; bank
	sta	<DP2.DataBank
	iny								; advance string pointer to byte after address
	sty	LO8.DiagStringPos					; save current string pointer



; Process actual hex byte, i.e. make it into a WRAM sub-string
	lda	[<DP2.DataAddress]					; load byte to print in hex
	pha
	lsr	a							; do upper nibble first
	lsr	a
	lsr	a
	lsr	a
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



Process_CC_SubInt8:
	iny								; increment string pointer to address of byte to print in hex
	lda	[<DP2.DiagStringAddress], y				; read address (low byte)
	sta	<DP2.DataAddress
	iny
	lda	[<DP2.DiagStringAddress], y				; high byte
	sta	<DP2.DataAddress+1
	iny
	lda	[<DP2.DiagStringAddress], y				; bank
	sta	<DP2.DataBank
	iny								; advance string pointer to byte after address
	sty	LO8.DiagStringPos					; save current string pointer



; Process actual byte, i.e. make dec number(s) into a WRAM sub-string
	lda	[<DP2.DataAddress]					; read byte
	sta	WRDIVL
	lda	#$00
	sta	WRDIVH
	PHA
	ldx	#0
	BRA	Process_CC_SubInt16@DivLoop



Process_CC_SubInt16:
	iny								; increment string pointer to starting address of bytes to print as 16-bit integer
	lda	[<DP2.DiagStringAddress], y				; read address (low byte)
	sta	<DP2.DataAddress
	iny
	lda	[<DP2.DiagStringAddress], y				; high byte
	sta	<DP2.DataAddress+1
	iny
	lda	[<DP2.DiagStringAddress], y				; bank
	sta	<DP2.DataBank
	iny								; advance string pointer to byte after address
	sty	LO8.DiagStringPos					; save current string pointer



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



Process_CC_SubString:
	iny								; increment string pointer to sub-string address
	lda	[<DP2.DiagStringAddress], y				; read sub-string address (low byte)
	sta	LO8.DiagSubStrAddress
	iny
	lda	[<DP2.DiagStringAddress], y				; high byte
	sta	LO8.DiagSubStrAddress+1
	iny
	lda	[<DP2.DiagStringAddress], y				; bank
	sta	LO8.DiagSubStrBank
	iny								; advance string pointer to byte after sub-string address
	sty	LO8.DiagStringPos					; save current string pointer

	Accu16

	stz	<DP2.DiagStringPos					; reset string offset so it starts reading the sub-string from the beginning
	lda	<DP2.DiagStringAddress					; save current string address
	sta	LO8.DiagStringAddress
	lda	LO8.DiagSubStrAddress					; load sub-string address
	sta	<DP2.DiagStringAddress

	Accu8

	lda	<DP2.DiagStringBank					; save current string bank
	sta	LO8.DiagStringBank
	lda	LO8.DiagSubStrBank					; load sub-string bank
	sta	<DP2.DiagStringBank
	lda	#%01000000						; set sub-string flag
	tsb	<DP2.DiagTextEffect

	rts



Process_CC_ToggleBold:
	lda	<DP2.DiagTextEffect
	eor	#%10000000						; toggle "bold text" bit
	sta	<DP2.DiagTextEffect

	rts



MakeTextBoxTilemapBG1:
	ldx	#VRAM_BG1_Tilemap3+kTextBox				; set VRAM address within new BG1 tilemap
	stx	VMADDL

	Accu16



; Line 1 of text box area
	lda	#0|$400							; patch up first tile ($00 = blank tile), palette no. 1
	sta	VMDATAL

	lda	#VRAM_Portrait/16|$400					; get tile no. for start of portrait
-	sta	VMDATAL
	inc	a
	inc	a
	cmp	#VRAM_Portrait/16+10|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+33						; end of line 1 + first tile of line 2
	bne	-



; Line 2 of text box area
	lda	#VRAM_Portrait/16+10|$400				; get next tile no.
-	sta	VMDATAL
	inc	a
	inc	a
	cmp	#VRAM_Portrait/16+20|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+32+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+65						; end of line 2 + first tile of line 3
	bne	-



; Line 3 of text box area
	lda	#VRAM_Portrait/16+20|$400				; get next tile no.
-	sta	VMDATAL
	inc	a
	inc	a
	cmp	#VRAM_Portrait/16+30|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+64+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+97						; end of line 3 + first tile of line 4
	bne	-



; Line 4 of text box area
	lda	#VRAM_Portrait/16+30|$400				; get next tile no.
-	sta	VMDATAL
	inc	a
	inc	a
	cmp	#VRAM_Portrait/16+40|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+96+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+129						; end of line 4 + first tile of line 5
	bne	-



; Line 5 of text box area
	lda	#VRAM_Portrait/16+40|$400				; get next tile no.
-	sta	VMDATAL
	inc	a
	inc	a
	cmp	#VRAM_Portrait/16+50|$400				; 5 (double) tiles done?
	bne	-

	ldx	#kTextBox+128+6
	lda	#0|$400							; blank tile
-	sta	VMDATAL
	inx
	cpx	#kTextBox+161						; end of line 5 + first tile of line 6
	bne	-



; Line 6 of text box area
	lda	#VRAM_Portrait/16+50|$400				; get next tile no.
-	sta	VMDATAL
	inc	a
	inc	a
	cmp	#VRAM_Portrait/16+60|$400				; 5 (double) tiles done?
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
; We use a fixed tilemap and generate Mode 5 compatible tile data based on the given text string on-the-fly in VRAM.

	ldx	#VRAM_BG2_Tilemap3+kTextBox				; set VRAM address within new BG2 tilemap
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
	inc	a							; tile no. += 2 (Mode 5 always shows two 8×8 tiles at once, resulting in a single 16×8 tile)
	inc	a
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
	inc	a							; tile no. += 2
	inc	a
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
	inc	a							; tile no. += 2
	inc	a
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
	inc	a							; tile no. += 2
	inc	a
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
	ldy	#0
-	lda.l	SRC_Font8x8, x						; first, copy font tile (font tiles sit on the "left")
	sta	VMDATAL
	inx
	inx
	iny
	cpy	#8							; 16 bytes (8 double bytes) per tile
	bne	-

	ldy	#0
-	stz	VMDATAL							; next, add 3 blank tiles (1 blank tile because Mode 5 forces 16×8 tiles
	iny								; and 2 blank tiles because BG1 is 4bpp)
	cpy	#24							; 16 bytes (8 double bytes) per tile
	bne	-

	cpx	#2048							; 2 KiB font done?
	bne	@BuildFontBG1

	Accu8

	rts



MakeMode5FontBG2:							; Expects VRAM address set to BG2 tile base
	Accu16

	ldx	#0

@BuildFontBG2:
	ldy	#0
-	stz	VMDATAL							; first, add 1 blank tile (Mode 5 forces 16×8 tiles,
	iny								; no more blank tiles because BG2 is 2bpp)
	cpy	#8							; 16 bytes (8 double bytes) per tile
	bne	-

	ldy	#0
-	lda.l	SRC_Font8x8, x						; next, copy 8×8 font tile (font tiles sit on the "right")
	sta	VMDATAL
	inx
	inx
	iny
	cpy	#8							; 16 bytes (8 double bytes) per tile
	bne	-

	cpx	#2048							; 2 KiB font done?
	bne	@BuildFontBG2

	Accu8

	rts



	.ACCU 16

ProcessVWFTiles:
	lda	<DP2.DiagASCIIChar					; ASCII char no. --> font tile no.
	asl	a							; value * 16 as 1 font tile = 16 bytes
	asl	a
	asl	a
	asl	a
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

ProcessVWFTilesBold:
	lda	<DP2.DiagASCIIChar					; ASCII char no. --> font tile no.
	asl	a							; value * 32 as 1 font tile = 16 bytes, and each character uses 2 tiles
	asl	a
	asl	a
	asl	a
	asl	a
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
	inc	a							; move table index to the right of current char
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x
	bne	+
	jmp	@VWFTilesDone2						; if entry is zero, jump out

+	Accu16

	lda	<DP2.VWF_BufferIndex					; we need to do a second half, check if 2 buffer tiles full first
	lsr	a							; buffer index / 16 = tile no.
	lsr	a
	lsr	a
	lsr	a
	cmp	#2
	bcc	+

	Accu8

	lda	#%00000001						; set "VWF buffer full" bit
	tsb	<DP2.TextBoxStatus

	WaitFrames	1

	Accu16

	FlushVWFTileBuffer2

	IncDiagTileDataCounter

+	Accu16								; finally, process right half of char graphics

	lda	<DP2.DiagASCIIChar					; ASCII char no. --> font tile no.
	asl	a							; value * 32 as 1 font tile = 16 bytes, and each character uses 2 tiles
	asl	a
	asl	a
	asl	a
	asl	a
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
	inc	a							; move table index to right half of current char
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



WriteFontTileToVRAM:
	Accu16

	ldy	#8							; 16 bytes (8 double bytes) per tile

-	lda.l	SRC_FontMode5, x					; copy font tile
	sta	VMDATAL
	inx
	inx
	dey
	bne	-

	Accu8

	rts



TextBoxAnimationClose:							; closing animation (scroll text box content out vertically below the screen)
	lda	<DP2.TextBoxVIRQ
	clc								; increase value to create the illusion that the text box "scrolls out" below the screen
	adc	#kTextBoxAnimSpd
	sta	<DP2.TextBoxVIRQ					; write new scanline for IRQ to fire
	sta	VTIMEL
	stz	VTIMEH

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

	lda	#$80							; set "new text box BG requested" flag, this is required as the flag is cleared during Vblank after a new gradient was loaded
	tsb	<DP2.TextBoxBG

	rts



TextBoxAnimationOpen:							; opening animation (scroll text box content in vertically from below)
	lda	<DP2.TextBoxVIRQ
	sec								; reduce value so the text box "scrolls" in from below the screen
	sbc	#kTextBoxAnimSpd
	sta	<DP2.TextBoxVIRQ
	sta	VTIMEL
	stz	VTIMEH

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

	lda	#$80							; set "new text box BG requested" flag, this is required as the flag is cleared during Vblank after a new gradient was loaded
	tsb	<DP2.TextBoxBG

	rts



; ******************** String processing functions *********************
;
; Code in this section based on code written by neviksti, (c) 2002

	.ACCU 8
	.INDEX 16

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
	jsr	(PTR_FillTextBuffer, x)					; write character to text buffer

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
	adc	#$0020							; move to the next line
	and	#$FFE0
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
;	adc	#$0008							; move to the next tab
;	and	#$FFF8
	adc	#$0004							; smaller tab size (4 tiles = 8 hi-res characters)
	and	#$fffc
;	adc	#$0002							; use this instead for even smaller tabs
;	and	#$fffe
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
	jsr	(PTR_FillTextBuffer, x)					; write sub string character to text buffer

	bra	-

@sfDone:
	ply								; restore original string pointer
	bra	PrintFLoop

@df:
	cmp	#'d'
	bne	@bf
	jsr	PrintInt16						; print 16-bit integer

	ply								; restore original string pointer
	bra	PrintFLoop

@bf:
	cmp	#'b'
	bne	@xf
	ldy	#0
	lda	[<DP2.DataAddress], y					; read byte to print
	jsr	PrintInt8						; print 8-bit integer

	ply								; restore original string pointer
	jmp	PrintFLoop

@xf:
	cmp	#'x'
	bne	@defaultF
	ldy	#0
	lda	[<DP2.DataAddress], y					; read hex byte to print
	jsr	PrintHex8						; print 8-bit hex integer

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
	jsr	(PTR_FillTextBuffer, x)					; write character to text buffer

	bra	@Loop

@Done:

	rts



FillTextBufferBG3:							; expectations: A = 8 bit, X/Y = 16 bit
	ldx	<DP2.TextCursor
	sta	RAM.BG3Tilemap, x					; write character to the BG3 text buffer
	inx								; advance text cursor position
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
	stx	<DP2.TextCursor

@Done:

	rts



PTR_FillTextBuffer:
	.DW	FillTextBufferBG3
	.DW	FillTextBufferMode5



; *********************** Sprite-based printing ************************

; A very basic sprite-based VWF renderer by Ramsis.
; Caveat #1: Max. length of message(s) is 32 characters at a time.
; Caveat #2: No support for control characters.

PrintSpriteText:
	ldy	#0
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

	and	#$00FF							; clear garbage in high byte
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

	rts



; ******************** Number processing functions *********************

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
	jsr	(PTR_FillTextBuffer, x)					; write them to the text buffer

	BRA	IntPrintLoop

_EndOfInt:

	RTS



;PrintHex8 -- Read an 8-bit value from Accu and print it in decimal on the screen

PrintInt8:								; assumes 8b mem, 16b index
	sta	WRDIVL
	lda	#$00
	sta	WRDIVH
	PHA
	BRA	DivLoop



;PrintHex8 -- Read an 8-bit value from Accu and print it in hex on the screen

PrintHex8:								; assumes 8b mem, 16b index
	pha
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	jsr	PrintHexNibble

	pla
	and	#$0F
	jsr	PrintHexNibble

	rts	

PrintHexNibble:								; assumes 8b mem, 16b index
	cmp	#$0A
	bcs	@nletter
	clc
	adc	#'0'
	ldx	LO8.Routine_FillTextBuffer
	jsr	(PTR_FillTextBuffer, x)					; write it to the text buffer

	rts

@nletter:
	clc
	adc	#'A'-10		
	ldx	LO8.Routine_FillTextBuffer
	jsr	(PTR_FillTextBuffer, x)					; write it to the text buffer

	rts



; ************************ Sprite-based numbers ************************

PrintSpriteHex8:
	pha
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	jsr	PrintSpriteHexNibble

	pla
	and	#$0F
	jsr	PrintSpriteHexNibble

	rts	



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

	and	#$00FF							; clear garbage in high byte
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



; ************************* Clearing functions *************************

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



; ******************************** EOF *********************************
