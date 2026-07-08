; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	MODE7 HANDLER
;
; ==================================================================================================



.ACCU 8
.INDEX 16

TestMode7:
	lda	#kForcedBlank
	sta	RAM_INIDISP
	stz	<DP2.HDMA_Channels					; disable HDMA
	wai								; wait for OAM to refresh

	jsl	DisableInterrupts

.IFNDEF PrecalcMode7Tables

	stz	WMADDL							; set WRAM address to $7F0000
	stz	WMADDM
	lda	#$01
	sta	WMADDH

;old:
; generate tables for 128 altitude settings, 152 scanlines each:
; altitude 0: $800 / $20, $24, $28 ... $280
; altitude 1: $1000 / $20, $24, $28 ... $280
; altitude 2: $1800 / $20, $24, $28 ... $280
; ...

;new:
; generate tables for 112 altitude settings, 152 scanlines each:
; altitude 0: $8800 / $20, $24, $28 ... $280
; altitude 1: $9000 / $20, $24, $28 ... $280
; altitude 2: $9800 / $20, $24, $28 ... $280
; ...

	Accu16

	pea	$0000							; high word of 32-bit dividend
	pea	$8800							; low word of 32-bit dividend
--	pea	$0020							; 16-bit divisor
-	jsr	Div32by16

	Accu8

	lda	<DP2.Temp+4						; location of quotient
	sta	WMDATA
	lda	<DP2.Temp+5
	sta	WMDATA

	Accu16

	pla								; divisor += 4
	clc
	adc	#4
	cmp	#$0280
	bcs	+
	pha
	bra	-

+	pla								; dividend += $800
	clc
	adc	#$0800
	bcc	+
	plx
	inx
	cpx	#4
	beq	++
	phx								; push high word of dividend
+	pha								; push low word of dividend
;	pea	$0020							; push initial divisor
	bra	--


++	phx
	pha
	pea	$0020							; 16-bit divisor
-	jsr	Div32by16

	Accu8

	lda	<DP2.Temp+4						; location of quotient
	sta	WMDATA
	lda	<DP2.Temp+5
	sta	WMDATA

	Accu16

	pla								; divisor += 4
	clc
	adc	#4
	cmp	#$0280
	bcs	+
	pha
	bra	-

+	Accu8

.ENDIF



; HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	DMAP3
	lda	#<COLDATA						; PPU register $2132 (color math subscreen backdrop color)
	sta	BBAD3
	ldx	#LO8.HDMA_ColorMath
	stx	A1T3L
	lda	#$7E							; table in WRAM expected
	sta	A1B3



; HDMA channel 4: Mode 7 A
	lda	#$42							; transfer mode (2 bytes --> $211B), indirect table mode
	sta	DMAP4
	lda	#<M7A							; PPU reg. $211B
	sta	BBAD4
	ldx	#SRC_HDMA_M7A
	stx	A1T4L
	lda	#:SRC_HDMA_M7A
	sta	A1B4
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB4



; HDMA channel 5: Mode 7 B
	lda	#$42							; transfer mode (2 bytes --> $211C), indirect table mode
	sta	DMAP5
	lda	#<M7B							; PPU reg. $211C
	sta	BBAD5
	ldx	#SRC_HDMA_M7B
	stx	A1T5L
	lda	#:SRC_HDMA_M7B
	sta	A1B5
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB5



; HDMA channel 6: Mode 7 C
	lda	#$42							; transfer mode (2 bytes --> $211D), indirect table mode
	sta	DMAP6
	lda	#<M7C							; PPU reg. $211D
	sta	BBAD6
	ldx	#SRC_HDMA_M7C
	stx	A1T6L
	lda	#:SRC_HDMA_M7C
	sta	A1B6
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB6



; HDMA channel 7: Mode 7 D
	lda	#$42							; transfer mode (2 bytes --> $211E), indirect table mode
	sta	DMAP7
	lda	#<M7D							; PPU reg. $211E
	sta	BBAD7
	ldx	#SRC_HDMA_M7D
	stx	A1T7L
	lda	#:SRC_HDMA_M7D
	sta	A1B7
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB7



; Load Mode 7 palette
	stz	CGADD							; start at color 0

	dma_0	$02, SRC_IoTmappal, CGDATA, 512



; Load Mode 7 character data
; ############################### FOR PIC2MODE7'S GFX OUTPUT
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#$0000							; set VRAM address $0000
	stx	VMADDL

	dma_0	$01, SRC_IoTmappic, VMDATAL, 32768
; ##########################################################



; ############################### FOR GFX2SNES'/PCX2SNES' OUTPUT
;	stz	VMAIN							; increment VRAM address by 1 after writing to $2118
;	ldx	#$0000							; set VRAM address $0000
;	stx	VMADDL

;	dma_0	$00, SRC_Maptilemap, VMDATAL, _sizeof_SRC_Maptilemap

