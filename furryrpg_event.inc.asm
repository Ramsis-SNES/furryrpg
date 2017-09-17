;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** EVENT HANDLER ***
;
;==========================================================================================



.ACCU 16
.INDEX 16

LoadEvent:								; expects valid event no. in 16-bit Accu
	asl	a
	tax
	lda.l	SRC_EventPointer, x					; load start of event code
	sta	DP_EventCodeAddress
	stz	DP_EventCodePointer					; reset code pointer

	Accu8

	lda	#:SRC_EventPointer					; set bank
	sta	DP_EventCodeBank
	stz	DP_EventControl						; clear all event control bits



; -------------------------- process event script
ProcessEventLoop:
	ldx	DP_EventWaitFrames					; check if we need to enter main loop (i.e., for screen elements to catch up, read joypads etc.)
	bne	__ProcessEventSubLoop
	jmp	__ProcessEventContinue

__ProcessEventSubLoop:
	WaitFrames	1

	lda	DP_EventControl						; check if we need to monitor joypad 1
	and	#%00000001
	beq	__PESL_Joy1Done

	Accu16								; yes, check buttons

	lda	DP_Joy1New
	and	DP_EventMonitorJoy1
	beq	+

	lda	DP_EventCodeJump					; button pressed, set new event code position
	sta	DP_EventCodePointer
	stz	DP_EventWaitFrames					; reset frame counter so event processing continues immediately

	Accu8

	bra	__ProcessEventContinue

+	Accu8

__PESL_Joy1Done:

	lda	DP_TextBoxStatus					; check if text box is open
	and	#%00000010
	beq	+

	jsr	MainTextBoxLoop						; yes, go to subroutine

+	lda	DP_Char1ScreenPosYX+1					; check if hero should be moved vertically
	sec
	sbc	VAR_Char1TargetScrPosYX+1
	beq	__PESL_MoveHeroNextCheck
	bcc	__PESL_MoveHeroDown

__PESL_MoveHeroUp:
	Accu16

	lda	DP_Char1ScreenPosYX
	ldx	DP_Char1WalkingSpd
-	sec
	sbc	#$0100							; Y -= 1
	dex								; as many times as DP_Char1WalkingSpd
	bne	-
	sta	DP_Char1ScreenPosYX
	lda	#TBL_Char1_up
	bra	__PESL_MoveHeroDone

__PESL_MoveHeroDown:
	Accu16

	lda	DP_Char1WalkingSpd					; area not scrollable, move hero sprite instead
	xba								; shift to high byte for Y value
	clc
	adc	DP_Char1ScreenPosYX					; Y += DP_Char1WalkingSpd
	sta	DP_Char1ScreenPosYX
	lda	#TBL_Char1_down
	bra	__PESL_MoveHeroDone

.ACCU 8

__PESL_MoveHeroNextCheck:
	lda	DP_Char1ScreenPosYX					; check if hero should be moved horizontally
	sec
	sbc	VAR_Char1TargetScrPosYX
	beq	__PESL_MoveHeroDone2
	bcc	__PESL_MoveHeroRight

__PESL_MoveHeroLeft:
	Accu16

	lda	DP_Char1ScreenPosYX
	sec
	sbc	DP_Char1WalkingSpd					; X -= DP_Char1WalkingSpd
	sta	DP_Char1ScreenPosYX
	lda	#TBL_Char1_left
	bra	__PESL_MoveHeroDone

__PESL_MoveHeroRight:
	Accu16

	lda	DP_Char1ScreenPosYX
	clc
	adc	DP_Char1WalkingSpd					; X += DP_Char1WalkingSpd
	sta	DP_Char1ScreenPosYX
	lda	#TBL_Char1_right

__PESL_MoveHeroDone:
	Accu8

	sta	DP_Char1SpriteStatus
	bra	+

__PESL_MoveHeroDone2:
	lda	#$80							; make character idle
	tsb	DP_Char1SpriteStatus

+	ldx	DP_EventWaitFrames
	dex
	stx	DP_EventWaitFrames
	beq	__ProcessEventContinue
	jmp	__ProcessEventSubLoop

__ProcessEventContinue:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y				; load next code byte
	cmp	#EC_END
	bne	+
	rtl								; end control code reached, return

+	iny								; increment code pointer

	Accu16

	and	#$00FF							; remove garbage in B
	asl	a							; use code byte ...
	tax								; ... as an index ...
	jmp	(ProcessEventCode, x)					; ... into our WIP collection of event processing routines



; ********************* Event processing routines **********************

