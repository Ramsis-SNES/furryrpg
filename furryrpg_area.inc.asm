;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** AREA HANDLER ***
;
;==========================================================================================



LoadArea:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	jsr	SpriteInit						; purge OAM

	DisableIRQs

	stz	DP_HDMAchannels						; disable HDMA
	stz	REG_HDMAEN
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	jsr	LoadTextBoxBorderTiles					; prepare some stuff for text box
	jsr	MakeTextBoxTileMapBG1
	jsr	MakeTextBoxTileMapBG2



; -------------------------- look up area properties, load area gfx data
	Accu16

	lda	DP_AreaCurrent
	asl	a
	tax
	lda.l	SRC_PointerAreaProperty, x				; set data offset for selected area
	tax
	lda.l	SRC_AreaProperties, x					; read area properties (16 bits of data)
	sta	DP_AreaProperties
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read gfx source offset (16 bits of data)
	sta	VAR_DMASourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaProperties, x					; read gfx source bank (8 bits of data)
	sta	VAR_DMASourceBank
	inx

	Accu16

	lda.l	SRC_AreaProperties, x					; read size of gfx (16 bits of data)
	sta	VAR_DMATransferLength
	inx
	inx
	lda	#$1801							; set DMA mode & B bus register (VMDATAL)
	sta	VAR_DMAModeBBusReg
	lda	#ADDR_VRAM_AreaBG1					; set VRAM address
	sta	REG_VMADDL
	jsl	RAM_Code



; -------------------------- load area tile map data
	lda.l	SRC_AreaProperties, x					; read tile map source offset (16 bits of data)
	sta	VAR_DMASourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaProperties, x					; read tile map source bank (8 bits of data)
	sta	VAR_DMASourceBank
	inx

	Accu16

	lda.l	SRC_AreaProperties, x					; read size of tile map (16 bits of data)
	sta	VAR_DMATransferLength
	inx
	inx
	lda	#$8000							; set DMA mode & B bus register (WMDATA)
	sta	VAR_DMAModeBBusReg

	Accu8

	ldy	#(ARRAY_ScratchSpace & $FFFF)				; set WRAM address to scratch space
	sty	REG_WMADDL
	stz	REG_WMADDH
	jsl	RAM_Code



; -------------------------- "deinterleave" tile map, add tile no. offset
	phx								; preserve area data pointer
	ldx	#(ARRAY_ScratchSpace & $FFFF)				; set DP_DataSrcAddress to scratch space for postindexed long addressing
	stx	DP_DataSrcAddress
	lda	#$7E
	sta	DP_DataSrcAddress+2
	ldx	#0
	ldy	#0

-	Accu16

	lda	[DP_DataSrcAddress], y					; read original tile map data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(ADDR_VRAM_AreaBG1 >> 4)				; 172 tiles

	Accu8

	sta	ARRAY_BG1TileMap1, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	ARRAY_BG1TileMap1Hi, x
	inx
	cpx	#1024
	bne	-

	ldx	#0

-	Accu16

	lda	[DP_DataSrcAddress], y					; read original tile map data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(ADDR_VRAM_AreaBG1 >> 4)				; 172 tiles

	Accu8

	sta	ARRAY_BG1TileMap2, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	ARRAY_BG1TileMap2Hi, x
	inx
	cpx	#1024
	bne	-

	plx								; restore area data pointer



; -------------------------- load area palette data
	Accu16

	lda.l	SRC_AreaProperties, x					; read palette source offset (16 bits of data)
	sta	VAR_DMASourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaProperties, x					; read palette source bank (8 bits of data)
	sta	VAR_DMASourceBank
	inx

	Accu16

	lda.l	SRC_AreaProperties, x					; read palette size (16 bits of data)
	sta	VAR_DMATransferLength
	inx
	inx
	lda	#$2202							; set DMA mode & B bus register (CGDATA)
	sta	VAR_DMAModeBBusReg

	Accu8

	lda	#ADDR_CGRAM_AREA					; set CGRAM address for BG1 tiles palette
	sta	REG_CGADD
	jsl	RAM_Code



; -------------------------- load area soundtrack data and area name
	Accu16

	lda.l	SRC_AreaProperties, x					; read default SNESGSS music track
	sta	DP_NextTrack
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read default MSU1 ambient track
	sta	DP_MSU1NextTrack
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read pointer to area name
	sta	DP_AreaNamePointer

	Accu8



