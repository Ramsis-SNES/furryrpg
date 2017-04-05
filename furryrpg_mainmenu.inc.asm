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
	cpx	#SRC_HDMA_ColMathMenu_End-SRC_HDMA_ColMathMenu
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
	lda	Joy1New+1
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
	lda	Joy1New+1
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
	lda	Joy1New
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

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

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
	lda	Joy1New+1
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
;	lda	Joy1New+1
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

	lda	DP_MSU1_Present
	beq	+
	stz	MSU_CONTROL						; stop MSU1 track
	stz	MSU_VOLUME
+
.ENDIF

	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	stz	DP_HDMA_Channels					; disable HDMA
	wai								; wait

	DisableIRQs



; -------------------------- clear tilemap buffers, init sprites
	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 10240

	jsr	SpriteInit						; FIXME, sprite #0 isn't empty on menu sprites



; -------------------------- clear VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM



; -------------------------- load menu GFX
	ldx	#ADDR_VRAM_BG1_Tiles					; set VRAM address for BG1 tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Logo, GFX_Logo, $18, 8000

	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $00, :SRC_Tilemap_Logo, SRC_Tilemap_Logo, $80, 1024

	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_InGameMenu, GFX_Sprites_InGameMenu, $18, 8192

	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- palettes --> CGRAM
	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 40

	lda	#ADDR_CGRAM_Area					; set CGRAM address for BG1 tiles palette
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Logo, SRC_Palette_Logo, $22, 32

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

	DMA_CH0 $02, :SRC_Palette_Sprites_InGameMenu, SRC_Palette_Sprites_InGameMenu, $22, 32

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
	sta	$4330
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	$4331
	ldx	#ARRAY_HDMA_ColorMath
	stx	$4332
	lda	#$7E							; table in WRAM expected
	sta	$4334



; -------------------------- set up menu BG color & misc. screen registers
	ldx	#0
-	lda.l	SRC_HDMA_ColMathMainMenu, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#SRC_HDMA_ColMathMainMenu_End-SRC_HDMA_ColMathMainMenu
	bne	-

	lda	#$01|$08						; set BG Mode 1 (BG3 priority)
	sta	REG_BGMODE
	lda	#%01100011						; 16×16 (small) / 32×32 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
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
	stz	REG_CGWSEL						; clear color math disable bits
	lda	#%00100001						; enable color math on BG1 + backdrop
	sta	REG_CGADSUB

	Accu16

	lda	#%0001011100010111					; turn on BG1/2/3 & sprites on mainscreen and subscreen
	sta	REG_TM
	sta	DP_Shadow_TSTM						; copy to shadow variable (not yet used)

	Accu8

	lda	#%00001000						; enable HDMA channels 3 (color math)
	tsb	DP_HDMA_Channels



; -------------------------- ring menu sprites
	lda	#$00							; tile num ("Inventory" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem1+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem1+3

	lda	#$04							; tile num ("Talent" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem2+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem2+3

	lda	#$08							; tile num ("Party" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem3+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem3+3

	lda	#$0C							; tile num ("Lily's log" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem4+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem4+3

	lda	#$40							; tile num ("Settings" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem5+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem5+3

	lda	#$44							; tile num ("Quit Game" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem6+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem6+3

	lda	#$48							; tile num (1st "??" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem7+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem7+3

	lda	#$4C							; tile num (2nd "??" sprite)
	sta	ARRAY_SpriteBuf1.RingMenuItem8+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuItem8+3

	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	lda	#$80							; set angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	DP_RingMenuAngle
	stz	DP_RingMenuAngle+1
	lda	#PARAM_RingMenuRadiusMin
	sta	DP_RingMenuRadius

__RingMenuOpenAnimation:
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
	bcc	__RingMenuOpenAnimation

	lda	#PARAM_RingMenuRadiusMax
	sta	DP_RingMenuRadius
	jsr	PutRingMenuItems



