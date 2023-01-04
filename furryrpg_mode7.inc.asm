;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MODE7 HANDLER ***
;
;==========================================================================================



TestMode7:
	.ACCU 8
	.INDEX 16

	lda	#$80							; enter forced blank
	sta	RAM_INIDISP
	stz	<DP2.HDMA_Channels					; disable HDMA
	wai								; wait for OAM to refresh

	DisableIRQs

	.IFNDEF PrecalcMode7Tables
		stz	WMADDL						; set WRAM address to $7F0000
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

		pea	$0000						; high word of 32-bit dividend
		pea	$8800						; low word of 32-bit dividend
	--	pea	$0020						; 16-bit divisor
	-	jsr	Div32by16

		Accu8

		lda	<DP2.Temp+4					; location of quotient
		sta	WMDATA
		lda	<DP2.Temp+5
		sta	WMDATA

		Accu16

		pla							; divisor += 4
		clc
		adc	#4
		cmp	#$0280
		bcs	+
		pha
		bra	-

	+	pla							; dividend += $800
		clc
		adc	#$0800
		bcc	+
		plx
		inx
		cpx	#4
		beq	++
		phx							; push high word of dividend
	+	pha							; push low word of dividend
	;	pea	$0020						; push initial divisor
		bra	--


	++	phx
		pha
		pea	$0020						; 16-bit divisor
	-	jsr	Div32by16

		Accu8

		lda	<DP2.Temp+4					; location of quotient
		sta	WMDATA
		lda	<DP2.Temp+5
		sta	WMDATA

		Accu16

		pla							; divisor += 4
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

	DMA_CH0 $02, SRC_IoTmappal, CGDATA, 512



; Load Mode 7 character data
; ############################### FOR PIC2MODE7'S GFX OUTPUT
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#$0000							; set VRAM address $0000
	stx	VMADDL

	DMA_CH0 $01, SRC_IoTmappic, VMDATAL, 32768
; ##########################################################



; ############################### FOR GFX2SNES'/PCX2SNES' OUTPUT
;	stz	VMAIN							; increment VRAM address by 1 after writing to $2118
;	ldx	#$0000							; set VRAM address $0000
;	stx	VMADDL

;	DMA_CH0 $00, SRC_Maptilemap, VMDATAL, _sizeof_SRC_Maptilemap

;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	VMAIN
;	ldx	#$0000							; set VRAM address $0000
;	stx	VMADDL

;	DMA_CH0 $00, SRC_Mappic, VMDATAH, _sizeof_SRC_Mappic
; ##############################################################

.ENDASM

; load GFX data for rotating sky above Mode 7 world

	ldx	#$4000							; set VRAM address $4000
	stx	VMADDL

	DMA_CH0 $01, SRC_Mode7_Sky, VMDATAL, _sizeof_SRC_Mode7_Sky

	ldx	#$5800							; set VRAM address $5800
	stx	VMADDL

	DMA_CH0 $01, SRC_TileMap_Mode7_Sky, VMDATAL, _sizeof_SRC_TileMap_Mode7_Sky

	stz	CGADD							; reset CGRAM address

	DMA_CH0 $02, SRC_Palette_Mode7_Sky, CGDATA, 32

.ASM



; Load HUD font
	ResetSprites

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	VMAIN
	ldx	#VRAM_Sprites						; set VRAM address for sprite tiles
	stx	VMADDL

	DMA_CH0 $01, SRC_Sprites_HUDfont, VMDATAL, 4096



.ENDASM

; Load cloud sprites
	DMA_CH0 $01, SRC_Sprites_Clouds, VMDATAL, 2048

	lda	#$A0							; start at 3rd sprite color
	sta	CGADD

	DMA_CH0 $02, SRC_Palette_Clouds, CGDATA, 32



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

	DMA_CH0 $00, SRC_HDMA_Mode7Sky72, WMDATA, _sizeof_SRC_HDMA_Mode7Sky72



