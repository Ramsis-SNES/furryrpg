;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** TEXT ENGINE ***
;
;==========================================================================================



; ************************ Dialog test section *************************

DialogTest:
	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP

	ResetSprites

	wai

	DisableIRQs

;.IFNDEF NOMUSIC
;	jsl	music_stop						; stop music in case it's playing

;	stz	MSU_CONTROL						; stop MSU1 track in case it's playing
;.ENDIF

	stz	DP_HDMA_Channels					; disable HDMA
	stz	REG_HDMAEN
	ldx	#(ARRAY_BG3TileMap & $FFFF)				; clear BG3 text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 1024

	ldx	#(ARRAY_HDMA_BackgrPlayfield & $FFFF)			; set WRAM address to playfield HDMA background
	stx	REG_WMADDL
	stz	REG_WMADDH						; array is in bank $7E

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 704	; clear HDMA table in case it was used before

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	jsr	LoadTextBoxBorderTiles					; prepare text box
	jsr	MakeTextBoxTileMapBG1
	jsr	MakeTextBoxTileMapBG2

	Accu16

	lda	#0							; make text box background black in case it was used before
	ldx	#0
-	sta	ARRAY_HDMA_BackgrTextBox, x
	inx
	inx
	cpx	#192
	bne	-

	ldx	#0							; put HDMA table into WRAM
-	lda.l	SRC_HDMA_ResetBGScroll, x
	sta	ARRAY_HDMA_BG_Scroll, x
	inx
	inx
	cpx	#16
	bne	-

	Accu8



; -------------------------- HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	REG_DMAP3
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	REG_BBAD3
	ldx	#ARRAY_HDMA_ColorMath
	stx	REG_A1T3L
	lda	#$7E							; table in WRAM expected
	sta	REG_A1B3



; -------------------------- HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	REG_DMAP4
	lda	#$0D							; PPU reg. $210D
	sta	REG_BBAD4
	ldx	#ARRAY_HDMA_BG_Scroll
	stx	REG_A1T4L
	lda	#$7E
	sta	REG_A1B4



; -------------------------- HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210F, 2 bytes --> $2110)
	sta	REG_DMAP5
	lda	#$0F							; PPU reg. $210F
	sta	REG_BBAD5
	ldx	#ARRAY_HDMA_BG_Scroll
	stx	REG_A1T5L
	lda	#$7E
	sta	REG_A1B5



; -------------------------- set PPU shadow registers
	lda	#$01|$08						; set BG Mode 1, BG3 priority
	sta	VAR_ShadowBGMODE
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	VAR_ShadowOBSEL
	lda	#$50							; BG1 tile map VRAM offset: $5000, screen size: 32×32
	sta	VAR_ShadowBG1SC
	lda	#$58							; BG2 tile map VRAM offset: $5800, screen size: 32×32
	sta	VAR_ShadowBG2SC
	lda	#$48							; BG3 tile map VRAM offset: $4800
	sta	VAR_ShadowBG3SC
	lda	#$00							; BG1/BG2 character data VRAM offset: $0000
	sta	VAR_ShadowBG12NBA
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	VAR_ShadowBG34NBA



; -------------------------- misc. settings
	lda	#%00010111						; turn on BG1/2/3 + sprites on mainscreen and subscreen
	sta	VAR_ShadowTM
	sta	VAR_ShadowTM

	SetNMI	TBL_NMI_Area						; use area NMI handler
	Accu16

	lda	#228							; dot number for interrupt (256 = too late, 204 = too early)
	sta	REG_HTIMEL
	lda	#224							; scanline number for interrupt (last scanline for now)
	sta	REG_VTIMEL

	Accu8

	sta	DP_TextBoxVIRQ						; save scanline no.

	SetIRQ	TBL_VIRQ_Area						; use area IRQ handler

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable Vblank NMI + Auto Joypad Read
	sta	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli								; re-enable interrupts

	PrintString	2, 2, "DIALOG TEST"				; print some on-screen help
	PrintString	4, 2, "Dpad r/l: next/prev string"
	PrintString	5, 12, "(hold Y for speed)"
	PrintString	6, 2, "Dpad up/dn: change language"
	PrintString	7, 2, "R/L: +/-50 strings"
	PrintString	8, 2, "A: make selection"

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMA_Updates
	tsb	DP_DMA_Updates+1

	WaitFrames	4						; give some time for screen refresh

	lda	#$0F							; turn screen back on
	sta	VAR_ShadowINIDISP
	jsr	InitDialogTextBox					; initialize text box

@DialogTestLoop:
	PrintString	10, 2, "DP_GameLanguage  = $"			; print some text-box-related variables
	PrintHexNum	DP_GameLanguage
	PrintString	11, 2, "DP_TextPointerNo = $"
	PrintHexNum	DP_TextPointerNo+1
	PrintHexNum	DP_TextPointerNo

	lda	#%00010000						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMA_Updates
	tsb	DP_DMA_Updates+1

	WaitFrames	1

	bit	DP_TextBoxStatus					; check if text box is active (MSB set)
	bpl	@NoTextBox
	jsr	ProcDialogTextBox

@NoTextBox:



; -------------------------- check for dpad up = next language
	lda	DP_Joy1New+1
	and	#%00001000
	beq	@DpadUpDone
	lda	DP_TextBoxSelection
	and	#$0F
	bne	@DpadUpDone
	lda	#TBL_Lang_Ger
	sta	DP_GameLanguage
	jsr	InitDialogTextBox@NextDialog

@DpadUpDone:



; -------------------------- check for dpad down = previous language
	lda	DP_Joy1New+1
	and	#%00000100
	beq	@DpadDownDone
	lda	DP_TextBoxSelection
	and	#$0F
	bne	@DpadUpDone
	lda	#TBL_Lang_Eng
	sta	DP_GameLanguage
	jsr	InitDialogTextBox@NextDialog

@DpadDownDone:



; -------------------------- check for Y + dpad right = fast forward text pointers
	lda	DP_Joy1Press+1						; Y pressed, check for dpad right
	and	#%01000001
	cmp	#%01000001
	beq	@NextTextPointer



; -------------------------- check for Y + dpad left = fast rewind text pointers
	lda	DP_Joy1Press+1						; Y pressed, check for dpad right
	and	#%01000010
	cmp	#%01000010
	beq	@PrevTextPointer



; -------------------------- check for dpad left = previous text pointer
	lda	DP_Joy1New+1
	and	#%00000010
	beq	@DpadLeftDone

@PrevTextPointer:
	Accu16

	lda	DP_TextPointerNo					; decrement text pointer
	sec
	sbc	#1
	bpl	+
	lda	#0
+	sta	DP_TextPointerNo

	Accu8

	jsr	InitDialogTextBox@NextDialog

@DpadLeftDone:



; -------------------------- check for dpad right = next text pointer
	lda	DP_Joy1New+1
	and	#%00000001
	beq	@DpadRightDone

@NextTextPointer:
	Accu16

	lda	DP_TextPointerNo					; increment text pointer
	clc
	adc	#1
	cmp	#_sizeof_PTR_DialogEng/2
	bcc	+
	lda	#_sizeof_PTR_DialogEng/2-1
+	sta	DP_TextPointerNo

	Accu8

	jsr	InitDialogTextBox@NextDialog

@DpadRightDone:



; -------------------------- check for A button
	bit	DP_Joy1New
	bpl	@AButtonDone
	bit	DP_TextBoxStatus					; check if text box is active (MSB set)
	bmi	@AButtonDone
	jsr	InitDialogTextBox@NextDialog

