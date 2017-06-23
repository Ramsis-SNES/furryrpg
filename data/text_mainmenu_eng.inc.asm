;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
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



; *************************** Text pointers ****************************

SRC_MainMenuTextPtrEng:
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



STR_SubMenuInventoryEng000:
	.DB "Refreshments            "

STR_SubMenuInventoryEng001:
	.DB "First-aid supplies      "

STR_SubMenuInventoryEng002:
	.DB "Food                    "

STR_SubMenuInventoryEng003:
	.DB "Weapons                 "

STR_SubMenuInventoryEng004:
	.DB "Short-range             "

STR_SubMenuInventoryEng005:
	.DB "Long-range              "

STR_SubMenuInventoryEng006:
	.DB "Armor                   "

STR_SubMenuInventoryEng007:
	.DB "Accessories             "

STR_SubMenuInventoryEng008:
	.DB "Battle Items            "

STR_SubMenuInventoryEng009:
	.DB "Attack Items            "

STR_SubMenuInventoryEng010:
	.DB "Defense Items           "

STR_SubMenuInventoryEng011:
	.DB "Treasure                "

STR_SubMenuInventoryEng012:
	.DB "Unappraised             "

STR_SubMenuInventoryEng013:
	.DB "Key Items               "



; ******************************** EOF *********************************
