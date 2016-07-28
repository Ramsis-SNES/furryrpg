;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2016 by Ramsis a.k.a. ManuLöwe (http://www.manuloewe.de/)
;
;	*** DIALOG STRINGS (GERMAN) ***
;
;==========================================================================================



; ****************************** Defines *******************************

;.DEFINE Auml		$80						; Ä
;.DEFINE Ouml		$81						; Ö
;.DEFINE Uuml		$82						; Ü
;.DEFINE auml		$83						; ä
;.DEFINE ouml		$84						; ö
;.DEFINE uuml		$85						; ü
;.DEFINE szlig		$86						; ß
;.DEFINE SYM_heart	$87, $88					; heart symbol
;.DEFINE SYM_quot	$89						; quotation mark
;.DEFINE SYM_mult	$8A						; multiplication sign



; ******************************* Dialog *******************************

; For TextPad (with "Regular expression" checked):
; Search for  : STR_DialogGer....
; Replace with: STR_DialogGer\i{0,1,4,0}

STR_DiagTestGer:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "DIALOG-TEST", CC_NewLine
	.DB "Steuerkreuz r/l (+Y): n", auml, "chster/vorheriger String", CC_NewLine
	.DB "R/L: +/-50 Strings", CC_NewLine
	.DB "A: Textbox schlie", szlig, "en | B: Auswahl abbrechen", CC_End

;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB"
;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB"
;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB"
;	.DB "ABABABABABABABABABABABABABABABABABABABABABABAB", CC_End	; 46 chars * 8 = 368 px

STR_DialogGer0000:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "J", Ouml, "RG B", Auml, "CKT QUASI ZWEI HAXENF", Uuml, "SSE VOM WILDPONY.", CC_NewLine
	.DB "j", ouml, "rg b", auml, "ckt quasi zwei haxenf", uuml, szlig, "e vom wildpony.", CC_NewLine
	.DB "0123456789 ", Auml, Ouml, Uuml, auml, ouml, uuml, szlig, CC_NewLine
	.DB "!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~", SYM_heart, SYM_quot, SYM_mult, CC_End

STR_DialogGer0001:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Uff, was f", uuml, "r ein Traum!", CC_ClearTextBox

STR_DialogGer0002:
	.DB CC_Indent, "Ich bin der F", auml, "hrte eines seltenen M", auml, "hnen-", CC_NewLine
	.DB CC_Indent, "Schneeleoparden gefolgt. Als ich ihn stellte,", CC_NewLine
	.DB CC_Indent, "hat er sich umgedreht und zu mir gesprochen ...", CC_ClearTextBox

STR_DialogGer0003:
	.DB CC_Indent, "Ich wei", szlig, " nicht mehr, was er sagte, nur", CC_NewLine
	.DB CC_Indent, "dass es mich total mitgenommen hat.", CC_End

STR_DialogGer0004:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Puh! Zum Gl", uuml, "ck war's nur ein Traum.", CC_ClearTextBox

STR_DialogGer0005:
	.DB CC_Indent, "Warum f", uuml, "hr' ich eigentlich Selbstgespr", auml, "che?", CC_NewLine
	.DB CC_Indent, "Ich sollte mich an die Arbeit machen!", CC_End

STR_DialogGer0006:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Das ist mein Haus.", CC_End

STR_DialogGer0007:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Meine Feuerstelle.", CC_NewLine
	.DB CC_Indent, "Vielleicht sollte ich heute noch etwas Feuerholz", CC_NewLine
	.DB CC_Indent, "sammeln ...", CC_End

STR_DialogGer0008:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Lecker, das Zeug. ", SYM_heart, CC_End

STR_DialogGer0009:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was in aller ...!?", CC_End

STR_DialogGer0010:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "TIGERFRAU:", CC_NewLine
	.DB CC_Indent, "Kein Wunder, wenn du deine Deckung", CC_NewLine
	.DB CC_Indent, "aufgibst ...", CC_End

STR_DialogGer0011:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Och, h", ouml, "r doch auf, Lily.", CC_End

STR_DialogGer0012:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tschuldige, Alec. Ich konnte einfach nicht", CC_NewLine
	.DB CC_Indent, "widerstehen. ", SYM_heart, CC_End

STR_DialogGer0013:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was willst du?", CC_End

STR_DialogGer0014:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sei nicht so schroff, ja!", CC_NewLine
	.DB CC_Indent, "Ich hab dir ein bisschen Milch mitgebracht.", CC_End

STR_DialogGer0015:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wozu das denn?", CC_End

STR_DialogGer0016:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Nun frag doch nicht dauernd so dummes Zeug,", CC_NewLine
	.DB CC_Indent, "sondern koste lieber mal.", CC_End

STR_DialogGer0017:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Na gut, okay. Aber nur dir zuliebe.", CC_End

STR_DialogGer0018:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Urgs ...", CC_End

STR_DialogGer0019:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Die ist einfach k", ouml, "stlich, oder?", CC_End

STR_DialogGer0020:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, Auml, "hmmmmm ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Na ja, wie gesagt, ist halt blo", szlig, " Milch.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Igitt. Was gibt's als n", auml, "chstes, Pastinakensuppe?", CC_End

STR_DialogGer0021:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ich wusste doch, dass du begeistert sein", CC_NewLine
	.DB CC_Indent, "w", uuml, "rdest. ", SYM_heart, CC_End

STR_DialogGer0022:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tut mir leid, Alec. Ich wollte dich nicht", CC_NewLine
	.DB CC_Indent, auml, "rgern.", CC_End

STR_DialogGer0023:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Sorry ...", CC_End

STR_DialogGer0024:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Keine Sorge, ist schon okay. ", SYM_heart, CC_End

STR_DialogGer0025:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Aber bestimmt bist du nicht nur hergekommen,", CC_NewLine
	.DB CC_Indent, "um mir Milch zu liefern, oder?", CC_End

STR_DialogGer0026:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Stimmt, bin ich nicht.", CC_End

STR_DialogGer0027:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Das Schicksal der ganzen Welt h", auml, "ngt nur", CC_NewLine
	.DB CC_Indent, "von dir ab!", CC_End

STR_DialogGer0028:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tihi, jetzt solltest du mal dein Gesicht", CC_NewLine
	.DB CC_Indent, "sehen ... ", SYM_heart, CC_End

STR_DialogGer0029:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "F", uuml, "r 'ne Sekunde hab' ich echt geglaubt ...", CC_End

STR_DialogGer0030:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Nee, aber du wirst Augen machen, wenn du erst", CC_NewLine
	.DB CC_Indent, "mal das hier h", ouml, "rst ...", CC_ClearTextBox

STR_DialogGer0031:
	.DB CC_Indent, "The mayor offers a reward to anyfur who finds", CC_NewLine
	.DB CC_Indent, "out what's behind this ghost people have been", CC_NewLine
	.DB CC_Indent, "talking about lately. You remember the stories", CC_NewLine
	.DB CC_Indent, "I told you, don't you?", CC_End

STR_DialogGer0032:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Of course!", CC_NewLine			; jump to 
	.DB CC_Selection, CC_Indent, "No idea what you mean!", CC_NewLine	; skip 
	.DB CC_Selection, CC_Indent, "Give me a hint, please.", CC_End		; skip 

STR_DialogGer0033:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Not just yours. The innkeeper, Tusker, claimed", CC_NewLine
	.DB CC_Indent, "that an armful of sausages were stolen from his", CC_NewLine
	.DB CC_Indent, "pantry just the other day.", CC_End

STR_DialogGer0034:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Where've you been, you dummy!", CC_End

STR_DialogGer0035:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Right. Apart from Tusker's missing sausages,", CC_NewLine
	.DB CC_Indent, "even more weird stuff's been going on in the", CC_NewLine
	.DB CC_Indent, "village.", CC_ClearTextBox

STR_DialogGer0036:
	.DB CC_Indent, "My Foxen neighbors' kid said he'd actually seen", CC_NewLine
	.DB CC_Indent, "the ghost with his own eyes, and ...", CC_End

STR_DialogGer0037:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "With who else's eyes would he have seen it,", CC_NewLine
	.DB CC_Indent, "anyway?", CC_End

STR_DialogGer0038:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "That's exactly what I told my neighbors.", CC_NewLine
	.DB CC_Indent, "But they're scared to death by now, too.", CC_ClearTextBox

STR_DialogGer0039:
	.DB CC_Indent, "Even Tusker, sensible though as he is, rather", CC_NewLine
	.DB CC_Indent, "chooses to believe in the supernatural. There's", CC_NewLine
	.DB CC_Indent, "just no way now to persuade anyfur to stick", CC_NewLine
	.DB CC_Indent, "with scientific evidence. So I thought ...", CC_End

STR_DialogGer0040:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... maybe you could use the help of some hunter?", CC_End

STR_DialogGer0041:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Not just any hunter, mind. ", SYM_heart, CC_End

STR_DialogGer0042:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "So what's the mayor's reward?", CC_NewLine	; jump to 
	.DB CC_Selection, CC_Indent, "I'd love to hunt some ghost!", CC_NewLine		; skip 
	.DB CC_Selection, CC_Indent, "Let's go on an adventure together!", CC_End	; skip 

STR_DialogGer0043:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "A bunch of gold, lots of food, and eternal glory,", CC_NewLine
	.DB CC_Indent, "they say.", CC_End

STR_DialogGer0044:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Never mind the gold. Glory sounds fun though.", CC_NewLine
	.DB CC_Indent, "Too bad the prize doesn't include any firewood ...", CC_End

STR_DialogGer0045:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, but it does ... I completely forgot! There", CC_NewLine
	.DB CC_Indent, "will be firewood. Loads of it. That's the", CC_NewLine
	.DB CC_Indent, "main thing, actually!", CC_End

STR_DialogGer0046:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Let's go then, what are we waiting for?", CC_NewLine
	.DB CC_Indent, "I want to be home early tonight!", CC_End

STR_DialogGer0047:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sure enough. ", SYM_heart, CC_End

STR_DialogGer0048:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Listen, I know somefur who can help us.", CC_NewLine
	.DB CC_Indent, "Before we go see the mayor, we should talk", CC_NewLine
	.DB CC_Indent, "to him.", CC_End

STR_DialogGer0049:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_NewLine, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, "<1> joins the party!", CC_End

STR_DialogGer0050:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Here we are at last.", CC_NewLine
	.DB CC_Indent, "Oh dear ...", CC_End

STR_DialogGer0051:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "What's the matter?", CC_End

STR_DialogGer0052:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "I completely forgot to tell my uncle that I'm", CC_NewLine
	.DB CC_Indent, "probably leaving for some time. Let's meet up", CC_NewLine
	.DB CC_Indent, "at Tusker's Inn in a bit, okay?", CC_End

STR_DialogGer0053:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "I'll go with you, shall I?", CC_End

STR_DialogGer0054:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "That's so nice of you, Alec. ", SYM_heart, CC_ClearTextBox

STR_DialogGer0055:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_Indent, "... But remember my uncle's a bit demented. He", CC_NewLine
	.DB CC_Indent, "probably wouldn't want to be seen by a stranger", CC_NewLine
	.DB CC_Indent, "in his condition.", CC_End

STR_DialogGer0056:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Okay. See you then.", CC_End

STR_DialogGer0057:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_NewLine, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, "<1> leaves the party!", CC_End

STR_DialogGer0058:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FREMDER WOLF:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_NewLine
	.DB CC_Indent, "Anscheinend sucht hier jemand ", Auml, "rger, das", CC_NewLine
	.DB CC_Indent, "bist nicht zuf", auml, "llig du?", CC_End

STR_DialogGer0059:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nenn mich nicht ", SYM_quot, "Leonido\"!", CC_End

STR_DialogGer0060:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FREMDER WOLF:", CC_NewLine
	.DB CC_Indent, "Gebongt-ido, Leonido ...", CC_End

STR_DialogGer0061:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_End

STR_DialogGer0062:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Was BITTESCH", Ouml, "N macht ihr zwei da!?", CC_End

STR_DialogGer0063:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Argh ... KERLE!", CC_NewLine
	.DB CC_Indent, "Entweder sie kabbeln sich oder ...", CC_End

STR_DialogGer0064:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oder was?", CC_End

STR_DialogGer0065:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER WOLF:", CC_NewLine
	.DB CC_Indent, "Ich bin Soldat. Mich mit anderen zu kabbeln", CC_NewLine
	.DB CC_Indent, "ist mein Beruf.", CC_End

STR_DialogGer0066:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Aber das hier ist der Typ, der dir bei deiner", CC_NewLine
	.DB CC_Indent, "Mission am ehesten helfen kann, wie gesagt!", CC_End

STR_DialogGer0067:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Aha, du bist also Alec Marlowe, der J", auml, "ger?", CC_NewLine
	.DB CC_Indent, "Dann muss ich mich entschuldigen. Freut mich,", CC_NewLine
	.DB CC_Indent, "dich kennenzulernen.", CC_End

STR_DialogGer0068:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was sollte das alles?", CC_End

STR_DialogGer0069:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Kleiner Tipp f", uuml, "r's n", auml, "chste Mal ...", CC_NewLine
	.DB CC_Indent, "Erst fragen, wen du vor dir hast, bevor du", CC_NewLine
	.DB CC_Indent, "wildfremde Leute anschnauzt!", CC_End

STR_DialogGer0070:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Das nennst du anschnauzen, ", SYM_quot, "Leonido\"?", CC_End

STR_DialogGer0071:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Schluss damit, oder ich versohl' dir deinen", CC_NewLine
	.DB CC_Indent, "Wolfen...", CC_End

STR_DialogGer0072:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ruhig Blut, Alec! Er hat sich doch nur", CC_NewLine
	.DB CC_Indent, "selbst zitiert!", CC_End

STR_DialogGer0073:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Da h", ouml, "rst du's, ", SYM_quot, "Leonido\". Wieder ein", CC_NewLine
	.DB CC_Indent, "Zitat, versteht sich ...", CC_End

STR_DialogGer0074:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, Uuml, "brigens bin ich selber schon oft genug", CC_NewLine
	.DB CC_Indent, SYM_quot, "angeschnauzt\" worden, wenn auch aus anderen", CC_NewLine
	.DB CC_Indent, "Gr", uuml, "nden.", CC_ClearTextBox

STR_DialogGer0075:
	.DB CC_Indent, "Um ehrlich zu sein, ist mir das v", ouml, "llig schnuppe.", CC_NewLine
	.DB CC_Indent, "Seit meiner Welpenzeit hab ich ein dickes Fell ...", CC_End

STR_DialogGer0076:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Du bist echt ein Spinner.", CC_End

STR_DialogGer0077:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Nein, ich bin Primus Greyfur, zu deinen Diensten.", CC_End

STR_DialogGer0078:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Er ist Soldat des Furderal Empire, Alec!", CC_End

STR_DialogGer0079:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Na dann ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Was hat dich hierher nach Librefur verschlagen?", CC_NewLine
	.DB CC_Selection, CC_Indent, "Du bist also ein Deserteur?", CC_End

STR_DialogGer0080:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Wenn ich ein Deserteur bin, dann bist du ein", CC_NewLine
	.DB CC_Indent, "Wilderer, Leonido.", CC_End

STR_DialogGer0081:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Ich hatte keine Lust mehr auf muffige Baracken", CC_NewLine
	.DB CC_Indent, "und besoffene Hauptleute und bin neuerdings", CC_NewLine
	.DB CC_Indent, "Freiberufler. Soll hei", szlig, "en, ich arbeite f", uuml, "r Geld.", CC_End

STR_DialogGer0082:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Klingt nach ziemlich hartem Brot ...", CC_End

STR_DialogGer0083:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Zugegeben, manchmal kann es hart sein.", CC_NewLine
	.DB CC_Indent, "Aber gerade heute ist es das nicht ...", CC_ClearTextBox

STR_DialogGer0084:
	.DB CC_Indent, "Now, if you'll excuse me? I have an appointment", CC_NewLine
	.DB CC_Indent, "at the mayor's. Unless you really mean it, and", CC_NewLine
	.DB CC_Indent, "want to join me hunting down some alleged ghost.", CC_End

STR_DialogGer0085:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Huh? Wait a minute ...", CC_ClearTextBox

STR_DialogGer0086:
	.DB CC_Indent, "Lily!", CC_NewLine
	.DB CC_Indent, "That was MY job, right there!", CC_End

STR_DialogGer0087:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "But your job plus his job equals our job,", CC_NewLine
	.DB CC_Indent, "doesn't it?", CC_NewLine
	.DB CC_Indent, "Also ... Sollen wir langsam aufbrechen?", CC_End

STR_DialogGer0088:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "JUGENDLICHE WOLFEN:", CC_NewLine
	.DB CC_Indent, "La ~ di ~ da ~", CC_NewLine
	.DB CC_Indent, "Ich find', dass dieser graufellige Soldat", CC_NewLine
	.DB CC_Indent, "mich mag. ", SYM_heart, CC_End

STR_DialogGer0089:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Welcome to your briefing, Primus Greyfur.", CC_End

STR_DialogGer0090:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Thank you, mayor. These two are with me.", CC_End

STR_DialogGer0091:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Miss Lilac Pondicherry ... I am enchanted.", CC_End

STR_DialogGer0092:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, CC_Selection, "Really?", CC_NewLine
	.DB CC_Indent, CC_Selection, "What about me?", CC_End

STR_DialogGer0093:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "In the name of all inhabitants of Furlorn village,", CC_NewLine
	.DB CC_Indent, "thank you for lending us your assistance, Sir", CC_NewLine
	.DB CC_Indent, "Greyfur.", CC_End

STR_DialogGer0094:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Just Primus, if you will.", CC_End

STR_DialogGer0095:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Sir Greyfur, as you are probably aware, eternal", CC_NewLine
	.DB CC_Indent, "glory awaits he who rids us of that dreadful", CC_NewLine
	.DB CC_Indent, "threat ...", CC_ClearTextBox

STR_DialogGer0096:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_Indent, "... a threat which has haunted our village", CC_NewLine
	.DB CC_Indent, "ever since you showed up here.", CC_End

STR_DialogGer0097:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Yeah, I ... wait, what? Just glory? No gold?", CC_End

STR_DialogGer0098:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Don't worry, you will of course be rewarded", CC_NewLine
	.DB CC_Indent, "timely, and decently. You have my word.", CC_End

STR_DialogGer0099:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Understood.", CC_End

STR_DialogGer0100:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "That's settled then.", CC_ClearTextBox

STR_DialogGer0101:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GOATEN MAYOR:", CC_NewLine
	.DB CC_Indent, "Be sure to talk to all the villagers, as somefur", CC_NewLine
	.DB CC_Indent, "among us is bound to have a clue on where to", CC_NewLine
	.DB CC_Indent, "start your quest. Godspeed!", CC_End

STR_DialogGer0102:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "So there goes my extra stack of firewood down", CC_NewLine
	.DB CC_Indent, "the drain. Lily, you and I need to talk.", CC_End

STR_DialogGer0103:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Don't forget the gold though. With it, you can", CC_NewLine
	.DB CC_Indent, "buy as much firewood as you want, can't you?", CC_End

STR_DialogGer0104:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "True. But why the charade?", CC_End

STR_DialogGer0105:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sorry, Alec ... I know you wanted to be home early", CC_NewLine
	.DB CC_Indent, "tonight. I was afraid that might not happen.", CC_ClearTextBox

STR_DialogGer0106:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_Indent, "But I knew YOU, didn't I? I knew you'd be glad", CC_NewLine
	.DB CC_Indent, "that I gave you a little nudge out of your", CC_NewLine
	.DB CC_Indent, "door ...", CC_End

STR_DialogGer0107:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sorry to interrupt, but are you two relatives?", CC_End

STR_DialogGer0108:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "No, we're lovers, of course.", CC_NewLine
	.DB CC_Selection, CC_Indent, "She once taught me how to read and write ...", CC_End

STR_DialogGer0109:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Alright ...", CC_End

STR_DialogGer0110:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "So the mayor told us to talk to the villagers.", CC_NewLine
	.DB CC_Indent, "Let's go!", CC_End

STR_DialogGer0111:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oje ...", CC_NewLine
	.DB CC_Indent, "Wie's aussieht, sitzen wir hier erst mal fest.", CC_End

STR_DialogGer0112:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Keine Sorge. Ich r", auml, "um' das Ger", uuml, "mpel hier weg,", CC_NewLine
	.DB CC_Indent, "und schon k", ouml, "nnen wir wieder verschwinden.", CC_End

STR_DialogGer0113:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Warte mal!", CC_End

STR_DialogGer0114:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was ist los?", CC_End

STR_DialogGer0115:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wo wir schon hier sind, k", ouml, "nnten wir uns", CC_NewLine
	.DB CC_Indent, "mal umsehen, meinst du nicht?", CC_End

STR_DialogGer0116:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sie hat recht, Leonido.", CC_NewLine
	.DB CC_Indent, "Meine Nase sagt mir, dass dieser Ort nicht ganz", CC_NewLine
	.DB CC_Indent, "fuchsenrein ist ...", CC_End

STR_DialogGer0117:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogGer0118:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Also? Was tun wir?", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Schleunigst abhauen!)", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Bleiben und mal umschauen)", CC_End

