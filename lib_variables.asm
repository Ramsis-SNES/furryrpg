;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** VARIABLE DEFINITIONS ***
;
;==========================================================================================



; ****************************** Notation ******************************

; Label prefixes:

; __		= sub-label
; ADDR_		= address value, as .DEFINEd
; ARRAY_	= non-Direct Page array
; CC_		= text box control code byte
; EC_		= event control code byte
; ERR_		= error code byte
; CMD_		= constant, as .DEFINEd (used as macro/subroutine command)
; CONST_	= arbitrary constant, stored in ROM
; DP_		= Direct Page variable
; GFX_		= graphics data, stored in ROM
; MSU_		= MSU1 hardware register
; PARAM_	= constant for assembly, as .DEFINEd
; PTR_		= 16-bit pointer, stored in ROM
; REG_		= SNES hardware register
; SCMD_		= constant, as .DEFINEd (used as SPC700 command)
; SRC_		= array of constants / binary data, stored in ROM
; ST_		= .STRUCT
; STR_		= ASCII string, stored in ROM
; TBL_		= constant in table, as .DEFINEd
; VAR_		= non-Direct Page variable



; *************************** SNES registers ***************************

; -------------------------- CPU status bits
.DEFINE DEC_MODE		$08
.DEFINE XY_8BIT			$10
.DEFINE A_8BIT			$20
.DEFINE AXY_8BIT		$30



; -------------------------- CPU & PPU registers
.DEFINE REG_INIDISP		$2100
.DEFINE REG_OBSEL		$2101
.DEFINE REG_OAMADDL		$2102
.DEFINE REG_OAMADDH		$2103
.DEFINE REG_OAMDATA		$2104
.DEFINE REG_BGMODE		$2105
.DEFINE REG_MOSAIC		$2106
.DEFINE REG_BG1SC		$2107
.DEFINE REG_BG2SC		$2108
.DEFINE REG_BG3SC		$2109
.DEFINE REG_BG4SC		$210A
.DEFINE REG_BG12NBA		$210B
.DEFINE REG_BG34NBA		$210C
.DEFINE REG_BG1HOFS		$210D
.DEFINE REG_BG1VOFS		$210E
.DEFINE REG_BG2HOFS		$210F
.DEFINE REG_BG2VOFS		$2110
.DEFINE REG_BG3HOFS		$2111
.DEFINE REG_BG3VOFS		$2112
.DEFINE REG_BG4HOFS		$2113
.DEFINE REG_BG4VOFS		$2114
.DEFINE REG_VMAIN		$2115
.DEFINE REG_VMADDL		$2116
.DEFINE REG_VMADDH		$2117
.DEFINE REG_VMDATAL		$2118
.DEFINE REG_VMDATAH		$2119
.DEFINE REG_M7SEL		$211A
.DEFINE REG_M7A			$211B
.DEFINE REG_M7B			$211C
.DEFINE REG_M7C			$211D
.DEFINE REG_M7D			$211E
.DEFINE REG_M7X			$211F
.DEFINE REG_M7Y			$2120
.DEFINE REG_CGADD		$2121
.DEFINE REG_CGDATA		$2122
.DEFINE REG_W12SEL		$2123
.DEFINE REG_W34SEL		$2124
.DEFINE REG_WOBJSEL		$2125
.DEFINE REG_WH0			$2126
.DEFINE REG_WH1			$2127
.DEFINE REG_WH2			$2128
.DEFINE REG_WH3			$2129
.DEFINE REG_WBGLOG		$212A
.DEFINE REG_WOBJLOG		$212B
.DEFINE REG_TM			$212C
.DEFINE REG_TS			$212D
.DEFINE REG_TMW			$212E
.DEFINE REG_TSW			$212F
.DEFINE REG_CGWSEL		$2130
.DEFINE REG_CGADSUB		$2131
.DEFINE REG_COLDATA		$2132
.DEFINE REG_SETINI		$2133
.DEFINE REG_MPYL		$2134
.DEFINE REG_MPYM		$2135
.DEFINE REG_MPYH		$2136
.DEFINE REG_SLHV		$2137
.DEFINE REG_RDOAM		$2138
.DEFINE REG_RDVRAML		$2139
.DEFINE REG_RDVRAMH		$213A
.DEFINE REG_RDCGRAM		$213B
.DEFINE REG_OPHCT		$213C
.DEFINE REG_OPVCT		$213D
.DEFINE REG_STAT77		$213E
.DEFINE REG_STAT78		$213F
.DEFINE REG_APUIO0		$2140
.DEFINE REG_APUIO1		$2141
.DEFINE REG_APUIO2		$2142
.DEFINE REG_APUIO3		$2143
.DEFINE REG_WMDATA		$2180
.DEFINE REG_WMADDL		$2181
.DEFINE REG_WMADDM		$2182
.DEFINE REG_WMADDH		$2183
.DEFINE REG_JOYWR		$4016
.DEFINE REG_JOYA		$4016
.DEFINE REG_JOYB		$4017
.DEFINE REG_NMITIMEN		$4200
.DEFINE REG_WRIO		$4201
.DEFINE REG_WRMPYA		$4202
.DEFINE REG_WRMPYB		$4203
.DEFINE REG_WRDIVL		$4204
.DEFINE REG_WRDIVH		$4205
.DEFINE REG_WRDIVB		$4206
.DEFINE REG_HTIMEL		$4207
.DEFINE REG_HTIMEH		$4208
.DEFINE REG_VTIMEL		$4209
.DEFINE REG_VTIMEH		$420A
.DEFINE REG_MDMAEN		$420B
.DEFINE REG_HDMAEN		$420C
.DEFINE REG_MEMSEL		$420D
.DEFINE REG_RDNMI		$4210
.DEFINE REG_TIMEUP		$4211
.DEFINE REG_HVBJOY		$4212
.DEFINE REG_RDIO		$4213
.DEFINE REG_RDDIVL		$4214
.DEFINE REG_RDDIVH		$4215
.DEFINE REG_RDMPYL		$4216
.DEFINE REG_RDMPYH		$4217
.DEFINE REG_JOY1L		$4218
.DEFINE REG_JOY1H		$4219
.DEFINE REG_JOY2L		$421A
.DEFINE REG_JOY2H		$421B
.DEFINE REG_JOY3L		$421C
.DEFINE REG_JOY3H		$421D
.DEFINE REG_JOY4L		$421E
.DEFINE REG_JOY4H		$421F
.DEFINE REG_DMAP0		$4300
.DEFINE REG_BBAD0		$4301
.DEFINE REG_A1T0L		$4302
.DEFINE REG_A1T0H		$4303
.DEFINE REG_A1B0		$4304
.DEFINE REG_DAS0L		$4305
.DEFINE REG_DAS0H		$4306
.DEFINE REG_DASB0		$4307
.DEFINE REG_A2A0L		$4308
.DEFINE REG_A2A0H		$4309
.DEFINE REG_NTRL0		$430A
.DEFINE REG_UNUSED0		$430B
.DEFINE REG_DMAP1		$4310
.DEFINE REG_BBAD1		$4311
.DEFINE REG_A1T1L		$4312
.DEFINE REG_A1T1H		$4313
.DEFINE REG_A1B1		$4314
.DEFINE REG_DAS1L		$4315
.DEFINE REG_DAS1H		$4316
.DEFINE REG_DASB1		$4317
.DEFINE REG_A2A1L		$4318
.DEFINE REG_A2A1H		$4319
.DEFINE REG_NTRL1		$431A
.DEFINE REG_UNUSED1		$431B
.DEFINE REG_DMAP2		$4320
.DEFINE REG_BBAD2		$4321
.DEFINE REG_A1T2L		$4322
.DEFINE REG_A1T2H		$4323
.DEFINE REG_A1B2		$4324
.DEFINE REG_DAS2L		$4325
.DEFINE REG_DAS2H		$4326
.DEFINE REG_DASB2		$4327
.DEFINE REG_A2A2L		$4328
.DEFINE REG_A2A2H		$4329
.DEFINE REG_NTRL2		$432A
.DEFINE REG_UNUSED2		$432B
.DEFINE REG_DMAP3		$4330
.DEFINE REG_BBAD3		$4331
.DEFINE REG_A1T3L		$4332
.DEFINE REG_A1T3H		$4333
.DEFINE REG_A1B3		$4334
.DEFINE REG_DAS3L		$4335
.DEFINE REG_DAS3H		$4336
.DEFINE REG_DASB3		$4337
.DEFINE REG_A2A3L		$4338
.DEFINE REG_A2A3H		$4339
.DEFINE REG_NTRL3		$433A
.DEFINE REG_UNUSED3		$433B
.DEFINE REG_DMAP4		$4340
.DEFINE REG_BBAD4		$4341
.DEFINE REG_A1T4L		$4342
.DEFINE REG_A1T4H		$4343
.DEFINE REG_A1B4		$4344
.DEFINE REG_DAS4L		$4345
.DEFINE REG_DAS4H		$4346
.DEFINE REG_DASB4		$4347
.DEFINE REG_A2A4L		$4348
.DEFINE REG_A2A4H		$4349
.DEFINE REG_NTRL4		$434A
.DEFINE REG_UNUSED4		$434B
.DEFINE REG_DMAP5		$4350
.DEFINE REG_BBAD5		$4351
.DEFINE REG_A1T5L		$4352
.DEFINE REG_A1T5H		$4353
.DEFINE REG_A1B5		$4354
.DEFINE REG_DAS5L		$4355
.DEFINE REG_DAS5H		$4356
.DEFINE REG_DASB5		$4357
.DEFINE REG_A2A5L		$4358
.DEFINE REG_A2A5H		$4359
.DEFINE REG_NTRL5		$435A
.DEFINE REG_UNUSED5		$435B
.DEFINE REG_DMAP6		$4360
.DEFINE REG_BBAD6		$4361
.DEFINE REG_A1T6L		$4362
.DEFINE REG_A1T6H		$4363
.DEFINE REG_A1B6		$4364
.DEFINE REG_DAS6L		$4365
.DEFINE REG_DAS6H		$4366
.DEFINE REG_DASB6		$4367
.DEFINE REG_A2A6L		$4368
.DEFINE REG_A2A6H		$4369
.DEFINE REG_NTRL6		$436A
.DEFINE REG_UNUSED6		$436B
.DEFINE REG_DMAP7		$4370
.DEFINE REG_BBAD7		$4371
.DEFINE REG_A1T7L		$4372
.DEFINE REG_A1T7H		$4373
.DEFINE REG_A1B7		$4374
.DEFINE REG_DAS7L		$4375
.DEFINE REG_DAS7H		$4376
.DEFINE REG_DASB7		$4377
.DEFINE REG_A2A7L		$4378
.DEFINE REG_A2A7H		$4379
.DEFINE REG_NTRL7		$437A
.DEFINE REG_UNUSED7		$437B




