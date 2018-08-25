;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MAIN MENU ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

.ENDASM

MainMenu:
	DrawFrame	10, 9, 11, 7
	PrintString	10, 11, "Inventory"
	PrintString	11, 11, "Talent"
	PrintString	12, 11, "Formation"
	PrintString	13, 11, "Lily's log"
	PrintString	14, 11, "Settings"
	PrintString	15, 11, "Quit game"



; -------------------------- menu "window" color
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathMenu, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMenu
	bne	-

	lda	#%00010000						; set color math enable bits (4-5) to "MathWindow"
	sta	REG_CGWSEL
	lda	#%00010111						; enable color math on BG1/2/3 + sprites
	sta	REG_CGADSUB
	lda	#86							; color "window" left pos
	sta	REG_WH0
	lda	#169							; color "window" right pos
	sta	REG_WH1
	lda	#%00100000						; color math window 1 area = outside (why does this work??)
	sta	REG_WOBJSEL
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	DP_HDMA_Channels

	Accu16

	lda	#%0001000000000111					; mainscreen : BG1/2/3, subscreen : sprites (i.e., sprites will disappear as $2130.1 is clear)
	sta	DP_Shadow_TSTM

	Accu8



MainMenuLoop:
	WaitFrames	1



; -------------------------- check for dpad up
	lda	DP_Joy1New+1
	and	#%00001000
	beq	++
	lda	ARRAY_HDMA_ColorMath+0					; first byte of color math HDMA table = no. of scanlines above color bar
	cmp	#80
	beq	+
	sec
	sbc	#8
	sta	ARRAY_HDMA_ColorMath+0
	bra	++

+	lda	#120
	sta	ARRAY_HDMA_ColorMath+0

++



; -------------------------- check for dpad down
	lda	DP_Joy1New+1
	and	#%00000100
	beq	++
	lda	ARRAY_HDMA_ColorMath+0					; first byte of color math HDMA table = no. of scanlines above color bar
	cmp	#120
	beq	+
	clc
	adc	#8
	sta	ARRAY_HDMA_ColorMath+0
	bra	++

+	lda	#80
	sta	ARRAY_HDMA_ColorMath+0

++



; -------------------------- check for A button
	lda	DP_Joy1New
	and	#%10000000
	beq	++
	lda	#%00000100						; mosaic on BG3
-	sta	REG_MOSAIC
	wai
	clc
	adc	#$10
	cmp	#$64
	bne	-

-	sta	REG_MOSAIC
	wai
	sec
	sbc	#$10
	cmp	#$04
	bne	-

	stz	REG_MOSAIC
/*	lda	ARRAY_HDMA_ColorMath+0
	cmp	#80
	bne	+
	ldx	#(ARRAY_BG3TileMap & $FFFF)				; clear text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 1024

	jmp	AreaEnter

+	cmp	#88
	bne	+
	jmp	PartyMenu

+	cmp	#96
	bne	+
	jmp	WorldMode3

+	cmp	#104
	bne	+
	jmp	TestMode7

+	jmp	MusicTest						; else, selection bar must be on the bottom
*/

++



; -------------------------- check for B button = back
	lda	DP_Joy1New+1
	and	#%10000000
	bne	+
	jmp	++

+	PrintString	9, 10, "             "
	PrintString	10, 10, "             "
	PrintString	11, 10, "             "
	PrintString	12, 10, "             "
	PrintString	13, 10, "             "
	PrintString	14, 10, "             "
	PrintString	15, 10, "             "
	PrintString	16, 10, "             "


	lda	#%00110000						; disable color math
	sta	REG_CGWSEL
	stz	REG_WOBJSEL						; disable color math window
	lda	#%00001000						; disable HDMA channel 3 (color math)
	trb	DP_HDMA_Channels

	Accu16

	lda	#%0001000000010000					; re-enable sprites
	tsb	DP_Shadow_TSTM

	Accu8

	jmp	MainAreaLoop

