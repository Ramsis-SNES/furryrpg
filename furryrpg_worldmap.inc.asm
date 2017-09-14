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
	jsr	SpriteInit

	wai

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
;	ldx	#$5000							; set VRAM address $5000
;	stx	REG_VMADDL

;	DMA_CH0 $01, :GFX_Mode7_Sky, GFX_Mode7_Sky, $18, 4368		; only load upper half of sky gfx

;	ldx	#$3C00							; set VRAM address $3C00
;	stx	REG_VMADDL

;	DMA_CH0 $01, :SRC_TileMap_Mode7_Sky, SRC_TileMap_Mode7_Sky, $18, _sizeof_SRC_TileMap_Mode7_Sky



; -------------------------- load horizon-blurring sprite
	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address $5000
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_SkyBlur, GFX_Sprites_SkyBlur, $18, 576



; -------------------------- load palettes
;	stz	REG_CGADD						; reset CGRAM address

;	DMA_CH0 $02, :SRC_Palette_Mode7_Sky, SRC_Palette_Mode7_Sky, $22, 32

	lda	#$10
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_WorldMap, SRC_Palette_WorldMap+32, $22, 224

	lda	#$C0
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Sprites_SkyBlur, SRC_Palette_Sprites_SkyBlur, $22, 32



; -------------------------- load sky gradient
	Accu16

	ldx	#$0000
-	lda.l	SRC_HDMA_WorldMapSky, x
	sta	ARRAY_HDMA_BackgrPlayfield, x
	inx
	inx
	cpx	#_sizeof_SRC_HDMA_WorldMapSky
	bne	-

	lda	#$0000
-	sta	ARRAY_HDMA_BackgrPlayfield, x				; fill the rest with zeroes
	inx
	inx
	cpx	#896
	bne	-

	Accu8



; -------------------------- HDMA channel 3: sky color gradient
	lda	#%01000011						; transfer mode (4 bytes --> $2121, $2121, $2122, $2122), indirect table mode
	sta	$4330
	lda	#$21							; PPU register $2121 (color index)
	sta	$4331
	ldx	#SRC_HDMA_ColorGradient
	stx	$4332
	lda	#:SRC_HDMA_ColorGradient
	sta	$4334
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4337



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



; -------------------------- HDMA channel 5: BG layer control
	lda	#$01							; transfer mode (1 byte --> $212C, 1 byte --> $212D)
	sta	$4350
	lda	#$2C							; PPU reg. $212C
	sta	$4351
	ldx	#SRC_HDMA_WorMapLayerControl
	stx	$4352
	lda	#:SRC_HDMA_WorMapLayerControl
	sta	$4354



; -------------------------- HDMA channel 6: window mask
	lda	#$01							; transfer mode (1 byte --> $2126, 1 byte --> $2127)
	sta	$4360
	lda	#$26							; PPU reg. $2126
	sta	$4361
	ldx	#SRC_HDMA_WorMapCurvature
	stx	$4362
	lda	#:SRC_HDMA_WorMapCurvature
	sta	$4364



