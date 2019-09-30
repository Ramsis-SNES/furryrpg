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
	.DB EC_MONITOR_INPUT_JOY1
		.DW %1111000011110000					; B, Y, Sel, Start, A, X, L, R
		.DW __Event00000_Jump1 - Event00000			; if any of those buttons are pressed, advance event code pointer to __Event00000_Jump1
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeFromBlack
		.DB CMD_EffectSpeed2
	.DB EC_WAIT_FRAMES						; show discaimer wall of text
		.DW 80
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed2
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowINIDISP & $FFFF				; enter forced blank
		.DB $80
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowBGMODE & $FFFF				; set BG Mode 3
		.DB $03
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowTM & $FFFF				; turn on BG1 only on mainscreen ...
		.DB %00000001
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowTS & $FFFF				; ... and subscreen
		.DB %00000001
	.DB EC_WAIT_FRAMES						; wait for reg update
		.DW 1
.IFNDEF NOMUSIC
	.DB EC_GSS_LOAD_TRACK
		.DW 7							; CHANGEME to intro tune
	.DB EC_GSS_TRACK_FADEIN
		.DW $00FF, $007F
	.DB EC_GSS_TRACK_PLAY
.ENDIF
	.DB EC_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_RamsisPal
		.DW 512
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL GFX_RamsisPic
		.DW _sizeof_GFX_RamsisPic
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_RamsisMap
		.DW _sizeof_SRC_RamsisMap
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeFromBlack
		.DB CMD_EffectSpeed2
	.DB EC_WAIT_FRAMES						; show big Ramsis portrait
		.DW 150
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed2
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowINIDISP & $FFFF				; enter forced blank
		.DB $80
	.DB EC_WAIT_FRAMES						; wait for reg update
		.DW 1
	.DB EC_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_RamsisPresentsPal
		.DW 512
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL GFX_RamsisPresentsPic
		.DW _sizeof_GFX_RamsisPresentsPic
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_RamsisPresentsMap
		.DW _sizeof_SRC_RamsisPresentsMap
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeFromBlack
		.DB CMD_EffectSpeed2
	.DB EC_WAIT_FRAMES						; show "Ramsis presents" message
		.DW 150
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed2
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowINIDISP & $FFFF				; enter forced blank
		.DB $80
	.DB EC_WAIT_FRAMES						; wait for reg update
		.DW 1
	.DB EC_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_StartPal
		.DW 512
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL GFX_StartPic
		.DW _sizeof_GFX_StartPic
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_StartMap
		.DW _sizeof_SRC_StartMap
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeFromBlack
		.DB CMD_EffectSpeed2
	.DB EC_WAIT_FRAMES						; show alpha title screen
		.DW 150
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed2
	.DB EC_SET_SHADOW_REGISTER
		.DW VAR_ShadowINIDISP & $FFFF				; enter forced blank
		.DB $80
	.DB EC_WAIT_FRAMES						; wait for reg update
		.DW 1
	.DB EC_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_SoundEnginesPal
		.DW 512
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL GFX_SoundEnginesPic
		.DW _sizeof_GFX_SoundEnginesPic
	.DB EC_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_SoundEnginesMap
		.DW _sizeof_SRC_SoundEnginesMap
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeFromBlack
		.DB CMD_EffectSpeed2
	.DB EC_WAIT_FRAMES						; show sound engine logos
		.DW 150
__Event00000_Jump1:
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed2
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
		.DW %0000000010000000					; A button
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
	.DB EC_SIMULATE_INPUT_JOY1
		.DW %0000000010000000					; A button (to clear the text box after event has finished)
	.DB EC_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB EC_WAIT_FRAMES
		.DW 100
	.DB EC_SCR_EFFECT_TRANSITION
		.DW EffectNoFadeToBlack
		.DB CMD_EffectSpeed1
.IFNDEF NOMUSIC
	.DB EC_GSS_TRACK_STOP
.ENDIF
	.DB EC_TOGGLE_AUTO_MODE
	.DB EC_END



; ******************************** EOF *********************************
