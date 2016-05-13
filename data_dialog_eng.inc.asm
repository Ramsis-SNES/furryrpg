;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** DIALOG STRINGS (ENGLISH) ***
;
;==========================================================================================



; ****************************** Defines *******************************

	.DEFINE Auml		$80		; Ä
	.DEFINE Ouml		$81		; Ö
	.DEFINE Uuml		$82		; Ü
	.DEFINE auml		$83		; ä
	.DEFINE ouml		$84		; ö
	.DEFINE uuml		$85		; ü
	.DEFINE szlig		$86		; ß
	.DEFINE SYM_heart	$87, $88	; heart symbol
	.DEFINE SYM_quot	$89		; quotation mark
	.DEFINE SYM_mult	$8A		; multiplication sign



; ******************************* Dialog *******************************

; For TextPad (with "Regular expression" checked):
; Search for  : STR_DialogEng....
; Replace with: STR_DialogEng\i{0,1,4,0}

STR_DiagTestEng:
	.DB CC_BoxBlue
	.DB "DIALOG TEST", CC_NewLine
	.DB "Dpad r/l: next/previous string (hold Y for speed)", CC_NewLine
	.DB "R/L: +/-50 strings", CC_NewLine
	.DB "A: close text box | B: escape selections", CC_End

;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB"
;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB"
;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB"
;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB", CC_End	; 46 chars * 8 = 368 px

STR_DialogEng0000:
	.DB CC_BoxBlue
	.DB "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.", CC_NewLine
	.DB "the quick brown fox jumps over the lazy dog.", CC_NewLine
	.DB "0123456789 ", Auml, Ouml, Uuml, auml, ouml, uuml, szlig, CC_NewLine
	.DB "!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~", SYM_heart, SYM_quot, SYM_mult, CC_End

STR_DialogEng0001:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Whew, what a dream!", CC_ClearTextBox

STR_DialogEng0002:
;	.DB CC_BoxBlue
;	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I was following the track of an elusive maned", CC_NewLine
	.DB CC_Indent, "snow leopard, and when I finally caught up", CC_NewLine
	.DB CC_Indent, "with him, he turned around and spoke to me ...", CC_ClearTextBox

STR_DialogEng0003:
;	.DB CC_BoxBlue
;	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I can't remember what he said, only that it", CC_NewLine
	.DB CC_Indent, "totally affected me.", CC_End

STR_DialogEng0004:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Phew! I'm glad it was just a dream.", CC_ClearTextBox

STR_DialogEng0005:
;	.DB CC_BoxBlue
;	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Why am I talking to myself, anyway?", CC_NewLine
	.DB CC_Indent, "I'd better get to work!", CC_End

STR_DialogEng0006:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "That's my house.", CC_End

STR_DialogEng0007:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "My fireplace.", CC_NewLine
	.DB CC_Indent, "Perhaps I should gather some more firewood", CC_NewLine
	.DB CC_Indent, "today ...", CC_End

STR_DialogEng0008:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Yummy stuff. ", SYM_heart, CC_End

STR_DialogEng0009:
	.DB CC_BoxPissed
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What the ...?!", CC_End

STR_DialogEng0010:
	.DB CC_BoxRed
	.DB "TIGER WOMAN:", CC_NewLine
	.DB CC_Indent, "Don't drop your guard, or ...", CC_End

STR_DialogEng0011:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oh, stop it already, Lily.", CC_End

STR_DialogEng0012:
	.DB CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry, Alec. I just couldn't resist. ", SYM_heart, CC_End

STR_DialogEng0013:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What do you want?", CC_End

STR_DialogEng0014:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't be so rude, you!", CC_NewLine
	.DB CC_Indent, "I've brought you some milk.", CC_End

STR_DialogEng0015:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What for?", CC_End

STR_DialogEng0016:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Stop asking silly questions and have a sip", CC_NewLine
	.DB CC_Indent, "already.", CC_End

STR_DialogEng0017:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well, okay. Just for you.", CC_End

STR_DialogEng0018:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Urgh ...", CC_End

STR_DialogEng0019:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Isn't it delicious?", CC_End

