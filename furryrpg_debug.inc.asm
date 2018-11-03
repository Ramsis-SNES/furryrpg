;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** DEBUG MENU ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

DebugMenu:
	lda	#$80							; enter forced blank
	sta	VAR_ShadowINIDISP

	ResetSprites
	Accu16

	stz	ARRAY_HDMA_BG_Scroll+1					; reset BG scroll values
	lda	#$00FF
	sta	ARRAY_HDMA_BG_Scroll+3

	Accu8

	stz	DP_HDMA_Channels					; disable HDMA



; -------------------------- clear tilemap buffers
	ldx	#(ARRAY_BG1TileMap1 & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 10240

	lda	#%00011111						; make sure BG1/2/3 lo/hi tilemaps get updated
	tsb	DP_DMA_Updates
	tsb	DP_DMA_Updates+1

	WaitFrames	3						; wait for regs/tilemaps to get cleared
	DisableIRQs



; -------------------------- load new NMI handler & GFX data
	SetNMI	TBL_NMI_DebugMenu

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_BG3_Tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Font8x8, GFX_Font8x8, <REG_VMDATAL, 2048

	ldx	#0
	lda	#$20							; priority bit
-	sta	ARRAY_BG3TileMapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-

	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_HUDfont, GFX_Sprites_HUDfont, <REG_VMDATAL, 4096

	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palettes_Text, SRC_Palettes_Text, <REG_CGDATA, 32

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palettes_HUD, SRC_Palettes_HUD, <REG_CGDATA, 32

	lda	#%00010111						; turn on BG1/2/3 and sprites on mainscreen and subscreen
	sta	REG_TM
	sta	REG_TS
	sta	VAR_ShadowTM						; copy to shadow variables
	sta	VAR_ShadowTS

	lda	#0
	ldx	#0
-	sta	ARRAY_SpriteDataArea.Hero1a, x				; overwrite char sprite buffer area with sprite 0 (empty)
	inx
	inx
	cpx	#24
	bne	-

	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; re-enable Vblank NMI + Auto Joypad Read
	sta	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli



; -------------------------- update PPU shadow registers in case they've been messed with
	lda	#$48|$01						; BG3 tile map VRAM offset: $4800, Tile Map size: 64×32 tiles
	sta	VAR_ShadowBG3SC
	lda	#$04							; BG3 character data VRAM offset: $4000 (ignore BG4 bits)
	sta	VAR_ShadowBG34NBA
	lda	#$01							; set BG Mode 1
	sta	VAR_ShadowBGMODE
	stz	REG_CGADD						; reset CGRAM address
	stz	REG_CGDATA						; $1C00 = dark blue as background color
	lda	#$1C
	sta	REG_CGDATA



; -------------------------- reset song pointer
	Accu16

	stz	DP_NextTrack

	Accu8



; -------------------------- done, draw debug menu
	PrintString	7, 3, "DEBUG MENU:"
	PrintString	10, 3, "Alpha intro"
	PrintString	11, 3, "Clear SRAM"
	PrintString	12, 3, "Load area: XXXX"
	PrintString	13, 3, "In-game menu"
	PrintString	14, 3, "Mode1 world map"
	PrintString	15, 3, "Mode7 world map"
	PrintString	16, 3, "Random number (0-255):"
	PrintString	17, 3, "Show sprite gallery"
	PrintString	18, 3, "SNESGSS music test:"
;	PrintString	19, 3, ""
;	PrintString	20, 3, ""

	stz	DP_SpriteTextMon					; reset sprite text filling level so it won't draw more than 1 cursor ;-)

	PrintSpriteText	10, 2, ">", 0					; put cursor on first line

	wai

	lda	#$0F							; turn on the screen
	sta	VAR_ShadowINIDISP



DebugMenuLoop:
	wai

	Accu16

	lda	DP_NextTrack
	asl	a
	tax
	lda.l	SRC_TrackPointerTable, x				; load track name pointer
	sta	DP_DataAddress

	Accu8

	lda	#:SRC_TrackPointerTable
	sta	DP_DataBank

	SetTextPos	12, 14
	PrintHexNum	DP_AreaCurrent+1				; print no. of area to load

	SetTextPos	12, 16
	PrintHexNum	DP_AreaCurrent

	PrintString	19, 4, "%s"					; print current SNESGSS song title

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates



; -------------------------- update time using RTC
	lda	DP_GameConfig
	and	#%00000010
	bne	+
	jmp	@RTCDone

