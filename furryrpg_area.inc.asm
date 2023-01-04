;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA HANDLER ***
;
;==========================================================================================



LoadAreaData:
	.ACCU 8
	.INDEX 16

	lda	#$80							; enter forced blank
	sta	RAM_INIDISP
;	jsr	SpriteInit						; purge OAM
	jsr	SpriteDataInit						; purge sprite data buffer

	wai

	DisableIRQs

	.IFNDEF NOMUSIC
		SNESGSS_Command kGSS_MUSIC_STOP, 0			; stop music in case it's playing

		stz	MSU_CONTROL					; stop MSU1 track in case it's playing
	.ENDIF

	stz	<DP2.HDMA_Channels					; disable HDMA
	stz	HDMAEN
	ldx	#loword(RAM.BG3Tilemap)					; clear BG3 text
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 1024

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	jsr	LoadTextBoxBorderTiles					; prepare some stuff for text box
	jsr	MakeTextBoxTilemapBG1
	jsr	MakeTextBoxTilemapBG2



; Look up area properties, load area gfx data
	Accu16

	lda	<DP2.AreaCurrent
	asl	a
	tax
	lda.l	PTR_AreaProperties, x					; set data offset for selected area
	tax
	lda.l	SRC_AreaPropertyTables, x				; read area properties (16 bits of data)
	sta	<DP2.AreaProperties
	inx
	inx
	lda.l	SRC_AreaPropertyTables, x				; read gfx source offset (16 bits of data)
	sta	RAM_DMA_SourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaPropertyTables, x				; read gfx source bank (8 bits of data)
	sta	RAM_DMA_SourceBank
	inx

	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read size of gfx (16 bits of data)
	sta	RAM_DMA_TransferLength
	inx
	inx
	lda	#$1801							; set DMA mode & B bus register (VMDATAL)
	sta	RAM_DMA_ModeBBusReg
	lda	#VRAM_AreaBG1						; set VRAM address
	sta	VMADDL
	jsl	RAM.Routines.DMA



; Load area BG1 tilemap data
	lda.l	SRC_AreaPropertyTables, x				; read tilemap source offset (16 bits of data)
	sta	RAM_DMA_SourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaPropertyTables, x				; read tilemap source bank (8 bits of data)
	sta	RAM_DMA_SourceBank
	inx

	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read size of tilemap (16 bits of data)
	sta	RAM_DMA_TransferLength
	inx
	inx
	lda	#$8000							; set DMA mode & B bus register (WMDATA)
	sta	RAM_DMA_ModeBBusReg

	Accu8

	ldy	#loword(RAM.ScratchSpace)				; set WRAM address to scratch space
	sty	WMADDL
	stz	WMADDH
	jsl	RAM.Routines.DMA



; "Deinterleave" BG1 tilemap, add tile no. offset
	phx								; preserve area data pointer
	ldx	#loword(RAM.ScratchSpace)				; set DP2.DataAddress to scratch space for postindexed long addressing
	stx	<DP2.DataAddress
	lda	#$7E
	sta	<DP2.DataBank
	ldx	#0
	ldy	#0

-	Accu16

	lda	[<DP2.DataAddress], y					; read original tilemap data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(VRAM_AreaBG1 >> 4)					; 172 tiles

	Accu8

	sta	RAM.BG1Tilemap1, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	RAM.BG1Tilemap1Hi, x
	inx
	cpx	#1024
	bne	-

	ldx	#0

-	Accu16

	lda	[<DP2.DataAddress], y					; read original tilemap data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(VRAM_AreaBG1 >> 4)					; 172 tiles

	Accu8

	sta	RAM.BG1Tilemap2, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	RAM.BG1Tilemap2Hi, x
	inx
	cpx	#1024
	bne	-

	plx								; restore area data pointer



; Load area BG2 tilemap data (optional)
	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read tilemap source offset (16 bits of data)
	cmp	#$FFFF							; $FFFF = no BG2 tilemap for this area
	bne	+
	inx								; skip 5 bytes of unused BG2 tilemap pointers
	inx
	inx
	inx
	inx
	jmp	@BG2TilemapDone

+	sta	RAM_DMA_SourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaPropertyTables, x				; read tilemap source bank (8 bits of data)
;	cmp	#$FF							; never mind checking those again
;	beq	@BG2TilemapDone
	sta	RAM_DMA_SourceBank
	inx

	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read size of tilemap (16 bits of data)
;	cmp	#$FFFF
;	beq	@BG2TilemapDone
	sta	RAM_DMA_TransferLength
	inx
	inx
	lda	#$8000							; set DMA mode & B bus register (WMDATA)
	sta	RAM_DMA_ModeBBusReg

	Accu8

	ldy	#loword(RAM.ScratchSpace)				; set WRAM address to scratch space
	sty	WMADDL
	stz	WMADDH
	jsl	RAM.Routines.DMA



; "Deinterleave" BG2 tilemap, add tile no. offset
	phx								; preserve area data pointer
	ldx	#loword(RAM.ScratchSpace)				; set DP2.DataAddress to scratch space for postindexed long addressing
	stx	<DP2.DataAddress
	lda	#$7E
	sta	<DP2.DataBank
	ldx	#0
	ldy	#0

