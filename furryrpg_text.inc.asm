;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** TEXT ENGINE ***
;
;==========================================================================================



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



OpenTextBox:

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

@ProcessNextDialog:
	lda	#:SRC_DiagPointerEng
	clc								; add language constant to get the correct text bank
	adc	DP_TextLanguage
	sta	DP_TextBoxStrBank
	lda	DP_TextLanguage						; check language again for the right pointer table
	bne	+

	Accu16

	lda	DP_TextPointerNo
	asl	a
	tax
	lda.l	SRC_DiagPointerEng, x					; DP_TextLanguage is 0 --> English
	bra	++

+	;cmp	#TBL_Lang_Ger						; German language selected?
;	bne	Somewhere						; for even more languages/text banks

	Accu16

	lda	DP_TextPointerNo
	asl	a
	tax
	lda.l	SRC_DiagPointerGer, x					; DP_TextLanguage is 1 --> German
++	sta	DP_TextBoxStrPtr
	stz	DP_TextStringCounter					; reset string counter

	Accu8

	lda	#%01000010						; set text box open, text pending flags
	sta	DP_TextBoxStatus
	rts



MainTextBoxLoop:							; this routine needs to be called once per frame

; -------------------------- check text box status
	lda	DP_TextBoxStatus					; don't process text if "VWF buffer full bit" is set
	bit	#$01
	bne	@PrintDialogTextDone

	bit	#%00100000						; text box frozen?
	beq	@TextBoxNotFrozen
	lda	DP_Joy1New						; yes, wait for player to press the A button
	and	#%10000000
	bne	+
	jmp	@MainTextBoxLoopDone

+	lda	#%10000000						; A pressed, set "clear text box" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

	stz	DP_TextTileDataCounter					; reset tile counter
	stz	DP_TextTileDataCounter+1
	lda	#%00100000						; clear "freeze text box" bit
	trb	DP_TextBoxStatus
	jmp	@MainTextBoxLoopDone

@TextBoxNotFrozen:
	and	#%01000000						; more text pending?
	beq	@PrintDialogTextDone

	jsr	ProcessNextText

@PrintDialogTextDone:



; -------------------------- check for selection
	lda	DP_TextBoxSelection
	bit	#%00001111
	beq	@DrawSelBarDone

	bit	DP_TextBoxStatus
	bvs	@DrawSelBarDone						; only draw sel bar after current string is finished

	jsr	TextBoxHandleSelection

@DrawSelBarDone:



; -------------------------- check for dpad up = next language
	lda	DP_Joy1New+1
	and	#%00001000
	beq	@DpadUpDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#TBL_Lang_Ger
	sta	DP_TextLanguage
	jsr	ClearHUD

	lda	#PARAM_HUD_Xpos						; load initial X starting position of HUD
	sta	temp							; used in upcoming subroutine
	clc								; make up for different X position of "text box" and text
	adc	#6
	sta	DP_TextCursor
	lda	DP_HUD_Ypos						; ditto for Y position
	sta	temp+1
	clc
	adc	#4
	sta	DP_TextCursor+1
	jsr	PutAreaNameIntoHUD

	WaitFrames	1

	jmp	OpenTextBox@ProcessNextDialog

@DpadUpDone:



; -------------------------- check for dpad down = previous language
	lda	DP_Joy1New+1
	and	#%00000100
	beq	@DpadDownDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#TBL_Lang_Eng
	sta	DP_TextLanguage
	jsr	ClearHUD

	lda	#PARAM_HUD_Xpos						; load initial X starting position of HUD
	sta	temp							; used in upcoming subroutine
	clc								; make up for different X position of "text box" and text
	adc	#6
	sta	DP_TextCursor
	lda	DP_HUD_Ypos						; ditto for Y position
	sta	temp+1
	clc
	adc	#4
	sta	DP_TextCursor+1
	jsr	PutAreaNameIntoHUD

	WaitFrames	1

	jmp	OpenTextBox@ProcessNextDialog

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
	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#%00001111						; clear selection bits just in case
	trb	DP_TextBoxSelection

	WaitFrames	1

	Accu16

	lda	DP_TextPointerNo					; decrement text pointer
	sec
	sbc	#1
	bpl	+
	lda	#0
+	sta	DP_TextPointerNo

	Accu8

	jmp	OpenTextBox@ProcessNextDialog

@DpadLeftDone:



; -------------------------- check for dpad right = next text pointer
	lda	DP_Joy1New+1
	and	#%00000001
	beq	@DpadRightDone

@NextTextPointer:
	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#%00001111						; clear selection bits
	trb	DP_TextBoxSelection

	WaitFrames	1

	Accu16

	lda	DP_TextPointerNo					; increment text pointer
	clc
	adc	#1
	cmp	#_sizeof_SRC_DiagPointerEng/2
	bcc	+
	lda	#_sizeof_SRC_DiagPointerEng/2-1
+	sta	DP_TextPointerNo

	Accu8

	jmp	OpenTextBox@ProcessNextDialog

@DpadRightDone:



; -------------------------- check for L button = text pointers -= 50
	lda	DP_Joy1New
	and	#%00100000
	beq	@LButtonDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#%00001111						; clear selection bits
	trb	DP_TextBoxSelection

	WaitFrames	1

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

	jmp	OpenTextBox@ProcessNextDialog

@LButtonDone:



; -------------------------- check for R button = text pointers += 50
	lda	DP_Joy1New
	and	#%00010000
	beq	@RButtonDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#%00001111						; clear selection bits
	trb	DP_TextBoxSelection

	WaitFrames	1

	Accu16

	lda	DP_TextPointerNo					; increment text pointer
	cmp	#_sizeof_SRC_DiagPointerEng/2-50
	bcc	+
	lda	#_sizeof_SRC_DiagPointerEng/2-1
	bra	++
+;	clc								; never mind, carry is already clear
	adc	#50
++	sta	DP_TextPointerNo

	Accu8

	jmp	OpenTextBox@ProcessNextDialog

@RButtonDone:



; -------------------------- check for B button = close text box
	lda	DP_Joy1New+1
	bpl	@BButtonDone
	jsr	TextBoxAnimationClose

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

;	WaitFrames	1

@BButtonDone:

@MainTextBoxLoopDone:
	rts



TextBoxHandleSelection:
	lda	DP_TextBoxSelection
	bit	#%00000001						; check if selection starts on line 1
	beq	+
	lda	#0
	bra	++

+	bit	#%00000010						; check if selection starts on line 2
	beq	+
	lda	#8
	bra	++

+	bit	#%00000100						; check if selection starts on line 3
	beq	+
	lda	#16
	bra	++

+	lda	#24							; else, selection starts on line 4, even though that doesn't make much sense :p
++	clc
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



TBHSLoop:
	WaitFrames	1						; don't use WAI here as IRQ is enabled



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
	bpl	@AButtonDone
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
	beq	+
	stz	DP_TextBoxSelection					; invalid value, clear all selection bits
	bra	@TBHSDone
+	lda	#%10000000						; line 4 = 7th bit (d)
++	sta	DP_TextBoxSelection					; bits 0-3 cleared
	bra	@TBHSDone

@AButtonDone:



; -------------------------- check for B button = leave selection
	lda	DP_Joy1New+1
	bpl	TBHSLoop

-	WaitFrames	1

	lda	DP_Joy1New+1						; wait for player to release button so the text box won't instantly close
	bmi	-

	stz	DP_TextBoxSelection					; clear all selection bits

@TBHSDone:
	lda	#%00001000						; disable HDMA channel 3 (color math) // FIXME for CM on playfield!!
	trb	DP_HDMA_Channels
	rts



VWFTileBufferFull:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN

	Accu16

	lda	DP_TextTileDataCounter
	clc								; add VRAM address for BG2 font tiles (+ 32 empty tiles),
	adc	#ADDR_VRAM_TextBoxL1					; this is done here once so we can proceed with zero-based counter math
	sta	REG_VMADDL						; store as new VRAM address

	ldy	#0							; transfer VWF tile buffer to VRAM
-	lda	ARRAY_VWF_TileBuffer, y					; copy font tiles
	sta	REG_VMDATAL
	iny
	iny
	cpy	#32							; 2 tiles, 16 bytes per tile
	bne	-

	ldy	#0
-	lda	ARRAY_VWF_TileBuffer2, y				; next, copy font tiles from upper buffer to lower buffer
	sta	ARRAY_VWF_TileBuffer, y
	iny
	iny
	cpy	#32							; 2 tiles
	bne	-

	lda	#0
