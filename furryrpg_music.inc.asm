;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MUSIC HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

LoadTrackGSS:
	DisableIRQs

	Accu16

	lda.w	#SCMD_LOAD
	sta	gss_command
	stz	gss_param
	jsl	spc_command_asm

	Accu16

	lda	DP_NextTrack
	asl	a
	tax
	lda.l	SRC_TrackPtrBankTable, x				; read bank byte of pointers
	sta	DP_SPC_DataBank
	lda.l	SRC_TrackPtrOffsetTable, x				; read offset of pointers
	sta	DP_SPC_DataOffset
	lda	#6							; data length = 3 16-bit pointers to ADSR table, SFX, and music
	sta	DP_SPC_DataSize
	lda	#$0208							; store pointers to SPC700 memory address $208
	sta	DP_SPC_DataAddress
	jsl	spc_load_data

	Accu16

	lda.w	#SCMD_LOAD
	sta	gss_command
	stz	gss_param
	jsl	spc_command_asm

	Accu16

	lda	DP_NextTrack
	asl	a
	tax
	lda.l	SRC_TrackSmpBankTable, x				; read bank byte of sample pack
	sta	DP_SPC_DataBank
	lda.l	SRC_TrackSmpOffsetTable, x				; read offset of sample pack
	sta	DP_SPC_DataOffset
	lda.l	SRC_TrackSmpLengthTable, x				; data length
	sta	DP_SPC_DataSize
	lda	#$0B24							; store samples to SPC700 memory address $B24 ($200 + $924, where $924 = size of sound driver)
	sta	DP_SPC_DataAddress
	jsl	spc_load_data

	Accu16

	lda.w	#SCMD_LOAD
	sta	gss_command
	stz	gss_param
	jsl	spc_command_asm

	Accu16

	lda	DP_NextTrack
	asl	a
	tax
	lda.l	SRC_TrackNotBankTable, x				; read bank byte of Notes data
	sta	DP_SPC_DataBank
	lda.l	SRC_TrackNotOffsetTable, x				; read offset of Notes data (excluding 2 bytes at the beginning, denoting file size)
	sta	DP_SPC_DataOffset
	lda.l	SRC_TrackNotSizeTable, x				; read file size
	sta	DP_SPC_DataSize
	lda.l	SRC_TrackSmpLengthTable, x				; store samples to SPC700 memory address $B24 + size of sample pack
	clc
	adc	#$0B24
	sta	DP_SPC_DataAddress
	jsl	spc_load_data

	Accu16

	lda.w	#SCMD_INITIALIZE					; this is important, or else the song won't play correctly
	sta	gss_command
	stz	gss_param
	jsl	spc_command_asm

	lda.l	REG_RDNMI						; clear NMI flag
	lda.l	DP_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli
	rtl



PlayTrackGSS:
	DisableIRQs							; reminder: this was moved here from the original SNESGSS routines as of build #00203

	Accu16

	lda	#SCMD_STEREO						; default output is mono, so issue stereo command ...
	sta	gss_command
	lda	#1							; ... with 1 as parameter
	sta	gss_param
	jsl	spc_command_asm

	Accu16

	lda	#$00FF
	sta	DP_SPC_VolFadeSpeed
	lda	#$007F
	sta	DP_SPC_VolCurrent
	jsl	spc_global_volume

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
	rtl



PlayTrackNow:
	DisableIRQs

	jsl	music_stop
	jsl	LoadTrackGSS
	jsl	PlayTrackGSS

	rts



SRC_TrackPtrBankTable:
	.DW :SRC_track_00_pointers
	.DW :SRC_track_01_pointers
	.DW :SRC_track_02_pointers
	.DW :SRC_track_03_pointers
	.DW :SRC_track_04_pointers
	.DW :SRC_track_05_pointers
	.DW :SRC_track_06_pointers
	.DW :SRC_track_07_pointers
	.DW :SRC_track_08_pointers
	.DW :SRC_track_09_pointers
	.DW :SRC_track_10_pointers
	.DW :SRC_track_10_pointers					; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW :SRC_track_10_pointers					; ditto for track #12



