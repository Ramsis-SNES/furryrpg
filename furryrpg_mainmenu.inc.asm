; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	MAIN MENU
;
; ==================================================================================================



; MAIN MENU
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

InGameMenu:

.IFNDEF NOMUSIC

	SNESGSS_Command kGSS_MUSIC_STOP, 0				; stop music // REMOVEME when done with menu

	lda	<DP2.GameConfig
	and	#kGameConfigMSU1					; check for "MSU1 present" flag
	beq	+
	stz	MSU_CONTROL						; stop MSU1 track
	stz	MSU_VOLUME
+

.ENDIF

	lda	#kForcedBlank
	sta	RAM_INIDISP
	stz	<DP2.HDMA_Channels					; disable HDMA
	wai								; wait
	jsl	DisableInterrupts



; Clear tilemap buffers, init sprites
	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 10240

	lda	#$CC
	sta	<DP2.EmptySpriteNo
	jsr	SpriteInit



; Clear VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	stz	VMADDL							; reset VRAM address
	stz	VMADDH

	dma_0	$09, SRC_0000, VMDATAL, 0				; clear VRAM



; Load menu GFX
	ldx	#VRAM_BG1_Tiles						; set VRAM address for BG1 tiles
	stx	VMADDL

	dma_0	$01, SRC_Logo, VMDATAL, _sizeof_SRC_Logo

	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	dma_0	$00, SRC_Tilemap_Logo, WMDATA, _sizeof_SRC_Tilemap_Logo

	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	dma_0	$01, SRC_Sprites_InGameMenu, VMDATAL, 8192

	ldx	#VRAM_BG3_Tiles
	stx	VMADDL

	dma_0	$01, SRC_Font8x8, VMDATAL, 2048

	ldx	#0
	lda	#$20							; priority bit
-	inx
	sta	RAM.BG3Tilemap, x					; set priority bit for BG3 tiles
	inx
	cpx	#2048
	bne	-



; Palettes --> CGRAM
	stz	CGADD							; reset CGRAM address

	dma_0	$02, SRC_Palettes_Text, CGDATA, 40

	lda	#CGRAM_Area						; set CGRAM address for BG1 tiles palette
	sta	CGADD

	dma_0	$02, SRC_Palette_Logo, CGDATA, 32

	lda	#CGRAM_Area						; palette no. = CGRAM address RSH 2
	rsh	2
	ldx	#0
-	inx
	sta	RAM.BG1Tilemap1, x					; store palette no.
	inx
	cpx	#2048
	bne	-

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	CGADD

	dma_0	$02, SRC_Palette_Sprites_InGameMenu, CGDATA, 32

	lda	#kBG1Tilemap1|kBG2Tilemap1|kBG3Tilemap			; update BG1/2/3 tilemaps once NMI is re-enabled
	tsb	<DP2.DMA_Updates

	set	"NMI", Vblank_DebugMenu

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	NMITIMEN
	cli

	wait	"frames", 3						; wait for tilemaps to get updated



; HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> COLDATA register)
	sta	DMAP3
	lda	#<COLDATA
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

	lda	#kBGMODE_1|kBG3priority
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
	lda	#kTM_BG1|kTM_BG2|kTM_BG3|kTM_OBJ			; turn on BG1, BG2, BG3 + sprites on mainscreen and subscreen
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

	lda	#kINIDISP_15						; turn on screen
	sta	RAM_INIDISP

	lda	#lobyte($80 + 30 * 8)					; set starting angle for 1st item (Inventory) on ring menu ($80 = 12:00 o'clock), plus angle displacement for opening animation, see below
	sta	<DP2.RingMenuAngle
	lda	#kRingMenuRadiusMin
	sta	<DP2.RingMenuRadius