@AButtonDone:



; -------------------------- check for L button = text pointers -= 50
	lda	DP_Joy1New
	and	#%00100000
	beq	@LButtonDone

	Accu16

	lda	DP_TextPointerNo					; decrement text pointer
	cmp	#50
	bcs	+
	lda	#0
	bra	++
+;	sec								; never mind, carry is already set
	sbc	#50
++	sta	DP_TextPointerNo

	Accu8

	jsr	InitDialogTextBox@NextDialog

@LButtonDone:



; -------------------------- check for R button = text pointers += 50
	lda	DP_Joy1New
	and	#%00010000
	beq	@RButtonDone

	Accu16

	lda	DP_TextPointerNo					; increment text pointer
	cmp	#_sizeof_PTR_DialogEng/2-50
	bcc	+
	lda	#_sizeof_PTR_DialogEng/2-1
	bra	++
+;	clc								; never mind, carry is already clear
	adc	#50
++	sta	DP_TextPointerNo

	Accu8

	jsr	InitDialogTextBox@NextDialog

@RButtonDone:



; -------------------------- check for Start button = return to debug menu
	lda	DP_Joy1Press+1
	and	#%00010000
	beq	@StartButtonDone
	stz	DP_TextBoxStatus					; reset text box status
	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP
	lda	#%00110000						; clear IRQ enable bits
	trb	VAR_Shadow_NMITIMEN

	WaitFrames	1

	jmp	DebugMenu

@StartButtonDone:

	jmp	@DialogTestLoop



; ************************* Dialog text engine *************************

.ACCU 8
.INDEX 16

LoadTextBoxBorderTiles:
	ldx	#ADDR_VRAM_BG2_Tiles + $80				; set VRAM address for BG2 font tiles (+ 16 empty tiles)
	stx	REG_VMADDL
	ldx	#$0100							; upper left corner (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0110							; upper left corner (2) / upper border (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0110							; upper border (2) / upper right corner (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0120							; upper right corner (2)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0130							; left border (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0000							; left border (2) / right border (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0140							; right border (2)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0150							; lower left corner (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0160							; lower left corner (2) / lower border (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0160							; lower border (2) / lower right corner (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0170							; lower right corner (2)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0180							; black tile (1)
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0180							; black tile (2)
	jsr	SaveTextBoxTileToVRAM

	rts



InitDialogTextBox:

; -------------------------- prepare selection bar & set shadow PPU regs/misc. parameters
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathDialogSel, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathDialogSel
	bne	-

	lda	#%00010000						; set color math enable bits (4-5) to "MathWindow"
	sta	VAR_ShadowCGWSEL
	lda	#%00100011						; enable color math on BG1/2 & mainscreen backdrop
	sta	VAR_ShadowCGADSUB
	lda	#50							; color "window" left pos
	sta	VAR_ShadowWH0
	lda	#244							; color "window" right pos
	sta	VAR_ShadowWH1
	lda	#%00100000						; color math window 1 area = outside (why does this work??)
	sta	VAR_ShadowWOBJSEL

	Accu16

	lda	#%0000001100000011					; turn on BG1/2 only (i.e., disable BG3 and sprites) for text box
	sta	VAR_TextBox_TSTM
	lda	ARRAY_HDMA_BG_Scroll+1					; copy BG scroll reg values to second half of playfield
	sta	ARRAY_HDMA_BG_Scroll+6
	lda	ARRAY_HDMA_BG_Scroll+3
	sta	ARRAY_HDMA_BG_Scroll+8
;	stz	ARRAY_HDMA_BG_Scroll+11					; reset scrolling parameters for text box area
;	lda	#$00FF
;	sta	ARRAY_HDMA_BG_Scroll+13

	Accu8

	lda	#97							; set initial size of playfield BG to fill the whole screen (127 + 97 = 224)
	sta	ARRAY_HDMA_BG_Scroll+5
	stz	ARRAY_HDMA_BG_Scroll+10

@NextDialog:
	lda	#%00110100						; (re)activate HDMA ch. 2 (backdrop color), 4, 5 (BG scrolling regs)
	tsb	DP_HDMA_Channels
	lda	#%00110000						; (re)enable IRQ at H=$4207 and V=$4209
	tsb	VAR_Shadow_NMITIMEN
	lda	#%00000010						; set "clear text box" flag in case it was used before
	sta	DP_TextBoxStatus
	stz	DP_TextBoxSelection					; reset selection bits

	WaitFrames	1

	lda	#:PTR_DialogEng
	clc								; add language constant to get the correct text bank
	adc	DP_GameLanguage
	sta	DP_DiagStringBank
	lda	DP_GameLanguage						; check language again for the right pointer table
	bne	+

	Accu16

	lda	DP_TextPointerNo
	asl	a
	tax
	lda.l	PTR_DialogEng, x					; DP_GameLanguage is 0 --> English
	bra	++

+	;cmp	#TBL_Lang_Ger						; German language selected?
;	bne	Somewhere						; for even more languages/text banks

	Accu16

	lda	DP_TextPointerNo
	asl	a
	tax
	lda.l	PTR_DialogGer, x					; DP_GameLanguage is 1 --> German
++	sta	DP_DiagStringAddress
	stz	DP_DiagStringPos					; reset string position/index

	Accu8

	lda	#%10000000						; set "text box active" flag
	sta	DP_TextBoxStatus
	rts



ProcDialogTextBox:							; if the text box is active, then this routine must be called once per frame
	bit	DP_TextBoxStatus					; check status
	bvs	@Wait							; "wait" flag set or not?
	lda	DP_TextBoxStatus					; check status again
	bit	#%00000100						; "kill text box" flag set?
	bne	@KillTextBox

@CurrentString:
	lda	DP_DiagStringPos+1					; text box opening animation should only kick in after CC_Portrait and CC_Box* have been processed, so check string position
	bne	+							; if high byte <> 0, don't bother, and continue processing string
	lda	DP_DiagStringPos
	cmp	#3							; string pointer variable (16-bit) must be >=3
	bcc	+
	lda	DP_TextBoxVIRQ						; before printing the string, make sure the opening animation has completed
	cmp	#176
	beq	+
	jsr	TextBoxAnimationOpen
	bra	@TextBoxDone						; if text box wasn't fully visible, jump out

+	jsr	ProcessNextText
	bra	@TextBoxDone

@Wait:									; wait for some player input
	lda	DP_TextBoxSelection					; check if any selection bit is set
	bit	#%00001111
	beq	@WaitForButtonA
	jsr	TextBoxHandleSelection

	bra	@TextBoxDone

@WaitForButtonA:							; usual wait condition: wait for player confirmation
	bit	DP_Joy1New						; wait for player to press the A button (MSB)
	bpl	@TextBoxDone
	lda	#%01000000						; A pressed, clear "wait" flag
	trb	DP_TextBoxStatus
	bra	@TextBoxDone

@KillTextBox:
	lda	DP_TextBoxVIRQ
	cmp	#224
	beq	+
	jsr	TextBoxAnimationClose
	bra	@TextBoxDone

+	lda	#%00110000						; text box completely removed, clear IRQ enable bits
	trb	VAR_Shadow_NMITIMEN
	lda	#%00110100						; deactivate used HDMA channels
	trb	DP_HDMA_Channels
	lda	#%00000010						; set "clear text box" flag only
	sta	DP_TextBoxStatus

;	Accu16

