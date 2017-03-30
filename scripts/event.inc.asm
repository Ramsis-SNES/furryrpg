;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** EVENT CONTROL SCRIPTING CODE ***
;
;==========================================================================================



SRC_EventPointer:
	.DW Event00000
	.DW Event00001



Event00000:
	.DB EC_INIT_ALPHAINTRO
	.DB EC_END



Event00001:
	.DB EC_LOAD_AREA
		.DW 2
.IFNDEF NOMUSIC
	.DB EC_GSS_LOAD_TRACK
		.DW 12
.ENDIF
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeFromBlack
		.DB CMD_EffectDelay3
.IFNDEF NOMUSIC
	.DB EC_GSS_TRACK_FADEIN
		.DW $00FF, $007F
	.DB EC_GSS_TRACK_PLAY
.ENDIF
	.DB EC_WAIT_FRAMES
		.DW 20
	.DB EC_DIALOG
		.DW DialogStringNo0001
	.DB EC_WAIT_FRAMES
		.DW 20
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectDelay1
.IFNDEF NOMUSIC
	.DB EC_GSS_TRACK_STOP
.ENDIF
	.DB EC_END



; ******************************** EOF *********************************
