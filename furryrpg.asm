;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** ROM LAYOUT ***
;
;==========================================================================================



; ****************************** Defines *******************************

.DEFINE DEBUG
;.DEFINE NOMUSIC							; activate this to disable music
.DEFINE CurrentBank	0
.DEFINE TotalROMBanks	20						; self-reminder: increase value when using more banks (crucial for ROM integrity check)
.DEFINE START_OFFSET	$F000						; start code offset in bank $C0

.DEFINE SPC700_DRV	".\\music\\spc700-driver-v1.4.bin"

.DEFINE TRACK00_SMP	".\\music\\00-sun-wind-and-rain-spc700.bin"
.DEFINE TRACK01_SMP	".\\music\\01-through-darkness-spc700.bin"
.DEFINE TRACK02_SMP	".\\music\\02-theme-of-despair-spc700.bin"
.DEFINE TRACK03_SMP	".\\music\\03-three-buskers-spc700.bin"
.DEFINE TRACK04_SMP	".\\music\\04-and-one-buffoon-spc700.bin"
.DEFINE TRACK05_SMP	".\\music\\05-troubled-mind-spc700.bin"
.DEFINE TRACK06_SMP	".\\music\\06-fanfare1-spc700.bin"
.DEFINE TRACK07_SMP	".\\music\\07-allons-ensemble-spc700.bin"
.DEFINE TRACK08_SMP	".\\music\\08-caterwauling-spc700.bin"
.DEFINE TRACK09_SMP	".\\music\\09-contemplate-spc700.bin"
.DEFINE TRACK10_SMP	".\\music\\10-tembas-theme-spc700.bin"

.DEFINE TRACK00_NOTES	".\\music\\00-sun-wind-and-rain-music.bin"
.DEFINE TRACK01_NOTES	".\\music\\01-through-darkness-music.bin"
.DEFINE TRACK02_NOTES	".\\music\\02-theme-of-despair-music.bin"
.DEFINE TRACK03_NOTES	".\\music\\03-three-buskers-music.bin"
.DEFINE TRACK04_NOTES	".\\music\\04-and-one-buffoon-music.bin"
.DEFINE TRACK05_NOTES	".\\music\\05-troubled-mind-music.bin"
.DEFINE TRACK06_NOTES	".\\music\\06-fanfare1-music.bin"
.DEFINE TRACK07_NOTES	".\\music\\07-allons-ensemble-music.bin"
.DEFINE TRACK08_NOTES	".\\music\\08-caterwauling-music.bin"
.DEFINE TRACK09_NOTES	".\\music\\09-contemplate-music.bin"
.DEFINE TRACK10_NOTES	".\\music\\10-tembas-theme-music.bin"
.DEFINE TRACK11_NOTES	".\\music\\11-triumph-beta-music.bin"
.DEFINE TRACK12_NOTES	".\\music\\12-furlorn-village-music.bin"

.EMPTYFILL		$FF



; ********************** ROM makeup, SNES header ***********************

.BASE $C0

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
.ORG START_OFFSET + $FB0

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
.ORG START_OFFSET

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
;	.DB "12345678901234567890123456789012345678901234567890123456", "        "
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

;STR_SoftwareVersionNo_END:

STR_SoftwareMaker:
	.DB "Copyright (c) 2016 by Ramsis - http://manuloewe.de/"
	.DB 0

STR_SoftwareBuild:
	.DB "Build #"

STR_SoftwareBuildNo:
	.DB "00264"
	.DB 0

;STR_Software_BuildNo_END:

STR_SoftwareBuildTimestamp:
	.DB "Assembled ", WLA_TIME
	.DB 0

;PTR_SoftwareVersion:
;	.DW STR_SoftwareVersion

;PTR_SoftwareBuild:
;	.DW STR_SoftwareBuild

CONST_Zeroes:
	.DW 0



SRC_VblankJumpTable:
	jml	Vblank_Area
	jml	Vblank_DebugMenu
	jml	Vblank_Error
	jml	Vblank_Mode7
	jml	Vblank_WorldMap
	jml	Vblank_Intro



SRC_IRQJumpTable:
	jml	HIRQ_MainMenu
	jml	VIRQ_Area
	jml	VIRQ_Mode7

.ENDS



.SECTION "Main Code" SEMIFREE

