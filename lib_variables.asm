;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** VARIABLE DEFINITIONS ***
;
;==========================================================================================



; ****************************** Notation ******************************

; Labels without prefixes generally reference easily identifiable stuff
; (e.g. SNES registers).

; Alias label prefixes:
; dstr_		= .DSTRUCT
; evc_		= event control code byte
; k		= parameter (constant/macro argument/etc.)
; struct_	= .STRUCT

; RAM address label prefixes (prefixes with a dot are INSTANCEOFs):
; CGRAM_	= CGRAM address
; DPx.		= Direct Page variable/array (x=2-9)
; LO8.		= non-Direct Page variable/array in the lowest 8K of WRAM (more specifically, within $0A00-$1FFF)
; RAM.		= variable/array within $7E2000-$7FFFFF
; RAM_		= variable within $7E2000-$7FFFFF
; SRAM_		= SRAM variable/array
; VRAM_		= VRAM address

; ROM address label prefixes:
; PTR_		= 16-bit pointer(s)
; SRC_		= binary data (code, data table, GFX ...)
; STR_		= ASCII/dialogue string

; misc label prefixes:
; MSU_		= MSU1 hardware register
; SRTC_		= real-time clock hardware register



; ********************** Hardware registers etc. ***********************

; SNES CPU status bits
	.DEFINE kDecimal	$08
	.DEFINE kX8		$10
	.DEFINE kA8		$20
	.DEFINE kAX8		kA8|kX8

; SNES PPU registers
	.DEFINE INIDISP		$2100
	.DEFINE OBSEL		$2101
	.DEFINE OAMADDL		$2102
	.DEFINE OAMADDH		$2103
	.DEFINE OAMDATA		$2104
	.DEFINE BGMODE		$2105
	.DEFINE MOSAIC		$2106
	.DEFINE BG1SC		$2107
	.DEFINE BG2SC		$2108
	.DEFINE BG3SC		$2109
	.DEFINE BG4SC		$210A
	.DEFINE BG12NBA		$210B
	.DEFINE BG34NBA		$210C
	.DEFINE BG1HOFS		$210D
	.DEFINE BG1VOFS		$210E
	.DEFINE BG2HOFS		$210F
	.DEFINE BG2VOFS		$2110
	.DEFINE BG3HOFS		$2111
	.DEFINE BG3VOFS		$2112
	.DEFINE BG4HOFS		$2113
	.DEFINE BG4VOFS		$2114
	.DEFINE VMAIN		$2115
	.DEFINE VMADDL		$2116
	.DEFINE VMADDH		$2117
	.DEFINE VMDATAL		$2118
	.DEFINE VMDATAH		$2119
	.DEFINE M7SEL		$211A
	.DEFINE M7A		$211B
	.DEFINE M7B		$211C
	.DEFINE M7C		$211D
	.DEFINE M7D		$211E
	.DEFINE M7X		$211F
	.DEFINE M7Y		$2120
	.DEFINE CGADD		$2121
	.DEFINE CGDATA		$2122
	.DEFINE W12SEL		$2123
	.DEFINE W34SEL		$2124
	.DEFINE WOBJSEL		$2125
	.DEFINE WH0		$2126
	.DEFINE WH1		$2127
	.DEFINE WH2		$2128
	.DEFINE WH3		$2129
	.DEFINE WBGLOG		$212A
	.DEFINE WOBJLOG		$212B
	.DEFINE TM		$212C
	.DEFINE TS		$212D
	.DEFINE TMW		$212E
	.DEFINE TSW		$212F
	.DEFINE CGWSEL		$2130
	.DEFINE CGADSUB		$2131
	.DEFINE COLDATA		$2132
	.DEFINE SETINI		$2133
	.DEFINE MPYL		$2134
	.DEFINE MPYM		$2135
	.DEFINE MPYH		$2136
	.DEFINE SLHV		$2137
	.DEFINE RDOAM		$2138
	.DEFINE RDVRAML		$2139
	.DEFINE RDVRAMH		$213A
	.DEFINE RDCGRAM		$213B
	.DEFINE OPHCT		$213C
	.DEFINE OPVCT		$213D
	.DEFINE STAT77		$213E
	.DEFINE STAT78		$213F

; SNES SPC700 communication ports
	.DEFINE APUIO0		$2140
	.DEFINE APUIO1		$2141
	.DEFINE APUIO2		$2142
	.DEFINE APUIO3		$2143

; SNES WRAM communication ports
	.DEFINE WMDATA		$2180
	.DEFINE WMADDL		$2181
	.DEFINE WMADDM		$2182
	.DEFINE WMADDH		$2183

; SNES CPU registers
	.DEFINE JOYWR		$4016
	.DEFINE JOYA		$4016
	.DEFINE JOYB		$4017
	.DEFINE NMITIMEN	$4200
	.DEFINE WRIO		$4201
	.DEFINE WRMPYA		$4202
	.DEFINE WRMPYB		$4203
	.DEFINE WRDIVL		$4204
	.DEFINE WRDIVH		$4205
	.DEFINE WRDIVB		$4206
	.DEFINE HTIMEL		$4207
	.DEFINE HTIMEH		$4208
	.DEFINE VTIMEL		$4209
	.DEFINE VTIMEH		$420A
	.DEFINE MDMAEN		$420B
	.DEFINE HDMAEN		$420C
	.DEFINE MEMSEL		$420D
	.DEFINE RDNMI		$4210
	.DEFINE TIMEUP		$4211
	.DEFINE HVBJOY		$4212
	.DEFINE RDIO		$4213
	.DEFINE RDDIVL		$4214
	.DEFINE RDDIVH		$4215
	.DEFINE RDMPYL		$4216
	.DEFINE RDMPYH		$4217
	.DEFINE JOY1L		$4218
	.DEFINE JOY1H		$4219
	.DEFINE JOY2L		$421A
	.DEFINE JOY2H		$421B
	.DEFINE JOY3L		$421C
	.DEFINE JOY3H		$421D
	.DEFINE JOY4L		$421E
	.DEFINE JOY4H		$421F

