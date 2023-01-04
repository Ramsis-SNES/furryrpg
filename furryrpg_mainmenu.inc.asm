;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MAIN MENU ***
;
;==========================================================================================



	.ENDASM

MainMenu:
	.ACCU 8
	.INDEX 16

	DrawFrame	10, 9, 11, 7
	PrintString	10, 11, kTextBG3, "Inventory"
	PrintString	11, 11, kTextBG3, "Talent"
	PrintString	12, 11, kTextBG3, "Formation"
	PrintString	13, 11, kTextBG3, "Lily's log"
	PrintString	14, 11, kTextBG3, "Settings"
	PrintString	15, 11, kTextBG3, "Quit game"



; Menu "window" color
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathMenu, x
	sta	LO8.HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMenu
	bne	-

	lda	#%00010000						; set color math enable bits (4-5) to "MathWindow"
	sta	CGWSEL
	lda	#%00010111						; enable color math on BG1/2/3 + sprites
	sta	CGADSUB
	lda	#86							; color "window" left pos
	sta	WH0
	lda	#169							; color "window" right pos
	sta	WH1
	lda	#%00100000						; color math window 1 area = outside (why does this work??)
	sta	WOBJSEL
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	<DP2.HDMA_Channels

	Accu16

	lda	#%0001000000000111					; mainscreen : BG1/2/3, subscreen : sprites (i.e., sprites will disappear as $2130.1 is clear)
	sta	<DP2.Shadow_TSTM

	Accu8



MainMenuLoop:
	WaitFrames	1



; Check for dpad up
	lda	<DP2.Joy1New+1
	and	#%00001000
	beq	++
	lda	LO8.HDMA_ColorMath+0					; first byte of color math HDMA table = no. of scanlines above color bar
	cmp	#80
	beq	+
	sec
	sbc	#8
	sta	LO8.HDMA_ColorMath+0
	bra	++

+	lda	#120
	sta	LO8.HDMA_ColorMath+0

++



; Check for dpad down
	lda	<DP2.Joy1New+1
	and	#%00000100
	beq	++
	lda	LO8.HDMA_ColorMath+0					; first byte of color math HDMA table = no. of scanlines above color bar
	cmp	#120
	beq	+
	clc
	adc	#8
	sta	LO8.HDMA_ColorMath+0
	bra	++

+	lda	#80
	sta	LO8.HDMA_ColorMath+0

++



; Check for A button
	lda	<DP2.Joy1New
	and	#%10000000
	beq	++
	lda	#%00000100						; mosaic on BG3
-	sta	MOSAIC
	wai
	clc
	adc	#$10
	cmp	#$64
	bne	-

-	sta	MOSAIC
	wai
	sec
	sbc	#$10
	cmp	#$04
	bne	-

	stz	MOSAIC
