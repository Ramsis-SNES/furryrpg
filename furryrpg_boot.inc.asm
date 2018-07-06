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
	jsl	CheckForMSU1						; check if MSU1 present
	jsl	CheckSRAM						; check SRAM integrity



; -------------------------- copy DMA routine to WRAM
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
	sta	REG_TM
	sta	REG_TS
	sta	VAR_ShadowTM						; copy to shadow variables
	sta	VAR_ShadowTS

	SetNMI	TBL_NMI_DebugMenu
	JoyInit								; initialize joypads and enable NMI

	lda	ADDR_SRAM_GoodROM					; if byte is $01, then ROM integrity check was already passed
	cmp	#$01
	beq	+
	lda	#$0F							; turn on the screen
	sta	VAR_ShadowINIDISP
	jsr	VerifyROMIntegrity

+	jml	DebugMenu



; -------------------------- intro / title screen
ShowAlphaIntro:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

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
	lda	DP_Shadow_NMITIMEN					; reenable interrupts
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
	sta	DP_Shadow_NMITIMEN
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

VerifyROMIntegrity:
	stz	REG_CGADD						; reset CGRAM address for mainscreen BG color
	lda	#$7E							; $077E = bright yellow
	sta	REG_CGDATA
	lda	#$07
	sta	REG_CGDATA

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
	lda	#$C0							; set start address to $C00000
	sta	temp+7

.IFDEF DEBUG
	SetTextPos	9, 17
	PrintHexNum	temp+7

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
.ENDIF

	Accu16

	stz	temp+5
	lda	#$01FE							; assume [$C0FFDC-F] = $FF, $FF, $00, $00, so add these right now
	sta	temp+3
	ldy	#0
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#$FFDC							; location of checksum complement & checksum reached?
	bne	-

	ldy	#$FFE0							; skip both
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	bne	-

	Accu8

	inc	temp+7							; increment bank byte

--
.IFDEF DEBUG
	SetTextPos	9, 17
	PrintHexNum	temp+7

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
.ENDIF

	Accu16

	ldy	#0
-	lda	[temp+5], y						; from bank $C1 onwards, don't skip anything
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	bne	-

	Accu8

	lda	temp+7							; increment bank byte
	inc	a
	sta	temp+7
	cmp	#$C0 + TotalROMBanks					; all banks checked?
	bcc	--

	Accu16

	lda	temp+3							; compare sum to ROM checksum
	cmp	$C0FFDE
	bne	__ROMIntegrityBad
	eor	#$FFFF							; compare (sum XOR $FFFF) to ROM checksum complement
	cmp	$C0FFDC
	beq	__ROMIntegrityGood

__ROMIntegrityBad:
	Accu8

	stz	REG_CGADD						; reset CGRAM address
	lda	#$1C							; $001C = red
	sta	REG_CGDATA
	stz	REG_CGDATA

	PrintString	11, 3, "Corrupt ROM, unable to"
	PrintString	12, 3, "continue!"

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates

	Freeze								; enter trap loop

__ROMIntegrityGood:
	Accu8

	stz	REG_CGADD						; reset CGRAM address (i.e., set it to mainscreen backdrop color)
	lda	#$E4							; $13E4 = light green
	sta	REG_CGDATA
	lda	#$13
	sta	REG_CGDATA

	PrintString	11, 3, "ROM integrity check passed!"
	PrintString	12, 3, "Press any button ..."

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
	lda	#$01							; remember that ROM integrity check was passed
	sta	temp							; source data in temp
	ldx	#temp							; source data offset
	stx	DP_DataAddress
	lda	#$7E							; source data bank
	sta	DP_DataBank
	ldx	#(ADDR_SRAM_GoodROM & $FFFF) + 1			; destination offset + data length
	ldy	#1							; data length
	jsl	WriteDataToSRAM

	WaitUserInput

	rts



; *********************** Sprite initialization ************************

SpriteInit:
	php	

	AccuIndex16

	ldx	#$0000

__Init_OAM_lo:
	lda	#$F0F8
	sta	ARRAY_SpriteBuf1, x					; initialize all sprites to be off the screen
	inx
	inx
	stz	ARRAY_SpriteBuf1, x
	inx
	inx
	cpx	#$0200
	bne	__Init_OAM_lo

	Accu8

	ldx	#$0000

__Init_OAM_hi1:
	stz	ARRAY_SpriteBuf2, x					; small sprites for the sprite font
	inx
	cpx	#8							; see .STRUCT oam_high
	bne	__Init_OAM_hi1

	lda	#%10101010						; large sprites for everything else

__Init_OAM_hi2:
	sta	ARRAY_SpriteBuf2, x
	inx
	cpx	#32
	bne	__Init_OAM_hi2

	plp
	rts



; **************************** RAM routines ****************************

SRC_RAM_Code:

;SRC_CodeDoDMA:
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



;SRC_CodeUpdatePPURegs:
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
