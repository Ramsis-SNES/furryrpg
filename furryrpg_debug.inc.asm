;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** DEBUG MENU ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

DebugMenu:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	Accu16

	stz	ARRAY_HDMA_BGScroll+1					; reset BG scroll values
	lda	#$00FF
	sta	ARRAY_HDMA_BGScroll+3

	Accu8

	stz	DP_HDMAchannels						; disable HDMA



; -------------------------- clear tilemap buffers
	ldx	#(TileMapBG1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	ldx	#(TileMapBG2 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	ldx	#(TileMapBG3 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	lda	#%01110111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates

	WaitFrames	5						; wait for regs/tilemaps to get cleared

	DisableIRQs
	SetNMI	TBL_NMI_DebugMenu



; -------------------------- load new NMI handler & GFX data
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

	ldx	#ADDR_VRAM_SPR_Tiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_Smallfont, GFX_Sprites_Smallfont, $18, 4096

	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, $22, 32

	Accu16

	lda	#%0001011100010111					; turn on BG1/2/3 and sprites on mainscreen and subscreen
	sta	REG_TM
	sta	DP_Shadow_TSTM						; copy to shadow variable

	Accu8

	lda	#$02
	ldx	#0
-	sta	SpriteBuf1.PlayableChar, x				; overwrite char sprite buffer area with some unused sprite font tiles
	inx
	inx
	cpx	#24
	bne	-

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; re-enable Vblank NMI + Auto Joypad Read
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli



; -------------------------- update registers in case they've been messed with
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	REG_BG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	REG_BG34NBA
	lda	#$01							; set BG Mode 1
	sta	REG_BGMODE

	stz	REG_CGADD						; reset CGRAM address
	stz	REG_CGDATA						; $1C00 = dark blue as background color
	lda	#$1C
	sta	REG_CGDATA



; -------------------------- reset song pointer
	Accu16

	stz	DP_NextTrack

	Accu8



; -------------------------- done, draw debug menu
;	PrintString	2, 3, "FURRY RPG! (Build #00220)"
;	PrintString	3, 3, "(c) by www.ManuLoewe.de"

	PrintString	7, 3, "DEBUG MENU:"
	PrintString	10, 3, "Alpha intro"
	PrintString	11, 3, "Area/dialog test"
	PrintString	12, 3, "Error test (BRK)"
	PrintString	13, 3, "Error test (COP)"
	PrintString	14, 3, "Mode1 world map"
	PrintString	15, 3, "Mode7 world map"
	PrintString	16, 3, "Move sprite on circular path"
	PrintString	17, 3, "Show sprite gallery"
	PrintString	18, 3, "SNESGSS music test:"
;	PrintString	16, 3, ""
;	PrintString	17, 3, ""

	stz	SprTextMon						; reset sprite text filling level so it won't draw more than 1 cursor ;-)

	PrintSpriteText	10, 2, $10, 0					; put cursor on first line ($10 = cursor tile no.)

	wai

	lda	#$0F							; turn on the screen
	sta	REG_INIDISP



DebugMenuLoop:
	wai

-	lda	REG_HVBJOY						; are we still on Vblank?
	bmi	-							; yes, wait

	Accu16

	lda	DP_NextTrack
	asl	a
	tax
	lda.l	SRC_TrackPointerTable, x				; load track name pointer
	sta	DP_SubStrAddr

	Accu8

	lda	#:SRC_TrackPointerTable
	sta	DP_SubStrAddr+2

	PrintString	19, 4, "%s"					; print current SNESGSS song title

	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates



; -------------------------- check for dpad up
	lda	Joy1New+1
	and	#%00001000
	beq	++

	lda	SpriteBuf1.Text+1					; Y coord of cursor
	cmp	#78
	beq	+
	sec
	sbc	#8
	sta	SpriteBuf1.Text+1

	bra	++

+	lda	#142
	sta	SpriteBuf1.Text+1

++



; -------------------------- check for dpad down
	lda	Joy1New+1
	and	#%00000100
	beq	++

	lda	SpriteBuf1.Text+1
	cmp	#142
	beq	+
	clc
	adc	#8
	sta	SpriteBuf1.Text+1

	bra	++

+	lda	#78
	sta	SpriteBuf1.Text+1

++



; -------------------------- check for dpad left
	lda	Joy1New+1
	and	#%00000010
	beq	++

	lda	SpriteBuf1.Text+1					; only do anything if cursor is on music test
	cmp	#142
	bne	++

	lda	DP_NextTrack						; go to previous track
	dec	a
	bpl	+
	lda	#0
+	sta	DP_NextTrack

++



; -------------------------- check for dpad left
	lda	Joy1New+1
	and	#%00000001
	beq	++

	lda	SpriteBuf1.Text+1					; only do anything if cursor is on music test
	cmp	#134
	bne	++

	lda	DP_NextTrack						; go to next track
	inc	a
	cmp	#(SRC_TrackPointerTable_END-SRC_TrackPointerTable)/2
	bcc	+
	lda	#(SRC_TrackPointerTable_END-SRC_TrackPointerTable)/2-1
+	sta	DP_NextTrack

++



; -------------------------- check for A button
	lda	Joy1New
	and	#%10000000
	beq	++

	lda	SpriteBuf1.Text+1
	cmp	#78
	bne	+

	jmp	AlphaIntro

+	cmp	#86
	bne	+

	ldx	#(TileMapBG3 & $FFFF)					; clear text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	jmp	AreaEnter

+	cmp	#94
	bne	+

	brk	$FF

+	cmp	#102
	bne	+

	cop	$FF

+	cmp	#110
	bne	+

	jmp	LoadWorldMap

