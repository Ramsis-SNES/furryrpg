;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** ROM SETTINGS AND LAYOUT ***
;
;==========================================================================================



; *************************** Debug switches ***************************

.DEFINE DEBUG								; boot into debug menu, show verbose on-screen messages
;.DEFINE NOMUSIC							; uncomment this to disable music
.DEFINE PrecalcMode7Tables						; if disabled, 112 304-byte-long tables (>33 KiB) are calculated during runtime (and stored in WRAM), which currently adds ~6 seconds of loading time to the Mode7 map screen



; ************************** Basic ROM layout **************************

.DEFINE CurrentBank	0
.DEFINE TotalROMBanks	19						; self-reminder: increase value when using more banks (crucial for ROM integrity check)
.DEFINE StartOffset	$F000						; start code offset in bank $00, this must be >= $8000 because of how ROM Mode 21 ("HiROM") is mapped



; **************************** Data aliases ****************************

.DEFINE SPC700_Drv	"music/spc700-driver-v1.4.bin"

.DEFINE Track00_SMP	"music/00-sun-wind-and-rain-spc700.bin"
.DEFINE Track01_SMP	"music/01-through-darkness-spc700.bin"
.DEFINE Track02_SMP	"music/02-theme-of-despair-spc700.bin"
.DEFINE Track03_SMP	"music/03-three-buskers-spc700.bin"
.DEFINE Track04_SMP	"music/04-and-one-buffoon-spc700.bin"
.DEFINE Track05_SMP	"music/05-troubled-mind-spc700.bin"
.DEFINE Track06_SMP	"music/06-fanfare1-spc700.bin"
.DEFINE Track07_SMP	"music/07-allons-ensemble-spc700.bin"
.DEFINE Track08_SMP	"music/08-caterwauling-spc700.bin"
.DEFINE Track09_SMP	"music/09-contemplate-spc700.bin"
.DEFINE Track10_SMP	"music/10-tembas-theme-spc700.bin"

.DEFINE Track00_Notes	"music/00-sun-wind-and-rain-music.bin"
.DEFINE Track01_Notes	"music/01-through-darkness-music.bin"
.DEFINE Track02_Notes	"music/02-theme-of-despair-music.bin"
.DEFINE Track03_Notes	"music/03-three-buskers-music.bin"
.DEFINE Track04_Notes	"music/04-and-one-buffoon-music.bin"
.DEFINE Track05_Notes	"music/05-troubled-mind-music.bin"
.DEFINE Track06_Notes	"music/06-fanfare1-music.bin"
.DEFINE Track07_Notes	"music/07-allons-ensemble-music.bin"
.DEFINE Track08_Notes	"music/08-caterwauling-music.bin"
.DEFINE Track09_Notes	"music/09-contemplate-music.bin"
.DEFINE Track10_Notes	"music/10-tembas-theme-music.bin"
.DEFINE Track11_Notes	"music/11-triumph-beta-music.bin"
.DEFINE Track12_Notes	"music/12-furlorn-village-music.bin"



; ********************** ROM makeup, SNES header ***********************

.BASE $C0
.EMPTYFILL		$FF

.MEMORYMAP
	DEFAULTSLOT	0
	SLOTSIZE	$10000
	SLOT 0		$0000
.ENDME

.ROMBANKMAP
	BANKSTOTAL	24
	BANKSIZE	$10000						; ROM banks are 64 KBytes in size
	BANKS		24						; 24 ROM banks = 12 Mbit
.ENDRO

.SNESHEADER								; this also calculates ROM checksum & complement
	ID		"SNES"
	NAME		"FURRY RPG!           "
	HIROM
	FASTROM
	CARTRIDGETYPE	$02
	ROMSIZE		$0B
	SRAMSIZE	$03
	COUNTRY		$01
	LICENSEECODE	$33
	VERSION		$00
.ENDSNES



.BANK CurrentBank SLOT 0
.ORG StartOffset + $FB0

	.DB "00"							; new licensee code



; *************************** Vector tables ****************************

.SNESNATIVEVECTOR
	COP		DummyCOP
	BRK		DummyBRK
	ABORT		EmptyHandler
	NMI		DP_VblankJump
	UNUSED		$0000
	IRQ		DP_IRQJump
