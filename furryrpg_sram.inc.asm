;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** SRAM HANDLER ***
;
;==========================================================================================



.INDEX 16

CheckSRAM:
	A16

	lda ADDR_SRAM_SLOT1CHKSUM		; check slot 1 integrity
	eor #$FFFF
	cmp ADDR_SRAM_SLOT1CHKSUM+2
	beq +

	lda #$0000				; slot 1 checksum invalid, zero out slot 1 data
	ldx #$0000

-	sta ADDR_SRAM_SLOT1, x
	inx
	inx

	cpx #2048
	bne -

+	lda ADDR_SRAM_SLOT2CHKSUM		; check slot 2 integrity
	eor #$FFFF
	cmp ADDR_SRAM_SLOT2CHKSUM+2
	beq +

	lda #$0000				; slot 2 checksum invalid, zero out slot 2 data
	ldx #$0000

-	sta ADDR_SRAM_SLOT2, x
	inx
	inx

	cpx #2048
	bne -

+	lda ADDR_SRAM_SLOT3CHKSUM		; check slot 3 integrity
	eor #$FFFF
	cmp ADDR_SRAM_SLOT3CHKSUM+2
	beq +

	lda #$0000				; slot 3 checksum invalid, zero out slot 3 data
	ldx #$0000

-	sta ADDR_SRAM_SLOT3, x
	inx
	inx

	cpx #2048
	bne -

+	lda ADDR_SRAM_SLOT4CHKSUM		; check slot 4 integrity
	eor #$FFFF
	cmp ADDR_SRAM_SLOT4CHKSUM+2
	beq +

	lda #$0000				; slot 4 checksum invalid, zero out slot 4 data
	ldx #$0000

-	sta ADDR_SRAM_SLOT4, x
	inx
	inx

	cpx #2048
	bne -

+	A8
rts



; ******************************** EOF *********************************