;	lda	ARRAY_HDMA_BG_Scroll+1					; restore scrolling parameters // possibly needed on areas with vertical scrolling
;	sta	ARRAY_HDMA_BG_Scroll+11
;	lda	ARRAY_HDMA_BG_Scroll+3
;	sta	ARRAY_HDMA_BG_Scroll+13

;	Accu8

@TextBoxDone:
	rts



TextBoxHandleSelection:
	lda	DP_HDMA_Channels					; check if HDMA channel 3 (color math) is already enabled
	and	#%00001000
	bne	@WaitForInput



; -------------------------- determine text box line the selection starts on, and pre-load Accu with appropriate multiple of 8, i.e. Accu = (sel_start_line - 1) * 8, using a bit-manipulating loop
	lda	#0							; pre-load Accu with 0, use RSH to find the line the selection starts on
	xba								; preserve inital value
	lda	DP_TextBoxSelection
-	lsr	a							; test DP_TextBoxSelection bits from LSB onwards
	xba								; switch back to target Accu value
	bcs	+							; jump out as soon as first set bit found
	adc	#8							; bit was clear, add 8 to target Accu value // carry always clear at this point, so no need for clc before the adc
	xba								; switch back to next-higher selection bit
	bra	-							; rinse and repeat until first set bit found

+	clc
	adc	#PARAM_TextBoxColMath1st
	sta	ARRAY_HDMA_ColorMath+3
	sta	DP_TextBoxSelMin
	stz	DP_TextBoxSelMax
	lda	DP_TextBoxSelection
	lsr	a							; count no. of selection options available (4 max.)
	bcc	+
	inc	DP_TextBoxSelMax
+	lsr	a
	bcc	+
	inc	DP_TextBoxSelMax
+	lsr	a
	bcc	+
	inc	DP_TextBoxSelMax
+	lsr	a
	bcc	+
	inc	DP_TextBoxSelMax
+	lda	DP_TextBoxSelMax					; DP_TextBoxSelMax = (no. of options - 1) * 8 + DP_TextBoxSelMin
	dec	a
	asl	a
	asl	a
	asl	a
	clc
	adc	DP_TextBoxSelMin
	sta	DP_TextBoxSelMax
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	DP_HDMA_Channels
	bra	@JumpOut



@WaitForInput:

; -------------------------- check for dpad up
	lda	DP_Joy1New+1
	and	#%00001000
	beq	@DpadUpDone

	lda	ARRAY_HDMA_ColorMath+3					; move selection bar 8 scanlines up
	sec
	sbc	#8
	cmp	DP_TextBoxSelMin
	bcs	+
	lda	DP_TextBoxSelMin
+	sta	ARRAY_HDMA_ColorMath+3

@DpadUpDone:



; -------------------------- check for dpad down
	lda	DP_Joy1New+1
	and	#%00000100
	beq	@DpadDownDone

	lda	ARRAY_HDMA_ColorMath+3					; move selection bar 8 scanlines down
	clc
	adc	#8
	cmp	DP_TextBoxSelMax
	bcc	+
	lda	DP_TextBoxSelMax
+	sta	ARRAY_HDMA_ColorMath+3

@DpadDownDone:



; -------------------------- check for A button = make selection
	lda	DP_Joy1New
	bpl	@JumpOut
	lda	ARRAY_HDMA_ColorMath+3					; determine selection made by checking position of selection bar
	cmp	#PARAM_TextBoxColMath1st
	bne	+
	lda	#%00010000						; line 1 = 4th bit (a)
	bra	++
+	cmp	#PARAM_TextBoxColMath1st+8
	bne	+
	lda	#%00100000						; line 2 = 5th bit (b)
	bra	++
+	cmp	#PARAM_TextBoxColMath1st+16
	bne	+
	lda	#%01000000						; line 3 = 6th bit (c)
	bra	++
+	cmp	#PARAM_TextBoxColMath1st+24
	bne	+
	lda	#%10000000						; line 4 = 7th bit (d)
	bra	++
+	lda	#$00							; invalid value, clear all selection bits (shouldn't ever happen though)
++	sta	DP_TextBoxSelection					; bits 0-3 cleared
	lda	#%00001000						; disable HDMA channel 3 (color math) // FIXME for CM on playfield!!
	trb	DP_HDMA_Channels

@JumpOut:
	rts



ProcessNextText:
	Accu16

@NextStringByte:
	lda	DP_DiagStringPos
	tay								; transfer string position to Y index
	inc	a							; increment to next ASCII string character
	sta	DP_DiagStringPos					; (N.B.: inc a, sta dp is 1 cycle faster than inc dp)

	Accu8

	lda	[DP_DiagStringAddress], y				; read current byte of string
	cmp	#CC_End							; end of string reached?
	beq	@EndOfString						; yes, stop processing string
	cmp	#NO_CC							; control code or not?
	bcs	@NormalText

@ControlCode:
	Accu16

	and	#$00FF							; remove garbage in high byte
	asl	a							; use control code as jump index
	tax

	Accu8

	jmp	(PTR_ProcessDiagCC, x)					; control codes do rts, where applicable

@NormalText:								; process normal text
	Accu16

	and	#$00FF							; remove garbage in high byte
	sta	DP_DiagASCIIChar					; save ASCII char no.
	bit	DP_DiagTextEffect-1					; put MSB of DP_DiagTextEffect (an 8-bit variable) into MSB of (currently 16-bit) accumulator
	bmi	+							; MSB set --> use routine for bold font
	jsr	ProcessVWFTiles						; otherwise, use normal font routine
	bra	++

+	jsr	ProcessVWFTilesBold

++	Accu16

	lda	DP_VWF_BufferIndex					; check if 2 buffer tiles full
	cmp	#32							; 2 tiles × 16 = buffer index
	bcc	@NextStringByte						; buffer not full yet, continue reading string // ADDME/ADDFEATURE @JumpOut instead for slower text speed

	Accu8

	lda	#%00000001						; set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

	Accu16
	IncDiagTileDataCounter						; increment tile data counter to next 16×8 tile
	Accu8

	bra	@JumpOut

@EndOfString:								; CC_End encountered
	bit	DP_DiagTextEffect					; check sub-string flag
	bvc	@StringFinished
	lda	VAR_DiagStringBank					; sub-string finished, restore current string bank
	sta	DP_DiagStringBank

	Accu16

	lda	VAR_DiagStringAddress					; restore string address and offset/pointer
	sta	DP_DiagStringAddress
	lda	VAR_DiagStringPos
	sta	DP_DiagStringPos

	Accu8

	lda	#%01000000						; clear sub-string flag
	trb	DP_DiagTextEffect
	bra	@JumpOut

@StringFinished:							; string completely finished
	Accu16								; flush buffer and reset status parameters

	lda	DP_VWF_BitsUsed						; check if bit counter <> 0
	bne	+
	lda	DP_VWF_BufferIndex					; check if VWF buffer index <> 0
	beq	++

+	Accu8

	lda	#%00000001						; if either <> 0, set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1
++	Accu8

	lda	#%01000100						; set "wait" and "kill text box" status flags
	tsb	DP_TextBoxStatus
	stz	DP_DiagTileDataCounter					; clear tile data counter
	stz	DP_DiagTileDataCounter+1

@JumpOut:
	rts



PTR_ProcessDiagCC:							; self-reminder: order of table entries has to match CC_* .DEFINEs in variable definitions
	.DW Process_CC_BoxBG
	.DW Process_CC_BoxBG
	.DW Process_CC_BoxBG
	.DW Process_CC_BoxBG
	.DW Process_CC_BoxBG
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
	lsr	a							; revert jump index back to original control code (no. of background color gradient)
	ora	#$80							; set "change text box background" bit
	sta	DP_TextBoxBG
	rts								; aka bra/jmp ProcessNextText@JumpOut

