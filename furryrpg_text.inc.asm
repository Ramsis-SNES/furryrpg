;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
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

; -------------------------- FIXME: enhance routine with opening animation



; -------------------------- prepare selection bar
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathDialogSel, x
	sta	ARRAY_HDMA_ColorMath, x

	inx
	cpx	#SRC_HDMA_ColMathDialogSel_End-SRC_HDMA_ColMathDialogSel
	bne	-

	lda	#%00010000						; set color math enable bits (4-5) to "MathWindow"
	sta	$2130
	lda	#%00100000						; enable color math on mainscreen backdrop (color math isn't supported on BGs in Mode 5 anyway)
	sta	$2131
	lda	#50							; color "window" left pos
	sta	$2126
	lda	#244							; color "window" right pos
	sta	$2127
	lda	#%00100000						; color math window 1 area = outside (why does this work??)
	sta	$2125

	Accu16

	lda	#%0000001100000011					; turn on BG1/2 only (i.e., disable BG3 and sprites) for text box
	sta	VAR_TextBox_TSTM
	lda	ARRAY_HDMA_BGScroll+1					; copy BG scroll reg values to second half of playfield
	sta	ARRAY_HDMA_BGScroll+6
	lda	ARRAY_HDMA_BGScroll+3
	sta	ARRAY_HDMA_BGScroll+8
	stz	ARRAY_HDMA_BGScroll+11					; reset scrolling parameters for text box area
	lda	#$00FF
	sta	ARRAY_HDMA_BGScroll+13

	Accu8

	lda	#%00110100						; activate HDMA ch. 2 (backdrop color), 4, 5 (BG scrolling regs)
	tsb	DP_HDMAchannels
	lda	#%00110000						; enable IRQ at H=$4207 and V=$4209
	tsb	DP_Shadow_NMITIMEN
;	lda	#$08							; tell SETINI (Display Control 2) register that horizontal hi-res is used
;	sta	REG_SETINI

	WaitFrames	1



__ProcessNextDialog:
	lda	#:SRC_DiagPointerEng
	clc								; add language constant to get the correct text bank
	adc	DP_TextLanguage
	sta	DP_TextStringBank

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
++	sta	DP_TextString

	Accu8

	lda	#%01000010						; set text box open, text pending flags
	sta	DP_TextBoxStatus



MainTextBoxLoop:
	WaitFrames	1						; don't use WAI here as IRQ is enabled



; -------------------------- print dialog text
	lda	DP_TextBoxStatus					; don't process text if "VWF buffer full bit" is set
	bit	#$01
	bne	__PrintDialogTextDone

	and	#%01000010
	cmp	#%01000010						; text box open, and more text pending?
	bne	__PrintDialogTextDone

	jsr	ProcessNextText

__PrintDialogTextDone:



; -------------------------- check for selection bar
	lda	DP_TextBoxStatus
	bit	#%00111100
	beq	__DrawSelBarDone

	and	#%01000000						; only draw sel bar after current string is finished
	bne	__DrawSelBarDone

	jsr	TextBoxHandleSelection

__DrawSelBarDone:



; -------------------------- check for A button = close text box, return
	lda	Joy1New
	and	#%10000000
	beq	__MainTextBoxLoopAButtonDone

	jmp	__CloseTextBox

__MainTextBoxLoopAButtonDone:



; -------------------------- check for dpad up = next language
	lda	Joy1New+1
	and	#%00001000
	beq	__MainTextBoxLoopDpadUpDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

;	inc	DP_TextLanguage
	lda	#TBL_Lang_Ger
	sta	DP_TextLanguage
	jmp	__ProcessNextDialog

__MainTextBoxLoopDpadUpDone:



; -------------------------- check for dpad down = previous language
	lda	Joy1New+1
	and	#%00000100
	beq	__MainTextBoxLoopDpadDownDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

;	dec	DP_TextLanguage
	lda	#TBL_Lang_Eng
	sta	DP_TextLanguage
	jmp	__ProcessNextDialog

__MainTextBoxLoopDpadDownDone:



; -------------------------- check for Y + dpad right = fast forward text pointers
	lda	Joy1Press+1						; Y pressed, check for dpad right
	and	#%01000001
	cmp	#%01000001
	beq	__NextTextPointer



