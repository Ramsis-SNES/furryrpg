; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	MAIN GAME CODE
;
; ==================================================================================================



Startup:
	rep	#kAI8|kDecimal						; A/X/Y = 16 bit, decimal mode off

	set	"Stack_Pointer", P01.InitStack
	set	"Direct_Page", DP2					; #2 is standard for now

	Accu8

	set	"Data_Bank", $00

	jsr	InitRegisters
	jsr	InitAllRAM



; copy RAM routines to WRAM
	ldx	#loword(RAM.Routines)					; set WRAM address to RAM routines section
	stx	WMADDL
	stz	WMADDH

	dma_0	$00, SRC_RAM_Routines, WMDATA, _sizeof_SRC_RAM_Routines



; set up HDMA channel 2: main backdrop color
	lda	#%01000011						; transfer mode (4 bytes --> $2121, $2121, $2122, $2122), indirect table mode
	sta	DMAP2
	lda	#<CGADD							; PPU register $2121 (color index)
	sta	BBAD2
	ldx	#SRC_HDMA_ColorGradient
	stx	A1T2L
	lda	#:SRC_HDMA_ColorGradient
	sta	A1B2
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB2



; load and initialize SNESGSS sound driver
	jsr	InitSNESGSS



; more hardware checks/initialization
	jsl	CheckHardware						; check if special hardware and/or enhancement chips like MSU1, RTC etc. are available
	jsl	CheckSRAM						; check SRAM integrity, clear SRAM if corrupt
	jsr	SpriteInit						; set up the sprite buffer (LO8.ShadowOAM_Lo)
	jsr	SpriteDataInit



; check SRAM for game state (only ROM integrity for now)
	lda	SRAM.GameState
	and	#kGameStateGoodROM
	bne	@GameStateGoodROM
	jsr	CheckROMIntegrity					; back here means ROM good

	lda	#kGameStateGoodROM					; remember that ROM integrity check was passed
	sta	<DP2.Temp						; source data in DP2.Temp
	ldx	#DP2.Temp						; source data offset
	stx	<DP2.DataAddress
	lda	#$7E							; source data bank
	sta	<DP2.DataBank
	ldx	#loword(SRAM.GameState) + 1				; destination offset + data length
	ldy	#1							; data length (also src index)
	jsl	WriteDataToSRAM

@GameStateGoodROM:
;	jmp	VSplitscreenTest
;	jmp	StaticRenderingTest
;	jmp	DynamicRenderingTest

.IFDEF	DEBUG

	jml	DebugMenu

.ENDIF

	set	"NMI", Vblank_Intro

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	NMITIMEN
	sta	LO8.NMITIMEN
	cli

	jsl	ShowAlphaIntro

	jsl	ShowTitleScreen



; go to save manager/main game menu <-- possibly enter main game loop here, and use some variable bit to check for current game state?

MainGameLoop:
	; do stuff before next Vblank here

	wait	"frames", 1

	Accu16

	set	"Direct_Page", DP2					; set up the Direct Page for main game loop stuff

	Accu8

	set	"Data_Bank", $00

	lda	DP2.GameConfig
	; check bits

	jsr	UpdateGameTime

	; create RND numbers

	; we have work to do ...

	jmp	MainGameLoop



InitRegisters:
	phd								; preserve D register

	Accu16

	set	"Direct_Page", $2100					; set DP to PPU registers for faster access

	Accu8

	lda	#kForcedBlank
	sta	<INIDISP
	stz	<OBSEL							; regs $2101-$210C: set sprite, character, tile sizes to lowest, and set addresses to $0000
	stz	<OAMADDL
	stz	<OAMADDH

	; reg $2104: OAM data write

	stz	<BGMODE
	stz	<MOSAIC
	stz	<BG1SC
	stz	<BG2SC
	stz	<BG3SC
	stz	<BG4SC
	stz	<BG12NBA
	stz	<BG34NBA
	stz	<BG1HOFS						; regs $210D-$2114: set all BG scroll values to $0000
	stz	<BG1HOFS
	stz	<BG1VOFS
	stz	<BG1VOFS
	stz	<BG2HOFS
	stz	<BG2HOFS
	stz	<BG2VOFS
	stz	<BG2VOFS
	stz	<BG3HOFS
	stz	<BG3HOFS
	stz	<BG3VOFS
	stz	<BG3VOFS
	stz	<BG4HOFS
	stz	<BG4HOFS
	stz	<BG4VOFS
	stz	<BG4VOFS

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	<VMAIN
	stz	<VMADDL							; regs $2116-$2117: VRAM address
	stz	<VMADDH

	; skip regs $2118-2119 (VRAM data write)

	stz	<M7SEL
	stz	<M7A							; regs $211B-$2120: Mode7 matrix values
	lda	#$01
	sta	<M7A
	stz	<M7B
	stz	<M7B
	stz	<M7C
	stz	<M7C
	stz	<M7D
;	lda	#$01							; never mind, 8-bit Accu still contains $01
	sta	<M7D
	stz	<M7X
	stz	<M7X
	stz	<M7Y
	stz	<M7Y
	stz	<CGADD

	; skip reg $2122 (CGRAM data write)

	stz	<W12SEL							; regs $2123-$2133: turn off windows, main screens, sub screens, color addition,
	stz	<W34SEL							; fixed color = $00, no super-impose (external synchronization), no interlace, normal resolution
	stz	<WOBJSEL
	stz	<WH0
	stz	<WH1
	stz	<WH2
	stz	<WH3
	stz	<WBGLOG
	stz	<WOBJLOG
	stz	<TM
	stz	<TS
	stz	<TMW
	stz	<TSW

	lda	#$30
	sta	<CGWSEL
	stz	<CGADSUB

	lda	#$E0
	sta	<COLDATA
	stz	<SETINI

	; skip regs $2134-$213F (PPU read registers)
	; skip regs $2140-$2143 (APU communication)
	; skip reg $2180 (WRAM data read/write)

	stz	<WMADDL							; regs $2181-$2183: WRAM address
	stz	<WMADDM
	stz	<WMADDH

	; regs $4016-$4017: serial JoyPad read registers, no need to initialize

	Accu16

	set	"Direct_Page", $4200					; set DP to CPU registers

	Accu8

	stz	<NMITIMEN						; reg $4200: disable NMI, IRQ, and auto joypad read
	lda	#kWRIO_Joy1|kWRIO_Joy2					; I/O port: read joypads 1 and 2
	sta	<WRIO							; reg $4201: programmable I/O write port
	stz	<WRMPYA							; regs $4202-$4203: multiplication registers
	stz	<WRMPYB
	stz	<WRDIVL							; regs $4204-$4206: division registers
	stz	<WRDIVH
	stz	<WRDIVB							; this causes a division by 0 (which the SNES happily tolerates)
	stz	<HTIMEL							; regs $4207-$4208: Horizontal-IRQ timer setting
	stz	<HTIMEH
	stz	<VTIMEL							; regs $4209-$420A: Vertical-IRQ timer setting
	stz	<VTIMEH
	stz	<MDMAEN							; reg $420B: turn off all general DMA channels
	stz	<HDMAEN							; reg $420C: turn off all HDMA channels
	lda	#kFastROM						; reg $420D: set Memory-2 area to 3.58 MHz (FastROM)
	sta	<MEMSEL

	; skip:
	; regs $420E-$420F (unused registers)
	; reg $4210 (RDNMI)
	; reg $4211 (IRQ status)
	; reg $4212 (H/V-blank flag and JoyRead status)
	; reg $4213 (programmable I/O port)
	; regs $4214-$4215 (division result)
	; regs $4216-$4217 (multiplication product or division remainder)
	; regs $4218-$421F (JoyPad read registers)
	; regs $4300-$437F (DMA/HDMA parameters)

	stz	UNUSED0							; regs $43xB: unused registers (actually used temporarily down below)
	stz	UNUSED1
	stz	UNUSED2
	stz	UNUSED3
	stz	UNUSED4
	stz	UNUSED5
	stz	UNUSED6
	stz	UNUSED7

	pld								; restore D register

	rts



InitAllRAM:

; check for 128K VRAM expansion, VMAIN and VMADDL/H are already set up correctly
;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	VMAIN
;	stz	VMADDL							; reset VRAM address
;	stz	VMADDH

	ldx	#$1234							; write test value to VRAM address $0000
	stx	VMDATAL
	ldx	#$8000							; set VRAM address to $8000
	stx	VMADDL
	ldx	#$5678							; write a different test value to VRAM address $8000
	stx	VMDATAL
	stz	VMADDL							; reset VRAM address
	stz	VMADDH
	ldx	RDVRAML							; read VRAM address $0000 ...
	ldx	RDVRAML							; ... twice for good measure (cf. Fullsnes on VRAM read registers)
	cpx	#$1234							; on stock SNES, this should read back $5678
	bne	@VRAM128KDone

@VRAM128K:
	lda	#kGameConfigVRAM					; remember that VRAM expansion is present
	sta	UNUSED0							; using UNUSED0 as WRAM is cleared shortly

@VRAM128KDone:
	lda	1, s							; save return address before WRAM gets cleared
	sta	UNUSED1
	lda	2, s
	sta	UNUSED2

; clear all directly accessible RAM areas (with most parameters/addresses set in InitRegisters routine)
	stz	VMADDL							; reset VRAM address once again
	stz	VMADDH

	dma_0	$09, SRC_0000, VMDATAL, 0				; VRAM (length 0 = 65,536 bytes)
	dma_0	$08, SRC_0000, CGDATA, 512				; CGRAM (512 bytes)
	dma_0	$08, SRC_0000, OAMDATA, 544				; OAM (low+high OAM tables = 512+32 bytes)
	dma_0	$08, SRC_0000, WMDATA, 0				; WRAM (length 0 = 65,536 bytes = lower 64K of WRAM)

;	lda	#kDMA_Channel0						; never mind, Accu still holds this value
	sta	MDMAEN							; WRAM address in $2181-$2183 has reached $10000 now, re-initiate DMA transfer for the upper 64K of WRAM

	lda	UNUSED0							; write VRAM size bit to GameConfig
	sta	<DP2.GameConfig
	and	#kGameConfigVRAM					; check for 128K VRAM expansion again
	beq	@ClearRAMDone
	ldx	#$8000							; 128K of VRAM present, set VRAM address to $8000 (TESTME, shouldn't even be necessary)
	stx	VMADDL

	dma_0	$09, SRC_0000, VMDATAL, 0				; clear upper 64K of VRAM (length 0 = 65,536 bytes)

@ClearRAMDone:
	lda	UNUSED1							; restore return address
	sta	1, s
	lda	UNUSED2
	sta	2, s

	rts



; intro / title screen

ShowAlphaIntro:
	jsl	DisableInterrupts

	lda	#kForcedBlank
	sta	INIDISP

	SNESGSS_Command kGSS_MUSIC_STOP, 0				; stop music in case it's playing

	ldx	#loword(RAM.BG1Tilemap1)				; clear BG1/2 tilemap buffers
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 8192

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#$0000
	stx	VMADDL

	dma_0	$09, SRC_0000, VMDATAL, 0				; clear VRAM

	lda	#kBGMODE_5						; set BG Mode 5
	sta	RAM_BGMODE
	lda	#$50							; VRAM address for BG1 tilemap: $5000, size: 32×32 tiles
	sta	RAM_BG1SC
	lda	#$58							; VRAM address for BG2 tilemap: $5800, size: 32×32 tiles
	sta	RAM_BG2SC
	lda	#$20							; VRAM address for BG1 character data: $0000, BG2 character data: $2000
	sta	RAM_BG12NBA
	stz	BG1HOFS							; reset BG1 horizontal scroll
	stz	BG1HOFS
	stz	BG2HOFS							; reset BG2 horizontal scroll
	stz	BG2HOFS
	lda	#$FF							; scroll BG1 down by 1 px
	sta	BG1VOFS
	stz	BG1VOFS
;	lda	#$FF							; scroll BG2 down by 1 px
	sta	BG2VOFS
	stz	BG2VOFS
	lda	#kTM_BG1|kTM_BG2					; turn on BG1 and 2 only on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
	lda	#kPseudoH512
	sta	RAM_SETINI
	stz	CGADD							; reset CGRAM address
	stz	CGDATA							; $3C00 = blue background color
	lda	#$3C
	sta	CGDATA							; next DMA skips background color (2 bytes)

	dma_0	$02, SRC_Palettes_Text+2, CGDATA, 30

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#$0000							; set VRAM address for BG1 font tiles
	stx	VMADDL
	jsr	MakeMode5FontBG1

	ldx	#$2000							; set VRAM address for BG2 font tiles
	stx	VMADDL
	jsr	MakeMode5FontBG2

	ldx	#STR_Software_Title					; load address of string to print into DP2.DataAddress (24), print as sub-string
	stx	<DP2.DataAddress
	lda	#:STR_Software_Title
	sta	<DP2.DataBank

	PrintString	2, 2, kTextMode5, "%s"

	ldx	#STR_SoftwareBuild
	stx	<DP2.DataAddress
	lda	#:STR_SoftwareBuild
	sta	<DP2.DataBank

	PrintString	2, 19, kTextMode5, "%s"

	ldx	#STR_SoftwareMaker
	stx	<DP2.DataAddress
	lda	#:STR_SoftwareMaker
	sta	<DP2.DataBank

	PrintString	3, 2, kTextMode5, "%s"

	ldx	#STR_SoftwareBuildTime
	stx	<DP2.DataAddress
	lda	#:STR_SoftwareBuildTime
	sta	<DP2.DataBank

	PrintString	4, 2, kTextMode5, "%s"

	ldx	#STR_Disclaimer
	stx	<DP2.DataAddress
	lda	#:STR_Disclaimer
	sta	<DP2.DataBank

	PrintString	6, 2, kTextMode5, "%s"

	stz	VMAIN							; increment VRAM address by one word after writing to $2118
	ldx	#VRAM_BG1_Tilemap1					; set VRAM address for BG1 tilemap
	stx	VMADDL

	dma_0	$00, RAM.BG1Tilemap1, VMDATAL, 1024

	ldx	#VRAM_BG2_Tilemap1					; set VRAM address for BG2 tilemap
	stx	VMADDL

	dma_0	$00, RAM.BG2Tilemap1, VMDATAL, 1024

	set	"NMI", Vblank_Intro

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts
	sta	NMITIMEN
	cli

	Accu16

	lda	#0							; rest of intro = event #0
	jsl	LoadEvent

.ACCU 8

	lda	#kForcedBlank
	sta	RAM_INIDISP
	wai
	jsl	DisableInterrupts

	set	"NMI", Vblank_DebugMenu

.IFNDEF NOMUSIC

	SNESGSS_Command kGSS_GLOBAL_VOLUME, $1000			; fade-out intro song (fade speed: 16, global volume: 00)

	Accu8

.ENDIF

	ldx	#$0000
	stx	VMADDL

	dma_0	$09, SRC_0000, VMDATAL, 0				; clear VRAM

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	NMITIMEN
	sta	LO8.NMITIMEN
	cli

	rtl



ShowTitleScreen:

; load GFX, music



@Loop:

	wait	"frames", 1



; check for Start
	lda	<DP2.Joy1+1
	and	#kButtonStart
	beq	@StartButtonDone

	; Start pressed

@StartButtonDone:

	jmp	@Loop



; HARDWARE EVALUATION
; --------------------------------------------------------------------------------------------------

CheckHardware:



; check if MSU1 present
	lda	MSU_ID							; check for "S-MSU1"
	cmp	#'S'
	bne	@MSU1Done

	lda	MSU_ID+1
	cmp	#'-'
	bne	@MSU1Done

	lda	MSU_ID+2
	cmp	#'M'
	bne	@MSU1Done

	lda	MSU_ID+3
	cmp	#'S'
	bne	@MSU1Done

	lda	MSU_ID+4
	cmp	#'U'
	bne	@MSU1Done

	lda	MSU_ID+5
	cmp	#'1'
	bne	@MSU1Done

@MSU1Present:
	lda	#kGameConfigMSU1
	tsb	<DP2.GameConfig						; set "MSU1 present" flag

@MSU1Done:



; check if Sharp S-RTC present
	lda	#$0D							; probe S-RTC register by sending "get time" command
	sta	SRTC_WRITE

	lda	SRTC_READ						; first read should always return $0F
	and	#$0F							; mask off open-bus bits
	cmp	#$0F
	bne	@SRTCDone

@SRTCPresent:
	lda	#kGameConfigRTC
	tsb	<DP2.GameConfig						; set "S-RTC present" flag

@SRTCDone:



; check if console is Ultra16
	lda	#$AA							; attempt to unlock U16 registers
	sta	ULTRA16_LOCK

	lda	ULTRA16_DATA
	ora	#$40							; attempt to toggle LED (?)
	sta	ULTRA16_DATA

	lda	ULTRA16_LOCK
	cmp	#$55
	bne	@Ultra16Done

@Ultra16Present:
	lda	#kGameConfigU16
	tsb	<DP2.GameConfig						; set "Ultra16 present" flag

;	lda	ULTRA16_SNUM						; copy U16 serial number, maybe use this for some Easter egg?
;	sta	somewhere

@Ultra16Done:

	rtl



CheckROMIntegrity:
	jsr	SetupDebugRegsGFX					; load font, set up screen regs

	lda	#kINIDISP_15						; turn on the screen
	sta	RAM_INIDISP

.IFNDEF DEBUG

	PrintString	2, 3, kTextBG3, "Checking cartridge,"
	PrintString	3, 3, kTextBG3, "please wait ..."

	; FIXME, add animation/progress bar

.ELSE

	PrintString	2, 3, kTextBG3, "ROM integrity check"
	PrintString	3, 3, kTextBG3, "-------------------"
	PrintString	5, 3, kTextBG3, "This is done only once to"
	PrintString	6, 3, kTextBG3, "ensure the ROM is valid."
	PrintString	8, 3, kTextBG3, "Please wait ..."
	PrintString	9, 3, kTextBG3, "Reading bank $"

.ENDIF

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates



; read bank $C0 (special case as it contains checksum and checksum complement)
	lda	#$C0							; set start bank to $C0
	sta	<DP2.DataBank

.IFDEF DEBUG

	SetTextPos	9, 17
	PrintHexNum	<DP2.DataBank

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates

.ENDIF

	Accu16

	stz	<DP2.DataAddress					; reset address
	lda	#$05FA							; checksum & checksum complement always add up to $1FE, so add these right now (3 times because banks $40...$5F will be read twice)
	sta	<DP2.Temp+3
	ldy	#0
-	lda	[<DP2.DataAddress], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#$FFDC							; location of checksum complement & checksum reached?
	bne	-

	ldy	#$FFE0							; skip both
-	lda	[<DP2.DataAddress], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	bne	-

	Accu8

	inc	<DP2.DataBank						; increment bank byte



; read banks $C1...$FF

@ReadNextBank:

.IFDEF DEBUG

	SetTextPos	9, 17
	PrintHexNum	<DP2.DataBank

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates

.ENDIF

	Accu16

	ldy	#0
-	lda	[<DP2.DataAddress], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	bne	-

	Accu8

	inc	<DP2.DataBank						; increment bank byte
	bne	@ReadNextBank						; bank $FF done (wrapped around to 0)?



; read banks $40...$5F twice (see Fullsnes notes on ROM sizes and checksumming)
	jsr	ReadBanks40thru5F
	jsr	ReadBanks40thru5F



; compare checksums
	Accu16

	lda	<DP2.Temp+3
	cmp	$C0FFDE							; compare sum to "HiROM" checksum
	bne	@CorruptROM
	cmp	$40FFDE							; compare sum to "ExHiROM" checksum
	bne	@CorruptROM
	eor	#$FFFF							; invert sum (i.e., Accu now contains NOT sum)
	cmp	$C0FFDC							; compare inverted sum to "HiROM" checksum complement
	bne	@CorruptROM
	cmp	$40FFDC							; compare inverted sum to "ExHiROM" checksum complement
	bne	@CorruptROM

@GoodROM:
	Accu8

	rts

@CorruptROM:
	brk	kErrorCorruptROM



ReadBanks40thru5F:

; read bank $40 (special case as it contains checksum and checksum complement)
	lda	#$40							; set start bank to $40
	sta	<DP2.DataBank

.IFDEF DEBUG

	SetTextPos	9, 17
	PrintHexNum	<DP2.DataBank

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates

.ENDIF

	Accu16

	stz	<DP2.DataAddress					; reset address
	ldy	#0
-	lda	[<DP2.DataAddress], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#$FFDC							; location of checksum complement & checksum reached?
	bne	-

	ldy	#$FFE0							; skip both
-	lda	[<DP2.DataAddress], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	bne	-

	Accu8

	inc	<DP2.DataBank						; increment bank byte



; read banks $41...$5F

@ReadNextBank:

.IFDEF DEBUG

	SetTextPos	9, 17
	PrintHexNum	<DP2.DataBank

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates

.ENDIF

	Accu16

	ldy	#0
-	lda	[<DP2.DataAddress], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	bne	-

	Accu8

	lda	<DP2.DataBank						; increment bank byte
	ina
	sta	<DP2.DataBank
	cmp	#$60							; all banks done?
	bne	@ReadNextBank

	rts



; COMMON SUBROUTINES
; --------------------------------------------------------------------------------------------------

.ACCU 8

DisableInterrupts:
	sei
	lda	#$00
	sta.l	NMITIMEN						; use 24-bit addressing
	; FIXME add mirror var here?

	rtl



; SPRITE SUBROUTINES
; --------------------------------------------------------------------------------------------------

ConvertSpriteDataToBuffer:						; routine expects source data address set in WMADD<L/M/H>

; RAM.SpriteData* each consist of 128 5-byte-long entries of the
; following format:
;
; Byte 0 - X coordinate: lower 8 of 9 bits
; Byte 1 - X coordinate: 9th bit (bit 0), OBJ size (bit 1, bits 2-7 always clear)
; Byte 2 - Y coordinate: 8 bits total
; Byte 3 - Tile number: lower 8 of 9 bits (bit 9 = bit 0 of Attributes)
; Byte 4 - Attributes (as in FullSNES)
;
; This routine, which should be called once per frame during active
; display, converts this data to OAM hi/lo format in LO8.ShadowOAM_Lo
; and LO8.ShadowOAM_Hi, to be DMAed to actual OAM during Vblank.

	phx								; preserve super-loop indices
	phy
	stz	<DP2.SprDataObjNo					; reset object counter
	ldx	#0							; X = index for LO8.ShadowOAM_Lo

@ConvertSpriteDataLoop:
	lda	WMDATA							; read X coordinate lower 8 bits
	sta	LO8.ShadowOAM_Lo, x
	inx



; do some bitwise operation magic for 9th bit of X coordinate and sprite size in high OAM
	lda	<DP2.SprDataObjNo
	and	#%00000011						; (object no. AND $03) * 2 = amount of (single) ASL operations required for correct bit pair in current high OAM byte
	asl	a
	sta	<DP2.Temp						; DP2.Temp = counter variable for upcoming bit-shifting loop
	lda	#%00000011						; keep track of bit pair position, assume bits 0-1 for now
	sta	<DP2.SprDataHiOAMBits
	lda	<DP2.SprDataObjNo					; next, prepare index for LO8.ShadowOAM_Hi
	rsh	2							; object no. RSH 2 = byte in high OAM containing bit pair of current object

	Accu16

	and	#$00FF							; clear high byte
	tay								; Y = index for LO8.ShadowOAM_Hi

	Accu8

	lda	WMDATA							; read X coordinate upper 1 bit (bit 0), OBJ size (bit 1)
	and	#%00000011						; mask off unused/irrelevant bits just in case
-	dec	<DP2.Temp						; decrement counter, this needs to be done first as it could be zero (= no bit-shifting needed at all)
	bmi	+							; counter has reached/is zero --> jump out
	asl	a							; shift bits left until correct bit pair reached
	asl	<DP2.SprDataHiOAMBits					; keep track of bit pair position (important for bits that need to be cleared)
	bra	-