.INCLUDE "furryrpg_area.inc.asm"					; area handler
.INCLUDE "furryrpg_boot.inc.asm"					; boot code
.INCLUDE "furryrpg_debug.inc.asm"					; debug menu
.INCLUDE "furryrpg_effects_transitions.inc.asm"				; screen transition effects
.INCLUDE "furryrpg_irqnmi.inc.asm"					; Vblank NMI & IRQ handlers with subroutines
.INCLUDE "furryrpg_mainmenu.inc.asm"					; in-game main menu
.INCLUDE "furryrpg_mode7.inc.asm"					; Mode 7 handler
.INCLUDE "furryrpg_music.inc.asm"					; music handler
.INCLUDE "furryrpg_sram.inc.asm"					; SRAM handler
.INCLUDE "furryrpg_text.inc.asm"					; text printing routines
.INCLUDE "furryrpg_worldmap.inc.asm"					; world map handler

.ENDS



.SECTION "libs" SEMIFREE

.INCLUDE "lib_joypads.inc.asm"
.INCLUDE "lib_multi5.inc.asm"
.INCLUDE "lib_randomnrgen.inc.asm"
.INCLUDE "lib_snesgss.inc.asm"

.ENDS



.BANK CurrentBank SLOT 0
.ORG START_OFFSET + $FA0

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

.INCLUDE ".\\data\\gfx.inc.asm"						; sprites, fonts, palettes
.INCLUDE ".\\data\\tbl_fontwidth.inc.asm"				; font width table for sprite VWF

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "CharacterData 2"

GFX_Items_Eng:
.INCBIN ".\\gfx\\items_eng.pic"						; English item names (2bpp gfx, 40,960 bytes)

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "English dialog" FORCE

.INCLUDE ".\\data\\ptr_dialog_eng.inc.asm"				; pointers to English dialog
.INCLUDE ".\\data\\text_dialog_eng.inc.asm"				; English dialog

.ENDS

.ORG $8000

.SECTION "English misc. text" FORCE

.INCLUDE ".\\data\\text_items_eng.inc.asm"				; English item names
.INCLUDE ".\\data\\text_mainmenu_eng.inc.asm"				; English main menu strings

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "German dialog" FORCE

.INCLUDE ".\\data\\ptr_dialog_ger.inc.asm"				; pointers to German dialog
.INCLUDE ".\\data\\text_dialog_ger.inc.asm"				; German dialog

.ENDS

.ORG $8000

.SECTION "German items" FORCE

.INCLUDE ".\\data\\text_items_ger.inc.asm"				; German item names
.INCLUDE ".\\data\\text_mainmenu_ger.inc.asm"				; German main menu strings

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Source tables"

.INCLUDE ".\\data\\tbl_hdma.inc.asm"					; HDMA tables
.INCLUDE ".\\data\\tbl_mode7.inc.asm"					; Mode 7 scaling/rotation tables

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Intro GFX"

SRC_RamsisPresentsMap:
.INCBIN ".\\gfx\\ramsis-presents-256.map"

SRC_RamsisPresentsPal:
.INCBIN ".\\gfx\\ramsis-presents-256.pal"

GFX_RamsisPresentsPic:
.INCBIN ".\\gfx\\ramsis-presents-256.pic"

SRC_RamsisMap:
.INCBIN ".\\gfx\\ramsis-256.map"

SRC_RamsisPal:
.INCBIN ".\\gfx\\ramsis-256.pal"

GFX_RamsisPic:
.INCBIN ".\\gfx\\ramsis-256.pic"

SRC_SoundEnginesPal:
.INCBIN ".\\gfx\\sound-engines-256.pal"

GFX_SoundEnginesPic:
.INCBIN ".\\gfx\\sound-engines-256.pic"

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Intro GFX 2"

SRC_SoundEnginesMap:
.INCBIN ".\\gfx\\sound-engines-256.map"

SRC_StartMap:
.INCBIN ".\\gfx\\start2-256.map"

SRC_StartPal:
.INCBIN ".\\gfx\\start2-256.pal"

GFX_StartPic:
.INCBIN ".\\gfx\\start2-256.pic"

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "World Map GFX data"

GFX_WorldMap:
;.INCBIN ".\\thg.zst" SKIP $20C13 READ $8000
.INCBIN ".\\gfx\\thg.pic"

SRC_Palette_WorldMap:
;.INCBIN ".\\thg.zst" SKIP $618 READ 512
.INCBIN ".\\gfx\\thg.pal"

SRC_Tilemap_WorldMap:
;.INCBIN ".\\thg.zst" SKIP $28C13 READ $2000
.INCBIN ".\\gfx\\thg.map"

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION "Mode 7 GFX 2"

SRC_Sommappal:
.INCBIN ".\\gfx\\iot.pal" ;som_map.pal"
;.INCBIN ".\\SOM.zst" SKIP $618 READ 512

GFX_Sommappic:
.INCBIN ".\\gfx\\iot.bin" ;som_map.pic"
;.INCBIN ".\\SOM.zst" SKIP $20C13 READ $8000