.ENDNATIVEVECTOR



.SNESEMUVECTOR
	COP		EmptyHandler
	UNUSED		$0000
	ABORT		EmptyHandler
	NMI		EmptyHandler
	RESET		Startup
	IRQBRK		EmptyHandler
.ENDEMUVECTOR



; -------------------------- empty vectors
.BANK CurrentBank SLOT 0
.ORG StartOffset

.SECTION "Dummy/empty vectors" SEMIFREE

EmptyHandler:
	rti

DummyBRK:
	jml	ErrorHandlerBRK

DummyCOP:
	jml	ErrorHandlerCOP

.ENDS



.SECTION "Disclaimer" SEMIFREE

STR_DisclaimerWallofText:						; max. 20 lines, 46 chars per line
;	     12345678901234567890123456789012345678901234567890123456
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB "12345678901234567890123456789012345678901234567890123456", "        "
	.DB 0

.ENDS



; **************** Variables, macros, library routines *****************

.INCLUDE "lib_variables.asm"						; global variables
.INCLUDE "lib_macros.asm"						; macros



; ****************************** BANK $C0 ******************************

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "VersionStrings" FORCE

STR_Software_Title:
	.DB "FURRY RPG! (Working title)"

STR_SoftwareVersion:
	.DB " v"

STR_SoftwareVersionNo:
	.DB "0.0.1"
	.DB 0

STR_SoftwareMaker:
	.DB "Copyright (c) 201X by Ramsis - https://manuloewe.de/"
	.DB 0

STR_SoftwareBuild:
	.DB "Build #"

STR_SoftwareBuildNo:
	.DB "00287"
	.DB 0

STR_SoftwareBuildTimestamp:
	.DB "Assembled ", WLA_TIME
	.DB 0

;PTR_SoftwareVersion:
;	.DW STR_SoftwareVersion

;PTR_SoftwareBuild:
;	.DW STR_SoftwareBuild

CONST_Zeroes:
	.DW 0

CONST_FFs:
	.DW $FFFF



SRC_VblankJumpTable:
	jml	Vblank_Area
	jml	Vblank_DebugMenu
	jml	Vblank_Error
	jml	Vblank_Mode7
	jml	Vblank_WorldMap
	jml	Vblank_Intro



SRC_IRQJumpTable:
	jml	VIRQ_Area
	jml	VIRQ_Mode7

.ENDS



.SECTION "Main Code" SEMIFREE

.INCLUDE "furryrpg_area.inc.asm"					; area handler
.INCLUDE "furryrpg_boot.inc.asm"					; boot code
.INCLUDE "furryrpg_debug.inc.asm"					; debug menu
.INCLUDE "furryrpg_effects_transitions.inc.asm"				; screen transition effects
.INCLUDE "furryrpg_event.inc.asm"					; event handler
.INCLUDE "furryrpg_irqnmi.inc.asm"					; Vblank NMI & IRQ handlers with subroutines
.INCLUDE "furryrpg_mainmenu.inc.asm"					; in-game main menu
.INCLUDE "furryrpg_mode7.inc.asm"					; Mode 7 handler
.INCLUDE "furryrpg_music.inc.asm"					; music handler
.INCLUDE "furryrpg_sram.inc.asm"					; SRAM handler
.INCLUDE "furryrpg_text.inc.asm"					; text printing routines
.INCLUDE "furryrpg_worldmap.inc.asm"					; world map handler

.ENDS



.SECTION "data" SEMIFREE						; CHANGEME, move data/scripting files to other banks (requires acknowledgement of bank byte in area properties)

.INCLUDE "data/text_areanames_all.inc.asm"				; area names
.INCLUDE "data/tbl_areametamaps.inc.asm"				; area meta maps
.INCLUDE "scripts/event.inc.asm"					; event control scripting code

.ENDS



.SECTION "libs" SEMIFREE

.INCLUDE "lib_multi5.inc.asm"
.INCLUDE "lib_randomnrgen.inc.asm"
.INCLUDE "lib_snesgss.inc.asm"

.ENDS



.BANK CurrentBank SLOT 0
.ORG StartOffset + $FA0