; -------------------------- Enhancement chip registers
.DEFINE MSU_STATUS		$2000
.DEFINE MSU_READ		$2001
.DEFINE MSU_ID			$2002
.DEFINE MSU_SEEK		$2000
.DEFINE MSU_TRACK		$2004
.DEFINE MSU_VOLUME		$2006
.DEFINE MSU_CONTROL		$2007
.DEFINE SRTC_READ		$2800
.DEFINE SRTC_WRITE		$2801



; ************************ NMI/IRQ jump tables *************************

; -------------------------- IRQ routine table (for use with SetIRQ macro)
.ENUM $00
;	TBL_HIRQ_XXX		db
	TBL_VIRQ_Area		db
	TBL_VIRQ_Mode7		db
.ENDE



; -------------------------- Vblank routine table (for use with SetNMI macro)
.ENUM $00
	TBL_NMI_Area		db
	TBL_NMI_DebugMenu	db
	TBL_NMI_Error		db
	TBL_NMI_Intro		db
	TBL_NMI_Minimal		db
	TBL_NMI_Mode7		db
	TBL_NMI_WorldMap	db
.ENDE



; **************************** Error codes *****************************

.ENUM 0
	ERR_SPC700				db
.ENDE



; ************************ Event control codes *************************

.ENUM $00								; argument(s) (8/16 bit) / effect(s)
	EC_DIALOG				db			; dialog pointer (16)
	EC_DISABLE_HDMA_CH			db			; HDMA channel(s) no. # (8)
	EC_DMA_ROM2CGRAM			db			; CGRAM target address (8), ROM source address (16), ROM source bank (8), size (16)
	EC_DMA_ROM2VRAM				db			; VRAM target address (16), ROM source address (16), ROM source bank (8), size (16)
	EC_DMA_ROM2WRAM				db			; WRAM target address (16), WRAM target bank (8), ROM source address (16), ROM source bank (8), size (16)
	EC_ENABLE_HDMA_CH			db			; HDMA channel(s) no. # (8)
	EC_GSS_LOAD_TRACK			db			; track no. # (16)
	EC_GSS_TRACK_FADEIN			db			; speed (16), target volume (16)
	EC_GSS_TRACK_FADEOUT			db			; speed (16), target volume (16)
	EC_GSS_TRACK_PLAY			db			; none
	EC_GSS_TRACK_STOP			db			; none
	EC_INIT_GAMEINTRO			db			; none
	EC_JSL					db			; address (24) / go to some subroutine (long)
	EC_JSR					db			; address (16) / go to some subroutine
	EC_JUMP					db			; position in event script to jump to (16)
	EC_LOAD_AREA				db			; no. # of area (16)
	EC_LOAD_PARTY_FORMATION			db			; no. # of party formation
	EC_MONITOR_INPUT_JOY1			db			; joypad data (16), position in event script to jump to (16)
