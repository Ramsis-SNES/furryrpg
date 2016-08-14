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
	lda	DP_TextBoxCharPortrait					; check for "change character portrait" flag
	bpl	+
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



; -------------------------- update HUD if necessary
	bit	DP_HUD_Status						; check HUD status
	bmi	__ShowHUD
	bvs	__HideHUD
	bra	__UpdateHUDDone

__ShowHUD:
	lda	ARRAY_HDMA_HUDScroll+1
	ldb	ARRAY_HDMA_HUDScroll+7
-	dec	a							; make it appear faster than it disappears (hence multiple decrements)
	dec	a
	dec	a
	bpl	+							; only positive values allowed (except for #$FF)
	lda	#$FF							; underflow, set final scroll value
+	sta	ARRAY_HDMA_HUDScroll+1
	xba
	inc	a
	inc	a
	inc	a
	bmi	+							; only negative values allowed
	lda	#$FF							; overflow, set final scroll value
+	sta	ARRAY_HDMA_HUDScroll+7
	cmp	#$FF							; final scroll value reached?
	bne	__UpdateHUDDone
	lda	#%00000001						; yes, set "HUD is being displayed" bit
	sta	DP_HUD_Status
	stz	DP_HUD_DispCounter					; and reset display counter values
	stz	DP_HUD_DispCounter+1
	bra	__UpdateHUDDone

__HideHUD:
	lda	ARRAY_HDMA_HUDScroll+1
	ldb	ARRAY_HDMA_HUDScroll+7
-	inc	a
	sta	ARRAY_HDMA_HUDScroll+1
	xba
	dec	a
	sta	ARRAY_HDMA_HUDScroll+7
	cmp	#$CF							; final scroll value reached?
	bne	__UpdateHUDDone
	stz	DP_HUD_Status						; yes, clear HUD status bits

__UpdateHUDDone:



; -------------------------- animate playable character
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_SPR_Tiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	lda	DP_Char1SpriteStatus
	and	#%00000111						; isolate direction parameter
	sta	REG_WRMPYA
	lda	#$08							; multiply direction with #$0800 (2048) to get offset for upcoming DMA
	sta	REG_WRMPYB
	nop
	nop
	nop
	nop

	Accu16

	lda	REG_RDMPYL
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
	sta	ARRAY_SpriteBuf1.PlayableChar+2				; tile no. (upper half of body)
	clc
	adc	#$0020
	sta	ARRAY_SpriteBuf1.PlayableChar+6				; tile no. (lower half of body = upper half + 2 rows of 16 tiles)

	lda	DP_Char1PosYX
	sta	ARRAY_SpriteBuf1.PlayableChar
	clc
	adc	#$1000							; Y += 10
	sta	ARRAY_SpriteBuf1.PlayableChar+4

	Accu8

	jsr	RefreshBGs



; -------------------------- refresh sprites
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



__SkipRefreshes3:



; -------------------------- reset registers changed by V-IRQ for text box
	lda	#$01|$08						; set BG Mode 1 for area, BG3 priority
	sta	REG_BGMODE
	lda	DP_AreaProperties					; set tile map size according to area properties
	and	#%00000011						; mask off bits not related to screen size
	ora	#$50							; BG1 tile map VRAM offset: $5000
	sta	REG_BG1SC
	lda	DP_AreaProperties
	and	#%00000011
	ora	#$58							; BG2 tile map VRAM offset: $5800
	sta	REG_BG2SC

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
	sta	REG_BG1HOFS
	lda	ARRAY_HDMA_BGScroll+2
	sta	REG_BG1HOFS
	lda	ARRAY_HDMA_BGScroll+1					; BG2 horizontal scroll
	sta	REG_BG2HOFS
	lda	ARRAY_HDMA_BGScroll+2
	sta	REG_BG2HOFS
	lda	ARRAY_HDMA_BGScroll+3					; BG1 vertical scroll
	sta	REG_BG1VOFS
	lda	ARRAY_HDMA_BGScroll+4
	sta	REG_BG1VOFS
	lda	ARRAY_HDMA_BGScroll+3					; BG2 vertical scroll
	sta	REG_BG2VOFS
	lda	ARRAY_HDMA_BGScroll+4
	sta	REG_BG2VOFS
	lda	#$FF							; fixed BG3 vertical scroll = -1
	sta	REG_BG3VOFS
	stz	REG_BG3VOFS

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
	stz	REG_OAMADDL						; reset OAM address
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



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
	stz	REG_OAMADDL						; set OAM address to 0
	stz	REG_OAMADDH

	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



; -------------------------- Mode7
	Accu16

	lda	DP_Mode7_ScrollOffsetX
	lsr	a							; shift right for 13-bit value
	lsr	a
	lsr	a

	Accu8

	sta	REG_BG1HOFS						; BG1HOFS/M7HOFS
	xba
	sta	REG_BG1HOFS

	Accu16

	lda	DP_Mode7_ScrollOffsetY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	REG_BG1VOFS						; BG1VOFS/M7VOFS
	xba
	sta	REG_BG1VOFS

	Accu16

	lda	DP_Mode7_CenterCoordX
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	REG_M7X							; Mode 7 center position X register (low)
	xba
	sta	REG_M7X							; Mode 7 center position X register (high)

	Accu16

	lda	DP_Mode7_CenterCoordY
	lsr	a
	lsr	a
	lsr	a

	Accu8

	sta	REG_M7Y							; Mode 7 center position Y register (low)
	xba
	sta	REG_M7Y							; Mode 7 center position Y register (high)

; calculate table index based on altitude
	lda	#$C0							; $1C0 = 224*2 scanlines
	sta	REG_M7A
	lda	#$01
	sta	REG_M7A
	lda	DP_Mode7_Altitude
	sta	REG_M7B

	Accu16

	lda	REG_MPYL
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



Vblank_WorldMap:
	AccuIndex16

	pha								; push 16 bit registers onto stack
	phx
	phy

	Accu8

	jsr	UpdateGameTime



; -------------------------- refresh sprites
;	stz	REG_OAMADDL						; reset OAM address
;	stz	REG_OAMADDH

;	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



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

	DMA_CH0 $00, $7E, ARRAY_BG3TileMap, $18, 1024



; -------------------------- refresh BG3 (high tilemap bytes)
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMapHi, $19, 1024



; -------------------------- misc. tasks
	jsr	GetInput

	stz	REG_BG3HOFS						; reset BG3 horizontal scroll
	stz	REG_BG3HOFS
	lda	#$FF							; set BG3 vertical scroll = -1
	sta	REG_BG3VOFS
	stz	REG_BG3VOFS

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
;	stz	REG_OAMADDL						; reset OAM address
;	stz	REG_OAMADDH

;	DMA_CH0 $00, $7E, ARRAY_SpriteBuf1, $04, 544



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
	stz	REG_BG12NBA						; reset BG1/2 character data area designation to $0000
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
	sta	REG_BG1SC
	lda	#$7C							; BG2 tile map VRAM offset: $7C00, Tile Map size: 32×32 tiles
	sta	REG_BG2SC

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

RefreshBGs:								; refresh BGs according to DP_DMAUpdates
	ldy	#4							; DMA counter, do max. 4 DMAs per Vblank
	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118



; -------------------------- check/refresh BG1 (low tilemap bytes)
	lda	DP_DMAUpdates
	and	#%00000001						; check for 1st BG1 tile map (low bytes)
	beq	+

	ldx	#ADDR_VRAM_BG1_Tilemap1					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap1, $18, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	DP_DMAUpdates
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%00000010						; check for 2nd BG1 tile map (low bytes)
	beq	+

	ldx	#ADDR_VRAM_BG1_Tilemap2					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap2, $18, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	DP_DMAUpdates
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone



; -------------------------- check/refresh BG2 (low tilemap bytes)
+	lda	DP_DMAUpdates
	and	#%00000100						; check for 1st BG2 tile map (low bytes)
	beq	+

	ldx	#ADDR_VRAM_BG2_Tilemap1					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap1, $18, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	DP_DMAUpdates
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates
	and	#%00001000						; check for 2nd BG2 tile map (low bytes)
	beq	+

	ldx	#ADDR_VRAM_BG2_Tilemap2					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap2, $18, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	DP_DMAUpdates
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone



; -------------------------- check/refresh BG3 (low tilemap bytes)
+	lda	DP_DMAUpdates
	and	#%00010000						; check for BG3 tile map (low bytes)
	beq	+

	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMap, $18, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	DP_DMAUpdates
	dey
	bne	+

	jmp	__DMAUpdatesDone

+	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN



; -------------------------- check/refresh BG1 (high tilemap bytes)
	lda	DP_DMAUpdates+1
	and	#%00000001						; check for 1st BG1 tile map (high bytes)
	beq	+

	ldx	#ADDR_VRAM_BG1_Tilemap1					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap1Hi, $19, 1024

	lda	#%00000001						; clear respective DMA update bit
	trb	DP_DMAUpdates+1
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates+1
	and	#%00000010						; check for 2nd BG1 tile map (high bytes)
	beq	+

	ldx	#ADDR_VRAM_BG1_Tilemap2					; set VRAM address to BG1 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG1TileMap2Hi, $19, 1024

	lda	#%00000010						; clear respective DMA update bit
	trb	DP_DMAUpdates+1
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone



; -------------------------- check/refresh BG2 (high tilemap bytes)
+	lda	DP_DMAUpdates+1
	and	#%00000100						; check for 1st BG2 tile map (high bytes)
	beq	+

	ldx	#ADDR_VRAM_BG2_Tilemap1					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap1Hi, $19, 1024

	lda	#%00000100						; clear respective DMA update bit
	trb	DP_DMAUpdates+1
	dey								; decrement DMA counter
	bne	+

	jmp	__DMAUpdatesDone

+	lda	DP_DMAUpdates+1
	and	#%00001000						; check for 2nd BG2 tile map (high bytes)
	beq	+

	ldx	#ADDR_VRAM_BG2_Tilemap2					; set VRAM address to BG2 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG2TileMap2Hi, $19, 1024

	lda	#%00001000						; clear respective DMA update bit
	trb	DP_DMAUpdates+1
	dey								; decrement DMA counter
	beq	__DMAUpdatesDone



; -------------------------- check/refresh BG3 (high tilemap bytes)
+	lda	DP_DMAUpdates+1
	and	#%00010000						; check for BG3 tile map (high bytes)
	beq	__DMAUpdatesDone

	ldx	#ADDR_VRAM_BG3_Tilemap1					; set VRAM address to BG3 tile map
	stx	REG_VMADDL

	DMA_CH0 $00, $7E, ARRAY_BG3TileMapHi, $19, 1024

	lda	#%00010000						; clear respective DMA update bit
	trb	DP_DMAUpdates+1

__DMAUpdatesDone:
	rts



UpdateCharPortrait:
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_Portrait					; set VRAM address to char portrait
	stx	REG_VMADDL
	lda	#ADDR_CGRAM_PORTRAIT					; set CGRAM address for character portrait
	sta	REG_CGADD

	lda	DP_TextBoxCharPortrait
	and	#$7F							; check for portrait no., 0 = no portrait
	bne	+

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $22, 32		; no portrait wanted, so just zero out palette // FIXME, add masking tiles

	bra	__CharPortraitUpdated

+	Accu16								; portrait no. in A

	and	#$00FF							; remove garbage in high byte
	asl	a
	tax								; make portrait no. = index in GFX offset table
	lda.l	SRC_CharPortaitGFXTable, x
	sta	$4302							; data offset
	ldy	#$1801							; low byte: DMA mode, high byte: B bus register ($2118/VMDATA)
 	sty	$4300

	Accu8

	lda	#:GFX_Portrait_Char1					; data bank (all portraits need to be in the same bank)
	sta	$4304
	ldy	#1920							; data length
	sty	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

	Accu16

	lda.l	SRC_CharPortaitPaletteTable, x				; index is still in X, use that for correct palette
	sta	$4302							; data offset
	ldx	#$2202							; low byte: DMA mode, high byte: B bus register ($2122/CGDATA)
 	stx	$4300

	Accu8

	lda	#:SRC_Palette_Portrait_Char1				; data bank (all portrait palettes need to be in the same bank)
	sta	$4304
	ldx	#32							; data length (16 colors)
	stx	$4305
	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta	REG_MDMAEN

__CharPortraitUpdated:
	lda	#%10000000						; portrait updated, clear request flag
	trb	DP_TextBoxCharPortrait
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
	ldx	#(ARRAY_BG3TileMap & $FFFF)
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
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- font palette --> CGRAM
	stz	REG_CGADD						; reset CGRAM address
	stz	REG_CGDATA						; set mainscreen bg color: blue
	lda	#$70
	sta	REG_CGDATA

	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	REG_CGDATA
	inx
	cpx	#8
	bne	-



; -------------------------- register updates
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE

	lda	#$48							; BG3 tile map VRAM offset: $4800, Tile Map size: 32×32 tiles
	sta	REG_BG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#%00000100						; turn on BG3 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	PrintString	3, 2, "An error occurred!"
	PrintString	5, 2, "Error type: BRK"
	PrintString	6, 2, "Error address: $"

	lda	10, s
	sta	temp

	PrintHexNum	temp

	lda	9, s
	sta	temp

	PrintHexNum	temp

	lda	8, s
	sta	temp

	PrintHexNum	temp
	PrintString	7, 2, "Status register: $"

	lda	7, s
	sta	temp

	PrintHexNum	temp
	PrintString	9, 2, "Accuml.: $"

	lda	6, s
	sta	temp

	PrintHexNum	temp

	lda	5, s
	sta	temp

	PrintHexNum	temp
	PrintString	10, 2, "X index: $"

	lda	4, s
	sta	temp

	PrintHexNum	temp

	lda	3, s
	sta	temp

	PrintHexNum	temp
	PrintString	11, 2, "Y index: $"

	lda	2, s
	sta	temp

	PrintHexNum	temp

	lda	1, s
	sta	temp

	PrintHexNum	temp

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
	ldx	#(ARRAY_BG3TileMap & $FFFF)
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
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 HUD
	inx
	cpx	#1024
	bne	-



; -------------------------- font palette --> CGRAM
	stz	REG_CGADD						; reset CGRAM address
	lda	#$1C							; set mainscreen bg color: red
	sta	REG_CGDATA
	stz	REG_CGDATA

	ldx	#2							; skip original bg color
-	lda.l	SRC_Palettes_Text, x					; copy remaining 3 colors
	sta	REG_CGDATA
	inx
	cpx	#8
	bne	-



; -------------------------- register updates
	lda	#$01							; set BG mode 1
	sta	REG_BGMODE

	lda	#$48							; BG3 tile map VRAM offset: $4800, Tile Map size: 32×32 tiles
	sta	REG_BG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#%00000100						; turn on BG3 only
	sta	REG_TM							; on the mainscreen
	sta	REG_TS							; and on the subscreen

	PrintString	3, 2, "An error occurred!"
	PrintString	5, 2, "Error type: COP"
	PrintString	6, 2, "Error address: $"

	lda	10, s
	sta	temp

	PrintHexNum	temp

	lda	9, s
	sta	temp

	PrintHexNum	temp

	lda	8, s
	sta	temp

	PrintHexNum	temp
	PrintString	7, 2, "Status register: $"

	lda	7, s
	sta	temp

	PrintHexNum	temp
	PrintString	9, 2, "Accuml.: $"

	lda	6, s
	sta	temp

	PrintHexNum	temp

	lda	5, s
	sta	temp

	PrintHexNum	temp
	PrintString	10, 2, "X index: $"

	lda	4, s
	sta	temp

	PrintHexNum	temp

	lda	3, s
	sta	temp

	PrintHexNum	temp
	PrintString	11, 2, "Y index: $"

	lda	2, s
	sta	temp

	PrintHexNum	temp

	lda	1, s
	sta	temp

	PrintHexNum	temp

	SetNMI	TBL_NMI_Error

	lda.l	REG_RDNMI						; clear NMI flag
	lda	#$0F							; turn on screen
	sta	REG_INIDISP

	jmp Forever							; go to trap loop instead of RTI



; ******************************** EOF *********************************
