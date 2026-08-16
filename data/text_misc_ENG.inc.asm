; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	MISC. TEXT (ENGLISH/ENG)
;
; ==================================================================================================



; AREA NAMES
; --------------------------------------------------------------------------------------------------

SRC_AreaNamesENG:

.REPEAT 3 INDEX COUNT
	.DW STR_AreaNameENG{%.3d{COUNT}}				; create pointers for English area names
.ENDR

.REDEFINE COUNT = 0

	ar_name	kLangENG, "Chessboard<END>"
	ar_name	kLangENG, "Sandbox<END>"
	ar_name	kLangENG, "Temba’s Forest<END>"



; CHAPTER NAMES
; --------------------------------------------------------------------------------------------------

SRC_ChapterNamesENG:

.REPEAT 4 INDEX COUNT
	.DW STR_ChapterNameENG{%.3d{COUNT}}				; create pointers for English chapter names
.ENDR



STR_ChapterNameENG000:
	.DB "PROLOGUE", 0

STR_ChapterNameENG001:
	.DB "CHAPTER 1", 0

STR_ChapterNameENG002:
	.DB "CHAPTER 2", 0

STR_ChapterNameENG003:
	.DB "CHAPTER 3", 0



; CHARACTER NAMES
; --------------------------------------------------------------------------------------------------

; Array of 64 names (9 characters max. + NUL terminator per name), DMAed to WRAM for new game. No
; pointers (cf. items). For easy printing, unused characters have to be zero.

SRC_CharacterNames:
	.DB "ALEC",	$00, $00, $00, $00, $00, $00
	.DB "LILY",	$00, $00, $00, $00, $00, $00
	.DB "PRIMUS",	$00, $00, $00, $00
	.DB "MICKEY",	$00, $00, $00, $00
	.DB "REINHOLD",	$00, $00
	.DB "TARA",	$00, $00, $00, $00, $00, $00
	.DB "KILIAN",	$00, $00, $00, $00
	.DB "GREG",	$00, $00, $00, $00, $00, $00
	.DB "KIT",	$00, $00, $00, $00, $00, $00, $00
	.DB "FLUFFY",	$00, $00, $00, $00
	.DB "RUBY",	$00, $00, $00, $00, $00, $00
	.DB "TEMBA",	$00, $00, $00, $00, $00
	.DB "FRIBOLIN",	$00, $00					; names from here subject to change
	.DB "VIVIAN",	$00, $00, $00, $00
	.DB "QUMAR",	$00, $00, $00, $00, $00
	.DB "DANIELLE",	$00, $00
	.DB "MAURAS",	$00, $00, $00, $00
	.DB "IMKEN",	$00, $00, $00, $00, $00
	.DB "TEDDY",	$00, $00, $00, $00, $00
	.DB "SHASTA",	$00, $00, $00, $00
	.DB "JAY",	$00, $00, $00, $00, $00, $00, $00
	.DB "GUSTAV",	$00, $00, $00, $00
	.DB "GOETZ",	$00, $00, $00, $00, $00
	.DB "RAMOUNA",	$00, $00, $00
	.DB "LISSY",	$00, $00, $00, $00, $00
	.DB "KARLA",	$00, $00, $00, $00, $00
	.DB "PAOLO",	$00, $00, $00, $00, $00
	.DB "FABIO",	$00, $00, $00, $00, $00
	.DB "TENZIN",	$00, $00, $00, $00
	.DB "MINGBO",	$00, $00, $00, $00
	.DB "ETIENNE",	$00, $00, $00
	.DB "RACHEL",	$00, $00, $00, $00
	.DB "XAVIER",	$00, $00, $00, $00
	.DB "SANDRO",	$00, $00, $00, $00
	.DB "EISFELL",	$00, $00, $00
	.DB "EISMAEL",	$00, $00, $00
	.DB "TRAUGOT",	$00, $00, $00
	.DB "SUNNY",	$00, $00, $00, $00, $00
	.DB "HIROSHI",	$00, $00, $00
	.DB "DELANEY",	$00, $00, $00
	.DB "FATIMA",	$00, $00, $00, $00
	.DB "BRUCE",	$00, $00, $00, $00, $00
	.DB "YVETA",	$00, $00, $00, $00, $00
	.DB "CHARLIE",	$00, $00, $00
	.DB "SIMON",	$00, $00, $00, $00, $00
	.DB "VYKTOR",	$00, $00, $00, $00
	.DB "PHILIPP",	$00, $00, $00
	.DB "ESTELLA",	$00, $00, $00
	.DB "SCHOULA",	$00, $00, $00
	.DB "ARMIN",	$00, $00, $00, $00, $00
	.DB "CATO",	$00, $00, $00, $00, $00, $00
	.DB "KYRIL",	$00, $00, $00, $00, $00
	.DB "JUSTIN",	$00, $00, $00, $00
	.DB "PHYLLIS",	$00, $00, $00
	.DB "COLIN",	$00, $00, $00, $00, $00
	.DB "NIKITA",	$00, $00, $00, $00
	.DB "EMERALD",	$00, $00, $00
	.DB "ULFF",	$00, $00, $00, $00, $00, $00
	.DB "ANTONIO",	$00, $00, $00
	.DB "KATRIN",	$00, $00, $00, $00
	.DB "VIRGIL",	$00, $00, $00, $00
	.DB "ORIZON",	$00, $00, $00, $00
	.DB "LUNA",	$00, $00, $00, $00, $00, $00
	.DB "WALLENWYN",	$00



