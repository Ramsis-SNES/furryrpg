;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MODE7 HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

TestMode7:
	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	stz	DP_HDMA_Channels					; disable HDMA
	wai								; wait for OAM to refresh

	DisableIRQs

.IFNDEF PrecalcMode7Tables
	stz	REG_WMADDL						; set WRAM address to $7F0000
	stz	REG_WMADDM
	lda	#$01
	sta	REG_WMADDH

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

	lda	temp+4							; location of quotient
	sta	REG_WMDATA
	lda	temp+5
	sta	REG_WMDATA

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

	lda	temp+4							; location of quotient
	sta	REG_WMDATA
	lda	temp+5
	sta	REG_WMDATA

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



; -------------------------- HDMA channel 3: color math
	lda	#$02							; transfer mode (2 bytes --> $2132)
	sta	$4330
	lda	#$32							; PPU register $2132 (color math subscreen backdrop color)
	sta	$4331
	ldx	#ARRAY_HDMA_ColorMath
	stx	$4332
	lda	#$7E							; table in WRAM expected
	sta	$4334



; -------------------------- HDMA channel 4: Mode 7 A
	lda	#$42							; transfer mode (2 bytes --> $211B), indirect table mode
	sta	$4340
	lda	#$1B							; PPU reg. $211B
	sta	$4341
	ldx	#SRC_HDMA_M7A
	stx	$4342
	lda	#:SRC_HDMA_M7A
	sta	$4344
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4347



; -------------------------- HDMA channel 5: Mode 7 B
	lda	#$42							; transfer mode (2 bytes --> $211C), indirect table mode
	sta	$4350
	lda	#$1C							; PPU reg. $211C
	sta	$4351
	ldx	#SRC_HDMA_M7B
	stx	$4352
	lda	#:SRC_HDMA_M7B
	sta	$4354
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4357



; -------------------------- HDMA channel 6: Mode 7 C
	lda	#$42							; transfer mode (2 bytes --> $211D), indirect table mode
	sta	$4360
	lda	#$1D							; PPU reg. $211D
	sta	$4361
	ldx	#SRC_HDMA_M7C
	stx	$4362
	lda	#:SRC_HDMA_M7C
	sta	$4364
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4367



; -------------------------- HDMA channel 7: Mode 7 D
	lda	#$42							; transfer mode (2 bytes --> $211E), indirect table mode
	sta	$4370
	lda	#$1E							; PPU reg. $211E
	sta	$4371
	ldx	#SRC_HDMA_M7D
	stx	$4372
	lda	#:SRC_HDMA_M7D
	sta	$4374
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4377



; -------------------------- load Mode 7 palette
	stz	REG_CGADD						; start at color 0

	DMA_CH0 $02, :SRC_IoTmappal, SRC_IoTmappal, $22, 512



; -------------------------- load Mode 7 character data
; ############################### FOR PIC2MODE7'S GFX OUTPUT
	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#$0000							; set VRAM address $0000
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_IoTmappic, GFX_IoTmappic, $18, 32768
; ##########################################################



; ############################### FOR GFX2SNES'/PCX2SNES' OUTPUT
;	stz	REG_VMAIN						; increment VRAM address by 1 after writing to $2118
;	ldx	#$0000							; set VRAM address $0000
;	stx	REG_VMADDL

;	DMA_CH0 $00, :SRC_Maptilemap, SRC_Maptilemap, $18, SRC_Maptilemap_END - SRC_Maptilemap

;	lda	#$80							; increment VRAM address by 1 after writing to $2119
;	sta	REG_VMAIN
;	ldx	#$0000							; set VRAM address $0000
;	stx	REG_VMADDL

;	DMA_CH0 $00, :GFX_Mappic, GFX_Mappic, $19, GFX_Mappic_END - GFX_Mappic
; ##############################################################


	lda	#$58							; BG2 tile map VRAM offset: $5800, Tile Map size: 32×32 tiles
	sta	REG_BG2SC
	lda	#$40							; BG2 character data VRAM offset: $4000 (ignore BG1 bits)
	sta	REG_BG12NBA
	ldx	#$4000							; set VRAM address $4000
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Mode7_Sky, GFX_Mode7_Sky, $18, _sizeof_GFX_Mode7_Sky

	ldx	#$5800							; set VRAM address $5800
	stx	REG_VMADDL

	DMA_CH0 $01, :SRC_TileMap_Mode7_Sky, SRC_TileMap_Mode7_Sky, $18, _sizeof_SRC_TileMap_Mode7_Sky

	stz	REG_CGADD						; reset CGRAM address

	DMA_CH0 $02, :SRC_Palette_Mode7_Sky, SRC_Palette_Mode7_Sky, $22, 32

	lda	#$FF							; scroll BG2 down by 1 px
	sta	REG_BG2VOFS
	stz	REG_BG2VOFS



