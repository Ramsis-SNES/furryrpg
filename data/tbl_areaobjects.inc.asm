;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA PROPERTIES ***
;
;==========================================================================================



; *************************** Pointer table ****************************

;SRC_PointerAreaProperty:
;	.DW SRC_AreaProperty000-SRC_AreaProperties			; subtract start offset to allow zero-based calculations
;	.DW SRC_AreaProperty001-SRC_AreaProperties
;	.DW SRC_AreaProperty002-SRC_AreaProperties
;	.DW SRC_AreaProperty003-SRC_AreaProperties



; ************************** Area object data **************************

SRC_AreaObjects:

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

SRC_AreaObjects003:
	.DB 69, %01100001						; hero 1 (upper half): set "object is active," "object is hero," and "can collide with other objects" flags
	.DB 70, %01100001						; hero 1 (lower half): ditto
	.DB 128								; end of table (sprite #128 can't exist)



; ******************************** EOF *********************************