STR_DialogGer0119:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Hier war seit Ewigkeiten keiner mehr.", CC_End

STR_DialogGer0120:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Eine Puppe in Gestalt eines Fenneks.", CC_NewLine
	.DB CC_Indent, "Allerdings fehlen ihr die Augen.", CC_End

STR_DialogGer0121:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "What a creepy place.", CC_NewLine
	.DB CC_Indent, "I begin to feel like we shouldn't have come here", CC_NewLine
	.DB CC_Indent, "after all ...", CC_End

STR_DialogGer0122:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FENNEK-PUPPE:", CC_NewLine
	.DB CC_Indent, "Ich kann dich nicht sehen ...", CC_NewLine
	.DB CC_Indent, "... aber ich h", ouml, "re dein Herz schlagen!", CC_End

STR_DialogGer0123:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Look out! More enemies approaching!", CC_End

STR_DialogGer0124:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MALE VOICE:", CC_NewLine
	.DB CC_Indent, "I mean no harm ...", CC_End

STR_DialogGer0125:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "STRANGE FOX:", CC_NewLine
	.DB CC_Indent, "You fought very well.", CC_NewLine
	.DB CC_Indent, "Who are you?", CC_End

STR_DialogGer0126:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "I'm Alec, and these are my friends.", CC_NewLine
	.DB CC_Selection, CC_Indent, "I should ask you the same thing, Redcoat!", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Have Lily reply instead)", CC_End

