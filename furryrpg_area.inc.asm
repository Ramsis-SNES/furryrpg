;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** AREA HANDLER ***
;
;==========================================================================================



AreaEnter:
	lda	#$80							; INIDISP (Display Control 1): forced blank
	sta	$2100

	jsr	SpriteInit

	DisableInterrupts

	stz	DP_HDMAchannels						; disable HDMA
	stz	$420C

	lda	#$80							; VRAM address increment mode: increment address by one word after accessing the high byte ($2119)
	sta	$2115

	jsr	LoadTextBoxBorderTiles					; prepare some stuff for text box
	jsr	MakeTextBoxTilemapBG1
	jsr	MakeTextBoxTilemapBG2



; -------------------------- area data --> VRAM/WRAM
	ldx	#ADDR_VRAM_AreaBG1
	stx	$2116

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

-	A16

	lda.l	SRC_Tilemap_Area003, x
	dec	a							; make up for empty tile skipped in pic data
	clc								; add offset (font, portrait)
	adc	#(ADDR_VRAM_AreaBG1 >> 4)				; 172 tiles

	A8

	sta	[temp], y
	xba
	sta	[temp+3], y
	inx
	inx
	iny
	cpy	#1024
	bne	-

	ldx	#ADDR_VRAM_BG1_Tilemap2					; FIXME, add tilemap buffer for BG1/2 second tilemaps
	stx	$2116

	ldx	#2048

-	A16

	lda.l	SRC_Tilemap_Area003, x
	dec	a
	clc								; add offset
	adc	#(ADDR_VRAM_AreaBG1 >> 4)

	A8

	sta	$2118
	xba
	sta	$2119
	inx
	inx
	cpx	#4096
	bne	-



; -------------------------- HUD font --> VRAM
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	$2116

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	TileMapBG3Hi, x						; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- palettes --> CGRAM
	stz	$2121							; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda	#ADDR_CGRAM_AREA					; set CGRAM address for BG1 tiles palette
	sta	$2121

;	DMA_CH0 $02, :SRC_Palette_Area001, SRC_Palette_Area001, $22, 32
	DMA_CH0 $02, :SRC_Palette_Area003, SRC_Palette_Area003, $22, 32

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Spritesheet_Char1, SRC_Palette_Spritesheet_Char1, $22, 32



; -------------------------- HDMA tables --> WRAM
	A16

	ldx	#0
-	lda.l	SRC_HDMA_ResetBGScroll, x
	sta	ARRAY_HDMA_BGScroll, x
	inx
	inx
	cpx	#16
	bne	-

	A8



; -------------------------- HDMA channel 4: BG1 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210D, 2 bytes --> $210E)
	sta	$4340
	lda	#$0D							; PPU reg. $210D
	sta	$4341
	ldx	#ARRAY_HDMA_BGScroll
	stx	$4342
	lda	#$7E
	sta	$4344
;	lda	#$7E							; indirect HDMA CPU bus data address bank
;	sta	$4347



; -------------------------- HDMA channel 5: BG2 scroll registers
	lda	#$07							; transfer mode (2 bytes --> $210F, 2 bytes --> $2110)
	sta	$4350
	lda	#$0F							; PPU reg. $210F
	sta	$4351
	ldx	#ARRAY_HDMA_BGScroll
	stx	$4352
	lda	#$7E
	sta	$4354
;	lda	#$7E							; indirect HDMA CPU bus data address bank
;	sta	$4357



; -------------------------- screen registers
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	$2101
;	lda	#$03							; set BG Mode 3
;	sta	$2105
	lda	#$50|$01						; BG1 tile map VRAM offset: $5000, Tile Map size: 64×32 tiles
	sta	$2107
	lda	#$58|$01						; BG2 tile map VRAM offset: $5800, Tile Map size: 64×32 tiles
	sta	$2108
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	$2109
;	lda	#$00							; BG1/BG2 character data VRAM offset: $0000
	stz	$210B
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	$210C
;	lda	#$09							; interlace test
;	sta	$2133



; -------------------------- character, Vblank, and effect parameters
	A16

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

	A8

	SetVblankRoutine TBL_NMI_Area

	A16

	lda	#210							; dot number for interrupt (256 = too late, 204 = too early)
	sta	$4207
	lda	#176							; scanline number for interrupt: 176 (i.e., let IRQ fire in Hblank between scanlines 176 and 177)
	sta	$4209

	A8

	SetIRQRoutine TBL_VIRQ_Area

;	lda	#%00110000						; activate HDMA ch. 4, 5 (BG scroll reset)
;	tsb	DP_HDMAchannels

	lda	#$80							; make character idle
	sta	DP_Char1SpriteStatus

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable Vblank NMI + Auto Joypad Read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli								; re-enable interrupts

