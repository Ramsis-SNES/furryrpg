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
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	Accu16

	stz	ARRAY_HDMA_BGScroll+1					; reset BG scroll values
	lda	#$00FF
	sta	ARRAY_HDMA_BGScroll+3

	Accu8

	stz	DP_HDMAchannels						; disable HDMA



; -------------------------- clear tilemap buffers
	ldx	#(TileMapBG1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	ldx	#(TileMapBG2 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	ldx	#(TileMapBG3 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	lda	#%01110111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates

	WaitFrames	5						; wait for regs/tilemaps to get cleared

	DisableIRQs
	SetNMI	TBL_NMI_DebugMenu

;	stz	REG_SETINI						; SETINI (Display Control 2): no horizontal hi-res



; -------------------------- load new NMI handler & GFX data
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	TileMapBG3Hi, x						; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-

	ldx	#ADDR_VRAM_SPR_Tiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_Smallfont, GFX_Sprites_Smallfont, $18, 4096

	stz	$2121							; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	$2121

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	Accu16

	lda	#%0001011100010111					; turn on BG1/2/3 and sprites on mainscreen and subscreen
	sta	REG_TM
	sta	DP_Shadow_TSTM						; copy to shadow variable

	Accu8

	lda	#$02
	ldx	#0
-	sta	SpriteBuf1.PlayableChar, x				; overwrite char sprite buffer area with some unused sprite font tiles
	inx
	inx
	cpx	#24
	bne	-

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; re-enable Vblank NMI + Auto Joypad Read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli



; -------------------------- update registers in case they've been messed with
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	$2109
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	$210C
	lda	#$01							; set BG Mode 1
	sta	REG_BGMODE

	stz	$2121							; reset CGRAM address
	stz	$2122							; $1C00 = dark blue as background color
	lda	#$1C
	sta	$2122



; -------------------------- reset song pointer
	Accu16

	stz	DP_NextTrack

	Accu8



; -------------------------- done, draw debug menu
;	PrintString 2, 3, "FURRY RPG! (Build #00220)"
;	PrintString 3, 3, "(c) by www.ManuLoewe.de"

	PrintString 7, 3, "DEBUG MENU:"

;	DrawFrame 0, 9, 31, 7

	PrintString 10, 3, "Alpha intro"
	PrintString 11, 3, "Area/dialog test"
	PrintString 12, 3, "Error test (BRK)"
	PrintString 13, 3, "Error test (COP)"
	PrintString 14, 3, "Mode3 world map"
	PrintString 15, 3, "Mode7 world map"
	PrintString 16, 3, "Move sprite on circular path"
	PrintString 17, 3, "SNESGSS music test:"
;	PrintString 16, 3, ""
;	PrintString 17, 3, ""

	stz	SprTextMon						; reset sprite text filling level so it won't draw more than 1 cursor ;-)

	PrintSpriteText 10, 2, $10, 0					; put cursor on first line ($10 = cursor tile no.)

	wai

	lda	#$0F							; turn on the screen
	sta	REG_INIDISP



DebugMenuLoop:
	wai

-	lda	REG_HVBJOY						; are we still on Vblank?
	bmi	-							; yes, wait

	Accu16

	lda	DP_NextTrack
	asl	a
	tax
	lda.l	SRC_TrackPointerTable, x				; load track name pointer
	sta	DP_SubStrAddr

	Accu8

	lda	#:SRC_TrackPointerTable
	sta	DP_SubStrAddr+2

	PrintString 18, 4, "%s"						; print current SNESGSS song title

	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates



; -------------------------- check for dpad up
	lda	Joy1New+1
	and	#%00001000
	beq	++

	lda	SpriteBuf1.Text+1					; Y coord of cursor
	cmp	#78
	beq	+
	sec
	sbc	#8
	sta	SpriteBuf1.Text+1

	bra	++

+	lda	#134
	sta	SpriteBuf1.Text+1

++



; -------------------------- check for dpad down
	lda	Joy1New+1
	and	#%00000100
	beq	++

	lda	SpriteBuf1.Text+1
	cmp	#134
	beq	+
	clc
	adc	#8
	sta	SpriteBuf1.Text+1

	bra	++

+	lda	#78
	sta	SpriteBuf1.Text+1

++



; -------------------------- check for dpad left
	lda	Joy1New+1
	and	#%00000010
	beq	++

	lda	SpriteBuf1.Text+1					; only do anything if cursor is on music test
	cmp	#134
	bne	++

	lda	DP_NextTrack						; go to previous track
	dec	a
	bpl	+
	lda	#0
+	sta	DP_NextTrack

++



; -------------------------- check for dpad left
	lda	Joy1New+1
	and	#%00000001
	beq	++

	lda	SpriteBuf1.Text+1					; only do anything if cursor is on music test
	cmp	#134
	bne	++

	lda	DP_NextTrack						; go to next track
	inc	a
	cmp	#(SRC_TrackPointerTable_END-SRC_TrackPointerTable)/2
	bcc	+
	lda	#(SRC_TrackPointerTable_END-SRC_TrackPointerTable)/2-1
+	sta	DP_NextTrack

++