; -------------------------- check for Y + dpad left = fast rewind text pointers
	lda	Joy1Press+1						; Y pressed, check for dpad right
	and	#%01000010
	cmp	#%01000010
	beq	__PrevTextPointer



; -------------------------- check for dpad left = previous text pointer
	lda	Joy1New+1
	and	#%00000010
	beq	__MainTextBoxLoopDpadLeftDone

__PrevTextPointer:
	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

	Accu16

	lda	DP_TextPointerNo					; decrement text pointer
	sec
	sbc	#1
	bpl	+
	lda	#0
+	sta	DP_TextPointerNo

	Accu8

	jmp	__ProcessNextDialog

__MainTextBoxLoopDpadLeftDone:



; -------------------------- check for dpad right = next text pointer
	lda	Joy1New+1
	and	#%00000001
	beq	__MainTextBoxLoopDpadRightDone

__NextTextPointer:
	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

	Accu16

	lda	DP_TextPointerNo					; increment text pointer
	clc
	adc	#1
	cmp	#(SRC_DiagPointerEng_END-SRC_DiagPointerEng)/2
	bcc	+
	lda	#(SRC_DiagPointerEng_END-SRC_DiagPointerEng)/2-1
+	sta	DP_TextPointerNo

	Accu8

	jmp	__ProcessNextDialog

__MainTextBoxLoopDpadRightDone:



; -------------------------- check for L button = text pointers -= 50
	lda	Joy1New
	and	#%00100000
	beq	__MainTextBoxLoopLButtonDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

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

	jmp	__ProcessNextDialog

__MainTextBoxLoopLButtonDone:



; -------------------------- check for R button = text pointers += 50
	lda	Joy1New
	and	#%00010000
	beq	__MainTextBoxLoopRButtonDone

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

	Accu16

	lda	DP_TextPointerNo					; increment text pointer
	cmp	#(SRC_DiagPointerEng_END-SRC_DiagPointerEng)/2-50
	bcc	+
	lda	#(SRC_DiagPointerEng_END-SRC_DiagPointerEng)/2-1
	bra	++
+;	clc								; never mind, carry is already clear
	adc	#50
++	sta	DP_TextPointerNo

	Accu8

	jmp	__ProcessNextDialog

__MainTextBoxLoopRButtonDone:
	jmp	MainTextBoxLoop



__CloseTextBox:
	lda	#%00110000						; clear IRQ enable bits
	trb	DP_Shadow_NMITIMEN
	lda	#%00110100						; deactivate used HDMA channels
	trb	DP_HDMAchannels

	WaitFrames	1

	Accu16

	lda	ARRAY_HDMA_BGScroll+1					; restore scrolling parameters
	sta	ARRAY_HDMA_BGScroll+11
	lda	ARRAY_HDMA_BGScroll+3
	sta	ARRAY_HDMA_BGScroll+13

	Accu8

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

	rts



TextBoxHandleSelection:
	lda	DP_TextBoxStatus
	bit	#%00000100						; check if selection starts on line 1
	beq	+
	lda	#0
	bra	++

+	bit #%00001000							; check if selection starts on line 2
	beq	+
	lda	#8
	bra	++

+	bit #%00010000							; check if selection starts on line 3
	beq	+
	lda	#16
	bra	++

+	lda	#24							; else, selection starts on line 4, even though that doesn't make much sense :p
++	clc
	adc	#57
	sta	ARRAY_HDMA_ColorMath+3
	sta	DP_TextBoxSelMin
	stz	DP_TextBoxSelMax

	lda	DP_TextBoxStatus
	lsr	a							; get rid of 2 lower bits
	lsr	a
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
	tsb	DP_HDMAchannels



__TBHSLoop:
	WaitFrames	1						; don't use WAI here as IRQ is enabled


; -------------------------- check for dpad up
	lda	Joy1New+1
	and	#%00001000
	beq	__TBHSLoopDpadUpDone

	lda	ARRAY_HDMA_ColorMath+3					; move selection bar 8 scanlines up
	sec
	sbc	#8
	cmp	DP_TextBoxSelMin
	bcs	+
	lda	DP_TextBoxSelMin
+	sta	ARRAY_HDMA_ColorMath+3

