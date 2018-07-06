;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** HDMA TABLES ***
;
;==========================================================================================



;SRC_HDMA_BG12CharData:							; obsolete with ditched vertical split-screen in item menu
;	.DB 112|$80

;.REPEAT 112
;	.DB $40
;.ENDR

;	.DB 112|$80

;.REPEAT 112
;	.DB $40
;.ENDR

;	.DB 0



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
	.DB PARAM_Mode7SkyLines						; for the sky,
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
	.DB 127								; for 127 + PARAM_TextBoxColMath1st (at least 57) = 184 (or more) scanlines,
	.DB $E0, $E0							; apply black (i.e., don't affect display)

	.DB PARAM_TextBoxColMath1st					; patch this one in WRAM
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
	.DW ARRAY_HDMA_FX_1Byte

	.DB 112|$80
	.DW ARRAY_HDMA_FX_1Byte+112

	.DB 0								; end of HDMA table



SRC_HDMA_FX_2Bytes:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_FX_2Bytes

	.DB 112|$80
	.DW ARRAY_HDMA_FX_2Bytes+224

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



;SRC_HDMA_Mode5:							; obsolete with ditched vertical split-screen in item menu
;	.DB 112|$80

;.REPEAT 112
;	.DB $05
;.ENDR

;	.DB 112|$80

;.REPEAT 112
;	.DB $05
;.ENDR

;	.DB 0



SRC_HDMA_ResetBGScroll:
	.DB 127								; 127 + 49 = 176 scanlines = playfield
	.DW $0000, $00FF						; horiz. scroll = $0000, vert. scroll = $00FF (all values to be manipulated in WRAM)

	.DB 49
	.DW $0000, $00FF

	.DB 48
	.DW $0000, $00CF

	.DB 0



SRC_HDMA_WorMapCurvature:
	.DB 32								; for 32 scanlines, show everything
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
	.DB 32								; for 32 scanlines, show ((BG layer 2 and)) sprites
	.DB %00000000, %00010000
	.DB 1								; for all remaining scanlines, show BG layers 1, 2 and sprites
	.DB %00000011, %00010000
	.DB 0



SRC_HDMA_WorMapVertScr:
	.DB 112|$80							; 112 scanlines, continuous mode flag set
	.DW ARRAY_HDMA_WorMapVertScr

	.DB 112|$80
	.DW ARRAY_HDMA_WorMapVertScr+(112*2)

	.DB 0								; end of HDMA table



SRC_HDMA_WorMapVertScrDisplacement:
.REPEAT 32								; 32 scanlines = sky
	.DW 0
.ENDR
	.DW 64
	.DW 62
	.DW 60
	.DW 58
	.DW 56
	.DW 54
	.DW 52
	.DW 50
	.DW 48
	.DW 46
	.DW 44
	.DW 44
	.DW 42
	.DW 42
	.DW 40
	.DW 40
	.DW 38
	.DW 38
	.DW 36
	.DW 36
	.DW 34
	.DW 34
	.DW 32
	.DW 32
	.DW 30
	.DW 30
	.DW 28
	.DW 28
	.DW 26
	.DW 26
	.DW 24
	.DW 24
	.DW 23
	.DW 23
	.DW 22
	.DW 22
	.DW 21
	.DW 21
	.DW 20
	.DW 20
	.DW 19
	.DW 19
	.DW 18
	.DW 18
	.DW 18
	.DW 17
	.DW 17
	.DW 17
	.DW 16
	.DW 16
	.DW 16
	.DW 15
	.DW 15
	.DW 15
	.DW 14
	.DW 14
	.DW 14
	.DW 13
	.DW 13
	.DW 13
	.DW 12
	.DW 12
	.DW 12
	.DW 12
	.DW 11
	.DW 11
	.DW 11
	.DW 11
	.DW 10
	.DW 10
	.DW 10
	.DW 10
	.DW 9
	.DW 9
	.DW 9
	.DW 9
	.DW 8
	.DW 8
	.DW 8
	.DW 8
	.DW 7
	.DW 7
	.DW 7
	.DW 7
	.DW 6
	.DW 6
	.DW 6
	.DW 6
	.DW 6
	.DW 5
	.DW 5
	.DW 5
	.DW 5
	.DW 5
	.DW 4
	.DW 4
	.DW 4
	.DW 4
	.DW 3
	.DW 3
	.DW 3
	.DW 3
	.DW 3
	.DW 2
	.DW 2
	.DW 2
	.DW 2
	.DW 2
	.DW 1
	.DW 1
	.DW 1
	.DW 1
	.DW 1
.REPEAT 79
	.DW 0
.ENDR



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



SRC_HDMA_Diamond1:							; 448 bytes, usable with ARRAY_HDMA_FX_2Bytes --> $2126, $2127 for a diamond-shaped window // UNUSED
.DEFINE Value2126	$7F
.DEFINE Value2127	$80

.REPEAT 112								; create a 224 byte-long pattern of 7F 80 7E 81 ... 11 EE 10 EF
	.DB Value2126
	.DB Value2127

.REDEFINE Value2126	Value2126-1
.REDEFINE Value2127	Value2127+1

.ENDR

.REDEFINE Value2126	$10
.REDEFINE Value2127	$EF

.REPEAT 112								; create a 224 byte-long pattern of 10 EF 11 EE ... 7E 81 7F 80 (inverse of above pattern)
	.DB Value2126
	.DB Value2127

.REDEFINE Value2126	Value2126+1
.REDEFINE Value2127	Value2127-1

.ENDR



; ******************************** EOF *********************************
