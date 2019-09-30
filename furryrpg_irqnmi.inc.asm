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

	pha								; preserve 16 bit registers
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

+	bit	DP_TextBoxStatus					; check text box status
	bvs	@WaitOrDontClearTB					; bit 6 set --> wait for player input before e.g. clearing text box
	lda	DP_TextBoxStatus
	and	#%00000010
	beq	@WaitOrDontClearTB
	jsr	ClearTextBox						; bit 1 set and "wait" flag clear --> wipe text
	jmp	@SkipRefreshes						; ... and skip BG refreshes (to avoid glitches due to premature end of Vblank)

@WaitOrDontClearTB:
	lda	DP_TextBoxStatus
	and	#%00000001						; VWF buffer full?
	beq	@TextBoxDone
	jsr	FlushVWFTileBuffer

@TextBoxDone:



; -------------------------- animate playable character
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_SpriteTiles+$800				; set VRAM address for sprite tiles, skip sprite font
	stx	REG_VMADDL
	lda	DP_Hero1SpriteStatus
	and	#%00000111						; isolate direction parameter
	sta	REG_WRMPYA
	lda	#$08							; multiply direction with #$0800 (2048) to get offset for upcoming DMA
	sta	REG_WRMPYB

	Accu16								; 3 cycles

	lda	REG_RDMPYL						; 5 cycles (4 + 1 for 16-bit Accu)
	xba
	clc
	adc	#(GFX_Spritesheet_Hero1 & $FFFF)
	sta	REG_A1T0L						; data offset

	Accu8

	lda	#$01							; DMA mode
 	sta	REG_DMAP0
	lda	#$18							; B bus register ($2118)
	sta	REG_BBAD0
	lda	#:GFX_Spritesheet_Hero1					; data bank
	sta	REG_A1B0
	ldx	#2048							; data length
	stx	REG_DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_ShadowOAM_Lo, <REG_OAMDATA, 544

;	lda	#$80							; set OAM Priority Rotation flag
;	sta	REG_OAMADDH
;	lda	#36							; obj. no. with lowest priority (reserved area)
;	asl	a							; shift to bits 1-7
;	sta	REG_OAMADDL



@SkipRefreshes:



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

	ply								; restore 16 bit registers
	plx
	pla
	rti



Vblank_DebugMenu:
	AccuIndex16

	pha								; preserve 16 bit registers
	phx
	phy

	Accu8

	jsr	UpdateGameTime
	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_ShadowOAM_Lo, <REG_OAMDATA, 544



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

	ply								; restore 16 bit registers
	plx
	pla
	rti



Vblank_Error:
	AccuIndex16

	pha								; preserve 16 bit registers
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

	ply								; restore 16 bit registers
	plx
	pla
	rti



Vblank_Intro:
	AccuIndex16

	pha								; preserve 16 bit registers
	phx
	phy

	Accu8



; -------------------------- refresh sprites
;	stz	REG_OAMADDL						; reset OAM address
;	stz	REG_OAMADDH

;	DMA_CH0 $00, $7E, ARRAY_ShadowOAM_Lo, <REG_OAMDATA, 544



; -------------------------- update registers
	jsl	RAM_Code.UpdatePPURegs



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; restore 16 bit registers
	plx
	pla
	rti



Vblank_Minimal:
	AccuIndex16

	pha								; preserve 16 bit registers
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

	ply								; restore 16 bit registers
	plx
	pla
	rti



Vblank_Mode7:
	AccuIndex16

	pha								; preserve 16 bit registers
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; set OAM address to 0
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_ShadowOAM_Lo, <REG_OAMDATA, 544



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

	ply								; restore 16 bit registers
	plx
	pla
	rti



Vblank_WorldMap:
	AccuIndex16

	pha								; preserve 16 bit registers
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_ShadowOAM_Lo, <REG_OAMDATA, 544



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
	mvn	$7E, $00



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; restore 16 bit registers
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
	bne	@done							; yes, jump out

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
	beq	@joy2							; into the joy port, or it is not a joypad
	stx	DP_Joy1							; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	DP_Joy1Press