-	Accu16

	lda	[<DP2.DataAddress], y					; read original tilemap data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(VRAM_AreaBG1 >> 4)					; 172 tiles

	Accu8

	sta	RAM.BG2Tilemap1, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	RAM.BG2Tilemap1Hi, x
	inx
	cpx	#1024
	bne	-

	ldx	#0

-	Accu16

	lda	[<DP2.DataAddress], y					; read original tilemap data (16 bit)
	iny
	iny
	clc								; add offset (font, portrait)
	adc	#(VRAM_AreaBG1 >> 4)					; 172 tiles

	Accu8

	sta	RAM.BG2Tilemap2, x					; store new data
	xba
	ora	#$08							; set palette #2
	sta	RAM.BG2Tilemap2Hi, x
	inx
	cpx	#1024
	bne	-

	plx								; restore area data pointer

@BG2TilemapDone:



; Load area palette data
	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read palette source offset (16 bits of data)
	sta	RAM_DMA_SourceOffset
	inx
	inx

	Accu8

	lda.l	SRC_AreaPropertyTables, x				; read palette source bank (8 bits of data)
	sta	RAM_DMA_SourceBank
	inx

	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read palette size (16 bits of data)
	sta	RAM_DMA_TransferLength
	inx
	inx
	lda	#$2202							; set DMA mode & B bus register (CGDATA)
	sta	RAM_DMA_ModeBBusReg

	Accu8

	lda	#CGRAM_Area						; set CGRAM address for BG1 tiles palette
	sta	CGADD
	jsl	RAM.Routines.DMA



; Load & set collision map address
	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read meta map source offset (16 bits of data)
	sta	<DP2.AreaMetaMapAddr
	inx
	inx

	Accu8

	lda.l	SRC_AreaPropertyTables, x				; read meta map source bank (8 bits of data)
	sta	<DP2.AreaMetaMapAddr+2
	inx



; Load area soundtrack data and area name pointer
	Accu16

	lda.l	SRC_AreaPropertyTables, x				; read default SNESGSS music track
	sta	<DP2.NextTrack
	inx
	inx
	lda.l	SRC_AreaPropertyTables, x				; read default MSU1 ambient track
	sta	<DP2.MSU1_NextTrack
	inx
	inx
	lda.l	SRC_AreaPropertyTables, x				; read pointer to area name
	sta	<DP2.AreaNamePointerNo
	inx
	inx



; Load hero parameters for this area
	lda.l	SRC_AreaPropertyTables, x				; read hero screen position
	sta	<DP2.Hero1ScreenPosYX
	sta	LO8.Hero1TargetScrPosYX
	inx
	inx
	lda.l	SRC_AreaPropertyTables, x				; read hero map position (X)
	sta	<DP2.Hero1MapPosX
	inx
	inx
	lda.l	SRC_AreaPropertyTables, x				; read hero map position (Y)
	sta	<DP2.Hero1MapPosY
	inx
	inx

	Accu8

	lda.l	SRC_AreaPropertyTables, x				; read hero sprite status
	sta	<DP2.Hero1SpriteStatus



; Misc. palettes --> CGRAM
	lda	#$90							; set CGRAM address to #288 (word address) for sprites
	sta	CGADD

	DMA_CH0 $02, SRC_Palette_Spritesheet_Hero1, CGDATA, 32



; HDMA tables --> WRAM
	Accu16

	ldx	#0
-	lda.l	SRC_HDMA_ResetBGScroll, x
	sta	LO8.HDMA_BG_Scroll, x
	inx
	inx
	cpx	#16
	bne	-

	Accu8



; HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	DMAP3
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	BBAD3
	ldx	#LO8.HDMA_ColorMath
	stx	A1T3L
	lda	#$7E							; table in WRAM expected
	sta	A1B3



; HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	DMAP4
	lda	#$0D							; PPU reg. $210D
	sta	BBAD4
	ldx	#LO8.HDMA_BG_Scroll
	stx	A1T4L
	lda	#$7E
	sta	A1B4



; HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210F, 2 bytes --> $2110)
	sta	DMAP5
	lda	#$0F							; PPU reg. $210F
	sta	BBAD5
	ldx	#LO8.HDMA_BG_Scroll
	stx	A1T5L
	lda	#$7E
	sta	A1B5



; Set up RAM mirror registers
	lda	#$01|$08						; set BG Mode 1 for area, BG3 priority
	sta	RAM_BGMODE
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	RAM_OBSEL
	lda	<DP2.AreaProperties					; set tilemap size according to area properties
	and	#%00000011						; mask off bits not related to screen size
	ora	#$50							; VRAM address for BG1 tilemap: $5000
	sta	RAM_BG1SC
	lda	<DP2.AreaProperties
	and	#%00000011
	ora	#$58							; VRAM address for BG2 tilemap: $5800
	sta	RAM_BG2SC
	lda	#$48							; VRAM address for BG3 tilemap: $4800
	sta	RAM_BG3SC
	lda	#$00							; VRAM address for BG1 and BG2 character data: $0000
	sta	RAM_BG12NBA
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA



; Pre-load GSS music track
	lda	<DP2.NextTrack
	cmp	#$FF							; DP2.NextTrack = $FF --> don't load any music
	beq	@GSSLoadTrackDone

	jsl	LoadTrackGSS

@GSSLoadTrackDone:



