;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** MODE7 HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

TestMode7:
	lda #$80				; INIDISP (Display Control 1): forced blank
	sta $2100

	stz DP_HDMAchannels			; disable HDMA

	wai					; wait for OAM to refresh

	DisableInterrupts



; -------------------------- HDMA channel 4: Mode 7 A
	lda #$42				; transfer mode (2 bytes --> $211B), indirect table mode
	sta $4340

	lda #$1B				; PPU reg. $211B
	sta $4341

	ldx #SRC_HDMA_M7A
	stx $4342

	lda #:SRC_HDMA_M7A
	sta $4344

	lda #$7E				; indirect HDMA CPU bus data address bank
	sta $4347



; -------------------------- HDMA channel 5: Mode 7 B
	lda #$42				; transfer mode (2 bytes --> $211C), indirect table mode
	sta $4350

	lda #$1C				; PPU reg. $211C
	sta $4351

	ldx #SRC_HDMA_M7B
	stx $4352

	lda #:SRC_HDMA_M7B
	sta $4354

	lda #$7E				; indirect HDMA CPU bus data address bank
	sta $4357



; -------------------------- HDMA channel 6: Mode 7 C
	lda #$42				; transfer mode (2 bytes --> $211D), indirect table mode
	sta $4360

	lda #$1D				; PPU reg. $211D
	sta $4361

	ldx #SRC_HDMA_M7C
	stx $4362

	lda #:SRC_HDMA_M7C
	sta $4364

	lda #$7E				; indirect HDMA CPU bus data address bank
	sta $4367



; -------------------------- HDMA channel 7: Mode 7 D
	lda #$42				; transfer mode (2 bytes --> $211E), indirect table mode
	sta $4370

	lda #$1E				; PPU reg. $211E
	sta $4371

	ldx #SRC_HDMA_M7D
	stx $4372

	lda #:SRC_HDMA_M7D
	sta $4374

	lda #$7E				; indirect HDMA CPU bus data address bank
	sta $4377



; -------------------------- load Mode 7 palette
	stz $2121				; start at color 0

	DMA_CH0 $02, :SRC_Sommappal, SRC_Sommappal, $22, 512
;	DMA_CH0 $02, :SRC_Mappal, SRC_Mappal, $22, $0200



; -------------------------- load Mode 7 character data
; ############################### FOR PIC2MODE7'S GFX OUTPUT
	lda #$80				; VRAM address increment mode: increment address after high byte access
	sta $2115

	ldx #$0000				; set VRAM address $0000
	stx $2116

	DMA_CH0 $01, :GFX_Sommappic, GFX_Sommappic, $18, 32768 ;$0000
; ##########################################################



; ############################### FOR GFX2SNES'/PCX2SNES' OUTPUT
;	lda #$00				; VRAM address increment mode: increment address after low byte access
;	sta $2115

;	ldx #$0000				; set VRAM address $0000
;	stx $2116

;	DMA_CH0 $00, :SRC_Maptilemap, SRC_Maptilemap, $18, SRC_Maptilemap_END - SRC_Maptilemap

;	lda #$80				; VRAM address increment mode: increment address after high byte access
;	sta $2115

;	ldx #$0000				; set VRAM address $0000
;	stx $2116

;	DMA_CH0 $00, :GFX_Mappic, GFX_Mappic, $19, GFX_Mappic_END - GFX_Mappic
; ##############################################################



; -------------------------- clear char sprite
;	ldx #0

;-	stz SpriteBuf1.PlayableChar, x
;	inx
;	inx
;	cpx #24
;	bne -

	jsr SpriteInit



; -------------------------- load font & cloud sprites
	lda #$80				; VRAM address increment mode: increment address after high byte access
	sta $2115

	ldx #ADDR_VRAM_SPR_Tiles		; set VRAM address for sprite tiles
	stx $2116

	DMA_CH0 $01, :GFX_Sprites_Smallfont, GFX_Sprites_Smallfont, $18, 4096
	DMA_CH0 $01, :GFX_Sprites_Clouds, GFX_Sprites_Clouds, $18, 2048

	lda #$A0				; start at 3rd sprite color
	sta $2121

	DMA_CH0 $02, :SRC_Palette_Clouds, SRC_Palette_Clouds, $22, 32



