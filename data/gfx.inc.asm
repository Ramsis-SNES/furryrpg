;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** GRAPHICS DATA ***
;
;==========================================================================================



; ****************************** Defines *******************************

.DEFINE FONT_8x8		"gfx/font_8x8.pic"			; 2048 bytes
.DEFINE FONT_HUD		"gfx/font_hud_vwf.pic"
.DEFINE FONT_HUD_PAL		"gfx/font_hud_vwf.pal"
.DEFINE FONT_MODE5		"gfx/font_mode5_vwf1a.pic"		; 4096 bytes

.DEFINE LOGO			"gfx/logo-gr.pic"
.DEFINE LOGO_MAP		"gfx/logo-gr.map"
.DEFINE LOGO_PAL		"gfx/logo-gr.pal"

.DEFINE MENU_SPRITES		"gfx/menu-sprites.pic"
.DEFINE MENU_SPRITES_PAL	"gfx/menu-sprites.pal"

.DEFINE PORTRAIT_HERO1		"gfx/portrait_kimahri.pic"
.DEFINE PORTRAIT_HERO1_PAL	"gfx/portrait_kimahri.pal"
.DEFINE PORTRAIT_HERO2		"gfx/portrait_zakari.pic"
.DEFINE PORTRAIT_HERO2_PAL	"gfx/portrait_zakari.pal"
.DEFINE PORTRAIT_HERO3		"gfx/portrait_gengen.pic"
.DEFINE PORTRAIT_HERO3_PAL	"gfx/portrait_gengen.pal"
.DEFINE PORTRAIT_HERO4		"gfx/portrait_linkwolf.pic"
.DEFINE PORTRAIT_HERO4_PAL	"gfx/portrait_linkwolf.pal"

.DEFINE SPRITESHEET_HERO1	"gfx/Gengen2.pic"
.DEFINE SPRITESHEET_HERO1_PAL	"gfx/Gengen2.pal"



; ****************************** Palettes ******************************

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
.INCBIN FONT_HUD_PAL READ 32

SRC_Palette_Portrait_Hero1:
.INCBIN PORTRAIT_HERO1_PAL						; 32 bytes

SRC_Palette_Portrait_Hero2:
.INCBIN PORTRAIT_HERO2_PAL						; 32 bytes

SRC_Palette_Portrait_Hero3:
.INCBIN PORTRAIT_HERO3_PAL						; 32 bytes

SRC_Palette_Portrait_Hero4:
.INCBIN PORTRAIT_HERO4_PAL						; 32 bytes

SRC_Palette_Spritesheet_Hero1:
.INCBIN SPRITESHEET_HERO1_PAL						; 32 bytes

SRC_Palette_Sprites_InGameMenu:
.INCBIN MENU_SPRITES_PAL						; 32 bytes



; ************************ Font character data *************************

GFX_FontMode5:
.INCBIN FONT_MODE5							; 2bpp font for BG2 (4096 bytes)

GFX_Font8x8:
.INCBIN FONT_8x8							; 2bpp font for BG3 (2048 bytes)



; ************************ Character portraits *************************

GFX_Portrait_Hero1:
.INCBIN PORTRAIT_HERO1 READ 1920

GFX_Portrait_Hero2:
.INCBIN PORTRAIT_HERO2 READ 1920

GFX_Portrait_Hero3:
.INCBIN PORTRAIT_HERO3 READ 1920

GFX_Portrait_Hero4:
.INCBIN PORTRAIT_HERO4 READ 1920



; *********************** Sprite character data ************************

GFX_Sprites_HUDfont:
.INCBIN FONT_HUD							; 4096 bytes

GFX_Spritesheet_Hero1:
.INCBIN SPRITESHEET_HERO1

GFX_Sprites_InGameMenu:
.INCBIN MENU_SPRITES

GFX_Sprites_Clouds:
.INCBIN "gfx/cloud1.pic"

SRC_Palette_Clouds:
.INCBIN "gfx/cloud1.pal"

;SRC_Tilemap_Clouds:
;.INCBIN "gfx/cloud.map"

GFX_Sprites_Gallery:
.INCBIN "gfx/tantalus/fennec2.pic" READ 128				; only read first row of tiles for now
.INCBIN "gfx/tantalus/fox2.pic" READ 64
.INCBIN "gfx/tantalus/wolf1.pic" READ 64
.INCBIN "gfx/tantalus/wolf2.pic" READ 64
.INCBIN "gfx/tantalus/wolfclawblack.pic" READ 64

.REPEAT 128								; fill empty space before reading the next tile row
	.DB $00
.ENDR

