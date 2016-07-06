;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** AREA HANDLER ***
;
;==========================================================================================



AreaEnter:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	jsr	SpriteInit						; purge OAM

	DisableIRQs

	stz	DP_HDMAchannels						; disable HDMA
	stz	REG_HDMAEN
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	jsr	LoadTextBoxBorderTiles					; prepare some stuff for text box
	jsr	MakeTextBoxTilemapBG1
	jsr	MakeTextBoxTilemapBG2



; -------------------------- area data --> VRAM/WRAM
	ldx	#ADDR_VRAM_AreaBG1
	stx	REG_VMADDL

;	DMA_CH0 $01, :GFX_Area001, GFX_Area001, $18, 2080
	DMA_CH0 $01, :GFX_Area003, GFX_Area003, $18, 12320

	ldx	#(TileMapBG1 & $FFFF)					; put 24-bit address of BG1 tile maps into temp for upcoming Y indexing
	stx	temp
	ldx	#(TileMapBG1Hi & $FFFF)
	stx	temp+3
	lda	#$7E
	sta	temp+2
	sta	temp+5

	ldx	#0
	ldy	#0

-	Accu16

	lda.l	SRC_Tilemap_Area003, x
	dec	a							; make up for empty tile skipped in pic data
	clc								; add offset (font, portrait)
	adc	#(ADDR_VRAM_AreaBG1 >> 4)				; 172 tiles

	Accu8

	sta	[temp], y
	xba
	sta	[temp+3], y
	inx
	inx
	iny
	cpy	#1024
	bne	-

	ldx	#ADDR_VRAM_BG1_Tilemap2					; FIXME, add tilemap buffer for BG1/2 second tilemaps
	stx	REG_VMADDL

	ldx	#2048

-	Accu16

	lda.l	SRC_Tilemap_Area003, x
	dec	a
	clc								; add offset
	adc	#(ADDR_VRAM_AreaBG1 >> 4)

	Accu8

	sta	REG_VMDATAL
	xba
	sta	REG_VMDATAH
	inx
	inx
	cpx	#4096
	bne	-



; -------------------------- HUD font --> VRAM
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	TileMapBG3Hi, x						; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- palettes --> CGRAM
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda	#ADDR_CGRAM_AREA					; set CGRAM address for BG1 tiles palette
	sta	REG_CGADD

;	DMA_CH0 $02, :SRC_Palette_Area001, SRC_Palette_Area001, $22, 32
	DMA_CH0 $02, :SRC_Palette_Area003, SRC_Palette_Area003, $22, 32

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
	lda	#$50|$01						; BG1 tile map VRAM offset: $5000, Tile Map size: 64×32 tiles
	sta	REG_BG1SC
	lda	#$58|$01						; BG2 tile map VRAM offset: $5800, Tile Map size: 64×32 tiles
	sta	REG_BG2SC
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	REG_BG3SC
;	lda	#$00							; BG1/BG2 character data VRAM offset: $0000
	stz	REG_BG12NBA
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

	lda	#210							; dot number for interrupt (256 = too late, 204 = too early)
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

	lda	#%01110111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates

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
	DrawFrame	5, 1, 21, 2
	PrintString	2, 8, "   Temba Woods    "
	PrintString	23, 1, "Gengen"
	PrintString	24, 1, "HP: XXXX"
	PrintString	24, 20, "Time: XX:XX"



; -------------------------- play music & ambient sound effect
	lda	#10
	sta	DP_NextTrack
	stz	DP_NextTrack+1
	jsl	PlayTrack

	lda	DP_MSU1present
	beq	+

	ldx	#$0001							; MSU1 present, play track #1
	stx	MSU_TRACK
-	bit	MSU_STATUS						; wait for Audio Busy bit to clear
	bvs	-

	lda	#%00000011						; set play, repeat flags
	sta	MSU_CONTROL
	lda	#$FF
	sta	MSU_VOLUME
+



MainAreaLoop:
	WaitFrames	1						; don't use WAI here as IRQ might be enabled!

;	lda	DP_Shadow_NMITIMEN
;	sta	REG_NMITIMEN

	Accu16

	inc	DP_PlayerIdleCounter					; assume player is idle



; -------------------------- HUD display logic
	Accu8

	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	bne	__HUDIsVisible						; yes

	Accu16								; no

	lda	DP_PlayerIdleCounter					; check if player has been idle for at least 300 frames
	cmp	#300
	bcc	__HUDLogicDone

	Accu8

	lda	#%10000000						; yes, set "HUD should appear" bit
	sta	DP_HUD_Status
	bra	__HUDLogicDone

__HUDIsVisible:
	Accu16

	lda	DP_HUD_DispCounter
	inc	a
	cmp	#300
	bcc	+
	bra	__HideHUDOrNot
+	sta	DP_HUD_DispCounter
	bra	__HUDLogicDone

.ACCU 16

