; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	ROM SETTINGS AND LAYOUT
;
; ==================================================================================================



; GLOBAL .DEFINES AND .INCLUDES
; --------------------------------------------------------------------------------------------------

.DEFINE BuildNumASCII		"00558"
.DEFINE DEBUG								; boot to debug menu, show verbose on-screen messages
;.DEFINE NOMUSIC							; uncomment this to disable music
.DEFINE PrecalcMode7Tables						; if not .DEFINED, 112 304-byte-long tables (>33 KiB) are calculated during runtime (and stored in WRAM), which currently adds ~6 seconds of loading time to the Mode7 map screen
;.DEFINE UseCustomGSSDriver						; use a custom build of the SNESGSS sound driver (with stereo enabled by default) // incomplete/broken!
.DEFINE WorkAroundINIDISP						; jump through some hoops to work around the various INIDISP glitches discovered in 2021

.DEFINE IRQNMIRoutines		$8000					; location of IRQ/NMI routines, these must be anywhere in the upper 32K (of bank $40) due to ExHiROM mapping
.DEFINE ResetVector		$FFA0					; where we have the SNES start executing code, this must also be in the upper 32K (of bank $40) due to ExHiROM mapping
.DEFINE CartExtHeader		$FFB0					; extended SNES cartridge header ($FFB0..$FFBF)
;.DEFINE CartHeader		$FFC0					; regular SNES cartridge header ($FFC0..$FFCF)

 ; These two need to be .INCLUDEd earliest
.INCLUDE "variables.inc.asm"						; global variables
.INCLUDE "macros.inc.asm"						; macros

.STRINGMAPTABLE dialogue "data/tbl_dialogue.tbl"
.STRINGMAPTABLE HUD "data/tbl_hud_char.tbl"



; ROM MAKEUP, SNES HEADER
; --------------------------------------------------------------------------------------------------

.MEMORYMAP
	DEFAULTSLOT	0
	SLOTSIZE	$10000
	SLOT 0		$0000
.ENDME

.ROMBANKSIZE		$10000						; 64 KiB ROM banks
.ROMBANKS		96						; total ROM size = 48 Mbit

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

.SNESNATIVEVECTOR							; all in ROM bank $40 (ExHiROM mapping)
	COP		JumpBRKorCOP
	BRK		JumpBRKorCOP
	ABORT		EmptyHandler
	NMI		GlobalNMI
	UNUSED		$0000
	IRQ		GlobalIRQ
.ENDNATIVEVECTOR

.SNESEMUVECTOR								; all in ROM bank $40 (ExHiROM mapping)
	COP		EmptyHandler
	UNUSED		$0000
	ABORT		EmptyHandler
	NMI		EmptyHandler
	RESET		Reset
	IRQBRK		EmptyHandler
.ENDEMUVECTOR

.EMPTYFILL		$FF



; HIROM BANKS ($C0-$FF)
; --------------------------------------------------------------------------------------------------

.BASE $C0



; BANK $C0
; --------------------------------------------------------------------------------------------------

.DEFINE CurrentBank = 0

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Version and build" FORCE

STR_Software_Title:
	.DB "FURRY RPG! (Working title)"

STR_SoftwareVersion:
	.DB " v"

STR_SoftwareVersionNo:
	.DB "0.0.1"
	.DB $00

STR_SoftwareMaker:
	.DB "Copyright (c) by Ramsis - https://manuloewe.de/"
	.DB $00

STR_SoftwareBuild:
	.DB "Build #"

STR_SoftwareBuildNum:
	.DB BuildNumASCII
	.DB $00

STR_SoftwareBuildTime:
	.DB "Assembled ", WLA_TIME
	.DB $00

SRC_0000:
	.DW $0000

SRC_FFFF:
	.DW $FFFF

.ENDS



.SECTION "Disclaimer" FORCE

STR_Disclaimer:								; max. 20 lines, 56 chars + 8 spaces per line
	.DB "This game is not licensed, sponsored or endorsed by     ", "        "
	.DB "Nintendo Co., Ltd.                                      ", "        "
	.DB "                                                        ", "        "
	.DB "Story, dialogue, music, programming:                    ", "        "
	.DB "Ramsis aka ManuLoewe                                    ", "        "
	.DB "                                                        ", "        "
	.DB "Proudly made with the WLA DX cross assembler            ", "        "
	.DB "and without the use of any AI whatsoever.               ", "        "
	.DB "                                                        ", "        "
	.DB "All characters in this game are fictitious. Any         ", "        "
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
	.DB $00

