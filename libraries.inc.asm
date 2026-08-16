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

; Math routines from the 6502.org source library
; MULTI5 CONNECT CHECK
; Random Number Generator for SNES by Finn Shore



; MATH ROUTINES FROM 6502.ORG
; --------------------------------------------------------------------------------------------------

.ACCU 16
.INDEX 16

;-----------------------------
; 32 by 16 bit division (c) by Garth Wilson
; http://6502.org/source/integers/ummodfix/ummodfix.htm
;
                        ; +-----|-----+-----|-----+-----|-----+-----|------+
                        ; |  DIVISOR  |    D I V I D E N D    |temp storage|
                        ; |           |  hi cell     lo cell  |of carry bit|
                        ; |  N    N+1 | N+2   N+3 | N+4   N+5 | N+6   N+7  |
                        ; +-----|-----+-----|-----+-----|-----+-----|------+
;
Div32by16:
	lda	7, s							; high word of 32-bit dividend
	sta	<DP2.Temp+2
	lda	5, s							; low word of 32-bit dividend
	sta	<DP2.Temp+4
	lda	3, s							; 16-bit divisor
	sta	<DP2.Temp
	stz	<DP2.Temp+6						; clear 16-bit of temp storage

        SEC								; Detect overflow or /0 condition.  To find out, sub-
        LDA     DP2.Temp+2						; tract divisor from hi cell of dividend; if C flag
        SBC     DP2.Temp						; remains set, divisor was not big enough to avoid
        BCS     @uoflo							; overflow.  This also takes care of any /0 conditions.
									; If branch not taken, C flag is left clear for 1st ROL.
									; We will loop 16x; but since we shift the dividend
        LDX     #17							; over at the same time as shifting the answer in, the
									; operation must start AND finish with a shift of the
									; lo cell of the dividend (which ends up holding the
;       INDEX_16							; quotient), so we start with 17 in X.  We will use Y
									; for temporary storage too, so set index reg.s 16-bit.
@ushftl:
	ROL     DP2.Temp+4						; Move lo cell of dividend left one bit, also shifting
									; answer in.  The 1st rotation brings in a 0, which
        DEX								; later gets pushed off the other end in the last
        BEQ     @umend							; rotation.     Branch to the end if finished.

        ROL     DP2.Temp+2						; Shift hi cell of dividend left one bit, also shifting
        LDA     #0							; next bit in from high bit of lo cell.
        ROL     A
        STA     DP2.Temp+6						; Store old hi bit of dividend in N+6.

        SEC								; See if divisor will fit into hi 17 bits of dividend
        LDA     DP2.Temp+2						; by subtracting and then looking at carry flag.
        SBC     DP2.Temp						; If carry got cleared, divisor did not fit.
        TAY								; Save the difference in Y until we know if we need it.

        LDA     DP2.Temp+6						; Bit 0 of N+6 serves as 17th bit.
        SBC     #0							; Complete the subtraction by doing the 17th bit before
        BCC     @ushftl							; determining if the divisor fit into the hi 17 bits of
									; the dividend.  If so, the C flag remains set.
        STY     DP2.Temp+2						; If divisor fit into hi 17 bits, update dividend hi
        BRA     @ushftl							; cell to what it would be after subtraction.    Branch.

 @uoflo:
 	LDA     #$FFFF							; If an overflow or /0 condition occurs, put FFFF in
        STA     DP2.Temp+4						; both the quotient
        STA     DP2.Temp+2						; and the remainder.

 @umend:

	rts



; Fast Multiply by 10
; By Leo Nechaev (leo@ogpi.orsk.ru), 28 October 2000.

; https://6502.org/source/integers/fastx10.htm

MULT10:
	ASL         ;multiply by 2
	STA <DP2.Temp    ;temp store in TEMP
	ASL         ;again multiply by 2 (*4)
	ASL         ;again multiply by 2 (*8)
	CLC
	ADC <DP2.Temp    ;as result, A = x*8 + x*2
;	RTS

	rtl



; Fast Multiplication Using tables
; By Martin Arndt, 6 January 2004.

; https://6502.org/source/integers/fastmult.htm

;    	JSR	FastMultInit    ;first build the tables LO8.FastMultTable1..LO8.FastMultTable4 and init zp1-zp4

/* ------ Actual code snippet for multiplication (unused for now)

	Accu8
	Index8

    	LDY #$66    ;factor 1 in y
    	LDA #$12    ;factor 2 in a

    	STA <DP2.zp1     ;set zp addresses
    	STA <DP2.zp2
    	EOR #$ff
    	STA <DP2.zp3
    	STA <DP2.zp4

    	SEC
    	LDA (<DP2.zp1),y
    	SBC (<DP2.zp3),y
    	TAX         ;product lo in x
    	LDA (<DP2.zp2),y
        SBC (<DP2.zp4),y ;product hi in a

------ snip ------ */



FastMultInit:
	php

	Accu8
	Index8

	LDX #0      ;build square tables
    	STX LO8.FastMultTable3+$fe
    	STX LO8.FastMultTable4+$fe
    	LDY #$ff

@loop1:
	TXA
    	LSR
    	CLC
    	ADC LO8.FastMultTable3+$fe,x
    	STA LO8.FastMultTable1,x
    	STA LO8.FastMultTable3+$ff,x
    	STA LO8.FastMultTable3,y
    	LDA #0
    	ADC LO8.FastMultTable4+$fe,x
    	STA LO8.FastMultTable2,x
    	STA LO8.FastMultTable4+$ff,x
    	STA LO8.FastMultTable4,y
    	DEY
    	INX
    	BNE @loop1

@loop2:
	TXA
    	SEC
    	ROR
    	CLC
    	ADC LO8.FastMultTable1+$ff,x
    	STA LO8.FastMultTable1+$100,x
    	LDA #0
    	ADC LO8.FastMultTable2+$ff,x
    	STA LO8.FastMultTable2+$100,x
    	INX
    	BNE @loop2

    	LDA #>LO8.FastMultTable1  ;init zp addresses
    	STA <DP2.zp1+1
    	LDA #>LO8.FastMultTable2
    	STA <DP2.zp2+1
    	LDA #>LO8.FastMultTable3
    	STA <DP2.zp3+1
    	LDA #>LO8.FastMultTable4
    	STA <DP2.zp4+1

    	plp

    	rtl



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
