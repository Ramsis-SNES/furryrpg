; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	MISC. TEXT (GERMAN/DEU)
;
; ==================================================================================================



; AREA NAMES
; --------------------------------------------------------------------------------------------------

SRC_AreaNamesDEU:

.REPEAT 3 INDEX COUNT
	.DW STR_AreaNameDEU{%.3d{COUNT}}				; create pointers for German area names
.ENDR

.REDEFINE COUNT = 0

	ar_name	kLangDEU, "Schachbrett<END>"
	ar_name	kLangDEU, "Sandkasten<END>"
	ar_name	kLangDEU, "Tembas Wäldchen<END>"



; CHAPTER NAMES
; --------------------------------------------------------------------------------------------------

SRC_ChapterNamesDEU:

.REPEAT 4 INDEX COUNT
	.DW STR_ChapterNameDEU{%.3d{COUNT}}				; create pointers for German chapter names
.ENDR



STR_ChapterNameDEU000:
	.DB "PROLOG", 0

STR_ChapterNameDEU001:
	.DB "KAPITEL 1", 0

STR_ChapterNameDEU002:
	.DB "KAPITEL 2", 0

STR_ChapterNameDEU003:
	.DB "KAPITEL 3", 0



; ITEM NAMES
; --------------------------------------------------------------------------------------------------