+	sta	<DP2.Temp+1						; save bit pair in correct position
	ora	LO8.ShadowOAM_Hi, y					; set bit(s) that is/are to be set in current high OAM byte
	sta	LO8.ShadowOAM_Hi, y
	lda	<DP2.Temp+1						; load bit pair again
	eor	<DP2.SprDataHiOAMBits					; make set bits clear, and vice versa
	eor	#$FF							; \ these two instructions essentially replace a TRB instruction, which doesn't support indexed addressing
	and	LO8.ShadowOAM_Hi, y					; /
	sta	LO8.ShadowOAM_Hi, y



; rest is trivial
	lda	WMDATA							; read Y coordinate
	sta	LO8.ShadowOAM_Lo, x
	inx
	lda	WMDATA							; read tile no.
	sta	LO8.ShadowOAM_Lo, x
	inx
	lda	WMDATA							; read attributes
	sta	LO8.ShadowOAM_Lo, x
	inx
	inc	<DP2.SprDataObjNo					; increment object counter
	cpx	#512							; all 128 sprites done?
	bne	@ConvertSpriteDataLoop

	ply								; restore super-loop indices
	plx

	rts



ResetSprites:
	jsr	SpriteDataInit						; purge sprite data buffer

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer



SpriteDataInit:								; This routine sets up all available sprite data arrays (but not the OAM buffer itself) according to their respective in-game use.
	ldx	#0

	Accu16

@InitSprDataAreaLoop1:
	lda	#$00FF							; X coordinate (9 bits), sprite size (10th bit) 0 = small
	sta	RAM.SpriteDataArea, x					; initialize all sprites to be off the screen
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	RAM.SpriteDataArea, x
	inx

	Accu16

	lda	<DP2.EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; clear high byte
	sta	RAM.SpriteDataArea, x					; attributes, tile num
	inx
	inx
	cpx	#32*5							; sprite font done?
	bne	@InitSprDataAreaLoop1

@InitSprDataAreaLoop2:
	lda	#$02FF							; X coordinate (9 bits), sprite size (10th bit) 1 = large
	sta	RAM.SpriteDataArea, x
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	RAM.SpriteDataArea, x
	inx

	Accu16

	lda	<DP2.EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; clear high byte
	sta	RAM.SpriteDataArea, x					; attributes, tile num
	inx
	inx
	cpx	#128*5							; all sprites done?
	bne	@InitSprDataAreaLoop2

	ldx	#0

@InitSprDataMenuLoop:
	lda	#$02FF							; X coordinate (9 bits), sprite size (10th bit) 1 = large
	sta	RAM.SpriteDataMenu, x
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	RAM.SpriteDataMenu, x
	inx

	Accu16

	lda	<DP2.EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; clear high byte
	sta	RAM.SpriteDataMenu, x					; attributes, tile num
	inx
	inx
	cpx	#128*5							; all sprites done?
	bne	@InitSprDataMenuLoop

	Accu8

	rts



SpriteInit:								; This routine clears the OAM buffer // FIXME, change confusing sprite routine names, maybe get rid of this one completely
	php	

	AccuIndex16

	ldx	#$0000

@Init_OAM_lo:
	lda	#$E0FF
	sta	LO8.ShadowOAM_Lo, x					; initialize all sprites to be off the screen
	inx
	inx
	lda	<DP2.EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; clear high byte
	sta	LO8.ShadowOAM_Lo, x
	inx
	inx
	cpx	#$0200
	bne	@Init_OAM_lo

	Accu8

	ldx	#$0000

@Init_OAM_hi1:
	stz	LO8.ShadowOAM_Hi, x					; small sprites for the sprite font
	inx
	cpx	#8							; 8 * 4 = 32 sprites
	bne	@Init_OAM_hi1

	lda	#%10101010						; large sprites for everything else

@Init_OAM_hi2:
	sta	LO8.ShadowOAM_Hi, x
	inx
	cpx	#32
	bne	@Init_OAM_hi2

	plp

	rts



; RAM-BASED ROUTINES
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

SRC_RAM_Routines:

@BurstTransferSPC700:
	set	"Data_Bank", :SRC_SPC700_driver

;	ldx	#$023f							; prepare transfer address
	ldx	#$003f							; initial offset in SPC700 RAM (transfer routine below works by decrementing this)

; ---- Execute transfer routine

	ldy	#$0002
	sty	<APUIO2
	stz	<APUIO1
	lda	<APUIO0
	ina
	ina
	sta	<APUIO0
; Wait for acknowledgement
-	cmp	<APUIO0
	bne	-

; ---- Burst transfer of 63.5K using custom routine

@@outer_transfer_loop:
	ldy	#$003f							; 3
@@inner_transfer_loop:
	lda.w	SRC_SPC700_driver+$00,x	; #####	 examples		; 4 |
	sta	<APUIO0							; 3 |
	lda.w	SRC_SPC700_driver+$40,x					; 4 |
	sta	<APUIO1							; 3 |
	lda.w	SRC_SPC700_driver+$80,x					; 4 |
	sta	<APUIO2							; 3 |
	lda.w	SRC_SPC700_driver+$C0,x					; 4 |
	sta	<APUIO3							; 3 |
	tya								; 2 >> 30 cycles
-	cmp	<APUIO3							; 3 |
	bne	-							; 3 |
	dex								; 2 |
	dey								; 2 |
	bpl	@@inner_transfer_loop					; 3 >> 13 cycles

	rep	#$21							; 3 | // Accu16, clear carry
	txa								; 2 |
	adc	#$140							; 3 |
	tax								; 2 |

	Accu8								; 3 |

;	cpx	#$003f							; 3 |
	cpx	#$0A3F							; 3 | // $0A = 10 pages (2560 bytes) done?
	bne	@@outer_transfer_loop					; 3 >> 19 cycles

	rtl



@DMA:
	php								; preserve registers
	phb

	AccuIndex16

	pha
	phx
	phy

	Accu8

	set	"Data_Bank", $00					; for easier register access

	ldx	#$FFFF							; DMA mode (low byte), B bus register (high byte) // RAM_Routines.DMA + 14
 	stx	DMAP0
	ldx	#$FFFF							; data offset (16 bit) // RAM_Routines.DMA + 20
	stx	A1T0L
	lda	#$FF							; data bank (8 bit) // RAM_Routines.DMA + 26
	sta	A1B0
	ldx	#$FFFF							; data length (16 bit) // RAM_Routines.DMA + 31
	stx	DAS0L
	lda	#kDMA_Channel0						; initiate DMA transfer
	sta	MDMAEN

	AccuIndex16

	ply								; restore registers
	plx
	pla
	plb
	plp

	rtl



@UpdatePPURegs:
	php								; preserve CPU status
	phd								; preserve DP register

	AccuIndex16

	set	"Direct_Page", $2100					; set Direct Page to PPU registers

	Accu8



; update registers
	lda	#$0F							; + 11
	sta	<INIDISP
	lda	#$00							; + 15
	sta	<OBSEL
	lda	#$00							; + 19
	sta	<BGMODE
	lda	#$00							; + 23
	sta	<MOSAIC
	lda	#$00							; + 27
	sta	<BG1SC
	lda	#$00							; + 31
	sta	<BG2SC
	lda	#$00							; + 35
	sta	<BG3SC
	lda	#$00							; + 39
	sta	<BG4SC
	lda	#$00							; + 43
	sta	<BG12NBA
	lda	#$00							; + 47
	sta	<BG34NBA
	lda	#$00							; + 51
	sta	<W12SEL
	lda	#$00							; + 55
	sta	<W34SEL
	lda	#$00							; + 59
	sta	<WOBJSEL
	lda	#$00							; + 63
	sta	<WH0
	lda	#$00							; + 67
	sta	<WH1
	lda	#$00							; + 71
	sta	<WH2
	lda	#$00							; + 75
	sta	<WH3
	lda	#$00							; + 79
	sta	<WBGLOG
	lda	#$00							; + 83
	sta	<WOBJLOG
	lda	#$00							; + 87
	sta	<TM
	lda	#$00							; + 91
	sta	<TS
	lda	#$00							; + 95
	sta	<TMW
	lda	#$00							; + 99
	sta	<TSW
	lda	#$30							; + 103
	sta	<CGWSEL
	lda	#$00							; + 107
	sta	<CGADSUB
	lda	#$E0							; + 111
	sta	<COLDATA
	lda	#$00							; + 115
	sta	<SETINI

	pld								; restore DP register
	plp								; restore CPU status

	rtl