STR_DialogGer0127:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "STRANGE FOX:", CC_NewLine
	.DB CC_Indent, "Welcome to the Middle of Nowhere, Alec.", CC_End

STR_DialogGer0128:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "STRANGE FOX:", CC_NewLine
	.DB CC_Indent, "I am deeply sorry for being so rude in the", CC_NewLine
	.DB CC_Indent, "first place.", CC_End

STR_DialogGer0129:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "STRANGE FOX:", CC_NewLine
	.DB CC_Indent, "My name is Reinhold von Pappenheim.", CC_NewLine
	.DB CC_Indent, "I'm a professional ventriloquist.", CC_NewLine
	.DB CC_Indent, "Sorry again for frightening you people ...", CC_End

STR_DialogGer0130:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "So there we have our ", SYM_quot, "ghost.\"", CC_End

STR_DialogGer0131:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "You ever been to Furlorn village, by any chance?", CC_End

STR_DialogGer0132:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FUCHSENWELPE:", CC_NewLine
	.DB CC_Indent, "Wr", auml, "ffs! Ich h", auml, "ng' fest!!", CC_End

STR_DialogGer0133:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MICKEY:", CC_NewLine
	.DB CC_Indent, "Bitte was!? Pass auf, wenn du uns nicht SOFORT", CC_NewLine
	.DB CC_Indent, "Antwort gibst, mach ich dir einen Knoten in den", CC_NewLine
	.DB CC_Indent, "Schwanz! Kapiert?", CC_End

