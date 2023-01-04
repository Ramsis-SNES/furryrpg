;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** ROM SETTINGS AND LAYOUT ***
;
;==========================================================================================



; ******************************* Notes ********************************

; To be assembled with WLA DX v10.4, available at
; https://github.com/vhelin/wla-dx



; ******************** Global defines and includes *********************

.DEFINE DEBUG								; boot to debug menu, show verbose on-screen messages
;.DEFINE NOMUSIC							; uncomment this to disable music
.DEFINE PrecalcMode7Tables						; if not .DEFINED, 112 304-byte-long tables (>33 KiB) are calculated during runtime (and stored in WRAM), which currently adds ~6 seconds of loading time to the Mode7 map screen
;.DEFINE UseCustomGSSDriver						; use a custom build of the SNESGSS sound driver (with stereo enabled by default) // incomplete/broken!
.DEFINE WorkAroundINIDISP						; jump through some hoops to work around the various INIDISP glitches discovered in 2021

.DEFINE StartOffset	$FFA0						; start code offset in bank $40, this must be >= $8000 because of how ROM Mode 21/25 ("Ex/HiROM") is mapped

.INCLUDE "lib_variables.asm"						; global variables
.INCLUDE "lib_macros.asm"						; macros

.STRINGMAPTABLE ctrl	"data/tbl_dialogue_ctrl.tbl"
.STRINGMAPTABLE diag	"data/tbl_dialogue_char.tbl"
.STRINGMAPTABLE HUD	"data/tbl_hud_char.tbl"



; ********************** ROM makeup, SNES header ***********************

.EMPTYFILL		$FF

.MEMORYMAP
	DEFAULTSLOT	0
	SLOTSIZE	$10000
	SLOT 0		$0000
.ENDME

.ROMBANKSIZE		$10000						; ROM banks are 64 KiB in size
.ROMBANKS		96						; 96 ROM banks = 48 Mbit

.SNESHEADER								; this auto-calculates ROM checksum & complement, too
;	ID		"A00E"						; should be AxxE, where xx can be [0-9A-Z]. Last letter is then interpreted by bsnes as the country code (E = USA)
	ID		"SNS!"						; if there are any characters other than [0-9A-Z] in the ID, then bsnes resorts to the country byte at $(40)FFD9 instead
	NAME		"FURRY RPG!           "				; 21 characters
	EXHIROM								; aka Mode 25
	FASTROM
	CARTRIDGETYPE	$55						; ROM, RTC + battery-backed SRAM
	ROMSIZE		$0D						; 1 SHL n = 8 MiB (reported as a power of 2, even though actual ROM size is 6 MiB for now)
	SRAMSIZE	$03						; 8 KiB for now
	COUNTRY		$01						; USA
	LICENSEECODE	$33						; $33 = indicator for newer/extended cartridge header
	VERSION		$00
.ENDSNES

.SNESNATIVEVECTOR
	COP		DummyCOP					; in bank $40
	BRK		DummyBRK					; in bank $40
	ABORT		EmptyHandler					; in bank $40
	NMI		P00.JmpVblank					; in bank $00
	UNUSED		$0000
	IRQ		P00.JmpIRQ					; in bank $00
.ENDNATIVEVECTOR

.SNESEMUVECTOR
	COP		EmptyHandler
	UNUSED		$0000
	ABORT		EmptyHandler
	NMI		EmptyHandler
	RESET		Startup
	IRQBRK		EmptyHandler
.ENDEMUVECTOR



; ****************************** BANK $C0 ******************************

.BASE $C0								; add $C0 to all regular HiROM banks

.DEFINE CurrentBank	0						; start in bank 0

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Version and build" FORCE

	STR_Software_Title:
		.DB "FURRY RPG! (Working title)"

	STR_SoftwareVersion:
		.DB " v"

	STR_SoftwareVersionNo:
		.DB "0.0.1"
		.DB 0

	STR_SoftwareMaker:
		.DB "Copyright (c) 2023 by Ramsis - https://manuloewe.de/"
		.DB 0

	STR_SoftwareBuild:
		.DB "Build #"

	STR_SoftwareBuildNo:
		.DB "00520"
		.DB 0

	STR_SoftwareBuildTimestamp:
		.DB "Assembled ", WLA_TIME
		.DB 0

;	PTR_SoftwareVersion:
;		.DW STR_SoftwareVersion