++



; -------------------------- check for Start
;	lda	DP_Joy1New+1
;	and	#%00010000
;	beq	+

;	WaitUserInput

;+

	jmp	MainMenuLoop

.ASM



; ***************************** Main menu ******************************

InGameMenu:

.IFNDEF NOMUSIC
	jsl	music_stop						; stop music // REMOVEME when done with menu

	lda	DP_GameConfig
	and	#%00000001						; check for "MSU1 present" flag
	beq	+
	stz	MSU_CONTROL						; stop MSU1 track
	stz	MSU_VOLUME
+
.ENDIF

	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP
	stz	DP_HDMA_Channels					; disable HDMA
	wai								; wait

	DisableIRQs



; -------------------------- clear tilemap buffers, init sprites
	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 10240

	lda	#$CC
	sta	DP_EmptySpriteNo
	jsr	SpriteInit



; -------------------------- clear VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, <REG_VMDATAL, 0	; clear VRAM



; -------------------------- load menu GFX
	ldx	#ADDR_VRAM_BG1_Tiles					; set VRAM address for BG1 tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Logo, GFX_Logo, <REG_VMDATAL, 8000

	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $00, :SRC_Tilemap_Logo, SRC_Tilemap_Logo, <REG_WMDATA, 1024

	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_InGameMenu, GFX_Sprites_InGameMenu, <REG_VMDATAL, 8192

	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Font8x8, GFX_Font8x8, <REG_VMDATAL, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-



; -------------------------- palettes --> CGRAM
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, <REG_CGDATA, 40

	lda	#ADDR_CGRAM_Area					; set CGRAM address for BG1 tiles palette
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Logo, SRC_Palette_Logo, <REG_CGDATA, 32

	lda	#ADDR_CGRAM_Area					; palette no. = CGRAM address RSH 2
	lsr	a
	lsr	a
	ldx	#0
-	sta	ARRAY_BG1TileMap1Hi, x					; store palette no.
	inx
	cpx	#1024
	bne	-

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Sprites_InGameMenu, SRC_Palette_Sprites_InGameMenu, <REG_CGDATA, 32

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated once NMI is reenabled
	tsb	DP_DMA_Updates
	tsb	DP_DMA_Updates+1

	SetNMI	TBL_NMI_DebugMenu

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; reenable NMI & IRQ
	sta	REG_NMITIMEN
	cli

	WaitFrames	5						; wait for tilemaps to get updated



; -------------------------- HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	REG_DMAP3
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	REG_BBAD3
	ldx	#ARRAY_HDMA_ColorMath
	stx	REG_A1T3L
	lda	#$7E							; table in WRAM expected
	sta	REG_A1B3



; -------------------------- set up menu BG color & misc. PPU (shadow) registers
	ldx	#0
-	lda.l	SRC_HDMA_ColMathMainMenu, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMainMenu
	bne	-

	lda	#$01|$08						; set BG Mode 1 (BG3 priority)
	sta	VAR_ShadowBGMODE
	lda	#%01100011						; 16×16 (small) / 32×32 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	VAR_ShadowOBSEL
	lda	#$50|$01						; BG1 tile map VRAM offset: $5000, Tile Map size: 64×32 tiles
	sta	VAR_ShadowBG1SC
	lda	#$58|$01						; BG2 tile map VRAM offset: $5800, Tile Map size: 64×32 tiles
	sta	VAR_ShadowBG2SC
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	VAR_ShadowBG3SC
	lda	#$00							; BG1/BG2 character data VRAM offset: $0000
	sta	VAR_ShadowBG12NBA
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	VAR_ShadowBG34NBA
	stz	REG_BG1HOFS						; reset BG1 horizontal scroll
	stz	REG_BG1HOFS
	lda	#$FF							; set BG1 vertical scroll = -1
	sta	REG_BG1VOFS
	stz	REG_BG1VOFS
	stz	REG_BG2HOFS						; reset BG2 horizontal scroll
	stz	REG_BG2HOFS
	sta	REG_BG2VOFS						; set BG2 vertical scroll = -1
	stz	REG_BG2VOFS
	stz	REG_BG3HOFS						; reset BG3 horizontal scroll
	stz	REG_BG3HOFS
	sta	REG_BG3VOFS						; set BG3 vertical scroll = -1
	stz	REG_BG3VOFS
	lda	#$00							; clear color math disable bits
	sta	VAR_ShadowCGWSEL
	lda	#%00100001						; enable color math on BG1 + backdrop
	sta	VAR_ShadowCGADSUB
	lda	#%00010111						; turn on BG1/2/3 and sprites on mainscreen and subscreen
	sta	VAR_ShadowTM
	sta	VAR_ShadowTS
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	DP_HDMA_Channels



