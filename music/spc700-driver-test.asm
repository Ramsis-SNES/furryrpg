; SNESGSS sound driver code (0200 - 0B23)
;
; Disassembly, adjustments for reassembly with WLA-SPC700, and sound driver customizations
; (marked with "CUSTOM") by Ramsis, July 2022.
; Original code (using 6502-style syntax and mnemonics) by Shiru.
; Original comments (with preceding //) and labels taken from
; https://github.com/nathancassano/snesgss/blob/master/snes/spc700.asm.
;
; To assemble:
; wla-spc700 -v -o spc700-driver-test.o spc700-driver-test.asm
; wlalink -b -v spc700-driver-test.lnk spc700-driver-test.bin

.DEFINE SPC700_GSS_Driver	$0200		; address of SNESGSS driver code in sound RAM
.DEFINE UPDATE_RATE_HZ		160		; //quantization of music events

.DEFINE GSS_MusicUploadAddress	$0200



; //memory layout
; // $0000..$00ef direct page, all driver variables are there
; // $00f0..$00ff DSP registers
; // $0100..$01ff stack page
; // $0200..$nnnn driver code
; //        $xx00 sample directory
; //        $nnnn adsr data list
; //        $nnnn sound effects data
; //        $nnnn music data
; //		  $nnnn BRR streamer buffer



; //I/O registers

.DEFINE TEST 			$f0
.DEFINE CTRL 			$f1
.DEFINE ADDR 			$f2
.DEFINE DATA 			$f3
.DEFINE CPU0			$f4
.DEFINE CPU1 			$f5
.DEFINE CPU2 			$f6
.DEFINE CPU3 			$f7
.DEFINE TMP0 			$f8
.DEFINE TMP1 			$f9
.DEFINE T0TG 			$fa
.DEFINE T1TG 			$fb
.DEFINE T2TG 			$fc
.DEFINE T0OT 			$fd
.DEFINE T1OT 			$fe
.DEFINE T2OT 			$ff


; //DSP channel registers, x0..x9, x is channel number

.DEFINE DSP_VOLL  		$00
.DEFINE DSP_VOLR 		$01
.DEFINE DSP_PL   		$02
.DEFINE DSP_PH    		$03
.DEFINE DSP_SRCN  		$04
.DEFINE DSP_ADSR1 		$05
.DEFINE DSP_ADSR2 		$06
.DEFINE DSP_GAIN		$07
.DEFINE DSP_ENVX		$08
.DEFINE DSP_OUTX		$09


; //DSP registers for global settings

.DEFINE DSP_MVOLL 		$0c
.DEFINE DSP_MVOLR 		$1c
.DEFINE DSP_EVOLL 		$2c
.DEFINE DSP_EVOLR 		$3c
.DEFINE DSP_KON	 		$4c
.DEFINE DSP_KOF	 		$5c
.DEFINE DSP_FLG	 		$6c
.DEFINE DSP_ENDX		$7c
.DEFINE DSP_EFB	 		$0d
.DEFINE DSP_PMON		$2d
.DEFINE DSP_NON	 		$3d
.DEFINE DSP_EON	 		$4d
.DEFINE DSP_DIR	 		$5d
.DEFINE DSP_ESA	 		$6d
.DEFINE DSP_EDL	 		$7d
.DEFINE DSP_C0	 		$0f
.DEFINE DSP_C1	 		$1f
.DEFINE DSP_C2	 		$2f
.DEFINE DSP_C3	 		$3f
.DEFINE DSP_C4	 		$4f
.DEFINE DSP_C5	 		$5f
.DEFINE DSP_C6	 		$6f
.DEFINE DSP_C7			$7f


; //vars
; //max address for vars is $ef, because $f0..$ff is used for the I/O registers

; //first two bytes of the direct page are used by IPL!

.DEFINE D_STEREO		$02	; //byte
.DEFINE D_BUFPTR		$03	; //byte
.DEFINE D_ADSR_L		$04	; //byte
.DEFINE D_ADSR_H		$05	; //byte
.DEFINE D_CHx0 			$06	; //byte
.DEFINE D_CH0x 			$07	; //byte
.DEFINE D_KON	 		$08	; //byte
.DEFINE D_KOF	 		$09	; //byte
.DEFINE D_PAN			$0a	; //byte
.DEFINE D_VOL			$0b	; //byte
.DEFINE D_PTR_L			$0c	; //byte
.DEFINE D_PTR_H			$0d	; //byte
.DEFINE D_PITCH_UPD		$0e	; //byte
.DEFINE D_PITCH_L		$0f	; //byte
.DEFINE D_PITCH_H		$10	; //byte
.DEFINE D_TEMP			$11	; //byte
.DEFINE D_MUSIC_CHNS		$12	; //byte
.DEFINE D_PAUSE			$13	; //byte
.DEFINE D_EFFECTS_L		$14	; //byte
.DEFINE D_EFFECTS_H		$15	; //byte
.DEFINE D_GLOBAL_TGT		$16	; //byte
.DEFINE D_GLOBAL_OUT		$17	; //byte
.DEFINE D_GLOBAL_STEP		$18	; //byte
.DEFINE D_GLOBAL_DIV		$19	; //byte

.DEFINE S_ENABLE		$20	; //byte
.DEFINE S_BUFFER_OFF		$21	; //byte
.DEFINE S_BUFFER_PTR		$22	; //word
.DEFINE S_BUFFER_RD		$24	; //byte
.DEFINE S_BUFFER_WR		$25	; //byte

.DEFINE D_CHNVOL		$30	; //8 bytes
.DEFINE D_CHNPAN		$38	; //8 bytes

.DEFINE M_PTR_L			$48	; //8 bytes
.DEFINE M_PTR_H			$50	; //8 bytes
.DEFINE M_WAIT_L		$58	; //8 bytes
.DEFINE M_WAIT_H		$60	; //8 bytes
.DEFINE M_PITCH_L		$68	; //8 bytes
.DEFINE M_PITCH_H		$70	; //8 bytes
.DEFINE M_VOL			$78	; //8 bytes
.DEFINE M_DETUNE		$80	; //8 bytes
.DEFINE M_SLIDE			$88	; //8 bytes
.DEFINE M_PORTAMENTO		$90	; //8 bytes
.DEFINE M_PORTA_TO_L		$98	; //8 bytes
.DEFINE M_PORTA_TO_H		$a0	; //8 bytes
.DEFINE M_MODULATION		$a8	; //8 bytes
.DEFINE M_MOD_OFF		$b0	; //8 bytes
.DEFINE M_REF_LEN		$b8	; //8 bytes
.DEFINE M_REF_RET_L		$c0	; //8 bytes
.DEFINE M_REF_RET_H		$c8	; //8 bytes
.DEFINE M_INSTRUMENT		$d0	; //8 bytes

; //DSP registers write buffer located in the stack page, as it is not used for the most part
; //first four bytes are reserved for shortest echo buffer

.DEFINE D_BUFFER		$0104


.DEFINE streamBufSize		28		; //how many BRR blocks in a buffer, max is 28 (28*9=252)
.DEFINE streamSampleRate	16000		; //stream sample rate

.DEFINE streamData		$ffc0-(streamBufSize*9*9)	; //fixed location for streaming data

.DEFINE streamData1		streamData
.DEFINE streamData2		streamData1+(streamBufSize*9)
.DEFINE streamData3		streamData2+(streamBufSize*9)
.DEFINE streamData4		streamData3+(streamBufSize*9)
.DEFINE streamData5		streamData4+(streamBufSize*9)
.DEFINE streamData6		streamData5+(streamBufSize*9)
.DEFINE streamData7		streamData6+(streamBufSize*9)
.DEFINE streamData8		streamData7+(streamBufSize*9)
.DEFINE streamSync		streamData8+(streamBufSize*9)

.DEFINE streamPitch		(4096*streamSampleRate/32000)



.ROMBANKSIZE $10000
.ROMBANKS 1

.MEMORYMAP
	DEFAULTSLOT	0
	SLOTSIZE	$10000
	SLOT 0		$0000
.ENDME

.BANK 0 SLOT 0
.ORG SPC700_GSS_Driver-2			; start two bytes before address of driver code (for size word)

	.DW	EOF-_0200			; voilà (size of driver code)

_0200:	clrp
_0201:	mov	x, #$ef				; //stack is located in $100..$1ff
_0203:	mov	sp, x
_0204:	bra	mainLoopInit			; //$0204, editor should set two zeroes here

; Hmmm ... Does this mean the SNESGSS tracker software modifies the driver depending on
; features used, cf. lines 3464-3468 in UnitMain.cpp:

;	if(!effects)//if the effects aren't compiled, it is not for export
;	{
;		SPCMem[0x204]=0;//skip the bra mainLoopInit, to run preinitialized version of the driver
;		SPCMem[0x205]=0;
;	}

; (Not sure what the comment about sound effects is trying to say exactly??)

	bra	editorInit

sampleADSRPtr:
	.DW	0				; 16-bit pointer, to be patched in sound RAM by the song loading routine
;	.DW	sampleADSRAddr			; //$0208

soundEffectsDataPtr:
	.DW	0				; ditto
;	.DW	0				; //$020a

musicDataPtr:
	.DW	0				; ditto
;	.DW	musicDataAddr			; //$020c

editorInit:
@_020e:	call	!initDSPAndVars			; CUSTOM, this enables stereo now by default, as it should

;	mov	x, #1				; CUSTOM, good riddance
;	mov	D_STEREO, x			; CUSTOM, good riddance //enable stereo in the editor, mono by default
;	dec	x				; CUSTOM, good riddance
	mov	x, #0				; CUSTOM, x needs to be 0 before calling startMusic, cf. cmdMusicPlay
	call	!startMusic

mainLoopInit:
@_0219:	mov	a, #8000/UPDATE_RATE_HZ
@_021b:	mov	T0TG, a
@_021d:	mov	a, #$81				; //enable timer 0 and IPL
@_021f:	mov	CTRL, a
@_0221:	call	!setReady

; //main loop waits for next frame checking the timer
; //during the wait it checks and performs commands, also updates BRR streamer position (if enabled)

mainLoop:
@_0224:	mov	a, CPU0				; //read command code, when it is zero (kGSS_NONE), no new command
	cmp	a, CPU0				; CUSTOM, calima fix from https://forums.nesdev.org/viewtopic.php?p=229950#p229950
	bne	mainLoop			; CUSTOM, calima fix
	mov	y, a				; CUSTOM, calima fix
@_0226:	beq	commandDone
@_0228:	mov	CPU0, a				; //set busy flag for CPU by echoing a command code
@_022a:	mov	y, a
@_022b:	and	a, #$0f				; //get command offset in the jump table into X
@_022d:	asl	a
@_022e:	mov	x, a
@_022f:	mov	a, y
@_0230:	xcn	a				; //get channel number into Y
@_0231:	and	a, #$0f
@_0233:	mov	y, a
@_0234:	jmp	[!cmdList+x]

;//all commands jump back here

commandDone:
@_0237:	call	!updateBRRStreamerPos

@_023a:	mov	a, T0OT
@_023c:	beq	mainLoop
@_023e:	call	!updateGlobalVolume

@_0241:	call	!updateMusicPlayer

@_0244:	bra	mainLoop

cmdInitialize:
@_0246:	call	!setReady

@_0249:	call	!initDSPAndVars

@_024c:	bra	commandDone

cmdStereo:
@_024e:	mov	a, CPU2
@_0250:	mov	D_STEREO, a
@_0252:	call	!setReady

@_0255:	bra	commandDone

cmdGlobalVolume:
@_0257:	mov	a, CPU2				; //volume
@_0259:	mov	x, CPU3				; //change speed
@_025b:	call	!setReady

@_025e:	cmp	a, #127
@_0260:	bcc	@noClip
@_0262:	mov	a, #127

@noClip:
@_0264:	asl	a
@_0265:	mov	D_GLOBAL_TGT, a
@_0267:	mov	D_GLOBAL_STEP, x
@_0269:	bra	commandDone

cmdChannelVolume:
@_026b:	mov	a, CPU2				; //volume
	mov	x, CPU3				; //channel mask
	call	!setReady

	cmp	a, #127
	bcc	@noClip
	mov	a, #127

@noClip:
@_0278:	asl	a
	mov	y, a
	mov	a, x
	mov	x, #0

@check:
@_027d:	ror	a
	bcc	@noVol
	mov	D_CHNVOL+x, y

@noVol:
@_0282:	inc	x
	cmp	x, #8
	bne	@check

	call	!updateAllChannelsVolume

	bra	commandDone

cmdMusicPlay:
@_028c:	call	!setReady

@_028f:	mov	x, #0				; //music always uses channels starting from 0
@_0291:	mov	D_PAUSE, x			; //reset pause flag
@_0293:	call	!startMusic

@_0296:	jmp	!commandDone

cmdStopAllSounds:
@_0299:	call	!setReady

	mov	a, #8
	mov	D_MUSIC_CHNS, a
	bra	stopChannels

cmdMusicStop:
@_02a2:	call	!setReady

@_02a5:	mov	a, D_MUSIC_CHNS
@_02a7:	bne	stopChannels
@_02a9:	jmp	!commandDone

stopChannels:
@_02ac:	mov	a, #0

@loop:
@_02ae:	push	a
@_02af:	call	!setChannel

@_02b2:	mov	x, D_CH0x
@_02b4:	mov	a, #0
@_02b6:	mov	M_PTR_H+x, a
@_02b8:	call	!bufKeyOff

@_02bb:	pop	a
@_02bc:	inc	a
@_02bd:	dec	D_MUSIC_CHNS
@_02bf:	bne	@loop

@_02c1:	call	!bufKeyOffApply

@_02c4:	call	!bufKeyOnApply

@_02c7:	jmp	!commandDone

cmdMusicPause:
@_02ca:	mov	a, CPU2				; //pause state
	mov	D_PAUSE, a
	call	!setReady

	call	!updateAllChannelsVolume

	jmp	!commandDone

cmdSfxPlay:
@_02d7:	cmp	y, D_MUSIC_CHNS			; //don't play effects on music channels
	bcs	@play
	call	!setReady

	jmp	!commandDone

@play:
@_02e1:	mov	D_TEMP, y			; //remember requested channel
	mov	x, CPU1				; //volume
	mov	D_VOL, x
	mov	a, CPU2				; //effect number
	mov	x, CPU3				; //pan
	mov	D_PAN, x
	call	!setReady

	mov	y, #0				; //check if there is an effect with this number, just in case
	cmp	a, [D_EFFECTS_L]+y
	bcs	@done
	asl	a
	mov	y, a
	inc	y
	mov	a, [D_EFFECTS_L]+y
	mov	D_PTR_L, a
	inc	y
	mov	a, [D_EFFECTS_L]+y
	mov	D_PTR_H, a
	mov	x, D_TEMP
	call	!startSoundEffect

@done:
@_0307:	jmp	!commandDone

cmdLoad:
@_030a:	call	!setReady

@_030d:	call	!streamStop			; //stop BRR streaming to prevent glitches after loading

@_0310:	mov	x, #0
@_0312:	mov	D_KON, x
@_0314:	dec	x
@_0315:	mov	D_KOF, x
@_0317:	call	!bufKeyOffApply

@_031a:	mov	x, #$ef
@_031c:	mov	sp, x
@_031d:	jmp	!$ffc9

cmdFastLoad:
; Adapted from https://github.com/NovaSquirrel/snesgss-extended/blob/main/driver/snesgss_driver.s
	mov	x, CPU3      ; Number of pages
	mov	CPU2, #$80 ; Tell the 65c816 to start sending the data

	; Re-initialize the addresses for the self-modifying code
	; (Will result in multiple loads with the same value)
	mov	a, #>(GSS_MusicUploadAddress+$00)
	mov	!mA+2, a
	mov	a, #>(GSS_MusicUploadAddress+$40)
	mov	!mB+2, a
	mov	a, #>(GSS_MusicUploadAddress+$80)
	mov	!mC+2, a
	mov	a, #>(GSS_MusicUploadAddress+$C0)
	mov	!mD+2, a

	; ---------------------------------
	; Transfer four-byte chunks
	; ---------------------------------
page:
	mov	y, #$3f
quad:
	mov	a, CPU0
mA:	mov	!GSS_MusicUploadAddress+$00+y, a
	mov	a, CPU1
mB:	mov	!GSS_MusicUploadAddress+$40+y, a
	mov	a, CPU2
mC:	mov	!GSS_MusicUploadAddress+$80+y, a
	mov	a, CPU3
	mov	CPU2, y ; Tell 65c816 we're ready for more
mD:	mov	!GSS_MusicUploadAddress+$C0+y, a
	dec	y
	bpl	quad

	inc	!mA+2  ;Increment MSBs of addresses
	inc	!mB+2
	inc	!mC+2
	inc	!mD+2
	dec	x
	bne	page

	mov	<CPU2, #$00 ; Reset CPU2 so it's ready for the next time this command is called

	; Get ready for more commands
	call	!setReady
	jmp	!commandDone

cmdStreamStart:
@_0320:	call	!setReady

	mov	a, #0
	mov	S_BUFFER_WR, a
	mov	S_BUFFER_RD, a
	call	!streamSetBufPtr

	call	!streamClearBuffers

	mov	a, #$ff
	mov	S_ENABLE, a
	mov	x, #BRRStreamInitData&255
	mov	y, #BRRStreamInitData/256
	call	!sendDSPSequence

	mov	a, #0				; //sync channel volume to zero
	mov	!M_VOL+6, a
	mov	a, #127
	mov	!M_VOL+7, a
	call	!updateAllChannelsVolume

	jmp	!commandDone

cmdStreamStop:
@_034a:	call	!setReady

	call	!streamStop

	jmp	!commandDone

cmdStreamSend:
@_0353:	mov	a, S_ENABLE
	beq	@nosend
	mov	a, S_BUFFER_WR
	cmp	a, S_BUFFER_RD
	bne	@send

@nosend:
@_035d:	mov	a, #0
	mov	CPU2, a
	call	!setReady

	jmp	!commandDone

@send:
@_0367:	mov	a, #1
	mov	CPU2, a
	call	!setReady

	mov	x, #1

@wait1:
@_0370:	call	!updateBRRStreamerPos

	cmp	x, CPU0
	bne	@wait1
	mov	y, S_BUFFER_OFF
	mov	a, [S_BUFFER_PTR]+y		; //keep the flags
	and	a, #3
	or	a, CPU1
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	mov	a, CPU2
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	mov	a, CPU3
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	inc	x
	mov	CPU0, x

@wait2:
@_038f:	call	!updateBRRStreamerPos

	cmp	x, CPU0
	bne	@wait2
	mov	a, CPU1
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	mov	a, CPU2
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	mov	a, CPU3
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	inc	x
	mov	CPU0, x

@wait3:
@_03a8:	call	!updateBRRStreamerPos

	cmp	x, CPU0
	bne	@wait3
	mov	a, CPU1
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	mov	a, CPU2
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	mov	a, CPU3
	mov	[S_BUFFER_PTR]+y, a
	inc	y
	call	!setReady

	mov	a, #0
	mov	CPU2, a
	mov	S_BUFFER_OFF, y
	cmp	y, #streamBufSize*9
	bne	@skip
	mov	a, S_BUFFER_WR
	inc	a
	and	a, #7
	mov	S_BUFFER_WR, a
	call	!streamSetBufPtr

@skip:
@_03d5:	jmp	!commandDone

streamStop:
@_03d8:	mov	a, #0
@_03da:	mov	S_ENABLE, a
@_03dc:	mov	a, #DSP_KOF			; //stop channels 6 and 7
@_03de:	mov	ADDR, a
@_03e0:	mov	a, #$c0
@_03e2:	mov	DATA, a
@_03e4:	call	!updateAllChannelsVolume

@_03e7:	ret

; //clear BRR streamer buffers, fill them with c0 00..00 with stop bit in the last block

streamClearBuffers:
@_03e8:	mov	x, #0
@_03ea:	mov	a, #streamBufSize
@_03ec:	mov	D_TEMP, a

@clear0:
@_03ee:	mov	a, #$c0
@_03f0:	mov	!streamData1+x, a
@_03f3:	mov	!streamData2+x, a
@_03f6:	mov	!streamData3+x, a
@_03f9:	mov	!streamData4+x, a
@_03fc:	mov	!streamData5+x, a
@_03ff:	mov	!streamData6+x, a
@_0402:	mov	!streamData7+x, a
@_0405:	mov	!streamData8+x, a
@_0408:	mov	!streamSync+x, a
@_040b:	inc	x
@_040c:	mov	a, #$00
@_040e:	mov	y, #8

@clear1:
@_0410:	mov	!streamData1+x, a
@_0413:	mov	!streamData2+x, a
@_0416:	mov	!streamData3+x, a
@_0419:	mov	!streamData4+x, a
@_041c:	mov	!streamData5+x, a
@_041f:	mov	!streamData6+x, a
@_0422:	mov	!streamData7+x, a
@_0425:	mov	!streamData8+x, a
@_0428:	mov	!streamSync+x, a
@_042b:	inc	x
@_042c:	dec	y
@_042d:	bne	@clear1

@_042f:	dec	D_TEMP
@_0431:	bne	@clear0

@_0433:	mov	a, #$c3
@_0435:	mov	!streamData8+streamBufSize*9-9, a
@_0438:	mov	!streamSync+streamBufSize*9-9, a
@_043b:	ret

streamSetBufPtr:
@_043c:	asl	a
	mov	x, a
	mov	a, !streamBufferPtr+0+x
	mov	!S_BUFFER_PTR+0, a
	mov	a, !streamBufferPtr+1+x
	mov	!S_BUFFER_PTR+1, a
	mov	a, #0
	mov	S_BUFFER_OFF, a
	ret

; //start music, using the channels starting from the specified one
; //in: X=the starting channel, musicDataPtr=music data location

startMusic:
@_044f:	mov	a, !musicDataPtr+0 ;!$020c
@_0452:	mov	D_PTR_L, a
@_0454:	mov	a, !musicDataPtr+1 ;!$020d
@_0457:	mov	D_PTR_H, a
@_0459:	mov	y, #0				; //how many channels in the song
@_045b:	mov	a, [D_PTR_L]+y
@_045d:	mov	D_MUSIC_CHNS, a
@_045f:	bne	@start				; //just in case

	jmp	!commandDone

@start:
@_0464:	mov	D_TEMP, a
@_0466:	inc	y

@loop:
@_0467:	push	x
@_0468:	mov	a, x
@_0469:	call	!setChannel

@_046c:	push	y
@_046d:	call	!startChannel

@_0470:	mov	a, #128
@_0472:	mov	D_CHNPAN+x, a			; //reset pan for music channels
@_0474:	pop	y
@_0475:	pop	x
@_0476:	inc	x				; //the song requires too many channels, skip those that don't fit
@_0477:	cmp	x, #8
@_0479:	bcs	@done
@_047b:	inc	y
@_047c:	inc	y
@_047d:	dec	D_TEMP
@_047f:	bne	@loop

@done:
@_0481:	ret

; //start sound effects, almost the same as music
; //in: X=the starting channel, D_PTR=effect data location,D_VOL,D_PAN

startSoundEffect:
@_0482:	mov	y, #0
	mov	a, [D_PTR_L]+y			; //how many channels in the song
	mov	D_TEMP, a
	inc	y

@loop:
@_0489:	push	x
	mov	a, x
	call	!setChannel

	push	y
	call	!startChannel

	mov	a, D_VOL			; //apply effect volume
	cmp	a, #127
	bcc	@noClip				; FIXME, should branch in a meaningful way (sth not implemented?)

@noClip:
@_0498:	asl	a
	mov	D_CHNVOL+x, a
	mov	a, D_PAN			; //apply effect pan
	mov	D_CHNPAN+x, a
	pop	y
	pop	x
	inc	x
	cmp	x, #8
	bcs	@done
	inc	y
	inc	y
	dec	D_TEMP
	bne	@loop

@done:
@_04ac:	ret

; //initialize channel
; //in: {D_CH0x}=channel, {D_PTR_L},Y=offset to the channel data

startChannel:
@_04ad:	call	!bufKeyOff

@_04b0:	call	!bufKeyOffApply

@_04b3:	mov	x, D_CH0x
@_04b5:	mov	a, #0
@_04b7:	mov	M_PITCH_L+x, a			; //reset current pitch
@_04b9:	mov	M_PITCH_H+x, a 
@_04bb:	mov	M_PORTA_TO_L+x, a		; //reset portamento pitch
@_04bd:	mov	M_PORTA_TO_H+x, a 
@_04bf:	mov	M_DETUNE+x, a			; //reset all effects
@_04c1:	mov	M_SLIDE+x, a
@_04c3:	mov	M_PORTAMENTO+x, a
@_04c5:	mov	M_MODULATION+x, a
@_04c7:	mov	M_MOD_OFF+x, a
@_04c9:	mov	M_REF_LEN+x, a			; //reset reference
@_04cb:	mov	M_WAIT_H+x, a
@_04cd:	mov	a, #4				; //short delay between initial keyoff and starting a channel, to prevent clicks
@_04cf:	mov	M_WAIT_L+x, a
@_04d1:	mov	a, #127				; //set default channel volume
@_04d3:	mov	M_VOL+x, a
@_04d5:	mov	a, [D_PTR_L]+y
@_04d7:	mov	M_PTR_L+x, a
@_04d9:	inc	y
@_04da:	mov	a, [D_PTR_L]+y
@_04dc:	mov	M_PTR_H+x, a
@_04de:	ret

; //run one frame of music player

updateMusicPlayer:
@_04df:	call	!bufClear

@_04e2:	mov	a, #0

@loop:
@_04e4:	push	a
@_04e5:	mov	x, D_PAUSE
@_04e7:	beq	@noPause

	cmp	a, D_MUSIC_CHNS			; //the pause only skips channels with music
	bcc	@skipChannel

@noPause:
@_04ed:	call	!setChannel

@_04f0:	mov	a, #0				; //reset pitch update flag, set by any pitch change event in the updateChannel
@_04f2:	mov	D_PITCH_UPD, a
@_04f4:	call	!updateChannel			; //perform channel update

@_04f7:	call	!updatePitch			; //write pitch registers if the pitch was updated

@skipChannel:
@_04fa:	pop	a
@_04fb:	inc	a
@_04fc:	cmp	a, #8
@_04fe:	bne	@loop
@_0500:	call	!bufKeyOffApply

@_0503:	call	!bufApply

@_0506:	call	!bufKeyOnApply

@_0509:	ret

; //read one byte of a music channel data, and advance the read pointer in temp variable
; //readChannelByteZ sets Y offset to zero, readChannelByte skips it as Y often remains zero anyway
; //it also handles reference calls and returns

readChannelByteZ:
@_050a:	mov	y, #0

readChannelByte:
@_050c:	mov	a, [D_PTR_L]+y
@_050e:	incw	D_PTR_L
@_0510:	push	a
@_0511:	mov	x, D_CH0x
@_0513:	mov	a, M_REF_LEN+x			; //check reference length
@_0515:	beq	@done

@_0517:	dec	M_REF_LEN+x
@_0519:	bne	@done

@_051b:	mov	a, M_REF_RET_L+x		; //restore original pointer
@_051d:	mov	D_PTR_L, a
@_051f:	mov	a, M_REF_RET_H+x
@_0521:	mov	D_PTR_H, a

@done:
@_0523:	pop	a
@_0524:	ret

; //perform update of one music data channel, and parse channel data when needed

updateChannel:
@_0525:	mov	x, D_CH0x
@_0527:	mov	a, M_PTR_H+x			; //when the pointer MSB is zero, channel is inactive
@_0529:	bne	@processChannel
@_052b:	ret

@processChannel:
@_052c:	mov	D_PTR_H, a
@_052e:	mov	a, M_PTR_L+x
@_0530:	mov	D_PTR_L, a
@_0532:	mov	a, M_MODULATION+x		; //when modulation is active, pitch gets updated constantly
@_0534:	mov	D_PITCH_UPD, a
@_0536:	beq	@noModulation

	and	a, #$0f				; //advance the modulation pointer
	clrc
	adc	a, M_MOD_OFF+x
	cmp	a, #192
	bcc	@noWrap
	setc
	sbc	a, #192

@noWrap:
@_0544:	mov	M_MOD_OFF+x, a

@noModulation:
@_0546:	mov	a, M_PORTAMENTO+x
@_0548:	bne	@doPortamento			; //portamento has priority over slides
@_054a:	mov	a, M_SLIDE+x
@_054c:	bne	@doSlide
@_054e:	jmp	!@noSlide

@doSlide:
@_0551:	mov	D_PITCH_UPD, a
	bmi	@slideDown
	bra	@slideUp

@doPortamento:
@_0557:	mov	a, M_PITCH_H+x			; //compare current pitch and needed pitch
	cmp	a, M_PORTA_TO_H+x
;	bne	@portaCompareDone		; FIXME, jump to beq instruction makes no sense (should be _0563)
	bne	@portaCompareDone+2		; CUSTOM
	mov	a, M_PITCH_L+x
	cmp	a, M_PORTA_TO_L+x

@portaCompareDone:
@_0561:	beq	@noSlide			; //go noslide if no pitch change is needed
	bcs	@portaDown

@portaUp:
	inc	D_PITCH_UPD
	mov	a, M_PITCH_L+x
	clrc
	adc	a, M_PORTAMENTO+x
	mov	M_PITCH_L+x, a
	mov	a, M_PITCH_H+x
	adc	a, #0
	mov	M_PITCH_H+x, a
	cmp	a, M_PORTA_TO_H+x		; //check if the pitch goes higher than needed
	bne	@portaUpLimit
	mov	a, M_PITCH_L+x
	cmp	a, M_PORTA_TO_L+x

@portaUpLimit:
@_057c:	bcs	@portaPitchLimit
	bra	@noSlide

@portaDown:
@_0580:	inc	D_PITCH_UPD
	mov	a, M_PITCH_L+x
	setc
	sbc	a, M_PORTAMENTO+x
	mov	M_PITCH_L+x, a
	mov	a, M_PITCH_H+x
	sbc	a, #0
	mov	M_PITCH_H+x, a
	cmp	a, M_PORTA_TO_H+x		; //check if the pitch goes lower than needed
	bne	@portaDownLimit
	mov	a, M_PITCH_L+x
	cmp	a, M_PORTA_TO_L+x

@portaDownLimit:
@_0597:	bcc	@portaPitchLimit
	bra	@noSlide

@portaPitchLimit:
@_059b:	mov	a, M_PORTA_TO_L+x
	mov	M_PITCH_L+x, a
	mov	a, M_PORTA_TO_H+x
	mov	M_PITCH_H+x, a
	bra	@noSlide

@slideUp:
@_05a5:	mov	a, M_PITCH_L+x
	clrc
	adc	a, M_SLIDE+x
	mov	M_PITCH_L+x, a
	mov	a, M_PITCH_H+x
	adc	a, #0
	mov	M_PITCH_H+x, a
	cmp	a, #$40
	bcc	@noSlide
	mov	a, #$3f
	mov	M_PITCH_H+x, a
	mov	a, #$30
	mov	M_PITCH_L+x, a
	bra	@noSlide

@slideDown:
@_05c0:	mov	a, M_PITCH_L+x
	clrc
	adc	a, M_SLIDE+x
	mov	M_PITCH_L+x, a
	mov	a, M_PITCH_H+x
	adc	a, #255
	mov	M_PITCH_H+x, a
	bcs	@noSlide
	mov	a, #0
	mov	M_PITCH_H+x, a
	mov	M_PITCH_L+x, a

@noSlide:
@_05d5:	mov	a, M_WAIT_L+x
@_05d7:	bne	@wait1

@_05d9:	mov	a, M_WAIT_H+x
@_05db:	beq	@readLoopStart
@_05dd:	dec	M_WAIT_H+x

@wait1:
@_05df:	dec	M_WAIT_L+x
@_05e1:	mov	a, M_WAIT_L+x
@_05e3:	or	a, M_WAIT_H+x
@_05e5:	beq	@readLoopStart
@_05e7:	ret

@readLoopStart:
@_05e8:	call	!updateChannelVolume

@readLoop:
@_05eb:	call	!readChannelByteZ		; //read a new byte, set Y to zero, X to D_CH0x

@_05ee:	cmp	a, #149
@_05f0:	bcc	@setShortDelay
@_05f2:	cmp	a, #245
@_05f4:	beq	@keyOff
@_05f6:	bcc	@newNote
@_05f8:	cmp	a, #246
@_05fa:	beq	@setLongDelay
@_05fc:	cmp	a, #247
@_05fe:	beq	@setEffectVolume
@_0600:	cmp	a, #248
@_0602:	beq	@setEffectPan
@_0604:	cmp	a, #249
@_0606:	beq	@setEffectDetune
@_0608:	cmp	a, #250
@_060a:	beq	@setEffectSlide
@_060c:	cmp	a, #251
@_060e:	beq	@setEffectPortamento
@_0610:	cmp	a, #252
@_0612:	beq	@setEffectModulation
@_0614:	cmp	a, #253
@_0616:	beq	@setReference
@_0618:	cmp	a, #254
@_061a:	bne	@jumpLoop
@_061c:	jmp	!@setInstrument

@jumpLoop:					; //255
@_061f:	call	!readChannelByte

	push	a
	call	!readChannelByte

	mov	D_PTR_H, a
	pop	a
	mov	D_PTR_L, a
	bra	@readLoop

@keyOff:
@_062d:	call	!bufKeyOff

@_0630:	bra	@readLoop

@setShortDelay:
@_0632:	mov	M_WAIT_L+x, a
@_0634:	bra	@storePtr

@newNote:
@_0636:	setc
@_0637:	sbc	a, #150
@_0639:	call	!setPitch

@_063c:	mov	a, M_PORTAMENTO+x		; //only set key on when portamento is not active
@_063e:	bne	@readLoop
@_0640:	call	!bufKeyOn

@_0643:	bra	@readLoop

@setLongDelay:
@_0645:	call	!readChannelByte

@_0648:	mov	M_WAIT_L+x, a
@_064a:	call	!readChannelByte

@_064d:	mov	M_WAIT_H+x, a
@_064f:	bra	@storePtr

@setEffectVolume:
@_0651:	call	!readChannelByte		; //read volume value

	mov	M_VOL+x, a
	call	!updateChannelVolume		; //apply volume and pan

	bra	@readLoop

@setEffectPan:
@_065b:	call	!readChannelByte		; //read pan value

@_065e:	mov	D_CHNPAN+x, a 
@_0660:	call	!updateChannelVolume		; //apply volume and pan

@_0663:	bra	@readLoop

@setEffectDetune:
@_0665:	call	!readChannelByte		; //read detune value

	mov	M_DETUNE+x, a
	inc	D_PITCH_UPD			; //set pitch update flag
	jmp	!@readLoop

@setEffectSlide:
@_066f:	call	!readChannelByte		; //read slide value (8-bit signed, -99..99)

	mov	M_SLIDE+x, a
	jmp	!@readLoop

@setEffectPortamento:
@_0677:	call	!readChannelByte

	mov	M_PORTAMENTO+x, a
	jmp	!@readLoop

@setEffectModulation:
@_067f:	call	!readChannelByte		; //read modulation value

	mov	M_MODULATION+x, a
	jmp	!@readLoop

@setReference:
@_0687:	call	!readChannelByte		; //read reference LSB

@_068a:	push	a
@_068b:	call	!readChannelByte		; //read reference MSB

@_068e:	push	a
@_068f:	call	!readChannelByte		; //read reference length in bytes

@_0692:	mov	M_REF_LEN+x, a
@_0694:	mov	a, D_PTR_L			; //remember previous pointer as the return address
@_0696:	mov	M_REF_RET_L+x, a
@_0698:	mov	a, D_PTR_H
@_069a:	mov	M_REF_RET_H+x, a
@_069c:	pop	a				; //set reference pointer
@_069d:	mov	D_PTR_H, a
@_069f:	pop	a
@_06a0:	mov	D_PTR_L, a
@_06a2:	jmp	!@readLoop

@setInstrument:
@_06a5:	call	!readChannelByte

@_06a8:	call	!setInstrument

@_06ab:	jmp	!@readLoop

@storePtr:
@_06ae:	mov	x, D_CH0x
@_06b0:	mov	a, D_PTR_L			; //store changed pointer
@_06b2:	mov	M_PTR_L+x, a
@_06b4:	mov	a, D_PTR_H
@_06b6:	mov	M_PTR_H+x, a
@_06b8:	ret

; //initialize DSP registers and driver variables

initDSPAndVars:
@_06b9:	mov	x, #0
@_06bb:	mov	D_KON, x			; //no keys pressed
@_06bd:	mov	D_KOF, x			; //no keys released
	inc	x				; CUSTOM
@_06bf:	mov	D_STEREO, x			; stereo by default (yay)
	dec	x				; CUSTOM
@_06c1:	mov	D_MUSIC_CHNS, x			; //how many channels current music uses
@_06c3:	mov	D_PAUSE, x			; //pause mode is inactive
@_06c5:	mov	S_ENABLE, x			; //disable streaming
@_06c7:	mov	D_GLOBAL_DIV, x			; //reset global volume change speed divider
@_06c9:	mov	D_GLOBAL_OUT, x			; //current global volume
@_06cb:	mov	x, #255
@_06cd:	mov	D_GLOBAL_TGT, x			; //target global volume
@_06cf:	mov	D_GLOBAL_STEP, x		; //global volume change speed
@_06d1:	mov	x, #DSPInitData&255
@_06d3:	mov	y, #DSPInitData/256
@_06d5:	call	!sendDSPSequence

@_06d8:	mov	a, !sampleADSRPtr+0		; //set DP pointer to the ADSR list
@_06db:	mov	D_ADSR_L, a
@_06dd:	mov	a, !sampleADSRPtr+1
@_06e0:	mov	D_ADSR_H, a
@_06e2:	mov	a, !soundEffectsDataPtr+0	; //set DP pointer to sound effects data
@_06e5:	mov	D_EFFECTS_L, a
@_06e7:	mov	a, !soundEffectsDataPtr+1
@_06ea:	mov	D_EFFECTS_H, a
@_06ec:	mov	x, #0

@initChannels:
@_06ee:	mov	a, #0
@_06f0:	mov	M_PTR_H+x, a 
@_06f2:	mov	a, #128
@_06f4:	mov	D_CHNPAN+x, a 
@_06f6:	mov	a, #255
@_06f8:	mov	D_CHNVOL+x, a 
@_06fa:	mov	M_INSTRUMENT+x, a 
@_06fc:	inc	x
@_06fd:	cmp	x, #8
@_06ff:	bne	@initChannels
@_0701:	call	!streamClearBuffers

@_0704:	ret

; //updates play position for the BRR streamer

updateBRRStreamerPos:
@_0705:	mov	a, #DSP_ENDX			; //check if channel 6 stopped playing
@_0707:	mov	ADDR, a
@_0709:	mov	a, DATA
@_070b:	and	a, #$40
@_070d:	beq	@skip
@_070f:	mov	DATA, a
@_0711:	mov	a, S_BUFFER_RD
@_0713:	inc	a
@_0714:	and	a, #7
@_0716:	mov	S_BUFFER_RD, a

@skip:
@_0718:	ret

; //set the ready flag for the 65816 side, so it can send a new command

setReady:
@_0719:	push	a
@_071a:	mov	a, #%10010001			; //reset communication I/O, enable timer 0 and IPL
@_071c:	mov	CTRL, a
@_071e:	mov	a, #0
@_0720:	mov	CPU0, a
@_0722:	mov	CPU1, a
@_0724:	pop	a
@_0725:	ret

; //set current channel for all other setNNN routines
; //in: A=channel 0..7

setChannel:
@_0726:	mov	D_CH0x, a
@_0728:	asl	a
@_0729:	asl	a
@_072a:	asl	a
@_072b:	asl	a
@_072c:	mov	D_CHx0, a
@_072e:	ret

; //set instrument (sample and ADSR) for specified channel
; //in: {D_CHx0}=channel, A=instrument number 0..255

setInstrument:
@_072f:	mov	y, a
@_0730:	mov	x, D_CH0x
@_0732:	cmp	a, M_INSTRUMENT+x
@_0734:	beq	@skip
@_0736:	mov	M_INSTRUMENT+x, a 
@_0738:	mov	a, D_CHx0
@_073a:	or	a, #DSP_SRCN
@_073c:	mov	x, a
@_073d:	mov	a, y
@_073e:	call	!bufRegWrite			; //write instrument number, remains in A after jsr

@_0741:	asl	a				; //get offset for parameter tables
@_0742:	mov	y, a
@_0743:	mov	a, D_CHx0			; //write adsr parameters
@_0745:	or	a, #DSP_ADSR1
@_0747:	mov	x, a
@_0748:	mov	a, [D_ADSR_L]+y			; //first adsr byte
@_074a:	call	!bufRegWrite

@_074d:	mov	a, D_CHx0
@_074f:	or	a, #DSP_ADSR2
@_0751:	mov	x, a
@_0752:	inc	y
@_0753:	mov	a, [D_ADSR_L]+y			; //second adsr byte
@_0755:	call	!bufRegWrite

@skip:
@_0758:	ret

; //set pitch variables accoding to note
; //in: {D_CH0x}=channel, A=note

setPitch:
@_0759:	asl	a
@_075a:	mov	y, a
@_075b:	mov	x, D_CH0x
@_075d:	mov	a, !notePeriodTable+0+y
@_0760:	mov	M_PORTA_TO_L+x, a
@_0762:	mov	a, !notePeriodTable+1+y
@_0765:	mov	M_PORTA_TO_H+x, a
@_0767:	mov	a, M_PORTAMENTO+x
@_0769:	beq	@portaOff

	cmp	a, #99				; //P99 gets legato effect, changes pitch right away without sending keyon
	beq	@portaOff
	ret

@portaOff:
@_0770:	mov	a, M_PORTA_TO_L+x		; //when portamento is inactive, copy the target pitch into current pitch immideately
@_0772:	mov	M_PITCH_L+x, a
@_0774:	mov	a, M_PORTA_TO_H+x
@_0776:	mov	M_PITCH_H+x, a
@_0778:	inc	D_PITCH_UPD
@_077a:	ret

; //apply current pitch of the channel, also applies the detune value
; //in: {D_CHx0}=channel if the pitch change flag is set

updatePitch:
@_077b:	mov	a, D_PITCH_UPD
@_077d:	bne	@update
@_077f:	ret

@update:
@_0780:	mov	x, D_CH0x
@_0782:	mov	a, M_PITCH_L+x
@_0784:	clrc
@_0785:	adc	a, M_DETUNE+x
@_0787:	mov	D_PITCH_L, a
@_0789:	mov	a, M_PITCH_H+x
@_078b:	adc	a, #0
@_078d:	mov	D_PITCH_H, a
@_078f:	mov	a, M_MODULATION+x
@_0791:	beq	@noModulation

	and	a, #$f0
	mov	y, a
	mov	a, M_MOD_OFF+x
	mov	x, a
	mov	a, !vibratoTable+x
	bmi	@modSubtract

@modAdd:
	mul	ya
	mov	a, y
	clrc
	adc	a, D_PITCH_L
	mov	D_PITCH_L, a
	mov	a, D_PITCH_H
	adc	a, #0
	mov	D_PITCH_H, a
	bra	@noModulation

@modSubtract:
@_07ad:	eor	a, #255
	inc	a
	mul	ya
	mov	a, y
	mov	D_TEMP, a
	mov	a, D_PITCH_L
	setc
	sbc	a, D_TEMP
	mov	D_PITCH_L, a
	mov	a, D_PITCH_H
	sbc	a, #0
	mov	D_PITCH_H, a

@noModulation:
@_07c1:	mov	a, D_CHx0
@_07c3:	or	a, #DSP_PH
@_07c5:	mov	x, a
@_07c6:	mov	a, D_PITCH_H
@_07c8:	call	!bufRegWrite

@_07cb:	mov	a, D_CHx0
@_07cd:	or	a, #DSP_PL
@_07cf:	mov	x, a
@_07d0:	mov	a, D_PITCH_L
@_07d2:	call	!bufRegWrite

@_07d5:	ret

; //set volume and pan for current channel, according to M_VOL,D_CHNVOL,D_CHNPAN, and music pause state
; //in: {D_CHx0}=channel

updateChannelVolume:
@_07d6:	mov	x, D_CH0x
@_07d8:	cmp	x, D_MUSIC_CHNS
@_07da:	bcs	@noMute

@_07dc:	mov	a, D_PAUSE
@_07de:	beq	@noMute

	mov	a, #0
	bra	@calcVol

@noMute:
@_07e4:	mov	a, D_CHNVOL+x			; //get virtual channel volume

@calcVol:
@_07e6:	mov	y, M_VOL+x			; //get music channel volume
@_07e8:	mul	ya
@_07e9:	mov	D_VOL, y			; //resulting volume
@_07eb:	mov	a, D_STEREO
@_07ed:	bne	@stereo

@mono:
@_07ef:	mov	a, D_VOL
@_07f1:	push	a
@_07f2:	push	a
@_07f3:	bra	@setVol

@stereo:
@_07f5:	mov	a, D_CHNPAN+x			; //calculate left volume
@_07f7:	eor	a, #$ff
@_07f9:	mov	y, a
@_07fa:	mov	a, D_VOL
@_07fc:	mul	ya
@_07fd:	push	y
@_07fe:	mov	y, D_CHNPAN+x			; //calculate right volume
@_0800:	mov	a, D_VOL
@_0802:	mul	ya
@_0803:	push	y

@setVol:
@_0804:	mov	a, D_CHx0			; //write volume registers
@_0806:	or	a, #DSP_VOLR
@_0808:	mov	x, a
@_0809:	pop	a
@_080a:	call	!bufRegWrite

@_080d:	mov	a, D_CHx0
@_080f:	or	a, #DSP_VOLL
@_0811:	mov	x, a
@_0812:	pop	a
@_0813:	call	!bufRegWrite

@_0816:	ret

; //set volume and pan for all channels

updateAllChannelsVolume:
@_0817:	mov	a, #0

@updVol:
@_0819:	push	a
@_081a:	call	!setChannel

@_081d:	call	!updateChannelVolume

@_0820:	pop	a
@_0821:	inc	a
@_0822:	cmp	a, #8
@_0824:	bne	@updVol
@_0826:	call	!bufApply

@_0829:	ret

; //update global volume, considering current fade speed

updateGlobalVolume:
@_082a:	inc	D_GLOBAL_DIV
@_082c:	mov	a, D_GLOBAL_DIV
@_082e:	and	a, #7
@_0830:	beq	@update
@_0832:	mov	a, D_GLOBAL_STEP
@_0834:	cmp	a, #255
@_0836:	beq	@update
@_0838:	ret

@update:
@_0839:	mov	a, D_GLOBAL_OUT
@_083b:	cmp	a, D_GLOBAL_TGT
@_083d:	beq	@setVolume
@_083f:	bcs	@fadeOut

@fadeIn:
@_0841:	adc	a, D_GLOBAL_STEP
@_0843:	bcc	@fadeInLimit

	mov	a, D_GLOBAL_TGT
	bra	@setVolume

@fadeInLimit:
@_0849:	cmp	a, D_GLOBAL_TGT
@_084b:	bcc	@setVolume
@_084d:	mov	a, D_GLOBAL_TGT
@_084f:	bra	@setVolume

@fadeOut:
@_0851:	sbc	a, D_GLOBAL_STEP
@_0853:	bcs	@fadeOutLimit

@_0855:	mov	a, D_GLOBAL_TGT
@_0857:	bra	@setVolume

@fadeOutLimit:
@_0859:	cmp	a, D_GLOBAL_TGT
@_085b:	bcs	@setVolume
@_085d:	mov	a, D_GLOBAL_TGT

@setVolume:
@_085f:	mov	D_GLOBAL_OUT, a
@_0861:	lsr	a
@_0862:	mov	x, #DSP_MVOLL
@_0864:	mov	ADDR, x
@_0866:	mov	DATA, a
@_0868:	mov	x, #DSP_MVOLR
@_086a:	mov	ADDR, x
@_086c:	mov	DATA, a
@_086e:	ret

; //clear register writes buffer, just set ptr to 0

bufClear:
@_086f:	mov	D_BUFPTR, #0
@_0872:	ret

; //add register write in buffer
; //in X=reg, A=value

bufRegWrite:
@_0873:	push	a
@_0874:	mov	a, x
@_0875:	mov	x, D_BUFPTR
@_0877:	mov	!D_BUFFER+x, a
@_087a:	inc	x
@_087b:	pop	a
@_087c:	mov	!D_BUFFER+x, a
@_087f:	inc	x
@_0880:	mov	D_BUFPTR, x
@_0882:	ret

; //set keyon for specified channel in the temp variable
; //in: {D_CH0x}=channel

bufKeyOn:
@_0883:	mov	x, D_CH0x
@_0885:	mov	a, !channelMask+x
@_0888:	or	a, D_KON
@_088a:	mov	D_KON, a
@_088c:	ret

; //set keyoff for specified channel in the temp variable
; //in: {D_CH0x}=channel

bufKeyOff:
@_088d:	mov	x, D_CH0x
@_088f:	mov	a, !channelMask+x
@_0892:	or	a, D_KOF
@_0894:	mov	D_KOF, a
@_0896:	ret

; //send writes from buffer and clear it

bufApply:
@_0897:	mov	a, D_BUFPTR
@_0899:	beq	@done
@_089b:	mov	x, #0

@loop:
@_089d:	mov	a, !D_BUFFER+x
@_08a0:	mov	ADDR, a
@_08a2:	inc	x
@_08a3:	mov	a, !D_BUFFER+x
@_08a6:	mov	DATA, a
@_08a8:	inc	x
@_08a9:	cmp	x, D_BUFPTR
@_08ab:	bne	@loop
@_08ad:	mov	D_BUFPTR, #0

@done:
@_08b0:	ret

; //send keyon from the temp variable

bufKeyOnApply:
@_08b1:	mov	a, D_KON
@_08b3:	eor	a, #$ff
@_08b5:	and	a, D_KOF
@_08b7:	mov	x, #DSP_KOF
@_08b9:	mov	ADDR, x
@_08bb:	mov	D_KOF, a
@_08bd:	mov	DATA, a
@_08bf:	mov	a, #DSP_KON
@_08c1:	mov	ADDR, a
@_08c3:	mov	a, D_KON
@_08c5:	mov	D_KON, #0
@_08c8:	mov	DATA, a
@_08ca:	ret

; //send keyoff from the temp variable

bufKeyOffApply:
@_08cb:	mov	a, #DSP_KOF
@_08cd:	mov	ADDR, a
@_08cf:	mov	a, D_KOF
@_08d1:	mov	DATA, a
@_08d3:	ret

; //send sequence of DSP register writes, used for init

sendDSPSequence:
@_08d4:	mov	D_PTR_L, x
@_08d6:	mov	D_PTR_H, y
@_08d8:	mov	y, #0

@loop:
@_08da:	mov	a, [D_PTR_L]+y
@_08dc:	beq	@done
@_08de:	mov	ADDR, a
@_08e0:	inc	y
@_08e1:	mov	a, [D_PTR_L]+y
@_08e3:	mov	DATA, a
@_08e5:	inc	y
@_08e6:	bra	@loop

@done:
@_08e8:	ret



cmdList:

; 00 00 46 02 0A 03 4E 02 57 02 6B 02 8C 02 A2 02 CA 02 D7 02 99 02 20 03 4A 03 53 03 

;.DW $0000
;.DW _0246
;.DW _030a
;.DW _024e
;.DW _0257
;.DW _026b
;.DW _028c
;.DW _02a2
;.DW _02ca
;.DW _02d7
;.DW _0299
;.DW _0320
;.DW _034a
;.DW _0353

	.DW 0					; //0 no command, means the APU is ready for a new command
	.DW cmdInitialize			; //1 initialize DSP
	.DW cmdLoad				; //2 load new music data
	.DW cmdStereo				; //3 change stereo sound mode, mono by default
	.DW cmdGlobalVolume			; //4 set global volume
	.DW cmdChannelVolume			; //5 set channel volume
	.DW cmdMusicPlay			; //6 start music
	.DW cmdMusicStop			; //7 stop music
	.DW cmdMusicPause			; //8 pause music
	.DW cmdSfxPlay				; //9 play sound effect
	.DW cmdStopAllSounds			; //10 stop all sounds
	.DW cmdStreamStart			; //11 start sound streaming
	.DW cmdStreamStop			; //12 stop sound streaming
	.DW cmdStreamSend			; //13 send a block of data if needed
	.DW cmdFastLoad



notePeriodTable:

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($905-$200+2) READ 192

;.HEX BLOCK
;	                                    42 00 46 00
;	4A 00 4F 00 54 00 59 00 5E 00 64 00 6A 00 70 00
;	77 00 7E 00 85 00 8D 00 95 00 9E 00 A8 00 B2 00
;	BC 00 C8 00 D4 00 E0 00 EE 00 FC 00 0B 01 1B 01
;	2B 01 3D 01 50 01 64 01 79 01 90 01 A8 01 C1 01
;	DC 01 F8 01 16 02 36 02 57 02 7B 02 A1 02 C9 02
;	F3 02 20 03 50 03 82 03 B8 03 F0 03 2C 04 6C 04
;	AF 04 F6 04 42 05 92 05 E7 05 41 06 A0 06 05 07
;	70 07 E1 07 59 08 D8 08 5F 09 ED 09 85 0A 25 0B
;	CE 0B 82 0C 41 0D 0A 0E E0 0E C3 0F B3 10 B1 11
;	BE 12 DB 13 0A 15 4A 16 9D 17 05 19 82 1A 15 1C
;	C1 1D 86 1F 66 21 62 23 7D 25 B7 27 14 2A 95 2C
;	3B 2F 0A 32 04 35 2B 38 82 3B 0C 3F
;.ENDHEX

	.DW $0042,$0046,$004a,$004f,$0054,$0059,$005e,$0064,$006a,$0070,$0077,$007e
	.DW $0085,$008d,$0095,$009e,$00a8,$00b2,$00bc,$00c8,$00d4,$00e0,$00ee,$00fc
	.DW $010b,$011b,$012b,$013d,$0150,$0164,$0179,$0190,$01a8,$01c1,$01dc,$01f8
	.DW $0216,$0236,$0257,$027b,$02a1,$02c9,$02f3,$0320,$0350,$0382,$03b8,$03f0
	.DW $042c,$046c,$04af,$04f6,$0542,$0592,$05e7,$0641,$06a0,$0705,$0770,$07e1
	.DW $0859,$08d8,$095f,$09ed,$0a85,$0b25,$0bce,$0c82,$0d41,$0e0a,$0ee0,$0fc3
	.DW $10b3,$11b1,$12be,$13db,$150a,$164a,$179d,$1905,$1a82,$1c15,$1dc1,$1f86
	.DW $2166,$2362,$257d,$27b7,$2a14,$2c95,$2f3b,$320a,$3504,$382b,$3b82,$3f0c



vibratoTable:

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($9c5-$200+2) READ 192

;.HEX BLOCK
;	                                    00 04 08 0C
;	10 14 18 1C 20 24 28 2C 30 34 38 3B 3F 43 46 49
;	4D 50 53 56 59 5C 5F 62 64 67 69 6B 6D 70 71 73
;	75 76 78 79 7A 7B 7C 7D 7D 7E 7E 7E 7F 7E 7E 7E
;	7D 7D 7C 7B 7A 79 78 76 75 73 71 70 6D 6B 69 67
;	64 62 5F 5C 59 56 53 50 4D 49 46 43 3F 3B 38 34
;	30 2C 28 24 20 1C 18 14 10 0C 08 04 00 FC F8 F4
;	F0 EC E8 E4 E0 DC D8 D4 D0 CC C8 C5 C1 BD BA B7
;	B3 B0 AD AA A7 A4 A1 9E 9C 99 97 95 93 90 8F 8D
;	8B 8A 88 87 86 85 84 83 83 82 82 82 81 82 82 82
;	83 83 84 85 86 87 88 8A 8B 8D 8F 90 93 95 97 99
;	9C 9E A1 A4 A7 AA AD B0 B3 B7 BA BD C1 C5 C8 CC
;	D0 D4 D8 DC E0 E4 E8 EC F0 F4 F8 FC
;.ENDHEX

	.DB $00,$04,$08,$0c,$10,$14,$18,$1c,$20,$24,$28,$2c,$30,$34,$38,$3b
	.DB $3f,$43,$46,$49,$4d,$50,$53,$56,$59,$5c,$5f,$62,$64,$67,$69,$6b
	.DB $6d,$70,$71,$73,$75,$76,$78,$79,$7a,$7b,$7c,$7d,$7d,$7e,$7e,$7e
	.DB $7f,$7e,$7e,$7e,$7d,$7d,$7c,$7b,$7a,$79,$78,$76,$75,$73,$71,$70
	.DB $6d,$6b,$69,$67,$64,$62,$5f,$5c,$59,$56,$53,$50,$4d,$49,$46,$43
	.DB $3f,$3b,$38,$34,$30,$2c,$28,$24,$20,$1c,$18,$14,$10,$0c,$08,$04
	.DB $00,$fc,$f8,$f4,$f0,$ec,$e8,$e4,$e0,$dc,$d8,$d4,$d0,$cc,$c8,$c5
	.DB $c1,$bd,$ba,$b7,$b3,$b0,$ad,$aa,$a7,$a4,$a1,$9e,$9c,$99,$97,$95
	.DB $93,$90,$8f,$8d,$8b,$8a,$88,$87,$86,$85,$84,$83,$83,$82,$82,$82
	.DB $81,$82,$82,$82,$83,$83,$84,$85,$86,$87,$88,$8a,$8b,$8d,$8f,$90
	.DB $93,$95,$97,$99,$9c,$9e,$a1,$a4,$a7,$aa,$ad,$b0,$b3,$b7,$ba,$bd
	.DB $c1,$c5,$c8,$cc,$d0,$d4,$d8,$dc,$e0,$e4,$e8,$ec,$f0,$f4,$f8,$fc


channelMask:

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($a85-$200+2) READ 8

;.HEX 01 02 04 08 10 20 40 80

	.DB $01,$02,$04,$08,$10,$20,$40,$80



streamBufferPtr:

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($a8d-$200+2) READ 16

;.HEX BLOCK
;	            E4 F6 E0 F7 DC F8 D8 F9 D4 FA D0 FB
;	CC FC C8 FD
;.ENDHEX

	.DW streamData1
	.DW streamData2
	.DW streamData3
	.DW streamData4
	.DW streamData5
	.DW streamData6
	.DW streamData7
	.DW streamData8



DSPInitData:

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($a9d-$200+2) READ 45

;.HEX BLOCK
;	            6C 60 0C 00 1C 00 2D 00 3D 00 6D 01
;	7D 00 0D 00 0F 7F 1F 00 2F 00 3F 00 4F 00 5F 00
;	6F 00 7F 00 4D 00 2C 00 3C 00 5C FF 5D 0B 6C 20
;	00 
;.ENDHEX

	.DB DSP_FLG	,%01100000		; //mute, disable echo
	.DB DSP_MVOLL	,0			; //global volume to zero
	.DB DSP_MVOLR	,0
	.DB DSP_PMON	,0			; //no pitch modulation
	.DB DSP_NON	,0			; //no noise
	.DB DSP_ESA	,1			; //echo buffer in the stack page
	.DB DSP_EDL	,0			; //minimal echo buffer length
	.DB DSP_EFB	,0			; //no echo feedback
	.DB DSP_C0	,127			; //zero echo filter
	.DB DSP_C1	,0
	.DB DSP_C2	,0
	.DB DSP_C3	,0
	.DB DSP_C4	,0
	.DB DSP_C5	,0
	.DB DSP_C6	,0
	.DB DSP_C7	,0
	.DB DSP_EON	,0			; //echo disabled
	.DB DSP_EVOLL	,0			; //echo volume to zero
	.DB DSP_EVOLR	,0
	.DB DSP_KOF	,255			; //all keys off
	.DB DSP_DIR	,sampleDirAddr/256	; //sample dir location
	.DB DSP_FLG	,%00100000		; //no mute, disable echo
	.DB 0



BRRStreamInitData:

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($aca-$200+2) READ 19

;.HEX BLOCK
;	   75 00 77 1F 72 00 73 08 62 00 63 08 74 00 64
;	08 4C C0 00
;.ENDHEX

	.DB DSP_ADSR1	+$70,	$00		; //disable ADSR on channel 7
	.DB DSP_GAIN	+$70,	$1f
	.DB DSP_PL	+$70,	streamPitch&255	; //set pitch on channels 6 and 7
	.DB DSP_PH	+$70,	streamPitch/256
	.DB DSP_PL	+$60,	streamPitch&255
	.DB DSP_PH	+$60,	streamPitch/256
	.DB DSP_SRCN	+$70,	0		; //stream always playing on channel 7
	.DB DSP_SRCN	+$60,	8		; //sync stream always playing on channel 6
	.DB DSP_KON	,	$c0		; //start channels 6 and 7
	.DB 0



;	align 256				; //sample dir list should be aligned to 256 bytes

.REPEAT $D1					; no. of zeroes required after CUSTOMizations to align the start of the following table to address $0B00 (in sound RAM) = $0902 (in driver .BIN file)
	.DB 0
.ENDR

sampleDirAddr:					; //four bytes per sample, first 9 entries reserved for the BRR streamer

;.INCBIN "spc700-driver-v1.4.bin" SKIP ($b00-$200+2)

;.HEX BLOCK
;	                     E4 F6 E4 F6 E0 F7 E0 F7 DC
;	F8 DC F8 D8 F9 D8 F9 D4 FA D4 FA D0 FB D0 FB CC
;	FC CC FC C8 FD C8 FD C4 FE C4 FE
;.ENDHEX

	.DW streamData1,streamData1
	.DW streamData2,streamData2
	.DW streamData3,streamData3
	.DW streamData4,streamData4
	.DW streamData5,streamData5
	.DW streamData6,streamData6
	.DW streamData7,streamData7
	.DW streamData8,streamData8
	.DW streamSync,streamSync



EOF:
