;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MUSIC HANDLER ***
;
;==========================================================================================



; ************************** SNESGSS routines **************************

.ACCU 8
.INDEX 16

BootSPC700:								; this routine uploads only the SNESGSS sound driver to the SPC700, and initializes it (IRQ/NMI is still disabled)



; -------------------------- upload driver
	Accu16

	lda	#:SRC_spc700_driver					; set bank byte of driver code
	sta	DP_SPC_DataBank
	lda	#SRC_spc700_driver+2					; set offset of driver code (skipping first two bytes = size of driver code)
	sta	DP_SPC_DataOffset
	lda.l	SRC_spc700_driver					; data length = size of driver code (first two bytes of SRC_spc700_driver, should be $0924)
	sta	DP_SPC_DataSize
	lda	#$0200							; store driver to SPC700 memory address $0200 (3 track-specific 16-bit pointers at $0208-$020D are overwritten with correct data whenever an actual track is uploaded)
	sta	DP_SPC_DataAddress
	jsl	spc_load_data						; upload driver



; -------------------------- initialize sound driver for the first time
	Accu16

	lda.w	#SCMD_INITIALIZE					; send initialize command
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	rtl



LoadTrackGSS:								; this routine uploads GSS music data (song no. in DP_NextTrack) to the SPC700
	DisableIRQs



; -------------------------- upload pointers
	Accu16

	lda.w	#SCMD_LOAD						; send data load command
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	Accu16

	lda	DP_NextTrack						; get pointers for requested song
	asl	a
	tax
	lda.l	SRC_TrackPtrBankTable, x				; set bank byte of pointers
	sta	DP_SPC_DataBank
	lda.l	SRC_TrackPtrOffsetTable, x				; set offset of pointers
	sta	DP_SPC_DataOffset
	lda	#6							; data length = 3 16-bit pointers to ADSR table, SFX, and music
	sta	DP_SPC_DataSize
	lda	#$0208							; store pointers to SPC700 memory address $0208
	sta	DP_SPC_DataAddress
	jsl	spc_load_data						; upload pointers



; -------------------------- upload samples
	Accu16

	lda.w	#SCMD_LOAD						; send data load command
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	Accu16

	lda	DP_NextTrack						; get samples for requested song
	asl	a
	tax
	lda.l	SRC_TrackSmpBankTable, x				; set bank byte of sample pack
	sta	DP_SPC_DataBank
	lda.l	SRC_TrackSmpOffsetTable, x				; set offset of sample pack
	sta	DP_SPC_DataOffset
	lda.l	SRC_TrackSmpSizeTable, x				; data length = size of sample pack
	sta	DP_SPC_DataSize
	lda	#$0B24							; store samples to SPC700 memory address $0B24 ($0200 + $924, where $924 = size of sound driver)
	sta	DP_SPC_DataAddress
	jsl	spc_load_data						; upload samples



; -------------------------- upload notes
	Accu16

	lda.w	#SCMD_LOAD						; send data load command
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm

	Accu16

	lda	DP_NextTrack						; get music notes for requested song
	asl	a
	tax
	lda.l	SRC_TrackNotesBankTable, x				; set bank byte of notes data
	sta	DP_SPC_DataBank
	lda.l	SRC_TrackNotesOffsetTable, x				; set offset of notes data (excluding 2 bytes at the beginning, denoting file size)
	sta	DP_SPC_DataOffset
	lda.l	SRC_TrackNotesSizeTable, x				; data length = size of notes data
	sta	DP_SPC_DataSize
	lda.l	SRC_TrackSmpSizeTable, x				; store notes to SPC700 memory address ($0B24 + size of sample pack)
	clc
	adc	#$0B24
	sta	DP_SPC_DataAddress
	jsl	spc_load_data						; upload notes



; -------------------------- initialize sound driver again (this is important, or else the song won't play correctly)
	Accu16

	lda.w	#SCMD_INITIALIZE					; send initialize command
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm



; -------------------------- re-enable IRQ/NMI
.ACCU 8

	lda.l	REG_RDNMI						; clear NMI flag
	lda.l	VAR_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli
	rtl



PlayTrackGSS:								; this routine enables stereo, sets the volume and sends the play command to the GSS sound driver
	DisableIRQs							; reminder: this was moved here from the original SNESGSS routines as of build #00203



; -------------------------- set stereo
	Accu16

	lda	#SCMD_STEREO						; default output is mono, so issue stereo command ...
	sta	DP_GSS_command
	lda	#1							; ... with 1 as parameter
	sta	DP_GSS_param
	jsl	spc_command_asm



; -------------------------- set volume, fade speed
	Accu16

	lda	#$00FF
	sta	DP_SPC_VolFadeSpeed
	lda	#$007F
	sta	DP_SPC_VolCurrent
	jsl	spc_global_volume



; -------------------------- send play command
	Accu16

	lda.w	#SCMD_MUSIC_PLAY
	sta	DP_GSS_command
	stz	DP_GSS_param
	jsl	spc_command_asm



; -------------------------- re-enable IRQ/NMI
.ACCU 8

	lda.l	REG_RDNMI						; clear NMI flag
	lda.l	VAR_Shadow_NMITIMEN					; reenable interrupts
	sta.l	REG_NMITIMEN
	cli
	rtl



PlayTrackNow:								; this routine stops any music, loads a new track, and plays it instantly
	DisableIRQs

	jsl	music_stop
	jsl	LoadTrackGSS
	jsl	PlayTrackGSS

	rts



; **************************** SNESGSS data ****************************

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



SRC_TrackSmpSizeTable:
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



SRC_TrackNotesBankTable:
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



SRC_TrackNotesOffsetTable:
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



SRC_TrackNotesSizeTable:
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



SRC_TrackNamePointers:
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



; ***************************** MSU1 stuff *****************************

.ACCU 8

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