STR_DialogGer0134:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "BRAUNB", Auml, "R:", CC_NewLine
	.DB CC_Indent, "Habe die Ehre. ", Auml, "hem ...", CC_ClearTextBox
	
STR_DialogGer0135:
	.DB CC_Indent, "Mein Name ist Gregory Perpetuus Ebenezer", CC_NewLine
	.DB CC_Indent, "Hrabanus Eindhoven Dubois Quaoar van der", CC_NewLine
	.DB CC_Indent, "Muhlhausen Nido sulle Colline ... Junior.", CC_End

STR_DialogGer0136:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GORILLA 1:", CC_NewLine
	.DB CC_Indent, "G'day, mate.", CC_NewLine
	.DB CC_Indent, "Very pleased ter meetcha, me is ...", CC_ClearTextBox

STR_DialogGer0137:
	.DB CC_BoxEvil
	.DB CC_Indent, "... 'cuz me main hobby is turning lions into", CC_NewLine
	.DB CC_Indent, "sausage!", CC_NewLine
	.DB CC_Indent, "Oh, me name's Joe. Joe Lion-Trapper ...", CC_End

STR_DialogGer0138:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "GORILLA 2:", CC_NewLine
	.DB CC_Indent, "Hello there, hunky mane-bearer. ", SYM_heart, CC_NewLine
	.DB CC_Indent, "Your muscled appearance, coated in velvety", CC_NewLine
	.DB CC_Indent, "golden fur, is indeed a feast for the eyes ...", CC_ClearTextBox