STR_ItemsDEU:								; cf. STR_ItemsENG
	.DB "Item000000000000"
	.DB "Item000000000001"
	.DB "Item000000000002"
	.DB "Item000000000003"
	.DB "Item000000000004"
	.DB "Item000000000005"
	.DB "Item000000000006"
	.DB "Item000000000007"
	.DB "Item000000000008"
	.DB "Item000000000009"
	.DB "Item000000000010"
	.DB "Item000000000011"
	.DB "Item000000000012"
	.DB "Item000000000013"
	.DB "Item000000000014"
	.DB "Item000000000015"
	.DB "Item000000000016"
	.DB "Item000000000017"
	.DB "Item000000000018"
	.DB "Item000000000019"
	.DB "Item000000000020"
	.DB "Item000000000021"
	.DB "Item000000000022"
	.DB "Item000000000023"
	.DB "Item000000000024"
	.DB "Item000000000025"
	.DB "Item000000000026"
	.DB "Item000000000027"
	.DB "Item000000000028"
	.DB "Item000000000029"
	.DB "Item000000000030"
	.DB "Item000000000031"
	.DB "Item000000000032"
	.DB "Item000000000033"
	.DB "Item000000000034"
	.DB "Item000000000035"
	.DB "Item000000000036"
	.DB "Item000000000037"
	.DB "Item000000000038"
	.DB "Item000000000039"
	.DB "Item000000000040"
	.DB "Item000000000041"
	.DB "Item000000000042"
	.DB "Item000000000043"
	.DB "Item000000000044"
	.DB "Item000000000045"
	.DB "Item000000000046"
	.DB "Item000000000047"
	.DB "Item000000000048"
	.DB "Item000000000049"
	.DB "Item000000000050"
	.DB "Item000000000051"
	.DB "Item000000000052"
	.DB "Item000000000053"
	.DB "Item000000000054"
	.DB "Item000000000055"
	.DB "Item000000000056"
	.DB "Item000000000057"
	.DB "Item000000000058"
	.DB "Item000000000059"
	.DB "Item000000000060"
	.DB "Item000000000061"
	.DB "Item000000000062"
	.DB "Item000000000063"
	.DB "Item000000000064"
	.DB "Item000000000065"
	.DB "Item000000000066"
	.DB "Item000000000067"
	.DB "Item000000000068"
	.DB "Item000000000069"
	.DB "Item000000000070"
	.DB "Item000000000071"
	.DB "Item000000000072"
	.DB "Item000000000073"
	.DB "Item000000000074"
	.DB "Item000000000075"
	.DB "Item000000000076"
	.DB "Item000000000077"
	.DB "Item000000000078"
	.DB "Item000000000079"
	.DB "Item000000000080"
	.DB "Item000000000081"
	.DB "Item000000000082"
	.DB "Item000000000083"
	.DB "Item000000000084"
	.DB "Item000000000085"
	.DB "Item000000000086"
	.DB "Item000000000087"
	.DB "Item000000000088"
	.DB "Item000000000089"
	.DB "Item000000000090"
	.DB "Item000000000091"
	.DB "Item000000000092"
	.DB "Item000000000093"
	.DB "Item000000000094"
	.DB "Item000000000095"
	.DB "Item000000000096"
	.DB "Item000000000097"
	.DB "Item000000000098"
	.DB "Item000000000099"
	.DB "Item000000000100"
	.DB "Item000000000101"
	.DB "Item000000000102"
	.DB "Item000000000103"
	.DB "Item000000000104"
	.DB "Item000000000105"
	.DB "Item000000000106"
	.DB "Item000000000107"
	.DB "Item000000000108"
	.DB "Item000000000109"
	.DB "Item000000000110"
	.DB "Item000000000111"
	.DB "Item000000000112"
	.DB "Item000000000113"
	.DB "Item000000000114"
	.DB "Item000000000115"
	.DB "Item000000000116"
	.DB "Item000000000117"
	.DB "Item000000000118"
	.DB "Item000000000119"
	.DB "Item000000000120"
	.DB "Item000000000121"
	.DB "Item000000000122"
	.DB "Item000000000123"
	.DB "Item000000000124"
	.DB "Item000000000125"
	.DB "Item000000000126"
	.DB "Item000000000127"
	.DB "Item000000000128"
	.DB "Item000000000129"
	.DB "Item000000000130"
	.DB "Item000000000131"
	.DB "Item000000000132"
	.DB "Item000000000133"
	.DB "Item000000000134"
	.DB "Item000000000135"
	.DB "Item000000000136"
	.DB "Item000000000137"
	.DB "Item000000000138"
	.DB "Item000000000139"
	.DB "Item000000000140"
	.DB "Item000000000141"
	.DB "Item000000000142"
	.DB "Item000000000143"
	.DB "Item000000000144"
	.DB "Item000000000145"
	.DB "Item000000000146"
	.DB "Item000000000147"
	.DB "Item000000000148"
	.DB "Item000000000149"
	.DB "Item000000000150"
	.DB "Item000000000151"
	.DB "Item000000000152"
	.DB "Item000000000153"
	.DB "Item000000000154"
	.DB "Item000000000155"
	.DB "Item000000000156"
	.DB "Item000000000157"
	.DB "Item000000000158"
	.DB "Item000000000159"
	.DB "Item000000000160"
	.DB "Item000000000161"
	.DB "Item000000000162"
	.DB "Item000000000163"
	.DB "Item000000000164"
	.DB "Item000000000165"
	.DB "Item000000000166"
	.DB "Item000000000167"
	.DB "Item000000000168"
	.DB "Item000000000169"
	.DB "Item000000000170"
	.DB "Item000000000171"
	.DB "Item000000000172"
	.DB "Item000000000173"
	.DB "Item000000000174"
	.DB "Item000000000175"
	.DB "Item000000000176"
	.DB "Item000000000177"
	.DB "Item000000000178"
	.DB "Item000000000179"
	.DB "Item000000000180"
	.DB "Item000000000181"
	.DB "Item000000000182"
	.DB "Item000000000183"
	.DB "Item000000000184"
	.DB "Item000000000185"
	.DB "Item000000000186"
	.DB "Item000000000187"
	.DB "Item000000000188"
	.DB "Item000000000189"
	.DB "Item000000000190"
	.DB "Item000000000191"
	.DB "Item000000000192"
	.DB "Item000000000193"
	.DB "Item000000000194"
	.DB "Item000000000195"
	.DB "Item000000000196"
	.DB "Item000000000197"
	.DB "Item000000000198"
	.DB "Item000000000199"
	.DB "Item000000000200"
	.DB "Item000000000201"
	.DB "Item000000000202"
	.DB "Item000000000203"
	.DB "Item000000000204"
	.DB "Item000000000205"
	.DB "Item000000000206"
	.DB "Item000000000207"
	.DB "Item000000000208"
	.DB "Item000000000209"
	.DB "Item000000000210"
	.DB "Item000000000211"
	.DB "Item000000000212"
	.DB "Item000000000213"
	.DB "Item000000000214"
	.DB "Item000000000215"
	.DB "Item000000000216"
	.DB "Item000000000217"
	.DB "Item000000000218"
	.DB "Item000000000219"
	.DB "Item000000000220"
	.DB "Item000000000221"
	.DB "Item000000000222"
	.DB "Item000000000223"
	.DB "Item000000000224"
	.DB "Item000000000225"
	.DB "Item000000000226"
	.DB "Item000000000227"
	.DB "Item000000000228"
	.DB "Item000000000229"
	.DB "Item000000000230"
	.DB "Item000000000231"
	.DB "Item000000000232"
	.DB "Item000000000233"
	.DB "Item000000000234"
	.DB "Item000000000235"
	.DB "Item000000000236"
	.DB "Item000000000237"
	.DB "Item000000000238"
	.DB "Item000000000239"
	.DB "Item000000000240"
	.DB "Item000000000241"
	.DB "Item000000000242"
	.DB "Item000000000243"
	.DB "Item000000000244"
	.DB "Item000000000245"
	.DB "Item000000000246"
	.DB "Item000000000247"
	.DB "Item000000000248"
	.DB "Item000000000249"
	.DB "Item000000000250"
	.DB "Item000000000251"
	.DB "Item000000000252"
	.DB "Item000000000253"
	.DB "Item000000000254"
	.DB "Item000000000255"



