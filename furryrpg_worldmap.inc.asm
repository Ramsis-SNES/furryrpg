;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
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

	DMA_CH0 $01, :GFX_WorldMap, GFX_WorldMap, $18, 29696

	ldx	#$4000							; set VRAM address of new BG1 tilemap
	stx	REG_VMADDL

	DMA_CH0 $01, :SRC_Tilemap_WorldMap, SRC_Tilemap_WorldMap, $18, $2000



; -------------------------- load sky data
	ldx	#$5000							; set VRAM address $5000
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Mode7_Sky, GFX_Mode7_Sky, $18, 4368		; only load upper half of sky gfx

	ldx	#$3C00							; set VRAM address $3C00
	stx	REG_VMADDL

	DMA_CH0 $01, :SRC_TileMap_Mode7_Sky, SRC_TileMap_Mode7_Sky, $18, _sizeof_SRC_TileMap_Mode7_Sky



; -------------------------- load palettes
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palette_Mode7_Sky, SRC_Palette_Mode7_Sky, $22, 32

	DMA_CH0 $02, :SRC_Palette_WorldMap, SRC_Palette_WorldMap+32, $22, 480



; -------------------------- load horizon blur
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathMode1, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMode1
	bne	-

	lda	#%00000000						; clear color math disable bits (4-5)
	sta	REG_CGWSEL
	lda	#%00110111						; enable color math on BG1/2/3 + sprites + backdrop
	sta	REG_CGADSUB



; -------------------------- HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	$4330
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	$4331
	ldx	#ARRAY_HDMA_ColorMath
	stx	$4332
	lda	#$7E							; table in WRAM expected
	sta	$4334



; -------------------------- HDMA channel 4: BG1 vertical scroll register
	lda	#$42							; transfer mode (2 bytes --> $210E), indirect addressing mode
	sta	$4340
	lda	#$0E							; PPU reg. $210E
	sta	$4341
	ldx	#SRC_HDMA_WorMapVertScr
	stx	$4342
	lda	#:SRC_HDMA_WorMapVertScr
	sta	$4344
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4347



; -------------------------- HDMA channel 4: BG1 horizontal scroll register
;	lda	#$02							; transfer mode (2 bytes --> $210D)
;	sta	$4340
;	lda	#$0D							; PPU reg. $210D
;	sta	$4341
;	ldx	#ARRAY_HDMA_BG_Scroll
;	stx	$4342
;	lda	#$7E
;	sta	$4344



; -------------------------- HDMA channel 5: Layer control
	lda	#$01							; transfer mode (1 byte --> $212C, 1 byte --> $212D)
	sta	$4350
	lda	#$2C							; PPU reg. $212C
	sta	$4351
	ldx	#SRC_HDMA_WorMapLayerControl
	stx	$4352
	lda	#:SRC_HDMA_WorMapLayerControl
	sta	$4354



; -------------------------- set up NMI/misc. parameters
	SetNMI	TBL_NMI_WorldMap

	lda	#%00111000						; enable HDMA ch. 3 (color math), 4 (BG1 scroll) & 5 (layer control)
	tsb	DP_HDMA_Channels
	lda	#%00010001						; set BG Mode 1, tile size = 16×16 (layer control is done via HDMA)
	sta	REG_BGMODE
	lda	#$43							; set BG1's Tile Map VRAM offset to $4000 (word address)
	sta	REG_BG1SC						; and the Tile Map size to 64×64 tiles
	lda	#$3C							; BG2 tile map VRAM offset: $3C00, Tile Map size: 32×32 tiles
	sta	REG_BG2SC
	lda	#$50							; BG2 character data VRAM offset: $5000 (ignore BG1 bits)
	sta	REG_BG12NBA
	lda	#$FF							; scroll BG2 down by 1 px
	sta	REG_BG2VOFS
	stz	REG_BG2VOFS
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable NMI & auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli
	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



WorldMapLoop:
	wai



; -------------------------- check for dpad up
	lda	DP_Joy1Press+1
	and	#%00001000
	beq	__WorldMapLoopDpadUpDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_up
;	sta	DP_Char1SpriteStatus

	Accu16

	dec	DP_WorldMapBG1VScroll

	Accu8

__WorldMapLoopDpadUpDone:



; -------------------------- check for dpad down
	lda	DP_Joy1Press+1
	and	#%00000100
	beq	__WorldMapLoopDpadDownDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_down
;	sta	DP_Char1SpriteStatus

	Accu16

	inc	DP_WorldMapBG1VScroll

	Accu8

__WorldMapLoopDpadDownDone:



; -------------------------- check for dpad left
	lda	DP_Joy1Press+1
	and	#%00000010
	beq	__WorldMapLoopDpadLeftDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_left
;	sta	DP_Char1SpriteStatus

	Accu16

	dec	DP_WorldMapBG1HScroll

	Accu8

__WorldMapLoopDpadLeftDone:



; -------------------------- check for dpad right
	lda	DP_Joy1Press+1
	and	#%00000001
	beq	__WorldMapLoopDpadRightDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_right
;	sta	DP_Char1SpriteStatus

	Accu16

	inc	DP_WorldMapBG1HScroll

	Accu8

__WorldMapLoopDpadRightDone:



; -------------------------- check for Start
	lda	DP_Joy1+1
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
