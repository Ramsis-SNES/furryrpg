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
	sta	VAR_ShadowINIDISP
	stz	DP_HDMA_Channels					; disable HDMA
	jsr	SpriteInit

	wai

	DisableIRQs



; -------------------------- load map data
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000							; reset VRAM address
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_WorldMap, GFX_WorldMap, <REG_VMDATAL, 29696

	ldx	#$4000							; set VRAM address of new BG1 tilemap
	stx	REG_VMADDL

	DMA_CH0 $01, :SRC_Tilemap_WorldMap, SRC_Tilemap_WorldMap, <REG_VMDATAL, $2000



; -------------------------- load sky data
;	ldx	#$5000							; set VRAM address $5000
;	stx	REG_VMADDL

;	DMA_CH0 $01, :GFX_Mode7_Sky, GFX_Mode7_Sky, <REG_VMDATAL, 4368	; only load upper half of sky gfx

;	ldx	#$3C00							; set VRAM address $3C00
;	stx	REG_VMADDL

;	DMA_CH0 $01, :SRC_TileMap_Mode7_Sky, SRC_TileMap_Mode7_Sky, <REG_VMDATAL, _sizeof_SRC_TileMap_Mode7_Sky



; -------------------------- load horizon-blurring sprite
	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address $5000
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_SkyBlur, GFX_Sprites_SkyBlur, <REG_VMDATAL, 576



; -------------------------- load palettes
;	stz	REG_CGADD						; reset CGRAM address

;	DMA_CH0 $02, :SRC_Palette_Mode7_Sky, SRC_Palette_Mode7_Sky, <REG_CGDATA, 32

	lda	#$10
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_WorldMap, SRC_Palette_WorldMap+32, <REG_CGDATA, 224

	lda	#$C0
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Sprites_SkyBlur, SRC_Palette_Sprites_SkyBlur, <REG_CGDATA, 32



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
	sta	REG_DMAP3
	lda	#<REG_CGADD							; PPU register $2121 (color index)
	sta	REG_BBAD3
	ldx	#SRC_HDMA_ColorGradient
	stx	REG_A1T3L
	lda	#:SRC_HDMA_ColorGradient
	sta	REG_A1B3
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB3



; -------------------------- HDMA channel 4: BG1 vertical scroll register
	lda	#$42							; transfer mode (2 bytes --> $210E), indirect addressing mode
	sta	REG_DMAP4
	lda	#<REG_BG1VOFS						; PPU reg. $210E
	sta	REG_BBAD4
	ldx	#SRC_HDMA_WorMapVScroll
	stx	REG_A1T4L
	lda	#:SRC_HDMA_WorMapVScroll
	sta	REG_A1B4
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB4



; -------------------------- HDMA channel 5: BG layer control
	lda	#$01							; transfer mode (1 byte --> $212C, 1 byte --> $212D)
	sta	REG_DMAP5
	lda	#<REG_TM						; PPU reg. $212C
	sta	REG_BBAD5
	ldx	#SRC_HDMA_WorMapLayerControl
	stx	REG_A1T5L
	lda	#:SRC_HDMA_WorMapLayerControl
	sta	REG_A1B5



; -------------------------- HDMA channel 6: window mask
	lda	#$01							; transfer mode (1 byte --> $2126, 1 byte --> $2127)
	sta	REG_DMAP6
	lda	#<REG_WH0						; PPU reg. $2126
	sta	REG_BBAD6
	ldx	#SRC_HDMA_WorMapCurvature
	stx	REG_A1T6L
	lda	#:SRC_HDMA_WorMapCurvature
	sta	REG_A1B6



