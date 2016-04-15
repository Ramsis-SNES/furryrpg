;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** DEBUG MENU ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

DebugMenu:
	lda #$80				; enter forced blank
	sta $2100

;	lda #$20				; clear V-IRQ enable bit
;	trb DP_Shadow_NMITIMEN

	A16

	stz ARRAY_HDMA_BGScroll+1		; reset BG scroll values

	lda #$00FF
	sta ARRAY_HDMA_BGScroll+3

	A8

	stz DP_HDMAchannels			; disable HDMA



; -------------------------- clear tilemap buffers
	ldx #(TileMapBG1 & $FFFF)
	stx $2181
	stz $2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	ldx #(TileMapBG2 & $FFFF)
	stx $2181
	stz $2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	ldx #(TileMapBG3 & $FFFF)
	stx $2181
	stz $2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	lda #%01110111				; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb DP_DMAUpdates

	WaitForFrames 5				; wait for regs/tilemaps to get cleared

	DisableInterrupts
	SetVblankRoutine TBL_NMI_DebugMenu

;	stz $2133				; SETINI (Display Control 2): no horizontal hi-res



; -------------------------- load new NMI handler & GFX data
	lda #$80				; VRAM address increment mode: increment address after high byte access
	sta $2115

	ldx #ADDR_VRAM_SPR_Tiles		; set VRAM address for sprite tiles
	stx $2116

	DMA_CH0 $01, :GFX_Sprites_Smallfont, GFX_Sprites_Smallfont, $18, 4096

	lda #$80				; set CGRAM address to #256 (word address) for sprites
	sta $2121

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda #%00010111				; turn on BG1/2/3 and sprites
	sta $212C				; on the mainscreen
	sta $212D				; and on the subscreen

	lda #$02
	ldx #0

-	sta SpriteBuf1.PlayableChar, x		; overwrite char sprite buffer area with some unused sprite font tiles
	inx
	inx
	cpx #24
	bne -

	lda REG_RDNMI				; clear NMI flag

	lda #$81				; re-enable Vblank NMI + Auto Joypad Read
	sta DP_Shadow_NMITIMEN
	sta REG_NMITIMEN

	cli



; -------------------------- set background color
	stz $2121				; reset CGRAM address
	stz $2122				; $1C00 = dark blue
	lda #$1C
	sta $2122



; -------------------------- reset song pointer
	A16
	stz DP_NextTrack
	A8



; -------------------------- done, draw debug menu
;	PrintString 2, 3, "FURRY RPG! (Build #00220)"
;	PrintString 3, 3, "(c) by www.ManuLoewe.de"

	PrintString 7, 3, "DEBUG MENU:"

;	DrawFrame 0, 9, 31, 7

	PrintString 10, 3, "Area/dialog test"
	PrintString 11, 3, "Error test (BRK)"
	PrintString 12, 3, "Error test (COP)"
	PrintString 13, 3, "Menu party test"
	PrintString 14, 3, "Mode3 world map"
	PrintString 15, 3, "Mode7 world map"
	PrintString 16, 3, "SNESGSS music test:"
;	PrintString 16, 3, ""
;	PrintString 17, 3, ""

	stz SprTextMon				; reset sprite text filling level so it won't draw more than 1 cursor ;-)

	PrintSpriteText 10, 2, $10, 0		; put cursor on first line ($10 = cursor tile no.)

	wai

	lda #$0F				; turn on the screen
	sta $2100



DebugMenuLoop:
	wai

	A16

	lda DP_NextTrack
	asl a
	tax

	lda.l SRC_TrackPointerTable, x		; load track name pointer
	sta DP_SubStrAddr

	A8

	lda #:SRC_TrackPointerTable
	sta DP_SubStrAddr+2

	PrintString 17, 4, "%s"			; print current SNESGSS song title

	lda #%01000100				; make sure BG3 lo/hi tilemaps get updated
	tsb DP_DMAUpdates



; -------------------------- check for dpad up
	lda Joy1New+1
	and #%00001000
	beq ++

	lda SpriteBuf1.Text+1			; Y coord of cursor
	cmp #78
	beq +
	sec
	sbc #8
	sta SpriteBuf1.Text+1

	bra ++

+	lda #126
	sta SpriteBuf1.Text+1

++



; -------------------------- check for dpad down
	lda Joy1New+1
	and #%00000100
	beq ++

	lda SpriteBuf1.Text+1
	cmp #126
	beq +
	clc
	adc #8
	sta SpriteBuf1.Text+1

	bra ++

