; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	DIALOGUE STRINGS (ENGLISH/ENG)
;
; ==================================================================================================



; NOTES
; --------------------------------------------------------------------------------------------------

; For a list of available special characters and text box control codes, see data/tbl_dialogue.tbl
;
; IMPORTANT: A new string (i.e., with numbered label) is defined whenever the d_string macro is
; supplied with a language constant.
;
; Example for printing a number:
;	d_string "This is a hex number: <SUBHEX>"
;	.DL <hex no. label>
;	d_string "<00>"
;
; Example for including a sub-string:
;	d_string "This is a sub-string: <SUBSTR>"
;	.DL <sub-string label>
;
; Things to keep in mind:
; - Sub-strings must have their own NUL-terminator.
; - Only one sub-string level is acknowledged as the sub-string flag gets cleared as soon as a
;   sub-string's NUL terminator is encountered.
;
; As for Selections:
; "skip +1" indicates that the following string ("+1") should be skipped for the corresponding
; selection, "skip +2" would mean that the string after the next is to be skipped, and so on.
; TODO: Find a better way of doing this.



; POINTER TABLE FOR ENGLISH DIALOGUE
; --------------------------------------------------------------------------------------------------

SRC_DialoguePointerTableENG:

; IMPORTANT: If multiple pointer blocks are needed later on, use START <value> in the subsequent
; .REPEAT directive(s).

.REPEAT 202 INDEX COUNT
	.DW STR_DialogueENG{%.4d{COUNT}}				; create pointers for English dialogue strings
.ENDR



; ENGLISH DIALOGUE
; --------------------------------------------------------------------------------------------------

.REDEFINE COUNT = 0							; 4-digit string numbers for reference. Regex search: \d{4}$ Text Pastry command: Ctrl+Alt+N, \i 0 1 4

	d_string kLangENG, "<PORTRAIT><02><BG><01>"			; 0000
	d_string "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.<NL>"
	d_string "the quick brown fox jumps over the lazy dog.<NL>"
	d_string "0123456789 ÄÖÜäëïöüß <B>Bold text<B><NL>"
	d_string "!“#$%&’()*+,-./:;<=>?@[\]^_`{|}~♥×♫<00>"