-	sta	ARRAY_VWF_TileBuffer, y					; lastly, clear upper buffer (sic, as Y index wasn't reset to zero)
	iny
	iny
	cpy	#64
	bne	-

	stz	DP_VWF_BufferIndex					; reset buffer index

	Accu8

	lda	#$01							; done, reset "VWF buffer full" bit
	trb	DP_TextBoxStatus
	rts



ProcessNextText:

__ProcessTextLoop:
	Accu16

__ProcessTextLoop2:
	lda	DP_TextStringCounter
	tay								; transfer string position to Y index
	inc	a							; increment to next ASCII string character
	sta	DP_TextStringCounter					; (N.B.: inc a, sta dp is 1 cycle faster than inc dp)

	Accu8

	cmp	#4							; make text box appear on screen only after portrait and BG color data of a string have been processed (this doesn't affect the text box if it's already open) // self-reminder: NOT cmp #3 because of preceding inc a
	bne	+
	jsr	TextBoxAnimationOpen

+	lda	[DP_TextBoxStrPtr], y					; read ASCII string character
	cmp	#CC_End							; end of string reached?
	bne	+
	jmp	__ProcessTextDone					; yes, done

+	cmp	#NO_CC							; control code or not?
	bcc	+
	jmp	__ProcessTextNormal



; -------------------------- control code encountered, check type (order: very likely > less likely)
+	cmp	#CC_Portrait						; char portrait?
	bne	+
	iny								; increment string pointer to portrait no.
	lda	[DP_TextBoxStrPtr], y					; read portrait no. (0-127)
	ora	#$80							; set "change portrait" bit
	sta	DP_TextBoxCharPortrait					; save to "change portrait" request variable

	Accu16

	inc	DP_TextStringCounter					; increment to next ASCII string character
	jmp	__ProcessTextJumpOut

.ACCU 8

+	cmp	#CC_Indent						; indention?
	bne	+
	jmp	__ProcessTextIncTileCounter

+	cmp	#CC_NewLine						; carriage return?
	beq	__CarriageReturn
	cmp	#CC_ClearTextBox
	bne	+
	jmp	__ClearTextBoxMidString

+	cmp	#CC_Selection						; selection?
	bne	__OtherControlCode

	Accu16

	lda	DP_TextTileDataCounter					; selection required, check what line we've been on
	cmp	#46*8							; line 1?
	bcs	+

	Accu8

	lda	#%00000001
	bra	++

.ACCU 16

+	cmp	#92*8							; line 2?
	bcs	+

	Accu8

	lda	#%00000010
	bra	++

.ACCU 16

+	cmp	#138*8							; line 3?
	bcs	+

	Accu8

	lda	#%00000100
	bra	++

+	Accu8

	lda	#%00001000						; else, line 4
++	tsb	DP_TextBoxSelection
	jmp	__ProcessTextLoop

__OtherControlCode:
	cmp	#CC_BoxBlue						; self-reminder: This only works because we've already checked for all other CCs!
	bcs	+
	jmp	__ProcessTextLoop

+	ora	#$80							; set "change text box background" bit
	sta	DP_TextBoxBG

;	WaitFrames	1						; seems unnecessary

	jmp	__ProcessTextJumpOut

__CarriageReturn:
	lda	#$01							; set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

	Accu16

	stz	DP_VWF_BitsUsed						; reset VWF bit counter
	lda	DP_TextTileDataCounter					; check what line we've been on
	cmp	#46*8							; line 1?
	bne	+
	jmp	__ProcessTextJumpOut					; do nothing if carriage return requested after exactly 23 (16×8) tiles

+	bcs	+
	lda	#46*8							; go to line 2
	sta	DP_TextTileDataCounter
	jmp	__ProcessTextJumpOut

.ACCU 16

+	cmp	#92*8							; line 2?
	bne	+
	jmp	__ProcessTextJumpOut					; do nothing if carriage return requested after exactly 46 (16×8) tiles

+	bcs	+
	lda	#92*8							; go to line 3
	sta	DP_TextTileDataCounter
	jmp	__ProcessTextJumpOut

.ACCU 16

+	lda	#138*8							; otherwise, go to line 4
	sta	DP_TextTileDataCounter
	jmp	__ProcessTextJumpOut

.ACCU 8

__ClearTextBoxMidString:
	Accu16

	lda	DP_VWF_BitsUsed						; check if bit counter <> 0
	bne	+
	lda	DP_VWF_BufferIndex					; check if VWF buffer index <> 0
	beq	++

+	Accu8

	lda	#$01							; if either <> 0, set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

++	Accu8

	WaitFrames	1

	lda	#%00100000						; set "freeze text box" bit
	tsb	DP_TextBoxStatus
	jmp	__ProcessTextJumpOut



; -------------------------- process normal text
__ProcessTextNormal:
	Accu16

	and	#$00FF							; remove garbage in high byte
	sta	DP_TextASCIIChar					; save ASCII char no.

	Accu8

	jsr	ProcessVWFTiles

	Accu16

	lda	DP_VWF_BufferIndex					; check if 2 buffer tiles full
	lsr	a							; buffer index / 16 = tile no.
	lsr	a
	lsr	a
	lsr	a
	cmp	#2
	bcs	+
	jmp	__ProcessTextLoop2

+	Accu8

	lda	#$01							; set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

__ProcessTextIncTileCounter:
	Accu16

	lda	DP_TextTileDataCounter					; increment VRAM tile counter by 2 tiles
	clc
	adc	#16							; not 32 because of VRAM word addressing
	sta	DP_TextTileDataCounter

	Accu8

	bra	__ProcessTextJumpOut

__ProcessTextDone:
	Accu16

	lda	DP_VWF_BitsUsed						; check if bit counter <> 0
	bne	+
	lda	DP_VWF_BufferIndex					; check if VWF buffer index <> 0
	beq	++

+	Accu8

	lda	#$01							; if either <> 0, set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

++	Accu8

	lda	#%01000000						; clear "more text pending" flag
	trb	DP_TextBoxStatus

	Accu16

	stz	DP_TextTileDataCounter

__ProcessTextJumpOut:
	Accu8

	rts



ClearTextBox:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_TextBoxL1					; set VRAM address to beginning of line 1
	stx	REG_VMADDL

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 184*16		; 184 tiles



; -------------------------- clear VWF buffer
	Accu16

	lda	#0
	ldy	#0
-	sta	ARRAY_VWF_TileBuffer, y					; erase buffer
	iny
	iny
	cpy	#64							; 4 tiles, 16 bytes per tile
	bne	-

	stz	DP_TextTileDataCounter					; reset tile data counter
	stz	DP_VWF_BitsUsed						; reset used bits counter
	stz	DP_VWF_BufferIndex					; reset VWF buffer index

	Accu8

	lda	#%10000000						; text box is empty now, so clear the "clear text box" flag
	trb	DP_TextBoxStatus
	rts



LoadTextBoxBG:
	lda	DP_TextBoxBG
	and	#%01111111						; mask off request bit
	bne	+
	ldx	#(ARRAY_HDMA_BackgrTextBox & $FFFF)			; set WRAM address to text box HDMA background
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 192		; DP_TextBoxBG is zero, so make background black

	bra	@LoadTextBoxBGDone

+	dec	a							; make up for number difference (blue = $01)
	sta	REG_WRMPYA
	lda	#192							; multiply requested color table with 192 to get correct data offset for upcoming DMA
	sta	REG_WRMPYB

	Accu16								; 3 cycles

	lda	#224							; calculate DMA data length based on current IRQ scanline (e.g. when text box has fully "scrolled in": 224 - 176 = 48; 48 * 4 = 192)
	sec
	sbc	DP_TextBoxVIRQ
	asl	a
	asl	a
	tax								; save length in X
	bne	+							; only continue if length isn't zero, otherwise we'd end up with a destructive transfer of 65536 bytes ;-)

	Accu8

	bra	@LoadTextBoxBGDone