;	PTR_SoftwareBuild:
;		.DW STR_SoftwareBuild

	SRC_Zeroes:
		.DW 0

	SRC_FFs:
		.DW $FFFF

.ENDS



.SECTION "Disclaimer" FORCE

	STR_DisclaimerWallofText:					; max. 20 lines, 56 + 8 chars per line
		.DB "This game is not licensed, sponsored or endorsed by     ", "        "
		.DB "Nintendo Co., Ltd.                                      ", "        "
		.DB "                                                        ", "        "
		.DB "Story, dialogue, music, programming:                      ", "        "
		.DB "Ramsis aka ManuLoewe                                    ", "        "
		.DB "                                                        ", "        "
		.DB "Proudly made with the WLA DX cross assembler.           ", "        "
		.DB "                                                        ", "        "
		.DB "All characters in this game are ficticious. Any         ", "        "
		.DB "similarities to any person, living or dead, furred      ", "        "
		.DB "or non-furred, are purely coincidental.                 ", "        "
		.DB "                                                        ", "        "
		.DB "Thank Yous (in no particular order):                    ", "        "
		.DB "...                                                     ", "        "
		.DB "...                                                     ", "        "
		.DB "...                                                     ", "        "
		.DB "                                                        ", "        "
		.DB "                                                        ", "        "
		.DB "                                                        ", "        "
		.DB "                                                        ", "        "
		.DB 0

.ENDS



.SECTION "NMI/IRQ jump tables" FORCE

	SRC_VblankJumpTable:						; order has to match Vblank routine table in lib_variables.asm
		jml	Vblank_Area
		jml	Vblank_DebugMenu
;		jml	Vblank_Error
		jml	Vblank_Intro
		jml	Vblank_Minimal
		jml	Vblank_Mode7
		jml	Vblank_WorldMap



	SRC_IRQJumpTable:						; order has to match IRQ routine table in lib_variables.asm
		jml	HIRQ_MenuItemsVsplit
		jml	VIRQ_Area
		jml	VIRQ_Mode7

.ENDS



.SECTION "Test code 1" SEMIFREE

	UnusedCode:							; currently assembled to $(C0)05A0
		rts

;		lda	SRAM.Slot1.Hero1HP				; lda $B06040
;		lda	SRAM.Slot1.Hero1HPLo				; lda $B06040
		lda.w	#kGSS_NONE					; lda #$0000

.ENDS



.SECTION "Main code" SEMIFREE

	.INCLUDE "furryrpg_area.inc.asm"				; area handler
	.INCLUDE "furryrpg_boot.inc.asm"				; boot code
	.INCLUDE "furryrpg_debug.inc.asm"				; debug menu
	.INCLUDE "furryrpg_effects.inc.asm"				; on-screen effects
	.INCLUDE "furryrpg_event.inc.asm"				; event handler
	.INCLUDE "furryrpg_irqnmi.inc.asm"				; Vblank NMI & IRQ handlers with subroutines
	.INCLUDE "furryrpg_mainmenu.inc.asm"				; in-game main menu
	.INCLUDE "furryrpg_mode7.inc.asm"				; Mode 7 handler
	.INCLUDE "furryrpg_music.inc.asm"				; music handler
	.INCLUDE "furryrpg_sram.inc.asm"				; SRAM handler
	.INCLUDE "furryrpg_text.inc.asm"				; text printing routines
	.INCLUDE "furryrpg_worldmap.inc.asm"				; world map handler

.ENDS



.SECTION "Data" SEMIFREE						; CHANGEME, move data/scripting files to other banks (requires acknowledgement of bank byte in area properties)

	.INCLUDE "data/text_areanames_all.inc.asm"			; area names
	.INCLUDE "data/text_chapters_all.inc.asm"			; chapter names
	.INCLUDE "data/text_errorcodes.inc.asm"				; error code names
	.INCLUDE "data/text_GSS_tracknames.inc.asm"			; SNESGSS track names
	.INCLUDE "data/bin_areadata.inc.asm"				; area properties/objects tables, area meta maps
	.INCLUDE "scripts/event.inc.asm"				; event control scripting code

.ENDS



.SECTION "Libraries" SEMIFREE

	.INCLUDE "lib_multi5.inc.asm"
	.INCLUDE "lib_randomnrgen.inc.asm"
	.INCLUDE "lib_spc700.inc.asm"

.ENDS