;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	VMAIN
;	ldx	#$0000							; set VRAM address $0000
;	stx	VMADDL

;	dma_0	$00, SRC_Mappic, VMDATAH, _sizeof_SRC_Mappic
; ##############################################################

.ENDASM

; load GFX data for rotating sky above Mode 7 world

	ldx	#$4000							; set VRAM address $4000
	stx	VMADDL

	dma_0	$01, SRC_Mode7_Sky, VMDATAL, _sizeof_SRC_Mode7_Sky

	ldx	#$5800							; set VRAM address $5800
	stx	VMADDL

	dma_0	$01, SRC_TileMap_Mode7_Sky, VMDATAL, _sizeof_SRC_TileMap_Mode7_Sky

	stz	CGADD							; reset CGRAM address

	dma_0	$02, SRC_Palette_Mode7_Sky, CGDATA, 32

.ASM



; Load HUD font
	jsr	ResetSprites

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	dma_0	$01, SRC_Sprites_HUDfont, VMDATAL, 4096



.ENDASM

; Load cloud sprites
	dma_0	$01, SRC_Sprites_Clouds, VMDATAL, 2048

	lda	#$A0							; start at 3rd sprite color
	sta	CGADD

	dma_0	$02, SRC_Palette_Clouds, CGDATA, 32



; Write cloud tilemap
	Accu16

	lda	#$1870							; Y, X start values of upper left corner of 128×32 GFX
	sta	<DP2.Temp

	lda	#$3480							; tile properties (highest priority, fixed), tile num (start value)
	sta	<DP2.Temp+2

	ldx	#$0000
-	lda	<DP2.Temp						; Y, X
	sta	SpriteBuf1.Reserved, x
	clc
	adc	#$0010							; X += 16
	sta	<DP2.Temp
	inx
	inx

	lda	<DP2.Temp+2						; tile properties, tile num
	sta	SpriteBuf1.Reserved, x
	clc
	adc	#$0002							; tile num += 2
	sta	<DP2.Temp+2
	inx
	inx

	bit	#$000F							; check if last 4 bits of tile num clear = one row of 8 (large) sprites done?
	bne	-							; "inner loop"

	lda	<DP2.Temp
	and	#$FF70							; reset X = 8
	clc
	adc	#$1000							; Y += 16
	sta	<DP2.Temp
	lda	<DP2.Temp+2
	clc
	adc	#$0010							; tile num += 16 (i.e., skip one row of 8*8 tiles)
	sta	<DP2.Temp+2

	cpx	#$40							; 16 large sprites done?
	bne	-							; "outer loop"

	Accu8

	stz	<DP2.Temp+2						; see Mode 7 matrix calculations below



; Set transparency for clouds
	lda	#%00010000						; turn on BG1 on mainscreen only, sprites on subscreen
	sta	RAM_TM
	sta	RAM_TS

	Accu8

	lda	#$E0							; subscreen backdrop color
	sta	RAM_COLDATA
	sta	RAM_COLDATA
	lda	#%0000010						; enable BGs/OBJs on subscreen
	sta	RAM_CGWSEL
	lda	#%01000001						; enable color math on BG1, add subscreen and div by 2
	sta	RAM_CGADSUB

.ASM



; Load sky backdrop gradient
	ldx	#loword(RAM.HDMA_BackgrPlayfield)			; set WRAM address to playfield HDMA background
	stx	WMADDL
	stz	WMADDH

	dma_0	$00, SRC_HDMA_Mode7Sky72, WMDATA, _sizeof_SRC_HDMA_Mode7Sky72



; Set (PPU shadow) registers
	lda	#$58							; VRAM address for BG2 tilemap: $5800, size: 32×32 tiles
	sta	RAM_BG2SC
	lda	#$40							; VRAM address for BG2 character data: $4000 (ignore BG1 bits)
	sta	RAM_BG12NBA
	lda	#kBGMODE_1|kBG3priority					; BG Mode 1 for sky, BG3 priority (Mode 7 is switched to via IRQ)
	sta	RAM_BGMODE
;	lda	#kTM_BG2|kTM_OBJ					; turn on BG2 (for rotating sky above Mode 7 world) and sprites
	lda	#kTM_OBJ						; turn on sprites only
	sta	RAM_TM							; on the mainscreen
	sta	RAM_TS							; and on the subscreen
;	lda	#$FF							; scroll BG2 down by 1 px (for rotating sky above Mode 7 world)
;	sta	BG2VOFS
;	stz	BG2VOFS



; Load horizon blur
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathMode7, x
	sta	LO8.HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMode7
	bne	-

	lda	#%00000000						; clear color math disable bits (4-5)
	sta	RAM_CGWSEL
	lda	#%00110111						; enable color math on BG1/2/3 + sprites + backdrop
	sta	RAM_CGADSUB



