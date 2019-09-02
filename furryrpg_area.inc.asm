;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

LoadArea:
	jsr	LoadAreaData
	jmp	ShowArea



LoadAreaData:
	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP
;	jsr	SpriteInit						; purge OAM
	jsr	SpriteDataInit						; purge sprite data buffer
	wai

	DisableIRQs

.IFNDEF NOMUSIC
	jsl	music_stop						; stop music in case it's playing

	stz	MSU_CONTROL						; stop MSU1 track in case it's playing
.ENDIF

	stz	DP_HDMA_Channels					; disable HDMA
	stz	REG_HDMAEN
	ldx	#(ARRAY_BG3TileMap & $FFFF)				; clear BG3 text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 1024

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
	jsl	RAM_Code.DoDMA



; -------------------------- load area BG1 tile map data
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
	jsl	RAM_Code.DoDMA



; -------------------------- "deinterleave" BG1 tile map, add tile no. offset
	phx								; preserve area data pointer
	ldx	#(ARRAY_ScratchSpace & $FFFF)				; set DP_DataAddress to scratch space for postindexed long addressing
	stx	DP_DataAddress
	lda	#$7E
	sta	DP_DataAddress+2
	ldx	#0
	ldy	#0

-	Accu16

	lda	[DP_DataAddress], y					; read original tile map data (16 bit)
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

	lda	[DP_DataAddress], y					; read original tile map data (16 bit)
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



; -------------------------- load area BG2 tile map data (optional)
	Accu16

	lda.l	SRC_AreaProperties, x					; read tile map source offset (16 bits of data)
	cmp	#$FFFF							; $FFFF = no BG2 tile map for this area
	bne	+
	inx								; skip 5 bytes of unused BG2 tile map pointers
	inx
	inx
	inx
	inx
	jmp	@BG2TileMapDone

+	sta	VAR_DMASourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaProperties, x					; read tile map source bank (8 bits of data)
;	cmp	#$FF							; never mind checking those again
;	beq	@BG2TileMapDone
	sta	VAR_DMASourceBank
	inx

	Accu16

	lda.l	SRC_AreaProperties, x					; read size of tile map (16 bits of data)
;	cmp	#$FFFF
;	beq	@BG2TileMapDone
	sta	VAR_DMATransferLength
	inx
	inx
	lda	#$8000							; set DMA mode & B bus register (WMDATA)
	sta	VAR_DMAModeBBusReg

	Accu8

	ldy	#(ARRAY_ScratchSpace & $FFFF)				; set WRAM address to scratch space
	sty	REG_WMADDL
	stz	REG_WMADDH
	jsl	RAM_Code.DoDMA



; -------------------------- "deinterleave" BG2 tile map, add tile no. offset
	phx								; preserve area data pointer
	ldx	#(ARRAY_ScratchSpace & $FFFF)				; set DP_DataAddress to scratch space for postindexed long addressing
	stx	DP_DataAddress
	lda	#$7E
	sta	DP_DataAddress+2
	ldx	#0
	ldy	#0

-	Accu16

	lda	[DP_DataAddress], y					; read original tile map data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(ADDR_VRAM_AreaBG1 >> 4)				; 172 tiles

	Accu8

	sta	ARRAY_BG2TileMap1, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	ARRAY_BG2TileMap1Hi, x
	inx
	cpx	#1024
	bne	-

	ldx	#0

-	Accu16

	lda	[DP_DataAddress], y					; read original tile map data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(ADDR_VRAM_AreaBG1 >> 4)				; 172 tiles

	Accu8

	sta	ARRAY_BG2TileMap2, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	ARRAY_BG2TileMap2Hi, x
	inx
	cpx	#1024
	bne	-

	plx								; restore area data pointer

@BG2TileMapDone:



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

	lda	#ADDR_CGRAM_Area					; set CGRAM address for BG1 tiles palette
	sta	REG_CGADD
	jsl	RAM_Code.DoDMA



; -------------------------- load & set collision map address
	Accu16

	lda.l	SRC_AreaProperties, x					; read meta map source offset (16 bits of data)
	sta	DP_AreaMetaMapAddr
	inx
	inx

	Accu8

	lda.l	SRC_AreaProperties, x					; read meta map source bank (8 bits of data)
	sta	DP_AreaMetaMapAddr+2
	inx



; -------------------------- load area soundtrack data and area name pointer
	Accu16

	lda.l	SRC_AreaProperties, x					; read default SNESGSS music track
	sta	DP_NextTrack
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read default MSU1 ambient track
	sta	DP_MSU1_NextTrack
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read pointer to area name
	sta	DP_AreaNamePointerNo
	inx
	inx



