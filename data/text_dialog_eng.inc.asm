;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** DIALOG STRINGS (ENGLISH) ***
;
;==========================================================================================



; ******************************* Notes ********************************

; For a list of available special character aliases and text box control
; codes, see lib_variables.asm.
;
; Example for printing a number:
;	.DB "This is a hex number:", CC_NewLine
;	.DB CC_SubHex
;	.DL <label of hex no.>
;	.DB CC_End
;
; Example for including a sub-string:
;	.DB "This is a sub-string:", CC_NewLine
;	.DB CC_SubString
;	.DL <sub-string label>
;	.DB CC_End
;
; Just as regular strings, sub-strings must be terminated with CC_End.
; Sub-strings may contain sub-strings and/or numbers themselves, but
; then the rest of the master string will be disregarded as the sub-
; string flag gets cleared as soon as the sub-string's CC_End is
; encountered.



; ******************************* Dialog *******************************

STR_DialogEng0000:
	.DB CC_Portrait, 3, CC_BoxBlue
	.DB "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.", CC_NewLine
	.DB "the quick brown fox jumps over the lazy dog.", CC_NewLine
	.DB "0123456789 ", Auml, Ouml, Uuml, auml, ouml, uuml, szlig, CC_ToggleBold, " Bold text", CC_ToggleBold, CC_NewLine
	.DB "!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~", SYM_heart, SYM_mult, CC_End

STR_DialogEng0001:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Whew, what a dream!", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "I was following the track of an elusive maned", CC_NewLine
	.DB CC_Indent, "snow leopard, and when I finally caught up", CC_NewLine
	.DB CC_Indent, "with him, he turned around and spoke to me ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "I can't remember what he said, only that it", CC_NewLine
	.DB CC_Indent, "totally affected me.", CC_End

STR_DialogEng0002:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Phew! I'm glad it was just a dream.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Why am I talking to myself, anyway?", CC_NewLine
	.DB CC_Indent, "I'd better get to work!", CC_End

STR_DialogEng0003:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "That's my house.", CC_End

STR_DialogEng0004:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "My fireplace.", CC_NewLine
	.DB CC_Indent, "Perhaps I should gather some more firewood", CC_NewLine
	.DB CC_Indent, "today ...", CC_End

STR_DialogEng0005:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Yummy stuff. ", SYM_heart, CC_End

STR_DialogEng0006:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What the ...?!", CC_End

STR_DialogEng0007:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "TIGER WOMAN:", CC_NewLine
	.DB CC_Indent, "Don't drop your guard, or ...", CC_End

STR_DialogEng0008:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oh, stop it already, Lily.", CC_End

STR_DialogEng0009:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry, Alec. I just couldn't resist. ", SYM_heart, CC_End

STR_DialogEng0010:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What do you want?", CC_End

STR_DialogEng0011:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't be so rude, you!", CC_NewLine
	.DB CC_Indent, "I've brought you some milk.", CC_End

STR_DialogEng0012:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What for?", CC_End

STR_DialogEng0013:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Stop asking silly questions and have a sip", CC_NewLine
	.DB CC_Indent, "already.", CC_End

STR_DialogEng0014:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well, okay. Just for you.", CC_End

STR_DialogEng0015:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Urgh ...", CC_End

STR_DialogEng0016:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Isn't it delicious?", CC_End

STR_DialogEng0017:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ummmmm ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Well, as you said, it's just milk.", CC_NewLine		; show 0018, skip 0019 thru 0021
	.DB CC_Selection, CC_Indent, "Yuck. What's next on the menu, parsnip stew?", CC_End	; skip 0018

STR_DialogEng0018:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "I knew you'd love it. ", SYM_heart, CC_End

STR_DialogEng0019:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry, Alec. I wasn't meaning to annoy you.", CC_End

STR_DialogEng0020:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Sorry ...", CC_End

STR_DialogEng0021:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't worry, it's okay. ", SYM_heart, CC_End

STR_DialogEng0022:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "But I'm sure you haven't just come here", CC_NewLine
	.DB CC_Indent, "to bring me some milk, have you?", CC_End

STR_DialogEng0023:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Actually, no.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxAlert
	.DB CC_Indent, "The fate of the world depends on you!", CC_End

STR_DialogEng0024:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tee hee, look at your face now ... ", SYM_heart, CC_End

