;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
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



; Update text box
	lda	<DP2.TextBoxCharPortrait				; check for "change character portrait" flag
	bpl	+
	jsr	UpdateCharPortrait

+	lda	<DP2.TextBoxBG						; check if text box background change requested
	bpl	+
	jsr	LoadTextBoxBG						; bit 7 set --> load new background color table

+	bit	<DP2.TextBoxStatus					; check text box status
	bvs	@WaitOrDontClearTB					; bit 6 set --> wait for player input before e.g. clearing text box
	lda	<DP2.TextBoxStatus
	and	#%00000010
	beq	@WaitOrDontClearTB
	jsr	ClearTextBox						; bit 1 set and "wait" flag clear --> wipe text
	jmp	@SkipRefreshes						; ... and skip BG refreshes (to avoid glitches due to premature end of Vblank)

@WaitOrDontClearTB:
	lda	<DP2.TextBoxStatus
	and	#%00000001						; VWF buffer full?
	beq	@TextBoxDone
	jsr	FlushVWFTileBuffer

@TextBoxDone:



; Animate playable character
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_Sprites+$800					; set VRAM address for sprite tiles, skip sprite font
	stx	VMADDL
	lda	<DP2.Hero1SpriteStatus
	and	#%00000111						; isolate direction parameter
	sta	WRMPYA
	lda	#$08							; multiply direction with #$0800 (2048) to get offset for upcoming DMA
	sta	WRMPYB

	Accu16								; 3 cycles

	lda	RDMPYL							; 5 cycles (4 + 1 for 16-bit Accu)
	xba
	clc
	adc	#loword(SRC_Spritesheet_Hero1)
	sta	A1T0L							; data offset

	Accu8

	lda	#$01							; DMA mode
 	sta	DMAP0
	lda	#$18							; B bus register ($2118)
	sta	BBAD0
	lda	#:SRC_Spritesheet_Hero1					; data bank
	sta	A1B0
	ldx	#2048							; data length
	stx	DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	MDMAEN

	jsr	RefreshBGs



; Refresh sprites
	stz	OAMADDL							; reset OAM address
	stz	OAMADDH

	DMA_CH0 $00, LO8.ShadowOAM_Lo, OAMDATA, 544

;	lda	#$80							; set OAM Priority Rotation flag
;	sta	OAMADDH
;	lda	#36							; obj. no. with lowest priority (reserved area)
;	asl	a							; shift to bits 1-7
;	sta	OAMADDL



@SkipRefreshes:



; Update registers
	jsl	RAM.Routines.UpdatePPURegs

;	lda	LO8.NMITIMEN						; moved to active display (beginning of loop) as of build #004XX (it makes no sense to put this into Vblank)
;	sta	NMITIMEN



; Misc. tasks
	jsr	GetInput

	lda	LO8.HDMA_BG_Scroll+1					; BG1 horizontal scroll
	sta	BG1HOFS
	lda	LO8.HDMA_BG_Scroll+2
	sta	BG1HOFS
	lda	LO8.HDMA_BG_Scroll+1					; BG2 horizontal scroll
	sta	BG2HOFS
	lda	LO8.HDMA_BG_Scroll+2
	sta	BG2HOFS
	lda	LO8.HDMA_BG_Scroll+3					; BG1 vertical scroll
	sta	BG1VOFS
	lda	LO8.HDMA_BG_Scroll+4
	sta	BG1VOFS
	lda	LO8.HDMA_BG_Scroll+3					; BG2 vertical scroll
	sta	BG2VOFS
	lda	LO8.HDMA_BG_Scroll+4
	sta	BG2VOFS
;	lda	#$FF							; never mind, HDMA takes care of BG3 vertical scroll
;	sta	BG3VOFS
;	stz	BG3VOFS
	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	HDMAEN
	lda	RDNMI							; acknowledge NMI

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



; Refresh sprites
	stz	OAMADDL							; reset OAM address
	stz	OAMADDH

	DMA_CH0 $00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