.ENDS



.SECTION "Test code 1" SEMIFREE

	.DB "UNUSED/TEST CODE"

UnusedCode:
	rts

@Long:
	rtl

@Accumulator:
;	lda	SRAM.Slot1.Hero1HP					; lda $B06040
;	lda	SRAM.Slot1.Hero1HPLo					; lda $B06040
	lda.w	#kGSS_NONE						; A9 00 00
	sta.b	(<DP2.DataAddress)					; 92 1E
	sta	(<DP2.DataAddress)					; 92 1E
	sta	(DP2.DataAddress.#b)					; 92 1E
	lda	<DP2.DataAddress					; A5 1E
	lda	DP2.DataAddress.#b					; A5 1E
	lda	DP2.DataAddress						; AD 1E 02
	lda	P00.Test						; A5 00
	lda	P01.Reserved						; AD 00 01

@BitManipulation:
	lsh
	rsh
	lsh	3
	rsh	3

@ProgramCounter:
;	bsr	UnusedCode2
	brl	UnusedCode2						; 82 XX XX
;	.DB	$82, $XX, $XX
	per	DebugMenuLoop@YButtonDone-1
	rts

;	per	UnusedCode2						; 62 XX XX
;	.DB	$62, $XX, $XX
;	plx
;	jml	DebugMenuLoop@YButtonDone

	.DB "END OF UNUSED/TEST CODE"

.ENDS



.SECTION "Main code" SEMIFREE

; Self-reminder: furryrpg_irqnmi.inc.asm in bank $40 as of build #00558

.INCLUDE "furryrpg_main.inc.asm"					; main game/debug code
.INCLUDE "furryrpg_area.inc.asm"					; area handler
.INCLUDE "furryrpg_effects.inc.asm"					; on-screen effects
.INCLUDE "furryrpg_event.inc.asm"					; event handler
.INCLUDE "furryrpg_mainmenu.inc.asm"					; in-game main menu
.INCLUDE "furryrpg_mode7.inc.asm"					; Mode 7 handler
.INCLUDE "furryrpg_sound.inc.asm"					; music & sound effects
.INCLUDE "furryrpg_text.inc.asm"					; text printing routines
.INCLUDE "furryrpg_worldmap.inc.asm"					; world map handler

.ENDS



.SECTION "Data" SEMIFREE						; CHANGEME, move data/scripting files to other banks (requires acknowledgement of bank byte in area properties)

.INCLUDE "data/bin_areadata.inc.asm"					; area properties/objects tables, area meta maps
.INCLUDE "data/script_event.inc.asm"					; event control scripting code

.ENDS



.SECTION "Libraries" SEMIFREE

.INCLUDE "libraries.inc.asm"

.ENDS



.ORG ResetVector

.SECTION "Dummy boot code" FORCE

	.DB "BOOTCODEINBANK40"						; just so we won't forget ;-)

.ENDS



;.ORG CartExtHeader							; seems unnecessary (mirrored from bank $40 anyway)

;.SECTION "Maker code" FORCE

;	.DB "00"							; new licensee code (unlicensed)

;.ENDS



; $FFB2 Extended Header Game Code (automatically filled in by WLA DX)



;.ORG CartExtHeader + 6							; seems unnecessary (mirrored from bank $40 anyway)

;.SECTION "Extended header 2" FORCE

;	.DSB 10, $00							; reserved/expansion size/special version header bytes (zeroed out in a regular game)

;.ENDS



.ORG $FF00

.SECTION "Test code 2" FORCE

.ACCU 8
.INDEX 16

	.DB "UNUSED/TEST CODE"

UnusedCode2:
	rts

	.DB "END OF UNUSED/TEST CODE"

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Character data 1"

; Palettes

SRC_Palettes_Text:
	.DW $0000							; background (transparent)
	.DW $0C63							; font drop shadow (dark grey)
	.DW $5EF7 ;3DEF							; font color #2 (light grey, only used by 8x8 font)
	.DW $7FFF							; font (white)

	.DW $0000							; background (transparent)
	.DW $0C63							; font drop shadow (dark grey)
	.DW $0000							; unused color
	.DW $2C1F							; font (red)

	.DW $0000							; background (transparent)
	.DW $0C63							; font drop shadow (dark grey)
	.DW $0000							; unused color
	.DW $03E0							; font (green)

	.DW $0000							; background (transparent)
	.DW $0C63							; font drop shadow (dark grey)
	.DW $0000							; unused color
	.DW $03FF							; font (yellow)

SRC_Palettes_HUD:							; 16-color palette for HUD content
	.INCBIN "gfx/font_hud_vwf.pal" READ 32

SRC_Palette_Portrait_Hero1:
	.INCBIN "gfx/portrait_gengen.pal"				; 32 bytes

SRC_Palette_Portrait_Hero2:
	.INCBIN "gfx/portrait_kimahri.pal"				; 32 bytes

SRC_Palette_Spritesheet_Hero1:
	.INCBIN "gfx/Gengen2.pal"					; 32 bytes

SRC_Palette_Sprites_InGameMenu:
	.INCBIN "gfx/menu-sprites.pal"					; 32 bytes

; Font character data

SRC_FontMode5:
	.INCBIN "gfx/font_mode5_vwf_nor.pic"				; 2bpp font for BG2 (4096 bytes)

SRC_Font8x8:
	.INCBIN "gfx/font_8x8.pic"					; 2bpp font for BG3 (2048 bytes)

; Character portraits

SRC_Portrait_Hero1:
	.INCBIN "gfx/portrait_gengen.pic" READ 1920

SRC_Portrait_Hero2:
	.INCBIN "gfx/portrait_kimahri.pic" READ 1920

; Sprite character data

SRC_Sprites_HUDfont:
	.INCBIN "gfx/font_hud_vwf.pic"					; 4096 bytes

SRC_Spritesheet_Hero1:
	.INCBIN "gfx/Gengen2.pic"

SRC_Sprites_InGameMenu:
	.INCBIN "gfx/menu-sprites.pic"

SRC_Sprites_Clouds:
	.INCBIN "gfx/cloud1.pic"

SRC_Palette_Clouds:
	.INCBIN "gfx/cloud1.pal"

;SRC_Tilemap_Clouds:
;	.INCBIN "gfx/cloud.map"



; Logo data (b/w background image for menu)

SRC_Logo:
	.INCBIN "gfx/logo-gr.pic"					; 7968 bytes

SRC_Palette_Logo:
	.INCBIN "gfx/logo-gr.pal"					; 32 bytes

SRC_Tilemap_Logo:
	.INCBIN "gfx/logo-gr.map"					; 1792 bytes



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



; GFX pointer tables

SRC_CharPortraitGFX:
	.DW $0000							; dummy pointer (needed for correct table index)
	.DW SRC_Portrait_Hero1
	.DW SRC_Portrait_Hero2

SRC_CharPortraitPalette:
	.DW $0000							; ditto
	.DW SRC_Palette_Portrait_Hero1
	.DW SRC_Palette_Portrait_Hero2

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Character data 2"

SRC_FontMode5Bold:
	.INCBIN "gfx/font_mode5_vwf_fat.pic"				; 8 KiB
	.INCLUDE "data/bin_fontwidthtables.inc.asm"			; font width tables

SRC_StaticItemsENG:
	.INCBIN "gfx/static_items_eng.pic"				; English item names (2bpp gfx, 40,960 bytes)

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "English dialogue" FORCE

.INCLUDE "data/text_dialogue_ENG.inc.asm"				; English dialogue and pointers

.ENDS



.ORG $8000

.SECTION "English misc. text" FORCE

.INCLUDE "data/text_misc_ENG.inc.asm"					; English misc. text

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "German dialogue" FORCE

.INCLUDE "data/text_dialogue_DEU.inc.asm"				; German dialogue and pointers

.ENDS



.ORG $8000

.SECTION "German misc. text" FORCE

.INCLUDE "data/text_misc_DEU.inc.asm"					; German misc. text

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "HDMA tables"

.INCLUDE "data/bin_hdmatables.inc.asm"					; HDMA tables

.ENDS



.SECTION "Random number byte tables"

; The following assembler directives create tables containing random numbers.

SRC_RND_0009:
	.DBRND COUNT 64 MIN 0 MAX 9					; 64 random bytes (0-9)

SRC_RND_1019:
	.DBRND COUNT 64 MIN 10 MAX 19					; 64 random bytes (10-19)

SRC_RND_2029:
	.DBRND COUNT 64 MIN 20 MAX 29					; 64 random bytes (20-29)

SRC_RND_3039:
	.DBRND COUNT 64 MIN 30 MAX 39					; 64 random bytes (30-39)

SRC_RND_4049:
	.DBRND COUNT 64 MIN 40 MAX 49					; 64 random bytes (40-49)

SRC_RND_5059:
	.DBRND COUNT 64 MIN 50 MAX 59					; 64 random bytes (50-59)

SRC_RND_6069:
	.DBRND COUNT 64 MIN 60 MAX 69					; 64 random bytes (60-69)

SRC_RND_7079:
	.DBRND COUNT 64 MIN 70 MAX 79					; 64 random bytes (70-79)

SRC_RND_8089:
	.DBRND COUNT 64 MIN 80 MAX 89					; 64 random bytes (80-89)

SRC_RND_9099:
	.DBRND COUNT 64 MIN 90 MAX 99					; 64 random bytes (90-99)

SRC_RND_Hex:
	.DBRND COUNT 256 MIN 0 MAX 255					; 256 random bytes (0-255)

.ENDS



.SECTION "Sine, cosine, and Mode 7 scaling tables"

;	.DxSIN A, B, C, D, E
;	.DxCOS A, B, C, D, E
;
; A = starting angle
; B = number of additional angles (i.e., we get A + B angles total)
; C = "adder value" for next angle (for a full circle: 360 degrees divided by (A + B) angle representations, e.g.: 360 / 256 = 1.40625)
; D = sort of amplitude (for lack of a better word), see below
; E = offset added to bytes generated, see below
;
; From the WLA DX docs on values D and E:
;
; The fourth and fifth arguments can be seen from the pseudo code below, which also describes how ".DBCOS" works. The values can be integer or float.
;
; Remember that "cos" (and "sin") here returns values ranging from "-1" to "1":
;
;   .DBCOS A, B, C, D, E
;
;   for (B++; B > 0; B--) {
;     output_data((D * cos(A)) + E)
;     A = keep_in_range(A + C)
;   }

;SRC_SineTableX:								; Mode 7 flight: lookup table for X (hor. scrolling)
;	.DWSIN 0, 255, 1.40625, 64, 0

;SRC_CosineTableY:							; Mode 7 flight: lookup table for Y (vert. scrolling)
;	.DWCOS 0, 255, 1.40625, 64, 0

SRC_SineTable8:								; 256-byte-long sine table
	.DBSIN 0, 255, 1.40625, 128, 0

SRC_CosineTable8:							; 256-byte-long cosine table
	.DBCOS 0, 255, 1.40625, 128, 0

SRC_SineTable16:							; 256-word-long sine table
;	.DWSIN 0, 255, 1.40625, 128, 0
	.DWSIN 0, 255, 1.40625, 256, 0

SRC_CosineTable16:							; 256-word-long cosine table
;	.DWCOS 0, 255, 1.40625, 128, 0
	.DWCOS 0, 255, 1.40625, 256, 0



.IFDEF PrecalcMode7Tables

SRC_Mode7Scaling:
	.INCBIN "data/mode7_scalingtables.bin"

.ENDIF

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

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



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

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
;	.INCBIN "thg.zst" SKIP $20C13 READ $8000
	.INCBIN "gfx/thg.pic"

SRC_Palette_WorldMap:
;	.INCBIN "thg.zst" SKIP $618 READ 512
	.INCBIN "gfx/thg.pal"

SRC_Tilemap_WorldMap:
;	.INCBIN "thg.zst" SKIP $28C13 READ $2000
	.INCBIN "gfx/thg.map"

SRC_Sprites_SkyBlur:
	.INCBIN "gfx/sky_blur.pic"

SRC_Palette_Sprites_SkyBlur:
	.INCBIN "gfx/sky_blur.pal"					; 32 bytes

__sky_blur_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Mode 7 GFX"

SRC_IoTmappal:
	.INCBIN "gfx/iot.pal" READ 512

SRC_IoTmappic:
	.INCBIN "gfx/iot.bin"

__IoTmap_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS sound driver" SEMIFREE

SRC_SPC700_driver:

.IFNDEF UseCustomGSSDriver

	.INCBIN "music/spc700-driver-v1.4.bin" SKIP 2			; skip size bytes, include bare driver (see music/SNESGSS file format notes.txt), this is uploaded to the SPC700 at boot time

.ELSE

	.INCBIN "music/spc700-driver-custom.bin" SKIP 2			; ditto for customized sound driver
;	.INCBIN "music/spc700-driver-test.bin" SKIP 2			; ditto for customized sound driver (test = bigger custom driver with new commands)

.ENDIF

__SPC700_driver_END:

	.DSB 220, $FF							; padding (not really necessary; burst transfer routine uploads 10 * 256 bytes, this simply avoids unrelated data from next .SECTION getting uploaded)

.ENDS



.SECTION "GSS music tracks 10-12" SEMIFREE

SRC_track_10_pointers:
	.INCBIN "music/10-tembas-theme-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_10_samples:
	.INCBIN "music/10-tembas-theme-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_10_Notes:
	.INCBIN "music/10-tembas-theme-music.bin" SKIP 2		; skip size bytes

SRC_track_11_Notes:
	.INCBIN "music/11-triumph-beta-music.bin" SKIP 2		; skip size bytes

SRC_track_12_Notes:
	.INCBIN "music/12-furlorn-village-music.bin" SKIP 2		; skip size bytes

__track_12_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 00" SEMIFREE

;.IFNDEF UseCustomGSSDriver

SRC_track_00_pointers:
	.INCBIN "music/00-sun-wind-and-rain-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_00_samples:
	.INCBIN "music/00-sun-wind-and-rain-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_00_Notes:
	.INCBIN "music/00-sun-wind-and-rain-music.bin" SKIP 2		; skip size bytes

__track_00_END:

;.ELSE

;SRC_track_00_pointers:	; test files for bigger custom driver
;	.INCBIN "music/00-test-spc700.bin" SKIP 10 READ 6		; 2 + 8

;SRC_track_00_samples:
;	.INCBIN "music/00-test-spc700.bin" SKIP 2598			; skip driver code & size bytes

;SRC_track_00_Notes:
;	.INCBIN "music/00-test-music.bin" SKIP 2			; skip size bytes

;__track_00_END:

;.ENDIF

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 01" SEMIFREE

SRC_track_01_pointers:
	.INCBIN "music/01-through-darkness-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_01_samples:
	.INCBIN "music/01-through-darkness-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_01_Notes:
	.INCBIN "music/01-through-darkness-music.bin" SKIP 2		; skip size bytes

__track_01_END:

.ENDS



.SECTION "GSS music track 03" SEMIFREE

SRC_track_03_pointers:
	.INCBIN "music/03-three-buskers-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_03_samples:
	.INCBIN "music/03-three-buskers-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_03_Notes:
	.INCBIN "music/03-three-buskers-music.bin" SKIP 2		; skip size bytes

__track_03_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 02" SEMIFREE

SRC_track_02_pointers:
	.INCBIN "music/02-theme-of-despair-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_02_samples:
	.INCBIN "music/02-theme-of-despair-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_02_Notes:
	.INCBIN "music/02-theme-of-despair-music.bin" SKIP 2		; skip size bytes

__track_02_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 04" SEMIFREE

SRC_track_04_pointers:
	.INCBIN "music/04-and-one-buffoon-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_04_samples:
	.INCBIN "music/04-and-one-buffoon-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_04_Notes:
	.INCBIN "music/04-and-one-buffoon-music.bin" SKIP 2		; skip size bytes

__track_04_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 05" SEMIFREE

SRC_track_05_pointers:
	.INCBIN "music/05-troubled-mind-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_05_samples:
	.INCBIN "music/05-troubled-mind-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_05_Notes:
	.INCBIN "music/05-troubled-mind-music.bin" SKIP 2		; skip size bytes

__track_05_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 06" SEMIFREE

SRC_track_06_pointers:
	.INCBIN "music/06-fanfare1-spc700.bin" SKIP 10 READ 6		; 2 + 8

SRC_track_06_samples:
	.INCBIN "music/06-fanfare1-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_06_Notes:
	.INCBIN "music/06-fanfare1-music.bin" SKIP 2			; skip size bytes

__track_06_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 07" SEMIFREE

SRC_track_07_pointers:
	.INCBIN "music/07-allons-ensemble-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_07_samples:
	.INCBIN "music/07-allons-ensemble-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_07_Notes:
	.INCBIN "music/07-allons-ensemble-music.bin" SKIP 2		; skip size bytes

__track_07_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 08" SEMIFREE

SRC_track_08_pointers:
	.INCBIN "music/08-caterwauling-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_08_samples:
	.INCBIN "music/08-caterwauling-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_08_Notes:
	.INCBIN "music/08-caterwauling-music.bin" SKIP 2		; skip size bytes

__track_08_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "GSS music track 09" SEMIFREE

SRC_track_09_pointers:
	.INCBIN "music/09-contemplate-spc700.bin" SKIP 10 READ 6	; 2 + 8

SRC_track_09_samples:
	.INCBIN "music/09-contemplate-spc700.bin" SKIP kGSS_DriverSize+2	; skip driver code & size bytes

SRC_track_09_Notes:
	.INCBIN "music/09-contemplate-music.bin" SKIP 2			; skip size bytes

__track_09_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

;	incr	&CurrentBank

;.BANK CurrentBank SLOT 0
;.ORG $0000

;.SECTION ""
;.ENDS



; EXHIROM BANKS ($40-$5F)
; --------------------------------------------------------------------------------------------------

.BASE $00



; BANK $40
; --------------------------------------------------------------------------------------------------

.REDEFINE CurrentBank = $40

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Test code 3" FORCE

.ACCU 8
.INDEX 16

PrintTest:
	PrintString	2, 2, kTextBG3, "Print test bank $40"		; tested working

	rtl

.ENDS



.ORG IRQNMIRoutines

.SECTION "IRQ/NMI routines" FORCE

.INCLUDE "furryrpg_irqnmi.inc.asm"					; Vblank NMI & IRQ handlers with subroutines

.ENDS



.ORG ResetVector

.SECTION "ExHiROM Reset/BRK/COP/dummy vector targets" FORCE

Reset:
	sei								; disable interrupts
	clc
	xce								; switch to 65816 native mode
	jml	Startup

JumpBRKorCOP:
;JumpBRK:
	jml	ErrorHandler

;JumpCOP:
;	jml	Somewhere

EmptyHandler:
	rti

.ENDS



.ORG CartExtHeader

.SECTION "Extended header 1 maker code" FORCE

	.DB "00"							; new licensee code (unlicensed)

.ENDS



; $FFB2 extended header game code (automatically filled in by WLA DX)



.ORG CartExtHeader + 6

.SECTION "Extended header 2" FORCE

	.DSB 10, $00							; reserved/expansion size/special version header bytes (zeroed out in official game releases)

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

;	incr	&CurrentBank

;.BANK CurrentBank SLOT 0
;.ORG $0000

;.SECTION ""
;.ENDS



; .RAMSECTION TEST
; --------------------------------------------------------------------------------------------------

;.BASE $7E								; WRAM bank 0

/*
.RAMSECTION "testvars 1" BASE $7E BANK 0 SLOT 0 ;ALIGN 256 OFFSET 32
	P00				INSTANCEOF struct_RAM_0000_00FF
	P01				INSTANCEOF struct_RAM_0100_01FF

; We don't use .UNIONs for the DPs because we do need the respective high byte sometimes (not only for
; tricks like "SetDP DPx", but also for conveniently setting data source addresses within the DP).
; This means we need to address *all* DPx variables with an 8-bit operand hint, like "lda <DP2.Temp".

	DP2				INSTANCEOF struct_RAM_0200_02FF
	DP3				INSTANCEOF struct_RAM_0300_03FF
	DP4				INSTANCEOF struct_RAM_0400_04FF
	DP5				INSTANCEOF struct_RAM_0500_05FF
	DP6				INSTANCEOF struct_RAM_0600_06FF
	DP7				INSTANCEOF struct_RAM_0700_07FF
	DP8				INSTANCEOF struct_RAM_0800_08FF
	DP9				INSTANCEOF struct_RAM_0900_09FF
	LO8				INSTANCEOF struct_RAM_0A00_1FFF
	RAM				INSTANCEOF struct_RAM_7E2000
.ENDS

.RAMSECTION "testvars 2" BASE $7F BANK 1 SLOT 0 ;ALIGN 256 OFFSET 32
	RAM2				INSTANCEOF struct_RAM_7F
.ENDS
*/



; EOF
