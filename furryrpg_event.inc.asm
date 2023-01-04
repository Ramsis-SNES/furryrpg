;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** EVENT HANDLER ***
;
;==========================================================================================



LoadEvent:								; expects valid event no. in 16-bit Accu
	.ACCU 16
	.INDEX 16

	asl	a
	tax
	lda.l	SRC_EventPointer, x					; load start of event code // FIXME, possibly use this as pointer directly instead (and no pointer/Y-indexed addressing required when reading event code)
	sta	<DP2.EventCodeAddress
	stz	<DP2.EventCodePointer					; reset code pointer

	Accu8

	lda	#:SRC_EventPointer					; set bank
	sta	<DP2.EventCodeBank
	stz	<DP2.EventControl					; clear all event control bits



; Process event script

ProcessEventLoop:
	ldx	<DP2.EventWaitFrames					; check if we need to enter main loop (i.e., for screen elements to catch up, read joypads etc.)
	bne	@ProcessEventSubLoop
	jmp	@ProcessEventContinue

@ProcessEventSubLoop:
	lda	LO8.NMITIMEN						; FIXME, should be temporary
	sta	NMITIMEN

	WaitFrames	1

	lda	<DP2.EventControl					; check if we need to monitor joypad 1
	and	#%00000001
	beq	@Joy1Done

	Accu16								; yes, check buttons

	lda	<DP2.Joy1New
	and	<DP2.EventMonitorJoy1
	beq	+

	lda	<DP2.EventCodeJump					; button pressed, set new event code position
	sta	<DP2.EventCodePointer
	stz	<DP2.EventWaitFrames					; reset frame counter so event processing continues immediately

	Accu8

	bra	@ProcessEventContinue

+	Accu8

@Joy1Done:

	bit	<DP2.TextBoxStatus					; check if text box is active (MSB set)
	bpl	+
	jsr	ProcDialogTextBox					; yes, go to subroutine

+	lda	<DP2.Hero1ScreenPosYX+1					; check if hero should be moved vertically
	sec
	sbc	LO8.Hero1TargetScrPosYX+1
	beq	@MoveHeroNextCheck
	bcc	@MoveHeroDown

@MoveHeroUp:								; FIXME, move all active objects that need to be moved within this loop (not just hero)
	Accu16

	lda	<DP2.Hero1ScreenPosYX
	ldx	<DP2.Hero1WalkingSpd
-	sec
	sbc	#$0100							; Y -= 1
	dex								; as many times as DP2.Hero1WalkingSpd
	bne	-

	sta	<DP2.Hero1ScreenPosYX
	lda	#k8_Hero1_up
	bra	@MoveHeroDone

@MoveHeroDown:
	Accu16

	lda	<DP2.Hero1WalkingSpd					; area not scrollable, move hero sprite instead
	xba								; shift to high byte for Y value
	clc
	adc	<DP2.Hero1ScreenPosYX					; Y += DP2.Hero1WalkingSpd
	sta	<DP2.Hero1ScreenPosYX
	lda	#k8_Hero1_down
	bra	@MoveHeroDone

	.ACCU 8

@MoveHeroNextCheck:
	lda	<DP2.Hero1ScreenPosYX					; check if hero should be moved horizontally
	sec
	sbc	LO8.Hero1TargetScrPosYX
	beq	@MoveHeroDone2
	bcc	@MoveHeroRight

@MoveHeroLeft:
	Accu16

	lda	<DP2.Hero1ScreenPosYX
	sec
	sbc	<DP2.Hero1WalkingSpd					; X -= DP2.Hero1WalkingSpd
	sta	<DP2.Hero1ScreenPosYX
	lda	#k8_Hero1_left
	bra	@MoveHeroDone

@MoveHeroRight:
	Accu16

	lda	<DP2.Hero1ScreenPosYX
	clc
	adc	<DP2.Hero1WalkingSpd					; X += DP2.Hero1WalkingSpd
	sta	<DP2.Hero1ScreenPosYX
	lda	#k8_Hero1_right

@MoveHeroDone:
	Accu8

	sta	<DP2.Hero1SpriteStatus
	jsr	UpdateAreaSprites

	ldx	#loword(RAM.SpriteDataArea)				; set WRAM address for area sprite data array
	stx	WMADDL
	stz	WMADDH
	jsr	ConvertSpriteDataToBuffer

	bra	+

