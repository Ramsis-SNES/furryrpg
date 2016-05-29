;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** IRQ & NMI HANDLERS ***
;
;==========================================================================================



; ************************ Vblank/NMI routines *************************

Vblank_Area:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- update text box
	lda	DP_TextBoxCharPortrait					; check for "don't change character portrait" flag
	bmi	+

	jsr	UpdateCharPortrait
	jmp	__SkipRefreshes3					; changing the portrait involves 2 DMAs, so skip other stuff for now

+	lda	DP_TextBoxStatus					; check text box status
	bpl	+

	jsr	ClearTextBox						; bit 7 set --> wipe text
	jmp	__SkipRefreshes3					; ... and skip BG refreshes (to avoid glitches due to premature end of Vblank)

+	bit	#%00000001						; VWF buffer full?
	beq	__TextBoxVblankDone

	jsr	VWFTileBufferFull

__TextBoxVblankDone:



; -------------------------- animate playable character
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_SPR_Tiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	lda	DP_Char1SpriteStatus
	and	#%00000111						; isolate direction parameter
	sta	$4202
	lda	#$08							; multiply direction with #$0800 (2048) to get offset for upcoming DMA
	sta	$4203
	nop
	nop
	nop
	nop

	Accu16

	lda	$4216
	xba
	clc
	adc	#(GFX_Spritesheet_Char1 & $FFFF)
	sta	$4302							; data offset

	Accu8

	lda	#$01							; DMA mode
 	sta	$4300
	lda	#$18							; B bus register ($2118)
	sta	$4301
	lda	#:GFX_Spritesheet_Char1					; data bank
	sta	$4304
	ldx	#2048							; data length
	stx	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	lda	DP_Char1SpriteStatus
	bpl	__Char1IsWalking					; bit 7 set = idle

	stz	DP_Char1FrameCounter					; char is idle, reset frame counter
	lda	#TBL_Char1_frame00

	bra	__Char1WalkingDone

__Char1IsWalking:
	lda	DP_Char1FrameCounter					; 0-9: frame 1, 10-19: frame 0, 20-29: frame 2, 30-39: frame 0
	cmp	#40
	bcc	+
	stz	DP_Char1FrameCounter					; reset frame counter
	bra	__Char1Frame1

+	cmp	#30
	bcs	__Char1Frame0

	cmp	#20
	bcs	__Char1Frame2

	cmp	#10
	bcc	__Char1Frame1

__Char1Frame0:
	lda	#TBL_Char1_frame00
	bra	+

__Char1Frame2:
	lda	#TBL_Char1_frame02
	bra	+

__Char1Frame1:
	lda	#TBL_Char1_frame01
;	bra	+

+	inc	DP_Char1FrameCounter					; increment animation frame counter

__Char1WalkingDone:
	asl	a							; frame no. × 2 for correct tile no. in spritesheet

	Accu16

	and	#$00FF							; remove garbage bits
	ora	#$2000							; add sprite priority
	sta	SpriteBuf1.PlayableChar+2				; tile no. (upper half of body)
	clc
	adc	#$0020
	sta	SpriteBuf1.PlayableChar+6				; tile no. (lower half of body = upper half + 2 rows of 16 tiles)

	lda	DP_Char1PosYX
	sta	SpriteBuf1.PlayableChar
	clc
	adc	#$1000							; Y += 10
	sta	SpriteBuf1.PlayableChar+4

	Accu8

	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	$2102							; reset OAM address
	stz	$2103

	DMA_CH0 $00, $7E, SpriteBuf1, $04, 544



__SkipRefreshes3:



; -------------------------- reset registers changed by V-IRQ for text box
	lda	#$01|$08						; set BG Mode 1 for area, BG3 priority
	sta	REG_BGMODE
	lda	#$50|$01						; BG1 tile map VRAM offset: $5000, Tile Map size: 64×32 tiles
	sta	$2107
	lda	#$58|$01						; BG2 tile map VRAM offset: $5800, Tile Map size: 64×32 tiles
	sta	$2108

	Accu16

	lda	DP_Shadow_TSTM						; copy mainscreen & subscreen shadow registers
	sta	REG_TM

	Accu8

	lda	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