; Misc. tasks
	jsr	GetInput

	lda	#$FF							; BG3 vertical scroll
	sta	BG3VOFS
	stz	BG3VOFS
	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	HDMAEN
	lda	RDNMI							; acknowledge NMI

	AccuIndex16

	ply								; restore 16 bit registers
	plx
	pla

	rti



/*
Vblank_Error:
	AccuIndex16

	pha								; preserve 16 bit registers
	phx
	phy

	Accu8



; Refresh BG3 (low tilemap bytes)
	stz	VMAIN							; increment VRAM address by 1 after writing to $2118
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG3Tilemap, VMDATAL, 1024



; Refresh BG3 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG3TilemapHi, VMDATAH, 1024



; Misc. tasks
;	jsr	GetInput

	stz	BG3HOFS							; reset BG3 horizontal scroll
	stz	BG3HOFS
	lda	#$FF							; set BG3 vertical scroll = -1
	sta	BG3VOFS
	stz	BG3VOFS
	stz	HDMAEN							; disable HDMA
	lda	RDNMI							; acknowledge NMI

	AccuIndex16

	ply								; restore 16 bit registers
	plx
	pla

	rti
*/



Vblank_Intro:
	AccuIndex16

	pha								; preserve 16 bit registers
	phx
	phy

	Accu8



; Refresh sprites
;	stz	OAMADDL							; reset OAM address
;	stz	OAMADDH

;	DMA_CH0 $00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



; Misc. tasks
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	HDMAEN
	lda	RDNMI							; acknowledge NMI

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

	jsl	RAM.Routines.UpdatePPURegs
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	HDMAEN
	lda	RDNMI							; acknowledge NMI

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



; Refresh sprites
	stz	OAMADDL							; set OAM address to 0
	stz	OAMADDH

	DMA_CH0 $00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Mode7
	Accu16

	lda	<DP2.Mode7_ScrollOffsetX
	lsr	a							; shift right for 13-bit value
	lsr	a
	lsr	a

	Accu8

	sta	BG1HOFS							; BG1HOFS/M7HOFS
	xba
	sta	BG1HOFS

	Accu16

	lda	<DP2.Mode7_ScrollOffsetY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	BG1VOFS							; BG1VOFS/M7VOFS
	xba
	sta	BG1VOFS

	Accu16

	lda	<DP2.Mode7_CenterCoordX
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	M7X							; Mode 7 center position X register (low)
	xba
	sta	M7X							; Mode 7 center position X register (high)

	Accu16

	lda	<DP2.Mode7_CenterCoordY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	M7Y							; Mode 7 center position Y register (low)
	xba
	sta	M7Y							; Mode 7 center position Y register (high)

; calculate table offset based on current altitude
	Accu16

	lda	#$01C0							; 224 scanlines (*2 as the table consists of word entries for each scanline)
	sec
	sbc	#kMode7SkyLines*2					; subtract sky lines as those aren't present in the table

	Accu8

	sta	M7A							; write low byte
	xba
	sta	M7A							; write high byte
	lda	<DP2.Mode7_Altitude
	sta	M7B

	.IFDEF PrecalcMode7Tables
		Accu16

		lda	MPYL						; (number of lines * 2) * altitude setting = table offset
		clc
		adc	#loword(SRC_Mode7Scaling)
		sta	<DP2.DataAddress

		Accu8
	.ELSE
		ldx	MPYL						; (number of lines * 2) * altitude setting = table offset
		stx	<DP2.DataAddress
	.ENDIF

	lda	<DP2.Mode7_BG2HScroll
	sta	BG2HOFS
	stz	BG2HOFS



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



; Misc. tasks
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	HDMAEN

	lda	RDNMI							; acknowledge NMI

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