; Set new NMI/IRQ vectors & screen parameters
	set	"NMI", Vblank_Mode7

	Accu16

	lda	#220		;FIXME readjust				; dot number for interrupt (256 = too late, 204 = too early)
	sta	HTIMEL
;	stz	HTIMEL
	lda	#kMode7SkyLines						; scanline number for interrupt
	sta	VTIMEL

	Accu8

	set	"IRQ", VIRQ_Mode7

	lda	#%11111100						; enable HDMA channels 2-7
	sta	<DP2.HDMA_Channels
	lda	RDNMI							; clear NMI flag
	lda	#kNMITIMEN_Enable|kHVIRQ|kAutoJoy			; enable NMI, auto joypad read, and IRQ at H=HTIMEL and V=VTIMEL
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli
	jsr	ResetMode7Matrix

	wait	"frames", 1						; wait for altitude setting to take effect

	Accu16

	stz	<DP2.Temp						; clear DP2.Temp vars (used in CalcMode7Matrix)
	stz	<DP2.Temp+2
	stz	<DP2.Temp+4
	stz	<DP2.Temp+6

	Accu8

	jsr	CalcMode7Matrix

	lda	#kEffectSpeed3
	sta	<DP2.EffectSpeed
	ldx	#kEffectTypeHSplitIn
	jsr	(SRC_EffectTypes, x)

Mode7Loop:
;	PrintSpriteText	25, 22, "V-Line: $", 1
;	PrintSpriteHexNum	<DP2.Temp+7

	PrintSpriteText	25, 21, "Altitude: $", 1
	PrintSpriteHexNum	<DP2.Mode7_Altitude

	PrintSpriteText	23, 22, "Angle: $", 1
	PrintSpriteHexNum	<DP2.Mode7_RotAngle

;	PrintSpriteText	25, 18, "Center-X: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_CenterCoordX+1
;	PrintSpriteHexNum	<DP2.Mode7_CenterCoordX

;	PrintSpriteText	24, 21, "ScrX: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetX+1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetX

;	PrintSpriteText	25, 21, "ScrY: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetY+1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetY

	wait	"frames", 1						; don't use WAI here as IRQ is enabled



; Check for dpad up+left
	lda	<DP2.Joy1Press+1
	and	#kDpadUp|kDpadLeft
	cmp	#kDpadUp|kDpadLeft
	bne	@DpadUpLeftDone
	dec	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	ina
	cmp	#112
	bcc	+
	lda	#111
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	jmp	@SkipDpad						; skip additional d-pad checks (no more than 2 directions allowed)

@DpadUpLeftDone:



; Check for dpad up+right
	lda	<DP2.Joy1Press+1
	and	#kDpadUp|kDpadRight
	cmp	#kDpadUp|kDpadRight
	bne	@DpadUpRightDone
	inc	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	ina
	cmp	#112
	bcc	+
	lda	#111
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	@SkipDpad

@DpadUpRightDone:



; Check for dpad down+left
	lda	<DP2.Joy1Press+1
	and	#kDpadDown|kDpadLeft
	cmp	#kDpadDown|kDpadLeft
	bne	@DpadDownLeftDone
	dec	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	dea
	bpl	+
	lda	#0
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	@SkipDpad

@DpadDownLeftDone:



; Check for dpad down+right
	lda	<DP2.Joy1Press+1
	and	#kDpadDown|kDpadRight
	cmp	#kDpadDown|kDpadRight
	bne	@DpadDownRightDone
	inc	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	dea
	bpl	+
	lda	#0
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	@SkipDpad

@DpadDownRightDone:



; Check for dpad up
	lda	<DP2.Joy1Press+1
	and	#kDpadUp
	beq	@DpadUpDone
	lda	<DP2.Mode7_Altitude
	ina
	cmp	#112
	bcc	+
	lda	#111
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

@DpadUpDone:



; Check for dpad down
	lda	<DP2.Joy1Press+1
	and	#kDpadDown
	beq	@DpadDownDone
	lda	<DP2.Mode7_Altitude
	dea
	bpl	+
	lda	#0
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

@DpadDownDone:



; Check for dpad left
	lda	<DP2.Joy1Press+1
	and	#kDpadLeft
	beq	@DpadLeftDone
;	lda	<DP2.Mode7_BG2HScroll					; (for rotating sky above Mode 7 world)
;	sec
;	sbc	#5
;	sta	<DP2.Mode7_BG2HScroll
	dec	<DP2.Mode7_RotAngle
	jsr	CalcMode7Matrix

@DpadLeftDone:



; Check for dpad right
	lda	<DP2.Joy1Press+1
	and	#kDpadRight
	beq	@DpadRightDone
