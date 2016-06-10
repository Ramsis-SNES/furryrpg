;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** HDMA TABLES ***
;
;==========================================================================================



SRC_HDMA_ColMathMode7:
	.DB PARAM_MODE7_SKY_LINES					; for the sky,
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

SRC_HDMA_ColMathMode7_End:



SRC_HDMA_ColMathDialogSel:
	.DB 127								; for 127 + 57 = 184 scanlines,
	.DB $E0, $E0							; apply black (i.e., don't affect display)

	.DB 57								; patch this in WRAM
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

SRC_HDMA_ColMathDialogSel_End:



SRC_HDMA_ColMathMenu:
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

SRC_HDMA_ColMathMenu_End:



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

SRC_HDMA_ColMathMainMenu_End:



SRC_HDMA_HUDScroll:
	.DB 48								; 48 scanlines = 6 lines of text at top of the screen
	.DW $002F							; scroll HUD up by $30 lines (value to be manipulated in WRAM)

	.DB 128
	.DW $00FF							; reset scroll value for middle of the screen

	.DB 48								; 48 scanlines = 6 lines of text at bottom of the screen
	.DW $00CF							; scroll HUD down by $30 lines (value to be manipulated in WRAM)

	.DB 0



SRC_HDMA_MainEffects:							; FIXME, rename
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_MainEffects

	.DB 112|$80
	.DW ARRAY_HDMA_MainEffects+112

	.DB 0								; end of HDMA table



SRC_HDMA_M7A:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_M7A

	.DB 112|$80
	.DW ARRAY_HDMA_M7A+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_M7B:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_M7B

	.DB 112|$80
	.DW ARRAY_HDMA_M7B+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_M7C:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_M7C

	.DB 112|$80
	.DW ARRAY_HDMA_M7C+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_M7D:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_M7D

	.DB 112|$80
	.DW ARRAY_HDMA_M7D+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_ResetBGScroll:
	.DB 127								; 127 + 49 = 176 scanlines = playfield
	.DW $0000, $00FF						; horiz. scroll = $0000, vert. scroll = $00FF (values to be manipulated in WRAM)

	.DB 49
	.DW $0000, $00FF

	.DB 48								; 48 scanlines = text box area
	.DW $0000, $00FF

	.DB 0



SRC_HDMA_test5:
	.DB 112|$80

.REPEAT 112
	.DB $05
.ENDR

	.DB 112|$80

.REPEAT 112
	.DB $05
.ENDR

	.DB 0



; ********************** Backdrop color gradients **********************

; textbox scanlines:

; $00-$AF --> scanlines above textbox
; $B0-$DF --> textbox (with frame border)

SRC_HDMA_ColorGradient:
	.DB 127|$80							; 127 + 49 = 176 scanlines for playfield, continuous mode flag set
	.DW (ARRAY_HDMA_BackgrPlayfield & $FFFF)			; get low word

	.DB 49|$80
	.DW (ARRAY_HDMA_BackgrPlayfield & $FFFF)+(127*4)

	.DB 48|$80							; 48 scanlines for textbox, continuous mode flag set
	.DW (ARRAY_HDMA_BackgrTextBox & $FFFF)

	.DB 0								; end of HDMA table



SRC_HDMA_MenuParty:							; color gradient: black --> bright blue
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

SRC_HDMA_MenuParty_END:



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

SRC_HDMA_Mode7Sky72_END:



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



SRC_HDMA_TextBoxGradientPissed:
	.DW $0000,$0000							; 3 scanlines black (to suppress color in frame corners)
	.DW $0000,$0000
	.DW $0000,$0000
	.DW $0000,$0022							; start of "pissed" color gradient
	.DW $0000,$0423
	.DW $0000,$0444
	.DW $0000,$0444
	.DW $0000,$0445
	.DW $0000,$0466
	.DW $0000,$0467
	.DW $0000,$0468
	.DW $0000,$0488
	.DW $0000,$0489
	.DW $0000,$088A
	.DW $0000,$08AB
	.DW $0000,$08AC
	.DW $0000,$08AC
	.DW $0000,$08CD
	.DW $0000,$08CE
	.DW $0000,$08CF
	.DW $0000,$0CF0
	.DW $0000,$0CF0
	.DW $0000,$0CF1
	.DW $0000,$0D12
	.DW $0000,$0D13
	.DW $0000,$0D34
	.DW $0000,$0D34
	.DW $0000,$0D35
	.DW $0000,$1156
	.DW $0000,$1157
	.DW $0000,$1158
	.DW $0000,$1178
	.DW $0000,$1179
	.DW $0000,$117A
	.DW $0000,$119B
	.DW $0000,$119C
	.DW $0000,$159C
	.DW $0000,$15BD
	.DW $0000,$15BE
	.DW $0000,$15BF
	.DW $0000,$15DF
	.DW $0000,$15DF
	.DW $0000,$15DF
	.DW $0000,$15DF
	.DW $0000,$15DF							; end of "pissed" color gradient
	.DW $0000,$0000							; 3 scanlines black
	.DW $0000,$0000
	.DW $0000,$0000



; ******************************** EOF *********************************