; -------------------------- write horizon-blurring sprites to sprite buffer
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+128
	lda	#35
	sta	ARRAY_ShadowOAM_Lo+129
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+130
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+131

	lda	#16
	sta	ARRAY_ShadowOAM_Lo+132
	lda	#34
	sta	ARRAY_ShadowOAM_Lo+133
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+134
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+135

	lda	#32
	sta	ARRAY_ShadowOAM_Lo+136
	lda	#33
	sta	ARRAY_ShadowOAM_Lo+137
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+138
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+139

	lda	#40
	sta	ARRAY_ShadowOAM_Lo+140
	lda	#33
	sta	ARRAY_ShadowOAM_Lo+141
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+142
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+143

	lda	#56
	sta	ARRAY_ShadowOAM_Lo+144
	lda	#32
	sta	ARRAY_ShadowOAM_Lo+145
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+146
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+147

	lda	#72
	sta	ARRAY_ShadowOAM_Lo+148
	lda	#32
	sta	ARRAY_ShadowOAM_Lo+149
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+150
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+151

	lda	#88
	sta	ARRAY_ShadowOAM_Lo+152
	lda	#32
	sta	ARRAY_ShadowOAM_Lo+153
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+154
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+155

	lda	#104
	sta	ARRAY_ShadowOAM_Lo+156
	lda	#31
	sta	ARRAY_ShadowOAM_Lo+157
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+158
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+159

	lda	#120
	sta	ARRAY_ShadowOAM_Lo+160
	lda	#31
	sta	ARRAY_ShadowOAM_Lo+161
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+162
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+163

	lda	#136
	sta	ARRAY_ShadowOAM_Lo+164
	lda	#31
	sta	ARRAY_ShadowOAM_Lo+165
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+166
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+167

	lda	#152
	sta	ARRAY_ShadowOAM_Lo+168
	lda	#32
	sta	ARRAY_ShadowOAM_Lo+169
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+170
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+171

	lda	#168
	sta	ARRAY_ShadowOAM_Lo+172
	lda	#32
	sta	ARRAY_ShadowOAM_Lo+173
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+174
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+175

	lda	#184
	sta	ARRAY_ShadowOAM_Lo+176
	lda	#32
	sta	ARRAY_ShadowOAM_Lo+177
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+178
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+179

	lda	#200
	sta	ARRAY_ShadowOAM_Lo+180
	lda	#33
	sta	ARRAY_ShadowOAM_Lo+181
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+182
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+183

	lda	#208
	sta	ARRAY_ShadowOAM_Lo+184
	lda	#33
	sta	ARRAY_ShadowOAM_Lo+185
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+186
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+187

	lda	#224
	sta	ARRAY_ShadowOAM_Lo+188
	lda	#34
	sta	ARRAY_ShadowOAM_Lo+189
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+190
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+191

	lda	#240
	sta	ARRAY_ShadowOAM_Lo+192
	lda	#35
	sta	ARRAY_ShadowOAM_Lo+193
	lda	#0
	sta	ARRAY_ShadowOAM_Lo+194
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	ARRAY_ShadowOAM_Lo+195



; -------------------------- set transparency for blurring sprites
	lda	#$E0							; subscreen backdrop color
	sta	VAR_ShadowCOLDATA
	sta	VAR_ShadowCOLDATA
	lda	#%0000010						; enable BGs/OBJs on subscreen
	sta	VAR_ShadowCGWSEL
	lda	#%00000111						; enable color math on BG1, add subscreen
	sta	VAR_ShadowCGADSUB



