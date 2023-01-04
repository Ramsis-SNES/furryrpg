;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** MUSIC HANDLER ***
;
;==========================================================================================



; ************************ Song loading/playing ************************

LoadTrackGSS:								; this routine uploads GSS music data (using track no. in DP2.NextTrack) to the SPC700
	.ACCU 8
	.INDEX 16

	DisableIRQs



; Upload pointers
/*	SNESGSS_Command kGSS_LOAD, 0

	Accu16

	lda	<DP2.NextTrack						; get pointers for requested song
	asl	a
	tax
	lda.l	PTR_TrackPointerBank, x					; set source bank byte of pointers
	sta	<DP2.SNESlib_ptr+2
	lda.l	PTR_TrackPointerOffset, x				; set source address of pointers
	sta	<DP2.SNESlib_ptr
	lda	#6							; data length = 3 16-bit pointers to ADSR table, SFX, and music
	sta	<DP2.SPC_DataSize
	lda	#SPC700_GSS_Driver+8					; overwrite old/meaningless pointers embedded in the driver code already residing in SPC700 memory
	sta	<DP2.SPC_DataDestAddr
	jsl	spc_load_data						; upload pointers
*/

	SNESGSS_Command kGSS_LOAD, 0

	Accu16

	lda	<DP2.NextTrack						; get pointers for requested song
	asl	a
	tax
	lda.l	PTR_TrackPointerBank, x					; set source bank byte of pointers
	sta	<DP2.SNESlib_ptr+2
	lda.l	PTR_TrackPointerOffset, x				; set source address of pointers
	sta	<DP2.SNESlib_ptr

	Accu8

	ldy	#kGSS_DriverOffset+8					; overwrite old/meaningless pointers embedded in the driver code in SPC700 RAM
	jsr	spc_begin_upload					; (this also resets Y index)

-	lda	[<DP2.SNESlib_ptr], y
	jsr	spc_upload_byte						; upload pointers, this also increments Y index

	cpy	#6							; data length = 3 16-bit pointers to ADSR table, SFX, and music
	bne	-

	ldy	#kGSS_DriverOffset
	jsr	spc_execute



; Upload samples
	SNESGSS_Command kGSS_LOAD, 0

	Accu16

	lda	<DP2.NextTrack						; get samples for requested song
	asl	a
	tax
	lda.l	PTR_TrackSamplesBank, x					; set source bank byte of sample pack
	sta	<DP2.SNESlib_ptr+2
	lda.l	PTR_TrackSamplesOffset, x				; set source address of sample pack
	sta	<DP2.SNESlib_ptr
	lda.l	SRC_TrackSamplesSize, x					; data length = size of sample pack
	sta	<DP2.SPC_DataSize
	lda	#kGSS_DriverOffset+_sizeof_SRC_SPC700_driver		; store samples after driver code in SPC700 memory
	sta	<DP2.SPC_DataDestAddr
	jsl	spc_load_data						; upload samples



; Upload notes
	SNESGSS_Command kGSS_LOAD, 0

	Accu16

	lda	<DP2.NextTrack						; get music notes for requested song
	asl	a
	tax
	lda.l	PTR_TrackNotesBank, x					; set source bank byte of notes data
	sta	<DP2.SNESlib_ptr+2
	lda.l	PTR_TrackNotesOffset, x					; set source address of notes data
	sta	<DP2.SNESlib_ptr
	lda.l	SRC_TrackNotesSize, x					; data length = size of notes data
	sta	<DP2.SPC_DataSize
	lda.l	SRC_TrackSamplesSize, x					; store notes after samples in SPC700 memory
	clc
	adc	#kGSS_DriverOffset+_sizeof_SRC_SPC700_driver
	sta	<DP2.SPC_DataDestAddr
	jsl	spc_load_data						; upload notes

	SNESGSS_Command kGSS_INITIALIZE, 0				; initialize sound driver again (this is important, or else the song won't play correctly)

	.IFNDEF UseCustomGSSDriver
		SNESGSS_Command kGSS_STEREO, 1				; original SNESGSS sound driver initializes to mono playback, so send stereo command
	.ENDIF



; Re-enable IRQ/NMI
	lda.l	RDNMI							; clear NMI flag
	lda.l	LO8.NMITIMEN						; re-enable interrupts
	sta.l	NMITIMEN
	cli

	rtl



PlayTrackGSS:								; this routine sets the volume and sends the play command to the GSS sound driver
	DisableIRQs							; reminder: this was moved here from the original SNESGSS routines as of build #00203

	SNESGSS_Command kGSS_GLOBAL_VOLUME, $FF7F			; fade speed: 255, global volume: 127)
	SNESGSS_Command kGSS_MUSIC_PLAY, 0

	lda.l	RDNMI							; clear NMI flag
	lda.l	LO8.NMITIMEN						; re-enable interrupts
	sta.l	NMITIMEN
	cli

	rtl



