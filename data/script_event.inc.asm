; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	EVENT CONTROL SCRIPTING CODE
;
; ==================================================================================================



.REDEFINE COUNT = 0

SRC_EventPointer:

.REPEAT 2 INDEX COUNT
	.DW Event{%.5d{COUNT}}						; create pointers for Event00000...EventXXXXX
.ENDR



Event00000:
	ev_ctrl MONITOR_INPUT_JOY1
		.DW kAllButtons						; if any button (sans Dpad) is pressed ...
		.DW @Event00000_Jump1 - Event00000			; ... advance event code pointer to @Event00000_Jump1 (zero-based)
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	ev_ctrl WAIT_FRAMES						; show discaimer wall of text
		.DW 80
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	ev_ctrl WRITE_RAM_BYTE						; enter forced blank
		.DL RAM_INIDISP
		.DB kForcedBlank
	ev_ctrl WRITE_RAM_BYTE						; set BG Mode 3
		.DL RAM_BGMODE
		.DB kBGMODE_3
	ev_ctrl WRITE_RAM_BYTE
		.DL RAM_TM						; turn on BG1 only on mainscreen ...
		.DB kTM_BG1
	ev_ctrl WRITE_RAM_BYTE
		.DL RAM_TS						; ... and subscreen
		.DB kTS_BG1
	ev_ctrl WAIT_FRAMES						; wait for reg update
		.DW 1

.IFNDEF NOMUSIC

	ev_ctrl GSS_LOAD_TRACK
		.DW 7							; CHANGEME to intro tune
;	ev_ctrl GSS_COMMAND
;		.DW kGSS_STEREO
;		.DW 1
	ev_ctrl GSS_COMMAND
		.DW kGSS_GLOBAL_VOLUME
		.DW $FF7F						; high byte = fade speed, low byte = global volume
	ev_ctrl GSS_COMMAND
		.DW kGSS_MUSIC_PLAY
		.DW 0

.ENDIF

	ev_ctrl DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_RamsisPal
		.DW 512
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_RamsisPic
		.DW _sizeof_SRC_RamsisPic
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_RamsisMap
		.DW _sizeof_SRC_RamsisMap
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	ev_ctrl WAIT_FRAMES						; show big Ramsis portrait
		.DW 150
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	ev_ctrl WRITE_RAM_BYTE
		.DL RAM_INIDISP						; enter forced blank
		.DB kForcedBlank
	ev_ctrl WAIT_FRAMES						; wait for reg update
		.DW 1
	ev_ctrl DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_RamsisPresentsPal
		.DW 512
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_RamsisPresentsPic
		.DW _sizeof_SRC_RamsisPresentsPic
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_RamsisPresentsMap
		.DW _sizeof_SRC_RamsisPresentsMap
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	ev_ctrl WAIT_FRAMES						; show "Ramsis presents" message
		.DW 150
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	ev_ctrl WRITE_RAM_BYTE
		.DL RAM_INIDISP						; enter forced blank
		.DB kForcedBlank
	ev_ctrl WAIT_FRAMES						; wait for reg update
		.DW 1
	ev_ctrl DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_StartPal
		.DW 512
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_StartPic
		.DW _sizeof_SRC_StartPic
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_StartMap
		.DW _sizeof_SRC_StartMap
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	ev_ctrl WAIT_FRAMES						; show alpha title screen
		.DW 150
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	ev_ctrl WRITE_RAM_BYTE
		.DL RAM_INIDISP						; enter forced blank
		.DB kForcedBlank
	ev_ctrl WAIT_FRAMES						; wait for reg update
		.DW 1
	ev_ctrl DMA_ROM2CGRAM						; CGRAM target address (8), ROM source address (24), size (16)
		.DB $00
		.DL SRC_SoundEnginesPal
		.DW 512
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $0000
		.DL SRC_SoundEnginesPic
		.DW _sizeof_SRC_SoundEnginesPic
	ev_ctrl DMA_ROM2VRAM						; VRAM target address (16), ROM source address (24), size (16)
		.DW $5000
		.DL SRC_SoundEnginesMap
		.DW _sizeof_SRC_SoundEnginesMap
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectSpeed2
	ev_ctrl WAIT_FRAMES						; show sound engine logos
		.DW 150

@Event00000_Jump1:
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed2
	ev_ctrl ZERO_END



Event00001:
	ev_ctrl TOGGLE_AUTO_MODE					; auto-mode on
	ev_ctrl LOAD_AREA
		.DW 2

.IFNDEF NOMUSIC

	ev_ctrl GSS_LOAD_TRACK
		.DW 12

.ENDIF

	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeFromBlack
		.DB kEffectDelay2

.IFNDEF NOMUSIC

;	ev_ctrl GSS_COMMAND
;		.DW kGSS_STEREO
;		.DW 1
	ev_ctrl GSS_COMMAND
		.DW kGSS_GLOBAL_VOLUME
		.DW $FF7F						; high byte = fade speed, low byte = global volume
	ev_ctrl GSS_COMMAND
		.DW kGSS_MUSIC_PLAY
		.DW 0
.ENDIF

	ev_ctrl WAIT_FRAMES
		.DW 10
	ev_ctrl MOVE_HERO
		.DW $48D0						; target position (y, x)
		.DB 1							; speed
	ev_ctrl WAIT_FRAMES
		.DW 50
	ev_ctrl DIALOGUE
		.DW 1							; no. of wanted dialogue string (see labels in data/text_dialog_*)
	ev_ctrl WAIT_FRAMES
		.DW 150
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	ev_ctrl WAIT_FRAMES
		.DW 210
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	ev_ctrl WAIT_FRAMES
		.DW 180
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	ev_ctrl WAIT_FRAMES
		.DW 30
	ev_ctrl MOVE_HERO
		.DW $6880						; target position (y, x)
		.DB 2							; speed
	ev_ctrl WAIT_FRAMES
		.DW 80
	ev_ctrl MOVE_HERO
		.DW $7080						; target position (y, x)
		.DB 2							; speed
	ev_ctrl WAIT_FRAMES
		.DW 10
	ev_ctrl DIALOGUE
		.DW 2							; no. of wanted dialogue string (see labels in data/text_dialog_*)
	ev_ctrl WAIT_FRAMES
		.DW 100
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	ev_ctrl WAIT_FRAMES
		.DW 130
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW kButtonA						; A button (to clear the text box after event has finished)
	ev_ctrl SIMULATE_INPUT_JOY1
		.DW 0							; clear input
	ev_ctrl WAIT_FRAMES
		.DW 100
	ev_ctrl SCR_EFFECT_TRANSITION
		.DW kEffectTypeFadeToBlack
		.DB kEffectSpeed1

.IFNDEF NOMUSIC

	ev_ctrl GSS_COMMAND
		.DW kGSS_MUSIC_STOP
		.DW 0

.ENDIF

	ev_ctrl TOGGLE_AUTO_MODE					; auto-mode off
	ev_ctrl ZERO_END



; EOF