@MoveHeroDone2:
	lda	#$80							; make character idle
	tsb	<DP2.Hero1SpriteStatus

+	ldx	<DP2.EventWaitFrames
	dex
	stx	<DP2.EventWaitFrames
	beq	@ProcessEventContinue
	jmp	@ProcessEventSubLoop

@ProcessEventContinue:
	ldy	<DP2.EventCodePointer
	lda	[<DP2.EventCodeAddress], y				; load next code byte
	iny								; increment code pointer

	Accu16

	and	#$00FF							; clear garbage in B
	asl	a							; use code byte ...
	tax								; ... as an index ...
	jsr	(PTR_ProcessEventCode, x)				; ... into our WIP collection of event processing subroutines

	.ACCU 8

	jmp	ProcessEventLoop					; continue processing event script

;@ProcessEventDone:

;	rtl								; event script finished, return // never mind, cf. Process_evc_00_END



; ********************* Event processing routines **********************

PTR_ProcessEventCode:
	.DW Process_evc_00_END
	.DW Process_evc_BG3_TEXT
	.DW Process_evc_DIALOG
	.DW Process_evc_DISABLE_HDMA_CH
	.DW Process_evc_DMA_ROM2CGRAM
	.DW Process_evc_DMA_ROM2VRAM
	.DW Process_evc_DMA_ROM2WRAM
	.DW Process_evc_ENABLE_HDMA_CH
	.DW Process_evc_GSS_COMMAND
	.DW Process_evc_GSS_LOAD_TRACK
	.DW Process_evc_INIT_GAMEINTRO
	.DW Process_evc_JSL
	.DW Process_evc_JSR
	.DW Process_evc_JUMP
	.DW Process_evc_LOAD_AREA
	.DW Process_evc_LOAD_PARTY_FORMATION
	.DW Process_evc_MONITOR_INPUT_JOY1
;	.DW Process_evc_MONITOR_INPUT_JOY2
	.DW Process_evc_MOVE_ALLY
	.DW Process_evc_MOVE_HERO
	.DW Process_evc_MOVE_NPC
	.DW Process_evc_MOVE_OBJ
	.DW Process_evc_MSU_LOAD_TRACK
	.DW Process_evc_MSU_TRACK_FADEIN
	.DW Process_evc_MSU_TRACK_FADEOUT
	.DW Process_evc_MSU_TRACK_PLAY
	.DW Process_evc_MSU_TRACK_STOP
	.DW Process_evc_SCR_EFFECT
	.DW Process_evc_SCR_EFFECT_TRANSITION
	.DW Process_evc_SCR_SCROLL
	.DW Process_evc_SET_REGISTER
	.DW Process_evc_SIMULATE_INPUT_JOY1
	.DW Process_evc_SIMULATE_INPUT_JOY2
	.DW Process_evc_TOGGLE_AUTO_MODE
	.DW Process_evc_WAIT_JOY1
	.DW Process_evc_WAIT_JOY2
	.DW Process_evc_WAIT_FRAMES
	.DW Process_evc_WRITE_RAM_BYTE



;Process_evc_TEMPLATE:
;	.ACCU 16 -- or -- Accu8

;	lda	[<DP2.EventCodeAddress], y
	;use value
;	iny
;	iny
;	sty	<DP2.EventCodePointer

;	Accu8

;	rts



Process_evc_00_END:
	.ACCU 16

	pla								; clean up the stack as we don't return into ProcessEventLoop

	Accu8

	rtl								; return from LoadEvent



Process_evc_BG3_TEXT:
	Accu8

	lda	[<DP2.EventCodeAddress], y				; y position (given number * 32)
	xba								; first, shift left 8 bits
	lda	#$00							; clear low byte

	Accu16

	lsr	a							; shift right 3 bits for final y value
	lsr	a
	lsr	a

	Accu8

	iny
	ora	[<DP2.EventCodeAddress], y				; OR with x position, this is fine as x is never higher than 31 = $1F, and y (unless zero) can never be lower than (1 lsh 5) = $20

	Accu16

	sta	<DP2.TextCursor						; store as cursor position
	iny

	lda	[<DP2.EventCodeAddress], y				; 16-bit string pointer
	sta	<DP2.TextStringPtr
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; 8-bit string bank
	sta	<DP2.TextStringBank
	iny
	sty	<DP2.EventCodePointer

	Accu8

	ldx	#kTextBG3
	stx	LO8.Routine_FillTextBuffer
	jsr	SimplePrintF

	lda	#%00010000						; make sure BG3 lo tilemap gets updated
	tsb	<DP2.DMA_Updates

	rts



