; SNESGSS sound driver code (0200 - 0B23)
;
; Disassembly by Ramsis, July 2022.
; Original code (in 6502-style syntax) by Shiru (?).



..ffc0 mov   x, #$ef           A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..ffc2 mov   sp, x             A:00 X:ef Y:00 SP:01ef YA:0000 N.......
..ffc3 mov   a, #$00           A:00 X:ef Y:00 SP:01ef YA:0000 N.......
..ffc5 mov   (x), a            A:00 X:ef Y:00 SP:01ef YA:0000 ......Z.
..ffc6 dec   x                 A:00 X:ef Y:00 SP:01ef YA:0000 ......Z.
..ffc7 bne   $ffc5             A:00 X:ee Y:00 SP:01ef YA:0000 N.......
..ffc9 mov   $0f4, #$aa        A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..ffcc mov   $0f5, #$bb        A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..ffcf cmp   $0f4, #$cc        A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..ffd2 bne   $ffcf             A:00 X:00 Y:00 SP:01ef YA:0000 ........
..ffd4 bra   $ffef             A:00 X:00 Y:00 SP:01ef YA:0000 ......ZC
..ffef movw  ya, $0f6          A:00 X:00 Y:00 SP:01ef YA:0000 ......ZC
..fff1 movw  $000,ya           A:00 X:00 Y:02 SP:01ef YA:0200 .......C
..fff3 movw  ya, $0f4          A:00 X:00 Y:02 SP:01ef YA:0200 .......C
..fff5 mov   $0f4, a           A:cc X:00 Y:01 SP:01ef YA:01cc .......C
..fff7 mov   a, y              A:cc X:00 Y:01 SP:01ef YA:01cc .......C
..fff8 mov   x, a              A:01 X:00 Y:01 SP:01ef YA:0101 .......C
..fff9 bne   $ffd6             A:01 X:01 Y:01 SP:01ef YA:0101 .......C
..ffd6 mov   y, $0f4           A:01 X:01 Y:01 SP:01ef YA:0101 .......C
..ffd8 bne   $ffd6             A:01 X:01 Y:cc SP:01ef YA:cc01 N......C
..ffda cmp   y, $0f4           A:01 X:01 Y:00 SP:01ef YA:0001 ......ZC
..ffdc bne   $ffe9             A:01 X:01 Y:00 SP:01ef YA:0001 ......ZC
..ffde mov   a, $0f5           A:01 X:01 Y:00 SP:01ef YA:0001 ......ZC
..ffe0 mov   $0f4, y           A:20 X:01 Y:00 SP:01ef YA:0020 .......C
..ffe2 mov   ($000)+y, a       A:20 X:01 Y:00 SP:01ef YA:0020 .......C
..ffe4 inc   y                 A:20 X:01 Y:00 SP:01ef YA:0020 .......C
..ffe5 bne   $ffda             A:20 X:01 Y:01 SP:01ef YA:0120 .......C
..ffe9 bpl   $ffda             A:20 X:01 Y:01 SP:01ef YA:0120 .......C
..ffe7 inc   $001              A:14 X:01 Y:00 SP:01ef YA:0014 ......ZC
..ffeb cmp   y, $0f4           A:fe X:01 Y:24 SP:01ef YA:24fe N.......
..ffed bpl   $ffda             A:fe X:01 Y:24 SP:01ef YA:24fe N.......
..fffb jmp   ($0000+x)         A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.

..0200 clrp                    A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..0201 mov   x, #$ef           A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..0203 mov   sp, x             A:00 X:ef Y:00 SP:01ef YA:0000 N.......
..0204 bra   $0219             A:00 X:ef Y:00 SP:01ef YA:0000 N.......

; missing
; 2F 06 12 0B 24 0B 25 0B 3F B9 06 CD 01 D8 02 1D 3F 4F 04
;
; manual disassembly:

	bra	_020e		; 2F 06
	.dw	$0b12		; 12 0B		; 16-bit pointer
	.dw	$0b24		; 24 0B		; 16-bit pointer
	.dw	$0b25		; 25 0B		; 16-bit pointer
_020e	call	$06b9		; 3F B9 06

	mov	x, #$01		; CD 01
	mov	$002, x		; D8 02
	dec	x		; 1D
	call	$044f		; 3F 4F 04

..0219 mov   a, #$32           A:00 X:ef Y:00 SP:01ef YA:0000 N.......
..021b mov   $0fa, a           A:32 X:ef Y:00 SP:01ef YA:0032 ........
..021d mov   a, #$81           A:32 X:ef Y:00 SP:01ef YA:0032 ........
..021f mov   $0f1, a           A:81 X:ef Y:00 SP:01ef YA:0081 N.......
..0221 call  $0719             A:81 X:ef Y:00 SP:01ef YA:0081 N.......

..0224 mov   a, $0f4           A:81 X:ef Y:00 SP:01ef YA:0081 ......Z.
..0226 beq   $0237             A:00 X:ef Y:00 SP:01ef YA:0000 ......Z.
..0228 mov   $0f4, a           A:01 X:ef Y:00 SP:01ef YA:0001 ........
..022a mov   y, a              A:01 X:ef Y:00 SP:01ef YA:0001 ........
..022b and   a, #$0f           A:01 X:ef Y:01 SP:01ef YA:0101 ........
..022d asl   a                 A:01 X:ef Y:01 SP:01ef YA:0101 ........
..022e mov   x, a              A:02 X:ef Y:01 SP:01ef YA:0102 ........
..022f mov   a, y              A:02 X:02 Y:01 SP:01ef YA:0102 ........
..0230 xcn   a                 A:01 X:02 Y:01 SP:01ef YA:0101 ........
..0231 and   a, #$0f           A:10 X:02 Y:01 SP:01ef YA:0110 ........
..0233 mov   y, a              A:00 X:02 Y:01 SP:01ef YA:0100 ......Z.
..0234 jmp   ($08e9+x)         A:00 X:02 Y:00 SP:01ef YA:0000 ......Z.

..0237 call  $0705             A:00 X:ef Y:00 SP:01ef YA:0000 ......Z.

..023a mov   a, $0fd           A:01 X:ef Y:00 SP:01ef YA:0001 ........
..023c beq   $0224             A:00 X:ef Y:00 SP:01ef YA:0000 ......Z.
..023e call  $082a             A:02 X:fc Y:00 SP:01ef YA:0002 .......C

..0241 call  $04df             A:7f X:1c Y:00 SP:01ef YA:007f .......C

..0244 bra   $0224             A:00 X:5c Y:00 SP:01ef YA:0000 ......ZC

..0246 call  $0719             A:00 X:02 Y:00 SP:01ef YA:0000 ......Z.

..0249 call  $06b9             A:00 X:02 Y:00 SP:01ef YA:0000 ......Z.

..024c bra   $0237             A:c3 X:fc Y:00 SP:01ef YA:00c3 N......C

..024e mov   a, $0f6           A:00 X:06 Y:00 SP:01ef YA:0000 ......Z.
..0250 mov   $002, a           A:01 X:06 Y:00 SP:01ef YA:0001 ........
..0252 call  $0719             A:01 X:06 Y:00 SP:01ef YA:0001 ........

..0255 bra   $0237             A:01 X:06 Y:00 SP:01ef YA:0001 ......Z.

..0257 mov   a, $0f6           A:00 X:08 Y:00 SP:01ef YA:0000 ......Z.
..0259 mov   x, $0f7           A:7f X:08 Y:00 SP:01ef YA:007f ........
..025b call  $0719             A:7f X:ff Y:00 SP:01ef YA:007f N.......

..025e cmp   a, #$7f           A:7f X:ff Y:00 SP:01ef YA:007f ......Z.
..0260 bcc   $0264             A:7f X:ff Y:00 SP:01ef YA:007f ......ZC
..0262 mov   a, #$7f           A:7f X:ff Y:00 SP:01ef YA:007f ......ZC
..0264 asl   a                 A:7f X:ff Y:00 SP:01ef YA:007f .......C
..0265 mov   $016, a           A:fe X:ff Y:00 SP:01ef YA:00fe N.......
..0267 mov   $018, x           A:fe X:ff Y:00 SP:01ef YA:00fe N.......
..0269 bra   $0237             A:fe X:ff Y:00 SP:01ef YA:00fe N.......

; missing
; E4 F6 F8 F7 3F 19 07 68 7F 90 02 E8 7F 1C FD 7D CD 00 7C 90 02 DB 30 3D C8 08 D0 F6 3F 17 08 2F AB
;
; manual disassembly:

_026b	mov	a, $0f6		; E4 F6
	mov	x, $0f7		; F8 F7
	call	$0719		; 3F 19 07

	cmp	a, #$7f		; 68 7F
	bcc	_0278		; 90 02
	mov	a, #$7f		; E8 7F
_0278	asl	a		; 1C
	mov	y, a		; FD
	mov	a, x		; 7D
	mov	x, #$00		; CD 00
_027d	ror	a		; 7C
	bcc	_0282		; 90 02
	mov	$030+x, y	; DB 30
_0282	inc	x		; 3D
	cmp	x, #$08		; C8 08
	bne	_027d		; D0 F6

	call	$0817		; 3F 17 08

	bra	_0237		; 2F AB

..028c call  $0719             A:00 X:0c Y:00 SP:01ef YA:0000 ......Z.

..028f mov   x, #$00           A:00 X:0c Y:00 SP:01ef YA:0000 ......Z.
..0291 mov   $013, x           A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.
..0293 call  $044f             A:00 X:00 Y:00 SP:01ef YA:0000 ......Z.

