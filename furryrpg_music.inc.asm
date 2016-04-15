;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** MUSIC HANDLER ***
;
;==========================================================================================



.ACCU 8
.INDEX 16

PlayTrack:
	DisableInterrupts			; reminder: this was moved here from the original SNESGSS routines as of build #00203

	jsl music_stop

	A16

	lda.w #SCMD_LOAD
	sta gss_command
	stz gss_param
	jsl spc_command_asm

	A16

	lda DP_NextTrack
	asl a

	tax

	lda.l SRC_TrackPtrBankTable, x		; read bank byte of pointers
	sta DP_SPC_DATA_BANK

	lda.l SRC_TrackPtrOffsetTable, x	; read offset of pointers
	sta DP_SPC_DATA_OFFS

	lda #6					; data length = 3 16-bit pointers to ADSR table, SFX, and music
	sta DP_SPC_DATA_SIZE

	lda #$0208				; store pointers to SPC700 memory address $208
	sta DP_SPC_DATA_ADDR

	jsl spc_load_data

	A16

	lda.w #SCMD_LOAD
	sta gss_command
	stz gss_param
	jsl spc_command_asm

	A16

	lda DP_NextTrack
	asl a

	tax

	lda.l SRC_TrackSmpBankTable, x		; read bank byte of sample pack
	sta DP_SPC_DATA_BANK

	lda.l SRC_TrackSmpOffsetTable, x	; read offset of sample pack
	sta DP_SPC_DATA_OFFS

	lda.l SRC_TrackSmpLengthTable, x	; data length
	sta DP_SPC_DATA_SIZE

	lda #$0B24				; store samples to SPC700 memory address $B24 ($200 + $924, where $924 = size of sound driver)
	sta DP_SPC_DATA_ADDR

	jsl spc_load_data

	A16

	lda.w #SCMD_LOAD
	sta gss_command
	stz gss_param
	jsl spc_command_asm

	A16

	lda DP_NextTrack
	asl a

	tax

	lda.l SRC_TrackNotBankTable, x		; read bank byte of notes data
	sta DP_SPC_DATA_BANK

	lda.l SRC_TrackNotOffsetTable, x	; read offset of notes data (excluding 2 bytes at the beginning, denoting file size)
	sta DP_SPC_DATA_OFFS

	lda.l SRC_TrackNotSizeTable, x		; read file size
	sta DP_SPC_DATA_SIZE

	lda.l SRC_TrackSmpLengthTable, x	; store samples to SPC700 memory address $B24 + size of sample pack
	clc
	adc #$0B24
	sta DP_SPC_DATA_ADDR

	jsl spc_load_data

	A16

	lda.w #SCMD_INITIALIZE			; this is important, or else the song won't play correctly
	sta gss_command
	stz gss_param
	jsl spc_command_asm

	A16

	lda #SCMD_STEREO			; default output is mono, so issue stereo command ...
	sta gss_command
	lda #1					; ... with 1 as parameter
	sta gss_param
	jsl spc_command_asm

	A16

	lda #$00FF
	sta DP_SPC_VOL_FADESPD

	lda #$007F
	sta DP_SPC_VOL_CURRENT
	jsl spc_global_volume

	A16

	lda.w #SCMD_MUSIC_PLAY
	sta gss_command
	stz gss_param
	jsl spc_command_asm

	A8

	lda.l REG_RDNMI				; clear NMI flag to prevent graphics glitches (see Fullsnes, 4210h/RDNMI)

	lda.l DP_Shadow_NMITIMEN		; reenable interrupts
	sta.l REG_NMITIMEN

	cli
rtl



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



SRC_TrackSmpLengthTable:
	.DW SRC_track_00_samples_END-SRC_track_00_samples
	.DW SRC_track_01_samples_END-SRC_track_01_samples
	.DW SRC_track_02_samples_END-SRC_track_02_samples
	.DW SRC_track_03_samples_END-SRC_track_03_samples
	.DW SRC_track_04_samples_END-SRC_track_04_samples
	.DW SRC_track_05_samples_END-SRC_track_05_samples
	.DW SRC_track_06_samples_END-SRC_track_06_samples
	.DW SRC_track_07_samples_END-SRC_track_07_samples
	.DW SRC_track_08_samples_END-SRC_track_08_samples
	.DW SRC_track_09_samples_END-SRC_track_09_samples



SRC_TrackNotBankTable:
	.DW :SRC_track_00_notes
	.DW :SRC_track_01_notes
	.DW :SRC_track_02_notes
	.DW :SRC_track_03_notes
	.DW :SRC_track_04_notes
	.DW :SRC_track_05_notes
	.DW :SRC_track_06_notes
	.DW :SRC_track_07_notes
	.DW :SRC_track_08_notes
	.DW :SRC_track_09_notes



SRC_TrackNotOffsetTable:
	.DW SRC_track_00_notes+2
	.DW SRC_track_01_notes+2
	.DW SRC_track_02_notes+2
	.DW SRC_track_03_notes+2
	.DW SRC_track_04_notes+2
	.DW SRC_track_05_notes+2
	.DW SRC_track_06_notes+2
	.DW SRC_track_07_notes+2
	.DW SRC_track_08_notes+2
	.DW SRC_track_09_notes+2



SRC_TrackNotSizeTable:
	.INCBIN TRACK00_NOTES READ 2
	.INCBIN TRACK01_NOTES READ 2
	.INCBIN TRACK02_NOTES READ 2
	.INCBIN TRACK03_NOTES READ 2
	.INCBIN TRACK04_NOTES READ 2
	.INCBIN TRACK05_NOTES READ 2
	.INCBIN TRACK06_NOTES READ 2
	.INCBIN TRACK07_NOTES READ 2
	.INCBIN TRACK08_NOTES READ 2
	.INCBIN TRACK09_NOTES READ 2



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

SRC_TrackPointerTable_END:



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



; -------------------------- boot SPC700 with sound driver only, don't load music yet
BootSPC700:
	DisableInterrupts

;	php					; preserve processor status

	A16

	lda #:SRC_spc700_driver
	sta DP_SPC_DATA_BANK

	lda #SRC_spc700_driver+2
	sta DP_SPC_DATA_OFFS

	lda.l SRC_spc700_driver
	sta DP_SPC_DATA_SIZE

	lda #$0200
	sta DP_SPC_DATA_ADDR

	jsl spc_load_data

	A16

	lda.w #SCMD_INITIALIZE
	sta gss_command
	stz gss_param
	jsl spc_command_asm

	lda.l DP_Shadow_NMITIMEN		; reenable interrupts
	sta.l REG_NMITIMEN

	cli

;	plp					; restore processor status
rtl



; ******************************** EOF *********************************
