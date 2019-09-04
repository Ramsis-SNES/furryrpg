;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA PROPERTIES ***
;
;==========================================================================================



; *************************** Pointer table ****************************

PTR_AreaProperty:
	.DW SRC_AreaProperty000-SRC_AreaProperties			; subtract start offset to allow zero-based calculations
	.DW SRC_AreaProperty001-SRC_AreaProperties
	.DW SRC_AreaProperty002-SRC_AreaProperties
	.DW SRC_AreaProperty003-SRC_AreaProperties



; ************************* Area property data *************************

SRC_AreaProperties:

SRC_AreaProperty000:
	.DW %0000000000001101						; area properties: 64×32, x/y-scrollable
	.DL GFX_Area000							; 24-bit source address of tile data
	.DW _sizeof_GFX_Area000						; size of tile data
	.DL SRC_TileMapBG1_Area000					; 24-bit source address of BG1 tile map
	.DW _sizeof_SRC_TileMapBG1_Area000				; size of BG1 tile map
	.DL $FFFFFF ;SRC_TileMapBG2_Area000				; 24-bit source address of BG2 tile map ($FFFFFF = none)
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area000			; size of BG2 tile map ($FFFF = none)
	.DL SRC_Palette_Area000						; 24-bit source address of gfx palette(s)
	.DW _sizeof_SRC_Palette_Area000					; size of palette(s) (has to be a 16-bit value despite being smaller than 256 for DMA subroutine)
	.DL SRC_AreaMetaMap000						; 24-bit source address of collision map
	.DW $FFFF							; default SNESGSS music track ($FFFF = none)
	.DW $FFFF							; default MSU1 ambient track ($FFFF = none)
	.DW 0								; no. of area name pointer
	.DW $5078							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0078							; hero map position (X)
	.DW $0050							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

SRC_AreaProperty001:
	.DW %0000000000000000						; area properties: 32×32, not scrollable
	.DL GFX_Area001
	.DW _sizeof_GFX_Area001
	.DL SRC_TileMapBG1_Area001
	.DW _sizeof_SRC_TileMapBG1_Area001
	.DL $FFFFFF ;SRC_TileMapBG2_Area001
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area001
	.DL SRC_Palette_Area001
	.DW _sizeof_SRC_Palette_Area001
	.DL SRC_AreaMetaMap001
	.DW 12								; music track: "Furlorn Village"
	.DW $FFFF							; no MSU1 ambient track
	.DW 1
	.DW $5078							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0078							; hero map position (X)
	.DW $0050							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

SRC_AreaProperty002:
	.DW %0000000000000000						; area properties: 32×32, not scrollable
	.DL GFX_Area002
	.DW _sizeof_GFX_Area002
	.DL SRC_TileMapBG1_Area002
	.DW _sizeof_SRC_TileMapBG1_Area002
	.DL $FFFFFF ;SRC_TileMapBG2_Area002
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area002
	.DL SRC_Palette_Area002
	.DW _sizeof_SRC_Palette_Area002
	.DL SRC_AreaMetaMap002
	.DW $FFFF							; music track: none
	.DW $FFFF							; MSU1 ambient track: none
	.DW 2
	.DW $20D0							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $00D0							; hero map position (X)
	.DW $0020							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

SRC_AreaProperty003:
	.DW %0000000000000101						; area properties: 64×32, x-scrollable
	.DL GFX_Area003
	.DW _sizeof_GFX_Area003
	.DL SRC_TileMapBG1_Area003
	.DW _sizeof_SRC_TileMapBG1_Area003
	.DL $FFFFFF ;SRC_TileMapBG2_Area003
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area003
	.DL SRC_Palette_Area003
	.DW _sizeof_SRC_Palette_Area003
	.DL SRC_AreaMetaMap003
	.DW 10								; music track: "Temba's Theme"
	.DW 1								; MSU1 ambient track: Nightingale
	.DW 3
	.DW $2098							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0098							; hero map position (X)
	.DW $0020							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]



; ******************************** EOF *********************************
