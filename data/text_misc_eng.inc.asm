; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	MISC. TEXT (ENGLISH/ENG)
;
; ==================================================================================================



; NOTES
; --------------------------------------------------------------------------------------------------

; For a list of available special character aliases, see variables.asm.



; AREA NAME TEXT POINTERS
; --------------------------------------------------------------------------------------------------

SRC_AreaNamesENG:

.REPEAT 3 INDEX COUNT
	.DW STR_AreaNameENG{%.3d{COUNT}}				; create pointers for English area names
.ENDR



; AREA NAMES
; --------------------------------------------------------------------------------------------------

STR_AreaNameENG000:
	.STRINGMAP HUD, "Chessboard<END>"

STR_AreaNameENG001:
	.STRINGMAP HUD, "Sandbox<END>"

STR_AreaNameENG002:
	.STRINGMAP HUD, "Temba’s Forest<END>"



; CHAPTER NAME TEXT POINTERS
; --------------------------------------------------------------------------------------------------

SRC_ChapterNameENG:

.REPEAT 4 INDEX COUNT
	.DW STR_ChapterNameENG{%.3d{COUNT}}				; create pointers for English chapter names
.ENDR



; CHAPTER NAMES
; --------------------------------------------------------------------------------------------------

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

STR_CharacterName000:
	.DB "ALEC"

STR_CharacterName001:
	.DB "LILY"

STR_CharacterName002:
	.DB "PRIMUS"

STR_CharacterName003:
	.DB "REINHOLD"

STR_CharacterName004:
	.DB "GREG"

STR_CharacterName005:
	.DB "TARA"

;STR_CharacterName006:
;	.DB ""


; ERROR CODE TEXT POINTERS
; --------------------------------------------------------------------------------------------------

SRC_ErrorCode:

.REPEAT 2 INDEX COUNT
	.DW STR_ErrorCode{%.2d{COUNT}}					; create pointers for error codes
.ENDR

.REPEAT 254
	.DW STR_ErrorCode02
.ENDR



; ERROR CODE NAMES
; --------------------------------------------------------------------------------------------------

STR_ErrorCode00:
	.DB "Corrupt ROM data", 0

STR_ErrorCode01:
	.DB "SPC700 communication timeout", 0

STR_ErrorCode02:
	.DB "Unknown", 0

; add more as needed, adjust pointer table 



; ITEM NAMES
; --------------------------------------------------------------------------------------------------

STR_ItemsENG:

STR_ItemENG000:
	.DB "1234567890123456"

STR_ItemENG001:
	.DB "Rabbit Stick    "

STR_ItemENG002:
	.DB "Leather Gloves  "

STR_ItemENG003:
	.DB "Unknown Alloy   "

STR_ItemENG004:
	.DB "Unknown Vase    "

STR_ItemENG005:
	.DB "Cold Boar Roast "

STR_ItemENG006:
	.DB "Leather Pants   "

STR_ItemENG007:
	.DB "Wolfen Fur Brush"

STR_ItemENG008:
	.DB "Emerald Brooch  "

STR_ItemENG009:
	.DB "Leoniden Paw Wax"

STR_ItemENG010:
	.DB "Linen Cape      "

STR_ItemENG011:
	.DB "Librefur Map    "

STR_ItemENG012:
	.DB "Well Water      "

STR_ItemENG013:
	.DB "Parsnip         "

STR_ItemENG014:
	.DB "Deer Bait       "

STR_ItemENG015:
	.DB "Flintstone      "

STR_ItemENG016:
	.DB "Parden Bait     "

STR_ItemENG017:
	.DB "Fleckenstein Map"

STR_ItemENG018:
	.DB "Dungeon Key     "

STR_ItemENG019:
	.DB "Wooden Flute    "

STR_ItemENG020:
	.DB "Silver Flute    "

STR_ItemENG021:
	.DB "Leo Flayer      "

STR_ItemENG022:
	.DB "Gorilla Hide    "

STR_ItemENG023:
	.DB "Dorothy         "

STR_ItemENG024:
	.DB "Fennec Ears     "

STR_ItemENG025:
	.DB "Brown Ale       "