STR_DialogEng0020:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ummmmm ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Well, as you said, it's just milk.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Yuck. What's next on the menu, parsnip stew?", CC_End

STR_DialogEng0021:
	.DB CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "I knew you'd love it. ", SYM_heart, CC_End

STR_DialogEng0022:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry, Alec. I wasn't meaning to annoy you.", CC_End

STR_DialogEng0023:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Sorry ...", CC_End

STR_DialogEng0024:
	.DB CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't worry, it's okay. ", SYM_heart, CC_End

STR_DialogEng0025:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "But I'm sure you haven't just come here", CC_NewLine
	.DB CC_Indent, "to bring me some milk, have you?", CC_End

STR_DialogEng0026:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Actually, no.", CC_End

STR_DialogEng0027:
	.DB CC_BoxPissed
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "The fate of the world depends on you!", CC_End

STR_DialogEng0028:
	.DB CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tee hee, look at your face now ... ", SYM_heart, CC_End

STR_DialogEng0029:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "You had me there for a second ...", CC_End

STR_DialogEng0030:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "But wait 'til you hear this ...", CC_End
;	.DB " ", CC_NewLine
;	.DB CC_Indent, "", CC_End

STR_DialogEng0031:
	.DB CC_BoxRed
	.DB "STRANGE WOLF:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_NewLine
	.DB CC_Indent, "Looking for trouble, are we?", CC_End

STR_DialogEng0032:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Don't call me ", SYM_quot, "Leonido!\"", CC_End

STR_DialogEng0033:
	.DB CC_BoxRed
	.DB "STRANGE WOLF:", CC_NewLine
	.DB CC_Indent, "Okay-o, Leonido ...", CC_End

STR_DialogEng0034:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_End

STR_DialogEng0035:
	.DB CC_BoxPissed
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "What ARE you two doing?!", CC_End

STR_DialogEng0036:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Argh ... MALES!", CC_NewLine
	.DB CC_Indent, "Either they're fighting, or ...", CC_End

STR_DialogEng0037:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Or what?", CC_End

STR_DialogEng0038:
	.DB CC_BoxBlue
	.DB "STRANGE WOLF:", CC_NewLine
	.DB CC_Indent, "I'm a soldier. I fight.", CC_End

STR_DialogEng0039:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "But he's the guy I told you could help you", CC_NewLine
	.DB CC_Indent, "with your job!", CC_End

STR_DialogEng0040:
	.DB CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "Aha, so you're Alec Marlowe, the hunter?", CC_NewLine
	.DB CC_Indent, "Then I apologize. Pleased to meet you.", CC_End

STR_DialogEng0041:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What was that all about?", CC_End

STR_DialogEng0042:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Know what?", CC_NewLine
	.DB CC_Indent, "Ask for a name before cursing at", CC_NewLine
	.DB CC_Indent, "random people, next time!", CC_End

STR_DialogEng0043:
	.DB CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "You call that cursing, ", SYM_quot, "Leonido?\"", CC_End

STR_DialogEng0044:
	.DB CC_BoxPissed
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Stop it, or I'll kick your Wolfen ...", CC_End

STR_DialogEng0045:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Relax, Alec! He was just quoting himself!", CC_End

STR_DialogEng0046:
	.DB CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "She's right, ", SYM_quot, "Leonido.\" In quotes, mind you ...", CC_End

STR_DialogEng0047:
	.DB CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "By the way, I've been ", SYM_quot, "cursed\" at many times", CC_NewLine
	.DB CC_Indent, "before, myself, albeit for other reasons.", CC_ClearTextBox

STR_DialogEng0048:
;	.DB CC_BoxBlue
;	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "To be perfectly honest, I stopped bothering", CC_NewLine
	.DB CC_Indent, "back when I was a puppy ...", CC_End

STR_DialogEng0049:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "You're a jerk.", CC_End

STR_DialogEng0050:
	.DB CC_BoxBlue
	.DB "WOLFEN SOLDIER:", CC_NewLine
	.DB CC_Indent, "No, I'm Primus Greyfur, at your service.", CC_End

