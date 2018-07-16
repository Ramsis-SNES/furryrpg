;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** IRQ & NMI HANDLERS ***
;
;==========================================================================================



; ************************ Vblank/NMI routines *************************

Vblank_Area:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- update text box
	lda	DP_TextBoxCharPortrait					; check for "change character portrait" flag
	bpl	+
	jsr	UpdateCharPortrait

+	lda	DP_TextBoxBG						; check if text box background change requested
	bpl	+
	jsr	LoadTextBoxBG						; bit 7 set --> load new background color table

+	lda	DP_TextBoxStatus					; check text box status
	bpl	+
	jsr	ClearTextBox						; bit 7 set --> wipe text

	jmp	__SkipRefreshes3					; ... and skip BG refreshes (to avoid glitches due to premature end of Vblank)

+	bit	#%00000001						; VWF buffer full?
	beq	__TextBoxVblankDone
	jsr	VWFTileBufferFull

__TextBoxVblankDone:



; -------------------------- update HUD if necessary
	bit	DP_HUD_Status						; check HUD status
	bmi	__ShowHUD
	bvs	__HideHUD
	jmp	__UpdateHUDDone

__ShowHUD:
	Accu16								; take care about "text box" sprites

	lda	DP_HUD_TextBoxSize
	and	#$00FF							; remove garbage in high byte
	inc	a							; +1 for right edge of "text box" frame
	tay

	Accu8

	lda	DP_HUD_Ypos
	and	#%11111100						; make value divisable by 4 so rising values in DP_HUD_Ypos will always be the same
	clc								; DP_HUD_Ypos += 4 (HUD appears 4 times as fast as it disappears)
	adc	#4
	sta	DP_HUD_Ypos
	ldx	#1							; start at Y value
-	sta	ARRAY_SpriteBuf1.HUD_TextBox, x
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
	ldx	#1							; start at Y value
-	sta	ARRAY_SpriteBuf1.Text, x
	inx
	inx
	inx
	inx
	dey								; all font sprites done?
	bne	-

	lda	DP_HUD_Ypos						; final Y value reached?
	cmp	#PARAM_HUD_Yvisible
	bne	__UpdateHUDDone
	lda	DP_HUD_Status
	ora	#%00000001						; yes, set "HUD is being displayed" bit
	and	#%01111111						; clear "HUD should appear" bit
	sta	DP_HUD_Status
	stz	DP_HUD_DispCounter					; and reset display counter values
	stz	DP_HUD_DispCounter+1
	bra	__UpdateHUDDone

__HideHUD:
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
	bra	__UpdateHUDDone

+	ldx	#1							; start at Y value
-	sta	ARRAY_SpriteBuf1.HUD_TextBox, x
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
	ldx	#1							; start at Y value
-	sta	ARRAY_SpriteBuf1.Text, x
	inx
	inx
	inx
	inx
	dey								; all font sprites done?
	bne	-

__UpdateHUDDone:



; -------------------------- animate playable character
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_SpriteTiles+$800				; set VRAM address for sprite tiles, skip sprite font
	stx	REG_VMADDL
	lda	DP_Char1SpriteStatus
	and	#%00000111						; isolate direction parameter
	sta	REG_WRMPYA
	lda	#$08							; multiply direction with #$0800 (2048) to get offset for upcoming DMA
	sta	REG_WRMPYB

	Accu16								; 3 cycles

	lda	REG_RDMPYL						; 5 cycles (4 + 1 for 16-bit Accu)
	xba
	clc
	adc	#(GFX_Spritesheet_Char1 & $FFFF)
	sta	$4302							; data offset

	Accu8

	lda	#$01							; DMA mode
 	sta	$4300
	lda	#$18							; B bus register ($2118)
	sta	$4301
	lda	#:GFX_Spritesheet_Char1					; data bank
	sta	$4304
	ldx	#2048							; data length
	stx	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	lda	DP_Char1SpriteStatus
	bpl	__Char1IsWalking					; bit 7 set = idle

	stz	DP_Char1FrameCounter					; char is idle, reset frame counter
	lda	#TBL_Char1_frame00

	bra	__Char1WalkingDone

__Char1IsWalking:
	lda	DP_Char1FrameCounter					; 0-9: frame 1, 10-19: frame 0, 20-29: frame 2, 30-39: frame 0
	cmp	#40
	bcc	+
	stz	DP_Char1FrameCounter					; reset frame counter
	bra	__Char1Frame1