; -------------------------- HUD font --> VRAM
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- misc. palettes --> CGRAM
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Spritesheet_Char1, SRC_Palette_Spritesheet_Char1, $22, 32



; -------------------------- HDMA tables --> WRAM
	Accu16

	ldx	#0
-	lda.l	SRC_HDMA_ResetBGScroll, x
	sta	ARRAY_HDMA_BGScroll, x
	inx
	inx
	cpx	#16
	bne	-

	ldx	#0
-	lda.l	SRC_HDMA_HUDScroll, x
	sta	ARRAY_HDMA_HUDScroll, x
	inx
	inx
	cpx	#10
	bne	-

	Accu8



; -------------------------- HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	$4330
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	$4331
	ldx	#ARRAY_HDMA_ColorMath
	stx	$4332
	lda	#$7E							; table in WRAM expected
	sta	$4334



; -------------------------- HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	$4340
	lda	#$0D							; PPU reg. $210D
	sta	$4341
	ldx	#ARRAY_HDMA_BGScroll
	stx	$4342
	lda	#$7E
	sta	$4344



; -------------------------- HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210F, 2 bytes --> $2110)
	sta	$4350
	lda	#$0F							; PPU reg. $210F
	sta	$4351
	ldx	#ARRAY_HDMA_BGScroll
	stx	$4352
	lda	#$7E
	sta	$4354



; -------------------------- HDMA channel 6: BG3 HUD scroll
	lda	#$02							; transfer mode (2 bytes --> $2112)
	sta	$4360
	lda	#$12							; PPU reg. $2112 (BG3 vertical scroll)
	sta	$4361
	ldx	#ARRAY_HDMA_HUDScroll
	stx	$4362
	lda	#$7E
	sta	$4364



; -------------------------- screen registers
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	REG_OBSEL
;	lda	DP_AreaProperties					; set tile map size according to area properties // never mind, BG[12]SC are written during Vblank anyway
;	and	#%00000011						; mask off bits not related to screen size
;	ora	#$50							; BG1 tile map VRAM offset: $5000
;	sta	REG_BG1SC
;	lda	DP_AreaProperties
;	and	#%00000011
;	ora	#$58							; BG2 tile map VRAM offset: $5800
;	sta	REG_BG2SC
;	lda	DP_AreaProperties
;	and	#%00000011
	lda	#$48							; BG3 tile map VRAM offset: $4800
	sta	REG_BG3SC
	stz	REG_BG12NBA						; BG1/BG2 character data VRAM offset: $0000
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA



; -------------------------- character, Vblank, and effect parameters
	Accu16

	lda	#1							; set walking speed
	sta	DP_Char1WalkingSpd
	lda	#$5078							; set character position
	sta	DP_Char1PosYX
;	sta	SpriteBuf1.PlayableChar
;	clc
;	adc	#$1000							; Y += 10
;	sta	SpriteBuf1.PlayableChar+4
	lda	#%0001011100010111					; turn on BG1/2/3 + sprites
	sta	DP_Shadow_TSTM						; on mainscreen and subscreen

	Accu8

	SetNMI	TBL_NMI_Area

	Accu16

	lda	#211							; dot number for interrupt (256 = too late, 204 = too early)
	sta	REG_HTIMEL
	lda	#176							; scanline number for interrupt: 176 (i.e., let IRQ fire in Hblank between scanlines 176 and 177)
	sta	REG_VTIMEL

	Accu8

	SetIRQ	TBL_VIRQ_Area

	lda	#$80							; make character idle
	sta	DP_Char1SpriteStatus
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable Vblank NMI + Auto Joypad Read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli								; re-enable interrupts

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates
	tsb	DP_DMAUpdates+1
	lda	#%01000000						; enable HDMA ch. 6 (BG3 HUD scroll)
	tsb	DP_HDMAchannels

	WaitFrames	4						; let the screen clear up

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



; NIGHT
;	Accu16

;	lda	#%0000000000010111					; turn on BG1/2/3 + sprites on mainscreen only
;	sta	DP_Shadow_TSTM

;	Accu8

;	lda	#$72							; subscreen backdrop color to subtract
;	sta	REG_COLDATA
;	stz	REG_CGWSEL						; clear CM disable bits
;	lda	#%10010011						; enable color math on BG1/2 + sprites, subtract color
;	sta	REG_CGADSUB
;	jmp	Forever



.ENDASM

; NIGHT W/ SPRITES, XORed palette req.
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	lda	#ADDR_CGRAM_AREA					; set CGRAM address for BG1 tiles palette
	sta	REG_CGADD

	ldx	#0