+	lda #78
	sta SpriteBuf1.Text+1

++



; -------------------------- check for dpad left
	lda Joy1New+1
	and #%00000010
	beq ++

	lda SpriteBuf1.Text+1			; only do anything if cursor is on music test
	cmp #126
	bne ++

	lda DP_NextTrack			; go to previous track
	dec a
	bpl +
	lda #0
+	sta DP_NextTrack

++



; -------------------------- check for dpad left
	lda Joy1New+1
	and #%00000001
	beq ++

	lda SpriteBuf1.Text+1			; only do anything if cursor is on music test
	cmp #126
	bne ++

	lda DP_NextTrack			; go to next track
	inc a
	cmp #(SRC_TrackPointerTable_END-SRC_TrackPointerTable)/2
	bcc +
	lda #(SRC_TrackPointerTable_END-SRC_TrackPointerTable)/2-1
+	sta DP_NextTrack

++



; -------------------------- check for A button
	lda Joy1New
	and #%10000000
	beq ++

	lda SpriteBuf1.Text+1
	cmp #78
	bne +

	ldx #(TileMapBG3 & $FFFF)		; clear text
	stx $2181
	stz $2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	jmp AreaEnter

+	cmp #86
	bne +

	brk $FF

+	cmp #94
	bne +

	cop $FF

+	cmp #102
	bne +

	jmp PartyMenu

+	cmp #110
	bne +

	bra WorldMode3

+	cmp #118
	bne +

	jmp TestMode7

+	jsl PlayTrack				; else, cursor must be on music test

++



; -------------------------- check for Start
;	lda Joy1New+1
;	and #%00010000
;	beq +

;	WaitForUserInput

;+

	jmp DebugMenuLoop



; ******************************* Test *********************************

WorldMode3:
	lda #$80				; INIDISP (Display Control 1): forced blank
	sta $2100

	stz DP_HDMAchannels			; disable HDMA

	wai					; wait for reg $420C to get cleared

	DisableInterrupts



; -------------------------- load map data
	lda #$80				; VRAM address increment mode: increment address after accessing the high byte ($2119)
	sta $2115

	ldx #$0000				; reset VRAM address
	stx $2116

	DMA_CH0 $01, :GFX_Playfield_001, GFX_Playfield_001, $18, GFX_Playfield_001_END-GFX_Playfield_001	; 45,120 bytes

	ldx #$7C00				; set VRAM address of new BG1 tilemap (has to be greater than GFX length!!)
	stx $2116

	DMA_CH0 $01, :SRC_Playfield_001_MAP, SRC_Playfield_001_MAP, $18, 2048



; -------------------------- set up BG1 tilemap buffer
;	ldx #(>TileMapBG1)<<8+(<TileMapBG1)
;	stx $2181
;	stz $2183

;	DMA_CH0 $00, :SRC_Playfield_001_MAP, SRC_Playfield_001_MAP, $80, 1024



; -------------------------- load palette
	lda #ADDR_CGRAM_WORLDMAP
	sta $2121

	DMA_CH0 $02, :SRC_Palette_Playfield_001, SRC_Palette_Playfield_001, $22, 224	; 112 colors



; -------------------------- set up NMI/misc. parameters
	SetVblankRoutine TBL_NMI_Playfield

	lda #$7C				; set BG1's Tile Map VRAM offset to $7C00 (word address)
	sta $2107				; and the Tile Map size to 32×32 tiles

	lda #$81				; enable NMI and auto-joypad read
	sta DP_Shadow_NMITIMEN
	sta REG_NMITIMEN

	cli



; -------------------------- set some more parameters
	lda #$03				; set BG Mode 3 for playfield
	sta $2105

	lda #%00000001				; turn on BG1 only
	sta $212C				; on the mainscreen
	sta $212D				; and on the subscreen

	lda #CMD_EffectSpeed3
	sta DP_EffectSpeed

	jsr EffectHSplitIn

	WaitForUserInput

	lda #CMD_EffectSpeed3
	sta DP_EffectSpeed

	jsr EffectHSplitOut2

	ldx #(TileMapBG3 & $FFFF)		; clear text
	stx $2181
	stz $2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	lda #$80				; VRAM address increment mode: increment address by one word
	sta $2115				; after accessing the high byte ($2119)

	stz $2116				; regs $2116-$2117: VRAM address
	stz $2117

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0	; clear VRAM

	jml AreaEnter



; ******************************** EOF *********************************
