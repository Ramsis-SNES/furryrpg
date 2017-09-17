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
	sta	$00
	stz	$01							; regs $2101-$210C: set sprite, character, tile sizes to lowest, and set addresses to $0000
	stz	$02
	stz	$03

	; reg $2104: OAM data write

	stz	$05
	stz	$06
	stz	$07
	stz	$08
	stz	$09
	stz	$0A
	stz	$0B
	stz	$0C
	stz	$0D							; regs $210D-$2114: set all BG scroll values to $0000
	stz	$0D
	stz	$0E
	stz	$0E
	stz	$0F
	stz	$0F
	stz	$10
	stz	$10
	stz	$11
	stz	$11
	stz	$12
	stz	$12
	stz	$13
	stz	$13
	stz	$14
	stz	$14
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	$15
	stz	$16							; regs $2116-$2117: VRAM address
	stz	$17

	; regs $2118-2119: VRAM data write

	stz	$1A
	stz	$1B							; regs $211B-$2120: Mode7 matrix values
	lda	#$01
	sta	$1B
	stz	$1C
	stz	$1C
	stz	$1D
	stz	$1D
	stz	$1E
;	lda	#$01							; never mind, 8-bit Accu still contains $01
	sta	$1E
	stz	$1F
	stz	$1F
	stz	$20
	stz	$20
	stz	$21

	; reg $2122: CGRAM data write

	stz	$23							; regs $2123-$2133: turn off windows, main screens, sub screens, color addition,
	stz	$24							; fixed color = $00, no super-impose (external synchronization), no interlace, normal resolution
	stz	$25
	stz	$26
	stz	$27
	stz	$28
	stz	$29
	stz	$2A
	stz	$2B
	stz	$2C
	stz	$2D
	stz	$2E
	stz	$2F
	lda	#$30
	sta	$30
	stz	$31
	lda	#$E0
	sta	$32
	stz	$33

	; regs $2134-$213F: PPU read registers, no initialization needed
	; regs $2140-$2143: APU communication regs, no initialization required
	; reg $2180: WRAM data read/write

	stz	$81							; regs $2181-$2183: WRAM address
	stz	$82
	stz	$83

	; regs $4016-$4017: serial JoyPad read registers, no need to initialize

	Accu16

	SetDPag	$4200							; set Direct Page to CPU registers

	Accu8

	stz	$00							; reg $4200: disable timers, NMI, and auto-joyread
	lda	#$FF
	sta	$01							; reg $4201: programmable I/O write port, initalize to allow reading at in-port
	stz	$02							; regs $4202-$4203: multiplication registers
	stz	$03
	stz	$04							; regs $4204-$4206: division registers
	stz	$05
	stz	$06
	stz	$07							; regs $4207-$4208: Horizontal-IRQ timer setting
	stz	$08
	stz	$09							; regs $4209-$420A: Vertical-IRQ timer setting
	stz	$0A
	stz	$0B							; reg $420B: turn off all general DMA channels
	stz	$0C							; reg $420C: turn off all HDMA channels
	lda	#$01							; reg $420D: set Memory-2 area to 3.58 MHz (FastROM)
	sta	$0D

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

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; VRAM (length $0000 = 65536 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $22, 512		; CGRAM (512 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $04, 512+32		; OAM (low+high OAM tables = 512+32 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 0		; WRAM (length $0000 = 65536 bytes = lower 64K of WRAM)

;	lda	#$01							; never mind, Accu still contains this value
	sta	REG_MDMAEN						; WRAM address in $2181-$2183 has reached $10000 now, re-initiate DMA transfer for the upper 64K of WRAM
	jsr	SpriteInit						; set up the sprite buffer



; -------------------------- HDMA channel 2: main backdrop color
	lda	#%01000011						; transfer mode (4 bytes --> $2121, $2121, $2122, $2122), indirect table mode
	sta	$4320
	lda	#$21							; PPU register $2121 (color index)
	sta	$4321
	ldx	#SRC_HDMA_ColorGradient
	stx	$4322
	lda	#:SRC_HDMA_ColorGradient
	sta	$4324
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4327



; -------------------------- more hardware checks/initialization
	jsl	BootSPC700						; boot APU with SNESGSS sound driver
	jsl	CheckForMSU1						; check if MSU1 present
	jsl	CheckSRAM						; check SRAM integrity



; -------------------------- copy DMA routine to WRAM
	ldx	#RAM_Code						; set WRAM address to RAM code section
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $00, :SRC_CodeDoDMA, SRC_CodeDoDMA, $80, _sizeof_SRC_CodeDoDMA



; -------------------------- load gfx & palettes for debug screen
	ldx	#ADDR_VRAM_BG3_Tiles					; set VRAM address for BG3 tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Font8x8, GFX_Font8x8, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-

	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32



; -------------------------- set screen regs
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	REG_OBSEL
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	REG_BG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE

	Accu16

	lda	#%0001010000010100					; turn on BG3 + sprites
	sta	REG_TM							; on mainscreen and subscreen
	sta	DP_Shadow_TSTM						; copy to shadow variable

	Accu8

	SetNMI	TBL_NMI_DebugMenu
	JoyInit								; initialize joypads and enable NMI & IRQ

	lda	ADDR_SRAM_GoodROM					; if byte is $01, then ROM integrity check was already passed
	cmp	#$01
	beq	+
	lda	#$0F							; turn on the screen
	sta	REG_INIDISP
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

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 8192

	lda	#$80							; increment VRAM address by one word after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000
	stx	REG_VMADDL

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM

	lda	#5							; set BG Mode 5
	sta	REG_BGMODE
	lda	#$50							; set BG1's Tile Map VRAM offset to $5000
	sta	REG_BG1SC						; and the Tile Map size to 32×32 tiles
	lda	#$54							; set BG2's Tile Map VRAM offset to $5400
	sta	REG_BG2SC						; and the Tile Map size to 32×32 tiles
	lda	#$20							; set BG1's Character VRAM offset to $0000, BG2 to $2000
	sta	REG_BG12NBA
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

	Accu16

	lda	#%0000001100000011					; turn on BG1 and 2 only
	sta	REG_TM							; on mainscreen and subscreen
	sta	DP_Shadow_TSTM						; copy to shadow variable

	Accu8

	stz	REG_CGADD						; reset CGRAM address
	stz	REG_CGDATA						; $3C00 = blue background color
	lda	#$3C
	sta	REG_CGDATA

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text+2, $22, 30	; skip background color (2 bytes)

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

	DMA_CH0 $02, $7E, (ARRAY_BG1TileMap1 & $FFFF), $18, 1024	; update tile maps

	ldx	#$5400							; set VRAM address for BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $02, $7E, (ARRAY_BG2TileMap1 & $FFFF), $18, 1024

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
	sta	REG_INIDISP

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

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM

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



Forever:
	lda	#$81
	sta	REG_NMITIMEN						; turn on NMI
-	wai								; wait for next frame
	bra	-



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
	beq	+
	jmp	__ROMIntegrityBad

+	eor	#$FFFF							; compare (sum XOR $FFFF) to ROM checksum complement
	cmp	$C0FFDC
	beq	+
	jmp	__ROMIntegrityBad

+	Accu8

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

	bra	__ROMIntegrityGood

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
	jmp	Forever

__ROMIntegrityGood:
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

SRC_CodeDoDMA:
	php								; preserve registers
	phb

	AccuIndex16

	pha
	phx
	phy

	Accu8

	SetDBR	$00							; set Data Bank = $00 for easy register access

	ldx	#$FFFF							; DMA mode (low byte), B bus register (high byte) // RAM_Code + 14
 	stx	$4300
	ldx	#$FFFF							; data offset (16 bit) // RAM_Code + 20
	stx	$4302
	lda	#$FF							; data bank (8 bit) // RAM_Code + 26
	sta	$4304
	ldx	#$FFFF							; data length (16 bit) // RAM_Code + 31
	stx	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	AccuIndex16

	ply								; restore registers
	plx
	pla
	plb
	plp
	rtl

SRC_CodeDoDMA_END:



; ******************************** EOF *********************************
