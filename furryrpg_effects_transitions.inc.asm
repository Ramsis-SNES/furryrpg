;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** EFFECTS: TRANSITIONS ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

SRC_EffectPointer:
	.DW EffectFadeFromBlack
	.DW EffectFadeToBlack
	.DW EffectHSplitIn
	.DW EffectHSplitOut
	.DW EffectHSplitOut2
	.DW EffectShutterIn
	.DW EffectShutterOut
	.DW EffectDiamondIn
	.DW EffectDiamondOut



ScreenEffects:

; ************************* Fade from/to black *************************

EffectFadeFromBlack:
	lda	DP_EffectSpeed
	bmi	__FadeDelayFromBlack					; if speed value is negative, insert delay instead
	lda	#$00							; initial screen brightness

__FadeSpeedFromBlackLoop:
	sta	VAR_ShadowINIDISP
	ldx	DP_EffectSpeed						; use speed value to skip brightness values
-	inc	a
	cmp	#$0F							; prevent glitches due to speed values in event script that aren't divisors of 15, or completely pointless
	bcs	+
	dex
	bne	-

+	sta	VAR_ShadowINIDISP
	xba								; save current screen brightness in B
-	lda	REG_HVBJOY						; wait 1 frame
	bpl	-

-	lda	REG_HVBJOY
	bmi	-

	xba
	cmp	#$0F
	bne	__FadeSpeedFromBlackLoop

	bra	__FadeFromBlackDone

__FadeDelayFromBlack:
	eor	#$FF							; make speed value positive and use as delay value
	inc	a
	sta	DP_EffectSpeed
	lda	#$00							; initial screen brightness

__FadeDelayFromBlackLoop1:
	sta	VAR_ShadowINIDISP
	xba								; save current screen brightness in B
	ldx	DP_EffectSpeed						; use delay value to insert frames

__FadeDelayFromBlackLoop2:
-	lda	REG_HVBJOY
	bpl	-

-	lda	REG_HVBJOY
	bmi	-

	dex
	bne	__FadeDelayFromBlackLoop2

	xba								; increment screen brightness ...
	inc	a
	cmp	#$10							; ... until it's reached max value ($0F)
	bne	__FadeDelayFromBlackLoop1

__FadeFromBlackDone:
	rts



EffectFadeToBlack:
	lda	DP_EffectSpeed
	bmi	__FadeDelayToBlack					; if speed value is negative, insert delay instead
	lda	#$0F							; initial screen brightness

__FadeSpeedToBlackLoop:
	sta	VAR_ShadowINIDISP
	ldx	DP_EffectSpeed						; use speed value to skip brightness values
-	dec	a
	beq	+							; prevent glitches due to invalid speed values in event script
	dex
	bne	-

+	sta	VAR_ShadowINIDISP
	xba								; save current screen brightness in B
-	lda	REG_HVBJOY						; wait 1 frame
	bpl	-

-	lda	REG_HVBJOY
	bmi	-

	xba
	bne	__FadeSpeedToBlackLoop

	bra	__FadeToBlackDone

__FadeDelayToBlack:
	eor	#$FF							; make speed value positive and use as delay value
	inc	a
	sta	DP_EffectSpeed
	lda	#$0F							; initial screen brightness

__FadeDelayToBlackLoop1:
	sta	VAR_ShadowINIDISP
	xba								; save current screen brightness in B
	ldx	DP_EffectSpeed						; use delay value to insert frames

__FadeDelayToBlackLoop2:
-	lda	REG_HVBJOY
	bpl	-

-	lda	REG_HVBJOY
	bmi	-

	dex
	bne	__FadeDelayToBlackLoop2

	xba								; decrement screen brightness ...
	dec	a
	cmp	#$FF							; ... until it's reached zero
	bne	__FadeDelayToBlackLoop1

__FadeToBlackDone:
	rts



; ****************** Split horizontal in (from black) ******************

EffectHSplitIn:								; FIXME (occasional gfx glitches on real SNES)



