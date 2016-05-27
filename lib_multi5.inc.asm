;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** MULTIPLAYER STUFF ***
;
;==========================================================================================



.DB "START OF MULTI5 CONNECT CHECK"

check_mpa:
	php

	AccuIndex8

	stz	DP_Multi5_Status

-	lda	$4212							; automatic controller read enabled?
	and	#$01
	bne	-

; determine if MPA is connected or not?
	stz	$4016							; output "0" to out0
	lda	#$01
	sta	$4016							; output "1" to out0

	ldx	#$08
-	lda	$4016
	lsr	a
	lsr	a
	rol	DP_Multi5_Reg0hi					; read d1 of $4016 and store it to DP_Multi5_Reg0hi
	lda	$4017
	lsr	a
	lsr	a
	rol	DP_Multi5_Reg1hi					; read d1 of $4017 and store it to DP_Multi5_Reg1hi
	dex
	bne	-

	stz	$4016							; output "0" to out0

	ldx	#$08
-	lda	$4016
	lsr	a
	lsr	a
	rol	DP_Multi5_Reg0lo					; read d1 of $4016 and store it to DP_Multi5_Reg0lo
	lda	$4017
	lsr	a
	lsr	a
	rol	DP_Multi5_Reg1lo					; read d1 of $4017 and store it to DP_Multi5_Reg1lo
	dex
	bne	-

; determine if special device or MPA is connected?

; check controller port 1
	lda	DP_Multi5_Reg0hi
	cmp	#$FF							; is DP_Multi5_Reg0hi=$FF?
	bne	+							; YES -> determine if MPA or special device
									; NO -> branch, check connection on port 2
	lda	DP_Multi5_Reg0lo
	cmp	#$FF							; is DP_Multi5_Reg0lo=$FF?
	beq	+							; YES -> special device connected to port 1, jmp
									; NO -> MPA connected to port 1, set status
	lda	#$80
	sta	DP_Multi5_Status

; check controller port 2
+	lda	DP_Multi5_Reg1hi
	cmp	#$FF							; is DP_Multi5_Reg1hi=$FF?
	bne	+							; YES -> determine if MPA or special device
									; NO -> branch and return from routine
	lda	DP_Multi5_Reg1lo
	cmp	#$FF							; is DP_Multi5_Reg1lo=$FF?
	beq	+							; YES -> special device connected to port 2, return
									; NO -> MPA connected to port 2, set status
	lda	#$40
	ora	DP_Multi5_Status
	sta	DP_Multi5_Status

+	plp
	rtl

;.DB "NINTENDO SHVC MULTI5 CONNECT CHECK Ver1.00"
.DB "MODIFIED FROM SHVC MULTI5 CONNECT CHECK Ver1.00"
.DB "END OF MULTI5 CONNECT CHECK"



; ******************************** EOF *********************************