; -------------------------- ring menu cursor sprite
	lda	#PARAM_RingMenuCenterX-16				; X (subtract half of sprite width)
	sta	ARRAY_SpriteBuf1.RingMenuCursor
	lda	#PARAM_RingMenuCenterY-PARAM_RingMenuRadiusMax		; Y (subtract radius to place the cursor at the top of the menu)
	sta	ARRAY_SpriteBuf1.RingMenuCursor+1
	lda	#$80							; tile num (cursor sprite)
	sta	ARRAY_SpriteBuf1.RingMenuCursor+2
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	ARRAY_SpriteBuf1.RingMenuCursor+3

	DrawFrame	7, 1, 17, 2



.ENDASM

; -------------------------- menu "window" content
	DrawFrame	1, 1, 13, 12
	PrintString	2, 2, "Gengen"
	PrintString	3, 2, "9999/9999 HP"
	PrintString	4, 2, "9999/9999 EP"
	PrintString	6, 5, "Warrior"
	PrintString	7, 5, "Healthy"

	DrawFrame	17, 1, 13, 12
	PrintString	2, 18, "Lily"
	PrintString	3, 18, "9999/9999 HP"
	PrintString	4, 18, "9999/9999 EP"
	PrintString	6, 21, "Scholar"
	PrintString	7, 21, "Healthy"

	DrawFrame	1, 15, 13, 12
	PrintString	16, 2, "Mickey"
	PrintString	17, 2, "9999/9999 HP"
	PrintString	18, 2, "9999/9999 EP"
	PrintString	20, 5, "M. artist"
	PrintString	21, 5, "Healthy"

	DrawFrame	17, 15, 13, 12
	PrintString	16, 18, "Tara"
	PrintString	17, 18, "9999/9999 HP"
	PrintString	18, 18, "9999/9999 EP"
	PrintString	20, 21, "Healer"
	PrintString	21, 21, "Healthy"

;	Accu16

;	lda	#$3008							; set char 1 position
;	sta	DP_Char1PosYX

;	Accu8

.ASM

RingMenuLoop:
	wai



; -------------------------- check for dpad left
	lda	Joy1Press+1
	and	#%00000010
	beq	__RingMenuLoopDpadLeftDone

	ldy	#$0020							; change angle 32 times
-	wai
	dec	DP_RingMenuAngle					; dec angle --> rotate clockwise
	dec	DP_RingMenuAngle
	jsr	PutRingMenuItems

	dey
	dey
	bne	-

__RingMenuLoopDpadLeftDone:



; -------------------------- check for dpad right
	lda	Joy1Press+1
	and	#%00000001
	beq	__RingMenuLoopDpadRightDone

	ldy	#$0020
-	wai
	inc	DP_RingMenuAngle					; inc angle --> rotate counter-clockwise
	inc	DP_RingMenuAngle
	jsr	PutRingMenuItems

	dey
	dey
	bne	-

__RingMenuLoopDpadRightDone:



; -------------------------- update headline based on angle
	lda	DP_RingMenuAngle
	bne	+
	PrintString	2, 8, "    Settings    "
	jmp	++

+	cmp	#$20
	bne	+
	PrintString	2, 8, "   Quit Game    "
	jmp	++

+	cmp	#$40
	bne	+
	PrintString	2, 8, "      ???1      "
	jmp	++

+	cmp	#$60
	bne	+
	PrintString	2, 8, "      ???2      "
	jmp	++

+	cmp	#$80
	bne	+
	PrintString	2, 8, "   Inventory    "
	bra	++

+	cmp	#$A0
	bne	+
	PrintString	2, 8, "     Talent     "
	bra	++

+	cmp	#$C0
	bne	+
	PrintString	2, 8, "     Party      "
	bra	++

+	PrintString	2, 8, "   Lily's log   "
++