; Set (PPU shadow) registers
	lda	#$58							; VRAM address for BG2 tilemap: $5800, size: 32×32 tiles
	sta	RAM_BG2SC
	lda	#$40							; VRAM address for BG2 character data: $4000 (ignore BG1 bits)
	sta	RAM_BG12NBA
	lda	#$01|$08						; BG Mode 1 for sky, BG3 priority (Mode 7 is switched to via IRQ)
	sta	RAM_BGMODE
;	lda	#%00010010						; turn on BG2 (for rotating sky above Mode 7 world) and sprites
	lda	#%00010000						; turn on sprites only
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
	SetNMI	kNMI_Mode7

	Accu16

	lda	#220							; dot number for interrupt (256 = too late, 204 = too early)
	sta	HTIMEL
	lda	#kMode7SkyLines						; scanline number for interrupt
	sta	VTIMEL

	Accu8

	SetIRQ	kVIRQ_Mode7

	lda	#%11111100						; enable HDMA channels 2-7
	sta	<DP2.HDMA_Channels
	lda	RDNMI							; clear NMI flag
	lda	#%10110001						; enable NMI, auto-joypad read, and IRQ at H=HTIMEL and V=VTIMEL
	sta	LO8.NMITIMEN
	sta	NMITIMEN
	cli
	jsr	ResetMode7Matrix

	WaitFrames	1						; wait for altitude setting to take effect

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
	jsr	(PTR_EffectTypes, x)

Mode7Loop:
;	PrintSpriteText	25, 22, "V-Line: $", 1
;	PrintSpriteHexNum	<DP2.Temp+7

	PrintSpriteText	25, 20, "Altitude: $", 1
	PrintSpriteHexNum	<DP2.Mode7_Altitude

;	PrintSpriteText	23, 22, "Angle: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_RotAngle

;	PrintSpriteText	25, 18, "Center-X: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_CenterCoordX+1
;	PrintSpriteHexNum	<DP2.Mode7_CenterCoordX

;	PrintSpriteText	24, 21, "ScrX: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetX+1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetX

;	PrintSpriteText	25, 21, "ScrY: $", 1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetY+1
;	PrintSpriteHexNum	<DP2.Mode7_ScrollOffsetY

	WaitFrames	1						; don't use WAI here as IRQ is enabled



; Check for dpad up+left
	lda	<DP2.Joy1Press+1
	and	#%00001010
	cmp	#%00001010
	bne	@DpadUpLeftDone
	dec	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	inc	a
	cmp	#112
	bcc	+
	lda	#111
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	jmp	@SkipDpad						; skip additional d-pad checks (no more than 2 directions allowed)

@DpadUpLeftDone:



; Check for dpad up+right
	lda	<DP2.Joy1Press+1
	and	#%00001001
	cmp	#%00001001
	bne	@DpadUpRightDone
	inc	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	inc	a
	cmp	#112
	bcc	+
	lda	#111
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	@SkipDpad

@DpadUpRightDone:



; Check for dpad down+left
	lda	<DP2.Joy1Press+1
	and	#%00000110
	cmp	#%00000110
	bne	@DpadDownLeftDone
	dec	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	dec	a
	bpl	+
	lda	#0
+	sta	<DP2.Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	@SkipDpad

@DpadDownLeftDone:



; Check for dpad down+right
	lda	<DP2.Joy1Press+1
	and	#%00000101
	cmp	#%00000101
	bne	@DpadDownRightDone
	inc	<DP2.Mode7_RotAngle
	lda	<DP2.Mode7_Altitude
	dec	a
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
	inc	a
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
	dec	a
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
	jsr	(PTR_EffectTypes, x)

	lda	#%00110000						; clear IRQ enable bits
	trb	LO8.NMITIMEN

;	jsr	SpriteInit						; purge OAM

;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	VMAIN
;	stz	VMADDL							; reset VRAM address
;	stz	VMADDH

;	DMA_CH0 $09, SRC_Zeroes, VMDATAL, 0				; clear VRAM // no, not with NMI enabled

	jml	DebugMenu