.INCBIN "gfx/tantalus/fennec2.pic" SKIP 128 READ 128
.INCBIN "gfx/tantalus/fox2.pic" SKIP 64 READ 64
.INCBIN "gfx/tantalus/wolf1.pic" SKIP 64 READ 64
.INCBIN "gfx/tantalus/wolf2.pic" SKIP 64 READ 64
.INCBIN "gfx/tantalus/wolfclawblack.pic" SKIP 64 READ 64

.REPEAT 128
	.DB $00
.ENDR

.INCBIN "gfx/tantalus/fennec2.pic" SKIP 256 READ 128
.INCBIN "gfx/tantalus/fox2.pic" SKIP 128 READ 64
.INCBIN "gfx/tantalus/wolf1.pic" SKIP 128 READ 64
.INCBIN "gfx/tantalus/wolf2.pic" SKIP 128 READ 64
.INCBIN "gfx/tantalus/wolfclawblack.pic" SKIP 128 READ 64

.REPEAT 128
	.DB $00
.ENDR

.INCBIN "gfx/tantalus/fennec2.pic" SKIP 384 READ 128
.INCBIN "gfx/tantalus/fox2.pic" SKIP 192 READ 64
.INCBIN "gfx/tantalus/wolf1.pic" SKIP 192 READ 64
.INCBIN "gfx/tantalus/wolf2.pic" SKIP 192 READ 64
.INCBIN "gfx/tantalus/wolfclawblack.pic" SKIP 192 READ 64

.REPEAT 128
	.DB $00
.ENDR

SRC_Palettes_Sprites_Gallery:
.INCBIN "gfx/tantalus/fennec2.pal"
.INCBIN "gfx/tantalus/fox2.pal"
.INCBIN "gfx/tantalus/wolf1.pal"
.INCBIN "gfx/tantalus/wolf2.pal"
.INCBIN "gfx/tantalus/wolfclawblack.pal"



; ***************************** Logo data ******************************

GFX_Logo:
.INCBIN LOGO								; XXX bytes

SRC_Palette_Logo:
.INCBIN LOGO_PAL							; 512 bytes

SRC_Tilemap_Logo:
;.INCBIN LOGO_MAP							; 2048 bytes

.DEFINE SkipTileNo -2							; "deinterleave" tile maps output by gfx2snes

.REPEAT 1024
	.REDEFINE SkipTileNo SkipTileNo+2				; SkipTileNo += 2
	.INCBIN LOGO_MAP SKIP SkipTileNo READ 1				; read even (low) bytes of tilemap
.ENDR

;SRC_Tilemap_LogoHi:
;.REDEFINE SkipTileNo -1

;.REPEAT 1024
;	.REDEFINE SkipTileNo SkipTileNo+2
;	.INCBIN LOGO_MAP SKIP SkipTileNo READ 1				; read odd (high) bytes of tilemap
;.ENDR



; ***************************** Area data ******************************

GFX_Area000:
.INCBIN "gfx/area-000-chessbd.pic"

SRC_Palette_Area000:
.INCBIN "gfx/area-000-chessbd.pal"

SRC_TileMapBG1_Area000:
.INCBIN "gfx/area-000-chessbd.map"

GFX_Area001:
.INCBIN "gfx/area-001-sandbox2.pic"

SRC_Palette_Area001:
.INCBIN "gfx/area-001-sandbox2.pal"

SRC_TileMapBG1_Area001:
.INCBIN "gfx/area-001-sandbox2.map"

GFX_Area003:
.INCBIN "gfx/area-003-green.pic"

SRC_Palette_Area003:
.INCBIN "gfx/area-003-green.pal" READ 32

SRC_TileMapBG1_Area003:
.INCBIN "gfx/area-003-green.map"

;.REDEFINE SkipTileNo -2						; "deinterleave" tile maps output by gfx2snes

;.REPEAT 2048
;	.REDEFINE SkipTileNo SkipTileNo+2				; SkipTileNo += 2
;	.INCBIN "gfx/area-003-green.map" SKIP SkipTileNo READ 1		; read even bytes
;.ENDR

;SRC_TileMap_Area003Hi:
;.REDEFINE SkipTileNo -1

;.REPEAT 2048
;	.REDEFINE SkipTileNo SkipTileNo+2
;	.INCBIN "gfx/area-003-green.map" SKIP SkipTileNo READ 1		; read odd bytes
;.ENDR



; ************************* GFX pointer tables *************************

PTR_CharPortraitGFX:
	.DW 0								; dummy pointer (needed for correct table index)
	.DW GFX_Portrait_Hero1
	.DW GFX_Portrait_Hero2
	.DW GFX_Portrait_Hero3
	.DW GFX_Portrait_Hero4

PTR_CharPortraitPalette:
	.DW 0								; ditto
	.DW SRC_Palette_Portrait_Hero1
	.DW SRC_Palette_Portrait_Hero2
	.DW SRC_Palette_Portrait_Hero3
	.DW SRC_Palette_Portrait_Hero4



; ******************************** EOF *********************************