SRC_RAM_Routines_END:



SoftReset:								; FIXME, move SoftReset entry point to actual game booting routine
	Accu8
	Index16

	jsl	DisableInterrupts

	lda	#$00							; turn off DMA & HDMA
	sta.l	HDMAEN
	sta.l	MDMAEN

.IFNDEF NOMUSIC

	SNESGSS_Command kGSS_STOP_ALL_SOUNDS, 0				; stop all SPC700 sounds

	stz	MSU_CONTROL						; stop MSU1 track in case it's playing

.ENDIF

	AccuIndex16

	set	"Stack_Pointer", P01.InitStack
	set	"Direct_Page", DP2

	Accu8

	set	"Data_Bank", $00

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	stz	VMADDL							; reset VRAM address
	stz	VMADDH

	dma_0	$09, SRC_0000, VMDATAL, 0				; clear VRAM

; TODO (depending on code flow): Add sprite data init etc.
; FIXME SoftReset shouldn't necessarily automatically lead to DebugMenu



DebugMenu:
	jsl	DisableInterrupts					; in case of returning here from some other section

	lda	#kForcedBlank
	sta	INIDISP
	lda	#$00							; disable HDMA
	sta	HDMAEN
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now

	stz	<DP2.EmptySpriteNo					; set empty sprite = 0

	jsr	ResetSprites

	Accu16

	stz	LO8.HDMA_BG_Scroll+1					; reset BG scroll values
	lda	#$00FF
	sta	LO8.HDMA_BG_Scroll+3

	Accu8

	ldx	#loword(RAM.BG3Tilemap)					; set WRAM address to BG3 tilemap buffer
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 1024				; clear it (low bytes only, high bytes are set up in SetupDebugRegsGFX)



; Load GFX data, set up screen and NMI
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN

	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	dma_0	$01, SRC_Sprites_HUDfont, VMDATAL, 4096			; load HUD font (only cursor is used in debug menu)

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	CGADD

	dma_0	$02, SRC_Palettes_HUD, CGDATA, 32			; load HUD palette for sprite cursor

	jsr	SetupDebugRegsGFX					; load debug menu font, set up registers, (re-)enable NMI



; Done, draw debug menu
;	PrintString	2, 18, kTextBG3, "Stack: $"

;	tsc
;	sta	<DP2.Temp
;	xba
;	sta	<DP2.Temp+1

;	PrintHexNum	DP2.Temp+1
;	PrintHexNum	DP2.Temp

	PrintString	7, 3, kTextBG3, "DEBUG MENU"
	PrintString	10, 3, kTextBG3, "Alpha intro"
	PrintString	11, 3, kTextBG3, "Clear SRAM"
	PrintString	12, 3, kTextBG3, "Dialogue test"
	PrintString	13, 3, kTextBG3, "Load area: XXXX"
	PrintString	14, 3, kTextBG3, "In-game menu"
	PrintString	15, 3, kTextBG3, "Mode1 world map"
	PrintString	16, 3, kTextBG3, "Mode7 world map"
	PrintString	17, 3, kTextBG3, "Random number (0-255):"
	PrintString	18, 3, kTextBG3, "Set real-time clock"
	PrintString	19, 3, kTextBG3, "SNESGSS control ..."
;	PrintString	20, 3, kTextBG3, ""
;	PrintString	21, 3, kTextBG3, ""

	stz	<DP2.SpriteTextMon					; reset sprite text filling level so it won't draw more than 1 cursor ;-)

	PrintSpriteText	10, 2, ">", 0					; put cursor on first line

	Accu16

-	wai
	lda	<DP2.Joy1Press						; wait until no button is pressed so it won't load unwanded stuff e.g. upon returning to the debug menu from another section with Start
	bne	-

	Accu8

	lda	#kINIDISP_15						; turn on the screen
	sta	RAM_INIDISP



DebugMenuLoop:
	SetTextPos	13, 14
	PrintHexNum	<DP2.AreaCurrent+1				; update no. of area to load

	SetTextPos	13, 16
	PrintHexNum	<DP2.AreaCurrent



; Update time using RTC
	lda	<DP2.GameConfig
	and	#kGameConfigRTC
	bne	+
	jmp	@RTCDone

+	lda	#$0D							; send "get time" command
	sta	SRTC_WRITE
	lda	SRTC_READ						; first read = dummy value (should be $0F)
	lda	SRTC_READ						; read seconds (lower 4 bits)
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; read seconds (upper 4 bits)
	and	#$0F
	lsh	4							; shift into upper nibble
	ora	<DP2.Temp						; combine nibbles
	sta	LO8.Time_Second
	lda	SRTC_READ						; minutes.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; minutes.hi
	and	#$0F
	lsh	4
	ora	<DP2.Temp
	sta	LO8.Time_Minute
	lda	SRTC_READ						; hours.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; hours.hi
	and	#$0F
	lsh	4
	ora	<DP2.Temp
	sta	LO8.Time_Hour
	lda	SRTC_READ						; day.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; day.hi
	and	#$0F
	lsh	4
	ora	<DP2.Temp
	sta	LO8.Time_Day
	lda	SRTC_READ						; month
	and	#$0F
	sta	LO8.Time_Month
	lda	SRTC_READ						; year.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; year.hi
	and	#$0F
	lsh	4
	ora	<DP2.Temp
	sta	LO8.Time_Year
	lda	SRTC_READ						; century
	and	#$0F
	clc								; add 10 so it is stored as 19/20 (13h/14h)
	adc	#10
	sta	LO8.Time_Century
;	lda	SRTC_READ						; weekday
;	and	#$0F
;	sta	somewhere

	PrintString	25, 16, kTextBG3, "Time:"

	SetTextPos	25, 22
	PrintHexNum	LO8.Time_Hour
;	PrintHexNum	<DP2.GameTimeHour

	PrintString	25, 24, kTextBG3, ":"

	SetTextPos	25, 25
	PrintHexNum	LO8.Time_Minute
;	PrintHexNum	<DP2.GameTimeMinute

	PrintString	25, 27, kTextBG3, ":"

	SetTextPos	25, 28
	PrintHexNum	LO8.Time_Second
;	PrintHexNum	<DP2.GameTimeSecond

@RTCDone:



;	jsr	ShowCPUload

	lda	#%00010000						; make sure ONLY BG3 lo/hi tilemaps get updated
	sta	<DP2.DMA_Updates
	sta	<DP2.DMA_Updates+1					; hi tilemap update is actually only needed once (to clean up if Mode 1 world map was used), but who cares :p

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer

	wai



; Check for dpad up
	lda	<DP2.Joy1New+1
	and	#kDpadUp
	beq	@DpadUpDone
	lda	RAM.SpriteDataArea.Text+2				; Y coord of cursor
	sec
	sbc	#8
	cmp	#kDebugMenu1stLine
	bcs	+
	lda	#kDebugMenu1stLine + 9 * 8				; underflow, put cursor on last line // no. of last menu item (9) * line height (8)
+	sta	RAM.SpriteDataArea.Text+2

@DpadUpDone:



; Check for dpad down
	lda	<DP2.Joy1New+1
	and	#kDpadDown
	beq	@DpadDownDone
	lda	RAM.SpriteDataArea.Text+2
	clc
	adc	#8
	cmp	#kDebugMenu1stLine + 10 * 8				; no. of menu items (10) * line height (8)
	bcc	+
	lda	#kDebugMenu1stLine					; overflow, put cursor on first line
+	sta	RAM.SpriteDataArea.Text+2

@DpadDownDone:



; Check for dpad left
	lda	<DP2.Joy1New+1
	and	#kDpadLeft
	beq	@DpadLeftDone
	lda	RAM.SpriteDataArea.Text+2				; only do anything if cursor is on area loader
	cmp	#kDebugMenu1stLine + 24
	bne	@DpadLeftDone

	Accu16

	lda	<DP2.AreaCurrent
	dec	a
	cmp	#$FFFF
	bne	+
	lda	#_sizeof_SRC_AreaProperties/2-1				; underflow, load no. of last existing area
+	sta	<DP2.AreaCurrent

	Accu8

@DpadLeftDone:



; Check for dpad right
	lda	<DP2.Joy1New+1
	and	#kDpadRight
	beq	@DpadRightDone
	lda	RAM.SpriteDataArea.Text+2				; only do anything if cursor is on area loader
	cmp	#kDebugMenu1stLine + 24
	bne	@DpadRightDone

	Accu16

	lda	<DP2.AreaCurrent
	ina
	cmp	#_sizeof_SRC_AreaProperties/2
	bcc	+
	lda	#$0000							; overflow, load no. of first area
+	sta	<DP2.AreaCurrent

	Accu8

@DpadRightDone:



; Check for A button
	bit	<DP2.Joy1New
	bpl	@AButtonDone

	Accu16

	lda	RAM.SpriteDataArea.Text+2				; read Y position of cursor
	and	#$00FF							; clear high byte
	sec								; subtract Y value of first debug menu line
	sbc	#kDebugMenu1stLine
	lsr	a							; line height is 8 px, so we just need to divide by 4 to get the correct index
	lsr	a
	tax

	Accu8

	jmp	(SRC_DebugMenuEntry, x)

@AButtonDone:



; Check for B button
;	bit	<DP2.Joy1New+1
;	bpl	@BButtonDone

; SNES PowerPak test: The cart should lock its DMA port once a game is
; running, which this seems to confirm it does (it returns $21, as do
; emulators and other hardware --> likely open bus)

;	SetTextPos	25, 2
;	PrintHexNum	$21FF						; read PowerPak DMA port, print value

;@BButtonDone:



; Check for Y button
	bit	<DP2.Joy1New+1
	bvc	@YButtonDone
	jsl	PrintTest
;	jmp	UnusedCode@ProgramCounter

@YButtonDone:



; Check for Start
	lda	<DP2.Joy1Press+1
	and	#kButtonStart
	beq	@StartButtonDone

	Accu16

	lda	#1
	jsl	LoadEvent

.ACCU 8

	jmp	DebugMenu

@StartButtonDone:

	jmp	DebugMenuLoop



SRC_DebugMenuEntry:
	.DW Debug_ShowAlphaIntro
	.DW Debug_ClearSRAM
	.DW DialogueTest
	.DW ShowArea
	.DW InGameMenu
	.DW LoadWorldMap
	.DW TestMode7
	.DW Debug_PrintRandomNumber
	.DW Debug_SetRTC
	.DW Debug_SNESGSS_Control					; sound test is meant to work even .IFDEF NOMUSIC



Debug_ShowAlphaIntro:
	jsl	ShowAlphaIntro
	jmp	DebugMenu



Debug_ClearSRAM:
	Accu16

	jsl	CheckSRAM@ClearSRAM
	jmp	DebugMenu



.ACCU 8

Debug_PrintRandomNumber:
	jsr	CreateRandomNr

	SetTextPos	17, 26
	PrintNum	LO8.RandomNumbers

	stz	<DP2.TextStringPtr
	stz	<DP2.TextStringPtr+1
	lda	#:DebugMenu
	sta	<DP2.TextStringBank
	jsl	PrintF

	.DB "  ", 0							; clear trailing ciphers from old values

	jmp	DebugMenuLoop



Debug_SetRTC:
	jsl	DisableInterrupts

	lda	#kForcedBlank						; enter forced blank, register shadow variable still contains "screen on" + brightness setting
	sta	INIDISP
	ldx	#loword(RAM.BG3Tilemap)
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 2048				; clear BG3 tilemap

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated once NMI is re-enabled
	tsb	<DP2.DMA_Updates

	jsr	ResetSprites

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	NMITIMEN
	cli
	wai

	Accu16								; wait for no button presses

;-	lda	<DP2.Joy1
;	bne	-

;-	lda	<DP2.Joy1New
;	bne	-

-	lda	<DP2.Joy1Press
	bne	-

	Accu8

;	lda	#kINIDISP_15						; turn screen back on // never mind, this is done via register shadow variable
;	sta	INIDISP
	lda	<DP2.GameConfig						; check if S-RTC is present at all
	and	#kGameConfigRTC
	bne	@RTCpresent

	PrintString	2, 2, kTextBG3, "No real-time clock hardware\\n  found!"

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates

	wait	"user_input"

	jmp	DebugMenu

@RTCpresent:
	PrintString	2, 2, kTextBG3, "Adjust a value by holding\\n  the corresponding button and\\n  pressing up/down (d-pad)."
	PrintString	8, 2, kTextBG3, "YYYY-MM-DD hh:mm:ss"
	PrintString	11, 2, kTextBG3, "A button: seconds"
	PrintString	12, 2, kTextBG3, "B button: minutes"
	PrintString	13, 2, kTextBG3, "Y button: hours"
	PrintString	14, 2, kTextBG3, "X button: day"
	PrintString	15, 2, kTextBG3, "R button: month"
	PrintString	16, 2, kTextBG3, "L button: year"
	PrintString	18, 2, kTextBG3, "Select button: Toggle century"
	PrintString	19, 2, kTextBG3, "Start button: Save & exit"

@SetRTCLoop:
	wai

	SetTextPos	7, 2
	PrintNum	LO8.Time_Century				; variable contains value in decimal
	PrintHexNum	LO8.Time_Year

	PrintString	7, 6, kTextBG3, "-"

	lda	LO8.Time_Month
	cmp	#10
	bcs	+

	PrintString	7, 7, kTextBG3, "0"				; put a leading zero for months Jan thru Sept

+	PrintNum	LO8.Time_Month

	PrintString	7, 9, kTextBG3, "-"

	PrintHexNum	LO8.Time_Day

	SetTextPos	7, 13
	PrintHexNum	LO8.Time_Hour

	PrintString	7, 15, kTextBG3, ":"
	PrintHexNum	LO8.Time_Minute

	PrintString	7, 18, kTextBG3, ":"
	PrintHexNum	LO8.Time_Second

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates
	stz	<DP2.Temp						; reset increment/decrement variables
	stz	<DP2.Temp+1



; Check for D-pad up --> increment value
	lda	<DP2.Joy1New+1
	and	#kDpadUp
	beq	@DpadUpDone
	lda	#$01							; value += 1
	sta	<DP2.Temp
	sta	<DP2.Temp+1

@DpadUpDone:



; Check for D-pad down --> decrement value
	lda	<DP2.Joy1New+1
	and	#kDpadDown
	beq	@DpadDownDone
	lda	#$99							; value += $99 in decimal mode
	sta	<DP2.Temp
	lda	#$FF
	sta	<DP2.Temp+1

@DpadDownDone:



; Check for A button --> adjust second
	lda	<DP2.Joy1
	bpl	@AButtonDone
	sed								; enable decimal mode
	lda	LO8.Time_Second
	clc								; add inc/dec value
	adc	<DP2.Temp
	cmp	#$99
	bne	+
	lda	#$59							; keep value within range (0-59 in this case)
	bra	++
+	cmp	#$60
	bne	++
	lda	#$00
++	sta	LO8.Time_Second
	cld								; disable decimal mode

@AButtonDone:



; Check for B button --> adjust minute
	lda	<DP2.Joy1+1
	bpl	@BButtonDone
	sed
	lda	LO8.Time_Minute
	clc
	adc	<DP2.Temp
	cmp	#$99
	bne	+
	lda	#$59
	bra	++
+	cmp	#$60
	bne	++
	lda	#$00
++	sta	LO8.Time_Minute
	cld

@BButtonDone:



; Check for Y button --> adjust hour
	bit	<DP2.Joy1+1
	bvc	@YButtonDone
	sed
	lda	LO8.Time_Hour
	clc
	adc	<DP2.Temp
	cmp	#$99
	bne	+
	lda	#$23							; hour range: 0-23
	bra	++
+	cmp	#$24
	bne	++
	lda	#$00
++	sta	LO8.Time_Hour
	cld

@YButtonDone:



; Check for X button --> adjust day
	bit	<DP2.Joy1
	bvc	@XButtonDone
	sed
	lda	LO8.Time_Day
	clc
	adc	<DP2.Temp
	bne	+
	lda	#$31							; day range: 1-31
	bra	++
+	cmp	#$32
	bne	++
	lda	#$01
++	sta	LO8.Time_Day
	cld