;	d_string kLangENG, "<PORTRAIT><01><BG><01>"			; 0000
;	d_string "GENGEN:<NL>"
;	d_string "I’m a kobold!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0001
	d_string "ALEC:<NL>"
	d_string "<IND>Whew, what a dream!<CLR>"
	d_string "<IND>I was following the tracks of an elusive maned<NL>"
	d_string "<IND>snow leopard, and when I finally caught up<NL>"
	d_string "<IND>with him, he turned around and spoke to me ...<CLR>"
	d_string "<IND>I can’t remember what he said, only that it<NL>"
	d_string "<IND>totally affected me.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0002
	d_string "ALEC:<NL>"
	d_string "<IND>Phew! I’m glad it was just a dream.<CLR>"
	d_string "<IND>Why am I talking to myself, anyway?<NL>"
	d_string "<IND>I’d better get to work!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0003
	d_string "ALEC:<NL>"
	d_string "<IND>That’s my house.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0004
	d_string "ALEC:<NL>"
	d_string "<IND>My fireplace.<NL>"
	d_string "<IND>Perhaps I should gather some more firewood<NL>"
	d_string "<IND>today ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0005
	d_string "ALEC:<NL>"
	d_string "<IND>Yummy stuff. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0006
	d_string "ALEC:<NL>"
	d_string "<IND>My stack of firewood. Still need more though.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0007
	d_string "ALEC:<NL>"
	d_string "<IND>What the ...?!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><02>"			; 0008
	d_string "TIGRAN:<NL>"
	d_string "<IND>Don’t drop your guard, or ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0009
	d_string "ALEC:<NL>"
	d_string "<IND>Oh, stop it already, Lily.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0010
	d_string "LILY:<NL>"
	d_string "<IND>Sorry, Alec. I just couldn’t resist. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0011
	d_string "ALEC:<NL>"
	d_string "<IND>What do you want?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0012
	d_string "LILY:<NL>"
	d_string "<IND>Don’t be so rude, you!<NL>"
	d_string "<IND>I’ve brought you some coconut milk.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0013
	d_string "ALEC:<NL>"
	d_string "<IND>What for?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0014
	d_string "LILY:<NL>"
	d_string "<IND>Stop asking silly questions and have a sip<NL>"
	d_string "<IND>already.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0015
	d_string "ALEC:<NL>"
	d_string "<IND>Well, okay. Just for you.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0016
	d_string "ALEC:<NL>"
	d_string "<IND>Urgh ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0017
	d_string "LILY:<NL>"
	d_string "<IND>Isn’t it delicious?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0018
	d_string "ALEC:<NL>"
	d_string "<IND>Ummmmm ...<NL>"
	d_string "<SEL><IND>Well, as you said, it’s just coconut milk.<NL>"		; skip +2 thru +4
	d_string "<SEL><IND>Yuck. What’s next on the menu, parsnip stew?<00>"	; skip +1

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0019
	d_string "LILY:<NL>"
	d_string "<IND>I knew you’d love it. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0020
	d_string "LILY:<NL>"
	d_string "<IND>Sorry, Alec. I wasn’t meaning to annoy you.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0021
	d_string "ALEC:<NL>"
	d_string "<IND>Sorry ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0022
	d_string "LILY:<NL>"
	d_string "<IND>Don’t worry, it’s okay. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0023
	d_string "ALEC:<NL>"
	d_string "<IND>But I’m sure that’s not the only reason<NL>"
	d_string "<IND>you’ve come by today this early, is it?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0024
	d_string "LILY:<NL>"
	d_string "<IND>I haven’t, actually.<CLR>"
	d_string "<BG><05>"
	d_string "<IND>The fate of the world depends on you alone!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0025
	d_string "LILY:<NL>"
	d_string "<IND>Tee hee, look at your face now ... ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0026
	d_string "ALEC:<NL>"
	d_string "<IND>You had me there for a second ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0027
	d_string "LILY:<NL>"
	d_string "<IND>But wait ’til you hear this ...<CLR>"
	d_string "<IND>The mayor offers a reward to anyfur who finds<NL>"
	d_string "<IND>out what’s behind this “ghost’’ everyfur’s been<NL>"
	d_string "<IND>talking about lately. You remember the stories<NL>"
	d_string "<IND>I told you, don’t you?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0028
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Of course!<NL>"				; skip +2 thru +4
	d_string "<SEL><IND>No idea what you mean!<NL>"			; skip +1, +5
	d_string "<SEL><IND>Give me a hint, please.<00>"		; skip +1 thru +3, +5

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0029
	d_string "ALEC:<NL>"
	d_string "<IND>Not just yours. The innkeeper, Tusker, claimed<NL>"
	d_string "<IND>that an armful of sausages were stolen from his<NL>"
	d_string "<IND>pantry just the other day.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0030
	d_string "LILY:<NL>"
	d_string "<IND>Where’ve you been, you dummy!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0031
	d_string "ALEC:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Minding my own business, I guess.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0032
	d_string "LILY:<NL>"
	d_string "<IND>Fair enough. To cut a long story short, things have<NL>"
	d_string "<IND>been disappearing lately without any trace.<CLR>"
	d_string "<IND>Sausages have vanished from unlocked pantries,<NL>"
	d_string "<IND>shoes and laundry went missing, even things like<NL>"
	d_string "<IND>carpenters’ tools and fishing rods literally<NL>"
	d_string "<IND>evaporated when nofur was looking.<CLR>"