STR_DialogEng0051:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "He's a soldier from the Furderal Empire, Alec!", CC_End

STR_DialogEng0052:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "So ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Why did you end up here in Librefur?", CC_NewLine
	.DB CC_Selection, CC_Indent, "You're a deserter then?", CC_End

STR_DialogEng0053:
	.DB CC_BoxPissed
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "I'm as much of a deserter as you are a poacher,", CC_NewLine
	.DB CC_Indent, "Leonido.", CC_End

STR_DialogEng0054:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Grown tired of dull barracks and drunken", CC_NewLine
	.DB CC_Indent, "generals, I've gone freelance as of late.", CC_NewLine
	.DB CC_Indent, "In other words, I offer my services for money.", CC_End

STR_DialogEng0055:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Sounds like a hard way to make a living ...", CC_End

STR_DialogEng0056:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Admittedly, it's hard from time to time.", CC_NewLine
	.DB CC_Indent, "But not today ...", CC_End

STR_DialogEng0057:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Okay ... Shall we get going?", CC_End

STR_DialogEng0058:
	.DB CC_BoxPink
	.DB "YOUNG WOLFEN:", CC_NewLine
	.DB CC_Indent, "La ~ di ~ da ~", CC_NewLine
	.DB CC_Indent, "I think that grey-furred soldier likes me. ", SYM_heart, CC_End

STR_DialogEng0059:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Uh-oh ...", CC_NewLine
	.DB CC_Indent, "Looks like we're stuck here for now.", CC_End

STR_DialogEng0060:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Don't worry. I lift this up, and we'll be", CC_NewLine
	.DB CC_Indent, "outta here in no time.", CC_End

STR_DialogEng0061:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wait!", CC_End

STR_DialogEng0062:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What's the matter?", CC_End

STR_DialogEng0063:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "We might as well check out the place,", CC_NewLine
	.DB CC_Indent, "don't you think?", CC_End

STR_DialogEng0064:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "She's right, Leonido.", CC_NewLine
	.DB CC_Indent, "I smell something fishy going on here ...", CC_End

STR_DialogEng0065:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogEng0066:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well? What do we do?", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Be on the run!)", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Stay and explore)", CC_End

STR_DialogEng0067:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "No one's been around for ages.", CC_End

STR_DialogEng0068:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "It's a fennec puppet.", CC_NewLine
	.DB CC_Indent, "Its eyes are missing.", CC_End

STR_DialogEng0069:
	.DB CC_BoxRed
	.DB "FENNEC PUPPET:", CC_NewLine
	.DB CC_Indent, "I can't see you ...", CC_NewLine
	.DB CC_Indent, "... but I can hear your heart throbbing!", CC_End

STR_DialogEng0070:
	.DB CC_BoxBlue
	.DB "FOXLING:", CC_NewLine
	.DB CC_Indent, "Yikes! I'm stuck!!", CC_End

STR_DialogEng0071:
	.DB CC_BoxBlue
	.DB "MICKEY:", CC_NewLine
	.DB CC_Indent, "You whatta?!", CC_NewLine
	.DB CC_Indent, "Listen, if you don't tell us RIGHT NOW, I'm gonna", CC_NewLine
	.DB CC_Indent, "make a knot in your tail! Got it?", CC_End

STR_DialogEng0072:
	.DB CC_BoxBlue
	.DB "BROWN BEAR:", CC_NewLine
	.DB CC_Indent, "Allow me the honor. Ahem ...", CC_ClearTextBox
	
STR_DialogEng0073:
;	.DB CC_BoxBlue
;	.DB "BROWN BEAR:", CC_NewLine
	.DB CC_Indent, "My name is Gregory Perpetuus Ebenezer Hrabanus", CC_NewLine
	.DB CC_Indent, "Eindhoven Dubois Quaoar van der Muhlhausen", CC_NewLine
	.DB CC_Indent, "Nido sulle Colline ... junior.", CC_End

STR_DialogEng0074:
	.DB CC_BoxBlue
	.DB "GORILLA 1:", CC_NewLine
	.DB CC_Indent, "G'day, mate.", CC_NewLine
	.DB CC_Indent, "Very pleased ter meetcha, me is ...", CC_ClearTextBox