; -------------------------- prepare ring menu item sprites
	lda	#$00							; tile num ("Inventory" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem0+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem0+4

	lda	#$04							; tile num ("Talent" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem1+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem1+4

	lda	#$08							; tile num ("Party" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem2+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem2+4

	lda	#$0C							; tile num ("Lily's log" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem3+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem3+4

	lda	#$40							; tile num ("Settings" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem4+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem4+4

	lda	#$44							; tile num ("Quit Game" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem5+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem5+4

	lda	#$48							; tile num (1st "??" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem6+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem6+4

	lda	#$4C							; tile num (2nd "??" sprite)
	sta	ARRAY_SpriteDataMenu.RingItem7+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingItem7+4

	lda	#$0F							; turn on screen
	sta	VAR_ShadowINIDISP

	lda	#$80							; set angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	DP_RingMenuAngle
	stz	DP_RingMenuAngle+1
	lda	#PARAM_RingMenuRadiusMin
	sta	DP_RingMenuRadius

@RingMenuOpenAnimation:
	jsr	PutRingMenuItems

	wai
	lda	DP_RingMenuAngle
	sec
	sbc	#8
	sta	DP_RingMenuAngle
	lda	DP_RingMenuRadius					; 32 frames for moving sprites from RadiusMin (0) to RadiusMax (60)
	clc
	adc	#2
	sta	DP_RingMenuRadius
	cmp	#64
	bcc	@RingMenuOpenAnimation

	lda	#PARAM_RingMenuRadiusMax
	sta	DP_RingMenuRadius
	jsr	PutRingMenuItems



; -------------------------- ring menu cursor sprite
	lda	#PARAM_RingMenuCenterX-16				; X (subtract half of sprite width)
	sta	ARRAY_SpriteDataMenu.RingCursor
	lda	#%00000010						; X (upper 1 bit), sprite size (large)
	sta	ARRAY_SpriteDataMenu.RingCursor+1
	lda	#PARAM_RingMenuCenterY-PARAM_RingMenuRadiusMax		; Y (subtract radius to place the cursor at the top of the menu)
	sta	ARRAY_SpriteDataMenu.RingCursor+2
	lda	#$80							; tile num (cursor sprite)
	sta	ARRAY_SpriteDataMenu.RingCursor+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteDataMenu.RingCursor+4
	ldx	#ARRAY_SpriteDataMenu & $FFFF				; set WRAM address for menu sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	DrawFrame	7, 1, 17, 2

	stz	DP_LoopCounter



RingMenuLoop:
	wai



; -------------------------- check for dpad left
	lda	DP_Joy1Press+1
	and	#%00000010
	beq	@DpadLeftDone

	ldy	#$0020							; change angle 32 times
-	wai
	dec	DP_RingMenuAngle					; dec angle --> rotate clockwise
	dec	DP_RingMenuAngle
	jsr	PutRingMenuItems

	dey
	dey
	bne	-

@DpadLeftDone:



; -------------------------- check for dpad right
	lda	DP_Joy1Press+1
	and	#%00000001
	beq	@DpadRightDone

	ldy	#$0020
-	wai
	inc	DP_RingMenuAngle					; inc angle --> rotate counter-clockwise
	inc	DP_RingMenuAngle
	jsr	PutRingMenuItems

	dey
	dey
	bne	-

@DpadRightDone:



; -------------------------- update headline based on angle
	SetTextPos	2, 8

	lda	DP_RingMenuAngle					; angle $00, $20 ... $C0, $E0
	lsr	a							; shift into lower nibble
	lsr	a
	lsr	a
	lsr	a

	Accu16

	and	#$00FF							; remove garbage in B
	tax
	lda.l	PTR_RingMenuHeadEng, x					; x = pointer no.
	sta	DP_TextStringPtr

	Accu8

	lda	#:PTR_RingMenuHeadEng					; assume English
	clc
	adc	DP_TextLanguage						; add language constant for correct bank/language
	sta	DP_TextStringBank
	jsr	SimplePrintF

	lda	#%00010000						; make sure BG3 lo tile map gets updated
	tsb	DP_DMA_Updates



; -------------------------- check for A button = make selection
	lda	DP_Joy1New
	bpl	@AButtonDone
	lda	DP_RingMenuAngle					; make selection based on ring menu angle
	lsr	a							; shift into lower nibble
	lsr	a
	lsr	a
	lsr	a

	Accu16

	and #$000F							; remove garbage in high byte
	tax

	Accu8

	sta	DP_SubMenuNext
	jmp	(@PTR_MainMenuSelection, x)

@PTR_MainMenuSelection:
	.DW GotoSettings
	.DW GotoQuitGame
	.DW Goto???1
	.DW Goto???2
	.DW GotoInventory
	.DW GotoTalent
	.DW GotoParty
	.DW GotoLilysLog

@AButtonDone:

	inc	DP_LoopCounter
	lda	DP_LoopCounter
	cmp	#30
	bcc	@CursorBlinkingDone
	lda	ARRAY_SpriteDataMenu.RingCursor+3
	cmp	#$80
	bne	+
	lda	#$CC
	bra	++

+	lda	#$80
++	sta	ARRAY_SpriteDataMenu.RingCursor+3
	stz	DP_LoopCounter
	ldx	#ARRAY_SpriteDataMenu & $FFFF				; set WRAM address for menu sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

@CursorBlinkingDone:
	jmp	RingMenuLoop



