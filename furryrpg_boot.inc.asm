;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** BOOT CODE ***
;
;==========================================================================================



Boot:
	rep	#kAX8|kDecimal						; A/X/Y = 16 bit, decimal mode off
	lda	#P01.InitStackPtr					; set up the stack
	tcs

	SetDP	$2100							; set Direct Page to PPU registers

	Accu8

	SetDBR	$00							; set Data Bank = $00



; initialize registers
	lda	#$8F							; INIDISP (Display Control 1): forced blank
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

	; regs $2118-2119: VRAM data write

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

	; reg $2122: CGRAM data write

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

	; regs $2134-$213F: PPU read registers, no initialization needed
	; regs $2140-$2143: APU communication regs, no initialization required
	; reg $2180: WRAM data read/write

	stz	<WMADDL							; regs $2181-$2183: WRAM address
	stz	<WMADDM
	stz	<WMADDH

	; regs $4016-$4017: serial JoyPad read registers, no need to initialize

	Accu16

	SetDP	$4200							; set Direct Page to CPU registers

	Accu8

	stz	<NMITIMEN						; reg $4200: disable timers, NMI, and auto-joypad read

	lda	#$C0							; have the automatic read of the SNES read the first pair of JoyPads
	sta	<WRIO							; reg $4201: programmable I/O write port
	stz	<WRMPYA							; regs $4202-$4203: multiplication registers
	stz	<WRMPYB
	stz	<WRDIVL							; regs $4204-$4206: division registers
	stz	<WRDIVH
	stz	<WRDIVB
	stz	<HTIMEL							; regs $4207-$4208: Horizontal-IRQ timer setting
	stz	<HTIMEH
	stz	<VTIMEL							; regs $4209-$420A: Vertical-IRQ timer setting
	stz	<VTIMEH
	stz	<MDMAEN							; reg $420B: turn off all general DMA channels
	stz	<HDMAEN							; reg $420C: turn off all HDMA channels

	lda	#$01							; reg $420D: set Memory-2 area to 3.58 MHz (FastROM)
	sta	<MEMSEL

	; regs $420E-$420F: unused registers
	; reg $4210: RDNMI (R)
	; reg $4211: IRQ status, no need to initialize
	; reg $4212: H/V blank and JoyRead status, no need to initialize
	; reg $4213: programmable I/O inport, no need to initialize
	; regs $4214-$4215: divide results, no need to initialize
	; regs $4216-$4217: multiplication or remainder results, no need to initialize
	; regs $4218-$421f: JoyPad read registers, no need to initialize
	; regs $4300-$437F: DMA/HDMA parameters, unused registers

	Accu16

	SetDP	DP2							; set up the Direct Page, DP2 is standard for now

	Accu8



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
	beq	@VRAM128K

	stz	UNUSED0
	bra	@VRAM128KDone

@VRAM128K:
	lda	#%0001000						; remember that VRAM expansion is present
	sta	UNUSED0							; using UNUSED0 as WRAM is cleared shortly

@VRAM128KDone:



; clear all directly accessible RAM areas (with most parameters/addresses set above)
	stz	VMADDL							; reset VRAM address once again
	stz	VMADDH

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; VRAM (length 0 = 65536 bytes)
	DMA_CH0 $08, SRC_Zeroes, CGDATA, 512				; CGRAM (512 bytes)
	DMA_CH0 $08, SRC_Zeroes, OAMDATA, 544				; OAM (low+high OAM tables = 512+32 bytes)
	DMA_CH0 $08, SRC_Zeroes, WMDATA, 0				; WRAM (length 0 = 65536 bytes = lower 64K of WRAM)

;	lda	#$01							; never mind, Accu still contains this value
	sta	MDMAEN							; WRAM address in $2181-$2183 has reached $10000 now, re-initiate DMA transfer for the upper 64K of WRAM

	lda	UNUSED0							; write VRAM size bit to GameConfig
	sta	<DP2.GameConfig
	and	#%0001000						; check for 128K VRAM expansion again
	beq	@ClearRAMDone

	ldx	#$8000							; 128K of VRAM present, set VRAM address to $8000 (TESTME, shouldn't even be necessary)
	stx	VMADDL

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear upper 64K of VRAM (length 0 = 65536 bytes)

@ClearRAMDone:



; copy RAM routines to WRAM
	ldx	#loword(RAM.Routines)					; set WRAM address to RAM routines section
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $00, SRC_RAM_Routines, WMDATA, _sizeof_SRC_RAM_Routines



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
/*	Accu16

	lda	#:SRC_SPC700_driver					; set source bank byte of driver code
	sta	<DP2.SNESlib_ptr+2
	lda	#SRC_SPC700_driver					; set source address of driver code
	sta	<DP2.SNESlib_ptr
	lda	#_sizeof_SRC_SPC700_driver				; data length = size of driver code
	sta	<DP2.SPC_DataSize
	lda	#SPC700_GSS_Driver					; store driver to designated sound RAM address
	sta	<DP2.SPC_DataDestAddr
	jsl	spc_load_data						; upload driver

	SNESGSS_Command kGSS_INITIALIZE, 0				; initialize sound driver for the first time
*/