..0296 jmp   $0237             A:80 X:05 Y:0b SP:01ef YA:0b80 ......Z.

; missing
; 3F 19 07 E8 08 C4 12 2F 0A
;
; manual disassembly:

_0299	call	$0719		; 3F 19 07

	mov	a, #$08		; E8 08
	mov	$012, a		; C4 12
	bra	_02ac		; 2F 0A

..02a2 call  $0719             A:00 X:0e Y:00 SP:01ef YA:0000 ......Z.

..02a5 mov   a, $012           A:00 X:0e Y:00 SP:01ef YA:0000 ......Z.
..02a7 bne   $02ac             A:00 X:0e Y:00 SP:01ef YA:0000 ......Z.
..02a9 jmp   $0237             A:00 X:0e Y:00 SP:01ef YA:0000 ......Z.

..02ac mov   a, #$00           A:05 X:0e Y:00 SP:01ef YA:0005 ........
..02ae push  a                 A:00 X:0e Y:00 SP:01ef YA:0000 ......Z.
..02af call  $0726             A:00 X:0e Y:00 SP:01ee YA:0000 ......Z.

..02b2 mov   x, $007           A:00 X:0e Y:00 SP:01ee YA:0000 ......Z.
..02b4 mov   a, #$00           A:00 X:00 Y:00 SP:01ee YA:0000 ......Z.
..02b6 mov   $050+x, a         A:00 X:00 Y:00 SP:01ee YA:0000 ......Z.
..02b8 call  $088d             A:00 X:00 Y:00 SP:01ee YA:0000 ......Z.

..02bb pop   a                 A:01 X:00 Y:00 SP:01ee YA:0001 ........
..02bc inc   a                 A:00 X:00 Y:00 SP:01ef YA:0000 ........
..02bd dec   $012              A:01 X:00 Y:00 SP:01ef YA:0001 ........
..02bf bne   $02ae             A:01 X:00 Y:00 SP:01ef YA:0001 ........

..02c1 call  $08cb             A:05 X:04 Y:00 SP:01ef YA:0005 ......Z.

..02c4 call  $08b1             A:1f X:04 Y:00 SP:01ef YA:001f ........

..02c7 jmp   $0237             A:00 X:5c Y:00 SP:01ef YA:0000 ......Z.

; missing
; E4 F6 C4 13 3F 19 07 3F 17 08 5F 37 02 7E 12 B0
; 06 3F 19 07 5F 37 02 CB 11 F8 F5 D8 0B E4 F6 F8
; F7 D8 0A 3F 19 07 8D 00 77 14 B0 11 1C FD FC F7
; 14 C4 0C FC F7 14 C4 0D F8 11 3F 82 04 5F 37 02
;
; manual disassembly:

_02ca	mov	a, $0f6		; E4 F6
	mov	$013, a		; C4 13
	call	$0719		; 3F 19 07

	call	$0817		; 3F 17 08

	jmp	$0237		; 5F 37 02

_02d7	cmp	y, $012		; 7E 12
	bcs	_02e1		; B0 06
	call	$0719		; 3F 19 07

	jmp	$0237		; 5F 37 02

_02e1	mov	$011, y		; CB 11
	mov	x, $0f5		; F8 F5
	mov	$00b, x		; D8 0B
	mov	a, $0f6		; E4 F6
	mov	x, $0f7		; F8 F7
	mov	$00a, x		; D8 0A
	call	$0719		; 3F 19 07

	mov	y, #$00		; 8D 00
	cmp	a, ($014)+y	; 77 14
	bcs	_0307		; B0 11
	asl	a		; 1C
	mov	y, a		; FD
	inc	y		; FC
	mov	a, ($014)+y	; F7 14
	mov	$00c, a		; C4 0C
	inc	y		; FC
	mov	a, ($014)+y	; F7 14
	mov	$00d, a		; C4 0D
	mov	x, $011		; F8 11
	call	$0482		; 3F 82 04

_0307	jmp	$0237		; 5F 37 02

..030a call  $0719             A:00 X:04 Y:00 SP:01ef YA:0000 ......Z.

..030d call  $03d8             A:00 X:04 Y:00 SP:01ef YA:0000 ......Z.

..0310 mov   x, #$00           A:00 X:20 Y:00 SP:01ef YA:0000 ......ZC
..0312 mov   $008, x           A:00 X:00 Y:00 SP:01ef YA:0000 ......ZC
..0314 dec   x                 A:00 X:00 Y:00 SP:01ef YA:0000 ......ZC
..0315 mov   $009, x           A:00 X:ff Y:00 SP:01ef YA:0000 N......C
..0317 call  $08cb             A:00 X:ff Y:00 SP:01ef YA:0000 N......C

..031a mov   x, #$ef           A:ff X:ff Y:00 SP:01ef YA:00ff N......C
..031c mov   sp, x             A:ff X:ef Y:00 SP:01ef YA:00ff N......C
..031d jmp   $ffc9             A:ff X:ef Y:00 SP:01ef YA:00ff N......C

; missing
; 3F 19 07 E8 00 C4 25 C4 24 3F 3C 04 3F E8 03 E8
; FF C4 20 CD CA 8D 0A 3F D4 08 E8 00 C5 7E 00 E8
; 7F C5 7F 00 3F 17 08 5F 37 02 3F 19 07 3F D8 03
; 5F 37 02 E4 20 F0 06 E4 25 64 24 D0 0A E8 00 C4
; F6 3F 19 07 5F 37 02 E8 01 C4 F6 3F 19 07 CD 01
; 3F 05 07 3E F4 D0 F9 EB 21 F7 22 28 03 04 F5 D7
; 22 FC E4 F6 D7 22 FC E4 F7 D7 22 FC 3D D8 F4 3F
; 05 07 3E F4 D0 F9 E4 F5 D7 22 FC E4 F6 D7 22 FC
; E4 F7 D7 22 FC 3D D8 F4 3F 05 07 3E F4 D0 F9 E4
; F5 D7 22 FC E4 F6 D7 22 FC E4 F7 D7 22 FC 3F 19
; 07 E8 00 C4 F6 CB 21 AD FC D0 0A E4 25 BC 28 07
; C4 25 3F 3C 04 5F 37 02
;
; manual disassembly:

_0320	call	$0719		; 3F 19 07

	mov	a, #$00		; E8 00
	mov	$025, a		; C4 25
	mov	$024, a		; C4 24
	call	$043c		; 3F 3C 04

	call	$03e8		; 3F E8 03

	mov	a, #$ff		; E8 FF
	mov	$020, a		; C4 20
	mov	x, #$ca		; CD CA
	mov	y, #$0a		; 8D 0A
	call	$08d4		; 3F D4 08

	mov	a, #$00		; E8 00
	mov	$007e, a	; C5 7E 00
	mov	a, #$7f		; E8 7F
	mov	$007f, a	; C5 7F 00
	call	$0817		; 3F 17 08

	jmp	$0237		; 5F 37 02

_034a	call	$0719		; 3F 19 07

	call	$03d8		; 3F D8 03

	jmp	$0237		; 5F 37 02

_0353	mov	a, $020		; E4 20
	beq	_035d		; F0 06
	mov	a, $025		; E4 25
	cmp	a, $024		; 64 24
	bne	_0367		; D0 0A
_035d	mov	a, #$00		; E8 00
	mov	$0f6, a		; C4 F6
	call	$0719		; 3F 19 07

	jmp	$0237		; 5F 37 02

_0367	mov	a, #$01		; E8 01
	mov	$0f6, a		; C4 F6
	call	$0719		; 3F 19 07

	mov	x, #$01		; CD 01
_0370	call	$0705		; 3F 05 07

	cmp	x, $0f4		; 3E F4
	bne	_0370		; D0 F9
	mov	y, $021		; EB 21
	mov	a, ($022)+y	; F7 22
	and	a, #$03		; 28 03
	or	a, $0f5		; 04 F5
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	mov	a, $0f6		; E4 F6
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	mov	a, $0f7		; E4 F7
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	inc	x		; 3D
	mov	$0f4, x		; D8 F4
_038f	call	$0705		; 3F 05 07

	cmp	x, $0f4		; 3E F4
	bne	_038f		; D0 F9
	mov	a, $0f5		; E4 F5
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	mov	a, $0f6		; E4 F6
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	mov	a, $0f7		; E4 F7
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	inc	x		; 3D
	mov	$0f4, x		; D8 F4
_03a8	call	$0705		; 3F 05 07

	cmp	x, $0f4		; 3E F4
	bne	_03a8		; D0 F9
	mov	a, $0f5		; E4 F5
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	mov	a, $0f6		; E4 F6
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	mov	a, $0f7		; E4 F7
	mov	($022)+y, a	; D7 22
	inc	y		; FC
	call	$0719		; 3F 19 07

	mov	a, #$00		; E8 00
	mov	$0f6, a		; C4 F6
	mov	$021, y		; CB 21
	cmp	y, #$fc		; AD FC	
	bne	_03d5		; D0 0A
	mov	a, $025		; E4 25
	inc	a		; BC
	and	a, #$07		; 28 07
	mov	$025, a		; C4 25
	call	$043C		; 3F 3C 04
_03d5	jmp	$0237		; 5F 37 02

