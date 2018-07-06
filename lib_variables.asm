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



; -------------------------- MSU1 registers
.DEFINE MSU_STATUS		$2000
.DEFINE MSU_READ		$2001
.DEFINE MSU_ID			$2002
.DEFINE MSU_SEEK		$2000
.DEFINE MSU_TRACK		$2004
.DEFINE MSU_VOLUME		$2006
.DEFINE MSU_CONTROL		$2007



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
	TBL_NMI_Mode7		db
	TBL_NMI_WorldMap	db
	TBL_NMI_Intro		db
.ENDE



; ************************ Event control codes *************************

.ENUM $00								; argument(s) (8/16 bit) / effect(s)
	EC_DIALOG				db			; dialog pointer (16)
	EC_DISABLE_HDMA_CH			db			; HDMA channel(s) no. # (8)
	EC_DMA_ROM2CGRAM			db			; CGRAM target address (8), ROM source address (16), ROM source bank (8), size (16)
	EC_DMA_ROM2VRAM				db			; VRAM target address (16), ROM source address (16), ROM source bank (8), size (16)
	EC_ENABLE_HDMA_CH			db			; HDMA channel(s) no. # (8)
	EC_GSS_LOAD_TRACK			db			; track no. # (16)
	EC_GSS_TRACK_FADEIN			db			; speed (16), target volume (16)
	EC_GSS_TRACK_FADEOUT			db			; speed (16), target volume (16)
	EC_GSS_TRACK_PLAY			db			; none
	EC_GSS_TRACK_STOP			db			; none
	EC_INIT_GAMEINTRO			db			; none
	EC_JSL					db			; address (16) / go to some subroutine
	EC_JSR					db			; address (24) / go to some subroutine
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
	EC_SET_REGISTER				db			; register (16), value (8) 
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
	TBL_Char1_frame00	db
	TBL_Char1_frame01	db
	TBL_Char1_frame02	db
.ENDE



; -------------------------- playable character 1 direction table (matches spritesheet)
.ENUM $00
	TBL_Char1_down		db
	TBL_Char1_up		db
	TBL_Char1_left		db
	TBL_Char1_right		db
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

.DEFINE PARAM_HUD_Xpos		24					; X position (in px) of HUD text box start
.DEFINE PARAM_HUD_Ypos		239
.DEFINE PARAM_Mode7SkyLines	72					; number of scanlines for sky above Mode 7 landscape

.DEFINE PARAM_RingMenuCenterX	128
.DEFINE PARAM_RingMenuCenterY	112
.DEFINE PARAM_RingMenuRadiusMin	0
.DEFINE PARAM_RingMenuRadiusMax	60

.DEFINE PARAM_TextBox		$02C0					; tilemap entry for start of whole text box area
.DEFINE PARAM_TextBoxAnimSpd	4					; scrolling speed for text box animation (must be a divisor of 48)
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



; -------------------------- text box control codes
.DEFINE CC_Portrait		0
.DEFINE CC_BoxBlue		1
.DEFINE CC_BoxRed		2
.DEFINE CC_BoxPink		3
.DEFINE CC_BoxEvil		4
.DEFINE CC_BoxAlert		5
.DEFINE CC_ClearTextBox		6
.DEFINE CC_Indent		7
.DEFINE CC_NewLine		8
.DEFINE CC_Selection		9
.DEFINE NO_CC			10					; this has to be greater than the last control code
.DEFINE CC_End			$FF					; end-of-string marker



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
.ENUM $FF DESC								; negative numbers
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
	DP_VblankJump		dsb 4					; holds a 4-byte instruction like jml SomeVblankRoutine (NMI vector points here)
	DP_IRQJump		dsb 4					; holds a 4-byte instruction like jml SomeIRQRoutine (IRQ vector points here)

	temp			dsb 8