; Refresh sprites
	stz	OAMADDL							; reset OAM address
	stz	OAMADDH

	DMA_CH0 $00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Update registers
	jsl	RAM.Routines.UpdatePPURegs

	lda	<DP2.WorldMapBG1HScroll					; update scroll regs/HDMA tables
	sta	BG1HOFS
	lda	<DP2.WorldMapBG1HScroll+1
	and	#$3F							; limit value to $3FFF
	sta	BG1HOFS

	ldx	#loword(RAM.ScratchSpace)				; copy over scroll displacement table to HDMA array
	ldy	#LO8.HDMA_WorMapVScroll
	lda	#$01							; $01BF = 447 (i.e., 448 bytes are transferred)
	xba
	lda	#$BF
	mvn	$7E, $00						; self-reminder: This also sets the DBR to the destination bank ($00 in this case, otherwise uncomment/change the following). But, why won't mvn $00, $00 work just as well?!

;	SetDBR	$00							; set Data Bank = $00



; Misc. tasks
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	HDMAEN
	lda	RDNMI							; acknowledge NMI

	AccuIndex16

	ply								; restore 16 bit registers
	plx
	pla

	rti



; *************************** H-IRQ routines ***************************

	.ACCU 8
	.INDEX 16

HIRQ_MenuItemsVsplit:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator

	lda	#$01|$08						; switch to BG Mode 1 (BG3 priority)
	sta	BGMODE
	stz	BG12NBA							; reset BG1/2 character data area designation to $0000

	lda	TIMEUP							; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status

	rti



HIRQ_X:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator

	; do something here

	lda	TIMEUP							; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status

	rti



; *************************** V-IRQ routines ***************************

VIRQ_Area:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator
	lda	#$05							; switch to BG Mode 5 for text box
	sta	BGMODE
	lda	#$78							; VRAM address for BG1 tilemap: $7800, size: 32×32 tiles
	sta	BG1SC
	lda	#$7C							; VRAM address for BG2 tilemap: $7C00, size: 32×32 tiles
	sta	BG2SC
	lda	LO8.TextBox_TSTM					; write Main/Subscreen designation regs
	sta	TM
	lda	LO8.TextBox_TSTM+1
	sta	TS
	lda	TIMEUP							; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status

	rti



VIRQ_Mode7:
	php								; preserve processor status

	Accu8								; only use 8 bit accumulator

	pha								; preserve 8 bit accumulator
	lda	#$07							; switch to BG Mode 7
	sta	BGMODE
	lda	#%00010001						; turn on BG1 and sprites only
	sta	TM							; on the mainscreen
	sta	TS							; and on the subscreen
	lda	TIMEUP							; acknowledge IRQ
	pla								; restore 8 bit accumulator
	plp								; restore processor status

	rti



; ************************* Common subroutines *************************

	.ACCU 8
	.INDEX 16

GetInput:
	php
	lda	#$01
-	bit	HVBJOY
	bne	-							; wait till automatic JoyPort read is complete

	AccuIndex16



; Read joypad 1
	lda	<DP2.Joy1
	sta	<DP2.Joy1Old
	lda	<DP2.GameMode
	and	#%0000000010000000					; check if auto-mode is enabled
	beq	+
	lda	<DP2.AutoJoy1						; yes, load simulated joypad
	bra	++
+	lda	JOY1L							; otherwise, get JoyPad1
++	tax
	eor	<DP2.Joy1						; A = A xor JoyState = (changes in joy state)
	stx	<DP2.Joy1						; update JoyState
	ora	<DP2.Joy1Press						; A = (joy changes) or (buttons pressed)
	and	<DP2.Joy1						; A = ((joy changes) or (buttons pressed)) and (current joy state)
	sta	<DP2.Joy1Press						; store A = (buttons pressed since last clearing reg) and (button is still down)
	lda	<DP2.Joy1Old
	eor	#$FFFF
	and	<DP2.Joy1
	sta	<DP2.Joy1New



; Read joypad 2
	lda	<DP2.Joy2
	sta	<DP2.Joy2Old
	lda	<DP2.GameMode
	and	#%0000000010000000					; check if auto-mode is enabled
	beq	+
	lda	<DP2.AutoJoy2						; yes, load simulated joypad
	bra	++