.SECTION "Startup" FORCE

Startup:
	sei								; disable interrupts
	clc
	xce								; switch to native mode
	jml	Boot

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "CharacterData 1"

.INCLUDE "data/gfx.inc.asm"						; sprites, fonts, palettes
.INCLUDE "data/tbl_fontwidth.inc.asm"					; font width table for sprite VWF
.INCLUDE "data/tbl_areaproperties.inc.asm"				; area property tables & pointers

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "English dialog" FORCE

.INCLUDE "data/ptr_dialog_eng.inc.asm"					; pointers to English dialog
.INCLUDE "data/text_dialog_eng.inc.asm"					; English dialog

.ENDS

.ORG $8000

.SECTION "English misc. text" FORCE

.INCLUDE "data/text_items_eng.inc.asm"					; English item names
.INCLUDE "data/text_mainmenu_eng.inc.asm"				; English main menu strings
.INCLUDE "data/text_misc_eng.inc.asm"					; English misc. text

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "German dialog" FORCE

.INCLUDE "data/ptr_dialog_ger.inc.asm"					; pointers to German dialog
.INCLUDE "data/text_dialog_ger.inc.asm"					; German dialog

.ENDS

.ORG $8000

.SECTION "German misc. text" FORCE

.INCLUDE "data/text_items_ger.inc.asm"					; German item names
.INCLUDE "data/text_mainmenu_ger.inc.asm"				; German main menu strings
.INCLUDE "data/text_misc_ger.inc.asm"					; German misc. text

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Source tables"

.INCLUDE "data/tbl_hdma.inc.asm"					; HDMA tables
.INCLUDE "data/tbl_mode7.inc.asm"					; Mode 7 scaling/rotation tables

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Intro GFX"

SRC_RamsisPresentsMap:
.INCBIN "gfx/ramsis-presents-256.map"

SRC_RamsisPresentsPal:
.INCBIN "gfx/ramsis-presents-256.pal"

GFX_RamsisPresentsPic:
.INCBIN "gfx/ramsis-presents-256.pic"

SRC_RamsisMap:
.INCBIN "gfx/ramsis-256.map"

SRC_RamsisPal:
.INCBIN "gfx/ramsis-256.pal"

GFX_RamsisPic:
.INCBIN "gfx/ramsis-256.pic"

SRC_SoundEnginesPal:
.INCBIN "gfx/sound-engines-256.pal"

GFX_SoundEnginesPic:
.INCBIN "gfx/sound-engines-256.pic"

GFX_SoundEnginesPic_END:

.ENDS



; ****************************** NEW BANK ******************************

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

GFX_StartPic:
.INCBIN "gfx/start2-256.pic"

GFX_Area002:
.INCBIN "gfx/area-002-house.pic"

SRC_Palette_Area002:
.INCBIN "gfx/area-002-house.pal" READ 32

SRC_TileMapBG1_Area002:
.INCBIN "gfx/area-002-house.map"

GFX_Mode7_Sky:
.INCBIN "gfx/sky.pic"

SRC_Palette_Mode7_Sky:
.INCBIN "gfx/sky.pal" READ 32

SRC_TileMap_Mode7_Sky:
.INCBIN "gfx/sky.map"

MoreGFX_END:

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "World Map GFX data"

GFX_WorldMap:
;.INCBIN "thg.zst" SKIP $20C13 READ $8000
.INCBIN "gfx/thg.pic"

SRC_Palette_WorldMap:
;.INCBIN "thg.zst" SKIP $618 READ 512
.INCBIN "gfx/thg.pal"

SRC_Tilemap_WorldMap:
;.INCBIN "thg.zst" SKIP $28C13 READ $2000
.INCBIN "gfx/thg.map"

GFX_Sprites_SkyBlur:
.INCBIN "gfx/sky_blur.pic"

SRC_Palette_Sprites_SkyBlur:
.INCBIN "gfx/sky_blur.pal"						; 32 bytes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Mode 7 GFX 2"

SRC_IoTmappal:
.INCBIN "gfx/iot.pal" READ 512

GFX_IoTmappic:
.INCBIN "gfx/iot.bin"

GFX_IoTmappic_END:

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundDriver" SEMIFREE