; MAIN MENU TEXT
; --------------------------------------------------------------------------------------------------

SRC_MainMenuTextDEU:

.REPEAT 14 INDEX COUNT
	.DW STR_MainMenuDEU{%.3d{COUNT}}				; create pointers for German main menu stuff
.ENDR



STR_MainMenuDEU000:
	.DB "Inventar", 0

STR_MainMenuDEU001:
	.DB "Verwenden", 0

STR_MainMenuDEU002:
	.DB "Sortieren:", 0

STR_MainMenuDEU003:
	.DB "Name", 0

STR_MainMenuDEU004:
	.DB "Art", 0

STR_MainMenuDEU005:
	.DB "Reihenfolge:", 0

STR_MainMenuDEU006:
	.DB "Aufst.", 0

STR_MainMenuDEU007:
	.DB "Abst.", 0

STR_MainMenuDEU008:
	.DB "Art Objekt:", 0

STR_MainMenuDEU009:
	.DB "Nahrung", 0

STR_MainMenuDEU010:
	.DB "Waffe", 0

STR_MainMenuDEU011:
	.DB "Rüstung", 0

STR_MainMenuDEU012:
	.DB "Accessoire", 0

STR_MainMenuDEU013:
	.DB "Schätze", 0



SRC_RingMenuHeadDEU:
	.DW STR_RingMenuItemDEU00
	.DW STR_RingMenuItemDEU20
	.DW STR_RingMenuItemDEU40
	.DW STR_RingMenuItemDEU60
	.DW STR_RingMenuItemDEU80
	.DW STR_RingMenuItemDEUA0
	.DW STR_RingMenuItemDEUC0
	.DW STR_RingMenuItemDEUE0



STR_RingMenuItemDEU00:
	.DB " Einstellungen  ", 0

STR_RingMenuItemDEU20:
	.DB " Spiel beenden  ", 0

STR_RingMenuItemDEU40:
	.DB "      ???1      ", 0

STR_RingMenuItemDEU60:
	.DB "      ???2      ", 0

STR_RingMenuItemDEU80:
	.DB "    Inventar    ", 0

STR_RingMenuItemDEUA0:
	.DB "     Talent     ", 0

STR_RingMenuItemDEUC0:
	.DB "     Gruppe     ", 0

STR_RingMenuItemDEUE0:
	.DB " Lilys Logbuch  ", 0



STR_SubMenuInventoryDEU000:
	.DB "Refreshments            "

STR_SubMenuInventoryDEU001:
	.DB "First-aid supplies      "

STR_SubMenuInventoryDEU002:
	.DB "Food                    "

STR_SubMenuInventoryDEU003:
	.DB "Weapons                 "

STR_SubMenuInventoryDEU004:
	.DB "Short-range             "

STR_SubMenuInventoryDEU005:
	.DB "Long-range              "

STR_SubMenuInventoryDEU006:
	.DB "Armor                   "

STR_SubMenuInventoryDEU007:
	.DB "Accessories             "

STR_SubMenuInventoryDEU008:
	.DB "Battle Items            "

STR_SubMenuInventoryDEU009:
	.DB "Attack Items            "

STR_SubMenuInventoryDEU010:
	.DB "Defense Items           "

STR_SubMenuInventoryDEU011:
	.DB "Treasure                "

STR_SubMenuInventoryDEU012:
	.DB "Unappraised             "

STR_SubMenuInventoryDEU013:
	.DB "Key Items               "



; MISC TEXT
; --------------------------------------------------------------------------------------------------

SRC_MiscTextPointerDEU:

.REPEAT 10 INDEX COUNT
	.DW STR_MiscDEU{%.3d{COUNT}}					; create pointers for German misc. text
.ENDR



STR_MiscDEU000:
	.DB "LP", 0

STR_MiscDEU001:
	.DB "MP", 0

STR_MiscDEU002:
	.DB "Rush", 0							; FIXME

STR_MiscDEU003:
	.DB "Zeit", 0

STR_MiscDEU004:
	.DB "Ja", 0

STR_MiscDEU005:
	.DB "Nein", 0

STR_MiscDEU006:
	.DB "Okay", 0

STR_MiscDEU007:
	.DB "Fertig", 0

STR_MiscDEU008:
	.DB "Das geht nicht!", 0

STR_MiscDEU009:
	.DB "Speichern ...", 0

;STR_MiscDEU010:
;	.DB "", 0

;STR_MiscDEU011:
;	.DB "", 0

;STR_MiscDEU012:
;	.DB "", 0

;STR_MiscDEU013:
;	.DB "", 0



; EOF
