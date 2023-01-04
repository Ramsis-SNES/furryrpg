;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** WORLD MAP ***
;
;==========================================================================================



LoadWorldMap:
	.ACCU 8
	.INDEX 16

	lda	#$80							; enter forced blank
	sta	RAM_INIDISP
	stz	<DP2.HDMA_Channels					; disable HDMA
	jsr	SpriteInit

	wai

	DisableIRQs



; Load map data
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#$0000							; reset VRAM address
	stx	VMADDL

	DMA_CH0 $01, SRC_WorldMap, VMDATAL, 29696

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 3072				; clear area $3C00-$4000 (BG2 tilemap) in case it was used (like by Mode 7 map) // FIXME, use for BG2 tilemap data or disable BG2 completely

;	ldx	#$4000							; set VRAM address of new BG1 tilemap
;	stx	VMADDL

	DMA_CH0 $01, SRC_Tilemap_WorldMap, VMDATAL, 8192



; Load sky data
;	ldx	#$5000							; set VRAM address $5000
;	stx	VMADDL

;	DMA_CH0 $01, SRC_Mode7_Sky, VMDATAL, 4368			; only load upper half of sky gfx

;	ldx	#$3C00							; set VRAM address $3C00
;	stx	VMADDL

;	DMA_CH0 $01, SRC_TileMap_Mode7_Sky, VMDATAL, _sizeof_SRC_TileMap_Mode7_Sky



; Load horizon-blurring sprite
	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Sprites_SkyBlur, VMDATAL, 576



; Load palettes
;	stz	CGADD							; reset CGRAM address

;	DMA_CH0 $02, SRC_Palette_Mode7_Sky, CGDATA, 32

	lda	#$10
	sta	CGADD

	DMA_CH0 $02, SRC_Palette_WorldMap+32, CGDATA, 224

	lda	#$C0
	sta	CGADD

	DMA_CH0 $02, SRC_Palette_Sprites_SkyBlur, CGDATA, 32



; Load sky gradient
	Accu16

	ldx	#$0000
-	lda.l	SRC_HDMA_WorldMapSky, x
	sta	RAM.HDMA_BackgrPlayfield, x
	inx
	inx
	cpx	#_sizeof_SRC_HDMA_WorldMapSky
	bne	-

	lda	#$0000
-	sta	RAM.HDMA_BackgrPlayfield, x				; fill the rest with zeroes
	inx
	inx
	cpx	#896
	bne	-

	Accu8



; HDMA channel 3: sky color gradient
	lda	#%01000011						; transfer mode (4 bytes --> $2121, $2121, $2122, $2122), indirect table mode
	sta	DMAP3
	lda	#<CGADD							; PPU register $2121 (color index)
	sta	BBAD3
	ldx	#SRC_HDMA_ColorGradient
	stx	A1T3L
	lda	#:SRC_HDMA_ColorGradient
	sta	A1B3
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB3



; HDMA channel 4: BG1 vertical scroll register
	lda	#$42							; transfer mode (2 bytes --> $210E), indirect addressing mode
	sta	DMAP4
	lda	#<BG1VOFS						; PPU reg. $210E
	sta	BBAD4
	ldx	#SRC_HDMA_WorMapVScroll
	stx	A1T4L
	lda	#:SRC_HDMA_WorMapVScroll
	sta	A1B4
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB4



; HDMA channel 5: BG layer control
	lda	#$01							; transfer mode (1 byte --> $212C, 1 byte --> $212D)
	sta	DMAP5
	lda	#<TM							; PPU reg. $212C
	sta	BBAD5
	ldx	#SRC_HDMA_WorMapLayerControl
	stx	A1T5L
	lda	#:SRC_HDMA_WorMapLayerControl
	sta	A1B5



; HDMA channel 6: window mask
	lda	#$01							; transfer mode (1 byte --> $2126, 1 byte --> $2127)
	sta	DMAP6
	lda	#<WH0							; PPU reg. $2126
	sta	BBAD6
	ldx	#SRC_HDMA_WorMapCurvature
	stx	A1T6L
	lda	#:SRC_HDMA_WorMapCurvature
	sta	A1B6



