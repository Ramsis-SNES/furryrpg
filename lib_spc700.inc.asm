;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** SPC700/SNESGSS INTERFACE ***
;
;==========================================================================================



; ************************** SNESGSS routines **************************

spc_load_data:
	php								; preserve processor status
	phb								; preserve DBR

	Accu8

	SetDBR	$00							; set Data Bank = $00 for 16-bit register access

	AccuIndex16

	stz	LO8.TimeoutCounter					; reset timeout counter
	ldx	<DP2.SPC_DataSize					; X = data size
	ldy	#0							; Y = data index
	lda	#$bbaa							; IPL ready signature

@wait1:
	SPC700_WaitAB

	cmp	APUIO0
	bne	@wait1

	stz	LO8.TimeoutCounter					; reset timeout counter
	lda	<DP2.SPC_DataDestAddr
	sta	APUIO2
	lda	#$01cc							; IPL load and ready signature
	sta	APUIO0

	Accu8

@wait2:
	SPC700_WaitA

	cmp	APUIO0
	bne	@wait2

	stz	LO8.TimeoutCounter					; reset timeout counter
	stz	LO8.TimeoutCounter+1

@load1:
	lda	[<DP2.SNESlib_ptr], y
	sta	APUIO1
	tya
	sta	APUIO0
	iny
	
@load2:
	SPC700_WaitA

	cmp	APUIO0
	bne	@load2

	stz	LO8.TimeoutCounter					; reset timeout counter
	stz	LO8.TimeoutCounter+1
	dex
	bne	@load1

	iny
	bne	@load3
	iny
	
@load3:
	Accu16

	lda	#kGSS_DriverOffset					;loaded code starting address
	sta	APUIO2

	Accu8

	lda	#$00							;execute code
	sta	APUIO1	
	tya								;stop transfer
	sta	APUIO0

	Accu16

@load5:
	SPC700_WaitAB

	lda	APUIO0							;wait until SPC700 clears all communication ports, confirming that code has started
	ora	APUIO2
	bne	@load5

	stz	LO8.TimeoutCounter					; reset timeout counter
	plb								; restore DBR
	plp								; restore processor status

	rtl



	.ACCU 8

spc_command_asm:							; FIXME, we need to disable NMI/IRQ for this
;	DisableIRQs

-	SPC700_WaitA

	lda.l	APUIO0
	bne	-

	Accu16

	stz	LO8.TimeoutCounter					; reset timeout counter

	lda	<DP2.GSS_param
	sta.l	APUIO2

	lda	<DP2.GSS_command

	Accu8

	xba								; avoid 16-bit writes to APUIO0 (cf. Fullsnes)
	sta.l	APUIO1
	xba
	sta.l	APUIO0
;	cmp	#kGSS_LOAD						;don't wait acknowledge
;	beq	+

;	Accu8

-	SPC700_WaitA

	lda.l	APUIO0
	beq	-

	stz	LO8.TimeoutCounter					; reset timeout counter
	stz	LO8.TimeoutCounter+1

;+	Accu8								; LAST ADD 200

;	lda.l	RDNMI							; clear NMI flag
;	lda.l	LO8.NMITIMEN						; re-enable interrupts
;	sta.l	NMITIMEN
;	cli

	rtl

	

	.ENDASM

;void spc_command(unsigned int command,unsigned int param);

spc_command:
	php

	AccuIndex16

	lda	7,s							;param
	sta	<DP2.GSS_param
	lda	5,s							;command
	sta	<DP2.GSS_command
	jsl	spc_command_asm

	plp

	rtl



;void spc_stereo(unsigned int stereo);

spc_stereo:
	php

	AccuIndex16

	lda	5,s							;stereo
	sta	<DP2.GSS_param
	lda.w	#gss_STEREO
	sta	<DP2.GSS_command
	jsl	spc_command_asm

	plp

	rtl
	
	
	
;void spc_global_volume(unsigned int volume,unsigned int speed);