; -------------------------- load hero parameters for this area
	lda.l	SRC_AreaProperties, x					; read hero screen position
	sta	DP_Hero1ScreenPosYX
	sta	VAR_Hero1TargetScrPosYX
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read hero map position (X)
	sta	DP_Hero1MapPosX
	inx
	inx
	lda.l	SRC_AreaProperties, x					; read hero map position (Y)
	sta	DP_Hero1MapPosY
	inx
	inx

	Accu8

	lda.l	SRC_AreaProperties, x					; read hero sprite status
	sta	DP_Hero1SpriteStatus



; -------------------------- misc. palettes --> CGRAM
	lda	#$90							; set CGRAM address to #288 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Spritesheet_Hero1, SRC_Palette_Spritesheet_Hero1, <REG_CGDATA, 32



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



; -------------------------- HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	REG_DMAP3
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	REG_BBAD3
	ldx	#ARRAY_HDMA_ColorMath
	stx	REG_A1T3L
	lda	#$7E							; table in WRAM expected
	sta	REG_A1B3



; -------------------------- HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	REG_DMAP4
	lda	#$0D							; PPU reg. $210D
	sta	REG_BBAD4
	ldx	#ARRAY_HDMA_BG_Scroll
	stx	REG_A1T4L
	lda	#$7E
	sta	REG_A1B4



; -------------------------- HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210F, 2 bytes --> $2110)
	sta	REG_DMAP5
	lda	#$0F							; PPU reg. $210F
	sta	REG_BBAD5
	ldx	#ARRAY_HDMA_BG_Scroll
	stx	REG_A1T5L
	lda	#$7E
	sta	REG_A1B5



; -------------------------- set PPU shadow registers
	lda	#$01|$08						; set BG Mode 1 for area, BG3 priority
	sta	VAR_ShadowBGMODE
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	VAR_ShadowOBSEL
	lda	DP_AreaProperties					; set tile map size according to area properties
	and	#%00000011						; mask off bits not related to screen size
	ora	#$50							; BG1 tile map VRAM offset: $5000
	sta	VAR_ShadowBG1SC
	lda	DP_AreaProperties
	and	#%00000011
	ora	#$58							; BG2 tile map VRAM offset: $5800
	sta	VAR_ShadowBG2SC
	lda	#$48							; BG3 tile map VRAM offset: $4800
	sta	VAR_ShadowBG3SC
	lda	#$00							; BG1/BG2 character data VRAM offset: $0000
	sta	VAR_ShadowBG12NBA
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	VAR_ShadowBG34NBA



; -------------------------- pre-load GSS music track
	lda	DP_NextTrack+1
	cmp	#$FF							; DP_NextTrack = $FFFF --> don't load any music
	bne	+
	lda	DP_NextTrack
	cmp	#$FF
	beq	@GSSLoadTrackDone
+	jsl	LoadTrackGSS

@GSSLoadTrackDone:



; -------------------------- misc. settings
	lda	#%00010111						; turn on BG1/2/3 + sprites on mainscreen and subscreen
	sta	VAR_ShadowTM
	sta	VAR_ShadowTM

	SetNMI	TBL_NMI_Area
	Accu16

	lda	#228							; dot number for interrupt (256 = too late, 204 = too early)
	sta	REG_HTIMEL
	lda	#224							; scanline number for interrupt (none for now)
	sta	REG_VTIMEL
	sta	DP_TextBoxVIRQ

	Accu8
	SetIRQ	TBL_VIRQ_Area

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable Vblank NMI + Auto Joypad Read
	sta	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli								; re-enable interrupts
	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMA_Updates
	tsb	DP_DMA_Updates+1
	jsr	UpdateAreaSprites					; put characters on initial positions

	ldx	#ARRAY_SpriteDataArea & $FFFF				; set WRAM address for area sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer

	WaitFrames	4						; give some time for screen refresh

	rts



ShowArea:
	stz	DP_HUD_DispCounter					; reset HUD status
	stz	DP_HUD_DispCounter+1
	stz	DP_HUD_Status
	jsr	ClearHUD

	lda	#PARAM_HUD_Xpos						; initial X position of "text box" frame
	sta	DP_Temp
	clc								; make up for different X position of "text box" and text
	adc	#6
	sta	DP_TextCursor
	lda	#PARAM_HUD_Yhidden					; initial Y position (hidden)
	sta	DP_Temp+1
	clc
	adc	#4
	sta	DP_TextCursor+1
	jsr	PutAreaNameIntoHUD

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



.ENDASM

; CM EFFECT TEST 1: NIGHT
	lda	#%00010111						; mainscreen: BG1/2/3 + sprites
	sta	VAR_ShadowTM
	stz	VAR_ShadowTS						; subscreen: nothing
	lda	#$72							; subscreen backdrop color to subtract
	sta	REG_COLDATA
	stz	REG_CGWSEL						; clear CM disable bits
	lda	#%10010011						; enable color math on BG1/2 + sprites, subtract color
	sta	REG_CGADSUB

	Freeze