;	scrollYCounter		db
;	scrollYUp		db
;	scrollYDown		db
;	cursorX			db
;	cursorY			db
;	cursorYCounter		db
;	cursorYUp		db
;	cursorYDown		db
;	speedCounter		db
;	speedScroll		db

	sneslib_ptr		dsb 4
;	sneslib_temp		dsb 2
;	sneslib_rand1		dsb 2
;	sneslib_rand2		dsb 2
	gss_param		dsb 2
	gss_command		dsb 2
;	brr_stream_src		dsb 4
;	brr_stream_list		dsb 4

	DP_AreaCurrent		dw					; holds no. of current area
	DP_AreaMetaMapAddr	dsb 3					; holds 24-bit address of collision map
	DP_AreaMetaMapIndex	dw
	DP_AreaMetaMapIndex2	dw
	DP_AreaNamePointerNo	dw
	DP_AreaProperties	dw					; 0000000000bayxss [s = screen size, as in BGXSC regs, x/y = area is scrollable horizontally/vertically, a/b = auto-scroll area horizontally/vertically, 0 = reserved]
	DP_AutoJoy1		dw
	DP_AutoJoy2		dw
	DP_Char1FrameCounter	db
	DP_Char1MapPosX		dw					; in px
	DP_Char1MapPosY		dw					; in px
	DP_Char1ScreenPosYX	dw					; high byte = Y position, low byte = X position (in px)
	DP_Char1SpriteStatus	db					; irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]
	DP_Char1WalkingSpd	dw
