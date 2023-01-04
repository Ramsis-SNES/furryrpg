;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** DEBUG MENU ***
;
;==========================================================================================



SoftReset:								; FIXME, move SoftReset entry point to actual game booting routine
	Accu8

	Index16

	DisableIRQs

	lda	#$00							; turn off DMA & HDMA
	sta.l	HDMAEN
	sta.l	MDMAEN

	.IFNDEF NOMUSIC
		SNESGSS_Command kGSS_STOP_ALL_SOUNDS, 0			; stop all SPC700 sounds

		stz	MSU_CONTROL					; stop MSU1 track in case it's playing
	.ENDIF

	AccuIndex16

	lda	#P01.InitStackPtr					; set up the stack
	tcs

	SetDP	DP2							; set up the Direct Page, DP2 is standard for now

	Accu8

	SetDBR	$00							; set Data Bank = $00

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	stz	VMADDL							; reset VRAM address
	stz	VMADDH

	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear VRAM

; TODO (depending on code flow): Add sprite data init etc.



DebugMenu:
	DisableIRQs							; in case of returning here from some other section

	lda	#$80							; enter forced blank
	sta	INIDISP
	lda	#$00							; disable HDMA
	sta	HDMAEN
	stz	<DP2.HDMA_Channels
	stz	<DP2.DMA_Updates					; disable DMA updates for now

	stz	<DP2.EmptySpriteNo					; set empty sprite = 0

	ResetSprites

	Accu16

	stz	LO8.HDMA_BG_Scroll+1					; reset BG scroll values
	lda	#$00FF
	sta	LO8.HDMA_BG_Scroll+3

	Accu8

	ldx	#loword(RAM.BG3Tilemap)					; set WRAM address to BG3 tilemap buffer
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 1024				; clear it (low bytes only, high bytes are set up in SetupDebugRegsGFX)



; Load GFX data, set up screen and NMI
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN

	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Sprites_HUDfont, VMDATAL, 4096			; load HUD font (only cursor is used in debug menu)

	lda	#$80							; set CGRAM address to #256 (word address) for sprites
	sta	CGADD

	DMA_CH0 $02, SRC_Palettes_HUD, CGDATA, 32			; load HUD palette for sprite cursor

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

	lda	#$0F							; turn on the screen
	sta	RAM_INIDISP



DebugMenuLoop:
	lda	#%00010000						; make sure ONLY BG3 lo/hi tilemaps get updated
	sta	<DP2.DMA_Updates
	sta	<DP2.DMA_Updates+1					; hi tilemap update is actually only needed once (to clean up if Mode 1 world map was used), but who cares :p

	wai

	SetTextPos	13, 14
	PrintHexNum	<DP2.AreaCurrent+1				; print no. of area to load

	SetTextPos	13, 16
	PrintHexNum	<DP2.AreaCurrent



; Update time using RTC
	lda	<DP2.GameConfig
	and	#%00000010
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
	asl	a							; shift to upper nibble
	asl	a
	asl	a
	asl	a
	ora	<DP2.Temp						; combine nibbles
	sta	LO8.Time_Second
	lda	SRTC_READ						; minutes.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; minutes.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
	ora	<DP2.Temp
	sta	LO8.Time_Minute
	lda	SRTC_READ						; hours.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; hours.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
	ora	<DP2.Temp
	sta	LO8.Time_Hour
	lda	SRTC_READ						; day.lo
	and	#$0F
	sta	<DP2.Temp
	lda	SRTC_READ						; day.hi
	and	#$0F
	asl	a
	asl	a
	asl	a
	asl	a
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
	asl	a
	asl	a
	asl	a
	asl	a
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

	PrintString	25, 24, kTextBG3, ":"

	SetTextPos	25, 25
	PrintHexNum	LO8.Time_Minute

	PrintString	25, 27, kTextBG3, ":"

	SetTextPos	25, 28
	PrintHexNum	LO8.Time_Second

@RTCDone:



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
	lda	#_sizeof_PTR_AreaProperties/2-1				; underflow, load no. of last existing area
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
	inc	a
	cmp	#_sizeof_PTR_AreaProperties/2
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
	and	#$00FF							; remove garbage in high byte
	sec								; subtract Y value of first debug menu line
	sbc	#kDebugMenu1stLine
	lsr	a							; line height is 8 px, so we just need to divide by 4 to get the correct index
	lsr	a
	tax

	Accu8

	jmp	(PTR_DebugMenuEntry, x)

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
;	jsr	ShowCPUload
	jsl	PrintTest

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

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer

	jmp	DebugMenuLoop



PTR_DebugMenuEntry:
	.DW Debug_ShowAlphaIntro
	.DW Debug_ClearSRAM
	.DW DialogueTest
	.DW ShowArea
	.DW InGameMenu
	.DW LoadWorldMap
	.DW TestMode7
	.DW Debug_PrintRandomNumber
	.DW Debug_SetRTC
	.DW Debug_SNESGSS_Control					; sound test works even .IFDEF NOMUSIC ;-)

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
	DisableIRQs

	lda	#$80							; enter forced blank, register shadow variable still contains "screen on" + brightness setting
	sta	INIDISP
	ldx	#loword(RAM.BG3Tilemap)
	stx	WMADDL
	stz	WMADDH

	DMA_CH0 $08, SRC_Zeroes, WMDATA, 2048				; clear BG3 tilemap

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated once NMI is re-enabled
	tsb	<DP2.DMA_Updates

	ResetSprites

	lda	RDNMI							; clear NMI flag
	lda	#$81							; re-enable NMI
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

