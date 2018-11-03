;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** SNESGSS ROUTINES***
;
;==========================================================================================



BootSPC700:
	Accu16

	lda	#:SRC_spc700_driver
	sta	DP_SPC_DataBank
	lda	#SRC_spc700_driver+2
	sta	DP_SPC_DataOffset
	lda.l	SRC_spc700_driver
	sta	DP_SPC_DataSize
	lda	#$0200
	sta	DP_SPC_DataAddress
	jsl	spc_load_data

	Accu16

	lda.w	#SCMD_INITIALIZE
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	rtl



spc_load_data:
	php

	AccuIndex16

;	.ifndef DISABLE_SOUND
	stz	VAR_TimeoutCounter					; reset timeout counter
	lda.w	#0
	tay

	Accu8

;	sta.l	REG_NMITIMEN						;disable NMI,interrupts has to be disabled to prevent possible lockup in the IPL transfer routine
;	sei								;disable IRQ

	Accu16

	lda	DP_SPC_DataSize ;7,s					;size
	tax
	lda	DP_SPC_DataOffset ;9,s					;src
	sta	DP_SNESlib_ptr
	lda	DP_SPC_DataBank ;11,s					;srch
	sta	DP_SNESlib_ptr+2
	lda.w	#$bbaa							;IPL ready signature

_wait1:
	CheckErrorSPC700ab

	cmp.l	REG_APUIO0
	bne	_wait1

	lda	DP_SPC_DataAddress ;5,s					;adr
	stz	VAR_TimeoutCounter					; reset timeout counter
	sta.l	REG_APUIO2
	lda.w	#$01cc							;IPL load and ready signature
	sta.l	REG_APUIO0

	Accu8

_wait2:
	CheckErrorSPC700a

	cmp.l	REG_APUIO0
	bne	_wait2

	stz	VAR_TimeoutCounter					; reset timeout counter
	stz	VAR_TimeoutCounter+1
	phb
	lda	#0

	pha
	plb

_load1:

	lda	[DP_SNESlib_ptr],y
	sta.w	REG_APUIO1
	tya
	sta.w	REG_APUIO0
	iny
	
_load2:
	CheckErrorSPC700a

	cmp.w	REG_APUIO0
	bne	_load2

	stz	VAR_TimeoutCounter					; reset timeout counter
	stz	VAR_TimeoutCounter+1
	dex
	bne	_load1

	iny
	bne	_load3
	iny
	
_load3:

	plb

	Accu16

	lda.w	#$0200							;loaded code starting address
	sta.l	REG_APUIO2

	Accu8

	lda.b	#$00							;execute code
	sta.l	REG_APUIO1	
	tya								;stop transfer
	sta.l	REG_APUIO0

;	Accu16

;	ldx	#$80
;	lda.w	__tccs_snes_pad_count
;	cmp.w	#2
;	bcc	_load4

;	ldx	#$81
	
;_load4:

;	Accu8

;	txa
;	sta.l	REG_NMITIMEN						;enable NMI
;	cli								;enable IRQ

	Accu16

_load5:
	CheckErrorSPC700ab

	lda.l	REG_APUIO0						;wait until SPC700 clears all communication ports, confirming that code has started
	ora.l	REG_APUIO2
	bne	_load5

;	.endif

	stz	VAR_TimeoutCounter					; reset timeout counter
	plp
	rtl


	
spc_command_asm:

;	.ifndef DISABLE_SOUND

	Accu8
-	CheckErrorSPC700a

;	lda	#$00
;	sta.l	REG_NMITIMEN						; disable NMI // LAST ADD 198
;	sei								; disable IRQ // LAST ADD 198

	lda.l	REG_APUIO0
	bne	-

	stz	VAR_TimeoutCounter					; reset timeout counter
	stz	VAR_TimeoutCounter+1

	Accu16

	lda	DP_GSS_param
	sta.l	REG_APUIO2
	lda	DP_GSS_command
	sta.l	REG_APUIO0
	cmp.w	#SCMD_LOAD						;don't wait acknowledge
	beq	+

	Accu8
-	CheckErrorSPC700a

	lda.l	REG_APUIO0
	beq	-