;	stz	REG_SETINI



; -------------------------- misc. tasks
	jsr	GetInput

	lda	ARRAY_HDMA_BGScroll+1					; BG1 horizontal scroll
	sta	$210D
	lda	ARRAY_HDMA_BGScroll+2
	sta	$210D
	lda	ARRAY_HDMA_BGScroll+1					; BG2 horizontal scroll
	sta	$210F
	lda	ARRAY_HDMA_BGScroll+2
	sta	$210F
	lda	ARRAY_HDMA_BGScroll+3					; BG1 vertical scroll
	sta	$210E
	lda	ARRAY_HDMA_BGScroll+4
	sta	$210E
	lda	ARRAY_HDMA_BGScroll+3					; BG2 vertical scroll
	sta	$2110
	lda	ARRAY_HDMA_BGScroll+4
	sta	$2110
	lda	#$FF							; fixed BG3 vertical scroll = -1
	sta	$2112
	stz	$2112

	lda	DP_HDMAchannels						; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN

	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_DebugMenu:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime
	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	$2102							; reset OAM address
	stz	$2103

	DMA_CH0 $00, $7E, SpriteBuf1, $04, 544



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMAchannels						; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN

	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Mode7:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
	stz	$2102							; set OAM address to 0
	stz	$2103

	DMA_CH0 $00, $7E, SpriteBuf1, $04, 544



; -------------------------- Mode7
	Accu16

	lda	DP_Mode7_ScrollOffsetX
	lsr	a							; shift right for 13-bit value
	lsr	a
	lsr	a

	Accu8

	sta	$210D							; BG1HOFS/M7HOFS
	xba
	sta	$210D

	Accu16

	lda	DP_Mode7_ScrollOffsetY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	$210E							; BG1VOFS/M7VOFS
	xba
	sta	$210E

	Accu16

	lda	DP_Mode7_CenterCoordX
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	$211F							; Mode 7 center position X register (low)
	xba
	sta	$211F							; Mode 7 center position X register (high)

	Accu16

	lda	DP_Mode7_CenterCoordY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	$2120							; Mode 7 center position Y register (low)
	xba
	sta	$2120							; Mode 7 center position Y register (high)

; calculate table index based on altitude
	lda	#$C0							; $1C0 = 224*2 scanlines
	sta	$211B
	lda	#$01
	sta	$211B
	lda	DP_Mode7_Altitude
	sta	$211C

	Accu16

	lda	$2134
	sta	DP_Mode7_AltTabOffset
	lda	#(SRC_Mode7Scaling & $FFFF)
	clc
	adc	DP_Mode7_AltTabOffset
	sta	DP_Mode7_AltTabOffset

	Accu8



; -------------------------- reset registers changed by V-IRQ for Mode 7
	lda	#$01|$08						; set BG Mode 1 for sky, BG3 priority
	sta	REG_BGMODE

;	lda	#%00010110						; turn on BG2, BG3, and sprites
	lda	#%00010000
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMAchannels						; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN

	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Playfield:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
;	stz	$2102							; reset OAM address
;	stz	$2103

;	DMA_CH0 $00, $7E, SpriteBuf1, $04, 544



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMAchannels						; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN

	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Error:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8



; -------------------------- refresh BG3 (low tilemap bytes)
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118
	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG3, $18, 1024



; -------------------------- refresh BG3 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG3Hi, $19, 1024



; -------------------------- misc. tasks
	jsr	GetInput

	stz	$2111							; reset BG3 horizontal scroll
	stz	$2111
	lda	#$FF							; set BG3 vertical scroll = -1
	sta	$2112
	stz	$2112

	stz	REG_HDMAEN						; disable HDMA
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



Vblank_Intro:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8



