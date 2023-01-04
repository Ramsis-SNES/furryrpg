;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** SRAM HANDLER ***
;
;==========================================================================================



CheckSRAM:
	.ACCU 8
	.INDEX 16

	lda	#bankbyte(SRAM)						; set start address to SRAM data
	sta	<DP2.Temp+7

	Accu16

	lda	#loword(SRAM)
	sta	<DP2.Temp+5
	lda	#$01FE							; assume ChecksumCmpl = $FFFF and Checksum = $0000, so add these up right now
	sta	<DP2.Temp+3

	ldy	#0
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#lobyte(SRAM.ChecksumCmpl)				; location of SRAM checksum complement & checksum reached? // self-reminder: Use low byte here as y is zero-based and Temp+5 contains SRAM offset in middle byte. As it's an immediate value, WLA DX will still generate $00 as the high byte of a 16-bit operand.
	bne	-

	ldy	#lobyte(SRAM.Checksum+2)				; skip both // ditto
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#8192							; all SRAM data checked?
	bne	-

	lda	<DP2.Temp+3						; Temp+3 now contains the sum of all SRAM bytes
	cmp	SRAM.Checksum						; compare sum to checksum
	bne	@ClearSRAM

	eor	#$FFFF							; compare checksum XOR $FFFF to complement
	cmp	SRAM.ChecksumCmpl
	beq	@SRAMGood

@ClearSRAM:								; checksum and/or complement invalid means SRAM is corrupt
	lda	#$0000
	ldx	#$0000
-	sta	SRAM, x							; zero out SRAM data
	inx
	inx
	cpx	#8192
	bne	-

	lda	#$01FE							; write good checksum (has to be $01FE when everything else is zero)
	sta	SRAM.Checksum
	xba								; write checksum complement ($FE01)
	sta	SRAM.ChecksumCmpl

@SRAMGood:
	Accu8

	rtl



FixSRAMChecksum:
	lda	#bankbyte(SRAM)						; set start address to SRAM data
	sta	<DP2.Temp+7

	Accu16

	lda	#loword(SRAM)
	sta	<DP2.Temp+5
	lda	#$01FE							; assume ChecksumCmpl = $FFFF and Checksum = $0000, so add these right now
	sta	<DP2.Temp+3
	ldy	#0
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#lobyte(SRAM.ChecksumCmpl)				; location of SRAM checksum complement & checksum reached? // self-reminder as in CheckSRAM above
	bne	-

	ldy	#lobyte(SRAM.Checksum+2)				; skip both // ditto
-	lda	[<DP2.Temp+5], y
	and	#$00FF
	clc
	adc	<DP2.Temp+3
	sta	<DP2.Temp+3
	iny
	cpy	#8192							; end of SRAM data reached?
	bne	-

	lda	<DP2.Temp+3						; write new checksum and complement
	sta	SRAM.Checksum
	eor	#$FFFF
	sta	SRAM.ChecksumCmpl

	Accu8

	rts



WriteDataToSRAM:							; this routine expects the 24-bit source data address in DP2.DataAddress, destination offset (with data length added) in X, and data length in Y
-	dex								; counting down dest from (last data byte index + 1)
	dey								; counting down src from transfer length
	lda	[<DP2.DataAddress], y
	sta.l	bankbyte(SRAM)<<16, x					; x contains offset in middle byte, so just use SRAM bank as a base for writing bytes
	cpy	#0							; all bytes written?
	bne	-

	jsr	FixSRAMChecksum

	rtl



; ******************************** EOF *********************************