SRC_spc700_driver:
.INCBIN SPC700_Drv

.ENDS

.SECTION ".roDataSoundCode12" SEMIFREE

SRC_track_10_pointers:
.INCBIN Track10_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_10_samples:
.INCBIN Track10_SMP SKIP 2342						; 2 + 2340

SRC_track_10_Notes:
.INCBIN Track10_Notes

SRC_track_11_Notes:
.INCBIN Track11_Notes

SRC_track_12_Notes:
.INCBIN Track12_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode02" SEMIFREE

SRC_track_00_pointers:
.INCBIN Track00_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_00_samples:
.INCBIN Track00_SMP SKIP 2342						; 2 + 2340

SRC_track_00_samples_END:

.ENDS



.SECTION ".roDataMusic02" SEMIFREE

SRC_track_00_Notes:
.INCBIN Track00_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode03" SEMIFREE

SRC_track_01_pointers:
.INCBIN Track01_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_01_samples:
.INCBIN Track01_SMP SKIP 2342						; 2 + 2340

SRC_track_01_samples_END:

.ENDS



.SECTION ".roDataMusic03" SEMIFREE

SRC_track_01_Notes:
.INCBIN Track01_Notes

.ENDS



.SECTION ".roDataSoundCode05" SEMIFREE

SRC_track_03_pointers:
.INCBIN Track03_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_03_samples:
.INCBIN Track03_SMP SKIP 2342						; 2 + 2340

SRC_track_03_samples_END:

.ENDS



.SECTION ".roDataMusic05" SEMIFREE

SRC_track_03_Notes:
.INCBIN Track03_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode04" SEMIFREE

SRC_track_02_pointers:
.INCBIN Track02_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_02_samples:
.INCBIN Track02_SMP SKIP 2342						; 2 + 2340

SRC_track_02_samples_END:

.ENDS



.SECTION ".roDataMusic04" SEMIFREE

SRC_track_02_Notes:
.INCBIN Track02_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode06" SEMIFREE

SRC_track_04_pointers:
.INCBIN Track04_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_04_samples:
.INCBIN Track04_SMP SKIP 2342						; 2 + 2340

SRC_track_04_samples_END:

.ENDS



.SECTION ".roDataMusic06" SEMIFREE

SRC_track_04_Notes:
.INCBIN Track04_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode07" SEMIFREE

SRC_track_05_pointers:
.INCBIN Track05_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_05_samples:
.INCBIN Track05_SMP SKIP 2342						; 2 + 2340

SRC_track_05_samples_END:

.ENDS



.SECTION ".roDataMusic07" SEMIFREE

SRC_track_05_Notes:
.INCBIN Track05_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode08" SEMIFREE

SRC_track_06_pointers:
.INCBIN Track06_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_06_samples:
.INCBIN Track06_SMP SKIP 2342						; 2 + 2340

SRC_track_06_samples_END:

.ENDS



.SECTION ".roDataMusic08" SEMIFREE

SRC_track_06_Notes:
.INCBIN Track06_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode09" SEMIFREE

SRC_track_07_pointers:
.INCBIN Track07_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_07_samples:
.INCBIN Track07_SMP SKIP 2342						; 2 + 2340

SRC_track_07_samples_END:

.ENDS



.SECTION ".roDataMusic09" SEMIFREE

SRC_track_07_Notes:
.INCBIN Track07_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode10" SEMIFREE

SRC_track_08_pointers:
.INCBIN Track08_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_08_samples:
.INCBIN Track08_SMP SKIP 2342						; 2 + 2340

SRC_track_08_samples_END:

.ENDS



.SECTION ".roDataMusic10" SEMIFREE

SRC_track_08_Notes:
.INCBIN Track08_Notes

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode11" SEMIFREE

SRC_track_09_pointers:
.INCBIN Track09_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_09_samples:
.INCBIN Track09_SMP SKIP 2342						; 2 + 2340

SRC_track_09_samples_END:

.ENDS



.SECTION ".roDataMusic11" SEMIFREE

SRC_track_09_Notes:
.INCBIN Track09_Notes

.ENDS



; ******************************** EOF *********************************