@Jump01:
	d_string "<IND>My Foxen neighbors’ kid said he’d actually seen<NL>"
	d_string "<IND>the “ghost,’’ and presumed culprit, with his own eyes ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0033
	d_string "LILY:<NL>"
	d_string "<IND>Right. But apart from Tusker’s missing sausages,<NL>"
	d_string "<IND>even more weird stuff’s been going on in the<NL>"
	d_string "<IND>village.<CLR>"
	d_string "<JMP>"
	.DL STR_DialogueENG{%.4d{COUNT-2}}@Jump01

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0034
	d_string "ALEC:<NL>"
	d_string "<IND>With who else’s eyes would he have seen it,<NL>"
	d_string "<IND>anyway?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0035
	d_string "LILY:<NL>"
	d_string "<IND>That’s exactly what I told my neighbors, too.<NL>"
	d_string "<IND>But they’re scared to death by now.<CLR>"
	d_string "<IND>Even Tusker, sensible though as he is, rather<NL>"
	d_string "<IND>chooses to believe in the supernatural. There’s<NL>"
	d_string "<IND>just no way now to persuade anyfur to stick<NL>"
	d_string "<IND>with scientific evidence. So I thought ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0036
	d_string "ALEC:<NL>"
	d_string "<IND>... maybe you could use the help of some hunter?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0037
	d_string "LILY:<NL>"
	d_string "<IND>Not just any hunter, mind you. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0038
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>So what’s the mayor’s reward?<NL>"		; skip +1, +2
	d_string "<SEL><IND>I’d love to hunt some ghost!<00>"		; continue

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0039
	d_string "LILY:<NL>"
	d_string "<IND>Don’t you even want to hear what the mayor’s<NL>"
	d_string "<IND>reward is?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0040
	d_string "ALEC:<NL>"
	d_string "<IND>Huh? What’s that?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0041
	d_string "LILY:<NL>"
	d_string "<IND>A bunch of gold, lots of food, and eternal glory,<NL>"
	d_string "<IND>they say.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0042
	d_string "ALEC:<NL>"
	d_string "<IND>Never mind the gold. Glory sounds fun though.<NL>"
	d_string "<IND>Too bad the prize doesn’t include any firewood ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0043
	d_string "LILY:<NL>"
	d_string "<IND>Oh, but it does ... I completely forgot! There<NL>"
	d_string "<IND>will be firewood. Uh, loads of it. That’s the<NL>"
	d_string "<IND>main thing, actually!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0044
	d_string "ALEC:<NL>"
	d_string "<IND>Let’s go then, what are we waiting for?<NL>"
	d_string "<IND>I want to be home early tonight!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0045
	d_string "LILY:<NL>"
	d_string "<IND>Sure enough. ♥<CLR>"
	d_string "<BG><01>"
	d_string "<IND>Listen, I know somefur who can help us.<NL>"
	d_string "<IND>Before we go see the mayor, we should talk<NL>"
	d_string "<IND>to him.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0046
	d_string "<NL><IND><IND><IND><IND><IND><IND><1> joins the party!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0047
	d_string "LILY:<NL>"
	d_string "<IND>Here we are at last.<NL>"
	d_string "<IND>Oh dear ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0048
	d_string "ALEC:<NL>"
	d_string "<IND>What’s the matter?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0049
	d_string "LILY:<NL>"
	d_string "<IND>I completely forgot to tell my uncle that I’m<NL>"
	d_string "<IND>probably leaving for some time. Let’s meet up<NL>"
	d_string "<IND>at Tusker’s Inn in a bit, okay?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0050
	d_string "ALEC:<NL>"
	d_string "<IND>I’ll go with you, shall I?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0051
	d_string "LILY:<NL>"
	d_string "<IND>That’s so nice of you, Alec. ♥<CLR>"
	d_string "<BG><01>"
	d_string "<IND>... But remember my uncle’s a bit demented. He<NL>"
	d_string "<IND>probably wouldn’t want to be seen by a stranger<NL>"
	d_string "<IND>in his condition.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0052
	d_string "ALEC:<NL>"
	d_string "<IND>Okay. See you then.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0053
	d_string "<NL><IND><IND><IND><IND><IND><IND><1> leaves the party!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0054
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>Hey-ho, Leonido ...<NL>"
	d_string "<IND>For a member of your species, you seem rather<NL>"
	d_string "<IND>short. You’re not a hunter, are you?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0055
	d_string "ALEC:<NL>"
	d_string "<IND>Don’t call me “Leonido!’’<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><02>"			; 0056
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>Okay-o, Leonido ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0057
	d_string "PRIMUS:<NL>"
	d_string "<IND>Hey-ho, Leonido ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0058
	d_string "LILY:<NL>"
	d_string "<IND>What ARE you two doing?!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0059
	d_string "LILY:<NL>"
	d_string "<IND>Argh ... MALES!<NL>"
	d_string "<IND>Either they’re fighting, or ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0060
	d_string "ALEC:<NL>"
	d_string "<IND>Or what?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0061
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>I’m a soldier. Fighting is my profession.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0062
	d_string "LILY:<NL>"
	d_string "<IND>But he’s the guy I told you could help you<NL>"
	d_string "<IND>with your job!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0063
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>Aha, so you’re Alec Marlowe, the hunter?<NL>"
	d_string "<IND>Then I apologize. Pleased to meet you.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0064
	d_string "ALEC:<NL>"
	d_string "<IND>What was that all about?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0065
	d_string "ALEC:<NL>"
	d_string "<IND>Know what?<NL>"
	d_string "<IND>Ask for a name before cursing at<NL>"
	d_string "<IND>random furros, next time!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0066
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>You call that cursing, “Leonido?’’<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0067
	d_string "ALEC:<NL>"
	d_string "<IND>Stop it!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0068
	d_string "LILY:<NL>"
	d_string "<IND>Relax, Alec. He was just quoting himself.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0069
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>She’s right, “Leonido.’’ In quotes, mind you ...<CLR>"
	d_string "<IND>By the way, I’ve been “cursed’’ at many times<NL>"
	d_string "<IND>before, myself, albeit for other reasons.<CLR>"
	d_string "<IND>To be perfectly honest, I stopped bothering<NL>"
	d_string "<IND>back when I was a puppy ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0070
	d_string "ALEC:<NL>"
	d_string "<IND>You’re a jerk.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0071
	d_string "WOLFEN SOLDIER:<NL>"
	d_string "<IND>No, I’m Primus Greyfur, at your service.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0072
	d_string "LILY:<NL>"
	d_string "<IND>He’s a soldier from the Furderal Empire, Alec!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0073
	d_string "ALEC:<NL>"
	d_string "<IND>So ...<NL>"
	d_string "<SEL><IND>Why did you end up here in Librefur?<NL>"	; skip +1
	d_string "<SEL><IND>You’re a deserter then?<00>"		; continue

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0074
	d_string "PRIMUS:<NL>"
	d_string "<IND>I’m as much of a deserter as you are a poacher,<NL>"
	d_string "<IND>Leonido.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0075
	d_string "PRIMUS:<NL>"
	d_string "<IND>Grown tired of dull barracks and drunken<NL>"
	d_string "<IND>generals, I’ve gone freelance as of late.<NL>"
	d_string "<IND>In other words, I offer my services for money.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0076
	d_string "ALEC:<NL>"
	d_string "<IND>Sounds like a hard way to make a living ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0077
	d_string "PRIMUS:<NL>"
	d_string "<IND>Admittedly, it’s hard from time to time.<NL>"
	d_string "<IND>But not today ...<CLR>"
	d_string "<IND>Now, if you’ll excuse me? I have an appointment<NL>"
	d_string "<IND>at the mayor’s. Unless you really mean it, and<NL>"
	d_string "<IND>want to join me hunting down some alleged ghost.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0078
	d_string "ALEC:<NL>"
	d_string "<IND>Huh? Wait a minute ...<CLR>"
	d_string "<IND>Lily!<NL>"
	d_string "<IND>That was MY job, right there!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0079
	d_string "LILY:<NL>"
	d_string "<IND>But your job plus his job equals our job,<NL>"
	d_string "<IND>doesn’t it?<NL>"
	d_string "<IND>So ... let’s finally get going!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0080
	d_string "YOUNG WOLFEN:<NL>"
	d_string "<IND>La ♫ di ♫ da ♫<NL>"
	d_string "<IND>I think that grey-furred soldier likes me. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0081
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>Welcome to your briefing, Primus Greyfur.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0082
	d_string "PRIMUS:<NL>"
	d_string "<IND>Thank you, mayor. These two are with me.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0083
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>Miss Lilac Pondicherry ... I am enchanted.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0084
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Really?<NL>"				; no change in dialogue, only affect sympathy levels
	d_string "<SEL><IND>What about me?<00>"				; ditto

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0085
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>And Alexis Moreflaw, long time no see ... Sir Greyfur,<NL>"
	d_string "<IND>I may point out that every furmunity has a buffoon<NL>"
	d_string "<IND>of its own, and our village is no exception.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0086
	d_string "ALEC:<NL>"
	d_string "<IND>My name’s still ALEC MARLOWE, though!<NL>"
	d_string "<IND>And what the heck’s a “bassoon?!’’<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0087
	d_string "LILY:<NL>"
	d_string "<IND>Shhh ... Take it easy, Alec.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0088
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>In the name of all inhabitants of Furlorn village,<NL>"
	d_string "<IND>thank you for providing us your assistance, Sir<NL>"
	d_string "<IND>Greyfur.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0089
	d_string "PRIMUS:<NL>"
	d_string "<IND>Just Primus, if you will.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0090
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>Yes, of course ... Sir Greyfur, as you are probably<NL>"
	d_string "<IND>aware, eternal glory awaits he who rids us<NL>"
	d_string "<IND>of that dreadful threat ...<CLR>"
	d_string "<IND>... a threat which has haunted our village<NL>"
	d_string "<IND>ever since you showed up here.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0091
	d_string "PRIMUS:<NL>"
	d_string "<IND>Yeah, I ... wait, what? Just glory? No gold?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0092
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>Don’t worry, you will of course be rewarded<NL>"
	d_string "<IND>timely, and decently. You have my word.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0093
	d_string "PRIMUS:<NL>"
	d_string "<IND>Understood.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0094
	d_string "GOATEN MAYOR:<NL>"
	d_string "<IND>That’s settled, then.<CLR>"