STR_DialogEng0025:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "You had me there for a second ...", CC_End

STR_DialogEng0026:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "But wait 'til you hear this ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "The mayor offers a reward to anyfur who finds", CC_NewLine
	.DB CC_Indent, "out what's behind this \"ghost'' people have been", CC_NewLine
	.DB CC_Indent, "talking about lately. You remember the stories", CC_NewLine
	.DB CC_Indent, "I told you, don't you?", CC_End

STR_DialogEng0027:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Of course!", CC_NewLine			; skip 0029-0031
	.DB CC_Selection, CC_Indent, "No idea what you mean!", CC_NewLine	; skip 0028, 0032
	.DB CC_Selection, CC_Indent, "Give me a hint, please.", CC_End		; skip 0028-0030, 0032

STR_DialogEng0028:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Not just yours. The innkeeper, Tusker, claimed", CC_NewLine
	.DB CC_Indent, "that an armful of sausages were stolen from his", CC_NewLine
	.DB CC_Indent, "pantry just the other day.", CC_End

STR_DialogEng0029:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Where've you been, you dummy!", CC_End

STR_DialogEng0030:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Minding my own business, I guess.", CC_End

STR_DialogEng0031:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Fair enough. To cut a long story short, things have", CC_NewLine
	.DB CC_Indent, "been disappearing lately without any trace.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Sausages have vanished from unlocked pantries,", CC_NewLine
	.DB CC_Indent, "shoes and laundry went missing, even things like", CC_NewLine
	.DB CC_Indent, "carpenters' tools and fishing rods literally", CC_NewLine
	.DB CC_Indent, "evaporated when nofur was looking.", CC_ClearTextBox
; --------------------------------------------------------------------------------
@Jump01:
	.DB CC_Indent, "My Foxen neighbors' kid said he'd actually seen", CC_NewLine
	.DB CC_Indent, "the \"ghost,'' and presumed culprit, with his own eyes ...", CC_End

STR_DialogEng0032:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Right. But apart from Tusker's missing sausages,", CC_NewLine
	.DB CC_Indent, "even more weird stuff's been going on in the", CC_NewLine
	.DB CC_Indent, "village.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Jump
	.DW STR_DialogEng0031@Jump01

STR_DialogEng0033:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "With who else's eyes would he have seen it,", CC_NewLine
	.DB CC_Indent, "anyway?", CC_End

STR_DialogEng0034:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "That's exactly what I told my neighbors, too.", CC_NewLine
	.DB CC_Indent, "But they're scared to death by now.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Even Tusker, sensible though as he is, rather", CC_NewLine
	.DB CC_Indent, "chooses to believe in the supernatural. There's", CC_NewLine
	.DB CC_Indent, "just no way now to persuade anyfur to stick", CC_NewLine
	.DB CC_Indent, "with scientific evidence. So I thought ...", CC_End

STR_DialogEng0035:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... maybe you could use the help of some hunter?", CC_End

STR_DialogEng0036:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Not just any hunter, mind you. ", SYM_heart, CC_End

STR_DialogEng0037:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "So what's the mayor's reward?", CC_NewLine	; skip 0038, 0039
	.DB CC_Selection, CC_Indent, "I'd love to hunt some ghost!", CC_End		; continue

STR_DialogEng0038:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't you even want to hear what the mayor's", CC_NewLine
	.DB CC_Indent, "reward is?", CC_End

STR_DialogEng0039:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Huh? What's that?", CC_End

STR_DialogEng0040:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "A bunch of gold, lots of food, and eternal glory,", CC_NewLine
	.DB CC_Indent, "they say.", CC_End

STR_DialogEng0041:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Never mind the gold. Glory sounds fun though.", CC_NewLine
	.DB CC_Indent, "Too bad the prize doesn't include any firewood ...", CC_End

STR_DialogEng0042:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, but it does ... I completely forgot! There", CC_NewLine
	.DB CC_Indent, "will be firewood. Loads of it. That's the", CC_NewLine
	.DB CC_Indent, "main thing, actually!", CC_End

STR_DialogEng0043:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Let's go then, what are we waiting for?", CC_NewLine
	.DB CC_Indent, "I want to be home early tonight!", CC_End

STR_DialogEng0044:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sure enough. ", SYM_heart, CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxBlue
	.DB CC_Indent, "Listen, I know somefur who can help us.", CC_NewLine
	.DB CC_Indent, "Before we go see the mayor, we should talk", CC_NewLine
	.DB CC_Indent, "to him.", CC_End