; CM EFFECT TEST 2: NIGHT W/ SPRITES, XORed palette req.
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	lda	#ADDR_CGRAM_Area					; set CGRAM address for BG1 tiles palette
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
-	lda.l	SRC_Palette_Spritesheet_Hero1, x
	eor	#$FF
	sta	REG_CGDATA
	inx
	cpx	#32
	bne	-

	lda	#%00000100						; mainscreen: BG3
	sta	VAR_ShadowTM
	lda	#%00010011						; subscreen: BG1/2, sprites
	sta	VAR_ShadowTS
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

	Freeze



; CM EFFECT TEST 3: blue overlay
	lda	#%00000010						; clear color math disable bits (4-5), enable BGs/OBJs on subscreen
	sta	REG_CGWSEL
	lda	#%00100000						; enable color math on backdrop only
	sta	REG_CGADSUB
	stz	REG_CGADD						; set backdrop color to overlay the whole image
	stz	REG_CGDATA						; $6C00 = bright blue
	lda	#$6C
	sta	REG_CGDATA
	lda	#%00000100						; mainscreen: BG3
	sta	VAR_ShadowTM
	lda	#%00010011						; subscreen: BG1/2, sprites
	sta	VAR_ShadowTS

.ASM



; -------------------------- play music & ambient sound effect
.IFNDEF NOMUSIC
	lda	DP_NextTrack+1
	cmp	#$FF							; DP_NextTrack = $FFFF --> don't play any music
	bne	+
	lda	DP_NextTrack
	cmp	#$FF
	beq	@GSSPlayTrackDone
+	jsl	PlayTrackGSS

@GSSPlayTrackDone:
	lda	DP_GameConfig
	and	#%00000001						; check for "MSU1 present" flag
	beq	@MSU1TrackDone

	Accu16

	lda	DP_MSU1_NextTrack					; MSU1 present, set track
	cmp	#$FFFF							; $FFFF = don't play any MSU1 track
	beq	+
	sta	MSU_TRACK
-	lda	MSU_STATUS						; wait for Audio Busy bit to clear
	and	#%0000000001000000
	bne	-

	lda	#%0000001111111111					; set play, repeat flags, max. volume (16-bit write to MSU_CONTROL, too)
	sta	MSU_VOLUME

+	Accu8

@MSU1TrackDone:
.ENDIF



MainAreaLoop:
	WaitFrames	1						; don't use WAI here as IRQ might be enabled!

;	lda	VAR_Shadow_NMITIMEN
;	sta	REG_NMITIMEN



; -------------------------- player idle counter
	Accu16

	lda	DP_Joy1Press						; check for any input (sans Y button)
	and	#%1011111111110000
	beq	@PlayerIsIdle
	stz	DP_PlayerIdleCounter					; player not idle, reset counter
	bra	+

@PlayerIsIdle:
	lda	DP_PlayerIdleCounter
	inc	a							; assume player is idle
	cmp	#$FFFF
	bcs	+							; don't wrap around to 0
	sta	DP_PlayerIdleCounter

+	Accu8



; -------------------------- screen saver (darken screen every $1000 frames = 70-82 seconds when player is idle)
	lda	DP_PlayerIdleCounter+1
	lsr	a							; shift highest nibble of DP_PlayerIdleCounter (16 bit) to lower nibble of Accu
	lsr	a
	lsr	a
	lsr	a
	eor	#$0F							; convert to brightness level value ($00 --> $0F, $01 --> $0E ... $0F --> $00)
	sta	VAR_ShadowINIDISP



; -------------------------- HUD display logic
	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	bne	@HUDIsVisible						; yes

	Accu16

	lda	DP_PlayerIdleCounter					; no, check if player has been idle for at least 300 frames (5-6 seconds)
	cmp	#301
	bcc	@HUDLogicJumpOut					; no, jump out

	Accu8

	lda	#%10000000						; yes, set "HUD should appear" bit
	tsb	DP_HUD_Status
	bra	@HUDLogicDone

@HUDIsVisible:
	Accu16

	lda	DP_HUD_DispCounter
	inc	a
	sta	DP_HUD_DispCounter
	cmp	#151							; show HUD for at least 150 frames before hiding it again
	bcc	@HUDLogicJumpOut


@HideHUDOrNot:
	lda	DP_PlayerIdleCounter					; if player is currently idle, don't do anything
	bne	@HUDLogicJumpOut

	Accu8

	lda	#%01000000						; otherwise, set "HUD should disappear" bit
	tsb	DP_HUD_Status

@HUDLogicJumpOut:
	Accu8

@HUDLogicDone:



.IFDEF DEBUG
;	PrintString	2, 26, "X="
;	PrintHexNum	DP_Hero1ScreenPosYX
;	PrintString	3, 26, "Y="
;	PrintHexNum	DP_Hero1ScreenPosYX+1