STR_DialogGer0139:
	.DB CC_BoxEvil
	.DB CC_Indent, "... as it'll be for my fangs. Too bad you can't live", CC_NewLine
	.DB CC_Indent, "to witness our appreciation of your tasty flesh!", CC_NewLine
	.DB CC_Indent, "By the way, they call me Jim. Jim Lion-Slayer ...", CC_End

STR_DialogGer0140:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GORILLA 3:", CC_NewLine
	.DB CC_Indent, "Greetings, young Leonido.", CC_NewLine
	.DB CC_Indent, "Never mind either of my brothers' uncouth", CC_NewLine
	.DB CC_Indent, "talk ...", CC_ClearTextBox

STR_DialogGer0141:
	.DB CC_BoxEvil
	.DB CC_Indent, "Just rest assured that it will be an honor,", CC_NewLine
	.DB CC_Indent, "and a privilege, to take your precious hide.", CC_NewLine
	.DB CC_Indent, "For I am known as Jack. Jack Lion-Flayer ...", CC_End

STR_DialogGer0142:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Kleiner Tipp, ihr drei Affen ...", CC_NewLine
	.DB CC_Indent, "I won't be flayed by any Tom, Dick or Harry!", CC_End

STR_DialogGer0143:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tja, ich nehme alles zur", uuml, "ck.", CC_NewLine
	.DB CC_Indent, "Ich hatte nicht den leisesten Schimmer, dass", CC_NewLine
	.DB CC_Indent, "Wildschwein-Rostbraten SO lecker schmeckt.", CC_End