Process_CC_ClearTextBox:
	Accu16

	lda	DP_VWF_BitsUsed						; check if bit counter <> 0
	bne	+
	lda	DP_VWF_BufferIndex					; check if VWF buffer index <> 0
	beq	++

+	Accu8

	lda	#%00000001						; if either <> 0, set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

++	Accu8
	WaitFrames	1

	lda	#%01000010						; set "wait", "clear text box" status flags
	tsb	DP_TextBoxStatus
	stz	DP_DiagTileDataCounter					; reset tile counter
	stz	DP_DiagTileDataCounter+1
	rts

Process_CC_Indent:
	Accu16
	IncDiagTileDataCounter						; skip one 16×8 tile
	Accu8

	rts

Process_CC_Jump:
	iny								; increment string pointer to new string address (16 bits)
	lda	[DP_DiagStringAddress], y				; read low byte
	xba								; store in Accu B temporarily
	iny
	lda	[DP_DiagStringAddress], y				; read high byte
	xba								; new 16-bit address is now in Accu, restore correct byte order

	Accu16

	sta	DP_DiagStringAddress					; store as new text string pointer
	stz	DP_DiagStringPos					; reset string position/index

	Accu8

	rts

Process_CC_NewLine:
	lda	#%00000001						; set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

	Accu16
	IncDiagTileDataCounter						; increment tile data counter before checking for current text box line, this ensures that very short strings (using less than a full 16×8 tile) on lines 2 or 3 won't get simply overwritten by succeeding dialogue

	lda	#46*8							; check what line we've been on: line 1?
	cmp	DP_DiagTileDataCounter					; (line 2 starts at 46*8)
	bcs	+
	lda	#92*8							; line 2?
	cmp	DP_DiagTileDataCounter					; (line 3 starts at 92*8)
	bcs	+
	lda	#138*8							; otherwise, go to line 4
+	sta	DP_DiagTileDataCounter
	stz	DP_VWF_BitsUsed						; lastly, reset VWF bit counter

	Accu8

	rts								; do nothing if carriage return requested after exactly 23 (16×8) tiles

Process_CC_Portrait:
	iny								; increment string pointer to portrait no.
	lda	[DP_DiagStringAddress], y				; read portrait no. (0-127)
	ora	#$80							; set "change portrait" bit
	sta	DP_TextBoxCharPortrait					; save to "change portrait" request variable

	Accu16

	inc	DP_DiagStringPos					; advance ASCII string position/index

	Accu8

	rts

Process_CC_Selection:
	Accu16

	lda	DP_DiagTileDataCounter					; selection required, check what line we've been on
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

	tsb	DP_TextBoxSelection
	rts

Process_CC_SubHex:
	iny								; increment string pointer to address of byte to print in hex
	lda	[DP_DiagStringAddress], y				; read address (low byte)
	sta	DP_DataAddress
	iny
	lda	[DP_DiagStringAddress], y				; high byte
	sta	DP_DataAddress+1
	iny
	lda	[DP_DiagStringAddress], y				; bank
	sta	DP_DataBank
	iny								; advance string pointer to byte after address
	sty	VAR_DiagStringPos					; save current string pointer



; -------------------------- process actual hex byte, i.e. make it into a WRAM sub-string
	lda	[DP_DataAddress]					; load byte to print in hex
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
	lda	#CC_End							; add sub-string terminator
	sta	ARRAY_TempString, x

	Accu16

	stz	DP_DiagStringPos					; reset string offset so it starts reading the sub-string from the beginning
	lda	DP_DiagStringAddress					; save current string address
	sta	VAR_DiagStringAddress
	lda	#ARRAY_TempString					; load address of temp string array
	sta	DP_DiagStringAddress

	Accu8

	lda	DP_DiagStringBank					; save current string bank
	sta	VAR_DiagStringBank
	lda	#$7E							; set lower WRAM bank
	sta	DP_DiagStringBank
	lda	#%01000000						; set sub-string flag
	tsb	DP_DiagTextEffect
	rts

Process_CC_SubInt8:
	iny								; increment string pointer to address of byte to print in hex
	lda	[DP_DiagStringAddress], y				; read address (low byte)
	sta	DP_DataAddress
	iny
	lda	[DP_DiagStringAddress], y				; high byte
	sta	DP_DataAddress+1
	iny
	lda	[DP_DiagStringAddress], y				; bank
	sta	DP_DataBank
	iny								; advance string pointer to byte after address
	sty	VAR_DiagStringPos					; save current string pointer



; -------------------------- process actual byte, i.e. make dec number(s) into a WRAM sub-string
	lda	[DP_DataAddress]					; read byte
	sta	REG_WRDIVL
	lda	#$00
	sta	REG_WRDIVH
	PHA
	ldx	#0
	BRA	Process_CC_SubInt16@DivLoop

Process_CC_SubInt16:
	iny								; increment string pointer to starting address of bytes to print as 16-bit integer
	lda	[DP_DiagStringAddress], y				; read address (low byte)
	sta	DP_DataAddress
	iny
	lda	[DP_DiagStringAddress], y				; high byte
	sta	DP_DataAddress+1
	iny
	lda	[DP_DiagStringAddress], y				; bank
	sta	DP_DataBank
	iny								; advance string pointer to byte after address
	sty	VAR_DiagStringPos					; save current string pointer



; -------------------------- process actual bytes, i.e. make dec number(s) into a WRAM sub-string
	lda	#$00
	pha								; push $00
	ldy	#0
	lda	[DP_DataAddress], y					; read low byte
	sta	REG_WRDIVL						; DIVC.l
	iny
	lda	[DP_DataAddress], y					; read high byte
	sta	REG_WRDIVH						; DIVC.h  ... DIVC = [Y]
	ldx	#0

@DivLoop:
	lda	#$0A	
	sta	REG_WRDIVB						; DIVB = 10 --- division starts here (need to wait 16 cycles)
	NOP								; 2 cycles
	NOP								; 2 cycles
	NOP								; 2 cycles
	PHA								; 3 cycles
	PLA								; 4 cycles
	lda	#'0'							; 2 cycles
	CLC								; 2 cycles
	adc	REG_RDMPYL						; A = '0' + DIVC % DIVB
	PHA								; push character
	lda	REG_RDDIVL						; Result.l -> DIVC.l
	sta	REG_WRDIVL
	beq	@Low_0
	lda	REG_RDDIVH						; Result.h -> DIVC.h
	sta	REG_WRDIVH
	BRA	@DivLoop

@Low_0:
	lda	REG_RDDIVH						; Result.h -> DIVC.h
	sta	REG_WRDIVH
	beq	@IntPrintLoop						; if ((Result.l==$00) and (Result.h==$00)) then we're done, so print
	BRA	@DivLoop

@IntPrintLoop:								; until we get to the end of the string...
	PLA								; keep pulling characters and printing them
	beq	@EndOfInt
	sta	ARRAY_TempString, x
	inx
	BRA	@IntPrintLoop