@Jump01:
	d_string "<IND>Be sure to talk to all the villagers, as somefur<NL>"
	d_string "<IND>among us is bound to give you a hint on where to<NL>"
	d_string "<IND>start your quest. Godspeed!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0095
	d_string "GOATEN MAYOR:<NL>"
	d_string "<JMP>"
	.DL STR_DialogueENG{%.4d{COUNT-2}}@Jump01

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0096
	d_string "ALEC:<NL>"
	d_string "<IND>So there goes my extra stack of firewood down<NL>"
	d_string "<IND>the drain. Lily, you and I need to talk.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0097
	d_string "LILY:<NL>"
	d_string "<IND>Don’t forget the gold though. With it, you can<NL>"
	d_string "<IND>buy as much firewood as you want, can’t you?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0098
	d_string "ALEC:<NL>"
	d_string "<IND>Oh. Right ...<NL>"
	d_string "<IND>But why the charade?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0099
	d_string "LILY:<NL>"
	d_string "<IND>Sorry, Alec ... You said you wanted to be home early<NL>"
	d_string "<IND>tonight. I was afraid that might not happen.<CLR>"
	d_string "<IND>But I know you, don’t I? I knew you’d be glad<NL>"
	d_string "<IND>that I gave you a little nudge out of your<NL>"
	d_string "<IND>door, and ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0100
	d_string "PRIMUS:<NL>"
	d_string "<IND>Sorry to interrupt, but are you two related?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0101
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>No, we’re lovers, of course.<NL>"			; no change in dialogue, only affect sympathy levels
	d_string "<SEL><IND>She once taught me how to read and write ...<00>"	; ditto

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0102
	d_string "PRIMUS:<NL>"
	d_string "<IND>Alright ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0103
	d_string "LILY:<NL>"
	d_string "<IND>So the mayor told us to talk to the villagers.<NL>"
	d_string "<IND>Let’s go!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0104
	d_string "PRIMUS:<NL>"
	d_string "<IND>Well, I’m going to sleep.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0105
	d_string "ALEC:<NL>"
	d_string "<IND>Well, what are you waiting for?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0106
	d_string "ALEC:<NL>"
	d_string "<IND>Now that he’s gone ...<NL>"
	d_string "<SEL><IND>(I’ll sneak up on him, and tickle him all night long! ♥)<NL>"	; skip +1 thru +10
	d_string "<SEL><IND>(I’d better make it up to Lily for being a meanie.)<00>"		; continue

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0107
	d_string "ALEC:<NL>"
	d_string "<IND>There she is ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0108
	d_string "ALEC:<NL>"
	d_string "<IND>Listen, uhm ... I was just joking.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0109
	d_string "LILY:<NL>"
	d_string "<IND>Yes, I know.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0110
	d_string "ALEC:<NL>"
	d_string "<IND>What?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0111
	d_string "LILY:<NL>"
	d_string "<IND>We’ve known each other ever since we were<NL>"
	d_string "<IND>little cubs. In all these years, you’ve<NL>"
	d_string "<IND>never once embarrassed me ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0112
	d_string "ALEC:<NL>"
	d_string "<IND>I ... really?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0113
	d_string "LILY:<NL>"
	d_string "<IND>Sure thing.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0114
	d_string "ALEC:<NL>"
	d_string "<IND>Well, I’d better try and keep it that way, then.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0115
	d_string "ALEC:<NL>"
	d_string "<IND>Could you ... I mean, would you like to make us<NL>"
	d_string "<IND>your favorite dish tomorrow?<NL>"
	d_string "<IND>I mean ... please?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0116
	d_string "LILY:<NL>"
	d_string "<IND>Oh, Alec ... You are so sweet. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0117
	d_string "PRIMUS:<NL>"
	d_string "<IND>There you are.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0118
	d_string "ALEC:<NL>"
	d_string "<IND>How did you ...?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0119
	d_string "PRIMUS:<NL>"
	d_string "<IND>Heh. You’re not the only one around with a<NL>"
	d_string "<IND>good sense of smell.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0120
	d_string "ALEC:<NL>"
	d_string "<IND>Nice spot you picked for the night.<NL>"
	d_string "<IND>Mind if I join you?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0121
	d_string "PRIMUS:<NL>"
	d_string "<IND>I do mind in case you snore.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0122
	d_string "ALEC:<NL>"
	d_string "<IND>Don’t worry, mate.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0123
	d_string "ALEC:<NL>"
	d_string "<IND>Well ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0124
	d_string "PRIMUS:<NL>"
	d_string "<IND>What is it?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0125
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Good night, Primus. Sleep well.<NL>"			; skip +1
	d_string "<SEL><IND>Look how your ears shimmer in the moonlight ...<00>"	; skip +2

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0126
	d_string "PRIMUS:<NL>"
	d_string "<IND>Good night, Leonido.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0127
	d_string "PRIMUS:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>You too, Alec.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0128
	d_string "ALEC:<NL>"
	d_string "<IND>*Yaaaawn*<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0129
	d_string "PRIMUS:<NL>"
	d_string "<IND>Huh?! What’s this?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0130
	d_string "ALEC:<NL>"
	d_string "<IND>Parsnip stew. Lily just loves it.<NL>"
	d_string "<IND>Let’s spoon it up already.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0131
	d_string "PRIMUS:<NL>"
	d_string "<IND>*mumble* *thistasteslikefoxenpiss* *mumble*<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0132
	d_string "ALEC:<NL>"
	d_string "<IND>Shush, you!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0133
	d_string "LILY:<NL>"
	d_string "<IND>Uh-oh ...<NL>"
	d_string "<IND>Looks like we’re stuck here for now.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0134
	d_string "ALEC:<NL>"
	d_string "<IND>Don’t worry. I lift this up, and we’ll be<NL>"
	d_string "<IND>outta here in no time.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0135
	d_string "LILY:<NL>"
	d_string "<IND>Wait!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0136
	d_string "ALEC:<NL>"
	d_string "<IND>What’s the matter?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0137
	d_string "LILY:<NL>"
	d_string "<IND>We might as well check out the place,<NL>"
	d_string "<IND>don’t you think?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0138
	d_string "PRIMUS:<NL>"
	d_string "<IND>She’s right, Leonido.<NL>"
	d_string "<IND>I smell something fishy going on here ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0139
	d_string "ALEC:<NL>"
	d_string "<IND>...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0140
	d_string "ALEC:<NL>"
	d_string "<IND>Well? What do we do?<NL>"
	d_string "<SEL><IND>(Be on the run!)<NL>"	; no change in dialogue // FIXME, this choice doesn't really make sense
	d_string "<SEL><IND>(Stay and explore)<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0141
	d_string "ALEC:<NL>"
	d_string "<IND>No one’s been around for ages.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0142
	d_string "ALEC:<NL>"
	d_string "<IND>It’s a fennec puppet.<NL>"
	d_string "<IND>Its eyes are missing.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0143
	d_string "LILY:<NL>"
	d_string "<IND>What a creepy place.<NL>"
	d_string "<IND>I begin to feel like we shouldn’t have come here<NL>"
	d_string "<IND>after all ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><02>"			; 0144
	d_string "FENNEC PUPPET:<NL>"
	d_string "<IND>I can’t see you ...<NL>"
	d_string "<IND>... but I can hear your heart throbbing!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0145
	d_string "PRIMUS:<NL>"
	d_string "<IND>Look out! More enemies approaching!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0146
	d_string "MELODIC VOICE:<NL>"
	d_string "<IND>I mean no harm ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0147
	d_string "UNKNOWN FOX:<NL>"
	d_string "<IND>You fought very well.<NL>"
	d_string "<IND>Who are you?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0148
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>I’m Alec, and these are my friends.<NL>"		; skip +2, +3, +5
	d_string "<SEL><IND>I should ask you the same thing, Redcoat!<NL>"	; skip +2 thru +4
	d_string "<SEL><IND>(Have Lily reply instead)<00>"			; skip ... (might need to add a line or two)

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0149
	d_string "LILY:<NL>"
	d_string "<IND>Why did you attack us?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0150
	d_string "UNKNOWN FOX:<NL>"