; **************************** Song library ****************************

PTR_TrackPointerBank:
	.DW bankbyte(SRC_track_00_pointers)
	.DW bankbyte(SRC_track_01_pointers)
	.DW bankbyte(SRC_track_02_pointers)
	.DW bankbyte(SRC_track_03_pointers)
	.DW bankbyte(SRC_track_04_pointers)
	.DW bankbyte(SRC_track_05_pointers)
	.DW bankbyte(SRC_track_06_pointers)
	.DW bankbyte(SRC_track_07_pointers)
	.DW bankbyte(SRC_track_08_pointers)
	.DW bankbyte(SRC_track_09_pointers)
	.DW bankbyte(SRC_track_10_pointers)
	.DW bankbyte(SRC_track_10_pointers)					; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW bankbyte(SRC_track_10_pointers)					; ditto for track #12



PTR_TrackPointerOffset:
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



PTR_TrackSamplesBank:
	.DW bankbyte(SRC_track_00_samples)
	.DW bankbyte(SRC_track_01_samples)
	.DW bankbyte(SRC_track_02_samples)
	.DW bankbyte(SRC_track_03_samples)
	.DW bankbyte(SRC_track_04_samples)
	.DW bankbyte(SRC_track_05_samples)
	.DW bankbyte(SRC_track_06_samples)
	.DW bankbyte(SRC_track_07_samples)
	.DW bankbyte(SRC_track_08_samples)
	.DW bankbyte(SRC_track_09_samples)
	.DW bankbyte(SRC_track_10_samples)
	.DW bankbyte(SRC_track_10_samples)					; sic, track #11 uses the same instrument settings as #10 (for now)
	.DW bankbyte(SRC_track_10_samples)					; ditto for track #12



PTR_TrackSamplesOffset:
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



SRC_TrackSamplesSize:
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



PTR_TrackNotesBank:
	.DW bankbyte(SRC_track_00_Notes)
	.DW bankbyte(SRC_track_01_Notes)
	.DW bankbyte(SRC_track_02_Notes)
	.DW bankbyte(SRC_track_03_Notes)
	.DW bankbyte(SRC_track_04_Notes)
	.DW bankbyte(SRC_track_05_Notes)
	.DW bankbyte(SRC_track_06_Notes)
	.DW bankbyte(SRC_track_07_Notes)
	.DW bankbyte(SRC_track_08_Notes)
	.DW bankbyte(SRC_track_09_Notes)
	.DW bankbyte(SRC_track_10_Notes)
	.DW bankbyte(SRC_track_11_Notes)
	.DW bankbyte(SRC_track_12_Notes)



PTR_TrackNotesOffset:
	.DW SRC_track_00_Notes
	.DW SRC_track_01_Notes
	.DW SRC_track_02_Notes
	.DW SRC_track_03_Notes
	.DW SRC_track_04_Notes
	.DW SRC_track_05_Notes
	.DW SRC_track_06_Notes
	.DW SRC_track_07_Notes
	.DW SRC_track_08_Notes
	.DW SRC_track_09_Notes
	.DW SRC_track_10_Notes
	.DW SRC_track_11_Notes
	.DW SRC_track_12_Notes



SRC_TrackNotesSize:							; used to be.INCBINs of the first two bytes of music/*-music.bin, but _sizeof_ definitions are clearer (and consistent with SRC_TrackSamplesSize)
	.DW _sizeof_SRC_track_00_Notes
	.DW _sizeof_SRC_track_01_Notes
	.DW _sizeof_SRC_track_02_Notes
	.DW _sizeof_SRC_track_03_Notes
	.DW _sizeof_SRC_track_04_Notes
	.DW _sizeof_SRC_track_05_Notes
	.DW _sizeof_SRC_track_06_Notes
	.DW _sizeof_SRC_track_07_Notes
	.DW _sizeof_SRC_track_08_Notes
	.DW _sizeof_SRC_track_09_Notes
	.DW _sizeof_SRC_track_10_Notes
	.DW _sizeof_SRC_track_11_Notes
	.DW _sizeof_SRC_track_12_Notes



; ***************************** MSU1 stuff *****************************

	.ACCU 8

	.ENDASM

	lda	#$81							; VBlank NMI + Auto Joypad Read
	sta	NMITIMEN						; re-enable VBlank NMI
	cli

	SetTextPos	0, 0
	PrintString	"Currently playing song #\\n\\n"
	PrintString	"Press A to toggle between songs.\\n"
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

	lda	<DP2.Joy1New
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

	lda	<DP2.Joy1New
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