; -------------------------- load HUD font
	jsr	SpriteInit						; purge OAM

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	ldx	#ADDR_VRAM_SpriteTiles					; set VRAM address for sprite tiles
	stx	REG_VMADDL

	DMA_CH0 $01, :GFX_Sprites_HUDfont, GFX_Sprites_HUDfont, $18, 4096



.ENDASM

; -------------------------- load cloud sprites
	DMA_CH0 $01, :GFX_Sprites_Clouds, GFX_Sprites_Clouds, $18, 2048

	lda	#$A0							; start at 3rd sprite color
	sta	REG_CGADD

	DMA_CH0 $02, :SRC_Palette_Clouds, SRC_Palette_Clouds, $22, 32



; -------------------------- write cloud tilemap
	Accu16

	lda	#$1870							; Y, X start values of upper left corner of 128×32 GFX
	sta	temp

	lda	#$3480							; tile properties (highest priority, fixed), tile num (start value)
	sta	temp+2

	ldx	#$0000
-	lda	temp							; Y, X
	sta	SpriteBuf1.Reserved, x
	clc
	adc	#$0010							; X += 16
	sta	temp
	inx
	inx

	lda	temp+2							; tile properties, tile num
	sta	SpriteBuf1.Reserved, x
	clc
	adc	#$0002							; tile num += 2
	sta	temp+2
	inx
	inx

	bit	#$000F							; check if last 4 bits of tile num clear = one row of 8 (large) sprites done?
	bne	-							; "inner loop"

	lda	temp
	and	#$FF70							; reset X = 8
	clc
	adc	#$1000							; Y += 16
	sta	temp
	lda	temp+2
	clc
	adc	#$0010							; tile num += 16 (i.e., skip one row of 8*8 tiles)
	sta	temp+2

	cpx	#$40							; 16 large sprites done?
	bne	-							; "outer loop"

	Accu8

	stz	temp+2							; see Mode 7 matrix calculations below



; -------------------------- set transparency for clouds
	Accu16

	lda	#%0001000000000001					; turn on BG1 on mainscreen only, sprites on subscreen
	sta	REG_TM
	sta	DP_Shadow_TSTM

	Accu8

	lda	#$E0							; subscreen backdrop color
	sta	REG_COLDATA
	sta	REG_COLDATA
	lda	#%0000010						; enable BGs/OBJs on subscreen
	sta	REG_CGWSEL
	lda	#%01000001						; enable color math on BG1, add subscreen and div by 2
	sta	REG_CGADSUB

.ASM



; -------------------------- load sky backdrop gradient
	ldx	#(ARRAY_HDMA_BackgrPlayfield & $FFFF)			; set WRAM address to text box HDMA background
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $00, :SRC_HDMA_Mode7Sky72, SRC_HDMA_Mode7Sky72, $80, _sizeof_SRC_HDMA_Mode7Sky72



; -------------------------- load horizon blur
	ldx	#$0000
-	lda.l	SRC_HDMA_ColMathMode7, x
	sta	ARRAY_HDMA_ColorMath, x
	inx
	cpx	#_sizeof_SRC_HDMA_ColMathMode7
	bne	-

	lda	#%00000000						; clear color math disable bits (4-5)
	sta	REG_CGWSEL
	lda	#%00110111						; enable color math on BG1/2/3 + sprites + backdrop
	sta	REG_CGADSUB