+	cmp	#30
	bcs	__Char1Frame0

	cmp	#20
	bcs	__Char1Frame2

	cmp	#10
	bcc	__Char1Frame1

__Char1Frame0:
	lda	#TBL_Char1_frame00
	bra	+

__Char1Frame2:
	lda	#TBL_Char1_frame02
	bra	+

__Char1Frame1:
	lda	#TBL_Char1_frame01
;	bra	+

+	inc	DP_Char1FrameCounter					; increment animation frame counter

__Char1WalkingDone:
	asl	a							; frame no. × 2 for correct tile no. in spritesheet

	Accu16

	and	#$00FF							; remove garbage bits
	ora	#$2200							; add sprite priority, use palette no. 1
	clc
	adc	#$0080							; skip $80 tiles = sprite font
	sta	ARRAY_SpriteBuf1.PlayableChar+2				; tile no. (upper half of body)
	clc
	adc	#$0020
	sta	ARRAY_SpriteBuf1.PlayableChar+6				; tile no. (lower half of body = upper half + 2 rows of 16 tiles)

	lda	DP_Char1ScreenPosYX
	sta	ARRAY_SpriteBuf1.PlayableChar
	clc
	adc	#$1000							; Y += 10
	sta	ARRAY_SpriteBuf1.PlayableChar+4

	Accu8

	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544

;	lda	#$80							; set OAM Priority Rotation flag
;	sta	REG_OAMADDH
;	lda	#36							; obj. no. with lowest priority (reserved area)
;	asl	a							; shift to bits 1-7
;	sta	REG_OAMADDL



__SkipRefreshes3:



; -------------------------- update registers
	jsl	RAM_Code.UpdatePPURegs

	lda	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN



; -------------------------- misc. tasks
	jsr	GetInput

	lda	ARRAY_HDMA_BG_Scroll+1					; BG1 horizontal scroll
	sta	REG_BG1HOFS
	lda	ARRAY_HDMA_BG_Scroll+2
	sta	REG_BG1HOFS
	lda	ARRAY_HDMA_BG_Scroll+1					; BG2 horizontal scroll
	sta	REG_BG2HOFS
	lda	ARRAY_HDMA_BG_Scroll+2
	sta	REG_BG2HOFS
	lda	ARRAY_HDMA_BG_Scroll+3					; BG1 vertical scroll
	sta	REG_BG1VOFS
	lda	ARRAY_HDMA_BG_Scroll+4
	sta	REG_BG1VOFS
	lda	ARRAY_HDMA_BG_Scroll+3					; BG2 vertical scroll
	sta	REG_BG2VOFS
	lda	ARRAY_HDMA_BG_Scroll+4
	sta	REG_BG2VOFS
;	lda	#$FF							; never mind, HDMA takes care of BG3 vertical scroll
;	sta	REG_BG3VOFS
;	stz	REG_BG3VOFS
	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_DebugMenu:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime
	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



; -------------------------- update registers
	jsl	RAM_Code.UpdatePPURegs



; -------------------------- misc. tasks
	jsr	GetInput

	lda	#$FF							; BG3 vertical scroll
	sta	REG_BG3VOFS
	stz	REG_BG3VOFS
	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN

	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Error:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8



; -------------------------- refresh BG3 (low tilemap bytes)
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118
	ldx	#ADDR_VRAM_BG3_TileMap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMap, $18, 1024



; -------------------------- refresh BG3 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_TileMap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMapHi, $19, 1024



; -------------------------- misc. tasks
	jsr	GetInput

	stz	REG_BG3HOFS						; reset BG3 horizontal scroll
	stz	REG_BG3HOFS
	lda	#$FF							; set BG3 vertical scroll = -1
	sta	REG_BG3VOFS
	stz	REG_BG3VOFS

	stz	REG_HDMAEN						; disable HDMA
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Intro:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8



; -------------------------- refresh sprites
;	stz	REG_OAMADDL						; reset OAM address
;	stz	REG_OAMADDH

;	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



; -------------------------- update registers
	jsl	RAM_Code.UpdatePPURegs



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Minimal:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsl	RAM_Code.UpdatePPURegs
	jsr	GetInput

	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Mode7:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; set OAM address to 0
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