;	lda	<DP2.Mode7_BG2HScroll					; (for rotating sky above Mode 7 world)
;	clc
;	adc	#5
;	sta	<DP2.Mode7_BG2HScroll
	inc	<DP2.Mode7_RotAngle
	jsr	CalcMode7Matrix

@DpadRightDone:

@SkipDpad:



; Check for L
	lda	<DP2.Joy1Press
	and	#kButtonL
	beq	@LButtonDone
	dec	<DP2.Mode7_RotAngle
	dec	<DP2.Mode7_RotAngle
	jsr	CalcMode7Matrix

@LButtonDone:



; Check for R
	lda	<DP2.Joy1Press
	and	#kButtonR
	beq	@RButtonDone
	inc	<DP2.Mode7_RotAngle
	inc	<DP2.Mode7_RotAngle
	jsr	CalcMode7Matrix

@RButtonDone:



; Check for A = fly forward
	lda	<DP2.Joy1Press
	bpl	@AButtonDone

/*
; Try a shorter, faster implementation with sine/cosine lookup tables for inc/dec X/Y values
; (no luck yet, probably just needs a simple math fix though *cough* ScrollOffsetY *cough*)
	ldx	<DP2.Mode7_RotAngle

	Accu16

	lda.l	SRC_SineTableX, x
	clc
	adc	<DP2.Mode7_ScrollOffsetX
	and	#$1FFF							; max scroll value (CHECKME)
	sta	<DP2.Mode7_ScrollOffsetX
	clc								; add 128 pixels (half a scanline)
	adc	#$0400
	sta	<DP2.Mode7_CenterCoordX

	lda.l	SRC_CosineTableY, x
	clc
	adc	<DP2.Mode7_ScrollOffsetY
	and	#$1FFF							; max scroll value (CHECKME)
	sta	<DP2.Mode7_ScrollOffsetY
	clc
	adc	#$0400 + (kMode7SkyLines*8)
	sta	<DP2.Mode7_CenterCoordY

	Accu8

	bra	@AButtonDone
*/

	lda	<DP2.Mode7_RotAngle					; $00 < angle < $80 --> inc X
	beq	@FlightY						; don't change X if angle = 0
	cmp	#$80
	beq	@FlightY						; don't change X if angle = 128 (eq. 180°)
	bcs	+
	jsr	M7FlightIncX

	bra	@FlightY

+	jsr	M7FlightDecX						; $80 < angle <= $FF --> dec X

@FlightY:
	lda	<DP2.Mode7_RotAngle					; $40 < angle < $C0 --> inc Y
	cmp	#$40
	beq	@AButtonDone						; don't change Y if angle = 64 (eq. 90°)
	bcc	+
	cmp	#$C0
	beq	@AButtonDone						; don't change Y if angle = 192 (eq. 270°)
	bcs	+
	jsr	M7FlightIncY

	bra	@AButtonDone

+	jsr	M7FlightDecY						; $C0 < angle <= $FF | $00 < angle < $40 --> dec Y

@AButtonDone:

.ENDASM

; Check for B
	lda	<DP2.Joy1Press+1
	bpl	@BButtonDone

@BButtonDone:



; Check for X
	bit	<DP2.Joy1Press
	bvc	@XButtonDone

@XButtonDone:



; Check for Y
	bit	<DP2.Joy1Press+1
	bvc	@YButtonDone

@YButtonDone:

.ASM

; Check for Start
	lda	<DP2.Joy1New+1
	and	#kButtonStart
	beq	@StartButtonDone
	lda	#kEffectSpeed3
	sta	<DP2.EffectSpeed
	ldx	#kEffectTypeHSplitOut2
	jsr	(SRC_EffectTypes, x)

	lda	#kHVIRQ							; clear IRQ enable bits
	trb	LO8.NMITIMEN

;	jsr	SpriteInit						; purge OAM

;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	VMAIN
;	stz	VMADDL							; reset VRAM address
;	stz	VMADDH

;	dma_0	$09, SRC_0000, VMDATAL, 0				; clear VRAM // no, not with NMI enabled

	jml	DebugMenu

@StartButtonDone:



; Check for Select
	lda	<DP2.Joy1New+1
	and	#kButtonSel
	beq	@SelButtonDone
	jsr	ResetMode7Matrix

	wait	"frames", 1						; wait for altitude setting to take effect

	jsr	CalcMode7Matrix

@SelButtonDone:



; Misc. tasks, end loop
	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer

	jmp	Mode7Loop



; Calculate Mode 7 matrix parameters for next frame

; This is the algorithm to do signed 8×16 bit multiplication required for Mode 7 registers using hardware multiplication:
; - do unsigned 8×8 bit multiplication for lower 8 bits of multiplicand (while keeping track of multiplier sign), store 16-bit interim result in DP2.Temp
; - do unsigned 8×8 bit multiplication for upper 8 bits of multiplicand, add (interim result >> 8) and store as 16-bit final result (if multiplier sign was negative, make result negative)

