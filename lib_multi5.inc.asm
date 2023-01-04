;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MULTIPLAYER STUFF ***
;
;==========================================================================================



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



; ******************************** EOF *********************************