;	EC_MONITOR_INPUT_JOY2			db			; joypad data (16), position in event script to jump to (16)
	EC_MOVE_ALLY				db			; ally no. #, direction(s), speed
	EC_MOVE_HERO				db			; target screen position (16), speed (8) // caveat: position difference has to be divisible by speed value
	EC_MOVE_NPC				db			; NPC no. #, direction(s), speed
	EC_MOVE_OBJ				db			; obj. no. #, direction(s), speed
	EC_MSU_LOAD_TRACK			db			; track no. # (16)
	EC_MSU_TRACK_FADEIN			db			; speed
	EC_MSU_TRACK_FADEOUT			db			; speed
	EC_MSU_TRACK_PLAY			db			; 000000rpvvvvvvvv [r = Repeat flag, p = Play flag, v = volume] (16)
	EC_MSU_TRACK_STOP			db			; none
	EC_SCR_EFFECT				db			; effect no. #
	EC_SCR_EFFECT_TRANSITION		db			; transition effect no. #, speed
	EC_SCR_SCROLL				db			; BG(s), direction(s), speed
	EC_SET_REGISTER				db			; SNES register (16), value (8)
	EC_SET_SHADOW_REGISTER			db			; PPU shadow register & $FFFF (16), value (8)
	EC_SIMULATE_INPUT_JOY1			db			; joypad data (16)
	EC_SIMULATE_INPUT_JOY2			db			; joypad data (16)
	EC_TOGGLE_AUTO_MODE			db			; none / switch auto-mode on/off
	EC_WAIT_JOY1				db			; joypad data (16)
	EC_WAIT_JOY2				db			; joypad data (16)
	EC_WAIT_FRAMES				db			; no. of frames (16)
.ENDE

.DEFINE EC_END					$FF



; *********************** Sprite control tables ************************

; -------------------------- playable character 1 walking frames table (matches spritesheet)
.ENUM $00
	TBL_Hero1_frame00	db
	TBL_Hero1_frame01	db
	TBL_Hero1_frame02	db
.ENDE



; -------------------------- playable character 1 direction table (matches spritesheet)
.ENUM $00
	TBL_Hero1_down		db
	TBL_Hero1_up		db
	TBL_Hero1_left		db
	TBL_Hero1_right		db
.ENDE



; ************************** Misc. constants ***************************

; -------------------------- Memory map
.DEFINE ADDR_CGRAM_Portrait	$10
.DEFINE ADDR_CGRAM_Area		$20
.DEFINE ADDR_CGRAM_WorldMap	$20

.DEFINE ADDR_SRAM_Bank		$B0
.DEFINE ADDR_SRAM_GoodROM	$B06000					; $01 = ROM integrity test passed
.DEFINE ADDR_SRAM_ChksumCmpl	$B0600C					; SRAM checksum & complement
.DEFINE ADDR_SRAM_Chksum	$B0600E
.DEFINE ADDR_SRAM_Slot1		$B06000					; 16 bytes reserved
.DEFINE ADDR_SRAM_Slot1Data	$B06010
.DEFINE ADDR_SRAM_Slot2		$B06800					; ditto
.DEFINE ADDR_SRAM_Slot2Data	$B06810
.DEFINE ADDR_SRAM_Slot3		$B07000					; ditto
.DEFINE ADDR_SRAM_Slot3Data	$B07010
.DEFINE ADDR_SRAM_Slot4		$B07800					; ditto
.DEFINE ADDR_SRAM_Slot4Data	$B07810

.DEFINE ADDR_VRAM_BG1_Tiles	$0000
.DEFINE ADDR_VRAM_BG2_Tiles	$0000
.DEFINE ADDR_VRAM_TextBox	$0000					; text box (BG2)
.DEFINE ADDR_VRAM_TextBoxL1	$0100					; start of line 1 in text box (BG2)
.DEFINE ADDR_VRAM_Portrait	$06C0					; end of text box, start of portrait (BG1, 2 KiB)
.DEFINE ADDR_VRAM_AreaBG1	$0AC0					; area tiles for BG1
.DEFINE ADDR_VRAM_AreaBG2	$3800					; area tiles for BG2 (might need to start at an earlier address)

.DEFINE ADDR_VRAM_BG3_Tiles	$4000
.DEFINE ADDR_VRAM_BG3_TileMap1	$4800
.DEFINE ADDR_VRAM_BG3_TileMap2	$4C00

.DEFINE ADDR_VRAM_BG1_TileMap1	$5000
.DEFINE ADDR_VRAM_BG1_TileMap2	$5400
.DEFINE ADDR_VRAM_BG2_TileMap1	$5800
.DEFINE ADDR_VRAM_BG2_TileMap2	$5C00

.DEFINE ADDR_VRAM_SpriteTiles	$6000					; sprite tiles can go up to $7B5F, and also from $7C00-$7F5F

.DEFINE ADDR_VRAM_BG1_TileMap3	$7800					; only $7B60-$7BFF used for text box
.DEFINE ADDR_VRAM_BG2_TileMap3	$7C00					; only $7F60-$7FFF used for text box

.DEFINE PARAM_CollMarginLeft	3					; collision margin at left/right/top sprite edges
.DEFINE PARAM_CollMarginRight	3
.DEFINE PARAM_CollMarginTop	1					; the top margin value differs from the other two in that it acts as a protection against getting trapped when moving along upper edges horizontally