.IFDEF PrecalcMode7Tables

CalcMode7Matrix:
	lda	#:SRC_Mode7Scaling
	sta	<DP2.DataBank



; Calculate M7A/M7D for next frame

; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	<DP2.Temp+6
	txy
	lda	[<DP2.DataAddress], y
	sta	WRMPYA

	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_CosineTable8, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	ina
	dec	<DP2.Temp+6						; remember that multplier has wrong sign
+	sta	WRMPYB
	nop								; burn a few cycles
	nop
	ldx	RDMPYL							; store interim result
	stx	<DP2.Temp

; 8×8 multiplication for upper 8 bits of multiplicand
	iny
	lda	[<DP2.DataAddress], y
	sta	WRMPYA

	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_CosineTable8, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	ina
+	sta	WRMPYB
	tyx
	dex								; make up for preceding iny

	Accu16								; 3 cycles

	lda	RDMPYL							; 3 // store final result
	clc
	adc	<DP2.Temp+1
	bit	<DP2.Temp+5						; check for multiplier sign
	bpl	+
	eor	#$FFFF							; multiplier was negative, so make final result negative
	ina
+	sta	LO8.HDMA_M7A+(kMode7SkyLines*2), x
	sta	LO8.HDMA_M7D+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-



; Calculate M7B/M7C for next frame

; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	<DP2.Temp+6
	txy
	lda	[<DP2.DataAddress], y
	sta	WRMPYA

	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_SineTable8, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	ina
	dec	<DP2.Temp+6						; remember that multplier has wrong sign
+	sta	WRMPYB
	nop								; burn a few cycles
	nop
	ldx	RDMPYL							; store interim result
	stx	<DP2.Temp

; 8×8 multiplication for upper 8 bits of multiplicand
	iny
	lda	[<DP2.DataAddress], y
	sta	WRMPYA

	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_SineTable8, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	ina
+	sta	WRMPYB
	tyx
	dex

	Accu16								; 3 cycles

	lda	RDMPYL							; 3 // store final result
	clc
	adc	<DP2.Temp+1
	bit	<DP2.Temp+5						; check for multiplier sign
	bmi	+
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x
	eor	#$FFFF							; make M7C parameter negative and store in M7B
	ina
	sta	LO8.HDMA_M7B+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-

	rts

.ACCU 16

+	sta	LO8.HDMA_M7B+(kMode7SkyLines*2), x			; multiplier was negative, store negative value first in M7B
	eor	#$FFFF							; make M7B parameter positive and store in M7C
	ina
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-

	rts



; FIXME Try using PPU multiplication instead during Vblank w/ below new routine

CalcMode7MatrixPPU:
	lda	#:SRC_Mode7Scaling
	sta	<DP2.DataBank



; Calculate M7A/M7D for next frame
	ldx	#0
-	txy
	lda	[<DP2.DataAddress], y
	sta	M7A
	iny
	lda	[<DP2.DataAddress], y
	sta	M7A

	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_CosineTable8, x
	sta	M7B
	tyx
	dex								; make up for preceding iny

	Accu16

	lda	MPYM
	sta	LO8.HDMA_M7A+(kMode7SkyLines*2), x
	sta	LO8.HDMA_M7D+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-



; Calculate M7B/M7C for next frame
	ldx	#0
-	txy
	lda	[<DP2.DataAddress], y
	sta	M7A
	iny
	lda	[<DP2.DataAddress], y
	sta	M7A

	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_SineTable8, x
	sta	M7B
	tyx
	dex

	Accu16

	lda	MPYM
	bmi	+
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x
	eor	#$FFFF							; make M7C parameter negative and store in M7B
	ina
	sta	LO8.HDMA_M7B+(kMode7SkyLines*2), x
	bra	++

+	sta	LO8.HDMA_M7B+(kMode7SkyLines*2), x			; multiplier was negative, store negative value first in M7B
	eor	#$FFFF							; make M7B parameter positive and store in M7C
	ina
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x

++	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-

	rts

.ELSE

CalcMode7Matrix:
	ldx	<DP2.DataAddress					; set WRAM address to beginning of table (based on current altitude, as set during Vblank)
	stx	WMADDL
	lda	#$01
	sta	WMADDH



; Calculate M7A/M7D for next frame

; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	<DP2.Temp+6
	lda	WMDATA							; read table entry
	sta	WRMPYA
	txy								; preserve X in Y, this is faster than using the stack
	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_CosineTable8, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	ina
	dec	<DP2.Temp+6						; remember that multplier has wrong sign
+	sta	WRMPYB
	nop								; burn a few cycles
	nop
	ldx	RDMPYL							; store interim result
	stx	<DP2.Temp

; 8×8 multiplication for upper 8 bits of multiplicand
	lda	WMDATA							; read table entry
	sta	WRMPYA
	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_CosineTable8, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	ina