..03d8 mov   a, #$00           A:00 X:04 Y:00 SP:01ed YA:0000 ......Z.
..03da mov   $020, a           A:00 X:04 Y:00 SP:01ed YA:0000 ......Z.
..03dc mov   a, #$5c           A:00 X:04 Y:00 SP:01ed YA:0000 ......Z.
..03de mov   $0f2, a           A:5c X:04 Y:00 SP:01ed YA:005c ........
..03e0 mov   a, #$c0           A:5c X:04 Y:00 SP:01ed YA:005c ........
..03e2 mov   $0f3, a           A:c0 X:04 Y:00 SP:01ed YA:00c0 N.......
..03e4 call  $0817             A:c0 X:04 Y:00 SP:01ed YA:00c0 N.......

..03e7 ret                     A:00 X:20 Y:00 SP:01ed YA:0000 ......ZC

..03e8 mov   x, #$00           A:ff X:08 Y:2c SP:01eb YA:2cff ......ZC
..03ea mov   a, #$1c           A:ff X:00 Y:2c SP:01eb YA:2cff ......ZC
..03ec mov   $011, a           A:1c X:00 Y:2c SP:01eb YA:2c1c .......C
..03ee mov   a, #$c0           A:1c X:00 Y:2c SP:01eb YA:2c1c .......C
..03f0 mov   $f6e4+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..03f3 mov   $f7e0+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..03f6 mov   $f8dc+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..03f9 mov   $f9d8+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..03fc mov   $fad4+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..03ff mov   $fbd0+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..0402 mov   $fccc+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..0405 mov   $fdc8+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..0408 mov   $fec4+x, a        A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..040b inc   x                 A:c0 X:00 Y:2c SP:01eb YA:2cc0 N......C
..040c mov   a, #$00           A:c0 X:01 Y:2c SP:01eb YA:2cc0 .......C
..040e mov   y, #$08           A:00 X:01 Y:2c SP:01eb YA:2c00 ......ZC
..0410 mov   $f6e4+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..0413 mov   $f7e0+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..0416 mov   $f8dc+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..0419 mov   $f9d8+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..041c mov   $fad4+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..041f mov   $fbd0+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..0422 mov   $fccc+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..0425 mov   $fdc8+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..0428 mov   $fec4+x, a        A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..042b inc   x                 A:00 X:01 Y:08 SP:01eb YA:0800 .......C
..042c dec   y                 A:00 X:02 Y:08 SP:01eb YA:0800 .......C
..042d bne   $0410             A:00 X:02 Y:07 SP:01eb YA:0700 .......C
..042f dec   $011              A:00 X:09 Y:00 SP:01eb YA:0000 ......ZC
..0431 bne   $03ee             A:00 X:09 Y:00 SP:01eb YA:0000 .......C
..0433 mov   a, #$c3           A:00 X:fc Y:00 SP:01eb YA:0000 ......ZC
..0435 mov   $febb,a           A:c3 X:fc Y:00 SP:01eb YA:00c3 N......C
..0438 mov   $ffb7,a           A:c3 X:fc Y:00 SP:01eb YA:00c3 N......C
..043b ret                     A:c3 X:fc Y:00 SP:01eb YA:00c3 N......C

; missing
; 1C 5D F5 8D 0A C5 22 00 F5 8E 0A C5 23 00 E8 00 C4 21 6F
;
; manual disassembly:

_043c	asl	a		; 1C
	mov	x, a		; 5D
	mov	a, $0a8d+x	; F5 8D 0A
	mov	$0022, a	; C5 22 00
	mov	a, $0a8e+x	; F5 8E 0A
	mov	$0023, a	; C5 23 00
	mov	a, #$00		; E8 00
	mov	$021, a		; C4 21
	ret			; 6F

..044f mov   a, $020c          A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..0452 mov   $00c, a           A:68 X:00 Y:00 SP:01ed YA:0068 ........
..0454 mov   a, $020d          A:68 X:00 Y:00 SP:01ed YA:0068 ........
..0457 mov   $00d, a           A:dc X:00 Y:00 SP:01ed YA:00dc N.......
..0459 mov   y, #$00           A:dc X:00 Y:00 SP:01ed YA:00dc N.......
..045b mov   a, ($00c)+y       A:dc X:00 Y:00 SP:01ed YA:00dc ......Z.
..045d mov   $012, a           A:05 X:00 Y:00 SP:01ed YA:0005 ........
..045f bne   $0464             A:05 X:00 Y:00 SP:01ed YA:0005 ........

; missing
; 5F 37 02
;
; manual disassembly:

	jmp	$0237		; 5F 37 02

..0464 mov   $011, a           A:05 X:00 Y:00 SP:01ed YA:0005 ........
..0466 inc   y                 A:05 X:00 Y:00 SP:01ed YA:0005 ........
..0467 push  x                 A:05 X:00 Y:01 SP:01ed YA:0105 ........
..0468 mov   a, x              A:05 X:00 Y:01 SP:01ec YA:0105 ........
..0469 call  $0726             A:00 X:00 Y:01 SP:01ec YA:0100 ......Z.

..046c push  y                 A:00 X:00 Y:01 SP:01ec YA:0100 ......Z.
..046d call  $04ad             A:00 X:00 Y:01 SP:01eb YA:0100 ......Z.

..0470 mov   a, #$80           A:dc X:00 Y:02 SP:01eb YA:02dc N.......
..0472 mov   $038+x, a         A:80 X:00 Y:02 SP:01eb YA:0280 N.......
..0474 pop   y                 A:80 X:00 Y:02 SP:01eb YA:0280 N.......
..0475 pop   x                 A:80 X:00 Y:01 SP:01ec YA:0180 N.......
..0476 inc   x                 A:80 X:00 Y:01 SP:01ed YA:0180 N.......
..0477 cmp   x, #$08           A:80 X:01 Y:01 SP:01ed YA:0180 ........
..0479 bcs   $0481             A:80 X:01 Y:01 SP:01ed YA:0180 N.......
..047b inc   y                 A:80 X:01 Y:01 SP:01ed YA:0180 N.......
..047c inc   y                 A:80 X:01 Y:02 SP:01ed YA:0280 ........
..047d dec   $011              A:80 X:01 Y:03 SP:01ed YA:0380 ........
..047f bne   $0467             A:80 X:01 Y:03 SP:01ed YA:0380 ........
..0481 ret                     A:80 X:05 Y:0b SP:01ed YA:0b80 ......Z.

; missing
; 8D 00 F7 0C C4 11 FC 4D 7D 3F 26 07 6D 3F AD 04
; E4 0B 68 7F 90 00 1C D4 30 E4 0A D4 38 EE CE 3D
; C8 08 B0 06 FC FC 8B 11 D0 DD 6F
;
; manual disassembly:

	mov	y, #$00		; 8D 00
	mov	a, ($00c)+y	; F7 0C
	mov	$011, a		; C4 11
	inc	y		; FC
_0489	push	x		; 4D
	mov	a, x		; 7D
	call	$0726		; 3F 26 07

	push	y		; 6D
	call	$04ad		; 3F AD 04

	mov	a, $00b		; E4 0B
	cmp	a, #$7F		; 68 7F
	bcc	_0498		; 90 00		; FIXME should branch in a meaningful way (sth not implemented?)
_0498	asl	a		; 1C
	mov	$030+x, a	; D4 30
	mov	a, $00a		; E4 0A
	mov	$038+x, a	; D4 38
	pop	y		; EE
	pop	x		; CE
	inc	x		; 3D
	cmp	x, #$08		; C8 08
	bcs	_04ac		; B0 06
	inc	y		; FC
	inc	y		; FC
	dec	$011		; 8B 11
	bne	_0489		; D0 DD
_04ac	ret			; 6F


..04ad call  $088d             A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.

..04b0 call  $08cb             A:01 X:00 Y:01 SP:01e9 YA:0101 ........

..04b3 mov   x, $007           A:01 X:00 Y:01 SP:01e9 YA:0101 ........
..04b5 mov   a, #$00           A:01 X:00 Y:01 SP:01e9 YA:0101 ......Z.
..04b7 mov   $068+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04b9 mov   $070+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04bb mov   $098+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04bd mov   $0a0+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04bf mov   $080+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04c1 mov   $088+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04c3 mov   $090+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04c5 mov   $0a8+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04c7 mov   $0b0+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04c9 mov   $0b8+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04cb mov   $060+x, a         A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04cd mov   a, #$04           A:00 X:00 Y:01 SP:01e9 YA:0100 ......Z.
..04cf mov   $058+x, a         A:04 X:00 Y:01 SP:01e9 YA:0104 ........
..04d1 mov   a, #$7f           A:04 X:00 Y:01 SP:01e9 YA:0104 ........
..04d3 mov   $078+x, a         A:7f X:00 Y:01 SP:01e9 YA:017f ........
..04d5 mov   a, ($00c)+y       A:7f X:00 Y:01 SP:01e9 YA:017f ........
..04d7 mov   $048+x, a         A:73 X:00 Y:01 SP:01e9 YA:0173 ........
..04d9 inc   y                 A:73 X:00 Y:01 SP:01e9 YA:0173 ........
..04da mov   a, ($00c)+y       A:73 X:00 Y:02 SP:01e9 YA:0273 ........
..04dc mov   $050+x, a         A:dc X:00 Y:02 SP:01e9 YA:02dc N.......
..04de ret                     A:dc X:00 Y:02 SP:01e9 YA:02dc N.......

..04df call  $086f             A:7f X:1c Y:00 SP:01ed YA:007f .......C

..04e2 mov   a, #$00           A:7f X:1c Y:00 SP:01ed YA:007f .......C
..04e4 push  a                 A:00 X:1c Y:00 SP:01ed YA:0000 ......ZC
..04e5 mov   x, $013           A:00 X:1c Y:00 SP:01ec YA:0000 ......ZC
..04e7 beq   $04ed             A:00 X:00 Y:00 SP:01ec YA:0000 ......ZC