@joy2:
	bit	DP_Joy2							; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	@GetInputComplete					; into the joy port, or it is not a joypad
	stx	DP_Joy2							; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	DP_Joy2Press

@GetInputComplete:
	lda	DP_Joy1							; check for R+L+Start+Sel --> reset game
	and	#%0011000000110000
	cmp	#%0011000000110000
	bne	@done
	lda	#SoftReset & $FFFF					; load address of label "SoftReset"							; turn off the screen
	sta	11, s							; overwrite original location from where NMI was called (1, s = PHP in this subroutine, 3, s = return address of this subroutine, 9, s = Accu pushed at beginning of Vblank, 10, s = status register pushed when NMI fired)

	Accu8

	lda	#:SoftReset						; overwrite bank byte as well, so after RTI, the program continues at SoftReset
	sta	13, s
	lda	#$80							; turn off the screen
	sta	REG_INIDISP

@done:
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
	jmp	@DMAUpdatesDone

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
	jmp	@DMAUpdatesDone



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
	jmp	@DMAUpdatesDone

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
	jmp	@DMAUpdatesDone



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
	jmp	@DMAUpdatesDone

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
	jmp	@DMAUpdatesDone

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
	jmp	@DMAUpdatesDone



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
	jmp	@DMAUpdatesDone

+	lda	DP_DMA_Updates+1
	and	#%00001000						; check for 2nd BG2 tile map (high bytes)
	beq	+
	ldx	#ADDR_VRAM_BG2_TileMap2					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap2Hi, $19, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	DP_DMA_Updates+1
	dey								; decrement DMA counter
	beq	@DMAUpdatesDone



; -------------------------- check/refresh BG3 (high tilemap bytes)
+	lda	DP_DMA_Updates+1
	and	#%00010000						; check for BG3 tile map (high bytes)
	beq	@DMAUpdatesDone

	ldx	#ADDR_VRAM_BG3_TileMap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMapHi, $19, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	DP_DMA_Updates+1

@DMAUpdatesDone:
	rts



UpdateGameTime:
	sed								; decimal mode on

	clc
	lda	DP_GameTimeSeconds
	adc	#$01
	sta	DP_GameTimeSeconds
	cmp	#$60							; check if 60 frames = game time seconds have elapsed
	bcc	@UpdateMinutes

	stz	DP_GameTimeSeconds					; carry bit set, reset seconds

@UpdateMinutes:
	lda	DP_GameTimeMinutes					; increment minutes via carry bit
	adc	#$00
	sta	DP_GameTimeMinutes
	cmp	#$60							; check if 60 seconds have elapsed
	bcc	@UpdateHours

	stz	DP_GameTimeMinutes					; carry bit set, reset minutes

@UpdateHours:
	lda	DP_GameTimeHours					; increment hours via carry bit
	adc	#$00
	sta	DP_GameTimeHours
	cmp	#$24							; check if 24 hours have elapsed
	bcc	@TimeUpdateDone

	stz	DP_GameTimeHours					; carry bit set, reset hours

@TimeUpdateDone:
	cld								; decimal mode off
	rts



; ************************ Text box subroutines ************************

ClearTextBox:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_TextBoxL1					; set VRAM address to beginning of line 1
	stx	REG_VMADDL

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 184*16		; 184 tiles



; -------------------------- clear VWF buffer
	Accu16

	lda	#0
	ldy	#0
-	sta	ARRAY_VWF_TileBuffer, y					; erase buffer
	iny
	iny
	cpy	#64							; 4 tiles, 16 bytes per tile
	bne	-

	stz	DP_DiagTileDataCounter					; reset tile data counter
	stz	DP_VWF_BitsUsed						; reset used bits counter
	stz	DP_VWF_BufferIndex					; reset VWF buffer index

	Accu8

	lda	#%00000010						; text box is empty now, so clear the "clear text box" flag
	trb	DP_TextBoxStatus
	stz	DP_DiagTextEffect					; clear all text effect bits
	rts