@StartButtonDone:



; Check for Select
	lda	<DP2.Joy1New+1
	and	#kButtonSel
	beq	@SelButtonDone
	jsr	ResetMode7Matrix

	WaitFrames	1						; wait for altitude setting to take effect

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
	lda.l	SRC_CosineTable, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
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
	lda.l	SRC_CosineTable, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
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
	inc	a
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
	lda.l	SRC_SineTable, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
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
	lda.l	SRC_SineTable, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
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
	inc	a
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
	inc	a
	sta	LO8.HDMA_M7C+(kMode7SkyLines*2), x

	Accu8

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
	lda.l	SRC_CosineTable, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
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
	lda.l	SRC_CosineTable, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
+	sta	WRMPYB
	tyx								; restore X // 2 cycles

	Accu16								; 3

	lda	RDMPYL							; 3 // store final result
	clc
	adc	<DP2.Temp+1
	bit	<DP2.Temp+5						; check for multiplier sign
	bpl	+
	eor	#$FFFF							; multiplier was negative, so make final result negative
	inc	a
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
	lda.l	SRC_SineTable, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
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
	lda.l	SRC_SineTable, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
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
	inc	a
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
	inc	a
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

	and	#$003F							; remove garbage in high byte, make sure angle in low byte doesn't exceed max. index ($20)
	dec	a
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetX
	jmp	(@XDecByAngle, x)



@XDecByAngle:
	.DW @DecX1, @DecX2, @DecX3, @DecX4, @DecX5, @DecX6, @DecX7, @DecX8, @DecX9, @DecX10, @DecX11, @DecX12, @DecX13, @DecX14, @DecX15, @DecX16, @DecX17, @DecX18, @DecX19, @DecX20, @DecX21, @DecX22, @DecX23, @DecX24, @DecX25, @DecX26, @DecX27, @DecX28, @DecX29, @DecX30, @DecX31, @DecX32

@DecX32:
	dec	a

@DecX31:
	dec	a

@DecX30:
	dec	a

@DecX29:
	dec	a

@DecX28:
	dec	a

@DecX27:
	dec	a

@DecX26:
	dec	a

@DecX25:
	dec	a

@DecX24:
	dec	a

@DecX23:
	dec	a

@DecX22:
	dec	a

@DecX21:
	dec	a

@DecX20:
	dec	a

@DecX19:
	dec	a

@DecX18:
	dec	a

@DecX17:
	dec	a

@DecX16:
	dec	a

@DecX15:
	dec	a

@DecX14:
	dec	a

@DecX13:
	dec	a

@DecX12:
	dec	a

@DecX11:
	dec	a

@DecX10:
	dec	a

@DecX9:
	dec	a

@DecX8:
	dec	a

@DecX7:
	dec	a

@DecX6:
	dec	a

@DecX5:
	dec	a

@DecX4:
	dec	a

@DecX3:
	dec	a

@DecX2:
	dec	a

@DecX1:
	dec	a

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
	dec	a
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetX
	jmp	(@XIncByAngle, x)



@XIncByAngle:
	.DW @IncX1, @IncX2, @IncX3, @IncX4, @IncX5, @IncX6, @IncX7, @IncX8, @IncX9, @IncX10, @IncX11, @IncX12, @IncX13, @IncX14, @IncX15, @IncX16, @IncX17, @IncX18, @IncX19, @IncX20, @IncX21, @IncX22, @IncX23, @IncX24, @IncX25, @IncX26, @IncX27, @IncX28, @IncX29, @IncX30, @IncX31, @IncX32

@IncX32:
	inc	a

@IncX31:
	inc	a

@IncX30:
	inc	a

@IncX29:
	inc	a

@IncX28:
	inc	a

@IncX27:
	inc	a

@IncX26:
	inc	a

@IncX25:
	inc	a

@IncX24:
	inc	a

@IncX23:
	inc	a

@IncX22:
	inc	a

@IncX21:
	inc	a

@IncX20:
	inc	a

@IncX19:
	inc	a