; -------------------------- Mode7
	Accu16

	lda	DP_Mode7_ScrollOffsetX
	lsr	a							; shift right for 13-bit value
	lsr	a
	lsr	a

	Accu8

	sta	REG_BG1HOFS						; BG1HOFS/M7HOFS
	xba
	sta	REG_BG1HOFS

	Accu16

	lda	DP_Mode7_ScrollOffsetY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	REG_BG1VOFS						; BG1VOFS/M7VOFS
	xba
	sta	REG_BG1VOFS

	Accu16

	lda	DP_Mode7_CenterCoordX
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	REG_M7X							; Mode 7 center position X register (low)
	xba
	sta	REG_M7X							; Mode 7 center position X register (high)

	Accu16

	lda	DP_Mode7_CenterCoordY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	REG_M7Y							; Mode 7 center position Y register (low)
	xba
	sta	REG_M7Y							; Mode 7 center position Y register (high)

; calculate table offset based on current altitude
	Accu16

	lda	#$01C0							; 224 scanlines (*2 as the table consists of word entries for each scanline)
	sec
	sbc	#PARAM_Mode7SkyLines*2					; subtract sky lines as those aren't present in the table

	Accu8

	sta	REG_M7A							; write low byte
	xba
	sta	REG_M7A							; write high byte
	lda	DP_Mode7_Altitude
	sta	REG_M7B

.IFDEF PrecalcMode7Tables
	Accu16

	lda	REG_MPYL						; (number of lines * 2) * altitude setting = table offset
	clc
	adc	#(SRC_Mode7Scaling & $FFFF)
	sta	DP_DataAddress

	Accu8
.ELSE
	ldx	REG_MPYL						; (number of lines * 2) * altitude setting = table offset
	stx	DP_DataAddress
.ENDIF

	lda	DP_Mode7_BG2HScroll
	sta	REG_BG2HOFS
	stz	REG_BG2HOFS



; -------------------------- update registers
	jsl	RAM_Code.UpdatePPURegs



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN

	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_WorldMap:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



; -------------------------- update registers
	jsl	RAM_Code.UpdatePPURegs

	lda	DP_WorldMapBG1HScroll					; update scroll regs/HDMA tables
	sta	REG_BG1HOFS
	lda	DP_WorldMapBG1HScroll+1
	and	#$3F							; limit value to $3FFF
	sta	REG_BG1HOFS

	ldx	#(ARRAY_ScratchSpace & $FFFF)				; copy over scroll displacement table to HDMA array
	ldy	#ARRAY_HDMA_WorMapVScroll
	lda	#$01							; $01BF = 447 (i.e., 448 bytes are transferred)
	xba
	lda	#$BF
	mvn	$00, $7E



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



; *************************** H-IRQ routines ***************************

.ACCU 8
.INDEX 16

HIRQ_XXX:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator

	; do something here

	lda	REG_TIMEUP						; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status
	rti



; *************************** V-IRQ routines ***************************

VIRQ_Area:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator
	lda	#$05							; switch to BG Mode 5 for text box
	sta	REG_BGMODE
	lda	#$78							; BG1 tile map VRAM offset: $7800, Tile Map size: 32×32 tiles
	sta	REG_BG1SC
	lda	#$7C							; BG2 tile map VRAM offset: $7C00, Tile Map size: 32×32 tiles
	sta	REG_BG2SC
	lda	VAR_TextBox_TSTM					; write Main/Subscreen designation regs
	sta	REG_TM
	lda	VAR_TextBox_TSTM+1
	sta	REG_TS
	lda	REG_TIMEUP						; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status
	rti



VIRQ_Mode7:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator
	lda	#$07							; switch to BG Mode 7
	sta	REG_BGMODE
	lda	#%00010001						; turn on BG1 and sprites only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen
	lda	REG_TIMEUP						; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status
	rti



; ************************* Common subroutines *************************

.ACCU 8
.INDEX 16

GetInput:
	php
	lda	#$01
-	bit	REG_HVBJOY
	bne	-							; wait till automatic JoyPort read is complete

	AccuIndex16



; -------------------------- read joypad 1
	lda	DP_Joy1
	sta	DP_Joy1Old
	lda	DP_GameMode
	and	#%0000000010000000					; check if auto-mode is enabled
	beq	+
	lda	DP_AutoJoy1						; yes, load simulated joypad
	bra	++
+	lda	REG_JOY1L						; otherwise, get JoyPad1
++	tax
	eor	DP_Joy1							; A = A xor JoyState = (changes in joy state)
	stx	DP_Joy1							; update JoyState
	ora	DP_Joy1Press						; A = (joy changes) or (buttons pressed)
	and	DP_Joy1							; A = ((joy changes) or (buttons pressed)) and (current joy state)
	sta	DP_Joy1Press						; store A = (buttons pressed since last clearing reg) and (button is still down)
	lda	DP_Joy1Old
	eor	#$FFFF
	and	DP_Joy1
	sta	DP_Joy1New



