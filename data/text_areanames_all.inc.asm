;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA NAMES (ALL LANGUAGES) ***
;
;==========================================================================================



; ******************************* Notes ********************************

; For a list of available special character aliases, see
; lib_variables.asm.



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
