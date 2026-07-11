; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	IRQ & NMI HANDLERS
;
; ==================================================================================================



; H-/V-IRQ ROUTINES
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

GlobalIRQ:								; IRQ vector points here
	Accu8								; only use 8-bit accumulator

	pha								; preserve 8-bit accumulator

;	ldx	#$0000							; we can't afford the time/cycles to preserve and use X here
;	jsr	(LO8.JumpIRQ, x)
	jmp	(LO8.JumpIRQ)						; LO8.JumpIRQ expected to contain e.g., #VIRQ_Area

; Rest of routine (shown for reference but commented out here) needs to be done in every possible
; JumpIRQ target routine!

;	lda	TIMEUP							; acknowledge IRQ
;	pla								; restore 8-bit accumulator

;	rti



HIRQ_MenuItemsVsplit:
;	Accu8								; only use 8-bit accumulator

;	pha								; preserve 8-bit accumulator

	lda	#kBGMODE_1|kBG3priority					; switch to BG Mode 1, BG3 priority
	sta	BGMODE
	stz	BG12NBA							; reset BG1/2 character data area designation to $0000

	lda	TIMEUP							; acknowledge IRQ
	pla								; restore 8-bit accumulator

	rti



VIRQ_Area:
;	Accu8								; only use 8-bit accumulator

;	pha								; preserve 8-bit accumulator

	lda	#kBGMODE_5						; switch to BG Mode 5 for text box
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
	pla								; restore 8-bit accumulator

	rti



VIRQ_Mode7:
;	Accu8								; only use 8-bit accumulator

;	pha								; preserve 8-bit accumulator

	lda	#kBGMODE_7						; switch to BG Mode 7
	sta	BGMODE
	lda	#kTM_BG1|kTM_OBJ					; turn on BG1 and sprites only
	sta	TM							; on the mainscreen
	sta	TS							; and on the subscreen
	lda	TIMEUP							; acknowledge IRQ
	pla								; restore 8-bit accumulator

	rti



; VBLANK/NMI ROUTINES
; --------------------------------------------------------------------------------------------------

GlobalNMI:								; NMI vector points here
	AccuIndex16

	pha								; preserve 16-bit registers
	phx
	phy

	ldx	#$0000							; "table" in LO8.JumpNMI only ever consists of a single 16-bit value, so X must always be zero here (a JSR addressing mode workaround)
	jsr	(LO8.JumpNMI, x)					; LO8.JumpNMI expected to contain e.g., #Vblank_DebugMenu
;	jmp	(LO8.JumpNMI)

	lda	RDNMI							; acknowledge NMI

	AccuIndex16

	ply								; restore 16-bit registers
	plx
	pla

	rti



Vblank_Area:
	Accu8



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
	lda	#<VMDATAL						; B bus register
	sta	BBAD0
	lda	#:SRC_Spritesheet_Hero1					; data bank
	sta	A1B0
	ldx	#2048							; data length
	stx	DAS0L
	lda	#kDMA_Channel0						; initiate DMA transfer
	sta	MDMAEN

	jsr	RefreshBGs



; Refresh sprites
	stz	OAMADDL							; reset OAM address
	stz	OAMADDH

	dma_0	$00, LO8.ShadowOAM_Lo, OAMDATA, 544

;	lda	#$80							; set OAM Priority Rotation flag
;	sta	OAMADDH
;	lda	#36							; obj. no. with lowest priority (reserved area)
;	asl	a							; shift to bits 1-7
;	sta	OAMADDL



@SkipRefreshes:



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



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
	and	#kDMA_All~kDMA_Channel0					; channel 0 reserved for regular DMA
	sta	HDMAEN

	rts



Vblank_DebugMenu:
	Accu8

	jsr	RefreshBGs



; Refresh sprites
	stz	OAMADDL							; reset OAM address
	stz	OAMADDH

	dma_0	$00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



; Misc. tasks
	jsr	GetInput

	lda	#$FF							; BG3 vertical scroll
	sta	BG3VOFS
	stz	BG3VOFS
	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#kDMA_All~kDMA_Channel0					; channel 0 reserved for regular DMA
	sta	HDMAEN

	rts



/*
Vblank_Error:
	Accu8

; Refresh BG3
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG3Tilemap, VMDATAL, 2048



; Misc. tasks
;	jsr	GetInput

	stz	BG3HOFS							; reset BG3 horizontal scroll
	stz	BG3HOFS
	lda	#$FF							; set BG3 vertical scroll = -1
	sta	BG3VOFS
	stz	BG3VOFS
	stz	HDMAEN							; disable HDMA

	rts
*/



Vblank_Intro:
	Accu8

; Refresh sprites
;	stz	OAMADDL							; reset OAM address
;	stz	OAMADDH

;	dma_0	$00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



; Misc. tasks
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#kDMA_All~kDMA_Channel0					; channel 0 reserved for regular DMA
	sta	HDMAEN

	rts



Vblank_Minimal:
	Accu8

	jsl	RAM.Routines.UpdatePPURegs
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#kDMA_All~kDMA_Channel0					; channel 0 reserved for regular DMA
	sta	HDMAEN

	rts