@EndOfInt:
	lda	#CC_End							; add sub-string terminator
	sta	ARRAY_TempString, x

	Accu16

	stz	DP_DiagStringPos					; reset string offset so it starts reading the sub-string from the beginning
	lda	DP_DiagStringAddress					; save current string address
	sta	VAR_DiagStringAddress
	lda	#ARRAY_TempString					; load address of temp string array
	sta	DP_DiagStringAddress

	Accu8

	lda	DP_DiagStringBank					; save current string bank
	sta	VAR_DiagStringBank
	lda	#$7E							; set lower WRAM bank
	sta	DP_DiagStringBank
	lda	#%01000000						; set sub-string flag
	tsb	DP_DiagTextEffect
	rts

Process_CC_SubString:
	iny								; increment string pointer to sub-string address
	lda	[DP_DiagStringAddress], y				; read sub-string address (low byte)
	sta	VAR_DiagSubStrAddress
	iny
	lda	[DP_DiagStringAddress], y				; high byte
	sta	VAR_DiagSubStrAddress+1
	iny
	lda	[DP_DiagStringAddress], y				; bank
	sta	VAR_DiagSubStrBank
	iny								; advance string pointer to byte after sub-string address
	sty	VAR_DiagStringPos					; save current string pointer

	Accu16

	stz	DP_DiagStringPos					; reset string offset so it starts reading the sub-string from the beginning
	lda	DP_DiagStringAddress					; save current string address
	sta	VAR_DiagStringAddress
	lda	VAR_DiagSubStrAddress					; load sub-string address
	sta	DP_DiagStringAddress

	Accu8

	lda	DP_DiagStringBank					; save current string bank
	sta	VAR_DiagStringBank
	lda	VAR_DiagSubStrBank					; load sub-string bank
	sta	DP_DiagStringBank
	lda	#%01000000						; set sub-string flag
	tsb	DP_DiagTextEffect
	rts

Process_CC_ToggleBold:
	lda	DP_DiagTextEffect
	eor	#%10000000						; toggle "bold text" bit
	sta	DP_DiagTextEffect
	rts



MakeTextBoxTileMapBG1:
	ldx	#ADDR_VRAM_BG1_TileMap3+PARAM_TextBox			; set VRAM address within new BG1 tilemap
	stx	REG_VMADDL

	Accu16



; -------------------------- line 1 of text box area
	lda	#0|$400							; patch up first tile ($00 = blank tile), palette no. 1
	sta	REG_VMDATAL

	lda	#ADDR_VRAM_Portrait/16|$400				; get tile no. for start of portrait
-	sta	REG_VMDATAL
	inc	a
	inc	a
	cmp	#ADDR_VRAM_Portrait/16+10|$400				; 5 (double) tiles done?
	bne	-

	ldx	#PARAM_TextBox+6
	lda	#0|$400							; blank tile
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBox+33					; end of line 1 + first tile of line 2
	bne	-



; -------------------------- line 2 of text box area
	lda	#ADDR_VRAM_Portrait/16+10|$400				; get next tile no.
-	sta	REG_VMDATAL
	inc	a
	inc	a
	cmp	#ADDR_VRAM_Portrait/16+20|$400				; 5 (double) tiles done?
	bne	-

	ldx	#PARAM_TextBox+32+6
	lda	#0|$400							; blank tile
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBox+65					; end of line 2 + first tile of line 3
	bne	-



; -------------------------- line 3 of text box area
	lda	#ADDR_VRAM_Portrait/16+20|$400				; get next tile no.
-	sta	REG_VMDATAL
	inc	a
	inc	a
	cmp	#ADDR_VRAM_Portrait/16+30|$400				; 5 (double) tiles done?
	bne	-

	ldx	#PARAM_TextBox+64+6
	lda	#0|$400							; blank tile
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBox+97					; end of line 3 + first tile of line 4
	bne	-



; -------------------------- line 4 of text box area
	lda	#ADDR_VRAM_Portrait/16+30|$400				; get next tile no.
-	sta	REG_VMDATAL
	inc	a
	inc	a
	cmp	#ADDR_VRAM_Portrait/16+40|$400				; 5 (double) tiles done?
	bne	-

	ldx	#PARAM_TextBox+96+6
	lda	#0|$400							; blank tile
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBox+129					; end of line 4 + first tile of line 5
	bne	-



; -------------------------- line 5 of text box area
	lda	#ADDR_VRAM_Portrait/16+40|$400				; get next tile no.
-	sta	REG_VMDATAL
	inc	a
	inc	a
	cmp	#ADDR_VRAM_Portrait/16+50|$400				; 5 (double) tiles done?
	bne	-

	ldx	#PARAM_TextBox+128+6
	lda	#0|$400							; blank tile
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBox+161					; end of line 5 + first tile of line 6
	bne	-



; -------------------------- line 6 of text box area
	lda	#ADDR_VRAM_Portrait/16+50|$400				; get next tile no.
-	sta	REG_VMDATAL
	inc	a
	inc	a
	cmp	#ADDR_VRAM_Portrait/16+60|$400				; 5 (double) tiles done?
	bne	-

	ldx	#PARAM_TextBox+160+6
	lda	#0|$400							; blank tile
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBox+192					; end of line 6
	bne	-

	Accu8

	rts



MakeTextBoxTileMapBG2:
; We use a fixed tilemap and generate Mode 5 compatible tile data based on the given text string on-the-fly in VRAM.

	ldx	#ADDR_VRAM_BG2_TileMap3+PARAM_TextBox			; set VRAM address within new BG2 tilemap
	stx	REG_VMADDL

	Accu16



; -------------------------- line 1 of text box area
	lda	#27|$400						; tile no. of black tile, palette no. 1
	sta	REG_VMDATAL

	ldx	#PARAM_TextBox+1
	lda	#0							; no. of blank tile
-	sta	REG_VMDATAL						; 1st "line" of portrait
	inx
	cpx	#PARAM_TextBox+6					; 5 tiles done?
	bne	-

	lda	#16							; upper left corner tiles
	sta	REG_VMDATAL
	inx
	lda	#17							; upper border tiles
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBoxUL+PARAM_TextBoxWidth			; position: upper right corner
	bne	-

	lda	#18							; upper right corner tiles
	sta	REG_VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL



; -------------------------- line 2 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

	ldx	#PARAM_TextBox+33
	lda	#0							; no. of blank tile
-	sta	REG_VMDATAL						; 2nd "line" of portrait
	inx
	cpx	#PARAM_TextBox+32+6					; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	REG_VMDATAL
	inx
	lda	#$20							; $20 = no. of 1st text string tile in VRAM, $22 = second tile etc.
-	sta	REG_VMDATAL
	inc	a							; tile no. += 2 (Mode 5 always shows two 8×8 tiles at once, resulting in a single 16×8 tile)
	inc	a
	inx
	cpx	#PARAM_TextBoxLine1+PARAM_TextBoxWidth-1
	bne	-

	pha								; preserve no. of text string tile
	lda	#21							; right border tiles
	sta	REG_VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL



; -------------------------- line 3 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

	ldx	#PARAM_TextBox+65
	lda	#0							; no. of blank tile
-	sta	REG_VMDATAL						; 3rd "line" of portrait
	inx
	cpx	#PARAM_TextBox+64+6					; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	REG_VMDATAL
	inx

	pla								; restore no. of text string tile
-	sta	REG_VMDATAL
	inc	a							; tile no. += 2
	inc	a
	inx								; position in tilemap += 1
	cpx	#PARAM_TextBoxLine2+PARAM_TextBoxWidth-1
	bne	-

	pha								; preserve no. of text string tile
	lda	#21							; right border tiles
	sta	REG_VMDATAL
	inx
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL
	inx



; -------------------------- line 4 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

	ldx	#PARAM_TextBox+97
	lda	#0							; no. of blank tile