STR_DialogEng0045:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_NewLine, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, "<1> joins the party!", CC_End

STR_DialogEng0046:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Here we are at last.", CC_NewLine
	.DB CC_Indent, "Oh dear ...", CC_End

STR_DialogEng0047:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What's the matter?", CC_End

STR_DialogEng0048:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "I completely forgot to tell my uncle that I'm", CC_NewLine
	.DB CC_Indent, "probably leaving for some time. Let's meet up", CC_NewLine
	.DB CC_Indent, "at Tusker's Inn in a bit, okay?", CC_End

STR_DialogEng0049:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I'll go with you, shall I?", CC_End

STR_DialogEng0050:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "That's so nice of you, Alec. ", SYM_heart, CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxBlue
	.DB CC_Indent, "... But remember my uncle's a bit demented. He", CC_NewLine
	.DB CC_Indent, "probably wouldn't want to be seen by a stranger", CC_NewLine
	.DB CC_Indent, "in his condition.", CC_End

STR_DialogEng0051:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Okay. See you then.", CC_End

STR_DialogEng0052:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_NewLine, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, "<1> leaves the party!", CC_End

STR_DialogEng0053:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FOREIGN WOLF:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_NewLine
	.DB CC_Indent, "Looking for trouble, are we?", CC_End

STR_DialogEng0054:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Don't call me \"Leonido!''", CC_End

STR_DialogEng0055:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FOREIGN WOLF:", CC_NewLine
	.DB CC_Indent, "Okay-o, Leonido ...", CC_End

STR_DialogEng0056:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_End

STR_DialogEng0057:
	.DB CC_Portrait, 2, CC_BoxAlert
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "What ARE you two doing?!", CC_End

STR_DialogEng0058:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Argh ... MALES!", CC_NewLine
	.DB CC_Indent, "Either they're fighting, or ...", CC_End

STR_DialogEng0059:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Or what?", CC_End

STR_DialogEng0060:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FOREIGN WOLF:", CC_NewLine
	.DB CC_Indent, "I'm a soldier. I fight.", CC_End

STR_DialogEng0061:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "But he's the guy I told you could help you", CC_NewLine
	.DB CC_Indent, "with your job!", CC_End

STR_DialogEng0062:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "Aha, so you're Alec Marlowe, the hunter?", CC_NewLine
	.DB CC_Indent, "Then I apologize. Pleased to meet you.", CC_End

STR_DialogEng0063:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What was that all about?", CC_End

STR_DialogEng0064:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Know what?", CC_NewLine
	.DB CC_Indent, "Ask for a name before cursing at", CC_NewLine
	.DB CC_Indent, "random people, next time!", CC_End

STR_DialogEng0065:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "You call that cursing, \"Leonido?''", CC_End

STR_DialogEng0066:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Stop it, or I'll kick your Wolfen ...", CC_End

STR_DialogEng0067:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Relax, Alec! He was just quoting himself!", CC_End

STR_DialogEng0068:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "She's right, \"Leonido.'' In quotes, mind you ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "By the way, I've been \"cursed'' at many times", CC_NewLine
	.DB CC_Indent, "before, myself, albeit for other reasons.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "To be perfectly honest, I stopped bothering", CC_NewLine
	.DB CC_Indent, "back when I was a puppy ...", CC_End

STR_DialogEng0069:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "You're a jerk.", CC_End

STR_DialogEng0070:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "No, I'm Primus Greyfur, at your service.", CC_End

STR_DialogEng0071:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "He's a soldier from the Furderal Empire, Alec!", CC_End

STR_DialogEng0072:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "So ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Why did you end up here in Librefur?", CC_NewLine		; skip 0073
	.DB CC_Selection, CC_Indent, "You're a deserter then?", CC_End				; continue

STR_DialogEng0073:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "I'm as much of a deserter as you are a poacher,", CC_NewLine
	.DB CC_Indent, "Leonido.", CC_End

STR_DialogEng0074:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Grown tired of dull barracks and drunken", CC_NewLine
	.DB CC_Indent, "generals, I've gone freelance as of late.", CC_NewLine
	.DB CC_Indent, "In other words, I offer my services for money.", CC_End

STR_DialogEng0075:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Sounds like a hard way to make a living ...", CC_End