;	PrintString	2, 22, "ScrX="
;	PrintHexNum	ARRAY_HDMA_BGScroll+2
;	PrintHexNum	ARRAY_HDMA_BGScroll+1

;	PrintString	3, 22, "ScrY="
;	PrintHexNum	ARRAY_HDMA_BGScroll+4
;	PrintHexNum	ARRAY_HDMA_BGScroll+3

;	PrintString	7, 5, "MapPosX="
;	PrintHexNum	DP_Hero1MapPosX+1
;	PrintHexNum	DP_Hero1MapPosX

;	PrintString	8, 5, "MapPosY="
;	PrintHexNum	DP_Hero1MapPosY+1
;	PrintHexNum	DP_Hero1MapPosY
.ENDIF



; -------------------------- text box
	lda	DP_TextBoxStatus					; check if text box is open
	and	#%00000010
	beq	@NoTextBox
	jsr	MainTextBoxLoop						; yes, go to subroutine

	jmp	@SkipDpadABXY						; and skip subsequent button checks

@NoTextBox:



; -------------------------- check for A button
	bit	DP_Joy1New
	bpl	@AButtonDone
	jsr	AreaJoyButtonA

@AButtonDone:



; -------------------------- check for B button
	bit	DP_Joy1Press+1
	bmi	+
	lda	#1							; B not pressed, set slow walking speed
	bra	@BButtonDone

+	jsr	AreaJoyButtonB

@BButtonDone:
	sta	DP_Hero1WalkingSpd



; -------------------------- check for X button
	bit	DP_Joy1New
	bvc	@XButtonDone
	jsr	AreaJoyButtonX

@XButtonDone:



; -------------------------- check for Y button
	bit	DP_Joy1New+1
	bvc	@YButtonDone
	jsr	AreaJoyButtonY

@YButtonDone:



; -------------------------- check for dpad released
	lda	DP_Joy1New+1
	and	#%00001111
	bne	@DpadNewDone

	lda	#$80							; d-pad released, make character idle
	tsb	DP_Hero1SpriteStatus

@DpadNewDone:



; -------------------------- check for dpad up
	lda	DP_Joy1Press+1
	and	#%00001000
	beq	@DpadUpDone

	jsr	AreaJoyDpadUp

@DpadUpDone:



; -------------------------- check for dpad down
	lda	DP_Joy1Press+1
	and	#%00000100
	beq	@DpadDownDone

	jsr	AreaJoyDpadDown

@DpadDownDone:



; -------------------------- check for dpad left
	lda	DP_Joy1Press+1
	and	#%00000010
	beq	@DpadLeftDone

	jsr	AreaJoyDpadLeft

@DpadLeftDone:



; -------------------------- check for dpad right
	lda	DP_Joy1Press+1
	and	#%00000001
	beq	@DpadRightDone

	jsr	AreaJoyDpadRight

@DpadRightDone:

@SkipDpadABXY:



; -------------------------- check for Start
	lda	DP_Joy1+1
	and	#%00010000
	beq	@StartButtonDone

	jsr	AreaJoyButtonStart

@StartButtonDone:



; -------------------------- update HUD based on player input
	bit	DP_HUD_Status						; check HUD status
	bmi	@ShowHUD
	bvs	@HideHUD
	jmp	@UpdateHUDDone

@ShowHUD:
	Accu16								; take care about "text box" sprites

	lda	DP_HUD_TextBoxSize
	and	#$00FF							; remove garbage in high byte
	inc	a							; +1 for right edge of "text box" frame
	tay

	Accu8

	lda	DP_HUD_Ypos
	and	#%11111100						; make value divisible by 4 so rising values in DP_HUD_Ypos will always be the same
	clc								; DP_HUD_Ypos += 4 (HUD appears 4 times as fast as it disappears)
	adc	#4
	sta	DP_HUD_Ypos
	ldx	#2							; start at Y value
-	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	inx
	inx
	inx
	inx
	dey								; all "text box" sprites done?
	bne	-

	Accu16								; next, scroll text as well

	lda	DP_HUD_StrLength
	and	#$00FF							; remove garbage in high byte
	tay

	Accu8

	lda	DP_HUD_Ypos
	clc								; make up for different Y position of "text box" and text
	adc	#4
	ldx	#2							; start at Y value
-	sta	ARRAY_SpriteDataArea.Text, x
	inx
	inx
	inx
	inx
	inx
	dey								; all font sprites done?
	bne	-

	lda	DP_HUD_Ypos						; final Y value reached?
	cmp	#PARAM_HUD_Yvisible
	bne	@UpdateHUDDone
	lda	DP_HUD_Status
	ora	#%00000001						; yes, set "HUD is being displayed" bit
	and	#%01111111						; clear "HUD should appear" bit
	sta	DP_HUD_Status
	stz	DP_HUD_DispCounter					; and reset display counter values
	stz	DP_HUD_DispCounter+1
	bra	@UpdateHUDDone