-	sta	REG_VMDATAL						; 4th "line" of portrait
	inx
	cpx	#PARAM_TextBox+96+6					; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	REG_VMDATAL
	inx

	pla								; restore no. of text string tile
-	sta	REG_VMDATAL
	inc	a							; tile no. += 2
	inc	a
	inx								; position in tilemap += 1
	cpx	#PARAM_TextBoxLine3+PARAM_TextBoxWidth-1
	bne	-

	pha								; preserve no. of text string tile
	lda	#21							; right border tiles
	sta	REG_VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL



; -------------------------- line 5 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

	ldx	#PARAM_TextBox+129
	lda	#0							; no. of blank tile
-	sta	REG_VMDATAL						; 5th "line" of portrait
	inx
	cpx	#PARAM_TextBox+128+6					; 5 tiles done?
	bne	-

	lda	#20							; left border tiles
	sta	REG_VMDATAL
	inx

	pla								; restore no. of text string tile
-	sta	REG_VMDATAL
	inc	a							; tile no. += 2
	inc	a
	inx								; position in tilemap += 1
	cpx	#PARAM_TextBoxLine4+PARAM_TextBoxWidth-1
	bne	-

	lda	#21							; right border tiles
	sta	REG_VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL



; -------------------------- line 6 of text box area
;	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

	ldx	#PARAM_TextBox+161
	lda	#0							; no. of blank tile
-	sta	REG_VMDATAL						; 6th "line" of portrait
	inx
	cpx	#PARAM_TextBox+160+6					; 5 tiles done?
	bne	-

	lda	#23							; lower left corner tiles
	sta	REG_VMDATAL
	inx
	lda	#24							; lower border tiles
-	sta	REG_VMDATAL
	inx
	cpx	#PARAM_TextBoxUL+PARAM_TextBoxWidth+160			; lower right corner reached?
	bne	-

	lda	#25							; lower right corner tiles
	sta	REG_VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

	Accu8

	rts



MakeMode5FontBG1:							; Expects VRAM address set to BG1 tile base
	Accu16

	ldx	#0

@BuildFontBG1:
	ldy	#0
-	lda.l	GFX_Font8x8, x						; first, copy font tile (font tiles sit on the "left")
	sta	REG_VMDATAL
	inx
	inx
	iny
	cpy	#8							; 16 bytes (8 double bytes) per tile
	bne	-

	ldy	#0
