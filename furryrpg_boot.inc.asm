;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** BOOT CODE ***
;
;==========================================================================================



Boot:
	rep	#AXY_8BIT|DEC_MODE					; A/X/Y = 16 bit, decimal mode off
	lda	#$1FFF							; set stack pointer to $1FFF
	tcs

	SetDPag	$2100							; set Direct Page to PPU registers
	Accu8
	SetDBR	$00							; set Data Bank = $00



; -------------------------- initialize registers
	lda	#$8F							; INIDISP (Display Control 1): forced blank
	sta	<REG_INIDISP
	stz	<REG_OBSEL						; regs $2101-$210C: set sprite, character, tile sizes to lowest, and set addresses to $0000
	stz	<REG_OAMADDL
	stz	<REG_OAMADDH

	; reg $2104: OAM data write

	stz	<REG_BGMODE
	stz	<REG_MOSAIC
	stz	<REG_BG1SC
	stz	<REG_BG2SC
	stz	<REG_BG3SC
	stz	<REG_BG4SC
	stz	<REG_BG12NBA
	stz	<REG_BG34NBA
	stz	<REG_BG1HOFS						; regs $210D-$2114: set all BG scroll values to $0000
	stz	<REG_BG1HOFS
	stz	<REG_BG1VOFS
	stz	<REG_BG1VOFS
	stz	<REG_BG2HOFS
	stz	<REG_BG2HOFS
	stz	<REG_BG2VOFS
	stz	<REG_BG2VOFS
	stz	<REG_BG3HOFS
	stz	<REG_BG3HOFS
	stz	<REG_BG3VOFS
	stz	<REG_BG3VOFS
	stz	<REG_BG4HOFS
	stz	<REG_BG4HOFS
	stz	<REG_BG4VOFS
	stz	<REG_BG4VOFS
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	<REG_VMAIN
	stz	<REG_VMADDL						; regs $2116-$2117: VRAM address
	stz	<REG_VMADDH

	; regs $2118-2119: VRAM data write

	stz	<REG_M7SEL
	stz	<REG_M7A						; regs $211B-$2120: Mode7 matrix values
	lda	#$01
	sta	<REG_M7A
	stz	<REG_M7B
	stz	<REG_M7B
	stz	<REG_M7C
	stz	<REG_M7C
	stz	<REG_M7D
;	lda	#$01							; never mind, 8-bit Accu still contains $01
	sta	<REG_M7D
	stz	<REG_M7X
	stz	<REG_M7X
	stz	<REG_M7Y
	stz	<REG_M7Y
	stz	<REG_CGADD

	; reg $2122: CGRAM data write

	stz	<REG_W12SEL						; regs $2123-$2133: turn off windows, main screens, sub screens, color addition,
	stz	<REG_W34SEL						; fixed color = $00, no super-impose (external synchronization), no interlace, normal resolution
	stz	<REG_WOBJSEL
	stz	<REG_WH0
	stz	<REG_WH1
	stz	<REG_WH2
	stz	<REG_WH3
	stz	<REG_WBGLOG
	stz	<REG_WOBJLOG
	stz	<REG_TM
	stz	<REG_TS
	stz	<REG_TMW
	stz	<REG_TSW
	lda	#$30
	sta	<REG_CGWSEL
	stz	<REG_CGADSUB
	lda	#$E0
	sta	<REG_COLDATA
	stz	<REG_SETINI

	; regs $2134-$213F: PPU read registers, no initialization needed
	; regs $2140-$2143: APU communication regs, no initialization required
	; reg $2180: WRAM data read/write

	stz	<REG_WMADDL						; regs $2181-$2183: WRAM address
	stz	<REG_WMADDM
	stz	<REG_WMADDH

	; regs $4016-$4017: serial JoyPad read registers, no need to initialize

	Accu16
	SetDPag	$4200							; set Direct Page to CPU registers
	Accu8

	stz	<REG_NMITIMEN						; reg $4200: disable timers, NMI, and auto-joyread
	lda	#$FF
	sta	<REG_WRIO						; reg $4201: programmable I/O write port, initalize to allow reading at in-port
	stz	<REG_WRMPYA						; regs $4202-$4203: multiplication registers
	stz	<REG_WRMPYB
	stz	<REG_WRDIVL						; regs $4204-$4206: division registers
	stz	<REG_WRDIVH
	stz	<REG_WRDIVB
	stz	<REG_HTIMEL						; regs $4207-$4208: Horizontal-IRQ timer setting
	stz	<REG_HTIMEH
	stz	<REG_VTIMEL						; regs $4209-$420A: Vertical-IRQ timer setting
	stz	<REG_VTIMEH
	stz	<REG_MDMAEN						; reg $420B: turn off all general DMA channels
	stz	<REG_HDMAEN						; reg $420C: turn off all HDMA channels
	lda	#$01							; reg $420D: set Memory-2 area to 3.58 MHz (FastROM)
	sta	<REG_MEMSEL

	; regs $420E-$420F: unused registers
	; reg $4210: RDNMI (R)
	; reg $4211: IRQ status, no need to initialize
	; reg $4212: H/V blank and JoyRead status, no need to initialize
	; reg $4213: programmable I/O inport, no need to initialize
	; regs $4214-$4215: divide results, no need to initialize
	; regs $4216-$4217: multiplication or remainder results, no need to initialize
	; regs $4218-$421f: JoyPad read registers, no need to initialize
	; regs $4300-$437F: DMA/HDMA parameters, unused registers