+	sta	WRMPYB
	tyx								; restore X // 2 cycles

	Accu16								; 3

	lda	RDMPYL							; 3 // store final result
	clc
	adc	<DP2.Temp+1
	bit	<DP2.Temp+5						; check for multiplier sign
	bpl	+
	eor	#$FFFF							; multiplier was negative, so make final result negative
	ina
+	sta	LO8.HDMA_M7A+(kMode7SkyLines*2), x
	sta	LO8.HDMA_M7D+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-

	ldx	<DP2.DataAddress					; reset WRAM address to beginning of table
	stx	WMADDL



; Calculate M7B/M7C for next frame

; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	<DP2.Temp+6
	lda	WMDATA							; read table entry
	sta	WRMPYA
	txy								; preserve X
	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_SineTable8, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	ina
	dec	<DP2.Temp+6						; remember that multplier has wrong sign
+	sta	WRMPYB
	nop								; burn a few cycles
	nop
	ldx	RDMPYL							; store interim result
	stx	<DP2.Temp

; 8×8 multiplication for upper 8 bits of multiplicand
	lda	WMDATA							; read table entry
	sta	WRMPYA
	ldx	<DP2.Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_SineTable8, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	ina
+	sta	WRMPYB
	tyx								; restore X // 2 cycles

	Accu16								; 3

	lda	RDMPYL							; 3 // store final result
	clc
	adc	<DP2.Temp+1
	bit	<DP2.Temp+5						; check for multiplier sign
	bmi	+
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x
	eor	#$FFFF							; make M7C parameter negative and store in M7B
	ina
	sta	LO8.HDMA_M7B+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-

	rts

.ACCU 16

+	sta	LO8.HDMA_M7B+(kMode7SkyLines*2), x			; multiplier was negative, store negative value first in M7B
	eor	#$FFFF							; make M7B parameter positive and store in M7C
	ina
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(kMode7SkyLines*2)
	bne	-

	rts



.ACCU 16

;-----------------------------
; 32 by 16 bit division (c) by Garth Wilson
; http://6502.org/source/integers/ummodfix/ummodfix.htm
;
                        ; +-----|-----+-----|-----+-----|-----+-----|------+
                        ; |  DIVISOR  |    D I V I D E N D    |temp storage|
                        ; |           |  hi cell     lo cell  |of carry bit|
                        ; |  N    N+1 | N+2   N+3 | N+4   N+5 | N+6   N+7  |
                        ; +-----|-----+-----|-----+-----|-----+-----|------+
;
Div32by16:
	lda	7, s							; high word of 32-bit dividend
	sta	<DP2.Temp+2
	lda	5, s							; low word of 32-bit dividend
	sta	<DP2.Temp+4
	lda	3, s							; 16-bit divisor
	sta	<DP2.Temp
	stz	<DP2.Temp+6						; clear 16-bit of temp storage

        SEC								; Detect overflow or /0 condition.  To find out, sub-
        LDA     DP2.Temp+2						; tract divisor from hi cell of dividend; if C flag
        SBC     DP2.Temp						; remains set, divisor was not big enough to avoid
        BCS     @uoflo							; overflow.  This also takes care of any /0 conditions.
									; If branch not taken, C flag is left clear for 1st ROL.
									; We will loop 16x; but since we shift the dividend
        LDX     #17							; over at the same time as shifting the answer in, the
									; operation must start AND finish with a shift of the
									; lo cell of the dividend (which ends up holding the
;       INDEX_16							; quotient), so we start with 17 in X.  We will use Y
									; for temporary storage too, so set index reg.s 16-bit.
@ushftl:
	ROL     DP2.Temp+4						; Move lo cell of dividend left one bit, also shifting
									; answer in.  The 1st rotation brings in a 0, which
        DEX								; later gets pushed off the other end in the last
        BEQ     @umend							; rotation.     Branch to the end if finished.

        ROL     DP2.Temp+2						; Shift hi cell of dividend left one bit, also shifting
        LDA     #0							; next bit in from high bit of lo cell.
        ROL     A
        STA     DP2.Temp+6						; Store old hi bit of dividend in N+6.

        SEC								; See if divisor will fit into hi 17 bits of dividend
        LDA     DP2.Temp+2						; by subtracting and then looking at carry flag.
        SBC     DP2.Temp						; If carry got cleared, divisor did not fit.
        TAY								; Save the difference in Y until we know if we need it.

        LDA     DP2.Temp+6						; Bit 0 of N+6 serves as 17th bit.
        SBC     #0							; Complete the subtraction by doing the 17th bit before
        BCC     @ushftl							; determining if the divisor fit into the hi 17 bits of
									; the dividend.  If so, the C flag remains set.
        STY     DP2.Temp+2						; If divisor fit into hi 17 bits, update dividend hi
        BRA     @ushftl							; cell to what it would be after subtraction.    Branch.

 @uoflo:
 	LDA     #$FFFF							; If an overflow or /0 condition occurs, put FFFF in
        STA     DP2.Temp+4						; both the quotient
        STA     DP2.Temp+2						; and the remainder.

 @umend:

	rts

