;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** BOOT CODE ***
;
;==========================================================================================



Boot:
	rep #AXY_8BIT|DEC_MODE			; A/X/Y = 16 bit, decimal mode off

	lda #$1FFF				; set stack pointer to $1FFF
	tcs

	SetDirectPage $2100

	A8

	SetDataBank $00



; -------------------------- initialize registers
	lda #$8F				; INIDISP (Display Control 1): forced blank
	sta $00
	stz $01					; regs $2101-$210C: set sprite, character, tile sizes to lowest, and set addresses to $0000
	stz $02
	stz $03

	; reg $2104: OAM data write

	stz $05
	stz $06
	stz $07
	stz $08
	stz $09
	stz $0A
	stz $0B
	stz $0C
	stz $0D					; regs $210D-$2114: set all BG scroll values to $0000
	stz $0D
	stz $0E
	stz $0E
	stz $0F
	stz $0F
	stz $10
	stz $10
	stz $11
	stz $11
	stz $12
	stz $12
	stz $13               
	stz $13               
	stz $14
	stz $14
	lda #$80				; VRAM address increment mode: increment address by one word
	sta $15					; after accessing the high byte ($2119)
	stz $16					; regs $2116-$2117: VRAM address
	stz $17

	; regs $2118-2119: VRAM data write

	stz $1A
	stz $1B					; regs $211B-$2120: Mode7 matrix values
	lda #$01
	sta $1B
	stz $1C
	stz $1C
	stz $1D
	stz $1D
	stz $1E       
	lda #$01
	sta $1E
	stz $1F
	stz $1F
	stz $20
	stz $20
	stz $21

	; reg $2122: CGRAM data write

	stz $23					; regs $2123-$2133: turn off windows, main screens, sub screens, color addition,
	stz $24					; fixed color = $00, no super-impose (external synchronization), no interlace, normal resolution
	stz $25
	stz $26
	stz $27
	stz $28
	stz $29
	stz $2A
	stz $2B
	stz $2C
	stz $2D
	stz $2E
	stz $2F
	lda #$30
	sta $30
	stz $31
	lda #$E0
	sta $32
	stz $33

	; regs $2134-$213F: PPU read registers, no initialization needed
	; regs $2140-$2143: APU communication regs, no initialization required

	; reg $2180: WRAM data read/write

	stz $81					; regs $2181-$2183: WRAM address
	stz $82
	stz $83

	; regs $4016-$4017: serial JoyPad read registers, no need to initialize

	A16

	SetDirectPage $4200

	A8

	stz $00					; reg $4200: disable timers, NMI, and auto-joyread
	lda #$FF
	sta $01					; reg $4201: programmable I/O write port, initalize to allow reading at in-port
	stz $02					; regs $4202-$4203: multiplication registers
	stz $03
	stz $04					; regs $4204-$4206: division registers
	stz $05
	stz $06
	stz $07					; regs $4207-$4208: Horizontal-IRQ timer setting
	stz $08
	stz $09					; regs $4209-$420A: Vertical-IRQ timer setting
	stz $0A
	stz $0B					; reg $420B: turn off all general DMA channels
	stz $0C					; reg $420C: turn off all HDMA channels
	lda #$01				; reg $420D: set Memory-2 area to 3.58 MHz (FastROM)
	sta $0D

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
	A16

	SetDirectPage $0000

	A8

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0	; VRAM (length $0000 = 65536 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $22, 512	; CGRAM (512 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $04, 512+32	; OAM (low+high OAM tables = 512+32 bytes)
	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 0	; WRAM (length $0000 = 65536 bytes = lower 64K of WRAM)

	lda #$01				; WRAM address in $2181-$2183 has reached $10000 now,
	sta $420B				; so re-initiate DMA transfer for the upper 64K of WRAM

	jsr SpriteInit				; set up the sprite buffer



; -------------------------- HDMA channel 2: main backdrop color
	lda #%01000011				; transfer mode (4 bytes --> $2121, $2121, $2122, $2122), indirect table mode
	sta $4320

	lda #$21				; PPU register $2121 (color index)
	sta $4321

	ldx #SRC_HDMA_ColorGradient
	stx $4322

	lda #:SRC_HDMA_ColorGradient
	sta $4324

	lda #$7E				; indirect HDMA CPU bus data address bank
	sta $4327



; -------------------------- HDMA channel 3: color math
	lda #$02				; transfer mode (2 bytes --> $2132)
	sta $4330

	lda #$32				; PPU register $2132 (color math subscreen backdrop color)
	sta $4331

	ldx #ARRAY_HDMA_ColorMath
	stx $4332

	lda #$7E				; table in WRAM expected
	sta $4334



.IFDEF QUICKTEST
	SetVblankRoutine TBL_NMI_Intro

	jsr JoyInit				; initialize joypads and enable NMI
	jsl BootSPC700				; boot APU with SNESGSS sound driver
	jsl CheckForMSU
	jsr CheckSRAM

	jml AreaEnter

	lda #%00000011				; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta $2101
	jml TestMode7
.ENDIF



; -------------------------- intro / title screen
	lda #%00000011				; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta $2101

	lda #$03				; set BG Mode 3
	sta $2105

	lda #$50				; set BG1's Tile Map VRAM offset to $5000 (word address)
	sta $2107				; and the Tile Map size to 32×32 tiles

	lda #$20				; set BG1's Character VRAM offset to $0000 (word address)
	sta $210B				; (ignore BG2 bits)

	stz $210D				; reset BG1 horizontal scroll
	stz $210D

	lda #$FF				; set BG1 vertical scroll = -1 (reminder: 0 would mean 1st scanline invisible!)
	sta $210E
	stz $210E

	lda #%00010001				; turn on BG1 and sprites only
	sta $212C				; on the mainscreen
	sta $212D				; and on the subscreen

	SetVblankRoutine TBL_NMI_Intro

	jsr JoyInit				; initialize joypads and enable NMI
	jsl BootSPC700				; boot APU with SNESGSS sound driver
	jsl CheckForMSU
	jsr CheckSRAM

	A16

	lda #7
	sta DP_NextTrack

	A8

	jsl PlayTrack

;StartScreenProc:
	stz $2121				; reset CGRAM address
	DMA_CH0 $02, :SRC_RamsisPal, SRC_RamsisPal, $22, 512

	ldx #$0000
	stx $2116

	DMA_CH0 $01, :GFX_RamsisPic, GFX_RamsisPic, $18, 40384

	ldx #$5000
	stx $2116

	DMA_CH0 $01, :SRC_RamsisMap, SRC_RamsisMap, $18, 2048

	lda #$FF
	ldx #0

-	wai

	inc a
	inc a
	sta $2100

	inx
	cpx #8
	bne -

	WaitForFrames 150

	lda #$0F
	ldx #0

-	wai

	dec a
	dec a
	sta $2100

	inx
	cpx #8
	bne -

	lda #$80				; enter forced blank
	sta $2100

	WaitForFrames 10

	stz $2121				; reset CGRAM address
	DMA_CH0 $02, :SRC_RamsisPresentsPal, SRC_RamsisPresentsPal, $22, 512

	ldx #$0000
	stx $2116

	DMA_CH0 $01, :GFX_RamsisPresentsPic, GFX_RamsisPresentsPic, $18, 40384

	ldx #$5000
	stx $2116

	DMA_CH0 $01, :SRC_RamsisPresentsMap, SRC_RamsisPresentsMap, $18, 2048

	lda #$FF
	ldx #0

-	wai

	inc a
	inc a
	sta $2100

	inx
	cpx #8
	bne -

	WaitForFrames 150

	lda #$0F
	ldx #0

-	wai

	dec a
	dec a
	sta $2100

	inx
	cpx #8
	bne -

	lda #$80				; enter forced blank
	sta $2100

	WaitForFrames 10

	stz $2121				; reset CGRAM address
	DMA_CH0 $02, :SRC_StartPal, SRC_StartPal, $22, 512

	ldx #$0000
	stx $2116

	DMA_CH0 $01, :GFX_StartPic, GFX_StartPic, $18, 40384

	ldx #$5000
	stx $2116

	DMA_CH0 $01, :SRC_StartMap, SRC_StartMap, $18, 2048

	lda #$FF
	ldx #0

-	wai

	inc a
	inc a
	sta $2100

	inx
	cpx #8
	bne -

	WaitForFrames 150

	lda #$0F
	ldx #0

-	wai

	dec a
	dec a
	sta $2100

	inx
	cpx #8
	bne -

	lda #$80				; enter forced blank
	sta $2100

	WaitForFrames 10

	stz $2121				; reset CGRAM address
	DMA_CH0 $02, :SRC_SoundEnginesPal, SRC_SoundEnginesPal, $22, 512

	ldx #$0000
	stx $2116

	DMA_CH0 $01, :GFX_SoundEnginesPic, GFX_SoundEnginesPic, $18, 40384

	ldx #$5000
	stx $2116

	DMA_CH0 $01, :SRC_SoundEnginesMap, SRC_SoundEnginesMap, $18, 2048

	lda #$FF
	ldx #0

-	wai

	inc a
	inc a
	sta $2100

	inx
	cpx #8
	bne -

	WaitForFrames 150

	lda #$0F
	ldx #0

-	wai

	dec a
	dec a
	sta $2100

	inx
	cpx #8
	bne -

	lda #$80				; enter forced blank
	sta $2100

	DisableInterrupts

	A16

	lda #$0010				; fade-out intro song
	sta DP_SPC_VOL_FADESPD

	stz DP_SPC_VOL_CURRENT
	jsl spc_global_volume

	A8

	lda REG_RDNMI				; clear NMI flag

	lda #$81				; reenable interrupts
	sta REG_NMITIMEN

	cli

	WaitForFrames 20

	ldx #$0000
	stx $2116

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0	; clear VRAM

	jml AreaEnter



.ENDASM

; -------------------------- preliminary title screen loop
StartScreenLoop:
	wai



; -------------------------- check for Start
	lda Joy1+1
	and #%00010000
	beq StartScreenLoop



; -------------------------- Start pressed, go to debug menu
	lda #$0F

-	dec a
	sta $2100

	wai
	wai

	cmp #$00
	bne -

	jsr ClearSpriteText

	jml DebugMenu

.ASM



; -------------------------- clear BG1 tilemap
;	lda #$80				; VRAM address increment mode: increment address after accessing the high byte ($2119)
;	sta $2115

;	ldx #ADDR_VRAM_BG1_TILEMAP		; set VRAM address to BG1 tile map
;	stx $2116

;	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, $0800	; 2048 bytes (low & high tilemap byte)



; -------------------------- clear BG1 tilemap buffer
;	ldx #(>TileMapBG1)<<8+(<TileMapBG1)
;	stx $2181
;	stz $2183

;	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024



; -------------------------- black screen BG --> HDMA buffer
;	ldx #(>ARRAY_HDMA_BackgrPlayfield)<<8+(<ARRAY_HDMA_BackgrPlayfield)
;	stx $2181
;	stz $2183

;	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 704



; -------------------------- redraw text box
;	lda DP_TextBoxStatus
;	and #%00000001				; text box already open?
;	beq +

;	jsr __RedrawText			; if so, simply redraw previous text
;	bra ++

;+	jsr OpenTextBox				; otherwise, open text box normally

;++



; -------------------------- change char portrait
;	lda DP_TextBoxCharPortrait
;	and #%00011111
;	cmp #$04
;	bcs +
;	inc a
;	sta DP_TextBoxCharPortrait

;+

;	lda DP_TextBoxCharPortrait
;	and #%00011111
;	cmp #$01
;	beq +
;	dec a
;	sta DP_TextBoxCharPortrait

; +



Forever:
	lda #$81
	sta REG_NMITIMEN			; turn on NMI

-	wai					; wait for next frame
	bra -



.ENDASM

ShowBigSpriteText:
	lda #$38
	sta SpriteBuf1.BigText
	lda #$60
	sta SpriteBuf1.BigText+1
	lda #$0A				; "F"
	sta SpriteBuf1.BigText+2
	lda #$02
	sta SpriteBuf1.BigText+3

	lda #$48
	sta SpriteBuf1.BigText+4
	lda #$60
	sta SpriteBuf1.BigText+5
	lda #$48				; "U"
	sta SpriteBuf1.BigText+6
	lda #$02
	sta SpriteBuf1.BigText+7

	lda #$58
	sta SpriteBuf1.BigText+8
	lda #$60
	sta SpriteBuf1.BigText+9
	lda #$42				; "R"
	sta SpriteBuf1.BigText+10
	lda #$02
	sta SpriteBuf1.BigText+11

	lda #$68
	sta SpriteBuf1.BigText+12
	lda #$60
	sta SpriteBuf1.BigText+13
	lda #$42				; "R"
	sta SpriteBuf1.BigText+14
	lda #$02
	sta SpriteBuf1.BigText+15

	lda #$78
	sta SpriteBuf1.BigText+16
	lda #$60
	sta SpriteBuf1.BigText+17
	lda #$60				; "Y"
	sta SpriteBuf1.BigText+18
	lda #$02
	sta SpriteBuf1.BigText+19

	lda #$98
	sta SpriteBuf1.BigText+20
	lda #$60
	sta SpriteBuf1.BigText+21
	lda #$42				; "R"
	sta SpriteBuf1.BigText+22
	lda #$02
	sta SpriteBuf1.BigText+23

	lda #$A8
	sta SpriteBuf1.BigText+24
	lda #$60
	sta SpriteBuf1.BigText+25
	lda #$2E				; "P"
	sta SpriteBuf1.BigText+26
	lda #$02
	sta SpriteBuf1.BigText+27

	lda #$B8
	sta SpriteBuf1.BigText+28
	lda #$60
	sta SpriteBuf1.BigText+29
	lda #$0C				; "G"
	sta SpriteBuf1.BigText+30
	lda #$02
	sta SpriteBuf1.BigText+31
rts



.ASM



; *********************** Sprite initialization ************************

;.DEFINE sx		0
;.DEFINE sy		1
;.DEFINE sframe		2
;.DEFINE spriority	3



SpriteInit:
	php	

	AXY16

	ldx #$0000

__Init_OAM_lo:
	lda #$F0F0
	sta SpriteBuf1, x			; initialize all sprites to be off the screen

	inx
	inx

	lda #$0000
	sta SpriteBuf1, x

	inx
	inx
	cpx #$0200
	bne __Init_OAM_lo

	A8

	lda #%10101010				; large sprites for everything except the sprite font

	ldx #$0000

__Init_OAM_hi1:
	sta SpriteBuf2, x
	inx
	cpx #$0018				; see .STRUCT oam_high
	bne __Init_OAM_hi1

	lda #%00000000				; small sprites

__Init_OAM_hi2:
	sta SpriteBuf2, x
	inx
	cpx #$0020
	bne __Init_OAM_hi2

	;set the sprite to the highest priority
	;lda #$30
	;lda #%00110000
	;sta SpriteBuf1+spriority

	;lda #$00
	;sta SpriteBuf1+sframe

	plp
rts



; ******************************** EOF *********************************