; Misc. settings
	lda	#%00010111						; turn on BG1/2/3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TM

	SetNMI	kNMI_Area

	Accu16

	lda	#228							; dot number for interrupt (256 = too late, 204 = too early)
	sta	HTIMEL
	lda	#224							; scanline number for interrupt (last one for now)
	sta	VTIMEL

	Accu8

	sta	<DP2.TextBoxVIRQ					; save scanline no.

	SetIRQ	kVIRQ_Area

	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable Vblank NMI + Auto Joypad Read
	sta	LO8.NMITIMEN
	sta	NMITIMEN						; FIXME, needed for EffectHSplitIn, make LO8.NMITIMEN an actual mirror variable (copied to register within some main game loop, but not on Vblank)
	cli								; re-enable interrupts

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	<DP2.DMA_Updates
	tsb	<DP2.DMA_Updates+1
	jsr	UpdateAreaSprites					; put characters on initial positions

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer

	WaitFrames	4						; give some time for screen refresh

	rts



ShowArea:
	jsr	LoadAreaData

	stz	<DP2.HUD_DispCounter					; reset HUD status
	stz	<DP2.HUD_DispCounter+1
	stz	<DP2.HUD_Status
	jsr	ClearHUD

	lda	#kHUD_Xpos						; initial X position of "text box" frame
	sta	<DP2.Temp
	clc								; make up for different X position of "text box" and text
	adc	#6
	sta	<DP2.TextCursor
	lda	#kHUD_Yhidden						; initial Y position (hidden)
	sta	<DP2.Temp+1
	clc
	adc	#4
	sta	<DP2.TextCursor+1
	jsr	PutAreaNameIntoHUD

	lda	#kEffectSpeed3
	sta	<DP2.EffectSpeed
	ldx	#kEffectTypeHSplitIn
	jsr	(PTR_EffectTypes, x)



	.ENDASM

; CM EFFECT TEST 1: NIGHT
	lda	#%00010111						; mainscreen: BG1/2/3 + sprites
	sta	RAM_TM
	stz	RAM_TS							; subscreen: nothing
	lda	#$72							; subscreen backdrop color to subtract
	sta	COLDATA
	stz	CGWSEL							; clear CM disable bits
	lda	#%10010011						; enable color math on BG1/2 + sprites, subtract color
	sta	CGADSUB

-	bra	-



; CM EFFECT TEST 2: NIGHT W/ SPRITES, XORed palette req.
	lda	#$80							; enter forced blank
	sta	INIDISP
	lda	#CGRAM_Area						; set CGRAM address for BG1 tiles palette
	sta	CGADD
	ldx	#0
-	lda.l	SRC_Palette_Area001, x
	eor	#$FF
	sta	CGDATA
	inx
	cpx	#32
	bne	-

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	CGADD
	ldx	#0
-	lda.l	SRC_Palette_Spritesheet_Hero1, x
	eor	#$FF
	sta	CGDATA
	inx
	cpx	#32
	bne	-

	lda	#%00000100						; mainscreen: BG3
	sta	RAM_TM
	lda	#%00010011						; subscreen: BG1/2, sprites
	sta	RAM_TS
	stz	CGADD							; backdrop color to subtract
	lda	#$52
	sta	CGDATA
	lda	#$1E
	sta	CGDATA
	lda	#%00000010						; clear CM disable bits, enable BGs/OBJs on subscreen
	sta	CGWSEL
	lda	#%10100000						; enable color math on backdrop, subtract color
	sta	CGADSUB
	lda	#$0F
	sta	INIDISP

-	bra	-



; CM EFFECT TEST 3: blue overlay
	lda	#%00000010						; clear color math disable bits (4-5), enable BGs/OBJs on subscreen
	sta	CGWSEL
	lda	#%00100000						; enable color math on backdrop only
	sta	CGADSUB
	stz	CGADD							; set backdrop color to overlay the whole image
	stz	CGDATA							; $6C00 = bright blue
	lda	#$6C
	sta	CGDATA
	lda	#%00000100						; mainscreen: BG3
	sta	RAM_TM
	lda	#%00010011						; subscreen: BG1/2, sprites
	sta	RAM_TS

	.ASM



; Play music & ambient sound effect
	.IFNDEF NOMUSIC
		lda	<DP2.NextTrack+1
		cmp	#$FF						; DP2.NextTrack = $FFFF --> don't play any music
		bne	+
		lda	<DP2.NextTrack
		cmp	#$FF
		beq	@GSSPlayTrackDone

	+	jsl	PlayTrackGSS

	@GSSPlayTrackDone:

		lda	<DP2.GameConfig
		and	#%00000001					; check for "MSU1 present" flag
		beq	@MSU1TrackDone

		Accu16

		lda	<DP2.MSU1_NextTrack				; MSU1 present, set track
		cmp	#$FFFF						; $FFFF = don't play any MSU1 track
		beq	+
		sta	MSU_TRACK

	-	lda	MSU_STATUS					; wait for Audio Busy bit to clear
		and	#%0000000001000000
		bne	-

		lda	#%0000001111111111				; set play, repeat flags, max. volume (16-bit write to MSU_CONTROL, too)
		sta	MSU_VOLUME

	+	Accu8

	@MSU1TrackDone:

	.ENDIF



MainAreaLoop:
	WaitFrames	1						; don't use WAI here as IRQ might be enabled!

	lda	LO8.NMITIMEN
	sta	NMITIMEN