; ERROR CODE NAMES
; --------------------------------------------------------------------------------------------------

SRC_ErrorCode:

.REPEAT 2 INDEX COUNT
	.DW STR_ErrorCode{%.2d{COUNT}}					; create pointers for error codes
.ENDR

.REPEAT 254
	.DW STR_ErrorCode02
.ENDR



STR_ErrorCode00:
	.DB "Corrupt ROM data", 0

STR_ErrorCode01:
	.DB "SPC700 communication timeout", 0

STR_ErrorCode02:
	.DB "Unknown", 0

; add more as needed, adjust pointer table 



; ITEM NAMES
; --------------------------------------------------------------------------------------------------

STR_ItemsENG:								; 16 bytes each, calculate item position from here (or use e.g. "item" macro to define labels in the future)
	.DB "1234567890123456"
	.DB "Rabbit Stick    "
	.DB "Leather Gloves  "
	.DB "Unknown Alloy   "
	.DB "Unknown Vase    "
	.DB "Cold Boar Roast "
	.DB "Leather Pants   "
	.DB "Wolfen Fur Brush"
	.DB "Emerald Brooch  "
	.DB "Leoniden Paw Wax"
	.DB "Linen Cape      "
	.DB "Librefur Map    "
	.DB "Well Water      "
	.DB "Parsnip         "
	.DB "Deer Bait       "
	.DB "Flintstone      "
	.DB "Parden Bait     "
	.DB "Fleckenstein Map"
	.DB "Dungeon Key     "
	.DB "Wooden Flute    "
	.DB "Silver Flute    "
	.DB "Leo Flayer      "
	.DB "Gorilla Hide    "
	.DB "Dorothy         "
	.DB "Fennec Ears     "
	.DB "Brown Ale       "
	.DB "Yo-yo           "
	.DB "iiiiiiiiiiiiiiii"
	.DB "abababababababab"
	.DB "ngngngngngngngng"
	.DB "KKKKKKKKKKKKKKKK"
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

SRC_MainMenuTextENG:

.REPEAT 14 INDEX COUNT
	.DW STR_MainMenuENG{%.3d{COUNT}}				; create pointers for English main menu stuff
.ENDR



STR_MainMenuENG000:
	.DB "Inventory", 0

STR_MainMenuENG001:
	.DB "Use/Equip", 0

STR_MainMenuENG002:
	.DB "Sort by:", 0

STR_MainMenuENG003:
	.DB "Name", 0

STR_MainMenuENG004:
	.DB "Type", 0

STR_MainMenuENG005:
	.DB "Order:", 0