@IncX18:
	inc	a

@IncX17:
	inc	a

@IncX16:
	inc	a

@IncX15:
	inc	a

@IncX14:
	inc	a

@IncX13:
	inc	a

@IncX12:
	inc	a

@IncX11:
	inc	a

@IncX10:
	inc	a

@IncX9:
	inc	a

@IncX8:
	inc	a

@IncX7:
	inc	a

@IncX6:
	inc	a

@IncX5:
	inc	a

@IncX4:
	inc	a

@IncX3:
	inc	a

@IncX2:
	inc	a

@IncX1:
	inc	a

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
	dec	a
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetY
	jmp	(@YDecByAngle, x)



@YDecByAngle:
	.DW @DecY1, @DecY2, @DecY3, @DecY4, @DecY5, @DecY6, @DecY7, @DecY8, @DecY9, @DecY10, @DecY11, @DecY12, @DecY13, @DecY14, @DecY15, @DecY16, @DecY17, @DecY18, @DecY19, @DecY20, @DecY21, @DecY22, @DecY23, @DecY24, @DecY25, @DecY26, @DecY27, @DecY28, @DecY29, @DecY30, @DecY31, @DecY32

@DecY32:
	dec	a

@DecY31:
	dec	a

@DecY30:
	dec	a

@DecY29:
	dec	a

@DecY28:
	dec	a

@DecY27:
	dec	a

@DecY26:
	dec	a

@DecY25:
	dec	a

@DecY24:
	dec	a

@DecY23:
	dec	a

@DecY22:
	dec	a

@DecY21:
	dec	a

@DecY20:
	dec	a

@DecY19:
	dec	a

@DecY18:
	dec	a

@DecY17:
	dec	a

@DecY16:
	dec	a

@DecY15:
	dec	a

@DecY14:
	dec	a

@DecY13:
	dec	a

@DecY12:
	dec	a

@DecY11:
	dec	a

@DecY10:
	dec	a

@DecY9:
	dec	a

@DecY8:
	dec	a

@DecY7:
	dec	a

@DecY6:
	dec	a

@DecY5:
	dec	a

@DecY4:
	dec	a

@DecY3:
	dec	a

@DecY2:
	dec	a

@DecY1:
	dec	a

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
	dec	a
	asl	a
	tax
	lda	<DP2.Mode7_ScrollOffsetY
	jmp	(@YIncByAngle, x)



@YIncByAngle:
	.DW @IncY1, @IncY2, @IncY3, @IncY4, @IncY5, @IncY6, @IncY7, @IncY8, @IncY9, @IncY10, @IncY11, @IncY12, @IncY13, @IncY14, @IncY15, @IncY16, @IncY17, @IncY18, @IncY19, @IncY20, @IncY21, @IncY22, @IncY23, @IncY24, @IncY25, @IncY26, @IncY27, @IncY28, @IncY29, @IncY30, @IncY31, @IncY32

@IncY32:
	inc	a

@IncY31:
	inc	a

@IncY30:
	inc	a

@IncY29:
	inc	a

@IncY28:
	inc	a

@IncY27:
	inc	a

@IncY26:
	inc	a

@IncY25:
	inc	a

@IncY24:
	inc	a

@IncY23:
	inc	a

@IncY22:
	inc	a

@IncY21:
	inc	a

@IncY20:
	inc	a

@IncY19:
	inc	a

@IncY18:
	inc	a

@IncY17:
	inc	a

@IncY16:
	inc	a

@IncY15:
	inc	a

@IncY14:
	inc	a

@IncY13:
	inc	a

@IncY12:
	inc	a

@IncY11:
	inc	a

@IncY10:
	inc	a

@IncY9:
	inc	a

@IncY8:
	inc	a

@IncY7:
	inc	a

@IncY6:
	inc	a

@IncY5:
	inc	a

@IncY4:
	inc	a

@IncY3:
	inc	a

@IncY2:
	inc	a

@IncY1:
	inc	a

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



; ******************************** EOF *********************************