; -------------------------- write horizon-blurring sprites to sprite buffer
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved
	lda	#35
	sta	ARRAY_SpriteBuf1.Reserved+1
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+2
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+3

	lda	#16
	sta	ARRAY_SpriteBuf1.Reserved+4
	lda	#34
	sta	ARRAY_SpriteBuf1.Reserved+5
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+6
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+7

	lda	#32
	sta	ARRAY_SpriteBuf1.Reserved+8
	lda	#33
	sta	ARRAY_SpriteBuf1.Reserved+9
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+10
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+11

	lda	#40
	sta	ARRAY_SpriteBuf1.Reserved+12
	lda	#33
	sta	ARRAY_SpriteBuf1.Reserved+13
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+14
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+15

	lda	#56
	sta	ARRAY_SpriteBuf1.Reserved+16
	lda	#32
	sta	ARRAY_SpriteBuf1.Reserved+17
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+18
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+19

	lda	#72
	sta	ARRAY_SpriteBuf1.Reserved+20
	lda	#32
	sta	ARRAY_SpriteBuf1.Reserved+21
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+22
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+23

	lda	#88
	sta	ARRAY_SpriteBuf1.Reserved+24
	lda	#32
	sta	ARRAY_SpriteBuf1.Reserved+25
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+26
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+27

	lda	#104
	sta	ARRAY_SpriteBuf1.Reserved+28
	lda	#31
	sta	ARRAY_SpriteBuf1.Reserved+29
	lda	#0
	sta	ARRAY_SpriteBuf1.Reserved+30
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.Reserved+31

	lda	#120
	sta	ARRAY_SpriteBuf1.NPCs
	lda	#31
	sta	ARRAY_SpriteBuf1.NPCs+1
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+2
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+3

	lda	#136
	sta	ARRAY_SpriteBuf1.NPCs+4
	lda	#31
	sta	ARRAY_SpriteBuf1.NPCs+5
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+6
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+7

	lda	#152
	sta	ARRAY_SpriteBuf1.NPCs+8
	lda	#32
	sta	ARRAY_SpriteBuf1.NPCs+9
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+10
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+11

	lda	#168
	sta	ARRAY_SpriteBuf1.NPCs+12
	lda	#32
	sta	ARRAY_SpriteBuf1.NPCs+13
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+14
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+15

	lda	#184
	sta	ARRAY_SpriteBuf1.NPCs+16
	lda	#32
	sta	ARRAY_SpriteBuf1.NPCs+17
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+18
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+19

	lda	#200
	sta	ARRAY_SpriteBuf1.NPCs+20
	lda	#33
	sta	ARRAY_SpriteBuf1.NPCs+21
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+22
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+23

	lda	#208
	sta	ARRAY_SpriteBuf1.NPCs+24
	lda	#33
	sta	ARRAY_SpriteBuf1.NPCs+25
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+26
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+27

	lda	#224
	sta	ARRAY_SpriteBuf1.NPCs+28
	lda	#34
	sta	ARRAY_SpriteBuf1.NPCs+29
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+30
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+31

	lda	#240
	sta	ARRAY_SpriteBuf1.NPCs+32
	lda	#35
	sta	ARRAY_SpriteBuf1.NPCs+33
	lda	#0
	sta	ARRAY_SpriteBuf1.NPCs+34
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_SpriteBuf1.NPCs+35



; -------------------------- set transparency for blurring sprites
	lda	#$E0							; subscreen backdrop color
	sta	REG_COLDATA
	sta	REG_COLDATA
	lda	#%0000010						; enable BGs/OBJs on subscreen
	sta	REG_CGWSEL
	lda	#%00000111						; enable color math on BG1, add subscreen
	sta	REG_CGADSUB



; -------------------------- set up NMI/misc. parameters
	SetNMI	TBL_NMI_WorldMap

	lda	#%01111000						; enable HDMA ch. 3 (sky color gradient), 4 (BG1 scroll), 5 (layer control) & 6 (window mask)
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
	lda	#%00110011						; set up window mask for planet curvature
	sta	REG_W12SEL
	lda	#%00000011
	sta	REG_TMW
	sta	REG_TSW
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable NMI & auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli
	jsr	CalculateVerticalScrollDisplacement
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



; -------------------------- check for A button
;	lda	DP_Joy1New
;	bpl	+
;	lda	DP_HDMA_Channels						; toggle HDMA ch. 3 (sky color gradient)
;	eor	#%00001000
;	sta	DP_HDMA_Channels
;+



; -------------------------- check for Start
	lda	DP_Joy1+1
	and	#%00010000
	beq	__WorldMapLoopStButtonDone

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	stz	DP_HDMA_Channels					; disable HDMA
	wai
	lda	#%00110000						; set color math disable bits (4-5)
	sta	REG_CGWSEL
	stz	REG_CGADSUB
;	ldx	#(ARRAY_BG3TileMap & $FFFF)				; clear text
;	stx	REG_WMADDL
;	stz	REG_WMADDH

;	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	stz	REG_W12SEL						; clear window regs
	stz	REG_TMW
	stz	REG_TSW
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM

	jml	DebugMenu

__WorldMapLoopStButtonDone:

	jsr	CalculateVerticalScrollDisplacement

	jmp	WorldMapLoop



CalculateVerticalScrollDisplacement:
	ldx	#(ARRAY_ScratchSpace & $FFFF)				; set data address for upcoming loop
	stx	DP_DataSrcAddress
	lda	#$7E
	sta	DP_DataSrcBank

	Accu16

	ldx	#0
	ldy	#0
-	lda	DP_WorldMapBG1VScroll
	sec
	sbc.l	SRC_HDMA_WorMapVertScrDisplacement, x			; subtract displacement value for each scanline
	and	#$3FFF
	sta	[DP_DataSrcAddress], y					; save to HDMA array
	inx
	inx
	iny
	iny
	cpy	#448							; 224 scanlines done?
	bne	-

	Accu8

	rts



; ******************************** EOF *********************************
