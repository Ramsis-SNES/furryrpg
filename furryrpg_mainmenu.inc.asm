;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** MAIN MENU ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

MainMenu:
	DrawFrame 10, 9, 11, 7
	PrintString 10, 11, "Inventory"
	PrintString 11, 11, "Talent"
	PrintString 12, 11, "Formation"
	PrintString 13, 11, "Lily's log"
	PrintString 14, 11, "Settings"
	PrintString 15, 11, "Quit game"



; -------------------------- menu "window" color
	ldx	#$0000

-	lda.l	SRC_HDMA_ColMathMenu, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#SRC_HDMA_ColMathMenu_End-SRC_HDMA_ColMathMenu
	bne	-

	lda	#%00010000			; set color math enable bits (4-5) to "MathWindow"
	sta	$2130

	lda	#%00010111			; enable color math on BG1/2/3 + sprites
	sta	$2131

	lda	#86				; color "window" left pos
	sta	$2126

	lda	#169				; color "window" right pos
	sta	$2127

	lda	#%00100000			; color math window 1 area = outside (why does this work??)
	sta	$2125

	lda	#%00001000			; enable HDMA channel 3 (color math)
	tsb	DP_HDMAchannels

	A16
	lda	#%0001000000000111		; mainscreen : BG1/2/3, subscreen : sprites (i.e., sprites will disappear as $2130.1 is clear)
	sta	DP_Shadow_TSTM
	A8



MainMenuLoop:
	WaitForFrames 1

;	SetTextPos 2, 25
;	PrintHexNum DP_GameTime_Hours
;	PrintString 2, 27, ":"
;	PrintHexNum DP_GameTime_Minutes



; -------------------------- check for dpad up
	lda	Joy1New+1
	and	#%00001000
	beq	++

	lda	ARRAY_HDMA_ColorMath+0		; first byte of color math HDMA table = no. of scanlines above color bar
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

	lda	ARRAY_HDMA_ColorMath+0		; first byte of color math HDMA table = no. of scanlines above color bar
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

	lda	#%00000100			; mosaic on BG3

-	sta	$2106

	wai

	clc
	adc	#$10
	cmp	#$64
	bne	-

-	sta	$2106

	wai

	sec
	sbc	#$10
	cmp	#$04
	bne	-

	stz	$2106

/*	lda	ARRAY_HDMA_ColorMath+0
	cmp	#80
	bne	+

	ldx	#(TileMapBG3 & $FFFF)		; clear text
	stx	$2181
	stz	$2183

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

+	jmp	MusicTest			; else, selection bar must be on the bottom
*/

++



; -------------------------- check for B button = back
	lda	Joy1New+1
	and	#%10000000
	bne	+

	jmp	++

+	PrintString 9, 10, "             "
	PrintString 10, 10, "             "
	PrintString 11, 10, "             "
	PrintString 12, 10, "             "
	PrintString 13, 10, "             "
	PrintString 14, 10, "             "
	PrintString 15, 10, "             "
	PrintString 16, 10, "             "


	lda	#%00110000			; disable color math
	sta	$2130
	stz	$2125				; disable color math window

	lda	#%00001000			; disable HDMA channel 3 (color math)
	trb	DP_HDMAchannels

	A16
	lda	#%0001000000010000		; re-enable sprites
	tsb	DP_Shadow_TSTM
	A8

	jmp	MainAreaLoop

++



; -------------------------- check for Start
;	lda	Joy1New+1
;	and	#%00010000
;	beq	+

;	WaitForUserInput

;+

	jmp	MainMenuLoop



; ***************************** Main menu ******************************

InGameMenu:
	lda	#$80				; INIDISP (Display Control 1): forced blank
	sta	$2100

	stz	DP_HDMAchannels			; disable HDMA

	wai					; wait

	DisableInterrupts



; -------------------------- clear tilemap buffers, init sprites
	ldx	#(TileMapBG1 & $FFFF)
	stx	$2181
	stz	$2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024*6

	jsr	SpriteInit			; FIXME, sprite #0 isn't empty on menu sprites



; -------------------------- clear VRAM
	lda	#$80				; VRAM address increment mode: increment address by one word
	sta	$2115				; after accessing the high byte ($2119)

	stz	$2116				; regs $2116-$2117: VRAM address
	stz	$2117

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0	; clear VRAM