STR_DialogEng0076:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Admittedly, it's hard from time to time.", CC_NewLine
	.DB CC_Indent, "But not today ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Now, if you'll excuse me? I have an appointment", CC_NewLine
	.DB CC_Indent, "at the mayor's. Unless you really mean it, and", CC_NewLine
	.DB CC_Indent, "want to join me hunting down some alleged ghost.", CC_End

STR_DialogEng0077:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Huh? Wait a minute ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Lily!", CC_NewLine
	.DB CC_Indent, "That was MY job, right there!", CC_End

STR_DialogEng0078:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "But your job plus his job equals our job,", CC_NewLine
	.DB CC_Indent, "doesn't it?", CC_NewLine
	.DB CC_Indent, "So ... let's finally get going!", CC_End

STR_DialogEng0079:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "YOUNG WOLFEN:", CC_NewLine
	.DB CC_Indent, "La ~ di ~ da ~", CC_NewLine
	.DB CC_Indent, "I think that grey-furred soldier likes me. ", SYM_heart, CC_End

STR_DialogEng0080:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Welcome to your briefing, Primus Greyfur.", CC_End

STR_DialogEng0081:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Thank you, mayor. These two are with me.", CC_End

STR_DialogEng0082:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Miss Lilac Pondicherry ... I am enchanted.", CC_End

STR_DialogEng0083:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, CC_Selection, "Really?", CC_NewLine		; no change in dialogue, only affect sympathy levels
	.DB CC_Indent, CC_Selection, "What about me?", CC_End		; ditto

STR_DialogEng0084:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "And Alexis Moreflaw, long time no see ... Sir Greyfur,", CC_NewLine
	.DB CC_Indent, "I may point out that every furmunity has a buffoon", CC_NewLine
	.DB CC_Indent, "of its own, and our village is no exception.", CC_End

STR_DialogEng0085:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "My name's still ALEC MARLOWE, though!", CC_NewLine
	.DB CC_Indent, "And what the heck's a \"bassoon?!''", CC_End

STR_DialogEng0086:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Shhh ... Take it easy, Alec.", CC_End

STR_DialogEng0087:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "In the name of all inhabitants of Furlorn village,", CC_NewLine
	.DB CC_Indent, "thank you for providing us your assistance, Sir", CC_NewLine
	.DB CC_Indent, "Greyfur.", CC_End

STR_DialogEng0088:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Just Primus, if you will.", CC_End

STR_DialogEng0089:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Yes, of course ... Sir Greyfur, as you are probably", CC_NewLine
	.DB CC_Indent, "aware, eternal glory awaits he who rids us", CC_NewLine
	.DB CC_Indent, "of that dreadful threat ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "... a threat which has haunted our village", CC_NewLine
	.DB CC_Indent, "ever since you showed up here.", CC_End

STR_DialogEng0090:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Yeah, I ... wait, what? Just glory? No gold?", CC_End

STR_DialogEng0091:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Don't worry, you will of course be rewarded", CC_NewLine
	.DB CC_Indent, "timely, and decently. You have my word.", CC_End

STR_DialogEng0092:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Understood.", CC_End

STR_DialogEng0093:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "That's settled, then.", CC_ClearTextBox
; --------------------------------------------------------------------------------
@Jump01:
	.DB CC_Indent, "Be sure to talk to all the villagers, as somefur", CC_NewLine
	.DB CC_Indent, "among us is bound to give you a hint on where to", CC_NewLine
	.DB CC_Indent, "start your quest. Godspeed!", CC_End

STR_DialogEng0094:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Jump
	.DW STR_DialogEng0093@Jump01

STR_DialogEng0095:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "So there goes my extra stack of firewood down", CC_NewLine
	.DB CC_Indent, "the drain. Lily, you and I need to talk.", CC_End

STR_DialogEng0096:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't forget the gold though. With it, you can", CC_NewLine
	.DB CC_Indent, "buy as much firewood as you want, can't you?", CC_End

STR_DialogEng0097:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oh. Right ...", CC_NewLine
	.DB CC_Indent, "But why the charade?", CC_End

STR_DialogEng0098:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry, Alec ... You said you wanted to be home early", CC_NewLine
	.DB CC_Indent, "tonight. I was afraid that might not happen.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "But I know you, don't I? I knew you'd be glad", CC_NewLine
	.DB CC_Indent, "that I gave you a little nudge out of your", CC_NewLine
	.DB CC_Indent, "door, and ...", CC_End

