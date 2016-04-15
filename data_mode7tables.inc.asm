;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuL�we (http://www.manuloewe.de/)
;
;	*** TABLES FOR MODE 7 SCALING/ROTATION ***
;
;==========================================================================================



SRC_Mode7Scaling:
	.INCBIN "data_mode7_scaling_tables.bin"

SRC_Mode7Sin:
	.DB  0,  3,  6,  9,  12,  16,  19,  22
	.DB  25,  28,  31,  34,  37,  40,  43,  46
	.DB  48,  51,  54,  57,  60,  62,  65,  68
	.DB  70,  73,  75,  78,  80,  83,  85,  87
	.DB  90,  92,  94,  96,  98,  100,  102,  104
	.DB  105,  107,  109,  110,  112,  113,  115,  116
	.DB  117,  118,  119,  120,  121,  122,  123,  124
	.DB  124,  125,  126,  126,  126,  127,  127,  127

SRC_Mode7Cos:
	.DB  127,  127,  127,  127,  126,  126,  126,  125
	.DB  125,  124,  123,  123,  122,  121,  120,  119
	.DB  118,  116,  115,  114,  112,  111,  109,  108
	.DB  106,  104,  102,  101,  99,  97,  95,  93
	.DB  90,  88,  86,  84,  81,  79,  76,  74
	.DB  71,  69,  66,  63,  61,  58,  55,  52
	.DB  49,  47,  44,  41,  38,  35,  32,  29
	.DB  26,  23,  20,  17,  14,  10,  7,  4
	.DB  1, -2, -5, -8, -11, -14, -17, -21
	.DB -24, -27, -30, -33, -36, -39, -42, -45
	.DB -47, -50, -53, -56, -59, -61, -64, -67
	.DB -69, -72, -75, -77, -80, -82, -84, -87
	.DB -89, -91, -93, -95, -97, -99, -101, -103
	.DB -105, -107, -108, -110, -111, -113, -114, -115
	.DB -117, -118, -119, -120, -121, -122, -123, -124
	.DB -124, -125, -125, -126, -126, -127, -127, -127
	.DB -127, -127, -127, -127, -127, -126, -126, -125
	.DB -125, -124, -124, -123, -122, -121, -120, -119
	.DB -118, -117, -116, -114, -113, -111, -110, -108
	.DB -107, -105, -103, -101, -99, -97, -95, -93
	.DB -91, -89, -87, -84, -82, -80, -77, -75
	.DB -72, -70, -67, -64, -62, -59, -56, -53
	.DB -51, -48, -45, -42, -39, -36, -33, -30
	.DB -27, -24, -21, -18, -15, -12, -8, -5

; sin end, cos cont.

	.DB  0,  3,  6,  9,  12,  16,  19,  22
	.DB  25,  28,  31,  34,  37,  40,  43,  46
	.DB  48,  51,  54,  57,  60,  62,  65,  68
	.DB  70,  73,  75,  78,  80,  83,  85,  87
	.DB  90,  92,  94,  96,  98,  100,  102,  104
	.DB  105,  107,  109,  110,  112,  113,  115,  116
	.DB  117,  118,  119,  120,  121,  122,  123,  124
	.DB  124,  125,  126,  126,  126,  127,  127,  127



; ******************************** EOF *********************************