/*	lda	LO8.HDMA_ColorMath+0
	cmp	#80
	bne	+
	ldx	#loword(RAM.BG3Tilemap)					; clear text
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 1024

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



; Check for B button = back
	lda	<DP2.Joy1New+1
	and	#%10000000
	bne	+
	jmp	++

+	PrintString	9, 10, kTextBG3, "             "
	PrintString	10, 10, kTextBG3, "             "
	PrintString	11, 10, kTextBG3, "             "
	PrintString	12, 10, kTextBG3, "             "
	PrintString	13, 10, kTextBG3, "             "
	PrintString	14, 10, kTextBG3, "             "
	PrintString	15, 10, kTextBG3, "             "
	PrintString	16, 10, kTextBG3, "             "


	lda	#%00110000						; disable color math
	sta	CGWSEL
	stz	WOBJSEL							; disable color math window
	lda	#%00001000						; disable HDMA channel 3 (color math)
	trb	<DP2.HDMA_Channels

	Accu16

	lda	#%0001000000010000					; re-enable sprites
	tsb	<DP2.Shadow_TSTM

	Accu8

	jmp	MainAreaLoop

++



; Check for Start
;	lda	<DP2.Joy1New+1
;	and	#%00010000
;	beq	+

;	WaitUserInput

;+

	jmp	MainMenuLoop

	.ASM



; ***************************** Main menu ******************************

InGameMenu:

	.IFNDEF NOMUSIC
		SNESGSS_Command kGSS_MUSIC_STOP, 0			; stop music // REMOVEME when done with menu

		lda	<DP2.GameConfig
		and	#%00000001					; check for "MSU1 present" flag
		beq	+
		stz	MSU_CONTROL					; stop MSU1 track
		stz	MSU_VOLUME
	+
	.ENDIF

	lda	#$80							; enter forced blank
	sta	RAM_INIDISP
	stz	<DP2.HDMA_Channels					; disable HDMA
	wai								; wait

	DisableIRQs



; Clear tilemap buffers, init sprites
	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 10240

	lda	#$CC
	sta	<DP2.EmptySpriteNo
	jsr	SpriteInit



; Clear VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	stz	VMADDL							; reset VRAM address
	stz	VMADDH

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear VRAM



; Load menu GFX
	ldx	#VRAM_BG1_Tiles						; set VRAM address for BG1 tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Logo, VMDATAL, 8000

	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $00, SRC_Tilemap_Logo, WMDATA, 1024

	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Sprites_InGameMenu, VMDATAL, 8192

	ldx	#VRAM_BG3_Tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Font8x8, VMDATAL, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	RAM.BG3TilemapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-



; Palettes --> CGRAM
	stz	CGADD							; reset CGRAM address

	DMA_CH0 $02, SRC_Palettes_Text, CGDATA, 40

	lda	#CGRAM_Area						; set CGRAM address for BG1 tiles palette
	sta	CGADD

	DMA_CH0 $02, SRC_Palette_Logo, CGDATA, 32

	lda	#CGRAM_Area						; palette no. = CGRAM address RSH 2
	lsr	a
	lsr	a
	ldx	#0
-	sta	RAM.BG1Tilemap1Hi, x					; store palette no.
	inx
	cpx	#1024
	bne	-

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	CGADD

	DMA_CH0 $02, SRC_Palette_Sprites_InGameMenu, CGDATA, 32

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated once NMI is re-enabled
	tsb	<DP2.DMA_Updates
	tsb	<DP2.DMA_Updates+1

	SetNMI	kNMI_DebugMenu

	lda	RDNMI							; clear NMI flag
	lda	#$81							; re-enable NMI & IRQ
	sta	NMITIMEN
	cli

	WaitFrames	5						; wait for tilemaps to get updated



; HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	DMAP3
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	BBAD3
	ldx	#LO8.HDMA_ColorMath
	stx	A1T3L
	lda	#$7E							; table in WRAM expected
	sta	A1B3



; Set up menu BG color & misc. PPU (shadow) registers
	ldx	#0
-	lda.l	SRC_HDMA_ColMathMainMenu, x
	sta	LO8.HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMainMenu
	bne	-

	lda	#$01|$08						; set BG Mode 1 (BG3 priority)
	sta	RAM_BGMODE
	lda	#%01100011						; 16×16 (small) / 32×32 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	RAM_OBSEL
	lda	#$50|$01						; VRAM address for BG1 tilemap: $5000, size: 64×32 tiles
	sta	RAM_BG1SC
	lda	#$58|$01						; VRAM address for BG2 tilemap: $5800, size: 64×32 tiles
	sta	RAM_BG2SC
	lda	#$48|$01						; VRAM address for BG3 tilemap: $4800, size: 64×32 tiles
	sta	RAM_BG3SC
	lda	#$00							; VRAM address for BG1 and BG2 character data: $0000
	sta	RAM_BG12NBA
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA
	stz	BG1HOFS							; reset BG1 horizontal scroll
	stz	BG1HOFS
	lda	#$FF							; set BG1 vertical scroll = -1
	sta	BG1VOFS
	stz	BG1VOFS
	stz	BG2HOFS							; reset BG2 horizontal scroll
	stz	BG2HOFS
	sta	BG2VOFS							; set BG2 vertical scroll = -1
	stz	BG2VOFS
	stz	BG3HOFS							; reset BG3 horizontal scroll
	stz	BG3HOFS
	sta	BG3VOFS							; set BG3 vertical scroll = -1
	stz	BG3VOFS
	lda	#$00							; clear color math disable bits
	sta	RAM_CGWSEL
	lda	#%00100001						; enable color math on BG1 + backdrop
	sta	RAM_CGADSUB
	lda	#%00010111						; turn on BG1/2/3 and sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
	lda	#%00001000						; enable HDMA channel 3 (color math)
	tsb	<DP2.HDMA_Channels



; Prepare ring menu item sprites
	lda	#$00							; tile num ("Inventory" sprite)
	sta	RAM.SpriteDataMenu.RingItem0+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem0+4

	lda	#$04							; tile num ("Talent" sprite)
	sta	RAM.SpriteDataMenu.RingItem1+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem1+4

	lda	#$08							; tile num ("Party" sprite)
	sta	RAM.SpriteDataMenu.RingItem2+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem2+4

	lda	#$0C							; tile num ("Lily's log" sprite)
	sta	RAM.SpriteDataMenu.RingItem3+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem3+4

	lda	#$40							; tile num ("Settings" sprite)
	sta	RAM.SpriteDataMenu.RingItem4+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem4+4

	lda	#$44							; tile num ("Quit Game" sprite)
	sta	RAM.SpriteDataMenu.RingItem5+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem5+4

	lda	#$48							; tile num (1st "??" sprite)
	sta	RAM.SpriteDataMenu.RingItem6+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem6+4

	lda	#$4C							; tile num (2nd "??" sprite)
	sta	RAM.SpriteDataMenu.RingItem7+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingItem7+4

	lda	#$0F							; turn on screen
	sta	RAM_INIDISP

	lda	#$80							; set angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	<DP2.RingMenuAngle
	lda	#kRingMenuRadiusMin
	sta	<DP2.RingMenuRadius

@RingMenuOpenAnimation:
	jsr	PutRingMenuItems

	wai
	lda	<DP2.RingMenuAngle
	sec
	sbc	#8
	sta	<DP2.RingMenuAngle
	lda	<DP2.RingMenuRadius					; 32 frames for moving sprites from RadiusMin (0) to RadiusMax (60)
	clc
	adc	#2
	sta	<DP2.RingMenuRadius
	cmp	#64
	bcc	@RingMenuOpenAnimation

	lda	#kRingMenuRadiusMax
	sta	<DP2.RingMenuRadius
	jsr	PutRingMenuItems



; Ring menu cursor sprite
	lda	#kRingMenuCenterX-16					; X (subtract half of sprite width)
	sta	RAM.SpriteDataMenu.RingCursor
	lda	#%00000010						; X (upper 1 bit), sprite size (large)
	sta	RAM.SpriteDataMenu.RingCursor+1
	lda	#kRingMenuCenterY-kRingMenuRadiusMax			; Y (subtract radius to place the cursor at the top of the menu)
	sta	RAM.SpriteDataMenu.RingCursor+2
	lda	#$80							; tile num (cursor sprite)
	sta	RAM.SpriteDataMenu.RingCursor+3
	lda	#%00110000						; attributes (tile num & priority bits only)
	sta	RAM.SpriteDataMenu.RingCursor+4
	ldx	#loword(RAM.SpriteDataMenu)				; set WRAM address for menu sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	DrawFrame	7, 1, 17, 2

	jsr	UpdateMenuHeadline					; make sure initial headline (with frame) appears on the screen

	stz	<DP2.LoopCounter					; reset loop counter



RingMenuLoop:
	bit	<DP2.RingMenuStatus
	bmi	@RotateRingMenuLeft					; MSB set --> rotate ring menu counter-clockwise
	bvs	@RotateRingMenuRight					; bit 6 set --> rotate ring menu clockwise
	bra	@RotateRingMenuDone

@RotateRingMenuLeft:
	lda	<DP2.RingMenuAngle					; check if lower nibble is zero
	and	#$0F
	bne	+							; no, do/continue rotation
	lda	<DP2.RingMenuAngle					; check if upper nibble is even
	and	#$10
	bne	+							; no, do/continue rotation
	lda	#%10000000						; lower nibble zero and upper nibble even --> target angle ($00, $20 ... $E0) reached, clear status MSB (i.e., stop rotation)
	trb	<DP2.RingMenuStatus
	jsr	UpdateMenuHeadline					; make sure headline gets updated based on target angle

	bra	@RotateRingMenuDone

+	inc	<DP2.RingMenuAngle					; inc angle --> rotate counter-clockwise
	inc	<DP2.RingMenuAngle
	bra	@RotateRingMenuDone

@RotateRingMenuRight:
	lda	<DP2.RingMenuAngle
	and	#$0F
	bne	+
	lda	<DP2.RingMenuAngle
	and	#$10
	bne	+
	lda	#%01000000						; lower nibble zero and upper nibble even --> target angle ($00, $20 ... $E0) reached, clear status bit 6 (i.e., stop rotation)
	trb	<DP2.RingMenuStatus
	jsr	UpdateMenuHeadline					; make sure headline gets updated based on target angle

	bra	@RotateRingMenuDone

+	dec	<DP2.RingMenuAngle					; dec angle --> rotate clockwise
	dec	<DP2.RingMenuAngle

@RotateRingMenuDone:
	jsr	PutRingMenuItems					; put ring menu items based on current angle

	wai
	inc	<DP2.LoopCounter					; increment loop counter (used for blinking cursor sprite)



; Check for dpad left
	lda	<DP2.Joy1+1
	and	#kDpadLeft
	beq	@DpadLeftDone
	dec	<DP2.RingMenuAngle					; initiate clockwise rotation, this is required so that angle checks under @RotateRingMenuRight will work properly
	dec	<DP2.RingMenuAngle
	jsr	PutRingMenuItems

	wai								; make sure initial rotation makes it onto the screen
	inc	<DP2.LoopCounter					; increment loop counter to make up for the additional frame
	lda	<DP2.RingMenuStatus					; set appropriate rotation bit in status variable
	and	#%00111111						; clear left/right rotation bits
	ora	#%01000000						; set bit 6 (rotate ring menu right/clockwise)
	sta	<DP2.RingMenuStatus

@DpadLeftDone:



; Check for dpad right
	lda	<DP2.Joy1+1
	and	#kDpadRight
	beq	@DpadRightDone
	inc	<DP2.RingMenuAngle					; initiate counter-clockwise rotation, this is required so that angle checks under @RotateRingMenuLeft will work properly
	inc	<DP2.RingMenuAngle
	jsr	PutRingMenuItems

	wai								; make sure initial rotation makes it onto the screen
	inc	<DP2.LoopCounter					; increment loop counter to make up for the additional frame
	lda	<DP2.RingMenuStatus					; set appropriate rotation bit in status variable
	and	#%00111111						; clear left/right rotation bits
	ora	#%10000000						; set MSB (rotate ring menu left/counter-clockwise)
	sta	<DP2.RingMenuStatus

@DpadRightDone:



; Check for A button = make selection
	lda	<DP2.Joy1New
	bpl	@AButtonDone
	lda	<DP2.RingMenuAngle					; make selection based on ring menu angle
	and	#$0F							; check for proper target angle ($00, $20 ... $E0) to prevent errors, lower nibble must be zero
	bne	@AButtonDone						; still rotating, jump out
	lda	<DP2.RingMenuAngle					; upper nibble must be even
	and	#$10
	bne	@AButtonDone						; still rotating, jump out
	lda	<DP2.RingMenuAngle					; target angle is valid, shift into lower nibble
	lsr	a
	lsr	a
	lsr	a
	lsr	a

	Accu16

	and #$000F							; remove garbage in high byte
	tax

	Accu8

	sta	<DP2.SubMenuNext
	jmp	(@PTR_MainMenuSelection, x)

@PTR_MainMenuSelection:
	.DW GotoSettings
	.DW GotoQuitGame
	.DW GotoSecret1
	.DW GotoSecret2
	.DW GotoInventory
	.DW GotoTalent
	.DW GotoParty
	.DW GotoLilysLog

@AButtonDone:

	lda	<DP2.LoopCounter
	cmp	#30
	bcc	@CursorBlinkingDone
	lda	RAM.SpriteDataMenu.RingCursor+3
	cmp	#$80
	bne	+
	lda	#$CC
	bra	++

+	lda	#$80
++	sta	RAM.SpriteDataMenu.RingCursor+3
	stz	<DP2.LoopCounter
	ldx	#loword(RAM.SpriteDataMenu)				; set WRAM address for menu sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

@CursorBlinkingDone:
	jmp	RingMenuLoop



PutRingMenuItems:
	lda	<DP2.RingMenuAngle					; take angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem0)			; set WRAM address for 1st item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 2nd item on ring menu ($60 = 1:30 o'clock)
	sec
	sbc	#$20
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem1)			; set WRAM address for 2nd item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 3rd item on ring menu ($40 = 3:00 o'clock)
	sec
	sbc	#$40
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem2)			; set WRAM address for 3rd item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 4th item on ring menu ($20 = 4:30 o'clock)
	sec
	sbc	#$60
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem3)			; set WRAM address for 4th item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 5th item on ring menu ($00 = 6:00 o'clock)
	sec
	sbc	#$80
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem4)			; set WRAM address for 5th item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 6th item on ring menu ($E0 = 7:30 o'clock)
	clc
	adc	#$60
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem5)			; set WRAM address for 6th item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 7th item on ring menu ($C0 = 9:00 o'clock)
	clc
	adc	#$40
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem6)			; set WRAM address for 7th item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	lda	<DP2.RingMenuAngle					; set angle for 8th item on ring menu ($A0 = 10:30 o'clock)
	clc
	adc	#$20
	sta	<DP2.RingMenuAngleOffset
	ldx	#loword(RAM.SpriteDataMenu.RingItem7)			; set WRAM address for 8th item on ring menu
	stx	WMADDL
	stz	WMADDH
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu)				; set WRAM address for menu sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	rts



CalcRingItemPos:

; X := CenterX + sin(angle)*radius
; Y := CenterY + cos(angle)*radius

	ldx	<DP2.RingMenuAngleOffset
	lda.l	SRC_SineTable, x
	stz	M7A
	sta	M7A
	lda	<DP2.RingMenuRadius
	asl 	a							; not sure why this is needed (sin(angle)*radius*2 ??)
	sta	M7B
	lda	MPYH
	clc
	adc	#kRingMenuCenterX-16					; add CenterX, subtract half of sprite width (as with the cursor sprite)
	sta	WMDATA							; save X (lower 8 bits)
	lda	#%00000010
	sta	WMDATA							; save X (upper 1 bit), sprite size (large)
	ldx	<DP2.RingMenuAngleOffset
	lda.l	SRC_CosineTable, x
	stz	M7A
	sta	M7A
	lda	<DP2.RingMenuRadius
	asl 	a							; not sure why this is needed (cos(angle)*radius*2 ??)
	sta	M7B
	lda	MPYH
	clc
	adc	#kRingMenuCenterY					; add CenterY
	sta	WMDATA							; save Y

	rts



UpdateMenuHeadline:
	SetTextPos	2, 8

	lda	<DP2.RingMenuAngle					; update headline based on angle ($00, $20 ... $C0, $E0)
	lsr	a							; shift into lower nibble
	lsr	a
	lsr	a
	lsr	a

	Accu16

	and	#$00FF							; remove garbage in B
	tax
	lda.l	PTR_RingMenuHeadEng, x					; x = pointer no.
	sta	<DP2.TextStringPtr

	Accu8

	lda	#:PTR_RingMenuHeadEng					; assume English
	clc
	adc	<DP2.GameLanguage					; add language constant for correct bank/language
	sta	<DP2.TextStringBank

;	ldx	#kTextBG3						; add when needed
;	stx	LO8.Routine_FillTextBuffer
	jsr	SimplePrintF

	lda	#%00010000						; make sure BG3 lo tilemap gets updated
	tsb	<DP2.DMA_Updates

	rts



; ************************ Sub menu: Inventory *************************

GotoQuitGame:
;	jsr	RingMenuCloseAnimation

GotoSecret1:
;	jsr	RingMenuCloseAnimation

GotoSecret2:
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
	sta	RAM.SpriteDataMenu.RingCursor

	Accu8

	lda	#$E0
	sta	RAM.SpriteDataMenu.RingCursor+2

	Accu16

	lda	#$00CC							; $CC = empty 16×16 sprite
	sta	RAM.SpriteDataMenu.RingCursor+3

	Accu8

-	lda	<DP2.RingMenuAngle					; opening animation reversed
	clc
	adc	#8
	sta	<DP2.RingMenuAngle
	lda	<DP2.RingMenuRadius					; 32 frames for moving sprites from RadiusMax (60) to RadiusMin (0)
	cmp	#kRingMenuRadiusMin
	beq	+
	sec
	sbc	#2
	sta	<DP2.RingMenuRadius					; last value = 0
	jsr	PutRingMenuItems

	wai
	bra	-



; Remove all ring menu sprites except the selected one
+	lda	<DP2.SubMenuNext					; $00, $02, $04 ... $0E
	lsr	a							; table has byte entries --> $00, $01, $02 ... $07

	Accu16

	and	#$00FF							; remove garbage in high byte
	tax

	Accu8

	lda.l	SRC_RingItemToKeep, x					; read which ring menu item sprite to keep
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	ldx	#0
-	cpx	<DP2.Temp+4
	bne	+
	inx								; skip the selected sprite
	inx
	inx
	inx
	inx
	bra	++							; jump out in case it's the very last one

+	Accu16

	lda	#$00FF							; put sprites off-screen: X coordinate, sprite size
	sta	RAM.SpriteDataMenu.RingItem0, x				; clear out all other ring menu sprites
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	RAM.SpriteDataMenu.RingItem0, x
	inx

	Accu16

	lda	#$00CC							; $CC = empty 16×16 sprite
	sta	RAM.SpriteDataMenu.RingItem0, x
	inx
	inx
++	cpx	#40							; all 8 ring menu item sprites done?
	bne	-

	Accu8

TestLoop:
	wai

	ldx	<DP2.Temp+4

	lda	<DP2.Joy1Press+1					; up
	and	#kDpadUp
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0+2, x
	dec	a
	sta	RAM.SpriteDataMenu.RingItem0+2, x

+	lda	<DP2.Joy1Press+1					; down
	and	#kDpadDown
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0+2, x
	inc	a
	sta	RAM.SpriteDataMenu.RingItem0+2, x

+	lda	<DP2.Joy1Press+1					; left
	and	#kDpadLeft
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0, x
	dec	a
	sta	RAM.SpriteDataMenu.RingItem0, x

+	lda	<DP2.Joy1Press+1
	and	#kDpadRight						; right
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0, x
	inc	a
	sta	RAM.SpriteDataMenu.RingItem0, x

+	lda	<DP2.Joy1New						; A
	bpl	+
	lda	#0
	sta	RAM.SpriteDataMenu.RingItem0+1, x			; small spr

+	lda	<DP2.Joy1New+1						; B
	bpl	+
	lda	#2
	sta	RAM.SpriteDataMenu.RingItem0+1, x			; big spr

+	ldx	#loword(RAM.SpriteDataMenu)				; set WRAM address for menu sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	bra	TestLoop

	rts

SRC_RingItemToKeep:							; DP2.SubMenuNext RSH 1	| RingItemX (each * 5 bytes of sprite attributes)
	.DB 4*5								; 0			| 4
	.DB 5*5								; 1			| 5
	.DB 6*5								; 2			| 6
	.DB 7*5								; 3			| 7
	.DB 0*5								; 4			| 0
	.DB 1*5								; 5			| 1
	.DB 2*5								; 6			| 2
	.DB 3*5								; 7			| 3



; ********************* Vertical splitscreen test **********************

; Mode-5-based dynamic item rendering with vertical splitscreen

VSplitscreenTest:
	DisableIRQs

	lda	#$80							; enter forced blank
	sta	INIDISP
	stz	HDMAEN							; disable HDMA
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now



; Clear tilemap buffers, init sprites, load new font/GFX data
	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, <WMDATA, 1024*9			; clear all tilemap buffers (except BG3-hi)

;	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#VRAM_BG1_Tiles						; set VRAM address for BG1 font tiles
	stx	VMADDL
	jsr	MakeMode5FontBG1

	ldx	#VRAM_BG3_Tiles						; set VRAM address for BG2 font tiles (Mode 5 BG2 uses the same char data as Mode 1 BG3)
	stx	VMADDL
	jsr	MakeMode5FontBG2



; Palettes --> CGRAM
	stz	CGADD							; reset CGRAM address

	DMA_CH0 $02, SRC_Palettes_Text, <CGDATA, 32

;	lda	#$80							; set CGRAM address to #256 (word address) for sprites
;	sta	CGADD

;	DMA_CH0 $02, SRC_Palette_Sprites_InGameMenu, <CGDATA, 32



; Set up HDMA channel 6 for char data area designation
	ldx	#SRC_HDMA_BG12CharData
	stx	A1T6L
	lda	#:SRC_HDMA_BG12CharData
	sta	A1B6
	lda	#<BG12NBA						; PPU reg. $210B (BG12NBA)
	sta	BBAD6
	lda	#$00							; transfer mode (1 byte)
	sta	DMAP6



; Set up HDMA channel 7 for screen mode
	ldx	#SRC_HDMA_Mode5
	stx	A1T7L
	lda	#:SRC_HDMA_Mode5
	sta	A1B7
	lda	#<BGMODE						; PPU reg. $2105 (BGMODE)
	sta	BBAD7
	lda	#$00							; transfer mode (1 byte)
	sta	DMAP7



; Screen regs, additional parameters
	lda	#$48 ;|$01						; VRAM address for BG3 tilemap: $4800, size: 64×32 tiles
	sta	RAM_BG3SC

	lda	#$50 ;|$01						; VRAM address for BG1 tilemap: $5000, size: 64×32 tiles
	sta	RAM_BG1SC
	lda	#$58 ;|$01						; VRAM address for BG2 tilemap: $5800, size: 64×32 tiles
	sta	RAM_BG2SC

;	lda	#$40							; VRAM address for BG1/BG2 character data: $0000/$4000 // never mind, HDMA does this
;	sta	BG12NBA
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA
;	lda	#%00100000						; enable color math on backdrop only
;	sta	CGADSUB
	lda	#%00010111						; turn on BG1, BG2, BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
;	lda	#$00
;	sta	RAM_W12SEL						; disable windowing
;	sta	RAM_TMW
;	sta	RAM_TSW

	SetIRQ	kHIRQ_MenuItemsVsplit
	SetNMI	kNMI_DebugMenu

	lda	#50							; H-IRQ setup: dot number for interrupt
	sta	HTIMEL							; set low byte of H-timer
	stz	HTIMEH							; set high byte of H-timer
	lda	#%11000000						; enable HDMA channels 6 (BG1/2 char data area designation), 7 (BG Mode 5)
	tsb	<DP2.HDMA_Channels

	lda	#$0F
;	sta	INIDISP
	sta	RAM_INIDISP

	lda	#$91							; enable H-IRQ, NMI, and auto-joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli

	SetTextPos	2, 2

	ldx	#STR_ItemEng000
	stx	<DP2.TextStringPtr
	lda	#:STR_ItemEng000
	sta	<DP2.TextStringBank
	lda	#24
	sta	<DP2.Temp+3

@RenderItem:
	lda	#16
	sta	<DP2.HiResPrintLen
	jsr	PrintHiResFixedLenFWF

	Accu16

	lda	<DP2.TextStringPtr
	clc
	adc	#16
	sta	<DP2.TextStringPtr
	lda	<DP2.TextCursor
	clc
	adc	#24
	sta	<DP2.TextCursor

	Accu8

	dec	<DP2.Temp+3
	bne	@RenderItem

	SetTextPos	2, 16

	ldx	#STR_MainMenuEng000
	stx	<DP2.TextStringPtr
	lda	#:STR_MainMenuEng000
	sta	<DP2.TextStringBank

	ldy	#0
-	lda	[<DP2.TextStringPtr], y
	beq	+
	asl	a							; double char no. because font tiles were "expanded" for hi-res mode
	inc	a							; increment char no. because Mode 5 BG2 font tiles sit on the "right"
	jsr	FillTextBufferBG3

	iny
	bra	-
+

;	PrintString	2, 16, kTextBG3, "TESTESTESTESTESTETSET"

;	ldx	#loword(RAM.BG3Tilemap)
;	stx	WMADDL
;	stz	WMADDH

;	ldx	#0
;	lda	#$83
;-	sta	WMDATA							; fill the whole BG3 tilemap (for testing)
;	inx
;	cpx	#1024
;	bne	-

	lda	#%00011111						; make sure BG1-3 lo and BG1/2 hi tilemaps get updated
	tsb	<DP2.DMA_Updates
	and	#%00001111
	tsb	<DP2.DMA_Updates+1

-	bra	-



; *********************** Static rendering test ************************

; Mode-1-based static item rendering test

StaticRenderingTest:
	DisableIRQs

	lda	#$80							; enter forced blank
	sta	INIDISP
	stz	HDMAEN							; disable HDMA
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now



; Clear tilemap buffers, init sprites, load new font/GFX data
;	ldx	#loword(RAM.BG1Tilemap1)
;	stx	WMADDL
;	stz	WMADDH

;	DMA_CH0 $08, SRC_Zeroes, <WMDATA, 1024*9			; clear all tilemap buffers (except BG3-hi)

;	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#$3000 ;VRAM_BG3_Tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Font8x8, <VMDATAL, 2048
	DMA_CH0 $01, SRC_StaticItemsEng, <VMDATAL, 160*30



; Palettes --> CGRAM
	stz	CGADD							; reset CGRAM address

	DMA_CH0 $02, SRC_Palettes_Text, <CGDATA, 32



; Build BG3 tilemap for item list area
;	lda	#$30							; palette no. 4 | priority bit
	lda	#$20							; palette no. 0 | priority bit
	xba
	lda	#15							; no. of item rows
	sta	<DP2.Temp
	lda	#$80							; first tile of item list
	ldx	#228							; start of item list area in tilemap

@MakeBG3ItemTilemap:
	ldy	#10							; max. no. of tiles for an item name
-	sta	RAM.BG3Tilemap, x
	xba
	sta	RAM.BG3TilemapHi, x
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
-	sta	RAM.BG3Tilemap, x
	xba
	sta	RAM.BG3TilemapHi, x
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

	dec	<DP2.Temp
	bne	@MakeBG3ItemTilemap

	DrawFrame	1, 5, 29, 18



; Screen registers/misc. parameters
	lda	#$48|$01						; VRAM address for BG3 tilemap: $4800, size: 64×32 tiles
	sta	RAM_BG3SC
	lda	#$03							; switch BG3 char data area designation to $3000 // FIXME
	sta	RAM_BG34NBA
	lda	#$01							; set BG mode 1
	sta	RAM_BGMODE
	lda	#%00010100						; turn on BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
;	lda	#$00
;	sta	RAM_W12SEL						; disable windowing
;	sta	RAM_TMW
;	sta	RAM_TSW

	SetNMI	kNMI_DebugMenu

	lda	#%00010000						; make sure BG3 lo/hi tilemaps get updated
	tsb	<DP2.DMA_Updates
	tsb	<DP2.DMA_Updates+1

	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable NMI and auto-joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli
	lda	#$0F							; turn screen back on
	sta	RAM_INIDISP

-	bra	-



; ************************** Mode-5-based FWF **************************

; Mode-5-based dynamic item rendering test

DynamicRenderingTest:
	DisableIRQs

	lda	#$80							; enter forced blank
	sta	INIDISP
	stz	HDMAEN							; disable HDMA
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now



; Clear tilemap buffers, init sprites, load new font/GFX data
	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 1024*9				; clear all tilemap buffers (except BG3-hi)

	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#VRAM_BG1_Tiles						; set VRAM address for BG1 font tiles
	stx	VMADDL
	jsr	MakeMode5FontBG1

	ldx	#VRAM_BG3_Tiles						; set VRAM address for BG2 font tiles (Mode 5 BG2 uses the same char data as Mode 1 BG3)
	stx	VMADDL
	jsr	MakeMode5FontBG2



; Palettes --> CGRAM
	stz	CGADD							; reset CGRAM address

	DMA_CH0 $02, SRC_Palettes_Text, CGDATA, 32

;	lda	#$80							; set CGRAM address to #256 (word address) for sprites
;	sta	CGADD

;	DMA_CH0 $02, SRC_Palette_Sprites_InGameMenu, CGDATA, 32



; Set up HDMA channel 6 for char data area designation
;	ldx	#SRC_HDMA_BG12CharData
;	stx	A1T6L
;	lda	#:SRC_HDMA_BG12CharData
;	sta	A1B6
;	lda	#<BG12NBA						; PPU reg. $210B (BG12NBA)
;	sta	BBAD6
;	lda	#$00							; transfer mode (1 byte)
;	sta	DMAP6



; Screen regs, additional parameters
	lda	#$50 ;|$01						; VRAM address for BG1 tilemap: $5000, size: 64×32 tiles
	sta	RAM_BG1SC
	lda	#$58 ;|$01						; VRAM address for BG2 tilemap: $5800, size: 64×32 tiles
	sta	RAM_BG2SC

	lda	#$40							; VRAM address for BG1/BG2 character data: $0000/$4000
	sta	RAM_BG12NBA
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA
	lda	#$05
	sta	RAM_BGMODE
;	lda	#%00100000						; enable color math on backdrop only
;	sta	RAM_CGADSUB
	lda	#%00010111						; turn on BG1, BG2, BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS

;	lda	#%11000000						; enable HDMA channel 6 (BG1/2 char data area designation), 7 (BG Mode 5)
;	tsb	<DP2.HDMA_Channels

	SetNMI	kNMI_DebugMenu

	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable NMI and auto-joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli

	ldx	#0

	Accu16

	lda	#$0100							; item qty = 1, start with item #0
-	sta	RAM.GameDataInventory, x
	inc	a							; increment item no. #
	inx
	inx
	cpx	#32							; 16 items for now
	bne	-

	Accu8
	SetTextPos	2, 2

	ldx	#0

@ReadItemFromInventory:
	lda	RAM.GameDataInventory, x
	xba
	inx
	lda	RAM.GameDataInventory, x
	bne	+
	inx
	cpx	#512
	beq	@ReadItemFromInventoryDone
	bra	@ReadItemFromInventory

+	sta	LO8.GameDataItemQty
	xba

	Accu16

	and	#$00FF							; clear garbage in B
	asl	a
	asl	a
	asl	a
	asl	a
	clc
	adc	#STR_ItemsEng
	sta	<DP2.TextStringPtr

	Accu8

	lda	#:STR_ItemsEng
	sta	<DP2.TextStringBank
	inx
	cpx	#512
	beq	@ReadItemFromInventoryDone
	phx

@RenderItem:
	lda	#16
	sta	<DP2.HiResPrintLen
	jsr	PrintHiResFixedLenFWF

	Accu16

	lda	<DP2.TextCursor
	clc
	adc	#24
	sta	<DP2.TextCursor

	Accu8

	plx
	bra	@ReadItemFromInventory

@ReadItemFromInventoryDone:

/*	SetTextPos	2, 16

	ldx	#STR_MainMenuEng000
	stx	<DP2.TextStringPtr
	lda	#:STR_MainMenuEng000
	sta	<DP2.TextStringBank

	ldy	#0
-	lda	[<DP2.TextStringPtr], y
	beq	+
	asl	a							; double char no. because font tiles were "expanded" for hi-res mode
	inc	a							; increment char no. because Mode 5 BG2 font tiles sit on the "right"
	jsr	FillTextBufferMode5

	iny
	bra	-
+
*/
	lda	#%00001111						; make sure BG1 and BG2 lo/hi tilemaps get updated
	tsb	<DP2.DMA_Updates
	and	#%00001111
	tsb	<DP2.DMA_Updates+1