; -------------------------- read joypad 2
	lda	DP_Joy2
	sta	DP_Joy2Old
	lda	DP_GameMode
	and	#%0000000010000000					; check if auto-mode is enabled
	beq	+
	lda	DP_AutoJoy2						; yes, load simulated joypad
	bra	++
+	lda	REG_JOY2L						; get JoyPad2
++	tax
	eor	DP_Joy2							; A = A xor JoyState = (changes in joy state)
	stx	DP_Joy2							; update JoyState
	ora	DP_Joy2Press						; A = (joy changes) or (buttons pressed)
	and	DP_Joy2							; A = ((joy changes) or (buttons pressed)) and (current joy state)
	sta	DP_Joy2Press						; store A = (buttons pressed since last clearing reg) and (button is still down)
	lda	DP_Joy2Old
	eor	#$FFFF
	and	DP_Joy2
	sta	DP_Joy2New



; -------------------------- make sure Joypads 1, 2 are valid
	lda	DP_GameMode
	and	#%0000000010000000					; check if auto-mode is enabled
	bne	_done							; yes, jump out

	AccuIndex8

	lda	REG_JOYA
	eor	#$01
	and	#$01							; A = -bit0 of JOYA
	ora	DP_Joy1
	sta	DP_Joy1							; joy state = (joy state) or A.... so bit0 of Joy1State = 0 only if it is a valid joypad

	lda	REG_JOYB
	eor	#$01
	and	#$01							; A = -bit0 of JOYB
	ora	DP_Joy2
	sta	DP_Joy2							; joy state = (joy state) or A.... so bit0 of Joy1State = 0 only if it is a valid joypad



; -------------------------- change all invalid joypads to have a state of no button presses
	AccuIndex16

	ldx	#$0001
	lda	#$000F
	bit	DP_Joy1							; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	_joy2							; into the joy port, or it is not a joypad
	stx	DP_Joy1							; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	DP_Joy1Press

_joy2:
	bit	DP_Joy2							; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	_done							; into the joy port, or it is not a joypad
	stx	DP_Joy2							; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	DP_Joy2Press

_done:
	plp
	rts



.ACCU 8
.INDEX 16



RefreshBGs:								; refresh BGs according to DP_DMA_Updates
	ldy	#4							; DMA counter, do max. 4 DMAs per Vblank
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118



; -------------------------- check/refresh BG1 (low tilemap bytes)
	lda	DP_DMA_Updates
	and	#%00000001						; check for 1st BG1 tile map (low bytes)
	beq	+
	ldx	#ADDR_VRAM_BG1_TileMap1					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap1, $18, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	DP_DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone

+	lda	DP_DMA_Updates
	and	#%00000010						; check for 2nd BG1 tile map (low bytes)
	beq	+
	ldx	#ADDR_VRAM_BG1_TileMap2					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap2, $18, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	DP_DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone



; -------------------------- check/refresh BG2 (low tilemap bytes)
+	lda	DP_DMA_Updates
	and	#%00000100						; check for 1st BG2 tile map (low bytes)
	beq	+
	ldx	#ADDR_VRAM_BG2_TileMap1					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap1, $18, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	DP_DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone

+	lda	DP_DMA_Updates
	and	#%00001000						; check for 2nd BG2 tile map (low bytes)
	beq	+
	ldx	#ADDR_VRAM_BG2_TileMap2					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap2, $18, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	DP_DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone



; -------------------------- check/refresh BG3 (low tilemap bytes)
+	lda	DP_DMA_Updates
	and	#%00010000						; check for BG3 tile map (low bytes)
	beq	+
	ldx	#ADDR_VRAM_BG3_TileMap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMap, $18, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	DP_DMA_Updates
	dey
	bne	+
	jmp	__DMAUpdatesDone

+	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN



; -------------------------- check/refresh BG1 (high tilemap bytes)
	lda	DP_DMA_Updates+1
	and	#%00000001						; check for 1st BG1 tile map (high bytes)
	beq	+
	ldx	#ADDR_VRAM_BG1_TileMap1					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap1Hi, $19, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	DP_DMA_Updates+1
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone

+	lda	DP_DMA_Updates+1
	and	#%00000010						; check for 2nd BG1 tile map (high bytes)
	beq	+
	ldx	#ADDR_VRAM_BG1_TileMap2					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap2Hi, $19, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	DP_DMA_Updates+1
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone



; -------------------------- check/refresh BG2 (high tilemap bytes)
+	lda	DP_DMA_Updates+1
	and	#%00000100						; check for 1st BG2 tile map (high bytes)
	beq	+
	ldx	#ADDR_VRAM_BG2_TileMap1					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap1Hi, $19, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	DP_DMA_Updates+1
	dey								; decrement DMA counter
	bne	+
	jmp	__DMAUpdatesDone

+	lda	DP_DMA_Updates+1
	and	#%00001000						; check for 2nd BG2 tile map (high bytes)
	beq	+
	ldx	#ADDR_VRAM_BG2_TileMap2					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap2Hi, $19, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	DP_DMA_Updates+1
	dey								; decrement DMA counter
	beq	__DMAUpdatesDone



; -------------------------- check/refresh BG3 (high tilemap bytes)
+	lda	DP_DMA_Updates+1
	and	#%00010000						; check for BG3 tile map (high bytes)
	beq	__DMAUpdatesDone

	ldx	#ADDR_VRAM_BG3_TileMap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMapHi, $19, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	DP_DMA_Updates+1

__DMAUpdatesDone:
	rts



UpdateCharPortrait:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_Portrait					; set VRAM address to char portrait
	stx	REG_VMADDL
	lda	#ADDR_CGRAM_Portrait					; set CGRAM address for character portrait
	sta	REG_CGADD

	lda	DP_TextBoxCharPortrait
	and	#$7F							; check for portrait no., 0 = no portrait
	bne	+

	DMA_CH0 $09, :CONST_FFs, CONST_FFs, $18, 1920			; no portrait wanted, so put masking tiles over portrait
	DMA_CH0 $0A, :CONST_Zeroes, CONST_Zeroes, $22, 32		; and zero out palette

	bra	__CharPortraitUpdated

+	Accu16								; portrait no. in A

	and	#$00FF							; remove garbage in high byte
	asl	a
	tax								; make portrait no. = index in GFX offset table
	lda.l	SRC_CharPortaitGFXTable, x
	sta	$4302							; data offset
	ldy	#$1801							; low byte: DMA mode, high byte: B bus register ($2118/VMDATA)
 	sty	$4300

	Accu8

	lda	#:GFX_Portrait_Char1					; data bank (all portraits need to be in the same bank)
	sta	$4304
	ldy	#1920							; data length
	sty	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	Accu16

	lda.l	SRC_CharPortaitPaletteTable, x				; index is still in X, use that for correct palette
	sta	$4302							; data offset
	ldx	#$2202							; low byte: DMA mode, high byte: B bus register ($2122/CGDATA)
 	stx	$4300

	Accu8

	lda	#:SRC_Palette_Portrait_Char1				; data bank (all portrait palettes need to be in the same bank)
	sta	$4304
	ldx	#32							; data length (16 colors)
	stx	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

__CharPortraitUpdated:
	lda	#%10000000						; portrait updated, clear request flag
	trb	DP_TextBoxCharPortrait
	rts



UpdateGameTime:
	sed								; decimal mode on

	clc
	lda	DP_GameTimeSeconds
	adc	#$01
	sta	DP_GameTimeSeconds
	cmp	#$60							; check if 60 frames = game time seconds have elapsed
	bcc	__GameTimeUpdateMinutes

	stz	DP_GameTimeSeconds					; carry bit set, reset seconds

__GameTimeUpdateMinutes:
	lda	DP_GameTimeMinutes					; increment minutes via carry bit
	adc	#$00
	sta	DP_GameTimeMinutes
	cmp	#$60							; check if 60 seconds have elapsed
	bcc	__GameTimeUpdateHours

	stz	DP_GameTimeMinutes					; carry bit set, reset minutes

__GameTimeUpdateHours:
	lda	DP_GameTimeHours					; increment hours via carry bit
	adc	#$00
	sta	DP_GameTimeHours
	cmp	#$24							; check if 24 hours have elapsed
	bcc	__GameTimeUpdateDone

	stz	DP_GameTimeHours					; carry bit set, reset hours

__GameTimeUpdateDone:
	cld								; decimal mode off
	rts



; ************************** Software Errors ***************************

ErrorHandlerBRK:
	AccuIndex16

	pha								; preserve registers
	phx
	phy

	Accu8

	lda	#$80							; enter forced blank
	sta.l	REG_INIDISP

	DisableIRQs

.IFNDEF NOMUSIC
	jsl	sound_stop_all