STR_DialogEng0075:
	.DB CC_BoxEvil
;	.DB "GORILLA 1:", CC_NewLine
	.DB CC_Indent, "... 'cuz me main hobby is turning lions into", CC_NewLine
	.DB CC_Indent, "sausage!", CC_NewLine
	.DB CC_Indent, "Oh, me name's Joe. Joe Lion-Trapper ...", CC_End

STR_DialogEng0076:
	.DB CC_BoxPink
	.DB "GORILLA 2:", CC_NewLine
	.DB CC_Indent, "Hello there, hunky mane-bearer. ", SYM_heart, CC_NewLine
	.DB CC_Indent, "Your muscled appearance, coated in velvety", CC_NewLine
	.DB CC_Indent, "golden fur, is indeed a feast for the eyes ...", CC_ClearTextBox

STR_DialogEng0077:
	.DB CC_BoxEvil
;	.DB "GORILLA 2:", CC_NewLine
	.DB CC_Indent, "... as it'll be for my fangs. Too bad you can't live", CC_NewLine
	.DB CC_Indent, "to witness our appreciation of your tasty flesh!", CC_NewLine
	.DB CC_Indent, "By the way, they call me Jim. Jim Lion-Slayer ...", CC_End

STR_DialogEng0078:
	.DB CC_BoxBlue
	.DB "GORILLA 3:", CC_NewLine
	.DB CC_Indent, "Greetings, young Leonido.", CC_NewLine
	.DB CC_Indent, "Never mind either of my brothers' uncouth", CC_NewLine
	.DB CC_Indent, "talk ...", CC_ClearTextBox

STR_DialogEng0079:
	.DB CC_BoxEvil
;	.DB "GORILLA 3:", CC_NewLine
	.DB CC_Indent, "Just rest assured that it will be an honor,", CC_NewLine
	.DB CC_Indent, "and a privilege, to take your precious hide.", CC_NewLine
	.DB CC_Indent, "For I am known as Jack. Jack Lion-Flayer ...", CC_End

STR_DialogEng0080:
	.DB CC_BoxPissed
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Know what, you apes?", CC_NewLine
	.DB CC_Indent, "I won't be flayed by any Tom, Dick or Harry!", CC_End

STR_DialogEng0081:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Well, I stand corrected.", CC_NewLine
	.DB CC_Indent, "I hadn't the faintest idea wild boar roast", CC_NewLine
	.DB CC_Indent, "was THAT delicious.", CC_End

STR_DialogEng0082:
	.DB CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Thanks, Alec! ", SYM_heart, CC_End

STR_DialogEng0083:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "This tastes good indeed ...", CC_NewLine
	.DB CC_Indent, "*sniffle*", CC_NewLine
	.DB CC_Indent, "... but it certainly isn't wild boar roast.", CC_End

STR_DialogEng0084:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Yum! ", SYM_heart, CC_ClearTextBox

STR_DialogEng0085:
;	.DB CC_BoxBlue
;	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I never knew the taste of fresh primate liver", CC_NewLine
	.DB CC_Indent, "actually resembled salted pork ...!", CC_End

STR_DialogEng0086:
	.DB CC_BoxPissed
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wh...what?", CC_NewLine
	.DB CC_Indent, "You mean what I'm eating is ... the remains of ...", CC_End

STR_DialogEng0087:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... three quarrelsome gorillas?", CC_NewLine
	.DB CC_Indent, "Hehe ... Who knows?!", CC_End

STR_DialogEng0088:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Alec, you ... you ... *sob*", CC_End

STR_DialogEng0089:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Tell her the truth, will you?", CC_End

STR_DialogEng0090:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What, that we were actually just having", CC_NewLine
	.DB CC_Indent, "venison ragout?", CC_End

STR_DialogEng0091:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "No, Leonido.", CC_End

STR_DialogEng0092:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Tell her you are not in love with her.", CC_End

STR_DialogEng0093:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "That's none of your business.", CC_End

STR_DialogEng0094:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Well, I'm going to sleep.", CC_End