+	lda	#$0D							; seems to be the "get time" command ??
	sta	SRTC_WRITE
	lda	SRTC_READ						; dummy read, should be $0F
	lda	SRTC_READ						; seconds (lower 4 bits)
	and	#$0F
	sta	DP_Temp
	lda	SRTC_READ						; seconds (upper 4 bits)
	and	#$0F
	asl	a							; shift to upper nibble
	asl	a
	asl	a
	asl	a
	ora	DP_Temp							; combine nibbles
	sta	VAR_Time_Second
	lda	SRTC_READ						; minutes.lo
	and	#$0F
	sta	DP_Temp
	lda	SRTC_READ						; minutes.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
	ora	DP_Temp
	sta	VAR_Time_Minute
	lda	SRTC_READ						; hours.lo
	and	#$0F
	sta	DP_Temp
	lda	SRTC_READ						; hours.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
	ora	DP_Temp
	sta	VAR_Time_Hour
	lda	SRTC_READ						; day.lo
	and	#$0F
	sta	DP_Temp
	lda	SRTC_READ						; day.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
	ora	DP_Temp
	sta	VAR_Time_Day
	lda	SRTC_READ						; month
	and	#$0F
	sta	VAR_Time_Month
	lda	SRTC_READ						; year.lo
	and	#$0F
	sta	DP_Temp
	lda	SRTC_READ						; year.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
	ora	DP_Temp
	sta	VAR_Time_Year
	lda	SRTC_READ						; century
	and	#$0F
	sta	VAR_Time_Century
;	lda	SRTC_READ						; weekday
;	sta	somewhere

	PrintString	25, 16, "Time:"
	SetTextPos	25, 22
	PrintHexNum	VAR_Time_Hour
	PrintString	25, 24, ":"
	SetTextPos	25, 25
	PrintHexNum	VAR_Time_Minute
	PrintString	25, 27, ":"
	SetTextPos	25, 28
	PrintHexNum	VAR_Time_Second

@RTCDone:



; -------------------------- check for dpad up
	lda	DP_Joy1New+1
	and	#%00001000
	beq	@DpadUpDone
	lda	ARRAY_SpriteDataArea.Text+2				; Y coord of cursor
	sec
	sbc	#8
	cmp	#PARAM_DebugMenu1stLine
	bcs	+
	lda	#PARAM_DebugMenu1stLine + 8 * 8				; underflow, put cursor on last line // no. of last menu item (8) * line height (8)
+	sta	ARRAY_SpriteDataArea.Text+2

@DpadUpDone:



; -------------------------- check for dpad down
	lda	DP_Joy1New+1
	and	#%00000100
	beq	@DpadDownDone
	lda	ARRAY_SpriteDataArea.Text+2
	clc
	adc	#8
	cmp	#PARAM_DebugMenu1stLine + 9 * 8				; no. of menu items (9) * line height (8)
	bcc	+
	lda	#PARAM_DebugMenu1stLine					; overflow, put cursor on first line
+	sta	ARRAY_SpriteDataArea.Text+2

@DpadDownDone:



; -------------------------- check for dpad left
	lda	DP_Joy1New+1
	and	#%00000010
	beq	@DpadLeftDone
	lda	ARRAY_SpriteDataArea.Text+2				; only do anything if cursor is on area loader ...
	cmp	#PARAM_DebugMenu1stLine + 16
	bne	+

	Accu16

	lda	DP_AreaCurrent
	dec	a
	cmp	#$FFFF
	bne	_f
	lda	#_sizeof_SRC_PointerAreaProperty/2-1			; underflow, load no. of last existing area
__	sta	DP_AreaCurrent

	Accu8

	bra	@DpadLeftDone

+	lda	ARRAY_SpriteDataArea.Text+2				; ... or on music test
	cmp	#PARAM_DebugMenu1stLine + 8 * 8
	bne	@DpadLeftDone
	lda	DP_NextTrack						; go to previous track
	dec	a
	bpl	+
	lda	#0
+	sta	DP_NextTrack

@DpadLeftDone:



; -------------------------- check for dpad right
	lda	DP_Joy1New+1
	and	#%00000001
	beq	@DpadRightDone
	lda	ARRAY_SpriteDataArea.Text+2				; only do anything if cursor is on area loader ...
	cmp	#PARAM_DebugMenu1stLine + 16
	bne	+

	Accu16

	lda	DP_AreaCurrent
	inc	a
	cmp	#_sizeof_SRC_PointerAreaProperty/2
	bcc	_f
	lda	#$0000							; overflow, load no. of first area
__	sta	DP_AreaCurrent

	Accu8

	bra	@DpadRightDone

+	lda	ARRAY_SpriteDataArea.Text+2				; ... or on music test
	cmp	#PARAM_DebugMenu1stLine + 8 * 8
	bne	@DpadRightDone
	lda	DP_NextTrack						; go to next track
	inc	a
	cmp	#_sizeof_SRC_TrackPointerTable/2
	bcc	+
	lda	#_sizeof_SRC_TrackPointerTable/2-1
+	sta	DP_NextTrack

@DpadRightDone:



; -------------------------- check for A button
	lda	DP_Joy1New
	and	#%10000000
	beq	@AButtonDone

	Accu16

	lda	ARRAY_SpriteDataArea.Text+2				; read Y position of cursor
	and	#$00FF							; remove garbage in high byte
	sec								; subtract Y value of first debug menu line
	sbc	#PARAM_DebugMenu1stLine
	lsr	a							; line height is 8 px, so we just need to divide by 4 to get the correct index
	lsr	a
	tax

	Accu8

	jmp	(@@PTR_DebugMenuEntry, x)