; SNES DMA registers
	.DEFINE DMAP0		$4300
	.DEFINE BBAD0		$4301
	.DEFINE A1T0L		$4302
	.DEFINE A1T0H		$4303
	.DEFINE A1B0		$4304
	.DEFINE DAS0L		$4305
	.DEFINE DAS0H		$4306
	.DEFINE DASB0		$4307
	.DEFINE A2A0L		$4308
	.DEFINE A2A0H		$4309
	.DEFINE NTRL0		$430A
	.DEFINE UNUSED0		$430B
	.DEFINE DMAP1		$4310
	.DEFINE BBAD1		$4311
	.DEFINE A1T1L		$4312
	.DEFINE A1T1H		$4313
	.DEFINE A1B1		$4314
	.DEFINE DAS1L		$4315
	.DEFINE DAS1H		$4316
	.DEFINE DASB1		$4317
	.DEFINE A2A1L		$4318
	.DEFINE A2A1H		$4319
	.DEFINE NTRL1		$431A
	.DEFINE UNUSED1		$431B
	.DEFINE DMAP2		$4320
	.DEFINE BBAD2		$4321
	.DEFINE A1T2L		$4322
	.DEFINE A1T2H		$4323
	.DEFINE A1B2		$4324
	.DEFINE DAS2L		$4325
	.DEFINE DAS2H		$4326
	.DEFINE DASB2		$4327
	.DEFINE A2A2L		$4328
	.DEFINE A2A2H		$4329
	.DEFINE NTRL2		$432A
	.DEFINE UNUSED2		$432B
	.DEFINE DMAP3		$4330
	.DEFINE BBAD3		$4331
	.DEFINE A1T3L		$4332
	.DEFINE A1T3H		$4333
	.DEFINE A1B3		$4334
	.DEFINE DAS3L		$4335
	.DEFINE DAS3H		$4336
	.DEFINE DASB3		$4337
	.DEFINE A2A3L		$4338
	.DEFINE A2A3H		$4339
	.DEFINE NTRL3		$433A
	.DEFINE UNUSED3		$433B
	.DEFINE DMAP4		$4340
	.DEFINE BBAD4		$4341
	.DEFINE A1T4L		$4342
	.DEFINE A1T4H		$4343
	.DEFINE A1B4		$4344
	.DEFINE DAS4L		$4345
	.DEFINE DAS4H		$4346
	.DEFINE DASB4		$4347
	.DEFINE A2A4L		$4348
	.DEFINE A2A4H		$4349
	.DEFINE NTRL4		$434A
	.DEFINE UNUSED4		$434B
	.DEFINE DMAP5		$4350
	.DEFINE BBAD5		$4351
	.DEFINE A1T5L		$4352
	.DEFINE A1T5H		$4353
	.DEFINE A1B5		$4354
	.DEFINE DAS5L		$4355
	.DEFINE DAS5H		$4356
	.DEFINE DASB5		$4357
	.DEFINE A2A5L		$4358
	.DEFINE A2A5H		$4359
	.DEFINE NTRL5		$435A
	.DEFINE UNUSED5		$435B
	.DEFINE DMAP6		$4360
	.DEFINE BBAD6		$4361
	.DEFINE A1T6L		$4362
	.DEFINE A1T6H		$4363
	.DEFINE A1B6		$4364
	.DEFINE DAS6L		$4365
	.DEFINE DAS6H		$4366
	.DEFINE DASB6		$4367
	.DEFINE A2A6L		$4368
	.DEFINE A2A6H		$4369
	.DEFINE NTRL6		$436A
	.DEFINE UNUSED6		$436B
	.DEFINE DMAP7		$4370
	.DEFINE BBAD7		$4371
	.DEFINE A1T7L		$4372
	.DEFINE A1T7H		$4373
	.DEFINE A1B7		$4374
	.DEFINE DAS7L		$4375
	.DEFINE DAS7H		$4376
	.DEFINE DASB7		$4377
	.DEFINE A2A7L		$4378
	.DEFINE A2A7H		$4379
	.DEFINE NTRL7		$437A
	.DEFINE UNUSED7		$437B

; Enhancement chip registers
	.DEFINE MSU_STATUS	$2000
	.DEFINE MSU_READ	$2001
	.DEFINE MSU_ID		$2002
	.DEFINE MSU_SEEK	$2000
	.DEFINE MSU_TRACK	$2004					; 16-bit register ($2004-$2005)
	.DEFINE MSU_VOLUME	$2006
	.DEFINE MSU_CONTROL	$2007
	.DEFINE SRTC_READ	$2800					; register for reading the time
	.DEFINE SRTC_WRITE	$2801					; $0D = get time (and set index for read sequence to -1), $0E = send command (+ command byte)
									; known command bytes: $00 = set time (and set index for write sequence to 0), $04 = reset time (and set index to -1)
	.DEFINE ULTRA16_LOCK	$21C0
	.DEFINE ULTRA16_DATA	$21C1
	.DEFINE ULTRA16_SNUM	$21C2

; SNES joypad buttons
	.DEFINE kAllButtons	$F0F0
	.DEFINE kAllDpad	$0F

	.DEFINE kDpadUp		%00001000
	.DEFINE kDpadDown	%00000100
	.DEFINE kDpadLeft	%00000010
	.DEFINE kDpadRight	%00000001

	.DEFINE kButtonA	%10000000
	.DEFINE kButtonB	%10000000
	.DEFINE kButtonX	%01000000
	.DEFINE kButtonY	%01000000
	.DEFINE kButtonL	%00100000
	.DEFINE kButtonR	%00010000
	.DEFINE kButtonSel	%00100000
	.DEFINE kButtonStart	%00010000



; ************************ NMI/IRQ jump tables *************************

; IRQ routine index table (for use with SetIRQ macro)
	.ENUMID 0 STEP 4						; order has to match SRC_IRQJumpTable
	.ENUMID kHIRQ_MenuItemsVsplit
	.ENUMID kVIRQ_Area
	.ENUMID kVIRQ_Mode7