; -------------------------- refresh sprites
;	stz	$2102							; reset OAM address
;	stz	$2103

;	DMA_CH0 $00, $7E, SpriteBuf1, $04, 544



; -------------------------- misc. tasks
	jsr	GetInput

	lda	DP_HDMAchannels						; initiate HDMA transfers
	and	#%11111110						; make sure channel 0 isn't accidentally used (reserved for normal DMA)
	sta	REG_HDMAEN
	lda	REG_RDNMI						; acknowledge NMI

	AccuIndex16

	ply								; pull original 16 bit registers back
	plx
	pla
	rti



; *************************** H-IRQ routines ***************************

.ACCU 8
.INDEX 16

HIRQ_MainMenu:
	php								; preserve processor status

	Accu16

	pha								; preserve 16 bit accumulator

	Accu8

	lda	#$01|$08						; switch to BG Mode 1 (BG3 priority)
	sta	REG_BGMODE

	lda	REG_TIMEUP						; acknowledge IRQ

	Accu16

	pla								; pull 16 bit accumulator
	plp								; pull processor status
	rti



; *************************** V-IRQ routines ***************************

VIRQ_Area:
	php								; preserve processor status

	Accu16

	pha								; preserve 16 bit accumulator

	Accu8

;-	bit	REG_HVBJOY						; wait for Hblank period flag to get set
;	bvc	-

	lda	#$05							; switch to BG Mode 5 for text box
	sta	REG_BGMODE
	lda	#$78							; BG1 tile map VRAM offset: $7800, Tile Map size: 32×32 tiles
	sta	$2107
	lda	#$7C							; BG2 tile map VRAM offset: $7C00, Tile Map size: 32×32 tiles
	sta	$2108

	Accu16

	lda	VAR_TextBox_TSTM					; write Sub/Mainscreen designation regs
	sta	REG_TM

	Accu8

	lda	REG_TIMEUP						; acknowledge IRQ

	Accu16

	pla								; restore 16 bit accumulator
	plp								; restore processor status
	rti



VIRQ_Mode7:
	php								; preserve processor status

	Accu16

	pha								; preserve 16 bit accumulator

	Accu8

;-	bit	REG_HVBJOY						; wait for Hblank period flag to get set
;	bvc	-

	lda	#$07							; switch to BG Mode 7
	sta	REG_BGMODE
	lda	#%00010001						; turn on BG1 and sprites only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	lda	REG_TIMEUP						; acknowledge IRQ

	Accu16

	pla								; restore 16 bit accumulator
	plp								; restore processor status
	rti



; ************************* Common subroutines *************************

.ACCU 8
.INDEX 16

RefreshBGs:

; -------------------------- refresh BGs according to DP_DMAUpdates
	ldy	#2							; only do 2 DMAs per Vblank

	lda	DP_DMAUpdates
	and	#%00000001
	beq	+



; -------------------------- refresh BG1 (low tilemap bytes)
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118
	ldx	#ADDR_VRAM_BG1_Tilemap1					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG1, $18, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	DP_DMAUpdates

	dey
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%00000010
	beq	+



; -------------------------- refresh BG2 (low tilemap bytes)
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118
	ldx	#ADDR_VRAM_BG2_Tilemap1					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG2, $18, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	DP_DMAUpdates

	dey
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%00000100
	beq	+



; -------------------------- refresh BG3 (low tilemap bytes)
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118
	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG3, $18, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	DP_DMAUpdates

	dey
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%00010000
	beq	+



; -------------------------- refresh BG1 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG1_Tilemap1					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG1Hi, $19, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	DP_DMAUpdates

	dey
	beq	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%00100000
	beq	+



; -------------------------- refresh BG2 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG2_Tilemap1					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG2Hi, $19, 1024

	lda	#%00100000						; clear respective DMA update bit
	trb	DP_DMAUpdates

	dey
	beq	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%01000000
	beq	+