STR_ItemENG026:
	.DB "Yo-yo           "

STR_ItemENG027:
	.DB "iiiiiiiiiiiiiiii"

STR_ItemENG028:
	.DB "abababababababab"

STR_ItemENG029:
	.DB "ngngngngngngngng"

STR_ItemENG030:
	.DB "KKKKKKKKKKKKKKKK"

STR_ItemENG031:
	.DB "Item000000000031"

STR_ItemENG032:
	.DB "Item000000000032"

STR_ItemENG033:
	.DB "Item000000000033"

STR_ItemENG034:
	.DB "Item000000000034"

STR_ItemENG035:
	.DB "Item000000000035"

STR_ItemENG036:
	.DB "Item000000000036"

STR_ItemENG037:
	.DB "Item000000000037"

STR_ItemENG038:
	.DB "Item000000000038"

STR_ItemENG039:
	.DB "Item000000000039"

STR_ItemENG040:
	.DB "Item000000000040"

STR_ItemENG041:
	.DB "Item000000000041"

STR_ItemENG042:
	.DB "Item000000000042"

STR_ItemENG043:
	.DB "Item000000000043"

STR_ItemENG044:
	.DB "Item000000000044"

STR_ItemENG045:
	.DB "Item000000000045"

STR_ItemENG046:
	.DB "Item000000000046"

STR_ItemENG047:
	.DB "Item000000000047"

STR_ItemENG048:
	.DB "Item000000000048"

STR_ItemENG049:
	.DB "Item000000000049"

STR_ItemENG050:
	.DB "Item000000000050"

STR_ItemENG051:
	.DB "Item000000000051"

STR_ItemENG052:
	.DB "Item000000000052"

STR_ItemENG053:
	.DB "Item000000000053"

STR_ItemENG054:
	.DB "Item000000000054"

STR_ItemENG055:
	.DB "Item000000000055"

STR_ItemENG056:
	.DB "Item000000000056"

STR_ItemENG057:
	.DB "Item000000000057"

STR_ItemENG058:
	.DB "Item000000000058"

STR_ItemENG059:
	.DB "Item000000000059"

STR_ItemENG060:
	.DB "Item000000000060"

STR_ItemENG061:
	.DB "Item000000000061"

STR_ItemENG062:
	.DB "Item000000000062"

STR_ItemENG063:
	.DB "Item000000000063"

STR_ItemENG064:
	.DB "Item000000000064"

STR_ItemENG065:
	.DB "Item000000000065"

STR_ItemENG066:
	.DB "Item000000000066"

STR_ItemENG067:
	.DB "Item000000000067"

STR_ItemENG068:
	.DB "Item000000000068"

STR_ItemENG069:
	.DB "Item000000000069"

STR_ItemENG070:
	.DB "Item000000000070"

STR_ItemENG071:
	.DB "Item000000000071"

STR_ItemENG072:
	.DB "Item000000000072"

STR_ItemENG073:
	.DB "Item000000000073"

STR_ItemENG074:
	.DB "Item000000000074"

STR_ItemENG075:
	.DB "Item000000000075"

STR_ItemENG076:
	.DB "Item000000000076"

STR_ItemENG077:
	.DB "Item000000000077"

STR_ItemENG078:
	.DB "Item000000000078"

STR_ItemENG079:
	.DB "Item000000000079"

STR_ItemENG080:
	.DB "Item000000000080"

STR_ItemENG081:
	.DB "Item000000000081"

STR_ItemENG082:
	.DB "Item000000000082"

STR_ItemENG083:
	.DB "Item000000000083"

STR_ItemENG084:
	.DB "Item000000000084"

STR_ItemENG085:
	.DB "Item000000000085"

STR_ItemENG086:
	.DB "Item000000000086"

STR_ItemENG087:
	.DB "Item000000000087"

STR_ItemENG088:
	.DB "Item000000000088"

STR_ItemENG089:
	.DB "Item000000000089"

STR_ItemENG090:
	.DB "Item000000000090"

STR_ItemENG091:
	.DB "Item000000000091"

STR_ItemENG092:
	.DB "Item000000000092"

