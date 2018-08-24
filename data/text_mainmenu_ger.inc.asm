;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
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
;.DEFINE SYM_mult	$89						; multiplication sign



; *************************** Text pointers ****************************

PTR_RingMenuHeadGer:
	.DW STR_RingMenuItemGer00
	.DW STR_RingMenuItemGer20
	.DW STR_RingMenuItemGer40
	.DW STR_RingMenuItemGer60
	.DW STR_RingMenuItemGer80
	.DW STR_RingMenuItemGerA0
	.DW STR_RingMenuItemGerC0
	.DW STR_RingMenuItemGerE0



PTR_MainMenuTextGer:
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

STR_RingMenuItemGer00:
	.DB " Einstellungen  ", 0

STR_RingMenuItemGer20:
	.DB " Spiel beenden  ", 0

STR_RingMenuItemGer40:
	.DB "      ???1      ", 0

STR_RingMenuItemGer60:
	.DB "      ???2      ", 0

STR_RingMenuItemGer80:
	.DB "    Inventar    ", 0

STR_RingMenuItemGerA0:
	.DB "     Talent     ", 0

STR_RingMenuItemGerC0:
	.DB "     Gruppe     ", 0

STR_RingMenuItemGerE0:
	.DB " Lilys Logbuch  ", 0

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



STR_SubMenuInventoryGer000:
	.DB "Refreshments            "

STR_SubMenuInventoryGer001:
	.DB "First-aid supplies      "

STR_SubMenuInventoryGer002:
	.DB "Food                    "

STR_SubMenuInventoryGer003:
	.DB "Weapons                 "

STR_SubMenuInventoryGer004:
	.DB "Short-range             "

STR_SubMenuInventoryGer005:
	.DB "Long-range              "

STR_SubMenuInventoryGer006:
	.DB "Armor                   "

STR_SubMenuInventoryGer007:
	.DB "Accessories             "

STR_SubMenuInventoryGer008:
	.DB "Battle Items            "

STR_SubMenuInventoryGer009:
	.DB "Attack Items            "

STR_SubMenuInventoryGer010:
	.DB "Defense Items           "

STR_SubMenuInventoryGer011:
	.DB "Treasure                "

STR_SubMenuInventoryGer012:
	.DB "Unappraised             "

STR_SubMenuInventoryGer013:
	.DB "Key Items               "



; ******************************** EOF *********************************