; -------------------------- refresh BG3 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, TileMapBG3Hi, $19, 1024

	lda	#%01000000						; clear respective DMA update bit
	trb	DP_DMAUpdates

	dey
	beq	__DMAUpdatesDone

+

__DMAUpdatesDone:
	rts



UpdateCharPortrait:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_Portrait					; set VRAM address to char portrait
	stx	REG_VMADDL

	lda	DP_TextBoxCharPortrait
	and	#%00011111						; check for portrait no., 0 = no portrait
	bne	+

	lda	#ADDR_CGRAM_PORTRAIT					; set CGRAM address for character portrait, zero out palette
	sta	$2121

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $22, 32

	jmp	__CharPortraitUpdated

+	cmp	#1
	bne	+

	DMA_CH0 $01, :GFX_Portrait_Char1, GFX_Portrait_Char1, $18, 1920

	lda	#ADDR_CGRAM_PORTRAIT					; set CGRAM address for character portrait
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Portrait_Char1, SRC_Palette_Portrait_Char1, $22, 32

	jmp	__CharPortraitUpdated

+	cmp	#2
	bne	+

	DMA_CH0 $01, :GFX_Portrait_Char2, GFX_Portrait_Char2, $18, 1920

	lda	#ADDR_CGRAM_PORTRAIT					; set CGRAM address for character portrait
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Portrait_Char2, SRC_Palette_Portrait_Char2, $22, 32

	jmp	__CharPortraitUpdated

+	cmp	#3
	bne	+

	DMA_CH0 $01, :GFX_Portrait_Char3, GFX_Portrait_Char3, $18, 1920

	lda	#ADDR_CGRAM_PORTRAIT					; set CGRAM address for character portrait
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Portrait_Char3, SRC_Palette_Portrait_Char3, $22, 32

	bra	__CharPortraitUpdated

+	cmp	#4
	bne	+

	DMA_CH0 $01, :GFX_Portrait_Char4, GFX_Portrait_Char4, $18, 1920

	lda	#ADDR_CGRAM_PORTRAIT					; set CGRAM address for character portrait
	sta	$2121

	DMA_CH0 $02, :SRC_Palette_Portrait_Char4, SRC_Palette_Portrait_Char4, $22, 32

;	bra	__CharPortraitUpdated

+;	cmp	#5
;	bne	+
	; load char portrait #5
;	bra	__CharPortraitUpdated

__CharPortraitUpdated:
	lda	#%10000000						; portrait updated, remember that for next Vblank
	tsb	DP_TextBoxCharPortrait

__CharPortraitDone:
	rts



UpdateGameTime:
	sed								; decimal mode on

	clc
	lda	DP_GameTime_Seconds
	adc	#$01
	sta	DP_GameTime_Seconds
	cmp	#$60							; check if 60 frames = game time seconds have elapsed
	bcc	__GameTimeUpdateMinutes

	stz	DP_GameTime_Seconds					; carry bit set, reset seconds

__GameTimeUpdateMinutes:
	lda	DP_GameTime_Minutes					; increment minutes via carry bit
	adc	#$00
	sta	DP_GameTime_Minutes
	cmp	#$60							; check if 60 seconds have elapsed
	bcc	__GameTimeUpdateHours

	stz	DP_GameTime_Minutes					; carry bit set, reset minutes

__GameTimeUpdateHours:
	lda	DP_GameTime_Hours					; increment hours via carry bit
	adc	#$00
	sta	DP_GameTime_Hours
	cmp	#$24							; check if 24 hours have elapsed
	bcc	__GameTimeUpdateDone

	stz	DP_GameTime_Hours					; carry bit set, reset hours

__GameTimeUpdateDone:
	cld								; decimal mode off
	rts



; ************************** Software Errors ***************************

ErrorHandlerBRK:
	AccuIndex16

	pha
	phx
	phy

	Accu8

	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

	jsl	sound_stop_all

	Accu16

	SetDPag	$0000

	Accu8

	stz	REG_HDMAEN						; disable HDMA



