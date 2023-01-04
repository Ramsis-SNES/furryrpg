;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** ON-SCREEN EFFECTS ***
;
;==========================================================================================



PTR_EffectTypes:							; order has to match table of effect types in lib_variables.asm
	.DW EffectFadeFromBlack
	.DW EffectFadeToBlack

	.IFNDEF WorkAroundINIDISP
		.DW EffectHSplitIn
		.DW EffectHSplitOut
		.DW EffectHSplitOut2
	.ELSE
		.DW EffectHSplitInWA
		.DW EffectHSplitOutWA
		.DW EffectHSplitOut2WA
	.ENDIF

	.DW EffectShutterIn
	.DW EffectShutterOut
	.DW EffectDiamondIn
	.DW EffectDiamondOut



; ************************* Fade from/to black *************************

EffectFadeFromBlack:
	.ACCU 8
	.INDEX 16

	lda	<DP2.EffectSpeed
	bmi	@Delay							; if speed value is negative, insert delay instead
	lda	#$00							; initial screen brightness

@SpeedLoop:
	sta	RAM_INIDISP
	ldx	<DP2.EffectSpeed					; use speed value to skip brightness values
-	inc	a
	cmp	#$0F							; prevent glitches due to speed values in event script that aren't divisors of 15, or completely pointless
	bcs	+
	dex
	bne	-

+	sta	RAM_INIDISP
	xba								; save current screen brightness in B
-	lda	HVBJOY							; wait 1 frame
	bpl	-

-	lda	HVBJOY
	bmi	-

	xba
	cmp	#$0F
	bne	@SpeedLoop

	bra	@Done

@Delay:
	eor	#$FF							; make speed value positive and use as delay value
	inc	a
	sta	<DP2.EffectSpeed
	lda	#$00							; initial screen brightness

@DelayLoop1:
	sta	RAM_INIDISP
	xba								; save current screen brightness in B
	ldx	<DP2.EffectSpeed					; use delay value to insert frames

@DelayLoop2:
-	lda	HVBJOY
	bpl	-

-	lda	HVBJOY
	bmi	-

	dex
	bne	@DelayLoop2

	xba								; increment screen brightness ...
	inc	a
	cmp	#$10							; ... until it's reached max value ($0F)
	bne	@DelayLoop1

@Done:

	rts



EffectFadeToBlack:
	lda	<DP2.EffectSpeed
	bmi	@FadeDelayToBlack					; if speed value is negative, insert delay instead
	lda	#$0F							; initial screen brightness

@SpeedLoop:
	sta	RAM_INIDISP
	ldx	<DP2.EffectSpeed					; use speed value to skip brightness values
-	dec	a
	beq	+							; prevent glitches due to invalid speed values in event script
	dex
	bne	-

+	sta	RAM_INIDISP
	xba								; save current screen brightness in B
-	lda	HVBJOY							; wait 1 frame
	bpl	-

-	lda	HVBJOY
	bmi	-

	xba
	bne	@SpeedLoop

	bra	@Done

@FadeDelayToBlack:
	eor	#$FF							; make speed value positive and use as delay value
	inc	a
	sta	<DP2.EffectSpeed
	lda	#$0F							; initial screen brightness

@DelayLoop1:
	sta	RAM_INIDISP
	xba								; save current screen brightness in B
	ldx	<DP2.EffectSpeed					; use delay value to insert frames

@DelayLoop2:
-	lda	HVBJOY
	bpl	-

-	lda	HVBJOY
	bmi	-

	dex
	bne	@DelayLoop2

	xba								; decrement screen brightness ...
	dec	a
	cmp	#$FF							; ... until it's reached zero
	bne	@DelayLoop1

@Done:

	rts



; ****************** Split horizontal in (from black) ******************

EffectHSplitIn:								; WARNING, garbled sprites may occur on real SNES (1CHIP *and* 3-chip/SCPU-A), most likely related to the INIDISP glitch discovered in 2021

; Channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	DMAP1
	stz	BBAD1							; PPU reg. $2100
	ldx	#SRC_HDMA_FX_1Byte
	stx	A1T1L
	lda	#:SRC_HDMA_FX_1Byte
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Start with black screen, so zero out table
	ldx	#0
-	stz	LO8.HDMA_FX_1Byte, x
	inx
	cpx	#224
	bne	-

	lda	#$00
	sta	RAM_INIDISP