+

	Accu8								; LAST ADD 200

;	lda	#$81
;	sta.l	REG_NMITIMEN						; reenable NMI // LAST ADD 198
;	cli								; reenable IRQ // LAST ADD 198
	stz	VAR_TimeoutCounter					; reset timeout counter
	stz	VAR_TimeoutCounter+1

;	.endif

	rtl

	

;void spc_command(unsigned int command,unsigned int param);

spc_command:
	php

	AccuIndex16

	lda	7,s							;param
	sta	DP_GSS_param
	lda	5,s							;command
	sta	DP_GSS_command
	jsl	spc_command_asm

	plp
	rtl



;void spc_stereo(unsigned int stereo);

spc_stereo:
	php

	AccuIndex16

	lda	5,s							;stereo
	sta	DP_GSS_param
	lda.w	#SCMD_STEREO
	sta	DP_GSS_command
	jsl	spc_command_asm

	plp
	rtl
	
	
	
;void spc_global_volume(unsigned int volume,unsigned int speed);

spc_global_volume:
	php

	AccuIndex16

	lda	DP_SPC_VolFadeSpeed ;7,s				;speed
	xba
	and.w	#$ff00
	sta	DP_GSS_param
	lda	DP_SPC_VolCurrent ;5,s					;volume
	and.w	#$00ff
	ora	DP_GSS_param
	sta	DP_GSS_param
	lda.w	#SCMD_GLOBAL_VOLUME
	sta	DP_GSS_command
	jsl	spc_command_asm

	plp
	rtl
	
	
	
;void spc_channel_volume(unsigned int channels,unsigned int volume);

spc_channel_volume:
	php

	AccuIndex16

	lda	5,s							;channels
	xba
	and.w	#$ff00
	sta	DP_GSS_param
	lda	7,s							;volume
	and.w	#$00ff
	ora	DP_GSS_param
	sta	DP_GSS_param
	lda.w	#SCMD_CHANNEL_VOLUME
	sta	DP_GSS_command
	jsl	spc_command_asm

	plp
	rtl
	

	
;void music_stop(void);

music_stop:
	php

	AccuIndex16

	lda.w	#SCMD_MUSIC_STOP
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	plp
	rtl
	

	
;void music_pause(unsigned int pause);

music_pause:
	php

	AccuIndex16

	lda	5,s							;pause
	sta	DP_GSS_param
	lda.w	#SCMD_MUSIC_PAUSE
	sta	DP_GSS_command
	jsl	spc_command_asm

	plp
	rtl
	
	
	
;void sound_stop_all(void);

sound_stop_all:
	php

	AccuIndex16

	lda.w	#SCMD_STOP_ALL_SOUNDS
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	plp
	rtl
	
	
	
;void sfx_play(unsigned int chn,unsigned int sfx,unsigned int vol,int pan);

sfx_play:
	php

	AccuIndex16

	lda	11,s							;pan
	bpl +
	lda.w	#0
+
	cmp.w	#255
	bcc +
	lda.w	#255
+

	xba
	and.w	#$ff00
	sta	DP_GSS_param
	lda	7,s							;sfx number
	and.w	#$00ff
	ora	DP_GSS_param
	sta	DP_GSS_param
	lda	9,s							;volume
	xba
	and.w	#$ff00
	sta	DP_GSS_command
	lda	5,s							;chn
	asl	a
	asl	a
	asl	a
	asl	a
	and.w	#$00f0
	ora.w	#SCMD_SFX_PLAY
	ora	DP_GSS_command
	sta	DP_GSS_command
	jsl	spc_command_asm

	plp
	rtl
	


.ENDASM

spc_stream_update:
	php

	AccuIndex16

_stream_update_loop:
	lda.w	__tccs_spc_stream_enable
	bne	_stream_update_loop1

_stream_update_done:
	plp
	rtl

_stream_update_loop1:

	lda.w	__tccs_spc_stream_stop_flag
	beq	_stream_update_play

_test2:
	stz.w	__tccs_spc_stream_enable

	Accu8