+	lda	JOY2L							; get JoyPad2
++	tax
	eor	<DP2.Joy2						; A = A xor JoyState = (changes in joy state)
	stx	<DP2.Joy2						; update JoyState
	ora	<DP2.Joy2Press						; A = (joy changes) or (buttons pressed)
	and	<DP2.Joy2						; A = ((joy changes) or (buttons pressed)) and (current joy state)
	sta	<DP2.Joy2Press						; store A = (buttons pressed since last clearing reg) and (button is still down)
	lda	<DP2.Joy2Old
	eor	#$FFFF
	and	<DP2.Joy2
	sta	<DP2.Joy2New



; Make sure Joypads 1, 2 are valid
	lda	<DP2.GameMode
	and	#%0000000010000000					; check if auto-mode is enabled
	bne	@done							; yes, jump out

	AccuIndex8

	lda	JOYA
	eor	#$01
	and	#$01							; A = -bit0 of JOYA
	ora	<DP2.Joy1
	sta	<DP2.Joy1						; joy state = (joy state) or A.... so bit0 of Joy1State = 0 only if it is a valid joypad

	lda	JOYB
	eor	#$01
	and	#$01							; A = -bit0 of JOYB
	ora	<DP2.Joy2
	sta	<DP2.Joy2						; joy state = (joy state) or A.... so bit0 of Joy1State = 0 only if it is a valid joypad



; Change all invalid joypads to have a state of no button presses
	AccuIndex16

	ldx	#$0001
	lda	#$000F
	bit	<DP2.Joy1						; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	@joy2							; into the joy port, or it is not a joypad
	stx	<DP2.Joy1						; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	<DP2.Joy1Press

@joy2:
	bit	<DP2.Joy2						; A = joy state, if any of the bottom 4 bits are on... either nothing is plugged
	beq	@GetInputComplete					; into the joy port, or it is not a joypad
	stx	<DP2.Joy2						; if it is not a valid joypad put $0001 into the 2 joy state variables
	stz	<DP2.Joy2Press

@GetInputComplete:
	lda	<DP2.Joy1						; check for R+L+Start+Sel --> reset game
	and	#%0011000000110000
	cmp	#%0011000000110000
	bne	@done
	lda	#loword(SoftReset)					; load address of label "SoftReset"							; turn off the screen
	sta	11, s							; overwrite original location from where NMI was called (1, s = PHP in this subroutine, 3, s = return address of this subroutine, 9, s = Accu pushed at beginning of Vblank, 10, s = status register pushed when NMI fired)

	Accu8

	lda	#:SoftReset						; overwrite bank byte as well, so after rti, the program continues at SoftReset
	sta	13, s
	lda	#$80							; turn off the screen
	sta	INIDISP

@done:
	plp

	rts



	.ACCU 8
	.INDEX 16

RefreshBGs:								; refresh BGs according to DP2.DMA_Updates
	ldy	#4							; DMA counter, do max. 4 DMAs per Vblank
	stz	VMAIN							; increment VRAM address by 1 after writing to $2118



; Check/refresh BG1 (low tilemap bytes)
	lda	<DP2.DMA_Updates
	and	#%00000001						; check for 1st BG1 tilemap (low bytes)
	beq	+
	ldx	#VRAM_BG1_Tilemap1					; set VRAM address to BG1 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG1Tilemap1, VMDATAL, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone

+	lda	<DP2.DMA_Updates
	and	#%00000010						; check for 2nd BG1 tilemap (low bytes)
	beq	+
	ldx	#VRAM_BG1_Tilemap2					; set VRAM address to BG1 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG1Tilemap2, VMDATAL, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone



; Check/refresh BG2 (low tilemap bytes)
+	lda	<DP2.DMA_Updates
	and	#%00000100						; check for 1st BG2 tilemap (low bytes)
	beq	+
	ldx	#VRAM_BG2_Tilemap1					; set VRAM address to BG2 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG2Tilemap1, VMDATAL, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone

+	lda	<DP2.DMA_Updates
	and	#%00001000						; check for 2nd BG2 tilemap (low bytes)
	beq	+
	ldx	#VRAM_BG2_Tilemap2					; set VRAM address to BG2 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG2Tilemap2, VMDATAL, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone



; Check/refresh BG3 (low tilemap bytes)
+	lda	<DP2.DMA_Updates
	and	#%00010000						; check for BG3 tilemap (low bytes)
	beq	+
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG3Tilemap, VMDATAL, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey
	bne	+
	jmp	@DMAUpdatesDone

+	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN



; Check/refresh BG1 (high tilemap bytes)
	lda	<DP2.DMA_Updates+1
	and	#%00000001						; check for 1st BG1 tilemap (high bytes)
	beq	+
	ldx	#VRAM_BG1_Tilemap1					; set VRAM address to BG1 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG1Tilemap1Hi, VMDATAH, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	<DP2.DMA_Updates+1
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone

+	lda	<DP2.DMA_Updates+1
	and	#%00000010						; check for 2nd BG1 tilemap (high bytes)
	beq	+
	ldx	#VRAM_BG1_Tilemap2					; set VRAM address to BG1 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG1Tilemap2Hi, VMDATAH, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	<DP2.DMA_Updates+1
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone



; Check/refresh BG2 (high tilemap bytes)
+	lda	<DP2.DMA_Updates+1
	and	#%00000100						; check for 1st BG2 tilemap (high bytes)
	beq	+
	ldx	#VRAM_BG2_Tilemap1					; set VRAM address to BG2 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG2Tilemap1Hi, VMDATAH, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	<DP2.DMA_Updates+1
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone

+	lda	<DP2.DMA_Updates+1
	and	#%00001000						; check for 2nd BG2 tilemap (high bytes)
	beq	+
	ldx	#VRAM_BG2_Tilemap2					; set VRAM address to BG2 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG2Tilemap2Hi, VMDATAH, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	<DP2.DMA_Updates+1
	dey								; decrement DMA counter
	beq	@DMAUpdatesDone



; Check/refresh BG3 (high tilemap bytes)
+	lda	<DP2.DMA_Updates+1
	and	#%00010000						; check for BG3 tilemap (high bytes)
	beq	@DMAUpdatesDone

	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG3TilemapHi, VMDATAH, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	<DP2.DMA_Updates+1

@DMAUpdatesDone:

	rts



UpdateGameTime:								; FIXME, move to active display
	sed								; decimal mode on

	clc
	lda	<DP2.GameTimeSeconds
	adc	#$01
	sta	<DP2.GameTimeSeconds
	cmp	#$60							; check if 60 frames = game time seconds have elapsed
	bcc	@UpdateMinutes

	stz	<DP2.GameTimeSeconds					; carry bit set, reset seconds

@UpdateMinutes:
	lda	<DP2.GameTimeMinutes					; increment minutes via carry bit
	adc	#$00
	sta	<DP2.GameTimeMinutes
	cmp	#$60							; check if 60 seconds have elapsed
	bcc	@UpdateHours

	stz	<DP2.GameTimeMinutes					; carry bit set, reset minutes

@UpdateHours:
	lda	<DP2.GameTimeHours					; increment hours via carry bit
	adc	#$00
	sta	<DP2.GameTimeHours
	cmp	#$24							; check if 24 hours have elapsed
	bcc	@TimeUpdateDone

	stz	<DP2.GameTimeHours					; carry bit set, reset hours

@TimeUpdateDone:
	cld								; decimal mode off

	rts



; ************************ Text box subroutines ************************

ClearTextBox:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_TextBoxL1						; set VRAM address to beginning of line 1
	stx	VMADDL

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 184*16			; 184 tiles



; Clear VWF buffer // FIXME MOVE TO ACT. DISPLAY (cf. lines 466, 555, 855 in text.inc.asm)
	Accu16

	lda	#0
	ldy	#0