STR_DialogGer0144:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Danke, Alec! ", SYM_heart, CC_End

STR_DialogGer0145:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Schmeckt wirklich gut ...", CC_NewLine
	.DB CC_Indent, "*schn", uuml, "ffel*", CC_NewLine
	.DB CC_Indent, "... aber ist ganz sicher kein Wildschweinbraten.", CC_End

STR_DialogGer0146:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Schleck! ", SYM_heart, CC_ClearTextBox

STR_DialogGer0147:
	.DB CC_Indent, "Ich wusste gar nicht, dass frische Primatenleber", CC_NewLine
	.DB CC_Indent, "ein bisschen wie R", auml, "ucherschinken schmeckt ...!", CC_End

STR_DialogGer0148:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "W...was?", CC_NewLine
	.DB CC_Indent, "Soll das hei", szlig, "en, ich esse hier gerade ...", CC_NewLine
	.DB CC_Indent, "... die sterblichen ", Uuml, "berreste ...", CC_End

STR_DialogGer0149:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... von drei streits", uuml, "chtigen Gorillas?", CC_NewLine
	.DB CC_Indent, "Hehe ... Wer wei", szlig, "!?", CC_End

STR_DialogGer0150:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Alec, du ... du ... *schnief*", CC_End

STR_DialogGer0151:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sag ihr mal die Wahrheit, ja?", CC_End