.ORG StartOffset

.SECTION "Dummy boot code" FORCE

	.DB "BOOTCODEINBANK40"						; just so we won't forget ;-)

.ENDS



;.ORG $FFB0								; seems unnecessary (mirrored from bank $40 anyway)

;.SECTION "Maker code" FORCE

;	.DB "00"							; new licensee code (unlicensed)

;.ENDS



; $FFB2 Extended Header Game Code (automatically filled in by WLA DX)



;.ORG $FFB6								; seems unnecessary (mirrored from bank $40 anyway)

;.SECTION "Extended header 2" FORCE

;	.REPEAT 10
;		.DB $00							; reserved/expansion size/special version header bytes (should be zero in a normal game)
;	.ENDR

;.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Character data 1"

; Palettes

	SRC_Palettes_Text:
		.DW $0000						; background (transparent)
		.DW $0C63						; font drop shadow (dark grey)
		.DW $5EF7 ;3DEF						; font color #2 (light grey, only used by 8x8 font)
		.DW $7FFF						; font (white)

		.DW $0000						; background (transparent)
		.DW $0C63						; font drop shadow (dark grey)
		.DW $0000						; unused color
		.DW $2C1F						; font (red)

		.DW $0000						; background (transparent)
		.DW $0C63						; font drop shadow (dark grey)
		.DW $0000						; unused color
		.DW $03E0						; font (green)

		.DW $0000						; background (transparent)
		.DW $0C63						; font drop shadow (dark grey)
		.DW $0000						; unused color
		.DW $03FF						; font (yellow)

	SRC_Palettes_HUD:						; 16-color palette for HUD content
		.INCBIN "gfx/font_hud_vwf.pal" READ 32

	SRC_Palette_Portrait_Hero1:
		.INCBIN "gfx/portrait_gengen.pal"			; 32 bytes

	SRC_Palette_Portrait_Hero2:
		.INCBIN "gfx/portrait_kimahri.pal"			; 32 bytes

	SRC_Palette_Spritesheet_Hero1:
		.INCBIN "gfx/Gengen2.pal"				; 32 bytes

	SRC_Palette_Sprites_InGameMenu:
		.INCBIN "gfx/menu-sprites.pal"				; 32 bytes

; Font character data

	SRC_FontMode5:
		.INCBIN "gfx/font_mode5_vwf_nor.pic"			; 2bpp font for BG2 (4096 bytes)

	SRC_Font8x8:
		.INCBIN "gfx/font_8x8.pic"				; 2bpp font for BG3 (2048 bytes)

; Character portraits

	SRC_Portrait_Hero1:
		.INCBIN "gfx/portrait_gengen.pic" READ 1920

	SRC_Portrait_Hero2:
		.INCBIN "gfx/portrait_kimahri.pic" READ 1920

; Sprite character data

	SRC_Sprites_HUDfont:
		.INCBIN "gfx/font_hud_vwf.pic"				; 4096 bytes

	SRC_Spritesheet_Hero1:
		.INCBIN "gfx/Gengen2.pic"

	SRC_Sprites_InGameMenu:
		.INCBIN "gfx/menu-sprites.pic"

	SRC_Sprites_Clouds:
		.INCBIN "gfx/cloud1.pic"

	SRC_Palette_Clouds:
		.INCBIN "gfx/cloud1.pal"

;	SRC_Tilemap_Clouds:
;		.INCBIN "gfx/cloud.map"

; Logo data

	SRC_Logo:
		.INCBIN "gfx/logo-gr.pic"				; XXX bytes

	SRC_Palette_Logo:
		.INCBIN "gfx/logo-gr.pal"				; 512 bytes

	SRC_Tilemap_Logo:
;		.INCBIN "gfx/logo-gr.map"				; 2048 bytes

		.FOPEN "gfx/logo-gr.map" logo_gr			; "deinterleave" gfx2snes tilemaps 
			.FSEEK logo_gr 0 START
			.REPEAT 1024
				.FREAD logo_gr TilemapLoByte		; copy even (low) bytes of tilemap
				.DB TilemapLoByte
				.FREAD logo_gr TilemapHiByte		; read & discard odd (high) bytes of tilemap
			.ENDR
			.UNDEFINE TilemapLoByte
			.UNDEFINE TilemapHiByte
		.FCLOSE logo_gr