/*	ldy	#SPC700_GSS_Driver
	jsr	spc_begin_upload

	ldx	#0
-	lda.l	SRC_SPC700_driver, x
	jsr	spc_upload_byte

	inx
	cpx	#_sizeof_SRC_SPC700_driver
	bne	-

	ldy	#SPC700_GSS_Driver
	jsr	spc_execute

	SNESGSS_Command kGSS_INITIALIZE, 0				; initialize sound driver for the first time
*/

	jsr	FastUploadSoundDriver		; ##### test, upload driver w/ burst transfer routine

; no need to execute driver code as it jumps there after the transfer routine

	SNESGSS_Command kGSS_INITIALIZE, 0				; initialize sound driver for the first time



; more hardware checks/initialization
	jsl	CheckHardware						; check if special hardware and/or enhancement chips like MSU1, RTC etc. are available
	jsl	CheckSRAM						; check SRAM integrity, clear SRAM if corrupt
	jsr	SpriteInit						; set up the sprite buffer (LO8.ShadowOAM_Lo)
	jsr	SpriteDataInit



; check SRAM for game state (only ROM integrity for now)
	lda	SRAM.GoodROM						; if byte is $01, then ROM integrity check was already passed
	cmp	#$01
	beq	@GameState000
	jsr	CheckROMIntegrity					; back here means ROM good

	lda	#$01							; remember that ROM integrity check was passed
	sta	<DP2.Temp						; source data in DP2.Temp
	ldx	#DP2.Temp						; source data offset
	stx	<DP2.DataAddress
	lda	#$7E							; source data bank
	sta	<DP2.DataBank
	ldx	#loword(SRAM.GoodROM) + 1				; destination offset + data length
	ldy	#1							; data length (also src index)
	jsl	WriteDataToSRAM

@GameState000:
;	jmp	VSplitscreenTest
;	jmp	StaticRenderingTest
;	jmp	DynamicRenderingTest

	.IFDEF	DEBUG
		jml	DebugMenu
	.ENDIF

	SetNMI	kNMI_Intro

	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable NMI
	sta	NMITIMEN
	sta	LO8.NMITIMEN
	cli								; enable interrupts

	jsl	ShowAlphaIntro

	jsl	ShowTitleScreen



; go to save manager/main game menu <-- possibly enter main game loop here, and use some variable bit to check for current game state?

MainGameLoop:
	; do stuff before next Vblank here

	WaitFrames	1

	Accu16

	SetDP	DP2							; set up the Direct Page for main game loop stuff

	Accu8

	SetDBR	$00							; set Data Bank = $00

	lda	DP2.GameConfig
	; check bits

	jsr	UpdateGameTime

	; create RND numbers

	; we have work to do ...

	jmp	MainGameLoop



; intro / title screen

ShowAlphaIntro:
	DisableIRQs

	lda	#$80							; enter forced blank
	sta	INIDISP

	SNESGSS_Command kGSS_MUSIC_STOP, 0				; stop music in case it's playing

	ldx	#loword(RAM.BG1Tilemap1)				; clear BG1/2 tilemap buffers
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 8192

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	VMAIN
	ldx	#$0000
	stx	VMADDL

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear VRAM

	lda	#5							; set BG Mode 5
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
	lda	#%00000011						; turn on BG1 and 2 only on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
	lda	#%00001000						; "SHIFT SUBSCREEN HALF DOT TO THE LEFT"
	sta	RAM_SETINI
	stz	CGADD							; reset CGRAM address
	stz	CGDATA							; $3C00 = blue background color
	lda	#$3C
	sta	CGDATA							; next DMA skips background color (2 bytes)

	DMA_CH0 $02, SRC_Palettes_Text+2, CGDATA, 30

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

	ldx	#STR_SoftwareBuildTimestamp
	stx	<DP2.DataAddress
	lda	#:STR_SoftwareBuildTimestamp
	sta	<DP2.DataBank

	PrintString	4, 2, kTextMode5, "%s"

	ldx	#STR_DisclaimerWallofText
	stx	<DP2.DataAddress
	lda	#:STR_DisclaimerWallofText
	sta	<DP2.DataBank

	PrintString	6, 2, kTextMode5, "%s"

	stz	VMAIN							; increment VRAM address by one word after writing to $2118
	ldx	#VRAM_BG1_Tilemap1					; set VRAM address for BG1 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG1Tilemap1, VMDATAL, 1024

	ldx	#VRAM_BG2_Tilemap1					; set VRAM address for BG2 tilemap
	stx	VMADDL

	DMA_CH0 $00, RAM.BG2Tilemap1, VMDATAL, 1024

	SetNMI	kNMI_Intro

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts
	sta	NMITIMEN
	cli

	Accu16

	lda	#0							; rest of intro = event #0
	jsl	LoadEvent

	.ACCU 8

	lda	#$80							; enter forced blank
	sta	RAM_INIDISP
	wai

	DisableIRQs

	SetNMI	kNMI_DebugMenu

	.IFNDEF NOMUSIC
		SNESGSS_Command kGSS_GLOBAL_VOLUME, $1000		; fade-out intro song (fade speed: 16, global volume: 00)

		Accu8
	.ENDIF

	ldx	#$0000
	stx	VMADDL

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear VRAM

	lda	RDNMI							; clear NMI flag
	lda	#$81							; re-enable interrupts
	sta	NMITIMEN
	sta	LO8.NMITIMEN
	cli

	rtl