;	lda	#$0F							; turn screen back on // never mind, this is done via register shadow variable
;	sta	INIDISP
	lda	<DP2.GameConfig						; check if S-RTC is present at all
	and	#%00000010
	bne	@RTCpresent

	PrintString	2, 2, kTextBG3, "No real-time clock hardware\\n  found!"

	lda	#%00010000						; make sure BG3 low tilemap bytes are updated
	tsb	<DP2.DMA_Updates

	WaitUserInput

	jmp	DebugMenu

@RTCpresent:
	PrintString	2, 2, kTextBG3, "Adjust a value by holding\\n  the appropriate button and\\n  pressing up/down (d-pad)."
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
	and	#%00001000
	beq	@DpadUpDone
	lda	#$01							; value += 1
	sta	<DP2.Temp
	sta	<DP2.Temp+1

@DpadUpDone:



; Check for D-pad down --> decrement value
	lda	<DP2.Joy1New+1
	and	#%00000100
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
	and	#%00010000
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
	and	#%00100000
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
	and	#%00100000
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
	and	#%00010000
	bne	@WriteClockRegs
	jmp	@StartButtonDone

@WriteClockRegs:
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
	jmp	DebugMenu

@StartButtonDone:

	jmp	@SetRTCLoop



Debug_SNESGSS_Control:
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

	lda	#5							; BG Mode 5
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

	Accu16

	lda	DP2.NextTrack						; make NextTrack a sane value (could be $FFFF depending on area visited, which would break string printing)
	cmp	#_sizeof_STR_GSS_Tracks/32				; value higher than no. of last track in list?
	bcc	+
	lda	#_sizeof_STR_GSS_Tracks/32-1				; yes, load no. of last track (first track = $0000)
	sta	DP2.NextTrack

+	Accu8

	PrintString	2, 2, kTextMode5, "SNESGSS control panel\\n    ---------------------"

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts
	sta	NMITIMEN
	cli

SNESGSS_ControlLoop:
	ldx	#DP2.NextTrack+1
	stx	<DP2.DataAddress
	stz	<DP2.DataBank

	PrintString	5, 2, kTextMode5, "Play track:\\n     $%x"	; %x = track no. (high byte)

	ldx	#DP2.NextTrack
	stx	<DP2.DataAddress
	stz	<DP2.DataBank

	PrintString	6, 4, kTextMode5, "%x"				; track no. (low byte)

	Accu16

	lda	<DP2.NextTrack
	and	#$00FF							; clear garbage in high byte
	asl	a							; value in DP2.NextTrack * 32 for corresponding song name
	asl	a
	asl	a
	asl	a
	asl	a
	clc
	adc	#STR_GSS_Tracks						; add track list offset to address for song name to print
	sta	<DP2.DataAddress

	Accu8

	lda	#:STR_GSS_Tracks
	sta	<DP2.DataBank

	PrintString	6, 6, kTextMode5, "%s"				; song name

	ldx	#DP2.GSS_GlobalVol
	stx	<DP2.DataAddress
	stz	<DP2.DataBank

	PrintString	8, 2, kTextMode5, "Global volume:\\n     $%x"

	lda	#%00000101						; make sure BG1 and BG2 lo tilemaps get updated
	sta	<DP2.DMA_Updates
	stz	<DP2.DMA_Updates+1

	wai



; Check for A button
	bit	<DP2.Joy1New
	bpl	@AButtonDone

;	SNESGSS_Command kGSS_MUSIC_STOP, 0				; stop musc in case it's playing (doesn't seem to be needed as music stops as soon as the load command is sent)

	jsl	LoadTrackGSS						; this also re-enables stereo (when using original sound driver)

	DisableIRQs

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

	DisableIRQs

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
	inc	a
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

	DMA_CH0 $01, SRC_Font8x8, VMDATAL, 2048				; load debug menu font

	ldx	#0
	lda	#$20							; priority bit
-	sta	RAM.BG3TilemapHi, x					; set priority bit for BG3 tiles
	inx
	cpx	#1024
	bne	-

	stz	CGADD							; reset CGRAM address

	DMA_CH0 $02, SRC_Palettes_Text, CGDATA, 32			; load palettes



; Set up RAM mirror registers
	lda	#%00000011						; 8×8 (small) / 16×16 (large) sprites, character data at $6000 (multiply address bits [0-2] by $2000)
	sta	RAM_OBSEL
	lda	#$48|$01						; VRAM address for BG3 tilemap: $4800, size: 64×32 tiles
	sta	RAM_BG3SC
	lda	#$04							; VRAM address for BG3 character data: $4000 (ignore BG4 bits)
	sta	RAM_BG34NBA
	lda	#$01							; set BG mode 1
	sta	RAM_BGMODE
	lda	#%00010100						; turn on BG3 + sprites on mainscreen and subscreen
	sta	RAM_TM
	sta	RAM_TS
	lda	#%00110000						; set color math disable bits (4-5)
	sta	RAM_CGWSEL
	lda	#$00
	sta	RAM_W12SEL						; disable windowing
	sta	RAM_TMW
	sta	RAM_TSW
	sta	RAM_SETINI						; clear SETINI in case Mode 5 was used (intro disclaimer, SNESGSS control panel)


	SetNMI	kNMI_DebugMenu

	lda	RDNMI							; clear NMI flag
	lda	#$81							; enable NMI
	sta	NMITIMEN
	sta	LO8.NMITIMEN
	cli								; enable interrupts
	wai								; wait for NMI to fill joypad variables and PPU registers with valid data (first time upon cold boot)

	rts



; ************************ Debugging functions *************************

.ENDASM

; Show CPU load (via scanline counter)
ShowCPUload:
	lda	SLHV							; latch H/V counter
	lda	STAT78							; reset OPHCT/OPVCT flip-flops
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
	jsr	PrintF

	.DB "  ", 0							; clear trailing numbers from old values

	rts

.ASM



; ******************************** EOF *********************************