;	lda	#%00001000						; enable HDMA channel 3 (color math)
;	tsb	<DP2.HDMA_Channels

;	WaitFrames	4

	lda	#$0F							; turn screen back on
	sta	RAM_INIDISP

-	bra	-							; trap loop



; **********************************************************************

	.ENDASM

LoadMenuCharPortraits:
	ldx	#$01C0
	lda	#$02
-	sta	RAM.BG1Tilemap1, x
	inx
	inc	a
	inc	a
	cmp	#$0C
	bne	-

	ldx	#$01E0
	lda	#$12
-	sta	RAM.BG1Tilemap1, x
	inx
	inc	a
	inc	a
	cmp	#$1C
	bne	-

	ldx	#$0200
	lda	#$22
-	sta	RAM.BG1Tilemap1, x
	inx
	inc	a
	inc	a
	cmp	#$2C
	bne	-

	ldx	#$0220
	lda	#$32
-	sta	RAM.BG1Tilemap1, x
	inx
	inc	a
	inc	a
	cmp	#$3C
	bne	-

	ldx	#$0240
	lda	#$42
-	sta	RAM.BG1Tilemap1, x
	inx
	inc	a
	inc	a
	cmp	#$4C
	bne	-

	ldx	#$0260
	lda	#$52
-	sta	RAM.BG1Tilemap1, x
	inx
	inc	a
	inc	a
	cmp	#$5C
	bne	-

	rts

	.ASM



; ******************************** EOF *********************************
