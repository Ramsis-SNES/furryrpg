;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA DATA ***
;
;==========================================================================================



	.DEFINE	NextAreaNamePtr		0
	.DEFINE	NextAreaObjsPtr		0				; allow zero-based calculations
	.DEFINE	NextAreaPropsPtr	0				; allow zero-based calculations



; *************************** Pointer tables ***************************

PTR_AreaObjects:

	.REPEAT 3
		.DW NextAreaObjsPtr
		.REDEFINE NextAreaObjsPtr	NextAreaObjsPtr + _sizeof_SRC_AreaObjects000	; add table size for each new pointer
	.ENDR



PTR_AreaProperties:

	.REPEAT 3
		.DW NextAreaPropsPtr
		.REDEFINE NextAreaPropsPtr	NextAreaPropsPtr + _sizeof_SRC_AreaProperties000	; add table size for each new pointer
	.ENDR



; *************************** Area meta maps ***************************

SRC_AreaMetaMap000:
.REPEAT 224
	.DB $00
.ENDR
/*
	.DB $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
*/



SRC_AreaMetaMap001:
	.DB $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80
	.DB $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80



SRC_AreaMetaMap002:
.REPEAT 512								; 64×32 (8×8) tiles, so 2048/4 meta entries (each entry represents a block of 2×2 tiles)
	.DB $00
.ENDR



; **************************** Area objects ****************************

SRC_AreaObjectsTable:

SRC_AreaObjects000:
	.DB 69, %01100001						; hero 1 (upper half): set "object is active," "object is hero," and "can collide with other objects" flags
	.DB 70, %01100001						; hero 1 (lower half): ditto
	.DB 128								; end of table (sprite #128 can't exist)

SRC_AreaObjects001:
	.DB 69, %01100001						; hero 1 (upper half): set "object is active," "object is hero," and "can collide with other objects" flags
	.DB 70, %01100001						; hero 1 (lower half): ditto
	.DB 128								; end of table (sprite #128 can't exist)

SRC_AreaObjects002:
	.DB 69, %01100001						; hero 1 (upper half): set "object is active," "object is hero," and "can collide with other objects" flags
	.DB 70, %01100001						; hero 1 (lower half): ditto
	.DB 128								; end of table (sprite #128 can't exist)



; ************************** Area properties ***************************

SRC_AreaPropertyTables:

SRC_AreaProperties000:
	.DW %0000000000001101						; area properties: 64×32, x/y-scrollable
	.DL SRC_TilesBG1_Area000					; 24-bit source address of tile data
	.DW _sizeof_SRC_TilesBG1_Area000				; size of tile data
	.DL SRC_TileMapBG1_Area000					; 24-bit source address of BG1 tilemap
	.DW _sizeof_SRC_TileMapBG1_Area000				; size of BG1 tilemap
	.DL $FFFFFF ;SRC_TileMapBG2_Area000				; 24-bit source address of BG2 tilemap ($FFFFFF = none)
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area000			; size of BG2 tilemap ($FFFF = none)
	.DL SRC_Palette_Area000						; 24-bit source address of gfx palette(s)
	.DW _sizeof_SRC_Palette_Area000					; size of palette(s) (has to be a 16-bit value despite being smaller than 256 for DMA subroutine)
	.DL SRC_AreaMetaMap000						; 24-bit source address of collision map
	.DW $FFFF							; default SNESGSS music track ($FFFF = none)
	.DW $FFFF							; default MSU1 ambient track ($FFFF = none)
	.DW NextAreaNamePtr						; no. of area name pointer
	.DW $5078							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0078							; hero map position (X)
	.DW $0050							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

	.REDEFINE	NextAreaNamePtr	NextAreaNamePtr+2		; add 2 for each new area name pointer

SRC_AreaProperties001:
	.DW %0000000000000000						; area properties: 32×32, not scrollable
	.DL SRC_TilesBG1_Area001
	.DW _sizeof_SRC_TilesBG1_Area001
	.DL SRC_TileMapBG1_Area001
	.DW _sizeof_SRC_TileMapBG1_Area001
	.DL $FFFFFF ;SRC_TileMapBG2_Area001
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area001
	.DL SRC_Palette_Area001
	.DW _sizeof_SRC_Palette_Area001
	.DL SRC_AreaMetaMap001
	.DW 12								; SNESGSS music track: "Furlorn Village"
	.DW $FF								; no MSU1 ambient track
	.DW NextAreaNamePtr
	.DW $5078							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0078							; hero map position (X)
	.DW $0050							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

	.REDEFINE	NextAreaNamePtr	NextAreaNamePtr+2

SRC_AreaProperties002:
	.DW %0000000000000101						; area properties: 64×32, x-scrollable
	.DL SRC_TilesBG1_Area002
	.DW _sizeof_SRC_TilesBG1_Area002
	.DL SRC_TileMapBG1_Area002
	.DW _sizeof_SRC_TileMapBG1_Area002
	.DL $FFFFFF ;SRC_TileMapBG2_Area002
	.DW $FFFF ;_sizeof_SRC_TileMapBG2_Area002
	.DL SRC_Palette_Area002
	.DW _sizeof_SRC_Palette_Area002
	.DL SRC_AreaMetaMap002
	.DW 10								; SNESGSS music track: "Temba's Theme"
	.DW 1								; MSU1 ambient track: Nightingale
	.DW NextAreaNamePtr
	.DW $2098							; hero screen position (low byte = X, high byte = Y, numbers refer to top left of sprite)
	.DW $0098							; hero map position (X)
	.DW $0020							; hero map position (Y)
	.DB $80								; hero sprite status: irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]

	.REDEFINE	NextAreaNamePtr	NextAreaNamePtr+2

SRC_AreaProperties00X:



; ******************************** EOF *********************************
