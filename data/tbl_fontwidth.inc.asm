;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** FONT WIDTH TABLES ***
;
;==========================================================================================



; ********************** Dialog font width table ***********************

SRC_FWT_Dialog:
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8		; empty
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8		; text box border (8 tiles)
	.DB 6, 3, 6, 8, 8, 7, 8, 3, 4, 4, 8, 6, 3, 7, 3, 8		;  !"...
	.DB 7, 5, 8, 8, 8, 8, 8, 8, 8, 8, 3, 3, 6, 6, 6, 7		; 012...
	.DB 8, 8, 8, 8, 8, 7, 7, 8, 8, 5, 7, 8, 8, 8, 8, 8		; @AB...
	.DB 8, 8, 8, 8, 7, 8, 8, 8, 8, 7, 7, 4, 8, 4, 6, 8		; PQR...
	.DB 4, 8, 7, 7, 7, 7, 6, 7, 7, 3, 6, 7, 3, 8, 7, 7		; `ab...
	.DB 7, 7, 6, 7, 6, 7, 7, 8, 8, 7, 7, 5, 3, 5, 7, 8		; pqr...
	.DB 8, 8, 8, 8, 7, 7, 7, 8, 4, 7, 0, 0, 0, 0, 0, 0		; ÄÖÜ...
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

/*	This is for font_mode5_vwf2.pic
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8		; empty
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8		; text box border (8 tiles)
	.DB 6, 4, 7, 8, 8, 7, 8, 4, 5, 5, 8, 7, 3, 7, 4, 8		;  !"...
	.DB 8, 5, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 6, 7, 6, 8		; 012...
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 5, 8, 8, 8, 8, 8, 8		; @AB...
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 8, 4, 6, 7		; PQR...
	.DB 5, 8, 8, 8, 8, 8, 7, 8, 8, 5, 7, 8, 5, 8, 8, 8		; `ab...
	.DB 8, 8, 8, 8, 7, 8, 8, 8, 8, 8, 8, 5, 3, 5, 7, 8		; pqr...
	.DB 8, 8, 8, 8, 8, 8, 7, 8, 4, 7, 7, 0, 0, 0, 0, 0		; ÄÖÜ...
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
*/



; ********************** Sprite font width table ***********************

SRC_FWT_HUD:
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8		; empty sprite, text box frame
	.DB 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 5, 5, 5, 6		; empty sprite, text box frame, umlauts
	.DB 5, 2, 4, 6, 5, 5, 6, 2, 4, 4, 6, 6, 2, 5, 2, 5		;  !"...
	.DB 5, 3, 5, 5, 5, 5, 5, 5, 5, 5, 2, 2, 5, 5, 5, 5		; 012...
	.DB 8, 5, 5, 5, 5, 4, 4, 5, 5, 4, 5, 5, 4, 6, 6, 5		; @AB...
	.DB 5, 6, 5, 5, 6, 5, 5, 6, 6, 6, 5, 4, 5, 4, 6, 6		; PQR...
	.DB 3, 5, 5, 5, 5, 5, 4, 5, 5, 2, 3, 5, 2, 6, 5, 5		; `ab...
	.DB 5, 5, 4, 5, 4, 5, 5, 6, 6, 5, 5, 5, 2, 5, 5, 8		; pqr...



; ******************************** EOF *********************************