Vblank_Mode7:
	Accu8



; Refresh sprites
	stz	OAMADDL							; set OAM address to 0
	stz	OAMADDH

	dma_0	$00, LO8.ShadowOAM_Lo, OAMDATA, 544



; Mode7
	Accu16

	lda	<DP2.Mode7_ScrollOffsetX
	rsh	3							; shift right for 13-bit value

	Accu8

	sta	BG1HOFS							; BG1HOFS/M7HOFS
	xba
	sta	BG1HOFS

	Accu16

	lda	<DP2.Mode7_ScrollOffsetY
	rsh	3

	Accu8

	sta	BG1VOFS							; BG1VOFS/M7VOFS
	xba
	sta	BG1VOFS

	Accu16

	lda	<DP2.Mode7_CenterCoordX
	rsh	3

	Accu8

	sta	M7X							; Mode 7 center position X register (low)
	xba
	sta	M7X							; Mode 7 center position X register (high)

	Accu16

	lda	<DP2.Mode7_CenterCoordY
	rsh	3

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

	lda	MPYL							; (number of lines * 2) * altitude setting = table offset
	clc
	adc	#loword(SRC_Mode7Scaling)
	sta	<DP2.DataAddress

	Accu8
.ELSE
	ldx	MPYL							; (number of lines * 2) * altitude setting = table offset
	stx	<DP2.DataAddress
.ENDIF

	lda	<DP2.Mode7_BG2HScroll
	sta	BG2HOFS
	stz	BG2HOFS

;	jsl	CalcMode7MatrixPPU					; new routine with PPU multiplication



; Update registers
	jsl	RAM.Routines.UpdatePPURegs



; Misc. tasks
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#kDMA_All~kDMA_Channel0					; channel 0 reserved for regular DMA
	sta	HDMAEN

	rts



Vblank_WorldMap:
	Accu8



; Refresh sprites
	stz	OAMADDL							; reset OAM address
	stz	OAMADDH

	dma_0	$00, LO8.ShadowOAM_Lo, OAMDATA, 544



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
	mvn	bankbyte(RAM.ScratchSpace), bankbyte(LO8.HDMA_WorMapVScroll)	; $7E (src), $00 (dest), self-reminder: This also sets the DBR to the destination bank ($00 in this case)



; Misc. tasks
	jsr	GetInput

	lda	<DP2.HDMA_Channels					; initiate HDMA transfers
	and	#kDMA_All~kDMA_Channel0					; channel 0 reserved for regular DMA
	sta	HDMAEN

	rts



; COMMON SUBROUTINES
; --------------------------------------------------------------------------------------------------

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
	lda	#kForcedBlank						; turn off the screen
	sta	INIDISP

@done:
	plp

	rts



.ACCU 8
.INDEX 16

RefreshBGs:								; refresh BGs according to DP2.DMA_Updates
	ldy	#2							; DMA counter, do max. 2 DMAs per Vblank
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN



; Check/refresh BG1
	lda	<DP2.DMA_Updates
	and	#kBG1Tilemap1						; check for 1st BG1 tilemap
	beq	+
	ldx	#VRAM_BG1_Tilemap1					; set VRAM address to BG1 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG1Tilemap1, VMDATAL, 2048

	lda	#kBG1Tilemap1						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone

+	lda	<DP2.DMA_Updates
	and	#kBG1Tilemap2						; check for 2nd BG1 tilemap
	beq	+
	ldx	#VRAM_BG1_Tilemap2					; set VRAM address to BG1 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG1Tilemap2, VMDATAL, 2048

	lda	#kBG1Tilemap2						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone



; Check/refresh BG2
+	lda	<DP2.DMA_Updates
	and	#kBG2Tilemap1						; check for 1st BG2 tilemap
	beq	+
	ldx	#VRAM_BG2_Tilemap1					; set VRAM address to BG2 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG2Tilemap1, VMDATAL, 2048

	lda	#kBG2Tilemap1						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone

+	lda	<DP2.DMA_Updates
	and	#kBG2Tilemap2						; check for 2nd BG2 tilemap
	beq	+
	ldx	#VRAM_BG2_Tilemap2					; set VRAM address to BG2 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG2Tilemap2, VMDATAL, 2048

	lda	#kBG2Tilemap2						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey								; decrement DMA counter
	bne	+
	jmp	@DMAUpdatesDone



; Check/refresh BG3
+	lda	<DP2.DMA_Updates
	and	#kBG3Tilemap						; check for BG3 tilemap
	beq	+
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG3Tilemap, VMDATAL, 2048

	lda	#kBG3Tilemap						; clear respective DMA update bit
	trb	<DP2.DMA_Updates
	dey
	bne	+
	jmp	@DMAUpdatesDone

; Check/refresh something else
+

@DMAUpdatesDone:

	rts



; TEXT BOX SUBROUTINES
; --------------------------------------------------------------------------------------------------

ClearTextBox:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_TextBoxL1						; set VRAM address to beginning of line 1
	stx	VMADDL

	dma_0	$09, SRC_0000, VMDATAL, 184*16				; 184 tiles

	lda	#%00000010						; text box is empty now, so clear the "clear text box" flag
	trb	<DP2.TextBoxStatus

	rts



