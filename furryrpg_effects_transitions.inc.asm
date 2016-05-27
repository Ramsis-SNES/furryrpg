;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** EFFECTS: TRANSITIONS ***
;
;==========================================================================================



.ACCU 8
.INDEX 16



; ****************** Split horizontal in (from black) ******************

EffectHSplitIn:								; FIXME (occasional gfx glitches on real SNES)



; -------------------------- channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	$4310
	stz	$4311							; PPU reg. $2100
	ldx	#SRC_HDMA_MainEffects
	stx	$4312
	lda	#:SRC_HDMA_MainEffects
	sta	$4314
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4317



; -------------------------- start with black screen, so zero out table
	ldx	#0
-	stz	ARRAY_HDMA_MainEffects, x
	inx
	cpx	#224
	bne	-

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMAchannels



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
	lda	ARRAY_HDMA_MainEffects, x
	cmp	#$0F							; don't increment value if it's already reached #$0F
	bcs	+
	inc	a
	sta	ARRAY_HDMA_MainEffects, x
+	inx
	iny
	cpy	temp+4							; max. no. of scanlines done?
	bne	__HSplitInSubLoop1

	ldx	#112
	ldy	#0

__HSplitInSubLoop2:							; loop 2: go towards start of table
	dex
	lda	ARRAY_HDMA_MainEffects, x
	cmp	#$0F
	bcs	+
	inc	a
	sta	ARRAY_HDMA_MainEffects, x
+	iny
	cpy	temp+4
	bne	__HSplitInSubLoop2

	lda	temp+4							; 112 scanlines in each direction done?
	cmp	#112
	bcs	+

	inc	temp+4							; no, scanline counter max. += 2
	inc	temp+4

+	lda	ARRAY_HDMA_MainEffects					; yes, repeat a few more times until first byte of table is #$0F
	cmp	#$0F
	bne	__HSplitInMainLoop

	lda	#%00000010						; deactivate channel 1
	trb	DP_HDMAchannels
	rts



; ****************** Split horizontal out (to black) *******************

EffectHSplitOut:							; split out from the middle of the screen // FIXME (occasional gfx glitches on real SNES)



; -------------------------- channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	$4310
	stz	$4311							; PPU reg. $2100
	ldx	#SRC_HDMA_MainEffects
	stx	$4312
	lda	#:SRC_HDMA_MainEffects
	sta	$4314
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4317



; -------------------------- start with full brightness
	lda	#$0F
	ldx	#0

-	sta	ARRAY_HDMA_MainEffects, x
	inx
	cpx	#224
	bne	-

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMAchannels



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
	lda	ARRAY_HDMA_MainEffects, x
	beq	+							; don't decrement value if it's already reached #$00
	dec	a
	sta	ARRAY_HDMA_MainEffects, x
+	inx
	iny
	cpy	temp+4							; max. no. of scanlines done?
	bne	__HSplitOutSubLoop1

	ldx	#112
	ldy	#0

__HSplitOutSubLoop2:							; loop 2: go towards start of table
	dex
	lda	ARRAY_HDMA_MainEffects, x
	beq	+
	dec	a
	sta	ARRAY_HDMA_MainEffects, x
+	iny
	cpy	temp+4
	bne	__HSplitOutSubLoop2

	lda	temp+4							; 112 scanlines in each direction done?
	cmp	#112
	bcs	+

	inc	temp+4							; no, scanline counter max. += 2
	inc	temp+4

+	lda	ARRAY_HDMA_MainEffects					; yes, repeat a few more times until first byte of table is #$00
	bne	__HSplitOutMainLoop

	lda	#%00000010						; deactivate channel 1
	trb	DP_HDMAchannels

	WaitFrames	1						; wait for HDMA register update

	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	rts



EffectHSplitOut2:							; split out towards the middle of the screen // FIXME (occasional gfx glitches on real SNES)



; -------------------------- channel 1: main effects channel
	lda	#$40							; transfer mode (1 byte --> $2100), indirect table mode
	sta	$4310
	stz	$4311							; PPU reg. $2100
	ldx	#SRC_HDMA_MainEffects
	stx	$4312
	lda	#:SRC_HDMA_MainEffects
	sta	$4314
	lda	#$7E							; indirect HDMA CPU bus data address bank
	sta	$4317



; -------------------------- start with full brightness
	lda	#$0F
	ldx	#0

-	sta	ARRAY_HDMA_MainEffects, x
	inx
	cpx	#224
	bne	-

	lda	#%00000010						; activate HDMA channel 1
	tsb	DP_HDMAchannels



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
	lda	ARRAY_HDMA_MainEffects, x
	beq	+							; don't decrement value if it's already reached #$00
	dec	a
	sta	ARRAY_HDMA_MainEffects, x
+	iny
	cpy	temp+4							; max. no. of scanlines done?
	bne	__HSplitOut2SubLoop1

	ldx	#0							; loop 2: go from beginning towards middle of table
	ldy	#0

__HSplitOut2SubLoop2:
	lda	ARRAY_HDMA_MainEffects, x
	beq	+
	dec	a
	sta	ARRAY_HDMA_MainEffects, x
+	inx
	iny
	cpy	temp+4
	bne	__HSplitOut2SubLoop2

	lda	temp+4							; 112 scanlines in each direction done?
	cmp	#112
	bcs	+

	inc	temp+4							; no, scanline counter max. += 2
	inc	temp+4

+	lda	ARRAY_HDMA_MainEffects+112				; yes, repeat a few more times until the byte in the middle of the table is #$00
	bne	__HSplitOut2MainLoop

	lda	#%00000010						; deactivate channel 1
	trb	DP_HDMAchannels

	WaitFrames	1						; wait for HDMA register update

	lda	#$80							; enter forced blank
	sta	REG_INIDISP
	rts



; ******************************** EOF *********************************
