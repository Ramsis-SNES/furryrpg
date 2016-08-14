;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** AREA PROPERTIES ***
;
;==========================================================================================



; *************************** Pointer table ****************************

SRC_PointerAreaProperty:
	.DW SRC_AreaProperty000-SRC_AreaProperties			; subtract start offset to allow zero-based calculations
	.DW SRC_AreaProperty001-SRC_AreaProperties
	.DW SRC_AreaProperty002-SRC_AreaProperties
	.DW SRC_AreaProperty003-SRC_AreaProperties

SRC_PointerAreaProperty_END:



; ************************* Area property data *************************

SRC_AreaProperties:

SRC_AreaProperty000:
	.DW %0000000000001101						; area properties: 64×32, x/y-scrollable
	.DW GFX_Area000							; 16-bit source address of tile data
	.DB :GFX_Area000						; source bank of tile data
	.DW GFX_Area000_END-GFX_Area000					; size of tile data
	.DW SRC_Tilemap_Area000						; 16-bit source address of tile map
	.DB :SRC_Tilemap_Area000					; source bank of tile map
	.DW SRC_Tilemap_Area000_END-SRC_Tilemap_Area000			; size of tile map
	.DW SRC_Palette_Area000						; 16-bit source address of gfx palette(s)
	.DB :SRC_Palette_Area000					; source bank of gfx palette(s)
	.DW SRC_Palette_Area000_END-SRC_Palette_Area000			; size of palette(s) (has to be a 16-bit value despite being smaller than 256 for DMA subroutine)
	.DW $FFFF							; default SNESGSS music track ($FFFF = none)
	.DW $FFFF							; default MSU1 ambient track ($FFFF = none)
	.DW STR_AreaNameEng000						; area name

SRC_AreaProperty001:
	.DW %0000000000000000						; area properties: 32×32, not scrollable
	.DW GFX_Area001
	.DB :GFX_Area001
	.DW GFX_Area001_END-GFX_Area001
	.DW SRC_Tilemap_Area001
	.DB :SRC_Tilemap_Area001
	.DW SRC_Tilemap_Area001_END-SRC_Tilemap_Area001
	.DW SRC_Palette_Area001
	.DB :SRC_Palette_Area001
	.DW SRC_Palette_Area001_END-SRC_Palette_Area001
	.DW 12								; music track: "Furlorn Village"
	.DW $FFFF							; no MSU1 ambient track
	.DW STR_AreaNameEng001

SRC_AreaProperty002:
	.DW %0000000000000101						; area properties: 64×32, x-scrollable
	.DW GFX_Area003							; FIXME, this is just a placeholder
	.DB :GFX_Area003
	.DW GFX_Area003_END-GFX_Area003
	.DW SRC_Tilemap_Area003
	.DB :SRC_Tilemap_Area003
	.DW SRC_Tilemap_Area003_END-SRC_Tilemap_Area003
	.DW SRC_Palette_Area003
	.DB :SRC_Palette_Area003
	.DW SRC_Palette_Area003_END-SRC_Palette_Area003
	.DW 10								; music track: "Temba's Theme"
	.DW 1								; MSU1 ambient track: Nightingale
	.DW STR_AreaNameEng002

SRC_AreaProperty003:
	.DW %0000000000000101						; area properties: 64×32, x-scrollable
	.DW GFX_Area003
	.DB :GFX_Area003
	.DW GFX_Area003_END-GFX_Area003
	.DW SRC_Tilemap_Area003
	.DB :SRC_Tilemap_Area003
	.DW SRC_Tilemap_Area003_END-SRC_Tilemap_Area003
	.DW SRC_Palette_Area003
	.DB :SRC_Palette_Area003
	.DW SRC_Palette_Area003_END-SRC_Palette_Area003
	.DW 10								; music track: "Temba's Theme"
	.DW 1								; MSU1 ambient track: Nightingale
	.DW STR_AreaNameEng003



; ******************************** EOF *********************************