; "FlushVWFTileBuffer" as a function consists of two parts:
; 1. Transfer contents of LO8.VWF_TileBuffer to VRAM (this subroutine)
; 2. Copy contents of LO8.VWF_TileBuffer2 to LO8.VWF_TileBuffer,
;    this is done where appropriate (i.e., after the "VWF buffer full"
;    bit was set and one frame has elapsed to do part 1) during active
;    display as no more VRAM writing is involved.

FlushVWFTileBuffer:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	lda	<DP2.DiagTileCounter					; load tile number and convert to VRAM address

	Accu16

	and	#$00FF							; clear high byte
	lsh	4							; multiply by 16 (not 32 because of VRAM word addressing) for actual address offset
	clc								; add base address for BG2 font tiles (+ 32 empty tiles),
	adc	#VRAM_TextBoxL1						; this is done here because DP2.DiagTileCounter is zero-based
	sta	VMADDL							; store as VRAM address

	ldy	#0							; transfer VWF tile buffer to VRAM
-	lda	LO8.VWF_TileBuffer, y					; copy font tiles
	sta	VMDATAL
	iny
	iny
	cpy	#32							; 2 tiles, 16 bytes per tile
	bne	-

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

	dma_0	$08, SRC_0000, WMDATA, 192				; DP2.TextBoxBG is zero, so make background black

	bra	@LoadTextBoxBGDone

+	Accu16								; DP2.TextBoxBG is not zero, calculate DMA parameters for the text box "scrolling" animations to look correctly (obviously not needed with solid black background)

	and	#$00FF							; clear high byte
	asl	a							; use as index into offset pointer table
	tax
	lda.l	SRC_TextBoxGradient, x					; read and set source data offset for upcoming DMA
	sta	A1T0L



; Calculate DMA data length based on current IRQ scanline (e.g. when text box has fully "scrolled in": 224 - 176 = 48; 48 * 4 = 192)
	lda	<DP2.TextBoxVIRQ					; perform 16-bit subtraction 224-DP2.TextBoxVIRQ (which is an 8-bit variable) by doing -DP2.TextBoxVIRQ+224 instead
	and	#$00FF							; clear high byte
	eor	#$FFFF							; make number negative (two's complement)
	ina
	clc								; add 224
	adc	#224
	bne	+							; if zero at this point, jump out (otherwise we'd end up with a disastrous transfer of 65,536 bytes)

	Accu8

	bra	@LoadTextBoxBGDone

.ACCU 16

+	lsh	2							; scanline difference (i.e., text box height) not zero, continue calculation
	sta	DAS0L							; set calculated data length



; Next, calculate WRAM address based on value of DP2.TextBoxVIRQ (e.g. 176 * 4 - 704 = 0)
	lda	<DP2.TextBoxVIRQ
	and	#$00FF							; clear high byte once again
	lsh	2
	clc
	adc	#loword(RAM.HDMA_BackgrPlayfield)			; use playfield background as a base to save the subtraction of 704
	sta	WMADDL

	Accu8

	stz	WMADDH							; array is in bank $7E
 	stz	DMAP0							; DMA mode $00
	lda	#<WMDATA						; B bus register
	sta	BBAD0
	lda	#:SRC_HDMA_TextBoxGradientBlue				; source data bank
	sta	A1B0
	lda	#kDMA_Channel0						; initiate DMA transfer
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

	dma_0	$09, SRC_FFFF, VMDATAL, 1920				; no portrait wanted, so put masking tiles over portrait
	dma_0	$0A, SRC_0000, CGDATA, 32				; and zero out palette

	bra	@PortraitUpdateDone

+	Accu16								; portrait no. in A

	and	#$00FF							; clear high byte
	asl	a
	tax								; make portrait no. = index in GFX pointer table
	lda.l	SRC_CharPortraitGFX, x
	sta	A1T0L							; data offset
	ldy	#<VMDATAL<<8|$01					; B bus register (high byte), DMA mode (low byte)
 	sty	DMAP0

	Accu8

	lda	#:SRC_Portrait_Hero1					; data bank (all portraits need to be in the same bank)
	sta	A1B0
	ldy	#1920							; data length
	sty	DAS0L
	lda	#kDMA_Channel0						; initiate DMA transfer
	sta	MDMAEN

	Accu16

	lda.l	SRC_CharPortraitPalette, x				; index is still in X, use that for correct palette
	sta	A1T0L							; data offset
 	ldx	#<CGDATA<<8|$02						; B bus register (high byte), DMA mode (low byte)
	stx	DMAP0

	Accu8

	lda	#:SRC_Palette_Portrait_Hero1				; data bank (all portrait palettes need to be in the same bank)
	sta	A1B0
	ldx	#32							; data length (16 colors)
	stx	DAS0L
	lda	#kDMA_Channel0						; initiate DMA transfer
	sta	MDMAEN

@PortraitUpdateDone:
	lda	#%10000000						; portrait updated, clear request flag
	trb	<DP2.TextBoxCharPortrait

	rts



; EOF