STR_MainMenuENG006:
	.DB "Asc.", 0

STR_MainMenuENG007:
	.DB "Desc.", 0

STR_MainMenuENG008:
	.DB "Item Type:", 0

STR_MainMenuENG009:
	.DB "Food", 0

STR_MainMenuENG010:
	.DB "Weapon", 0

STR_MainMenuENG011:
	.DB "Armor", 0

STR_MainMenuENG012:
	.DB "Accessory", 0

STR_MainMenuENG013:
	.DB "Treasure", 0



SRC_RingMenuHeadENG:
	.DW STR_RingMenuItemENG00
	.DW STR_RingMenuItemENG20
	.DW STR_RingMenuItemENG40
	.DW STR_RingMenuItemENG60
	.DW STR_RingMenuItemENG80
	.DW STR_RingMenuItemENGA0
	.DW STR_RingMenuItemENGC0
	.DW STR_RingMenuItemENGE0



STR_RingMenuItemENG00:
	.DB "    Settings    ", 0

STR_RingMenuItemENG20:
	.DB "   Quit Game    ", 0

STR_RingMenuItemENG40:
	.DB "      ???1      ", 0

STR_RingMenuItemENG60:
	.DB "      ???2      ", 0

STR_RingMenuItemENG80:
	.DB "   Inventory    ", 0

STR_RingMenuItemENGA0:
	.DB "     Talent     ", 0

STR_RingMenuItemENGC0:
	.DB "     Party      ", 0

STR_RingMenuItemENGE0:
	.DB "   Lily's log   ", 0



STR_SubMenuInventoryENG000:
	.DB "Refreshments            "

STR_SubMenuInventoryENG001:
	.DB "First-aid supplies      "

STR_SubMenuInventoryENG002:
	.DB "Food                    "

STR_SubMenuInventoryENG003:
	.DB "Weapons                 "

STR_SubMenuInventoryENG004:
	.DB "Short-range             "

STR_SubMenuInventoryENG005:
	.DB "Long-range              "

STR_SubMenuInventoryENG006:
	.DB "Armor                   "

STR_SubMenuInventoryENG007:
	.DB "Accessories             "

STR_SubMenuInventoryENG008:
	.DB "Battle Items            "

STR_SubMenuInventoryENG009:
	.DB "Attack Items            "

STR_SubMenuInventoryENG010:
	.DB "Defense Items           "

STR_SubMenuInventoryENG011:
	.DB "Treasure                "

STR_SubMenuInventoryENG012:
	.DB "Unappraised             "

STR_SubMenuInventoryENG013:
	.DB "Key Items               "



; MISC TEXT
; --------------------------------------------------------------------------------------------------

SRC_MiscTextPointerENG:

.REPEAT 10 INDEX COUNT
	.DW STR_MiscENG{%.3d{COUNT}}					; create pointers for English misc. text
.ENDR



STR_MiscENG000:
	.DB "HP", 0

STR_MiscENG001:
	.DB "MP", 0

STR_MiscENG002:
	.DB "Rush", 0							; FIXME

STR_MiscENG003:
	.DB "Time", 0

STR_MiscENG004:
	.DB "Yes", 0

STR_MiscENG005:
	.DB "No", 0

STR_MiscENG006:
	.DB "OK", 0

STR_MiscENG007:
	.DB "Done", 0

STR_MiscENG008:
	.DB "Not possible!", 0

STR_MiscENG009:
	.DB "Saving ...", 0

;STR_MiscENG010:
;	.DB "", 0

;STR_MiscENG011:
;	.DB "", 0

;STR_MiscENG012:
;	.DB "", 0

;STR_MiscENG013:
;	.DB "", 0



; SNESGSS TRACK NAMES/INFO
; --------------------------------------------------------------------------------------------------

STR_GSS_Tracks:								; track no.