@XButtonDone:



; Check for R button --> adjust month
	lda	<DP2.Joy1
	and	#kButtonR
	beq	@RButtonDone
	lda	LO8.Time_Month
	clc								; not using decimal mode for the month value
	adc	<DP2.Temp+1
	bne	+
	lda	#12							; month range: 1-12
	bra	++
+	cmp	#13
	bne	++
	lda	#1
++	sta	LO8.Time_Month

@RButtonDone:



; Check for L button --> adjust year
	lda	<DP2.Joy1
	and	#kButtonL
	beq	@LButtonDone
	sed
	lda	LO8.Time_Year
	clc
	adc	<DP2.Temp						; year range: 0-99
	sta	LO8.Time_Year
	cld

@LButtonDone:



; Check for Select button --> toggle century
	lda	<DP2.Joy1New+1
	and	#kButtonSel
	beq	@SelButtonDone
	lda	LO8.Time_Century
	cmp	#20
	beq	+
	lda	#20
	bra	++
+	lda	#19
++	sta	LO8.Time_Century

@SelButtonDone:



; Check for Start
	lda	<DP2.Joy1+1
	and	#kButtonStart
	bne	@WriteClockRegs
	jmp	@StartButtonDone

@WriteClockRegs:							; self-reminder: Seconds elapsed since entering this menu are added on to seconds "typed" in ... (but, why?)
;	lda	#$0E							; setting the time (from Fullsnes): Send <0Eh,04h,0Dh,0Eh,00h,Timestamp(12 digits),0Dh> to [002801h]
;	sta	SRTC_WRITE						; but the first 3 command bytes don't seem to be necessary at all (?)
;	lda	#$04
;	sta	SRTC_WRITE
;	lda	#$0D
;	sta	SRTC_WRITE
	lda	#$0E							; send command
	sta	SRTC_WRITE
	stz	SRTC_WRITE						; $00 = "set time" command
	lda	LO8.Time_Second
	and	#$0F
	sta	SRTC_WRITE						; write seconds (lower 4 bits)
	lda	LO8.Time_Second
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	SRTC_WRITE						; write seconds (upper 4 bits)
	lda	LO8.Time_Minute
	and	#$0F
	sta	SRTC_WRITE						; minutes.lo
	lda	LO8.Time_Minute
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	SRTC_WRITE						; minutes.hi
	lda	LO8.Time_Hour
	and	#$0F
	sta	SRTC_WRITE						; hours.lo
	lda	LO8.Time_Hour
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	SRTC_WRITE						; hours.hi
	lda	LO8.Time_Day
	and	#$0F
	sta	SRTC_WRITE						; day.lo
	lda	LO8.Time_Day
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	SRTC_WRITE						; day.hi
	lda	LO8.Time_Month
	sta	SRTC_WRITE						; month
	lda	LO8.Time_Year
	and	#$0F
	sta	SRTC_WRITE						; year.lo
	lda	LO8.Time_Year
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	sta	SRTC_WRITE						; year.hi
	lda	LO8.Time_Century
	sec								; subtract 10 for correct format (9h/Ah)
	sbc	#10
	sta	SRTC_WRITE						; century
;	lda	#1
;	sta	SRTC_WRITE						; weekday (calculated automatically)
	lda	#$0D
	sta	SRTC_WRITE						; last byte in the Fullsnes sequence
	jmp	DebugMenu

@StartButtonDone:

	jmp	@SetRTCLoop



Debug_SNESGSS_Control:
	jsl	DisableInterrupts

	lda	#kForcedBlank
	sta	INIDISP

	SNESGSS_Command kGSS_MUSIC_STOP, 0				; stop music in case it's playing

	ldx	#loword(RAM.BG1Tilemap1)				; clear BG1/2 tilemap buffers
	stx	WMADDL
	stz	WMADDH

	dma_0	$08, SRC_0000, WMDATA, 8192

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#$0000
	stx	VMADDL

	dma_0	$09, SRC_0000, VMDATAL, 0				; clear VRAM

	lda	#kBGMODE_5						; BG Mode 5
	sta	RAM_BGMODE
	lda	#$50							; VRAM address for BG1 tilemap: $5000, size: 32×32 tiles
	sta	RAM_BG1SC
	lda	#$58							; VRAM address for BG2 tilemap: $5800, size: 32×32 tiles
	sta	RAM_BG2SC
	lda	#$20							; VRAM address for BG1 character data: $0000, BG2 character data: $2000
	sta	RAM_BG12NBA
	stz	BG1HOFS							; reset BG1 horizontal scroll
	stz	BG1HOFS
	stz	BG2HOFS							; reset BG2 horizontal scroll
	stz	BG2HOFS
	lda	#$FF							; scroll BG1 down by 1 px
	sta	BG1VOFS
	stz	BG1VOFS
;	lda	#$FF							; scroll BG2 down by 1 px
	sta	BG2VOFS
	stz	BG2VOFS
	lda	#kTM_BG1|kTM_BG2					; turn on BG1 and 2 only on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
	lda	#kPseudoH512
	sta	RAM_SETINI
	stz	CGADD							; reset CGRAM address
	stz	CGDATA							; $3C00 = blue background color
	lda	#$3C
	sta	CGDATA							; next DMA skips background color (2 bytes)

	dma_0	$02, SRC_Palettes_Text+2, CGDATA, 30

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#$0000							; set VRAM address for BG1 font tiles
	stx	VMADDL
	jsr	MakeMode5FontBG1

	ldx	#$2000							; set VRAM address for BG2 font tiles
	stx	VMADDL
	jsr	MakeMode5FontBG2

	Accu16

	lda	DP2.NextTrack						; make NextTrack a sane value (could be $FFFF depending on area visited, which would break string printing)
	cmp	#_sizeof_STR_GSS_Tracks/32				; value higher than no. of last track in list?
	bcc	+
	lda	#_sizeof_STR_GSS_Tracks/32-1				; yes, load no. of last track (first track = $0000)
	sta	DP2.NextTrack

+	Accu8

	PrintString	1, 1, kTextMode5, "SNESGSS control panel\\n  ---------------------"

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts
	sta	NMITIMEN
	cli

SNESGSS_ControlLoop:
	ldx	#DP2.NextTrack+1
	stx	<DP2.DataAddress
	stz	<DP2.DataBank

	PrintString	4, 1, kTextMode5, "Play track: %x"	; %x = track no. (high byte)

	ldx	#DP2.NextTrack
	stx	<DP2.DataAddress
	stz	<DP2.DataBank

	PrintString	4, 8, kTextMode5, "%x"				; track no. (low byte)

	Accu16

	lda	<DP2.NextTrack
	and	#$00FF							; clear high byte
	lsh	5							; value in DP2.NextTrack * 32 for corresponding song name
	clc
	adc	#STR_GSS_Tracks						; add track list offset to address for song name to print
	sta	<DP2.DataAddress

	Accu8

	lda	#:STR_GSS_Tracks
	sta	<DP2.DataBank

	PrintString	4, 10, kTextMode5, "-  %s"				; song name

	ldx	#DP2.GSS_GlobalVol
	stx	<DP2.DataAddress
	stz	<DP2.DataBank

	PrintString	6, 1, kTextMode5, "Global vol.:  %x"

	lda	#%00000101						; make sure BG1 and BG2 lo tilemaps get updated
	sta	<DP2.DMA_Updates
	stz	<DP2.DMA_Updates+1

	wai



; Check for A button
	bit	<DP2.Joy1New
	bpl	@AButtonDone

;	SNESGSS_Command kGSS_MUSIC_STOP, 0				; stop musc in case it's playing (doesn't seem to be needed as music stops as soon as the load command is sent)

	jsl	LoadTrackGSS						; this also re-enables stereo (when using original sound driver)

	jsl	DisableInterrupts

;	SNESGSS_Command kGSS_GLOBAL_VOLUME, $FF7F			; fade speed: 255, global volume: 127)
	SNESGSS_Command kGSS_MUSIC_PLAY, 0

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts
	sta	NMITIMEN
	cli

@AButtonDone:



; Check for B button
	bit	<DP2.Joy1New+1
	bpl	@BButtonDone

	jsl	DisableInterrupts

	SNESGSS_Command kGSS_MUSIC_STOP, 0

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts
	sta	NMITIMEN
	cli