STR_DialogEng0099:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sorry to interrupt, but are you two relatives?", CC_End

STR_DialogEng0100:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "No, we're lovers, of course.", CC_NewLine			; no change in dialogue, only affect sympathy levels
	.DB CC_Selection, CC_Indent, "She once taught me how to read and write ...", CC_End	; ditto

STR_DialogEng0101:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Alright ...", CC_End

STR_DialogEng0102:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "So the mayor told us to talk to the villagers.", CC_NewLine
	.DB CC_Indent, "Let's go!", CC_End

STR_DialogEng0103:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GORILLA 1:", CC_NewLine
	.DB CC_Indent, "G'day, mate.", CC_NewLine
	.DB CC_Indent, "Very pleased ter meetcha, me is ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxEvil
	.DB CC_Indent, "... 'cuz me main hobby is turning lions into", CC_NewLine
	.DB CC_Indent, "sausage!", CC_NewLine
	.DB CC_Indent, "Oh, me name's Joe. Joe Lion-Trapper ...", CC_End

STR_DialogEng0104:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "GORILLA 2:", CC_NewLine
	.DB CC_Indent, "Hello there, hunky mane-bearer. ", SYM_heart, CC_NewLine
	.DB CC_Indent, "Your muscled appearance, coated in velvety", CC_NewLine
	.DB CC_Indent, "golden fur, is indeed a feast for the eyes ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxEvil
	.DB CC_Indent, "... as it'll be for my fangs. Too bad you can't live", CC_NewLine
	.DB CC_Indent, "to witness our appreciation of your tasty flesh!", CC_NewLine
	.DB CC_Indent, "By the way, they call me Jim. Jim Lion-Slayer ...", CC_End

STR_DialogEng0105:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GORILLA 3:", CC_NewLine
	.DB CC_Indent, "Greetings, splendid Leoniden fellow.", CC_NewLine
	.DB CC_Indent, "Never mind either of my brothers' uncouth", CC_NewLine
	.DB CC_Indent, "talk ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxEvil
	.DB CC_Indent, "Just rest assured that it will be an honor,", CC_NewLine
	.DB CC_Indent, "and a privilege, to take your precious hide.", CC_NewLine
	.DB CC_Indent, "For I am known as Jack. Jack Lion-Flayer ...", CC_End

STR_DialogEng0106:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Know what, you apes?", CC_NewLine
	.DB CC_Indent, "I won't be flayed by any Tom, Dick or Harry!", CC_End

STR_DialogEng0107:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Well, I stand corrected.", CC_NewLine
	.DB CC_Indent, "I hadn't the faintest idea wild boar roast", CC_NewLine
	.DB CC_Indent, "was THAT delicious.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxPink
	.DB CC_Indent, "Thanks, Alec! ", SYM_heart, CC_End

STR_DialogEng0108:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "This tastes good indeed ...", CC_NewLine
	.DB CC_Indent, "*sniffle*", CC_NewLine
	.DB CC_Indent, "... but it certainly isn't wild boar roast.", CC_End

STR_DialogEng0109:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Yum! ", SYM_heart, CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "I never knew the taste of fresh primate liver", CC_NewLine
	.DB CC_Indent, "actually resembled salted pork ...!", CC_End

STR_DialogEng0110:
	.DB CC_Portrait, 2, CC_BoxAlert
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wh...what?", CC_NewLine
	.DB CC_Indent, "You mean what I'm eating is ... the remains of ...", CC_End

STR_DialogEng0111:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... three quarrelsome gorillas?", CC_NewLine
	.DB CC_Indent, "Hehe ... Who knows?!", CC_End

STR_DialogEng0112:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Alec, you ... you ... *sob*", CC_End

STR_DialogEng0113:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Tell her the truth, will you?", CC_End

STR_DialogEng0114:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What, that we were actually just having", CC_NewLine
	.DB CC_Indent, "venison ragout?", CC_End

STR_DialogEng0115:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "No, Leonido.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Tell her you are not in love with her.", CC_End

STR_DialogEng0116:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "That's none of your business.", CC_End

STR_DialogEng0117:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Well, I'm going to sleep.", CC_End

STR_DialogEng0118:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well, what are you waiting for?", CC_End