.ACCU 16

+	lda	REG_RDMPYL
	clc
	adc	#(SRC_HDMA_TextBoxGradientBlue & $FFFF)
	sta	REG_A1T0L							; data offset
	lda	DP_TextBoxVIRQ						; calculate WRAM address based on DP_TextBoxVIRQ (e.g. 176 * 4 - 704 = 0)
	asl	a
	asl	a
	clc
	adc	#(ARRAY_HDMA_BackgrPlayfield & $FFFF)			; use playfield background as a base to save the subtraction of 704
	sta	REG_WMADDL

	Accu8

	stz	REG_WMADDH						; array is in bank $7E
 	stz	REG_DMAP0						; DMA mode
	lda	#$80							; B bus register ($2180)
	sta	REG_BBAD0
	lda	#:SRC_HDMA_TextBoxGradientBlue				; data bank
	sta	REG_A1B0
	stx	REG_DAS0L						; data length
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

@LoadTextBoxBGDone:
	lda	#$80							; new table loaded, clear request bit
	trb	DP_TextBoxBG
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



ProcessVWFTiles:
	Accu16

	lda	DP_TextASCIIChar					; ASCII char no. --> font tile no.
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
	lda	#$00
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

	ldx	DP_TextASCIIChar					; ASCII char no. --> font width table index
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