.ENDIF



.ACCU 8

M7FlightDecX:								; expects angle in Accu
	cmp	#$A0
	bcc	@DoXDecByAngle

	cmp	#$E1
	bcs	+
	lda	#$20
	bra	@DoXDecByAngle

+	lda	#$80
	sec
	sbc	<DP2.Mode7_RotAngle

@DoXDecByAngle:
	Accu16

	and	#$003F							; clear high byte, make sure angle in low byte doesn't exceed max. index ($20)
	dea
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetX
	jmp	(@XDecByAngle, x)



@XDecByAngle:
	.DW @DecX1, @DecX2, @DecX3, @DecX4, @DecX5, @DecX6, @DecX7, @DecX8, @DecX9, @DecX10, @DecX11, @DecX12, @DecX13, @DecX14, @DecX15, @DecX16, @DecX17, @DecX18, @DecX19, @DecX20, @DecX21, @DecX22, @DecX23, @DecX24, @DecX25, @DecX26, @DecX27, @DecX28, @DecX29, @DecX30, @DecX31, @DecX32

@DecX32:
	dea

@DecX31:
	dea

@DecX30:
	dea

@DecX29:
	dea

@DecX28:
	dea

@DecX27:
	dea

@DecX26:
	dea

@DecX25:
	dea

@DecX24:
	dea

@DecX23:
	dea

@DecX22:
	dea

@DecX21:
	dea

@DecX20:
	dea

@DecX19:
	dea

@DecX18:
	dea

@DecX17:
	dea

@DecX16:
	dea

@DecX15:
	dea

@DecX14:
	dea

@DecX13:
	dea

@DecX12:
	dea

@DecX11:
	dea

@DecX10:
	dea

@DecX9:
	dea

@DecX8:
	dea

@DecX7:
	dea

@DecX6:
	dea

@DecX5:
	dea

@DecX4:
	dea

@DecX3:
	dea

@DecX2:
	dea

@DecX1:
	dea
	and	#$1FFF							; max scroll value (CHECKME)
	sta	<DP2.Mode7_ScrollOffsetX
	clc								; add 128 pixels (half a scanline)
	adc	#$0400
	sta	<DP2.Mode7_CenterCoordX

	Accu8

	rts



M7FlightIncX:								; expects angle in Accu
	cmp	#$20
	bcc	@DoXIncByAngle

	cmp	#$61
	bcs	+
	lda	#$20
	bra	@DoXIncByAngle

+	lda	#$80
	sec
	sbc	<DP2.Mode7_RotAngle

@DoXIncByAngle:
	Accu16

	and	#$003F
	dea
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetX
	jmp	(@XIncByAngle, x)



@XIncByAngle:
	.DW @IncX1, @IncX2, @IncX3, @IncX4, @IncX5, @IncX6, @IncX7, @IncX8, @IncX9, @IncX10, @IncX11, @IncX12, @IncX13, @IncX14, @IncX15, @IncX16, @IncX17, @IncX18, @IncX19, @IncX20, @IncX21, @IncX22, @IncX23, @IncX24, @IncX25, @IncX26, @IncX27, @IncX28, @IncX29, @IncX30, @IncX31, @IncX32

@IncX32:
	ina

@IncX31:
	ina

@IncX30:
	ina

@IncX29:
	ina

@IncX28:
	ina

@IncX27:
	ina

@IncX26:
	ina

@IncX25:
	ina

@IncX24:
	ina

@IncX23:
	ina

@IncX22:
	ina

@IncX21:
	ina

@IncX20:
	ina

@IncX19:
	ina

@IncX18:
	ina

@IncX17:
	ina

@IncX16:
	ina

@IncX15:
	ina

@IncX14:
	ina

@IncX13:
	ina

@IncX12:
	ina

@IncX11:
	ina

@IncX10:
	ina

@IncX9:
	ina

@IncX8:
	ina

@IncX7:
	ina

@IncX6:
	ina

@IncX5:
	ina

@IncX4:
	ina

@IncX3:
	ina

@IncX2:
	ina

@IncX1:
	ina
	and	#$1FFF							; max scroll value (CHECKME)
	sta	<DP2.Mode7_ScrollOffsetX
	clc								; add 128 pixels (half a scanline)
	adc	#$0400
	sta	<DP2.Mode7_CenterCoordX

	Accu8

	rts



M7FlightDecY:								; expects angle in Accu
	cmp	#$40
	bcc	+
	cmp	#$E0
	bcc	@DoYDecByAngle
	bra	@DoYDecFull