-	lda.l	SRC_Palette_Area001, x
	eor	#$FF
	sta	REG_CGDATA
	inx
	cpx	#32
	bne	-

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	ldx	#0
-	lda.l	SRC_Palette_Spritesheet_Char1, x
	eor	#$FF
	sta	REG_CGDATA
	inx
	cpx	#32
	bne	-

	Accu16

	lda	#%0001001100000100					; turn on BG1/2 + sprites on subscreen, BG3 (HUD) on mainscreen
	sta	DP_Shadow_TSTM

	Accu8

	stz	REG_CGADD						; backdrop color to subtract
	lda	#$52
	sta	REG_CGDATA
	lda	#$1E
	sta	REG_CGDATA
	lda	#%00000010						; clear CM disable bits, enable BGs/OBJs on subscreen
	sta	REG_CGWSEL
	lda	#%10100000						; enable color math on backdrop, subtract color
	sta	REG_CGADSUB
	lda	#$0F
	sta	REG_INIDISP
	jmp	Forever

.ASM



; EFFECT
;	lda	#%00000010						; clear color math disable bits (4-5), enable BGs/OBJs on subscreen
;	sta	REG_CGWSEL
;	lda	#%00100000						; enable color math on backdrop only
;	sta	REG_CGADSUB

;	stz	REG_CGADD						; set backdrop color to overlay the whole image
;	stz	REG_CGDATA						; $6C00 = bright blue
;	lda	#$6C
;	sta	REG_CGDATA

;	Accu16

;	lda	#%0001001100000100					; mainscreen: BG3 (HUD), subscreen: BG1/2, sprites
;	sta	DP_Shadow_TSTM

;	Accu8



; -------------------------- reset language/text parameters
	lda	#TBL_Lang_Eng
	sta	DP_TextLanguage

	Accu16

	stz	DP_TextPointerNo

	Accu8



; -------------------------- HUD contents
	DrawFrame	3, 1, 25, 2
;	PrintString	2, 4, "XXXXXXXXXXXXXXXXXXXXXXXX"		; area name
	PrintString	23, 1, "Gengen"
	PrintString	24, 1, "HP: XXXX"
	PrintString	24, 20, "Time: XX:XX"



; -------------------------- play music & ambient sound effect
.IFNDEF NOMUSIC
	lda	DP_NextTrack+1
	cmp	#$FF							; DP_NextTrack = $FFFF --> don't play any music
	bne	+

	lda	DP_NextTrack
	cmp	#$FF
	beq	__AreaGSSTrackDone

+	jsl	PlayTrack

__AreaGSSTrackDone:
	lda	DP_MSU1present
	beq	__AreaMSU1TrackDone

	Accu16

	lda	DP_MSU1NextTrack					; MSU1 present, set track
	cmp	#$FFFF							; $FFFF = don't play any MSU1 track
	beq	++
	sta	MSU_TRACK
-	lda	MSU_STATUS						; wait for Audio Busy bit to clear
	and	#%0000000001000000
	bne	-

	lda	#%0000001111111111					; set play, repeat flags, max. volume (16-bit write)
	sta	MSU_VOLUME

++	Accu8

__AreaMSU1TrackDone:
.ENDIF



MainAreaLoop:
	WaitFrames	1						; don't use WAI here as IRQ might be enabled!

;	lda	DP_Shadow_NMITIMEN
;	sta	REG_NMITIMEN

	Accu16

	lda	DP_PlayerIdleCounter
	inc	a							; assume player is idle
	cmp	#300
	bcs	+							; only increment counter up to a value of #299
	sta	DP_PlayerIdleCounter

+	Accu8



; -------------------------- HUD display logic
	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	bne	__HUDIsVisible						; yes

	Accu16

	lda	DP_PlayerIdleCounter					; no, check if player has been idle for at least 300 frames
	cmp	#299
	bcc	__HUDLogicJumpOut					; no, jump out

	Accu8

	lda	#%10000000						; yes, set "HUD should appear" bit
	sta	DP_HUD_Status
	bra	__HUDLogicDone

__HUDIsVisible:
	Accu16

	lda	DP_HUD_DispCounter
	inc	a
	cmp	#150							; show HUD for at least 150 frames before hiding it again
	bcs	__HideHUDOrNot
	sta	DP_HUD_DispCounter
	bra	__HUDLogicJumpOut