;	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



; Gradually increment screen brightness values
	lda	#2							; scanline counter max.
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

@MainLoop:
	dec	<DP2.Temp+6						; only wait for a new frame every Nth iteration (where N = value in DP2.EffectSpeed)
	bne	+

	WaitFrames	1

	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

+	ldx	#112							; start in the middle of the table
	ldy	#0

@SubLoop1:								; loop 1: go towards end of table
	lda	LO8.HDMA_FX_1Byte, x
	cmp	#$0F							; don't increment value if it's already reached #$0F
	bcs	+
	inc	a
	sta	LO8.HDMA_FX_1Byte, x
+	inx
	iny
	cpy	<DP2.Temp+4						; max. no. of scanlines done?
	bne	@SubLoop1

	ldx	#112
	ldy	#0

@SubLoop2:								; loop 2: go towards start of table
	dex
	lda	LO8.HDMA_FX_1Byte, x
	cmp	#$0F
	bcs	+
	inc	a
	sta	LO8.HDMA_FX_1Byte, x
+	iny
	cpy	<DP2.Temp+4
	bne	@SubLoop2

	lda	<DP2.Temp+4						; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	<DP2.Temp+4						; no, scanline counter max. += 2
	inc	<DP2.Temp+4

+	lda	LO8.HDMA_FX_1Byte					; yes, repeat a few more times until first byte of table is #$0F
	cmp	#$0F
	bne	@MainLoop

	lda	#$0F
	sta	RAM_INIDISP
;	jsr	SwitchFromPrevVblank

	lda	#%00000010						; deactivate channel 1
	trb	<DP2.HDMA_Channels

	rts



