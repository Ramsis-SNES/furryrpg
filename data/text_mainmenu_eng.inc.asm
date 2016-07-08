;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** TEXT: MAIN MENU (ENGLISH) ***
;
;==========================================================================================



; ****************************** Defines *******************************

;.DEFINE Auml		$80						; Ä
;.DEFINE Ouml		$81						; Ö
;.DEFINE Uuml		$82						; Ü
;.DEFINE auml		$83						; ä
;.DEFINE ouml		$84						; ö
;.DEFINE uuml		$85						; ü
;.DEFINE szlig		$86						; ß
;.DEFINE SYM_heart	$87, $88					; heart symbol
;.DEFINE SYM_quot	$89						; quotation mark
;.DEFINE SYM_mult	$8A						; multiplication sign



; *************************** Item pointers ****************************

; For TextPad (with "Regular expression" checked):
; Search for  : STR_MainMenuEng...
; Replace with: STR_MainMenuEng\i{0,1,3,0}

	.DW STR_MainMenuEng000
	.DW STR_MainMenuEng001
	.DW STR_MainMenuEng002
	.DW STR_MainMenuEng003
	.DW STR_MainMenuEng004
	.DW STR_MainMenuEng005
	.DW STR_MainMenuEng006
	.DW STR_MainMenuEng007
	.DW STR_MainMenuEng008
	.DW STR_MainMenuEng009
	.DW STR_MainMenuEng010
	.DW STR_MainMenuEng011
	.DW STR_MainMenuEng012
	.DW STR_MainMenuEng013



; ****************************** Strings *******************************

STR_MainMenuEng000:
	.DB "Inventory", 0

STR_MainMenuEng001:
	.DB "Use/Equip", 0

STR_MainMenuEng002:
	.DB "Sort By:"

STR_MainMenuEng003:
	.DB "Name", 0

STR_MainMenuEng004:
	.DB "Type"

STR_MainMenuEng005:
	.DB "Order:"

STR_MainMenuEng006:
	.DB "Asc."

STR_MainMenuEng007:
	.DB "Desc."

STR_MainMenuEng008:
	.DB "Item Type:"

STR_MainMenuEng009:
	.DB "Food"

STR_MainMenuEng010:
	.DB "Weapon"

STR_MainMenuEng011:
	.DB "Armor"

STR_MainMenuEng012:
	.DB "Accessory"

STR_MainMenuEng013:
	.DB "Treasure"



; ******************************** EOF *********************************