Process_evc_DIALOG:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.TextPointerNo
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	jsr	InitDialogTextBox

	rts



Process_evc_DISABLE_HDMA_CH:
	Accu8

	lda	[<DP2.EventCodeAddress], y
	trb	<DP2.HDMA_Channels
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_DMA_ROM2CGRAM:						; CGRAM target address (8), ROM source address (16), ROM source bank (8), size (16)
	Accu8

	lda	[<DP2.EventCodeAddress], y				; read CGRAM target address
	sta.l	CGADD
	iny

	Accu16

	lda	#<CGDATA<<8|$02						; B bus register (high byte), DMA mode (low byte)
 	sta.l	DMAP0
	lda	[<DP2.EventCodeAddress], y				; read data source address
	sta.l	A1T0L
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; read data source bank
	sta.l	A1B0
	iny

	Accu16

	lda	[<DP2.EventCodeAddress], y				; read data length
	sta.l	DAS0L

	Accu8

	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta.l	MDMAEN
	iny
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_DMA_ROM2VRAM:						; VRAM target address (16), ROM source address (16), ROM source bank (8), size (16)
	Accu8

	lda	#$80							; increment VRAM address by 1 after writing to $2119
	sta.l	VMAIN

	Accu16

	lda	[<DP2.EventCodeAddress], y				; read VRAM target address
	sta.l	VMADDL
	iny
	iny
	lda	#<VMDATAL<<8|$01					; B bus register (high byte), DMA mode (low byte)
 	sta.l	DMAP0
	lda	[<DP2.EventCodeAddress], y				; read data source address
	sta.l	A1T0L
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; read data source bank
	sta.l	A1B0
	iny

	Accu16

	lda	[<DP2.EventCodeAddress], y				; read data length
	sta.l	DAS0L

	Accu8

	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta.l	MDMAEN
	iny
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_DMA_ROM2WRAM:						; WRAM target address (16), WRAM target bank (8), ROM source address (16), ROM source bank (8), size (16)
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y				; read WRAM target address
	sta.l	WMADDL
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; read WRAM target bank
	and	#$01							; reduce to LSB (0 = bank $7E, 1 = bank $7F)
	sta.l	WMADDH
	iny

	Accu16

	lda	#<WMDATA<<8						; B bus register (high byte), DMA mode (low byte, 0 in this case)
 	sta.l	DMAP0
	lda	[<DP2.EventCodeAddress], y				; read data source address
	sta.l	A1T0L
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; read data source bank
	sta.l	A1B0
	iny

	Accu16

	lda	[<DP2.EventCodeAddress], y				; read data length
	sta.l	DAS0L

	Accu8

	lda	#%00000001						; initiate DMA transfer (channel 0)
	sta.l	MDMAEN
	iny
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_ENABLE_HDMA_CH:
	Accu8

	lda	[<DP2.EventCodeAddress], y
	tsb	<DP2.HDMA_Channels
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_GSS_COMMAND:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y				; load SNESGSS command
	sta	<DP2.GSS_command
	iny
	iny
	lda	[<DP2.EventCodeAddress], y				; load parameter
	sta	<DP2.GSS_param
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	jsl	spc_command_asm						; send command

	rts



Process_evc_GSS_LOAD_TRACK:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.NextTrack
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	jsl	LoadTrackGSS

	rts



Process_evc_INIT_GAMEINTRO:
	.ACCU 16

	sty	<DP2.EventCodePointer

	Accu8

;	jsl	GameIntro

	rts



Process_evc_JSL:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.DataAddress
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.DataBank
	iny
	sty	<DP2.EventCodePointer
	phk								; push current program bank onto stack
	pea	@ReturnAdressJSL-1					; push correct return address onto stack
	jml	[<DP2.DataAddress]

@ReturnAdressJSL:

	rts



