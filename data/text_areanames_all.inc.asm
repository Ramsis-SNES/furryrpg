;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA NAMES (ALL LANGUAGES) ***
;
;==========================================================================================



; ****************************** Defines *******************************

;.DEFINE Auml		$80						; Ä
;.DEFINE Ouml		$81						; Ö
;.DEFINE Uuml		$82						; Ü
.DEFINE HUD_auml	$1C						; ä
.DEFINE HUD_ouml	$1D						; ö
.DEFINE HUD_uuml	$1E						; ü
.DEFINE HUD_szlig	$1F						; ß
;.DEFINE SYM_heart	$87, $88					; heart symbol
;.DEFINE SYM_quot	$89						; quotation mark
;.DEFINE SYM_mult	$8A						; multiplication sign



; *************************** Text pointers ****************************

SRC_AreaNames:
	.DW SRC_AreaNamesPtrEng
	.DW SRC_AreaNamesPtrGer



SRC_AreaNamesPtrEng:
	.DW STR_AreaNameEng000
	.DW STR_AreaNameEng001
	.DW STR_AreaNameEng002
	.DW STR_AreaNameEng003



SRC_AreaNamesPtrGer:
	.DW STR_AreaNameGer000
	.DW STR_AreaNameGer001
	.DW STR_AreaNameGer002
	.DW STR_AreaNameGer003



; ************************** Area names (Eng) **************************

STR_AreaNameEng000:
	.DB "Chessboard", 0

STR_AreaNameEng001:
	.DB "Sandbox", 0

STR_AreaNameEng002:
	.DB "Alec's House", 0

STR_AreaNameEng003:
	.DB "Temba's Forest", 0



; ************************** Area names (Ger) **************************

STR_AreaNameGer000:
	.DB "Schachbrett", 0

STR_AreaNameGer001:
	.DB "Sandkasten", 0

STR_AreaNameGer002:
	.DB "Alecs Haus", 0

STR_AreaNameGer003:
	.DB "Tembas W", HUD_auml, "ldchen", 0



; ******************************** EOF *********************************