; -------------------------- load menu GFX
	ldx	#ADDR_VRAM_BG1_Tiles		; set VRAM address for BG1 tiles
	stx	$2116

	DMA_CH0 $01, :GFX_Logo, GFX_Logo, $18, 8000

	ldx	#(TileMapBG1 & $FFFF)
	stx	$2181
	stz	$2183

	DMA_CH0 $00, :SRC_Tilemap_Logo, SRC_Tilemap_Logo, $80, 1024

	ldx	#ADDR_VRAM_SPR_Tiles		; set VRAM address for sprite tiles
	stx	$2116

	DMA_CH0 $01, :GFX_Sprites_InGameMenu, GFX_Sprites_InGameMenu, $18, 8192

	ldx	#ADDR_VRAM_BG3_Tiles
	stx	$2116

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20				; priority bit
-	sta	TileMapBG3Hi, x			; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- palettes --> CGRAM
	stz	$2121				; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda	#ADDR_CGRAM_AREA		; set CGRAM address for BG1 tiles palette
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Logo, SRC_Palette_Logo, $22, 32

	lda	#ADDR_CGRAM_AREA		; palette no. = CGRAM address RSH 2
	lsr	a
	lsr	a

	ldx	#0
-	sta	TileMapBG1Hi, x			; store palette no.
	inx
	cpx	#1024
	bne	-

	lda	#$80				; set CGRAM address to #256 (word address) for sprites
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Sprites_InGameMenu, SRC_Palette_Sprites_InGameMenu, $22, 32

	lda	#%01110111			; make sure BG1/2/3 lo/hi tilemaps get updated once NMI is reenabled
	tsb	DP_DMAUpdates

	SetVblankRoutine TBL_NMI_DebugMenu

	lda	REG_RDNMI			; clear NMI flag
	lda	#$81				; reenable NMI & IRQ
	sta	REG_NMITIMEN
	cli

	WaitForFrames 5				; wait for tilemaps to get updated



; -------------------------- set up menu BG color & misc. screen registers
	lda	#%01100011			; 16×16 (small) / 32×32 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	$2101

	A16
	lda	#%0001011100010111		; turn on BG1/2/3 & sprites on mainscreen and	subscreen
	sta	$212C
	sta	DP_Shadow_TSTM			; copy to shadow variable (not yet used)
	A8

	ldx	#0
-	lda.l	SRC_HDMA_ColMathMainMenu, x
	sta	ARRAY_HDMA_ColorMath, x

	inx
	cpx	#SRC_HDMA_ColMathMainMenu_End-SRC_HDMA_ColMathMainMenu
	bne	-

	stz	$2130				; clear color math disable bits

	lda	#%00100001			; enable color math on BG1 + backdrop
	sta	$2131

	lda	#%00001000			; enable HDMA channels 3 (color math)
	tsb	DP_HDMAchannels



; -------------------------- ring menu sprites
	lda	#PARAM_RingMenuCenterX-16	; X (subtract half of sprite width)
	sta	SpriteBuf1.RingMenuCursor

	lda	#PARAM_RingMenuCenterY-PARAM_RingMenuRadius	; Y (subtract radius)
	sta	SpriteBuf1.RingMenuCursor+1

	lda	#$80				; tile num (cursor sprite)
	sta	SpriteBuf1.RingMenuCursor+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuCursor+3

	lda	#$00				; tile num ("Inventory" sprite)
	sta	SpriteBuf1.RingMenuItem1+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem1+3

	lda	#$04				; tile num ("Talent" sprite)
	sta	SpriteBuf1.RingMenuItem2+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem2+3

	lda	#$08				; tile num ("Party" sprite)
	sta	SpriteBuf1.RingMenuItem3+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem3+3

	lda	#$0C				; tile num ("Lily's log" sprite)
	sta	SpriteBuf1.RingMenuItem4+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem4+3

	lda	#$40				; tile num ("Settings" sprite)
	sta	SpriteBuf1.RingMenuItem5+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem5+3

	lda	#$44				; tile num ("Quit Game" sprite)
	sta	SpriteBuf1.RingMenuItem6+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem6+3

	lda	#$48				; tile num (1st "??" sprite)
	sta	SpriteBuf1.RingMenuItem7+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem7+3

	lda	#$4C				; tile num (2nd "??" sprite)
	sta	SpriteBuf1.RingMenuItem8+2

	lda	#%00110000			; attributes (tile num & priority bits only)
	sta	SpriteBuf1.RingMenuItem8+3

	lda	#$80				; set angle for cursor & 1st item on ring menu ($80 = 12:00 o'clock)
	sta	DP_RingMenuAngle
	stz	DP_RingMenuAngle+1

	jsr	PutRingMenuItems

	DrawFrame 7, 1, 17, 2



.ENDASM