; Vblank routine index table (for use with SetNMI macro)
	.ENUMID 0 STEP 4						; order has to match SRC_VblankJumpTable
	.ENUMID kNMI_Area
	.ENUMID kNMI_DebugMenu
;	.ENUMID kNMI_Error
	.ENUMID kNMI_Intro
	.ENUMID kNMI_Minimal
	.ENUMID kNMI_Mode7
	.ENUMID kNMI_WorldMap



; **************************** Error codes *****************************

	.ENUMID 0 STEP 2						; 128 possible error codes, order has to match both PTR_ErrorCode and PTR_ErrorCodeExtraInfo tables
	.ENUMID kErrorBRK
	.ENUMID kErrorCOP
	.ENUMID kErrorCorruptROM
	.ENUMID kErrorSPC700



; ************************ Event control codes *************************

	.ENUMID 0							; argument(s) (8/16 bit) / effect(s) (if not self-explanatory)
	.ENUMID evc_00_END						; none / end event script processing
	.ENUMID evc_BG3_TEXT						; y position (8), x position (8), string pointer (24) / prints a string on BG3
	.ENUMID evc_DIALOG						; dialogue pointer (16)
	.ENUMID evc_DISABLE_HDMA_CH					; HDMA channel(s) no. # (8)
	.ENUMID evc_DMA_ROM2CGRAM					; CGRAM target address (8), ROM source address (16), ROM source bank (8), size (16)
	.ENUMID evc_DMA_ROM2VRAM					; VRAM target address (16), ROM source address (16), ROM source bank (8), size (16)
	.ENUMID evc_DMA_ROM2WRAM					; WRAM target address (16), WRAM target bank (8), ROM source address (16), ROM source bank (8), size (16)
	.ENUMID evc_ENABLE_HDMA_CH					; HDMA channel(s) no. # (8)
	.ENUMID evc_GSS_COMMAND						; command (16), parameter (16)
	.ENUMID evc_GSS_LOAD_TRACK					; track no. # (16)
	.ENUMID evc_INIT_GAMEINTRO					; none
	.ENUMID evc_JSL							; address (24) / go to some subroutine (long)
	.ENUMID evc_JSR							; address (16) / go to some subroutine
	.ENUMID evc_JUMP						; position in event script to jump to (16)
	.ENUMID evc_LOAD_AREA						; no. # of area (16)
	.ENUMID evc_LOAD_PARTY_FORMATION				; no. # of party formation
	.ENUMID evc_MONITOR_INPUT_JOY1					; joypad data (16), position in event script to jump to (16)
;	.ENUMID evc_MONITOR_INPUT_JOY2					; joypad data (16), position in event script to jump to (16)
	.ENUMID evc_MOVE_ALLY						; ally no. #, direction(s), speed
	.ENUMID evc_MOVE_HERO						; target screen position (16), speed (8) // caveat: position difference has to be divisible by speed value
	.ENUMID evc_MOVE_NPC						; NPC no. #, direction(s), speed
	.ENUMID evc_MOVE_OBJ						; obj. no. #, direction(s), speed
	.ENUMID evc_MSU_LOAD_TRACK					; track no. # (16)
	.ENUMID evc_MSU_TRACK_FADEIN					; speed
	.ENUMID evc_MSU_TRACK_FADEOUT					; speed
	.ENUMID evc_MSU_TRACK_PLAY					; 000000rpvvvvvvvv [r = Repeat flag, p = Play flag, v = volume] (16)
	.ENUMID evc_MSU_TRACK_STOP					; none
	.ENUMID evc_SCR_EFFECT						; effect no. #
	.ENUMID evc_SCR_EFFECT_TRANSITION				; transition effect no. #, speed
	.ENUMID evc_SCR_SCROLL						; BG(s), direction(s), speed
	.ENUMID evc_SET_REGISTER					; SNES register (16), value (8)
	.ENUMID evc_SIMULATE_INPUT_JOY1					; joypad data (16)
	.ENUMID evc_SIMULATE_INPUT_JOY2					; joypad data (16)
	.ENUMID evc_TOGGLE_AUTO_MODE					; none
	.ENUMID evc_WAIT_JOY1						; joypad data (16)
	.ENUMID evc_WAIT_JOY2						; joypad data (16)
	.ENUMID evc_WAIT_FRAMES						; no. of frames (16)
	.ENUMID evc_WRITE_RAM_BYTE					; address (24), value (8) // write a byte to WRAM (for setting register mirror variables etc.)



; *********************** Sprite control tables ************************

; Playable character 1 walking frames table (matches spritesheet)
	.ENUMID 0 STEP 2
	.ENUMID k16_Hero1_frame00
	.ENUMID k16_Hero1_frame01
	.ENUMID k16_Hero1_frame02

; Playable character 1 direction table (matches spritesheet)
	.ENUMID 0
	.ENUMID k8_Hero1_down
	.ENUMID k8_Hero1_up
	.ENUMID k8_Hero1_left
	.ENUMID k8_Hero1_right



; ************************** Misc. constants ***************************

	.DEFINE kTextBG3		$0000				; used as index into PTR_FillTextBuffer, order (ascending value) has to match
	.DEFINE kTextMode5		$0002				; ditto

	.DEFINE kCollMarginLeft		3				; collision margin at left/right/top sprite edges
	.DEFINE kCollMarginRight	3
	.DEFINE kCollMarginTop		1				; the top margin value differs from the other two in that it acts as a protection against getting trapped when moving along upper edges horizontally

	.DEFINE kDebugMenu1stLine	78				; Y position of cursor sprite on first debug menu line

	.DEFINE kGSS_DriverOffset	$0200				; address/offset of SNESGSS driver code in sound RAM
	.DEFINE kGSS_DriverSize		2340				; size (in bytes) of SNESGSS driver code (used in .INCBINs of music data exported by either the original tracker software or a custom exporter)

	.DEFINE kHUD_Xpos		24				; X position (in px) of HUD text box start
	.DEFINE kHUD_Yhidden		240				; Y position of hidden HUD text box
	.DEFINE kHUD_Yvisible		20				; Y position of visible HUD text box

	.DEFINE kMode7SkyLines		72				; number of scanlines for sky above Mode 7 landscape

	.DEFINE kRingMenuCenterX	128
	.DEFINE kRingMenuCenterY	112
	.DEFINE kRingMenuRadiusMin	0
	.DEFINE kRingMenuRadiusMax	60

	.DEFINE kTextBox		$02C0				; tilemap entry for start of whole text box area
	.DEFINE kTextBoxAnimSpd		3				; scrolling speed for text box animation (must be a divisor of 48) // self-reminder: number must match the number of initial black scanlines in SRC_HDMA_TextBoxGradient*, or else TextBoxAnimationClose will leave behind non-black scanlines
	.DEFINE kTextBoxColMath1st	57				; start of first line in a text box selection