/*	SRC_Tilemap_LogoHi:
		.FOPEN "gfx/logo-gr.map" logo_gr			; "deinterleave" gfx2snes tilemaps
			.FSEEK logo_gr 0 START
			.REPEAT 1024
				.FREAD logo_gr TilemapLoByte		; read & discard even (low) bytes of tilemap
				.FREAD logo_gr TilemapHiByte		; copy odd (high) bytes of tilemap
				.DB TilemapHiByte
			.ENDR
			.UNDEFINE TilemapLoByte
			.UNDEFINE TilemapHiByte
		.FCLOSE logo_gr
*/

; Area data

	SRC_TilesBG1_Area000:
		.INCBIN "gfx/area-000-chessbd.pic"

	SRC_Palette_Area000:
		.INCBIN "gfx/area-000-chessbd.pal"

	SRC_TileMapBG1_Area000:
		.INCBIN "gfx/area-000-chessbd.map"

	SRC_TilesBG1_Area001:
		.INCBIN "gfx/area-001-sandbox2.pic"

	SRC_Palette_Area001:
		.INCBIN "gfx/area-001-sandbox2.pal"

	SRC_TileMapBG1_Area001:
		.INCBIN "gfx/area-001-sandbox2.map"

	SRC_TilesBG1_Area002:
		.INCBIN "gfx/area-002-green.pic"

	SRC_Palette_Area002:
		.INCBIN "gfx/area-002-green.pal" READ 32

	SRC_TileMapBG1_Area002:
		.INCBIN "gfx/area-002-green.map"

/*		.FOPEN "gfx/area-002-green.map" area_002_green		; "deinterleave" gfx2snes tilemaps
			.FSEEK area_002_green 0 START
			.REPEAT 1024
				.FREAD area_002_green TilemapLoByte	; copy even (low) bytes of tilemap
				.DB TilemapLoByte
				.FREAD area_002_green TilemapHiByte	; read & discard odd (high) bytes of tilemap
			.ENDR
;			.UNDEFINE TilemapLoByte
;			.UNDEFINE TilemapHiByte
;		.FCLOSE area_002_green

;		.FOPEN "gfx/area-002-green.map" area_002_green		; "deinterleave" gfx2snes tilemaps
			.FSEEK area_002_green 0 START
			.REPEAT 1024
				.FREAD area_002_green TilemapLoByte	; read & discard even (low) bytes of tilemap
				.FREAD area_002_green TilemapHiByte	; copy odd (high) bytes of tilemap
				.DB TilemapHiByte
			.ENDR
			.UNDEFINE TilemapLoByte
			.UNDEFINE TilemapHiByte
		.FCLOSE area_002_green
*/

; GFX pointer tables

	PTR_CharPortraitGFX:
		.DW 0							; dummy pointer (needed for correct table index)
		.DW SRC_Portrait_Hero1
		.DW SRC_Portrait_Hero2

	PTR_CharPortraitPalette:
		.DW 0							; ditto
		.DW SRC_Palette_Portrait_Hero1
		.DW SRC_Palette_Portrait_Hero2

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Character data 2"

	SRC_FontMode5Bold:
		.INCBIN "gfx/font_mode5_vwf_fat.pic"			; 8 KiB
		.INCLUDE "data/bin_fontwidthtables.inc.asm"		; font width tables

	SRC_StaticItemsEng:
		.INCBIN "gfx/static_items_eng.pic"			; English item names (2bpp gfx, 40,960 bytes)

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "English dialogue" FORCE

	.INCLUDE "data/ptr_dialogue_eng.inc.asm"			; pointers to English dialogue
	.INCLUDE "data/text_dialogue_eng.inc.asm"			; English dialogue

.ENDS

.ORG $8000

.SECTION "English misc. text" FORCE

	.INCLUDE "data/text_items_eng.inc.asm"				; English item names
	.INCLUDE "data/text_mainmenu_eng.inc.asm"			; English main menu strings
	.INCLUDE "data/text_misc_eng.inc.asm"				; English misc. text

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "German dialogue" FORCE

	.INCLUDE "data/ptr_dialogue_ger.inc.asm"			; pointers to German dialogue
	.INCLUDE "data/text_dialogue_ger.inc.asm"			; German dialogue

.ENDS

.ORG $8000