_stream_wait7:
	lda.l	REG_APUIO0
	bne	_stream_wait7
	lda.b	#SCMD_STREAM_STOP
	sta.l	REG_APUIO0

_stream_wait8:
	lda.l	REG_APUIO0
	beq	_stream_wait8
	bra	_stream_update_done

_stream_update_play:
	Accu8

_stream_wait1:
	lda.l	REG_APUIO0
	bne	_stream_wait1
	lda.b	#SCMD_STREAM_SEND
	sta.l	REG_APUIO0

_stream_wait2:
	lda.l	REG_APUIO0
	beq	_stream_wait2

_stream_wait3:
	lda.l	REG_APUIO0
	bne	_stream_wait3

	lda.l	REG_APUIO2
	beq	_stream_update_done

	Accu16

	lda.w	__tccs_spc_stream_block_src+0
	sta	brr_stream_src+0
	lda.w	__tccs_spc_stream_block_src+2
	sta	brr_stream_src+2
	lda.w	__tccs_spc_stream_block_repeat
	beq	_norepeat

	dec.w	__tccs_spc_stream_block_repeat
	ldy.w	__tccs_spc_stream_block_ptr_prev

	bra	_stream_update_send

_norepeat:
	ldy.w	__tccs_spc_stream_block_ptr

	Accu8

	lda	[brr_stream_src],y
	iny

	Accu16

	and.w	#$00ff
	lsr	a
	bcc	_stream_update_repeat

	sta.w	__tccs_spc_stream_block_repeat
	sty.w	__tccs_spc_stream_block_ptr
	cpy.w	__tccs_spc_stream_block_size
	bcc	_stream_update_nojump1

	inc.w	__tccs_spc_stream_block
	jsr	_stream_set_block

_stream_update_nojump1:
	ldy.w	__tccs_spc_stream_block_ptr_prev
	bra	_stream_update_send

_stream_update_repeat:
	lda.w	__tccs_spc_stream_block_ptr
	sta.w	__tccs_spc_stream_block_ptr_prev
	tay
	clc
	adc.w	#9
	sta.w	__tccs_spc_stream_block_ptr
	cmp.w	__tccs_spc_stream_block_size
	bcc	_stream_update_send

	inc.w	__tccs_spc_stream_block
	phy
	jsr	_stream_set_block
	ply

_stream_update_send:
	Accu8

	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO1
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO2
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO3

	lda	#1
	sta.l	REG_APUIO0
	inc	a

_stream_wait5:
	cmp.l	REG_APUIO0
	bne	_stream_wait5

	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO1
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO2
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO3

	lda	#2
	sta.l	REG_APUIO0
	inc	a

_stream_wait6:
	cmp.l	REG_APUIO0
	bne	_stream_wait6

	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO1
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO2
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	REG_APUIO3

	lda	#3
	sta.l	REG_APUIO0

	jmp	_stream_update_loop


_stream_set_block:
	lda.w	__tccs_spc_stream_block_list+0
	sta	brr_stream_list+0
	lda.w	__tccs_spc_stream_block_list+2
	sta	brr_stream_list+2

	lda.w	__tccs_spc_stream_block
	asl	a
	asl	a
	tay

	lda	$000C32, y ;[brr_stream_list],y
	iny
	iny
	sta.w	__tccs_spc_stream_block_src+0
	
	lda	$000C32, y ;[brr_stream_list],y
	iny
	iny
	sta.w	__tccs_spc_stream_block_src+2
	ora.w	__tccs_spc_stream_block_src+0
	bne	_noeof
	
	lda.w	#1
	sta.w	__tccs_spc_stream_stop_flag

_noeof:
	lda.w	__tccs_spc_stream_block_src+0
	sta	brr_stream_list+0
	lda.w	__tccs_spc_stream_block_src+2
	sta	brr_stream_list+2
	ldy	#0
	lda	$000C32, y ;[brr_stream_list],y
	sta.w	__tccs_spc_stream_block_size
	stz.w	__tccs_spc_stream_block_repeat
	lda.w	#2
	sta.w	__tccs_spc_stream_block_ptr
	sta.w	__tccs_spc_stream_block_ptr_prev
	rts

.ASM



; ******************************** EOF *********************************