SRC_TrackPtrOffsetTable:
	.DW SRC_track_00_pointers
	.DW SRC_track_01_pointers
	.DW SRC_track_02_pointers
	.DW SRC_track_03_pointers
	.DW SRC_track_04_pointers
	.DW SRC_track_05_pointers
	.DW SRC_track_06_pointers
	.DW SRC_track_07_pointers
	.DW SRC_track_08_pointers
	.DW SRC_track_09_pointers
	.DW SRC_track_10_pointers
	.DW SRC_track_10_pointers					; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW SRC_track_10_pointers					; ditto for track #12



SRC_TrackSmpBankTable:
	.DW :SRC_track_00_samples
	.DW :SRC_track_01_samples
	.DW :SRC_track_02_samples
	.DW :SRC_track_03_samples
	.DW :SRC_track_04_samples
	.DW :SRC_track_05_samples
	.DW :SRC_track_06_samples
	.DW :SRC_track_07_samples
	.DW :SRC_track_08_samples
	.DW :SRC_track_09_samples
	.DW :SRC_track_10_samples
	.DW :SRC_track_10_samples					; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW :SRC_track_10_samples					; ditto for track #12



SRC_TrackSmpOffsetTable:
	.DW SRC_track_00_samples
	.DW SRC_track_01_samples
	.DW SRC_track_02_samples
	.DW SRC_track_03_samples
	.DW SRC_track_04_samples
	.DW SRC_track_05_samples
	.DW SRC_track_06_samples
	.DW SRC_track_07_samples
	.DW SRC_track_08_samples
	.DW SRC_track_09_samples
	.DW SRC_track_10_samples
	.DW SRC_track_10_samples					; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW SRC_track_10_samples					; ditto for track #12



SRC_TrackSmpLengthTable:
	.DW _sizeof_SRC_track_00_samples
	.DW _sizeof_SRC_track_01_samples
	.DW _sizeof_SRC_track_02_samples
	.DW _sizeof_SRC_track_03_samples
	.DW _sizeof_SRC_track_04_samples
	.DW _sizeof_SRC_track_05_samples
	.DW _sizeof_SRC_track_06_samples
	.DW _sizeof_SRC_track_07_samples
	.DW _sizeof_SRC_track_08_samples
	.DW _sizeof_SRC_track_09_samples
	.DW _sizeof_SRC_track_10_samples
	.DW _sizeof_SRC_track_10_samples				; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW _sizeof_SRC_track_10_samples				; ditto for track #12



SRC_TrackNotBankTable:
	.DW :SRC_track_00_Notes
	.DW :SRC_track_01_Notes
	.DW :SRC_track_02_Notes
	.DW :SRC_track_03_Notes
	.DW :SRC_track_04_Notes
	.DW :SRC_track_05_Notes
	.DW :SRC_track_06_Notes
	.DW :SRC_track_07_Notes
	.DW :SRC_track_08_Notes
	.DW :SRC_track_09_Notes
	.DW :SRC_track_10_Notes
	.DW :SRC_track_11_Notes
	.DW :SRC_track_12_Notes



SRC_TrackNotOffsetTable:
	.DW SRC_track_00_Notes+2
	.DW SRC_track_01_Notes+2
	.DW SRC_track_02_Notes+2
	.DW SRC_track_03_Notes+2
	.DW SRC_track_04_Notes+2
	.DW SRC_track_05_Notes+2
	.DW SRC_track_06_Notes+2
	.DW SRC_track_07_Notes+2
	.DW SRC_track_08_Notes+2
	.DW SRC_track_09_Notes+2
	.DW SRC_track_10_Notes+2
	.DW SRC_track_11_Notes+2
	.DW SRC_track_12_Notes+2



SRC_TrackNotSizeTable:
	.INCBIN Track00_Notes READ 2
	.INCBIN Track01_Notes READ 2
	.INCBIN Track02_Notes READ 2
	.INCBIN Track03_Notes READ 2
	.INCBIN Track04_Notes READ 2
	.INCBIN Track05_Notes READ 2
	.INCBIN Track06_Notes READ 2
	.INCBIN Track07_Notes READ 2
	.INCBIN Track08_Notes READ 2
	.INCBIN Track09_Notes READ 2
	.INCBIN Track10_Notes READ 2
	.INCBIN Track11_Notes READ 2
	.INCBIN Track12_Notes READ 2



SRC_TrackPointerTable:
	.DW STR_Track00
	.DW STR_Track01
	.DW STR_Track02
	.DW STR_Track03
	.DW STR_Track04
	.DW STR_Track05
	.DW STR_Track06
	.DW STR_Track07
	.DW STR_Track08
	.DW STR_Track09
	.DW STR_Track10
	.DW STR_Track11
	.DW STR_Track12