@BButtonDone:



; Check for X button
	bit	<DP2.Joy1New
	bvc	@XButtonDone

;	do something

@XButtonDone:



; Check for Y button
	bit	<DP2.Joy1New+1
	bvc	@YButtonDone

;	do something

@YButtonDone:



; Check for L button
	lda	<DP2.Joy1New
	and	#kButtonL
	beq	@LButtonDone

	Accu16

	lda	DP2.NextTrack						; decrement NextTrack, make sure it won't wrap around to $FFFF
	dec	a
	cmp	#$FFFF							; previous value was zero?
	bne	+
	lda	#_sizeof_STR_GSS_Tracks/32-1				; yes, load no. of last track
+	sta	DP2.NextTrack

	Accu8

@LButtonDone:



; Check for R button
	lda	<DP2.Joy1New
	and	#kButtonR
	beq	@RButtonDone

	Accu16

	lda	DP2.NextTrack						; increment NextTrack, make sure it won't go higher than total no. of tracks
	ina
	cmp	#_sizeof_STR_GSS_Tracks/32				; value higher than no. of last track in list?
	bcc	+
	lda	#$0000							; yes, wrap around to first track ($0000)
+	sta	DP2.NextTrack

	Accu8

@RButtonDone:



; Check for Start
	lda	<DP2.Joy1New+1
	and	#kButtonStart
	beq	@StartButtonDone

	jmp	DebugMenu

@StartButtonDone:

	jmp	SNESGSS_ControlLoop



SetupDebugRegsGFX:							; Load gfx & palettes and set up PPU registers for debug screen
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN

	ldx	#VRAM_BG3_Tiles						; set VRAM address for BG3 tiles
	stx	VMADDL

	dma_0	$01, SRC_Font8x8, VMDATAL, 2048				; load debug menu font

	ldx	#0
	lda	#$20							; priority bit
-	sta	RAM.BG3TilemapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-

	stz	CGADD							; reset CGRAM address

	dma_0	$02, SRC_Palettes_Text, CGDATA, 32			; load palettes



; Set up RAM mirror registers
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	RAM_OBSEL
	lda	#$48|$01						; VRAM address for BG3 tilemap: $4800, size: 64×32 tiles
	sta	RAM_BG3SC
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA
	lda	#kBGMODE_1						; set BG mode 1
	sta	RAM_BGMODE
	lda	#kTM_BG3|kTM_OBJ					; turn on BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
	lda	#%00110000						; set color math disable bits (4-5)
	sta	RAM_CGWSEL
	lda	#$00
	sta	RAM_W12SEL						; disable windowing
	sta	RAM_TMW
	sta	RAM_TSW
	sta	RAM_SETINI						; clear SETINI in case Mode 5 was used (intro disclaimer, SNESGSS control panel)

	set	"NMI", Vblank_DebugMenu

	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kAutoJoy				; enable interrupts + auto joypad read
	sta	NMITIMEN
	sta	LO8.NMITIMEN
	cli
	wai								; wait for NMI to fill joypad variables and PPU registers with valid data (first time upon cold boot)

	rts



; DEBUGGING FUNCTIONS
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

; Show CPU load (via scanline counter)
ShowCPUload:
	lda	SLHV							; latch H/V counter
;	lda	STAT78							; reset OPHCT/OPVCT flip-flops
	lda	OPVCT
	sta	<DP2.CurrentScanline
	lda	OPVCT
	and	#$01							; mask off 7 open bus bits
	sta	<DP2.CurrentScanline+1

	SetTextPos	2, 2
	PrintNum	<DP2.CurrentScanline

	stz	<DP2.TextStringPtr
	stz	<DP2.TextStringPtr+1
	lda	#:ShowCPUload
	sta	<DP2.TextStringBank
	jsl	PrintF

	.DB "  ", 0							; clear trailing numbers from old values

;	PrintNum	<DP2.CurrentScanline+1

	rts



; SRAM ACCESSING ROUTINES
; --------------------------------------------------------------------------------------------------

.ACCU 8
.INDEX 16

CheckSRAM:
	lda	#bankbyte(SRAM)						; set start address to SRAM data
	sta	<DP2.Temp+7

	Accu16

	lda	#loword(SRAM)
	sta	<DP2.Temp+5
	lda	#$01FE							; assume ChecksumCmpl = $FFFF and Checksum = $0000, so add these up right now
	sta	<DP2.Temp+3

	ldy	#0
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#lobyte(SRAM.ChecksumCmpl)				; location of SRAM checksum complement & checksum reached? // self-reminder: Use low byte here as y is zero-based and Temp+5 contains SRAM offset in middle byte. As it's an immediate value, WLA DX will still generate $00 as the high byte of a 16-bit operand.
	bne	-

	ldy	#lobyte(SRAM.Checksum+2)				; skip both // ditto
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#8192							; all SRAM data checked?
	bne	-

	lda	<DP2.Temp+3						; Temp+3 now contains the sum of all SRAM bytes
	cmp	SRAM.Checksum						; compare sum to checksum
	bne	@ClearSRAM

	eor	#$FFFF							; compare checksum XOR $FFFF to complement
	cmp	SRAM.ChecksumCmpl
	beq	@SRAMGood

@ClearSRAM:								; checksum and/or complement invalid means SRAM is corrupt
	lda	#$0000
	ldx	#$0000
-	sta	SRAM, x							; zero out SRAM data
	inx
	inx
	cpx	#8192
	bne	-

	lda	#$01FE							; write good checksum (has to be $01FE when everything else is zero)
	sta	SRAM.Checksum
	xba								; write checksum complement ($FE01)
	sta	SRAM.ChecksumCmpl

@SRAMGood:
	Accu8

	rtl



FixSRAMChecksum:
	lda	#bankbyte(SRAM)						; set start address to SRAM data
	sta	<DP2.Temp+7

	Accu16

	lda	#loword(SRAM)
	sta	<DP2.Temp+5
	lda	#$01FE							; assume ChecksumCmpl = $FFFF and Checksum = $0000, so add these right now
	sta	<DP2.Temp+3
	ldy	#0
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#lobyte(SRAM.ChecksumCmpl)				; location of SRAM checksum complement & checksum reached? // self-reminder as in CheckSRAM above
	bne	-

	ldy	#lobyte(SRAM.Checksum+2)				; skip both // ditto
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#8192							; end of SRAM data reached?
	bne	-

	lda	<DP2.Temp+3						; write new checksum and complement
	sta	SRAM.Checksum
	eor	#$FFFF
	sta	SRAM.ChecksumCmpl

	Accu8

	rts



; The following routine expects the 24-bit source data address in DP2.DataAddress,
; destination offset (with data length added) in X, and data length in Y

WriteDataToSRAM:
-	dex								; counting down dest from (last data byte index + 1)
	dey								; counting down src from transfer length
	lda	[<DP2.DataAddress], y
	sta.l	bankbyte(SRAM)<<16, x					; x contains offset in middle byte, so just use SRAM bank as a base for writing bytes
	cpy	#0							; all bytes written?
	bne	-

	jsr	FixSRAMChecksum

	rtl



; SOFTWARE ERROR HANDLER
; --------------------------------------------------------------------------------------------------

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



; 8x8 font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_BG3_Tiles
	stx	VMADDL

	dma_0	$01, SRC_Font8x8, VMDATAL, 2048

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
	lda	#kBGMODE_1						; set BG mode 1
	sta	BGMODE
	lda	#$48							; VRAM address for BG3 tilemap: $4800, size: 32×32 tiles
	sta	BG3SC
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	BG34NBA
	lda	#kTM_BG3						; turn on BG3 only
	sta	TM							; on the mainscreen
	sta	TS							; and on the subscreen



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



; Update BG3 tilemap
	stz	VMAIN							; increment VRAM address by 1 after writing to $2118
	ldx	#VRAM_BG3_Tilemap1					; set VRAM address to BG3 tilemap
	stx	VMADDL

	dma_0	$00, RAM.BG3Tilemap, VMDATAL, 1024



; Turn screen back on, put CPU to sleep
	lda	#kINIDISP_15
	sta	INIDISP
	stp								; halt the CPU



; EOF