GFX_Sommappic_END:

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundDriver" SEMIFREE

SRC_spc700_driver:
.INCBIN SPC700_DRV

.ENDS

.SECTION ".roDataSoundCode12" SEMIFREE

SRC_track_10_pointers:
.INCBIN TRACK10_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_10_samples:
.INCBIN TRACK10_SMP SKIP 2342						; 2 + 2340

SRC_track_10_samples_END:

SRC_track_10_notes:
.INCBIN TRACK10_NOTES

SRC_track_11_notes:
.INCBIN TRACK11_NOTES

SRC_track_12_notes:
.INCBIN TRACK12_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode02" SEMIFREE

SRC_track_00_pointers:
.INCBIN TRACK00_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_00_samples:
.INCBIN TRACK00_SMP SKIP 2342						; 2 + 2340

SRC_track_00_samples_END:

.ENDS



.SECTION ".roDataMusic02" SEMIFREE

SRC_track_00_notes:
.INCBIN TRACK00_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode03" SEMIFREE

SRC_track_01_pointers:
.INCBIN TRACK01_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_01_samples:
.INCBIN TRACK01_SMP SKIP 2342						; 2 + 2340

SRC_track_01_samples_END:

.ENDS



.SECTION ".roDataMusic03" SEMIFREE

SRC_track_01_notes:
.INCBIN TRACK01_NOTES

.ENDS



.SECTION ".roDataSoundCode05" SEMIFREE

SRC_track_03_pointers:
.INCBIN TRACK03_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_03_samples:
.INCBIN TRACK03_SMP SKIP 2342						; 2 + 2340

SRC_track_03_samples_END:

.ENDS



.SECTION ".roDataMusic05" SEMIFREE

SRC_track_03_notes:
.INCBIN TRACK03_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode04" SEMIFREE

SRC_track_02_pointers:
.INCBIN TRACK02_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_02_samples:
.INCBIN TRACK02_SMP SKIP 2342						; 2 + 2340

SRC_track_02_samples_END:

.ENDS



.SECTION ".roDataMusic04" SEMIFREE

SRC_track_02_notes:
.INCBIN TRACK02_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode06" SEMIFREE

SRC_track_04_pointers:
.INCBIN TRACK04_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_04_samples:
.INCBIN TRACK04_SMP SKIP 2342						; 2 + 2340

SRC_track_04_samples_END:

.ENDS



.SECTION ".roDataMusic06" SEMIFREE

SRC_track_04_notes:
.INCBIN TRACK04_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode07" SEMIFREE

SRC_track_05_pointers:
.INCBIN TRACK05_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_05_samples:
.INCBIN TRACK05_SMP SKIP 2342						; 2 + 2340

SRC_track_05_samples_END:

.ENDS



.SECTION ".roDataMusic07" SEMIFREE

SRC_track_05_notes:
.INCBIN TRACK05_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode08" SEMIFREE

SRC_track_06_pointers:
.INCBIN TRACK06_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_06_samples:
.INCBIN TRACK06_SMP SKIP 2342						; 2 + 2340

SRC_track_06_samples_END:

.ENDS



.SECTION ".roDataMusic08" SEMIFREE

SRC_track_06_notes:
.INCBIN TRACK06_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode09" SEMIFREE

SRC_track_07_pointers:
.INCBIN TRACK07_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_07_samples:
.INCBIN TRACK07_SMP SKIP 2342						; 2 + 2340

SRC_track_07_samples_END:

.ENDS



.SECTION ".roDataMusic09" SEMIFREE

SRC_track_07_notes:
.INCBIN TRACK07_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode10" SEMIFREE

SRC_track_08_pointers:
.INCBIN TRACK08_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_08_samples:
.INCBIN TRACK08_SMP SKIP 2342						; 2 + 2340

SRC_track_08_samples_END:

.ENDS



.SECTION ".roDataMusic10" SEMIFREE

SRC_track_08_notes:
.INCBIN TRACK08_NOTES

.ENDS



; ****************************** NEW BANK ******************************

.REDEFINE CurrentBank	CurrentBank+1

.BANK CurrentBank SLOT 0
.ORG 0

.SECTION ".roDataSoundCode11" SEMIFREE

SRC_track_09_pointers:
.INCBIN TRACK09_SMP SKIP 10 READ 6					; 2 + 8

SRC_track_09_samples:
.INCBIN TRACK09_SMP SKIP 2342						; 2 + 2340

SRC_track_09_samples_END:

.ENDS



.SECTION ".roDataMusic11" SEMIFREE

SRC_track_09_notes:
.INCBIN TRACK09_NOTES

.ENDS



; ******************************** EOF *********************************