; Player idle counter
	Accu16

	lda	<DP2.Joy1Press						; check for any input (sans Y button)
	and	#%1011111111110000
	beq	@PlayerIsIdle
	stz	<DP2.PlayerIdleCounter					; player not idle, reset counter
	bra	+

@PlayerIsIdle:
	lda	<DP2.PlayerIdleCounter
	inc	a							; assume player is idle
	cmp	#$FFFF
	bcs	+							; don't wrap around to 0
	sta	<DP2.PlayerIdleCounter

+	Accu8



; Screen saver (darken screen every $1000 frames = 70-82 seconds when player is idle)
	lda	<DP2.PlayerIdleCounter+1
	lsr	a							; shift highest nibble of DP2.PlayerIdleCounter (16 bit) to lower nibble of Accu
	lsr	a
	lsr	a
	lsr	a
	eor	#$0F							; convert to brightness level value ($00 --> $0F, $01 --> $0E ... $0F --> $00)
	sta	RAM_INIDISP



; HUD display logic
	lda	<DP2.HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	bne	@HUDIsVisible						; yes

	Accu16

	lda	<DP2.PlayerIdleCounter					; no, check if player has been idle for at least 300 frames (5-6 seconds)
	cmp	#301
	bcc	@HUDLogicJumpOut					; no, jump out

	Accu8

	lda	#%10000000						; yes, set "HUD should appear" bit
	tsb	<DP2.HUD_Status
	bra	@HUDLogicDone

@HUDIsVisible:
	Accu16

	lda	<DP2.HUD_DispCounter
	inc	a
	sta	<DP2.HUD_DispCounter
	cmp	#151							; show HUD for at least 150 frames before hiding it again
	bcc	@HUDLogicJumpOut


@HideHUDOrNot:
	lda	<DP2.PlayerIdleCounter					; if player is currently idle, don't do anything
	bne	@HUDLogicJumpOut

	Accu8

	lda	#%01000000						; otherwise, set "HUD should disappear" bit
	tsb	<DP2.HUD_Status

@HUDLogicJumpOut:
	Accu8

@HUDLogicDone:



	.IFDEF DEBUG
;		PrintString	2, 26, kTextBG3, "X="
;		PrintHexNum	<DP2.Hero1ScreenPosYX
;		PrintString	3, 26, kTextBG3, "Y="
;		PrintHexNum	<DP2.Hero1ScreenPosYX+1

;		PrintString	2, 22, kTextBG3, "ScrX="
;		PrintHexNum	ARRAY_HDMA_BGScroll+2
;		PrintHexNum	ARRAY_HDMA_BGScroll+1

;		PrintString	3, 22, kTextBG3, "ScrY="
;		PrintHexNum	ARRAY_HDMA_BGScroll+4
;		PrintHexNum	ARRAY_HDMA_BGScroll+3

;		PrintString	7, 5, kTextBG3, "MapPosX="
;		PrintHexNum	<DP2.Hero1MapPosX+1
;		PrintHexNum	<DP2.Hero1MapPosX

;		PrintString	8, 5, kTextBG3, "MapPosY="
;		PrintHexNum	<DP2.Hero1MapPosY+1
;		PrintHexNum	<DP2.Hero1MapPosY
	.ENDIF



; Text box
	bit	<DP2.TextBoxStatus					; check if text box is active (MSB set)
	bpl	@NoTextBox
	jsr	ProcDialogTextBox					; yes, go to subroutine

	jmp	@SkipDpadABXY						; and skip subsequent button checks

@NoTextBox:



; Check for dpad released // all dpad checks need to be made before other button checks as e.g. A needs to override flags in DP2.Hero1SpriteStatus)
	lda	<DP2.Joy1New+1
	and	#kAllDpad
	bne	@DpadNewDone

	lda	#$80							; d-pad released, make character idle
	tsb	<DP2.Hero1SpriteStatus

@DpadNewDone:



; Check for dpad up
	lda	<DP2.Joy1Press+1
	and	#kDpadUp
	beq	@DpadUpDone

	jsr	AreaJoyDpadUp

@DpadUpDone:



; Check for dpad down
	lda	<DP2.Joy1Press+1
	and	#kDpadDown
	beq	@DpadDownDone

	jsr	AreaJoyDpadDown

@DpadDownDone:



; Check for dpad left
	lda	<DP2.Joy1Press+1
	and	#kDpadLeft
	beq	@DpadLeftDone

	jsr	AreaJoyDpadLeft

@DpadLeftDone:



; Check for dpad right
	lda	<DP2.Joy1Press+1
	and	#kDpadRight
	beq	@DpadRightDone

	jsr	AreaJoyDpadRight

@DpadRightDone:



; Check for A button
	bit	<DP2.Joy1New
	bpl	@AButtonDone
	jsr	AreaJoyButtonA

@AButtonDone:



; Check for B button
	bit	<DP2.Joy1Press+1
	bmi	+
	lda	#1							; B not pressed, set slow walking speed
	bra	@BButtonDone

+	jsr	AreaJoyButtonB

@BButtonDone:
	sta	<DP2.Hero1WalkingSpd



; Check for X button
	bit	<DP2.Joy1New
	bvc	@XButtonDone
	jsr	AreaJoyButtonX

@XButtonDone:



; Check for Y button
	bit	<DP2.Joy1New+1
	bvc	@YButtonDone
	jsr	AreaJoyButtonY

