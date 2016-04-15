;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuL�we (http://www.manuloewe.de/)
;
;	*** ROM LAYOUT ***
;
;==========================================================================================



; ****************************** Defines *******************************

.BASE $C0

.DEFINE DEBUG
;.DEFINE NOMUSIC				; activate this to disable music // FIXME (make this actually work)
;.DEFINE QUICKTEST				; for quick tests (skipping intro)

.DEFINE START_OFFSET	$F000			; start code offset in bank $C0

.DEFINE SPC700_DRV	".\\music\\00-spc700-driver.bin"

.DEFINE TRACK00_SMP	".\\music\\02-worldmap-3-spc700.bin"
.DEFINE TRACK01_SMP	".\\music\\03-cave-1-spc700.bin"
.DEFINE TRACK02_SMP	".\\music\\04-despair-spc700.bin"
.DEFINE TRACK03_SMP	".\\music\\05-three-buskers-spc700.bin"
.DEFINE TRACK04_SMP	".\\music\\05-and-one-buffoon-spc700.bin"
.DEFINE TRACK05_SMP	".\\music\\06-troubled-mind-spc700.bin"
.DEFINE TRACK06_SMP	".\\music\\07-fanfare1-spc700.bin"
.DEFINE TRACK07_SMP	".\\music\\08-allons-ensemble-spc700.bin"
.DEFINE TRACK08_SMP	".\\music\\09-caterwauling-spc700.bin"
.DEFINE TRACK09_SMP	".\\music\\10-contemplate-spc700.bin"

.DEFINE TRACK00_NOTES	".\\music\\02-worldmap-3-music.bin"
.DEFINE TRACK01_NOTES	".\\music\\03-cave-1-music.bin"
.DEFINE TRACK02_NOTES	".\\music\\04-despair-music.bin"
.DEFINE TRACK03_NOTES	".\\music\\05-three-buskers-music.bin"
.DEFINE TRACK04_NOTES	".\\music\\05-and-one-buffoon-music.bin"
.DEFINE TRACK05_NOTES	".\\music\\06-troubled-mind-music.bin"
.DEFINE TRACK06_NOTES	".\\music\\07-fanfare1-music.bin"
.DEFINE TRACK07_NOTES	".\\music\\08-allons-ensemble-music.bin"
.DEFINE TRACK08_NOTES	".\\music\\09-caterwauling-music.bin"
.DEFINE TRACK09_NOTES	".\\music\\10-contemplate-music.bin"

.EMPTYFILL		$FF



; ********************** ROM makeup, SNES header ***********************

.MEMORYMAP
	DEFAULTSLOT	0
	SLOTSIZE	$10000
	SLOT 0		$0000
.ENDME



.ROMBANKMAP
	BANKSTOTAL	24
	BANKSIZE	$10000			; ROM banks are 64 KBytes in size
	BANKS		24			; 24 ROM banks = 12 Mbit
.ENDRO



.SNESHEADER					; this also calculates ROM checksum & complement
	ID		"SNES"
	NAME		"FURRY RPG!           "
	HIROM
	FASTROM
	CARTRIDGETYPE	$02
	ROMSIZE		$09
	SRAMSIZE	$03
	COUNTRY		$01
	LICENSEECODE	$33
	VERSION		$00
.ENDSNES



.BANK 0 SLOT 0
.ORG START_OFFSET + $FB0

	.DB		"00"			; new licensee code



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
.BANK 0 SLOT 0
.ORG START_OFFSET

.SECTION "Dummy/empty vectors" SEMIFREE

EmptyHandler:
	rti

DummyBRK:
	jml ErrorHandlerBRK

DummyCOP:
	jml ErrorHandlerCOP

.ENDS



; **************** Variables, macros, library routines *****************

	.INCLUDE "lib_variables.asm"		; global variables
	.INCLUDE "lib_macros.asm"		; macros



; ****************************** BANK $C0 ******************************

.BANK 0 SLOT 0
.ORG 0

.SECTION "VersionStrings" FORCE

STR_Software_Title:
	.DB "FURRY RPG! (WORKING TITLE)"

STR_SoftwareVersion:
	.DB " v"

STR_SoftwareVersionNo:
	.DB "0.0.1"
	.DB 0

;STR_SoftwareVersionNo_END:

STR_SoftwareMaker:
	.DB $A9, " 2016 by www.ManuLoewe.de"	; $A9 = copyright symbol
	.DB 0

STR_SoftwareBuild:
	.DB "Build #"

STR_SoftwareBuildNo:
	.DB "00250"
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
	jml Vblank_Area
	jml Vblank_DebugMenu
	jml Vblank_Error
	jml Vblank_Mode7
	jml Vblank_Playfield
	jml Vblank_Intro



SRC_IRQJumpTable:
	jml HIRQ_MainMenu
	jml VIRQ_Area
	jml VIRQ_Mode7

.ENDS



.SECTION "Main Code" SEMIFREE
	.INCLUDE "furryrpg_area.inc.asm"	; area handler
	.INCLUDE "furryrpg_boot.inc.asm"	; boot code
	.INCLUDE "furryrpg_debug.inc.asm"	; debug menu
	.INCLUDE "furryrpg_effects_transitions.inc.asm"	; screen transition effects
	.INCLUDE "furryrpg_irqnmi.inc.asm"	; Vblank NMI & IRQ handlers with subroutines
	.INCLUDE "furryrpg_mainmenu.inc.asm"	; in-game main menu
	.INCLUDE "furryrpg_mode7.inc.asm"	; Mode 7 handler
	.INCLUDE "furryrpg_music.inc.asm"	; music handler
	.INCLUDE "furryrpg_sram.inc.asm"	; SRAM handler
	.INCLUDE "furryrpg_text.inc.asm"	; text printing routines
.ENDS



.SECTION "libs" SEMIFREE
	.INCLUDE "lib_joypads.inc.asm"
	.INCLUDE "lib_multi5.inc.asm"
	.INCLUDE "lib_snesgss.inc.asm"
.ENDS



.BANK 0 SLOT 0
.ORG START_OFFSET + $FA0

.SECTION "Startup" FORCE

Startup:
	sei					; disable interrupts
	clc
	xce					; switch to native mode

	jml Boot

.ENDS



; ****************************** BANK $C1 ******************************

.BANK 1 SLOT 0
.ORG 0

.SECTION "CharacterData"
	.INCLUDE "data_gfxdata.inc.asm"	; sprites, fonts, palettes
	.INCLUDE "data_fontwidthtables.inc.asm"	; font width table for sprite VWF
.ENDS



; ****************************** BANK $C2 ******************************

.BANK 2 SLOT 0
.ORG 0

.SECTION "Dialog" FORCE
	.INCLUDE "data_dialogpointers.inc.asm"	; pointers
	.INCLUDE "data_dialog.inc.asm"		; dialog
.ENDS

.ORG $8000

.SECTION "Items" FORCE
	.INCLUDE "data_items.inc.asm"		; item names
.ENDS



; ****************************** BANK $C3 ******************************

.BANK 3 SLOT 0
.ORG 0

.SECTION "Source tables"
	.INCLUDE "data_hdmatables.inc.asm"	; HDMA tables
	.INCLUDE "data_mode7tables.inc.asm"	; Mode 7 scaling/rotation tables
.ENDS



; ****************************** BANK $C4 ******************************

.BANK 4 SLOT 0
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



; ****************************** BANK $C5 ******************************

.BANK 5 SLOT 0
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



; ****************************** BANK $C6 ******************************

.BANK 6 SLOT 0
.ORG 0

.SECTION "Playfield GFX"

GFX_Playfield_001:
;	.INCBIN ".\\gfx\\playfield_001.pic"
	.INCBIN ".\\gfx\\pitcairn.pic"

GFX_Playfield_001_END:



SRC_Playfield_001_MAP:
;	.INCBIN ".\\gfx\\playfield_001.map"
	.INCBIN ".\\gfx\\pitcairn.map"

SRC_Playfield_001_MAP_END:

.ENDS



; ****************************** BANK $C7 ******************************

.BANK 7 SLOT 0
.ORG 0

.SECTION "Mode 7 GFX 2"

SRC_Sommappal:
	.INCBIN ".\\gfx\\iot.pal" ;som_map.pal"
;	.INCBIN ".\\SOM.zst" SKIP $618 READ 512

GFX_Sommappic:
	.INCBIN ".\\gfx\\iot.bin" ;som_map.pic"
;	.INCBIN ".\\SOM.zst" SKIP $20C13 READ $8000

GFX_Sommappic_END:

.ENDS



; ****************************** BANK $C8 ******************************

.BANK 8 SLOT 0
.ORG 0

.SECTION ".roDataSoundDriver" SEMIFREE

SRC_spc700_driver:
	.INCBIN SPC700_DRV

.ENDS



; ****************************** BANK $C9 ******************************

.BANK 9 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode02" SEMIFREE

SRC_track_00_pointers:
	.INCBIN TRACK00_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_00_samples:
	.INCBIN TRACK00_SMP SKIP 2342		; 2 + 2340

SRC_track_00_samples_END:

.ENDS



.SECTION ".roDataMusic02" SEMIFREE

SRC_track_00_notes:
	.INCBIN TRACK00_NOTES

.ENDS



; ****************************** BANK $CA ******************************

.BANK 10 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode03" SEMIFREE

SRC_track_01_pointers:
	.INCBIN TRACK01_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_01_samples:
	.INCBIN TRACK01_SMP SKIP 2342		; 2 + 2340

SRC_track_01_samples_END:

.ENDS



.SECTION ".roDataMusic03" SEMIFREE

SRC_track_01_notes:
	.INCBIN TRACK01_NOTES

.ENDS



.SECTION ".roDataSoundCode05" SEMIFREE

SRC_track_03_pointers:
	.INCBIN TRACK03_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_03_samples:
	.INCBIN TRACK03_SMP SKIP 2342		; 2 + 2340

SRC_track_03_samples_END:

.ENDS



.SECTION ".roDataMusic05" SEMIFREE

SRC_track_03_notes:
	.INCBIN TRACK03_NOTES

.ENDS



; ****************************** BANK $CB ******************************

.BANK 11 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode04" SEMIFREE

SRC_track_02_pointers:
	.INCBIN TRACK02_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_02_samples:
	.INCBIN TRACK02_SMP SKIP 2342		; 2 + 2340

SRC_track_02_samples_END:

.ENDS



.SECTION ".roDataMusic04" SEMIFREE

SRC_track_02_notes:
	.INCBIN TRACK02_NOTES

.ENDS



; ****************************** BANK $CC ******************************

.BANK 12 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode06" SEMIFREE

SRC_track_04_pointers:
	.INCBIN TRACK04_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_04_samples:
	.INCBIN TRACK04_SMP SKIP 2342		; 2 + 2340

SRC_track_04_samples_END:

.ENDS



.SECTION ".roDataMusic06" SEMIFREE

SRC_track_04_notes:
	.INCBIN TRACK04_NOTES

.ENDS



; ****************************** BANK $CD ******************************

.BANK 13 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode07" SEMIFREE

SRC_track_05_pointers:
	.INCBIN TRACK05_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_05_samples:
	.INCBIN TRACK05_SMP SKIP 2342		; 2 + 2340

SRC_track_05_samples_END:

.ENDS



.SECTION ".roDataMusic07" SEMIFREE

SRC_track_05_notes:
	.INCBIN TRACK05_NOTES

.ENDS



; ****************************** BANK $CE ******************************

.BANK 14 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode08" SEMIFREE

SRC_track_06_pointers:
	.INCBIN TRACK06_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_06_samples:
	.INCBIN TRACK06_SMP SKIP 2342		; 2 + 2340

SRC_track_06_samples_END:

.ENDS



.SECTION ".roDataMusic08" SEMIFREE

SRC_track_06_notes:
	.INCBIN TRACK06_NOTES

.ENDS



; ****************************** BANK $CF ******************************

.BANK 15 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode09" SEMIFREE

SRC_track_07_pointers:
	.INCBIN TRACK07_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_07_samples:
	.INCBIN TRACK07_SMP SKIP 2342		; 2 + 2340

SRC_track_07_samples_END:

.ENDS



.SECTION ".roDataMusic09" SEMIFREE

SRC_track_07_notes:
	.INCBIN TRACK07_NOTES

.ENDS



; ****************************** BANK $CE ******************************

.BANK 16 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode10" SEMIFREE

SRC_track_08_pointers:
	.INCBIN TRACK08_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_08_samples:
	.INCBIN TRACK08_SMP SKIP 2342		; 2 + 2340

SRC_track_08_samples_END:

.ENDS



.SECTION ".roDataMusic10" SEMIFREE

SRC_track_08_notes:
	.INCBIN TRACK08_NOTES

.ENDS



; ****************************** BANK $CF ******************************

.BANK 17 SLOT 0
.ORG 0

.SECTION ".roDataSoundCode11" SEMIFREE

SRC_track_09_pointers:
	.INCBIN TRACK09_SMP SKIP 10 READ 6	; 2 + 8

SRC_track_09_samples:
	.INCBIN TRACK09_SMP SKIP 2342		; 2 + 2340

SRC_track_09_samples_END:

.ENDS



.SECTION ".roDataMusic11" SEMIFREE

SRC_track_09_notes:
	.INCBIN TRACK09_NOTES

.ENDS



; ******************************** EOF *********************************
