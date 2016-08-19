;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** VARIABLE DEFINITIONS ***
;
;==========================================================================================



; ****************************** Notation ******************************

; Label prefixes:

; __		= sub-label
; ADDR_		= address value, as .DEFINEd
; ARRAY_	= non-Direct Page array
; CC_		= control code byte (for text strings)
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

; -------------------------- processor status bits
.DEFINE DEC_MODE		$08
.DEFINE XY_8BIT			$10
.DEFINE A_8BIT			$20
.DEFINE AXY_8BIT		$30



; -------------------------- CPU/PPU registers
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
.DEFINE REG_APUIO01		$2140					; for 16-bit writes to $2140/$2141
.DEFINE REG_APUIO23		$2142					; for 16-bit writes to $2142/$2143
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
	TBL_HIRQ_MainMenu	db
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
.DEFINE ADDR_CGRAM_PORTRAIT	$10
.DEFINE ADDR_CGRAM_AREA		$20
.DEFINE ADDR_CGRAM_WORLDMAP	$20

.DEFINE ADDR_SRAM_BANK		$B0
.DEFINE ADDR_SRAM_ROMGOOD	$B06000					; $01 = ROM integrity test passed
.DEFINE ADDR_SRAM_CHKSUMCMPL	$B0600C					; SRAM checksum & complement
.DEFINE ADDR_SRAM_CHKSUM	$B0600E
.DEFINE ADDR_SRAM_SLOT1		$B06000					; 16 bytes reserved
.DEFINE ADDR_SRAM_SLOT1DATA	$B06010
.DEFINE ADDR_SRAM_SLOT2		$B06800					; ditto
.DEFINE ADDR_SRAM_SLOT2DATA	$B06810
.DEFINE ADDR_SRAM_SLOT3		$B07000					; ditto
.DEFINE ADDR_SRAM_SLOT3DATA	$B07010
.DEFINE ADDR_SRAM_SLOT4		$B07800					; ditto
.DEFINE ADDR_SRAM_SLOT4DATA	$B07810

.DEFINE ADDR_VRAM_BG1_Tiles	$0000
.DEFINE ADDR_VRAM_BG2_Tiles	$0000
.DEFINE ADDR_VRAM_TextBox	$0000					; text box (BG2)
.DEFINE ADDR_VRAM_TextBoxL1	$0100					; start of line 1 in text box (BG2)
.DEFINE ADDR_VRAM_Portrait	$06C0					; end of text box, start of portrait (BG1, 2 KiB)
.DEFINE ADDR_VRAM_AreaBG1	$0AC0					; area tiles for BG1
.DEFINE ADDR_VRAM_AreaBG2	$3800					; area tiles for BG2 (might need to start at an earlier address)

.DEFINE ADDR_VRAM_BG3_Tiles	$4000
.DEFINE ADDR_VRAM_BG3_Tilemap1	$4800
.DEFINE ADDR_VRAM_BG3_Tilemap2	$4C00

.DEFINE ADDR_VRAM_BG1_Tilemap1	$5000
.DEFINE ADDR_VRAM_BG1_Tilemap2	$5400
.DEFINE ADDR_VRAM_BG2_Tilemap1	$5800
.DEFINE ADDR_VRAM_BG2_Tilemap2	$5C00

.DEFINE ADDR_VRAM_SPR_Tiles	$6000					; sprite tiles can go up to $7B5F, and also from $7C00-$7F5F

.DEFINE ADDR_VRAM_BG1_Tilemap3	$7800					; only $7B60-$7BFF used for text box
.DEFINE ADDR_VRAM_BG2_Tilemap3	$7C00					; only $7F60-$7FFF used for text box

.DEFINE PARAM_RingMenuCenterX	128
.DEFINE PARAM_RingMenuCenterY	112
.DEFINE PARAM_RingMenuRadiusMin	0
.DEFINE PARAM_RingMenuRadiusMax	60

.DEFINE PARAM_MODE7_SKY_LINES	72					; number of scanlines for sky above Mode 7 landscape

.DEFINE PARAM_TextBox		$02C0					; tilemap entry for start of whole text box area
;.DEFINE PARAM_TextBoxInside	$02E0					; tilemap entry for inside of text box
.DEFINE PARAM_TextBox_Line1	$02E7					; tilemap entry for start of line 1 in text box
.DEFINE PARAM_TextBox_Line2	$0307					; tilemap entry for start of line 2 in text box
.DEFINE PARAM_TextBox_Line3	$0327					; tilemap entry for start of line 3 in text box
.DEFINE PARAM_TextBox_Line4	$0347					; tilemap entry for start of line 4 in text box

