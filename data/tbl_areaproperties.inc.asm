;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (http://manuloewe.de/)
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
	.DW SRC_TileMapBG1_Area000					; 16-bit source address of BG1 tile map
	.DB :SRC_TileMapBG1_Area000					; source bank of BG1 tile map
	.DW SRC_TileMapBG1_Area000_END-SRC_TileMapBG1_Area000		; size of BG1 tile map
	.DW $FFFF ;SRC_TileMapBG2_Area000				; 16-bit source address of BG2 tile map ($FFFF = none)
	.DB $FF ;:SRC_TileMapBG2_Area000				; source bank of BG2 tile map ($FF = none)
	.DW $FFFF ;SRC_TileMapBG2_Area000_END-SRC_TileMapBG2_Area000	; size of BG2 tile map ($FFFF = none)
	.DW SRC_Palette_Area000						; 16-bit source address of gfx palette(s)
	.DB :SRC_Palette_Area000					; source bank of gfx palette(s)
	.DW SRC_Palette_Area000_END-SRC_Palette_Area000			; size of palette(s) (has to be a 16-bit value despite being smaller than 256 for DMA subroutine)
	.DW SRC_AreaMetaMap000						; 16-bit source address of collision map
	.DB :SRC_AreaMetaMap000						; source bank of collision map
	.DW $FFFF							; default SNESGSS music track ($FFFF = none)
	.DW $FFFF							; default MSU1 ambient track ($FFFF = none)
	.DW STR_AreaNameEng000						; area name
	.DW $5078							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0078							; hero map position (X)
	.DW $0050							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

SRC_AreaProperty001:
	.DW %0000000000000000						; area properties: 32×32, not scrollable
	.DW GFX_Area001
	.DB :GFX_Area001
	.DW GFX_Area001_END-GFX_Area001
	.DW SRC_TileMapBG1_Area001
	.DB :SRC_TileMapBG1_Area001
	.DW SRC_TileMapBG1_Area001_END-SRC_TileMapBG1_Area001
	.DW $FFFF ;SRC_TileMapBG2_Area001
	.DB $FF ;:SRC_TileMapBG2_Area001
	.DW $FFFF ;SRC_TileMapBG2_Area001_END-SRC_TileMapBG2_Area001
	.DW SRC_Palette_Area001
	.DB :SRC_Palette_Area001
	.DW SRC_Palette_Area001_END-SRC_Palette_Area001
	.DW SRC_AreaMetaMap001
	.DB :SRC_AreaMetaMap001
	.DW 12								; music track: "Furlorn Village"
	.DW $FFFF							; no MSU1 ambient track
	.DW STR_AreaNameEng001
	.DW $5078							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0078							; hero map position (X)
	.DW $0050							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

SRC_AreaProperty002:
	.DW %0000000000000101						; area properties: 64×32, x-scrollable
	.DW GFX_Area003							; FIXME, this is just a placeholder
	.DB :GFX_Area003
	.DW GFX_Area003_END-GFX_Area003
	.DW SRC_TileMapBG1_Area003
	.DB :SRC_TileMapBG1_Area003
	.DW SRC_TileMapBG1_Area003_END-SRC_TileMapBG1_Area003
	.DW $FFFF ;SRC_TileMapBG2_Area003
	.DB $FF ;:SRC_TileMapBG2_Area003
	.DW $FFFF ;SRC_TileMapBG2_Area003_END-SRC_TileMapBG2_Area003
	.DW SRC_Palette_Area003
	.DB :SRC_Palette_Area003
	.DW SRC_Palette_Area003_END-SRC_Palette_Area003
	.DW SRC_AreaMetaMap002
	.DB :SRC_AreaMetaMap002
	.DW 10								; music track: "Temba's Theme"
	.DW 1								; MSU1 ambient track: Nightingale
	.DW STR_AreaNameEng002
	.DW $2098							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0098							; hero map position (X)
	.DW $0020							; hero map position (Y)
	.DB $82								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

SRC_AreaProperty003:
	.DW %0000000000000101						; area properties: 64×32, x-scrollable
	.DW GFX_Area003
	.DB :GFX_Area003
	.DW GFX_Area003_END-GFX_Area003
	.DW SRC_TileMapBG1_Area003
	.DB :SRC_TileMapBG1_Area003
	.DW SRC_TileMapBG1_Area003_END-SRC_TileMapBG1_Area003
	.DW $FFFF ;SRC_TileMapBG2_Area003
	.DB $FF ;:SRC_TileMapBG2_Area003
	.DW $FFFF ;SRC_TileMapBG2_Area003_END-SRC_TileMapBG2_Area003
	.DW SRC_Palette_Area003
	.DB :SRC_Palette_Area003
	.DW SRC_Palette_Area003_END-SRC_Palette_Area003
	.DW SRC_AreaMetaMap003
	.DB :SRC_AreaMetaMap003
	.DW 10								; music track: "Temba's Theme"
	.DW 1								; MSU1 ambient track: Nightingale
	.DW STR_AreaNameEng003
	.DW $2098							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0098							; hero map position (X)
	.DW $0020							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]



; ******************************** EOF *********************************