VWFShiftBits:
	phx
	phy

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

	ply
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



TextBoxAnimationClose:

; -------------------------- closing animation (scroll text box content out vertically below the screen)
@CloseTextBoxAniLoop:
	WaitFrames	1

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+13					; subtract speed value to vertical BG scroll data, i.e. scroll BG down
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
	lda	#$80							; set "new text box BG requested" flag, this is required within the loop as the flag is cleared during Vblank after a new gradient was loaded
	tsb	DP_TextBoxBG
	lda	DP_TextBoxVIRQ						; increase value to create the illusion that the text box "scrolls out" below the screen
	clc
	adc	#PARAM_TextBoxAnimSpd
	sta	DP_TextBoxVIRQ						; write new scanline for IRQ to fire
	sta	REG_VTIMEL
	cmp	#224
	bne	@CloseTextBoxAniLoop

	Accu8

	lda	#%00110000						; clear IRQ enable bits
	trb	VAR_Shadow_NMITIMEN
	lda	#%00110100						; deactivate used HDMA channels
	trb	DP_HDMA_Channels

	WaitFrames	1

;	Accu16

;	lda	ARRAY_HDMA_BG_Scroll+1					; restore scrolling parameters // possibly needed on areas with vertical scrolling
;	sta	ARRAY_HDMA_BG_Scroll+11
;	lda	ARRAY_HDMA_BG_Scroll+3
;	sta	ARRAY_HDMA_BG_Scroll+13

;	Accu8

	rts



TextBoxAnimationOpen:

; -------------------------- opening animation (scroll text box content in vertically from below)
	lda	#%00110100						; activate HDMA ch. 2 (backdrop color), 4, 5 (BG scrolling regs)
	tsb	DP_HDMA_Channels
	lda	#%00110000						; enable IRQ at H=$4207 and V=$4209
	tsb	VAR_Shadow_NMITIMEN

@OpenTextBoxAniLoop:
	WaitFrames	1

	Accu16

	lda	DP_TextBoxVIRQ						; final value (scanline 176) reached?
	cmp	#176
	beq	+							; yes, jump out
	sec								; no --> reduce value to create so the text box "scrolls" in from below the screen
	sbc	#PARAM_TextBoxAnimSpd
	sta	DP_TextBoxVIRQ
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
	lda	#$80							; set "new text box BG requested" flag
	tsb	DP_TextBoxBG
	lda	DP_TextBoxVIRQ						; lastly, write new scanline for IRQ to fire
	sta	REG_VTIMEL
	bra	@OpenTextBoxAniLoop

+	Accu8

	rts



; ******************** String processing functions *********************
;
; Code in this section based on code written by neviksti, (c) 2002

.ACCU 8
.INDEX 16

;PrintF -- Print a formatted, NUL-terminated string to Stdout
;In:   X -- points to format string
;      Y -- points to parameter buffer
;Out: none
;Modifies: none
;Notes:
;     Supported Format characters:
;       %s -- sub-string (reads 16-bit pointer from Y data)
;       %d -- 16-bit Integer (reads 16-bit data from Y data)
;       %b -- 8-bit Integer (reads 8-bit data from Y data)
;       %x -- 8-bit hex Integer (reads 8-bit data from Y data)
;       %% -- normal %
;       \n -- Newline
;       \t -- Tab
;       \b -- Page break	>> REMOVED
;       \\ -- normal slash
;     String pointers all refer to current Data Bank (DB)