.ENDASM

; -------------------------- write cloud tilemap
	A16

	lda #$1870				; Y, X start values of upper left corner of 128×32 GFX
	sta temp

	lda #$3480				; tile properties (highest priority, fixed), tile num (start value)
	sta temp+2

	ldx #$0000

-	lda temp				; Y, X
	sta SpriteBuf1.Reserved, x
	clc
	adc #$0010				; X += 16
	sta temp
	inx
	inx

	lda temp+2				; tile properties, tile num
	sta SpriteBuf1.Reserved, x
	clc
	adc #$0002				; tile num += 2
	sta temp+2
	inx
	inx

	bit #$000F				; check if last 4 bits of tile num clear = one row of 8 (large) sprites done?
	bne -					; "inner loop"

	lda temp
	and #$FF70				; reset X = 8
	clc
	adc #$1000				; Y += 16
	sta temp

	lda temp+2
	clc
	adc #$0010				; tile num += 16 (i.e., skip one row of 8*8 tiles)
	sta temp+2

	cpx #$40				; 16 large sprites done?
	bne -					; "outer loop"

	A8

	stz temp+2				; see Mode 7 matrix calculations below



; -------------------------- set transparency for clouds
	A16

	lda #%0001000000000001			; turn on BG1 on mainscreen only, sprites on subscreen
	sta DP_Shadow_TSTM
	sta $212C

	A8

;	stz $2121
;	stz $2122
;	stz $2122

	lda #$E0				; subscreen backdrop color
	sta $2132
	sta $2132

	lda #%0000010				; enable BGs/OBJs on subscreen
	sta $2130

	lda #%01000001				; enable color math on BG1, add subscreen and div by 2
	sta $2131

.ASM



; -------------------------- load sky backdrop gradient
	ldx #(ARRAY_HDMA_BackgrPlayfield & $FFFF)	; set WRAM address to text box HDMA background
	stx $2181
	stz $2183

	DMA_CH0 $00, :SRC_HDMA_Mode7Sky72, SRC_HDMA_Mode7Sky72, $80, SRC_HDMA_Mode7Sky72_END - SRC_HDMA_Mode7Sky72



; -------------------------- load horizon blur
	ldx #$0000

-	lda.l SRC_HDMA_ColMathMode7, x
	sta ARRAY_HDMA_ColorMath, x

	inx
	cpx #SRC_HDMA_ColMathMode7_End-SRC_HDMA_ColMathMode7
	bne -

	lda #%00000000				; clear color math disable bits (4-5)
	sta $2130

	lda #%00110111				; enable color math on BG1/2/3 + sprites + backdrop
	sta $2131