-	sta	LO8.VWF_TileBuffer, y					; erase buffer
	iny
	iny
	cpy	#64							; 4 tiles, 16 bytes per tile
	bne	-

	stz	<DP2.DiagTileDataCounter				; reset tile data counter
	stz	<DP2.VWF_BitsUsed					; reset used bits counter
	stz	<DP2.VWF_BufferIndex					; reset VWF buffer index

	Accu8

	lda	#%00000010						; text box is empty now, so clear the "clear text box" flag
	trb	<DP2.TextBoxStatus
	stz	<DP2.DiagTextEffect					; clear all text effect bits

	rts



; "FlushVWFTileBuffer" as a function consists of two parts:
; 1. Transfer contents of LO8.VWF_TileBuffer to VRAM (this subroutine)
; 2. Copy contents of LO8.VWF_TileBuffer2 to LO8.VWF_TileBuffer
;    (macro), this is done where appropriate (i.e., after the "VWF
;    buffer full" bit was set and one frame passed to do part 1) during
;    active display as no more VRAM writing is involved.

FlushVWFTileBuffer:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN

	Accu16

	lda	<DP2.DiagTileDataCounter
	clc								; add VRAM address for BG2 font tiles (+ 32 empty tiles),
	adc	#VRAM_TextBoxL1						; this is done here once so we can proceed with zero-based counter math
	sta	VMADDL							; store as new VRAM address

	ldy	#0							; transfer VWF tile buffer to VRAM
-	lda	LO8.VWF_TileBuffer, y					; copy font tiles
	sta	VMDATAL
	iny
	iny
	cpy	#32							; 2 tiles, 16 bytes per tile
	bne	-

;	FlushVWFTileBuffer2						; this is done during active display (used to be part of this subroutine)

	Accu8

	lda	#$01							; done, clear "VWF buffer full" bit
	trb	<DP2.TextBoxStatus

	rts



LoadTextBoxBG:
	lda	<DP2.TextBoxBG
	and	#%01111111						; mask off request bit
	bne	+
	ldx	#loword(RAM.HDMA_BackgrTextBox)				; set WRAM address to text box HDMA background
	stx	WMADDL
	stz	WMADDH							; array is in bank $7E

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 192				; DP2.TextBoxBG is zero, so make background black

	bra	@LoadTextBoxBGDone

+	Accu16								; DP2.TextBoxBG is not zero, calculate DMA parameters for the text box "scrolling" animations to look correctly (obviously not needed with solid black background)

	and	#$00FF							; remove garbage in high byte
	asl	a							; use as index into offset pointer table
	tax
	lda.l	PTR_TextBoxGradient, x					; read and set source data offset for upcoming DMA
	sta	A1T0L



; Calculate DMA data length based on current IRQ scanline (e.g. when text box has fully "scrolled in": 224 - 176 = 48; 48 * 4 = 192)
	lda	<DP2.TextBoxVIRQ					; perform 16-bit subtraction 224-DP2.TextBoxVIRQ (which is an 8-bit variable) by doing -DP2.TextBoxVIRQ+224 instead
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
	sta	DAS0L							; set calculated data length



; Next, calculate WRAM address based on value of DP2.TextBoxVIRQ (e.g. 176 * 4 - 704 = 0)
	lda	<DP2.TextBoxVIRQ
	and	#$00FF							; remove garbage in high byte once again
	asl	a
	asl	a
	clc
	adc	#loword(RAM.HDMA_BackgrPlayfield)			; use playfield background as a base to save the subtraction of 704
	sta	WMADDL

	Accu8

	stz	WMADDH							; array is in bank $7E
 	stz	DMAP0							; DMA mode $00
	lda	#<WMDATA						; B bus register ($2180)
	sta	BBAD0
	lda	#:SRC_HDMA_TextBoxGradientBlue				; source data bank
	sta	A1B0
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	MDMAEN

@LoadTextBoxBGDone:
	lda	#$80							; new table loaded, clear request bit
	trb	<DP2.TextBoxBG

	rts



UpdateCharPortrait:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_Portrait						; set VRAM address to char portrait
	stx	VMADDL
	lda	#CGRAM_Portrait						; set CGRAM address for character portrait
	sta	CGADD

	lda	<DP2.TextBoxCharPortrait				; check for portrait no., 0 = no portrait
	and	#$7F							; mask off "change portrait" bit
	bne	+

	DMA_CH0 $09, SRC_FFs, VMDATAL, 1920				; no portrait wanted, so put masking tiles over portrait

	DMA_CH0 $0A, SRC_Zeroes, CGDATA, 32				; and zero out palette

	bra	@PortraitUpdateDone

+	Accu16								; portrait no. in A

	and	#$00FF							; remove garbage in high byte
	asl	a
	tax								; make portrait no. = index in GFX pointer table
	lda.l	PTR_CharPortraitGFX, x
	sta	A1T0L							; data offset
	ldy	#$1801							; low byte: DMA mode, high byte: B bus register ($2118/VMDATA)
 	sty	DMAP0

	Accu8

	lda	#:SRC_Portrait_Hero1					; data bank (all portraits need to be in the same bank)
	sta	A1B0
	ldy	#1920							; data length
	sty	DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	MDMAEN

	Accu16

	lda.l	PTR_CharPortraitPalette, x				; index is still in X, use that for correct palette
	sta	A1T0L							; data offset
	ldx	#$2202							; low byte: DMA mode, high byte: B bus register ($2122/CGDATA)
 	stx	DMAP0

	Accu8

	lda	#:SRC_Palette_Portrait_Hero1				; data bank (all portrait palettes need to be in the same bank)
	sta	A1B0
	ldx	#32							; data length (16 colors)
	stx	DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	MDMAEN

@PortraitUpdateDone:
	lda	#%10000000						; portrait updated, clear request flag
	trb	<DP2.TextBoxCharPortrait

	rts



; ************************** Software Errors ***************************

ErrorHandler:
	php								; preserve CPU status

	AccuIndex16

	pha								; preserve registers
	phx
	phy

	SetDP	$0200

	Accu8

	DisableIRQs

	SetDBR	$00

	stz	HDMAEN							; disable HDMA
	lda	#$80							; enter forced blank
	sta	INIDISP

@FromBRKorCOP:



; Clear BG3 tilemap buffer
	ldx	#loword(RAM.BG3Tilemap)
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 2048



; 8x8 font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_BG3_Tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Font8x8, VMDATAL, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	RAM.BG3TilemapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-



; Font palette --> CGRAM
	stz	CGADD							; reset CGRAM address
	stz	CGDATA							; set mainscreen bg color: blue
	lda	#$70
	sta	CGDATA
	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	CGDATA
	inx
	cpx	#8
	bne	-



; Register updates
	lda	#$01							; set BG mode 1
	sta	BGMODE
	lda	#$48							; VRAM address for BG3 tilemap: $4800, size: 32×32 tiles
	sta	BG3SC
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	BG34NBA
	lda	#%00000100						; turn on BG3 only
	sta	TM							; on the mainscreen
	sta	TS							; and on the subscreen



; Print error info
	PrintString	3, 2, kTextBG3, "An error occurred!"
	PrintString	6, 2, kTextBG3, "Error type:"

	lda	<DP2.ErrorCode

	Accu16

	and	#$00FF							; clear garbage in high byte
;	asl	a							; never mind (error code table consists of 2-byte entries)
	tax
	phx								; preserve error code for later use

	lda.l	PTR_ErrorCode, x					; load pointer to error code name
	sta	<DP2.DataAddress

	Accu8

	lda	#:PTR_ErrorCode
	sta	<DP2.DataBank

	PrintString	7, 2, kTextBG3, "%s"				; print error code name



; print extra info depending on error type
	plx								; restore error code as jump index
	jmp	(@PTR_ErrorCodeExtraInfo, x)

@PTR_ErrorCodeExtraInfo:
	.DW @ErrorBRKorCOP
	.DW @ErrorBRKorCOP
	.DW @ErrorCorruptROM
	.DW @ErrorSPC700

@ErrorBRKorCOP:
	PrintString	10, 2, kTextBG3, "BRK/COP signature byte: $"
	PrintHexNum	<DP2.ErrorSignature

	PrintString	12, 2, kTextBG3, "PC: $"

	lda	10, s							; PC bank
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	9, s							; PC middle byte
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	8, s							; PC low byte
	dec	a							; make up for automatic program counter increment
	dec	a
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	jmp	@ExtraInfoDone

@ErrorCorruptROM:
	PrintString	10, 2, kTextBG3, "ROM header checksum:"

	SetTextPos	10, 23
	PrintHexNum	$40FFDF

	SetTextPos	10, 25
	PrintHexNum	$40FFDE

	PrintString	12, 2, kTextBG3, "Calculated checksum:"

	SetTextPos	12, 23
	PrintHexNum	<DP2.Temp+4

	SetTextPos	12, 25
	PrintHexNum	<DP2.Temp+3

	jmp	@ExtraInfoDone

@ErrorSPC700:
	; nothing for now

;	jmp	@ExtraInfoDone						; uncomment when adding more error types

@ExtraInfoDone:
	PrintString	15, 2, kTextBG3, "A: $"

	lda	6, s
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	5, s
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	PrintString	16, 2, kTextBG3, "X: $"

	lda	4, s
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	3, s
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	PrintString	17, 2, kTextBG3, "Y: $"

	lda	2, s
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	1, s
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	PrintString	20, 2, kTextBG3, "CPU status: %%"

	lda	7, s
	sta	<DP2.Temp

	PrintBinary	<DP2.Temp



; Update BG3 tilemap
	stz	VMAIN							; increment VRAM address by 1 after writing to $2118
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG3Tilemap, VMDATAL, 1024



; Turn screen back on, put CPU to sleep
	lda	#$0F
	sta	INIDISP
	stp								; halt the CPU



ErrorHandlerBRK:
	AccuIndex16

	pha								; preserve registers (processor status already pushed by the BRK instruction)
	phx
	phy

	SetDP	$0200

	Accu8

	lda	#$00							; disable NMI (IRQ disable flag already set by the BRK instruction)
	sta.l	NMITIMEN

	SetDBR	$00

	stz	HDMAEN							; disable HDMA
	lda	#$80							; enter forced blank
	sta	INIDISP
	lda	#kErrorBRK
	sta	<DP2.ErrorCode

	lda	8, s							; load BRK signature byte address (can't use Stack Relative Indirect Indexed addressing here unfortunately because the program counter already pointed to the next byte when it was pushed onto the stack)
	dec	a							; decrement low byte of program counter to signature byte address (i.e., make up for automatic PC increment)
	sta	<DP2.DataAddress
	lda	9, s
	sta	<DP2.DataAddress+1
	lda	10, s
	sta	<DP2.DataBank
	lda	[<DP2.DataAddress]					; load BRK signature byte
	sta	<DP2.ErrorSignature

	jmp	ErrorHandler@FromBRKorCOP



ErrorHandlerCOP:
	AccuIndex16

	pha								; preserve registers (processor status already pushed by the COP instruction)
	phx
	phy

	SetDP	$0200

	Accu8

	lda	#$00							; disable NMI (IRQ disable flag already set by the COP instruction)
	sta.l	NMITIMEN

	SetDBR	$00

	stz	HDMAEN							; disable HDMA
	lda	#$80							; enter forced blank
	sta	INIDISP
	lda	#kErrorCOP
	sta	<DP2.ErrorCode

	lda	8, s							; cf. loading of BRK signature byte address
	dec	a
	sta	<DP2.DataAddress
	lda	9, s
	sta	<DP2.DataAddress+1
	lda	10, s
	sta	<DP2.DataBank
	lda	[<DP2.DataAddress]					; load COP signature byte
	sta	<DP2.ErrorSignature

	jmp	ErrorHandler@FromBRKorCOP



; ******************************** EOF *********************************
