;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (http://manuloewe.de/)
;
;	*** WORLD MAP ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

LoadWorldMap:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	stz	DP_HDMA_Channels					; disable HDMA

	wai								; wait for reg $420C to get cleared

	DisableIRQs



; -------------------------- load map data
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000							; reset VRAM address
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_WorldMap, GFX_WorldMap, $18, $8000

	ldx	#$4000							; set VRAM address of new BG1 tilemap
	stx	REG_VMADDL

	DMA_CH0 $01, :SRC_Tilemap_WorldMap, SRC_Tilemap_WorldMap, $18, $2000



; -------------------------- load palette
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palette_WorldMap, SRC_Palette_WorldMap, $22, 512



; -------------------------- HDMA tables --> WRAM
	Accu16

	ldx	#0
-	lda.l	SRC_HDMA_ResetBGScroll, x
	sta	ARRAY_HDMA_BG_Scroll, x
	inx
	inx
	cpx	#16
	bne	-

	Accu8



; -------------------------- HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	$4340
	lda	#$0D							; PPU reg. $210D
	sta	$4341
	ldx	#ARRAY_HDMA_BG_Scroll
	stx	$4342
	lda	#$7E
	sta	$4344



; -------------------------- HDMA channel 5: CGRAM address/data
	lda	#$47							; transfer mode (2 bytes --> $2121, 2 bytes --> $2122), indirect addressing mode
	sta	$4350
	lda	#$21							; PPU reg. $2121
	sta	$4351
	ldx	#SRC_HDMA_WorldMapCG1
	stx	$4352
	lda	#:SRC_HDMA_WorldMapCG1
	sta	$4354
	lda	#:SRC_HDMA_WorldMapCG1
	sta	$4357



; -------------------------- set up NMI/misc. parameters
	lda	#%00110000						; enable HDMA ch. 4 (BG1 scroll) & 5 (CGRAM address & data)
	tsb	DP_HDMA_Channels

	SetNMI	TBL_NMI_WorldMap

	lda	#$43							; set BG1's Tile Map VRAM offset to $4000 (word address)
	sta	REG_BG1SC						; and the Tile Map size to 64×64 tiles
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable NMI and auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli



; -------------------------- set some more parameters
	lda	#%00010001						; set BG Mode 1, tile size = 16×16
	sta	REG_BGMODE
	lda	#%00000001						; turn on BG1 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen
	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



WorldMapLoop:
	wai



; -------------------------- check for dpad up
	lda	Joy1Press+1
	and	#%00001000
	beq	__WorldMapLoopDpadUpDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_up
;	sta	DP_Char1SpriteStatus

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+3
	dec	a
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+3
	sta	ARRAY_HDMA_BG_Scroll+8
	sta	ARRAY_HDMA_BG_Scroll+13

	Accu8

__WorldMapLoopDpadUpDone:



; -------------------------- check for dpad down
	lda	Joy1Press+1
	and	#%00000100
	beq	__WorldMapLoopDpadDownDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_down
;	sta	DP_Char1SpriteStatus

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+3
	inc	a
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+3
	sta	ARRAY_HDMA_BG_Scroll+8
	sta	ARRAY_HDMA_BG_Scroll+13

	Accu8

__WorldMapLoopDpadDownDone:



; -------------------------- check for dpad left
	lda	Joy1Press+1
	and	#%00000010
	beq	__WorldMapLoopDpadLeftDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_left
;	sta	DP_Char1SpriteStatus

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+1
	dec	a
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+1
	sta	ARRAY_HDMA_BG_Scroll+6
	sta	ARRAY_HDMA_BG_Scroll+11

	Accu8

__WorldMapLoopDpadLeftDone:



; -------------------------- check for dpad right
	lda	Joy1Press+1
	and	#%00000001
	beq	__WorldMapLoopDpadRightDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_right
;	sta	DP_Char1SpriteStatus

	Accu16

	lda	ARRAY_HDMA_BG_Scroll+1
	inc	a
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+1
	sta	ARRAY_HDMA_BG_Scroll+6
	sta	ARRAY_HDMA_BG_Scroll+11

	Accu8

__WorldMapLoopDpadRightDone:



; -------------------------- check for Start
	lda	Joy1+1
	and	#%00010000
	beq	__WorldMapLoopStButtonDone

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	ldx	#(ARRAY_BG3TileMap & $FFFF)				; clear text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM

	jml	DebugMenu

__WorldMapLoopStButtonDone:
	jmp	WorldMapLoop



; ******************************** EOF *********************************