@HideHUD:
	lda	#%00000001						; clear "HUD is visible" bit now so the player can bring the HUD back with Y while it's disappearing
	trb	DP_HUD_Status

	Accu16								; take care about "text box" sprites

	lda	DP_HUD_TextBoxSize
	and	#$00FF							; remove garbage in high byte
	inc	a							; +1 for right edge of "text box" frame
	tay

	Accu8

	lda	DP_HUD_Ypos
	dec	a
	sta	DP_HUD_Ypos						; DP_HUD_Ypos -= 1
	cmp	#PARAM_HUD_Yhidden					; final/initial (hidden) Y value reached?
	bne	+
	lda	#%01000000
	trb	DP_HUD_Status						; yes, clear "HUD should disappear" status bit
	bra	@UpdateHUDDone

+	ldx	#2							; start at Y value
-	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	inx
	inx
	inx
	inx
	dey								; all "text box" sprites done?
	bne	-

	Accu16								; next, scroll text as well

	lda	DP_HUD_StrLength
	and	#$00FF							; remove garbage in high byte
	tay

	Accu8

	lda	DP_HUD_Ypos
	clc								; make up for different Y position of "text box" and text
	adc	#4
	ldx	#2							; start at Y value
-	sta	ARRAY_SpriteDataArea.Text, x
	inx
	inx
	inx
	inx
	inx
	dey								; all font sprites done?
	bne	-

@UpdateHUDDone:



; -------------------------- determine active objects (sprites) // set static values for now
	lda	#%01100001						; set "object is active," "object is hero," and "can collide with other objects" flags
	ldx	#69							; 69th sprite = first hero sprite
	sta	ARRAY_ObjectList, x
	inx								; 70th sprite = second hero sprite
	sta	ARRAY_ObjectList, x



; -------------------------- misc. tasks, end loop
	jsr	UpdateAreaSprites

	ldx	#ARRAY_SpriteDataArea & $FFFF				; set WRAM address for area sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer

	jmp	MainAreaLoop



; ************************ Handle player input *************************



; -------------------------- A button pressed = do lots of important stuff ;-)
AreaJoyButtonA:
	lda	#$80							; make character idle
	tsb	DP_Hero1SpriteStatus

	; ### TODO: CHECK FOR CHARACTER INTERACTION, TREASURE, POINTS OF INTEREST ETC.

.IFDEF DEBUG
	jsr	OpenTextBox
.ENDIF

	rts


; -------------------------- B button pressed = make HUD disappear/set fast walking speed
AreaJoyButtonB:
	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	beq	+
	lda	DP_HUD_Status
	ora	#%01000000						; yes, set "HUD should disappear" bit
	and	#%01111111						; clear "HUD should appear" bit in case it's set
	sta	DP_HUD_Status
+	lda	#2							; set fast walking speed
	rts



; -------------------------- X button pressed = transition to in-game menu
AreaJoyButtonX:
	; ### TODO: preserve area data

	jmp	InGameMenu

	rts



; -------------------------- Y button pressed = show HUD
AreaJoyButtonY:
	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	bne	+
	lda	DP_HUD_Status
	ora	#%10000000						; no, set "HUD should appear" bit
	and	#%10111111						; clear "HUD should disappear" bit in case it's set
	sta	DP_HUD_Status
	lda	#1							; simulate idle player so HUD won't disappear and reappear when there is no input within the next 5-7 seconds
	sta	DP_PlayerIdleCounter
+	rts



AreaJoyButtonL:
	rts



AreaJoyButtonR:
	rts



