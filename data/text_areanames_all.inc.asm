;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** AREA NAMES (ALL LANGUAGES) ***
;
;==========================================================================================



; *************************** Text pointers ****************************

PTR_AreaNames:
	.DW PTR_AreaNamesEng
	.DW PTR_AreaNamesGer



PTR_AreaNamesEng:
	.DW STR_AreaNameEng000
	.DW STR_AreaNameEng001
	.DW STR_AreaNameEng002



PTR_AreaNamesGer:
	.DW STR_AreaNameGer000
	.DW STR_AreaNameGer001
	.DW STR_AreaNameGer002



; ************************** Area names (Eng) **************************

STR_AreaNameEng000:
	.STRINGMAP HUD, "Chessboard<END>"

STR_AreaNameEng001:
	.STRINGMAP HUD, "Sandbox<END>"

STR_AreaNameEng002:
	.STRINGMAP HUD, "Temba’s Forest<END>"



; ************************** Area names (Ger) **************************

STR_AreaNameGer000:
	.STRINGMAP HUD, "Schachbrett<END>"

STR_AreaNameGer001:
	.STRINGMAP HUD, "Sandkasten<END>"

STR_AreaNameGer002:
	.STRINGMAP HUD, "Tembas Wäldchen<END>"



; ******************************** EOF *********************************