STR_DialogGer0152:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Welche? Dass wir in Wirklichkeit gerade", CC_NewLine
	.DB CC_Indent, "Hirschragout gefuttert haben?", CC_End

STR_DialogGer0153:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Nein, Leonido.", CC_End

STR_DialogGer0154:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sag ihr, dass du nicht auch in sie verliebt bist.", CC_End

STR_DialogGer0155:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Das geht dich ", uuml, "berhaupt nichts an.", CC_End

STR_DialogGer0156:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Wie auch immer, ich geh jetzt schlafen.", CC_End

STR_DialogGer0157:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wie auch immer, worauf wartest du noch?", CC_End

STR_DialogGer0158:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Jetzt wo er weg ist ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "(... schleich' ich mich an und kitzel ihn durch! ", SYM_heart, ")", CC_NewLine
	.DB CC_Selection, CC_Indent, "(... stelle ich mich lieber mit Lily wieder gut.)", CC_End

STR_DialogGer0159:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Da ist sie ja ...", CC_End

STR_DialogGer0160:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "H", ouml, "r mal, ", auml, "hm ... Ich hab nur Spa", szlig, " gemacht.", CC_End

STR_DialogGer0161:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ja, ich wei", szlig, ".", CC_End

STR_DialogGer0162:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was?", CC_End