@YButtonDone:

@SkipDpadABXY:



; Check for Start
	lda	<DP2.Joy1+1
	and	#kButtonStart
	beq	@StartButtonDone

	jsr	AreaJoyButtonStart

@StartButtonDone:



; Update HUD based on player input
	bit	<DP2.HUD_Status						; check HUD status
	bmi	@ShowHUD
	bvs	@HideHUD
	jmp	@UpdateHUDDone

@ShowHUD:
	Accu16								; take care about "text box" sprites

	lda	<DP2.HUD_TextBoxSize
	and	#$00FF							; remove garbage in high byte
	inc	a							; +1 for right edge of "text box" frame
	tay

	Accu8

	lda	<DP2.HUD_Ypos
	and	#%11111100						; make value divisible by 4 so rising values in DP2.HUD_Ypos will always be the same
	clc								; DP2.HUD_Ypos += 4 (HUD appears 4 times as fast as it disappears)
	adc	#4
	sta	<DP2.HUD_Ypos
	ldx	#2							; start at Y value
-	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	inx
	inx
	inx
	inx
	dey								; all "text box" sprites done?
	bne	-

	Accu16								; next, scroll text as well

	lda	<DP2.HUD_StrLength
	and	#$00FF							; remove garbage in high byte
	tay

	Accu8

	lda	<DP2.HUD_Ypos
	clc								; make up for different Y position of "text box" and text
	adc	#4
	ldx	#2							; start at Y value
-	sta	RAM.SpriteDataArea.Text, x
	inx
	inx
	inx
	inx
	inx
	dey								; all font sprites done?
	bne	-

	lda	<DP2.HUD_Ypos						; final Y value reached?
	cmp	#kHUD_Yvisible
	bne	@UpdateHUDDone
	lda	<DP2.HUD_Status
	ora	#%00000001						; yes, set "HUD is being displayed" bit
	and	#%01111111						; clear "HUD should appear" bit
	sta	<DP2.HUD_Status
	stz	<DP2.HUD_DispCounter					; and reset display counter values
	stz	<DP2.HUD_DispCounter+1
	bra	@UpdateHUDDone

@HideHUD:
	lda	#%00000001						; clear "HUD is visible" bit now so the player can bring the HUD back with Y while it's disappearing
	trb	<DP2.HUD_Status

	Accu16								; take care about "text box" sprites

	lda	<DP2.HUD_TextBoxSize
	and	#$00FF							; remove garbage in high byte
	inc	a							; +1 for right edge of "text box" frame
	tay

	Accu8

	lda	<DP2.HUD_Ypos
	dec	a
	sta	<DP2.HUD_Ypos						; DP2.HUD_Ypos -= 1
	cmp	#kHUD_Yhidden						; final/initial (hidden) Y value reached?
	bne	+
	lda	#%01000000
	trb	<DP2.HUD_Status						; yes, clear "HUD should disappear" status bit
	bra	@UpdateHUDDone

+	ldx	#2							; start at Y value
-	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	inx
	inx
	inx
	inx
	dey								; all "text box" sprites done?
	bne	-

	Accu16								; next, scroll text as well

	lda	<DP2.HUD_StrLength
	and	#$00FF							; remove garbage in high byte
	tay

	Accu8

	lda	<DP2.HUD_Ypos
	clc								; make up for different Y position of "text box" and text
	adc	#4
	ldx	#2							; start at Y value
-	sta	RAM.SpriteDataArea.Text, x
	inx
	inx
	inx
	inx
	inx
	dey								; all font sprites done?
	bne	-

@UpdateHUDDone:



; Determine active objects (sprites) // set static values for now
	lda	#%01100001						; set "object is active," "object is hero," and "can collide with other objects" flags
	ldx	#69							; 69th sprite = first hero sprite
	sta	LO8.ObjectList, x
	inx								; 70th sprite = second hero sprite
	sta	LO8.ObjectList, x



; Misc. tasks, end loop
	jsr	UpdateAreaSprites

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer

	jmp	MainAreaLoop



; ************************ Handle player input *************************

; A button pressed = do lots of important stuff ;-)

AreaJoyButtonA:
	lda	#$80							; make character idle
	tsb	<DP2.Hero1SpriteStatus

	; ### TODO: CHECK FOR CHARACTER INTERACTION, TREASURE, POINTS OF INTEREST ETC.

	.IFDEF DEBUG
		jsr	InitDialogTextBox
	.ENDIF

	rts


; B button pressed = make HUD disappear/set fast walking speed

AreaJoyButtonB:
	lda	<DP2.HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	beq	+
	lda	<DP2.HUD_Status
	and	#%01111111						; yes, clear "HUD should appear" bit in case it's set
	ora	#%01000000						; set "HUD should disappear" bit
	sta	<DP2.HUD_Status
+	lda	#2							; set fast walking speed

	rts



; X button pressed = transition to in-game menu

AreaJoyButtonX:
	; ### TODO: preserve area data

	jmp	InGameMenu

	rts



; Y button pressed = show HUD

AreaJoyButtonY:
	lda	<DP2.HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	bne	+
	lda	<DP2.HUD_Status
	ora	#%10000000						; no, set "HUD should appear" bit
	and	#%10111111						; clear "HUD should disappear" bit in case it's set
	sta	<DP2.HUD_Status
	lda	#1							; simulate idle player so HUD won't disappear and reappear when there is no input within the next 5-7 seconds
	sta	<DP2.PlayerIdleCounter