; missing
; 64 12 90 0D
;
; manual disassembly:

	cmp	a, $012		; 64 12
	bcc	_04fa		; 90 0D

..04ed call  $0726             A:00 X:00 Y:00 SP:01ec YA:0000 ......ZC

..04f0 mov   a, #$00           A:00 X:00 Y:00 SP:01ec YA:0000 ......Z.
..04f2 mov   $00e, a           A:00 X:00 Y:00 SP:01ec YA:0000 ......Z.
..04f4 call  $0525             A:00 X:00 Y:00 SP:01ec YA:0000 ......Z.

..04f7 call  $077b             A:00 X:00 Y:00 SP:01ec YA:0000 ......Z.

..04fa pop   a                 A:00 X:00 Y:00 SP:01ec YA:0000 ......Z.
..04fb inc   a                 A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..04fc cmp   a, #$08           A:01 X:00 Y:00 SP:01ed YA:0001 ........
..04fe bne   $04e4             A:01 X:00 Y:00 SP:01ed YA:0001 N.......
..0500 call  $08cb             A:08 X:07 Y:00 SP:01ed YA:0008 ......ZC

..0503 call  $0897             A:00 X:07 Y:00 SP:01ed YA:0000 ......ZC

..0506 call  $08b1             A:00 X:07 Y:00 SP:01ed YA:0000 ......ZC

..0509 ret                     A:00 X:5c Y:00 SP:01ed YA:0000 ......ZC

..050a mov   y, #$00           A:3e X:04 Y:3f SP:01e8 YA:3f3e ....H...
..050c mov   a, ($00c)+y       A:3e X:04 Y:00 SP:01e8 YA:003e ....H.Z.
..050e incw  $00c              A:f8 X:04 Y:00 SP:01e8 YA:00f8 N...H...
..0510 push  a                 A:f8 X:04 Y:00 SP:01e8 YA:00f8 N...H...
..0511 mov   x, $007           A:f8 X:04 Y:00 SP:01e7 YA:00f8 N...H...
..0513 mov   a, $0b8+x         A:f8 X:00 Y:00 SP:01e7 YA:00f8 ....H.Z.
..0515 beq   $0523             A:00 X:00 Y:00 SP:01e7 YA:0000 ....H.Z.

..0517 dec   $0b8+x            A:1c X:04 Y:00 SP:01e7 YA:001c .......C
..0519 bne   $0523             A:1c X:04 Y:00 SP:01e7 YA:001c .......C

..051b mov   a, $0c0+x         A:01 X:00 Y:00 SP:01e7 YA:0001 ......ZC
..051d mov   $00c, a           A:fb X:00 Y:00 SP:01e7 YA:00fb N......C
..051f mov   a, $0c8+x         A:fb X:00 Y:00 SP:01e7 YA:00fb N......C
..0521 mov   $00d, a           A:dc X:00 Y:00 SP:01e7 YA:00dc N......C
..0523 pop   a                 A:00 X:00 Y:00 SP:01e7 YA:0000 ....H.Z.
..0524 ret                     A:f8 X:00 Y:00 SP:01e8 YA:00f8 ....H.Z.

..0525 mov   x, $007           A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..0527 mov   a, $050+x         A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..0529 bne   $052c             A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..052b ret                     A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.

..052c mov   $00d, a           A:dc X:00 Y:0b SP:01ea YA:0bdc N...H...
..052e mov   a, $048+x         A:dc X:00 Y:0b SP:01ea YA:0bdc N...H...
..0530 mov   $00c, a           A:73 X:00 Y:0b SP:01ea YA:0b73 ....H...
..0532 mov   a, $0a8+x         A:73 X:00 Y:0b SP:01ea YA:0b73 ....H...
..0534 mov   $00e, a           A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.
..0536 beq   $0546             A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.

; missing
; 28 0F 60 94 B0 68 C0 90 03 80 A8 C0 D4 B0
;
; manual disassembly:

	and	a, #$0f		; 28 0F
	clrc			; 60
	adc	a, $0b0+x	; 94 B0
	cmp	a, #$c0		; 68 C0
	bcc	_0544		; 90 03
	setc			; 80
	sbc	a, #$c0		; A8 C0
_0544	mov	$0b0+x, a	; D4 B0

..0546 mov   a, $090+x         A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.
..0548 bne   $0557             A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.
..054a mov   a, $088+x         A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.
..054c bne   $0551             A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.
..054e jmp   $05d5             A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.

; missing
; C4 0E 30 6B 2F 4E F4 70 74 A0 D0 04 F4 68 74 98
; F0 72 B0 1B AB 0E F4 68 60 94 90 D4 68 F4 70 88
; 00 D4 70 74 A0 D0 04 F4 68 74 98 B0 1D 2F 55 AB
; 0E F4 68 80 B4 90 D4 68 F4 70 A8 00 D4 70 74 A0
; D0 04 F4 68 74 98 90 02 2F 3A F4 98 D4 68 F4 A0
; D4 70 2F 30 F4 68 60 94 88 D4 68 F4 70 88 00 D4
; 70 68 40 90 1F E8 3F D4 70 E8 30 D4 68 2F 15 F4
; 68 60 94 88 D4 68 F4 70 88 FF D4 70 B0 06 E8 00
; D4 70 D4 68
;
; manual disassembly:

	mov	$00e, a		; C4 0E
	bmi	_05c0		; 30 6B
	bra	_05a5		; 2F 4E

	mov	a, $070+x	; F4 70
	cmp	a, $0a0+x	; 74 A0
	bne	_0561		; D0 04		; FIXME, jump to beq instruction makes no sense (should be _0563)
	mov	a, $068+x	; F4 68
	cmp	a, $098+x	; 74 98
_0561	beq	_05d5		; F0 72
	bcs	_0580		; B0 1B
	inc	$00e		; AB 0E
	mov	a, $068+x	; F4 68
	clrc			; 60
	adc	a, $090+x	; 94 90
	mov	$068+x, a	; D4 68
	mov	a, $070+x	; F4 70
	adc	a, #$00		; 88 00
	mov	$070+x, a	; D4 70
	cmp	a, $0a0+x	; 74 A0
	bne	_057c		; D0 04
	mov	a, $068+x	; F4 68
	cmp	a, $098+x	; 74 98
_057c	bcs	_059b		; B0 1D
	bra	_05d5		; 2F 55

_0580	inc	$00e		; AB 0E
	mov	a, $068+x	; F4 68
	setc			; 80
	sbc	a, $090+x	; B4 90
	mov	$068+x, a	; D4 68
	mov	a, $070+x	; F4 70
	sbc	a, #$00		; A8 00
	mov	$070+x, a	; D4 70
	cmp	a, $0a0+x	; 74 A0
	bne	_0597		; D0 04
	mov	a, $068+x	; F4 68
	cmp	a, $098+x	; 74 98
_0597	bcc	_059b		; 90 02
	bra	_05d5		; 2F 3A

_059b	mov	a, $098+x	; F4 98
	mov	$068+x, a	; D4 68
	mov	a, $0a0+x	; F4 A0
	mov	$070+x, a	; D4 70
	bra	_05d5		; 2F 30

_05a5	mov	a, $068+x	; F4 68
	clrc			; 60
	adc	a, $088+x	; 94 88
	mov	$068+x, a	; D4 68
	mov	a, $070+x	; F4 70
	adc	a, #$00		; 88 00
	mov	$070+x, a	; D4 70
	cmp	a, #$40		; 68 40
	bcc	_05d5		; 90 1F
	mov	a, #$3f		; E8 3F
	mov	$070+x, a	; D4 70
	mov	a, #$30		; E8 30
	mov	$068+x, a	; D4 68
	bra	_05d5		; 2F 15

_05c0	mov	a, $068+x	; F4 68
	clrc			; 60
	adc	a, $088+x	; 94 88
	mov	$068+x, a	; D4 68
	mov	a, $070+x	; F4 70
	adc	a, #$ff		; 88 FF
	mov	$070+x, a	; D4 70
	bcs	_05d5		; B0 06
	mov	a, #$00		; E8 00
	mov	$070+x, a	; D4 70
	mov	$068+x, a	; D4 68

..05d5 mov   a, $058+x         A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.
..05d7 bne   $05df             A:04 X:00 Y:0b SP:01ea YA:0b04 ....H...

..05d9 mov   a, $060+x         A:00 X:01 Y:00 SP:01ea YA:0000 ......Z.
..05db beq   $05e8             A:04 X:01 Y:00 SP:01ea YA:0004 ........
..05dd dec   $060+x            A:04 X:01 Y:00 SP:01ea YA:0004 ........
..05df dec   $058+x            A:04 X:00 Y:0b SP:01ea YA:0b04 ....H...
..05e1 mov   a, $058+x         A:04 X:00 Y:0b SP:01ea YA:0b04 ....H...
..05e3 or    a, $060+x         A:03 X:00 Y:0b SP:01ea YA:0b03 ....H...
..05e5 beq   $05e8             A:03 X:00 Y:0b SP:01ea YA:0b03 ....H...
..05e7 ret                     A:03 X:00 Y:0b SP:01ea YA:0b03 ....H...

..05e8 call  $07d6             A:00 X:00 Y:0b SP:01ea YA:0b00 ....H.Z.

..05eb call  $050a             A:3e X:04 Y:3f SP:01ea YA:3f3e ....H...