@RingMenuOpenAnimation:
	jsr	PutRingMenuItems

	wai

	lda	<DP2.RingMenuAngle					; subtract 8 * 30 (frames) from angle
	sec
	sbc	#8
	sta	<DP2.RingMenuAngle
	lda	<DP2.RingMenuRadius					; add 2 * 30 (frames) to radius (RadiusMax = 60)
	clc
	adc	#2
	sta	<DP2.RingMenuRadius
	cmp	#kRingMenuRadiusMax
	bne	@RingMenuOpenAnimation

	jsr	PutRingMenuItems					; angle should be $80 by now



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

.IFDEF DEBUG
	PrintString	26, 22, kTextBG3, "Angle: "
	PrintHexNum	<DP2.RingMenuAngle
.ENDIF

	bit	<DP2.RingMenuStatus
	bmi	@RotateRingMenuLeft					; MSB set --> rotate ring menu counter-clockwise
	bvs	@RotateRingMenuRight					; bit 6 set --> rotate ring menu clockwise
	bra	@RotateRingMenuDone

@RotateRingMenuLeft:
	lda	<DP2.RingMenuAngle					; check if lower nibble is zero
	and	#$0F
	bne	@@Force							; no, do/continue rotation
	lda	<DP2.RingMenuAngle					; check if upper nibble is even
	and	#$10
	bne	@@Force							; no, do/continue rotation
	lda	#%10000000						; lower nibble zero and upper nibble even --> target angle ($00, $20 ... $E0) reached, clear status MSB (i.e., stop rotation)
	trb	<DP2.RingMenuStatus
	jsr	UpdateMenuHeadline					; make sure headline gets updated based on target angle

	bra	@RotateRingMenuDone

@@Force:
	lda	<DP2.RingMenuAngle					; inc angle --> rotate counter-clockwise
	ina
	ina
	sta	<DP2.RingMenuAngle
	bra	@RotateRingMenuDone

@RotateRingMenuRight:
	lda	<DP2.RingMenuAngle
	and	#$0F
	bne	@@Force
	lda	<DP2.RingMenuAngle
	and	#$10
	bne	@@Force
	lda	#%01000000						; lower nibble zero and upper nibble even --> target angle ($00, $20 ... $E0) reached, clear status bit 6 (i.e., stop rotation)
	trb	<DP2.RingMenuStatus
	jsr	UpdateMenuHeadline					; make sure headline gets updated based on target angle

	bra	@RotateRingMenuDone

@@Force:
	lda	<DP2.RingMenuAngle					; dec angle --> rotate clockwise
	dea
	dea
	sta	<DP2.RingMenuAngle

@RotateRingMenuDone:
	jsr	PutRingMenuItems					; put ring menu items based on current angle

	wai
	inc	<DP2.LoopCounter					; increment loop counter (used for blinking cursor sprite)



; left pressed = counter-clockwise rotation, right pressed = clockwise rotation (like in Secret of Mana)

; Check for dpad left
	lda	<DP2.Joy1+1
	and	#kDpadLeft
	beq	@DpadLeftDone

	lda	<DP2.RingMenuStatus					; set appropriate rotation bit in status variable
	and	#%00111111						; clear rotation bits
	ora	#%10000000						; set MSB (rotate ring menu left/counter-clockwise)
	sta	<DP2.RingMenuStatus
	bra	@RotateRingMenuLeft@Force

@DpadLeftDone:



; Check for dpad right
	lda	<DP2.Joy1+1
	and	#kDpadRight
	beq	@DpadRightDone

	lda	<DP2.RingMenuStatus					; set appropriate rotation bit in status variable
	and	#%00111111						; clear rotation bits
	ora	#%01000000						; set bit 6 (rotate ring menu right/clockwise)
	sta	<DP2.RingMenuStatus
	bra	@RotateRingMenuRight@Force

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

	and #$000F							; clear high byte (& upper nibble, just to be safe)
	tax

	Accu8

	sta	<DP2.SubMenuNext
	jmp	(@SRC_MainMenuSelection, x)