; -------------------------- channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	REG_DMAP1
	stz	REG_BBAD1							; PPU reg. $2100
	ldx	#SRC_HDMA_FX_1Byte
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_1Byte
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- start with black screen, so zero out table
	ldx	#0
-	stz	ARRAY_HDMA_FX_1Byte, x
	inx
	cpx	#224
	bne	-

	lda	#$00
	sta	VAR_ShadowINIDISP
	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels



; -------------------------- gradually increment screen brightness values
	lda	#2							; scanline counter max.
	sta	temp+4
	stz	temp+5
	lda	DP_EffectSpeed
	sta	temp+6

__HSplitInMainLoop:
	dec	temp+6							; only wait for a new frame every Nth iteration (where N = value in DP_EffectSpeed)
	bne	+

	WaitFrames	1

	lda	DP_EffectSpeed
	sta	temp+6

+	ldx	#112							; start in the middle of the table
	ldy	#0

__HSplitInSubLoop1:							; loop 1: go towards end of table
	lda	ARRAY_HDMA_FX_1Byte, x
	cmp	#$0F							; don't increment value if it's already reached #$0F
	bcs	+
	inc	a
	sta	ARRAY_HDMA_FX_1Byte, x
+	inx
	iny
	cpy	temp+4							; max. no. of scanlines done?
	bne	__HSplitInSubLoop1

	ldx	#112
	ldy	#0

__HSplitInSubLoop2:							; loop 2: go towards start of table
	dex
	lda	ARRAY_HDMA_FX_1Byte, x
	cmp	#$0F
	bcs	+
	inc	a
	sta	ARRAY_HDMA_FX_1Byte, x
+	iny
	cpy	temp+4
	bne	__HSplitInSubLoop2

	lda	temp+4							; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	temp+4							; no, scanline counter max. += 2
	inc	temp+4

+	lda	ARRAY_HDMA_FX_1Byte					; yes, repeat a few more times until first byte of table is #$0F
	cmp	#$0F
	bne	__HSplitInMainLoop

	lda	#$0F
	sta	VAR_ShadowINIDISP
	jsr	SwitchFromPrevVblank

	lda	#%00000010						; deactivate channel 1
	trb	DP_HDMA_Channels
	rts



; ****************** Split horizontal out (to black) *******************

EffectHSplitOut:							; split out from the middle of the screen // FIXME (occasional gfx glitches on real SNES)



; -------------------------- channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	REG_DMAP1
	stz	REG_BBAD1							; PPU reg. $2100
	ldx	#SRC_HDMA_FX_1Byte
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_1Byte
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- start with full brightness
	lda	#$0F
	sta	VAR_ShadowINIDISP
	ldx	#0

-	sta	ARRAY_HDMA_FX_1Byte, x
	inx
	cpx	#224
	bne	-

	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels



; -------------------------- gradually decrement screen brightness values
	lda	#2							; scanline counter max.
	sta	temp+4
	stz	temp+5
	lda	DP_EffectSpeed
	sta	temp+6

__HSplitOutMainLoop:
	dec	temp+6
	bne	+

	WaitFrames	1

	lda	DP_EffectSpeed
	sta	temp+6

+	ldx	#112							; start in the middle of the table
	ldy	#0

__HSplitOutSubLoop1:							; loop 1: go towards end of table
	lda	ARRAY_HDMA_FX_1Byte, x
	beq	+							; don't decrement value if it's already reached #$00
	dec	a
	sta	ARRAY_HDMA_FX_1Byte, x
+	inx
	iny
	cpy	temp+4							; max. no. of scanlines done?
	bne	__HSplitOutSubLoop1

	ldx	#112
	ldy	#0

__HSplitOutSubLoop2:							; loop 2: go towards start of table
	dex
	lda	ARRAY_HDMA_FX_1Byte, x
	beq	+
	dec	a
	sta	ARRAY_HDMA_FX_1Byte, x
+	iny
	cpy	temp+4
	bne	__HSplitOutSubLoop2

	lda	temp+4							; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	temp+4							; no, scanline counter max. += 2
	inc	temp+4