EffectHSplitInWA:							; same effect as above, except we DMA two bytes to $21FF, $2100 in order to work around the INIDISP glitch discovered in 2021 ($21FF is open bus so it shouldn't affect anything)

; Channel 1: main effects channel
	lda	#$41							; transfer mode (2 bytes --> $21FF, $2100), indirect table mode
	sta	DMAP1
	lda	#$FF							; PPU reg. $21FF, $2100
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Start with black screen, so zero out table
	ldx	#0
-	stz	LO8.HDMA_FX_2Bytes, x
	inx
	cpx	#448
	bne	-

	lda	#$00
	sta	RAM_INIDISP
;	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



; Gradually increment screen brightness values
	lda	#2							; scanline counter max.
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

@MainLoop:
	dec	<DP2.Temp+6						; only wait for a new frame every Nth iteration (where N = value in DP2.EffectSpeed)
	bne	+

	WaitFrames	1

	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

+	ldx	#224							; start in the middle of the table
	ldy	#0

	Accu16

@SubLoop1:								; loop 1: go towards end of table
	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$0F0F							; don't increment value if it's already reached #$0F
	bcs	+
	clc
	adc	#$0101							; add 1 to two bytes at once
	sta	LO8.HDMA_FX_2Bytes, x
+	inx
	inx
	iny
	cpy	<DP2.Temp+4						; max. no. of scanlines done?
	bne	@SubLoop1

	ldx	#224
	ldy	#0

@SubLoop2:								; loop 2: go towards start of table
	dex
	dex
	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$0F0F
	bcs	+
	clc
	adc	#$0101
	sta	LO8.HDMA_FX_2Bytes, x
+	iny
	cpy	<DP2.Temp+4
	bne	@SubLoop2

	Accu8

	lda	<DP2.Temp+4						; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	<DP2.Temp+4						; no, scanline counter max. += 2
	inc	<DP2.Temp+4

+	Accu16

	lda	LO8.HDMA_FX_2Bytes					; yes, repeat a few more times until first byte of table is #$0F
	cmp	#$0F0F
	beq	@Done

	Accu8

	bra	@MainLoop

@Done:
	Accu8

	lda	#$0F
	sta	RAM_INIDISP
;	jsr	SwitchFromPrevVblank

	lda	#%00000010						; deactivate channel 1
	trb	<DP2.HDMA_Channels

	rts



; ****************** Split horizontal out (to black) *******************

EffectHSplitOut:							; split out from the middle of the screen // WARNING, cf. EffectHSplitIn

; Channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	DMAP1
	stz	BBAD1							; PPU reg. $2100
	ldx	#SRC_HDMA_FX_1Byte
	stx	A1T1L
	lda	#:SRC_HDMA_FX_1Byte
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Start with full brightness
	lda	#$0F
	sta	RAM_INIDISP
	ldx	#0

-	sta	LO8.HDMA_FX_1Byte, x
	inx
	cpx	#224
	bne	-

;	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



; Gradually decrement screen brightness values
	lda	#2							; scanline counter max.
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

@MainLoop:
	dec	<DP2.Temp+6
	bne	+

	WaitFrames	1

	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

+	ldx	#112							; start in the middle of the table
	ldy	#0

@SubLoop1:								; loop 1: go towards end of table
	lda	LO8.HDMA_FX_1Byte, x
	beq	+							; don't decrement value if it's already reached #$00
	dec	a
	sta	LO8.HDMA_FX_1Byte, x
+	inx
	iny
	cpy	<DP2.Temp+4						; max. no. of scanlines done?
	bne	@SubLoop1

	ldx	#112
	ldy	#0

@SubLoop2:								; loop 2: go towards start of table
	dex
	lda	LO8.HDMA_FX_1Byte, x
	beq	+
	dec	a
	sta	LO8.HDMA_FX_1Byte, x
+	iny
	cpy	<DP2.Temp+4
	bne	@SubLoop2

	lda	<DP2.Temp+4						; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	<DP2.Temp+4						; no, scanline counter max. += 2
	inc	<DP2.Temp+4

+	lda	LO8.HDMA_FX_1Byte					; yes, repeat a few more times until first byte of table is #$00
	bne	@MainLoop

	lda	#$80
	sta	RAM_INIDISP
	lda	#%00000010						; deactivate channel 1
	trb	<DP2.HDMA_Channels

	WaitFrames	1						; wait for HDMA register update

;	jsr	SwitchFromPrevVblank

	rts



EffectHSplitOutWA:							; same effect as above, but with INIDISP glitch workaround (cf. EffectHSplitInWA)

; Channel 1: main effects channel
	lda	#$41							; transfer mode (2 bytes --> $21FF, $2100), indirect table mode
	sta	DMAP1
	lda	#$FF							; PPU reg. $21FF, $2100
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Start with full brightness
	lda	#$0F
	sta	RAM_INIDISP
	ldx	#0

-	sta	LO8.HDMA_FX_2Bytes, x
	inx
	cpx	#448
	bne	-

;	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



; Gradually decrement screen brightness values
	lda	#2							; scanline counter max.
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

@MainLoop:
	dec	<DP2.Temp+6
	bne	+

	WaitFrames	1

	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

+	ldx	#224							; start in the middle of the table
	ldy	#0

	Accu16

@SubLoop1:								; loop 1: go towards end of table
	lda	LO8.HDMA_FX_2Bytes, x
	beq	+							; don't decrement value if it's already reached #$00
	sec
	sbc	#$0101							; subtract 1 from two bytes at once
	sta	LO8.HDMA_FX_2Bytes, x
+	inx
	inx
	iny
	cpy	<DP2.Temp+4						; max. no. of scanlines done?
	bne	@SubLoop1

	ldx	#224
	ldy	#0

@SubLoop2:								; loop 2: go towards start of table
	dex
	dex
	lda	LO8.HDMA_FX_2Bytes, x
	beq	+
	sec
	sbc	#$0101
	sta	LO8.HDMA_FX_2Bytes, x
+	iny
	cpy	<DP2.Temp+4
	bne	@SubLoop2

	Accu8

	lda	<DP2.Temp+4						; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	<DP2.Temp+4						; no, scanline counter max. += 2
	inc	<DP2.Temp+4

+	Accu16

	lda	LO8.HDMA_FX_2Bytes					; yes, repeat a few more times until first byte of table is #$00
	beq	+

	Accu8

	bra	@MainLoop

+	Accu8

	lda	#$80
	sta	RAM_INIDISP
	lda	#%00000010						; deactivate channel 1
	trb	<DP2.HDMA_Channels

	WaitFrames	1						; wait for HDMA register update

;	jsr	SwitchFromPrevVblank

	rts



EffectHSplitOut2:							; split out towards the middle of the screen // WARNING, cf. EffectHSplitIn

; Channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	DMAP1
	stz	BBAD1							; PPU reg. $2100
	ldx	#SRC_HDMA_FX_1Byte
	stx	A1T1L
	lda	#:SRC_HDMA_FX_1Byte
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Start with full brightness
	lda	#$0F
	sta	RAM_INIDISP
	ldx	#0

-	sta	LO8.HDMA_FX_1Byte, x
	inx
	cpx	#224
	bne	-

;	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



; Gradually decrement screen brightness values
	lda	#2							; scanline counter max.
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

@MainLoop:
	dec	<DP2.Temp+6
	bne	+

	WaitFrames	1

	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

+	ldx	#224							; loop 1: go from end towards middle of table
	ldy	#0

@SubLoop1:
	dex
	lda	LO8.HDMA_FX_1Byte, x
	beq	+							; don't decrement value if it's already reached #$00
	dec	a
	sta	LO8.HDMA_FX_1Byte, x
+	iny
	cpy	<DP2.Temp+4						; max. no. of scanlines done?
	bne	@SubLoop1

	ldx	#0							; loop 2: go from beginning towards middle of table
	ldy	#0

@SubLoop2:
	lda	LO8.HDMA_FX_1Byte, x
	beq	+
	dec	a
	sta	LO8.HDMA_FX_1Byte, x
+	inx
	iny
	cpy	<DP2.Temp+4
	bne	@SubLoop2

	lda	<DP2.Temp+4						; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	<DP2.Temp+4						; no, scanline counter max. += 2
	inc	<DP2.Temp+4

+	lda	LO8.HDMA_FX_1Byte+112					; yes, repeat a few more times until the byte in the middle of the table is #$00
	bne	@MainLoop

	lda	#$80
	sta	RAM_INIDISP
	lda	#%00000010						; deactivate channel 1
	trb	<DP2.HDMA_Channels

	WaitFrames	1						; wait for HDMA register update

;	jsr	SwitchFromPrevVblank

	rts



EffectHSplitOut2WA:							; same effect as above, but with INIDISP glitch workaround (cf. EffectHSplitInWA)

; Channel 1: main effects channel
	lda	#$41							; transfer mode (2 bytes --> $21FF, $2100), indirect table mode
	sta	DMAP1
	lda	#$FF							; PPU reg. $21FF, $2100
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Start with full brightness
	lda	#$0F
	sta	RAM_INIDISP
	ldx	#0

-	sta	LO8.HDMA_FX_2Bytes, x
	inx
	cpx	#224
	bne	-

;	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



; Gradually decrement screen brightness values
	lda	#2							; scanline counter max.
	sta	<DP2.Temp+4
	stz	<DP2.Temp+5
	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

@MainLoop:
	dec	<DP2.Temp+6
	bne	+

	WaitFrames	1

	lda	<DP2.EffectSpeed
	sta	<DP2.Temp+6

+	ldx	#448							; loop 1: go from end towards middle of table
	ldy	#0

	Accu16

@SubLoop1:
	dex
	dex
	lda	LO8.HDMA_FX_2Bytes, x
	beq	+							; don't decrement value if it's already reached #$00
	sec
	sbc	#$0101							; subtract 1 from two bytes at once
	sta	LO8.HDMA_FX_2Bytes, x
+	iny
	cpy	<DP2.Temp+4						; max. no. of scanlines done?
	bne	@SubLoop1

	ldx	#0							; loop 2: go from beginning towards middle of table
	ldy	#0

@SubLoop2:
	lda	LO8.HDMA_FX_2Bytes, x
	beq	+
	sec
	sbc	#$0101
	sta	LO8.HDMA_FX_2Bytes, x
+	inx
	inx
	iny
	cpy	<DP2.Temp+4
	bne	@SubLoop2

	Accu8

	lda	<DP2.Temp+4						; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	<DP2.Temp+4						; no, scanline counter max. += 2
	inc	<DP2.Temp+4

+	Accu16

	lda	LO8.HDMA_FX_2Bytes+224					; yes, repeat a few more times until the byte in the middle of the table is #$00
	beq	@Done

	Accu8

	bra	@MainLoop

@Done:
	Accu8

	lda	#$80
	sta	RAM_INIDISP
	lda	#%00000010						; deactivate channel 1
	trb	<DP2.HDMA_Channels

	WaitFrames	1						; wait for HDMA register update

;	jsr	SwitchFromPrevVblank

	rts



; ****************** "Camera shutter" in (from black) ******************

EffectShutterIn:

; Channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	DMAP1
	lda	#$26							; PPU reg. $2126
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	W12SEL
	sta	W34SEL
	lda	#%00000011						; and sprites
	sta	WOBJSEL
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	TMW							; on mainscreen
	sta	TSW							; and subscreen



; Fill HDMA table with initial values
	Accu16

	lda	#$7F80							; initial horizontal boundaries (lo = X1, hi = X2 --> window area is negative, i.e. all content is disabled for now)
	ldx	#0
-	sta	LO8.HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels

	WaitFrames	1

	lda	#$0F							; turn screen on
	sta	INIDISP
	ldx	#222							; initial value for upper vertical boundary = scanline 111 (times 2 as each entry in the HDMA table is 2 bytes)
	stx	<DP2.Temp
	ldx	#226							; initial value for lower vertical boundary = scanline 113 (ditto)
	stx	<DP2.Temp+2
	lda	#$7F							; initial values that get stored to HDMA array for a rectangular window shape
	sta	<DP2.Temp+4
	lda	#$80
	sta	<DP2.Temp+5

@Loop1:
	WaitFrames	1

	ldx	<DP2.Temp						; load current upper vertical boundary
-	lda	<DP2.Temp+4
	sta	LO8.HDMA_FX_2Bytes, x					; store new X1 value
	inx
	lda	<DP2.Temp+5
	sta	LO8.HDMA_FX_2Bytes, x					; store new X2 value
	inx
	cpx	<DP2.Temp+2						; do this again for next scanlines until lower vertical boundary reached
	bne	-

	Accu16

	dec	<DP2.Temp						; increase vertical window size
	dec	<DP2.Temp
	dec	<DP2.Temp
	dec	<DP2.Temp
	inc	<DP2.Temp+2
	inc	<DP2.Temp+2
	inc	<DP2.Temp+2
	inc	<DP2.Temp+2

	Accu8

	dec	<DP2.Temp+4						; increase horizontal window size
	dec	<DP2.Temp+4
	inc	<DP2.Temp+5
	inc	<DP2.Temp+5
	lda	<DP2.Temp+2						; repeat until all 224 scanlines are done
	cmp	#$C2
	bne	@Loop1

	lda	<DP2.Temp+3
	cmp	#$01
	bne	@Loop1

	lda	#%00000010						; deactivate HDMA channel 1
	trb	<DP2.HDMA_Channels

@Loop2:
	WaitFrames	1

	lda	<DP2.Temp+4						; as the SNES screen is 256×224 px, we still need to adjust the window width (16 px missing on either side) to its final value
	cmp	#$FF
	beq	@Done
	sta	WH0
	lda	<DP2.Temp+5
	sta	WH1
	dec	<DP2.Temp+4
	dec	<DP2.Temp+4
	inc	<DP2.Temp+5
	inc	<DP2.Temp+5
	bra	@Loop2

@Done:
	stz	W12SEL							; clear used registers
	stz	W34SEL
	stz	WOBJSEL
	stz	TMW
	stz	TSW
	jsr	SwitchFromPrevVblank

	rts



; ****************** "Camera shutter" out (to black) *******************

EffectShutterOut:

; Channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	DMAP1
	lda	#$26							; PPU reg. $2126
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Fill HDMA table with initial values
	Accu16

	lda	#$EE11							; initial horizontal boundaries (lo = X1, hi = X2)
	ldx	#0
-	sta	LO8.HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	ldx	#2							; initial value for upper vertical boundary = scanline 1 (times 2 as each entry in the HDMA table is 2 bytes)
	stx	<DP2.Temp
	ldx	#446							; initial value for lower vertical boundary = scanline 223 (ditto)
	stx	<DP2.Temp+2
	stz	<DP2.Temp+4						; initial values that get stored to HDMA array
	lda	#$FF
	sta	<DP2.Temp+5



; Set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	W12SEL
	sta	W34SEL
	lda	#%00000011						; and sprites
	sta	WOBJSEL
	stz	WH0							; set initial window 1 X1
	lda	#$FF							; set initial window 1 X2
	sta	WH1
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	TMW							; on mainscreen
	sta	TSW							; and subscreen



@Loop1:
	WaitFrames	1

	lda	<DP2.Temp+4						; as the SNES screen is 256×224 px, we need to adjust the window width first (16 px missing on either side)
	cmp	#$12
	beq	+
	sta	WH0
	lda	<DP2.Temp+5
	sta	WH1
	inc	<DP2.Temp+4
	inc	<DP2.Temp+4
	dec	<DP2.Temp+5
	dec	<DP2.Temp+5
	bra	@Loop1

+	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels

@Loop2:
	WaitFrames	1

	ldx	#0
-	lda	#$80
	sta	LO8.HDMA_FX_2Bytes, x					; above upper window boundary, store negative values (i.e., disable all content)
	inx
	lda	#$7F
	sta	LO8.HDMA_FX_2Bytes, x
	inx
	cpx	<DP2.Temp
	bne	-

-	lda	<DP2.Temp+4
	sta	LO8.HDMA_FX_2Bytes, x					; within window, store current X1 value
	inx
	lda	<DP2.Temp+5
	sta	LO8.HDMA_FX_2Bytes, x					; store current X2 value
	inx
	cpx	<DP2.Temp+2						; do this again for all scanlines until lower horizontal boundary reached
	bne	-

-	lda	#$80
	sta	LO8.HDMA_FX_2Bytes, x					; below lower window boundary, store negative values (i.e., disable all content)
	inx
	lda	#$7F
	sta	LO8.HDMA_FX_2Bytes, x
	inx
	cpx	#448
	bne	-

	Accu16

	inc	<DP2.Temp						; decrease vertical window size
	inc	<DP2.Temp
	inc	<DP2.Temp
	inc	<DP2.Temp
	dec	<DP2.Temp+2
	dec	<DP2.Temp+2
	dec	<DP2.Temp+2
	dec	<DP2.Temp+2

	Accu8

	inc	<DP2.Temp+4						; decrease horizontal window size
	inc	<DP2.Temp+4
	dec	<DP2.Temp+5
	dec	<DP2.Temp+5
	lda	<DP2.Temp						; repeat until window collapses
	cmp	#226
	bne	@Loop2

	lda	#$80							; turn screen off
	sta	INIDISP
	lda	#%00000010						; deactivate HDMA channel 1
	trb	<DP2.HDMA_Channels
	stz	W12SEL							; clear used registers
	stz	W34SEL
	stz	WOBJSEL
	stz	TMW
	stz	TSW
	jsr	SwitchFromPrevVblank

	rts



; ********************* "Diamond" in (from black) **********************

EffectDiamondIn:

; Channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	DMAP1
	lda	#$26							; PPU reg. $2126
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	W12SEL
	sta	W34SEL
	lda	#%00000011						; and sprites
	sta	WOBJSEL
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	TMW							; on mainscreen
	sta	TSW							; and subscreen



; Fill HDMA table with initial values
	Accu16

	lda	#$7F80							; initial horizontal boundaries (caveat: lo = X1, hi = X2, i.e. window area is intentionally negative --> all content is disabled)
	ldx	#0
-	sta	LO8.HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels

	WaitFrames	1

	lda	#$0F
	sta	INIDISP

	ldx	#222							; initial value for upper vertical boundary (times 2 as each entry in the HDMA table is 2 bytes)
	stx	<DP2.Temp
	ldx	#226							; initial value for lower vertical boundary (ditto)
	stx	<DP2.Temp+2

@Loop1:
	WaitFrames	1

	ldx	<DP2.Temp
-	dec	LO8.HDMA_FX_2Bytes, x
	inx
	inc	LO8.HDMA_FX_2Bytes, x
	inx
	cpx	<DP2.Temp+2
	bne	-

	Accu16

	dec	<DP2.Temp
	dec	<DP2.Temp
	inc	<DP2.Temp+2
	inc	<DP2.Temp+2

	Accu8

	lda	<DP2.Temp+1
	bne	@Loop1

	lda	<DP2.Temp
	bne	@Loop1

@Loop2:									; up to this point, we created a diamond-shaped window, so repeat manipulating HDMA values for all scanlines until the whole screen is visible
	WaitFrames	1

	ldx	#0
-	lda	LO8.HDMA_FX_2Bytes, x
	beq	+
	dec	LO8.HDMA_FX_2Bytes, x
+	inx
	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$FF
	beq	+
	inc	LO8.HDMA_FX_2Bytes, x
+	inx
	cpx	#448
	bne	-

	lda	LO8.HDMA_FX_2Bytes
	bne	@Loop2

	lda	#%00000010						; deactivate HDMA channel 1
	trb	<DP2.HDMA_Channels
	stz	W12SEL							; clear used registers
	stz	W34SEL
	stz	WOBJSEL
	stz	TMW
	stz	TSW
	jsr	SwitchFromPrevVblank

	rts



; ********************** "Diamond" out (to black) **********************

EffectDiamondOut:

; Channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	DMAP1
	lda	#$26							; PPU reg. $2126
	sta	BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	DASB1



; Fill HDMA table with initial values
	Accu16

	lda	#$FF00							; initial horizontal boundaries (caveat: lo = X1, hi = X2 --> all content is enabled for now)
	ldx	#0
-	sta	LO8.HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	ldx	#2							; initial value for upper vertical boundary = scanline 1 (times 2 as each entry in the HDMA table is 2 bytes)
	stx	<DP2.Temp
	ldx	#446							; initial value for lower vertical boundary = scanline 223 (ditto)
	stx	<DP2.Temp+2



; Set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	W12SEL
	sta	W34SEL
	lda	#%00000011						; and sprites
	sta	WOBJSEL
	stz	WH0							; set initial window 1 X1
	lda	#$FF							; set initial window 1 X2
	sta	WH1
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	TMW							; on mainscreen
	sta	TSW							; and subscreen
	lda	#%00000010						; activate HDMA channel 1
	tsb	<DP2.HDMA_Channels



@Loop1:
	WaitFrames	1

	ldx	#0
-	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$80
	beq	+
	inc	LO8.HDMA_FX_2Bytes, x
+	inx
	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$7F
	beq	+
	dec	LO8.HDMA_FX_2Bytes, x
+	inx
	cpx	<DP2.Temp
	bne	-

	ldx	<DP2.Temp+2
-	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$80
	beq	+
	inc	LO8.HDMA_FX_2Bytes, x
+	inx
	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$7F
	beq	+
	dec	LO8.HDMA_FX_2Bytes, x
+	inx
	cpx	#448
	bne	-

	Accu16

	inc	<DP2.Temp						; decrease vertical window size
	inc	<DP2.Temp
	dec	<DP2.Temp+2
	dec	<DP2.Temp+2

	Accu8

	lda	<DP2.Temp						; repeat until diamond-shaped window has appeared
	cmp	#226
	bne	@Loop1

@Loop2:									; repeat the process for all scanlines until the whole screen is black
	WaitFrames	1

	ldx	#0
-	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$80
	beq	+
	inc	LO8.HDMA_FX_2Bytes, x
+	inx
	lda	LO8.HDMA_FX_2Bytes, x
	cmp	#$7F
	beq	+
	dec	LO8.HDMA_FX_2Bytes, x
+	inx
	cpx	#448
	bne	-

	lda	LO8.HDMA_FX_2Bytes+$E0
	cmp	#$7F
	bne	@Loop2

	lda	#$80							; turn screen off
	sta	INIDISP
	lda	#%00000010						; deactivate HDMA channel 1
	trb	<DP2.HDMA_Channels
	stz	W12SEL							; clear used registers
	stz	W34SEL
	stz	WOBJSEL
	stz	TMW
	stz	TSW
	jsr	SwitchFromPrevVblank

	rts



; ************************* Common subroutines *************************

SwitchToMinimalVblank:
	DisableIRQs

	Accu16

	lda.w	P00.JmpVblank						; preserve original Vblank JMP address // caveat: .w or .l operand hints needed as JmpVblank is not in any Direct Page any more (otherwise, it looks to WLA DX like a DP address)
	sta	LO8.Temp
	lda.w	P00.JmpVblank+2
	sta	LO8.Temp+2

	Accu8

	SetNMI	kNMI_Minimal

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN
	sta	NMITIMEN
	cli								; re-enable interrupts

	rts



SwitchFromPrevVblank:
	DisableIRQs

	Accu16

	lda	LO8.Temp						; restore original Vblank JMP address // cf. SwitchToMinimalVblank for operand hints
	sta.w	P00.JmpVblank
	lda	LO8.Temp+2
	sta.w	P00.JmpVblank+2

	Accu8

	lda	RDNMI							; clear NMI flag
	lda	LO8.NMITIMEN						; re-enable interrupts using shadow variable
	sta	NMITIMEN
	cli

	rts



; ******************************** EOF *********************************
