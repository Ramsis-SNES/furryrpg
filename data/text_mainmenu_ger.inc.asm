;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (http://manuloewe.de/)
;
;	*** TEXT: MAIN MENU (GERMAN) ***
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

	.DW STR_MainMenuGer000
	.DW STR_MainMenuGer001
	.DW STR_MainMenuGer002
	.DW STR_MainMenuGer003
	.DW STR_MainMenuGer004
	.DW STR_MainMenuGer005
	.DW STR_MainMenuGer006
	.DW STR_MainMenuGer007
	.DW STR_MainMenuGer008
	.DW STR_MainMenuGer009
	.DW STR_MainMenuGer010
	.DW STR_MainMenuGer011
	.DW STR_MainMenuGer012
	.DW STR_MainMenuGer013



; ****************************** Strings *******************************

STR_MainMenuGer000:
	.DB "Inventory", 0

STR_MainMenuGer001:
	.DB "Use/Equip", 0

STR_MainMenuGer002:
	.DB "Sort By:"

STR_MainMenuGer003:
	.DB "Name", 0

STR_MainMenuGer004:
	.DB "Type"

STR_MainMenuGer005:
	.DB "Order:"

STR_MainMenuGer006:
	.DB "Asc."

STR_MainMenuGer007:
	.DB "Desc."

STR_MainMenuGer008:
	.DB "Item Type:"

STR_MainMenuGer009:
	.DB "Food"

STR_MainMenuGer010:
	.DB "Weapon"

STR_MainMenuGer011:
	.DB "Armor"

STR_MainMenuGer012:
	.DB "Accessory"

STR_MainMenuGer013:
	.DB "Treasure"



; ******************************** EOF *********************************