ProcessEventCode:
	.DW Process_EC_DIALOG
	.DW Process_EC_DISABLE_HDMA_CH
	.DW Process_EC_DMA_ROM2CGRAM
	.DW Process_EC_DMA_ROM2VRAM
	.DW Process_EC_ENABLE_HDMA_CH
	.DW Process_EC_GSS_LOAD_TRACK
	.DW Process_EC_GSS_TRACK_FADEIN
	.DW Process_EC_GSS_TRACK_FADEOUT
	.DW Process_EC_GSS_TRACK_PLAY
	.DW Process_EC_GSS_TRACK_STOP
	.DW Process_EC_INIT_GAMEINTRO
	.DW Process_EC_JSL
	.DW Process_EC_JSR
	.DW Process_EC_LOAD_AREA
	.DW Process_EC_LOAD_PARTY_FORMATION
	.DW Process_EC_MONITOR_INPUT_JOY1
;	.DW Process_EC_MONITOR_INPUT_JOY2
	.DW Process_EC_MOVE_ALLY
	.DW Process_EC_MOVE_HERO
	.DW Process_EC_MOVE_NPC
	.DW Process_EC_MOVE_OBJ
	.DW Process_EC_MSU_LOAD_TRACK
	.DW Process_EC_MSU_TRACK_FADEIN
	.DW Process_EC_MSU_TRACK_FADEOUT
	.DW Process_EC_MSU_TRACK_PLAY
	.DW Process_EC_MSU_TRACK_STOP
	.DW Process_EC_SCR_EFFECT
	.DW Process_EC_SCR_EFFECT_TRANSITION
	.DW Process_EC_SCR_SCROLL
	.DW Process_EC_SET_REGISTER
	.DW Process_EC_SIMULATE_INPUT_JOY1
	.DW Process_EC_SIMULATE_INPUT_JOY2
	.DW Process_EC_TOGGLE_AUTO_MODE
	.DW Process_EC_WAIT_JOY1
	.DW Process_EC_WAIT_JOY2
	.DW Process_EC_WAIT_FRAMES

Process_EC_DIALOG:
	lda	[DP_EventCodeAddress], y
	sta	DP_TextPointerNo
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jsr	OpenTextBox

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_DISABLE_HDMA_CH:
	Accu8

	lda	[DP_EventCodeAddress], y
	trb	DP_HDMA_Channels
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_DMA_ROM2CGRAM:						; CGRAM target address (8), ROM source address (16), ROM source bank (8), size (16)
	Accu8

	lda	[DP_EventCodeAddress], y				; read CGRAM target address
	sta.l	REG_CGADD
	iny

	Accu16

	lda	#(REG_CGDATA & $FF) << 8 | $02				; B bus register (high byte), DMA mode (low byte)
 	sta.l	$004300

	lda	[DP_EventCodeAddress], y				; read data source address
	sta.l	$004302
	iny
	iny

	Accu8

	lda	[DP_EventCodeAddress], y				; read data source bank
	sta.l	$004304
	iny

	Accu16

	lda	[DP_EventCodeAddress], y				; read data length
	sta.l	$004305

	Accu8

	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta.l	REG_MDMAEN
	iny
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_DMA_ROM2VRAM:						; VRAM target address (16), ROM source address (16), ROM source bank (8), size (16)
	Accu8

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta.l	REG_VMAIN

	Accu16

	lda	[DP_EventCodeAddress], y				; read VRAM target address
	sta.l	REG_VMADDL
	iny
	iny
	lda	#(REG_VMDATAL & $FF) << 8 | $01				; B bus register (high byte), DMA mode (low byte)
 	sta.l	$004300
	lda	[DP_EventCodeAddress], y				; read data source address
	sta.l	$004302
	iny
	iny

	Accu8

	lda	[DP_EventCodeAddress], y				; read data source bank
	sta.l	$004304
	iny

	Accu16

	lda	[DP_EventCodeAddress], y				; read data length
	sta.l	$004305

	Accu8

	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta.l	REG_MDMAEN
	iny
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_ENABLE_HDMA_CH:
	Accu8

	lda	[DP_EventCodeAddress], y
	tsb	DP_HDMA_Channels
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_GSS_LOAD_TRACK:
	lda	[DP_EventCodeAddress], y
	sta	DP_NextTrack
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jsl	LoadTrackGSS

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_GSS_TRACK_FADEIN:
	lda	[DP_EventCodeAddress], y
	sta	DP_SPC_VolFadeSpeed
	iny
	iny
	lda	[DP_EventCodeAddress], y
	sta	DP_SPC_VolCurrent
	iny
	iny
	sty	DP_EventCodePointer
	jsl	spc_global_volume

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_GSS_TRACK_FADEOUT:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_GSS_TRACK_PLAY:
	sty	DP_EventCodePointer

	Accu8
	DisableIRQs
	Accu16

	lda	#SCMD_STEREO						; default output is mono, so issue stereo command ...
	sta	gss_command
	lda	#1							; ... with 1 as parameter
	sta	gss_param
	jsl	spc_command_asm

	Accu16

	lda.w	#SCMD_MUSIC_PLAY
	sta	gss_command
	stz	gss_param
	jsl	spc_command_asm

	Accu8

	lda.l	REG_RDNMI						; clear NMI flag
	lda.l	DP_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_GSS_TRACK_STOP:
	sty	DP_EventCodePointer

	Accu8
	DisableIRQs

	jsl	music_stop

	lda.l	REG_RDNMI						; clear NMI flag
	lda.l	DP_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_INIT_GAMEINTRO:
	sty	DP_EventCodePointer

	Accu8