Process_evc_JSR:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.DataAddress
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8								; assume 8-bit Accu in subroutine

	pea	@ReturnAdressJSR-1					; push correct return address onto stack
	jmp	(DP2.DataAddress)					; jump to subroutine

@ReturnAdressJSR:

	rts



Process_evc_JUMP:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y				; read new event code pointer
	sta	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_LOAD_AREA:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.AreaCurrent
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	jsr	LoadAreaData

	rts



Process_evc_LOAD_PARTY_FORMATION:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MONITOR_INPUT_JOY1:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y				; read buttons to monitor
	sta	<DP2.EventMonitorJoy1
	iny
	iny
	lda	[<DP2.EventCodeAddress], y				; read event script code position to jump to
	sta	<DP2.EventCodeJump

	Accu8

	lda	#%00000001						; set "monitor joypad 1" bit
	sta	<DP2.EventControl
	iny
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_MOVE_ALLY:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MOVE_HERO:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	LO8.Hero1TargetScrPosYX					; target screen position
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.Hero1WalkingSpd					; speed
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_MOVE_NPC:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MOVE_OBJ:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MSU_LOAD_TRACK:
	Accu8

	lda	<DP2.GameConfig
	and	#%00000001						; check for "MSU1 present" flag
	beq	+
	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.MSU1_NextTrack

-	bit	MSU_STATUS						; wait for Audio Busy bit to clear
	bvs	-

+	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_MSU_TRACK_FADEIN:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MSU_TRACK_FADEOUT:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MSU_TRACK_PLAY:
	.ACCU 16

	lda	<DP2.GameConfig
	and	#%0000000000000001					; check for "MSU1 present" flag
	beq	+
	ldy	<DP2.EventCodePointer
	lda	[<DP2.EventCodeAddress], y
	sta	MSU_VOLUME
+	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_MSU_TRACK_STOP:
	.ACCU 16

	sty	<DP2.EventCodePointer

	Accu8

	lda	<DP2.GameConfig
	and	#%00000001						; check for "MSU1 present" flag
	beq	+
	stz	MSU_CONTROL

+	rts



Process_evc_SCR_EFFECT:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_SCR_EFFECT_TRANSITION:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	tax
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.EffectSpeed
	iny
	sty	<DP2.EventCodePointer
	jsr	(PTR_EffectTypes, x)

	rts



Process_evc_SCR_SCROLL:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_SET_REGISTER:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y				; load register to be written to
	sta	<DP2.RegisterBuffer
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; load 8-bit value
	sta	(<DP2.RegisterBuffer)					; write value to desired register // CHECKME, might want to use 24-bit addressing instead to be safe
	iny
	sty	<DP2.EventCodePointer

	rts



Process_evc_SIMULATE_INPUT_JOY1:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.AutoJoy1
	iny
	iny
	sty	<DP2.EventCodePointer
	lda	#1							; make sure simulated input gets acknowledged
	sta	<DP2.EventWaitFrames

	Accu8

	rts



Process_evc_SIMULATE_INPUT_JOY2:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.AutoJoy2
	iny
	iny
	sty	<DP2.EventCodePointer
	lda	#1							; make sure simulated input gets acknowledged
	sta	<DP2.EventWaitFrames

	Accu8

	rts



Process_evc_TOGGLE_AUTO_MODE:
	.ACCU 16

	sty	<DP2.EventCodePointer

	Accu8

	lda	<DP2.GameMode
	eor	#%10000000						; flip auto-mode bit
	sta	<DP2.GameMode

	rts



Process_evc_WAIT_JOY1:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_WAIT_JOY2:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	;use value
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_WAIT_FRAMES:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y
	sta	<DP2.EventWaitFrames
	iny
	iny
	sty	<DP2.EventCodePointer

	Accu8

	rts



Process_evc_WRITE_RAM_BYTE:
	.ACCU 16

	lda	[<DP2.EventCodeAddress], y				; load RAM address
	sta	WMADDL
	iny
	iny

	Accu8

	lda	[<DP2.EventCodeAddress], y				; load RAM bank
	and	#%00000001						; mask off unused bits for good measure
	sta	WMADDH
	iny
	lda	[<DP2.EventCodeAddress], y				; load 8-bit value
	sta	WMDATA							; write value
	iny
	sty	<DP2.EventCodePointer

	rts



; ******************************** EOF *********************************
