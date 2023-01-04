;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** DIALOGUE STRINGS (ENGLISH) ***
;
;==========================================================================================



; ******************************* Notes ********************************

; For a list of available special characters and text box control codes,
; see data/tbl_dialogue_*.tbl
;
; Example for printing a number:
;	.STRINGMAP diag, "This is a hex number:<NL>"
;	.STRINGMAP diag, "<SUBHEX>"
;	.DL <label of hex no.>
;	.STRINGMAP diag, "<END>"
;
; Example for including a sub-string:
;	.STRINGMAP diag, "This is a sub-string:<NL>"
;	.STRINGMAP diag, "<SUBSTR>"
;	.DL <sub-string label>
;	.STRINGMAP diag, "<END>"
;
; Just as regular strings, sub-strings must be NUL-terminated. Sub-
; strings may contain sub-strings and/or numbers of their own, but if
; a sub-string contains another sub-string, the main string will be
; be discarded (the sub-string flag gets cleared as soon as the sub-
; string's NUL terminator is encountered).
;
; "skip +1" on e.g. string 0100 indicates that string 0101 should be
; skipped for the corresponding selection, "skip +2" would mean that
; string 0102 is to be skipped, and so on. We use relative string
; references because string numbers change whenever more dialogue is
; added, and adjusting every single instance of these is too tedious
; otherwise.
;
; Jump label numbers (e.g. "Jump9999:") always match the number of the
; string they appear in for convenience when adding/removing dialogue.
; It should be safe, and least confusing, to readjust all jump labels
; in descending order, i.e. starting from the highest numbered string,
; as dialogue is most often added, not removed (so numbers will rise).



; ************************** English Dialogue **************************

STR_DialogEng0000:
	.STRINGMAP ctrl, "<PORTRAIT>$02<BG>$01"
	.STRINGMAP diag, "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.<NL>"
	.STRINGMAP diag, "the quick brown fox jumps over the lazy dog.<NL>"
	.STRINGMAP diag, "0123456789 ÄÖÜäëïöüß <B>Bold text<B><NL>"
	.STRINGMAP diag, "!“#$%&’()*+,-./:;<=>?@[\]^_`{|}~♥×♫<END>"

STR_DialogEng0001:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Whew, what a dream!<CLR>"

	.STRINGMAP diag, "<IND>I was following the tracks of an elusive maned<NL>"
	.STRINGMAP diag, "<IND>snow leopard, and when I finally caught up<NL>"
	.STRINGMAP diag, "<IND>with him, he turned around and spoke to me ...<CLR>"

	.STRINGMAP diag, "<IND>I can’t remember what he said, only that it<NL>"
	.STRINGMAP diag, "<IND>totally affected me.<END>"

STR_DialogEng0002:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Phew! I’m glad it was just a dream.<CLR>"

	.STRINGMAP diag, "<IND>Why am I talking to myself, anyway?<NL>"
	.STRINGMAP diag, "<IND>I’d better get to work!<END>"

STR_DialogEng0003:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>That’s my house.<END>"

STR_DialogEng0004:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>My fireplace.<NL>"
	.STRINGMAP diag, "<IND>Perhaps I should gather some more firewood<NL>"
	.STRINGMAP diag, "<IND>today ...<END>"

STR_DialogEng0005:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Yummy stuff. ♥<END>"

STR_DialogEng0006:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>My stack of firewood. Still need more though.<END>"

STR_DialogEng0007:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What the ...?!<END>"

STR_DialogEng0008:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "TIGER WOMAN:<NL>"
	.STRINGMAP diag, "<IND>Don’t drop your guard, or ...<END>"

STR_DialogEng0009:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Oh, stop it already, Lily.<END>"

STR_DialogEng0010:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Sorry, Alec. I just couldn’t resist. ♥<END>"

STR_DialogEng0011:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What do you want?<END>"

STR_DialogEng0012:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Don’t be so rude, you!<NL>"
	.STRINGMAP diag, "<IND>I’ve brought you some milk.<END>"

STR_DialogEng0013:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What for?<END>"

STR_DialogEng0014:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Stop asking silly questions and have a sip<NL>"
	.STRINGMAP diag, "<IND>already.<END>"

STR_DialogEng0015:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Well, okay. Just for you.<END>"

STR_DialogEng0016:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Urgh ...<END>"

STR_DialogEng0017:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Isn’t it delicious?<END>"

STR_DialogEng0018:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ummmmm ...<NL>"
	.STRINGMAP diag, "<SEL><IND>Well, as you said, it’s just milk.<NL>"			; skip +2 thru +4
	.STRINGMAP diag, "<SEL><IND>Yuck. What’s next on the menu, parsnip stew?<END>"	; skip +1

STR_DialogEng0019:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>I knew you’d love it. ♥<END>"

STR_DialogEng0020:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Sorry, Alec. I wasn’t meaning to annoy you.<END>"

STR_DialogEng0021:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Sorry ...<END>"

STR_DialogEng0022:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Don’t worry, it’s okay. ♥<END>"

STR_DialogEng0023:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>But I’m sure you haven’t just come here<NL>"
	.STRINGMAP diag, "<IND>to bring me some milk, have you?<END>"

STR_DialogEng0024:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Actually, no.<CLR>"

	.STRINGMAP ctrl, "<BG>$05"
	.STRINGMAP diag, "<IND>The fate of the world depends on you!<END>"

STR_DialogEng0025:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Tee hee, look at your face now ... ♥<END>"

STR_DialogEng0026:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>You had me there for a second ...<END>"

STR_DialogEng0027:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>But wait ’til you hear this ...<CLR>"

	.STRINGMAP diag, "<IND>The mayor offers a reward to anyfur who finds<NL>"
	.STRINGMAP diag, "<IND>out what’s behind this “ghost’’ everyfur’s been<NL>"
	.STRINGMAP diag, "<IND>talking about lately. You remember the stories<NL>"
	.STRINGMAP diag, "<IND>I told you, don’t you?<END>"

STR_DialogEng0028:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Of course!<NL>"			; skip +2 thru +4
	.STRINGMAP diag, "<SEL><IND>No idea what you mean!<NL>"	; skip +1, +5
	.STRINGMAP diag, "<SEL><IND>Give me a hint, please.<END>"	; skip +1 thru +3, +5

STR_DialogEng0029:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Not just yours. The innkeeper, Tusker, claimed<NL>"
	.STRINGMAP diag, "<IND>that an armful of sausages were stolen from his<NL>"
	.STRINGMAP diag, "<IND>pantry just the other day.<END>"

STR_DialogEng0030:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Where’ve you been, you dummy!<END>"

STR_DialogEng0031:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>...<CLR>"

	.STRINGMAP diag, "<IND>Minding my own business, I guess.<END>"

STR_DialogEng0032:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Fair enough. To cut a long story short, things have<NL>"
	.STRINGMAP diag, "<IND>been disappearing lately without any trace.<CLR>"

	.STRINGMAP diag, "<IND>Sausages have vanished from unlocked pantries,<NL>"
	.STRINGMAP diag, "<IND>shoes and laundry went missing, even things like<NL>"
	.STRINGMAP diag, "<IND>carpenters’ tools and fishing rods literally<NL>"
	.STRINGMAP diag, "<IND>evaporated when nofur was looking.<CLR>"

Jump0032:
	.STRINGMAP diag, "<IND>My Foxen neighbors’ kid said he’d actually seen<NL>"
	.STRINGMAP diag, "<IND>the “ghost,’’ and presumed culprit, with his own eyes ...<END>"

STR_DialogEng0033:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Right. But apart from Tusker’s missing sausages,<NL>"
	.STRINGMAP diag, "<IND>even more weird stuff’s been going on in the<NL>"
	.STRINGMAP diag, "<IND>village.<CLR>"

	.STRINGMAP ctrl, "<JMP>"
	.DL Jump0032

STR_DialogEng0034:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>With who else’s eyes would he have seen it,<NL>"
	.STRINGMAP diag, "<IND>anyway?<END>"

STR_DialogEng0035:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>That’s exactly what I told my neighbors, too.<NL>"
	.STRINGMAP diag, "<IND>But they’re scared to death by now.<CLR>"

	.STRINGMAP diag, "<IND>Even Tusker, sensible though as he is, rather<NL>"
	.STRINGMAP diag, "<IND>chooses to believe in the supernatural. There’s<NL>"
	.STRINGMAP diag, "<IND>just no way now to persuade anyfur to stick<NL>"
	.STRINGMAP diag, "<IND>with scientific evidence. So I thought ...<END>"

STR_DialogEng0036:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>... maybe you could use the help of some hunter?<END>"

STR_DialogEng0037:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Not just any hunter, mind you. ♥<END>"

STR_DialogEng0038:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>So what’s the mayor’s reward?<NL>"	; skip +1, +2
	.STRINGMAP diag, "<SEL><IND>I’d love to hunt some ghost!<END>"	; continue

STR_DialogEng0039:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Don’t you even want to hear what the mayor’s<NL>"
	.STRINGMAP diag, "<IND>reward is?<END>"

STR_DialogEng0040:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Huh? What’s that?<END>"

STR_DialogEng0041:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>A bunch of gold, lots of food, and eternal glory,<NL>"
	.STRINGMAP diag, "<IND>they say.<END>"

STR_DialogEng0042:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Never mind the gold. Glory sounds fun though.<NL>"
	.STRINGMAP diag, "<IND>Too bad the prize doesn’t include any firewood ...<END>"

STR_DialogEng0043:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Oh, but it does ... I completely forgot! There<NL>"
	.STRINGMAP diag, "<IND>will be firewood. Loads of it. That’s the<NL>"
	.STRINGMAP diag, "<IND>main thing, actually!<END>"

STR_DialogEng0044:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Let’s go then, what are we waiting for?<NL>"
	.STRINGMAP diag, "<IND>I want to be home early tonight!<END>"

STR_DialogEng0045:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Sure enough. ♥<CLR>"

	.STRINGMAP ctrl, "<BG>$01"
	.STRINGMAP diag, "<IND>Listen, I know somefur who can help us.<NL>"
	.STRINGMAP diag, "<IND>Before we go see the mayor, we should talk<NL>"
	.STRINGMAP diag, "<IND>to him.<END>"

STR_DialogEng0046:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "<NL><IND><IND><IND><IND><IND><IND><1> joins the party!<END>"

STR_DialogEng0047:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Here we are at last.<NL>"
	.STRINGMAP diag, "<IND>Oh dear ...<END>"

STR_DialogEng0048:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What’s the matter?<END>"

STR_DialogEng0049:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>I completely forgot to tell my uncle that I’m<NL>"
	.STRINGMAP diag, "<IND>probably leaving for some time. Let’s meet up<NL>"
	.STRINGMAP diag, "<IND>at Tusker’s Inn in a bit, okay?<END>"

STR_DialogEng0050:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>I’ll go with you, shall I?<END>"

STR_DialogEng0051:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>That’s so nice of you, Alec. ♥<CLR>"

	.STRINGMAP ctrl, "<BG>$01"
	.STRINGMAP diag, "<IND>... But remember my uncle’s a bit demented. He<NL>"
	.STRINGMAP diag, "<IND>probably wouldn’t want to be seen by a stranger<NL>"
	.STRINGMAP diag, "<IND>in his condition.<END>"

STR_DialogEng0052:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Okay. See you then.<END>"

STR_DialogEng0053:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "<NL><IND><IND><IND><IND><IND><IND><1> leaves the party!<END>"

STR_DialogEng0054:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FOREIGN WOLF:<NL>"
	.STRINGMAP diag, "<IND>Hey-ho, Leonido ...<NL>"
	.STRINGMAP diag, "<IND>For a member of your species, you seem rather<NL>"
	.STRINGMAP diag, "<IND>short. You’re not a hunter, are you?<END>"

STR_DialogEng0055:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Don’t call me “Leonido!’’<END>"

STR_DialogEng0056:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "FOREIGN WOLF:<NL>"
	.STRINGMAP diag, "<IND>Okay-o, Leonido ...<END>"

STR_DialogEng0057:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Hey-ho, Leonido ...<END>"

STR_DialogEng0058:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>What ARE you two doing?!<END>"

STR_DialogEng0059:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Argh ... MALES!<NL>"
	.STRINGMAP diag, "<IND>Either they’re fighting, or ...<END>"

STR_DialogEng0060:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Or what?<END>"

STR_DialogEng0061:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FOREIGN WOLF:<NL>"
	.STRINGMAP diag, "<IND>I’m a soldier. Fighting is my profession.<END>"

STR_DialogEng0062:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>But he’s the guy I told you could help you<NL>"
	.STRINGMAP diag, "<IND>with your job!<END>"

STR_DialogEng0063:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFEN SOLDIER:<NL>"
	.STRINGMAP diag, "<IND>Aha, so you’re Alec Marlowe, the hunter?<NL>"
	.STRINGMAP diag, "<IND>Then I apologize. Pleased to meet you.<END>"

STR_DialogEng0064:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What was that all about?<END>"

STR_DialogEng0065:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Know what?<NL>"
	.STRINGMAP diag, "<IND>Ask for a name before cursing at<NL>"
	.STRINGMAP diag, "<IND>random furros, next time!<END>"

STR_DialogEng0066:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFEN SOLDIER:<NL>"
	.STRINGMAP diag, "<IND>You call that cursing, “Leonido?’’<END>"

STR_DialogEng0067:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Stop it!<END>"

STR_DialogEng0068:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Relax, Alec. He was just quoting himself.<END>"

STR_DialogEng0069:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFEN SOLDIER:<NL>"
	.STRINGMAP diag, "<IND>She’s right, “Leonido.’’ In quotes, mind you ...<CLR>"

	.STRINGMAP diag, "<IND>By the way, I’ve been “cursed’’ at many times<NL>"
	.STRINGMAP diag, "<IND>before, myself, albeit for other reasons.<CLR>"

	.STRINGMAP diag, "<IND>To be perfectly honest, I stopped bothering<NL>"
	.STRINGMAP diag, "<IND>back when I was a puppy ...<END>"

STR_DialogEng0070:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>You’re a jerk.<END>"

STR_DialogEng0071:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFEN SOLDIER:<NL>"
	.STRINGMAP diag, "<IND>No, I’m Primus Greyfur, at your service.<END>"

STR_DialogEng0072:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>He’s a soldier from the Furderal Empire, Alec!<END>"

STR_DialogEng0073:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>So ...<NL>"
	.STRINGMAP diag, "<SEL><IND>Why did you end up here in Librefur?<NL>"	; skip +2
	.STRINGMAP diag, "<SEL><IND>You’re a deserter then?<END>"		; continue

STR_DialogEng0074:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>I’m as much of a deserter as you are a poacher,<NL>"
	.STRINGMAP diag, "<IND>Leonido.<END>"

STR_DialogEng0075:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Grown tired of dull barracks and drunken<NL>"
	.STRINGMAP diag, "<IND>generals, I’ve gone freelance as of late.<NL>"
	.STRINGMAP diag, "<IND>In other words, I offer my services for money.<END>"

STR_DialogEng0076:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Sounds like a hard way to make a living ...<END>"

STR_DialogEng0077:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Admittedly, it’s hard from time to time.<NL>"
	.STRINGMAP diag, "<IND>But not today ...<CLR>"

	.STRINGMAP diag, "<IND>Now, if you’ll excuse me? I have an appointment<NL>"
	.STRINGMAP diag, "<IND>at the mayor’s. Unless you really mean it, and<NL>"
	.STRINGMAP diag, "<IND>want to join me hunting down some alleged ghost.<END>"

STR_DialogEng0078:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Huh? Wait a minute ...<CLR>"

	.STRINGMAP diag, "<IND>Lily!<NL>"
	.STRINGMAP diag, "<IND>That was MY job, right there!<END>"

STR_DialogEng0079:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>But your job plus his job equals our job,<NL>"
	.STRINGMAP diag, "<IND>doesn’t it?<NL>"
	.STRINGMAP diag, "<IND>So ... let’s finally get going!<END>"

STR_DialogEng0080:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "YOUNG WOLFEN:<NL>"
	.STRINGMAP diag, "<IND>La ♫ di ♫ da ♫<NL>"
	.STRINGMAP diag, "<IND>I think that grey-furred soldier likes me. ♥<END>"

STR_DialogEng0081:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>Welcome to your briefing, Primus Greyfur.<END>"

STR_DialogEng0082:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Thank you, mayor. These two are with me.<END>"

STR_DialogEng0083:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>Miss Lilac Pondicherry ... I am enchanted.<END>"

STR_DialogEng0084:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Really?<NL>"		; no change in dialogue, only affect sympathy levels
	.STRINGMAP diag, "<SEL><IND>What about me?<END>"	; ditto

STR_DialogEng0085:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>And Alexis Moreflaw, long time no see ... Sir Greyfur,<NL>"
	.STRINGMAP diag, "<IND>I may point out that every furmunity has a buffoon<NL>"
	.STRINGMAP diag, "<IND>of its own, and our village is no exception.<END>"

STR_DialogEng0086:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>My name’s still ALEC MARLOWE, though!<NL>"
	.STRINGMAP diag, "<IND>And what the heck’s a “bassoon?!’’<END>"

STR_DialogEng0087:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Shhh ... Take it easy, Alec.<END>"

STR_DialogEng0088:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>In the name of all inhabitants of Furlorn village,<NL>"
	.STRINGMAP diag, "<IND>thank you for providing us your assistance, Sir<NL>"
	.STRINGMAP diag, "<IND>Greyfur.<END>"

STR_DialogEng0089:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Just Primus, if you will.<END>"

STR_DialogEng0090:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>Yes, of course ... Sir Greyfur, as you are probably<NL>"
	.STRINGMAP diag, "<IND>aware, eternal glory awaits he who rids us<NL>"
	.STRINGMAP diag, "<IND>of that dreadful threat ...<CLR>"

	.STRINGMAP diag, "<IND>... a threat which has haunted our village<NL>"
	.STRINGMAP diag, "<IND>ever since you showed up here.<END>"

STR_DialogEng0091:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Yeah, I ... wait, what? Just glory? No gold?<END>"

STR_DialogEng0092:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>Don’t worry, you will of course be rewarded<NL>"
	.STRINGMAP diag, "<IND>timely, and decently. You have my word.<END>"

STR_DialogEng0093:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Understood.<END>"

STR_DialogEng0094:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP diag, "<IND>That’s settled, then.<CLR>"

Jump0094:
	.STRINGMAP diag, "<IND>Be sure to talk to all the villagers, as somefur<NL>"
	.STRINGMAP diag, "<IND>among us is bound to give you a hint on where to<NL>"
	.STRINGMAP diag, "<IND>start your quest. Godspeed!<END>"

STR_DialogEng0095:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GOATEN MAYOR:<NL>"
	.STRINGMAP ctrl, "<JMP>"
	.DL Jump0094

STR_DialogEng0096:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>So there goes my extra stack of firewood down<NL>"
	.STRINGMAP diag, "<IND>the drain. Lily, you and I need to talk.<END>"

STR_DialogEng0097:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Don’t forget the gold though. With it, you can<NL>"
	.STRINGMAP diag, "<IND>buy as much firewood as you want, can’t you?<END>"

STR_DialogEng0098:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Oh. Right ...<NL>"
	.STRINGMAP diag, "<IND>But why the charade?<END>"

STR_DialogEng0099:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Sorry, Alec ... You said you wanted to be home early<NL>"
	.STRINGMAP diag, "<IND>tonight. I was afraid that might not happen.<CLR>"

	.STRINGMAP diag, "<IND>But I know you, don’t I? I knew you’d be glad<NL>"
	.STRINGMAP diag, "<IND>that I gave you a little nudge out of your<NL>"
	.STRINGMAP diag, "<IND>door, and ...<END>"

STR_DialogEng0100:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Sorry to interrupt, but are you two relatives?<END>"

STR_DialogEng0101:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>No, we’re lovers, of course.<NL>"			; no change in dialogue, only affect sympathy levels
	.STRINGMAP diag, "<SEL><IND>She once taught me how to read and write ...<END>"	; ditto

STR_DialogEng0102:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Alright ...<END>"

STR_DialogEng0103:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>So the mayor told us to talk to the villagers.<NL>"
	.STRINGMAP diag, "<IND>Let’s go!<END>"

STR_DialogEng0104:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GORILLA 1:<NL>"
	.STRINGMAP diag, "<IND>G’day, mate.<NL>"
	.STRINGMAP diag, "<IND>Very pleased ter meetcha, me is ...<CLR>"

	.STRINGMAP ctrl, "<BG>$04"
	.STRINGMAP diag, "<IND>... ’cuz me main hobby is turning lions into<NL>"
	.STRINGMAP diag, "<IND>sausage!<NL>"
	.STRINGMAP diag, "<IND>Oh, me name’s Joe. Joe Lion-Trapper ...<END>"

STR_DialogEng0105:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "GORILLA 2:<NL>"
	.STRINGMAP diag, "<IND>Hello there, hunky mane-bearer. ♥<NL>"
	.STRINGMAP diag, "<IND>Your muscled appearance, coated in velvety<NL>"
	.STRINGMAP diag, "<IND>golden fur, is indeed a feast for the eyes ...<CLR>"

	.STRINGMAP ctrl, "<BG>$04"
	.STRINGMAP diag, "<IND>... as it’ll be for my fangs. Too bad you can’t live<NL>"
	.STRINGMAP diag, "<IND>to witness our appreciation of your tasty flesh!<NL>"
	.STRINGMAP diag, "<IND>By the way, they call me Jim. Jim Lion-Slayer ...<END>"

STR_DialogEng0106:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GORILLA 3:<NL>"
	.STRINGMAP diag, "<IND>Greetings, splendid Leoniden fellow.<NL>"
	.STRINGMAP diag, "<IND>Never mind either of my brothers’ uncouth<NL>"
	.STRINGMAP diag, "<IND>talk ...<CLR>"

	.STRINGMAP ctrl, "<BG>$04"
	.STRINGMAP diag, "<IND>Just rest assured that it will be an honor,<NL>"
	.STRINGMAP diag, "<IND>and a privilege, to take your precious hide.<NL>"
	.STRINGMAP diag, "<IND>For I am known as Jack. Jack Lion-Flayer ...<END>"

STR_DialogEng0107:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Know what, you apes?<NL>"
	.STRINGMAP diag, "<IND>I won’t be flayed by any Tom, Dick or Harry!<END>"

STR_DialogEng0108:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Well, I stand corrected.<NL>"
	.STRINGMAP diag, "<IND>I hadn’t the faintest idea wild boar roast<NL>"
	.STRINGMAP diag, "<IND>was THAT delicious.<CLR>"

	.STRINGMAP ctrl, "<BG>$03"
	.STRINGMAP diag, "<IND>Thanks, Alec! ♥<END>"

STR_DialogEng0109:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>This tastes good indeed ...<NL>"
	.STRINGMAP diag, "<IND>*sniffle*<NL>"
	.STRINGMAP diag, "<IND>... but it certainly isn’t wild boar roast.<END>"

STR_DialogEng0110:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Yum! ♥<CLR>"

	.STRINGMAP diag, "<IND>I never knew the taste of fresh primate liver<NL>"
	.STRINGMAP diag, "<IND>actually resembled salted pork ...!<END>"

STR_DialogEng0111:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Wh...what?<NL>"
	.STRINGMAP diag, "<IND>You mean what I’m eating is ... the remains of ...<END>"

STR_DialogEng0112:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>... three quarrelsome gorillas?<NL>"
	.STRINGMAP diag, "<IND>Hehe ... Who knows?!<END>"

STR_DialogEng0113:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Alec, you ... you ... *sob*<END>"

STR_DialogEng0114:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Tell her the truth, will you?<END>"

STR_DialogEng0115:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What, that we were actually just having<NL>"
	.STRINGMAP diag, "<IND>venison ragout?<END>"

STR_DialogEng0116:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>No, Leonido.<CLR>"

	.STRINGMAP diag, "<IND>Tell her you are not in love with her.<END>"

STR_DialogEng0117:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>That’s none of your business.<END>"

STR_DialogEng0118:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Well, I’m going to sleep.<END>"

STR_DialogEng0119:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Well, what are you waiting for?<END>"

STR_DialogEng0120:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Now that he’s gone ...<NL>"
	.STRINGMAP diag, "<SEL><IND>(I’ll sneak up on him, and tickle him all night long! ♥)<NL>"	; skip +1 thru +10
	.STRINGMAP diag, "<SEL><IND>(I’d better make it up to Lily for being a meanie.)<END>"		; continue

STR_DialogEng0121:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>There she is ...<END>"

STR_DialogEng0122:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Listen, uhm ... I was just joking.<END>"

STR_DialogEng0123:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Yes, I know.<END>"

STR_DialogEng0124:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What?<END>"

STR_DialogEng0125:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>We’ve known each other ever since we were<NL>"
	.STRINGMAP diag, "<IND>little cubs. In all these years, you’ve<NL>"
	.STRINGMAP diag, "<IND>never once embarrassed me ...<END>"

STR_DialogEng0126:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>I ... really?<END>"

STR_DialogEng0127:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>No kidding.<END>"

STR_DialogEng0128:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Well, I’d better try and keep it that way, then.<END>"

STR_DialogEng0129:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Could you ... I mean, would you like to make us<NL>"
	.STRINGMAP diag, "<IND>your favorite dish tomorrow?<NL>"
	.STRINGMAP diag, "<IND>I mean ... please?<END>"

STR_DialogEng0130:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Oh, Alec ... You are so sweet. ♥<END>"

STR_DialogEng0131:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>There you are.<END>"

STR_DialogEng0132:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>How did you ...?<END>"

STR_DialogEng0133:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Heh. You’re not the only one around with a<NL>"
	.STRINGMAP diag, "<IND>good sense of smell.<END>"

STR_DialogEng0134:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Nice spot you picked for the night.<NL>"
	.STRINGMAP diag, "<IND>Mind if I join you?<END>"

STR_DialogEng0135:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>I do mind in case you snore.<END>"

STR_DialogEng0136:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Don’t worry, mate.<END>"

STR_DialogEng0137:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Well ...<END>"

STR_DialogEng0138:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>What is it?<END>"

STR_DialogEng0139:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Good night, Primus. Sleep well.<NL>"			; skip +1
	.STRINGMAP diag, "<SEL><IND>Look how your ears shimmer in the moonlight ...<END>"	; skip +2

STR_DialogEng0140:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Good night, Leonido.<END>"

STR_DialogEng0141:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>...<CLR>"

	.STRINGMAP diag, "<IND>You too, Alec.<END>"

STR_DialogEng0142:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>*Yaaaawn*<END>"

STR_DialogEng0143:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Huh?! What’s this?<END>"

STR_DialogEng0144:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Parsnip stew. Lily just loves it.<NL>"
	.STRINGMAP diag, "<IND>Let’s spoon it up already.<END>"

STR_DialogEng0145:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>*mumble* *thistasteslikefoxenpiss* *mumble*<END>"

STR_DialogEng0146:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Shush, you!<END>"

STR_DialogEng0147:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Uh-oh ...<NL>"
	.STRINGMAP diag, "<IND>Looks like we’re stuck here for now.<END>"

STR_DialogEng0148:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Don’t worry. I lift this up, and we’ll be<NL>"
	.STRINGMAP diag, "<IND>outta here in no time.<END>"

STR_DialogEng0149:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Wait!<END>"

STR_DialogEng0150:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What’s the matter?<END>"

STR_DialogEng0151:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>We might as well check out the place,<NL>"
	.STRINGMAP diag, "<IND>don’t you think?<END>"

STR_DialogEng0152:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>She’s right, Leonido.<NL>"
	.STRINGMAP diag, "<IND>I smell something fishy going on here ...<END>"

STR_DialogEng0153:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>...<END>"

STR_DialogEng0154:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Well? What do we do?<NL>"
	.STRINGMAP diag, "<SEL><IND>(Be on the run!)<NL>"	; no change in dialogue // FIXME, this choice doesn't really make sense
	.STRINGMAP diag, "<SEL><IND>(Stay and explore)<END>"

STR_DialogEng0155:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>No one’s been around for ages.<END>"

STR_DialogEng0156:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>It’s a fennec puppet.<NL>"
	.STRINGMAP diag, "<IND>Its eyes are missing.<END>"

STR_DialogEng0157:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>What a creepy place.<NL>"
	.STRINGMAP diag, "<IND>I begin to feel like we shouldn’t have come here<NL>"
	.STRINGMAP diag, "<IND>after all ...<END>"

STR_DialogEng0158:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "FENNEC PUPPET:<NL>"
	.STRINGMAP diag, "<IND>I can’t see you ...<NL>"
	.STRINGMAP diag, "<IND>... but I can hear your heart throbbing!<END>"

STR_DialogEng0159:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Look out! More enemies approaching!<END>"

STR_DialogEng0160:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MELODIC VOICE:<NL>"
	.STRINGMAP diag, "<IND>I mean no harm ...<END>"

STR_DialogEng0161:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "UNKNOWN FOX:<NL>"
	.STRINGMAP diag, "<IND>You fought very well.<NL>"
	.STRINGMAP diag, "<IND>Who are you?<END>"

STR_DialogEng0162:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>I’m Alec, and these are my friends.<NL>"		; skip +2, +3, +5
	.STRINGMAP diag, "<SEL><IND>I should ask you the same thing, Redcoat!<NL>"	; skip +2 thru +4
	.STRINGMAP diag, "<SEL><IND>(Have Lily reply instead)<END>"			; skip ... (might need to add a line or two)

STR_DialogEng0163:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Why did you attack us?<END>"

STR_DialogEng0164:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "UNKNOWN FOX:<NL>"
Jump0164:
	.STRINGMAP diag, "<IND>I wasn’t going to hurt you, and neither was<NL>"
	.STRINGMAP diag, "<IND>Dorothy.<END>"

STR_DialogEng0165:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "UNKNOWN FOX:<NL>"
	.STRINGMAP diag, "<IND>Welcome to my burrow, Alec.<END>"

STR_DialogEng0166:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "UNKNOWN FOX:<NL>"
	.STRINGMAP diag, "<IND>I am deeply sorry for being so rude in the<NL>"
	.STRINGMAP diag, "<IND>first place.<END>"

STR_DialogEng0167:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "UNKNOWN FOX:<NL>"
	.STRINGMAP diag, "<IND>My name is Reinhold von Pappenheim.<NL>"
	.STRINGMAP diag, "<IND>I’m a professional ventriloquist.<NL>"
	.STRINGMAP diag, "<IND>I apologize for scaring youfurs ...<END>"

STR_DialogEng0168:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "REINHOLD:<NL>"
	.STRINGMAP ctrl, "<JMP>"
	.DL Jump0164

STR_DialogEng0169:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>You ever been to Furlorn village, by any chance?<END>"

STR_DialogEng0170:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>He definitely has. Don’t you smell those smoked<NL>"
	.STRINGMAP diag, "<IND>summer sausages Tusker said had gone missing?<END>"

STR_DialogEng0171:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "REINHOLD:<NL>"
	.STRINGMAP diag, "<IND>I confess to snatching food from nearby villages.<NL>"
	.STRINGMAP diag, "<IND>There is nothing to eat out here in the wild.<END>"

STR_DialogEng0172:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>So there we have our “ghost.’’<END>"

STR_DialogEng0173:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Nothing to eat, you say? But the forests around<NL>"
	.STRINGMAP diag, "<IND>these parts are full of prey!<END>"

STR_DialogEng0174:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "DOROTHY:<NL>"
	.STRINGMAP diag, "<IND>He’s not a hunter, you see. Nor a gatherer. He’s<NL>"
	.STRINGMAP diag, "<IND>just a con artist. A trickster, if you will. Without<NL>"
	.STRINGMAP diag, "<IND>stealing, he’d have starved to death before long.<END>"

STR_DialogEng0175:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Whoa! How can this thing talk, anyway?!<END>"

STR_DialogEng0176:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Don’t let him fool you. A ventriloquist is able<NL>"
	.STRINGMAP diag, "<IND>to speak without moving his lips.<END>"

STR_DialogEng0177:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "DOROTHY:<NL>"
	.STRINGMAP diag, "<IND>Exactly. ♥<END>"

STR_DialogEng0178:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Crazy claws!<NL>"
	.STRINGMAP diag, "<SEL><IND>That’s ... creepy.<END>"

STR_DialogEng0179:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Guys, I don’t get it. With a stunt like this, he<NL>"
	.STRINGMAP diag, "<IND>could make a fortune as a street performer in<NL>"
	.STRINGMAP diag, "<IND>any big city.<CLR>"

	.STRINGMAP diag, "<IND>But instead, you’re living out here, in secret.<NL>"
	.STRINGMAP diag, "<IND>It strikes me as though you were hiding from<NL>"
	.STRINGMAP diag, "<IND>something.<END>"

STR_DialogEng0180:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Stop, you little bastard! Now!<END>"

STR_DialogEng0181:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FOXLING:<NL>"
	.STRINGMAP diag, "<IND>Yikes! I’m stuck!!<END>"

STR_DialogEng0182:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Gotcha!<END>"

STR_DialogEng0183:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>So once again, WHERE IS MY FOOD?<END>"

STR_DialogEng0184:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FOXLING:<NL>"
	.STRINGMAP diag, "<IND>Really, I dunno!<END>"

STR_DialogEng0185:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>You whatta?!<NL>"
	.STRINGMAP diag, "<IND>Listen, if you don’t tell me RIGHT NOW, I’m gonna<NL>"
	.STRINGMAP diag, "<IND>make a knot in your tail! Got it?<END>"

STR_DialogEng0186:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "FOXLING:<NL>"
	.STRINGMAP diag, "<IND>Heeeelp!!<NL>"
	.STRINGMAP diag, "<IND>*squeal*<END>"

STR_DialogEng0187:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>We should help the little one!<END>"

STR_DialogEng0188:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Right on!<END>"

STR_DialogEng0189:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Huh?<NL>"
	.STRINGMAP diag, "<IND>Who the jackal’s mange are youfurs?<END>"

STR_DialogEng0190:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>*Huff, puff*<NL>"
	.STRINGMAP diag, "<IND>Idiots! It’s your fault that little thief got away.<CLR>"

	.STRINGMAP diag, "<IND>I should’ve lambasted him while I had a chance!<END>"

STR_DialogEng0191:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Wait ... Did he steal something from you?<END>"

STR_DialogEng0192:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Dammit, yes! Eatables! EGGS!!<END>"

STR_DialogEng0193:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Oi ... That doesn’t sound good.<END>"

STR_DialogEng0194:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Sorry for the misunderstanding. We thought ...<END>"

STR_DialogEng0195:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>I don’t care what you think!<CLR>"

	.STRINGMAP ctrl, "<BG>$01"
	.STRINGMAP diag, "<IND>My eggs are gone, that’s what counts!<NL>"
	.STRINGMAP diag, "<IND>Those were pheasant eggs, by the way.<NL>"
	.STRINGMAP diag, "<IND>Very nutritious. And now they’re GONE FOR GOOD!<END>"

STR_DialogEng0196:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>I’m a hunter. I know where to find pheasant nests.<NL>"
	.STRINGMAP diag, "<IND>I could help you get a fresh replacement.<END>"

STR_DialogEng0197:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Really?<END>"

STR_DialogEng0198:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Yeah.<END>"

STR_DialogEng0199:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Why would you do this for me?<END>"

STR_DialogEng0200:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>We owe you, after all.<NL>"				; skip +1, +3
	.STRINGMAP diag, "<SEL><IND>I’m gonna have you slurp up some wicked stuff. ♥<NL>"	; skip +1, +2
	.STRINGMAP diag, "<SEL><IND>(Have Lily reply instead)<END>"				; skip +3

STR_DialogEng0201:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Alec’s right. After all, we feel obliged to<NL>"
	.STRINGMAP diag, "<IND>compensate for your loss.<END>"

STR_DialogEng0202:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>Right. Let’s go then.<END>"

STR_DialogEng0203:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>You bet I will. ♥<NL>"
	.STRINGMAP diag, "<IND>Awright, let’s go.<END>"

STR_DialogEng0204:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>What’s your name, by the way?<END>"

STR_DialogEng0205:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSCLY PARDEN:<NL>"
	.STRINGMAP diag, "<IND>...<CLR>"

	.STRINGMAP diag, "<IND>Call me Mickey.<END>"

STR_DialogEng0206:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>I’m Alec, and these are my friends.<NL>"	; only affect sympathy levels
	.STRINGMAP diag, "<SEL><IND>Call me Leonido. ♥<END>"

STR_DialogEng0207:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "BROWN BEAR:<NL>"
	.STRINGMAP diag, "<IND>Allow me the honor. Ahem ...<CLR>"

	.STRINGMAP diag, "<IND>My name is Gregory Perpetuus Ebenezer Hrabanus<NL>"
	.STRINGMAP diag, "<IND>Eindhoven Dubois Quaoar van der Mühlhausen<NL>"
	.STRINGMAP diag, "<IND>Nido sulle Colline ... junior.<END>"

STR_DialogEng0208:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "TARA:<NL>"
	.STRINGMAP diag, "<IND>Don’t you lay your paw on me!<END>"

/*
STR_DialogEng0209:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "<NL>"
	.STRINGMAP diag, "<IND><NL>"
	.STRINGMAP diag, "<IND><NL>"
	.STRINGMAP diag, "<IND><END>"
*/



; ******************************** EOF *********************************