PrintF:
	ply								; pull return address from stack, which is actually the start of our string (minus one)
	iny								; make y = start of string

PrintFStart:
	PHP

	Accu8
	Index16

PrintFLoop:
	lda	[DP_TextStringPtr], y					; read next format string character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
	CMP	#'%'
	beq	PrintFFormat						; handle format character
	CMP	#'\'
	beq	PrintFControl						; handle control character

NormalPrint:
	jsr	FillTextBuffer						; write character to text buffer

	bra	PrintFLoop

PrintFDone:
	PLP
	phy								; push return address (-1) onto stack
	RTS



PrintFControl:
	lda	[DP_TextStringPtr], y					; read control character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
_cn:	CMP	#'n'
	bne	_ct

	AccuIndex16

	lda	DP_TextCursor						; get current position
	CLC
	adc	#$0020							; move to the next line
	AND	#$FFE0
	sta	DP_TextCursor						; save new position

	Accu8

	bra	PrintFLoop

_ct:	CMP	#'t'
	bne	_defaultC

	AccuIndex16

	lda	DP_TextCursor						; get current position
	CLC
;	adc	#$0008							; move to the next tab
;	AND	#$FFF8
	adc	#$0004							; smaller tab size (4 tiles = 8 hi-res characters)
	and	#$fffc
;	adc	#$0002							; use this instead for even smaller tabs
;	and	#$fffe
	sta	DP_TextCursor						; save new position

	Accu8

	bra	PrintFLoop

_defaultC:
	lda	#'\'							; normal backslash
	bra	NormalPrint

PrintFFormat:
	lda	[DP_TextStringPtr], y					; read format character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
_sf:	CMP	#'s'
	bne	_df
	phy								; preserve current format string pointer

	ldy	#0
-	lda	[DP_DataAddress], y					; read sub string character
	beq	__PrintSubstringDone					; check for NUL terminator
	iny								; increment input pointer
	jsr	FillTextBuffer						; write sub string character to text buffer

	bra	-

__PrintSubstringDone:
	ply
	bra	PrintFLoop
_df:	CMP	#'d'
	bne	_bf
	jsr	PrintInt16						; print 16-bit integer

	bra	PrintFLoop
_bf:	CMP	#'b'
	bne	_xf
	jsr	PrintInt8						; print 8-bit integer

	bra	PrintFLoop
_xf:	CMP	#'x'
	bne	_defaultF
	jsr	PrintHex8						; print 8-bit hex integer

	bra	PrintFLoop
_defaultF:
	lda	#'%'
	bra	NormalPrint



PrintFtemp:
	ldx	#ARRAY_TempString
	stx	DP_TextStringPtr
	lda	#$7E
	sta	DP_TextStringBank
	ldy	#0

@Loop:
	lda	[DP_TextStringPtr], y					; read next string character
	beq	@Done							; check for NUL terminator
	iny								; increment input pointer
	jsr	FillTextBuffer						; write character to text buffer

	bra	@Loop

@Done:
	rts



; In: A -- ASCII code to print
; Out: none
; Modifies: P

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

; A very basic sprite-based font renderer by ManuLöwe.
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
	sta	ARRAY_SpriteBuf1.Text, x				; X
	phx								; preserve text buffer index

	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	SRC_FWT_HUD, x						; advance cursor position as per font width table entry
	sta	DP_TextCursor

	plx								; restore text buffer index
	inx
	lda	DP_TextCursor+1
	sta	ARRAY_SpriteBuf1.Text, x				; Y
	inx

	pla
	ply
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	ARRAY_SpriteBuf1.Text, x				; tile num
	inx

	lda	DP_SpriteTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	ARRAY_SpriteBuf1.Text, x				; tile attributes

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

;PrintInt16 -- Read a 16-bit value pointed to by Y and print it to stdout
;In:  Y -- Points to integer in current data bank
;Out: Y=Y+2
;Modifies: P
;Notes: Uses Print to output ASCII to stdout

PrintInt16:								; assumes 8b mem, 16b index
	lda	#$00
	PHA								; push $00
	lda	$0000,Y
	sta	$4204							; DIVC.l
	lda	$0001,Y
	sta	$4205							; DIVC.h  ... DIVC = [Y]
	INY
	INY