;	jsl	GameIntro

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_JSL:
	lda	[DP_EventCodeAddress], y
	sta	DP_DataAddress
	iny
	iny

	Accu8

	lda	[DP_EventCodeAddress], y
	sta	DP_DataBank
	iny
	sty	DP_EventCodePointer
	phk								; push current program bank onto stack
	pea	__ReturnAdressJSL-1					; push return address minus 1 (RTL adds 1) onto stack
	jml	[DP_DataAddress]

__ReturnAdressJSL:

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_JSR:
	lda	[DP_EventCodeAddress], y
	sta	DP_DataAddress
	iny
	iny
	sty	DP_EventCodePointer

	Accu8								; assume 8-bit Accu in subroutine

	pea	__ReturnAdressJSR-1					; push return address minus 1 (RTS adds 1) onto stack
	jmp	(DP_DataAddress)					; jump to subroutine

__ReturnAdressJSR:

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_LOAD_AREA:
	lda	[DP_EventCodeAddress], y
	sta	DP_AreaCurrent
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jsr	LoadAreaData

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_LOAD_PARTY_FORMATION:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MONITOR_INPUT_JOY1:
	lda	[DP_EventCodeAddress], y				; read buttons to monitor
	sta	DP_EventMonitorJoy1
	iny
	iny
	lda	[DP_EventCodeAddress], y				; read event script code position to jump to
	sta	DP_EventCodeJump

	Accu8

	lda	#%00000001						; set "monitor joypad 1" bit
	sta	DP_EventControl
	iny
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_ALLY:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_HERO:
	lda	[DP_EventCodeAddress], y
	sta	VAR_Char1TargetScrPosYX					; target screen position
	iny
	iny

	Accu8

	lda	[DP_EventCodeAddress], y
	sta	DP_Char1WalkingSpd					; speed
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_NPC:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_OBJ:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_LOAD_TRACK:
	lda	DP_MSU1_Present
	and	#$0001
	beq	+
	lda	[DP_EventCodeAddress], y
	sta	DP_MSU1_NextTrack
-	lda	MSU_STATUS						; wait for Audio Busy bit to clear
	and	#%0000000001000000
	bne	-

+	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_FADEIN:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_FADEOUT:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_PLAY:
	lda	DP_MSU1_Present
	and	#$0001
	beq	+
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	sta	MSU_VOLUME
+	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_STOP:
	sty	DP_EventCodePointer

	Accu8

	lda	DP_MSU1_Present
	and	#$01
	beq	+
	stz	MSU_CONTROL
+	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SCR_EFFECT:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SCR_EFFECT_TRANSITION:
	lda	[DP_EventCodeAddress], y
	tax
	iny
	iny

	Accu8

	lda	[DP_EventCodeAddress], y
	sta	DP_EffectSpeed
	iny
	sty	DP_EventCodePointer
	jsr	(SRC_EffectPointer, x)

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SCR_SCROLL:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SET_REGISTER:
	lda	[DP_EventCodeAddress], y				; load register to be written to
	sta	DP_RegisterBuffer
	iny
	iny

	Accu8

	lda	[DP_EventCodeAddress], y				; load 8-bit value
	sta	(DP_RegisterBuffer)					; write value to desired register // CHECKME, might want to use 24-bit addressing instead to be safe
	iny
	sty	DP_EventCodePointer
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SIMULATE_INPUT_JOY1:
	lda	[DP_EventCodeAddress], y
	sta	DP_AutoJoy1
	iny
	iny
	sty	DP_EventCodePointer
	lda	#1							; make sure simulated input gets acknowledged
	sta	DP_EventWaitFrames

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SIMULATE_INPUT_JOY2:
	lda	[DP_EventCodeAddress], y
	sta	DP_AutoJoy2
	iny
	iny
	sty	DP_EventCodePointer
	lda	#1							; make sure simulated input gets acknowledged
	sta	DP_EventWaitFrames

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_TOGGLE_AUTO_MODE:
	sty	DP_EventCodePointer

	Accu8

	lda	DP_GameMode
	eor	#%10000000						; flip auto-mode bit
	sta	DP_GameMode
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_WAIT_JOY1:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_WAIT_JOY2:
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_WAIT_FRAMES:
	lda	[DP_EventCodeAddress], y
	sta	DP_EventWaitFrames
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop



; ******************************** EOF *********************************