.DEFINE PARAM_DebugMenu1stLine	78					; Y position of cursor sprite on first debug menu line
.DEFINE PARAM_ErrWaitSPC700	3000					; max. no. of wait loops when communicating with the SPC700 until an error is triggered (the exact value doesn't really matter, but it sholud be reasonably high enough)
.DEFINE PARAM_HUD_Xpos		24					; X position (in px) of HUD text box start
.DEFINE PARAM_HUD_Yhidden	240					; Y position of hidden HUD text box
.DEFINE PARAM_HUD_Yvisible	20					; Y position of visible HUD text box
.DEFINE PARAM_Mode7SkyLines	72					; number of scanlines for sky above Mode 7 landscape

.DEFINE PARAM_RingMenuCenterX	128
.DEFINE PARAM_RingMenuCenterY	112
.DEFINE PARAM_RingMenuRadiusMin	0
.DEFINE PARAM_RingMenuRadiusMax	60

.DEFINE PARAM_TextBox		$02C0					; tilemap entry for start of whole text box area
.DEFINE PARAM_TextBoxAnimSpd	4					; scrolling speed for text box animation (must be a divisor of 48)
.DEFINE PARAM_TextBoxColMath1st	57					; start of first line in a text box selection
;.DEFINE PARAM_TextBoxInside	$02E0					; tilemap entry for inside of text box
.DEFINE PARAM_TextBoxLine1	$02E7					; tilemap entry for start of line 1 in text box
.DEFINE PARAM_TextBoxLine2	$0307					; tilemap entry for start of line 2 in text box
.DEFINE PARAM_TextBoxLine3	$0327					; tilemap entry for start of line 3 in text box
.DEFINE PARAM_TextBoxLine4	$0347					; tilemap entry for start of line 4 in text box

.DEFINE PARAM_TextBoxUL		$02C6					; tilemap entry for upper left corner of text box
.DEFINE PARAM_TextBoxWidth	24					; in "full" (i.e., 16×8) hi-res tiles



; -------------------------- dialog string numbers
.ENUM 0
	DialogStringTest	db
	DialogStringNo0000	db
	DialogStringNo0001	db
	DialogStringNo0002	db
	DialogStringNo0003	db
	DialogStringNo0004	db
	DialogStringNo0005	db
	DialogStringNo0006	db
	DialogStringNo0007	db
	DialogStringNo0008	db
	DialogStringNo0009	db
	DialogStringNo0010	db
	DialogStringNo0011	db
	DialogStringNo0012	db
	DialogStringNo0013	db
	DialogStringNo0014	db
	DialogStringNo0015	db
	DialogStringNo0016	db
	DialogStringNo0017	db
	DialogStringNo0018	db
	DialogStringNo0019	db
	DialogStringNo0020	db
	DialogStringNo0021	db
	DialogStringNo0022	db
	DialogStringNo0023	db
	DialogStringNo0024	db
	DialogStringNo0025	db
	DialogStringNo0026	db
	DialogStringNo0027	db
	DialogStringNo0028	db
	DialogStringNo0029	db
	DialogStringNo0030	db
	DialogStringNo0031	db
	DialogStringNo0032	db
	DialogStringNo0033	db
	DialogStringNo0034	db
	DialogStringNo0035	db
	DialogStringNo0036	db
	DialogStringNo0037	db
	DialogStringNo0038	db
	DialogStringNo0039	db
	DialogStringNo0040	db
	DialogStringNo0041	db
	DialogStringNo0042	db
	DialogStringNo0043	db
	DialogStringNo0044	db
	DialogStringNo0045	db
	DialogStringNo0046	db
	DialogStringNo0047	db
	DialogStringNo0048	db
	DialogStringNo0049	db
	DialogStringNo0050	db
	DialogStringNo0051	db
	DialogStringNo0052	db
	DialogStringNo0053	db
	DialogStringNo0054	db
	DialogStringNo0055	db
	DialogStringNo0056	db
	DialogStringNo0057	db
	DialogStringNo0058	db
	DialogStringNo0059	db
	DialogStringNo0060	db
	DialogStringNo0061	db
	DialogStringNo0062	db
	DialogStringNo0063	db
	DialogStringNo0064	db
	DialogStringNo0065	db
	DialogStringNo0066	db
	DialogStringNo0067	db
	DialogStringNo0068	db
	DialogStringNo0069	db
	DialogStringNo0070	db
	DialogStringNo0071	db
	DialogStringNo0072	db
	DialogStringNo0073	db
	DialogStringNo0074	db
	DialogStringNo0075	db
	DialogStringNo0076	db
	DialogStringNo0077	db
	DialogStringNo0078	db
	DialogStringNo0079	db
	DialogStringNo0080	db
	DialogStringNo0081	db
	DialogStringNo0082	db
	DialogStringNo0083	db
	DialogStringNo0084	db
	DialogStringNo0085	db
	DialogStringNo0086	db
	DialogStringNo0087	db
	DialogStringNo0088	db
	DialogStringNo0089	db
	DialogStringNo0090	db
	DialogStringNo0091	db
	DialogStringNo0092	db
	DialogStringNo0093	db
	DialogStringNo0094	db
	DialogStringNo0095	db
	DialogStringNo0096	db
	DialogStringNo0097	db
	DialogStringNo0098	db
	DialogStringNo0099	db
	DialogStringNo0100	db
	DialogStringNo0101	db
	DialogStringNo0102	db
	DialogStringNo0103	db
	DialogStringNo0104	db
	DialogStringNo0105	db
	DialogStringNo0106	db
	DialogStringNo0107	db
	DialogStringNo0108	db
	DialogStringNo0109	db
	DialogStringNo0110	db
	DialogStringNo0111	db
	DialogStringNo0112	db
	DialogStringNo0113	db
	DialogStringNo0114	db
	DialogStringNo0115	db
	DialogStringNo0116	db
	DialogStringNo0117	db
	DialogStringNo0118	db
	DialogStringNo0119	db
	DialogStringNo0120	db
	DialogStringNo0121	db
	DialogStringNo0122	db
	DialogStringNo0123	db
	DialogStringNo0124	db
	DialogStringNo0125	db
	DialogStringNo0126	db
	DialogStringNo0127	db
	DialogStringNo0128	db
	DialogStringNo0129	db
	DialogStringNo0130	db
	DialogStringNo0131	db
	DialogStringNo0132	db
	DialogStringNo0133	db
	DialogStringNo0134	db
	DialogStringNo0135	db
	DialogStringNo0136	db
	DialogStringNo0137	db
	DialogStringNo0138	db
	DialogStringNo0139	db
	DialogStringNo0140	db
	DialogStringNo0141	db
	DialogStringNo0142	db
	DialogStringNo0143	db
	DialogStringNo0144	db
	DialogStringNo0145	db
	DialogStringNo0146	db
	DialogStringNo0147	db
	DialogStringNo0148	db
	DialogStringNo0149	db
	DialogStringNo0150	db
	DialogStringNo0151	db
	DialogStringNo0152	db
	DialogStringNo0153	db
	DialogStringNo0154	db
	DialogStringNo0155	db
	DialogStringNo0156	db
	DialogStringNo0157	db
	DialogStringNo0158	db
	DialogStringNo0159	db
	DialogStringNo0160	db
	DialogStringNo0161	db
	DialogStringNo0162	db
	DialogStringNo0163	db
	DialogStringNo0164	db
	DialogStringNo0165	db
	DialogStringNo0166	db
	DialogStringNo0167	db
	DialogStringNo0168	db
	DialogStringNo0169	db
	DialogStringNo0170	db
	DialogStringNo0171	db
	DialogStringNo0172	db
	DialogStringNo0173	db
	DialogStringNo0174	db
	DialogStringNo0175	db
	DialogStringNo0176	db
	DialogStringNo0177	db
	DialogStringNo0178	db
	DialogStringNo0179	db
	DialogStringNo0180	db
	DialogStringNo0181	db
	DialogStringNo0182	db
	DialogStringNo0183	db
	DialogStringNo0184	db
	DialogStringNo0185	db
	DialogStringNo0186	db
	DialogStringNo0187	db
	DialogStringNo0188	db
	DialogStringNo0189	db
	DialogStringNo0190	db
	DialogStringNo0191	db
	DialogStringNo0192	db
	DialogStringNo0193	db
	DialogStringNo0194	db
	DialogStringNo0195	db
	DialogStringNo0196	db
	DialogStringNo0197	db
	DialogStringNo0198	db
	DialogStringNo0199	db
	DialogStringNo0200	db
	DialogStringNo0201	db
	DialogStringNo0202	db
	DialogStringNo0203	db
	DialogStringNo0204	db
	DialogStringNo0205	db
	DialogStringNo0206	db
	DialogStringNo0207	db
	DialogStringNo0208	db
.ENDE



; -------------------------- language constants
.ENUM $00
	TBL_Lang_Eng		db					; the order of the languages must match the order of dialog banks!
;	TBL_Lang_Eng2		db
;	TBL_Lang_Eng3		db
	TBL_Lang_Ger		db
;	TBL_Lang_Ger2		db
;	TBL_Lang_Ger3		db
;	TBL_Lang_XXX		db
;	TBL_Lang_XXX		db
;	TBL_Lang_XXX		db
.ENDE



; -------------------------- text box control codes (order has to match the PTR_ProcessTextCC jump table)
.DEFINE CC_Portrait		0
.DEFINE CC_BoxBlue		1
.DEFINE CC_BoxRed		2
.DEFINE CC_BoxPink		3
.DEFINE CC_BoxEvil		4
.DEFINE CC_BoxAlert		5
.DEFINE CC_ClearTextBox		6
.DEFINE CC_Indent		7
.DEFINE CC_Jump			8
.DEFINE CC_NewLine		9
.DEFINE CC_Selection		10
.DEFINE CC_ToggleBold		11
.DEFINE NO_CC			12					; this has to be greater than the last control code
.DEFINE CC_End			255					; $FF = string terminator



; -------------------------- effect numbers
.ENUM 0
	EffectNoFadeFromBlack	dw
	EffectNoFadeToBlack	dw
	EffectNoHSplitIn	dw
	EffectNoHSplitOut	dw
	EffectNoHSplitOut2	dw
	EffectNoShutterIn	dw
	EffectNoShutterOut	dw
	EffectNoDiamondIn	dw
	EffectNoDiamondOut	dw
.ENDE



; -------------------------- effect speed values
.ENUM 1									; positive numbers
	CMD_EffectSpeed1	db
	CMD_EffectSpeed2	db
	CMD_EffectSpeed3	db
	CMD_EffectSpeed4	db
	CMD_EffectSpeed5	db
	CMD_EffectSpeed6	db
	CMD_EffectSpeed7	db
	CMD_EffectSpeed8	db
	CMD_EffectSpeed9	db
	CMD_EffectSpeed10	db
	CMD_EffectSpeed11	db
	CMD_EffectSpeed12	db
.ENDE



; -------------------------- effect delay values
.ENUM $100 DESC								; negative numbers
	CMD_EffectDelay1	db
	CMD_EffectDelay2	db
	CMD_EffectDelay3	db
	CMD_EffectDelay4	db
	CMD_EffectDelay5	db
	CMD_EffectDelay6	db
	CMD_EffectDelay7	db
	CMD_EffectDelay8	db
	CMD_EffectDelay9	db
	CMD_EffectDelay10	db
	CMD_EffectDelay11	db
	CMD_EffectDelay12	db
.ENDE



; -------------------------- SNESGSS SPC commands
.DEFINE SCMD_NONE		$00
.DEFINE SCMD_INITIALIZE		$01
.DEFINE SCMD_LOAD		$02
.DEFINE SCMD_STEREO		$03
.DEFINE SCMD_GLOBAL_VOLUME	$04
.DEFINE SCMD_CHANNEL_VOLUME	$05
.DEFINE SCMD_MUSIC_PLAY 	$06
.DEFINE SCMD_MUSIC_STOP 	$07
.DEFINE SCMD_MUSIC_PAUSE 	$08
.DEFINE SCMD_SFX_PLAY		$09
.DEFINE SCMD_STOP_ALL_SOUNDS	$0a
.DEFINE SCMD_STREAM_START	$0b
.DEFINE SCMD_STREAM_STOP	$0c
.DEFINE SCMD_STREAM_SEND	$0d



; *********************** Direct page variables ************************

.ENUM $00
	ONE_JumpVblank		dsb 4	; DON'T RELOCATE THIS!!		; holds a 4-byte instruction like jml SomeVblankRoutine (NMI vector points here)
	TWO_JumpIRQ		dsb 4	; DON'T RELOCATE THIS!!		; holds a 4-byte instruction like jml SomeIRQRoutine (IRQ vector points here)

	DP_AreaCurrent		dw					; holds no. of current area
	DP_AreaMetaMapAddr	dsb 3					; holds 24-bit address of collision map
	DP_AreaMetaMapIndex	dw
	DP_AreaMetaMapIndex2	dw
	DP_AreaNamePointerNo	dw
	DP_AreaProperties	dw					; rrrrrrrrrrbayxss [s = screen size, as in BGXSC regs, x/y = area is scrollable horizontally/vertically, a/b = auto-scroll area horizontally/vertically, r = reserved]
	DP_AutoJoy1		dw
	DP_AutoJoy2		dw
;	DP_BRR_stream_src	dsb 4					; SNESGSS
;	DP_BRR_stream_list	dsb 4					; SNESGSS
	DP_Chapter		db					; holds no. of current game chapter
	DP_Hero1FrameCounter	db
	DP_Hero1MapPosX		dw					; in px
	DP_Hero1MapPosY		dw					; in px
	DP_Hero1ScreenPosYX	dw					; high byte = Y position, low byte = X position (in px)
	DP_Hero1SpriteStatus	db					; irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]
	DP_Hero1WalkingSpd	dw