DivLoop:
	lda	#$0A	
	sta	$4206							; DIVB = 10 --- division starts here (need to wait 16 cycles)
	NOP								; 2 cycles
	NOP								; 2 cycles
	NOP								; 2 cycles
	PHA								; 3 cycles
	PLA								; 4 cycles
	lda	#'0'							; 2 cycles
	CLC								; 2 cycles
	adc	$4216							; A = '0' + DIVC % DIVB
	PHA								; push character
	lda	$4214							; Result.l -> DIVC.l
	sta	$4204
	beq	_Low_0
	lda	$4215							; Result.h -> DIVC.h
	sta	$4205
	BRA	DivLoop

_Low_0:
	lda	$4215							; Result.h -> DIVC.h
	sta	$4205
	beq	IntPrintLoop						; if ((Result.l==$00) and (Result.h==$00)) then we're done, so print
	BRA	DivLoop

IntPrintLoop:								; until we get to the end of the string...
	PLA								; keep pulling characters and printing them
	beq	_EndOfInt
	jsr	FillTextBuffer						; write them to the text buffer

	BRA	IntPrintLoop

_EndOfInt:
	RTS



;PrintInt8 -- Read an 8-bit value pointed to by Y and print it to stdout
;In:  Y -- Points to integer in current data bank
;Out: Y=Y+1
;Modifies: P
;Notes: Uses Print to output ASCII to stdout

PrintInt8:								; assumes 8b mem, 16b index
	lda	$0000,Y
	INY

PrintInt8_noload:
	sta	$4204
	lda	#$00
	sta	$4205
	PHA
	BRA	DivLoop

;PrintInt16_noload:							; assumes 8b mem, 16b index
;	lda	#$00
;	PHA								; push $00
;	stx	$4204							; DIVC = X
;	jsr	DivLoop



;PrintHex8 -- Read an 8-bit value pointed to by Y and print it in hex to stdout
;In:  Y -- Points to integer in current data bank
;Out: Y=Y+1
;Modifies: P
;Notes: Uses Print to output ASCII to stdout

PrintHex8:								; assumes 8b mem, 16b index
	lda	$0000,Y
	iny

PrintHex8_noload:
	pha
	lsr	A
	lsr	A
	lsr	A
	lsr	A
	jsr	PrintHexNibble

	pla
	and	#$0F
	jsr	PrintHexNibble

	rts	

PrintHexNibble:								; assumes 8b mem, 16b index
	cmp	#$0A
	bcs	_nletter
	clc
	adc	#'0'
	jsr	FillTextBuffer						; write it to the text buffer

	rts

_nletter: 	
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
	bcs	_nletter2
	clc
	adc	#'0'
	jsr	FillSpriteTextBuf					; write it to the text buffer

	rts

_nletter2: 	
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
	sta	ARRAY_SpriteBuf1.Text, x				; X
	phx								; preserve tilemap index

	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	SRC_FWT_HUD, x						; advance cursor position as per font width table entry
	sta	DP_TextCursor

	plx								; restore tilemap index
	inx
	lda	DP_TextCursor+1
	sta	ARRAY_SpriteBuf1.Text, x				; Y
	inx

	pla
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	ARRAY_SpriteBuf1.Text, x				; tile num
	inx

	lda	DP_SpriteTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	ARRAY_SpriteBuf1.Text, x				; tile attributes
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

	lda	#$F0F0
	ldx	#0
-	sta	ARRAY_SpriteBuf1.HUD_TextBox, x				; Y, X
	inx
	inx
	stz	ARRAY_SpriteBuf1.HUD_TextBox, x				; tile no. = 0 (empty)
	inx
	inx
	cpx	#144							; 144 / 4 = 36 tiles
	bne	-

	ldx	#0
-	sta	ARRAY_SpriteBuf1.Text, x				; Y, X
	inx
	inx
	stz	ARRAY_SpriteBuf1.Text, x				; tile no. = 0 (empty)
	inx
	inx
	cpx	#128							; 128 / 4 = 32 tiles
	bne	-

	stz	DP_SpriteTextMon					; reset buffer monitor

	Accu8

	rts



; ******************************** EOF *********************************