STR_ItemENG093:
	.DB "Item000000000093"

STR_ItemENG094:
	.DB "Item000000000094"

STR_ItemENG095:
	.DB "Item000000000095"

STR_ItemENG096:
	.DB "Item000000000096"

STR_ItemENG097:
	.DB "Item000000000097"

STR_ItemENG098:
	.DB "Item000000000098"

STR_ItemENG099:
	.DB "Item000000000099"

STR_ItemENG100:
	.DB "Item000000000100"

STR_ItemENG101:
	.DB "Item000000000101"

STR_ItemENG102:
	.DB "Item000000000102"

STR_ItemENG103:
	.DB "Item000000000103"

STR_ItemENG104:
	.DB "Item000000000104"

STR_ItemENG105:
	.DB "Item000000000105"

STR_ItemENG106:
	.DB "Item000000000106"

STR_ItemENG107:
	.DB "Item000000000107"

STR_ItemENG108:
	.DB "Item000000000108"

STR_ItemENG109:
	.DB "Item000000000109"

STR_ItemENG110:
	.DB "Item000000000110"

STR_ItemENG111:
	.DB "Item000000000111"

STR_ItemENG112:
	.DB "Item000000000112"

STR_ItemENG113:
	.DB "Item000000000113"

STR_ItemENG114:
	.DB "Item000000000114"

STR_ItemENG115:
	.DB "Item000000000115"

STR_ItemENG116:
	.DB "Item000000000116"

STR_ItemENG117:
	.DB "Item000000000117"

STR_ItemENG118:
	.DB "Item000000000118"

STR_ItemENG119:
	.DB "Item000000000119"

STR_ItemENG120:
	.DB "Item000000000120"

STR_ItemENG121:
	.DB "Item000000000121"

STR_ItemENG122:
	.DB "Item000000000122"

STR_ItemENG123:
	.DB "Item000000000123"

STR_ItemENG124:
	.DB "Item000000000124"

STR_ItemENG125:
	.DB "Item000000000125"

STR_ItemENG126:
	.DB "Item000000000126"

STR_ItemENG127:
	.DB "Item000000000127"

STR_ItemENG128:
	.DB "Item000000000128"

STR_ItemENG129:
	.DB "Item000000000129"

STR_ItemENG130:
	.DB "Item000000000130"

STR_ItemENG131:
	.DB "Item000000000131"

STR_ItemENG132:
	.DB "Item000000000132"

STR_ItemENG133:
	.DB "Item000000000133"

STR_ItemENG134:
	.DB "Item000000000134"

STR_ItemENG135:
	.DB "Item000000000135"

STR_ItemENG136:
	.DB "Item000000000136"

STR_ItemENG137:
	.DB "Item000000000137"

STR_ItemENG138:
	.DB "Item000000000138"

STR_ItemENG139:
	.DB "Item000000000139"

STR_ItemENG140:
	.DB "Item000000000140"

STR_ItemENG141:
	.DB "Item000000000141"

STR_ItemENG142:
	.DB "Item000000000142"

STR_ItemENG143:
	.DB "Item000000000143"

STR_ItemENG144:
	.DB "Item000000000144"

STR_ItemENG145:
	.DB "Item000000000145"

STR_ItemENG146:
	.DB "Item000000000146"

STR_ItemENG147:
	.DB "Item000000000147"

STR_ItemENG148:
	.DB "Item000000000148"

STR_ItemENG149:
	.DB "Item000000000149"

STR_ItemENG150:
	.DB "Item000000000150"

STR_ItemENG151:
	.DB "Item000000000151"

STR_ItemENG152:
	.DB "Item000000000152"

STR_ItemENG153:
	.DB "Item000000000153"

STR_ItemENG154:
	.DB "Item000000000154"

STR_ItemENG155:
	.DB "Item000000000155"

STR_ItemENG156:
	.DB "Item000000000156"

STR_ItemENG157:
	.DB "Item000000000157"

STR_ItemENG158:
	.DB "Item000000000158"

STR_ItemENG159:
	.DB "Item000000000159"

STR_ItemENG160:
	.DB "Item000000000160"