@Jump01:
	d_string "<IND>I wasn’t going to hurt you, and neither was<NL>"
	d_string "<IND>Dorothy.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0151
	d_string "UNKNOWN FOX:<NL>"
	d_string "<IND>Welcome to my burrow, Alec.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0152
	d_string "UNKNOWN FOX:<NL>"
	d_string "<IND>I am deeply sorry for being so rude in the<NL>"
	d_string "<IND>first place.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0153
	d_string "UNKNOWN FOX:<NL>"
	d_string "<IND>My name is Reinhold von Pappenheim.<NL>"
	d_string "<IND>I’m a professional ventriloquist.<NL>"
	d_string "<IND>I apologize for scaring youfurs ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0154
	d_string "REINHOLD:<NL>"
	d_string "<JMP>"
	.DL STR_DialogueENG{%.4d{COUNT-5}}@Jump01

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0155
	d_string "ALEC:<NL>"
	d_string "<IND>You ever been to Furlorn village, by any chance?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0156
	d_string "PRIMUS:<NL>"
	d_string "<IND>He definitely has. Don’t you smell those smoked<NL>"
	d_string "<IND>summer sausages Tusker said had gone missing?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0157
	d_string "REINHOLD:<NL>"
	d_string "<IND>I confess to snatching food from nearby villages.<NL>"
	d_string "<IND>There is nothing to eat out here in the wild.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0158
	d_string "LILY:<NL>"
	d_string "<IND>So there we have our “ghost.’’<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0159
	d_string "ALEC:<NL>"
	d_string "<IND>Nothing to eat, you say? But the forests around<NL>"
	d_string "<IND>these parts are full of prey!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0160
	d_string "DOROTHY:<NL>"
	d_string "<IND>He’s not a hunter, you see. Nor a gatherer. He’s<NL>"
	d_string "<IND>just a con artist. A trickster, if you will. Without<NL>"
	d_string "<IND>stealing, he’d have starved to death before long.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0161
	d_string "ALEC:<NL>"
	d_string "<IND>Whoa! How can this thing talk, anyway?!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0162
	d_string "LILY:<NL>"
	d_string "<IND>Don’t let him fool you. A ventriloquist is able<NL>"
	d_string "<IND>to speak without moving his lips.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><03>"			; 0163
	d_string "DOROTHY:<NL>"
	d_string "<IND>Exactly. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0164
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Crazy claws!<NL>"
	d_string "<SEL><IND>That’s ... creepy.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0165
	d_string "PRIMUS:<NL>"
	d_string "<IND>Guys, I don’t get it. With a stunt like this, he<NL>"
	d_string "<IND>could make a fortune as a street performer in<NL>"
	d_string "<IND>any big city.<CLR>"
	d_string "<IND>But instead, you’re living out here, in secret.<NL>"
	d_string "<IND>It strikes me as though you were hiding from<NL>"
	d_string "<IND>something.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0166
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Stop, you little bastard! Now!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0167
	d_string "FOXLING:<NL>"
	d_string "<IND>Yikes! I’m stuck!!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0168
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Gotcha!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0169
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>So once again, WHERE IS MY FOOD?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0170
	d_string "FOXLING:<NL>"
	d_string "<IND>Really, I dunno!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0171
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>You whatta?!<NL>"
	d_string "<IND>Listen, if you don’t tell me RIGHT NOW, I’m gonna<NL>"
	d_string "<IND>make a knot in your tail! Got it?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0172
	d_string "FOXLING:<NL>"
	d_string "<IND>Heeeelp!!<NL>"
	d_string "<IND>*squeal*<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0173
	d_string "LILY:<NL>"
	d_string "<IND>We should help the little one!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0174
	d_string "ALEC:<NL>"
	d_string "<IND>Right on!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><02>"			; 0175
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Huh?<NL>"
	d_string "<IND>Who the jackal’s mange are youfurs?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0176
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>*Huff, puff*<NL>"
	d_string "<IND>Idiots! It’s your fault that little thief got away.<CLR>"
	d_string "<IND>I should’ve lambasted him while I had a chance!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0177
	d_string "PRIMUS:<NL>"
	d_string "<IND>Wait ... Did he steal something from you?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0178
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Dammit, yes! EATABLES! <B>EGGS!!<B><00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0179
	d_string "ALEC:<NL>"
	d_string "<IND>Oi ... That doesn’t sound good.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0180
	d_string "LILY:<NL>"
	d_string "<IND>Sorry for the misunderstanding. We thought ...<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0181
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND><B>I don’t care!<B><CLR>"
	d_string "<BG><01>"
	d_string "<IND>My eggs are gone, that’s what counts!<NL>"
	d_string "<IND>Those were pheasant eggs, by the way.<NL>"
	d_string "<IND>Very nutritious. And now they’re GONE FOR GOOD!<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0182
	d_string "ALEC:<NL>"
	d_string "<IND>I’m a hunter. I know where to find pheasant nests.<NL>"
	d_string "<IND>I could help you get a fresh replacement.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0183
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Really?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0184
	d_string "ALEC:<NL>"
	d_string "<IND>Yeah.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0185
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Why would you do this for me?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0186
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>We owe you, after all.<NL>"					; skip +1, +3
	d_string "<SEL><IND>I’m gonna have you slurp up some wicked stuff. ♥<NL>"	; skip +1, +2
	d_string "<SEL><IND>(Have Lily reply instead)<00>"				; skip +3

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0187
	d_string "LILY:<NL>"
	d_string "<IND>Alec’s right. After all, we feel obliged to<NL>"
	d_string "<IND>compensate for your loss.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0188
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>Right. Let’s go then.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0189
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>You bet I will. ♥<NL>"
	d_string "<IND>Awright, let’s go.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0190
	d_string "ALEC:<NL>"
	d_string "<IND>What’s your name, by the way?<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0191
	d_string "MUSCLY PARDEN:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Call me Mickey.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0192
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>I’m Alec, and these are my friends.<NL>"	; only affect sympathy levels
	d_string "<SEL><IND>Call me Leonido. ♥<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0193
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>Allow me the honor. Ahem ...<CLR>"
@Jump01:
	d_string "<IND>My name is Gregory Perpetuus Ebenezer Hrabanus<NL>"
	d_string "<IND>Eindhoven Dubois Quaoar van der Mühlhausen<NL>"
	d_string "<IND>Nido sulle Colline ... junior.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0194
	d_string "LILY:<NL>"
	d_string "<IND>Oh. Really.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0195
	d_string "PRIMUS:<NL>"
	d_string "<IND>Junior, heh.<NL>"
	d_string "<IND>I wonder what the senior’s names might have been<NL>"
	d_string "<IND>then.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0196
	d_string "ALEC:<NL>"
	d_string "<IND>Gregory ...<NL>"
	d_string "<SEL><IND>Say that again?<NL>"			; skip +4
	d_string "<SEL><IND>Can I call you Greg?<00>"			; skip +1 thru +3

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0197
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>Certainly. Ahem ...<CLR>"
	d_string "<JMP>"
	.DL STR_DialogueENG{%.4d{COUNT-5}}@Jump01

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0198
	d_string "LILY:<NL>"
	d_string "<IND>That’s a mouthful.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0199
	d_string "BROWN BEAR:<NL>"
@Jump01:
	d_string "<IND>I prefer to go by Greg anyway.<00>"

	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0200
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>That’s fine.<NL>"
	d_string "<JMP>"
	.DL STR_DialogueENG{%.4d{COUNT-2}}@Jump01

	d_string kLangENG, "<PORTRAIT><00><BG><05>"			; 0201
	d_string "TARA:<NL>"
	d_string "<IND>Don’t you lay your paw on me!<00>"

/*
	d_string kLangENG, "<PORTRAIT><00><BG><01>"			; 0202
	d_string "<NL>"
	d_string "<IND><NL>"
	d_string "<IND><NL>"
	d_string "<IND><00>"
*/

; edge-case test strings
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<NL>"
;	d_string "l<NL>"
;	d_string "i1<NL>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<CLR>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<NL>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<00>"



; EOF
