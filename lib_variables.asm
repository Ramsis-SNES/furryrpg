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
	.DEFINE REG_SLHV		$2137
	.DEFINE REG_OPVCT		$213D
	.DEFINE REG_NMITIMEN		$4200
	.DEFINE REG_RDNMI		$4210
	.DEFINE REG_TIMEUP		$4211
	.DEFINE REG_HVBJOY		$4212
	.DEFINE REG_JOY0		$4218
	.DEFINE REG_JOY1		$421A
	.DEFINE REG_JOY2		$421C
	.DEFINE REG_JOY3		$421E
	.DEFINE REG_JOYSER0		$4016
	.DEFINE REG_JOYSER1		$4017
	.DEFINE REG_WRIO		$4201



; -------------------------- SPC700 I/O ports
	.DEFINE REG_APUIO0		$2140
	.DEFINE REG_APUIO1		$2141
	.DEFINE REG_APUIO2		$2142
	.DEFINE REG_APUIO3		$2143
	.DEFINE REG_APUIO01		$2140	; for 16-bit writes to $2140/$2141
	.DEFINE REG_APUIO23		$2142	; for 16-bit writes to $2142/$2143



; -------------------------- MSU1 registers

	.DEFINE MSU_STATUS		$2000
	.DEFINE MSU_READ		$2001
	.DEFINE MSU_ID			$2002
	.DEFINE MSU_SEEK		$2000
	.DEFINE MSU_TRACK		$2004
	.DEFINE MSU_VOLUME		$2006
	.DEFINE MSU_CONTROL		$2007



; ************************ NMI/IRQ jump tables *************************

; -------------------------- IRQ routine table (for use with SetIRQRoutine macro)
.ENUM $00
	TBL_HIRQ_MainMenu	db
	TBL_VIRQ_Area		db
	TBL_VIRQ_Mode7		db
.ENDE



; -------------------------- Vblank routine table (for use with SetVblankRoutine macro)
.ENUM $00
	TBL_NMI_Area		db
	TBL_NMI_DebugMenu	db
	TBL_NMI_Error		db
	TBL_NMI_Mode7		db
	TBL_NMI_Playfield	db
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

	.DEFINE ADDR_SRAM_ROMGOOD	$B06000	; $01 = ROM integrity test passed
	.DEFINE ADDR_SRAM_CHKSUMCMPL	$B0600C	; SRAM checksum & complement
	.DEFINE ADDR_SRAM_CHKSUM	$B0600E

	.DEFINE ADDR_SRAM_SLOT1		$B06000	; 16 bytes reserved
	.DEFINE ADDR_SRAM_SLOT1DATA	$B06010

	.DEFINE ADDR_SRAM_SLOT2		$B06800	; ditto
	.DEFINE ADDR_SRAM_SLOT2DATA	$B06810

	.DEFINE ADDR_SRAM_SLOT3		$B07000	; ditto
	.DEFINE ADDR_SRAM_SLOT3DATA	$B07010

	.DEFINE ADDR_SRAM_SLOT4		$B07800	; ditto
	.DEFINE ADDR_SRAM_SLOT4DATA	$B07810

	.DEFINE ADDR_VRAM_BG1_Tiles	$0000
	.DEFINE ADDR_VRAM_BG2_Tiles	$0000
	.DEFINE ADDR_VRAM_TextBox	$0000	; text box (BG2)
	.DEFINE ADDR_VRAM_TextBoxL1	$0100	; start of line 1 in text box (BG2)
	.DEFINE ADDR_VRAM_Portrait	$06C0	; end of text box, start of portrait (BG1, 2 KiB)
	.DEFINE ADDR_VRAM_AreaBG1	$0AC0	; area tiles for BG1
	.DEFINE ADDR_VRAM_AreaBG2	$3800	; area tiles for BG2 (might need to start at an earlier address)

	.DEFINE ADDR_VRAM_BG3_Tiles	$4000
	.DEFINE ADDR_VRAM_BG3_Tilemap1	$4800
	.DEFINE ADDR_VRAM_BG3_Tilemap2	$4C00

	.DEFINE ADDR_VRAM_BG1_Tilemap1	$5000
	.DEFINE ADDR_VRAM_BG1_Tilemap2	$5400
	.DEFINE ADDR_VRAM_BG2_Tilemap1	$5800
	.DEFINE ADDR_VRAM_BG2_Tilemap2	$5C00

	.DEFINE ADDR_VRAM_SPR_Tiles	$6000	; sprite tiles can go up to $7B5F, and also from $7C00-$7F5F

	.DEFINE ADDR_VRAM_BG1_Tilemap3	$7800	; only $7B60-$7BFF used for text box
	.DEFINE ADDR_VRAM_BG2_Tilemap3	$7C00	; only $7F60-$7FFF used for text box

	.DEFINE PARAM_RingMenuCenterX	128
	.DEFINE PARAM_RingMenuCenterY	172
	.DEFINE PARAM_RingMenuRadius	120

	.DEFINE PARAM_MODE7_SKY_LINES	72	; number of scanlines for sky above Mode 7 landscape

	.DEFINE PARAM_TextBox		$02C0	; tilemap entry for start of whole text box area