@SRC_MainMenuSelection:
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
	ldx	#loword(RAM.SpriteDataMenu.RingItem0)			; set WRAM address for 1st item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; take angle for 1st item on ring menu ($80 = 12:00 o'clock)
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem1)			; set WRAM address for 2nd item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 2nd item on ring menu ($60 = 1:30 o'clock)
	sec
	sbc	#$20							; $80 - $20
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem2)			; set WRAM address for 3rd item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 3rd item on ring menu ($40 = 3:00 o'clock)
	sec
	sbc	#$40
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem3)			; set WRAM address for 4th item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 4th item on ring menu ($20 = 4:30 o'clock)
	sec
	sbc	#$60
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem4)			; set WRAM address for 5th item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 5th item on ring menu ($00 = 6:00 o'clock)
	sec
	sbc	#$80
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem5)			; set WRAM address for 6th item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 6th item on ring menu ($E0 = 7:30 o'clock)
	clc
	adc	#$60
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem6)			; set WRAM address for 7th item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 7th item on ring menu ($C0 = 9:00 o'clock)
	clc
	adc	#$40
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu.RingItem7)			; set WRAM address for 8th item on ring menu
	stx	WMADDL
	stz	WMADDH
	lda	<DP2.RingMenuAngle					; set angle for 8th item on ring menu ($A0 = 10:30 o'clock)
	clc
	adc	#$20
	jsr	CalcRingItemPos

	ldx	#loword(RAM.SpriteDataMenu)				; set WRAM address for menu sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer				; write changes to sprite buffer

	rts



CalcRingItemPos:

; X := CenterX + sin(angle)*radius
; Y := CenterY + cos(angle)*radius

; Calculate X coordinate
	Accu16

	and	#$00FF							; clear high byte
	asl	a							; use angle in Accu as index into 16-bit tables
	tax
	lda.l	SRC_SineTable16, x					; get sin(angle)

	Accu8

	sta	M7A							; multiply by radius
	xba
	sta	M7A
	lda	<DP2.RingMenuRadius
	sta	M7B
	lda	MPYM
	clc
	adc	#kRingMenuCenterX-16					; add CenterX, subtract half of sprite width (as with the cursor sprite)
	sta	WMDATA							; save X coordinate (lower 8 bits)
	lda	#%00000010
	sta	WMDATA							; save X coordinate (upper 1 bit), sprite size (large)

; Calculate Y coordinate
	Accu16

	lda.l	SRC_CosineTable16, x					; get cos(angle) (index register still intact)

	Accu8

	sta	M7A							; multiply by radius
	xba
	sta	M7A
	lda	<DP2.RingMenuRadius
	sta	M7B
	lda	MPYM
	clc
	adc	#kRingMenuCenterY					; add CenterY
	sta	WMDATA							; save Y coordinate

	rts



UpdateMenuHeadline:
	SetTextPos	2, 8

	lda	#:SRC_RingMenuHeadENG					; assume English
	clc
	adc	<DP2.GameLanguage					; add language constant for correct bank/language
	sta	<DP2.TextStringBank
	sta	<DP2.DataBank

	Accu16

	lda	<DP2.GameLanguage					; check for selected language
	and	#$00FF							; clear high byte
	asl	a
	tax
	lda.l	SRC_RingMenuHeadPointers, x				; starting address of headline pointers of a given language into DataAddress
	sta	<DP2.DataAddress
	lda	<DP2.RingMenuAngle					; update headline based on angle ($00, $20 ... $C0, $E0)
	and	#$00FF							; clear high byte
	rsh	4							; shift angle into lower nibble
	tay								; y = pointer no.
	lda	[<DP2.DataAddress], y
	sta	<DP2.TextStringPtr

	Accu8

;	ldx	#kTextBG3						; add when needed
;	stx	LO8.Routine_FillTextBuffer
	jsr	SimplePrintF

	lda	#kBG3Tilemap						; update BG3 tilemap
	tsb	<DP2.DMA_Updates

	rts

SRC_RingMenuHeadPointers:
	.DW SRC_RingMenuHeadENG
	.DW SRC_RingMenuHeadDEU



; SUB MENU: INVENTORY
; --------------------------------------------------------------------------------------------------

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

	and	#$00FF							; clear high byte
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
	dea
	sta	RAM.SpriteDataMenu.RingItem0+2, x

+	lda	<DP2.Joy1Press+1					; down
	and	#kDpadDown
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0+2, x
	ina
	sta	RAM.SpriteDataMenu.RingItem0+2, x

+	lda	<DP2.Joy1Press+1					; left
	and	#kDpadLeft
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0, x
	dea
	sta	RAM.SpriteDataMenu.RingItem0, x

+	lda	<DP2.Joy1Press+1
	and	#kDpadRight						; right
	beq	+
	lda	RAM.SpriteDataMenu.RingItem0, x
	ina
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



; VERTICAL SPLITSCREEN TEST
; --------------------------------------------------------------------------------------------------

; Mode-5-based dynamic item rendering with vertical splitscreen

VSplitscreenTest:
	jsl	DisableInterrupts

	lda	#kForcedBlank
	sta	INIDISP
	stz	HDMAEN							; disable HDMA
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now



; Clear tilemap buffers, init sprites, load new font/GFX data
	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, <WMDATA, 1024*9				; clear all tilemap buffers (except BG3-hi)

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

	dma_0	$02, SRC_Palettes_Text, <CGDATA, 32

;	lda	#$80							; set CGRAM address to #256 (word address) for sprites
;	sta	CGADD

;	dma_0	$02, SRC_Palette_Sprites_InGameMenu, <CGDATA, 32



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
	lda	#kTM_BG1|kTM_BG2|kTM_BG3|kTM_OBJ			; turn on BG1, BG2, BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
;	lda	#$00
;	sta	RAM_W12SEL						; disable windowing
;	sta	RAM_TMW
;	sta	RAM_TSW

	set	"IRQ", HIRQ_MenuItemsVsplit
	set	"NMI", Vblank_DebugMenu

	lda	#50							; H-IRQ setup: dot number for interrupt
	sta	HTIMEL							; set low byte of H-timer
	stz	HTIMEH							; set high byte of H-timer
	lda	#%11000000						; enable HDMA channels 6 (BG1/2 char data area designation), 7 (BG Mode 5)
	tsb	<DP2.HDMA_Channels

	lda	#kINIDISP_15
;	sta	INIDISP
	sta	RAM_INIDISP

	lda	#kNMITIMEN_Enable|kHIRQ|kAutoJoy			; enable NMI, H-IRQ, and auto joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli

	SetTextPos	2, 2

	ldx	#STR_ItemENG000
	stx	<DP2.TextStringPtr
	lda	#:STR_ItemENG000
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
	adc	#24 * 2
	sta	<DP2.TextCursor

	Accu8

	dec	<DP2.Temp+3
	bne	@RenderItem

	SetTextPos	2, 16

	ldx	#STR_MainMenuENG000
	stx	<DP2.TextStringPtr
	lda	#:STR_MainMenuENG000
	sta	<DP2.TextStringBank

	ldy	#0
-	lda	[<DP2.TextStringPtr], y
	beq	+
	asl	a							; double char no. because font tiles were "expanded" for hi-res mode
	ina								; increment char no. because Mode 5 BG2 font tiles sit on the "right"
	jsr	FillTextBufferBG3

	iny
	bra	-
+

;	PrintString	2, 16, kTextBG3, "TESTESTESTESTESTEST"

	ldx	#loword(RAM.BG3Tilemap)
	stx	WMADDL
	stz	WMADDH

	ldx	#1024							; fill the whole tilemap for testing
-	lda	#$83
	sta	WMDATA							; write tile
	lda	#$20
	sta	WMDATA							; set priority bit
	dex
	bne	-

	lda	#kBG1Tilemap1|kBG2Tilemap1|kBG3Tilemap			; update BG1/2/3 tilemaps
	tsb	<DP2.DMA_Updates

-	bra	-



; STATIC RENDERING TEST
; --------------------------------------------------------------------------------------------------

; Mode-1-based static item rendering test

StaticRenderingTest:
	jsl	DisableInterrupts

	lda	#kForcedBlank
	sta	INIDISP
	stz	HDMAEN							; disable HDMA
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now



; Clear tilemap buffers, init sprites, load new font/GFX data
;	ldx	#loword(RAM.BG1Tilemap1)
;	stx	WMADDL
;	stz	WMADDH

;	dma_0	$08, SRC_0000, <WMDATA, 1024*9				; clear all tilemap buffers (except BG3-hi)

;	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#$3000 ;VRAM_BG3_Tiles
	stx	VMADDL

	dma_0	$01, SRC_Font8x8, <VMDATAL, 2048
	dma_0	$01, SRC_StaticItemsENG, <VMDATAL, 160*30



; Palettes --> CGRAM
	stz	CGADD							; reset CGRAM address

	dma_0	$02, SRC_Palettes_Text, <CGDATA, 32



; Build BG3 tilemap for item list area
	Accu16

	lda	#15							; no. of item rows
	sta	<DP2.Temp

	lda	#$2080							; high byte: palette no. 0 | priority bit, low byte: first tile of item list
	ldx	#228*2							; start of item list area in tilemap

@MakeBG3ItemTilemap:
	ldy	#10							; max. no. of tiles for an item name
-	sta	RAM.BG3Tilemap, x
	ina								; increment tile no.
	inx								; increment index
	inx
	dey
	bne	-

	pha								; preserve tile data
	txa
	clc
	adc	#5 * 2							; space between column 1 and 2: 5 tiles
	tax
	pla								; restore tile data

	ldy	#10							; max. no. of tiles for an item name
-	sta	RAM.BG3Tilemap, x
	ina
	inx
	inx
	dey
	bne	-

	pha
	txa
	clc
	adc	#7 * 2							; go to next line in item list
	tax
	pla

	dec	<DP2.Temp
	bne	@MakeBG3ItemTilemap

	Accu8

	DrawFrame	1, 5, 29, 18



; Screen registers/misc. parameters
	lda	#$48|$01						; VRAM address for BG3 tilemap: $4800, size: 64×32 tiles
	sta	RAM_BG3SC
	lda	#$03							; switch BG3 char data area designation to $3000 // FIXME
	sta	RAM_BG34NBA
	lda	#kBGMODE_1						; set BG mode 1
	sta	RAM_BGMODE
	lda	#kTM_BG3|kTM_OBJ					; turn on BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
;	lda	#$00
;	sta	RAM_W12SEL						; disable windowing
;	sta	RAM_TMW
;	sta	RAM_TSW

	set	"NMI", Vblank_DebugMenu

	lda	#kBG3Tilemap						; update BG3 tilemap
	tsb	<DP2.DMA_Updates

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli
	lda	#kINIDISP_15						; turn screen back on
	sta	RAM_INIDISP

-	bra	-



; DYNAMIC RENDERING TEST
; --------------------------------------------------------------------------------------------------

; Mode-5-based dynamic item rendering test

DynamicRenderingTest:
	jsl	DisableInterrupts

	lda	#kForcedBlank
	sta	INIDISP
	stz	HDMAEN							; disable HDMA
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now



; Clear tilemap buffers, init sprites, load new font/GFX data
	ldx	#loword(RAM.BG1Tilemap1)
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 2048 * 5				; clear all tilemap buffers

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

	dma_0	$02, SRC_Palettes_Text, CGDATA, 32

;	lda	#$80							; set CGRAM address to #256 (word address) for sprites
;	sta	CGADD

;	dma_0	$02, SRC_Palette_Sprites_InGameMenu, CGDATA, 32



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
	lda	#kBGMODE_5
	sta	RAM_BGMODE
;	lda	#%00100000						; enable color math on backdrop only
;	sta	RAM_CGADSUB
	lda	#kTM_BG1|kTM_BG2|kTM_BG3|kTM_OBJ			; turn on BG1, BG2, BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
;	lda	#%11000000						; enable HDMA channel 6 (BG1/2 char data area designation), 7 (BG Mode 5)
;	tsb	<DP2.HDMA_Channels

	set	"NMI", Vblank_DebugMenu

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli



; Fill inventory list with some items
	ldx	#0

	Accu16

	lda	#$0100							; item qty = 1, start with item #0
-	sta	RAM.GameDataInventory, x
	ina								; increment item no. #
	inx
	inx
	cpx	#32							; 16 items for now
	bne	-

	Accu8
	SetTextPos	2, 2

	ldx	#0

@ReadItemFromInventory:
	lda	RAM.GameDataInventory, x				; read item no.
	xba
	inx
	lda	RAM.GameDataInventory, x				; read quantity
	bne	+
	inx								; if zero, read next item (256 max.)
	cpx	#512
	beq	@ReadItemFromInventoryDone
	bra	@ReadItemFromInventory

+	sta	LO8.GameDataItemQty					; (unnecessary, but whatever)
	xba

	Accu16

	and	#$00FF							; clear high byte
	lsh	4							; item no. × 16 (16 characters per item name)
	clc
	adc	#STR_ItemsENG						; add offset of item names table
	sta	<DP2.TextStringPtr

	Accu8

	lda	#:STR_ItemsENG
	sta	<DP2.TextStringBank
	phx								; preserve item index

@RenderItem:
	lda	#16
	sta	<DP2.HiResPrintLen
	jsr	PrintHiResFixedLenFWF

	Accu16

	lda	<DP2.TextCursor
	clc
	adc	#24 * 2
	sta	<DP2.TextCursor

	Accu8

	plx								; restore item index
	inx
	cpx	#512							; read next item (256 max.)
	bne	@ReadItemFromInventory

@ReadItemFromInventoryDone:

/*	SetTextPos	2, 16

	ldx	#STR_MainMenuENG000
	stx	<DP2.TextStringPtr
	lda	#:STR_MainMenuENG000
	sta	<DP2.TextStringBank

	ldy	#0
-	lda	[<DP2.TextStringPtr], y
	beq	+
	asl	a							; double char no. because font tiles were "expanded" for hi-res mode
	ina								; increment char no. because Mode 5 BG2 font tiles sit on the "right"
	jsr	FillTextBufferMode5

	iny
	bra	-
+
*/
	lda	#kBG1Tilemap1|kBG2Tilemap1				; update BG1/2 tilemaps
	tsb	<DP2.DMA_Updates
;	lda	#%00001000						; enable HDMA channel 3 (color math)
;	tsb	<DP2.HDMA_Channels

;	wait	"frames", 4

	lda	#kINIDISP_15						; turn screen back on
	sta	RAM_INIDISP

-	bra	-							; trap loop



; --------------------------------------------------------------------------------------------------

.ENDASM

LoadMenuCharPortraits:
	ldx	#$01C0
	lda	#$02
-	sta	RAM.BG1Tilemap1, x
	inx
	ina
	ina
	cmp	#$0C
	bne	-

	ldx	#$01E0
	lda	#$12
-	sta	RAM.BG1Tilemap1, x
	inx
	ina
	ina
	cmp	#$1C
	bne	-

	ldx	#$0200
	lda	#$22
-	sta	RAM.BG1Tilemap1, x
	inx
	ina
	ina
	cmp	#$2C
	bne	-

	ldx	#$0220
	lda	#$32
-	sta	RAM.BG1Tilemap1, x
	inx
	ina
	ina
	cmp	#$3C
	bne	-

	ldx	#$0240
	lda	#$42
-	sta	RAM.BG1Tilemap1, x
	inx
	ina
	ina
	cmp	#$4C
	bne	-

	ldx	#$0260
	lda	#$52
-	sta	RAM.BG1Tilemap1, x
	inx
	ina
	ina
	cmp	#$5C
	bne	-

	rts

.ASM



; EOF