;	DP_CurrentScanline	dw					; holds no. of current scanline (for CPU load meter)
	DP_DataAddress		dsb 2					; holds a 24-bit data address e.g. for string pointers, data transfers to SRAM, etc.
	DP_DataBank		db
	DP_DMA_Updates		dw					; rrrcbbaarrr32211 [123 = BG no. that needs to have its tile map(s) updated on next Vblank (low bytes), abc = same thing for high bytes, r = reserved. The lower bit of each BG represents the first half of a 64×32/32×64 tile map, the higher one represents the second half.]
	DP_EffectSpeed		dw
	DP_ErrorCode		db
	DP_EmptySpriteNo	db					; holds no. of empty sprite in current spritesheet (usually 0), this is acknowledged in the sprite initialization routine
	DP_EventCodeAddress	dsb 2
	DP_EventCodeBank	db
	DP_EventCodeJump	dw					; holds event script code pointer to jump to
	DP_EventCodePointer	dw					; holds current event script code pointer
	DP_EventControl		db					; rrrrrrrm [m = monitor joypad 1, r = reserved]
	DP_EventMonitorJoy1	dw					; joypad bits to be monitored by event handler
	DP_EventWaitFrames	dw
	DP_GameConfig		db					; rrrrrucm [c = RTC present, m = MSU1 present, u = Ultra16 present, r = reserved]
	DP_GameMode		db					; arrrrrrr [a = auto-mode, r = reserved]
	DP_GameTimeSeconds	db					; 1 game time second = 1 frame (??)
	DP_GameTimeMinutes	db
	DP_GameTimeHours	db
	DP_GSS_command		dsb 2					; SNESGSS
	DP_GSS_param		dsb 2					; SNESGSS
	DP_HDMA_Channels	db					; variable is copied to $420C (HDMAEN) during Vblank
	DP_HiResPrintLen	db					; holds length of menu hi-res string to print
	DP_HiResPrintMon	db					; keep track of BG we're printing on: $00 = BG1 (start), $01 = BG2
	DP_HUD_DispCounter	dw					; holds frame count since HUD appeared
	DP_HUD_Status		db					; adrrrrrp [a/d = HUD should (re-)appear/disappear, p = HUD is present on screen, r = reserved]
	DP_HUD_StrLength	db					; holds no. of HUD text characters
	DP_HUD_TextBoxSize	db					; holds no. of HUD text box (frame) sprites
	DP_HUD_Ypos		db					; holds current Y position of HUD
	DP_Joy1			dw					; Current button state of joypad1, bit0=0 if it is a valid joypad
	DP_Joy2			dw					; same thing for all pads...
	DP_Joy1Press		dw					; Holds joypad1 keys that are pressed and have been pressed since clearing this mem location
	DP_Joy2Press		dw					; same thing for all pads...
	DP_Joy1New		dw
	DP_Joy2New		dw
	DP_Joy1Old		dw
	DP_Joy2Old		dw
	DP_LoopCounter		dw					; counts loop iterations
	DP_Mode7_Altitude	db					; altitude setting (currently 0-127)
	DP_Mode7_BG2HScroll	db
	DP_Mode7_CenterCoordX	dw
	DP_Mode7_CenterCoordY	dw
	DP_Mode7_RotAngle	dw					; currently needs to be 16-bit as it's used as an index in CalcMode7Matrix
	DP_Mode7_ScrollOffsetX	dw
	DP_Mode7_ScrollOffsetY	dw
	DP_MSU1_NextTrack	dw
	DP_Multi5_Reg0lo	db
	DP_Multi5_Reg0hi	db
	DP_Multi5_Reg1lo	db
	DP_Multi5_Reg1hi	db
	DP_Multi5_Status	db
	DP_NextTrack		dw					; holds no. of music track to load
	DP_NextEvent		dw					; holds no. of event to load
	DP_PlayerIdleCounter	dw					; holds frame count since last button press
	DP_RegisterBuffer	dw					; holds register to be written to next by event handler
	DP_RingMenuAngle	db
	DP_RingMenuAngleOffset	dw
	DP_RingMenuRadius	db
	DP_RingMenuStatus	db					; eirrrrrr 	[e = rotate ring menu left, i = rotate ring menu right, r = reserved]
	DP_SNESlib_ptr		dsb 4					; SNESGSS