; -------------------------- menu "window" content
	DrawFrame 1, 1, 13, 12
	PrintString 2, 2, "Gengen"
	PrintString 3, 2, "9999/9999 HP"
	PrintString 4, 2, "9999/9999 EP"
	PrintString 6, 5, "Warrior"
	PrintString 7, 5, "Healthy"

	DrawFrame 17, 1, 13, 12
	PrintString 2, 18, "Lily"
	PrintString 3, 18, "9999/9999 HP"
	PrintString 4, 18, "9999/9999 EP"
	PrintString 6, 21, "Scholar"
	PrintString 7, 21, "Healthy"

	DrawFrame 1, 15, 13, 12
	PrintString 16, 2, "Mickey"
	PrintString 17, 2, "9999/9999 HP"
	PrintString 18, 2, "9999/9999 EP"
	PrintString 20, 5, "M. artist"
	PrintString 21, 5, "Healthy"

	DrawFrame 17, 15, 13, 12
	PrintString 16, 18, "Tara"
	PrintString 17, 18, "9999/9999 HP"
	PrintString 18, 18, "9999/9999 EP"
	PrintString 20, 21, "Healer"
	PrintString 21, 21, "Healthy"

;	A16
;	lda	#$3008				; set char 1 position
;	sta	DP_Char1PosYX
;	A8

.ASM

	lda	#$0F
	sta	$2100

RingMenuLoop:
	wai



; -------------------------- check for dpad left
	lda	Joy1Press+1
	and	#%00000010
	beq	__RingMenuLoopDpadLeftDone

	ldy	#$0020				; change angle 32 times
-	wai
	dec	DP_RingMenuAngle		; dec angle --> rotate clockwise
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
	inc	DP_RingMenuAngle		; inc	angle --> rotate counter-clockwise
	inc	DP_RingMenuAngle
	jsr	PutRingMenuItems
	dey
	dey
	bne	-

__RingMenuLoopDpadRightDone:



; -------------------------- update headline based on angle
	lda	DP_RingMenuAngle
	bne	+

	PrintString 2, 8, "    Settings    "

	jmp	++

+	cmp	#$20
	bne	+

	PrintString 2, 8, "   Quit Game    "

	jmp	++

+	cmp	#$40
	bne	+

	PrintString 2, 8, "      ???1      "

	jmp	++

+	cmp	#$60
	bne	+

	PrintString 2, 8, "      ???2      "

	bra	++

+	cmp	#$80
	bne	+

	PrintString 2, 8, "   Inventory    "

	bra	++

+	cmp	#$A0
	bne	+

	PrintString 2, 8, "     Talent     "

	bra	++

+	cmp	#$C0
	bne	+

	PrintString 2, 8, "     Party      "

	bra	++

+	PrintString 2, 8, "   Lily's log   "
++

;.IFDEF DEBUG
;	PrintString 23, 2, "Angle: $"
;	PrintHexNum DP_RingMenuAngle
;.ENDIF

	lda	#%00000100			; make sure BG3 lo tilemap gets updated
	tsb	DP_DMAUpdates

	jmp	RingMenuLoop