; Track names have to consist of exactly 31 characters and a NUL terminator (32 bytes total).
; We use a fixed length of strings and no pointers so we don't have to worry about overwriting
; trailing characters with spaces when cycling through songs.
	.DB "Sun, Wind, And Rain            ", 0			; #00
	.DB "Through Darkness               ", 0			; #01
	.DB "Theme Of Despair               ", 0			; #02
	.DB "Three Buskers ...              ", 0			; #03
	.DB "... And One Buffoon            ", 0			; #04
	.DB "Troubled Mind                  ", 0			; #05
	.DB "Fanfare 1                      ", 0			; #06
	.DB "Allons Ensemble!               ", 0			; #07
	.DB "Caterwauling                   ", 0			; #08
	.DB "Contemplate                    ", 0			; #09
	.DB "Temba's Theme                  ", 0			; #10
	.DB "Triumph (Beta)                 ", 0			; #11
	.DB "Furlorn Village                ", 0			; #12

STR_GSS_TrackInfo:								; track no.

; 255 characters + NUL terminator per info, order has to match the above track names list.
	.DB "    8-channel piece with rich instrumentation and custom        "	; #00
	.DB "    sample (t. bells) meant as an immersive world map theme.    "
	.DB "    The minor third shift (Emaj --> Gmaj) in the second half    "
	.DB "    leads up to a gratuitous descending fifths climax.         ", 0

	.DB "    Cave theme with custom samples (accordion, clap). It        "	; #01
	.DB "    doesn't work too well on SNESGSS, especially since the      "
	.DB "    triplet/quintuplet-ridden guitar part is completely         "
	.DB "    missing here due to technical limitations.                 ", 0

	.DB "    Alternate (and rather boring) world map theme. This         "	; #02
	.DB "    one will likely end up on the cutting room floor.           "
	.DB "                                                                "
	.DB "                                                               ", 0

	.DB "    3-voice piece I wrote as a teenager for another game        "	; #03
	.DB "    project. It's very much playable using real instruments,    "
	.DB "    in case you and your two friends are keen on trying         "
	.DB "    it out.                                                    ", 0

	.DB "    Funnily enough, this variation of the previous piece        "	; #04
	.DB "    is quite literally a joke.                                  "
	.DB "                                                                "
	.DB "                                                               ", 0

	.DB "    8-channel piece in A minor, originally written for          "	; #05
	.DB "    string orchestra. Doesn't sound too good with every-        "
	.DB "    thing that was changed due to SNESGSS's limitations,        "
	.DB "    and it's probably too long for this purpose anyway.        ", 0

	.DB "    8-channel \"long\" fanfare with two whole step shifts         "	; #06
	.DB "    and, as you probably noticed, a ton of loading time.        "
	.DB "                                                                "
	.DB "                                                               ", 0

	.DB "    Originally written for, well, an actual ensemble,           "	; #07
	.DB "    this one doesn't have much in common with the other         "
	.DB "    musical themes and ideas for this game, so it might         "
	.DB "    well be replaced later on.                                 ", 0

	.DB "    Initially a placeholder, though the instrumentation         "	; #08
	.DB "    seems to make it fit some scene of comic relief, so         "
	.DB "    who knows ...                                               "
	.DB "                                                               ", 0

	.DB "    Custom sample test (vibraphone, pan flute) using a tune     "	; #09
	.DB "    I originally wrote for guitar and solo voice/flute/         "
	.DB "    recorder. This one feels a bit out of place and will        "
	.DB "    likely be replaced at some point.                          ", 0

	.DB "    Very emotional theme in Amaj and 5/4 time for one of        "	; #10
	.DB "    the secret characters, Temba.                               "
	.DB "                                                                "
	.DB "                                                               ", 0

	.DB "    Meant as a flying airship theme or similar, though          "	; #11
	.DB "    it needs some refinement regarding both instrumentation     "
	.DB "    and composition--the return to Cmaj after the reprise       "
	.DB "    feels a bit too forced as of yet.                          ", 0

	.DB "    Light-hearted Dmaj village theme in 2/4 time                "	; #12
	.DB "    using 7-measure phrases throughout, which is                "
	.DB "    almost unheard of in the Complete Works of Ramsis(tm)       "
	.DB "    and adds to the overall playfulness of the piece.          ", 0



; EOF