.SECTION "German misc. text" FORCE

	.INCLUDE "data/text_items_ger.inc.asm"				; German item names
	.INCLUDE "data/text_mainmenu_ger.inc.asm"			; German main menu strings
	.INCLUDE "data/text_misc_ger.inc.asm"				; German misc. text

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "HDMA tables"

	.INCLUDE "data/bin_hdmatables.inc.asm"				; HDMA tables

.ENDS

.SECTION "Random number byte tables"

; The following assembler directives create tables containing random numbers.

	SRC_RND_0009:
		.DBRND COUNT 64 MIN 0 MAX 9				; 64 random bytes (0-9)

	SRC_RND_1019:
		.DBRND COUNT 64 MIN 10 MAX 19				; 64 random bytes (10-19)

	SRC_RND_2029:
		.DBRND COUNT 64 MIN 20 MAX 29				; 64 random bytes (20-29)

	SRC_RND_3039:
		.DBRND COUNT 64 MIN 30 MAX 39				; 64 random bytes (30-39)

	SRC_RND_4049:
		.DBRND COUNT 64 MIN 40 MAX 49				; 64 random bytes (40-49)

	SRC_RND_5059:
		.DBRND COUNT 64 MIN 50 MAX 59				; 64 random bytes (50-59)

	SRC_RND_6069:
		.DBRND COUNT 64 MIN 60 MAX 69				; 64 random bytes (60-69)

	SRC_RND_7079:
		.DBRND COUNT 64 MIN 70 MAX 79				; 64 random bytes (70-79)

	SRC_RND_8089:
		.DBRND COUNT 64 MIN 80 MAX 89				; 64 random bytes (80-89)

	SRC_RND_9099:
		.DBRND COUNT 64 MIN 90 MAX 99				; 64 random bytes (90-99)

	SRC_RND_Hex:
		.DBRND COUNT 256 MIN 0 MAX 255				; 256 random bytes (0-255)

.ENDS

.SECTION "Sine, cosine, and Mode 7 scaling tables"

; The following assembler directives create 256-byte-long sine/cosine
; tables that are very similar (close enough) to the old ones made with
; an ancient tool named RollerCoaster.

	SRC_SineTable:							; 256-byte-long sine table
		.DBSIN 0, 255, 1.40625, 127, 0

	SRC_CosineTable:						; 256-byte-long cosine table
		.DBCOS 0, 255, 1.40625, 127, 0

;		       |  |    |        |    |
;		       |  |    |        |    ----------- 0 = some sort of offset added to bytes generated (?)
;		       |  |    |        |
;		       |  |    |        ---------------- 127 = IDK, some sort of range like in the older tool, perhaps?
;		       |  |    |
;		       |  |    ------------------------- 1.40625 = "adder value" of 360 (degrees) divided by 256 (angle representations)
;		       |  |
;		       |  ------------------------------ 255 = no. of additional angles
;		       |
;		       --------------------------------- 0 = starting angle

/* Old tables (generated with RollerCoaster) for reference

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
	.DB -27, -24, -21, -18, -15, -12, -8, -5			; sin end
	.DB  0,  3,  6,  9,  12,  16,  19,  22				; cos cont.
	.DB  25,  28,  31,  34,  37,  40,  43,  46
	.DB  48,  51,  54,  57,  60,  62,  65,  68
	.DB  70,  73,  75,  78,  80,  83,  85,  87
	.DB  90,  92,  94,  96,  98,  100,  102,  104
	.DB  105,  107,  109,  110,  112,  113,  115,  116
	.DB  117,  118,  119,  120,  121,  122,  123,  124
	.DB  124,  125,  126,  126,  126,  127,  127,  127
*/

	.IFDEF PrecalcMode7Tables
		SRC_Mode7Scaling:
			.INCBIN "data/mode7_scalingtables.bin"
	.ENDIF

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Intro GFX"

	SRC_RamsisPresentsMap:
		.INCBIN "gfx/ramsis-presents-256.map"

	SRC_RamsisPresentsPal:
		.INCBIN "gfx/ramsis-presents-256.pal"

	SRC_RamsisPresentsPic:
		.INCBIN "gfx/ramsis-presents-256.pic"

	SRC_RamsisMap:
		.INCBIN "gfx/ramsis-256.map"

	SRC_RamsisPal:
		.INCBIN "gfx/ramsis-256.pal"

	SRC_RamsisPic:
		.INCBIN "gfx/ramsis-256.pic"

	SRC_SoundEnginesPal:
		.INCBIN "gfx/sound-engines-256.pal"

	SRC_SoundEnginesPic:
		.INCBIN "gfx/sound-engines-256.pic"

	__SoundEnginesPic_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "More GFX data"

	SRC_SoundEnginesMap:
		.INCBIN "gfx/sound-engines-256.map"

	SRC_StartMap:
		.INCBIN "gfx/start2-256.map"

	SRC_StartPal:
		.INCBIN "gfx/start2-256.pal"

	SRC_StartPic:
		.INCBIN "gfx/start2-256.pic"

	__start2_END:

.ENDS

.SECTION "World map GFX data"

	SRC_WorldMap:
;		.INCBIN "thg.zst" SKIP $20C13 READ $8000
		.INCBIN "gfx/thg.pic"

	SRC_Palette_WorldMap:
;		.INCBIN "thg.zst" SKIP $618 READ 512
		.INCBIN "gfx/thg.pal"

	SRC_Tilemap_WorldMap:
;		.INCBIN "thg.zst" SKIP $28C13 READ $2000
		.INCBIN "gfx/thg.map"

	SRC_Sprites_SkyBlur:
		.INCBIN "gfx/sky_blur.pic"

	SRC_Palette_Sprites_SkyBlur:
		.INCBIN "gfx/sky_blur.pal"				; 32 bytes

	__sky_blur_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Mode 7 GFX"

	SRC_IoTmappal:
		.INCBIN "gfx/iot.pal" READ 512

	SRC_IoTmappic:
		.INCBIN "gfx/iot.bin"

	__IoTmap_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS sound driver" SEMIFREE

	.IFNDEF UseCustomGSSDriver
		SRC_SPC700_driver:
			.INCBIN "music/spc700-driver-v1.4.bin" SKIP 2	; skip size bytes, include bare driver (see music/SNESGSS file format notes.txt), this is uploaded to the SPC700 at boot time

		__SPC700_driver_END:

	.ELSE
		SRC_SPC700_driver:
			.INCBIN "music/spc700-driver-custom.bin" SKIP 2	; ditto for customized sound driver
;			.INCBIN "music/spc700-driver-test.bin" SKIP 2	; ditto for customized sound driver (test = bigger custom driver with new commands)

		__SPC700_driver_END:

	.ENDIF

.ENDS

.SECTION "GSS music tracks 10-12" SEMIFREE

	SRC_track_10_pointers:
		.INCBIN "music/10-tembas-theme-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_10_samples:
		.INCBIN "music/10-tembas-theme-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_10_Notes:
		.INCBIN "music/10-tembas-theme-music.bin" SKIP 2	; skip size bytes

	SRC_track_11_Notes:
		.INCBIN "music/11-triumph-beta-music.bin" SKIP 2	; skip size bytes

	SRC_track_12_Notes:
		.INCBIN "music/12-furlorn-village-music.bin" SKIP 2	; skip size bytes

	__track_12_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 00" SEMIFREE

;	.IFNDEF UseCustomGSSDriver
		SRC_track_00_pointers:
			.INCBIN "music/00-sun-wind-and-rain-spc700.bin" SKIP 10 READ 6	; 2 + 8

		SRC_track_00_samples:
			.INCBIN "music/00-sun-wind-and-rain-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

		SRC_track_00_Notes:
			.INCBIN "music/00-sun-wind-and-rain-music.bin" SKIP 2	; skip size bytes

		__track_00_END:

;	.ELSE
;		SRC_track_00_pointers:	; test files for bigger custom driver
;			.INCBIN "music/00-test-spc700.bin" SKIP 10 READ 6	; 2 + 8

;		SRC_track_00_samples:
;			.INCBIN "music/00-test-spc700.bin" SKIP 2598	; skip driver code & size bytes

;		SRC_track_00_Notes:
;			.INCBIN "music/00-test-music.bin" SKIP 2	; skip size bytes

;		__track_00_END:

;	.ENDIF

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 01" SEMIFREE

	SRC_track_01_pointers:
		.INCBIN "music/01-through-darkness-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_01_samples:
		.INCBIN "music/01-through-darkness-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_01_Notes:
		.INCBIN "music/01-through-darkness-music.bin" SKIP 2	; skip size bytes

	__track_01_END:

.ENDS