; -------------------------- clear all directly accessible RAM areas (with parameters/addresses set/reset above)
	Accu16
	SetDPag	$0000							; set Direct Page = $0000
	Accu8
	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, <REG_VMDATAL, 0	; VRAM (length $0000 = 65536 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_CGDATA, 512	; CGRAM (512 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_OAMDATA, 544	; OAM (low+high OAM tables = 512+32 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 0	; WRAM (length $0000 = 65536 bytes = lower 64K of WRAM)

;	lda	#$01							; never mind, Accu still contains this value
	sta	REG_MDMAEN						; WRAM address in $2181-$2183 has reached $10000 now, re-initiate DMA transfer for the upper 64K of WRAM
	jsr	SpriteInit						; set up the sprite buffer
	jsr	SpriteDataInit



; -------------------------- HDMA channel 2: main backdrop color
	lda	#%01000011						; transfer mode (4 bytes --> $2121, $2121, $2122, $2122), indirect table mode
	sta	REG_DMAP2
	lda	#<REG_CGADD						; PPU register $2121 (color index)
	sta	REG_BBAD2
	ldx	#SRC_HDMA_ColorGradient
	stx	REG_A1T2L
	lda	#:SRC_HDMA_ColorGradient
	sta	REG_A1B2
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB2



; -------------------------- more hardware checks/initialization
	jsl	BootSPC700						; boot APU with SNESGSS sound driver
	jsl	CheckHardware						; check if special hardware and/or enhancement chips like MSU1, RTC etc. are available
	jsl	CheckSRAM						; check SRAM integrity



; -------------------------- copy RAM routines to WRAM
	ldx	#RAM_Code & $FFFF					; set WRAM address to RAM code section
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $00, :SRC_RAM_Code, SRC_RAM_Code, <REG_WMDATA, _sizeof_SRC_RAM_Code



; -------------------------- load gfx & palettes for debug screen
	ldx	#ADDR_VRAM_BG3_Tiles					; set VRAM address for BG3 tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Font8x8, GFX_Font8x8, <REG_VMDATAL, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-

	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, <REG_CGDATA, 32



; -------------------------- set PPU shadow registers
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	VAR_ShadowOBSEL
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	VAR_ShadowBG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	VAR_ShadowBG34NBA
	lda	#$01							; set BG mode 1
	sta	VAR_ShadowBGMODE
	lda	#%00010100						; turn on BG3 + sprites on mainscreen and subscreen
	sta	VAR_ShadowTM
	sta	VAR_ShadowTS

	SetNMI	TBL_NMI_DebugMenu
	JoyInit								; initialize joypads and enable NMI

	lda	ADDR_SRAM_GoodROM					; if byte is $01, then ROM integrity check was already passed
	cmp	#$01
	beq	+
	lda	#$0F							; turn on the screen
	sta	VAR_ShadowINIDISP
	jsr	CheckROMIntegrity

+	jml	DebugMenu



; -------------------------- intro / title screen
ShowAlphaIntro:
	DisableIRQs

	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	jsl	music_stop						; stop music in case it's playing

	ldx	#(ARRAY_BG1TileMap1 & $FFFF)				; clear BG1/2 tile map buffers
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 8192

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000
	stx	REG_VMADDL

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, <REG_VMDATAL, 0	; clear VRAM

	lda	#5							; set BG Mode 5
	sta	VAR_ShadowBGMODE
	lda	#$50							; set BG1's Tile Map VRAM offset to $5000
	sta	VAR_ShadowBG1SC						; and the Tile Map size to 32×32 tiles
	lda	#$54							; set BG2's Tile Map VRAM offset to $5400
	sta	VAR_ShadowBG2SC						; and the Tile Map size to 32×32 tiles
	lda	#$20							; set BG1's Character VRAM offset to $0000, BG2 to $2000
	sta	VAR_ShadowBG12NBA
	stz	REG_BG1HOFS						; reset BG1 horizontal scroll
	stz	REG_BG1HOFS
	stz	REG_BG2HOFS						; reset BG2 horizontal scroll
	stz	REG_BG2HOFS
	lda	#$FF							; scroll BG1 down by 1 px
	sta	REG_BG1VOFS
	stz	REG_BG1VOFS
;	lda	#$FF							; scroll BG2 down by 1 px
	sta	REG_BG2VOFS
	stz	REG_BG2VOFS
	lda	#%00000011						; turn on BG1 and 2 only on mainscreen and subscreen
	sta	VAR_ShadowTM
	sta	VAR_ShadowTS
	stz	REG_CGADD						; reset CGRAM address
	stz	REG_CGDATA						; $3C00 = blue background color
	lda	#$3C
	sta	REG_CGDATA						; next DMA skips background color (2 bytes)

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text+2, <REG_CGDATA, 30

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000							; set VRAM address for BG1 font tiles
	stx	REG_VMADDL
	jsr	MakeMode5FontBG1

	ldx	#$2000							; set VRAM address for BG2 font tiles
	stx	REG_VMADDL
	jsr	MakeMode5FontBG2

	SetTextPos	2, 2

	ldx	#STR_Software_Title
	stx	DP_TextStringPtr
	lda	#:STR_Software_Title
	sta	DP_TextStringBank
	jsr	PrintHiResFWF

	lda	#' '							; add a space before the build no.
	sta	ARRAY_TempString
	stz	ARRAY_TempString+1
	ldx	#ARRAY_TempString
	stx	DP_TextStringPtr
	lda	#$7E
	sta	DP_TextStringBank
	jsr	PrintHiResFWF

	ldx	#STR_SoftwareBuild
	stx	DP_TextStringPtr
	lda	#:STR_SoftwareBuild
	sta	DP_TextStringBank
	jsr	PrintHiResFWF

	SetTextPos	3, 2

	ldx	#STR_SoftwareMaker
	stx	DP_TextStringPtr
	lda	#:STR_SoftwareMaker
	sta	DP_TextStringBank
	jsr	PrintHiResFWF

	SetTextPos	4, 2

	ldx	#STR_SoftwareBuildTimestamp
	stx	DP_TextStringPtr
	lda	#:STR_SoftwareBuildTimestamp
	sta	DP_TextStringBank
	jsr	PrintHiResFWF

	SetTextPos	6, 2

	ldx	#STR_DisclaimerWallofText
	stx	DP_TextStringPtr
	lda	#:STR_DisclaimerWallofText
	sta	DP_TextStringBank
	jsr	PrintHiResFWF

	stz	REG_VMAIN						; increment VRAM address by one word after writing to $2118
	ldx	#$5000							; set VRAM address for BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $02, $7E, (ARRAY_BG1TileMap1 & $FFFF), <REG_VMDATAL, 1024

	ldx	#$5400							; set VRAM address for BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $02, $7E, (ARRAY_BG2TileMap1 & $FFFF), <REG_VMDATAL, 1024

	SetNMI	TBL_NMI_Intro

	lda	REG_RDNMI						; clear NMI flag
	lda	VAR_Shadow_NMITIMEN					; reenable interrupts
	sta	REG_NMITIMEN
	cli

	Accu16

	lda	#0							; rest of intro = event #0
	jsl	LoadEvent

.ACCU 8

	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP
	wai

	DisableIRQs
	SetNMI	TBL_NMI_DebugMenu

.IFNDEF NOMUSIC
	Accu16

	lda	#$0010							; fade-out intro song
	sta	DP_SPC_VolFadeSpeed
	stz	DP_SPC_VolCurrent
	jsl	spc_global_volume

	Accu8
.ENDIF

	ldx	#$0000
	stx	REG_VMADDL

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, <REG_VMDATAL, 0	; clear VRAM

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; reenable interrupts
	sta	REG_NMITIMEN
	sta	VAR_Shadow_NMITIMEN
	cli
	rtl



.ENDASM

; -------------------------- preliminary title screen loop
StartScreenLoop:
	wai



; -------------------------- check for Start
	lda	DP_Joy1+1
	and	#%00010000
	beq	StartScreenLoop



; -------------------------- Start pressed, go to debug menu
	lda	#$0F
-	dec	a
	sta	REG_INIDISP
	wai
	wai
	cmp	#$00
	bne	-

	jsr	ClearSpriteText

	jml	DebugMenu

.ASM



; ************************* Testing functions **************************

CheckHardware:



; -------------------------- MSU1 (byuu, ikari)
	lda	MSU_ID							; check for "S-MSU1"
	cmp	#'S'
	bne	__NoMSU1
	lda	MSU_ID+1
	cmp	#'-'
	bne	__NoMSU1
	lda	MSU_ID+2
	cmp	#'M'
	bne	__NoMSU1
	lda	MSU_ID+3
	cmp	#'S'
	bne	__NoMSU1
	lda	MSU_ID+4
	cmp	#'U'
	bne	__NoMSU1
	lda	MSU_ID+5
	cmp	#'1'
	beq	__MSU1Found

__NoMSU1:
	lda	#%00000001
	trb	DP_GameConfig						; clear "MSU1 present" flag
	bra	+

__MSU1Found:
	lda	#%00000001
	tsb	DP_GameConfig						; set "MSU1 present" flag
+



; -------------------------- S-RTC (Sharp)
	lda	SRTC_READ
	and	#$0F							; from Fullsnes: If ([002800h] AND 0F)=0Fh then read <Timestamp(13 digits)>
	cmp	#$0F
	beq	__SRTCfound
	lda	#%00000010
	trb	DP_GameConfig						; clear "S-RTC present" flag
	bra	+

__SRTCfound:
	lda	#%00000010
	tsb	DP_GameConfig						; set "S-RTC present" flag
/*	lda	#$0E							; from Fullsnes: Send <0Eh,04h,0Dh,0Eh,00h,Timestamp(12 digits),0Dh> to [002801h]
	sta	SRTC_WRITE
	lda	#$04
	sta	SRTC_WRITE
	lda	#$0D
	sta	SRTC_WRITE
	lda	#$0E
	sta	SRTC_WRITE
	stz	SRTC_WRITE
	stz	SRTC_WRITE						; seconds (lower 4 bits)
	stz	SRTC_WRITE						; seconds (upper 4 bits)
	lda	#$05
	sta	SRTC_WRITE						; minutes.lo
	lda	#$02
	sta	SRTC_WRITE						; minutes.hi
	lda	#$06
	sta	SRTC_WRITE						; hours.lo
	lda	#$01
	sta	SRTC_WRITE						; hours.hi
	lda	#$07
	sta	SRTC_WRITE						; day.lo
	lda	#$01
	sta	SRTC_WRITE						; day.hi
	lda	#$07
	sta	SRTC_WRITE						; month
	lda	#$08
	sta	SRTC_WRITE						; year.lo
	lda	#$01
	sta	SRTC_WRITE						; year.hi
	lda	#$0A
	sta	SRTC_WRITE						; century
;	lda	something
;	sta	SRTC_WRITE						; weekday
	lda	#$0D
	sta	SRTC_WRITE
*/
+



; -------------------------- Ultra16 (d4s)
	lda	#$AA
	sta	$21C0
	lda	$21C1
	ora	#$40
	sta	$21C1
	lda	$21C0
	cmp	#$55
	beq	@U16Detected
	lda	#%00000100
	trb	DP_GameConfig						; clear "Ultra16 present" flag
	bra	+

@U16Detected:
	lda	#%00000100
	tsb	DP_GameConfig						; set "Ultra16 present" flag
+	rtl



CheckROMIntegrity:
	PrintString	2, 3, "ROM integrity check"
	PrintString	3, 3, "-------------------"
	PrintString	5, 3, "This is done only once to"
	PrintString	6, 3, "ensure the ROM is valid."
	PrintString	8, 3, "Please wait ..."

.IFDEF DEBUG
	PrintString	9, 3, "Reading bank $"
.ENDIF

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates



; -------------------------- read bank $C0
	lda	#$C0							; set start bank to $C0
	sta	DP_DataBank

.IFDEF DEBUG
	SetTextPos	9, 17
	PrintHexNum	DP_DataBank

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
.ENDIF

	Accu16

	stz	DP_DataAddress						; reset address
	lda	#$05FA							; checksum & checksum complement always add up to $1FE, so add these right now (3 times because banks $40...$5F will be read twice)
	sta	DP_Temp+3
	ldy	#0
-	lda	[DP_DataAddress], y
	and	#$00FF
	clc
	adc	DP_Temp+3
	sta	DP_Temp+3
	iny
	cpy	#$FFDC							; location of checksum complement & checksum reached?
	bne	-

	ldy	#$FFE0							; skip both
-	lda	[DP_DataAddress], y
	and	#$00FF
	clc
	adc	DP_Temp+3
	sta	DP_Temp+3
	iny
	bne	-

	Accu8

	inc	DP_DataBank						; increment bank byte



; -------------------------- read banks $C1...$FF
@ReadNextBank:


.IFDEF DEBUG
	SetTextPos	9, 17
	PrintHexNum	DP_DataBank

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
.ENDIF

	Accu16

	ldy	#0
-	lda	[DP_DataAddress], y
	and	#$00FF
	clc
	adc	DP_Temp+3
	sta	DP_Temp+3
	iny
	bne	-

	Accu8

	inc	DP_DataBank						; increment bank byte
	bne	@ReadNextBank						; bank $FF done (wrapped around to 0)?



; -------------------------- read banks $40...$5F twice (see Fullsnes notes on ROM sizes and checksumming)
	jsr	ReadBanks40thru5F
	jsr	ReadBanks40thru5F



; -------------------------- perform checksum checks
	Accu16

	lda	DP_Temp+3
	cmp	$C0FFDE							; compare sum to "HiROM" ROM checksum
	bne	@ROMIntegrityBad
	cmp	$40FFDE							; compare sum to "ExHiROM" ROM checksum
	bne	@ROMIntegrityBad
	eor	#$FFFF
	cmp	$C0FFDC							; compare (sum XOR $FFFF) to "HiROM" ROM checksum complement
	bne	@ROMIntegrityBad
	cmp	$40FFDC							; compare (sum XOR $FFFF) to "ExHiROM" ROM checksum complement
	bne	@ROMIntegrityBad
	jmp	@ROMIntegrityGood

@ROMIntegrityBad:
	Accu8

	stz	REG_CGADD						; reset CGRAM address
	lda	#$1C							; $001C = red background color
	sta	REG_CGDATA
	stz	REG_CGDATA

	PrintString	11, 3, "Corrupt ROM, unable to"
	PrintString	12, 3, "continue!"

.IFDEF DEBUG
	PrintString	14, 3, "Chsum:"
	SetTextPos	14, 10
	PrintHexNum	DP_Temp+3
	SetTextPos	14, 12
	PrintHexNum	DP_Temp+4
.ENDIF

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates

	Freeze								; enter trap loop

@ROMIntegrityGood:
	Accu8

	lda	#$01							; remember that ROM integrity check was passed
	sta	DP_Temp							; source data in DP_Temp
	ldx	#DP_Temp						; source data offset
	stx	DP_DataAddress
	lda	#$7E							; source data bank
	sta	DP_DataBank
	ldx	#(ADDR_SRAM_GoodROM & $FFFF) + 1			; destination offset + data length
	ldy	#1							; data length
	jsl	WriteDataToSRAM

	rts



ReadBanks40thru5F:
	lda	#$40							; set start bank to $40
	sta	DP_DataBank

.IFDEF DEBUG
	SetTextPos	9, 17
	PrintHexNum	DP_DataBank

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
.ENDIF

	Accu16

	stz	DP_DataAddress						; reset address
	ldy	#0
-	lda	[DP_DataAddress], y
	and	#$00FF
	clc
	adc	DP_Temp+3
	sta	DP_Temp+3
	iny
	cpy	#$FFDC							; location of checksum complement & checksum reached?
	bne	-

	ldy	#$FFE0							; skip both
-	lda	[DP_DataAddress], y
	and	#$00FF
	clc
	adc	DP_Temp+3
	sta	DP_Temp+3
	iny
	bne	-

	Accu8

	inc	DP_DataBank						; increment bank byte



; -------------------------- read banks $41...$5F
@ReadNextBank:


.IFDEF DEBUG
	SetTextPos	9, 17
	PrintHexNum	DP_DataBank

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
.ENDIF

	Accu16

	ldy	#0
-	lda	[DP_DataAddress], y
	and	#$00FF
	clc
	adc	DP_Temp+3
	sta	DP_Temp+3
	iny
	bne	-

	Accu8

	lda	DP_DataBank						; increment bank byte
	inc	a
	sta	DP_DataBank
	cmp	#$60							; all banks done?
	bne	@ReadNextBank

	rts



; ************************* Sprite subroutines *************************

ConvertSpriteDataToBuffer:						; routine expects source data address set in REG_WMADD<L/M/H>

; ARRAY_SpriteData* each consist of 128 5-byte-long entries of the
; following format:
;
; Byte 0 - X-Coordinate lower 8bit
; Byte 1 - X-Coordinate upper 1bit (bit 0), OBJ size (bit 1)
; Byte 2 - Y-Coordinate (all 8bits)
; Byte 3 - Tile Number  (lower 8bit) (upper 1bit within Attributes)
; Byte 4 - Attributes
;
; This routine, which should be called once per frame during active
; display, converts this data to OAM hi/lo format in ARRAY_ShadowOAM_Lo
; and ARRAY_ShadowOAM_Hi (which are transferred to OAM during Vblank).

	phx								; preserve super-loop indices
	phy
	stz	DP_SprDataObjNo						; reset object counter
	ldx	#0							; X = index for ARRAY_ShadowOAM_Lo

@ConvertSpriteDataLoop:
	lda	REG_WMDATA						; read X coordinate lower 8 bits
	sta	ARRAY_ShadowOAM_Lo, x
	inx



; -------------------------- some bitwise operation magic for 9th bit of X coordinate and sprite size in high OAM
	lda	DP_SprDataObjNo
	and	#%00000011						; (object no. AND $03) * 2 = amount of (single) ASL operations required for correct bit pair in current high OAM byte
	asl	a
	sta	DP_Temp							; DP_Temp = counter variable for upcoming bit-shifting loop
	lda	#%00000011						; keep track of bit pair position, assume bits 0-1 for now
	sta	DP_SprDataHiOAMBits
	lda	DP_SprDataObjNo						; next, prepare index for ARRAY_ShadowOAM_Hi
	lsr	a							; object no. RSH 2 = byte in high OAM containing bit pair of current object
	lsr	a

	Accu16

	and	#$00FF							; remove garbage data
	tay								; Y = index for ARRAY_ShadowOAM_Hi

	Accu8

	lda	REG_WMDATA						; read X coordinate upper 1 bit (bit 0), OBJ size (bit 1)
	and	#%00000011						; mask off unused/irrelevant bits just in case
-	dec	DP_Temp							; decrement counter, this needs to be done first as it could be zero (= no bit-shifting needed at all)
	bmi	+							; counter has reached/is zero --> jump out
	asl	a							; shift bits left until correct bit pair reached
	asl	DP_SprDataHiOAMBits					; keep track of bit pair position (important for bits that need to be cleared)
	bra	-

+	sta	DP_Temp+1						; save bit pair in correct position
	ora	ARRAY_ShadowOAM_Hi, y					; set bit(s) that is/are to be set in current high OAM byte
	sta	ARRAY_ShadowOAM_Hi, y
	lda	DP_Temp+1						; load bit pair again
	eor	DP_SprDataHiOAMBits					; make set bits clear, and vice versa
	eor	#$FF							; \ these two instructions essentially replace a TRB instruction, which doesn't support indexed addressing
	and	ARRAY_ShadowOAM_Hi, y					; /
	sta	ARRAY_ShadowOAM_Hi, y



; -------------------------- rest is trivial
	lda	REG_WMDATA						; read Y coordinate
	sta	ARRAY_ShadowOAM_Lo, x
	inx
	lda	REG_WMDATA						; read tile no.
	sta	ARRAY_ShadowOAM_Lo, x
	inx
	lda	REG_WMDATA						; read attributes
	sta	ARRAY_ShadowOAM_Lo, x
	inx
	inc	DP_SprDataObjNo						; increment object counter
	cpx	#512							; all 128 sprites done?
	bne	@ConvertSpriteDataLoop

	ply								; restore super-loop indices
	plx
	rts



SpriteDataInit:
	ldx	#0

	Accu16

@InitSprDataAreaLoop1:
	lda	#$00FF							; X coordinate (9 bits), sprite size (10th bit) 0 = small
	sta	ARRAY_SpriteDataArea, x					; initialize all sprites to be off the screen
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	ARRAY_SpriteDataArea, x
	inx

	Accu16

	lda	DP_EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; mask off garbage data
	sta	ARRAY_SpriteDataArea, x					; attributes, tile num
	inx
	inx
	cpx	#32*5							; sprite font done?
	bne	@InitSprDataAreaLoop1

@InitSprDataAreaLoop2:
	lda	#$02FF							; X coordinate (9 bits), sprite size (10th bit) 1 = large
	sta	ARRAY_SpriteDataArea, x
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	ARRAY_SpriteDataArea, x
	inx

	Accu16

	lda	DP_EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; mask off garbage data
	sta	ARRAY_SpriteDataArea, x					; attributes, tile num
	inx
	inx
	cpx	#128*5							; all sprites done?
	bne	@InitSprDataAreaLoop2

	ldx	#0

@InitSprDataMenuLoop:
	lda	#$02FF							; X coordinate (9 bits), sprite size (10th bit) 1 = large
	sta	ARRAY_SpriteDataMenu, x
	inx
	inx

	Accu8

	lda	#$E0							; Y coordinate
	sta	ARRAY_SpriteDataMenu, x
	inx

	Accu16

	lda	DP_EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; mask off garbage data
	sta	ARRAY_SpriteDataMenu, x					; attributes, tile num
	inx
	inx
	cpx	#128*5							; all sprites done?
	bne	@InitSprDataMenuLoop

	Accu8

	rts



SpriteInit:
	php	

	AccuIndex16

	ldx	#$0000

@Init_OAM_lo:
	lda	#$E0FF
	sta	ARRAY_ShadowOAM_Lo, x					; initialize all sprites to be off the screen
	inx
	inx
	lda	DP_EmptySpriteNo					; acknowledge no. of empty sprite (usually 0)
	and	#$00FF							; mask off garbage data
	sta	ARRAY_ShadowOAM_Lo, x
	inx
	inx
	cpx	#$0200
	bne	@Init_OAM_lo

	Accu8

	ldx	#$0000

@Init_OAM_hi1:
	stz	ARRAY_ShadowOAM_Hi, x					; small sprites for the sprite font
	inx
	cpx	#8							; 8 * 4 = 32 sprites
	bne	@Init_OAM_hi1

	lda	#%10101010						; large sprites for everything else

@Init_OAM_hi2:
	sta	ARRAY_ShadowOAM_Hi, x
	inx
	cpx	#32
	bne	@Init_OAM_hi2

	plp
	rts



; **************************** RAM routines ****************************

SRC_RAM_Code:

@SRC_CodeDoDMA:
	php								; preserve registers
	phb

	AccuIndex16

	pha
	phx
	phy

	Accu8
	SetDBR	$00							; set Data Bank = $00 for easy register access

	ldx	#$FFFF							; DMA mode (low byte), B bus register (high byte) // RAM_Code.DoDMA + 14
 	stx	REG_DMAP0
	ldx	#$FFFF							; data offset (16 bit) // RAM_Code.DoDMA + 20
	stx	REG_A1T0L
	lda	#$FF							; data bank (8 bit) // RAM_Code.DoDMA + 26
	sta	REG_A1B0
	ldx	#$FFFF							; data length (16 bit) // RAM_Code.DoDMA + 31
	stx	REG_DAS0L
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	AccuIndex16

	ply								; restore registers
	plx
	pla
	plb
	plp
	rtl



@SRC_CodeUpdatePPURegs:
	php								; preserve registers
	phd

	AccuIndex16
	SetDPag	$2100							; set Direct Page to PPU registers
	Accu8



; -------------------------- update registers
	lda	#$0F							; + 11
	sta	<REG_INIDISP
	lda	#$00							; + 15
	sta	<REG_OBSEL
	lda	#$00							; + 19
	sta	<REG_BGMODE
	lda	#$00							; + 23
	sta	<REG_MOSAIC
	lda	#$00							; + 27
	sta	<REG_BG1SC
	lda	#$00							; + 31
	sta	<REG_BG2SC
	lda	#$00							; + 35
	sta	<REG_BG3SC
	lda	#$00							; + 39
	sta	<REG_BG4SC
	lda	#$00							; + 43
	sta	<REG_BG12NBA
	lda	#$00							; + 47
	sta	<REG_BG34NBA
	lda	#$00							; + 51
	sta	<REG_W12SEL
	lda	#$00							; + 55
	sta	<REG_W34SEL
	lda	#$00							; + 59
	sta	<REG_WOBJSEL
	lda	#$00							; + 63
	sta	<REG_WH0
	lda	#$00							; + 67
	sta	<REG_WH1
	lda	#$00							; + 71
	sta	<REG_WH2
	lda	#$00							; + 75
	sta	<REG_WH3
	lda	#$00							; + 79
	sta	<REG_WBGLOG
	lda	#$00							; + 83
	sta	<REG_WOBJLOG
	lda	#$00							; + 87
	sta	<REG_TM
	lda	#$00							; + 91
	sta	<REG_TS
	lda	#$00							; + 95
	sta	<REG_TMW
	lda	#$00							; + 99
	sta	<REG_TSW
	lda	#$30							; + 103
	sta	<REG_CGWSEL
	lda	#$00							; + 107
	sta	<REG_CGADSUB
	lda	#$E0							; + 111
	sta	<REG_COLDATA
	lda	#$00							; + 115
	sta	<REG_SETINI

	pld								; restore registers
	plp
	rtl

SRC_RAM_Code_END:



; ******************************** EOF *********************************