spc_global_volume:
	php

	AccuIndex16

	lda	7,s							;speed
	xba
	and.w	#$ff00
	sta	<DP2.GSS_param
	lda	5,s							;volume
	and.w	#$00ff
	ora	<DP2.GSS_param
	sta	<DP2.GSS_param
	lda.w	#gss_GLOBAL_VOLUME
	sta	<DP2.GSS_command
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
	sta	<DP2.GSS_param
	lda	7,s							;volume
	and.w	#$00ff
	ora	<DP2.GSS_param
	sta	<DP2.GSS_param
	lda.w	#gss_CHANNEL_VOLUME
	sta	<DP2.GSS_command
	jsl	spc_command_asm

	plp

	rtl
	

	
;void music_stop(void);

music_stop:
	php

	AccuIndex16

	lda.w	#gss_MUSIC_STOP
	sta	<DP2.GSS_command
	stz	<DP2.GSS_param
	jsl	spc_command_asm

	plp

	rtl
	

	
;void music_pause(unsigned int pause);

music_pause:
	php

	AccuIndex16

	lda	5,s							;pause
	sta	<DP2.GSS_param
	lda.w	#gss_MUSIC_PAUSE
	sta	<DP2.GSS_command
	jsl	spc_command_asm

	plp

	rtl
	
	
	
;void sound_stop_all(void);

sound_stop_all:
	php

	AccuIndex16

	lda.w	#gss_STOP_ALL_SOUNDS
	sta	<DP2.GSS_command
	stz	<DP2.GSS_param
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
	sta	<DP2.GSS_param
	lda	7,s							;sfx number
	and.w	#$00ff
	ora	<DP2.GSS_param
	sta	<DP2.GSS_param
	lda	9,s							;volume
	xba
	and.w	#$ff00
	sta	<DP2.GSS_command
	lda	5,s							;chn
	asl	a
	asl	a
	asl	a
	asl	a
	and.w	#$00f0
	ora.w	#gss_SFX_PLAY
	ora	<DP2.GSS_command
	sta	<DP2.GSS_command
	jsl	spc_command_asm

	plp

	rtl
	


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
	lda.l	APUIO0
	bne	_stream_wait7
	lda.b	#gss_STREAM_STOP
	sta.l	APUIO0

_stream_wait8:
	lda.l	APUIO0
	beq	_stream_wait8
	bra	_stream_update_done

_stream_update_play:
	Accu8

_stream_wait1:
	lda.l	APUIO0
	bne	_stream_wait1
	lda.b	#gss_STREAM_SEND
	sta.l	APUIO0

_stream_wait2:
	lda.l	APUIO0
	beq	_stream_wait2

_stream_wait3:
	lda.l	APUIO0
	bne	_stream_wait3

	lda.l	APUIO2
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
	sta.l	APUIO1
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO2
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO3

	lda	#1
	sta.l	APUIO0
	inc	a

_stream_wait5:
	cmp.l	APUIO0
	bne	_stream_wait5

	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO1
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO2
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO3

	lda	#2
	sta.l	APUIO0
	inc	a

_stream_wait6:
	cmp.l	APUIO0
	bne	_stream_wait6

	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO1
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO2
	lda	$000C2E, y ;[brr_stream_src],y
	iny
	sta.l	APUIO3

	lda	#3
	sta.l	APUIO0

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



; ************************** SPCload routines **************************

FastUploadSoundDriver:
	phd								; preserve DP and data bank
	phb

	ldy	#$0002
	jsr	spc_begin_upload

; ---- First, upload transfer routine

	ldx	#$0000
-	lda.l	SRC_BlarggTransfer, x
	jsr	spc_upload_byte
	inx
	cpy	#_sizeof_SRC_BlarggTransfer
	bne	-

	Accu16

	SetDP	$2100							; set Direct Page to APU registers

	Accu8

; Next, upload driver using burst transfer routine. Initial routine (65816 side) contains address/size values for SNESGSS driver

;	jsl	SRC_RAM_Routines@BurstTransferSPC700
	jsl	RAM.Routines.BurstTransferSPC700

	plb								; restore data bank & DP
	pld

	rts



spc_begin_upload:
	sty	APUIO2							; Set address
	ldy	#$BBAA							; Wait for SPC
-	cpy	APUIO0
	bne	-

	lda	#$CC							; Send acknowledgement
	sta	APUIO1
	sta	APUIO0
-	cmp	APUIO0							; Wait for acknowledgement
	bne	-

	ldy	#0							; Initialize index
	rts