; Write horizon-blurring sprites to sprite buffer
	lda	#0
	sta	LO8.ShadowOAM_Lo+128
	lda	#35
	sta	LO8.ShadowOAM_Lo+129
	lda	#0
	sta	LO8.ShadowOAM_Lo+130
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+131

	lda	#16
	sta	LO8.ShadowOAM_Lo+132
	lda	#34
	sta	LO8.ShadowOAM_Lo+133
	lda	#0
	sta	LO8.ShadowOAM_Lo+134
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+135

	lda	#32
	sta	LO8.ShadowOAM_Lo+136
	lda	#33
	sta	LO8.ShadowOAM_Lo+137
	lda	#0
	sta	LO8.ShadowOAM_Lo+138
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+139

	lda	#40
	sta	LO8.ShadowOAM_Lo+140
	lda	#33
	sta	LO8.ShadowOAM_Lo+141
	lda	#0
	sta	LO8.ShadowOAM_Lo+142
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+143

	lda	#56
	sta	LO8.ShadowOAM_Lo+144
	lda	#32
	sta	LO8.ShadowOAM_Lo+145
	lda	#0
	sta	LO8.ShadowOAM_Lo+146
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+147

	lda	#72
	sta	LO8.ShadowOAM_Lo+148
	lda	#32
	sta	LO8.ShadowOAM_Lo+149
	lda	#0
	sta	LO8.ShadowOAM_Lo+150
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+151

	lda	#88
	sta	LO8.ShadowOAM_Lo+152
	lda	#32
	sta	LO8.ShadowOAM_Lo+153
	lda	#0
	sta	LO8.ShadowOAM_Lo+154
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+155

	lda	#104
	sta	LO8.ShadowOAM_Lo+156
	lda	#31
	sta	LO8.ShadowOAM_Lo+157
	lda	#0
	sta	LO8.ShadowOAM_Lo+158
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+159

	lda	#120
	sta	LO8.ShadowOAM_Lo+160
	lda	#31
	sta	LO8.ShadowOAM_Lo+161
	lda	#0
	sta	LO8.ShadowOAM_Lo+162
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+163

	lda	#136
	sta	LO8.ShadowOAM_Lo+164
	lda	#31
	sta	LO8.ShadowOAM_Lo+165
	lda	#0
	sta	LO8.ShadowOAM_Lo+166
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+167

	lda	#152
	sta	LO8.ShadowOAM_Lo+168
	lda	#32
	sta	LO8.ShadowOAM_Lo+169
	lda	#0
	sta	LO8.ShadowOAM_Lo+170
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+171

	lda	#168
	sta	LO8.ShadowOAM_Lo+172
	lda	#32
	sta	LO8.ShadowOAM_Lo+173
	lda	#0
	sta	LO8.ShadowOAM_Lo+174
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+175

	lda	#184
	sta	LO8.ShadowOAM_Lo+176
	lda	#32
	sta	LO8.ShadowOAM_Lo+177
	lda	#0
	sta	LO8.ShadowOAM_Lo+178
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+179

	lda	#200
	sta	LO8.ShadowOAM_Lo+180
	lda	#33
	sta	LO8.ShadowOAM_Lo+181
	lda	#0
	sta	LO8.ShadowOAM_Lo+182
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+183

	lda	#208
	sta	LO8.ShadowOAM_Lo+184
	lda	#33
	sta	LO8.ShadowOAM_Lo+185
	lda	#0
	sta	LO8.ShadowOAM_Lo+186
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+187

	lda	#224
	sta	LO8.ShadowOAM_Lo+188
	lda	#34
	sta	LO8.ShadowOAM_Lo+189
	lda	#0
	sta	LO8.ShadowOAM_Lo+190
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+191

	lda	#240
	sta	LO8.ShadowOAM_Lo+192
	lda	#35
	sta	LO8.ShadowOAM_Lo+193
	lda	#0
	sta	LO8.ShadowOAM_Lo+194
	lda	#%10111000						; highest priority (3), palette no. 4, flip vertically
	sta	LO8.ShadowOAM_Lo+195



; Set transparency for blurring sprites
	lda	#$E0							; subscreen backdrop color
	sta	RAM_COLDATA
	sta	RAM_COLDATA
	lda	#%0000010						; enable BGs/OBJs on subscreen
	sta	RAM_CGWSEL
	lda	#%00000111						; enable color math on BG1, add subscreen
	sta	RAM_CGADSUB



