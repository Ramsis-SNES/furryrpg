;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** ERROR CODES ***
;
;==========================================================================================



; *************************** Text pointers ****************************

PTR_ErrorCode:
	.DW STR_ErrorCode00
	.DW STR_ErrorCode01
	.DW STR_ErrorCode02
	.DW STR_ErrorCode03



; ************************** Error code names **************************

STR_ErrorCode00:
	.DB "Illegal BRK instruction", 0

STR_ErrorCode01:
	.DB "Illegal COP instruction", 0

STR_ErrorCode02:
	.DB "Corrupt ROM data", 0

STR_ErrorCode03:
	.DB "SPC700 communication timeout", 0



; ******************************** EOF *********************************