;	.DEFINE kTextBoxInside		$02E0				; tilemap entry for inside of text box
	.DEFINE kTextBoxLine1		$02E7				; tilemap entry for start of line 1 in text box
	.DEFINE kTextBoxLine2		$0307				; tilemap entry for start of line 2 in text box
	.DEFINE kTextBoxLine3		$0327				; tilemap entry for start of line 3 in text box
	.DEFINE kTextBoxLine4		$0347				; tilemap entry for start of line 4 in text box
	.DEFINE kTextBoxUL		$02C6				; tilemap entry for upper left corner of text box
	.DEFINE kTextBoxWidth		24				; in "full" (i.e., 16×8) hi-res tiles

	.DEFINE kWaitSPC700		3000				; max. no. of wait loops when communicating with the SPC700 until an error is triggered (the exact value doesn't really matter, but it sholud be reasonably high enough)

; Language constants
	.ENUMID 0
	.ENUMID kLang_Eng						; the order of the languages must match the order of dialogue banks!
;	.ENUMID kLang_Eng2
;	.ENUMID kLang_Eng3
	.ENUMID kLang_Ger
;	.ENUMID kLang_Ger2
;	.ENUMID kLang_Ger3
;	.ENUMID kLang_XXX
;	.ENUMID kLang_XXX
;	.ENUMID kLang_XXX

; Effect types
	.ENUMID 0 STEP 2						; order has to match PTR_EffectTypes table
	.ENUMID kEffectTypeFadeFromBlack
	.ENUMID kEffectTypeFadeToBlack
	.ENUMID kEffectTypeHSplitIn
	.ENUMID kEffectTypeHSplitOut
	.ENUMID kEffectTypeHSplitOut2
	.ENUMID kEffectTypeShutterIn
	.ENUMID kEffectTypeShutterOut
	.ENUMID kEffectTypeDiamondIn
	.ENUMID kEffectTypeDiamondOut

; Effect speed values (signed numbers)
	.ENUMID 1							; positive values
	.ENUMID kEffectSpeed1
	.ENUMID kEffectSpeed2
	.ENUMID kEffectSpeed3
	.ENUMID kEffectSpeed4
	.ENUMID kEffectSpeed5
	.ENUMID kEffectSpeed6
	.ENUMID kEffectSpeed7
	.ENUMID kEffectSpeed8
	.ENUMID kEffectSpeed9
	.ENUMID kEffectSpeed10
	.ENUMID kEffectSpeed11
	.ENUMID kEffectSpeed12

; Effect delay values (signed numbers)
	.ENUMID $FF STEP -1						; negative values (self-reminder: a negative STEP produces a decrementing .ENUMID)
	.ENUMID kEffectDelay1
	.ENUMID kEffectDelay2
	.ENUMID kEffectDelay3
	.ENUMID kEffectDelay4
	.ENUMID kEffectDelay5
	.ENUMID kEffectDelay6
	.ENUMID kEffectDelay7
	.ENUMID kEffectDelay8
	.ENUMID kEffectDelay9
	.ENUMID kEffectDelay10
	.ENUMID kEffectDelay11
	.ENUMID kEffectDelay12

; SNESGSS commands
	.ENUMID 0
	.ENUMID kGSS_NONE						; no command, means the APU is ready for a new command
	.ENUMID kGSS_INITIALIZE						; initialize DSP
	.ENUMID kGSS_LOAD						; load new music data
	.ENUMID kGSS_STEREO						; change stereo sound mode (mono by default in original SNESGSS sound driver)
	.ENUMID kGSS_GLOBAL_VOLUME					; set global volume
	.ENUMID kGSS_CHANNEL_VOLUME					; set channel volume
	.ENUMID kGSS_MUSIC_PLAY						; start music
	.ENUMID kGSS_MUSIC_STOP						; stop music
	.ENUMID kGSS_MUSIC_PAUSE					; pause music
	.ENUMID kGSS_SFX_PLAY						; play sound effect
	.ENUMID kGSS_STOP_ALL_SOUNDS					; stop all sounds
	.ENUMID kGSS_STREAM_START					; start sound streaming
	.ENUMID kGSS_STREAM_STOP					; stop sound streaming
	.ENUMID kGSS_STREAM_SEND					; send a block of data if needed
	.ENUMID kGSS_FASTLOAD						; WIP


; *********************** Misc. memory addresses ***********************

	.DEFINE CGRAM_Portrait		$10
	.DEFINE CGRAM_Area		$20
	.DEFINE CGRAM_WorldMap		$20

	.DEFINE VRAM_BG1_Tiles		$0000
	.DEFINE VRAM_BG2_Tiles		$0000
	.DEFINE VRAM_TextBox		$0000				; text box (BG2)
	.DEFINE VRAM_TextBoxL1		$0100				; start of line 1 in text box (BG2)
	.DEFINE VRAM_Portrait		$06C0				; end of text box, start of portrait (BG1, 2 KiB)
	.DEFINE VRAM_AreaBG1		$0AC0				; area tiles for BG1
	.DEFINE VRAM_AreaBG2		$3800				; area tiles for BG2 (might need to start at an earlier address)

	.DEFINE VRAM_BG3_Tiles		$4000
	.DEFINE VRAM_BG3_Tilemap1	$4800
	.DEFINE VRAM_BG3_Tilemap2	$4C00

	.DEFINE VRAM_BG1_Tilemap1	$5000
	.DEFINE VRAM_BG1_Tilemap2	$5400
	.DEFINE VRAM_BG2_Tilemap1	$5800
	.DEFINE VRAM_BG2_Tilemap2	$5C00

	.DEFINE VRAM_Sprites		$6000				; sprite tiles can go up to $7B5F, and also from $7C00-$7F5F

	.DEFINE VRAM_BG1_Tilemap3	$7800				; only $7B60-$7BFF used for text box
	.DEFINE VRAM_BG2_Tilemap3	$7C00				; only $7F60-$7FFF used for text box



; ************************** WRAM memory map ***************************

; $0000-$01FF: Reserved for stack, Vblank/IRQ jump instructions
; $0200-$09FF: 8 Direct Pages, only the first one is used as of now
; $0A00-$1FFF: various variables

; $7E2000-...: various variables
; $7F0000-...: unused as of now



; WRAM .STRUCTs (in ascending order)

; Self-reminder: Use (at least) 16-bit operand hints for anything within RAM_0000_00FF and RAM_RAM_0100_01FF as these look to WLA DX like Direct Page address space!

	.STRUCT struct_RAM_0000_00FF SIZE 256
		JmpVblank			dsb 4			; NMI vector points here. Holds a 4-byte instruction like jml $C01234
		JmpIRQ				dsb 4			; IRQ vector points here. Holds a 4-byte instruction like jml $C56789
	.ENDST

	.STRUCT struct_RAM_0100_01FF SIZE 256
		Reserved			dsb 255
		InitStackPtr			db			; initial stack pointer = $01FF
	.ENDST

	.STRUCT struct_RAM_0200_02FF SIZE 256
		AreaCurrent			dw			; holds no. of current area
		AreaMetaMapAddr			dsb 3			; holds 24-bit address of collision map
		AreaMetaMapIndex		dw
		AreaMetaMapIndex2		dw
		AreaNamePointerNo		dw
		AreaProperties			dw			; rrrrrrrrrrbayxss [s = screen size, as in BGXSC regs, x/y = area is scrollable horizontally/vertically, a/b = auto-scroll area horizontally/vertically, r = reserved]
		AutoJoy1			dw
		AutoJoy2			dw
;		BRR_stream_src			dsb 4			; SNESGSS
;		BRR_stream_list			dsb 4			; SNESGSS
		Chapter				db			; holds no. of current game chapter
		Hero1FrameCounter		db
		Hero1MapPosX			dw			; in px
		Hero1MapPosY			dw			; in px
		Hero1ScreenPosYX		dw			; high byte = Y position, low byte = X position (in px)
		Hero1SpriteStatus		db			; irrrrddd [i = not walking (idle), ddd = facing direction (0 = down, 1 = up, 2 = left, 3 = right)]
		Hero1WalkingSpd			dw
;		CurrentScanline			dw			; holds no. of current scanline (for CPU load meter)
		DataAddress			dsb 2			; holds a 24-bit data address e.g. for string pointers, data transfers to SRAM, etc.
		DataBank			db
		DiagASCIIChar			dw			; holds current dialogue ASCII character no.
		DiagStringAddress		dw			; 16-bit address of dialogue string // caveat: dialogue string addresses need to be separate from other (FWF/sprite) string addresses as the engine can process both types of strings at the same time (e.g. text box + HUD)
		DiagStringBank			db			; 8-bit bank no. of dialogue string
		DiagStringPos			dw			; holds current dialogue string position (= index to current character)
		DiagTextEffect			db			; bsrrrrrr [b = toggle bold font, s = sub-string active, r = reserved]
		DiagTileDataCounter		dw			; holds current VRAM tile data address
		DMA_Updates			dw			; rrrcbbaarrr32211 [123 = BG no. that needs to have its tilemap(s) updated on next Vblank (low bytes), abc = same thing for high bytes, r = reserved. The lower bit of each BG represents the first half of a 64×32/32×64 tilemap, the higher one represents the second half.]
		EffectSpeed			dw
		ErrorCode			db
		ErrorSignature			db
		EmptySpriteNo			db			; holds no. of empty sprite in current spritesheet (usually 0), this is acknowledged in the sprite initialization routine
		EventCodeAddress		dsb 2
		EventCodeBank			db
		EventCodeJump			dw			; holds event script code pointer to jump to
		EventCodePointer		dw			; holds current event script code pointer
		EventControl			db			; rrrrrrrm [m = monitor joypad 1, r = reserved]
		EventMonitorJoy1		dw			; joypad bits to be monitored by event handler
		EventWaitFrames			dw
		GameConfig			db			; rrrrvucm [c = RTC present, m = MSU1 present, u = Ultra16 present, v = 128K VRAM installed, r = reserved]
		GameLanguage			db			; holds global game language constant (used to determine both text and gfx banks/addresses according to language chosen by player)
		GameMode			db			; arrrrrrr [a = auto-mode, r = reserved]
		GameTimeSeconds			db			; 1 game time second = 1 frame (??)
		GameTimeMinutes			db
		GameTimeHours			db
		GSS_command			dsb 2			; SNESGSS
		GSS_GlobalVol			db			; GlobalVol (lo) and FadeSpeed (hi) are addressed as a word!
		GSS_FadeSpeed			db
		GSS_param			dsb 2			; SNESGSS
		HDMA_Channels			db			; variable is copied to $420C (HDMAEN) during Vblank
		HiResPrintLen			db			; holds length of menu hi-res string to print
		HiResPrintMon			db			; keep track of BG we're printing on: $00 = BG1 (start), $01 = BG2
		HUD_DispCounter			dw			; holds frame count since HUD appeared
		HUD_Status			db			; adrrrrrp [a/d = HUD should (re-)appear/disappear, p = HUD is present on screen, r = reserved]
		HUD_StrLength			db			; holds no. of HUD text characters
		HUD_TextBoxSize			db			; holds no. of HUD text box (frame) sprites
		HUD_Ypos			db			; holds current Y position of HUD
		Joy1				dw			; Current button state of joypad1, bit0=0 if it is a valid joypad
		Joy2				dw			; same thing for all pads...
		Joy1Press			dw			; Holds joypad1 keys that are pressed and have been pressed since clearing this mem location
		Joy2Press			dw			; same thing for all pads...
		Joy1New				dw
		Joy2New				dw
		Joy1Old				dw
		Joy2Old				dw
		LoopCounter			dw			; counts loop iterations
		Mode7_Altitude			db			; altitude setting (currently 0-127)
		Mode7_BG2HScroll		db
		Mode7_CenterCoordX		dw
		Mode7_CenterCoordY		dw
		Mode7_RotAngle			dw			; currently needs to be 16-bit as it's used as an index in CalcMode7Matrix
		Mode7_ScrollOffsetX		dw
		Mode7_ScrollOffsetY		dw
		MSU1_NextTrack			dw			; holds no. of MSU1 track to load
		Multi5_Reg0lo			db
		Multi5_Reg0hi			db
		Multi5_Reg1lo			db
		Multi5_Reg1hi			db
		Multi5_Status			db
		NextTrack			dw			; holds no. of SNESGSS song track to load
		NextEvent			dw			; holds no. of event to load
		PlayerIdleCounter		dw			; holds frame count since last button press
		RegisterBuffer			dw			; holds register to be written to next by event handler
		RingMenuAngle			db
		RingMenuAngleOffset		dw
		RingMenuRadius			db
		RingMenuStatus			db			; eirrrrrr [e = rotate ring menu left, i = rotate ring menu right, r = reserved]
		SNESlib_ptr			dsb 4			; SNESGSS (24-bit source data address, highest 8 bits always 0!?)
;		SNESlib_rand1			dsb 2			; SNESGSS
;		SNESlib_rand2			dsb 2			; SNESGSS
;		SNESlib_temp			dsb 2			; SNESGSS
;		SPC_DataBank			dw			; bank byte of source data to be uploaded to SPC700 (FIXME, high byte is always 0 --> waste of precious DP space)
;		SPC_DataOffset			dw			; 16-bit address of source data to be uploaded to SPC700
		SPC_DataDestAddr		dw			; 16-bit destination address in sound RAM for data to be uploaded to SPC700
		SPC_DataSize			dw			; 16-bit size of source data to be uploaded to SPC700
		SprDataObjNo			db			; holds no. of current object (0-127)
		SprDataHiOAMBits		db			; holds bits to manipulate in high OAM/ShadowOAM_Hi
		SpriteTextMon			dw			; keeps track of sprite-based text buffer filling level
		SpriteTextPalette		db			; holds palette to use when printing sprite-based text
		SubMenuNext			db			; holds no. of sub menu selected
		Temp				dsb 8
		TextBoxBG			db			; bnnnnnnn [b = change text box background, n = no. of color table (0-127)
		TextBoxCharPortrait		db			; pnnnnnnn [p = change character portrait, n = no. of portrait (0-127)
		TextBoxSelection		db			; dcba4321 [1-4 = text box contains selection on line no. 1-4, a-d = selection made by player (1-4)
		TextBoxSelMax			db			; for HDMA selection bar
		TextBoxSelMin			db			; ditto
		TextBoxStatus			db			; awrrrkcb [a = text box active, b = VWF buffer full, c = clear text box, k = kill text box, r = reserved, w = wait for player input]
		TextBoxVIRQ			db			; scanline no. of text box start (for scrolling animation)
		TextCursor			dw
		TextPointerNo			dw
		TextStringPtr			dw			; 16-bit FWF/sprite string pointer (or zeroes) // see caveat @ DiagStringAddress
		TextStringBank			db			; 8-bit bank no. of FWF/sprite string
		VWF_BitsUsed			dw
		VWF_BufferIndex			dw
		VWF_Loop			db
		WorldMapBG1VScroll		dw
		WorldMapBG1HScroll		dw
	.ENDST

	.STRUCT struct_RAM_0300_03FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0400_04FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0500_05FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0600_06FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0700_07FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0800_08FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0900_09FF SIZE 256
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_0A00_1FFF SIZE $1600				; the SIZE here might get relevant later on (e.g., should we decide to convert the WRAM .ENUMs into .RAMSECTIONs)
		HDMA_ColorMath			dsb 96
		HDMA_M7A			dsb 448
		HDMA_M7B			dsb 448
		HDMA_M7C			dsb 448
		HDMA_M7D			dsb 448
		HDMA_FX_1Byte			dsb 224
		HDMA_FX_2Bytes			dsb 448
		HDMA_BG_Scroll			dsb 16
		HDMA_WorMapVScroll		dsb 448
		ObjectList			dsb 128			; keeps track of currently active sprites, 1 byte per sprite: hcirrrra [a = object is active, c = object can collide with other objects, h = object can collide with hero(es), i = object is hero sprite, r = reserved]
		RandomNumbers			dsb 130			; for random numbers
		ShadowOAM_Lo			dsb 512
		ShadowOAM_Hi			dsb 32
		Temp				dsb 32			; for misc. temp bytes
		TempString			dsb 32			; for temp strings
		VWF_TileBuffer			dsb 32
		VWF_TileBuffer2			dsb 32

		DiagStringAddress		dw			; backup for DP variable of the same name (while processing sub-strings etc.)
		DiagStringBank			db			; ditto
		DiagStringPos			dw			; ditto
		DiagSubStrAddress		dw			; holds sub-string address
		DiagSubStrBank			db			; holds sub-string bank
		GameDataItemQty			db
		Hero1TargetScrPosYX		dw			; high byte = Y position, low byte = X position (in px)
		Routine_FillTextBuffer		dw			; holds address of routine to be used for printing strings to the screen
		NMITIMEN			db			; mirror of NMITIMEN
		TextBox_TSTM			dw			; mirrors of subscreen (high) & mainscreen (low) designation registers ($212C/212D) for text box area
		Time_Second			db			; RTC-based time/date variables
		Time_Minute			db
		Time_Hour			db
		Time_Day			db
		Time_Month			db
		Time_Year			db
		Time_Century			db
		TimeoutCounter			dw
	.ENDST

	.STRUCT struct_BG12Tilemap
		Beginning			dsb 704
		TextBox				dsb 192			; 6 lines, 32 tiles each
		Reserved			dsb 128
	.ENDST

	.STRUCT struct_BG3Tilemap
		AllTiles			dsb 1024
	.ENDST

	.STRUCT struct_BG3TilemapHi
		AllTiles			dsb 1024
	.ENDST

	.STRUCT struct_RAM_Routines
		BurstTransferSPC700		dsb 71
		DMA				dsb 49
		UpdatePPURegs			dsb 121
	.ENDST

	.STRUCT struct_SpriteDataArea
		Text				dsb 32 * 5		; 32 chars = one line of text
		HUD_TextBox			dsb 36 * 5		; (180 / 2) / 5 = 18 characters in a full box
		Hero1a				dsb 5
		Hero1b				dsb 5
		Hero1c				dsb 5
		Hero1d				dsb 5
		Hero1Weapon1			dsb 5
		Hero1Weapon2			dsb 5
		Hero1Weapon3			dsb 5
		Hero1Weapon4			dsb 5
		Hero2a				dsb 5
		Hero2b				dsb 5
		Hero2c				dsb 5
		Hero2d				dsb 5
		Hero2Weapon1			dsb 5
		Hero2Weapon2			dsb 5
		Hero2Weapon3			dsb 5
		Hero2Weapon4			dsb 5
		Hero3a				dsb 5
		Hero3b				dsb 5
		Hero3c				dsb 5
		Hero3d				dsb 5
		Hero3Weapon1			dsb 5
		Hero3Weapon2			dsb 5
		Hero3Weapon3			dsb 5
		Hero3Weapon4			dsb 5
		NPCs				dsb 36 * 5		; 36 / 2 = max. 18 (16×32) furries
	.ENDST

;	.STRUCT struct_SpriteDataBattle
;	.ENDST

	.STRUCT struct_SpriteDataMenu
		Hero1a				dsb 5
		Hero1b				dsb 5
		Hero1c				dsb 5
		Hero1d				dsb 5
		Hero2a				dsb 5
		Hero2b				dsb 5
		Hero2c				dsb 5
		Hero2d				dsb 5
		Hero3a				dsb 5
		Hero3b				dsb 5
		Hero3c				dsb 5
		Hero3d				dsb 5
		MainCursor			dsb 5
		RingCursor			dsb 5
		RingItem0			dsb 5
		RingItem1			dsb 5
		RingItem2			dsb 5
		RingItem3			dsb 5
		RingItem4			dsb 5
		RingItem5			dsb 5
		RingItem6			dsb 5
		RingItem7			dsb 5
		Z_Reserved			dsb 106 * 5
	.ENDST

;	.STRUCT struct_SpriteDataX
;	.ENDST

	.STRUCT struct_RAM_7E2000 SIZE $E000
		BG1Tilemap1			INSTANCEOF struct_BG12Tilemap		; each tilemap is 1024 bytes in size (32×32 tiles)
		BG1Tilemap2			dsb 1024
		BG1Tilemap1Hi			INSTANCEOF struct_BG12Tilemap
		BG1Tilemap2Hi			dsb 1024
		BG2Tilemap1			INSTANCEOF struct_BG12Tilemap
		BG2Tilemap2			dsb 1024
		BG2Tilemap1Hi			INSTANCEOF struct_BG12Tilemap
		BG2Tilemap2Hi			dsb 1024
		BG3Tilemap			INSTANCEOF struct_BG3Tilemap
		BG3TilemapHi			INSTANCEOF struct_BG3TilemapHi
		GameDataInventory		dsb 512					; two-byte array for 256 items. Low byte = item no., high byte = quantity
		HDMA_BackgrPlayfield		dsb 704					; 16-bit palette index & 16-bit color entry for 176 scanlines
		HDMA_BackgrTextBox		dsb 192					; ditto for 48 scanlines
		ScratchSpace			dsb 16384
		SpriteDataArea			INSTANCEOF struct_SpriteDataArea	; 128*5 = 640 bytes
;		SpriteDataBattle		INSTANCEOF struct_SpriteDataBattle	; ditto
		SpriteDataMenu			INSTANCEOF struct_SpriteDataMenu	; ditto
;		SpriteDataX			INSTANCEOF struct_SpriteDataX		; ditto
		Routines			INSTANCEOF struct_RAM_Routines		; for modifiable routines
	.ENDST

	.STRUCT struct_RAM_7F SIZE $10000
		dummy_byte			db
	.ENDST

	.STRUCT struct_RAM_AllUpper
						INSTANCEOF struct_RAM_7E2000
						INSTANCEOF struct_RAM_7F
	.ENDST



; Variables referencing the above .STRUCTs

; WRAM area $7E0000-$7E1FFF is addressed with a bank byte of $00 most of the time, so the following
; .ENUM omits that

	.ENUM 0
		P00				INSTANCEOF struct_RAM_0000_00FF
		P01				INSTANCEOF struct_RAM_0100_01FF

; We don't use .UNIONs for the DPs because we do need the respective high byte sometimes (not only for
; tricks like "SetDP DPx", but also for conveniently setting data source addresses within the DP).
; This means we need to address *all* DPx variables with an 8-bit operand hint, like "lda <DP2.Temp".

		DP2				INSTANCEOF struct_RAM_0200_02FF
		DP3				INSTANCEOF struct_RAM_0300_03FF
		DP4				INSTANCEOF struct_RAM_0400_04FF
		DP5				INSTANCEOF struct_RAM_0500_05FF
		DP6				INSTANCEOF struct_RAM_0600_06FF
		DP7				INSTANCEOF struct_RAM_0700_07FF
		DP8				INSTANCEOF struct_RAM_0800_08FF
		DP9				INSTANCEOF struct_RAM_0900_09FF
		LO8				INSTANCEOF struct_RAM_0A00_1FFF
	.ENDE

; WRAM area $7E2000-$7FFFFF is generally addressed with the corresponding bank byte, so the following
; .ENUM includes that

	.ENUM $7E2000
		RAM				INSTANCEOF struct_RAM_AllUpper
	.ENDE

; The following .DEFINEs help keep struct_RAM_Routines more clean, and allow for shorter variable names

	.DEFINE RAM_BurstXfer_SrcBank		RAM.Routines.BurstTransferSPC700+1
	.DEFINE RAM_BurstXfer_Src00		RAM.Routines.BurstTransferSPC700+28
	.DEFINE RAM_BurstXfer_Src40		RAM.Routines.BurstTransferSPC700+33
	.DEFINE RAM_BurstXfer_Src80		RAM.Routines.BurstTransferSPC700+38
	.DEFINE RAM_BurstXfer_SrcC0		RAM.Routines.BurstTransferSPC700+43
	.DEFINE RAM_BurstXfer_CPX		RAM.Routines.BurstTransferSPC700+66

	.DEFINE RAM_DMA_ModeBBusReg		RAM.Routines.DMA+14
	.DEFINE RAM_DMA_SourceOffset		RAM.Routines.DMA+20
	.DEFINE RAM_DMA_SourceBank		RAM.Routines.DMA+26
	.DEFINE RAM_DMA_TransferLength		RAM.Routines.DMA+31

	.DEFINE RAM_INIDISP			RAM.Routines.UpdatePPURegs+11
	.DEFINE RAM_OBSEL			RAM.Routines.UpdatePPURegs+15
	.DEFINE RAM_BGMODE			RAM.Routines.UpdatePPURegs+19
	.DEFINE RAM_MOSAIC			RAM.Routines.UpdatePPURegs+23
	.DEFINE RAM_BG1SC			RAM.Routines.UpdatePPURegs+27
	.DEFINE RAM_BG2SC			RAM.Routines.UpdatePPURegs+31
	.DEFINE RAM_BG3SC			RAM.Routines.UpdatePPURegs+35
	.DEFINE RAM_BG4SC			RAM.Routines.UpdatePPURegs+39
	.DEFINE RAM_BG12NBA			RAM.Routines.UpdatePPURegs+43
	.DEFINE RAM_BG34NBA			RAM.Routines.UpdatePPURegs+47
	.DEFINE RAM_W12SEL			RAM.Routines.UpdatePPURegs+51
	.DEFINE RAM_W34SEL			RAM.Routines.UpdatePPURegs+55
	.DEFINE RAM_WOBJSEL			RAM.Routines.UpdatePPURegs+59
	.DEFINE RAM_WH0				RAM.Routines.UpdatePPURegs+63
	.DEFINE RAM_WH1				RAM.Routines.UpdatePPURegs+67
	.DEFINE RAM_WH2				RAM.Routines.UpdatePPURegs+71
	.DEFINE RAM_WH3				RAM.Routines.UpdatePPURegs+75
	.DEFINE RAM_WBGLOG			RAM.Routines.UpdatePPURegs+79
	.DEFINE RAM_WOBJLOG			RAM.Routines.UpdatePPURegs+83
	.DEFINE RAM_TM				RAM.Routines.UpdatePPURegs+87
	.DEFINE RAM_TS				RAM.Routines.UpdatePPURegs+91
	.DEFINE RAM_TMW				RAM.Routines.UpdatePPURegs+95
	.DEFINE RAM_TSW				RAM.Routines.UpdatePPURegs+99
	.DEFINE RAM_CGWSEL			RAM.Routines.UpdatePPURegs+103
	.DEFINE RAM_CGADSUB			RAM.Routines.UpdatePPURegs+107
	.DEFINE RAM_COLDATA			RAM.Routines.UpdatePPURegs+111
	.DEFINE RAM_SETINI			RAM.Routines.UpdatePPURegs+115



; ************************** SRAM memory map ***************************

; SRAM .STRUCTs

	.STRUCT struct_SRAM_Header SIZE 64				; 64 bytes total
		GoodROM				db			; $01 = ROM integrity test passed
		ChecksumCmpl			dw			; SRAM checksum complement
		Checksum			dw			; SRAM checksum
	.ENDST

	.STRUCT struct_SRAM_Slot SIZE 2032				; fill with game vars/event flags/etc. as needed
		Hero1HPCur			.dw
		Hero1HPCurLo			db
		Hero1HPCurHi			db
		Hero1HPMax			.dw
		Hero1HPMaxLo			db
		Hero1HPMaxHi			db

		Hero2HPCur			.dw
		Hero2HPCurLo			db
		Hero2HPCurHi			db
		Hero2HPMax			.dw
		Hero2HPMaxLo			db
		Hero2HPMaxHi			db

		Hero3HPCur			.dw
		Hero3HPCurLo			db
		Hero3HPCurHi			db
		Hero3HPMax			.dw
		Hero3HPMaxLo			db
		Hero3HPMaxHi			db

		Hero4HPCur			.dw
		Hero4HPCurLo			db
		Hero4HPCurHi			db
		Hero4HPMax			.dw
		Hero4HPMaxLo			db
		Hero4HPMaxHi			db
	.ENDST

	.STRUCT struct_SRAM						; 64 + 2032 * 4 = 8192 bytes
						INSTANCEOF struct_SRAM_Header
		Slot1				INSTANCEOF struct_SRAM_Slot
		Slot2				INSTANCEOF struct_SRAM_Slot
		Slot3				INSTANCEOF struct_SRAM_Slot
		Slot4				INSTANCEOF struct_SRAM_Slot
	.ENDST



; Variables referencing the above .STRUCTs

	.ENUM $B06000
		SRAM				INSTANCEOF struct_SRAM
	.ENDE



; ******************************** EOF *********************************