.DEFINE PARAM_TEXTBOX_UL	$02C6					; tilemap entry for upper left corner of text box
.DEFINE PARAM_TEXTBOX_WIDTH	24					; in "full" (i.e., 16×8) hi-res tiles



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
.DEFINE CC_BoxPissed		5
.DEFINE CC_ClearTextBox		6
.DEFINE CC_Indent		7
.DEFINE CC_NewLine		8
.DEFINE CC_Selection		9
.DEFINE NO_CC			10					; this has to be greater than the last control code
.DEFINE CC_End			$FF					; end-of-string marker



; -------------------------- various commands
.DEFINE CMD_EffectSpeed1	$01
.DEFINE CMD_EffectSpeed2	$02
.DEFINE CMD_EffectSpeed3	$03
.DEFINE CMD_EffectSpeed4	$04
.DEFINE CMD_EffectSpeed5	$05
.DEFINE CMD_EffectSpeed6	$06
.DEFINE CMD_EffectSpeed7	$07
.DEFINE CMD_EffectSpeed8	$08



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

	strPtr			dw
	strBank			dsb 3

	DP_SubStrAddr		dsb 3					; holds a 24-bit sub string start address

	SprTextMon		dw					; keeps track of sprite-based text buffer filling level
	SprTextPalette		db					; holds palette to use when printing sprite-based text

	temp			dsb 8

	Cursor			dw

	Joy1			dw					; Current button state of joypad1, bit0=0 if it is a valid joypad
	Joy2			dw					; same thing for all pads...

	Joy1Press		dw					; Holds joypad1 keys that are pressed and have been pressed since clearing this mem location
	Joy2Press		dw					; same thing for all pads...
									; X Y TL  TR . . . .
									; A B sel st U D L R
	Joy1New			dw
	Joy2New			dw

	Joy1Old			dw
	Joy2Old			dw

	scrollYCounter		db
	scrollYUp		db
	scrollYDown		db

	cursorX			db
	cursorY			db
	cursorYCounter		db
	cursorYUp		db
	cursorYDown		db

	speedCounter		db
	speedScroll		db

	sneslib_ptr		dsb 4
	sneslib_temp		dsb 2
	sneslib_rand1		dsb 2
	sneslib_rand2		dsb 2

	gss_param		dsb 2
	gss_command		dsb 2

	brr_stream_src		dsb 4
	brr_stream_list		dsb 4

	DP_NextTrack		dw
	DP_SPC_DATA_BANK	dw
	DP_SPC_DATA_OFFS	dw
	DP_SPC_DATA_SIZE	dw
	DP_SPC_DATA_ADDR	dw
	DP_SPC_VOL_CURRENT	dw
	DP_SPC_VOL_FADESPD	dw

	DP_AreaCurrent		dw					; holds no. of current area
	DP_AreaMetaMapAddr	dsb 3					; holds 24-bit address of collision map
	DP_AreaMetaMapIndex	dw
	DP_AreaNamePointer	dw
	DP_AreaProperties	dw					; 0000000000bayxss [s = screen size, as in BGXSC regs, x/y = area is scrollable horizontally/vertically, a/b = auto-scroll area horizontally/vertically, 0 = reserved]

	DP_Char1FrameCounter	db
	DP_Char1MapPosX		dw					; in px
	DP_Char1MapPosY		dw					; in px
	DP_Char1ScreenPosYX	dw					; high byte = Y position, low byte = X position (in px)
	DP_Char1SpriteStatus	db					; irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]
	DP_Char1WalkingSpd	dw

	DP_DataSrcAddress	dsb 3					; holds a 24-bit source address e.g. for data transfers to SRAM

	DP_DMAUpdates		dw					; rrrcbbaarrr32211 [123 = BG no. that needs to have its tile map(s) updated on next Vblank (low bytes), abc = same thing for high bytes, r = reserved. The lower bit of each BG represents the first half of a 64×32/32×64 tile map, the higher one represents the second half.]

	DP_EffectSpeed		db

	DP_HDMAchannels		db					; DCBAcbsr [ABCD = M7A/M7B/M7C/M7D, c = color math, b = background color gradient, s = screen mode, r = reserved]. Variable is transferred to $420C during Vblank


	DP_GameMode		db					; 7rrrrrrr [7 = Mode7 on/off, r = reserved]

	DP_GameTime_Seconds	db					; 1 game time second = 1 frame (??)
	DP_GameTime_Minutes	db
	DP_GameTime_Hours	db

	DP_HiResPrintLen	db					; holds length of menu hi-res string to print
	DP_HiResPrintMon	db					; keep track of BG we're printing on: $00 = BG1 (start), $01 = BG2

	DP_HUD_DispCounter	dw					; holds frame count since HUD appeared
	DP_HUD_Status		db					; adrrrrrp [a/d = HUD should (re-)appear/disappear, p = HUD is present on screen]
	DP_PlayerIdleCounter	dw					; holds frame count since last button press

	DP_RingMenuAngle	dw
	DP_RingMenuAngleOffset	dw
	DP_RingMenuRadius	db

	DP_Mode7_Altitude	db
	DP_Mode7_AltTabOffset	dsb 3					; holds a 24-bit address
	DP_Mode7_RotAngle	dw					; currently needs to be 16-bit as it's used as an index in CalcMode7Matrix
	DP_Mode7_ScrollOffsetX	dw
	DP_Mode7_ScrollOffsetY	dw
	DP_Mode7_CenterCoordX	dw
	DP_Mode7_CenterCoordY	dw
	DP_Mode7_FrameCounter	db

	DP_MSU1present		db
	DP_MSU1NextTrack	dw

	DP_Multi5_Reg0lo	db
	DP_Multi5_Reg0hi	db
	DP_Multi5_Reg1lo	db
	DP_Multi5_Reg1hi	db
	DP_Multi5_Status	db

	DP_Shadow_NMITIMEN	db					; shadow copy of REG_NMITIMEN
	DP_Shadow_TSTM		dw					; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D)

	DP_TextASCIIChar	dw					; holds current ASCII character no.
	DP_TextBoxCharPortrait	db					; pnnnnnnn [p = change character portrait, n = no. of portrait (0-127)
	DP_TextBoxSelection	db					; holds selection option chosen by player
	DP_TextBoxSelMax	db					; for HDMA selection bar
	DP_TextBoxSelMin	db					; ditto
	DP_TextBoxStatus	db					; cm4321ot [c = clear text box, m = there is more text to process, o = text box is open, 1-4 = text box contains selection on line no. 1-4, t = VWF buffer full, transfer to VRAM]
	DP_TextLanguage		db					; holds language constant
	DP_TextPointer		dw
	DP_TextPointerBank	db
	DP_TextPointerNo	dw
	DP_TextString		dw
	DP_TextStringBank	db
	DP_TextStringCounter	dw					; holds current ASCII string position
	DP_TextTileDataCounter	dw					; holds current VRAM tile data address

	DP_CurrentScanline	dw					; holds no. of current scanline (for CPU load meter)

	DP_VWFBitsUsed		dw
	DP_VWFBufferIndex	dw
	DP_VWFLoop		db
.ENDE									; 188 of 256 bytes used



; *********** $0100-$01FF: Reserved for another direct page ************



; ****************************** .STRUCTs ******************************

.STRUCT oam_high
	Cursor			db
	NPCs			dsb 10
	RingMenu		dsb 4
	Reserved		dsb 7
	PlayableChar		dsb 2
	Text			dsb 8
.ENDST



.STRUCT oam_low
	Cursor			dsb 4
	CursorReserved		dsb 12
	NPCs			dsb 160
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
	Reserved		dsb 112
	PlayableChar		dsb 24
	PlayableCharReserved	dsb 8
	Text			dsb 128					; for one line of text (32 chars)
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

	ARRAY_VWFTileBuffer		dsb 32
	ARRAY_VWFTileBuffer2		dsb 32

	ARRAY_HDMA_ColorMath		dsb 96

	ARRAY_HDMA_M7A			dsb 448
	ARRAY_HDMA_M7B			dsb 448
	ARRAY_HDMA_M7C			dsb 448
	ARRAY_HDMA_M7D			dsb 448

	ARRAY_HDMA_MainEffects		dsb 224
	ARRAY_HDMA_BGScroll		dsb 16
	ARRAY_HDMA_HUDScroll		dsb 10

	ARRAY_TempString		dsb 32				; for temp strings

	VAR_TextBox_TSTM		dw				; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D) for text box area
.ENDE									; $BDC bytes + $200 = $DDC bytes used (stack resides at $1FFF)



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
