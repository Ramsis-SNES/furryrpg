; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	LIBRARY CODE
;
; ==================================================================================================



; FILE CONTENTS
; --------------------------------------------------------------------------------------------------

; MULTI5 CONNECT CHECK
; Random Number Generator for SNES by Finn Shore



; MULTI5 CONNECT CHECK
; --------------------------------------------------------------------------------------------------

.DB "START OF MULTI5 CONNECT CHECK"

check_mpa:
	php

	AccuIndex8

	stz	<DP2.Multi5_Status
-	lda	HVBJOY							; automatic controller read enabled?
	and	#$01
	bne	-

; determine if MPA is connected or not?
	stz	JOYWR							; output "0" to out0
	lda	#$01
	sta	JOYWR							; output "1" to out0
	ldx	#$08
-	lda	JOYA
	lsr	a
	lsr	a
	rol	<DP2.Multi5_Reg0hi					; read d1 of $4016 and store it to DP_Multi5_Reg0hi
	lda	JOYB
	lsr	a
	lsr	a
	rol	<DP2.Multi5_Reg1hi					; read d1 of $4017 and store it to DP_Multi5_Reg1hi
	dex
	bne	-

	stz	JOYWR							; output "0" to out0
	ldx	#$08
-	lda	JOYA
	lsr	a
	lsr	a
	rol	<DP2.Multi5_Reg0lo					; read d1 of $4016 and store it to DP_Multi5_Reg0lo
	lda	JOYB
	lsr	a
	lsr	a
	rol	<DP2.Multi5_Reg1lo					; read d1 of $4017 and store it to DP_Multi5_Reg1lo
	dex
	bne	-

; determine if special device or MPA is connected?

; check controller port 1
	lda	<DP2.Multi5_Reg0hi
	cmp	#$FF							; is DP_Multi5_Reg0hi=$FF?
	bne	+							; YES -> determine if MPA or special device
									; NO -> branch, check connection on port 2
	lda	<DP2.Multi5_Reg0lo
	cmp	#$FF							; is DP_Multi5_Reg0lo=$FF?
	beq	+							; YES -> special device connected to port 1, jmp
									; NO -> MPA connected to port 1, set status
	lda	#$80
	sta	<DP2.Multi5_Status

; check controller port 2
+	lda	<DP2.Multi5_Reg1hi
	cmp	#$FF							; is DP_Multi5_Reg1hi=$FF?
	bne	+							; YES -> determine if MPA or special device
									; NO -> branch and return from routine
	lda	<DP2.Multi5_Reg1lo
	cmp	#$FF							; is DP_Multi5_Reg1lo=$FF?
	beq	+							; YES -> special device connected to port 2, return
									; NO -> MPA connected to port 2, set status
	lda	#$40
	ora	<DP2.Multi5_Status
	sta	<DP2.Multi5_Status
+	plp
	rtl

;.DB "NINTENDO SHVC MULTI5 CONNECT CHECK Ver1.00"
.DB "MODIFIED FROM SHVC MULTI5 CONNECT CHECK Ver1.00"
.DB "END OF MULTI5 CONNECT CHECK"



; RANDOM NUMBER GENERATOR
; --------------------------------------------------------------------------------------------------

; Random Number Generator for SNES by Finn Shore
; 
; $82 random byte table placed at $1100 to $1181
; table pointer placed at $1182

CreateRandomNr:
	php								; preserve processor status

	Accu16
	Index8

	ldy	#$80							; $80 byte table plus 2 byte first entry

__AGAIN:								; begin
	and	#$ff7f							; create random table pointer
	tax								; move pointer to x reg
	xba 
	rol	a							; throw away lost bit
	;adc	$213e							; read $213f to swtich H/V scroll to low byte (unnecessary)
	adc	$2136							; read $2137 to latch H/V scroll register ($4201 msb must be set, usually is)
	adc	$213c							; use H/V scroll value (sometimes fails to latch but still random)
	ror	LO8.RandomNumbers+1, x ;$1101,x				; rotate array location
	adc	LO8.RandomNumbers, x ;$1100,x				; use low byte as high byte
	sta	LO8.RandomNumbers, y ;$1100,y				; complete entry
	dey
	beq	__AGAIN							; ensure final entry is written
	bvs	__SKIP							; randomize entry location by (0,1)
	dey

__SKIP:
	bpl	__AGAIN							; redo until finished

;	tdc								; transfer direct page usually #0000 to A
;	sta	$1182							; zero pointer at $1182 or choose location

	plp								; restore processor status
	rts



; EOF