STR_ItemENG161:
	.DB "Item000000000161"

STR_ItemENG162:
	.DB "Item000000000162"

STR_ItemENG163:
	.DB "Item000000000163"

STR_ItemENG164:
	.DB "Item000000000164"

STR_ItemENG165:
	.DB "Item000000000165"

STR_ItemENG166:
	.DB "Item000000000166"

STR_ItemENG167:
	.DB "Item000000000167"

STR_ItemENG168:
	.DB "Item000000000168"

STR_ItemENG169:
	.DB "Item000000000169"

STR_ItemENG170:
	.DB "Item000000000170"

STR_ItemENG171:
	.DB "Item000000000171"

STR_ItemENG172:
	.DB "Item000000000172"

STR_ItemENG173:
	.DB "Item000000000173"

STR_ItemENG174:
	.DB "Item000000000174"

STR_ItemENG175:
	.DB "Item000000000175"

STR_ItemENG176:
	.DB "Item000000000176"

STR_ItemENG177:
	.DB "Item000000000177"

STR_ItemENG178:
	.DB "Item000000000178"

STR_ItemENG179:
	.DB "Item000000000179"

STR_ItemENG180:
	.DB "Item000000000180"

STR_ItemENG181:
	.DB "Item000000000181"

STR_ItemENG182:
	.DB "Item000000000182"

STR_ItemENG183:
	.DB "Item000000000183"

STR_ItemENG184:
	.DB "Item000000000184"

STR_ItemENG185:
	.DB "Item000000000185"

STR_ItemENG186:
	.DB "Item000000000186"

STR_ItemENG187:
	.DB "Item000000000187"

STR_ItemENG188:
	.DB "Item000000000188"

STR_ItemENG189:
	.DB "Item000000000189"

STR_ItemENG190:
	.DB "Item000000000190"

STR_ItemENG191:
	.DB "Item000000000191"

STR_ItemENG192:
	.DB "Item000000000192"

STR_ItemENG193:
	.DB "Item000000000193"

STR_ItemENG194:
	.DB "Item000000000194"

STR_ItemENG195:
	.DB "Item000000000195"

STR_ItemENG196:
	.DB "Item000000000196"

STR_ItemENG197:
	.DB "Item000000000197"

STR_ItemENG198:
	.DB "Item000000000198"

STR_ItemENG199:
	.DB "Item000000000199"

STR_ItemENG200:
	.DB "Item000000000200"

STR_ItemENG201:
	.DB "Item000000000201"

STR_ItemENG202:
	.DB "Item000000000202"

STR_ItemENG203:
	.DB "Item000000000203"

STR_ItemENG204:
	.DB "Item000000000204"

STR_ItemENG205:
	.DB "Item000000000205"

STR_ItemENG206:
	.DB "Item000000000206"

STR_ItemENG207:
	.DB "Item000000000207"

STR_ItemENG208:
	.DB "Item000000000208"

STR_ItemENG209:
	.DB "Item000000000209"

STR_ItemENG210:
	.DB "Item000000000210"

STR_ItemENG211:
	.DB "Item000000000211"

STR_ItemENG212:
	.DB "Item000000000212"

STR_ItemENG213:
	.DB "Item000000000213"

STR_ItemENG214:
	.DB "Item000000000214"

STR_ItemENG215:
	.DB "Item000000000215"

STR_ItemENG216:
	.DB "Item000000000216"

STR_ItemENG217:
	.DB "Item000000000217"

STR_ItemENG218:
	.DB "Item000000000218"

STR_ItemENG219:
	.DB "Item000000000219"

STR_ItemENG220:
	.DB "Item000000000220"

STR_ItemENG221:
	.DB "Item000000000221"

STR_ItemENG222:
	.DB "Item000000000222"

STR_ItemENG223:
	.DB "Item000000000223"

STR_ItemENG224:
	.DB "Item000000000224"

STR_ItemENG225:
	.DB "Item000000000225"

STR_ItemENG226:
	.DB "Item000000000226"

STR_ItemENG227:
	.DB "Item000000000227"

STR_ItemENG228:
	.DB "Item000000000228"