..05ee cmp   a, #$95           A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H.Z.
..05f0 bcc   $0632             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05f2 cmp   a, #$f5           A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05f4 beq   $062d             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05f6 bcc   $0636             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05f8 cmp   a, #$f6           A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05fa beq   $0645             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05fc cmp   a, #$f7           A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..05fe beq   $0651             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..0600 cmp   a, #$f8           A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H..C
..0602 beq   $065b             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H.ZC
..0604 cmp   a, #$f9           A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0606 beq   $0665             A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0608 cmp   a, #$fa           A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..060a beq   $066f             A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..060c cmp   a, #$fb           A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..060e beq   $0677             A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0610 cmp   a, #$fc           A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0612 beq   $067f             A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0614 cmp   a, #$fd           A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0616 beq   $0687             A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..0618 cmp   a, #$fe           A:fe X:00 Y:00 SP:01ea YA:00fe ....H..C
..061a bne   $061f             A:fe X:00 Y:00 SP:01ea YA:00fe ....H.ZC
..061c jmp   $06a5             A:fe X:00 Y:00 SP:01ea YA:00fe ....H.ZC

; missing
; 3F 0C 05 2D 3F 0C 05 C4 0D AE C4 0C 2F BE
;
; manual disassembly:

	call	$050c		; 3F 0C 05

	push	a		; 2D
	call	$050c		; 3F 0C 05

	mov	$00d, a		; C4 0D
	pop	a		; AE
	mov	$00c, a		; C4 0C
	bra	_05eb		; 2F BE

..062d call  $088d             A:f5 X:00 Y:00 SP:01ea YA:00f5 ......ZC

..0630 bra   $05eb             A:1f X:00 Y:00 SP:01ea YA:001f .......C

..0632 mov   $058+x, a         A:34 X:00 Y:00 SP:01ea YA:0034 N.......
..0634 bra   $06ae             A:34 X:00 Y:00 SP:01ea YA:0034 N.......

..0636 setc                    A:e0 X:00 Y:00 SP:01ea YA:00e0 N...H...
..0637 sbc   a, #$96           A:e0 X:00 Y:00 SP:01ea YA:00e0 N...H..C
..0639 call  $0759             A:4a X:00 Y:00 SP:01ea YA:004a .......C

..063c mov   a, $090+x         A:12 X:00 Y:94 SP:01ea YA:9412 ........
..063e bne   $05eb             A:00 X:00 Y:94 SP:01ea YA:9400 ......Z.
..0640 call  $0883             A:00 X:00 Y:94 SP:01ea YA:9400 ......Z.

..0643 bra   $05eb             A:01 X:00 Y:94 SP:01ea YA:9401 ........

..0645 call  $050c             A:f6 X:01 Y:00 SP:01ea YA:00f6 ......ZC

..0648 mov   $058+x, a         A:80 X:01 Y:00 SP:01ea YA:0080 ......ZC
..064a call  $050c             A:80 X:01 Y:00 SP:01ea YA:0080 ......ZC

..064d mov   $060+x, a         A:04 X:01 Y:00 SP:01ea YA:0004 ......ZC
..064f bra   $06ae             A:04 X:01 Y:00 SP:01ea YA:0004 ......ZC

; missing
; 3F 0C 05 D4 78 3F D6 07 2F 90
;
; manual disassembly:

	call	$050c		; 3F 0C 05

	mov	$078+x, a	; D4 78
	call	$07d6		; 3F D6 07

	bra	_05eb		; 2F 90

..065b call  $050c             A:f8 X:00 Y:00 SP:01ea YA:00f8 ....H.ZC

..065e mov   $038+x, a         A:80 X:00 Y:00 SP:01ea YA:0080 ....H.ZC
..0660 call  $07d6             A:80 X:00 Y:00 SP:01ea YA:0080 ....H.ZC

..0663 bra   $05eb             A:3e X:08 Y:3f SP:01ea YA:3f3e ....H...

; missing
; 3F 0C 05 D4 80 AB 0E 5F EB 05 3F 0C 05 D4 88 5F EB 05 3F 0C 05 D4 90 5F EB 05 3F 0C 05 D4 A8 5F EB 05
;
; manual disassembly:

	call	$050c		; 3F 0C 05

	mov	$080+x, a	; D4 80
	inc	$00e		; AB 0E
	jmp	_05eb		; 5F EB 05

	call	$050c		; 3F 0C 05

	mov	$088+x, a	; D4 88
	jmp	_05eb		; 5F EB 05

	call	$050c		; 3F 0C 05

	mov	$090+x, a	; D4 90
	jmp	_05eb		; 5F EB 05

	call	$050c		; 3F 0C 05

	mov	$0A8+x, a	; D4 A8
	jmp	_05eb		; 5F EB 05

..0687 call  $050c             A:fd X:04 Y:00 SP:01ea YA:00fd ......ZC

..068a push  a                 A:78 X:04 Y:00 SP:01ea YA:0078 ......ZC
..068b call  $050c             A:78 X:04 Y:00 SP:01e9 YA:0078 ......ZC

..068e push  a                 A:7c X:04 Y:00 SP:01e9 YA:007c ......ZC
..068f call  $050c             A:7c X:04 Y:00 SP:01e8 YA:007c ......ZC

..0692 mov   $0b8+x, a         A:1c X:04 Y:00 SP:01e8 YA:001c ......ZC
..0694 mov   a, $00c           A:1c X:04 Y:00 SP:01e8 YA:001c ......ZC
..0696 mov   $0c0+x, a         A:b4 X:04 Y:00 SP:01e8 YA:00b4 N......C
..0698 mov   a, $00d           A:b4 X:04 Y:00 SP:01e8 YA:00b4 N......C
..069a mov   $0c8+x, a         A:7c X:04 Y:00 SP:01e8 YA:007c .......C
..069c pop   a                 A:7c X:04 Y:00 SP:01e8 YA:007c .......C
..069d mov   $00d, a           A:7c X:04 Y:00 SP:01e9 YA:007c .......C
..069f pop   a                 A:7c X:04 Y:00 SP:01e9 YA:007c .......C
..06a0 mov   $00c, a           A:78 X:04 Y:00 SP:01ea YA:0078 .......C
..06a2 jmp   $05eb             A:78 X:04 Y:00 SP:01ea YA:0078 .......C

..06a5 call  $050c             A:fe X:00 Y:00 SP:01ea YA:00fe ....H.ZC

..06a8 call  $072f             A:09 X:00 Y:00 SP:01ea YA:0009 ....H.ZC

..06ab jmp   $05eb             A:ab X:0e Y:13 SP:01ea YA:13ab ....H...

..06ae mov   x, $007           A:34 X:00 Y:00 SP:01ea YA:0034 N.......
..06b0 mov   a, $00c           A:34 X:00 Y:00 SP:01ea YA:0034 ......Z.
..06b2 mov   $048+x, a         A:79 X:00 Y:00 SP:01ea YA:0079 ........
..06b4 mov   a, $00d           A:79 X:00 Y:00 SP:01ea YA:0079 ........
..06b6 mov   $050+x, a         A:dc X:00 Y:00 SP:01ea YA:00dc N.......
..06b8 ret                     A:dc X:00 Y:00 SP:01ea YA:00dc N.......

..06b9 mov   x, #$00           A:00 X:02 Y:00 SP:01ed YA:0000 ......Z.
..06bb mov   $008, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06bd mov   $009, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06bf mov   $002, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06c1 mov   $012, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06c3 mov   $013, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06c5 mov   $020, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06c7 mov   $019, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06c9 mov   $017, x           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06cb mov   x, #$ff           A:00 X:00 Y:00 SP:01ed YA:0000 ......Z.
..06cd mov   $016, x           A:00 X:ff Y:00 SP:01ed YA:0000 N.......
..06cf mov   $018, x           A:00 X:ff Y:00 SP:01ed YA:0000 N.......
..06d1 mov   x, #$9d           A:00 X:ff Y:00 SP:01ed YA:0000 N.......
..06d3 mov   y, #$0a           A:00 X:9d Y:00 SP:01ed YA:0000 N.......
..06d5 call  $08d4             A:00 X:9d Y:0a SP:01ed YA:0a00 ........

..06d8 mov   a, $0208          A:00 X:9d Y:2c SP:01ed YA:2c00 ......Z.
..06db mov   $004, a           A:12 X:9d Y:2c SP:01ed YA:2c12 ........
..06dd mov   a, $0209          A:12 X:9d Y:2c SP:01ed YA:2c12 ........
..06e0 mov   $005, a           A:0b X:9d Y:2c SP:01ed YA:2c0b ........
..06e2 mov   a, $020a          A:0b X:9d Y:2c SP:01ed YA:2c0b ........
..06e5 mov   $014, a           A:24 X:9d Y:2c SP:01ed YA:2c24 ........
..06e7 mov   a, $020b          A:24 X:9d Y:2c SP:01ed YA:2c24 ........
..06ea mov   $015, a           A:0b X:9d Y:2c SP:01ed YA:2c0b ........
..06ec mov   x, #$00           A:0b X:9d Y:2c SP:01ed YA:2c0b ........
..06ee mov   a, #$00           A:0b X:00 Y:2c SP:01ed YA:2c0b ......Z.
..06f0 mov   $050+x, a         A:00 X:00 Y:2c SP:01ed YA:2c00 ......Z.
..06f2 mov   a, #$80           A:00 X:00 Y:2c SP:01ed YA:2c00 ......Z.
..06f4 mov   $038+x, a         A:80 X:00 Y:2c SP:01ed YA:2c80 N.......
..06f6 mov   a, #$ff           A:80 X:00 Y:2c SP:01ed YA:2c80 N.......
..06f8 mov   $030+x, a         A:ff X:00 Y:2c SP:01ed YA:2cff N.......
..06fa mov   $0d0+x, a         A:ff X:00 Y:2c SP:01ed YA:2cff N.......
..06fc inc   x                 A:ff X:00 Y:2c SP:01ed YA:2cff N.......
..06fd cmp   x, #$08           A:ff X:01 Y:2c SP:01ed YA:2cff ........
..06ff bne   $06ee             A:ff X:01 Y:2c SP:01ed YA:2cff N.......
..0701 call  $03e8             A:ff X:08 Y:2c SP:01ed YA:2cff ......ZC

