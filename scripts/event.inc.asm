;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** EVENT CONTROL SCRIPTING CODE ***
;
;==========================================================================================



SRC_EventPointer:
	.DW Event00000
	.DW Event00001



Event00000:
	.DB evc_MONITOR_INPUT_JOY1
		.DW kAllButtons						; if any button (sans Dpad) is pressed ...
		.DW @Event00000_Jump1 - Event00000			; ... advance event code pointer to @Event00000_Jump1 (zero-based)
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	.DB evc_WAIT_FRAMES						; show discaimer wall of text
		.DW 80
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	.DB evc_WRITE_RAM_BYTE						; enter forced blank
		.DL RAM_INIDISP
		.DB $80
	.DB evc_WRITE_RAM_BYTE						; set BG Mode 3
		.DL RAM_BGMODE
		.DB $03
	.DB evc_WRITE_RAM_BYTE
		.DL RAM_TM						; turn on BG1 only on mainscreen ...
		.DB %00000001
	.DB evc_WRITE_RAM_BYTE
		.DL RAM_TS						; ... and subscreen
		.DB %00000001
	.DB evc_WAIT_FRAMES						; wait for reg update
		.DW 1

	.IFNDEF NOMUSIC
		.DB evc_GSS_LOAD_TRACK
			.DW 7						; CHANGEME to intro tune
;		.DB evc_GSS_COMMAND
;			.DW kGSS_STEREO
;			.DW 1
		.DB evc_GSS_COMMAND
			.DW kGSS_GLOBAL_VOLUME
			.DW $FF7F					; high byte = fade speed, low byte = global volume
		.DB evc_GSS_COMMAND
			.DW kGSS_MUSIC_PLAY
			.DW 0
	.ENDIF

	.DB evc_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_RamsisPal
		.DW 512
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_RamsisPic
		.DW _sizeof_SRC_RamsisPic
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_RamsisMap
		.DW _sizeof_SRC_RamsisMap
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	.DB evc_WAIT_FRAMES						; show big Ramsis portrait
		.DW 150
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	.DB evc_WRITE_RAM_BYTE
		.DL RAM_INIDISP						; enter forced blank
		.DB $80
	.DB evc_WAIT_FRAMES						; wait for reg update
		.DW 1
	.DB evc_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_RamsisPresentsPal
		.DW 512
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_RamsisPresentsPic
		.DW _sizeof_SRC_RamsisPresentsPic
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_RamsisPresentsMap
		.DW _sizeof_SRC_RamsisPresentsMap
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	.DB evc_WAIT_FRAMES						; show "Ramsis presents" message
		.DW 150
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	.DB evc_WRITE_RAM_BYTE
		.DL RAM_INIDISP						; enter forced blank
		.DB $80
	.DB evc_WAIT_FRAMES						; wait for reg update
		.DW 1
	.DB evc_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_StartPal
		.DW 512
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_StartPic
		.DW _sizeof_SRC_StartPic
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_StartMap
		.DW _sizeof_SRC_StartMap
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	.DB evc_WAIT_FRAMES						; show alpha title screen
		.DW 150
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	.DB evc_WRITE_RAM_BYTE
		.DL RAM_INIDISP						; enter forced blank
		.DB $80
	.DB evc_WAIT_FRAMES						; wait for reg update
		.DW 1
	.DB evc_DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_SoundEnginesPal
		.DW 512
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_SoundEnginesPic
		.DW _sizeof_SRC_SoundEnginesPic
	.DB evc_DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_SoundEnginesMap
		.DW _sizeof_SRC_SoundEnginesMap
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	.DB evc_WAIT_FRAMES						; show sound engine logos
		.DW 150
@Event00000_Jump1:
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	.DB evc_00_END



Event00001:
	.DB evc_TOGGLE_AUTO_MODE					; auto-mode on
	.DB evc_LOAD_AREA
		.DW 2

	.IFNDEF NOMUSIC
		.DB evc_GSS_LOAD_TRACK
			.DW 12
	.ENDIF

	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectDelay2

	.IFNDEF NOMUSIC
;		.DB evc_GSS_COMMAND
;			.DW kGSS_STEREO
;			.DW 1
		.DB evc_GSS_COMMAND
			.DW kGSS_GLOBAL_VOLUME
			.DW $FF7F					; high byte = fade speed, low byte = global volume
		.DB evc_GSS_COMMAND
			.DW kGSS_MUSIC_PLAY
			.DW 0
	.ENDIF

	.DB evc_WAIT_FRAMES
		.DW 10
	.DB evc_MOVE_HERO
		.DW $48D0						; target position (y, x)
		.DB 1							; speed
	.DB evc_WAIT_FRAMES
		.DW 50
	.DB evc_DIALOG
		.DW 1							; no. of wanted dialogue string (see labels in data/text_dialog_*)
	.DB evc_WAIT_FRAMES
		.DW 150
	.DB evc_SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	.DB evc_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB evc_WAIT_FRAMES
		.DW 210
	.DB evc_SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	.DB evc_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB evc_WAIT_FRAMES
		.DW 180
	.DB evc_SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	.DB evc_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB evc_WAIT_FRAMES
		.DW 30
	.DB evc_MOVE_HERO
		.DW $6880						; target position (y, x)
		.DB 2							; speed
	.DB evc_WAIT_FRAMES
		.DW 80
	.DB evc_MOVE_HERO
		.DW $7080						; target position (y, x)
		.DB 2							; speed
	.DB evc_WAIT_FRAMES
		.DW 10
	.DB evc_DIALOG
		.DW 2							; no. of wanted dialogue string (see labels in data/text_dialog_*)
	.DB evc_WAIT_FRAMES
		.DW 100
	.DB evc_SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	.DB evc_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB evc_WAIT_FRAMES
		.DW 130
	.DB evc_SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button (to clear the text box after event has finished)
	.DB evc_SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	.DB evc_WAIT_FRAMES
		.DW 100
	.DB evc_SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed1

	.IFNDEF NOMUSIC
		.DB evc_GSS_COMMAND
			.DW kGSS_MUSIC_STOP
			.DW 0
	.ENDIF

	.DB evc_TOGGLE_AUTO_MODE					; auto-mode off
	.DB evc_00_END



; ******************************** EOF *********************************
