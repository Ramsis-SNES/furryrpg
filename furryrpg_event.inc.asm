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
	sta	DP_EventCodeAddress+2



; -------------------------- process event script
ProcessEventLoop:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y				; load next code byte
	cmp	#EC_END
	beq	+
	iny								; increment code pointer
	sty	DP_EventCodePointer

	Accu16

	and	#$00FF							; remove garbage in B
	asl	a							; use code byte ...
	tax								; ... as an index ...
	jmp	(ProcessEventCode, x)					; ... into our WIP collection of event processing routines

ProcessEventCode:
	.DW Process_EC_DIALOG
	.DW Process_EC_GSS_LOAD_TRACK
	.DW Process_EC_GSS_TRACK_FADEIN
	.DW Process_EC_GSS_TRACK_FADEOUT
	.DW Process_EC_GSS_TRACK_PLAY
	.DW Process_EC_GSS_TRACK_STOP
	.DW Process_EC_INIT_ALPHAINTRO
	.DW Process_EC_INIT_GAMEINTRO
	.DW Process_EC_LOAD_AREA
	.DW Process_EC_LOAD_PARTY_FORMATION
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
	.DW Process_EC_WAIT_JOY1
	.DW Process_EC_WAIT_JOY2
	.DW Process_EC_WAIT_FRAMES

.ACCU 8

+	rtl



; ********************* Event processing routines **********************

.ACCU 16

Process_EC_DIALOG:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	sta	DP_TextPointerNo
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jsr	OpenTextBox

	bra	ProcessEventLoop

.ACCU 16

Process_EC_GSS_LOAD_TRACK:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	sta	DP_NextTrack
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jsl	LoadTrackGSS

	bra	ProcessEventLoop

.ACCU 16

Process_EC_GSS_TRACK_FADEIN:
	ldy	DP_EventCodePointer
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
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_GSS_TRACK_PLAY:
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
	Accu8

	DisableIRQs

	jsl	music_stop

	lda.l	REG_RDNMI						; clear NMI flag
	lda.l	DP_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli
	jmp	ProcessEventLoop

.ACCU 16

Process_EC_INIT_ALPHAINTRO:
	Accu8

	jsl	AlphaIntro

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_INIT_GAMEINTRO:
	Accu8

;	jsl	GameIntro

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_LOAD_AREA:
	ldy	DP_EventCodePointer
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
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_ALLY:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_HERO:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_NPC:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MOVE_OBJ:
	ldy	DP_EventCodePointer
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
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	sta	DP_MSU1_NextTrack
-	lda	MSU_STATUS						; wait for Audio Busy bit to clear
	and	#%0000000001000000
	bne	-

+	inc	DP_EventCodePointer
	inc	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_FADEIN:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_FADEOUT:
	ldy	DP_EventCodePointer
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
+	inc	DP_EventCodePointer
	inc	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_MSU_TRACK_STOP:
	Accu8

	lda	DP_MSU1_Present
	and	#$01
	beq	+
	stz	MSU_CONTROL
+	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SCR_EFFECT:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_SCR_EFFECT_TRANSITION:
	ldy	DP_EventCodePointer
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
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_WAIT_JOY1:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_WAIT_JOY2:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	;use value
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

	jmp	ProcessEventLoop

.ACCU 16

Process_EC_WAIT_FRAMES:
	ldy	DP_EventCodePointer
	lda	[DP_EventCodeAddress], y
	tax
	iny
	iny
	sty	DP_EventCodePointer

	Accu8

__WaitFramesLoop:
-	lda	REG_HVBJOY
	bpl	-

-	lda	REG_HVBJOY
	bmi	-

	dex
	bne	__WaitFramesLoop

	jmp	ProcessEventLoop



; ******************************** EOF *********************************
