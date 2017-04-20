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
	.DB EC_TOGGLE_AUTO_MODE
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
		.DW 10
	.DB EC_MOVE_HERO
		.DW $48D0						; target position (y, x)
		.DB 1							; speed
	.DB EC_WAIT_FRAMES
		.DW 50
	.DB EC_DIALOG
		.DW DialogStringNo0001
	.DB EC_WAIT_FRAMES
		.DW 150
	.DB EC_SIMULATE_INPUT_JOY1
		.DW %0000000010000000					; A button
	.DB EC_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB EC_WAIT_FRAMES
		.DW 210
	.DB EC_SIMULATE_INPUT_JOY1
		.DW %0000000010000000					; A button
	.DB EC_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB EC_WAIT_FRAMES
		.DW 180
	.DB EC_SIMULATE_INPUT_JOY1
		.DW %1000000000000000					; B button
	.DB EC_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB EC_WAIT_FRAMES
		.DW 30
	.DB EC_MOVE_HERO
		.DW $6880						; target position (y, x)
		.DB 2							; speed
	.DB EC_WAIT_FRAMES
		.DW 80
	.DB EC_MOVE_HERO
		.DW $7080						; target position (y, x)
		.DB 2							; speed
	.DB EC_WAIT_FRAMES
		.DW 10
	.DB EC_DIALOG
		.DW DialogStringNo0002
	.DB EC_WAIT_FRAMES
		.DW 100
	.DB EC_SIMULATE_INPUT_JOY1
		.DW %0000000010000000					; A button
	.DB EC_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB EC_WAIT_FRAMES
		.DW 130
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed1
	.DB EC_SIMULATE_INPUT_JOY1
		.DW %1000000000000000					; B button (to clear the text box after event has finished)
	.DB EC_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
.IFNDEF NOMUSIC
	.DB EC_GSS_TRACK_STOP
.ENDIF
	.DB EC_WAIT_FRAMES
		.DW 30
	.DB EC_TOGGLE_AUTO_MODE
	.DB EC_END



; ******************************** EOF *********************************
