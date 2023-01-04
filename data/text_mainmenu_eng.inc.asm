;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** TEXT: MAIN MENU (ENGLISH) ***
;
;==========================================================================================



; ******************************* Notes ********************************

; For a list of available special character aliases, see
; lib_variables.asm.



; *************************** Text pointers ****************************

PTR_RingMenuHeadEng:
	.DW STR_RingMenuItemEng00
	.DW STR_RingMenuItemEng20
	.DW STR_RingMenuItemEng40
	.DW STR_RingMenuItemEng60
	.DW STR_RingMenuItemEng80
	.DW STR_RingMenuItemEngA0
	.DW STR_RingMenuItemEngC0
	.DW STR_RingMenuItemEngE0



PTR_MainMenuTextEng:
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

STR_RingMenuItemEng00:
	.DB "    Settings    ", 0

STR_RingMenuItemEng20:
	.DB "   Quit Game    ", 0

STR_RingMenuItemEng40:
	.DB "      ???1      ", 0

STR_RingMenuItemEng60:
	.DB "      ???2      ", 0

STR_RingMenuItemEng80:
	.DB "   Inventory    ", 0

STR_RingMenuItemEngA0:
	.DB "     Talent     ", 0

STR_RingMenuItemEngC0:
	.DB "     Party      ", 0

STR_RingMenuItemEngE0:
	.DB "   Lily's log   ", 0

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