@@PTR_DebugMenuEntry:
	.DW @@GotoShowAlphaIntro
	.DW @@GotoClearSRAM
	.DW LoadArea
	.DW InGameMenu
	.DW LoadWorldMap
	.DW TestMode7
	.DW @@PrintRandomNumber
	.DW ShowSpriteGallery
	.DW @@GotoPlayTrack						; sound test works even .IFDEF NOMUSIC ;-)

@@GotoShowAlphaIntro:
	jsl	ShowAlphaIntro
	jmp	DebugMenu

@@GotoClearSRAM:
	Accu16

	jsl	CheckSRAM@ClearSRAM
	jmp	DebugMenu

.ACCU 8

@@GotoPlayTrack:
	jsl	PlayTrackNow
	bra	@AButtonDone

@@PrintRandomNumber:
	jsr	CreateRandomNr

	SetTextPos	16, 26
	PrintNum	ARRAY_RandomNumbers

	stz	DP_TextStringPtr
	stz	DP_TextStringPtr+1
	lda	#:DebugMenu
	sta	DP_TextStringBank
	jsr	PrintF

	.DB "  ", 0							; clear trailing ciphers from old values

@AButtonDone:



; -------------------------- check for Y button
;	bit	DP_Joy1New+1
;	bvc	@YButtonDone
;	jsr	ShowCPUload

;@YButtonDone:



; -------------------------- check for Start
	lda	DP_Joy1Press+1
	and	#%00010000
	beq	@StartButtonDone

	Accu16

	lda	#1
	jsl	LoadEvent

.ACCU 8

	jmp	DebugMenu

@StartButtonDone:

	ldx	#ARRAY_SpriteDataArea & $FFFF				; set WRAM address for area sprite data array
	stx	REG_WMADDL
	stz	REG_WMADDH
	jsr	ConvertSpriteDataToBuffer
	jmp	DebugMenuLoop



ShowSpriteGallery:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP

	DisableIRQs

	ldx	#(ARRAY_BG3TileMap & $FFFF)
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, <REG_WMDATA, 2048	; clear BG3 tile map

	jsr	SpriteInit						; purge OAM

	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_Gallery, GFX_Sprites_Gallery, <REG_VMDATAL, 2048

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palettes_Sprites_Gallery, SRC_Palettes_Sprites_Gallery, <REG_CGDATA, 160

	Accu16



; -------------------------- fennec puppet
	lda	#$2020							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+128
	lda	#$0000							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+130
	lda	#$2030							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+132
	lda	#$0002							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+134
	lda	#$3020							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+136
	lda	#$0020							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+138
	lda	#$3030							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+140
	lda	#$0022							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+142



; -------------------------- fox
	lda	#$2050							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+144
	lda	#$0204							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+146
	lda	#$3050							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+148
	lda	#$0224							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+150



; -------------------------- wolf 1
	lda	#$2070							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+152
	lda	#$0406							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+154
	lda	#$3070							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+156
	lda	#$0426							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+158



; -------------------------- wolf 2
	lda	#$2090							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+160
	lda	#$0608							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+162
	lda	#$3090							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+164
	lda	#$0628							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+166



; -------------------------- wolf 3
	lda	#$20B0							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+168
	lda	#$080A							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+170
	lda	#$30B0							; x (low), y (high)
	sta	ARRAY_ShadowOAM_Lo+172
	lda	#$082A							; tile no (low), attributes (high)
	sta	ARRAY_ShadowOAM_Lo+174



; -------------------------- registers
;	lda	#%0001000000010000					; turn on sprites only on mainscreen and subscreen
;	sta	REG_TM
;	sta	DP_Shadow_TSTM						; copy to shadow variable

	Accu8

	PrintString	1, 3, "Sprites contributed by\n   Tantalus:"
	PrintString	9, 3, "Dorothy   Wolf1   Wolf3"
	PrintString	10, 10, "Fox    Wolf2"

	lda	#%00010000						; make sure BG3 low tile map bytes are updated
	tsb	DP_DMA_Updates
	lda	REG_RDNMI						; clear NMI flag
	lda	#$81							; reenable NMI
	sta	REG_NMITIMEN
	cli
	lda	#$0F							; turn screen back on
	sta	REG_INIDISP

	WaitUserInput

	jsr	SpriteInit						; purge OAM
	jmp	DebugMenu



; ************************ Debugging functions *************************

.ENDASM

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

	stz	DP_TextStringPtr
	stz	DP_TextStringPtr+1
	lda	#:ShowCPUload
	sta	DP_TextStringBank
	jsr	PrintF

	.DB "  ", 0							; clear trailing numbers from old values

	rts

.ASM



; ******************************** EOF *********************************