STR_DialogEng0119:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Now that he's gone ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "(I'll sneak up on him, and tickle him all night long! ", SYM_heart, ")", CC_NewLine	; skip 0120-0129
	.DB CC_Selection, CC_Indent, "(I'd better make it up to Lily for being a meanie.)", CC_End			; continue (don't skip later Primus cut scene)

STR_DialogEng0120:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "There she is ...", CC_End

STR_DialogEng0121:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Listen, uhm ... I was just joking.", CC_End

STR_DialogEng0122:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Yes, I know.", CC_End

STR_DialogEng0123:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What?", CC_End

STR_DialogEng0124:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "We've known each other ever since we were", CC_NewLine
	.DB CC_Indent, "little cubs. In all these years, you've", CC_NewLine
	.DB CC_Indent, "never once embarrassed me ...", CC_End

STR_DialogEng0125:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I ... really?", CC_End

STR_DialogEng0126:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "No kidding.", CC_End

STR_DialogEng0127:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well, I'd better try and keep it that way, then.", CC_End

STR_DialogEng0128:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Could you ... I mean, would you like to make us", CC_NewLine
	.DB CC_Indent, "your favorite dish tomorrow?", CC_NewLine
	.DB CC_Indent, "I mean ... please?", CC_End

STR_DialogEng0129:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, Alec ... You are so sweet. ", SYM_heart, CC_End

STR_DialogEng0130:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "There you are.", CC_End

STR_DialogEng0131:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "How did you ...?", CC_End

STR_DialogEng0132:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Heh. You're not the only one around with a", CC_NewLine
	.DB CC_Indent, "good sense of smell.", CC_End

STR_DialogEng0133:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nice spot you picked for the night.", CC_NewLine
	.DB CC_Indent, "Mind if I join you?", CC_End

STR_DialogEng0134:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "I do mind in case you snore.", CC_End

STR_DialogEng0135:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Don't worry, mate.", CC_End

STR_DialogEng0136:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well ...", CC_End

STR_DialogEng0137:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "What is it?", CC_End

STR_DialogEng0138:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Good night, Primus. Sleep well.", CC_NewLine			; skip 0139
	.DB CC_Selection, CC_Indent, "Look how your ears shimmer in the moonlight ...", CC_End		; skip 0140

STR_DialogEng0139:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Good night, Leonido.", CC_End

STR_DialogEng0140:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "You too, Alec.", CC_End

STR_DialogEng0141:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "*Yaaaawn*", CC_End

STR_DialogEng0142:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Huh?! What's this?", CC_End

STR_DialogEng0143:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Parsnip stew. Lily just loves it.", CC_NewLine
	.DB CC_Indent, "Let's spoon it up already.", CC_End

STR_DialogEng0144:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "*mumble* *thistasteslikefoxenpiss* *mumble*", CC_End

STR_DialogEng0145:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Shush, you!", CC_End

STR_DialogEng0146:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Uh-oh ...", CC_NewLine
	.DB CC_Indent, "Looks like we're stuck here for now.", CC_End

STR_DialogEng0147:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Don't worry. I lift this up, and we'll be", CC_NewLine
	.DB CC_Indent, "outta here in no time.", CC_End

STR_DialogEng0148:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wait!", CC_End

STR_DialogEng0149:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What's the matter?", CC_End

STR_DialogEng0150:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "We might as well check out the place,", CC_NewLine
	.DB CC_Indent, "don't you think?", CC_End

STR_DialogEng0151:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "She's right, Leonido.", CC_NewLine
	.DB CC_Indent, "I smell something fishy going on here ...", CC_End

STR_DialogEng0152:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogEng0153:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well? What do we do?", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Be on the run!)", CC_NewLine	; no change in dialogue // FIXME, this choice doesn't really make sense
	.DB CC_Selection, CC_Indent, "(Stay and explore)", CC_End

STR_DialogEng0154:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "No one's been around for ages.", CC_End

STR_DialogEng0155:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "It's a fennec puppet.", CC_NewLine
	.DB CC_Indent, "Its eyes are missing.", CC_End

STR_DialogEng0156:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "What a creepy place.", CC_NewLine
	.DB CC_Indent, "I begin to feel like we shouldn't have come here", CC_NewLine
	.DB CC_Indent, "after all ...", CC_End

STR_DialogEng0157:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FENNEC PUPPET:", CC_NewLine
	.DB CC_Indent, "I can't see you ...", CC_NewLine
	.DB CC_Indent, "... but I can hear your heart throbbing!", CC_End

STR_DialogEng0158:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Look out! More enemies approaching!", CC_End

STR_DialogEng0159:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MELODIC VOICE:", CC_NewLine
	.DB CC_Indent, "I mean no harm ...", CC_End

STR_DialogEng0160:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "UNKNOWN FOX:", CC_NewLine
	.DB CC_Indent, "You fought very well.", CC_NewLine
	.DB CC_Indent, "Who are you?", CC_End

STR_DialogEng0161:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "I'm Alec, and these are my friends.", CC_NewLine		; skip 0163, 0164, 0166
	.DB CC_Selection, CC_Indent, "I should ask you the same thing, Redcoat!", CC_NewLine	; skip 0163-0165
	.DB CC_Selection, CC_Indent, "(Have Lily reply instead)", CC_End			; skip 0165, 0166, 0168

STR_DialogEng0162:
	.DB CC_Portrait, 2, CC_BoxAlert
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Why did you attack us?", CC_End

STR_DialogEng0163:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "UNKNOWN FOX:", CC_NewLine
@Jump01:
	.DB CC_Indent, "I wasn't going to hurt you, and neither was", CC_NewLine
	.DB CC_Indent, "Dorothy.", CC_End

STR_DialogEng0164:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "UNKNOWN FOX:", CC_NewLine
	.DB CC_Indent, "Welcome to my burrow, Alec.", CC_End

STR_DialogEng0165:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "UNKNOWN FOX:", CC_NewLine
	.DB CC_Indent, "I am deeply sorry for being so rude in the", CC_NewLine
	.DB CC_Indent, "first place.", CC_End

STR_DialogEng0166:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "UNKNOWN FOX:", CC_NewLine
	.DB CC_Indent, "My name is Reinhold von Pappenheim.", CC_NewLine
	.DB CC_Indent, "I'm a professional ventriloquist.", CC_NewLine
	.DB CC_Indent, "I apologize for scaring youfurs ...", CC_End

STR_DialogEng0167:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "REINHOLD:", CC_NewLine
	.DB CC_Jump
	.DW STR_DialogEng0163@Jump01

STR_DialogEng0168:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "You ever been to Furlorn village, by any chance?", CC_End

STR_DialogEng0169:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "He definitely has. Don't you smell those smoked", CC_NewLine
	.DB CC_Indent, "summer sausages Tusker said had gone missing?", CC_End

STR_DialogEng0170:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "REINHOLD:", CC_NewLine
	.DB CC_Indent, "I confess to snatching food from nearby villages.", CC_NewLine
	.DB CC_Indent, "There is nothing to eat out here in the wild.", CC_End

STR_DialogEng0171:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "So there we have our \"ghost.''", CC_End

STR_DialogEng0172:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nothing to eat, you say? But the forests around", CC_NewLine
	.DB CC_Indent, "these parts are full of prey!", CC_End

STR_DialogEng0173:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "DOROTHY:", CC_NewLine
	.DB CC_Indent, "He's not a hunter, you see. Nor a gatherer. He's", CC_NewLine
	.DB CC_Indent, "just a con artist. A trickster, if you will. Without", CC_NewLine
	.DB CC_Indent, "stealing, he'd have starved to death before long.", CC_End

STR_DialogEng0174:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Whoa! How can this thing talk, anyway?!", CC_End

STR_DialogEng0175:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't let him fool you. A ventriloquist is able", CC_NewLine
	.DB CC_Indent, "to speak without moving his lips.", CC_End

STR_DialogEng0176:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "DOROTHY:", CC_NewLine
	.DB CC_Indent, "Exactly. ", SYM_heart, CC_End

STR_DialogEng0177:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, CC_Selection, "Crazy claws!", CC_NewLine
	.DB CC_Indent, CC_Selection, "That's ... creepy.", CC_End

STR_DialogEng0178:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Guys, I don't get it. With a stunt like this, he", CC_NewLine
	.DB CC_Indent, "could make a fortune as a street performer in", CC_NewLine
	.DB CC_Indent, "any big city.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "But instead, you're living out here, in secret.", CC_NewLine
	.DB CC_Indent, "It strikes me as though you were hiding from", CC_NewLine
	.DB CC_Indent, "something.", CC_End

STR_DialogEng0179:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Stop, you little bastard! Now!", CC_End

STR_DialogEng0180:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FOXLING:", CC_NewLine
	.DB CC_Indent, "Yikes! I'm stuck!!", CC_End

STR_DialogEng0181:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Gotcha!", CC_End

STR_DialogEng0182:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "So once again, WHERE IS MY FOOD?", CC_End

STR_DialogEng0183:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FOXLING:", CC_NewLine
	.DB CC_Indent, "Really, I dunno!", CC_End

STR_DialogEng0184:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "You whatta?!", CC_NewLine
	.DB CC_Indent, "Listen, if you don't tell me RIGHT NOW, I'm gonna", CC_NewLine
	.DB CC_Indent, "make a knot in your tail! Got it?", CC_End

STR_DialogEng0185:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "FOXLING:", CC_NewLine
	.DB CC_Indent, "Heeeelp!!", CC_NewLine
	.DB CC_Indent, "*squeal*", CC_End

STR_DialogEng0186:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "We should help the little one!", CC_End

STR_DialogEng0187:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Right on!", CC_End

STR_DialogEng0188:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Huh?", CC_NewLine
	.DB CC_Indent, "Who the jackal's mange are youfurs?", CC_End

STR_DialogEng0189:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "*Huff, puff*", CC_NewLine
	.DB CC_Indent, "Idiots! It's your fault that little thief got away.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "I should've lambasted him while I had a chance!", CC_End

STR_DialogEng0190:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Wait ... Did he steal something from you?", CC_End

STR_DialogEng0191:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Dammit, yes! Eatables! EGGS!!", CC_End

STR_DialogEng0192:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oi ... That doesn't sound good.", CC_End

STR_DialogEng0193:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry for the misunderstanding. We thought ...", CC_End

STR_DialogEng0194:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "I don't care what you think!", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxBlue
	.DB CC_Indent, "My eggs are gone, that's what counts!", CC_NewLine
	.DB CC_Indent, "Those were pheasant eggs, by the way.", CC_NewLine
	.DB CC_Indent, "Very nutritious. And now they're GONE FOR GOOD!", CC_End

STR_DialogEng0195:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I'm a hunter. I know where to find pheasant nests.", CC_NewLine
	.DB CC_Indent, "I could help you get a fresh replacement.", CC_End

STR_DialogEng0196:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Really?", CC_End

STR_DialogEng0197:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Yeah.", CC_End

STR_DialogEng0198:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Why would you do this for me?", CC_End

STR_DialogEng0199:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "We owe you, after all.", CC_NewLine					; skip 0201, 0203
	.DB CC_Selection, CC_Indent, "I'm gonna have you slurp up some wicked stuff. ", SYM_heart, CC_NewLine	; skip 0201, 0202
	.DB CC_Selection, CC_Indent, "(Have Lily reply instead)", CC_End					; skip 0203

STR_DialogEng0200:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Alec's right. After all, we feel obliged to", CC_NewLine
	.DB CC_Indent, "compensate for your loss.", CC_End

STR_DialogEng0201:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "Right. Let's go then.", CC_End

STR_DialogEng0202:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "You bet I will. ", SYM_heart, CC_NewLine
	.DB CC_Indent, "Awright, let's go.", CC_End

STR_DialogEng0203:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What's your name, by the way?", CC_End

STR_DialogEng0204:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSCLY PARDEN:", CC_NewLine
	.DB CC_Indent, "...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Call me Mickey.", CC_End

STR_DialogEng0205:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "I'm Alec, and these are my friends.", CC_NewLine		; only affect sympathy levels
	.DB CC_Selection, CC_Indent, "Call me Leonido. ", SYM_heart, CC_End

STR_DialogEng0206:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "BROWN BEAR:", CC_NewLine
	.DB CC_Indent, "Allow me the honor. Ahem ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "My name is Gregory Perpetuus Ebenezer Hrabanus", CC_NewLine
	.DB CC_Indent, "Eindhoven Dubois Quaoar van der Muhlhausen", CC_NewLine
	.DB CC_Indent, "Nido sulle Colline ... junior.", CC_End

STR_DialogEng0207:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "TARA:", CC_NewLine
	.DB CC_Indent, "Don't you lay your paw on me!", CC_End

/*
STR_DialogEng0208:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_End
*/



; ******************************** EOF *********************************
