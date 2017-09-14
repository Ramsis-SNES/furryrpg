;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MISC. TEXT (ENGLISH) ***
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

SRC_MiscTextPointerEng:
	.DW STR_MiscEng000
	.DW STR_MiscEng001
	.DW STR_MiscEng002
	.DW STR_MiscEng003
	.DW STR_MiscEng004
	.DW STR_MiscEng005
	.DW STR_MiscEng006
	.DW STR_MiscEng007
	.DW STR_MiscEng008
;	.DW STR_MiscEng009
;	.DW STR_MiscEng010
;	.DW STR_MiscEng011
;	.DW STR_MiscEng012
;	.DW STR_MiscEng013



; ****************************** Strings *******************************

STR_MiscEng000:
	.DB "HP", 0

STR_MiscEng001:
	.DB "MP", 0

STR_MiscEng002:
	.DB "Rush"							; FIXME

STR_MiscEng003:
	.DB "Time", 0

STR_MiscEng004:
	.DB "Yes"

STR_MiscEng005:
	.DB "No"

STR_MiscEng006:
	.DB "OK"

STR_MiscEng007:
	.DB "Done"

STR_MiscEng008:
	.DB "Not possible!"

;STR_MiscEng009:
;	.DB ""

;STR_MiscEng010:
;	.DB ""

;STR_MiscEng011:
;	.DB ""

;STR_MiscEng012:
;	.DB ""

;STR_MiscEng013:
;	.DB ""



; ******************************** EOF *********************************