AreaJoyDpadUp:
	lda	#TBL_Hero1_up
	sta	DP_Hero1SpriteStatus
	jsr	MakeCollIndexUp

	ldy	DP_AreaMetaMapIndex
	lda	[DP_AreaMetaMapAddr], y					; check for BG collision using meta map entries
	bmi	+++
	ldy	DP_AreaMetaMapIndex2
	lda	[DP_AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	DP_Hero1MapPosY
	sec
	sbc	DP_Hero1WalkingSpd
	sta	DP_Hero1MapPosY
	lda	DP_AreaProperties					; check if area may be scrolled vertically
	and	#%0000000000001000
	bne	+
	lda	DP_Hero1ScreenPosYX					; area not scrollable, move hero sprite instead
	ldx	DP_Hero1WalkingSpd
-	sec
	sbc	#$0100							; Y -= 1
	dex								; as many times as DP_Hero1WalkingSpd
	bne	-
	sta	DP_Hero1ScreenPosYX
	bra	++

+	lda	DP_Hero1WalkingSpd
	eor	#$FFFF							; make negative
	inc	a
	clc
	adc	ARRAY_HDMA_BG_Scroll+3					; scroll area
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+3

++	Accu8

+++	rts



AreaJoyDpadDown:
	lda	#TBL_Hero1_down
	sta	DP_Hero1SpriteStatus
	jsr	MakeCollIndexDown

	ldy	DP_AreaMetaMapIndex
	lda	[DP_AreaMetaMapAddr], y					; check for BG collision using meta map entries
	bmi	+++
	ldy	DP_AreaMetaMapIndex2
	lda	[DP_AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	DP_Hero1MapPosY
	clc
	adc	DP_Hero1WalkingSpd
	sta	DP_Hero1MapPosY
	lda	DP_AreaProperties					; check if area may be scrolled vertically
	and	#%0000000000001000
	bne	+
	lda	DP_Hero1WalkingSpd					; area not scrollable, move hero sprite instead
	xba								; shift to high byte for Y value
	clc
	adc	DP_Hero1ScreenPosYX					; Y += DP_Hero1WalkingSpd
	sta	DP_Hero1ScreenPosYX
	bra	++

+	lda	DP_Hero1WalkingSpd
	clc
	adc	ARRAY_HDMA_BG_Scroll+3					; scroll area
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+3

++	Accu8

+++	rts



AreaJoyDpadLeft:
	lda	#TBL_Hero1_left
	sta	DP_Hero1SpriteStatus
	jsr	MakeCollIndexLeft

	ldy	DP_AreaMetaMapIndex
	lda	[DP_AreaMetaMapAddr], y					; check for BG collision using meta map entries
	bmi	+++
	ldy	DP_AreaMetaMapIndex2
	lda	[DP_AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	DP_Hero1MapPosX
	sec
	sbc	DP_Hero1WalkingSpd
	sta	DP_Hero1MapPosX
	lda	DP_AreaProperties					; check if area may be scrolled horizontally
	and	#%0000000000000100
	bne	+
	lda	DP_Hero1ScreenPosYX					; area not scrollable, move hero sprite instead
	sec
	sbc	DP_Hero1WalkingSpd					; X -= DP_Hero1WalkingSpd
	sta	DP_Hero1ScreenPosYX
	bra	++

+	lda	ARRAY_HDMA_BG_Scroll+1					; scroll area
	sec
	sbc	DP_Hero1WalkingSpd
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+1

++	Accu8

+++	rts



AreaJoyDpadRight:
	lda	#TBL_Hero1_right
	sta	DP_Hero1SpriteStatus
	jsr	MakeCollIndexRight

	ldy	DP_AreaMetaMapIndex
	lda	[DP_AreaMetaMapAddr], y					; check for BG collision using meta map entries
	bmi	+++
	ldy	DP_AreaMetaMapIndex2
	lda	[DP_AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	DP_Hero1MapPosX
	clc
	adc	DP_Hero1WalkingSpd
	sta	DP_Hero1MapPosX
	lda	DP_AreaProperties					; check if area may be scrolled horizontally
	and	#%0000000000000100
	bne	+
	lda	DP_Hero1ScreenPosYX					; area not scrollable, move hero sprite instead
	clc
	adc	DP_Hero1WalkingSpd					; X += DP_Hero1WalkingSpd
	sta	DP_Hero1ScreenPosYX
	bra	++

+	lda	ARRAY_HDMA_BG_Scroll+1					; scroll area
	clc
	adc	DP_Hero1WalkingSpd
	and	#$3FFF
	sta	ARRAY_HDMA_BG_Scroll+1

++	Accu8

+++	rts



AreaJoyButtonStart:

.IFNDEF DEBUG
	; ### TODO: Implement Pause function
	rts
.ELSE
	pla								; clean up stack from jsr AreaJoyButtonStart
	pla
	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus
	lda	VAR_Shadow_NMITIMEN
	and	#%11001111						; clear IRQ enable bits
	sta	REG_NMITIMEN
;	lda	#TBL_Hero1_down|$80					; make char face the player (for menu later) // adjust when debug menu is removed
;	sta	DP_Hero1SpriteStatus
	jsr	ClearHUD

	WaitFrames	1

.IFNDEF NOMUSIC
	jsl	music_stop						; stop music

	lda	DP_GameConfig
	and	#%00000001						; check for "MSU1 present" flag
	beq	+
	stz	MSU_CONTROL						; stop ambient soundtrack
+
.ENDIF

	jmp	DebugMenu
.ENDIF





UpdateAreaSprites:
	lda	DP_Hero1SpriteStatus
	bpl	@Hero1IsWalking						; bit 7 set = idle
	stz	DP_Hero1FrameCounter					; char is idle, reset frame counter
	lda	#TBL_Hero1_frame00
	bra	@Hero1WalkingDone

@Hero1IsWalking:
	lda	DP_Hero1FrameCounter					; 0-9: frame 1, 10-19: frame 0, 20-29: frame 2, 30-39: frame 0
	cmp	#40
	bcc	+
	stz	DP_Hero1FrameCounter					; reset frame counter
	bra	@Hero1Frame1

+	cmp	#30
	bcs	@Hero1Frame0
	cmp	#20
	bcs	@Hero1Frame2
	cmp	#10
	bcc	@Hero1Frame1

@Hero1Frame0:
	lda	#TBL_Hero1_frame00
	bra	+

@Hero1Frame2:
	lda	#TBL_Hero1_frame02
	bra	+

@Hero1Frame1:
	lda	#TBL_Hero1_frame01
+	inc	DP_Hero1FrameCounter					; increment animation frame counter

@Hero1WalkingDone:
	asl	a							; frame no. × 2 for correct tile no. in spritesheet

	Accu16

	and	#$00FF							; remove garbage bits
	ora	#$2200							; add sprite priority, use palette no. 1
	clc
	adc	#$0080							; skip $80 tiles = sprite font
	sta	ARRAY_SpriteDataArea.Hero1a+3				; tile no. (upper half of body)
	clc
	adc	#$0020
	sta	ARRAY_SpriteDataArea.Hero1b+3				; tile no. (lower half of body = upper half + 2 rows of 16 tiles)
	lda	DP_Hero1ScreenPosYX

	Accu8

	sta	ARRAY_SpriteDataArea.Hero1a
	sta	ARRAY_SpriteDataArea.Hero1b
	xba
	sta	ARRAY_SpriteDataArea.Hero1a+2
	clc
	adc	#16							; Y += 16 for lower half
	sta	ARRAY_SpriteDataArea.Hero1b+2

	Accu8

	rts



; **************************** HUD contens *****************************

PutAreaNameIntoHUD:							; HUD "text box" position (DP_Temp, DP_Temp+1) and DP_TextCursor are expected to contain sane values
	lda	#:SRC_AreaNames						; caveat: all area names & pointers should be located in the same bank
	sta	DP_TextStringBank
	sta	DP_DataBank

	Accu16

	lda	DP_TextLanguage						; check for selected language
	and	#$00FF							; mask off garbage bits
	asl	a
	tax
	lda.l	SRC_AreaNames, x					; starting address of area names of a given language into DataAddress
	sta	DP_DataAddress
	lda	DP_AreaNamePointerNo					; use area name pointer no. ...
	asl	a
	tay
	lda	[DP_DataAddress], y					; ... to read correct pointer
	sta	DP_TextStringPtr

	Accu8

@PutTextIntoHUD:
	ldy	#0							; get HUD string length
-	lda	[DP_TextStringPtr], y
	beq	+							; NUL terminator reached?
	iny								; increment input pointer
	bra	-

+	tya								; low byte is sufficient
	sta	DP_HUD_StrLength					; save value for later scrolling
	stz	DP_SpriteTextPalette					; use palette 0
	jsr	PrintSpriteText

	lda	DP_HUD_StrLength
	sta	REG_M7A
	stz	REG_M7A
	lda	#6							; HUD_StrLength × 6 (average width of font chars)
	sta	REG_M7B
	lda	REG_MPYL
	lsr	a							; divide result by 16 for loop index as each text box frame tile is 16 px wide
	lsr	a
	lsr	a
	lsr	a
	tay
	sta	DP_HUD_TextBoxSize					; save value (reused later for scrolling)
	ldx	#0
	lda	DP_Temp							; X
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	clc
	adc	#16							; X += 16
	sta	DP_Temp
	inx
	lda	#%00000010						; set sprite size = large
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx		
	lda	DP_Temp+1							; Y
	sta	DP_HUD_Ypos						; save to var for scrolling
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	lda	#2							; tile no. of left border
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	lda	#%00110000						; attributes, set highest priority
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	dey

-	lda	DP_Temp							; X
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	clc
	adc	#16							; X += 16
	sta	DP_Temp
	inx
	lda	#%00000010						; set sprite size = large
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx		
	lda	DP_Temp+1							; Y
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	lda	#3							; tile no. of main box
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	lda	#%00110000						; attributes, set highest priority
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	dey
	bne	-

	lda	DP_Temp							; X
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	clc
	adc	#16							; X += 16
	sta	DP_Temp
	inx
	lda	#%00000010						; set sprite size = large
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx		
	lda	DP_Temp+1							; Y
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	lda	#4							; tile no. of right border
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	inx
	lda	#%00110000						; attributes, set highest priority
	sta	ARRAY_SpriteDataArea.HUD_TextBox, x
	rts



; ************************ Collision detection *************************

MakeCollIndexUp:



; -------------------------- create collision index for left edge of char sprite
	Accu16

	ldy	#0
	lda	DP_Hero1MapPosX						; MapPosX/Y references the upper leftmost sprite pixel
	clc								; acknowledge left collision margin
	adc	#PARAM_CollMarginLeft
-	cmp	#16							; value still >=16?
	bcc	+
	sec								; no, subtract 16 from value (each meta map entry represents 2×2 tiles, or 16×16 px)
	sbc	#16
	iny								; add 1 to collision index per 16 pixels subtracted
	bra	-

+	sty	DP_AreaMetaMapIndex					; save interim result (horizontal position in meta map)
	ldy	#0
	lda	DP_Hero1MapPosY
	clc								; add 1 row (w/o top margin) --> check character's lower 16×16 sprite (upper half of body is unaffected)
	adc	#16-PARAM_CollMarginTop
-	cmp	#16							; value still >=16?
	bcc	+
	sec								; no, subtract 16 from value
	sbc	#16
	tax								; preserve Accu in unused X register
	tya
	clc								; add 16 to collision index per 16 pixels subtracted as there are 16 meta map entries per line // FIXME for area maps larger than 32×32 tiles
	adc	#16
	tay
	txa								; restore Accu
	bra	-

+	tya
	sta	DP_AreaMetaMapIndex2					; save interim result (vertical position in meta map) so we won't need to calculate this part again
	clc
	adc	DP_AreaMetaMapIndex
	sta	DP_AreaMetaMapIndex					; save final index value for left edge



; -------------------------- create collision index for right edge of char sprite
	ldy	#0
	lda	DP_Hero1MapPosX
	clc								; go to right edge, acknowledge right collision margin
	adc	#16-PARAM_CollMarginRight
-	cmp	#16							; same thing as above
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	tya
	clc
	adc	DP_AreaMetaMapIndex2
	sta	DP_AreaMetaMapIndex2					; save final index value for right edge

	Accu8

	rts



MakeCollIndexDown:



; -------------------------- create collision index for left edge of char sprite
	Accu16

	ldy	#0
	lda	DP_Hero1MapPosX
	clc								; acknowledge left collision margin
	adc	#PARAM_CollMarginLeft
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	sty	DP_AreaMetaMapIndex
	ldy	#0
	lda	DP_Hero1MapPosY
	clc								; add 2 rows (+1 px) --> check tile below character's lower 16×16 sprite
	adc	#33
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	tax
	tya
	clc
	adc	#16
	tay
	txa
	bra	-

+	tya
	sta	DP_AreaMetaMapIndex2					; save interim result for later
	clc
	adc	DP_AreaMetaMapIndex
	sta	DP_AreaMetaMapIndex



; -------------------------- create collision index for right edge of char sprite
	ldy	#0
	lda	DP_Hero1MapPosX
	clc								; go to right edge, acknowledge right collision margin
	adc	#16-PARAM_CollMarginRight
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	tya
	clc
	adc	DP_AreaMetaMapIndex2
	sta	DP_AreaMetaMapIndex2

	Accu8

	rts



MakeCollIndexLeft:



; -------------------------- create collision index for upper corner of lower char sprite
	Accu16

	ldy	#0
	lda	DP_Hero1MapPosX
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	sty	DP_AreaMetaMapIndex
	sty	DP_AreaMetaMapIndex2					; save interim result for later
	ldy	#0
	lda	DP_Hero1MapPosY
	clc								; add 1 row for lower char sprite
	adc	#16+PARAM_CollMarginTop
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	tax
	tya
	clc
	adc	#16
	tay
	txa
	bra	-

+	tya
	clc
	adc	DP_AreaMetaMapIndex
	sta	DP_AreaMetaMapIndex



; -------------------------- create collision index for lower corner of lower char sprite
	ldy	#0
	lda	DP_Hero1MapPosY
	clc								; add 2 rows (-1 px)
	adc	#31
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	tax
	tya
	clc
	adc	#16
	tay
	txa
	bra	-

+	tya
	clc
	adc	DP_AreaMetaMapIndex2
	sta	DP_AreaMetaMapIndex2

	Accu8

	rts



MakeCollIndexRight:



; -------------------------- create collision index for upper corner of lower char sprite
	Accu16

	ldy	#0
	lda	DP_Hero1MapPosX
	clc								; go to right edge
	adc	#16
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	sty	DP_AreaMetaMapIndex
	sty	DP_AreaMetaMapIndex2					; save interim result for later
	ldy	#0
	lda	DP_Hero1MapPosY
	clc								; add 1 row for lower char sprite
	adc	#16+PARAM_CollMarginTop
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	tax
	tya
	clc
	adc	#16
	tay
	txa
	bra	-

+	tya
	clc
	adc	DP_AreaMetaMapIndex
	sta	DP_AreaMetaMapIndex



; -------------------------- create collision index for lower corner of lower char sprite
	ldy	#0
	lda	DP_Hero1MapPosY
	clc								; add 2 rows (-1 px)
	adc	#31
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	tax
	tya
	clc
	adc	#16
	tay
	txa
	bra	-

+	tya
	clc
	adc	DP_AreaMetaMapIndex2
	sta	DP_AreaMetaMapIndex2

	Accu8

	rts



; ******************************** EOF *********************************