; -------------------------- set new NMI/IRQ vectors & screen parameters
	SetNMI	TBL_NMI_Mode7

	Accu16

	lda	#220							; dot number for interrupt (256 = too late, 204 = too early)
	sta	REG_HTIMEL
	lda	#PARAM_Mode7SkyLines					; scanline number for interrupt
	sta	REG_VTIMEL

	Accu8

	SetIRQ	TBL_VIRQ_Mode7

	lda	#%11111100						; enable HDMA channels 2-7
	sta	DP_HDMA_Channels
	lda	REG_RDNMI						; clear NMI flag
	lda	#%10110001						; enable NMI, auto-joypad read, and IRQ at H=HTIMEL and V=VTIMEL
	sta	DP_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli
	jsr	ResetMode7Matrix

	WaitFrames	2						; wait for altitude setting to take effect (FIXME, doesn't work with just 1 frame?!)

	Accu16

	stz	temp							; clear temp vars (used in CalcMode7Matrix)
	stz	temp+2
	stz	temp+4
	stz	temp+6

	Accu8

	jsr	CalcMode7Matrix

	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitIn



Mode7Loop:
;	PrintSpriteText	25, 22, "V-Line: $", 1
;	PrintSpriteHexNum	temp+7

	PrintSpriteText	25, 20, "Altitude: $", 1
	PrintSpriteHexNum	DP_Mode7_Altitude

;	PrintSpriteText	23, 22, "Angle: $", 1
;	PrintSpriteHexNum	DP_Mode7_RotAngle

;	PrintSpriteText	25, 18, "Center-X: $", 1
;	PrintSpriteHexNum	DP_Mode7_CenterCoordX+1
;	PrintSpriteHexNum	DP_Mode7_CenterCoordX

;	PrintSpriteText	24, 21, "ScrX: $", 1
;	PrintSpriteHexNum	DP_Mode7_ScrollOffsetX+1
;	PrintSpriteHexNum	DP_Mode7_ScrollOffsetX

;	PrintSpriteText	25, 21, "ScrY: $", 1
;	PrintSpriteHexNum	DP_Mode7_ScrollOffsetY+1
;	PrintSpriteHexNum	DP_Mode7_ScrollOffsetY

	WaitFrames	1						; don't use WAI here as IRQ is enabled



; -------------------------- check for dpad up+left
	lda	DP_Joy1Press+1
	and	#%00001010
	cmp	#%00001010
	bne	++
	dec	DP_Mode7_RotAngle
	lda	DP_Mode7_Altitude
	inc	a
	cmp	#112
	bcc	+
	lda	#111
+	sta	DP_Mode7_Altitude
	jsr	CalcMode7Matrix

	jmp	__M7SkipDpad						; skip additional d-pad checks (no more than 2 directions allowed)
++



; -------------------------- check for dpad up+right
	lda	DP_Joy1Press+1
	and	#%00001001
	cmp	#%00001001
	bne	++
	inc	DP_Mode7_RotAngle
	lda	DP_Mode7_Altitude
	inc	a
	cmp	#112
	bcc	+
	lda	#111
+	sta	DP_Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	__M7SkipDpad
++



; -------------------------- check for dpad down+left
	lda	DP_Joy1Press+1
	and	#%00000110
	cmp	#%00000110
	bne	++
	dec	DP_Mode7_RotAngle
	lda	DP_Mode7_Altitude
	dec	a
	bpl	+
	lda	#0
+	sta	DP_Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	__M7SkipDpad
++



; -------------------------- check for dpad down+right
	lda	DP_Joy1Press+1
	and	#%00000101
	cmp	#%00000101
	bne	++
	inc	DP_Mode7_RotAngle
	lda	DP_Mode7_Altitude
	dec	a
	bpl	+
	lda	#0
+	sta	DP_Mode7_Altitude
	jsr	CalcMode7Matrix

	bra	__M7SkipDpad
++



; -------------------------- check for dpad up
	lda	DP_Joy1Press+1
	and	#%00001000
	beq	++
	lda	DP_Mode7_Altitude
	inc	a
	cmp	#112
	bcc	+
	lda	#111
+	sta	DP_Mode7_Altitude
	jsr	CalcMode7Matrix
++



; -------------------------- check for dpad down
	lda	DP_Joy1Press+1
	and	#%00000100
	beq	++
	lda	DP_Mode7_Altitude
	dec	a
	bpl	+
	lda	#0
+	sta	DP_Mode7_Altitude
	jsr	CalcMode7Matrix
++



; -------------------------- check for dpad left
	lda	DP_Joy1Press+1
	and	#%00000010
	beq	+
	lda	DP_Mode7_BG2HScroll
	sec
	sbc	#5
	sta	DP_Mode7_BG2HScroll
	dec	DP_Mode7_RotAngle
	jsr	CalcMode7Matrix
+



; -------------------------- check for dpad right
	lda	DP_Joy1Press+1
	and	#%00000001
	beq	+
	lda	DP_Mode7_BG2HScroll
	clc
	adc	#5
	sta	DP_Mode7_BG2HScroll
	inc	DP_Mode7_RotAngle
	jsr	CalcMode7Matrix
+



__M7SkipDpad:



; -------------------------- check for L
	lda	DP_Joy1Press
	and	#%00100000
	beq	+
	dec	DP_Mode7_RotAngle
	dec	DP_Mode7_RotAngle
	jsr	CalcMode7Matrix
+



; -------------------------- check for R
	lda	DP_Joy1Press
	and	#%00010000
	beq	+
	inc	DP_Mode7_RotAngle
	inc	DP_Mode7_RotAngle
	jsr	CalcMode7Matrix
+



; -------------------------- check for A = fly forward
	lda	DP_Joy1Press
	and	#%10000000
	beq	++
	lda	DP_Mode7_RotAngle					; $00 < angle < $80 --> inc X
	beq	__M7FlightY						; don't change X if angle = 0
	cmp	#$80
	beq	__M7FlightY						; don't change X if angle = 128 (eq. 180°)
	bcs	+
	jsr	M7FlightIncX

	bra	__M7FlightY

+	jsr	M7FlightDecX						; $80 < angle <= $FF --> dec X

__M7FlightY:
	lda	DP_Mode7_RotAngle					; $40 < angle < $C0 --> inc Y
	cmp	#$40
	beq	++							; don't change Y if angle = 64 (eq. 90°)
	bcc	+
	cmp	#$C0
	beq	++							; don't change Y if angle = 192 (eq. 270°)
	bcs	+
	jsr	M7FlightIncY

	bra	++

+	jsr	M7FlightDecY						; $C0 < angle <= $FF | $00 < angle < $40 --> dec Y

++

.ENDASM

; -------------------------- check for B
	lda	DP_Joy1Press+1
	and	#%10000000
	beq	+

+



; -------------------------- check for X
	lda	DP_Joy1Press
	and	#%01000000
	beq	+

+



; -------------------------- check for Y
	lda	DP_Joy1Press+1
	and	#%01000000
	beq	+

+

.ASM

; -------------------------- check for Start
	lda	DP_Joy1New+1
	and	#%00010000
	beq	+
	lda	#CMD_EffectSpeed3
	sta	DP_EffectSpeed
	jsr	EffectHSplitOut2

	jsr	SpriteInit						; purge OAM

	ldx	#(ARRAY_BG3TileMap & $FFFF)				; clear text
	stx	REG_WMADDL
	stz	REG_WMADDH

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta	REG_VMAIN
	stz	REG_VMADDL						; reset VRAM address
	stz	REG_VMADDH

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0		; clear VRAM

	jml	DebugMenu
+



; -------------------------- check for Select
	lda	DP_Joy1New+1
	and	#%00100000
	beq	+
	jsr	ResetMode7Matrix

	WaitFrames	1						; wait for altitude setting to take effect

	jsr	CalcMode7Matrix
+

	jmp	Mode7Loop



; -------------------------- calculate Mode 7 matrix parameters for next frame

; This is the algorithm to do signed 8×16 bit multiplication required for Mode 7 registers using hardware multiplication:
; - do unsigned 8×8 bit multiplication for lower 8 bits of multiplicand (while keeping track of multiplier sign), store 16-bit interim result in temp
; - do unsigned 8×8 bit multiplication for upper 8 bits of multiplicand, add (interim result >> 8) and store as 16-bit final result (if multiplier sign was negative, make result negative)

.IFDEF PrecalcMode7Tables

CalcMode7Matrix:
	lda	#:SRC_Mode7Scaling
	sta	DP_DataBank



; -------------------------- calculate M7A/M7D for next frame
; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	temp+6
	txy
	lda	[DP_DataAddress], y
	sta	REG_WRMPYA

	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_Mode7Cos, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
	dec	temp+6							; remember that multplier has wrong sign
+	sta	REG_WRMPYB
	nop								; burn a few cycles
	nop
	ldx	REG_RDMPYL						; store interim result
	stx	temp

; 8×8 multiplication for upper 8 bits of multiplicand
	iny
	lda	[DP_DataAddress], y
	sta	REG_WRMPYA

	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_Mode7Cos, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
+	sta	REG_WRMPYB
	tyx
	dex								; make up for preceding iny

	Accu16								; 3 cycles

	lda	REG_RDMPYL						; 3 // store final result
	clc
	adc	temp+1
	bit	temp+5							; check for multiplier sign
	bpl	+
	eor	#$FFFF							; multiplier was negative, so make final result negative
	inc	a
+	sta	ARRAY_HDMA_M7A+(PARAM_Mode7SkyLines*2), x
	sta	ARRAY_HDMA_M7D+(PARAM_Mode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(PARAM_Mode7SkyLines*2)
	bne	-



; -------------------------- calculate M7B/M7C for next frame
; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	temp+6
	txy
	lda	[DP_DataAddress], y
	sta	REG_WRMPYA

	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_Mode7Sin, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
	dec	temp+6							; remember that multplier has wrong sign
+	sta	REG_WRMPYB
	nop								; burn a few cycles
	nop
	ldx	REG_RDMPYL						; store interim result
	stx	temp

; 8×8 multiplication for upper 8 bits of multiplicand
	iny
	lda	[DP_DataAddress], y
	sta	REG_WRMPYA

	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_Mode7Sin, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
+	sta	REG_WRMPYB
	tyx
	dex

	Accu16								; 3 cycles

	lda	REG_RDMPYL						; 3 // store final result
	clc
	adc	temp+1
	bit	temp+5							; check for multiplier sign
	bmi	+
	sta	ARRAY_HDMA_M7C+(PARAM_Mode7SkyLines*2), x
	eor	#$FFFF							; make M7C parameter negative and store in M7B
	inc	a
	sta	ARRAY_HDMA_M7B+(PARAM_Mode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(PARAM_Mode7SkyLines*2)
	bne	-
	rts

.ACCU 16

+	sta	ARRAY_HDMA_M7B+(PARAM_Mode7SkyLines*2), x		; multiplier was negative, store negative value first in M7B
	eor	#$FFFF							; make M7B parameter positive and store in M7C
	inc	a
	sta	ARRAY_HDMA_M7C+(PARAM_Mode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(PARAM_Mode7SkyLines*2)
	bne	-
	rts

.ELSE

CalcMode7Matrix:
	ldx	DP_DataAddress						; set WRAM address to beginning of table (based on current altitude, as set during Vblank)
	stx	REG_WMADDL
	lda	#$01
	sta	REG_WMADDH



; -------------------------- calculate M7A/M7D for next frame
; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	temp+6
	lda	REG_WMDATA						; read table entry
	sta	REG_WRMPYA
	txy								; preserve X in Y, this is faster than using the stack
	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_Mode7Cos, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
	dec	temp+6							; remember that multplier has wrong sign
+	sta	REG_WRMPYB
	nop								; burn a few cycles
	nop
	ldx	REG_RDMPYL						; store interim result
	stx	temp

; 8×8 multiplication for upper 8 bits of multiplicand
	lda	REG_WMDATA						; read table entry
	sta	REG_WRMPYA
	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the cos table
	lda.l	SRC_Mode7Cos, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
+	sta	REG_WRMPYB
	tyx								; restore X // 2 cycles

	Accu16								; 3

	lda	REG_RDMPYL						; 3 // store final result
	clc
	adc	temp+1
	bit	temp+5							; check for multiplier sign
	bpl	+
	eor	#$FFFF							; multiplier was negative, so make final result negative
	inc	a
+	sta	ARRAY_HDMA_M7A+(PARAM_Mode7SkyLines*2), x
	sta	ARRAY_HDMA_M7D+(PARAM_Mode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(PARAM_Mode7SkyLines*2)
	bne	-

	ldx	DP_DataAddress						; reset WRAM address to beginning of table
	stx	REG_WMADDL



; -------------------------- calculate M7B/M7C for next frame
; 8×8 multiplication for lower 8 bits of multiplicand
	ldx	#0
-	stz	temp+6
	lda	REG_WMDATA						; read table entry
	sta	REG_WRMPYA
	txy								; preserve X
	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_Mode7Sin, x
	bpl	+							; check for negative multiplier
	eor	#$FF							; make multiplier positive
	inc	a
	dec	temp+6							; remember that multplier has wrong sign
+	sta	REG_WRMPYB
	nop								; burn a few cycles
	nop
	ldx	REG_RDMPYL						; store interim result
	stx	temp

; 8×8 multiplication for upper 8 bits of multiplicand
	lda	REG_WMDATA						; read table entry
	sta	REG_WRMPYA
	ldx	DP_Mode7_RotAngle					; angle into X for indexing into the sin table
	lda.l	SRC_Mode7Sin, x
	bpl	+							; check for negative multiplier once again
	eor	#$FF							; make multiplier positive
	inc	a
+	sta	REG_WRMPYB
	tyx								; restore X // 2 cycles

	Accu16								; 3

	lda	REG_RDMPYL						; 3 // store final result
	clc
	adc	temp+1
	bit	temp+5							; check for multiplier sign
	bmi	+
	sta	ARRAY_HDMA_M7C+(PARAM_Mode7SkyLines*2), x
	eor	#$FFFF							; make M7C parameter negative and store in M7B
	inc	a
	sta	ARRAY_HDMA_M7B+(PARAM_Mode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(PARAM_Mode7SkyLines*2)
	bne	-
	rts

.ACCU 16

+	sta	ARRAY_HDMA_M7B+(PARAM_Mode7SkyLines*2), x		; multiplier was negative, store negative value first in M7B
	eor	#$FFFF							; make M7B parameter positive and store in M7C
	inc	a
	sta	ARRAY_HDMA_M7C+(PARAM_Mode7SkyLines*2), x

	Accu8

	inx
	inx
	cpx	#448-(PARAM_Mode7SkyLines*2)
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
	sta	temp+2
	lda	5, s							; low word of 32-bit dividend
	sta	temp+4
	lda	3, s							; 16-bit divisor
	sta	temp
	stz	temp+6							; clear 16-bit of temp storage

        SEC             ; Detect overflow or /0 condition.  To find out, sub-
        LDA     temp+2     ; tract divisor from hi cell of dividend; if C flag
        SBC     temp       ; remains set, divisor was not big enough to avoid
        BCS     uoflo   ; overflow.  This also takes care of any /0 conditions.
                        ; If branch not taken, C flag is left clear for 1st ROL.
                        ; We will loop 16x; but since we shift the dividend
        LDX     #17     ; over at the same time as shifting the answer in, the
                        ; operation must start AND finish with a shift of the
                        ; lo cell of the dividend (which ends up holding the
;       INDEX_16        ; quotient), so we start with 17 in X.  We will use Y
                        ; for temporary storage too, so set index reg.s 16-bit.
ushftl: ROL     temp+4     ; Move lo cell of dividend left one bit, also shifting
                        ; answer in.  The 1st rotation brings in a 0, which
        DEX             ; later gets pushed off the other end in the last
        BEQ     umend   ; rotation.     Branch to the end if finished.

        ROL     temp+2     ; Shift hi cell of dividend left one bit, also shifting
        LDA     #0      ; next bit in from high bit of lo cell.
        ROL     A
        STA     temp+6     ; Store old hi bit of dividend in N+6.

        SEC             ; See if divisor will fit into hi 17 bits of dividend
        LDA     temp+2     ; by subtracting and then looking at carry flag.
        SBC     temp       ; If carry got cleared, divisor did not fit.
        TAY             ; Save the difference in Y until we know if we need it.

        LDA     temp+6     ; Bit 0 of N+6 serves as 17th bit.
        SBC     #0      ; Complete the subtraction by doing the 17th bit before
        BCC     ushftl  ; determining if the divisor fit into the hi 17 bits of
                        ; the dividend.  If so, the C flag remains set.
        STY     temp+2     ; If divisor fit into hi 17 bits, update dividend hi
        BRA     ushftl  ; cell to what it would be after subtraction.    Branch.

 uoflo: LDA     #$FFFF  ; If an overflow or /0 condition occurs, put FFFF in
        STA     temp+4     ; both the quotient
        STA     temp+2     ; and the remainder.

 umend:
	rts
.ENDIF



.ACCU 8

M7FlightDecX:								; expects angle in Accu
	cmp	#$A0
	bcc	__DoXDecByAngle

	cmp	#$E1
	bcs	+
	lda	#$20
	bra	__DoXDecByAngle

+	lda	#$80
	sec
	sbc	DP_Mode7_RotAngle

__DoXDecByAngle:
	Accu16

	and	#$003F							; remove garbage in high byte, make sure angle in low byte doesn't exceed max. index ($20)
	dec	a
	asl	a
	tax
	lda	DP_Mode7_ScrollOffsetX
	jmp	(__XDecByAngle, x)



__XDecByAngle:
	.DW __DecX1, __DecX2, __DecX3, __DecX4, __DecX5, __DecX6, __DecX7, __DecX8, __DecX9, __DecX10, __DecX11, __DecX12, __DecX13, __DecX14, __DecX15, __DecX16, __DecX17, __DecX18, __DecX19, __DecX20, __DecX21, __DecX22, __DecX23, __DecX24, __DecX25, __DecX26, __DecX27, __DecX28, __DecX29, __DecX30, __DecX31, __DecX32

__DecX32:
	dec	a

__DecX31:
	dec	a

__DecX30:
	dec	a

__DecX29:
	dec	a

__DecX28:
	dec	a

__DecX27:
	dec	a

__DecX26:
	dec	a

__DecX25:
	dec	a

__DecX24:
	dec	a

__DecX23:
	dec	a

__DecX22:
	dec	a

__DecX21:
	dec	a

__DecX20:
	dec	a

__DecX19:
	dec	a

__DecX18:
	dec	a

__DecX17:
	dec	a

__DecX16:
	dec	a

__DecX15:
	dec	a

__DecX14:
	dec	a

__DecX13:
	dec	a

__DecX12:
	dec	a

__DecX11:
	dec	a

__DecX10:
	dec	a

__DecX9:
	dec	a

__DecX8:
	dec	a

__DecX7:
	dec	a

__DecX6:
	dec	a

__DecX5:
	dec	a

__DecX4:
	dec	a

__DecX3:
	dec	a

__DecX2:
	dec	a

__DecX1:
	dec	a

	and	#$1FFF							; max scroll value (CHECKME)
	sta	DP_Mode7_ScrollOffsetX
	clc								; add 128 pixels (half a scanline)
	adc	#$0400
	sta	DP_Mode7_CenterCoordX

	Accu8

	rts



M7FlightIncX:								; expects angle in Accu
	cmp	#$20
	bcc	__DoXIncByAngle

	cmp	#$61
	bcs	+
	lda	#$20
	bra	__DoXIncByAngle

+	lda	#$80
	sec
	sbc	DP_Mode7_RotAngle

__DoXIncByAngle:
	Accu16

	and	#$003F
	dec	a
	asl	a
	tax
	lda	DP_Mode7_ScrollOffsetX
	jmp	(__XIncByAngle, x)



__XIncByAngle:
	.DW __IncX1, __IncX2, __IncX3, __IncX4, __IncX5, __IncX6, __IncX7, __IncX8, __IncX9, __IncX10, __IncX11, __IncX12, __IncX13, __IncX14, __IncX15, __IncX16, __IncX17, __IncX18, __IncX19, __IncX20, __IncX21, __IncX22, __IncX23, __IncX24, __IncX25, __IncX26, __IncX27, __IncX28, __IncX29, __IncX30, __IncX31, __IncX32

__IncX32:
	inc	a

__IncX31:
	inc	a

__IncX30:
	inc	a

__IncX29:
	inc	a

__IncX28:
	inc	a

__IncX27:
	inc	a

__IncX26:
	inc	a

__IncX25:
	inc	a

__IncX24:
	inc	a

__IncX23:
	inc	a

__IncX22:
	inc	a

__IncX21:
	inc	a

__IncX20:
	inc	a

__IncX19:
	inc	a

__IncX18:
	inc	a

__IncX17:
	inc	a

__IncX16:
	inc	a

__IncX15:
	inc	a

__IncX14:
	inc	a

__IncX13:
	inc	a

__IncX12:
	inc	a

__IncX11:
	inc	a

__IncX10:
	inc	a

__IncX9:
	inc	a

__IncX8:
	inc	a

__IncX7:
	inc	a

__IncX6:
	inc	a

__IncX5:
	inc	a

__IncX4:
	inc	a

__IncX3:
	inc	a

__IncX2:
	inc	a

__IncX1:
	inc	a

	and	#$1FFF							; max scroll value (CHECKME)
	sta	DP_Mode7_ScrollOffsetX
	clc								; add 128 pixels (half a scanline)
	adc	#$0400
	sta	DP_Mode7_CenterCoordX

	Accu8

	rts



M7FlightDecY:								; expects angle in Accu
	cmp	#$40
	bcc	+
	cmp	#$E0
	bcc	__DoYDecByAngle
	bra	__DoYDecFull

+	cmp	#$20
	bcs	++

__DoYDecFull:
	lda	#$20
	bra	__DoYDecByAngle

++	lda	#$40
	sec
	sbc	DP_Mode7_RotAngle

__DoYDecByAngle:
	Accu16

	and	#$003F
	dec	a
	asl	a
	tax
	lda	DP_Mode7_ScrollOffsetY
	jmp	(__YDecByAngle, x)



__YDecByAngle:
	.DW __DecY1, __DecY2, __DecY3, __DecY4, __DecY5, __DecY6, __DecY7, __DecY8, __DecY9, __DecY10, __DecY11, __DecY12, __DecY13, __DecY14, __DecY15, __DecY16, __DecY17, __DecY18, __DecY19, __DecY20, __DecY21, __DecY22, __DecY23, __DecY24, __DecY25, __DecY26, __DecY27, __DecY28, __DecY29, __DecY30, __DecY31, __DecY32

__DecY32:
	dec	a

__DecY31:
	dec	a

__DecY30:
	dec	a

__DecY29:
	dec	a

__DecY28:
	dec	a

__DecY27:
	dec	a

__DecY26:
	dec	a

__DecY25:
	dec	a

__DecY24:
	dec	a

__DecY23:
	dec	a

__DecY22:
	dec	a

__DecY21:
	dec	a

__DecY20:
	dec	a

__DecY19:
	dec	a

__DecY18:
	dec	a

__DecY17:
	dec	a

__DecY16:
	dec	a

__DecY15:
	dec	a

__DecY14:
	dec	a

__DecY13:
	dec	a

__DecY12:
	dec	a

__DecY11:
	dec	a

__DecY10:
	dec	a

__DecY9:
	dec	a

__DecY8:
	dec	a

__DecY7:
	dec	a

__DecY6:
	dec	a

__DecY5:
	dec	a

__DecY4:
	dec	a

__DecY3:
	dec	a

__DecY2:
	dec	a

__DecY1:
	dec	a

	and	#$1FFF							; max scroll value (CHECKME)
	sta	DP_Mode7_ScrollOffsetY
	clc
	adc	#$0400 + (PARAM_Mode7SkyLines*8)
	sta	DP_Mode7_CenterCoordY

	Accu8

	rts



M7FlightIncY:								; expects angle in Accu
	cmp	#$60
	bcc	__DoYIncByAngle
	cmp	#$A1
	bcs	+
	lda	#$20							; $60 <= angle <= $A0 --> increment Y by 32
	bra	__DoYIncByAngle

+	lda	#$C0
	sec
	sbc	DP_Mode7_RotAngle

__DoYIncByAngle:
	Accu16

	and	#$003F
	dec	a
	asl	a
	tax
	lda	DP_Mode7_ScrollOffsetY
	jmp	(__YIncByAngle, x)



__YIncByAngle:
	.DW __IncY1, __IncY2, __IncY3, __IncY4, __IncY5, __IncY6, __IncY7, __IncY8, __IncY9, __IncY10, __IncY11, __IncY12, __IncY13, __IncY14, __IncY15, __IncY16, __IncY17, __IncY18, __IncY19, __IncY20, __IncY21, __IncY22, __IncY23, __IncY24, __IncY25, __IncY26, __IncY27, __IncY28, __IncY29, __IncY30, __IncY31, __IncY32

__IncY32:
	inc	a

__IncY31:
	inc	a

__IncY30:
	inc	a

__IncY29:
	inc	a

__IncY28:
	inc	a

__IncY27:
	inc	a

__IncY26:
	inc	a

__IncY25:
	inc	a

__IncY24:
	inc	a

__IncY23:
	inc	a

__IncY22:
	inc	a

__IncY21:
	inc	a

__IncY20:
	inc	a

__IncY19:
	inc	a

__IncY18:
	inc	a

__IncY17:
	inc	a

__IncY16:
	inc	a

__IncY15:
	inc	a

__IncY14:
	inc	a

__IncY13:
	inc	a

__IncY12:
	inc	a

__IncY11:
	inc	a

__IncY10:
	inc	a

__IncY9:
	inc	a

__IncY8:
	inc	a

__IncY7:
	inc	a

__IncY6:
	inc	a

__IncY5:
	inc	a

__IncY4:
	inc	a

__IncY3:
	inc	a

__IncY2:
	inc	a

__IncY1:
	inc	a

	and	#$1FFF							; max scroll value (CHECKME)
	sta	DP_Mode7_ScrollOffsetY
	clc
	adc	#$0400 + (PARAM_Mode7SkyLines*8)
	sta	DP_Mode7_CenterCoordY

	Accu8

	rts



ResetMode7Matrix:
	Accu16

	stz	DP_Mode7_ScrollOffsetX
	stz	DP_Mode7_ScrollOffsetY
	lda	#$0400							; 16-bit values
	sta	DP_Mode7_CenterCoordX
	lda	#$0400 + (PARAM_Mode7SkyLines*8)
	sta	DP_Mode7_CenterCoordY

	Accu8

	lda	#56
	sta	DP_Mode7_Altitude
	stz	DP_Mode7_RotAngle
	stz	REG_M7SEL						; M7SEL: no flipping, Screen Over = wrap
	rts



; ******************************** EOF *********************************