+	lda	ARRAY_HDMA_FX_1Byte					; yes, repeat a few more times until first byte of table is #$00
	bne	__HSplitOutMainLoop

	lda	#$80
	sta	VAR_ShadowINIDISP
	lda	#%00000010						; deactivate channel 1
	trb	DP_HDMA_Channels

	WaitFrames	1						; wait for HDMA register update

	jsr	SwitchFromPrevVblank

	rts



EffectHSplitOut2:							; split out towards the middle of the screen // FIXME (occasional gfx glitches on real SNES)



; -------------------------- channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	REG_DMAP1
	stz	REG_BBAD1							; PPU reg. $2100
	ldx	#SRC_HDMA_FX_1Byte
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_1Byte
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- start with full brightness
	lda	#$0F
	sta	VAR_ShadowINIDISP
	ldx	#0

-	sta	ARRAY_HDMA_FX_1Byte, x
	inx
	cpx	#224
	bne	-

	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels



; -------------------------- gradually decrement screen brightness values
	lda	#2							; scanline counter max.
	sta	temp+4
	stz	temp+5
	lda	DP_EffectSpeed
	sta	temp+6

__HSplitOut2MainLoop:
	dec	temp+6
	bne	+

	WaitFrames	1

	lda	DP_EffectSpeed
	sta	temp+6

+	ldx	#224							; loop 1: go from end towards middle of table
	ldy	#0

__HSplitOut2SubLoop1:
	dex
	lda	ARRAY_HDMA_FX_1Byte, x
	beq	+							; don't decrement value if it's already reached #$00
	dec	a
	sta	ARRAY_HDMA_FX_1Byte, x
+	iny
	cpy	temp+4							; max. no. of scanlines done?
	bne	__HSplitOut2SubLoop1

	ldx	#0							; loop 2: go from beginning towards middle of table
	ldy	#0

__HSplitOut2SubLoop2:
	lda	ARRAY_HDMA_FX_1Byte, x
	beq	+
	dec	a
	sta	ARRAY_HDMA_FX_1Byte, x
+	inx
	iny
	cpy	temp+4
	bne	__HSplitOut2SubLoop2

	lda	temp+4							; 112 scanlines in each direction done?
	cmp	#112
	bcs	+
	inc	temp+4							; no, scanline counter max. += 2
	inc	temp+4

+	lda	ARRAY_HDMA_FX_1Byte+112					; yes, repeat a few more times until the byte in the middle of the table is #$00
	bne	__HSplitOut2MainLoop

	lda	#$80
	sta	VAR_ShadowINIDISP
	lda	#%00000010						; deactivate channel 1
	trb	DP_HDMA_Channels

	WaitFrames	1						; wait for HDMA register update

	jsr	SwitchFromPrevVblank

	rts



; ****************** "Camera shutter" in (from black) ******************

EffectShutterIn:



; -------------------------- channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	REG_DMAP1
	lda	#$26							; PPU reg. $2126
	sta	REG_BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	REG_W12SEL
	sta	REG_W34SEL
	lda	#%00000011						; and sprites
	sta	REG_WOBJSEL
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	REG_TMW							; on mainscreen
	sta	REG_TSW							; and subscreen



; -------------------------- fill HDMA table with initial values
	Accu16

	lda	#$7F80							; initial horizontal boundaries (lo = X1, hi = X2 --> window area is negative, i.e. all content is disabled for now)
	ldx	#0
-	sta	ARRAY_HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels

	WaitFrames	1

	lda	#$0F							; turn screen on
	sta	REG_INIDISP
	ldx	#222							; initial value for upper vertical boundary = scanline 111 (times 2 as each entry in the HDMA table is 2 bytes)
	stx	temp
	ldx	#226							; initial value for lower vertical boundary = scanline 113 (ditto)
	stx	temp+2
	lda	#$7F							; initial values that get stored to HDMA array for a rectangular window shape
	sta	temp+4
	lda	#$80
	sta	temp+5

__ShutterInLoop1:
	WaitFrames	1

	ldx	temp							; load current upper vertical boundary