; Set up NMI and shadow PPU regs /misc. parameters
	SetNMI	kNMI_WorldMap

	lda	#%01111000						; enable HDMA ch. 3 (sky color gradient), 4 (BG1 scroll), 5 (layer control) & 6 (window mask)
	tsb	<DP2.HDMA_Channels
	lda	#%00010001						; BG Mode 1, tile size = 16×16 (layer control is done via HDMA)
	sta	RAM_BGMODE
	lda	#$43							; VRAM address for BG1 tilemap: $4000, size: 64×64 tiles
	sta	RAM_BG1SC
	lda	#$3C							; VRAM address for BG2 tilemap: $3C00, size: 32×32 tiles
	sta	RAM_BG2SC
	lda	#$50							; VRAM address for BG1 character data: $0000, BG2 character data: $5000
	sta	RAM_BG12NBA
	lda	#$FF							; scroll BG2 down by 1 px
	sta	BG2VOFS
	stz	BG2VOFS
	lda	#%00110011						; set up window mask for planet curvature
	sta	RAM_W12SEL
	lda	#%00000011
	sta	RAM_TMW
	sta	RAM_TSW
	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable NMI & auto-joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli
	jsr	CalcVScrollDisplacement

	wai								; wait for register/sprite buffer update before split-in effect
	lda	#kEffectSpeed3
	sta	<DP2.EffectSpeed
	ldx	#kEffectTypeHSplitIn
	jsr	(PTR_EffectTypes, x)



WorldMapLoop:
	wai



; Check for dpad up
	lda	<DP2.Joy1Press+1
	and	#kDpadUp
	beq	@DpadUpDone

;	stz	<DP2.PlayerIdleCounter
;	stz	<DP2.PlayerIdleCounter+1
;	lda	#TBL_Char1_up
;	sta	<DP2.Char1SpriteStatus

	Accu16

	dec	<DP2.WorldMapBG1VScroll

	Accu8

@DpadUpDone:



; Check for dpad down
	lda	<DP2.Joy1Press+1
	and	#kDpadDown
	beq	@DpadDownDone

;	stz	<DP2.PlayerIdleCounter
;	stz	<DP2.PlayerIdleCounter+1
;	lda	#TBL_Char1_down
;	sta	<DP2.Char1SpriteStatus

	Accu16

	inc	<DP2.WorldMapBG1VScroll

	Accu8

@DpadDownDone:



; Check for dpad left
	lda	<DP2.Joy1Press+1
	and	#kDpadLeft
	beq	@DpadLeftDone

;	stz	<DP2.PlayerIdleCounter
;	stz	<DP2.PlayerIdleCounter+1
;	lda	#TBL_Char1_left
;	sta	<DP2.Char1SpriteStatus

	Accu16

	dec	<DP2.WorldMapBG1HScroll

	Accu8

@DpadLeftDone:



; Check for dpad right
	lda	<DP2.Joy1Press+1
	and	#kDpadRight
	beq	@DpadRightDone

;	stz	<DP2.PlayerIdleCounter
;	stz	<DP2.PlayerIdleCounter+1
;	lda	#TBL_Char1_right
;	sta	<DP2.Char1SpriteStatus

	Accu16

	inc	<DP2.WorldMapBG1HScroll

	Accu8

@DpadRightDone:



; Check for A button
;	lda	<DP2.Joy1New
;	bpl	@AButtonDone
;	lda	<DP2.HDMA_Channels					; toggle HDMA ch. 3 (sky color gradient)
;	eor	#%00001000
;	sta	<DP2.HDMA_Channels
;
;@AButtonDone:



; Check for Start
	lda	<DP2.Joy1+1
	and	#kButtonStart
	beq	@StartButtonDone

	lda	#kEffectSpeed3
	sta	<DP2.EffectSpeed
	ldx	#kEffectTypeHSplitOut2
	jsr	(PTR_EffectTypes, x)

;	stz	<DP2.HDMA_Channels					; disable HDMA // never mind, done in debug menu
;	lda	#%00110000						; set color math disable bits (4-5) // never mind, all done in debug menu
;	sta	RAM_CGWSEL
;	lda	#$00
;	sta	RAM_CGADSUB
;	sta	RAM_W12SEL						; clear window regs
;	sta	RAM_TMW
;	sta	RAM_TSW
;	wai

;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	VMAIN
;	stz	VMADDL							; reset VRAM address
;	stz	VMADDH

;	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear VRAM // no, not with NMI enabled

	jml	DebugMenu

@StartButtonDone:

	jsr	CalcVScrollDisplacement

	jmp	WorldMapLoop



CalcVScrollDisplacement:
	ldx	#loword(RAM.ScratchSpace)				; set data address for upcoming loop
	stx	<DP2.DataAddress
	lda	#$7E
	sta	<DP2.DataBank

	Accu16

	ldx	#0
	ldy	#0
-	lda	<DP2.WorldMapBG1VScroll
	sec
	sbc.l	SRC_HDMA_WorMapVScrollDisplacement, x			; subtract displacement value for each scanline
	and	#$3FFF
	sta	[<DP2.DataAddress], y					; save to HDMA array
	inx
	inx
	iny
	iny
	cpy	#448							; 224 scanlines done?
	bne	-

	Accu8

	rts



; ******************************** EOF *********************************
