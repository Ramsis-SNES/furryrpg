;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** GRAPHICS DATA ***
;
;==========================================================================================



; ****************************** Defines *******************************

.DEFINE PORTRAIT_CHAR1		".\\gfx\\portrait_kimahri.pic"
.DEFINE PORTRAIT_CHAR1_PAL	".\\gfx\\portrait_kimahri.pal"
.DEFINE PORTRAIT_CHAR2		".\\gfx\\portrait_zakari.pic"
.DEFINE PORTRAIT_CHAR2_PAL	".\\gfx\\portrait_zakari.pal"
.DEFINE PORTRAIT_CHAR3		".\\gfx\\portrait_gengen.pic"
.DEFINE PORTRAIT_CHAR3_PAL	".\\gfx\\portrait_gengen.pal"
.DEFINE PORTRAIT_CHAR4		".\\gfx\\portrait_linkwolf.pic"
.DEFINE PORTRAIT_CHAR4_PAL	".\\gfx\\portrait_linkwolf.pal"

.DEFINE FONT_BIGSPRITES		".\\gfx\\font_sprites_big.pic"
.DEFINE FONT_BIGSPRITES_PAL	".\\gfx\\font_sprites_big.pal"

.DEFINE FONT_HUD		".\\gfx\\font_hud.pic"			; 2048 bytes
.DEFINE FONT_MODE5		".\\gfx\\font_mode5_vwf2.pic"		; 4096 bytes

.DEFINE FONT_SPRITES		".\\gfx\\font_spr.pic"

.DEFINE LOGO			".\\gfx\\logo-gr.pic"
.DEFINE LOGO_MAP		".\\gfx\\logo-gr.map"
.DEFINE LOGO_PAL		".\\gfx\\logo-gr.pal"

.DEFINE MENU_SPRITES		".\\gfx\\menu-sprites.pic"
.DEFINE MENU_SPRITES_PAL	".\\gfx\\menu-sprites.pal"

.DEFINE SPRITESHEET_CHAR1	".\\gfx\\Gengen2.pic"
.DEFINE SPRITESHEET_CHAR1_PAL	".\\gfx\\Gengen2.pal"



; ****************************** Palettes ******************************

SRC_Palettes_Text:
	.DW $0000							; background (transparent)
	.DW $0C63							; font drop shadow (dark grey)
	.DW $5EF7 ;3DEF							; font color #2 (light grey, only used by HUD font)
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

.INCBIN FONT_BIGSPRITES_PAL						; 32 bytes

SRC_Palette_Portrait_Char1:
.INCBIN PORTRAIT_CHAR1_PAL						; 32 bytes

SRC_Palette_Portrait_Char2:
.INCBIN PORTRAIT_CHAR2_PAL						; 32 bytes

SRC_Palette_Portrait_Char3:
.INCBIN PORTRAIT_CHAR3_PAL						; 32 bytes

SRC_Palette_Portrait_Char4:
.INCBIN PORTRAIT_CHAR4_PAL						; 32 bytes

SRC_Palette_Spritesheet_Char1:
.INCBIN SPRITESHEET_CHAR1_PAL						; 32 bytes

SRC_Palette_Sprites_InGameMenu:
.INCBIN MENU_SPRITES_PAL						; 32 bytes



; ************************ Font character data *************************

GFX_FontMode5:
.INCBIN FONT_MODE5							; 2bpp font for BG2 (4096 bytes)

GFX_FontHUD:
.INCBIN FONT_HUD							; 2bpp font for HUD on BG3 (2048 bytes)



; ************************ Character portraits *************************

GFX_Portrait_Char1:
.INCBIN PORTRAIT_CHAR1 READ 1920

GFX_Portrait_Char2:
.INCBIN PORTRAIT_CHAR2 READ 1920

GFX_Portrait_Char3:
.INCBIN PORTRAIT_CHAR3 READ 1920

GFX_Portrait_Char4:
.INCBIN PORTRAIT_CHAR4 READ 1920



; *********************** Sprite character data ************************

GFX_Sprites_Bigfont:
.INCBIN FONT_BIGSPRITES							; 4096 bytes

GFX_Sprites_Smallfont:
.INCBIN FONT_SPRITES							; 4096 bytes

GFX_Spritesheet_Char1:
.INCBIN SPRITESHEET_CHAR1

GFX_Sprites_InGameMenu:
.INCBIN MENU_SPRITES

GFX_Sprites_Clouds:
.INCBIN ".\\gfx\\cloud1.pic"

SRC_Palette_Clouds:
.INCBIN ".\\gfx\\cloud1.pal"

;SRC_Tilemap_Clouds:
;.INCBIN ".\\gfx\\cloud.map"



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
;.INCBIN ".\\gfx\\area-000-chessbd.pic"

SRC_Palette_Area000:
;.INCBIN ".\\gfx\\area-000-chessbd.pal"

SRC_Tilemap_Area000:
;.INCBIN ".\\gfx\\area-000-chessbd.map"



GFX_Area001:
;.INCBIN ".\\gfx\\area-001-sandbox2.pic"

SRC_Palette_Area001:
;.INCBIN ".\\gfx\\area-001-sandbox2.pal"

SRC_Tilemap_Area001:
;.INCBIN ".\\gfx\\area-001-sandbox2.map"



GFX_Area003:
.INCBIN ".\\gfx\\area-003-green.pic" SKIP 32				; gfx2snes erroneously adds 1 blank tile at the beginning

SRC_Palette_Area003:
.INCBIN ".\\gfx\\area-003-green.pal"

SRC_Tilemap_Area003:
.INCBIN ".\\gfx\\area-003-green.map"

;.REDEFINE SkipTileNo -2						; "deinterleave" tile maps output by gfx2snes

;.REPEAT 2048
;	.REDEFINE SkipTileNo SkipTileNo+2				; SkipTileNo += 2
;	.INCBIN ".\\gfx\\area-003.map" SKIP SkipTileNo READ 1		; read even bytes
;.ENDR

;SRC_Tilemap_Area003Hi:
;.REDEFINE SkipTileNo -1

;.REPEAT 2048
;	.REDEFINE SkipTileNo SkipTileNo+2
;	.INCBIN ".\\gfx\\area-003.map" SKIP SkipTileNo READ 1		; read odd bytes
;.ENDR



; ******************************** EOF *********************************