STR_DialogGer0163:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wir kennen uns von Welpenpfoten an. In all den", CC_NewLine
	.DB CC_Indent, "Jahren hast du mich nicht ein einziges Mal in", CC_NewLine
	.DB CC_Indent, "Verlegenheit gebracht ...", CC_End

STR_DialogGer0164:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ich ... echt nicht?", CC_End

STR_DialogGer0165:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ehrenwort.", CC_End

STR_DialogGer0166:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Na, dann seh' ich lieber zu, dass das so bleibt.", CC_End

STR_DialogGer0167:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "K", ouml, "nntest du ... Also, w", uuml, "rdest du uns morgen", CC_NewLine
	.DB CC_Indent, "dein Lieblingsessen machen?", CC_NewLine
	.DB CC_Indent, "Ich meine ... bitte?", CC_End

STR_DialogGer0168:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, Alec ... Du bist so lieb. ", SYM_heart, CC_End

STR_DialogGer0169:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Da bist du ja.", CC_End

STR_DialogGer0170:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wie hast du mich ...?", CC_End

STR_DialogGer0171:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Heh. Du bist nicht der Einzige hier, der", CC_NewLine
	.DB CC_Indent, "eine feine Nase hat.", CC_End

STR_DialogGer0172:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ein sch", ouml, "nes Pl", auml, "tzchen zum Schlafen hast du da", CC_NewLine
	.DB CC_Indent, "gefunden. Was dagegen, wenn ich mich zu dir", CC_NewLine
	.DB CC_Indent, "geselle?", CC_End

STR_DialogGer0173:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Ich habe etwas dagegen, falls du schnarchst.", CC_End

STR_DialogGer0174:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Keine Sorge, Kumpel.", CC_End

STR_DialogGer0175:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Dann also ...", CC_End

STR_DialogGer0176:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Was ist noch?", CC_End

STR_DialogGer0177:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Gute Nacht, Primus. Schlaf gut.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Wie deine Ohren im Mondlicht schimmern ...", CC_End

STR_DialogGer0178:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Gute Nacht, Leonido.", CC_End

STR_DialogGer0179:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogGer0180:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Du auch, Alec.", CC_End

STR_DialogGer0181:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "*G", auml, auml, auml, auml, "hn*", CC_End

STR_DialogGer0182:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "H", ouml, "h!? Was ist das?", CC_End

STR_DialogGer0183:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Pastinakensuppe. Lily steht da total drauf.", CC_NewLine
	.DB CC_Indent, "Einfach Nase zuhalten und ausl", ouml, "ffeln.", CC_End

STR_DialogGer0184:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "*murmel* *schmecktjawiefuchsenpisse* *grummel*", CC_End

STR_DialogGer0185:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Pst, sei blo", szlig, " still!", CC_End

STR_DialogGer0186:
	.DB CC_Portrait, 0, CC_BoxPissed
	.DB "TARA:", CC_NewLine
	.DB CC_Indent, "Nimm ja deine Pfote von mir!", CC_End

/*
STR_DialogGerXXX:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_End
*/

STR_DialogGer031old:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "LEWNICAWN: Y'know, I can be a real chatterbox, myself.", CC_NewLine
	.DB CC_Indent, "If I'm in the right mood, mind ya. Then, I even enjoy" CC_NewLine
	.DB CC_Indent, "telling fairytales to my tail! Anyway, let's talk about", CC_NewLine
	.DB CC_Indent, "that Wolfen guy you're looking for.", CC_End

STR_DialogGer032old:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "MERCENARY: That coat of yours ... I'm going to sell it", CC_NewLine
	.DB CC_Indent, "to he who makes the highest bid. Or, you can try and" CC_NewLine
	.DB CC_Indent, "fight me. To the death!", CC_NewLine
	.DB CC_Indent, "Well? What do you say, Foxen wimp?", CC_End



; ******************************** EOF *********************************