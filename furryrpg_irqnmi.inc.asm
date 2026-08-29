; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	IRQ & NMI HANDLERS
;
; ==================================================================================================



; SOFTWARE INTERRUPTS & ERROR HANDLER
; --------------------------------------------------------------------------------------------------

EmptyHandler:
	rti

JumpBRK:
JumpCOP:
	jml	ErrorHandler						; not even necessary ($40:8000-FFFF mirrored to $00:8000-FFFF), but let's keep things consistent



; For software errors, we actively use the BRK instruction along with a known error code as the
; signature byte (error code list in variables.inc.asm).
; Caveat: Unintended BRK/COP (e.g. when crashing due to wrong Accu size) may falsely yield defined
; error codes, depending on the next byte after the instruction (should be obvious when it happens).

ErrorHandler:
	AccuIndex16

	pha								; preserve registers (processor status already pushed by BRK/COP)
	phx
	phy

	set	"Direct_Page", DP2

	Accu8

	lda	#$00							; disable NMI (IRQ disable flag already set by BRK/COP)
	sta.l	NMITIMEN

	set	"Data_Bank", $00

	stz	HDMAEN							; disable HDMA
	lda	#kForcedBlank
	sta	INIDISP

	lda	8, s							; load BRK/COP signature byte address (can't use Stack Relative Indirect Indexed addressing here unfortunately because the program counter already pointed to the next byte when it was pushed onto the stack)
	dea								; decrement low byte of program counter to signature byte address (i.e., make up for automatic PC increment)
	sta	<DP2.DataAddress
	lda	9, s
	sta	<DP2.DataAddress+1
	lda	10, s
	sta	<DP2.DataBank
	lda	[<DP2.DataAddress]					; read and save BRK/COP signature byte
	sta	<DP2.ErrorCode



; Clear BG3 tilemap buffer
	ldx	#loword(RAM.BG3Tilemap)
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 2048

;	jsr	SetBG3TilesPriority					; not needed, we only use BG3 anyway



; 8x8 font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#kVRAM_BG3_Tiles
	stx	VMADDL

	dma_0	$01, SRC_Font8x8, VMDATAL, 2048



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



; Register settings
	lda	#kBGMODE_1						; set BG mode 1
	sta	BGMODE
	lda	#$48							; VRAM address for BG3 tilemap: $4800, size: 32×32 tiles
	sta	BG3SC
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	BG34NBA
	lda	#kTM_BG3						; turn on BG3 only
	sta	TM							; on the mainscreen



; Print error info
	PrintString	3, 2, kTextBG3, "Software error!"
	PrintString	6, 2, kTextBG3, "Error type:"

	lda	<DP2.ErrorCode

	Accu16

	and	#$00FF							; clear high byte
	asl	a							; SRC_ErrorCode has 2-byte entries
	tax
	phx								; preserve error code index while printing
	lda.l	SRC_ErrorCode, x					; load pointer to error code name
	sta	<DP2.DataAddress

	Accu8

	lda	#:SRC_ErrorCode
	sta	<DP2.DataBank

	PrintString	7, 2, kTextBG3, "%s"				; print error code name



; Print extra info depending on error type
	plx								; restore error code index
	jmp	(@SRC_ErrorCodeInfo, x)

@SRC_ErrorCodeInfo:
	.DW @ErrorCorruptROM
	.DW @ErrorSPC700

.REPEAT 254
	.DW @ErrorUnknown
.ENDR

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

	jmp	@ExtraInfoDone

@ErrorUnknown:
	PrintString	10, 2, kTextBG3, "BRK/COP signature byte: $"
	PrintHexNum	<DP2.ErrorCode

	PrintString	12, 2, kTextBG3, "PC: $"

	lda	10, s							; PC bank
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	9, s							; PC middle byte
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

	lda	8, s							; PC low byte
	dea								; make up for automatic program counter increment
	dea
	sta	<DP2.Temp

	PrintHexNum	<DP2.Temp

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



; Update BG3 tilemap (NMI remains disabled)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#kVRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	dma_0	$01, RAM.BG3Tilemap, VMDATAL, 2048



; Turn screen back on, put CPU to sleep
	lda	#kINIDISP_15
	sta	INIDISP
	stp								; halt the CPU



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
	lda	#hibyte(kVRAM_BG1_Tilemap3)				; VRAM address for BG1 tilemap, size: 32×32 tiles
	sta	BG1SC
	lda	#hibyte(kVRAM_BG2_Tilemap3)				; VRAM address for BG2 tilemap, size: 32×32 tiles
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



Vblank_Area:								; FIXME slowdowns (sprite animation + text)
	Accu8



; Update text box
	lda	<DP2.TextBoxPortrait+1					; check for "change character portrait" flag
	bpl	+
	jsr	UpdateCharPortrait

+	lda	<DP2.TextBoxBG						; check if text box background change requested
	bpl	+
	jsr	LoadTextBoxBG						; bit 7 set --> load new background color table

+	bit	<DP2.TextBoxStatus					; check text box status
	bvs	@WaitOrDontClearTB					; bit 6 set --> wait for player input before e.g. clearing text box

	lda	<DP2.TextBoxStatus
	bit	#kTextBoxStatusClear					; check for "clear text box"
	beq	@WaitOrDontClearTB
	and	#kTextBoxStatusClear~$FF				; clear bit 1 while we're at it
	sta	<DP2.TextBoxStatus
	jsr	ClearTextBox						; bit 1 was set and "wait" flag clear --> wipe text
	bra	@SkipRefreshes						; ... and skip BG refreshes (to avoid glitches due to premature end of Vblank)

@WaitOrDontClearTB:
	lda	<DP2.VWF_BufferIndex					; check if 2 buffer tiles full
	cmp	#32							; 2 tiles × 16 = beyond max. buffer index
	bcs	+
	lda	<DP2.TextBoxStatus
	and	#kTextBoxStatusFlush					; flush VWF buffer? (forced e.g. when end of string reached)
	beq	@TextBoxDone

+	jsr	FlushVWFTileBuffer
	bra	@SkipRefreshes						; skip BG refreshes // FIXME do sprites still

@TextBoxDone:



; Animate playable character
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#kVRAM_Sprites+$800					; set VRAM address for sprite tiles, skip sprite font
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



; BG1/BG2 scrolling done via HDMA

; BG3 scrolling: add when needed
;	lda	#$FF
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
	ldx	#kVRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
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
	shr	3							; shift right for 13-bit value

	Accu8

	sta	BG1HOFS							; BG1HOFS/M7HOFS
	xba
	sta	BG1HOFS

	Accu16

	lda	<DP2.Mode7_ScrollOffsetY
	shr	3

	Accu8

	sta	BG1VOFS							; BG1VOFS/M7VOFS
	xba
	sta	BG1VOFS

	Accu16

	lda	<DP2.Mode7_CenterCoordX
	shr	3

	Accu8

	sta	M7X							; Mode 7 center position X register (low)
	xba
	sta	M7X							; Mode 7 center position X register (high)

	Accu16

	lda	<DP2.Mode7_CenterCoordY
	shr	3

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



; Copy over scroll displacement table to HDMA array
	ldx	#loword(RAM.ScratchSpace)				; source
	ldy	#loword(RAM.HDMA_WorMapVScroll+kWorldMapSkyLines*2)	; destination (with offset added for sky)
	lda	#hibyte(kWorldMapScrollDispSize-1)			; data length (i.e., #kWorldMapScrollDispSize bytes are transferred)
	xba
	lda	#lobyte(kWorldMapScrollDispSize-1)
	phb								; preserve DBR (changed to destination by the following block move instruction)
	mvn	bankbyte(RAM.ScratchSpace), bankbyte(RAM.HDMA_WorMapVScroll)	; $7E (src), $7E (dest) (but reversed in object code)
	plb								; restore DBR



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
	sta	13, s							; overwrite original location from where NMI was called (1, s = PHP in this subroutine, 3, s = return address of this subroutine, 9, s = Accu pushed at beginning of Vblank, 10, s = status register pushed when NMI fired, 11, s = return address for GlobalNMI subroutine)

	Accu8

	lda	#:SoftReset						; overwrite bank byte as well, so after rti, the program continues at SoftReset
	sta	15, s

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
	ldx	#kVRAM_BG1_Tilemap1					; set VRAM address to BG1 tilemap
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
	ldx	#kVRAM_BG1_Tilemap2					; set VRAM address to BG1 tilemap
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
	ldx	#kVRAM_BG2_Tilemap1					; set VRAM address to BG2 tilemap
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
	ldx	#kVRAM_BG2_Tilemap2					; set VRAM address to BG2 tilemap
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
	ldx	#kVRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
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
	ldx	#kVRAM_TextBoxL1					; set VRAM address to beginning of line 1
	stx	VMADDL

	dma_0	$09, SRC_0000, VMDATAL, 184*16				; 184 tiles

	rts



FlushVWFTileBuffer:

; First, transfer contents of LO8.VWF_TileBuffer to VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	lda	<DP2.VWF_TileCounter					; load tile number and convert to VRAM address

	Accu16

	and	#$00FF							; clear high byte
	shl	4							; multiply by 16 (not 32 because of VRAM word addressing) for actual address offset
	sta	VMADDL							; store as VRAM address

	Accu8

	dma_0	$01, LO8.VWF_TileBuffer, VMDATAL, 32			; DMA is about one and a half scanlines faster than manual copying

; Next, copy contents of LO8.VWF_TileBuffer2 to LO8.VWF_TileBuffer, and clear the latter. This part
; is another ~1,5 scanlines faster than the old FlushVWFTileBuffer2 routine.
	Accu16

	ldx	#LO8.VWF_TileBuffer2					; source
	ldy	#LO8.VWF_TileBuffer					; destination
	lda	#31							; data length = 31 (i.e., 32 bytes are transferred)
;	phb								; preserve DBR // not needed, DB is/remains $00
	mvn	bankbyte(LO8.VWF_TileBuffer2), bankbyte(LO8.VWF_TileBuffer)	; $00 (src), $00 (dest) (but reversed in object code)
;	plb								; restore DBR (see above)

	stz	<DP2.VWF_BufferIndex					; reset buffer index with Accu still 16-bit

	Accu8

	set	"WRAM_port", LO8.VWF_TileBuffer2
	dma_0	$08, SRC_0000, WMDATA, 32				; clear upper buffer

	inc	<DP2.VWF_TileCounter					; increment tile counter to next 16×8 tile
	lda	#kTextBoxStatusFlush					; done, clear "flush buffer" bit
	trb	<DP2.TextBoxStatus					; 2 + 5 cycles (but lda/and/sta is even slower)

	rts



LoadTextBoxBG:
	set	"WRAM_port", RAM.HDMA_BG_TextBox

	lda	<DP2.TextBoxBG
	and	#%01111111						; mask off "change background" request bit
	sta	<DP2.TextBoxBG						; write back value (i.e., clear "change background" request bit)
	bne	+

	dma_0	$08, SRC_0000, WMDATA, _sizeof_RAM.HDMA_BG_TextBox	; value zero --> make background black

	rts

+	Accu16								; value not zero, set DMA parameters for wanted BG gradient

	and	#$00FF							; clear high byte
	tax								; use as index into offset pointer table
	lda.l	SRC_TextBoxGradient, x					; read and set source data offset for upcoming DMA
	sta	A1T0L

	Accu8

 	stz	DMAP0							; DMA mode $00
	lda	#<WMDATA						; B bus register
	sta	BBAD0
	lda	#bankbyte(SRC_HDMA_TextBoxGradientBlue)			; source data bank
	sta	A1B0
	ldx	#_sizeof_RAM.HDMA_BG_TextBox
	stx	DAS0L
	lda	#kDMA_Channel0						; initiate DMA transfer
	sta	MDMAEN

	rts



UpdateCharPortrait:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#kVRAM_Portrait						; set VRAM address to char portrait
	stx	VMADDL
	lda	#kCGRAM_Portrait					; set CGRAM address for character portrait
	sta	CGADD

	Accu16

	lda	<DP2.TextBoxPortrait					; check for portrait no., zero = no portrait
	and	#$7FFF							; mask off "change portrait" request bit
	sta	<DP2.TextBoxPortrait					; write back value (i.e., clear "change portrait" request bit)
	bne	+

	Accu8								; value zero --> no portrait wanted

	dma_0	$09, SRC_FFFF, VMDATAL, 1920				; put masking tiles over portrait
	dma_0	$0A, SRC_0000, CGDATA, 32				; zero out palette

	rts

.ACCU 16

+	tax								; make portrait no. = index in GFX pointer table
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

	rts



; EOF