;	.DEFINE PARAM_TextBoxInside	$02E0	; tilemap entry for inside of text box
	.DEFINE PARAM_TextBox_Line1	$02E7	; tilemap entry for start of line 1 in text box
	.DEFINE PARAM_TextBox_Line2	$0307	; tilemap entry for start of line 2 in text box
	.DEFINE PARAM_TextBox_Line3	$0327	; tilemap entry for start of line 3 in text box
	.DEFINE PARAM_TextBox_Line4	$0347	; tilemap entry for start of line 4 in text box

	.DEFINE PARAM_TEXTBOX_UL	$02C6	; tilemap entry for upper left corner of text box
	.DEFINE PARAM_TEXTBOX_WIDTH	24	; in "full" (i.e., 16×8) hi-res tiles



; -------------------------- language constants
.ENUM $00
	TBL_Lang_Eng		db		; the order of the languages must match the order of dialog banks!
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
	.DEFINE CC_End			$FF	; end-of-string marker
;	.DEFINE CC_FONT_WHITE		0	; font color control codes = palette numbers (i.e., don't relocate these)
;	.DEFINE CC_FONT_RED		1
;	.DEFINE CC_FONT_GREEN		2
;	.DEFINE CC_FONT_YELLOW		3
	.DEFINE CC_BoxBlue		4	; from here on, CCs are relocatable
	.DEFINE CC_BoxRed		5
	.DEFINE CC_BoxPink		6
	.DEFINE CC_BoxEvil		7
	.DEFINE CC_BoxPissed		8
	.DEFINE CC_ClearTextBox		9
	.DEFINE CC_Indent		10
	.DEFINE CC_NewLine		11
	.DEFINE CC_Selection		12
	.DEFINE NO_CC			13	; this has to be greater than the last control code



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
	DP_VblankJump		dsb 4		; holds a 4-byte instruction like jml SomeVblankRoutine (NMI vector points here)
	DP_IRQJump		dsb 4		; holds a 4-byte instruction like jml SomeVblankRoutine (IRQ vector points here)

	strPtr			dw
	strBank			dsb 3

	DP_SubStrAddr		dsb 3		; holds a 24-bit sub string start address

	SprTextMon		dw		; keeps track of sprite-based text buffer filling level
	SprTextPalette		db		; holds palette to use when printing sprite-based text

	temp			dsb 8

	Cursor			dw

	Joy1			dw		; Current button state of joypad1, bit0=0 if it is a valid joypad
	Joy2			dw		; same thing for all pads...

	Joy1Press		dw		; Holds joypad1 keys that are pressed and have been
						; pressed since clearing this mem location
	Joy2Press		dw		; same thing for all pads...
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

	DP_Char1FrameCounter	db
	DP_Char1PosYX		dw		; high byte = Y position, low byte = X position
	DP_Char1SpriteStatus	db		; irrrrddd [i = not walking (idle), ddd = walking direction (0 = down, 1 = up, 2 = left, 3 = right)]
;	DP_Char1SpriteStatus	dw		; irrrrfffrrrrrddd [i = not walking (idle), fff = frame no., ddd = direction (0 = down, 1 = up, 2 = left)]
	DP_Char1WalkingSpd	dw

	DP_DMAUpdates		dw		; rrrrrrrrdcba4321 [1234 = BG no. that needs to have its lower tilemap updated on next Vblank, abcd = same thing for upper tilemaps, r = reserved]

	DP_EffectSpeed		db

	DP_HDMAchannels		db		; DCBAcbsr [ABCD = M7A/M7B/M7C/M7D, c = color math, b = background color gradient, s = screen mode, r = reserved]
						; Variable is transferred to $420C during Vblank

	DP_GameMode		db		; 7rrrrrrr [7 = Mode7 on/off, r = reserved]

	DP_GameTime_Seconds	db		; 1 game time second = 1 frame (??)
	DP_GameTime_Minutes	db
	DP_GameTime_Hours	db

	DP_RingMenuAngle	dw
	DP_RingMenuAngleOffset	dw

	DP_Mode7_Altitude	db
	DP_Mode7_AltTabOffset	dsb 3		; holds a 24-bit address
	DP_Mode7_RotAngle	dw		; currently needs to be 16-bit as it's used as an index in CalcMode7Matrix
	DP_Mode7_ScrollOffsetX	dw
	DP_Mode7_ScrollOffsetY	dw
	DP_Mode7_CenterCoordX	dw
	DP_Mode7_CenterCoordY	dw
	DP_Mode7_FrameCounter	db

	DP_MSU1present		db

	DP_Multi5_Reg0lo	db
	DP_Multi5_Reg0hi	db
	DP_Multi5_Reg1lo	db
	DP_Multi5_Reg1hi	db
	DP_Multi5_Status	db

	DP_Shadow_NMITIMEN	db		; shadow copy of REG_NMITIMEN
	DP_Shadow_TSTM		dw		; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D)

	DP_TextASCIIChar	dw		; holds current ASCII character no.
	DP_TextBoxCharPortrait	db		; nrrppppp [n = don't change character portrait, p = change portrait: 0 = no portrait (max. 31 portraits), r = reserved]
	DP_TextBoxSelection	db		; holds selection option chosen by player
	DP_TextBoxSelMax	db		; for HDMA selection bar
	DP_TextBoxSelMin	db		; ditto
	DP_TextBoxStatus	db		; cm4321ot [c = clear text box, m = there is more text to process, o = text box is open, r = reserved, 1-4 = text box contains selection on line no. 1-4, t = VWF buffer full, transfer to VRAM]
	DP_TextLanguage		db		; holds language constant
	DP_TextPointer		dw
	DP_TextPointerBank	db
	DP_TextPointerNo	dw
	DP_TextString		dw
	DP_TextStringBank	db
	DP_TextStringCounter	db		; holds current ASCII string position
	DP_TextTileDataCounter	dw		; holds current VRAM tile data address

	DP_CurrentScanline	dw		; holds no. of current scanline (for CPU load meter)

	DP_VWFBitsUsed		dw
	DP_VWFBufferIndex	dw
	DP_VWFLoop		db
.ENDE						; XXX of 256 bytes used



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
	Text			dsb 128		; for one line of text (32 chars)
.ENDST



.STRUCT sram
	Slot1			dsb 16		; 16 bytes per slot reserved
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
	TextBox			dsb 192		; 6 lines, 32 tiles each
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
	SpriteBuf1	INSTANCEOF oam_low	; 512 bytes
	SpriteBuf2	INSTANCEOF oam_high	; 32 bytes

	ARRAY_VWFTileBuffer		dsb 32
	ARRAY_VWFTileBuffer2		dsb 32
;	ARRAY_VWFTileBuffer3		dsb 64

	ARRAY_HDMA_ColorMath		dsb 96

	ARRAY_HDMA_M7A			dsb 448
	ARRAY_HDMA_M7B			dsb 448
	ARRAY_HDMA_M7C			dsb 448
	ARRAY_HDMA_M7D			dsb 448

;	ARRAY_HDMA_M7A2			dsb 448
;	ARRAY_HDMA_M7B2			dsb 448
;	ARRAY_HDMA_M7C2			dsb 448
;	ARRAY_HDMA_M7D2			dsb 448

	ARRAY_HDMA_MainEffects		dsb 224
	ARRAY_HDMA_BGScroll		dsb 16

	VAR_TextBox_TSTM		dw	; shadow copies of subscreen (high) & mainscreen (low) designation registers ($212C/212D) for text box area
.ENDE						; $XXX bytes + $XXX = $XXX bytes used (stack resides at $1FFF)



; ********************** Variables in upper WRAM ***********************

.ENUM $7E2000
	TileMapBG1	INSTANCEOF tilemap_bg1		; 1024 bytes
	TileMapBG1Hi	INSTANCEOF tilemap_bg1_hi	; 1024 bytes
	TileMapBG2	INSTANCEOF tilemap_bg2		; 1024 bytes
	TileMapBG2Hi	INSTANCEOF tilemap_bg2_hi	; 1024 bytes
	TileMapBG3	INSTANCEOF tilemap_bg3		; 1024 bytes
	TileMapBG3Hi	INSTANCEOF tilemap_bg3_hi	; 1024 bytes

	ARRAY_HDMA_BackgrPlayfield	dsb 704		; 16-bit palette index & 16-bit color entry for 176 scanlines
	ARRAY_HDMA_BackgrTextBox	dsb 192		; ditto for 48 scanlines
.ENDE



; *************************** SRAM variables ***************************

.ENUM $6000
	SRAM		INSTANCEOF sram
.ENDE						; max. 8192 bytes



; ******************************** EOF *********************************