; -------------------------- set new NMI/IRQ vectors & screen parameters
	SetVblankRoutine TBL_NMI_Mode7

	A16

	lda #220				; dot number for interrupt (256 = too late, 204 = too early)
	sta $4207

	lda #PARAM_MODE7_SKY_LINES		; scanline number for interrupt
	sta $4209

	A8

	SetIRQRoutine TBL_VIRQ_Mode7

	lda REG_RDNMI				; clear NMI flag, this is necessary to prevent occasional graphics glitches (see Fullsnes, 4210h/RDNMI)

	lda #%10110001				; enable NMI, auto-joypad read, and IRQ at H=$4207 and V=$4209
	sta DP_Shadow_NMITIMEN
	sta REG_NMITIMEN

	cli

	lda #%11111100				; enable HDMA channels 2-7
	sta DP_HDMAchannels

	jsr ResetMode7Matrix

	WaitForFrames 2				; wait for altitude setting to take effect (FIXME, doesn't work with just 1 frame?!)

	A16

	stz temp				; clear temp vars (used in CalcMode7Matrix)
	stz temp+2
	stz temp+4
	stz temp+6

	A8

	jsr CalcMode7Matrix

	lda #CMD_EffectSpeed3
	sta DP_EffectSpeed

	jsr EffectHSplitIn



Mode7Loop:
;	PrintSpriteText 25, 22, "V-Line: $", 1
;	PrintSpriteHexNum temp+7

;	PrintSpriteText 23, 22, "Angle: $", 1
;	PrintSpriteHexNum DP_Mode7_RotAngle

;	PrintSpriteText 25, 18, "Center-X: $", 1
;	PrintSpriteHexNum DP_Mode7_CenterCoordX+1
;	PrintSpriteHexNum DP_Mode7_CenterCoordX

;	PrintSpriteText 24, 21, "ScrX: $", 1
;	PrintSpriteHexNum DP_Mode7_ScrollOffsetX+1
;	PrintSpriteHexNum DP_Mode7_ScrollOffsetX

;	PrintSpriteText 25, 21, "ScrY: $", 1
;	PrintSpriteHexNum DP_Mode7_ScrollOffsetY+1
;	PrintSpriteHexNum DP_Mode7_ScrollOffsetY

	WaitForFrames 1				; don't use WAI here as IRQ is enabled

;-	lda REG_HVBJOY				; wait for start of Vblank
;	bpl -



; -------------------------- check for dpad up
	lda Joy1Press+1
	and #%00001000
	beq ++

	lda DP_Mode7_Altitude
	inc a
	cmp #128
	bcc +
	lda #127
+	sta DP_Mode7_Altitude

	jsr CalcMode7Matrix
++



; -------------------------- check for dpad down
	lda Joy1Press+1
	and #%00000100
	beq ++

	lda DP_Mode7_Altitude
	dec a
	bpl +
	lda #0
+	sta DP_Mode7_Altitude

	jsr CalcMode7Matrix
++



; -------------------------- check for dpad left
	lda Joy1Press+1
	and #%00000010
	beq +

	dec DP_Mode7_RotAngle

	jsr CalcMode7Matrix
+



; -------------------------- check for dpad right
	lda Joy1Press+1
	and #%00000001
	beq +

	inc DP_Mode7_RotAngle

	jsr CalcMode7Matrix
+



; -------------------------- check for L
	lda Joy1Press
	and #%00100000
	beq +

	dec DP_Mode7_RotAngle
	dec DP_Mode7_RotAngle

	jsr CalcMode7Matrix
+



; -------------------------- check for R
	lda Joy1Press
	and #%00010000
	beq +

	inc DP_Mode7_RotAngle
	inc DP_Mode7_RotAngle

	jsr CalcMode7Matrix
+



; -------------------------- check for A = fly forward
	lda Joy1Press
	and #%10000000
	beq ++

	lda DP_Mode7_RotAngle			; $00 < angle < $80 --> inc X
	beq __M7FlightY				; don't change X if angle = 0
	cmp #$80
	beq __M7FlightY				; don't change X if angle = 128 (eq. 180°)
	bcs +
	jsr M7FlightIncX
	bra __M7FlightY

+	jsr M7FlightDecX			; $80 < angle <= $FF --> dec X

__M7FlightY:
	lda DP_Mode7_RotAngle			; $40 < angle < $C0 --> inc Y
	cmp #$40
	beq ++					; don't change Y if angle = 64 (eq. 90°)
	bcc +
	cmp #$C0
	beq ++					; don't change Y if angle = 192 (eq. 270°)
	bcs +
	jsr M7FlightIncY
	bra ++

+	jsr M7FlightDecY			; $C0 < angle <= $FF | $00 < angle < $40 --> dec Y

++

.ENDASM

; -------------------------- check for B
	lda Joy1Press+1
	and #%10000000
	beq +

+



; -------------------------- check for X
	lda Joy1Press
	and #%01000000
	beq +

+



; -------------------------- check for Y
	lda Joy1Press+1
	and #%01000000
	beq +

+

.ASM

; -------------------------- check for Start
	lda Joy1New+1
	and #%00010000
	beq +

	lda #CMD_EffectSpeed3
	sta DP_EffectSpeed

	jsr EffectHSplitOut2
	jsr SpriteInit				; purge OAM

	ldx #(TileMapBG3 & $FFFF)		; clear text
	stx $2181
	stz $2183

	DMA_CH0 $08, :CONST_Zeroes, CONST_Zeroes, $80, 1024

	lda #$80				; VRAM address increment mode: increment address by one word
	sta $2115				; after accessing the high byte ($2119)

	stz $2116				; regs $2116-$2117: VRAM address
	stz $2117

	DMA_CH0 $09, :CONST_Zeroes, CONST_Zeroes, $18, 0	; clear VRAM

	jmp AreaEnter
+



; -------------------------- check for Select
	lda Joy1New+1
	and #%00100000
	beq +

	jsr ResetMode7Matrix

	WaitForFrames 1				; wait for altitude setting to take effect

	jsr CalcMode7Matrix
+



; -------------------------- show CPU load
	lda $2137				; latch H/V counter
	lda $213F				; reset OPHCT/OPVCT flip-flops

	lda $213D
	sta DP_CurrentScanline

	lda $213D
	and #$01				; mask off 7 open bus bits
	sta DP_CurrentScanline+1

	PrintSpriteText 25, 21, "V-line: $", 1
	PrintSpriteHexNum DP_CurrentScanline+1
	PrintSpriteHexNum DP_CurrentScanline

	jmp Mode7Loop



; -------------------------- calculate Mode 7 matrix parameters for next frame
CalcMode7Matrix:
	lda #:SRC_Mode7Scaling
	sta DP_Mode7_AltTabOffset+2



; This is the algorithm to do signed 8×16 bit multiplication using CPU multiplication registers:
; 1. do unsigned 8×8 bit multiplication for lower 8 bits of multiplicand, store 16-bit interim result in temp
; 2. do unsigned 8×8 bit multiplication for upper 8 bits of multiplicand, store 16-bit interim result in temp+3 (it's crucial that temp+2 remains $00)
; 3. combine interim results, keeping the upper 16 bits of the 24-bit result only (the lower 8 bits aren't needed by the Mode 7 matrix parameters)
;
; As CPU multiplication is unsigned, this is how the sign of the multiplier is accounted for:
; 1. if multiplier is positive, simply do the two 8×8 bit multiplications one by one, and do (temp+3)+(temp+1) for the end result
; 2. if multiplier is negative, make it positive first, then do the two 8×8 bit multiplications one by one, and do -(temp+3)-(temp+1) for the end result
;
; Proof of concept:
; Consider this multiplication:
; 17 * (-5) = -85
; Now make the multiplier positive, and store the two interim results:
; 7 * 5 = 35
; 10 * 5 = 50
; Now make the second result negative, and subtract the first one:
; (-50) - 35 = -85



; -------------------------- calculate M7A/M7D for next frame
; 8×8 multiplication for lower 8 bits of multiplicand
	ldx #0

-	stz temp+6

	txy

	lda [DP_Mode7_AltTabOffset], y
	sta $4202

	phx

	ldx DP_Mode7_RotAngle			; angle into X for indexing into the cos table

	lda.l SRC_Mode7Cos, x
	bpl +					; check for negative multiplier

	eor #$FF				; make multiplier positive
	inc a
	pha

	lda #$01				; remember that multplier has wrong sign
	sta temp+6

	pla
+	sta $4203

	plx					; 5 cycles

	A16					; 3

	lda $4216				; 3 // store interim result 1
	sta temp

	A8

; 8×8 multiplication for upper 8 bits of multiplicand
	iny

	lda [DP_Mode7_AltTabOffset], y
	sta $4202

	phx

	ldx DP_Mode7_RotAngle			; angle into X for indexing into the cos table

	lda.l SRC_Mode7Cos, x
	bpl +					; check for negative multiplier once again

	eor #$FF				; make multiplier positive
	inc a

+	sta $4203

	plx					; 5 cycles

	A16					; 3

	lda $4216				; 3 // store interim result 2
	sta temp+3

	A8

	lda temp+6				; check how to combine interim results due to sign of multiplier
	beq +

	A16

	lda temp+3				; end result negative, subtract (interim 1 >> 8) from negative interim 2
	eor #$FFFF
	inc a
	sec
	sbc temp+1

	bra ++

+	A16

	lda temp+3				; end result positive, add (interim 1 >> 8) to interim 2
	clc
	adc temp+1

++	sta ARRAY_HDMA_M7A+(PARAM_MODE7_SKY_LINES*2), x
	sta ARRAY_HDMA_M7D+(PARAM_MODE7_SKY_LINES*2), x

	A8

	inx
	inx
	cpx #448-(PARAM_MODE7_SKY_LINES*2)
	bne -



; -------------------------- calculate M7B/M7C for next frame
; 8×8 multiplication for lower 8 bits of multiplicand
	ldx #0

-	stz temp+6

	txy

	lda [DP_Mode7_AltTabOffset], y
	sta $4202

	phx

	ldx DP_Mode7_RotAngle			; angle into X for indexing into the sin table

	lda.l SRC_Mode7Sin, x
	bpl +					; check for negative multiplier

	eor #$FF				; make multiplier positive
	inc a
	pha

	lda #$01				; remember that multplier has wrong sign
	sta temp+6

	pla
+	sta $4203

	plx					; 5 cycles

	A16					; 3

	lda $4216				; 3 // store interim result 1
	sta temp

	A8

; 8×8 multiplication for upper 8 bits of multiplicand
	iny

	lda [DP_Mode7_AltTabOffset], y
	sta $4202

	phx

	ldx DP_Mode7_RotAngle			; angle into X for indexing into the sin table

	lda.l SRC_Mode7Sin, x
	bpl +					; check for negative multiplier once again

	eor #$FF				; make multiplier positive
	inc a

+	sta $4203

	plx					; 5 cycles

	A16					; 3

	lda $4216				; 3 // store interim result 2
	sta temp+3

	A8

	lda temp+6				; check how to combine interim results due to sign of multiplier
	beq +

	A16

	lda temp+3				; end result negative, subtract (interim 1 >> 8) from negative interim 2
	eor #$FFFF
	inc a
	sec
	sbc temp+1

	bra ++

+	A16

	lda temp+3				; end result positive, add (interim 1 >> 8) to interim 2
	clc
	adc temp+1

++	sta ARRAY_HDMA_M7C+(PARAM_MODE7_SKY_LINES*2), x
	eor #$FFFF				; make M7C parameter negative and store in M7B
	inc a
	sta ARRAY_HDMA_M7B+(PARAM_MODE7_SKY_LINES*2), x

	A8

	inx
	inx
	cpx #448-(PARAM_MODE7_SKY_LINES*2)
	bne -
rts



M7FlightDecX:					; expects angle in Accu
	cmp #$A0
	bcc __DoXDecByAngle

	cmp #$E1
	bcs +
	lda #$20
	bra __DoXDecByAngle

+	lda #$80
	sec
	sbc DP_Mode7_RotAngle

__DoXDecByAngle:
	A16

	and #$003F				; remove garbage in high byte, make sure angle in low byte doesn't exceed max. index ($20)
	dec a
	asl a
	tax

	lda DP_Mode7_ScrollOffsetX
	jmp (__XDecByAngle, x)



__XDecByAngle:
	.DW __DecX1, __DecX2, __DecX3, __DecX4, __DecX5, __DecX6, __DecX7, __DecX8, __DecX9, __DecX10, __DecX11, __DecX12, __DecX13, __DecX14, __DecX15, __DecX16, __DecX17, __DecX18, __DecX19, __DecX20, __DecX21, __DecX22, __DecX23, __DecX24, __DecX25, __DecX26, __DecX27, __DecX28, __DecX29, __DecX30, __DecX31, __DecX32

__DecX32:
	dec a

__DecX31:
	dec a

__DecX30:
	dec a

__DecX29:
	dec a

__DecX28:
	dec a

__DecX27:
	dec a

__DecX26:
	dec a

__DecX25:
	dec a

__DecX24:
	dec a

__DecX23:
	dec a

__DecX22:
	dec a

__DecX21:
	dec a

__DecX20:
	dec a

__DecX19:
	dec a

__DecX18:
	dec a

__DecX17:
	dec a

__DecX16:
	dec a

__DecX15:
	dec a

__DecX14:
	dec a

__DecX13:
	dec a

__DecX12:
	dec a

__DecX11:
	dec a

__DecX10:
	dec a

__DecX9:
	dec a

__DecX8:
	dec a

__DecX7:
	dec a

__DecX6:
	dec a

__DecX5:
	dec a

__DecX4:
	dec a

__DecX3:
	dec a

__DecX2:
	dec a

__DecX1:
	dec a

	and #$1FFF				; max scroll value (CHECKME)
	sta DP_Mode7_ScrollOffsetX
	clc					; add 128 pixels (half a scanline)
	adc #$0400
	sta DP_Mode7_CenterCoordX

	A8
rts



M7FlightIncX:					; expects angle in Accu
	cmp #$20
	bcc __DoXIncByAngle

	cmp #$61
	bcs +
	lda #$20
	bra __DoXIncByAngle

+	lda #$80
	sec
	sbc DP_Mode7_RotAngle

__DoXIncByAngle:
	A16

	and #$003F
	dec a
	asl a
	tax

	lda DP_Mode7_ScrollOffsetX
	jmp (__XIncByAngle, x)



__XIncByAngle:
	.DW __IncX1, __IncX2, __IncX3, __IncX4, __IncX5, __IncX6, __IncX7, __IncX8, __IncX9, __IncX10, __IncX11, __IncX12, __IncX13, __IncX14, __IncX15, __IncX16, __IncX17, __IncX18, __IncX19, __IncX20, __IncX21, __IncX22, __IncX23, __IncX24, __IncX25, __IncX26, __IncX27, __IncX28, __IncX29, __IncX30, __IncX31, __IncX32

__IncX32:
	inc a

__IncX31:
	inc a

__IncX30:
	inc a

__IncX29:
	inc a

__IncX28:
	inc a

__IncX27:
	inc a

__IncX26:
	inc a

__IncX25:
	inc a

__IncX24:
	inc a

__IncX23:
	inc a

__IncX22:
	inc a

__IncX21:
	inc a

__IncX20:
	inc a

__IncX19:
	inc a

__IncX18:
	inc a

__IncX17:
	inc a

__IncX16:
	inc a

__IncX15:
	inc a

__IncX14:
	inc a

__IncX13:
	inc a

__IncX12:
	inc a

__IncX11:
	inc a

__IncX10:
	inc a

__IncX9:
	inc a

__IncX8:
	inc a

__IncX7:
	inc a

__IncX6:
	inc a

__IncX5:
	inc a

__IncX4:
	inc a

__IncX3:
	inc a

__IncX2:
	inc a

__IncX1:
	inc a

	and #$1FFF				; max scroll value (CHECKME)
	sta DP_Mode7_ScrollOffsetX
	clc					; add 128 pixels (half a scanline)
	adc #$0400
	sta DP_Mode7_CenterCoordX

	A8
rts



M7FlightDecY:					; expects angle in Accu
	cmp #$40
	bcc +

	cmp #$E0
	bcc __DoYDecByAngle
	bra __DoYDecFull

+	cmp #$20
	bcs ++

__DoYDecFull:
	lda #$20
	bra __DoYDecByAngle

++	lda #$40
	sec
	sbc DP_Mode7_RotAngle

__DoYDecByAngle:
	A16

	and #$003F
	dec a
	asl a
	tax

	lda DP_Mode7_ScrollOffsetY
	jmp (__YDecByAngle, x)



__YDecByAngle:
	.DW __DecY1, __DecY2, __DecY3, __DecY4, __DecY5, __DecY6, __DecY7, __DecY8, __DecY9, __DecY10, __DecY11, __DecY12, __DecY13, __DecY14, __DecY15, __DecY16, __DecY17, __DecY18, __DecY19, __DecY20, __DecY21, __DecY22, __DecY23, __DecY24, __DecY25, __DecY26, __DecY27, __DecY28, __DecY29, __DecY30, __DecY31, __DecY32

__DecY32:
	dec a

__DecY31:
	dec a

__DecY30:
	dec a

__DecY29:
	dec a

__DecY28:
	dec a

__DecY27:
	dec a

__DecY26:
	dec a

__DecY25:
	dec a

__DecY24:
	dec a

__DecY23:
	dec a

__DecY22:
	dec a

__DecY21:
	dec a

__DecY20:
	dec a

__DecY19:
	dec a

__DecY18:
	dec a

__DecY17:
	dec a

__DecY16:
	dec a

__DecY15:
	dec a

__DecY14:
	dec a

__DecY13:
	dec a

__DecY12:
	dec a

__DecY11:
	dec a

__DecY10:
	dec a

__DecY9:
	dec a

__DecY8:
	dec a

__DecY7:
	dec a

__DecY6:
	dec a

__DecY5:
	dec a

__DecY4:
	dec a

__DecY3:
	dec a

__DecY2:
	dec a

__DecY1:
	dec a

	and #$1FFF				; max scroll value (CHECKME)
	sta DP_Mode7_ScrollOffsetY
	clc
	adc #$0400 + (PARAM_MODE7_SKY_LINES*8)
	sta DP_Mode7_CenterCoordY

	A8
rts



M7FlightIncY:					; expects angle in Accu
	cmp #$60
	bcc __DoYIncByAngle
	cmp #$A1
	bcs +
	lda #$20				; $60 <= angle <= $A0 --> increment Y by 32
	bra __DoYIncByAngle

+	lda #$C0
	sec
	sbc DP_Mode7_RotAngle

__DoYIncByAngle:
	A16

	and #$003F
	dec a
	asl a
	tax

	lda DP_Mode7_ScrollOffsetY
	jmp (__YIncByAngle, x)



__YIncByAngle:
	.DW __IncY1, __IncY2, __IncY3, __IncY4, __IncY5, __IncY6, __IncY7, __IncY8, __IncY9, __IncY10, __IncY11, __IncY12, __IncY13, __IncY14, __IncY15, __IncY16, __IncY17, __IncY18, __IncY19, __IncY20, __IncY21, __IncY22, __IncY23, __IncY24, __IncY25, __IncY26, __IncY27, __IncY28, __IncY29, __IncY30, __IncY31, __IncY32

__IncY32:
	inc a

__IncY31:
	inc a

__IncY30:
	inc a

__IncY29:
	inc a

__IncY28:
	inc a

__IncY27:
	inc a

__IncY26:
	inc a

__IncY25:
	inc a

__IncY24:
	inc a

__IncY23:
	inc a

__IncY22:
	inc a

__IncY21:
	inc a

__IncY20:
	inc a

__IncY19:
	inc a

__IncY18:
	inc a

__IncY17:
	inc a

__IncY16:
	inc a

__IncY15:
	inc a

__IncY14:
	inc a

__IncY13:
	inc a

__IncY12:
	inc a

__IncY11:
	inc a

__IncY10:
	inc a

__IncY9:
	inc a

__IncY8:
	inc a

__IncY7:
	inc a

__IncY6:
	inc a

__IncY5:
	inc a

__IncY4:
	inc a

__IncY3:
	inc a

__IncY2:
	inc a

__IncY1:
	inc a

	and #$1FFF				; max scroll value (CHECKME)
	sta DP_Mode7_ScrollOffsetY
	clc
	adc #$0400 + (PARAM_MODE7_SKY_LINES*8)
	sta DP_Mode7_CenterCoordY

	A8
rts



ResetMode7Matrix:
	A16

	stz DP_Mode7_ScrollOffsetX
	stz DP_Mode7_ScrollOffsetY

	lda #$0400				; 16-bit values
	sta DP_Mode7_CenterCoordX

	lda #$0400 + (PARAM_MODE7_SKY_LINES*8)
	sta DP_Mode7_CenterCoordY

	A8

	lda #64
	sta DP_Mode7_Altitude
	stz DP_Mode7_RotAngle
	stz $211A				; M7SEL: no flipping, Screen Over = wrap
rts



; ******************************** EOF *********************************