__TBHSLoopDpadUpDone:



; -------------------------- check for dpad down
	lda	Joy1New+1
	and	#%00000100
	beq	__TBHSLoopDpadDownDone

	lda	ARRAY_HDMA_ColorMath+3					; move selection bar 8 scanlines down
	clc
	adc	#8
	cmp	DP_TextBoxSelMax
	bcc	+
	lda	DP_TextBoxSelMax
+	sta	ARRAY_HDMA_ColorMath+3

__TBHSLoopDpadDownDone:



; -------------------------- check for B button = leave selection
	lda	Joy1New+1
	bpl	__TBHSLoop

__TBHSDone:
	lda	#%00111100						; clear selection bits
	trb	DP_TextBoxStatus
	lda	#%00001000						; disable HDMA channel 3 (color math) // FIXME for CM on playfield!!
	trb	DP_HDMAchannels
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
-	lda	ARRAY_VWFTileBuffer, y					; copy font tiles
	sta	REG_VMDATAL
	iny
	iny
	cpy	#32							; 2 tiles, 16 bytes per tile
	bne	-

	ldy	#0
-	lda	ARRAY_VWFTileBuffer2, y					; next, copy font tiles from upper buffer to lower buffer
	sta	ARRAY_VWFTileBuffer, y
	iny
	iny
	cpy	#32							; 2 tiles
	bne	-

	lda	#0