-	lda	temp+4
	sta	ARRAY_HDMA_FX_2Bytes, x					; store new X1 value
	inx
	lda	temp+5
	sta	ARRAY_HDMA_FX_2Bytes, x					; store new X2 value
	inx
	cpx	temp+2							; do this again for next scanlines until lower vertical boundary reached
	bne	-

	Accu16

	dec	temp							; increase vertical window size
	dec	temp
	dec	temp
	dec	temp
	inc	temp+2
	inc	temp+2
	inc	temp+2
	inc	temp+2

	Accu8

	dec	temp+4							; increase horizontal window size
	dec	temp+4
	inc	temp+5
	inc	temp+5
	lda	temp+2							; repeat until all 224 scanlines are done
	cmp	#$C2
	bne	__ShutterInLoop1

	lda	temp+3
	cmp	#$01
	bne	__ShutterInLoop1

	lda	#%00000010						; deactivate HDMA channel 1
	trb	DP_HDMA_Channels

__ShutterInLoop2:
	WaitFrames	1

	lda	temp+4							; as the SNES screen is 256×224 px, we still need to adjust the window width (16 px missing on either side) to its final value
	cmp	#$FF
	beq	__ShutterInDone
	sta	REG_WH0
	lda	temp+5
	sta	REG_WH1
	dec	temp+4
	dec	temp+4
	inc	temp+5
	inc	temp+5
	bra	__ShutterInLoop2

__ShutterInDone:
	stz	REG_W12SEL						; clear used registers
	stz	REG_W34SEL
	stz	REG_WOBJSEL
	stz	REG_TMW
	stz	REG_TSW

	jsr	SwitchFromPrevVblank

	rts



; ****************** "Camera shutter" out (to black) *******************

EffectShutterOut:



; -------------------------- channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	REG_DMAP1
	lda	#$26							; PPU reg. $2126
	sta	REG_BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- fill HDMA table with initial values
	Accu16

	lda	#$EE11							; initial horizontal boundaries (lo = X1, hi = X2)
	ldx	#0
-	sta	ARRAY_HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	ldx	#2							; initial value for upper vertical boundary = scanline 1 (times 2 as each entry in the HDMA table is 2 bytes)
	stx	temp
	ldx	#446							; initial value for lower vertical boundary = scanline 223 (ditto)
	stx	temp+2
	stz	temp+4							; initial values that get stored to HDMA array
	lda	#$FF
	sta	temp+5



; -------------------------- set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	REG_W12SEL
	sta	REG_W34SEL
	lda	#%00000011						; and sprites
	sta	REG_WOBJSEL
	stz	REG_WH0							; set initial window 1 X1
	lda	#$FF							; set initial window 1 X2
	sta	REG_WH1
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	REG_TMW							; on mainscreen
	sta	REG_TSW							; and subscreen



__ShutterOutLoop1:
	WaitFrames	1

	lda	temp+4							; as the SNES screen is 256×224 px, we need to adjust the window width first (16 px missing on either side)
	cmp	#$12
	beq	+
	sta	REG_WH0
	lda	temp+5
	sta	REG_WH1
	inc	temp+4
	inc	temp+4
	dec	temp+5
	dec	temp+5
	bra	__ShutterOutLoop1

+	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels

__ShutterOutLoop2:
	WaitFrames	1

	ldx	#0
-	lda	#$80
	sta	ARRAY_HDMA_FX_2Bytes, x					; above upper window boundary, store negative values (i.e., disable all content)
	inx
	lda	#$7F
	sta	ARRAY_HDMA_FX_2Bytes, x
	inx
	cpx	temp
	bne	-

-	lda	temp+4
	sta	ARRAY_HDMA_FX_2Bytes, x					; within window, store current X1 value
	inx
	lda	temp+5
	sta	ARRAY_HDMA_FX_2Bytes, x					; store current X2 value
	inx
	cpx	temp+2							; do this again for all scanlines until lower horizontal boundary reached
	bne	-