PutRingMenuItems:
	lda	DP_RingMenuAngle		; take angle for 1st item on ring menu ($80 = 12:00 o'clock)
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem1	; set WRAM address for 1st item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 2nd item on ring menu ($60 = 1:30 o'clock)
	sec
	sbc	#$20
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem2	; set WRAM address for 2nd item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 3rd item on ring menu ($40 = 3:00 o'clock)
	sec
	sbc	#$40
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem3	; set WRAM address for 3rd item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 4th item on ring menu ($20 = 4:30 o'clock)
	sec
	sbc	#$60
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem4	; set WRAM address for 4th item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 5th item on ring menu ($00 = 6:00 o'clock)
	sec
	sbc	#$80
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem5	; set WRAM address for 5th item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 6th item on ring menu ($E0 = 7:30 o'clock)
	clc
	adc	#$60
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem6	; set WRAM address for 6th item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 7th item on ring menu ($C0 = 9:00 o'clock)
	clc
	adc	#$40
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem7	; set WRAM address for 7th item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos

	lda	DP_RingMenuAngle		; set angle for 8th item on ring menu ($A0 = 10:30 o'clock)
	clc
	adc	#$20
	sta	DP_RingMenuAngleOffset

	ldx	#SpriteBuf1.RingMenuItem8	; set WRAM address for 8th item on ring menu
	stx	$2181
	stz	$2183
	jsr	CalcRingMenuItemPos
rts



CalcRingMenuItemPos:

; X := CenterX + sin(angle)*radius
; Y := CenterY + cos(angle)*radius

	ldx	DP_RingMenuAngleOffset
	lda.l	SRC_Mode7Sin, x
	sta	$211B
	stz	$211B
	lda	#PARAM_RingMenuRadius
	sta	$211C
	lda	$2135
	clc
	adc	#PARAM_RingMenuCenterX-16	; subtract half of sprite width (as above)
	pha

	lda	DP_RingMenuAngleOffset
	cmp	#$81
	bcc	+

	pla					; if angle > $80, subtract radius
	sec
	sbc	#PARAM_RingMenuRadius
	pha

+	pla
	sta	$2180				; save X

	ldx	DP_RingMenuAngleOffset
	lda.l	SRC_Mode7Cos, x
	sta	$211B
	stz	$211B
	lda	#PARAM_RingMenuRadius
	sta	$211C
	lda	$2135
	clc
	adc	#PARAM_RingMenuCenterY-(PARAM_RingMenuRadius/2)	; subtract radius/2 (as above)
	pha

	lda	DP_RingMenuAngleOffset
	cmp	#$C0
	bcs	+
	cmp	#$41
	bcc	+

	pla					; if $40 < angle < $C0, subtract radius
	sec
	sbc	#PARAM_RingMenuRadius
	pha

+	pla
	sta	$2180				; save Y
rts



.ENDASM
	lda	#$80				; VRAM address increment mode: increment address by one word after accessing the high byte ($2119)
	sta	$2115

	ldx	#ADDR_VRAM_BG2_TILES + $480	; set VRAM address for BG2 font tiles
	stx	$2116

	ldx	#$04C0				; "L"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0650				; "e"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0660				; "f"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0740				; "t"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$03A0				; ":"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0200				; " "
	jsr	SaveTextBoxTileToVRAM

	ldx	#$04D0				; "M"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$06F0				; "o"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0640				; "d"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0650				; "e"
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0200				; " "
	jsr	SaveTextBoxTileToVRAM

	ldx	#$0350				; "5"
	jsr	SaveTextBoxTileToVRAM

	lda	#$90
	sta	TileMapBG2 + 163

	lda	#$92
	sta	TileMapBG2 + 164

	lda	#$94
	sta	TileMapBG2 + 165

	lda	#$96
	sta	TileMapBG2 + 195

	lda	#$98
	sta	TileMapBG2 + 196

	lda	#$9A
	sta	TileMapBG2 + 197

	PrintString 5, 14, "Right:"
	PrintString 6, 14, "Mode 1"



; -------------------------- set new IRQ vector
	SetIRQRoutine TBL_IRQ_MainMenu



; -------------------------- set up HDMA channel 5 for screen mode
	ldx	#SRC_HDMA_test5
	stx	$4352
	lda	#:SRC_HDMA_test5
	sta	$4354
	lda	#$05				; PPU reg. $2105 (screen mode)
	sta	$4351
	lda	#$00				; transfer mode (1 byte)
	sta	$4350

	lda	#%00100000			; enable HDMA channel 5 (temp screen mode)
	sta	DP_HDMAchannels

	lda	#$28				; H-IRQ setup: dot number for interrupt
	sta	$4207				; set low byte of H-timer
	stz	$4208				; set high byte of H-timer

	lda	#$91				; enable H-IRQ, NMI, and auto-joypad read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli

	lda	#%00000110			; turn on BG2/3
	sta	$212C				; on the mainscreen
	sta	$212D				; and	on the subscreen

	lda	#$0F				; turn screen back on
	sta	$2100

	WaitForUserInput

	lda	#$80				; enter forced blank
	sta	$2100

	stz	DP_HDMAchannels			; disable HDMA

	lda	#$81				; enable Vblank NMI + Auto Joypad Read (no H-IRQ any more)
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN

	wai					; wait for reg $420C to get cleared

	lda	#$01|$08			; set BG Mode 1 (BG3 priority)
	sta	$2105

	lda	#$00				; clear BG2 tilemap
	sta	TileMapBG2 + 163
	sta	TileMapBG2 + 164
	sta	TileMapBG2 + 165
	sta	TileMapBG2 + 195
	sta	TileMapBG2 + 196
	sta	TileMapBG2 + 197

;	lda	#$20				; set BG1's Character VRAM offset to $0000 (word address)
;	sta	$210B				; and BG2's Character VRAM offset to $2000 (word address)

	jml	DebugMenu



LoadMenuCharPortraits:
;	rep	#A_8BIT				; A = 16 bit

	ldx	#$01C0
	lda	#$02
-	sta	TileMapBG1, x
	inx
	inc	a
	inc	a
	cmp	#$0C
	bne	-

	ldx	#$01E0
	lda	#$12
-	sta	TileMapBG1, x
	inx
	inc	a
	inc	a
	cmp	#$1C
	bne	-

	ldx	#$0200
	lda	#$22
-	sta	TileMapBG1, x
	inx
	inc	a
	inc	a
	cmp	#$2C
	bne	-

	ldx	#$0220
	lda	#$32
-	sta	TileMapBG1, x
	inx
	inc	a
	inc	a
	cmp	#$3C
	bne	-

	ldx	#$0240
	lda	#$42
-	sta	TileMapBG1, x
	inx
	inc	a
	inc	a
	cmp	#$4C
	bne	-

	ldx	#$0260
	lda	#$52
-	sta	TileMapBG1, x
	inx
	inc	a
	inc	a
	cmp	#$5C
	bne	-

;	sep	#A_8BIT				; A = 8 bit
rts

.ASM



; ******************************** EOF *********************************
