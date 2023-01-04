;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** RANDOM NUMBER GENERATOR ***
;
;==========================================================================================



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



; ******************************** EOF *********************************