__HideHUDOrNot:
	lda	DP_PlayerIdleCounter					; if player is still idle, don't do anything
	cmp	#299
	bcs	__HUDLogicJumpOut

	Accu8

	lda	#%01000000						; otherwise, set "HUD should disappear" bit
	sta	DP_HUD_Status

__HUDLogicJumpOut:
	Accu8

__HUDLogicDone:



; -------------------------- HUD contents
	lda	#:AreaNames
	sta	DP_SubStrAddr+2

	Accu16

	lda	DP_TextLanguage						; check for selected language
	and	#$00FF							; mask off garbage bits
	tax
	lda	DP_AreaNamePointer
-	dex
	cpx	#$FFFF
	beq	+
	clc
	adc	#AreaNames_END-AreaNames				; add offset to sub-string address based on language
	bra	-

+	sta	DP_SubStrAddr

	Accu8

	PrintString	2, 4, "%s"					; area name



.IFDEF DEBUG
;	PrintString	2, 26, "X="
;	PrintHexNum	DP_Char1PosYX
;	PrintString	3, 26, "Y="
;	PrintHexNum	DP_Char1PosYX+1

;	PrintString	2, 22, "ScrX="
;	PrintHexNum	ARRAY_HDMA_BGScroll+2
;	PrintHexNum	ARRAY_HDMA_BGScroll+1

;	PrintString	3, 22, "ScrY="
;	PrintHexNum	ARRAY_HDMA_BGScroll+4
;	PrintHexNum	ARRAY_HDMA_BGScroll+3
.ENDIF



; -------------------------- update HUD game time
;	PrintString	24, 20, "Time: XX:XX"

	SetTextPos	24, 26
	PrintHexNum	DP_GameTime_Hours
	SetTextPos	24, 29
	PrintHexNum	DP_GameTime_Minutes



; -------------------------- check for B button = make HUD disappear/run
	lda	Joy1Press+1
	and	#%10000000
	bne	+

	lda	#1							; B not pressed, set slow walking speed
	bra	__MainAreaLoopBButtonDone

+	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	beq	+
	lda	#%01000000						; yes, set "HUD should disappear" bit
	sta	DP_HUD_Status

+	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#2							; B pressed, set fast walking speed

__MainAreaLoopBButtonDone:
	sta	DP_Char1WalkingSpd



; -------------------------- check for Y button = show HUD
	lda	Joy1New+1
	and	#%01000000
	beq	__MainAreaLoopYButtonDone

	stz	DP_PlayerIdleCounter					; reset both "player idle" and HUD display counters
	stz	DP_PlayerIdleCounter+1
	stz	DP_HUD_DispCounter
	stz	DP_HUD_DispCounter+1

	lda	DP_HUD_Status						; check if HUD is already being displayed
	and	#%00000001
	bne	__MainAreaLoopYButtonDone

	lda	#%10000000						; no, set "HUD should appear" bit
	sta	DP_HUD_Status

__MainAreaLoopYButtonDone:



; -------------------------- check for dpad released
	lda	Joy1New+1
	and	#%00001111
	bne	__MainAreaLoopDpadNewDone

	lda	#$80							; d-pad released, make character idle
	tsb	DP_Char1SpriteStatus

__MainAreaLoopDpadNewDone:



; -------------------------- check for dpad up
	lda	Joy1Press+1
	and	#%00001000
	beq	__MainAreaLoopDpadUpDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_up
	sta	DP_Char1SpriteStatus

	Accu16

	lda	DP_AreaProperties					; check if area may be scrolled vertically
	and	#%0000000000001000
	bne	+

	lda	DP_Char1WalkingSpd					; area not scrollable, move hero sprite instead
	xba								; shift to high byte for Y value
	eor	#$FFFF							; make negative
	inc	a
	clc
	adc	DP_Char1PosYX						; Y = Y - DP_Char1WalkingSpd (add negative value)
	sta	DP_Char1PosYX
	bra	++

;	Accu8

;	lda	DP_Char1PosYX+1						; check for walking area border
;	cmp	#$B1
;	bcc	__MainAreaLoopDpadUpDone

;	stz	DP_Char1PosYX+1

;	Accu16

+	lda	DP_Char1WalkingSpd
	eor	#$FFFF							; make negative
	inc	a
	clc
	adc	ARRAY_HDMA_BGScroll+3					; scroll area
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+3

++	Accu8

__MainAreaLoopDpadUpDone:



; -------------------------- check for dpad down
	lda	Joy1Press+1
	and	#%00000100
	beq	__MainAreaLoopDpadDownDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_down
	sta	DP_Char1SpriteStatus

	Accu16

	lda	DP_AreaProperties					; check if area may be scrolled vertically
	and	#%0000000000001000
	bne	+

	lda	DP_Char1WalkingSpd					; area not scrollable, move hero sprite instead
	xba								; shift to high byte for Y value
	clc
	adc	DP_Char1PosYX						; Y += DP_Char1WalkingSpd
	sta	DP_Char1PosYX
	bra	++

;	Accu8

;	lda	DP_Char1PosYX+1						; check for walking area border
;	cmp	#$B1
;	bcc	__MainAreaLoopDpadDownDone

;	lda	#$B0
;	sta	DP_Char1PosYX+1


;	Accu16

+	lda	DP_Char1WalkingSpd
	clc
	adc	ARRAY_HDMA_BGScroll+3					; scroll area
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+3

++	Accu8

__MainAreaLoopDpadDownDone:



; -------------------------- check for dpad left
	lda	Joy1Press+1
	and	#%00000010
	beq	__MainAreaLoopDpadLeftDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_left
	sta	DP_Char1SpriteStatus

	Accu16

	lda	DP_AreaProperties					; check if area may be scrolled horizontally
	and	#%0000000000000100
	bne	+

	lda	DP_Char1PosYX						; area not scrollable, move hero sprite instead
	sec
	sbc	DP_Char1WalkingSpd					; X = X - DP_Char1WalkingSpd
	sta	DP_Char1PosYX
	bra	++

;	Accu8

;	lda	DP_Char1PosYX						; check for walking area border
;	cmp	#$10
;	bcs	__MainAreaLoopDpadLeftDone

;	lda	#$10
;	sta	DP_Char1PosYX

;	Accu16

+	lda	ARRAY_HDMA_BGScroll+1					; scroll area
	sec
	sbc	DP_Char1WalkingSpd
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+1

++	Accu8

__MainAreaLoopDpadLeftDone:



; -------------------------- check for dpad right
	lda	Joy1Press+1
	and	#%00000001
	beq	__MainAreaLoopDpadRightDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_right
	sta	DP_Char1SpriteStatus

	Accu16

	lda	DP_AreaProperties					; check if area may be scrolled horizontally
	and	#%0000000000000100
	bne	+

	lda	DP_Char1PosYX						; area not scrollable, move hero sprite instead
	clc
	adc	DP_Char1WalkingSpd					; X += DP_Char1WalkingSpd
	sta	DP_Char1PosYX
	bra	++

;	Accu8

;	lda	DP_Char1PosYX						; check for walking area border
;	cmp	#$E1
;	bcc	__MainAreaLoopDpadRightDone

;	lda	#$E0
;	sta	DP_Char1PosYX


;	Accu16

+	lda	ARRAY_HDMA_BGScroll+1					; scroll area
	clc
	adc	DP_Char1WalkingSpd
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+1

++	Accu8

__MainAreaLoopDpadRightDone:



; -------------------------- check for A button = open text box
	lda	Joy1New
	and	#%10000000
	beq	__MainAreaLoopAButtonDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#$80							; make character idle
	tsb	DP_Char1SpriteStatus
	jsr	OpenTextBox

__MainAreaLoopAButtonDone:



; -------------------------- check for X button
	lda	Joy1New
	and	#%01000000
	beq	__MainAreaLoopXButtonDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	jmp	InGameMenu

__MainAreaLoopXButtonDone:



; -------------------------- check for Start
	lda	Joy1+1
	and	#%00010000
	beq	__MainAreaLoopStButtonDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2
	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	#%00110000						; clear IRQ enable bits
	trb	DP_Shadow_NMITIMEN
	lda	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
;	lda	#TBL_Char1_down|$80					; make char face the player (for menu later) // adjust when debug menu is removed
;	sta	DP_Char1SpriteStatus

	WaitFrames	1

.IFNDEF NOMUSIC
	jsl	music_stop						; stop music
	lda	DP_MSU1present
	beq	+
	stz	MSU_CONTROL						; stop ambient soundtrack
+
.ENDIF

	jmp	DebugMenu

__MainAreaLoopStButtonDone:
;	jsr	ShowCPUload

	lda	#%00010000						; make sure BG3 lo tile map gets updated
	tsb	DP_DMAUpdates

	jmp	MainAreaLoop



; ******************************** EOF *********************************