..0704 ret                     A:c3 X:fc Y:00 SP:01ed YA:00c3 N......C

..0705 mov   a, #$7c           A:00 X:ef Y:00 SP:01ed YA:0000 ......Z.
..0707 mov   $0f2, a           A:7c X:ef Y:00 SP:01ed YA:007c ........
..0709 mov   a, $0f3           A:7c X:ef Y:00 SP:01ed YA:007c ........
..070b and   a, #$40           A:ff X:ef Y:00 SP:01ed YA:00ff N.......
..070d beq   $0718             A:40 X:ef Y:00 SP:01ed YA:0040 ........
..070f mov   $0f3, a           A:40 X:ef Y:00 SP:01ed YA:0040 ........
..0711 mov   a, $024           A:40 X:ef Y:00 SP:01ed YA:0040 ........
..0713 inc   a                 A:00 X:ef Y:00 SP:01ed YA:0000 ......Z.
..0714 and   a, #$07           A:01 X:ef Y:00 SP:01ed YA:0001 ........
..0716 mov   $024, a           A:01 X:ef Y:00 SP:01ed YA:0001 ........
..0718 ret                     A:01 X:ef Y:00 SP:01ed YA:0001 ........

..0719 push  a                 A:81 X:ef Y:00 SP:01ed YA:0081 N.......
..071a mov   a, #$91           A:81 X:ef Y:00 SP:01ec YA:0081 N.......
..071c mov   $0f1, a           A:91 X:ef Y:00 SP:01ec YA:0091 N.......
..071e mov   a, #$00           A:91 X:ef Y:00 SP:01ec YA:0091 N.......
..0720 mov   $0f4, a           A:00 X:ef Y:00 SP:01ec YA:0000 ......Z.
..0722 mov   $0f5, a           A:00 X:ef Y:00 SP:01ec YA:0000 ......Z.
..0724 pop   a                 A:00 X:ef Y:00 SP:01ec YA:0000 ......Z.
..0725 ret                     A:81 X:ef Y:00 SP:01ed YA:0081 ......Z.

..0726 mov   $007, a           A:00 X:00 Y:00 SP:01ea YA:0000 ......ZC
..0728 asl   a                 A:00 X:00 Y:00 SP:01ea YA:0000 ......ZC
..0729 asl   a                 A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..072a asl   a                 A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..072b asl   a                 A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..072c mov   $006, a           A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..072e ret                     A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.

..072f mov   y, a              A:09 X:00 Y:00 SP:01e8 YA:0009 ....H.ZC
..0730 mov   x, $007           A:09 X:00 Y:09 SP:01e8 YA:0909 ....H..C
..0732 cmp   a, $0d0+x         A:09 X:00 Y:09 SP:01e8 YA:0909 ....H.ZC
..0734 beq   $0758             A:09 X:00 Y:09 SP:01e8 YA:0909 ....H...
..0736 mov   $0d0+x, a         A:09 X:00 Y:09 SP:01e8 YA:0909 ....H...
..0738 mov   a, $006           A:09 X:00 Y:09 SP:01e8 YA:0909 ....H...
..073a or    a, #$04           A:00 X:00 Y:09 SP:01e8 YA:0900 ....H.Z.
..073c mov   x, a              A:04 X:00 Y:09 SP:01e8 YA:0904 ....H...
..073d mov   a, y              A:04 X:04 Y:09 SP:01e8 YA:0904 ....H...
..073e call  $0873             A:09 X:04 Y:09 SP:01e8 YA:0909 ....H...

..0741 asl   a                 A:09 X:0a Y:09 SP:01e8 YA:0909 ....H...
..0742 mov   y, a              A:12 X:0a Y:09 SP:01e8 YA:0912 ....H...
..0743 mov   a, $006           A:12 X:0a Y:12 SP:01e8 YA:1212 ....H...
..0745 or    a, #$05           A:00 X:0a Y:12 SP:01e8 YA:1200 ....H.Z.
..0747 mov   x, a              A:05 X:0a Y:12 SP:01e8 YA:1205 ....H...
..0748 mov   a, ($004)+y       A:05 X:05 Y:12 SP:01e8 YA:1205 ....H...
..074a call  $0873             A:bf X:05 Y:12 SP:01e8 YA:12bf N...H...

..074d mov   a, $006           A:bf X:0c Y:12 SP:01e8 YA:12bf ....H...
..074f or    a, #$06           A:00 X:0c Y:12 SP:01e8 YA:1200 ....H.Z.
..0751 mov   x, a              A:06 X:0c Y:12 SP:01e8 YA:1206 ....H...
..0752 inc   y                 A:06 X:06 Y:12 SP:01e8 YA:1206 ....H...
..0753 mov   a, ($004)+y       A:06 X:06 Y:13 SP:01e8 YA:1306 ....H...
..0755 call  $0873             A:ab X:06 Y:13 SP:01e8 YA:13ab N...H...

..0758 ret                     A:ab X:0e Y:13 SP:01e8 YA:13ab ....H...

..0759 asl   a                 A:4a X:00 Y:00 SP:01e8 YA:004a .......C
..075a mov   y, a              A:94 X:00 Y:00 SP:01e8 YA:0094 N.......
..075b mov   x, $007           A:94 X:00 Y:94 SP:01e8 YA:9494 N.......
..075d mov   a, $0905+y        A:94 X:00 Y:94 SP:01e8 YA:9494 ......Z.
..0760 mov   $098+x, a         A:be X:00 Y:94 SP:01e8 YA:94be N.......
..0762 mov   a, $0906+y        A:be X:00 Y:94 SP:01e8 YA:94be N.......
..0765 mov   $0a0+x, a         A:12 X:00 Y:94 SP:01e8 YA:9412 ........
..0767 mov   a, $090+x         A:12 X:00 Y:94 SP:01e8 YA:9412 ........
..0769 beq   $0770             A:00 X:00 Y:94 SP:01e8 YA:9400 ......Z.

; missing
; 68 63 F0 01 6F
;
; manual disassembly:

	cmp	a, #$63		; 68 63
	beq	$0770		; F0 01
	ret			; 6F

..0770 mov   a, $098+x         A:00 X:00 Y:94 SP:01e8 YA:9400 ......Z.
..0772 mov   $068+x, a         A:be X:00 Y:94 SP:01e8 YA:94be N.......
..0774 mov   a, $0a0+x         A:be X:00 Y:94 SP:01e8 YA:94be N.......
..0776 mov   $070+x, a         A:12 X:00 Y:94 SP:01e8 YA:9412 ........
..0778 inc   $00e              A:12 X:00 Y:94 SP:01e8 YA:9412 ........
..077a ret                     A:12 X:00 Y:94 SP:01e8 YA:9412 ........

..077b mov   a, $00e           A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..077d bne   $0780             A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..077f ret                     A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.

..0780 mov   x, $007           A:01 X:00 Y:00 SP:01ea YA:0001 ........
..0782 mov   a, $068+x         A:01 X:00 Y:00 SP:01ea YA:0001 ......Z.
..0784 clrc                    A:be X:00 Y:00 SP:01ea YA:00be N.......
..0785 adc   a, $080+x         A:be X:00 Y:00 SP:01ea YA:00be N.......
..0787 mov   $00f, a           A:be X:00 Y:00 SP:01ea YA:00be N.......
..0789 mov   a, $070+x         A:be X:00 Y:00 SP:01ea YA:00be N.......
..078b adc   a, #$00           A:12 X:00 Y:00 SP:01ea YA:0012 ........
..078d mov   $010, a           A:12 X:00 Y:00 SP:01ea YA:0012 ........
..078f mov   a, $0a8+x         A:12 X:00 Y:00 SP:01ea YA:0012 ........
..0791 beq   $07c1             A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.

; missing
; 28 F0 FD F4 B0 5D F5 C5 09 30 0F CF DD 60 84 0F
; C4 0F E4 10 88 00 C4 10 2F 14 48 FF BC CF DD C4
; 11 E4 0F 80 A4 11 C4 0F E4 10 A8 00 C4 10
;
; manual disassembly:

	and	a, #$f0		; 28 F0
	mov	y, a		; FD
	mov	a, $0b0+x	; F4 B0
	mov	x, a		; 5D
	mov	a, $09C5+x	; F5 C5 09
	bmi	_07ad		; 30 0F
	mul	ya		; CF
	mov	a, y		; DD
	clrc			; 60
	adc	a, $00f		; 84 0F
	mov	$00f, a		; C4 0F
	mov	a, $010		; E4 10
	adc	a, #$00		; 88 00
	mov	$010, a		; C4 10
	bra	_07c1		; 2F 14

_07ad	eor	a, #$ff		; 48 FF
	inc	a		; BC
	mul	ya		; CF
	mov	a, y		; DD
	mov	$011, a		; C4 11
	mov	a, $00f		; E4 0F
	setc			; 80
	sbc	a, $011		; A4 11
	mov	$00f, a		; C4 0F
	mov	a, $010		; E4 10
	sbc	a, #$00		; A8 00
	mov	$010, a		; C4 10

