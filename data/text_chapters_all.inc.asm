;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** CHAPTER NAMES (ALL LANGUAGES) ***
;
;==========================================================================================



; ******************************* Notes ********************************

; For a list of available special character aliases, see
; lib_variables.asm.



; *************************** Text pointers ****************************

PTR_ChapterNameEng:
	.DW STR_ChapterNameEng000
	.DW STR_ChapterNameEng001
	.DW STR_ChapterNameEng002
	.DW STR_ChapterNameEng003



PTR_ChapterNameGer:
	.DW STR_ChapterNameGer000
	.DW STR_ChapterNameGer001
	.DW STR_ChapterNameGer002
	.DW STR_ChapterNameGer003



; ************************** Chapter names (Eng) **************************

STR_ChapterNameEng000:
	.DB "PROLOGUE", 0

STR_ChapterNameEng001:
	.DB "CHAPTER 1", 0

STR_ChapterNameEng002:
	.DB "CHAPTER 2", 0

STR_ChapterNameEng003:
	.DB "CHAPTER 3", 0



; ************************** Chapter names (Ger) **************************

STR_ChapterNameGer000:
	.DB "PROLOG", 0

STR_ChapterNameGer001:
	.DB "KAPITEL 1", 0

STR_ChapterNameGer002:
	.DB "KAPITEL 2", 0

STR_ChapterNameGer003:
	.DB "KAPITEL 3", 0



; ******************************** EOF *********************************