__HideHUDOrNot:
	lda	DP_PlayerIdleCounter					; if player is still idle, don't do anything
	cmp	#300
	bcs	__HUDLogicDone

	Accu8

	lda	#%01000000						; otherwise, set "HUD should disappear" bit
	sta	DP_HUD_Status

__HUDLogicDone:
	Accu8



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

	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates
.ENDIF



; -------------------------- update HUD game time
;	PrintString	24, 20, "Time: XX:XX"

	SetTextPos	24, 26
	PrintHexNum	DP_GameTime_Hours
	SetTextPos	24, 29
	PrintHexNum	DP_GameTime_Minutes



; -------------------------- check for B button = run :-)
	lda	Joy1Press+1
	and	#%10000000
	beq	+

	lda	DP_HUD_Status						; check whether HUD is already being displayed
	and	#%00000001
	beq	+
	lda	#%01000000						; yes, set "HUD should disappear" bit
	sta	DP_HUD_Status

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#2							; B pressed, set fast walking speed
	bra	++

+	lda	#1							; B released, set slow walking speed
++	sta	DP_Char1WalkingSpd



; -------------------------- check for Y button = show HUD
	lda	Joy1New+1
	and	#%01000000
	beq	__MainAreaLoopYButtonDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	DP_HUD_Status						; check if HUD is already being displayed
	and	#%00000001
	bne	__MainAreaLoopYButtonDone

	lda	#%10000000						; no, set "HUD should appear" bit
	sta	DP_HUD_Status
	stz	DP_HUD_DispCounter					; and reset "HUD visible" counter
	stz	DP_HUD_DispCounter+1

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

/*	Accu16

	lda	DP_Char1WalkingSpd
	xba								; shift to high byte for Y value
	eor	#$FFFF							; make negative
	inc	a
	clc
	adc	DP_Char1PosYX						; Y = Y - DP_Char1WalkingSpd (add negative value)
	sta	DP_Char1PosYX

	Accu8

	lda	DP_Char1PosYX+1						; check for walking area border
	cmp	#$B1
	bcc	__MainAreaLoopDpadUpDone

	stz	DP_Char1PosYX+1
*/

	Accu16

	lda	ARRAY_HDMA_BGScroll+3
	dec	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+3

	Accu8

__MainAreaLoopDpadUpDone:



; -------------------------- check for dpad down
	lda	Joy1Press+1
	and	#%00000100
	beq	__MainAreaLoopDpadDownDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_down
	sta	DP_Char1SpriteStatus

/*	Accu16

	lda	DP_Char1WalkingSpd
	xba								; shift to high byte for Y value
	clc
	adc	DP_Char1PosYX						; Y += DP_Char1WalkingSpd
	sta	DP_Char1PosYX

	Accu8

	lda	DP_Char1PosYX+1						; check for walking area border
	cmp	#$B1
	bcc	__MainAreaLoopDpadDownDone

	lda	#$B0
	sta	DP_Char1PosYX+1
*/

	Accu16

	lda	ARRAY_HDMA_BGScroll+3
	inc	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+3

	Accu8

__MainAreaLoopDpadDownDone:



; -------------------------- check for dpad left
	lda	Joy1Press+1
	and	#%00000010
	beq	__MainAreaLoopDpadLeftDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_left
	sta	DP_Char1SpriteStatus

/*	Accu16

	lda	DP_Char1PosYX
	sec
	sbc	DP_Char1WalkingSpd					; X = X - DP_Char1WalkingSpd
	sta	DP_Char1PosYX

	Accu8

	lda	DP_Char1PosYX						; check for walking area border
	cmp	#$10
	bcs	__MainAreaLoopDpadLeftDone

	lda	#$10
	sta	DP_Char1PosYX
*/

	Accu16

	lda	ARRAY_HDMA_BGScroll+1
	dec	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+1

	Accu8

__MainAreaLoopDpadLeftDone:



; -------------------------- check for dpad right
	lda	Joy1Press+1
	and	#%00000001
	beq	__MainAreaLoopDpadRightDone

	stz	DP_PlayerIdleCounter
	stz	DP_PlayerIdleCounter+1
	lda	#TBL_Char1_right
	sta	DP_Char1SpriteStatus

/*	Accu16

	lda	DP_Char1PosYX
	clc
	adc	DP_Char1WalkingSpd					; X += DP_Char1WalkingSpd
	sta	DP_Char1PosYX

	Accu8

	lda	DP_Char1PosYX						; check for walking area border
	cmp	#$E1
	bcc	__MainAreaLoopDpadRightDone

	lda	#$E0
	sta	DP_Char1PosYX
*/

	Accu16

	lda	ARRAY_HDMA_BGScroll+1
	inc	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+1

	Accu8

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

	jsl	music_stop						; stop music
	lda	DP_MSU1present
	beq	+
	stz	MSU_CONTROL						; stop ambient soundtrack
+

	jmp	DebugMenu

__MainAreaLoopStButtonDone:
;	jsr	ShowCPUload
	jmp	MainAreaLoop



; ******************************** EOF *********************************