-	lda	#$80
	sta	ARRAY_HDMA_FX_2Bytes, x					; below lower window boundary, store negative values (i.e., disable all content)
	inx
	lda	#$7F
	sta	ARRAY_HDMA_FX_2Bytes, x
	inx
	cpx	#448
	bne	-

	Accu16

	inc	temp							; decrease vertical window size
	inc	temp
	inc	temp
	inc	temp
	dec	temp+2
	dec	temp+2
	dec	temp+2
	dec	temp+2

	Accu8

	inc	temp+4							; decrease horizontal window size
	inc	temp+4
	dec	temp+5
	dec	temp+5
	lda	temp							; repeat until window collapses
	cmp	#226
	bne	__ShutterOutLoop2

	lda	#$80							; turn screen off
	sta	REG_INIDISP
	lda	#%00000010						; deactivate HDMA channel 1
	trb	DP_HDMA_Channels
	stz	REG_W12SEL						; clear used registers
	stz	REG_W34SEL
	stz	REG_WOBJSEL
	stz	REG_TMW
	stz	REG_TSW

	jsr	SwitchFromPrevVblank

	rts



; ********************* "Diamond" in (from black) **********************

EffectDiamondIn:



; -------------------------- channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	REG_DMAP1
	lda	#$26							; PPU reg. $2126
	sta	REG_BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	REG_W12SEL
	sta	REG_W34SEL
	lda	#%00000011						; and sprites
	sta	REG_WOBJSEL
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	REG_TMW							; on mainscreen
	sta	REG_TSW							; and subscreen



; -------------------------- fill HDMA table with initial values
	Accu16

	lda	#$7F80							; initial horizontal boundaries (caveat: lo = X1, hi = X2, i.e. window area is intentionally negative --> all content is disabled)
	ldx	#0
-	sta	ARRAY_HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels

	WaitFrames	1

	lda	#$0F
	sta	REG_INIDISP

	ldx	#222							; initial value for upper vertical boundary (times 2 as each entry in the HDMA table is 2 bytes)
	stx	temp
	ldx	#226							; initial value for lower vertical boundary (ditto)
	stx	temp+2

__DiamondInLoop1:
	WaitFrames	1

	ldx	temp
-	dec	ARRAY_HDMA_FX_2Bytes, x
	inx
	inc	ARRAY_HDMA_FX_2Bytes, x
	inx
	cpx	temp+2
	bne	-

	Accu16

	dec	temp
	dec	temp
	inc	temp+2
	inc	temp+2

	Accu8

	lda	temp+1
	bne	__DiamondInLoop1

	lda	temp
	bne	__DiamondInLoop1

__DiamondInLoop2:							; up to this point, we created a diamond-shaped window, so repeat manipulating HDMA values for all scanlines until the whole screen is visible
	WaitFrames	1

	ldx	#0
-	lda	ARRAY_HDMA_FX_2Bytes, x
	beq	+
	dec	ARRAY_HDMA_FX_2Bytes, x
+	inx
	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$FF
	beq	+
	inc	ARRAY_HDMA_FX_2Bytes, x
+	inx
	cpx	#448
	bne	-

	lda	ARRAY_HDMA_FX_2Bytes
	bne	__DiamondInLoop2

	lda	#%00000010						; deactivate HDMA channel 1
	trb	DP_HDMA_Channels
	stz	REG_W12SEL						; clear used registers
	stz	REG_W34SEL
	stz	REG_WOBJSEL
	stz	REG_TMW
	stz	REG_TSW

	jsr	SwitchFromPrevVblank

	rts



; ********************** "Diamond" out (to black) **********************

EffectDiamondOut:



; -------------------------- channel 1: main effects channel
	lda	#$41							; transfer mode (1 byte --> $2126, $2127), indirect table mode
	sta	REG_DMAP1
	lda	#$26							; PPU reg. $2126
	sta	REG_BBAD1
	ldx	#SRC_HDMA_FX_2Bytes
	stx	REG_A1T1L
	lda	#:SRC_HDMA_FX_2Bytes
	sta	REG_A1B1
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	REG_DASB1