;	DP_CurrentScanline	dw					; holds no. of current scanline (for CPU load meter)
	DP_DataAddress		dsb 2					; holds a 24-bit data address e.g. for string pointers, data transfers to SRAM, etc.
	DP_DataBank		db
	DP_DMA_Updates		dw					; rrrcbbaarrr32211 [123 = BG no. that needs to have its tile map(s) updated on next Vblank (low bytes), abc = same thing for high bytes, r = reserved. The lower bit of each BG represents the first half of a 64×32/32×64 tile map, the higher one represents the second half.]
	DP_EffectSpeed		dw
	DP_EventCodeAddress	dsb 2
	DP_EventCodeBank	db
	DP_EventCodeJump	dw					; holds event script code pointer to jump to
	DP_EventCodePointer	dw					; holds current event script code pointer
	DP_EventControl		db					; rrrrrrrm [m = monitor joypad 1, r = reserved]
	DP_EventMonitorJoy1	dw					; joypad bits to be monitored by event handler
	DP_EventWaitFrames	dw
	DP_GameMode		db					; arrrrrrr [a = auto-mode, r = reserved]
	DP_GameTimeSeconds	db					; 1 game time second = 1 frame (??)
	DP_GameTimeMinutes	db
	DP_GameTimeHours	db
	DP_HDMA_Channels	db					; DCBAcbsr [ABCD = M7A/M7B/M7C/M7D, c = color math, b = background color gradient, s = screen mode, r = reserved]. Variable is transferred to $420C during Vblank
	DP_HiResPrintLen	db					; holds length of menu hi-res string to print
	DP_HiResPrintMon	db					; keep track of BG we're printing on: $00 = BG1 (start), $01 = BG2
	DP_HUD_DispCounter	dw					; holds frame count since HUD appeared
	DP_HUD_Status		db					; adrrrrrp [a/d = HUD should (re-)appear/disappear, p = HUD is present on screen]
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
	DP_Mode7_Altitude	db					; altitude setting (currently 0-127)
	DP_Mode7_BG2HScroll	db
	DP_Mode7_CenterCoordX	dw
	DP_Mode7_CenterCoordY	dw
	DP_Mode7_RotAngle	dw					; currently needs to be 16-bit as it's used as an index in CalcMode7Matrix
	DP_Mode7_ScrollOffsetX	dw
	DP_Mode7_ScrollOffsetY	dw
	DP_MSU1_NextTrack	dw
	DP_MSU1_Present		db
	DP_Multi5_Reg0lo	db
	DP_Multi5_Reg0hi	db
	DP_Multi5_Reg1lo	db
	DP_Multi5_Reg1hi	db
	DP_Multi5_Status	db
	DP_NextTrack		dw					; holds no. of music track to load
	DP_NextEvent		dw					; holds no. of event to load
	DP_PlayerIdleCounter	dw					; holds frame count since last button press
	DP_RegisterBuffer	dw					; holds register to be written to next by event handler
	DP_RingMenuAngle	dw
	DP_RingMenuAngleOffset	dw
	DP_RingMenuRadius	db
	DP_Shadow_NMITIMEN	db					; shadow copy of REG_NMITIMEN
	DP_Shadow_TSTM		dw					; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D)
	DP_SPC_DataBank		dw
	DP_SPC_DataOffset	dw
	DP_SPC_DataSize		dw
	DP_SPC_DataAddress	dw
	DP_SPC_VolCurrent	dw
	DP_SPC_VolFadeSpeed	dw
	DP_SpriteTextMon	dw					; keeps track of sprite-based text buffer filling level
	DP_SpriteTextPalette	db					; holds palette to use when printing sprite-based text
	DP_TextASCIIChar	dw					; holds current ASCII character no.
	DP_TextBoxBG		db					; bnnnnnnn [b = change text box background, n = no. of color table (0-127)
	DP_TextBoxCharPortrait	db					; pnnnnnnn [p = change character portrait, n = no. of portrait (0-127)
	DP_TextBoxSelection	db					; rrrr4321 [1-4 = text box contains selection on line no. 1-4, r = reserved], also holds selection made by player
	DP_TextBoxSelMax	db					; for HDMA selection bar
	DP_TextBoxSelMin	db					; ditto
	DP_TextBoxStatus	db					; cmfrrrot [c = clear text box, f = freeze text box until player presses A, m = there is more text to process, o = text box is open, r = reserved, t = VWF buffer full, transfer to VRAM]
	DP_TextBoxStrPtr	dw					; 16-bit string pointer (or zeroes) // caveat: text box string addresses need to be separate from other (FWF) string addresses as the engine can process both types of strings at the same time (e.g. text box + HUD)
	DP_TextBoxStrBank	db					; 8-bit bank no. of string
	DP_TextBoxVIRQ		dw					; scanline no. of text box start (for scrolling animation)
	DP_TextCursor		dw
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
.ENDE									; 181 of 256 bytes used



; *********** $0100-$01FF: Reserved for another direct page ************



; ****************************** .STRUCTs ******************************

.STRUCT oam_high
	Text			dsb 8
	HUD_TextBox		dsb 9
	RingMenu		dsb 4
	NPCs			dsb 7
	PlayableChar		dsb 2
	Reserved		dsb 2
.ENDST



.STRUCT oam_low
	Text			dsb 128					; for one line of text (32 chars)
	HUD_TextBox		dsb 144					; 144 / 2 = 72, i. e. a full box can hold at least 18 characters
	RingMenuCursor		dsb 4
	RingMenuItem1		dsb 4
	RingMenuItem2		dsb 4
	RingMenuItem3		dsb 4
	RingMenuItem4		dsb 4
	RingMenuItem5		dsb 4
	RingMenuItem6		dsb 4
	RingMenuItem7		dsb 4
	RingMenuItem8		dsb 4
	RingMenuMisc		dsb 28
	NPCs			dsb 112					; 112 / 2 = 56, i. e. max. 14 (16×32) furries possible
	PlayableChar		dsb 24
	PlayableCharReserved	dsb 8
	Reserved		dsb 32
.ENDST



.STRUCT sram
	Slot1			dsb 16					; 16 bytes per slot reserved
	Slot1Data		dsb 2032
	Slot2			dsb 16
	Slot2Data		dsb 2032
	Slot3			dsb 16
	Slot3Data		dsb 2032
	Slot4			dsb 16
	Slot4Data		dsb 2032
.ENDST



.STRUCT tilemap_bg1
	Beginning		dsb 704
	TextBox			dsb 192					; 6 lines, 32 tiles each
	Unused			dsb 128
.ENDST



.STRUCT tilemap_bg1_hi
	Beginning		dsb 704
	TextBox			dsb 192
	Unused			dsb 128
.ENDST



.STRUCT tilemap_bg2
	Beginning		dsb 704
	TextBox			dsb 192
	Unused			dsb 128
.ENDST



.STRUCT tilemap_bg2_hi
	Beginning		dsb 704
	TextBox			dsb 192
	Unused			dsb 128
.ENDST



.STRUCT tilemap_bg3
	AllTiles		dsb 1024
.ENDST



.STRUCT tilemap_bg3_hi
	AllTiles		dsb 1024
.ENDST



; ******************* Variables in lower 8K of WRAM ********************

.ENUM $0200
	RAM_Code			dsb 256				; for modifiable routines

	ARRAY_SpriteBuf1		INSTANCEOF oam_low		; 512 bytes
	ARRAY_SpriteBuf2		INSTANCEOF oam_high		; 32 bytes

	ARRAY_VWF_TileBuffer		dsb 32
	ARRAY_VWF_TileBuffer2		dsb 32

	ARRAY_HDMA_ColorMath		dsb 96

	ARRAY_HDMA_M7A			dsb 448
	ARRAY_HDMA_M7B			dsb 448
	ARRAY_HDMA_M7C			dsb 448
	ARRAY_HDMA_M7D			dsb 448

	ARRAY_HDMA_FX_1Byte		dsb 224
	ARRAY_HDMA_FX_2Bytes		dsb 448
	ARRAY_HDMA_BG_Scroll		dsb 16
	ARRAY_HDMA_WorMapVertScr	dsb 448

	ARRAY_TempString		dsb 32				; for temp strings

	VAR_Char1TargetScrPosYX		dw				; high byte = Y position, low byte = X position (in px)
	VAR_TextBox_TSTM		dw				; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D) for text box area
.ENDE									; $D9C bytes + $200 = $F9C bytes used (stack resides at $1FFF)



.DEFINE VAR_DMAModeBBusReg		RAM_Code+14
.DEFINE VAR_DMASourceOffset		RAM_Code+20
.DEFINE VAR_DMASourceBank		RAM_Code+26
.DEFINE VAR_DMATransferLength		RAM_Code+31



; ********************** Variables in upper WRAM ***********************

.ENUM $7E2000
	ARRAY_BG1TileMap1		INSTANCEOF tilemap_bg1		; each tile map is 1024 bytes in size (32×32 tiles)
	ARRAY_BG1TileMap2		dsb 1024
	ARRAY_BG1TileMap1Hi		INSTANCEOF tilemap_bg1_hi
	ARRAY_BG1TileMap2Hi		dsb 1024
	ARRAY_BG2TileMap1		INSTANCEOF tilemap_bg2
	ARRAY_BG2TileMap2		dsb 1024
	ARRAY_BG2TileMap1Hi		INSTANCEOF tilemap_bg2_hi
	ARRAY_BG2TileMap2Hi		dsb 1024
	ARRAY_BG3TileMap		INSTANCEOF tilemap_bg3
	ARRAY_BG3TileMapHi		INSTANCEOF tilemap_bg3_hi
	ARRAY_HDMA_BackgrPlayfield	dsb 704				; 16-bit palette index & 16-bit color entry for 176 scanlines
	ARRAY_HDMA_BackgrTextBox	dsb 192				; ditto for 48 scanlines
	ARRAY_ScratchSpace		dsb 16384
.ENDE



; *************************** SRAM variables ***************************

.ENUM $6000
	SRAM				INSTANCEOF sram
.ENDE									; max. 8192 bytes



; ******************************** EOF *********************************