;	PrintString 1, 2, "Gengen"
;	PrintString 2, 2, "HP: 9999"
;	PrintString 3, 2, "EP: 0000"
	PrintString 23, 17, "-Green Greens-"
;	PrintString 2, 19, "Time:"

;	PrintString 14, 13, "M7H/X="
;	PrintHexNum DP_Mode7_ScrollOffsetX+1
;	PrintHexNum DP_Mode7_ScrollOffsetX
;	PrintString 15, 13, "M7V/Y="
;	PrintHexNum DP_Mode7_ScrollOffsetY+1
;	PrintHexNum DP_Mode7_ScrollOffsetY

	lda	#%01110111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates

	WaitForFrames 4							; let the screen clear up

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



; NIGHT
;	A16
;	lda	#%0000000000010111					; turn on BG1/2/3 + sprites on mainscreen only
;	sta	DP_Shadow_TSTM
;	A8

;	lda	#$72							; subscreen backdrop color to subtract
;	sta	$2132
;	stz	$2130							; clear CM disable bits
;	lda	#%10010011						; enable color math on BG1/2 + sprites, subtract color
;	sta	$2131

;	jmp	Forever



.ENDASM

; NIGHT W/ SPRITES, XORed palette req.
	lda	#$80
	sta	$2100

	lda	#ADDR_CGRAM_AREA					; set CGRAM address for BG1 tiles palette
	sta	$2121

	ldx	#0
-	lda.l	SRC_Palette_Area001, x
	eor	#$FF
	sta	$2122
	inx
	cpx	#32
	bne	-

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	$2121

	ldx	#0
-	lda.l	SRC_Palette_Spritesheet_Char1, x
	eor	#$FF
	sta	$2122
	inx
	cpx	#32
	bne	-

	A16
	lda	#%0001001100000100					; turn on BG1/2 + sprites on subscreen, BG3 (HUD) on mainscreen
	sta	DP_Shadow_TSTM
	A8

	stz	$2121							; backdrop color to subtract
	lda	#$52
	sta	$2122
	lda	#$1E
	sta	$2122
	lda	#%00000010						; clear CM disable bits, enable BGs/OBJs on subscreen
	sta	$2130
	lda	#%10100000						; enable color math on backdrop, subtract color
	sta	$2131

	lda	#$0F
	sta	$2100

	jmp	Forever

.ASM



; EFFECT
;	lda	#%00000010						; clear color math disable bits (4-5), enable BGs/OBJs on subscreen
;	sta	$2130
;	lda	#%00100000						; enable color math on backdrop only
;	sta	$2131

;	stz	$2121							; set backdrop color to overlay the whole image
;	stz	$2122							; $6C00 = bright blue
;	lda	#$6C
;	sta	$2122

;	A16
;	lda	#%0001001100000100					; mainscreen: BG3 (HUD), subscreen: BG1/2, sprites
;	sta	DP_Shadow_TSTM
;	A8



; -------------------------- reset language/text parameters
	lda	#TBL_Lang_Eng
	sta	DP_TextLanguage

	A16
	stz	DP_TextPointerNo
	A8



MainAreaLoop:
	WaitForFrames 1							; don't use WAI here as IRQ might be enabled!

;	lda	DP_Shadow_NMITIMEN
;	sta	REG_NMITIMEN

;	SetTextPos 2, 25
;	PrintHexNum DP_GameTime_Hours
;	PrintString 2, 27, ":"
;	PrintHexNum DP_GameTime_Minutes

.IFDEF DEBUG
;	PrintString 2, 26, "X="
;	PrintHexNum DP_Char1PosYX
;	PrintString 3, 26, "Y="
;	PrintHexNum DP_Char1PosYX+1

	PrintString 2, 22, "ScrX="
	PrintHexNum ARRAY_HDMA_BGScroll+2
	PrintHexNum ARRAY_HDMA_BGScroll+1

	PrintString 3, 22, "ScrY="
	PrintHexNum ARRAY_HDMA_BGScroll+4
	PrintHexNum ARRAY_HDMA_BGScroll+3

	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates
.ENDIF



; -------------------------- check for B button = run :-)
	lda	Joy1Press+1
	and	#%10000000
	beq	+
	lda	#2							; B pressed, set fast walking speed
	bra	++

+	lda	#1							; B released, set slow walking speed
++	sta	DP_Char1WalkingSpd



; -------------------------- check for Y button = open menu
;	lda	Joy1Press+1
;	and	#%01000000
;	beq	__MainAreaLoopYButtonDone

;	jmp	MainMenu