-	stz	REG_VMDATAL						; next, add 3 blank tiles (1 blank tile because Mode 5 forces 16×8 tiles
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
-	stz	REG_VMDATAL						; first, add 1 blank tile (Mode 5 forces 16×8 tiles,
	iny								; no more blank tiles because BG2 is 2bpp)
	cpy	#8							; 16 bytes (8 double bytes) per tile
	bne	-

	ldy	#0
-	lda.l	GFX_Font8x8, x						; next, copy 8×8 font tile (font tiles sit on the "right")
	sta	REG_VMDATAL
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
	lda	DP_DiagASCIIChar					; ASCII char no. --> font tile no.
	asl	a							; value * 16 as 1 font tile = 16 bytes
	asl	a
	asl	a
	asl	a
	tax

	Accu8

	ldy	DP_VWF_BufferIndex
	lda	#16							; loop through 16 bytes per tile
	sta	DP_VWF_Loop

@VWFTilesLoop:
	lda.l	GFX_FontMode5, x
	xba								; move to high byte
	lda	#$00							; clear low byte
	jsr	VWFShiftBits						; shift tile data if necessary

	ora	ARRAY_VWF_TileBuffer+16, y				; store upper 8 bit
	sta	ARRAY_VWF_TileBuffer+16, y
	xba
	ora	ARRAY_VWF_TileBuffer, y					; store lower 8 bit
	sta	ARRAY_VWF_TileBuffer, y
	inx
	iny
	dec	DP_VWF_Loop
	bne	@VWFTilesLoop

	ldx	DP_DiagASCIIChar					; ASCII char no. --> font width table index
	lda.l	SRC_FWT_Dialog, x
	clc
	adc	DP_VWF_BitsUsed
	cmp	#8
	bcs	+
	sta	DP_VWF_BitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	DP_VWF_BufferIndex

	Accu8

	bra	@VWFTilesDone

+	sec
	sbc	#8
	sta	DP_VWF_BitsUsed
	sty	DP_VWF_BufferIndex

@VWFTilesDone:
	rts



.ACCU 16

ProcessVWFTilesBold:
	lda	DP_DiagASCIIChar					; ASCII char no. --> font tile no.
	asl	a							; value * 32 as 1 font tile = 16 bytes, and each character uses 2 tiles
	asl	a
	asl	a
	asl	a
	asl	a
	tax

	Accu8

	lda	#16							; loop through 16 bytes per tile
	sta	DP_VWF_Loop
	ldy	DP_VWF_BufferIndex

@VWFTilesLoop1:
	lda.l	GFX_FontMode5Bold, x
	xba								; move to high byte
	lda	#$00							; clear low byte
	jsr	VWFShiftBits						; shift tile data if necessary

	ora	ARRAY_VWF_TileBuffer+16, y				; store upper 8 bit
	sta	ARRAY_VWF_TileBuffer+16, y
	xba
	ora	ARRAY_VWF_TileBuffer, y					; store lower 8 bit
	sta	ARRAY_VWF_TileBuffer, y
	inx
	iny
	dec	DP_VWF_Loop
	bne	@VWFTilesLoop1

	Accu16

	lda	DP_DiagASCIIChar					; get correct ASCII char no. font width table index
	asl	a							; the table consists of 2 entries per character, so double the value
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x					; ASCII char graphics (right half) --> font width table index
	clc
	adc	DP_VWF_BitsUsed
	cmp	#8
	bcs	+
	sta	DP_VWF_BitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	DP_VWF_BufferIndex

	Accu8

	bra	@VWFTilesDone1

+	sec
	sbc	#8
	sta	DP_VWF_BitsUsed
	sty	DP_VWF_BufferIndex

@VWFTilesDone1:
	Accu16

	lda	DP_DiagASCIIChar					; check if there is a right half of character graphics
	asl	a							; 2 entries per character, so make up for that
	inc	a							; move table index to the right of current char
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x
	bne	+
	jmp	@VWFTilesDone2						; if entry is zero, jump out

+	Accu16

	lda	DP_VWF_BufferIndex					; we need to do a second half, check if 2 buffer tiles full first
	lsr	a							; buffer index / 16 = tile no.
	lsr	a
	lsr	a
	lsr	a
	cmp	#2
	bcc	+

	Accu8

	lda	#%00000001						; set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

	Accu16
	IncDiagTileDataCounter

+	Accu16								; finally, process right half of char graphics

	lda	DP_DiagASCIIChar					; ASCII char no. --> font tile no.
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
	sta	DP_VWF_Loop
	ldy	DP_VWF_BufferIndex

@VWFTilesLoop2:
	lda.l	GFX_FontMode5Bold, x
	xba								; move to high byte
	lda	#$00							; clear low byte
	jsr	VWFShiftBits						; shift tile data if necessary

	ora	ARRAY_VWF_TileBuffer+16, y				; store upper 8 bit
	sta	ARRAY_VWF_TileBuffer+16, y
	xba
	ora	ARRAY_VWF_TileBuffer, y					; store lower 8 bit
	sta	ARRAY_VWF_TileBuffer, y
	inx
	iny
	dec	DP_VWF_Loop
	bne	@VWFTilesLoop2

	Accu16

	lda	DP_DiagASCIIChar					; get correct ASCII char no. font width table index
	asl	a							; the table consists of 2 entries per character, so double the value
	inc	a							; move table index to right half of current char
	tax

	Accu8

	lda.l	SRC_FWT_DialogBold, x					; ASCII char graphics (right half) --> font width table index
	clc
	adc	DP_VWF_BitsUsed
	cmp	#8
	bcs	+
	sta	DP_VWF_BitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	DP_VWF_BufferIndex

	Accu8

	bra	@VWFTilesDone2

+	sec
	sbc	#8
	sta	DP_VWF_BitsUsed
	sty	DP_VWF_BufferIndex

@VWFTilesDone2:
	rts



VWFShiftBits:
	phx

	Accu16

	pha
	lda	DP_VWF_BitsUsed
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



SaveTextBoxTileToVRAM:
	Accu16

	ldy	#0
-	lda.l	GFX_FontMode5, x					; copy font tile
	sta	REG_VMDATAL
	inx
	inx
	iny
	cpy	#8							; 16 bytes (8 double bytes) per tile
	bne	-

	Accu8

	rts



TextBoxAnimationClose:							; closing animation (scroll text box content out vertically below the screen)
	lda	DP_TextBoxVIRQ
	clc								; increase value to create the illusion that the text box "scrolls out" below the screen
	adc	#PARAM_TextBoxAnimSpd
	sta	DP_TextBoxVIRQ						; write new scanline for IRQ to fire
	sta	REG_VTIMEL
	stz	REG_VTIMEH

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+13					; subtract speed value from vertical BG scroll data, i.e. scroll BG down
	sec
	sbc	#PARAM_TextBoxAnimSpd
	sta	ARRAY_HDMA_BG_Scroll+13

	Accu8

	lda	ARRAY_HDMA_BG_Scroll+5					; increase playfield BG size by speed value
	clc
	adc	#PARAM_TextBoxAnimSpd
	sta	ARRAY_HDMA_BG_Scroll+5
	lda	ARRAY_HDMA_BG_Scroll+10					; reduce text box BG size by speed value
	sec
	sbc	#PARAM_TextBoxAnimSpd
	sta	ARRAY_HDMA_BG_Scroll+10

	lda	#$80							; set "new text box BG requested" flag, this is required as the flag is cleared during Vblank after a new gradient was loaded
	tsb	DP_TextBoxBG
	rts



TextBoxAnimationOpen:							; opening animation (scroll text box content in vertically from below)
	lda	DP_TextBoxVIRQ
	sec								; reduce value so the text box "scrolls" in from below the screen
	sbc	#PARAM_TextBoxAnimSpd
	sta	DP_TextBoxVIRQ
	sta	REG_VTIMEL
	stz	REG_VTIMEH

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+13					; add speed value to vertical BG scroll data, i.e. scroll BG up
	clc
	adc	#PARAM_TextBoxAnimSpd
	sta	ARRAY_HDMA_BG_Scroll+13

	Accu8

	lda	ARRAY_HDMA_BG_Scroll+5					; reduce playfield BG size by speed value
	sec
	sbc	#PARAM_TextBoxAnimSpd
	sta	ARRAY_HDMA_BG_Scroll+5
	lda	ARRAY_HDMA_BG_Scroll+10					; increase text box BG size by speed value
	clc
	adc	#PARAM_TextBoxAnimSpd
	sta	ARRAY_HDMA_BG_Scroll+10

	lda	#$80							; set "new text box BG requested" flag, this is required as the flag is cleared during Vblank after a new gradient was loaded
	tsb	DP_TextBoxBG
	rts



; ******************** String processing functions *********************
;
; Code in this section based on code written by neviksti, (c) 2002

.ACCU 8
.INDEX 16

;PrintF -- Print a formatted, NUL-terminated string to Stdout
;Notes:
;     Supported Format characters:
;       %s -- sub-string (reads NUL-terminated data from [DP_DataAddress])
;       %d -- 16-bit Integer (reads 16-bit data from [DP_DataAddress])
;       %b -- 8-bit Integer (reads 8-bit data from [DP_DataAddress])
;       %x -- 8-bit hex Integer (reads 8-bit data from [DP_DataAddress])
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
	lda	[DP_TextStringPtr], y					; read next format string character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
	cmp	#'%'
	beq	PrintFFormat						; handle format character
	cmp	#'\'
	beq	PrintFControl						; handle control character

NormalPrint:
	jsr	FillTextBuffer						; write character to text buffer

	bra	PrintFLoop

PrintFDone:
	plp
	phy								; push return address (-1) onto stack
	rts



PrintFControl:
	lda	[DP_TextStringPtr], y					; read control character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer

@cn:	cmp	#'n'
	bne	@ct

	AccuIndex16

	lda	DP_TextCursor						; get current position
	clc
	adc	#$0020							; move to the next line
	and	#$FFE0
	sta	DP_TextCursor						; save new position

	Accu8

	bra	PrintFLoop

@ct:
	cmp	#'t'
	bne	@defaultC

	AccuIndex16

	lda	DP_TextCursor						; get current position
	clc
;	adc	#$0008							; move to the next tab
;	and	#$FFF8
	adc	#$0004							; smaller tab size (4 tiles = 8 hi-res characters)
	and	#$fffc
;	adc	#$0002							; use this instead for even smaller tabs
;	and	#$fffe
	sta	DP_TextCursor						; save new position

	Accu8

	bra	PrintFLoop

@defaultC:
	lda	#'\'							; normal backslash
	bra	NormalPrint



PrintFFormat:
	lda	[DP_TextStringPtr], y					; read format character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
	phy								; preserve current format string pointer

@sf:
	cmp	#'s'
	bne	@df
	ldy	#0
-	lda	[DP_DataAddress], y					; read sub string character
	beq	@sfDone							; check for NUL terminator
	iny								; increment input pointer
	jsr	FillTextBuffer						; write sub string character to text buffer

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
	lda	[DP_DataAddress], y					; read byte to print
	jsr	PrintInt8						; print 8-bit integer

	ply								; restore original string pointer
	bra	PrintFLoop

@xf:
	cmp	#'x'
	bne	@defaultF
	ldy	#0
	lda	[DP_DataAddress], y					; read hex byte to print
	jsr	PrintHex8						; print 8-bit hex integer

	ply								; restore original string pointer
	jmp	PrintFLoop

@defaultF:
	lda	#'%'
	jmp	NormalPrint



;PrintFtemp:
;	ldx	#ARRAY_TempString
;	stx	DP_TextStringPtr
;	lda	#$7E
;	sta	DP_TextStringBank

SimplePrintF:								; expects 24-bit pointer to string in DP_TextStringPtr
	ldy	#0

@Loop:
	lda	[DP_TextStringPtr], y					; read next string character
	beq	@Done							; check for NUL terminator
	iny								; increment input pointer
	jsr	FillTextBuffer						; write character to text buffer

	bra	@Loop

@Done:
	rts



FillTextBuffer:								; expectations: A = 8 bit, X/Y = 16 bit
	ldx	DP_TextCursor
	sta	ARRAY_BG3TileMap, x					; write character to the BG3 text buffer
	inx								; advance text cursor position
	stx	DP_TextCursor
	rts



; -------------------------- Mode-5-based fixed-width printing
PrintHiResFWF:
	php

	Accu8
	Index16

	ldy	#0

PrintHiResLoop:
	lda	[DP_TextStringPtr], y					; read next format string character
	beq	PrintHiResDone						; check for NUL terminator
	iny								; increment input pointer
	jsr	FillHiResTextBuffer					; write character to text buffer

	bra	PrintHiResLoop

PrintHiResDone:
	plp
	rts



PrintHiResFixedLenFWF:
	php

	Accu8
	Index16

	ldy	#0

PrintHiResFixedLenLoop:
	lda	[DP_TextStringPtr], y					; read next format string character
	iny								; increment input pointer
	jsr	FillHiResTextBuffer					; write character to text buffer

	dec	DP_HiResPrintLen
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

FillHiResTextBuffer:							; expectations: A = 8 bit, X/Y = 16 bit
	asl	a							; character code × 2 so it matches hi-res font tile location
	xba								; preserve character code
	ldx	DP_TextCursor
	lda	DP_HiResPrintMon
	bne	@FillHiResTextBufferBG2					; if BG monitor value is not zero, use BG2

@FillHiResTextBufferBG1:
	inc	DP_HiResPrintMon					; otherwise, change value and use BG1
	xba								; restore character code
	sta	ARRAY_BG1TileMap1, x					; write it to the BG1 text buffer
	bra	@FillHiResTextBufferDone				; ... and done

@FillHiResTextBufferBG2:
	stz	DP_HiResPrintMon					; reset BG monitor value
	xba								; restore character code
	sta	ARRAY_BG2TileMap1, x					; write it to the BG2 text buffer
	inx								; ... and advance text cursor position
	stx	DP_TextCursor

@FillHiResTextBufferDone:
	rts



; *********************** Sprite-based printing ************************

; A very basic sprite-based VWF renderer by ManuLöwe.
; Caveat #1: Max. length of message(s) is 32 characters at a time.
; Caveat #2: No support for control characters.

PrintSpriteText:
	ldy	#0
	php

	Accu8
	Index16

	ldx	DP_SpriteTextMon					; start where there is some unused sprite text buffer

@PrintSpriteTextLoop:
	lda	[DP_TextStringPtr], y					; read next string character
	beq	@PrintSpriteTextDone					; check for NUL terminator
	iny								; increment input pointer
	phy
	pha

	Accu16

	and	#$00FF							; delete garbage in high byte
	tay

	Accu8

	lda	DP_TextCursor
	sta	ARRAY_SpriteDataArea.Text, x				; X
	phx								; preserve text buffer index
	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	SRC_FWT_HUD, x						; advance cursor position as per font width table entry
	sta	DP_TextCursor
	plx								; restore text buffer index
	inx
	inx								; skip 9th bit of X coordinate and sprite size
	lda	DP_TextCursor+1
	sta	ARRAY_SpriteDataArea.Text, x				; Y
	inx
	pla
	ply
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	ARRAY_SpriteDataArea.Text, x				; tile num
	inx
	lda	DP_SpriteTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	ARRAY_SpriteDataArea.Text, x				; tile attributes
	inx
	cpx	#$0080							; if sprite buffer is full, reset
	bcc	+
	ldx	#$0000
+	stx	DP_SpriteTextMon					; keep track of sprite text buffer filling level
	bra	@PrintSpriteTextLoop

@PrintSpriteTextDone:
	plp
	rts



; ******************** Number processing functions *********************

;PrintInt16 -- Read a 16-bit value in DP_DataAddress and print it to the screen

PrintInt16:								; assumes 8b mem, 16b index
	lda	#$00
	pha								; push $00
	ldy	#0
	lda	[DP_DataAddress], y					; read low byte
	sta	REG_WRDIVL						; DIVC.l
	iny
	lda	[DP_DataAddress], y					; read high byte
	sta	REG_WRDIVH						; DIVC.h  ... DIVC = [Y]

DivLoop:
	lda	#$0A	
	sta	REG_WRDIVB						; DIVB = 10 --- division starts here (need to wait 16 cycles)
	NOP								; 2 cycles
	NOP								; 2 cycles
	NOP								; 2 cycles
	PHA								; 3 cycles
	PLA								; 4 cycles
	lda	#'0'							; 2 cycles
	CLC								; 2 cycles
	adc	REG_RDMPYL						; A = '0' + DIVC % DIVB
	PHA								; push character
	lda	REG_RDDIVL						; Result.l -> DIVC.l
	sta	REG_WRDIVL
	beq	_Low_0
	lda	REG_RDDIVH						; Result.h -> DIVC.h
	sta	REG_WRDIVH
	BRA	DivLoop

_Low_0:
	lda	REG_RDDIVH						; Result.h -> DIVC.h
	sta	REG_WRDIVH
	beq	IntPrintLoop						; if ((Result.l==$00) and (Result.h==$00)) then we're done, so print
	BRA	DivLoop

IntPrintLoop:								; until we get to the end of the string...
	PLA								; keep pulling characters and printing them
	beq	_EndOfInt
	jsr	FillTextBuffer						; write them to the text buffer

	BRA	IntPrintLoop

_EndOfInt:
	RTS



;PrintHex8 -- Read an 8-bit value from Accu and print it in decimal on the screen

PrintInt8:								; assumes 8b mem, 16b index
	sta	REG_WRDIVL
	lda	#$00
	sta	REG_WRDIVH
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
	jsr	FillTextBuffer						; write it to the text buffer

	rts

@nletter:
	clc
	adc	#'A'-10		
	jsr	FillTextBuffer						; write it to the text buffer

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
	ldx	DP_SpriteTextMon					; start where there is some unused sprite text buffer
	pha

	Accu16

	and	#$00FF							; delete garbage in high byte
	tay

	Accu8

	lda	DP_TextCursor
	sta	ARRAY_SpriteDataArea.Text, x				; X
	phx								; preserve tilemap index
	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	SRC_FWT_HUD, x						; advance cursor position as per font width table entry
	sta	DP_TextCursor
	plx								; restore tilemap index
	inx
	inx								; skip 9th bit of X coordinate and sprite size
	lda	DP_TextCursor+1
	sta	ARRAY_SpriteDataArea.Text, x				; Y
	inx
	pla
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	ARRAY_SpriteDataArea.Text, x				; tile num
	inx
	lda	DP_SpriteTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	ARRAY_SpriteDataArea.Text, x				; tile attributes
	inx
	cpx	#$0080							; if sprite buffer is full, reset
	bcc	+
	ldx	#$0000
+	stx	DP_SpriteTextMon					; keep track of sprite text buffer filling level

	plp
	rts



; ************************* Clearing functions *************************

ClearHUD:
	Accu16

	ldx	#0
-	lda	#$00F0
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x			; X (9 bits), sprite size
	inx
	inx

	Accu8

	lda	#$F0
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x			; Y
	inx

	Accu16

	lda	#0
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x			; tile no. = 0 (empty), attributes
	inx
	inx
	cpx	#180							; 180 / 5 = 36 tiles
	bne	-

	ldx	#0
-	lda	#$00F0
	sta	ARRAY_SpriteDataArea.Text, x				; X (9 bits), sprite size
	inx
	inx

	Accu8

	lda	#$F0
	sta	ARRAY_SpriteDataArea.Text, x				; Y
	inx

	Accu16

	lda	#0
	sta	ARRAY_SpriteDataArea.Text, x				; tile no. = 0 (empty), attributes
	inx
	inx
	cpx	#160							; 160 / 5 = 32 tiles
	bne	-

	stz	DP_SpriteTextMon					; reset buffer monitor

	Accu8

	rts



; ******************************** EOF *********************************