PutRingMenuItems:
	lda	DP_RingMenuAngle					; take angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem0 & $FFFF			; set WRAM address for 1st item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 2nd item on ring menu ($60 = 1:30 o'clock)
	sec
	sbc	#$20
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem1 & $FFFF			; set WRAM address for 2nd item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 3rd item on ring menu ($40 = 3:00 o'clock)
	sec
	sbc	#$40
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem2 & $FFFF			; set WRAM address for 3rd item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 4th item on ring menu ($20 = 4:30 o'clock)
	sec
	sbc	#$60
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem3 & $FFFF			; set WRAM address for 4th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 5th item on ring menu ($00 = 6:00 o'clock)
	sec
	sbc	#$80
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem4 & $FFFF			; set WRAM address for 5th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 6th item on ring menu ($E0 = 7:30 o'clock)
	clc
	adc	#$60
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem5 & $FFFF			; set WRAM address for 6th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 7th item on ring menu ($C0 = 9:00 o'clock)
	clc
	adc	#$40
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem6 & $FFFF			; set WRAM address for 7th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	lda	DP_RingMenuAngle					; set angle for 8th item on ring menu ($A0 = 10:30 o'clock)
	clc
	adc	#$20
	sta	DP_RingMenuAngleOffset
	ldx	#ARRAY_SpriteDataMenu.RingItem7 & $FFFF			; set WRAM address for 8th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingItemPos

	ldx	#ARRAY_SpriteDataMenu & $FFFF				; set WRAM address for menu sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	rts



CalcRingItemPos:

; X := CenterX + sin(angle)*radius
; Y := CenterY + cos(angle)*radius

	ldx	DP_RingMenuAngleOffset
	lda.l	SRC_Mode7Sin, x
	stz	REG_M7A
	sta	REG_M7A
	lda	DP_RingMenuRadius
	asl 	a							; not sure why this is needed (sin(angle)*radius*2 ??)
	sta	REG_M7B
	lda	REG_MPYH
	clc
	adc	#PARAM_RingMenuCenterX-16				; add CenterX, subtract half of sprite width (as with the cursor sprite)
	sta	REG_WMDATA						; save X (lower 8 bits)
	lda	#%00000010
	sta	REG_WMDATA						; save X (upper 1 bit), sprite size (large)
	ldx	DP_RingMenuAngleOffset
	lda.l	SRC_Mode7Cos, x
	stz	REG_M7A
	sta	REG_M7A
	lda	DP_RingMenuRadius
	asl 	a							; not sure why this is needed (cos(angle)*radius*2 ??)
	sta	REG_M7B
	lda	REG_MPYH
	clc
	adc	#PARAM_RingMenuCenterY					; add CenterY
	sta	REG_WMDATA						; save Y
	rts



; ************************ Sub menu: Inventory *************************

GotoQuitGame:
;	jsr	RingMenuCloseAnimation

Goto???1:
;	jsr	RingMenuCloseAnimation

Goto???2:
;	jsr	RingMenuCloseAnimation

GotoTalent:
;	jsr	RingMenuCloseAnimation

GotoParty:
;	jsr	RingMenuCloseAnimation

GotoLilysLog:
;	jsr	RingMenuCloseAnimation

GotoSettings:
;	jsr	RingMenuCloseAnimation

GotoInventory:
	jsr	RingMenuCloseAnimation



RingMenuCloseAnimation:
	Accu16

	lda	#$00FF							; hide cursor
	sta	ARRAY_SpriteDataMenu.RingCursor

	Accu8

	lda	#$E0
	sta	ARRAY_SpriteDataMenu.RingCursor+2

	Accu16

	lda	#$00CC							; $CC = empty 16×16 sprite
	sta	ARRAY_SpriteDataMenu.RingCursor+3

	Accu8

-	lda	DP_RingMenuAngle					; opening animation reversed
	clc
	adc	#8
	sta	DP_RingMenuAngle
	lda	DP_RingMenuRadius					; 32 frames for moving sprites from RadiusMax (60) to RadiusMin (0)
	cmp	#PARAM_RingMenuRadiusMin
	beq	+
	sec
	sbc	#2
	sta	DP_RingMenuRadius					; last value = 0
	jsr	PutRingMenuItems

	wai
	bra	-



; -------------------------- remove all ring menu sprites except the selected one
+	lda	DP_SubMenuNext						; $00, $02, $04 ... $0E
	lsr	a							; table has byte entries --> $00, $01, $02 ... $07

	Accu16

	and	#$00FF							; remove garbage in high byte
	tax

	Accu8

	lda.l	SRC_RingItemToKeep, x					; read which ring menu item sprite to keep
	sta	DP_Temp+4
	stz	DP_Temp+5
	ldx	#0
-	cpx	DP_Temp+4
	bne	+
	inx								; skip the selected sprite
	inx
	inx
	inx
	inx
	bra	++							; jump out in case it's the very last one

+	Accu16

	lda	#$00FF							; put sprites off-screen: X coordinate, sprite size
	sta	ARRAY_SpriteDataMenu.RingItem0, x			; clear out all other ring menu sprites
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	ARRAY_SpriteDataMenu.RingItem0, x
	inx

	Accu16

	lda	#$00CC							; $CC = empty 16×16 sprite
	sta	ARRAY_SpriteDataMenu.RingItem0, x
	inx
	inx
++	cpx	#40							; all 8 ring menu item sprites done?
	bne	-

	Accu8

TestLoop:
	wai

	ldx	DP_Temp+4

	lda	DP_Joy1Press+1 ; up
	and	#%00001000
	beq	+
	lda	ARRAY_SpriteDataMenu.RingItem0+2, x
	dec	a
	sta	ARRAY_SpriteDataMenu.RingItem0+2, x

+	lda	DP_Joy1Press+1 ; down
	and	#%00000100
	beq	+
	lda	ARRAY_SpriteDataMenu.RingItem0+2, x
	inc	a
	sta	ARRAY_SpriteDataMenu.RingItem0+2, x

+	lda	DP_Joy1Press+1 ; left
	and	#%00000010
	beq	+
	lda	ARRAY_SpriteDataMenu.RingItem0, x
	dec	a
	sta	ARRAY_SpriteDataMenu.RingItem0, x

+	lda	DP_Joy1Press+1
	and	#%00000001 ; right
	beq	+
	lda	ARRAY_SpriteDataMenu.RingItem0, x
	inc	a
	sta	ARRAY_SpriteDataMenu.RingItem0, x

+	lda	DP_Joy1New ; A
	bpl	+
	lda	#0
	sta	ARRAY_SpriteDataMenu.RingItem0+1, x ; small spr

+	lda	DP_Joy1New+1 ; B
	bpl	+
	lda	#2
	sta	ARRAY_SpriteDataMenu.RingItem0+1, x ; big spr

+	ldx	#ARRAY_SpriteDataMenu & $FFFF				; set WRAM address for menu sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	bra	TestLoop

	rts

SRC_RingItemToKeep:							; DP_SubMenuNext RSH 1	| RingItemX (each * 5 bytes of sprite attributes)
	.DB 4*5								; 0			| 4
	.DB 5*5								; 1			| 5
	.DB 6*5								; 2			| 6
	.DB 7*5								; 3			| 7
	.DB 0*5								; 4			| 0
	.DB 1*5								; 5			| 1
	.DB 2*5								; 6			| 2
	.DB 3*5								; 7			| 3



	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP
	stz	DP_HDMA_Channels					; disable HDMA
	wai

	DisableIRQs



; -------------------------- clear tilemap buffers, init sprites, load new font/GFX data
	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 1024*9	; clear all tile map buffers (except BG3-hi)

	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG1_Tiles					; set VRAM address for BG1 font tiles
	stx	REG_VMADDL
	jsr	MakeMode5FontBG1

	ldx	#ADDR_VRAM_BG3_Tiles					; set VRAM address for BG2 font tiles (Mode 5 BG2 uses the same char data as Mode 1 BG3)
	stx	REG_VMADDL
	jsr	MakeMode5FontBG2



; -------------------------- palettes --> CGRAM
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, <REG_CGDATA, 32

;	lda	#$80							; set CGRAM address to #256 (word address) for sprites
;	sta	REG_CGADD

;	DMA_CH0 $02, :SRC_Palette_Sprites_InGameMenu, SRC_Palette_Sprites_InGameMenu, <REG_CGDATA, 32



; -------------------------- set up HDMA channel 6 for char data area designation
;	ldx	#SRC_HDMA_BG12CharData
;	stx	REG_A1T6L
;	lda	#:SRC_HDMA_BG12CharData
;	sta	REG_A1B6
;	lda	#$0B							; PPU reg. $210B (BG12NBA)
;	sta	REG_BBAD6
;	lda	#$00							; transfer mode (1 byte)
;	sta	REG_DMAP6



; -------------------------- screen regs, additional parameters
	lda	#$05
	sta	VAR_ShadowBGMODE
	lda	#$40							; BG1/BG2 character data VRAM offset: $0000/$4000 // never mind, HDMA does this
	sta	VAR_ShadowBG12NBA
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	VAR_ShadowBG34NBA
	lda	#%00100000						; enable color math on backdrop only
	sta	VAR_ShadowCGADSUB

;	lda	#%11000000						; enable HDMA channel 6 (BG1/2 char data area designation), 7 (BG Mode 5)
;	tsb	DP_HDMA_Channels

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable NMI and auto-joypad read
	sta	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli

	ldx	#0

	Accu16

	lda	#$0100							; item qty = 1, start with item #0
-	sta	ARRAY_GameDataInventory, x
	inc	a							; increment item no. #
	inx
	inx
	cpx	#32							; 16 items for now
	bne	-

	Accu8
	SetTextPos	2, 2

	ldx	#0

@ReadItemFromInventory:
	lda	ARRAY_GameDataInventory, x
	xba
	inx
	lda	ARRAY_GameDataInventory, x
	bne	+
	inx
	cpx	#512
	beq	@ReadItemFromInventoryDone
	bra	@ReadItemFromInventory

+	sta	VAR_GameDataItemQty
	xba

	Accu16

	and	#$00FF							; remove garbage in B
	asl	a
	asl	a
	asl	a
	asl	a
	clc
	adc	#STR_ItemsEng
	sta	DP_TextStringPtr

	Accu8

	lda	#:STR_ItemsEng
	sta	DP_TextStringBank
	inx
	cpx	#512
	beq	@ReadItemFromInventoryDone
	phx

@RenderItem:
	lda	#16
	sta	DP_HiResPrintLen
	jsr	PrintHiResFixedLenFWF

	Accu16

	lda	DP_TextCursor
	clc
	adc	#24
	sta	DP_TextCursor

	Accu8

	plx
	bra	@ReadItemFromInventory

@ReadItemFromInventoryDone:

/*	SetTextPos	2, 16

	ldx	#STR_MainMenuEng000
	stx	DP_TextStringPtr
	lda	#:STR_MainMenuEng000
	sta	DP_TextStringBank

	ldy	#0
-	lda	[DP_TextStringPtr], y
	beq	+
	asl	a							; double char no. because font tiles were "expanded" for hi-res mode
	inc	a							; increment char no. because Mode 5 BG2 font tiles sit on the "right"
	jsr	FillTextBuffer

	iny
	bra	-
+
*/
	lda	#%00011111						; make sure BG1-3 lo and BG1/2 hi tilemaps get updated
	tsb	DP_DMA_Updates
	and	#%00001111
	tsb	DP_DMA_Updates+1
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	DP_HDMA_Channels

	WaitFrames	4

	lda	#$0F							; turn screen back on
	sta	VAR_ShadowINIDISP

	Freeze



; **********************************************************************



.ENDASM

LoadMenuCharPortraits:
	ldx	#$01C0
	lda	#$02
-	sta	ARRAY_BG1TileMap1, x
	inx
	inc	a
	inc	a
	cmp	#$0C
	bne	-

	ldx	#$01E0
	lda	#$12
-	sta	ARRAY_BG1TileMap1, x
	inx
	inc	a
	inc	a
	cmp	#$1C
	bne	-

	ldx	#$0200
	lda	#$22
-	sta	ARRAY_BG1TileMap1, x
	inx
	inc	a
	inc	a
	cmp	#$2C
	bne	-

	ldx	#$0220
	lda	#$32
-	sta	ARRAY_BG1TileMap1, x
	inx
	inc	a
	inc	a
	cmp	#$3C
	bne	-

	ldx	#$0240
	lda	#$42
-	sta	ARRAY_BG1TileMap1, x
	inx
	inc	a
	inc	a
	cmp	#$4C
	bne	-

	ldx	#$0260
	lda	#$52
-	sta	ARRAY_BG1TileMap1, x
	inx
	inc	a
	inc	a
	cmp	#$5C
	bne	-

	rts

.ASM



; ******************************** EOF *********************************