;__MainAreaLoopYButtonDone:



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

	lda	#TBL_Char1_up
	sta	DP_Char1SpriteStatus

/*	A16
	lda	DP_Char1WalkingSpd
	xba								; shift to high byte for Y value
	eor	#$FFFF							; make negative
	inc	a
	clc
	adc	DP_Char1PosYX						; Y = Y - DP_Char1WalkingSpd (add negative value)
	sta	DP_Char1PosYX
	A8

	lda	DP_Char1PosYX+1						; check for walking area border
	cmp	#$B1
	bcc	__MainAreaLoopDpadUpDone

	stz	DP_Char1PosYX+1
*/

	A16
	lda	ARRAY_HDMA_BGScroll+3
	dec	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+3
	A8

__MainAreaLoopDpadUpDone:



; -------------------------- check for dpad down
	lda	Joy1Press+1
	and	#%00000100
	beq	__MainAreaLoopDpadDownDone

	lda	#TBL_Char1_down
	sta	DP_Char1SpriteStatus

/*	A16
	lda	DP_Char1WalkingSpd
	xba								; shift to high byte for Y value
	clc
	adc	DP_Char1PosYX						; Y += DP_Char1WalkingSpd
	sta	DP_Char1PosYX
	A8

	lda	DP_Char1PosYX+1						; check for walking area border
	cmp	#$B1
	bcc	__MainAreaLoopDpadDownDone

	lda	#$B0
	sta	DP_Char1PosYX+1
*/

	A16
	lda	ARRAY_HDMA_BGScroll+3
	inc	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+3
	A8

__MainAreaLoopDpadDownDone:



; -------------------------- check for dpad left
	lda	Joy1Press+1
	and	#%00000010
	beq	__MainAreaLoopDpadLeftDone

	lda	#TBL_Char1_left
	sta	DP_Char1SpriteStatus

/*	A16
	lda	DP_Char1PosYX
	sec
	sbc	DP_Char1WalkingSpd					; X = X - DP_Char1WalkingSpd
	sta	DP_Char1PosYX
	A8

	lda	DP_Char1PosYX						; check for walking area border
	cmp	#$10
	bcs	__MainAreaLoopDpadLeftDone

	lda	#$10
	sta	DP_Char1PosYX
*/

	A16
	lda	ARRAY_HDMA_BGScroll+1
	dec	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+1
	A8

__MainAreaLoopDpadLeftDone:



; -------------------------- check for dpad right
	lda	Joy1Press+1
	and	#%00000001
	beq	__MainAreaLoopDpadRightDone

	lda	#TBL_Char1_right
	sta	DP_Char1SpriteStatus

/*	A16
	lda	DP_Char1PosYX
	clc
	adc	DP_Char1WalkingSpd					; X += DP_Char1WalkingSpd
	sta	DP_Char1PosYX
	A8

	lda	DP_Char1PosYX						; check for walking area border
	cmp	#$E1
	bcc	__MainAreaLoopDpadRightDone

	lda	#$E0
	sta	DP_Char1PosYX
*/

	A16
	lda	ARRAY_HDMA_BGScroll+1
	inc	a
	and	#$3FFF
	sta	ARRAY_HDMA_BGScroll+1
	A8

__MainAreaLoopDpadRightDone:



; -------------------------- check for A button = open text box
	lda	Joy1New
	and	#%10000000
	beq	__MainAreaLoopAButtonDone

	lda	#$80							; make character idle
	tsb	DP_Char1SpriteStatus
	lda	#$03
	sta	DP_TextBoxCharPortrait					; set char portrait #3
	jsr	OpenTextBox

__MainAreaLoopAButtonDone:



; -------------------------- check for X button
	lda	Joy1New
	and	#%01000000
	beq	__MainAreaLoopXButtonDone

	jmp	InGameMenu

__MainAreaLoopXButtonDone:



; -------------------------- check for Start
	lda	Joy1+1
	and	#%00010000
	beq	__MainAreaLoopStButtonDone

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	lda	#%10000000						; set "clear text box" bit
	sta	DP_TextBoxStatus

	lda	#%00110000						; clear IRQ enable bits
	trb	DP_Shadow_NMITIMEN

	lda	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN

;	lda	#%00110100						; deactivate used HDMA channels
;	trb	DP_HDMAchannels

;	lda	#TBL_Char1_down|$80					; make char face the player (for menu later) // adjust when debug menu is removed
;	sta	DP_Char1SpriteStatus

	WaitForFrames 1

	jmp	DebugMenu

__MainAreaLoopStButtonDone:
	jsr	ShowCPUload
	jmp	MainAreaLoop



; ******************************** EOF *********************************