; -------------------------- clear BG3 tilemap buffer
	ldx	#(TileMapBG3 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048



; -------------------------- HUD font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	TileMapBG3Hi, x						; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- font palette --> CGRAM
	stz	$2121							; reset CGRAM address

	stz	$2122							; set mainscreen bg color: blue
	lda	#$70
	sta	$2122

	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	$2122
	inx
	cpx	#8
	bne	-



; -------------------------- register updates
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE

	lda	#$48							; BG3 tile map VRAM offset: $4800, Tile Map size: 32×32 tiles
	sta	$2109
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	$210C
	lda	#%00000100						; turn on BG3 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	PrintString 3, 2, "An error occurred!"
	PrintString 5, 2, "Error type: BRK"
	PrintString 6, 2, "Error address: $"

	lda	10, s
	sta	temp
	PrintHexNum temp

	lda	9, s
	sta	temp
	PrintHexNum temp

	lda	8, s
	sta	temp
	PrintHexNum temp

	PrintString 7, 2, "Status register: $"

	lda	7, s
	sta	temp
	PrintHexNum temp

	PrintString 9, 2, "Accuml.: $"

	lda	6, s
	sta	temp
	PrintHexNum temp

	lda	5, s
	sta	temp
	PrintHexNum temp

	PrintString 10, 2, "X index: $"

	lda	4, s
	sta	temp
	PrintHexNum temp

	lda	3, s
	sta	temp
	PrintHexNum temp

	PrintString 11, 2, "Y index: $"

	lda	2, s
	sta	temp
	PrintHexNum temp

	lda	1, s
	sta	temp
	PrintHexNum temp

	SetNMI	TBL_NMI_Error

	lda.l	REG_RDNMI						; clear NMI flag
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	jmp Forever							; go to trap loop instead of RTI



ErrorHandlerCOP:
	AccuIndex16

	pha
	phx
	phy

	Accu8

	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

	jsl	sound_stop_all

	Accu16

	SetDPag	$0000

	Accu8

	stz	REG_HDMAEN						; disable HDMA



; -------------------------- clear BG3 tilemap buffer
	ldx	#(TileMapBG3 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048



; -------------------------- HUD font --> VRAM
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_FontHUD, GFX_FontHUD, $18, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	TileMapBG3Hi, x						; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- font palette --> CGRAM
	stz	$2121							; reset CGRAM address
	lda	#$1C							; set mainscreen bg color: red
	sta	$2122
	stz	$2122

	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	$2122
	inx
	cpx	#8
	bne	-



; -------------------------- register updates
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE

	lda	#$48							; BG3 tile map VRAM offset: $4800, Tile Map size: 32×32 tiles
	sta	$2109
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	$210C
	lda	#%00000100						; turn on BG3 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	PrintString 3, 2, "An error occurred!"
	PrintString 5, 2, "Error type: COP"
	PrintString 6, 2, "Error address: $"

	lda	10, s
	sta	temp
	PrintHexNum temp

	lda	9, s
	sta	temp
	PrintHexNum temp

	lda	8, s
	sta	temp
	PrintHexNum temp

	PrintString 7, 2, "Status register: $"

	lda	7, s
	sta	temp
	PrintHexNum temp

	PrintString 9, 2, "Accuml.: $"

	lda	6, s
	sta	temp
	PrintHexNum temp

	lda	5, s
	sta	temp
	PrintHexNum temp

	PrintString 10, 2, "X index: $"

	lda	4, s
	sta	temp
	PrintHexNum temp

	lda	3, s
	sta	temp
	PrintHexNum temp

	PrintString 11, 2, "Y index: $"

	lda	2, s
	sta	temp
	PrintHexNum temp

	lda	1, s
	sta	temp
	PrintHexNum temp

	SetNMI	TBL_NMI_Error

	lda.l	REG_RDNMI						; clear NMI flag
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	jmp Forever							; go to trap loop instead of RTI



; ******************************** EOF *********************************