; -------------------------- fill HDMA table with initial values
	Accu16

	lda	#$FF00							; initial horizontal boundaries (caveat: lo = X1, hi = X2 --> all content is enabled for now)
	ldx	#0
-	sta	ARRAY_HDMA_FX_2Bytes, x
	inx
	inx
	cpx	#448
	bne	-

	Accu8

	jsr	SwitchToMinimalVblank

	ldx	#2							; initial value for upper vertical boundary = scanline 1 (times 2 as each entry in the HDMA table is 2 bytes)
	stx	temp
	ldx	#446							; initial value for lower vertical boundary = scanline 223 (ditto)
	stx	temp+2



; -------------------------- set registers
	lda	#%00110011						; enable window 1 (+ inversion) for BG1 thru BG4
	sta	REG_W12SEL
	sta	REG_W34SEL
	lda	#%00000011						; and sprites
	sta	REG_WOBJSEL
	stz	REG_WH0							; set initial window 1 X1
	lda	#$FF							; set initial window 1 X2
	sta	REG_WH1
	lda	#%00011111						; enable window masking on BG1 thru BG4 and sprites
	sta	REG_TMW							; on mainscreen
	sta	REG_TSW							; and subscreen
	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMA_Channels



__DiamondOutLoop1:
	WaitFrames	1

	ldx	#0
-	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$80
	beq	+
	inc	ARRAY_HDMA_FX_2Bytes, x
+	inx
	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$7F
	beq	+
	dec	ARRAY_HDMA_FX_2Bytes, x
+	inx
	cpx	temp
	bne	-

	ldx	temp+2
-	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$80
	beq	+
	inc	ARRAY_HDMA_FX_2Bytes, x
+	inx
	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$7F
	beq	+
	dec	ARRAY_HDMA_FX_2Bytes, x
+	inx
	cpx	#448
	bne	-

	Accu16

	inc	temp							; decrease vertical window size
	inc	temp
	dec	temp+2
	dec	temp+2

	Accu8

	lda	temp							; repeat until diamond-shaped window has appeared
	cmp	#226
	bne	__DiamondOutLoop1

__DiamondOutLoop2:							; repeat the process for all scanlines until the whole screen is black
	WaitFrames	1

	ldx	#0
-	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$80
	beq	+
	inc	ARRAY_HDMA_FX_2Bytes, x
+	inx
	lda	ARRAY_HDMA_FX_2Bytes, x
	cmp	#$7F
	beq	+
	dec	ARRAY_HDMA_FX_2Bytes, x
+	inx
	cpx	#448
	bne	-

	lda	ARRAY_HDMA_FX_2Bytes+$E0
	cmp	#$7F
	bne	__DiamondOutLoop2

	lda	#$80							; turn screen off
	sta	REG_INIDISP
	lda	#%00000010						; deactivate HDMA channel 1
	trb	DP_HDMA_Channels
	stz	REG_W12SEL						; clear used registers
	stz	REG_W34SEL
	stz	REG_WOBJSEL
	stz	REG_TMW
	stz	REG_TSW

	jsr	SwitchFromPrevVblank

	rts



; ************************* Common subroutines *************************

SwitchToMinimalVblank:
	DisableIRQs

	Accu16

	lda	DP_VblankJump						; preserve original Vblank JMP address
	sta	ARRAY_Temp
	lda	DP_VblankJump+2
	sta	ARRAY_Temp+2

	Accu8

	SetNMI	TBL_NMI_Minimal

	lda	REG_RDNMI						; clear NMI flag
	lda	VAR_Shadow_NMITIMEN
	sta	REG_NMITIMEN
	cli								; re-enable interrupts
	rts



SwitchFromPrevVblank:
	DisableIRQs

	Accu16

	lda	ARRAY_Temp						; restore original Vblank JMP address
	sta	DP_VblankJump
	lda	ARRAY_Temp+2
	sta	DP_VblankJump+2

	Accu8

	lda	REG_RDNMI						; clear NMI flag
	lda	VAR_Shadow_NMITIMEN					; re-enable interrupts using shadow variable
	sta	REG_NMITIMEN
	cli
	rts



; ******************************** EOF *********************************