-	sta	ARRAY_VWFTileBuffer, y					; lastly, clear upper buffer (sic, as Y index wasn't reset to zero)
	iny
	iny
	cpy	#64
	bne	-

	stz	DP_VWFBufferIndex					; reset buffer index

	Accu8

	lda	#$01							; done, reset "VWF buffer full" bit
	trb	DP_TextBoxStatus
	rts



ProcessNextText:

__ProcessTextLoop:
	lda	DP_TextStringCounter

	Accu16

	and	#$00FF							; remove garbage in high byte
	tay

	Accu8

	inc	DP_TextStringCounter					; increment to next ASCII string character
	lda	[DP_TextString], y					; read ASCII string character
	cmp	#CC_End							; end of string reached?
	bne	+
	jmp	__ProcessTextDone					; yes, done

+	cmp	#NO_CC							; control code or not?
	bcc	+
	jmp	__ProcessTextNormal



; -------------------------- control code encountered, check type (order: very likely > less likely)
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

	lda	#%00000100
	bra	++

.ACCU 16

+	cmp	#92*8							; line 2?
	bcs	+

	Accu8

	lda	#%00001000
	bra	++

.ACCU 16

+	cmp	#138*8							; line 3?
	bcs	+

	Accu8

	lda	#%00010000
	bra	++

+	Accu8

	lda	#%00100000						; else, line 4
++	tsb	DP_TextBoxStatus

	bra	__ProcessTextLoop

__OtherControlCode:
	cmp	#CC_BoxBlue
	bcs	+
;	sta	DP_TextPalette						; 0-3 = switch palette font
	bra	__ProcessTextLoop

+	jsr	ChangeTextBoxBG
	jmp	__ProcessTextJumpOut

__CarriageReturn:
	lda	#$01							; set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

	Accu16

	stz	DP_VWFBitsUsed						; reset VWF bit counter
	lda	DP_TextTileDataCounter					; check what line we've been on
	cmp	#46*8							; line 1?
	bne	+

	jmp	__ProcessTextJumpOut					; do nothing if carriage return requested after exactly 46 chars
+	bcs	+

	lda	#46*8							; go to line 2
	sta	DP_TextTileDataCounter
	jmp	__ProcessTextJumpOut

.ACCU 16

+	cmp	#92*8							; line 2?
	bne	+

	jmp	__ProcessTextJumpOut					; do nothing if carriage return requested after exactly 92 chars
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

	lda	DP_VWFBitsUsed						; check if bit counter <> 0
	bne	+

	lda	DP_VWFBufferIndex					; check if VWF buffer index <> 0
	beq	++

+	Accu8

	lda	#$01							; if either <> 0, set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

;	WaitFrames	1						; never mind, see below

++	Accu8

-	WaitFrames	1						; next, wait for player to press the A button

	lda	Joy1New
	and	#%10000000
	beq	-

	lda	#%10000000						; lastly, set "clear text box" bit
	sta	DP_TextBoxStatus

	WaitFrames	1

	Accu16

	inc	DP_TextPointerNo					; increment to next text pointer
	pla								; pull 16 bits of garbage off the stack as there's no rts from jsr ProcessNextText

	Accu8

	jmp	__ProcessNextDialog



; -------------------------- process normal text
__ProcessTextNormal:
	Accu16

	and	#$00FF							; remove garbage in high byte
	sta	DP_TextASCIIChar					; save ASCII char no.

	Accu8

	jsr	ProcessVWFTiles

	Accu16

	lda	DP_VWFBufferIndex					; check if 2 buffer tiles full
	lsr	a							; buffer index / 16 = tile no.
	lsr	a
	lsr	a
	lsr	a
	cmp	#2
	bcs	+

	Accu8

	jmp	__ProcessTextLoop

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

	lda	DP_VWFBitsUsed						; check if bit counter <> 0
	bne	+

	lda	DP_VWFBufferIndex					; check if VWF buffer index <> 0
	beq	++

+	Accu8

	lda	#$01							; if either <> 0, set "VWF buffer full" bit
	tsb	DP_TextBoxStatus

	WaitFrames	1

++	Accu8

	lda	#%01000000						; clear "more text pending" flag
	trb	DP_TextBoxStatus

;	stz	DP_TextPalette						; reset string parameters
	stz	DP_TextStringCounter

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

;	stz	DP_TextPalette						; reset string parameters
	stz	DP_TextStringCounter

	Accu16

	stz	DP_TextTileDataCounter					; reset tile data counter
	stz	DP_VWFBitsUsed

	Accu8

	jsr	ClearVWFBuffer

	lda	#%10000000						; text box is empty now, so clear the "clear text box" flag
	trb	DP_TextBoxStatus
	rts



;ClearTextBoxSingleLine:
;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	REG_VMAIN
;	ldx	#ADDR_VRAM_BG2_TEXTBOXL1				; set VRAM address to beginning of line 1
;	stx	REG_VMADDL

;	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 800		; 50 tiles × 16 bytes
;	rts



MakeTextBoxTilemapBG1:
	ldx	#ADDR_VRAM_BG1_Tilemap3+PARAM_TextBox			; set VRAM address within new BG1 tilemap
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



MakeTextBoxTilemapBG2:
; We use a fixed tilemap and generate Mode 5 compatible tile data based on the given text string on-the-fly in VRAM.

	ldx	#ADDR_VRAM_BG2_Tilemap3+PARAM_TextBox			; set VRAM address within new BG2 tilemap
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
	cpx	#PARAM_TEXTBOX_UL+PARAM_TEXTBOX_WIDTH			; position: upper right corner
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
	cpx	#PARAM_TextBox_Line1+PARAM_TEXTBOX_WIDTH-1
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
	cpx	#PARAM_TextBox_Line2+PARAM_TEXTBOX_WIDTH-1
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
	cpx	#PARAM_TextBox_Line3+PARAM_TEXTBOX_WIDTH-1
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
	cpx	#PARAM_TextBox_Line4+PARAM_TEXTBOX_WIDTH-1
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
	cpx	#PARAM_TEXTBOX_UL+PARAM_TEXTBOX_WIDTH+160		; lower right corner reached?
	bne	-

	lda	#25							; lower right corner tiles
	sta	REG_VMDATAL
	lda	#27|$400						; tile no. of black tile
	sta	REG_VMDATAL

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

	ldy	DP_VWFBufferIndex
	lda	#16							; loop through 16 bytes per tile
	sta	DP_VWFLoop

__VWFTilesLoop:
	lda.l	GFX_FontMode5, x
	xba								; move to high byte
	lda	#$00
	jsr	VWFShiftBits						; shift tile data if necessary
	ora	ARRAY_VWFTileBuffer+16, y				; store upper 8 bit
	sta	ARRAY_VWFTileBuffer+16, y
	xba
	ora	ARRAY_VWFTileBuffer, y					; store lower 8 bit
	sta	ARRAY_VWFTileBuffer, y
	inx
	iny
	dec	DP_VWFLoop
	bne	__VWFTilesLoop

	ldx	DP_TextASCIIChar					; ASCII char no. --> font width table index
	lda.l	SRC_FWTDialogue, x
	clc
	adc	DP_VWFBitsUsed
	cmp	#8
	bcs	+
	sta	DP_VWFBitsUsed

	Accu16

	tya
	sec
	sbc	#16
	sta	DP_VWFBufferIndex

	Accu8

	bra	__ProcessVWFTilesDone

+	sec
	sbc	#8
	sta	DP_VWFBitsUsed
	sty	DP_VWFBufferIndex

__ProcessVWFTilesDone:
	rts



VWFShiftBits:
	phx
	phy

	Accu16

	pha
	lda	DP_VWFBitsUsed
	bne	+

	pla
	bra	__VWFShiftBitsDone

+	dec	a
	asl	a
	tax

	pla

	jmp	(__VWFShiftAmount, x)



__VWFShiftAmount:
	.DW __R1, __R2, __R3, __R4, __R5, __R6, __R7

__R7:
	lsr	a

__R6:
	lsr	a

__R5:
	lsr	a

__R4:
	lsr	a

__R3:
	lsr	a

__R2:
	lsr	a

__R1:
	lsr	a



__VWFShiftBitsDone:
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



ClearVWFBuffer:
	Accu16

	lda	#0
	ldy	#0
-	sta	ARRAY_VWFTileBuffer, y					; copy font tiles
	iny
	iny
	cpy	#64							; 4 tiles, 16 bytes per tile
	bne	-

	stz	DP_VWFBufferIndex					; reset buffer index

	Accu8

	rts



ChangeTextBoxBG:
	ldx	#(ARRAY_HDMA_BackgrTextBox & $FFFF)			; set WRAM address to text box HDMA background
	stx	REG_WMADDL
	stz	REG_WMADDH

	cmp	#CC_BoxRed						; check for text box color code
	bne	+

-	bit	REG_HVBJOY						; wait for Hblank // CHECKME on 1/1/1 console
	bvc	-

	DMA_CH0 $00, :SRC_HDMA_TextBoxGradientRed, SRC_HDMA_TextBoxGradientRed, $80, 48*4

	jmp	__ChangeTextBoxBGDone

+	cmp	#CC_BoxPink
	bne	+

-	bit	REG_HVBJOY						; wait for Hblank
	bvc	-

	DMA_CH0 $00, :SRC_HDMA_TextBoxGradientPink, SRC_HDMA_TextBoxGradientPink, $80, 48*4

	bra	__ChangeTextBoxBGDone

+	cmp	#CC_BoxEvil
	bne	+

-	bit	REG_HVBJOY						; wait for Hblank
	bvc	-

	DMA_CH0 $00, :SRC_HDMA_TextBoxGradientEvil, SRC_HDMA_TextBoxGradientEvil, $80, 48*4

	bra	__ChangeTextBoxBGDone

+	cmp	#CC_BoxPissed
	bne	_f

-	bit	REG_HVBJOY						; wait for Hblank
	bvc	-

	DMA_CH0 $00, :SRC_HDMA_TextBoxGradientPissed, SRC_HDMA_TextBoxGradientPissed, $80, 48*4

	bra	__ChangeTextBoxBGDone

__	bit	REG_HVBJOY						; wait for Hblank
	bvc	_b

	DMA_CH0 $00, :SRC_HDMA_TextBoxGradientBlue, SRC_HDMA_TextBoxGradientBlue, $80, 48*4

__ChangeTextBoxBGDone:
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

	stz	strBank
	stz	strBank+1
	lda	#$C0							; debug menu strings are all in bank $C0
	sta	strBank+2

PrintFStart:
	PHP
;	PHA
;	PHX
;	PHY

	Accu8
	Index16

PrintFLoop:
	lda	[strBank], y						; read next format string character
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
;	PLY
;	PLX
;	PLA
	PLP
	phy								; push return address (-1) onto stack
	RTS



PrintFControl:
	lda	[strBank], y						; read control character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
_cn:	CMP	#'n'
	bne	_ct

	AccuIndex16

	lda	Cursor							; get current position
	CLC
	adc	#$0020							; move to the next line
	AND	#$FFE0
	sta	Cursor							; save new position

	Accu8

	bra	PrintFLoop

_ct:	CMP	#'t'
	bne	_defaultC

	AccuIndex16

	lda	Cursor							; get current position
	CLC
;	adc	#$0008							; move to the next tab
;	AND	#$FFF8
	adc	#$0004							; smaller tab size (4 tiles = 8 hi-res characters)
	and	#$fffc
;	adc	#$0002							; use this instead for even smaller tabs
;	and	#$fffe
	sta	Cursor							; save new position

	Accu8

	bra	PrintFLoop

_defaultC:
	lda	#'\'							; normal backslash
	bra	NormalPrint

PrintFFormat:
	lda	[strBank], y						; read format character
	beq	PrintFDone						; check for NUL terminator
	iny								; increment input pointer
_sf:	CMP	#'s'
	bne	_df
	phy								; preserve current format string pointer

	ldy	#0
-	lda	[DP_SubStrAddr], y					; read sub string character
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



; In: A -- ASCII code to print
; Out: none
; Modifies: P

FillTextBuffer:								; expectations: A = 8 bit, X/Y = 16 bit
;	phx
	ldx	Cursor
	sta	TileMapBG3, x						; write character to the BG1 text buffer
	inx								; advance text cursor position
	stx	Cursor
;	plx
	rts



; *********************** Sprite-based printing ************************

; A very basic sprite-based font renderer by ManuLöwe.
; Caveat #1: Max. length of message(s) is 32 characters at a time.
; Caveat #2: No support for control characters.

PrintSpriteText:
	ldy	strPtr
	php

	Accu8
	Index16

	ldx	SprTextMon						; start where there is some unused sprite text buffer

__PrintSpriteTextLoop:
	lda	[strBank], y						; read next string character
	beq	__PrintSpriteTextDone					; check for NUL terminator
	iny								; increment input pointer
	phy
	pha

	Accu16

	and	#$00FF							; delete garbage in high byte
	tay

	Accu8

	lda	Cursor
	sta	SpriteBuf1.Text, x					; X
	phx								; preserve tilemap index

	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	FWT_Sprite, x						; advance cursor position as per font width table entry
	sta	Cursor

	plx								; restore tilemap index
	inx
	lda	Cursor+1
	sta	SpriteBuf1.Text, x					; Y
	inx

	pla
	ply
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	SpriteBuf1.Text, x					; tile num
	inx

	lda	SprTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	SpriteBuf1.Text, x					; tile attributes

	inx
	cpx	#$0080							; if sprite buffer is full, reset
	bcc	+

	ldx	#$0000
+	stx	SprTextMon						; keep track of sprite text buffer filling level
	bra	__PrintSpriteTextLoop

__PrintSpriteTextDone:
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

	ldx	SprTextMon						; start where there is some unused sprite text buffer
	pha

	Accu16

	and	#$00FF							; delete garbage in high byte
	tay

	Accu8

	lda	Cursor
	sta	SpriteBuf1.Text, x					; X
	phx								; preserve tilemap index

	tyx								; adc doesn't support absolute long addressing indexed with Y, so we have to switch to X for that
	clc
	adc.l	FWT_Sprite, x						; advance cursor position as per font width table entry
	sta	Cursor

	plx								; restore tilemap index
	inx
	lda	Cursor+1
	sta	SpriteBuf1.Text, x					; Y
	inx

	pla
;	clc
;	adc	#$80							; diff between ASCII char and tile num
	sta	SpriteBuf1.Text, x					; tile num
	inx

	lda	SprTextPalette
	asl	a							; shift palette num to bit 1-3
	ora	#$30							; set highest priority
	sta	SpriteBuf1.Text, x					; tile attributes
	inx
	cpx	#$0080							; if sprite buffer is full, reset
	bcc	+

	ldx	#$0000
+	stx	SprTextMon						; keep track of sprite text buffer filling level

	plp
	rts



; ************************* Clearing functions *************************

ClearSpriteText:
	Accu16

	lda	#$F0F0
	ldy	#$0000

-	sta	SpriteBuf1.Text, y					; Y, X
	iny
	iny
	iny
	iny
	cpy	#$0080							; 128 / 4 = 32 tiles
	bne	-

	stz	SprTextMon						; reset filling level

	Accu8

	rts



; ******************************** EOF *********************************
