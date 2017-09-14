;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MISC. TEXT (GERMAN) ***
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

SRC_MiscTextPointerGer:
	.DW STR_MiscGer000
	.DW STR_MiscGer001
	.DW STR_MiscGer002
	.DW STR_MiscGer003
	.DW STR_MiscGer004
	.DW STR_MiscGer005
	.DW STR_MiscGer006
	.DW STR_MiscGer007
	.DW STR_MiscGer008
;	.DW STR_MiscGer009
;	.DW STR_MiscGer010
;	.DW STR_MiscGer011
;	.DW STR_MiscGer012
;	.DW STR_MiscGer013



; ****************************** Strings *******************************

STR_MiscGer000:
	.DB "LP", 0

STR_MiscGer001:
	.DB "MP", 0

STR_MiscGer002:
	.DB "Rush"							; FIXME

STR_MiscGer003:
	.DB "Zeit", 0

STR_MiscGer004:
	.DB "Ja"

STR_MiscGer005:
	.DB "Nein"

STR_MiscGer006:
	.DB "Okay"

STR_MiscGer007:
	.DB "Fertig"

STR_MiscGer008:
	.DB "Das geht nicht!"

;STR_MiscGer009:
;	.DB ""

;STR_MiscGer010:
;	.DB ""

;STR_MiscGer011:
;	.DB ""

;STR_MiscGer012:
;	.DB ""

;STR_MiscGer013:
;	.DB ""



; ******************************** EOF *********************************