+	cmp	#$20
	bcs	++

@DoYDecFull:
	lda	#$20
	bra	@DoYDecByAngle

++	lda	#$40
	sec
	sbc	<DP2.Mode7_RotAngle

@DoYDecByAngle:
	Accu16

	and	#$003F
	dea
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetY
	jmp	(@YDecByAngle, x)



@YDecByAngle:
	.DW @DecY1, @DecY2, @DecY3, @DecY4, @DecY5, @DecY6, @DecY7, @DecY8, @DecY9, @DecY10, @DecY11, @DecY12, @DecY13, @DecY14, @DecY15, @DecY16, @DecY17, @DecY18, @DecY19, @DecY20, @DecY21, @DecY22, @DecY23, @DecY24, @DecY25, @DecY26, @DecY27, @DecY28, @DecY29, @DecY30, @DecY31, @DecY32

@DecY32:
	dea

@DecY31:
	dea

@DecY30:
	dea

@DecY29:
	dea

@DecY28:
	dea

@DecY27:
	dea

@DecY26:
	dea

@DecY25:
	dea

@DecY24:
	dea

@DecY23:
	dea

@DecY22:
	dea

@DecY21:
	dea

@DecY20:
	dea

@DecY19:
	dea

@DecY18:
	dea

@DecY17:
	dea

@DecY16:
	dea

@DecY15:
	dea

@DecY14:
	dea

@DecY13:
	dea

@DecY12:
	dea

@DecY11:
	dea

@DecY10:
	dea

@DecY9:
	dea

@DecY8:
	dea

@DecY7:
	dea

@DecY6:
	dea

@DecY5:
	dea

@DecY4:
	dea

@DecY3:
	dea

@DecY2:
	dea

@DecY1:
	dea
	and	#$1FFF							; max scroll value (CHECKME)
	sta	<DP2.Mode7_ScrollOffsetY
	clc
	adc	#$0400 + (kMode7SkyLines*8)
	sta	<DP2.Mode7_CenterCoordY

	Accu8

	rts



M7FlightIncY:								; expects angle in Accu
	cmp	#$60
	bcc	@DoYIncByAngle
	cmp	#$A1
	bcs	+
	lda	#$20							; $60 <= angle <= $A0 --> increment Y by 32
	bra	@DoYIncByAngle

+	lda	#$C0
	sec
	sbc	<DP2.Mode7_RotAngle

@DoYIncByAngle:
	Accu16

	and	#$003F
	dea
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetY
	jmp	(@YIncByAngle, x)



@YIncByAngle:
	.DW @IncY1, @IncY2, @IncY3, @IncY4, @IncY5, @IncY6, @IncY7, @IncY8, @IncY9, @IncY10, @IncY11, @IncY12, @IncY13, @IncY14, @IncY15, @IncY16, @IncY17, @IncY18, @IncY19, @IncY20, @IncY21, @IncY22, @IncY23, @IncY24, @IncY25, @IncY26, @IncY27, @IncY28, @IncY29, @IncY30, @IncY31, @IncY32

@IncY32:
	ina

@IncY31:
	ina

@IncY30:
	ina

@IncY29:
	ina

@IncY28:
	ina

@IncY27:
	ina

@IncY26:
	ina

@IncY25:
	ina

@IncY24:
	ina

@IncY23:
	ina

@IncY22:
	ina

@IncY21:
	ina

@IncY20:
	ina

@IncY19:
	ina

@IncY18:
	ina

@IncY17:
	ina

@IncY16:
	ina

@IncY15:
	ina

@IncY14:
	ina

@IncY13:
	ina

@IncY12:
	ina

@IncY11:
	ina

@IncY10:
	ina

@IncY9:
	ina

@IncY8:
	ina

@IncY7:
	ina

@IncY6:
	ina

@IncY5:
	ina

@IncY4:
	ina

@IncY3:
	ina

@IncY2:
	ina

@IncY1:
	ina
	and	#$1FFF							; max scroll value (CHECKME)
	sta	<DP2.Mode7_ScrollOffsetY
	clc
	adc	#$0400 + (kMode7SkyLines*8)
	sta	<DP2.Mode7_CenterCoordY

	Accu8

	rts



ResetMode7Matrix:
	Accu16

	stz	<DP2.Mode7_ScrollOffsetX
	stz	<DP2.Mode7_ScrollOffsetY
	lda	#$0400							; 16-bit values
	sta	<DP2.Mode7_CenterCoordX
	lda	#$0400 + (kMode7SkyLines*8)
	sta	<DP2.Mode7_CenterCoordY

	Accu8

	lda	#56
	sta	<DP2.Mode7_Altitude
	stz	<DP2.Mode7_RotAngle
	stz	M7SEL							; M7SEL: no flipping, Screen Over = wrap

	rts



; EOF