;	DP_SNESlib_rand1	dsb 2					; SNESGSS
;	DP_SNESlib_rand2	dsb 2					; SNESGSS
;	DP_SNESlib_temp		dsb 2					; SNESGSS
	DP_SPC_DataBank		dw
	DP_SPC_DataOffset	dw
	DP_SPC_DataSize		dw
	DP_SPC_DataAddress	dw
	DP_SPC_VolCurrent	dw
	DP_SPC_VolFadeSpeed	dw
	DP_SprDataObjNo		db					; holds no. of current object (0-127)
	DP_SprDataHiOAMBits	db					; holds bits to manipulate in high OAM/ARRAY_SpriteBuf2
	DP_SpriteTextMon	dw					; keeps track of sprite-based text buffer filling level
	DP_SpriteTextPalette	db					; holds palette to use when printing sprite-based text
	DP_SubMenuNext		db					; holds no. of sub menu selected
	DP_Temp			dsb 8
	DP_TextASCIIChar	dw					; holds current ASCII character no.
	DP_TextBoxBG		db					; bnnnnnnn [b = change text box background, n = no. of color table (0-127)
	DP_TextBoxCharPortrait	db					; pnnnnnnn [p = change character portrait, n = no. of portrait (0-127)
	DP_TextBoxSelection	db					; dcba4321 [1-4 = text box contains selection on line no. 1-4, a-d = selection made by player (1-4)
	DP_TextBoxSelMax	db					; for HDMA selection bar
	DP_TextBoxSelMin	db					; ditto
	DP_TextBoxStatus	db					; cmfrrrot [c = clear text box, f = freeze text box until player presses A, m = there is more text to process, o = text box is open, r = reserved, t = VWF buffer full, transfer to VRAM]
	DP_TextBoxStrPtr	dw					; 16-bit string pointer (or zeroes) // caveat: text box string addresses need to be separate from other (FWF) string addresses as the engine can process both types of strings at the same time (e.g. text box + HUD)
	DP_TextBoxStrBank	db					; 8-bit bank no. of string
	DP_TextBoxVIRQ		dw					; scanline no. of text box start (for scrolling animation)
	DP_TextCursor		dw
	DP_TextEffect		db					; brrrrrrr [b = toggle bold font, r = reserved]
	DP_TextLanguage		db					; holds language constant
	DP_TextPointerNo	dw
	DP_TextStringPtr	dw					; 16-bit string pointer (or zeroes) // see caveat @ DP_TextBoxStrPtr
	DP_TextStringBank	db					; 8-bit bank no. of string
	DP_TextStringCounter	dw					; holds current ASCII string position
	DP_TextTileDataCounter	dw					; holds current VRAM tile data address
	DP_VWF_BitsUsed		dw
	DP_VWF_BufferIndex	dw
	DP_VWF_Loop		db
	DP_WorldMapBG1VScroll	dw
	DP_WorldMapBG1HScroll	dw
.ENDE									; 188 of 256 bytes used



; *********** $0100-$01FF: Reserved for another direct page ************



; ****************************** .STRUCTs ******************************

.STRUCT ST_RAM_Code
	DoDMA			dsb 49
	UpdatePPURegs		dsb 121
.ENDST



.STRUCT ST_SRAM
	Slot1			dsb 16					; 16 bytes per slot reserved
	Slot1Data		dsb 2032
	Slot2			dsb 16
	Slot2Data		dsb 2032
	Slot3			dsb 16
	Slot3Data		dsb 2032
	Slot4			dsb 16
	Slot4Data		dsb 2032
.ENDST



.STRUCT ST_BG1TileMap1
	Beginning		dsb 704
	TextBox			dsb 192					; 6 lines, 32 tiles each
	Unused			dsb 128
.ENDST



.STRUCT ST_BG1TileMap1Hi
	Beginning		dsb 704
	TextBox			dsb 192
	Unused			dsb 128
.ENDST



.STRUCT ST_BG2TileMap1
	Beginning		dsb 704
	TextBox			dsb 192
	Unused			dsb 128
.ENDST



.STRUCT ST_BG2TileMap1Hi
	Beginning		dsb 704
	TextBox			dsb 192
	Unused			dsb 128
.ENDST



.STRUCT ST_BG3TileMap
	AllTiles		dsb 1024
.ENDST



.STRUCT ST_BG3TileMapHi
	AllTiles		dsb 1024
.ENDST



.STRUCT ST_SpriteDataArea
	Text			dsb 32 * 5				; 32 chars = one line of text
	HUD_TextBox		dsb 36 * 5				; (180 / 2) / 5 = 18 characters in a full box
	Hero1a			dsb 5
	Hero1b			dsb 5
	Hero1c			dsb 5
	Hero1d			dsb 5
	Hero1Weapon1		dsb 5
	Hero1Weapon2		dsb 5
	Hero1Weapon3		dsb 5
	Hero1Weapon4		dsb 5
	Hero2a			dsb 5
	Hero2b			dsb 5
	Hero2c			dsb 5
	Hero2d			dsb 5
	Hero2Weapon1		dsb 5
	Hero2Weapon2		dsb 5
	Hero2Weapon3		dsb 5
	Hero2Weapon4		dsb 5
	Hero3a			dsb 5
	Hero3b			dsb 5
	Hero3c			dsb 5
	Hero3d			dsb 5
	Hero3Weapon1		dsb 5
	Hero3Weapon2		dsb 5
	Hero3Weapon3		dsb 5
	Hero3Weapon4		dsb 5
	NPCs			dsb 36 * 5				; 36 / 2 = max. 18 (16×32) furries
.ENDST



;.STRUCT ST_SpriteDataBattle
;.ENDST



.STRUCT ST_SpriteDataMenu
	Hero1a			dsb 5
	Hero1b			dsb 5
	Hero1c			dsb 5
	Hero1d			dsb 5
	Hero2a			dsb 5
	Hero2b			dsb 5
	Hero2c			dsb 5
	Hero2d			dsb 5
	Hero3a			dsb 5
	Hero3b			dsb 5
	Hero3c			dsb 5
	Hero3d			dsb 5
	MainCursor		dsb 5
	RingCursor		dsb 5
	RingItem0		dsb 5
	RingItem1		dsb 5
	RingItem2		dsb 5
	RingItem3		dsb 5
	RingItem4		dsb 5
	RingItem5		dsb 5
	RingItem6		dsb 5
	RingItem7		dsb 5
	Z_Reserved		dsb 106 * 5
.ENDST



;.STRUCT ST_SpriteDataMode7
;.ENDST



; ******************* Variables in lower 8K of WRAM ********************

.ENUM $0200
	ARRAY_HDMA_ColorMath		dsb 96
	ARRAY_HDMA_M7A			dsb 448
	ARRAY_HDMA_M7B			dsb 448
	ARRAY_HDMA_M7C			dsb 448
	ARRAY_HDMA_M7D			dsb 448
	ARRAY_HDMA_FX_1Byte		dsb 224
	ARRAY_HDMA_FX_2Bytes		dsb 448
	ARRAY_HDMA_BG_Scroll		dsb 16
	ARRAY_HDMA_WorMapVScroll	dsb 448
	ARRAY_ObjectList		dsb 128				; keeps track of currently active sprites, 1 byte per sprite: hcirrrra [a = object is active, c = object can collide with other objects, h = object can collide with hero(es), i = object is hero sprite, r = reserved]
	ARRAY_RandomNumbers		dsb 130				; for random numbers
	ARRAY_ShadowOAM_Lo		dsb 512
	ARRAY_ShadowOAM_Hi		dsb 32
	ARRAY_Temp			dsb 32				; for misc. temp bytes
	ARRAY_TempString		dsb 32				; for temp strings
	ARRAY_VWF_TileBuffer		dsb 32
	ARRAY_VWF_TileBuffer2		dsb 32

	VAR_GameDataItemQty		db
	VAR_Hero1TargetScrPosYX		dw				; high byte = Y position, low byte = X position (in px)
	VAR_Shadow_NMITIMEN		db				; shadow copy of REG_NMITIMEN
	VAR_TextBox_TSTM		dw				; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D) for text box area
	VAR_Time_Second			db				; RTC-based time/date variables
	VAR_Time_Minute			db
	VAR_Time_Hour			db
	VAR_Time_Day			db
	VAR_Time_Month			db
	VAR_Time_Year			db
	VAR_Time_Century		db
	VAR_TimeoutCounter		dw
.ENDE									; $F81 bytes + $200 = $1181 bytes used (initial stack pointer is set to $1FFF)



; ********************** Variables in upper WRAM ***********************

.ENUM $7E2000
	ARRAY_BG1TileMap1		INSTANCEOF ST_BG1TileMap1	; each tile map is 1024 bytes in size (32×32 tiles)
	ARRAY_BG1TileMap2		dsb 1024
	ARRAY_BG1TileMap1Hi		INSTANCEOF ST_BG1TileMap1Hi
	ARRAY_BG1TileMap2Hi		dsb 1024
	ARRAY_BG2TileMap1		INSTANCEOF ST_BG2TileMap1
	ARRAY_BG2TileMap2		dsb 1024
	ARRAY_BG2TileMap1Hi		INSTANCEOF ST_BG2TileMap1Hi
	ARRAY_BG2TileMap2Hi		dsb 1024
	ARRAY_BG3TileMap		INSTANCEOF ST_BG3TileMap
	ARRAY_BG3TileMapHi		INSTANCEOF ST_BG3TileMapHi
	ARRAY_GameDataInventory		dsb 512				; two-byte array for 256 items. Low byte = item no., high byte = quantity
	ARRAY_HDMA_BackgrPlayfield	dsb 704				; 16-bit palette index & 16-bit color entry for 176 scanlines
	ARRAY_HDMA_BackgrTextBox	dsb 192				; ditto for 48 scanlines
	ARRAY_ScratchSpace		dsb 16384
	ARRAY_SpriteDataArea		INSTANCEOF ST_SpriteDataArea	; 128 * 5 = 640 bytes
;	ARRAY_SpriteDataBattle		INSTANCEOF ST_SpriteDataBattle	; ditto
	ARRAY_SpriteDataMenu		INSTANCEOF ST_SpriteDataMenu	; ditto
;	ARRAY_SpriteDataXXX		INSTANCEOF ST_SpriteDataXXX	; ditto
	RAM_Code			INSTANCEOF ST_RAM_Code		; for modifiable routines
.ENDE

.DEFINE VAR_DMAModeBBusReg		RAM_Code.DoDMA+14
.DEFINE VAR_DMASourceOffset		RAM_Code.DoDMA+20
.DEFINE VAR_DMASourceBank		RAM_Code.DoDMA+26
.DEFINE VAR_DMATransferLength		RAM_Code.DoDMA+31

.DEFINE VAR_ShadowINIDISP		RAM_Code.UpdatePPURegs+11
.DEFINE VAR_ShadowOBSEL			RAM_Code.UpdatePPURegs+15
.DEFINE VAR_ShadowBGMODE		RAM_Code.UpdatePPURegs+19
.DEFINE VAR_ShadowMOSAIC		RAM_Code.UpdatePPURegs+23
.DEFINE VAR_ShadowBG1SC			RAM_Code.UpdatePPURegs+27
.DEFINE VAR_ShadowBG2SC			RAM_Code.UpdatePPURegs+31
.DEFINE VAR_ShadowBG3SC			RAM_Code.UpdatePPURegs+35
.DEFINE VAR_ShadowBG4SC			RAM_Code.UpdatePPURegs+39
.DEFINE VAR_ShadowBG12NBA		RAM_Code.UpdatePPURegs+43
.DEFINE VAR_ShadowBG34NBA		RAM_Code.UpdatePPURegs+47
.DEFINE VAR_ShadowW12SEL		RAM_Code.UpdatePPURegs+51
.DEFINE VAR_ShadowW34SEL		RAM_Code.UpdatePPURegs+55
.DEFINE VAR_ShadowWOBJSEL		RAM_Code.UpdatePPURegs+59
.DEFINE VAR_ShadowWH0			RAM_Code.UpdatePPURegs+63
.DEFINE VAR_ShadowWH1			RAM_Code.UpdatePPURegs+67
.DEFINE VAR_ShadowWH2			RAM_Code.UpdatePPURegs+71
.DEFINE VAR_ShadowWH3			RAM_Code.UpdatePPURegs+75
.DEFINE VAR_ShadowWBGLOG		RAM_Code.UpdatePPURegs+79
.DEFINE VAR_ShadowWOBJLOG		RAM_Code.UpdatePPURegs+83
.DEFINE VAR_ShadowTM			RAM_Code.UpdatePPURegs+87
.DEFINE VAR_ShadowTS			RAM_Code.UpdatePPURegs+91
.DEFINE VAR_ShadowTMW			RAM_Code.UpdatePPURegs+95
.DEFINE VAR_ShadowTSW			RAM_Code.UpdatePPURegs+99
.DEFINE VAR_ShadowCGWSEL		RAM_Code.UpdatePPURegs+103
.DEFINE VAR_ShadowCGADSUB		RAM_Code.UpdatePPURegs+107
.DEFINE VAR_ShadowCOLDATA		RAM_Code.UpdatePPURegs+111
.DEFINE VAR_ShadowSETINI		RAM_Code.UpdatePPURegs+115



; *************************** SRAM variables ***************************

.ENUM $6000
	SRAM				INSTANCEOF ST_SRAM
.ENDE									; max. 8192 bytes



; ******************************** EOF *********************************