; -------------------------- check for A button
	lda	Joy1New
	and	#%10000000
	beq	++

	lda	SpriteBuf1.Text+1
	cmp	#78
	bne	+

	jmp	AlphaIntro

+	cmp	#86
	bne	+

	ldx	#(TileMapBG3 & $FFFF)					; clear text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	jmp	AreaEnter

+	cmp	#94
	bne	+

	brk	$FF

+	cmp	#102
	bne	+

	cop	$FF

+	cmp	#110
	bne	+

	jmp	WorldMode3

+	cmp	#118
	bne	+

	jmp	TestMode7

+	cmp	#126
	bne	+

	jmp	MoveSpriteCircularTest

+	jsl	PlayTrack						; else, cursor must be on music test

++



; -------------------------- check for Start
;	lda	Joy1Press+1
;	and	#%00010000
;	beq	+

;	DoSomething

;+

	jsr	ShowCPUload
	jmp	DebugMenuLoop



; ************************ Debugging functions *************************

; -------------------------- show CPU load (via scanline counter)
ShowCPUload:
	lda	REG_SLHV						; latch H/V counter
	lda	REG_STAT78						; reset OPHCT/OPVCT flip-flops
	lda	REG_OPVCT
	sta	DP_CurrentScanline
	lda	REG_OPVCT
	and	#$01							; mask off 7 open bus bits
	sta	DP_CurrentScanline+1

	SetTextPos 2, 2
	PrintNum DP_CurrentScanline

	jsr	PrintF
	.DB "  ", 0							; clear trailing numbers from old values

	rts



; ******************************* Tests ********************************

MoveSpriteCircularTest:
	ldx	#(TileMapBG3 & $FFFF)					; clear BG3 tilemap
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	stz	temp							; reset angle
	stz	temp+1

	lda	#70							; set radius
	sta	temp+2

; X := CenterX + sin(angle)*radius
; Y := CenterY + cos(angle)*radius

	PrintString 2, 20, "Angle: $"



__MSCTestLoop:
	wai

-	lda	REG_HVBJOY						; are we still on Vblank?
	bmi	-							; yes, wait

	SetTextPos 2, 28
	PrintHexNum temp

	ldx	temp
	lda.l	SRC_Mode7Sin, x
	sta	$211B
	stz	$211B
	lda	temp+2							; radius
	sta	$211C

	lda	$2135
	clc
	adc	#128
	sta	SpriteBuf1.Text						; X

	lda	temp
	cmp	#$81
	bcc	+
	
	lda	SpriteBuf1.Text						; if angle > $80, subtract radius
	sec
	sbc	temp+2
	sta	SpriteBuf1.Text						; X

+	ldx	temp
	lda.l	SRC_Mode7Cos, x
	sta	$211B
	stz	$211B
	lda	temp+2							; radius
	sta	$211C

	lda	$2135
	clc
	adc	#112
	sta	SpriteBuf1.Text+1					; Y

	lda	temp
	cmp	#$C0
	bcs	+
	cmp	#$41
	bcc	+

	lda	SpriteBuf1.Text+1					; if $40 < angle < $C0, subtract radius
	sec
	sbc	temp+2
	sta	SpriteBuf1.Text+1					; Y

+	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates

	inc	temp



; -------------------------- check for Start
	lda	Joy1New+1
	and	#%00010000
	beq	+

	jmp	DebugMenu
+

	jsr	ShowCPUload
	jmp	__MSCTestLoop



WorldMode3:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	stz	DP_HDMAchannels						; disable HDMA

	wai								; wait for reg $420C to get cleared

	DisableIRQs



; -------------------------- load map data
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000							; reset VRAM address
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Playfield_001, GFX_Playfield_001, $18, GFX_Playfield_001_END-GFX_Playfield_001	; 45,120 bytes

	ldx	#$7C00							; set VRAM address of new BG1 tilemap (has to be greater than GFX length!!)
	stx	REG_VMADDL

	DMA_CH0 $01, :SRC_Playfield_001_MAP, SRC_Playfield_001_MAP, $18, 2048



; -------------------------- set up BG1 tilemap buffer
;	ldx	#(TileMapBG1 & $FFFF)
;	stx	REG_WMADDL
;	stz	REG_WMADDH

;	DMA_CH0 $00, :SRC_Playfield_001_MAP, SRC_Playfield_001_MAP, $80, 1024



; -------------------------- load palette
	lda	#ADDR_CGRAM_WORLDMAP
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Playfield_001, SRC_Palette_Playfield_001, $22, 224	; 112 colors



; -------------------------- set up NMI/misc. parameters
	SetNMI	TBL_NMI_Playfield

	lda	#$7C							; set BG1's Tile Map VRAM offset to $7C00 (word address)
	sta	$2107							; and the Tile Map size to 32×32 tiles

	lda	#$81							; enable NMI and auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli



; -------------------------- set some more parameters
	lda	#$03							; set BG Mode 3 for playfield
	sta	REG_BGMODE

	lda	#%00000001						; turn on BG1 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn

	WaitUserInput

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	ldx	#(TileMapBG3 & $FFFF)					; clear text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM

	jml	AreaEnter



; ******************************** EOF *********************************
