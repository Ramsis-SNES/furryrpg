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

; Always use equal sign for .DEFINEs with numbers here, no need for vertical alignment

; Build number
.DEFINE BuildNumASCII = "00581"

; Boot to debug menu, show verbose on-screen messages
.DEFINE DEBUG								

; Location of IRQ/NMI routines, these must be anywhere in the upper 32K (of bank $40) when using
; ExHiROM mapping (unless RAM-mapped)
.DEFINE IRQNMIRoutines = $8000

; Disable music
;.DEFINE NOMUSIC

; Disable music & sound effects
;.DEFINE NOSOUND

; Pre-calculate 112 304-byte-long tables (>33 KiB) for Mode 7 flying animation (otherwise, these
; are calculated during runtime and stored in WRAM, which adds ~6 seconds of loading time)
.DEFINE PrecalcMode7Tables

; Where the SNES starts executing code, this must also be in the upper 32K (of bank $40) when using
; ExHiROM mapping ($10 bytes max, extended header starts at $FFB0)
.DEFINE ResetVector = $FFA0

; Use a custom build of the SNESGSS sound driver (incomplete/broken!)
;.DEFINE UseCustomGSSDriver

; Jump through some hoops to work around the various INIDISP glitches discovered in 2021
.DEFINE WorkAroundINIDISP

; Variables and macros need to be .INCLUDEd as early as possible
.INCLUDE "variables.inc.asm"
.INCLUDE "macros.inc.asm"

; Text string mapping tables
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
;	ID		"SNS!"						; see GAMECODE in .SNESEXPANDEDHEADER
	NAME		"FURRY RPG!           "				; 21 characters
	EXHIROM								; aka Mode 25
	FASTROM
	CARTRIDGETYPE	$55						; ROM, RTC + battery-backed SRAM
	ROMSIZE		$0D						; (1 SHL n) KiB = 8 MiB (reported as a power of 2, even though actual ROM size is 6 MiB for now)
	SRAMSIZE	$03						; 8 KiB for now
	COUNTRY		$01						; USA/Canada (implies NTSC) / see notes
	LICENSEECODE	$33						; $33 = indicator for newer/extended cartridge header
	VERSION		$00
.ENDSNES

.SNESEXPANDEDHEADER
	MAKERCODE		"00"
	GAMECODE		"SNS!"					; see notes before changing this
	EXPANSIONFLASHSIZE	$00
	EXPANSIONRAMSIZE	$00
	SPECIALVERSION		$00
	CHIPSETSUBTYPE		$00
 .ENDSNES

.SNESNATIVEVECTOR							; all in ROM bank $40 (ExHiROM mapping)
	COP		JumpCOP
	BRK		JumpBRK
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



; HIROM BANKS ($C0-$FF) FROM HERE
; --------------------------------------------------------------------------------------------------

.BASE $C0								; bank numbers for reference. Regex search:  HIROM_..$ (with preceding space), Insert Nums command: Ctrl+Alt+N, 192:1~02X
.DEFINE CurrentBank = $00						; HIROM_C0

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
	shl
	shr
	shl	3
	shr	3

@ProgramCounter:
	bsr	UnusedCode2
;	brl	UnusedCode2						; 82 XX XX
	per	DebugMenuLoop@YButtonDone-1
	rts

;	per	UnusedCode2						; 62 XX XX
;	plx
;	jml	DebugMenuLoop@YButtonDone

@ProvokeError:
	brk	$FF
	cop	$FF



UnusedCode2:
	rts

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



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank						; HIROM_C1

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Character data 1" SEMIFREE

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
	.INCBIN "gfx/font_8x8.pic"					; 2bpp font for BG3 and Mode 5 FWF printing (2048 bytes)



; Hero portraits

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
	.INCBIN "gfx/area-001-sandbox.pic"

SRC_Palette_Area001:
	.INCBIN "gfx/area-001-sandbox.pal"

SRC_TileMapBG1_Area001:
	.INCBIN "gfx/area-001-sandbox.map"

SRC_TilesBG1_Area002:
	.INCBIN "gfx/area-002-green.pic"

SRC_Palette_Area002:
	.INCBIN "gfx/area-002-green.pal"

SRC_TileMapBG1_Area002:
	.INCBIN "gfx/area-002-green.map"



; GFX pointer tables

SRC_CharPortraitGFX:
	.DW $0000							; dummy pointer (used when no portrait wanted)
	.DW SRC_Portrait_Hero1
	.DW SRC_Portrait_Hero2

SRC_CharPortraitPalette:
	.DW $0000							; ditto
	.DW SRC_Palette_Portrait_Hero1
	.DW SRC_Palette_Portrait_Hero2

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank						; HIROM_C2

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Character data 2" SEMIFREE

SRC_FontMode5Bold:
	.INCBIN "gfx/font_mode5_vwf_fat.pic"				; 8 KiB
	.INCLUDE "data/bin_fontwidthtables.inc.asm"			; font width tables

SRC_StaticItemsENG:
	.INCBIN "gfx/static_items_eng.pic"				; English item names (2bpp gfx, 40,960 bytes)

.ENDS



.SECTION "Text box tilemaps" SEMIFREE

SRC_TextBoxTilemapBG1:

.HEX BLOCK
	00046C046E0470047204740400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	0004760478047A047C047E0400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00048004820484048604880400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00048A048C048E049004920400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00049404960498049A049C0400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00049E04A004A204A404A60400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
	00040004000400040004000400040004
.ENDHEX

SRC_TextBoxTilemapBG2:

.HEX BLOCK
	1B040000000000000000000010001100
	11001100110011001100110011001100
	11001100110011001100110011001100
	11001100110011001100110012001B04
	1B040000000000000000000014002000
	22002400260028002A002C002E003000
	32003400360038003A003C003E004000
	42004400460048004A004C0015001B04
	1B040000000000000000000014004E00
	500052005400560058005A005C005E00
	600062006400660068006A006C006E00
	700072007400760078007A0015001B04
	1B040000000000000000000014007C00
	7E00800082008400860088008A008C00
	8E00900092009400960098009A009C00
	9E00A000A200A400A600A80015001B04
	1B04000000000000000000001400AA00
	AC00AE00B000B200B400B600B800BA00
	BC00BE00C000C200C400C600C800CA00
	CC00CE00D000D200D400D60015001B04
	1B040000000000000000000017001800
	18001800180018001800180018001800
	18001800180018001800180018001800
	18001800180018001800180019001B04
.ENDHEX

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank						; HIROM_C3

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

	incr	&CurrentBank						; HIROM_C4

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

	incr	&CurrentBank						; HIROM_C5

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "HDMA tables" SEMIFREE

.INCLUDE "data/bin_hdmatables.inc.asm"					; HDMA tables

.ENDS



.SECTION "Random number byte tables" SEMIFREE

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



.SECTION "Sine, cosine, and Mode 7 scaling tables" SEMIFREE

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

; Mode 7 "flight" scroll lookup tables, D values affect scrolling speed
SRC_SineTableScrollX:							; lookup table for X (hor. scroll offset)
	.DWSIN 0, 255, 1.40625, 32, 0

SRC_CosineTableScrollY:							; lookup table for Y (vert. scroll offset)
	.DWCOS 0, 255, 1.40625, 32, 0

; Mode 7 "flight" main HDMA math tables, D values affect altitude (might need to change values
; depending on source graphics) and shouldn't go over 127 (signed values)
SRC_SineTable8:								; 256-byte-long sine table
	.DBSIN 0, 255, 1.40625, 127, 0

SRC_CosineTable8:							; 256-byte-long cosine table
	.DBCOS 0, 255, 1.40625, 127, 0

; Tables for ring menu sprite placement, D values affect ring menu radius (256 ensures that
; kRingMenuRadiusMin/kRingMenuRadiusMax represent actual pixel values)
SRC_SineTable16:							; 256-word-long sine table
	.DWSIN 0, 255, 1.40625, 256, 0

SRC_CosineTable16:							; 256-word-long cosine table
	.DWCOS 0, 255, 1.40625, 256, 0



.IFDEF PrecalcMode7Tables

SRC_Mode7Scaling:
	.INCBIN "data/mode7_scalingtables.bin"

.ENDIF

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank						; HIROM_C6

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Intro GFX" SEMIFREE

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

	incr	&CurrentBank						; HIROM_C7

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "More GFX data" SEMIFREE

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



.SECTION "World map GFX data" SEMIFREE

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

	incr	&CurrentBank						; HIROM_C8

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Mode 7 GFX" SEMIFREE

SRC_IoTmappal:
	.INCBIN "gfx/iot.pal" READ 512

SRC_IoTmappic:
	.INCBIN "gfx/iot.bin"

__IoTmap_END:

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

	incr	&CurrentBank						; HIROM_C9

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

	incr	&CurrentBank						; HIROM_CA

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

	incr	&CurrentBank						; HIROM_CB

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

	incr	&CurrentBank						; HIROM_CC

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

	incr	&CurrentBank						; HIROM_CD

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

	incr	&CurrentBank						; HIROM_CE

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

	incr	&CurrentBank						; HIROM_CF

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

	incr	&CurrentBank						; HIROM_D0

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

	incr	&CurrentBank						; HIROM_D1

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

	incr	&CurrentBank						; HIROM_D2

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

;	incr	&CurrentBank						; HIROM_D3

;.BANK CurrentBank SLOT 0
;.ORG $0000

;.SECTION "" SEMIFREE
;.ENDS



; EXHIROM BANKS ($40-$5F) FROM HERE
; --------------------------------------------------------------------------------------------------

.BASE $00								; bank numbers for reference. Regex search: EXHIROM_..$, Insert Nums command: Ctrl+Alt+N, 64:1~02X
.REDEFINE CurrentBank = $40						; EXHIROM_40

.BANK CurrentBank SLOT 0
.ORG $0000

.SECTION "Test code 3" FORCE

.ACCU 8
.INDEX 16

PrintTest:
	PrintString	2, 2, kTextBG3, "Print test bank $40\\n  "	; tested working
;	PrintNum	<DP2.GameConfig
	PrintHexNum	LO8.Time_Second

	PrintSpriteText	2, 24, "Test ", 0
	PrintSpriteHexNum	LO8.Time_Second

	rtl

.ENDS



.ORG IRQNMIRoutines

.SECTION "IRQ/NMI routines" FORCE

.INCLUDE "furryrpg_irqnmi.inc.asm"					; Vblank NMI, IRQ & software interrupt handlers

.ENDS



.ORG ResetVector

.SECTION "ExHiROM Reset vector target" FORCE

Reset:
	sei								; disable interrupts
	clc
	xce								; switch to 65816 native mode
	jml	Startup							; long jump is crucial here for correct Program Counter bank

.ENDS



; NEW BANK
; --------------------------------------------------------------------------------------------------

;	incr	&CurrentBank						; EXHIROM_41

;.BANK CurrentBank SLOT 0
;.ORG $0000

;.SECTION "" SEMIFREE
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
