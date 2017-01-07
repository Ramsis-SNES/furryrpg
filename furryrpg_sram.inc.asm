;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (http://manuloewe.de/)
;
;	*** SRAM HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

CheckSRAM:
	lda	#ADDR_SRAM_Bank						; set start address to SRAM data
	sta	temp+7

	Accu16

	lda	#(ADDR_SRAM_Slot1 & $FFFF)
	sta	temp+5
	lda	#$01FE							; assume ADDR_SRAM_ChksumCmpl = $FFFF and ADDR_SRAM_Chksum = $0000, so add these right now
	sta	temp+3

	ldy	#0
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#<ADDR_SRAM_ChksumCmpl					; location of SRAM checksum complement & checksum reached?
	bne	-

	ldy	#<ADDR_SRAM_Slot1Data					; skip both
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#$2000							; end of SRAM data reached?
	bne	-

	lda	temp+3
	cmp	ADDR_SRAM_Chksum
	bne	__SRAMBad

	eor	#$FFFF
	cmp	ADDR_SRAM_ChksumCmpl
	beq	__SRAMGood

__SRAMBad:
	lda	#$0000							; checksum invalid, zero out SRAM data
	ldx	#$0000
-	sta	ADDR_SRAM_Slot1, x
	inx
	inx
	cpx	#8192
	bne	-

	lda	#$01FE							; write good checksum (has to be $01FE when everything else is zero)
	sta	ADDR_SRAM_Chksum
	xba								; write checksum complement ($FE01)
	sta	ADDR_SRAM_ChksumCmpl

__SRAMGood:
	Accu8

	rtl



WriteDataToSRAM:							; this routine expects the 24-bit source data address in DP_DataSrcAddress, destination offset (with data length added) in X, and data length in Y
	dex								; decrement X for actual dest offset of last data byte
	dey								; decrement Y for actual src offset of last data byte
-	lda	[DP_DataSrcAddress], y
	sta.l	$B00000, x
	dex
	dey
	cpy	#$FFFF							; all bytes written?
	bne	-

	jsr	FixSRAMChecksum

	rtl



FixSRAMChecksum:
	lda	#ADDR_SRAM_Bank						; set start address to SRAM data
	sta	temp+7

	Accu16

	lda	#(ADDR_SRAM_Slot1 & $FFFF)
	sta	temp+5
	lda	#$01FE							; assume ADDR_SRAM_ChksumCmpl = $FFFF and ADDR_SRAM_Chksum = $0000, so add these right now
	sta	temp+3
	ldy	#0
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#<ADDR_SRAM_ChksumCmpl					; location of SRAM checksum complement & checksum reached?
	bne	-

	ldy	#<ADDR_SRAM_Slot1Data					; skip both
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#$2000							; end of SRAM data reached?
	bne	-

	lda	temp+3							; write new checksum
	sta	ADDR_SRAM_Chksum
	eor	#$FFFF							; and complement
	sta	ADDR_SRAM_ChksumCmpl

	Accu8

	rts



; ******************************** EOF *********************************