.ENDIF

	Accu16

	SetDPag	$0000

	Accu8

	SetDBR	$00

	stz	REG_HDMAEN						; disable HDMA



; -------------------------- clear BG3 tilemap buffer
	ldx	#(ARRAY_BG3TileMap & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048



; -------------------------- 8x8 font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Font8x8, GFX_Font8x8, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-



; -------------------------- font palette --> CGRAM
	stz	REG_CGADD						; reset CGRAM address
	stz	REG_CGDATA						; set mainscreen bg color: blue
	lda	#$70
	sta	REG_CGDATA
	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	REG_CGDATA
	inx
	cpx	#8
	bne	-



; -------------------------- register updates
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE
	lda	#$48							; BG3 tile map VRAM offset: $4800, Tile Map size: 32×32 tiles
	sta	REG_BG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#%00000100						; turn on BG3 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	PrintString	3, 2, "An error occurred!"
	PrintString	5, 2, "Error type: BRK"
	PrintString	6, 2, "Error address: $"

	lda	10, s
	sta	temp

	PrintHexNum	temp

	lda	9, s
	sta	temp

	PrintHexNum	temp

	lda	8, s
	sta	temp

	PrintHexNum	temp
	PrintString	7, 2, "Status register: $"

	lda	7, s
	sta	temp

	PrintHexNum	temp
	PrintString	9, 2, "Accuml.: $"

	lda	6, s
	sta	temp

	PrintHexNum	temp

	lda	5, s
	sta	temp

	PrintHexNum	temp
	PrintString	10, 2, "X index: $"

	lda	4, s
	sta	temp

	PrintHexNum	temp

	lda	3, s
	sta	temp

	PrintHexNum	temp
	PrintString	11, 2, "Y index: $"

	lda	2, s
	sta	temp

	PrintHexNum	temp

	lda	1, s
	sta	temp

	PrintHexNum	temp

	SetNMI	TBL_NMI_Error

	lda	REG_RDNMI						; clear NMI flag
	cli								; reenable interrupts
	lda	#$81
	sta	REG_NMITIMEN
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	Freeze								; enter trap loop instead of RTI



ErrorHandlerCOP:
	AccuIndex16

	pha								; preserve registers
	phx
	phy

	Accu8

	lda	#$80							; enter forced blank
	sta.l	REG_INIDISP

	DisableIRQs

.IFNDEF NOMUSIC
	jsl	sound_stop_all
.ENDIF

	Accu16

	SetDPag	$0000

	Accu8

	SetDBR	$00

	stz	REG_HDMAEN						; disable HDMA



; -------------------------- clear BG3 tilemap buffer
	ldx	#(ARRAY_BG3TileMap & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048



; -------------------------- 8x8 font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Font8x8, GFX_Font8x8, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-



; -------------------------- font palette --> CGRAM
	stz	REG_CGADD						; reset CGRAM address
	lda	#$1C							; set mainscreen bg color: red
	sta	REG_CGDATA
	stz	REG_CGDATA
	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	REG_CGDATA
	inx
	cpx	#8
	bne	-



; -------------------------- register updates
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE
	lda	#$48							; BG3 tile map VRAM offset: $4800, Tile Map size: 32×32 tiles
	sta	REG_BG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#%00000100						; turn on BG3 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	PrintString	3, 2, "An error occurred!"
	PrintString	5, 2, "Error type: COP"
	PrintString	6, 2, "Error address: $"

	lda	10, s
	sta	temp

	PrintHexNum	temp

	lda	9, s
	sta	temp

	PrintHexNum	temp

	lda	8, s
	sta	temp

	PrintHexNum	temp
	PrintString	7, 2, "Status register: $"

	lda	7, s
	sta	temp

	PrintHexNum	temp
	PrintString	9, 2, "Accuml.: $"

	lda	6, s
	sta	temp

	PrintHexNum	temp

	lda	5, s
	sta	temp

	PrintHexNum	temp
	PrintString	10, 2, "X index: $"

	lda	4, s
	sta	temp

	PrintHexNum	temp

	lda	3, s
	sta	temp

	PrintHexNum	temp
	PrintString	11, 2, "Y index: $"

	lda	2, s
	sta	temp

	PrintHexNum	temp

	lda	1, s
	sta	temp

	PrintHexNum	temp

	SetNMI	TBL_NMI_Error

	lda	REG_RDNMI						; clear NMI flag
	cli								; reenable interrupts
	lda	#$81
	sta	REG_NMITIMEN
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	Freeze								; enter trap loop instead of RTI



; ******************************** EOF *********************************
