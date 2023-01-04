;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** SNESGSS SONG TRACK NAMES (ALL LANGUAGES) ***
;
;==========================================================================================



; ************************ SNESGSS track names *************************

; Track names have to consist of exactly 31 characters and a NUL termi-
; nator (32 bytes total). We use a fixed length of strings and no poin-
; ters so we don't have to worry about overwriting trailing characters
; with spaces when cycling through songs.

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



; ******************************** EOF *********************************