+	rts



AreaJoyButtonL:

	rts



AreaJoyButtonR:

	rts



AreaJoyDpadUp:
	lda	#k8_Hero1_up
	sta	<DP2.Hero1SpriteStatus
	jsr	MakeCollIndexUp

	ldy	<DP2.AreaMetaMapIndex
	lda	[<DP2.AreaMetaMapAddr], y				; check for BG collision using meta map entries
	bmi	+++
	ldy	<DP2.AreaMetaMapIndex2
	lda	[<DP2.AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	<DP2.Hero1MapPosY
	sec
	sbc	<DP2.Hero1WalkingSpd
	sta	<DP2.Hero1MapPosY
	lda	<DP2.AreaProperties					; check if area may be scrolled vertically
	and	#%0000000000001000
	bne	+
	lda	<DP2.Hero1ScreenPosYX					; area not scrollable, move hero sprite instead
	ldx	<DP2.Hero1WalkingSpd
-	sec
	sbc	#$0100							; Y -= 1
	dex								; as many times as DP2.Hero1WalkingSpd
	bne	-
	sta	<DP2.Hero1ScreenPosYX
	bra	++

+	lda	<DP2.Hero1WalkingSpd
	eor	#$FFFF							; make negative
	inc	a
	clc
	adc	LO8.HDMA_BG_Scroll+3					; scroll area
	and	#$3FFF
	sta	LO8.HDMA_BG_Scroll+3

++	Accu8

+++	rts



AreaJoyDpadDown:
	lda	#k8_Hero1_down
	sta	<DP2.Hero1SpriteStatus
	jsr	MakeCollIndexDown

	ldy	<DP2.AreaMetaMapIndex
	lda	[<DP2.AreaMetaMapAddr], y				; check for BG collision using meta map entries
	bmi	+++
	ldy	<DP2.AreaMetaMapIndex2
	lda	[<DP2.AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	<DP2.Hero1MapPosY
	clc
	adc	<DP2.Hero1WalkingSpd
	sta	<DP2.Hero1MapPosY
	lda	<DP2.AreaProperties					; check if area may be scrolled vertically
	and	#%0000000000001000
	bne	+
	lda	<DP2.Hero1WalkingSpd					; area not scrollable, move hero sprite instead
	xba								; shift to high byte for Y value
	clc
	adc	<DP2.Hero1ScreenPosYX					; Y += DP2.Hero1WalkingSpd
	sta	<DP2.Hero1ScreenPosYX
	bra	++

+	lda	<DP2.Hero1WalkingSpd
	clc
	adc	LO8.HDMA_BG_Scroll+3					; scroll area
	and	#$3FFF
	sta	LO8.HDMA_BG_Scroll+3

++	Accu8

+++	rts



AreaJoyDpadLeft:
	lda	#k8_Hero1_left
	sta	<DP2.Hero1SpriteStatus
	jsr	MakeCollIndexLeft

	ldy	<DP2.AreaMetaMapIndex
	lda	[<DP2.AreaMetaMapAddr], y				; check for BG collision using meta map entries
	bmi	+++
	ldy	<DP2.AreaMetaMapIndex2
	lda	[<DP2.AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	<DP2.Hero1MapPosX
	sec
	sbc	<DP2.Hero1WalkingSpd
	sta	<DP2.Hero1MapPosX
	lda	<DP2.AreaProperties					; check if area may be scrolled horizontally
	and	#%0000000000000100
	bne	+
	lda	<DP2.Hero1ScreenPosYX					; area not scrollable, move hero sprite instead
	sec
	sbc	<DP2.Hero1WalkingSpd					; X -= DP2.Hero1WalkingSpd
	sta	<DP2.Hero1ScreenPosYX
	bra	++

+	lda	LO8.HDMA_BG_Scroll+1					; scroll area
	sec
	sbc	<DP2.Hero1WalkingSpd
	and	#$3FFF
	sta	LO8.HDMA_BG_Scroll+1

++	Accu8

+++	rts



AreaJoyDpadRight:
	lda	#k8_Hero1_right
	sta	<DP2.Hero1SpriteStatus
	jsr	MakeCollIndexRight

	ldy	<DP2.AreaMetaMapIndex
	lda	[<DP2.AreaMetaMapAddr], y				; check for BG collision using meta map entries
	bmi	+++
	ldy	<DP2.AreaMetaMapIndex2
	lda	[<DP2.AreaMetaMapAddr], y
	bmi	+++

	Accu16

	lda	<DP2.Hero1MapPosX
	clc
	adc	<DP2.Hero1WalkingSpd
	sta	<DP2.Hero1MapPosX
	lda	<DP2.AreaProperties					; check if area may be scrolled horizontally
	and	#%0000000000000100
	bne	+
	lda	<DP2.Hero1ScreenPosYX					; area not scrollable, move hero sprite instead
	clc
	adc	<DP2.Hero1WalkingSpd					; X += DP2.Hero1WalkingSpd
	sta	<DP2.Hero1ScreenPosYX
	bra	++

+	lda	LO8.HDMA_BG_Scroll+1					; scroll area
	clc
	adc	<DP2.Hero1WalkingSpd
	and	#$3FFF
	sta	LO8.HDMA_BG_Scroll+1

++	Accu8

+++	rts



AreaJoyButtonStart:

	.IFNDEF DEBUG

	; ### TODO: Implement Pause function

		rts

	.ELSE
		pla							; clean up stack from jsr AreaJoyButtonStart
		pla
		lda	#kEffectSpeed3
		sta	<DP2.EffectSpeed
		ldx	#kEffectTypeHSplitOut2
		jsr	(PTR_EffectTypes, x)

		stz	<DP2.TextBoxStatus				; reset text box status
		lda	#%00110000					; clear IRQ enable bits
		trb	LO8.NMITIMEN
;		lda	#k8_Hero1_down|$80				; make char face the camera (for menu later) // adjust when debug menu is removed
;		sta	<DP2.Hero1SpriteStatus
		jsr	ClearHUD

		WaitFrames	1

		.IFNDEF NOMUSIC
			SNESGSS_Command kGSS_MUSIC_STOP, 0		; stop music

			lda	<DP2.GameConfig
			and	#%00000001				; check for "MSU1 present" flag
			beq	+
			stz	MSU_CONTROL				; stop ambient soundtrack
		+
		.ENDIF

		jmp	DebugMenu
	.ENDIF



UpdateAreaSprites:
	lda	<DP2.Hero1SpriteStatus
	bpl	@Hero1IsWalking						; bit 7 set = idle
	stz	<DP2.Hero1FrameCounter					; char is idle, reset frame counter

	Accu16

	lda	#k16_Hero1_frame00
	bra	@Hero1WalkingDone

	.ACCU 8

@Hero1IsWalking:
	lda	<DP2.Hero1FrameCounter					; 0-9: frame 1, 10-19: frame 0, 20-29: frame 2, 30-39: frame 0
	cmp	#40
	bcc	+
	stz	<DP2.Hero1FrameCounter					; reset frame counter
	bra	@Hero1Frame1

+	cmp	#30
	bcs	@Hero1Frame0
	cmp	#20
	bcs	@Hero1Frame2
	cmp	#10
	bcc	@Hero1Frame1

@Hero1Frame0:
	Accu16

	lda	#k16_Hero1_frame00
	bra	@Hero1WalkingDone

@Hero1Frame2:
	Accu16

	lda	#k16_Hero1_frame02
	bra	@Hero1WalkingDone

@Hero1Frame1:
	Accu16

	lda	#k16_Hero1_frame01

@Hero1WalkingDone:
	ora	#$2200							; add sprite priority, use palette no. 1
	clc
	adc	#$0080							; skip $80 tiles = sprite font
	sta	RAM.SpriteDataArea.Hero1a+3				; tile no. (upper half of body)
	clc
	adc	#$0020
	sta	RAM.SpriteDataArea.Hero1b+3				; tile no. (lower half of body = upper half + 2 rows of 16 tiles)

	lda	<DP2.Hero1ScreenPosYX

	Accu8

	sta	RAM.SpriteDataArea.Hero1a
	sta	RAM.SpriteDataArea.Hero1b
	xba
	sta	RAM.SpriteDataArea.Hero1a+2
	clc
	adc	#16							; Y += 16 for lower half
	sta	RAM.SpriteDataArea.Hero1b+2

	inc	<DP2.Hero1FrameCounter					; increment animation frame counter

	rts



; **************************** HUD contens *****************************

PutAreaNameIntoHUD:							; HUD "text box" position (DP2.Temp, DP2.Temp+1) and DP2.TextCursor are expected to contain sane values
	lda	#:PTR_AreaNames						; caveat: all area names & pointers should be located in the same bank
	sta	<DP2.TextStringBank
	sta	<DP2.DataBank

	Accu16

	lda	<DP2.GameLanguage					; check for selected language
	and	#$00FF							; mask off garbage bits
	asl	a
	tax
	lda.l	PTR_AreaNames, x					; starting address of area names of a given language into DataAddress
	sta	<DP2.DataAddress
	lda	<DP2.AreaNamePointerNo					; use area name pointer no. ...
;	asl	a
	tay
	lda	[<DP2.DataAddress], y					; ... to read correct pointer
	sta	<DP2.TextStringPtr

	Accu8

@PutTextIntoHUD:
	ldy	#0							; get HUD string length
-	lda	[<DP2.TextStringPtr], y
	beq	+							; NUL terminator reached?
	iny								; increment input pointer
	bra	-

+	tya								; low byte is sufficient
	sta	<DP2.HUD_StrLength					; save value for later scrolling
	stz	<DP2.SpriteTextPalette					; use palette 0
	jsr	PrintSpriteText

	lda	<DP2.HUD_StrLength
	sta	M7A
	stz	M7A
	lda	#6							; HUD_StrLength × 6 (average width of font chars)
	sta	M7B
	lda	MPYL
	lsr	a							; divide result by 16 for loop index as each text box frame tile is 16 px wide
	lsr	a
	lsr	a
	lsr	a
	tay
	sta	<DP2.HUD_TextBoxSize					; save value (reused later for scrolling)
	ldx	#0
	lda	<DP2.Temp						; X
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	clc
	adc	#16							; X += 16
	sta	<DP2.Temp
	inx
	lda	#%00000010						; set sprite size = large
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx		
	lda	<DP2.Temp+1						; Y
	sta	<DP2.HUD_Ypos						; save to var for scrolling
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	lda	#2							; tile no. of left border
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	lda	#%00110000						; attributes, set highest priority
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	dey

-	lda	<DP2.Temp						; X
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	clc
	adc	#16							; X += 16
	sta	<DP2.Temp
	inx
	lda	#%00000010						; set sprite size = large
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx		
	lda	<DP2.Temp+1						; Y
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	lda	#3							; tile no. of main box
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	lda	#%00110000						; attributes, set highest priority
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	dey
	bne	-

	lda	<DP2.Temp						; X
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	clc
	adc	#16							; X += 16
	sta	<DP2.Temp
	inx
	lda	#%00000010						; set sprite size = large
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx		
	lda	<DP2.Temp+1						; Y
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	lda	#4							; tile no. of right border
	sta	RAM.SpriteDataArea.HUD_TextBox, x
	inx
	lda	#%00110000						; attributes, set highest priority
	sta	RAM.SpriteDataArea.HUD_TextBox, x

	rts



; ************************ Collision detection *************************

MakeCollIndexUp:

; Create collision index for left edge of char sprite
	Accu16

	ldy	#0
	lda	<DP2.Hero1MapPosX					; MapPosX/Y references the upper leftmost sprite pixel
	clc								; acknowledge left collision margin
	adc	#kCollMarginLeft
-	cmp	#16							; value still >=16?
	bcc	+
	sec								; no, subtract 16 from value (each meta map entry represents 2×2 tiles, or 16×16 px)
	sbc	#16
	iny								; add 1 to collision index per 16 pixels subtracted
	bra	-

+	sty	<DP2.AreaMetaMapIndex					; save interim result (horizontal position in meta map)
	ldy	#0
	lda	<DP2.Hero1MapPosY
	clc								; add 1 row (w/o top margin) --> check character's lower 16×16 sprite (upper half of body is unaffected)
	adc	#16-kCollMarginTop
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
	sta	<DP2.AreaMetaMapIndex2					; save interim result (vertical position in meta map) so we won't need to calculate this part again
	clc
	adc	<DP2.AreaMetaMapIndex
	sta	<DP2.AreaMetaMapIndex					; save final index value for left edge



; Create collision index for right edge of char sprite
	ldy	#0
	lda	<DP2.Hero1MapPosX
	clc								; go to right edge, acknowledge right collision margin
	adc	#16-kCollMarginRight
-	cmp	#16							; same thing as above
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	tya
	clc
	adc	<DP2.AreaMetaMapIndex2
	sta	<DP2.AreaMetaMapIndex2					; save final index value for right edge

	Accu8

	rts



MakeCollIndexDown:



; Create collision index for left edge of char sprite
	Accu16

	ldy	#0
	lda	<DP2.Hero1MapPosX
	clc								; acknowledge left collision margin
	adc	#kCollMarginLeft
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	sty	<DP2.AreaMetaMapIndex
	ldy	#0
	lda	<DP2.Hero1MapPosY
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
	sta	<DP2.AreaMetaMapIndex2					; save interim result for later
	clc
	adc	<DP2.AreaMetaMapIndex
	sta	<DP2.AreaMetaMapIndex



; Create collision index for right edge of char sprite
	ldy	#0
	lda	<DP2.Hero1MapPosX
	clc								; go to right edge, acknowledge right collision margin
	adc	#16-kCollMarginRight
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	tya
	clc
	adc	<DP2.AreaMetaMapIndex2
	sta	<DP2.AreaMetaMapIndex2

	Accu8

	rts



MakeCollIndexLeft:



; Create collision index for upper corner of lower char sprite
	Accu16

	ldy	#0
	lda	<DP2.Hero1MapPosX
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	sty	<DP2.AreaMetaMapIndex
	sty	<DP2.AreaMetaMapIndex2					; save interim result for later
	ldy	#0
	lda	<DP2.Hero1MapPosY
	clc								; add 1 row for lower char sprite
	adc	#16+kCollMarginTop
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
	adc	<DP2.AreaMetaMapIndex
	sta	<DP2.AreaMetaMapIndex



; Create collision index for lower corner of lower char sprite
	ldy	#0
	lda	<DP2.Hero1MapPosY
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
	adc	<DP2.AreaMetaMapIndex2
	sta	<DP2.AreaMetaMapIndex2

	Accu8

	rts



MakeCollIndexRight:



; Create collision index for upper corner of lower char sprite
	Accu16

	ldy	#0
	lda	<DP2.Hero1MapPosX
	clc								; go to right edge
	adc	#16
-	cmp	#16
	bcc	+
	sec
	sbc	#16
	iny
	bra	-

+	sty	<DP2.AreaMetaMapIndex
	sty	<DP2.AreaMetaMapIndex2					; save interim result for later
	ldy	#0
	lda	<DP2.Hero1MapPosY
	clc								; add 1 row for lower char sprite
	adc	#16+kCollMarginTop
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
	adc	<DP2.AreaMetaMapIndex
	sta	<DP2.AreaMetaMapIndex



; Create collision index for lower corner of lower char sprite
	ldy	#0
	lda	<DP2.Hero1MapPosY
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
	adc	<DP2.AreaMetaMapIndex2
	sta	<DP2.AreaMetaMapIndex2

	Accu8

	rts



; ******************************** EOF *********************************
