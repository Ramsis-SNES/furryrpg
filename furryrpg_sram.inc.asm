;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** SRAM HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

CheckSRAM:
	lda	#ADDR_SRAM_BANK						; set start address to SRAM data
	sta	temp+7

	Accu16

	lda	#(ADDR_SRAM_SLOT1 & $FFFF)
	sta	temp+5
	lda	#$01FE							; assume ADDR_SRAM_CHKSUMCMPL = $FFFF and ADDR_SRAM_CHKSUM = $0000, so add these right now
	sta	temp+3

	ldy	#0
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#<ADDR_SRAM_CHKSUMCMPL					; location of SRAM checksum complement & checksum reached?
	bne	-

	ldy	#<ADDR_SRAM_SLOT1DATA					; skip both
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#$2000							; end of SRAM data reached?
	bne	-

	lda	temp+3
	cmp	ADDR_SRAM_CHKSUM
	bne	__SRAMBad

	eor	#$FFFF
	cmp	ADDR_SRAM_CHKSUMCMPL
	beq	__SRAMGood

__SRAMBad:
	lda	#$0000							; checksum invalid, zero out SRAM data
	ldx	#$0000
-	sta	ADDR_SRAM_SLOT1, x
	inx
	inx
	cpx	#8192
	bne	-

	lda	#$01FE							; write good checksum (has to be $01FE when everything else is zero)
	sta	ADDR_SRAM_CHKSUM
	xba								; write checksum complement ($FE01)
	sta	ADDR_SRAM_CHKSUMCMPL

__SRAMGood:
	Accu8

	rts



FixSRAMChecksum:
	lda	#ADDR_SRAM_BANK						; set start address to SRAM data
	sta	temp+7

	Accu16

	lda	#(ADDR_SRAM_SLOT1 & $FFFF)
	sta	temp+5
	lda	#$01FE							; assume ADDR_SRAM_CHKSUMCMPL = $FFFF and ADDR_SRAM_CHKSUM = $0000, so add these right now
	sta	temp+3
	ldy	#0
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#<ADDR_SRAM_CHKSUMCMPL					; location of SRAM checksum complement & checksum reached?
	bne	-

	ldy	#<ADDR_SRAM_SLOT1DATA					; skip both
-	lda	[temp+5], y
	and	#$00FF
	clc
	adc	temp+3
	sta	temp+3
	iny
	cpy	#$2000							; end of SRAM data reached?
	bne	-

	lda	temp+3							; write new checksum
	sta	ADDR_SRAM_CHKSUM
	eor	#$FFFF							; and complement
	sta	ADDR_SRAM_CHKSUMCMPL

	Accu8

	rts



; ******************************** EOF *********************************