STR_ItemENG229:
	.DB "Item000000000229"

STR_ItemENG230:
	.DB "Item000000000230"

STR_ItemENG231:
	.DB "Item000000000231"

STR_ItemENG232:
	.DB "Item000000000232"

STR_ItemENG233:
	.DB "Item000000000233"

STR_ItemENG234:
	.DB "Item000000000234"

STR_ItemENG235:
	.DB "Item000000000235"

STR_ItemENG236:
	.DB "Item000000000236"

STR_ItemENG237:
	.DB "Item000000000237"

STR_ItemENG238:
	.DB "Item000000000238"

STR_ItemENG239:
	.DB "Item000000000239"

STR_ItemENG240:
	.DB "Item000000000240"

STR_ItemENG241:
	.DB "Item000000000241"

STR_ItemENG242:
	.DB "Item000000000242"

STR_ItemENG243:
	.DB "Item000000000243"

STR_ItemENG244:
	.DB "Item000000000244"

STR_ItemENG245:
	.DB "Item000000000245"

STR_ItemENG246:
	.DB "Item000000000246"

STR_ItemENG247:
	.DB "Item000000000247"

STR_ItemENG248:
	.DB "Item000000000248"

STR_ItemENG249:
	.DB "Item000000000249"

STR_ItemENG250:
	.DB "Item000000000250"

STR_ItemENG251:
	.DB "Item000000000251"

STR_ItemENG252:
	.DB "Item000000000252"

STR_ItemENG253:
	.DB "Item000000000253"

STR_ItemENG254:
	.DB "Item000000000254"

STR_ItemENG255:
	.DB "Item000000000255"



; MAIN MENU TEXT POINTERS
; --------------------------------------------------------------------------------------------------

SRC_RingMenuHeadENG:
	.DW STR_RingMenuItemENG00
	.DW STR_RingMenuItemENG20
	.DW STR_RingMenuItemENG40
	.DW STR_RingMenuItemENG60
	.DW STR_RingMenuItemENG80
	.DW STR_RingMenuItemENGA0
	.DW STR_RingMenuItemENGC0
	.DW STR_RingMenuItemENGE0



SRC_MainMenuTextENG:

.REPEAT 14 INDEX COUNT
	.DW STR_MainMenuENG{%.3d{COUNT}}				; create pointers for English main menu stuff
.ENDR



; MAIN MENU STRINGS
; --------------------------------------------------------------------------------------------------

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

STR_MainMenuENG000:
	.DB "Inventory", 0

STR_MainMenuENG001:
	.DB "Use/Equip", 0

STR_MainMenuENG002:
	.DB "Sort By:"

STR_MainMenuENG003:
	.DB "Name", 0

STR_MainMenuENG004:
	.DB "Type"

STR_MainMenuENG005:
	.DB "Order:"

STR_MainMenuENG006:
	.DB "Asc."

STR_MainMenuENG007:
	.DB "Desc."

STR_MainMenuENG008:
	.DB "Item Type:"

STR_MainMenuENG009:
	.DB "Food"

STR_MainMenuENG010:
	.DB "Weapon"

STR_MainMenuENG011:
	.DB "Armor"

STR_MainMenuENG012:
	.DB "Accessory"

STR_MainMenuENG013:
	.DB "Treasure"



; SUB-MENU STRINGS
; --------------------------------------------------------------------------------------------------

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



; MISC TEXT POINTERS
; --------------------------------------------------------------------------------------------------

SRC_MiscTextPointerENG:

.REPEAT 10 INDEX COUNT
	.DW STR_MiscENG{%.3d{COUNT}}					; create pointers for English misc. text
.ENDR



; MISC TEXT STRINGS
; --------------------------------------------------------------------------------------------------

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



; SNESGSS TRACK NAMES
; --------------------------------------------------------------------------------------------------

; Track names have to consist of exactly 31 characters and a NUL terminator (32 bytes total).
; We use a fixed length of strings and no pointers so we don't have to worry about overwriting
; trailing characters with spaces when cycling through songs.

STR_GSS_Tracks:								; track no.
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

STR_GSS_Tracks_END:



; EOF
