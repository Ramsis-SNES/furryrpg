; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	HDMA TABLES
;
; ==================================================================================================



SRC_HDMA_BG12CharData:							; for vertical split-screen test
	.DB 112|$80
	.DSB 112, $40

	.DB 112|$80
	.DSB 112, $40

	.DB 0



SRC_HDMA_ColMathMode1:
	.DB 32								; for the sky,
	.DB $E0, $E0							; apply black (i.e., don't affect display)

	.DB 1								; apply b/w values for blur effect
	.DB $E0,$FC
	.DB 1
	.DB $E0,$FB
	.DB 1
	.DB $E0,$FA
	.DB 1
	.DB $E0,$F8
	.DB 1
	.DB $E0,$F7
	.DB 1
	.DB $E0,$F6
	.DB 1
	.DB $E0,$F4
	.DB 2
	.DB $E0,$F3
	.DB 2
	.DB $E0,$F2
	.DB 3
	.DB $E0,$F1
	.DB 4
	.DB $E0,$F0
	.DB 3
	.DB $E0,$EF
	.DB 3
	.DB $E0,$EE
	.DB 4
	.DB $E0,$ED
	.DB 3
	.DB $E0,$EC
	.DB 3
	.DB $E0,$EB
	.DB 3
	.DB $E0,$EA
	.DB 4
	.DB $E0,$E9
	.DB 4
	.DB $E0,$E8
	.DB 3
	.DB $E0,$E7
	.DB 2
	.DB $E0,$E6
	.DB 3
	.DB $E0,$E5
	.DB 4
	.DB $E0,$E4
	.DB 6
	.DB $E0,$E3
	.DB 8
	.DB $E0,$E2
	.DB 10
	.DB $E0,$E1

	.DB 1								; for the remaining scanlines,
	.DB $E0, $E0							; don't affect display
	.DB 0



SRC_HDMA_ColMathMode7:
	.DB kMode7SkyLines						; for the sky,
	.DB $E0, $E0							; apply black (i.e., don't affect display)

	.DB 1								; apply b/w values for blur effect
	.DB $E0,$FC
	.DB 1
	.DB $E0,$FB
	.DB 1
	.DB $E0,$FA
	.DB 1
	.DB $E0,$F8
	.DB 1
	.DB $E0,$F7
	.DB 1
	.DB $E0,$F6
	.DB 1
	.DB $E0,$F4
	.DB 2
	.DB $E0,$F3
	.DB 2
	.DB $E0,$F2
	.DB 3
	.DB $E0,$F1
	.DB 4
	.DB $E0,$F0
	.DB 3
	.DB $E0,$EF
	.DB 3
	.DB $E0,$EE
	.DB 4
	.DB $E0,$ED
	.DB 3
	.DB $E0,$EC
	.DB 3
	.DB $E0,$EB
	.DB 3
	.DB $E0,$EA
	.DB 4
	.DB $E0,$E9
	.DB 4
	.DB $E0,$E8
	.DB 3
	.DB $E0,$E7
	.DB 2
	.DB $E0,$E6
	.DB 3
	.DB $E0,$E5
	.DB 4
	.DB $E0,$E4
	.DB 6
	.DB $E0,$E3
	.DB 8
	.DB $E0,$E2
	.DB 10
	.DB $E0,$E1

	.DB 1								; for the remaining scanlines,
	.DB $E0, $E0							; don't affect display
	.DB 0



SRC_HDMA_ColMathDialogSel:
	.DB 127								; for 127 + kTextBoxColMath1st (at least 57) = 184 (or more) scanlines,
	.DB $E0, $E0							; apply black (i.e., don't affect display)

	.DB kTextBoxColMath1st						; patch this one in WRAM
	.DB $E0, $E0

	.DB 1								; for 8 scanlines (= line height), apply color
	.DB $E0, %11101111
	.DB 6
	.DB $E0, %11101111
	.DB 1
	.DB $E0, %11101101

	.DB 1								; for the remaining scanlines,
	.DB $E0, $E0							; don't affect display
	.DB 0



SRC_HDMA_ColMathMenu:							; UNUSED as of now
	.DB 80								; for 80 scanlines (uppermost menu entry, value to be patched in WRAM for anything below it),
	.DB $E0, $E0							; apply black (i.e., don't affect display)

	.DB 1								; for 8 scanlines (= line height), apply color
	.DB $E0, %10011011
	.DB 6
	.DB $E0, %10001111
	.DB 1
	.DB $E0, %10011011

	.DB 1								; for the remaining scanlines,
	.DB $E0, $E0							; don't affect display
	.DB 0



SRC_HDMA_ColMathMainMenu:
	.DB 7
	.DB $E0, $80
	.DB 7
	.DB $E0, $81
	.DB 7
	.DB $E0, $82
	.DB 7
	.DB $E0, $83
	.DB 7
	.DB $E0, $84
	.DB 7
	.DB $E0, $85
	.DB 7
	.DB $E0, $86
	.DB 7
	.DB $E0, $87
	.DB 7
	.DB $E0, $88
	.DB 7
	.DB $E0, $89
	.DB 7
	.DB $E0, $8A
	.DB 7
	.DB $E0, $8B
	.DB 7
	.DB $E0, $8C
	.DB 7
	.DB $E0, $8D
	.DB 7
	.DB $E0, $8E
	.DB 7
	.DB $E0, $8F
	.DB 7
	.DB $E0, $90
	.DB 7
	.DB $E0, $91
	.DB 7
	.DB $E0, $92
	.DB 7
	.DB $E0, $93
	.DB 7
	.DB $E0, $94
	.DB 7
	.DB $E0, $95
	.DB 7
	.DB $E0, $96
	.DB 7
	.DB $E0, $97
	.DB 7
	.DB $E0, $98
	.DB 7
	.DB $E0, $99
	.DB 7
	.DB $E0, $9A
	.DB 7
	.DB $E0, $9B
	.DB 7
	.DB $E0, $9C
	.DB 7
	.DB $E0, $9D
	.DB 7
	.DB $E0, $9E
	.DB 7
	.DB $E0, $9F



SRC_HDMA_FX_1Byte:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW loword(RAM.HDMA_FX_1Byte)

	.DB 112|$80
	.DW loword(RAM.HDMA_FX_1Byte+112)

	.DB 0								; end of HDMA table



SRC_HDMA_FX_2Bytes:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW loword(RAM.HDMA_FX_2Bytes)

	.DB 112|$80
	.DW loword(RAM.HDMA_FX_2Bytes+224)

	.DB 0								; end of HDMA table



SRC_HDMA_M7A:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW LO8.HDMA_M7A

	.DB 112|$80
	.DW LO8.HDMA_M7A+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_M7B:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW LO8.HDMA_M7B

	.DB 112|$80
	.DW LO8.HDMA_M7B+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_M7C:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW LO8.HDMA_M7C

	.DB 112|$80
	.DW LO8.HDMA_M7C+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_M7D:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW LO8.HDMA_M7D

	.DB 112|$80
	.DW LO8.HDMA_M7D+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_Mode5:								; for vertical split-screen test
	.DB 112|$80
	.DSB 112, $05

	.DB 112|$80
	.DSB 112, $05

	.DB 0


SRC_HDMA_BG_Scroll:

; Filled with initial values; to be copied to WRAM for scanline and scroll value manipulation.
; Designed in such a way that the two HDMA channels using this table (4 & 5 right now) can remain
; enabled all the time in area/dialogue test.

	.DB 127								; 127 + X scanlines for playfield
	.DW $0000, $00FF						; horiz. scroll, vert. scroll

	.DB 224-127							; 49 (kPlayfieldHeight-127) when text box fully visible
	.DW $0000, $00FF						; horiz. scroll, vert. scroll

	.DB 0								; 48 (kTextBoxHeight) when text box fully visible
	.DW $0000, $00FF-kTextBoxHeight					; horiz. scroll, vert. scroll

	.DB 0



SRC_HDMA_WorMapCurvature:
	.DB kWorldMapSkyLines						; for sky, show everything
	.DB 0, 255
	.DB 1								; gradually increase window content
	.DB 104, 151
	.DB 1
	.DB 56, 199
	.DB 1
	.DB 32, 223
	.DB 1
	.DB 16, 239
	.DB 1								; for the remaining scanlines, show everything
	.DB 0, 255
	.DB 0



SRC_HDMA_WorMapLayerControl:
	.DB kWorldMapSkyLines						; for sky, show sprites only
	.DB %00000000, %00010000
	.DB 1								; for all remaining scanlines, show BG layers 1, 2 and sprites
	.DB %00000011, %00010000
	.DB 0



SRC_HDMA_WorMapVScroll:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW loword(RAM.HDMA_WorMapVScroll)

	.DB 112|$80
	.DW loword(RAM.HDMA_WorMapVScroll + 224)

	.DB 0								; end of HDMA table



SRC_HDMA_WorMapVScrollDisplacement:

; The table is unfortunately backwards (last entry corresponds to first scanline). Also, not sure
; if it's in fact "better" than the old one ...
;
;/** Generated using Dr LUT - Free Lookup Table Generator
;  * https://github.com/ppelikan/drlut
;  **/
;// Formula: 0.07*t^4 (amplitude: 0.00000080, offset: 0, samples/array size: 192)
; int16_t values converted to assembler directives (obviously)

	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000
	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0001
	.DW $0001, $0001, $0001, $0001, $0001, $0001, $0001
	.DW $0001, $0001, $0001, $0001, $0001, $0001, $0001
	.DW $0001, $0001, $0002, $0002, $0002, $0002, $0002
	.DW $0002, $0002, $0002, $0002, $0002, $0003, $0003
	.DW $0003, $0003, $0003, $0003, $0003, $0004, $0004
	.DW $0004, $0004, $0004, $0004, $0005, $0005, $0005
	.DW $0005, $0005, $0006, $0006, $0006, $0006, $0007
	.DW $0007, $0007, $0007, $0008, $0008, $0008, $0009
	.DW $0009, $0009, $0009, $000A, $000A, $000A, $000B
	.DW $000B, $000C, $000C, $000C, $000D, $000D, $000E
	.DW $000E, $000F, $000F, $0010, $0010, $0010, $0011
	.DW $0012, $0012, $0013, $0013, $0014, $0014, $0015
	.DW $0016, $0016, $0017, $0017, $0018, $0019, $0019
	.DW $001A, $001B, $001C, $001C, $001D, $001E, $001F
	.DW $001F, $0020, $0021, $0022, $0023, $0024, $0025
	.DW $0026, $0027, $0028, $0029, $002A, $002B, $002C
	.DW $002D, $002E, $002F, $0030, $0031, $0032, $0033
	.DW $0035, $0036, $0037, $0038, $0039, $003B, $003C
	.DW $003D, $003F, $0040, $0042, $0043, $0044, $0046
	.DW $0047, $0049, $004B



; BACKDROP COLOR GRADIENTS
; --------------------------------------------------------------------------------------------------

; textbox scanlines:

; $00-$AF --> scanlines above textbox
; $B0-$DF --> textbox (with frame border)

SRC_HDMA_ColorGradient:
	.DB 127|$80							; 127 + 49 = 176 scanlines for playfield, continuous mode flag set
	.DW loword(RAM.HDMA_BG_Playfield)

	.DB kPlayfieldHeight-127|$80
	.DW loword(RAM.HDMA_BG_Playfield)+(127*4)

	.DB kTextBoxHeight|$80						; 48 scanlines for textbox, continuous mode flag set
	.DW loword(RAM.HDMA_BG_Playfield)+(kPlayfieldHeight*4)		; value manipulated in WRAM for text box "scrolling" animation
;	.DW loword(RAM.HDMA_BG_TextBox)

	.DB 0								; end of HDMA table



SRC_HDMA_MenuParty:							; color gradient: black --> bright blue (UNUSED as of now)

.REPEAT 7
	.dw $0000,$0000
.ENDR

.REPEAT 7
	.dw $0000,$0400
.ENDR

.REPEAT 7
	.dw $0000,$0800
.ENDR

.REPEAT 7
	.dw $0000,$0C00
.ENDR

.REPEAT 7
	.dw $0000,$1000
.ENDR

.REPEAT 7
	.dw $0000,$1400
.ENDR

.REPEAT 7
	.dw $0000,$1800
.ENDR

.REPEAT 7
	.dw $0000,$1C00
.ENDR

.REPEAT 7
	.dw $0000,$2000
.ENDR

.REPEAT 7
	.dw $0000,$2400
.ENDR

.REPEAT 7
	.dw $0000,$2800
.ENDR

.REPEAT 7
	.dw $0000,$2C00
.ENDR

.REPEAT 7
	.dw $0000,$3000
.ENDR

.REPEAT 7
	.dw $0000,$3400
.ENDR

.REPEAT 7
	.dw $0000,$3800
.ENDR

.REPEAT 7
	.dw $0000,$3C00
.ENDR

.REPEAT 7
	.dw $0000,$4000
.ENDR

.REPEAT 7
	.dw $0000,$4400
.ENDR

.REPEAT 7
	.dw $0000,$4800
.ENDR

.REPEAT 7
	.dw $0000,$4C00
.ENDR

.REPEAT 7
	.dw $0000,$5000
.ENDR

.REPEAT 7
	.dw $0000,$5400
.ENDR

.REPEAT 7
	.dw $0000,$5800
.ENDR

.REPEAT 7
	.dw $0000,$5C00
.ENDR

.REPEAT 7
	.dw $0000,$6000
.ENDR

.REPEAT 7
	.dw $0000,$6400
.ENDR

.REPEAT 7
	.dw $0000,$6800
.ENDR

.REPEAT 7
	.dw $0000,$6C00
.ENDR

.REPEAT 7
	.dw $0000,$7000
.ENDR

.REPEAT 7
	.dw $0000,$7400
.ENDR

.REPEAT 7
	.dw $0000,$7800
.ENDR

.REPEAT 7
	.dw $0000,$7C00
.ENDR



SRC_HDMA_Mode7Sky72:
	.DW $0000,$5961
	.DW $0000,$5981
	.DW $0000,$5982
	.DW $0000,$5982
	.DW $0000,$5982
	.DW $0000,$59A3
	.DW $0000,$59A3
	.DW $0000,$5DA3
	.DW $0000,$5DA4
	.DW $0000,$5DA4
	.DW $0000,$5DC4
	.DW $0000,$5DC5
	.DW $0000,$5DC5
	.DW $0000,$5DC5
	.DW $0000,$5DE6
	.DW $0000,$5DE6
	.DW $0000,$5DE6
	.DW $0000,$5DE7
	.DW $0000,$61E7
	.DW $0000,$6207
	.DW $0000,$6208
	.DW $0000,$6208
	.DW $0000,$6228
	.DW $0000,$6229
	.DW $0000,$6229
	.DW $0000,$6229
	.DW $0000,$622A
	.DW $0000,$624A
	.DW $0000,$664A
	.DW $0000,$664B
	.DW $0000,$664B
	.DW $0000,$666B
	.DW $0000,$666C
	.DW $0000,$666C
	.DW $0000,$666C
	.DW $0000,$668C
	.DW $0000,$668D
	.DW $0000,$668D
	.DW $0000,$668E
	.DW $0000,$6A8E
	.DW $0000,$6AAE
	.DW $0000,$6AAE
	.DW $0000,$6AAF
	.DW $0000,$6AAF
	.DW $0000,$6ACF
	.DW $0000,$6AD0
	.DW $0000,$6AD0
	.DW $0000,$6AD0
	.DW $0000,$6AD1
	.DW $0000,$6EF1
	.DW $0000,$6EF1
	.DW $0000,$6EF2
	.DW $0000,$6EF2
	.DW $0000,$6F12
	.DW $0000,$6F13
	.DW $0000,$6F13
	.DW $0000,$6F13
	.DW $0000,$6F34
	.DW $0000,$6F34
	.DW $0000,$6F34
	.DW $0000,$7335
	.DW $0000,$7355
	.DW $0000,$7355
	.DW $0000,$7356
	.DW $0000,$7356
	.DW $0000,$7356
	.DW $0000,$7376
	.DW $0000,$7377
	.DW $0000,$7377
	.DW $0000,$7378
	.DW $0000,$7798
	.DW $0000,$7798



SRC_TextBoxGradient:
	.DW 0								; dummy pointer for black background
	.DW SRC_HDMA_TextBoxGradientBlue
	.DW SRC_HDMA_TextBoxGradientRed
	.DW SRC_HDMA_TextBoxGradientPink
	.DW SRC_HDMA_TextBoxGradientEvil
	.DW SRC_HDMA_TextBoxGradientAlert
	.DW SRC_HDMA_TextBoxGradientGray



SRC_HDMA_TextBoxGradientBlue:
	.DW $0000,$0000							; 3 scanlines black (to suppress color in frame corners)
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$1000							; start of blue color gradient
	.DW $0000,$1000
	.DW $0000,$1400
	.DW $0000,$1400
	.DW $0000,$1800
	.DW $0000,$1800
	.DW $0000,$1C00
	.DW $0000,$1C00
	.DW $0000,$2000
	.DW $0000,$2000
	.DW $0000,$2400
	.DW $0000,$2400
	.DW $0000,$2800
	.DW $0000,$2800
	.DW $0000,$2C00
	.DW $0000,$2C00
	.DW $0000,$3000
	.DW $0000,$3000
	.DW $0000,$3400
	.DW $0000,$3400
	.DW $0000,$3800
	.DW $0000,$3800
	.DW $0000,$3C00
	.DW $0000,$3C00
	.DW $0000,$4000
	.DW $0000,$4000
	.DW $0000,$4400
	.DW $0000,$4400
	.DW $0000,$4800
	.DW $0000,$4800
	.DW $0000,$4C00
	.DW $0000,$4C00
	.DW $0000,$5000
	.DW $0000,$5000
	.DW $0000,$5400
	.DW $0000,$5400
	.DW $0000,$5800
	.DW $0000,$5800
	.DW $0000,$5C00
	.DW $0000,$5C00
	.DW $0000,$6000
	.DW $0000,$6000							; end of blue color gradient
	.DW $0000,$0000							; 3 scanlines black
	.DW $0000,$0000
	.DW $0000,$0000



SRC_HDMA_TextBoxGradientRed:
	.DW $0000,$0000							; 3 scanlines black (to suppress color in frame corners)
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0004							; start of red color gradient
	.DW $0000,$0004
	.DW $0000,$0005
	.DW $0000,$0005
	.DW $0000,$0006
	.DW $0000,$0006
	.DW $0000,$0007
	.DW $0000,$0007
	.DW $0000,$0008
	.DW $0000,$0008
	.DW $0000,$0009
	.DW $0000,$0009
	.DW $0000,$000A
	.DW $0000,$000A
	.DW $0000,$000B
	.DW $0000,$000B
	.DW $0000,$000C
	.DW $0000,$000C
	.DW $0000,$000D
	.DW $0000,$000D
	.DW $0000,$000E
	.DW $0000,$000E
	.DW $0000,$000F
	.DW $0000,$000F
	.DW $0000,$0010
	.DW $0000,$0010
	.DW $0000,$0011
	.DW $0000,$0011
	.DW $0000,$0012
	.DW $0000,$0012
	.DW $0000,$0013
	.DW $0000,$0013
	.DW $0000,$0014
	.DW $0000,$0014
	.DW $0000,$0015
	.DW $0000,$0015
	.DW $0000,$0016
	.DW $0000,$0016
	.DW $0000,$0017
	.DW $0000,$0017
	.DW $0000,$0018
	.DW $0000,$0018							; end of red color gradient
	.DW $0000,$0000							; 3 scanlines black
	.DW $0000,$0000
	.DW $0000,$0000



SRC_HDMA_TextBoxGradientPink:
	.DW $0000,$0000							; 3 scanlines black (to suppress color in frame corners)
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$1004							; start of pink color gradient
	.DW $0000,$1004
	.DW $0000,$1405
	.DW $0000,$1405
	.DW $0000,$1806
	.DW $0000,$1806
	.DW $0000,$1C07
	.DW $0000,$1C07
	.DW $0000,$2008
	.DW $0000,$2409
	.DW $0000,$240A
	.DW $0000,$280A
	.DW $0000,$280B
	.DW $0000,$2C0B
	.DW $0000,$300C
	.DW $0000,$300D
	.DW $0000,$340D
	.DW $0000,$380D
	.DW $0000,$380E
	.DW $0000,$3C0F
	.DW $0000,$4010
	.DW $0000,$4411
	.DW $0000,$4412
	.DW $0000,$4812
	.DW $0000,$4813
	.DW $0000,$4C13
	.DW $0000,$5014
	.DW $0000,$5415
	.DW $0000,$5816
	.DW $0000,$5C17
	.DW $0000,$5C18
	.DW $0000,$6018
	.DW $0000,$6419
	.DW $0000,$681A
	.DW $0000,$6C1A
	.DW $0000,$6C1B
	.DW $0000,$701C
	.DW $0000,$701D
	.DW $0000,$741D
	.DW $0000,$781E
	.DW $0000,$781F
	.DW $0000,$7C1F							; end of pink color gradient
	.DW $0000,$0000							; 3 scanlines black
	.DW $0000,$0000
	.DW $0000,$0000



SRC_HDMA_TextBoxGradientEvil:
	.DW $0000,$0000							; 3 scanlines black (to suppress color in frame corners)
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0001							; start of "evil" color gradient
	.DW $0000,$0401
	.DW $0000,$0401
	.DW $0000,$0402
	.DW $0000,$0422
	.DW $0000,$0423
	.DW $0000,$0823
	.DW $0000,$0823
	.DW $0000,$0824
	.DW $0000,$0824
	.DW $0000,$0824
	.DW $0000,$0C25
	.DW $0000,$0C25
	.DW $0000,$0C25
	.DW $0000,$0C26
	.DW $0000,$0C26
	.DW $0000,$0C26
	.DW $0000,$1027
	.DW $0000,$1047
	.DW $0000,$1048
	.DW $0000,$1048
	.DW $0000,$1048
	.DW $0000,$1449
	.DW $0000,$1449
	.DW $0000,$1449
	.DW $0000,$144A
	.DW $0000,$144A
	.DW $0000,$184A
	.DW $0000,$184B
	.DW $0000,$186B
	.DW $0000,$186B
	.DW $0000,$186C
	.DW $0000,$1C6C
	.DW $0000,$1C6D
	.DW $0000,$1C6D
	.DW $0000,$1C6D
	.DW $0000,$1C6E
	.DW $0000,$206E
	.DW $0000,$206E
	.DW $0000,$206F
	.DW $0000,$206F
	.DW $0000,$206F							; end of "evil" color gradient
	.DW $0000,$0000							; 3 scanlines black
	.DW $0000,$0000
	.DW $0000,$0000



SRC_HDMA_TextBoxGradientAlert:
	.DW $0000,$0000							; 3 scanlines black (to suppress color in frame corners)
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0421							; start of "alert" color gradient
	.DW $0000,$0442
	.DW $0000,$0443
	.DW $0000,$0463
	.DW $0000,$0464
	.DW $0000,$0465
	.DW $0000,$0086
	.DW $0000,$0086
	.DW $0000,$00A7
	.DW $0000,$00A8
	.DW $0000,$00A9
	.DW $0000,$00CA
	.DW $0000,$00CA
	.DW $0000,$00EB
	.DW $0000,$00EB
	.DW $0000,$010C
	.DW $0000,$010D
	.DW $0000,$012E
	.DW $0000,$012E
	.DW $0000,$014F
	.DW $0000,$0150
	.DW $0000,$0150
	.DW $0000,$0171
	.DW $0000,$0172
	.DW $0000,$0192
	.DW $0000,$0193
	.DW $0000,$01B4
	.DW $0000,$01B5
	.DW $0000,$01D5
	.DW $0000,$01D6
	.DW $0000,$01F7
	.DW $0000,$01F8
	.DW $0000,$01F8
	.DW $0000,$0219
	.DW $0000,$021A
	.DW $0000,$023B
	.DW $0000,$023B
	.DW $0000,$023B
	.DW $0000,$023B
	.DW $0000,$023B
	.DW $0000,$023B
	.DW $0000,$023B							; end of "alert" color gradient
	.DW $0000,$0000							; 3 scanlines black
	.DW $0000,$0000
	.DW $0000,$0000



SRC_HDMA_TextBoxGradientGray:
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0421
	.DW $0000,$0842
	.DW $0000,$0842
	.DW $0000,$0C63
	.DW $0000,$0C63
	.DW $0000,$1084
	.DW $0000,$1084
	.DW $0000,$14A5
	.DW $0000,$14A5
	.DW $0000,$18C6
	.DW $0000,$18C6
	.DW $0000,$1CE7
	.DW $0000,$1CE7
	.DW $0000,$2108
	.DW $0000,$2108
	.DW $0000,$2529
	.DW $0000,$2529
	.DW $0000,$294A
	.DW $0000,$294A
	.DW $0000,$2D6B
	.DW $0000,$2D6B
	.DW $0000,$318C
	.DW $0000,$318C
	.DW $0000,$35AD
	.DW $0000,$35AD
;	.DW $0000,$35AD							; this entry removed
	.DW $0000,$39CE							; this entry doubled up instead (looks weird otherwise)
	.DW $0000,$39CE
	.DW $0000,$3DEF
	.DW $0000,$3DEF
	.DW $0000,$4210
	.DW $0000,$4210
	.DW $0000,$4631
	.DW $0000,$4631
	.DW $0000,$4A52
	.DW $0000,$4A52
	.DW $0000,$4E73
	.DW $0000,$4E73
	.DW $0000,$4E73
	.DW $0000,$5294
	.DW $0000,$5294
	.DW $0000,$5294
	.DW $0000,$5294
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0000



SRC_HDMA_WorldMapSky:
	.DW $0000,$7905
	.DW $0000,$7905
	.DW $0000,$7926
	.DW $0000,$7946
	.DW $0000,$7947
	.DW $0000,$7967
	.DW $0000,$7968
	.DW $0000,$7989
	.DW $0000,$79A9
	.DW $0000,$79AA
	.DW $0000,$79CA
	.DW $0000,$79EB
	.DW $0000,$79EB
	.DW $0000,$7A0C
	.DW $0000,$7A0C
	.DW $0000,$7A2D
	.DW $0000,$7A2E
	.DW $0000,$7A4E
	.DW $0000,$7A6F
	.DW $0000,$7A6F
	.DW $0000,$7A90
	.DW $0000,$7A91
	.DW $0000,$7AB1
	.DW $0000,$7AD2
	.DW $0000,$7AD2
	.DW $0000,$7AF3
	.DW $0000,$7B14
	.DW $0000,$7B14
	.DW $0000,$7B35
	.DW $0000,$7B35
	.DW $0000,$7B35
	.DW $0000,$7B35
	.DW $0000,$7B35
	.DW $0000,$7B35
	.DW $0000,$7B35
	.DW $0000,$7B35



SRC_HDMA_Diamond1:							; 448 bytes, usable with RAM.HDMA_FX_2Bytes --> $2126, $2127 for a diamond-shaped window // UNUSED

.DEFINE Value2126	$7F
.DEFINE Value2127	$80

.REPEAT 112								; create a 224 byte-long pattern of 7F 80 7E 81 ... 11 EE 10 EF
	.DB Value2126
	.DB Value2127

	decr	&Value2126
	incr	&Value2127
.ENDR

.REDEFINE Value2126	$10
.REDEFINE Value2127	$EF

.REPEAT 112								; create a 224 byte-long pattern of 10 EF 11 EE ... 7E 81 7F 80 (inverse of above pattern)
	.DB Value2126
	.DB Value2127

	incr	&Value2126
	decr	&Value2127
.ENDR

.UNDEFINE Value2126
.UNDEFINE Value2127



; EOF