..07c1 mov   a, $006           A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..07c3 or    a, #$03           A:00 X:00 Y:00 SP:01ea YA:0000 ......Z.
..07c5 mov   x, a              A:03 X:00 Y:00 SP:01ea YA:0003 ........
..07c6 mov   a, $010           A:03 X:03 Y:00 SP:01ea YA:0003 ........
..07c8 call  $0873             A:12 X:03 Y:00 SP:01ea YA:0012 ........

..07cb mov   a, $006           A:12 X:10 Y:00 SP:01ea YA:0012 ........
..07cd or    a, #$02           A:00 X:10 Y:00 SP:01ea YA:0000 ......Z.
..07cf mov   x, a              A:02 X:10 Y:00 SP:01ea YA:0002 ........
..07d0 mov   a, $00f           A:02 X:02 Y:00 SP:01ea YA:0002 ........
..07d2 call  $0873             A:be X:02 Y:00 SP:01ea YA:00be N.......

..07d5 ret                     A:be X:12 Y:00 SP:01ea YA:00be ........

..07d6 mov   x, $007           A:00 X:04 Y:00 SP:01e8 YA:0000 ......Z.
..07d8 cmp   x, $012           A:00 X:00 Y:00 SP:01e8 YA:0000 ......Z.
..07da bcs   $07e4             A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC

..07dc mov   a, $013           A:00 X:00 Y:0b SP:01e8 YA:0b00 N...H...
..07de beq   $07e4             A:00 X:00 Y:0b SP:01e8 YA:0b00 ....H.Z.

; missing
; E8 00 2F 02
;
; manual disassembly:

	mov	a, #$00		; E8 00
	bra	_07e6		; 2F 02

..07e4 mov   a, $030+x         A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC
..07e6 mov   y, $078+x         A:ff X:00 Y:00 SP:01e8 YA:00ff N......C
..07e8 mul   ya                A:ff X:00 Y:00 SP:01e8 YA:00ff ......ZC
..07e9 mov   $00b, y           A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC
..07eb mov   a, $002           A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC
..07ed bne   $07f5             A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC
..07ef mov   a, $00b           A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC
..07f1 push  a                 A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC
..07f2 push  a                 A:00 X:00 Y:00 SP:01e7 YA:0000 ......ZC
..07f3 bra   $0804             A:00 X:00 Y:00 SP:01e6 YA:0000 ......ZC

..07f5 mov   a, $038+x         A:01 X:00 Y:7e SP:01e8 YA:7e01 ....H...
..07f7 eor   a, #$ff           A:80 X:00 Y:7e SP:01e8 YA:7e80 N...H...
..07f9 mov   y, a              A:7f X:00 Y:7e SP:01e8 YA:7e7f ....H...
..07fa mov   a, $00b           A:7f X:00 Y:7f SP:01e8 YA:7f7f ....H...
..07fc mul   ya                A:7e X:00 Y:7f SP:01e8 YA:7f7e ....H...
..07fd push  y                 A:82 X:00 Y:3e SP:01e8 YA:3e82 ....H...
..07fe mov   y, $038+x         A:82 X:00 Y:3e SP:01e7 YA:3e82 ....H...
..0800 mov   a, $00b           A:82 X:00 Y:80 SP:01e7 YA:8082 N...H...
..0802 mul   ya                A:7e X:00 Y:80 SP:01e7 YA:807e ....H...
..0803 push  y                 A:00 X:00 Y:3f SP:01e7 YA:3f00 ....H...
..0804 mov   a, $006           A:00 X:00 Y:00 SP:01e6 YA:0000 ......ZC
..0806 or    a, #$01           A:00 X:00 Y:00 SP:01e6 YA:0000 ......ZC
..0808 mov   x, a              A:01 X:00 Y:00 SP:01e6 YA:0001 .......C
..0809 pop   a                 A:01 X:01 Y:00 SP:01e6 YA:0001 .......C
..080a call  $0873             A:00 X:01 Y:00 SP:01e7 YA:0000 .......C

..080d mov   a, $006           A:00 X:02 Y:00 SP:01e7 YA:0000 .......C
..080f or    a, #$00           A:00 X:02 Y:00 SP:01e7 YA:0000 ......ZC
..0811 mov   x, a              A:00 X:02 Y:00 SP:01e7 YA:0000 ......ZC
..0812 pop   a                 A:00 X:00 Y:00 SP:01e7 YA:0000 ......ZC
..0813 call  $0873             A:00 X:00 Y:00 SP:01e8 YA:0000 ......ZC

..0816 ret                     A:00 X:04 Y:00 SP:01e8 YA:0000 .......C

..0817 mov   a, #$00           A:c0 X:04 Y:00 SP:01eb YA:00c0 N.......
..0819 push  a                 A:00 X:04 Y:00 SP:01eb YA:0000 ......Z.
..081a call  $0726             A:00 X:04 Y:00 SP:01ea YA:0000 ......Z.

..081d call  $07d6             A:00 X:04 Y:00 SP:01ea YA:0000 ......Z.

..0820 pop   a                 A:00 X:04 Y:00 SP:01ea YA:0000 .......C
..0821 inc   a                 A:00 X:04 Y:00 SP:01eb YA:0000 .......C
..0822 cmp   a, #$08           A:01 X:04 Y:00 SP:01eb YA:0001 .......C
..0824 bne   $0819             A:01 X:04 Y:00 SP:01eb YA:0001 N.......
..0826 call  $0897             A:08 X:20 Y:00 SP:01eb YA:0008 ......ZC

..0829 ret                     A:00 X:20 Y:00 SP:01eb YA:0000 ......ZC

..082a inc   $019              A:02 X:fc Y:00 SP:01ed YA:0002 .......C
..082c mov   a, $019           A:02 X:fc Y:00 SP:01ed YA:0002 .......C
..082e and   a, #$07           A:01 X:fc Y:00 SP:01ed YA:0001 .......C
..0830 beq   $0839             A:01 X:fc Y:00 SP:01ed YA:0001 .......C
..0832 mov   a, $018           A:01 X:fc Y:00 SP:01ed YA:0001 .......C
..0834 cmp   a, #$ff           A:ff X:fc Y:00 SP:01ed YA:00ff N......C
..0836 beq   $0839             A:ff X:fc Y:00 SP:01ed YA:00ff ......ZC
..0838 ret                     A:10 X:10 Y:00 SP:01ed YA:0010 ........

..0839 mov   a, $017           A:ff X:fc Y:00 SP:01ed YA:00ff ......ZC
..083b cmp   a, $016           A:00 X:fc Y:00 SP:01ed YA:0000 ......ZC
..083d beq   $085f             A:00 X:fc Y:00 SP:01ed YA:0000 ........
..083f bcs   $0851             A:00 X:fc Y:00 SP:01ed YA:0000 ........
..0841 adc   a, $018           A:00 X:fc Y:00 SP:01ed YA:0000 ........
..0843 bcc   $0849             A:ff X:fc Y:00 SP:01ed YA:00ff N.......

; missing
; E4 16 2F 16
;
; manual disassembly:

	mov	a, $016		; E4 16
	bra	_085f		; 2F 16

..0849 cmp   a, $016           A:ff X:fc Y:00 SP:01ed YA:00ff N.......
..084b bcc   $085f             A:ff X:fc Y:00 SP:01ed YA:00ff ......ZC
..084d mov   a, $016           A:ff X:fc Y:00 SP:01ed YA:00ff ......ZC
..084f bra   $085f             A:ff X:fc Y:00 SP:01ed YA:00ff N......C

..0851 sbc   a, $018           A:ff X:05 Y:0b SP:01ed YA:0bff .......C
..0853 bcs   $0859             A:00 X:05 Y:0b SP:01ed YA:0b00 ....H.ZC

..0855 mov   a, $016           A:fe X:5c Y:00 SP:01ed YA:00fe N...H...
..0857 bra   $085f             A:00 X:5c Y:00 SP:01ed YA:0000 ....H.Z.

..0859 cmp   a, $016           A:00 X:05 Y:0b SP:01ed YA:0b00 ....H.ZC
..085b bcs   $085f             A:00 X:05 Y:0b SP:01ed YA:0b00 ....H...
..085d mov   a, $016           A:00 X:05 Y:0b SP:01ed YA:0b00 ....H...
..085f mov   $017, a           A:ff X:fc Y:00 SP:01ed YA:00ff N......C
..0861 lsr   a                 A:ff X:fc Y:00 SP:01ed YA:00ff N......C
..0862 mov   x, #$0c           A:7f X:fc Y:00 SP:01ed YA:007f .......C
..0864 mov   $0f2, x           A:7f X:0c Y:00 SP:01ed YA:007f .......C
..0866 mov   $0f3, a           A:7f X:0c Y:00 SP:01ed YA:007f .......C
..0868 mov   x, #$1c           A:7f X:0c Y:00 SP:01ed YA:007f .......C
..086a mov   $0f2, x           A:7f X:1c Y:00 SP:01ed YA:007f .......C
..086c mov   $0f3, a           A:7f X:1c Y:00 SP:01ed YA:007f .......C
..086e ret                     A:7f X:1c Y:00 SP:01ed YA:007f .......C

..086f mov   $003, #$00        A:7f X:1c Y:00 SP:01eb YA:007f .......C
..0872 ret                     A:7f X:1c Y:00 SP:01eb YA:007f .......C