+	cmp	#118
	bne	+

	jmp	TestMode7

+	cmp	#126
	bne	+

	jmp	MoveSpriteCircularTest

+	cmp	#134
	bne	+

	jmp	ShowSpriteGallery

+	jsl	PlayTrack						; else, cursor must be on music test

++



; -------------------------- check for Start
;	lda	Joy1Press+1
;	and	#%00010000
;	beq	+

;	DoSomething

;+

	jsr	ShowCPUload
	jmp	DebugMenuLoop



ShowSpriteGallery:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

	ldx	#(TileMapBG3 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048		; clear BG3 tile map

	jsr	SpriteInit						; purge OAM
	ldx	#ADDR_VRAM_SPR_Tiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_Gallery, GFX_Sprites_Gallery, $18, 2048

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palettes_Sprites_Gallery, SRC_Palettes_Sprites_Gallery, $22, 160

	Accu16



; -------------------------- fennec puppet
	lda	#$2020							; x (low), y (high)
	sta	SpriteBuf1.NPCs
	lda	#$0000							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+2
	lda	#$2030							; x (low), y (high)
	sta	SpriteBuf1.NPCs+4
	lda	#$0002							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+6
	lda	#$3020							; x (low), y (high)
	sta	SpriteBuf1.NPCs+8
	lda	#$0020							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+10
	lda	#$3030							; x (low), y (high)
	sta	SpriteBuf1.NPCs+12
	lda	#$0022							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+14



; -------------------------- fox
	lda	#$2050							; x (low), y (high)
	sta	SpriteBuf1.NPCs+16
	lda	#$0204							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+18
	lda	#$3050							; x (low), y (high)
	sta	SpriteBuf1.NPCs+20
	lda	#$0224							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+22



; -------------------------- wolf 1
	lda	#$2070							; x (low), y (high)
	sta	SpriteBuf1.NPCs+24
	lda	#$0406							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+26
	lda	#$3070							; x (low), y (high)
	sta	SpriteBuf1.NPCs+28
	lda	#$0426							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+30



; -------------------------- wolf 2
	lda	#$2090							; x (low), y (high)
	sta	SpriteBuf1.NPCs+32
	lda	#$0608							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+34
	lda	#$3090							; x (low), y (high)
	sta	SpriteBuf1.NPCs+36
	lda	#$0628							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+38



; -------------------------- wolf 2
	lda	#$20B0							; x (low), y (high)
	sta	SpriteBuf1.NPCs+40
	lda	#$080A							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+42
	lda	#$30B0							; x (low), y (high)
	sta	SpriteBuf1.NPCs+44
	lda	#$082A							; tile no (low), attributes (high)
	sta	SpriteBuf1.NPCs+46



; -------------------------- registers
;	lda	#%0001000000010000					; turn on sprites only on mainscreen and subscreen
;	sta	REG_TM
;	sta	DP_Shadow_TSTM						; copy to shadow variable

	Accu8

	PrintString	1, 3, "Sprites contributed by\n   Tantalus:"
	PrintString	9, 3, "Dorothy   Wolf1   Wolf3"
	PrintString	10, 10, "Fox    Wolf2"

	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates
	lda	#$81							; reenable NMI
	sta	REG_NMITIMEN
	lda	#$0F							; turn screen back on
	sta	REG_INIDISP

	WaitUserInput

	jsr	SpriteInit						; purge OAM
	jmp	DebugMenu



; ************************ Debugging functions *************************

; -------------------------- show CPU load (via scanline counter)
ShowCPUload:
	lda	REG_SLHV						; latch H/V counter
	lda	REG_STAT78						; reset OPHCT/OPVCT flip-flops
	lda	REG_OPVCT
	sta	DP_CurrentScanline
	lda	REG_OPVCT
	and	#$01							; mask off 7 open bus bits
	sta	DP_CurrentScanline+1

	SetTextPos	2, 2
	PrintNum	DP_CurrentScanline

	jsr	PrintF
	.DB "  ", 0							; clear trailing numbers from old values

	rts



; ******************************* Tests ********************************

MoveSpriteCircularTest:
	ldx	#(TileMapBG3 & $FFFF)					; clear BG3 tilemap
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 2048

	stz	temp							; reset angle
	stz	temp+1

	lda	#35							; set radius
	sta	temp+2

; X := CenterX + sin(angle)*radius
; Y := CenterY + cos(angle)*radius

	PrintString	2, 20, "Angle: $"



__MSCTestLoop:
	wai

-	lda	REG_HVBJOY						; are we still on Vblank?
	bmi	-							; yes, wait

	SetTextPos	2, 28
	PrintHexNum	temp

	ldx	temp
	lda.l	SRC_Mode7Sin, x
	stz	REG_M7A
	sta	REG_M7A
	lda	temp+2							; radius
	asl	a							; not sure why this is needed
	sta	REG_M7B
	lda	REG_MPYH
	clc
	adc	#128							; add CenterX
	sta	SpriteBuf1.Text						; X

	ldx	temp
	lda.l	SRC_Mode7Cos, x
	stz	REG_M7A
	sta	REG_M7A
	lda	temp+2							; radius
	asl	a							; not sure why this is needed
	sta	REG_M7B
	lda	REG_MPYH
	clc
	adc	#112							; add CenterY
	sta	SpriteBuf1.Text+1					; Y

	lda	#%01000100						; make sure BG3 lo/hi tilemaps get updated
	tsb	DP_DMAUpdates

	inc	temp



; -------------------------- check for Start
	lda	Joy1New+1
	and	#%00010000
	beq	+

	jmp	DebugMenu
+

	jsr	ShowCPUload
	jmp	__MSCTestLoop



; ******************************** EOF *********************************