; -------------------------- set up NMI and shadow PPU regs /misc. parameters
	SetNMI	TBL_NMI_WorldMap

	lda	#%01111000						; enable HDMA ch. 3 (sky color gradient), 4 (BG1 scroll), 5 (layer control) & 6 (window mask)
	tsb	DP_HDMA_Channels
	lda	#%00010001						; set BG Mode 1, tile size = 16×16 (layer control is done via HDMA)
	sta	VAR_ShadowBGMODE
	lda	#$43							; set BG1's Tile Map VRAM offset to $4000 (word address)
	sta	VAR_ShadowBG1SC						; and the Tile Map size to 64×64 tiles
	lda	#$3C							; BG2 tile map VRAM offset: $3C00, Tile Map size: 32×32 tiles
	sta	VAR_ShadowBG2SC
	lda	#$50							; BG2 character data VRAM offset: $5000 (ignore BG1 bits)
	sta	VAR_ShadowBG12NBA
	lda	#$FF							; scroll BG2 down by 1 px
	sta	REG_BG2VOFS
	stz	REG_BG2VOFS
	lda	#%00110011						; set up window mask for planet curvature
	sta	VAR_ShadowW12SEL
	lda	#%00000011
	sta	VAR_ShadowTMW
	sta	VAR_ShadowTSW
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable NMI & auto-joypad read
	sta	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli
	jsr	CalcVScrollDisplacement

	wai								; wait for register/sprite buffer update before split-in effect
	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



WorldMapLoop:
	wai



; -------------------------- check for dpad up
	lda	DP_Joy1Press+1
	and	#%00001000
	beq	@DpadUpDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_up
;	sta	DP_Char1SpriteStatus

	Accu16

	dec	DP_WorldMapBG1VScroll

	Accu8

@DpadUpDone:



; -------------------------- check for dpad down
	lda	DP_Joy1Press+1
	and	#%00000100
	beq	@DpadDownDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_down
;	sta	DP_Char1SpriteStatus

	Accu16

	inc	DP_WorldMapBG1VScroll

	Accu8

@DpadDownDone:



; -------------------------- check for dpad left
	lda	DP_Joy1Press+1
	and	#%00000010
	beq	@DpadLeftDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_left
;	sta	DP_Char1SpriteStatus

	Accu16

	dec	DP_WorldMapBG1HScroll

	Accu8

@DpadLeftDone:



; -------------------------- check for dpad right
	lda	DP_Joy1Press+1
	and	#%00000001
	beq	@DpadRightDone

;	stz	DP_PlayerIdleCounter
;	stz	DP_PlayerIdleCounter+1
;	lda	#TBL_Char1_right
;	sta	DP_Char1SpriteStatus

	Accu16

	inc	DP_WorldMapBG1HScroll

	Accu8

@DpadRightDone:



; -------------------------- check for A button
;	lda	DP_Joy1New
;	bpl	@AButtonDone
;	lda	DP_HDMA_Channels						; toggle HDMA ch. 3 (sky color gradient)
;	eor	#%00001000
;	sta	DP_HDMA_Channels
;
;@AButtonDone:



; -------------------------- check for Start
	lda	DP_Joy1+1
	and	#%00010000
	beq	@StartButtonDone

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	stz	DP_HDMA_Channels					; disable HDMA
	lda	#%00110000						; set color math disable bits (4-5)
	sta	VAR_ShadowCGWSEL
	lda	#$00
	sta	VAR_ShadowCGADSUB
	sta	VAR_ShadowW12SEL					; clear window regs
	sta	VAR_ShadowTMW
	sta	VAR_ShadowTSW
	wai
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, <REG_VMDATAL, 0	; clear VRAM

	jml	DebugMenu

@StartButtonDone:

	jsr	CalcVScrollDisplacement

	jmp	WorldMapLoop



CalcVScrollDisplacement:
	ldx	#(ARRAY_ScratchSpace & $FFFF)				; set data address for upcoming loop
	stx	DP_DataAddress
	lda	#$7E
	sta	DP_DataBank

	Accu16

	ldx	#0
	ldy	#0
-	lda	DP_WorldMapBG1VScroll
	sec
	sbc.l	SRC_HDMA_WorMapVScrollDisplacement, x			; subtract displacement value for each scanline
	and	#$3FFF
	sta	[DP_DataAddress], y					; save to HDMA array
	inx
	inx
	iny
	iny
	cpy	#448							; 224 scanlines done?
	bne	-

	Accu8

	rts



; ******************************** EOF *********************************