; Max:
;	.DB "XXXXXXXXXXXXXXXXXXXXXXXXXXX", 0

STR_Track00:
	.DB "00 Sun, Wind, And Rain     ", 0

STR_Track01:
	.DB "01 Through Darkness        ", 0

STR_Track02:
	.DB "02 Theme Of Despair        ", 0

STR_Track03:
	.DB "03 Three Buskers ...       ", 0

STR_Track04:
	.DB "04 ... And One Buffoon     ", 0

STR_Track05:
	.DB "05 Troubled Mind           ", 0

STR_Track06:
	.DB "06 Fanfare 1               ", 0

STR_Track07:
	.DB "07 Allons Ensemble!        ", 0

STR_Track08:
	.DB "08 Caterwauling            ", 0

STR_Track09:
	.DB "09 Contemplate             ", 0

STR_Track10:
	.DB "10 Temba's Theme           ", 0

STR_Track11:
	.DB "11 Triumph (Beta)          ", 0

STR_Track12:
	.DB "12 Furlorn Village         ", 0



; -------------------------- boot SPC700 with sound driver only, don't load music yet
BootSPC700:
	DisableIRQs

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
	sta	gss_command
	stz	gss_param
	jsl	spc_command_asm

	lda.l	DP_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli

	rtl



; ***************************** MSU1 stuff *****************************

.ACCU 8

CheckForMSU1:
	lda	MSU_ID							; check for "S-MSU1"
	cmp	#'S'
	bne	__NoMSU1
	lda	MSU_ID+1
	cmp	#'-'
	bne	__NoMSU1
	lda	MSU_ID+2
	cmp	#'M'
	bne	__NoMSU1
	lda	MSU_ID+3
	cmp	#'S'
	bne	__NoMSU1
	lda	MSU_ID+4
	cmp	#'U'
	bne	__NoMSU1
	lda	MSU_ID+5
	cmp	#'1'
	beq	__MSU1Found

__NoMSU1:
	lda	#%00000001
	trb	DP_GameConfig						; clear "MSU1 present" flag
	bra	+

__MSU1Found:
	lda	#%00000001
	tsb	DP_GameConfig						; set "MSU1 present" flag
+	rtl



.ENDASM

	lda	#$81							; VBlank NMI + Auto Joypad Read
	sta	$4200							; re-enable VBlank NMI
	cli

	SetTextPos	0, 0
	PrintString	"Currently playing song #\n\n"
	PrintString	"Press A to toggle between songs.\n"
	PrintString	"Song #0 will be resumed if #1 has been playing."



BackTo0:
	ldx	#$0000
	stx	MSU_TRACK

-	bit	MSU_STATUS						; wait for Audio Busy bit to clear
	bvs	-

	lda	#%00000011						; set play, repeat flags
	sta	MSU_CONTROL

	SetTextPos	0, 12
	PrintString	"0"

	lda	#$00
-	inc	a
	inc	a
	inc	a
	wai
	sta	MSU_VOLUME
	cmp	#$FF
	bne	-

MSUloop1:
	wai

	lda	DP_Joy1New
	and	#$80							; check for A button
	beq	MSUloop1

	lda	#$FF
-	dec	a
	dec	a
	dec	a
	wai
	sta	MSU_VOLUME
	bne	-

	lda	#%00000100						; clear play/repeat flags, set resume flag
	sta	MSU_CONTROL
	ldx	#$0001
	stx	MSU_TRACK

-	bit	MSU_STATUS						; wait for Audio Busy bit to clear
	bvs	-

	lda	#%00000011						; set play, repeat flags
	sta	MSU_CONTROL

	SetTextPos	0, 12
	PrintString	"1"

	lda	#$00
-	inc	a
	inc	a
	inc	a
	wai
	sta	MSU_VOLUME
	cmp	#$FF
	bne	-

MSUloop2:
	wai

	lda	DP_Joy1New
	and	#$80							; check for A button
	beq	MSUloop2

	lda	#$FF
-	dec	a
	dec	a
	dec	a
	wai
	sta	MSU_VOLUME
	bne	-

	jmp	BackTo0

.ASM



; ******************************** EOF *********************************