FlushVWFTileBuffer:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN

	Accu16

	lda	DP_DiagTileDataCounter
	clc								; add VRAM address for BG2 font tiles (+ 32 empty tiles),
	adc	#ADDR_VRAM_TextBoxL1					; this is done here once so we can proceed with zero-based counter math
	sta	REG_VMADDL						; store as new VRAM address

	ldy	#0							; transfer VWF tile buffer to VRAM
-	lda	ARRAY_VWF_TileBuffer, y					; copy font tiles
	sta	REG_VMDATAL
	iny
	iny
	cpy	#32							; 2 tiles, 16 bytes per tile
	bne	-

	ldy	#0
-	lda	ARRAY_VWF_TileBuffer2, y				; next, copy font tiles from upper buffer to lower buffer
	sta	ARRAY_VWF_TileBuffer, y
	iny
	iny
	cpy	#32							; 2 tiles
	bne	-

	lda	#0
-	sta	ARRAY_VWF_TileBuffer, y					; lastly, clear upper buffer (sic, as Y index wasn't reset to zero)
	iny
	iny
	cpy	#64
	bne	-

	stz	DP_VWF_BufferIndex					; reset buffer index

	Accu8

	lda	#$01							; done, clear "VWF buffer full" bit
	trb	DP_TextBoxStatus
	rts



LoadTextBoxBG:
	lda	DP_TextBoxBG
	and	#%01111111						; mask off request bit
	bne	+
	ldx	#(ARRAY_HDMA_BackgrTextBox & $FFFF)			; set WRAM address to text box HDMA background
	stx	REG_WMADDL
	stz	REG_WMADDH						; array is in bank $7E

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 192	; DP_TextBoxBG is zero, so make background black

	bra	@LoadTextBoxBGDone

+	Accu16								; DP_TextBoxBG is not zero, calculate DMA parameters for the text box "scrolling" animations to look correctly (obviously not needed with solid black background)

	and	#$00FF							; remove garbage in high byte
	asl	a							; use as index into offset pointer table
	tax
	lda.l	PTR_TextBoxGradient, x					; read and set source data offset for upcoming DMA
	sta	REG_A1T0L



; -------------------------- ; calculate DMA data length based on current IRQ scanline (e.g. when text box has fully "scrolled in": 224 - 176 = 48; 48 * 4 = 192)
	lda	DP_TextBoxVIRQ						; perform 16-bit subtraction 224-DP_TextBoxVIRQ (which is an 8-bit variable) by doing -DP_TextBoxVIRQ+224 instead
	and	#$00FF							; remove garbage in high byte
	eor	#$FFFF							; make number negative (two's complement)
	inc	a
	clc								; add 224
	adc	#224
	bne	+							; if zero at this point, jump out (otherwise we'd end up with a disastrous transfer of 65536 bytes)

	Accu8

	bra	@LoadTextBoxBGDone

.ACCU 16

+	asl	a							; scanline difference (i.e., text box height) not zero, continue calculation
	asl	a
	sta	REG_DAS0L						; set calculated data length



; -------------------------- ; next, calculate WRAM address based on value of DP_TextBoxVIRQ (e.g. 176 * 4 - 704 = 0)
	lda	DP_TextBoxVIRQ
	and	#$00FF							; remove garbage in high byte once again
	asl	a
	asl	a
	clc
	adc	#(ARRAY_HDMA_BackgrPlayfield & $FFFF)			; use playfield background as a base to save the subtraction of 704
	sta	REG_WMADDL

	Accu8

	stz	REG_WMADDH						; array is in bank $7E
 	stz	REG_DMAP0						; DMA mode $00
	lda	#<REG_WMDATA						; B bus register ($2180)
	sta	REG_BBAD0
	lda	#:SRC_HDMA_TextBoxGradientBlue				; source data bank
	sta	REG_A1B0
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

@LoadTextBoxBGDone:
	lda	#$80							; new table loaded, clear request bit
	trb	DP_TextBoxBG
	rts



UpdateCharPortrait:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_Portrait					; set VRAM address to char portrait
	stx	REG_VMADDL
	lda	#ADDR_CGRAM_Portrait					; set CGRAM address for character portrait
	sta	REG_CGADD

	lda	DP_TextBoxCharPortrait					; check for portrait no., 0 = no portrait
	and	#$7F							; mask off "change portrait" bit
	bne	+

	DMA_CH0 $09, :CONST_FFs, CONST_FFs, <REG_VMDATAL, 1920		; no portrait wanted, so put masking tiles over portrait
	DMA_CH0 $0A, :CONST_Zeroes, CONST_Zeroes, <REG_CGDATA, 32	; and zero out palette

	bra	@PortraitUpdateDone

+	Accu16								; portrait no. in A

	and	#$00FF							; remove garbage in high byte
	asl	a
	tax								; make portrait no. = index in GFX pointer table
	lda.l	PTR_CharPortraitGFX, x
	sta	REG_A1T0L						; data offset
	ldy	#$1801							; low byte: DMA mode, high byte: B bus register ($2118/VMDATA)
 	sty	REG_DMAP0

	Accu8

	lda	#:GFX_Portrait_Hero1					; data bank (all portraits need to be in the same bank)
	sta	REG_A1B0
	ldy	#1920							; data length
	sty	REG_DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	Accu16

	lda.l	PTR_CharPortraitPalette, x				; index is still in X, use that for correct palette
	sta	REG_A1T0L						; data offset
	ldx	#$2202							; low byte: DMA mode, high byte: B bus register ($2122/CGDATA)
 	stx	REG_DMAP0

	Accu8

	lda	#:SRC_Palette_Portrait_Hero1				; data bank (all portrait palettes need to be in the same bank)
	sta	REG_A1B0
	ldx	#32							; data length (16 colors)
	stx	REG_DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

@PortraitUpdateDone:
	lda	#%10000000						; portrait updated, clear request flag
	trb	DP_TextBoxCharPortrait
	rts



; ************************** Software Errors ***************************

ErrorHandler:
	AccuIndex16

	pha								; preserve registers
	phx
	phy
	php

	Accu8

	lda	#$80							; enter forced blank
	sta.l	REG_INIDISP

	DisableIRQs
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
	lda	#$1F							; set mainscreen bg color: pink
	sta	REG_CGDATA
	lda	#$7C
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
	PrintString	5, 2, "Error code: "
	PrintHexNum	5, 14, DP_ErrorCode
	PrintString	6, 2, "Error type:"

	lda	DP_ErrorCode

	Accu16

	and	#$00FF							; remove garbage in high byte
	asl	a
	tax
	lda.l	PTR_ErrorCode, x					; load pointer to error code name
	sta	DP_DataAddress

	Accu8

	lda	#:PTR_ErrorCode
	sta	DP_DataBank

	PrintString	7, 2, "%s"					; print error code name
	PrintString	9, 2, "Status register: $"

	lda	7, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	10, 2, "Accuml.: $"

	lda	6, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	5, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	11, 2, "X index: $"

	lda	4, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	3, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	12, 2, "Y index: $"

	lda	2, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	1, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	SetNMI	TBL_NMI_Error

	lda	REG_RDNMI						; clear NMI flag
	cli								; reenable interrupts
	lda	#$81
	sta	REG_NMITIMEN
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	Freeze								; enter trap loop instead of RTI



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
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	9, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	8, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	7, 2, "Status register: $"

	lda	7, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	9, 2, "Accuml.: $"

	lda	6, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	5, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	10, 2, "X index: $"

	lda	4, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	3, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	11, 2, "Y index: $"

	lda	2, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	1, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
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
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	9, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	8, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	7, 2, "Status register: $"

	lda	7, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	9, 2, "Accuml.: $"

	lda	6, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	5, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	10, 2, "X index: $"

	lda	4, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	3, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	PrintString	11, 2, "Y index: $"

	lda	2, s
	sta	DP_Temp

	PrintHexNum	DP_Temp

	lda	1, s
	sta	DP_Temp

	PrintHexNum	DP_Temp
	SetNMI	TBL_NMI_Error

	lda	REG_RDNMI						; clear NMI flag
	cli								; reenable interrupts
	lda	#$81
	sta	REG_NMITIMEN
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	Freeze								; enter trap loop instead of RTI



; ******************************** EOF *********************************