spc_execute:
	sty	APUIO2
	stz	APUIO1
	lda	APUIO0
	inc	a
	inc	a
	sta	APUIO0

; Wait for acknowledgement
-	cmp	APUIO0
	bne	-

	rts



spc_upload_byte:
	sta	APUIO1
	tya								; Signal it's ready
	sta	APUIO0
-	cmp	APUIO0							; Wait for acknowledgement
	bne	-

	iny
	rts



	.ENDASM

spc_next_upload:
	sty	APUIO2

; Send command
; Special case operation has been fully tested.
	lda	APUIO0
	inc	a
	inc	a
	bne	+
	inc	a
+	sta	APUIO1
	sta	APUIO0

; Wait for acknowledgement
-	cmp	APUIO0
	bne	-

	ldy	#0
	rts



start_exec_io:

; Set execution address
	ldx	#$00F5
	stx	APUIO2
	stz	APUIO1      						; NOP
	ldx	#$FE2F      						; BRA *-2

; Signal to SPC that we're ready
	lda	APUIO0
	inc	a
	inc	a
	sta	APUIO0

; Wait for acknowledgement
-	cmp	APUIO0
	bne	-

; Quickly write branch
	stx	APUIO2
	rts

;---------------------------------------

exec_instr:

; Replace instruction
	stx	APUIO0
	lda	#$FC
	sta	APUIO3      						; 30

        ; SPC BRA loop takes 4 cycles, so it reads
        ; the branch offset every 4 SPC cycles (84 master).
        ; We must handle the case where it read just before
        ; the write above, and when it reads just after it.
        ; If it reads just after, we have at least 7 SPC
        ; cycles (147 master) to change restore the branch
        ; offset.

        ; 48 minimum, 90 maximum
        ora	#0
        ora	#0
        ora	#0
        nop
        nop
        nop

        ; 66 delay, about the middle of the above limits
	phd ;4
	pld ;5

        ; Give plenty of extra time if single execution
        ; isn't needed, as this avoids such tight timing
        ; requirements.

	phd ;4
	pld ;5
	phd ;4
	pld ;5

        ; Patch loop to skip first two bytes
	lda	#$FE        	; 16
	sta	APUIO3      ; 30

        ; 38 minimum (assuming 66 delay above)
	phd ; 4
	pld ; 5

        ; Give plenty of extra time if single execution
        ; isn't needed, as this avoids such tight timing
        ; requirements.

	phd
	pld
	phd
	pld
	rts

	.ASM



; **************************** SPC700 code *****************************

; SPC transfer routine by Shay Green <gblargg@gmail.com>

SRC_BlarggTransfer:							; .org $0002

;	.byt $CD,$FE		;	mov x,#$FE			; transfer 254 pages
	.byt $CD,$0B		;	mov x,#$0B			; test: transfer 11 pages for driver

	; Transfer four-byte chunks
	.byt $8D,$3F		; page: mov y,#$3F
	.byt $E4,$F4		; quad: mov a,$F4
	.byt $D6,$00,$02	; mov0: mov !$0200+y,a
	.byt $E4,$F5		;	mov a,$F5
	.byt $D6,$40,$02	; mov1: mov !$0240+y,a
	.byt $E4,$F6		;	mov a,$F6
	.byt $D6,$80,$02	; mov2: mov !$0280+y,a
	.byt $E4,$F7		;	mov a,$F7			; tell S-CPU we're ready for more
	.byt $CB,$F7		;	mov $F7,Y
	.byt $D6,$C0,$02	; mov3: mov !$02C0+y,a
	.byt $00		;	nop				; give some time for S-CPU HDMA / WRAM refresh
	.byt $DC 		;	dec	y
	.byt $10,-26		;	bpl quad
	; Increment MSBs of addresses
	.byt $AB,$0A		;	inc	mov0+2
	.byt $AB,$0F		;	inc	mov1+2
	.byt $AB,$14		;	inc	mov2+2
	.byt $AB,$1B		;	inc	mov3+2
	.byt $1D    		;	dec	x
	.byt $D0,-39		;	bne	page
	; Rerun loader
;	.byt $5F,$C0,$FF	;	jmp $FFC0
	.byt $5F,$00,$02	;	jmp $0200			; jump directly to driver code



; ******************************** EOF *********************************
