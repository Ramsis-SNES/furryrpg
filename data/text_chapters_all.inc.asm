;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** Chapter NAMES (ALL LANGUAGES) ***
;
;==========================================================================================



; ****************************** Defines *******************************

;.DEFINE Auml		$80						; Ä
;.DEFINE Ouml		$81						; Ö
;.DEFINE Uuml		$82						; Ü
;.DEFINE SYM_heart	$87, $88					; heart symbol
;.DEFINE SYM_mult	$89						; multiplication sign



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