;.IFDEF DEBUG
;	PrintString	23, 2, "Angle: $"
;	PrintHexNum	DP_RingMenuAngle
;.ENDIF

	lda	#%00010000						; make sure BG3 lo tile map gets updated
	tsb	DP_DMA_Updates



; -------------------------- check for A button = make selection
	lda	Joy1New
	and	#%10000000
	beq	__RingMenuLoopAButtonDone

	lda	DP_RingMenuAngle					; make selection based on ring menu angle
	lsr	a							; shift into lower nibble
	lsr	a
	lsr	a
	lsr	a

	Accu16

	and #$000F							; remove garbage data
	tax

	Accu8

	jmp	(SRC_MainMenuSelTbl, x)

__RingMenuLoopAButtonDone:

	jmp	RingMenuLoop



SRC_MainMenuSelTbl:
	.DW	GotoSettings
	.DW	GotoQuitGame
	.DW	Goto???1
	.DW	Goto???2
	.DW	GotoInventory
	.DW	GotoTalent
	.DW	GotoParty
	.DW	GotoLilysLog



PutRingMenuItems:
	lda	DP_RingMenuAngle					; take angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem1				; set WRAM address for 1st item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 2nd item on ring menu ($60 = 1:30 o'clock)
	sec
	sbc	#$20
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem2				; set WRAM address for 2nd item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 3rd item on ring menu ($40 = 3:00 o'clock)
	sec
	sbc	#$40
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem3				; set WRAM address for 3rd item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 4th item on ring menu ($20 = 4:30 o'clock)
	sec
	sbc	#$60
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem4				; set WRAM address for 4th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 5th item on ring menu ($00 = 6:00 o'clock)
	sec
	sbc	#$80
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem5				; set WRAM address for 5th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 6th item on ring menu ($E0 = 7:30 o'clock)
	clc
	adc	#$60
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem6				; set WRAM address for 6th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 7th item on ring menu ($C0 = 9:00 o'clock)
	clc
	adc	#$40
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem7				; set WRAM address for 7th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle					; set angle for 8th item on ring menu ($A0 = 10:30 o'clock)
	clc
	adc	#$20
	sta	DP_RingMenuAngleOffset

	ldx	#ARRAY_SpriteBuf1.RingMenuItem8				; set WRAM address for 8th item on ring menu
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	CalcRingMenuItemPos

	rts



CalcRingMenuItemPos:

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
	sta	REG_WMDATA						; save X

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

Goto???1:
;GotoInventoryV-Split:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

	stz	REG_HDMAEN						; disable HDMA



; -------------------------- clear tilemap buffers, init sprites, load new font/GFX data
	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024*9		; clear all tile map buffers (except BG3-hi)

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

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

;	lda	#$80							; set CGRAM address to #256 (word address) for sprites
;	sta	REG_CGADD

;	DMA_CH0 $02, :SRC_Palette_Sprites_InGameMenu, SRC_Palette_Sprites_InGameMenu, $22, 32



; -------------------------- set up HDMA channel 6 for char data area designation
	ldx	#SRC_HDMA_BG12CharData
	stx	$4362
	lda	#:SRC_HDMA_BG12CharData
	sta	$4364
	lda	#$0B							; PPU reg. $210B (BG12NBA)
	sta	$4361
	lda	#$00							; transfer mode (1 byte)
	sta	$4360



; -------------------------- set up HDMA channel 7 for screen mode
	ldx	#SRC_HDMA_Mode5
	stx	$4372
	lda	#:SRC_HDMA_Mode5
	sta	$4374
	lda	#$05							; PPU reg. $2105 (BGMODE)
	sta	$4371
	lda	#$00							; transfer mode (1 byte)
	sta	$4370



; -------------------------- screen regs, additional parameters
;	lda	#$40							; BG1/BG2 character data VRAM offset: $0000/$4000 // never mind, HDMA does this
;	sta	REG_BG12NBA
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#%00100000						; enable color math on backdrop only
	sta	REG_CGADSUB

	SetIRQ	TBL_HIRQ_MainMenu

	lda	#44							; H-IRQ setup: dot number for interrupt
	sta	REG_HTIMEL						; set low byte of H-timer
	stz	REG_HTIMEH						; set high byte of H-timer
	lda	#%11000000						; enable HDMA channels 6 (BG1/2 char data area designation), 7 (BG Mode 5)
	tsb	DP_HDMA_Channels
	lda	#$91							; enable H-IRQ, NMI, and auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli
	lda	#$0F
	sta	REG_INIDISP

	SetTextPos	2, 2

	ldx	#STR_ItemEng000
	stx	DP_TextStringPtr
	lda	#:STR_ItemEng000
	sta	DP_TextStringBank
	lda	#24
	sta	temp+3

__RenderItem:
	lda	#16
	sta	DP_HiResPrintLen
	jsr	PrintHiResFixedLenFWF

	Accu16

	lda	DP_TextStringPtr
	clc
	adc	#16
	sta	DP_TextStringPtr
	lda	DP_TextCursor
	clc
	adc	#24
	sta	DP_TextCursor

	Accu8

	dec	temp+3
	bne	__RenderItem

	SetTextPos	2, 16

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

;	ldx	#(ARRAY_BG3TileMap & $FFFF)
;	stx	REG_WMADDL
;	stz	REG_WMADDH

;	ldx	#0
;	lda	#$83
;-	sta	REG_WMDATA						; fill BG3 tile map (for testing)
;	inx
;	cpx	#1024
;	bne	-

	lda	#%00011111						; make sure BG1-3 lo and BG1/2 hi tilemaps get updated
	tsb	DP_DMA_Updates
	and	#%00001111
	tsb	DP_DMA_Updates+1

	Freeze



Goto???2:

GotoTalent:

GotoParty:

GotoLilysLog:

GotoSettings:

GotoInventory:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

	stz	REG_HDMAEN						; disable HDMA



; -------------------------- clear tilemap buffers, init sprites, load new font/GFX data
;	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
;	stx	REG_WMADDL
;	stz	REG_WMADDH

;	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024*9		; clear all tile map buffers (except BG3-hi)

	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#$3000 ;ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048
	DMA_CH0 $01, :GFX_Items_Eng, GFX_Items_Eng, $18, 160*30



; -------------------------- build BG3 tile map for item list area
	lda	#$30							; palette no. 4 | priority bit
	xba
	lda	#15							; no. of item rows
	sta	temp
	lda	#$80							; first tile of item list
	ldx	#228							; start of item list area in tile map

__MakeBG3ItemTileMap:
	ldy	#10							; max. no. of tiles for an item name
-	sta	ARRAY_BG3TileMap, x
	xba
	sta	ARRAY_BG3TileMapHi, x
	xba

	Accu16

	inc	a

	Accu8

	inx
	dey
	bne	-

	inx								; space between column 1 and 2: 5 tiles
	inx
	inx
	inx
	inx
	ldy	#10							; max. no. of tiles for an item name
-	sta	ARRAY_BG3TileMap, x
	xba
	sta	ARRAY_BG3TileMapHi, x
	xba

	Accu16

	inc	a

	Accu8

	inx
	dey
	bne	-

	Accu16

	pha
	txa
	clc
	adc	#7							; go to next line in item list
	tax
	pla

	Accu8

	dec	temp
	bne	__MakeBG3ItemTileMap

	DrawFrame	1, 5, 29, 18



; -------------------------- screen registers/misc. parameters
	lda	#$03							; switch BG3 char data area designation to $3000 // FIXME
	sta	REG_BG34NBA
	lda	#%00011111						; make sure BG1-3 lo/hi tilemaps get updated
	tsb	DP_DMA_Updates
	tsb	DP_DMA_Updates+1
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; enable NMI and auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli
	lda	#$0F							; turn screen back on
	sta	REG_INIDISP

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