ShowTitleScreen:

; load GFX, music



@Loop:

	WaitFrames	1



; check for Start
	lda	<DP2.Joy1+1
	and	#%00010000
	beq	@StartButtonDone

	; Start pressed

@StartButtonDone:

	jmp	@Loop



; ************************ Hardware evaluation *************************

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
	lda	#%00000001
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
	lda	#%00000010
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
	lda	#%00000100
	tsb	<DP2.GameConfig						; set "Ultra16 present" flag

	lda	ULTRA16_SNUM						; copy U16 serial number, maybe use this for some sort of in-game secret/surprise?
;	sta	somewhere

@Ultra16Done:

	rtl



CheckROMIntegrity:
	jsr	SetupDebugRegsGFX					; load font, set up screen regs

	lda	#$0F							; turn on the screen
	sta	RAM_INIDISP

	.IFNDEF DEBUG
		PrintString	2, 3, kTextBG3, "Checking cartridge,"
		PrintString	3, 3, kTextBG3, "please wait ..."
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



; read bank $C0
	lda	#$C0							; set start bank to $C0
	sta	<DP2.DataBank

	.IFDEF DEBUG
		SetTextPos	9, 17
		PrintHexNum	<DP2.DataBank

		lda	#%00010000					; make sure BG3 low tilemap bytes are updated
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

		lda	#%00010000					; make sure BG3 low tilemap bytes are updated
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
	Accu8

	lda	#kErrorCorruptROM
	sta	<DP2.ErrorCode
	jml	ErrorHandler



ReadBanks40thru5F:
	lda	#$40							; set start bank to $40
	sta	<DP2.DataBank

	.IFDEF DEBUG
		SetTextPos	9, 17
		PrintHexNum	<DP2.DataBank

		lda	#%00010000					; make sure BG3 low tilemap bytes are updated
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

		lda	#%00010000					; make sure BG3 low tilemap bytes are updated
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
	inc	a
	sta	<DP2.DataBank
	cmp	#$60							; all banks done?
	bne	@ReadNextBank

	rts



; ************************* Sprite subroutines *************************

ConvertSpriteDataToBuffer:						; routine expects source data address set in WMADD<L/M/H>

; RAM.SpriteData* each consist of 128 5-byte-long entries of the
; following format:
;
; Byte 0 - X coordinate lower 8 of 9 bits
; Byte 1 - X coordinate 9th bit (bit 0), OBJ size (bit 1) (bits 2-7 always clear)
; Byte 2 - Y coordinate (8 bits total)
; Byte 3 - Tile number lower 8 of 9 bits (bit 9 = bit 0 of Attributes)
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
	lsr	a							; object no. RSH 2 = byte in high OAM containing bit pair of current object
	lsr	a

	Accu16

	and	#$00FF							; remove garbage data
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
	and	#$00FF							; clear garbage in high byte
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
	and	#$00FF							; mask off garbage data
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
	and	#$00FF							; mask off garbage data
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
	and	#$00FF							; mask off garbage data
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



; **************************** RAM routines ****************************

SRC_RAM_Routines:

@BurstTransferSPC700:
	.ACCU 8
	.INDEX 16

	SetDBR	:SRC_SPC700_driver	; ##### example

;	ldx	#$023f							; prepare transfer address
	ldx	#$003f

; ---- Execute transfer routine

	ldy	#$0002
	sty	<APUIO2
	stz	<APUIO1
	lda	<APUIO0
	inc	a
	inc	a
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
	cpx	#$0B3f							; 3 |
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

	SetDBR	$00							; set Data Bank = $00 for easier register access

	ldx	#$FFFF							; DMA mode (low byte), B bus register (high byte) // RAM_Routines.DMA + 14
 	stx	DMAP0
	ldx	#$FFFF							; data offset (16 bit) // RAM_Routines.DMA + 20
	stx	A1T0L
	lda	#$FF							; data bank (8 bit) // RAM_Routines.DMA + 26
	sta	A1B0
	ldx	#$FFFF							; data length (16 bit) // RAM_Routines.DMA + 31
	stx	DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
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

	SetDP	$2100							; set Direct Page to PPU registers

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



; ******************************** EOF *********************************