STR_DialogEng0095:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well, what are you waiting for?", CC_End

STR_DialogEng0096:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Now that he's gone ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "(I'll sneak up on him, and tickle him all night! ", SYM_heart, ")", CC_NewLine
	.DB CC_Selection, CC_Indent, "(I'd better make it up to Lily for being a meanie.)", CC_End

STR_DialogEng0097:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "There she is ...", CC_End

STR_DialogEng0098:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Listen, uhm ... I was just joking.", CC_End

STR_DialogEng0099:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Yes, I know.", CC_End

STR_DialogEng0100:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What?", CC_End

STR_DialogEng0101:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "We've known each other ever since we were", CC_NewLine
	.DB CC_Indent, "little cubs. In all these years, you've", CC_NewLine
	.DB CC_Indent, "never once embarrassed me ...", CC_End

STR_DialogEng0102:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I ... really?", CC_End

STR_DialogEng0103:
	.DB CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "No kidding.", CC_End

STR_DialogEng0104:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well, I'd better try and keep it that way, then.", CC_End

STR_DialogEng0105:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Could you ... I mean, would you like to make us", CC_NewLine
	.DB CC_Indent, "your favorite dish tomorrow?", CC_NewLine
	.DB CC_Indent, "I mean ... please?", CC_End

STR_DialogEng0106:
	.DB CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, Alec ... You are so sweet. ", SYM_heart, CC_End

STR_DialogEng0107:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "There you are.", CC_End

STR_DialogEng0108:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "How did you ...?", CC_End

STR_DialogEng0109:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Heh. You're not the only one around with a", CC_NewLine
	.DB CC_Indent, "good sense of smell.", CC_End

STR_DialogEng0110:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nice spot you picked for the night.", CC_NewLine
	.DB CC_Indent, "Mind if I join you?", CC_End

STR_DialogEng0111:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "I do mind in case you snore.", CC_End

STR_DialogEng0112:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Don't worry, mate.", CC_End

STR_DialogEng0113:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Well ...", CC_End

STR_DialogEng0114:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "What is it?", CC_End

STR_DialogEng0115:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Good night, Primus. Sleep well.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Look how your ears shimmer in the moonlight ...", CC_End

STR_DialogEng0116:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Good night, Leonido.", CC_End

STR_DialogEng0117:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogEng0118:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "You too, Alec.", CC_End

STR_DialogEng0119:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "*Yaaaawn*", CC_End

STR_DialogEng0120:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Huh?! What's this?", CC_End

STR_DialogEng0121:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Parsnip stew. Lily just loves it.", CC_NewLine
	.DB CC_Indent, "Let's spoon it up already.", CC_End

STR_DialogEng0122:
	.DB CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "*mumble* *thistasteslikefoxenpiss* *mumble*", CC_End

STR_DialogEng0123:
	.DB CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Shush, you!", CC_End

STR_DialogEng0124:
	.DB CC_BoxPissed
	.DB "TARA:", CC_NewLine
	.DB CC_Indent, "Don't you lay your paw on me!", CC_End

/*
STR_DialogEngXXX:
	.DB CC_BoxBlue
	.DB "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_End
*/

STR_DialogEng031old:
	.DB CC_BoxBlue
	.DB "LEWNICAWN: Y'know, I can be a real chatterbox, myself.", CC_NewLine
	.DB CC_Indent, "If I'm in the right mood, mind ya. Then, I even enjoy" CC_NewLine
	.DB CC_Indent, "telling fairytales to my tail! Anyway, let's talk about", CC_NewLine
	.DB CC_Indent, "that Wolfen guy you're looking for.", CC_End

STR_DialogEng032old:
	.DB CC_BoxRed
	.DB "MERCENARY: That coat of yours ... I'm going to sell it", CC_NewLine
	.DB CC_Indent, "to he who makes the highest bid. Or, you can try and" CC_NewLine
	.DB CC_Indent, "fight me. To the death!", CC_NewLine
	.DB CC_Indent, "Well? What do you say, Foxen wimp?", CC_End



; ******************************** EOF *********************************