..0873 push  a                 A:00 X:01 Y:00 SP:01e5 YA:0000 .......C
..0874 mov   a, x              A:00 X:01 Y:00 SP:01e4 YA:0000 .......C
..0875 mov   x, $003           A:01 X:01 Y:00 SP:01e4 YA:0001 .......C
..0877 mov   $0104+x, a        A:01 X:00 Y:00 SP:01e4 YA:0001 ......ZC
..087a inc   x                 A:01 X:00 Y:00 SP:01e4 YA:0001 ......ZC
..087b pop   a                 A:01 X:01 Y:00 SP:01e4 YA:0001 .......C
..087c mov   $0104+x, a        A:00 X:01 Y:00 SP:01e5 YA:0000 .......C
..087f inc   x                 A:00 X:01 Y:00 SP:01e5 YA:0000 .......C
..0880 mov   $003, x           A:00 X:02 Y:00 SP:01e5 YA:0000 .......C
..0882 ret                     A:00 X:02 Y:00 SP:01e5 YA:0000 .......C

..0883 mov   x, $007           A:00 X:00 Y:94 SP:01e8 YA:9400 ......Z.
..0885 mov   a, $0a85+x        A:00 X:00 Y:94 SP:01e8 YA:9400 ......Z.
..0888 or    a, $008           A:01 X:00 Y:94 SP:01e8 YA:9401 ........
..088a mov   $008, a           A:01 X:00 Y:94 SP:01e8 YA:9401 ........
..088c ret                     A:01 X:00 Y:94 SP:01e8 YA:9401 ........

..088d mov   x, $007           A:00 X:00 Y:01 SP:01e7 YA:0100 ......Z.
..088f mov   a, $0a85+x        A:00 X:00 Y:01 SP:01e7 YA:0100 ......Z.
..0892 or    a, $009           A:01 X:00 Y:01 SP:01e7 YA:0101 ........
..0894 mov   $009, a           A:01 X:00 Y:01 SP:01e7 YA:0101 ........
..0896 ret                     A:01 X:00 Y:01 SP:01e7 YA:0101 ........

..0897 mov   a, $003           A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC
..0899 beq   $08b0             A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC
..089b mov   x, #$00           A:20 X:20 Y:00 SP:01e9 YA:0020 .......C
..089d mov   a, $0104+x        A:20 X:00 Y:00 SP:01e9 YA:0020 ......ZC
..08a0 mov   $0f2, a           A:01 X:00 Y:00 SP:01e9 YA:0001 .......C
..08a2 inc   x                 A:01 X:00 Y:00 SP:01e9 YA:0001 .......C
..08a3 mov   a, $0104+x        A:01 X:01 Y:00 SP:01e9 YA:0001 .......C
..08a6 mov   $0f3, a           A:00 X:01 Y:00 SP:01e9 YA:0000 ......ZC
..08a8 inc   x                 A:00 X:01 Y:00 SP:01e9 YA:0000 ......ZC
..08a9 cmp   x, $003           A:00 X:02 Y:00 SP:01e9 YA:0000 .......C
..08ab bne   $089d             A:00 X:02 Y:00 SP:01e9 YA:0000 N.......
..08ad mov   $003, #$00        A:00 X:20 Y:00 SP:01e9 YA:0000 ......ZC
..08b0 ret                     A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC

..08b1 mov   a, $008           A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC
..08b3 eor   a, #$ff           A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC
..08b5 and   a, $009           A:ff X:07 Y:00 SP:01eb YA:00ff N......C
..08b7 mov   x, #$5c           A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC
..08b9 mov   $0f2, x           A:00 X:5c Y:00 SP:01eb YA:0000 .......C
..08bb mov   $009, a           A:00 X:5c Y:00 SP:01eb YA:0000 .......C
..08bd mov   $0f3, a           A:00 X:5c Y:00 SP:01eb YA:0000 .......C
..08bf mov   a, #$4c           A:00 X:5c Y:00 SP:01eb YA:0000 .......C
..08c1 mov   $0f2, a           A:4c X:5c Y:00 SP:01eb YA:004c .......C
..08c3 mov   a, $008           A:4c X:5c Y:00 SP:01eb YA:004c .......C
..08c5 mov   $008, #$00        A:00 X:5c Y:00 SP:01eb YA:0000 ......ZC
..08c8 mov   $0f3, a           A:00 X:5c Y:00 SP:01eb YA:0000 ......ZC
..08ca ret                     A:00 X:5c Y:00 SP:01eb YA:0000 ......ZC

..08cb mov   a, #$5c           A:08 X:07 Y:00 SP:01eb YA:0008 ......ZC
..08cd mov   $0f2, a           A:5c X:07 Y:00 SP:01eb YA:005c .......C
..08cf mov   a, $009           A:5c X:07 Y:00 SP:01eb YA:005c .......C
..08d1 mov   $0f3, a           A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC
..08d3 ret                     A:00 X:07 Y:00 SP:01eb YA:0000 ......ZC

..08d4 mov   $00c, x           A:00 X:9d Y:0a SP:01eb YA:0a00 ........
..08d6 mov   $00d, y           A:00 X:9d Y:0a SP:01eb YA:0a00 ........
..08d8 mov   y, #$00           A:00 X:9d Y:0a SP:01eb YA:0a00 ........
..08da mov   a, ($00c)+y       A:00 X:9d Y:00 SP:01eb YA:0000 ......Z.
..08dc beq   $08e8             A:6c X:9d Y:00 SP:01eb YA:006c ........
..08de mov   $0f2, a           A:6c X:9d Y:00 SP:01eb YA:006c ........
..08e0 inc   y                 A:6c X:9d Y:00 SP:01eb YA:006c ........
..08e1 mov   a, ($00c)+y       A:6c X:9d Y:01 SP:01eb YA:016c ........
..08e3 mov   $0f3, a           A:60 X:9d Y:01 SP:01eb YA:0160 ........
..08e5 inc   y                 A:60 X:9d Y:01 SP:01eb YA:0160 ........
..08e6 bra   $08da             A:60 X:9d Y:02 SP:01eb YA:0260 ........
..08e8 ret                     A:00 X:9d Y:2c SP:01eb YA:2c00 ......Z.

_08e9:				; command jump table
; 00 00 46 02 0A 03 4E 02 57 02 6B 02 8C 02 A2 02
; CA 02 D7 02 99 02 20 03 4A 03 53 03 

_0905:				; data table
;                                     42 00 46 00
; 4A 00 4F 00 54 00 59 00 5E 00 64 00 6A 00 70 00
; 77 00 7E 00 85 00 8D 00 95 00 9E 00 A8 00 B2 00
; BC 00 C8 00 D4 00 E0 00 EE 00 FC 00 0B 01 1B 01
; 2B 01 3D 01 50 01 64 01 79 01 90 01 A8 01 C1 01
; DC 01 F8 01 16 02 36 02 57 02 7B 02 A1 02 C9 02
; F3 02 20 03 50 03 82 03 B8 03 F0 03 2C 04 6C 04
; AF 04 F6 04 42 05 92 05 E7 05 41 06 A0 06 05 07
; 70 07 E1 07 59 08 D8 08 5F 09 ED 09 85 0A 25 0B
; CE 0B 82 0C 41 0D 0A 0E E0 0E C3 0F B3 10 B1 11
; BE 12 DB 13 0A 15 4A 16 9D 17 05 19 82 1A 15 1C
; C1 1D 86 1F 66 21 62 23 7D 25 B7 27 14 2A 95 2C
; 3B 2F 0A 32 04 35 2B 38 82 3B 0C 3F 

_09c5:				; data table
;                                     00 04 08 0C
; 10 14 18 1C 20 24 28 2C 30 34 38 3B 3F 43 46 49
; 4D 50 53 56 59 5C 5F 62 64 67 69 6B 6D 70 71 73
; 75 76 78 79 7A 7B 7C 7D 7D 7E 7E 7E 7F 7E 7E 7E
; 7D 7D 7C 7B 7A 79 78 76 75 73 71 70 6D 6B 69 67
; 64 62 5F 5C 59 56 53 50 4D 49 46 43 3F 3B 38 34
; 30 2C 28 24 20 1C 18 14 10 0C 08 04 00 FC F8 F4
; F0 EC E8 E4 E0 DC D8 D4 D0 CC C8 C5 C1 BD BA B7
; B3 B0 AD AA A7 A4 A1 9E 9C 99 97 95 93 90 8F 8D
; 8B 8A 88 87 86 85 84 83 83 82 82 82 81 82 82 82
; 83 83 84 85 86 87 88 8A 8B 8D 8F 90 93 95 97 99
; 9C 9E A1 A4 A7 AA AD B0 B3 B7 BA BD C1 C5 C8 CC
; D0 D4 D8 DC E0 E4 E8 EC F0 F4 F8 FC 

_0a85:				; data table
; 01 02 04 08 10 20 40 80 

_0a8d:				; data tables
;             E4 F6 E0 F7 DC F8 D8 F9 D4 FA D0 FB
; CC FC C8 FD 6C 60 0C 00 1C 00 2D 00 3D 00 6D 01
; 7D 00 0D 00 0F 7F 1F 00 2F 00 3F 00 4F 00 5F 00
; 6F 00 7F 00 4D 00 2C 00 3C 00 5C FF 5D 0B 6C 20
; 00 75 00 77 1F 72 00 73 08 62 00 63 08 74 00 64
; 08 4C C0 00 00 00 00 00 00 00 00 00 00 00 00 00
; 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
; 00 00 00 00 00 00 00 E4 F6 E4 F6 E0 F7 E0 F7 DC
; F8 DC F8 D8 F9 D8 F9 D4 FA D4 FA D0 FB D0 FB CC
; FC CC FC C8 FD C8 FD C4 FE C4 FE