.SECTION "GSS music track 03" SEMIFREE

	SRC_track_03_pointers:
		.INCBIN "music/03-three-buskers-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_03_samples:
		.INCBIN "music/03-three-buskers-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_03_Notes:
		.INCBIN "music/03-three-buskers-music.bin" SKIP 2	; skip size bytes

	__track_03_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 02" SEMIFREE

	SRC_track_02_pointers:
		.INCBIN "music/02-theme-of-despair-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_02_samples:
		.INCBIN "music/02-theme-of-despair-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_02_Notes:
		.INCBIN "music/02-theme-of-despair-music.bin" SKIP 2	; skip size bytes

	__track_02_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 04" SEMIFREE

	SRC_track_04_pointers:
		.INCBIN "music/04-and-one-buffoon-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_04_samples:
		.INCBIN "music/04-and-one-buffoon-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_04_Notes:
		.INCBIN "music/04-and-one-buffoon-music.bin" SKIP 2	; skip size bytes

	__track_04_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 05" SEMIFREE

	SRC_track_05_pointers:
		.INCBIN "music/05-troubled-mind-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_05_samples:
		.INCBIN "music/05-troubled-mind-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_05_Notes:
		.INCBIN "music/05-troubled-mind-music.bin" SKIP 2	; skip size bytes

	__track_05_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 06" SEMIFREE

	SRC_track_06_pointers:
		.INCBIN "music/06-fanfare1-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_06_samples:
		.INCBIN "music/06-fanfare1-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_06_Notes:
		.INCBIN "music/06-fanfare1-music.bin" SKIP 2		; skip size bytes

	__track_06_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 07" SEMIFREE

	SRC_track_07_pointers:
		.INCBIN "music/07-allons-ensemble-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_07_samples:
		.INCBIN "music/07-allons-ensemble-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_07_Notes:
		.INCBIN "music/07-allons-ensemble-music.bin" SKIP 2	; skip size bytes

	__track_07_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 08" SEMIFREE

	SRC_track_08_pointers:
		.INCBIN "music/08-caterwauling-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_08_samples:
		.INCBIN "music/08-caterwauling-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_08_Notes:
		.INCBIN "music/08-caterwauling-music.bin" SKIP 2	; skip size bytes

	__track_08_END:

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $C0								; reminder: HiROM bank

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "GSS music track 09" SEMIFREE

	SRC_track_09_pointers:
		.INCBIN "music/09-contemplate-spc700.bin" SKIP 10 READ 6	; 2 + 8

	SRC_track_09_samples:
		.INCBIN "music/09-contemplate-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

	SRC_track_09_Notes:
		.INCBIN "music/09-contemplate-music.bin" SKIP 2		; skip size bytes

	__track_09_END:

.ENDS



; ****************************** Bank $40 ******************************

.BASE $00								; banks $40-$5F are ExHiROM banks, .BASE needs to be zero

.REDEFINE CurrentBank	$40

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Test code 2" FORCE

	PrintTest:
		PrintString	2, 2, kTextBG3, "Print test bank $40"	; tested working

		rtl

.ENDS



.ORG StartOffset

.SECTION "ExHiROM boot code & dummy vectors" FORCE

	Startup:
		sei							; disable interrupts
		clc
		xce							; switch to 65816 native mode
		jml	Boot

	EmptyHandler:
		rti

	DummyBRK:
		jml	ErrorHandlerBRK

	DummyCOP:
		jml	ErrorHandlerCOP

.ENDS



.ORG $FFB0

.SECTION "Extended header 1 maker code" FORCE

	.DB "00"							; new licensee code (unlicensed)

.ENDS



; $FFB2 Extended Header Game Code (automatically filled in by WLA DX)



.ORG $FFB6

.SECTION "Extended header 2" FORCE

	.REPEAT 10
		.DB $00							; reserved/expansion size/special version header bytes (should be zero in a normal game)
	.ENDR

.ENDS



; ****************************** NEW BANK ******************************

;.BASE $00								; reminder: ExHiROM bank

;.REDEFINE CurrentBank	CurrentBank+1

;.BANK CurrentBank SLOT 0
;.ORG 0

;.SECTION ""
;.ENDS



; ************************** .RAMSECTION test **************************

; Why are .RAMSECTIONs constrained to use MEMORYMAP's SLOT definitions?!

;.RAMSECTION "testvars 1" BANK $7E SLOT 0
;	moomin1		DW
;	phantom		DB
;	nyanko		DB
;	enemy		DB
;.ENDS



; ******************************** EOF *********************************
