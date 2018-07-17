;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 201X by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
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
;.DEFINE SYM_mult	$89						; multiplication sign



; ******************************* Dialog *******************************

STR_DiagTestGer:
	.DB CC_Portrait, 3, CC_BoxBlue
	.DB "DIALOG-TEST", CC_NewLine
	.DB "Steuerkreuz r/l (+Y): n", auml, "chster/vorheriger String", CC_NewLine
	.DB "R/L: +/-50 Strings", CC_NewLine
	.DB "B: Textbox schlie", szlig, "en/Auswahl abbrechen", CC_End

STR_DialogGer0000:
	.DB CC_Portrait, 3, CC_BoxBlue
	.DB "J", Ouml, "RG B", Auml, "CKT QUASI ZWEI HAXENF", Uuml, "SSE VOM WILDPONY.", CC_NewLine
	.DB "j", ouml, "rg b", auml, "ckt quasi zwei haxenf", uuml, szlig, "e vom wildpony.", CC_NewLine
	.DB "0123456789 ", Auml, Ouml, Uuml, auml, ouml, uuml, szlig, CC_NewLine
	.DB "!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~", SYM_heart, SYM_mult, CC_End

STR_DialogGer0001:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Uff, was f", uuml, "r ein Traum!", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Ich bin der F", auml, "hrte eines seltenen M", auml, "hnen-", CC_NewLine
	.DB CC_Indent, "Schneeleoparden gefolgt. Als ich ihn stellte,", CC_NewLine
	.DB CC_Indent, "hat er sich umgedreht und zu mir gesprochen ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Ich wei", szlig, " nicht mehr, was er sagte, nur", CC_NewLine
	.DB CC_Indent, "dass es mich total mitgenommen hat.", CC_End

STR_DialogGer0002:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Puh! Zum Gl", uuml, "ck war's nur ein Traum.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Warum f", uuml, "hr' ich eigentlich Selbstgespr", auml, "che?", CC_NewLine
	.DB CC_Indent, "Ich sollte mich an die Arbeit machen!", CC_End

STR_DialogGer0003:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Das ist mein Haus.", CC_End

STR_DialogGer0004:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Meine Feuerstelle.", CC_NewLine
	.DB CC_Indent, "Vielleicht sollte ich heute noch etwas Feuerholz", CC_NewLine
	.DB CC_Indent, "sammeln ...", CC_End

STR_DialogGer0005:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Lecker, das Zeug. ", SYM_heart, CC_End

STR_DialogGer0006:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was in aller ...!?", CC_End

STR_DialogGer0007:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "TIGERFRAU:", CC_NewLine
	.DB CC_Indent, "Kein Wunder, wenn du deine Deckung", CC_NewLine
	.DB CC_Indent, "aufgibst ...", CC_End

STR_DialogGer0008:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Och, h", ouml, "r doch auf, Lily.", CC_End

STR_DialogGer0009:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tschuldige, Alec. Ich konnte einfach nicht", CC_NewLine
	.DB CC_Indent, "widerstehen. ", SYM_heart, CC_End

STR_DialogGer0010:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was willst du?", CC_End

STR_DialogGer0011:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Sei nicht so schroff, ja!", CC_NewLine
	.DB CC_Indent, "Ich hab dir ein bisschen Milch mitgebracht.", CC_End

STR_DialogGer0012:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wozu das denn?", CC_End

STR_DialogGer0013:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Nun frag doch nicht dauernd so dummes Zeug,", CC_NewLine
	.DB CC_Indent, "sondern koste lieber mal.", CC_End

STR_DialogGer0014:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Na gut, okay. Aber nur dir zuliebe.", CC_End

STR_DialogGer0015:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Urgs ...", CC_End

STR_DialogGer0016:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Die ist einfach k", ouml, "stlich, oder?", CC_End

STR_DialogGer0017:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, Auml, "hmmmmm ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Na ja, wie gesagt, ist halt blo", szlig, " Milch.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Igitt. Was gibt's als n", auml, "chstes, Pastinakensuppe?", CC_End

STR_DialogGer0018:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ich wusste doch, dass du begeistert sein", CC_NewLine
	.DB CC_Indent, "w", uuml, "rdest. ", SYM_heart, CC_End

STR_DialogGer0019:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tut mir leid, Alec. Ich wollte dich nicht", CC_NewLine
	.DB CC_Indent, auml, "rgern.", CC_End

STR_DialogGer0020:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Sorry ...", CC_End

STR_DialogGer0021:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Keine Sorge, ist schon okay. ", SYM_heart, CC_End

STR_DialogGer0022:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Aber bestimmt bist du nicht nur hergekommen,", CC_NewLine
	.DB CC_Indent, "um mir Milch zu liefern, oder?", CC_End

STR_DialogGer0023:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Stimmt, bin ich nicht.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxAlert
	.DB CC_Indent, "Das Schicksal der ganzen Welt h", auml, "ngt nur", CC_NewLine
	.DB CC_Indent, "von dir ab!", CC_End

STR_DialogGer0024:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tihi, jetzt solltest du mal dein Gesicht", CC_NewLine
	.DB CC_Indent, "sehen ... ", SYM_heart, CC_End

STR_DialogGer0025:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "F", uuml, "r 'ne Sekunde hab' ich echt geglaubt ...", CC_End

STR_DialogGer0026:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Nee, aber du wirst Augen machen, wenn du erst", CC_NewLine
	.DB CC_Indent, "mal das hier h", ouml, "rst ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Der B", uuml, "rgermeister verspricht demjenigen eine", CC_NewLine
	.DB CC_Indent, "Belohnung, der rausfindet, was es mit diesem" CC_NewLine
	.DB CC_Indent, ",,Geist\" auf sich hat, von dem alle reden. Ich hab", CC_NewLine
	.DB CC_Indent, "dir doch davon erz", auml, "hlt, wei", szlig, "t du noch?", CC_End

STR_DialogGer0027:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Na klar!", CC_NewLine
	.DB CC_Selection, CC_Indent, "Keine Ahnung, was du meinst!", CC_NewLine
	.DB CC_Selection, CC_Indent, "Hilf mir mal auf die Spr", uuml, "nge ...", CC_End

STR_DialogGer0028:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nicht nur du. Tusker hat neulich erz", auml, "hlt, aus", CC_NewLine
	.DB CC_Indent, "der Vorratskammer seiner Sch", auml, "nke sei ein", CC_NewLine
	.DB CC_Indent, "Dutzend Ringe Dauerwurst geklaut worden.", CC_End

STR_DialogGer0029:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Du lebst aber auch echt hinter dem Mond!", CC_End

STR_DialogGer0030:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Abgesehen von Tuskers verschwundenen W", uuml, "rsten", CC_NewLine
	.DB CC_Indent, "sind im Dorf in letzter Zeit noch mehr komische", CC_NewLine
	.DB CC_Indent, "Sachen passiert.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Der Kleine meiner Fuchsennachbarn behauptet", CC_NewLine
	.DB CC_Indent, "sogar, er h", auml, "tte den Geist mit eigenen Augen", CC_NewLine
	.DB CC_Indent, "gesehen, und ...", CC_End

STR_DialogGer0031:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Mit wessen Augen h", auml, "tte er ihn auch sonst sehen", CC_NewLine
	.DB CC_Indent, "sollen?", CC_End

STR_DialogGer0032:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Genau das hab ich meinen Nachbarn auch gesagt.", CC_NewLine
	.DB CC_Indent, "Aber die sind mittlerweile alle drei zu Tode", CC_NewLine
	.DB CC_Indent, "ver", auml, "ngstigt.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Sogar Tusker, eigentlich ein vern", uuml, "nftiger Kerl,", CC_NewLine
	.DB CC_Indent, "glaubt mittlerweile lieber an ", uuml, "bernat", uuml, "rliche", CC_NewLine
	.DB CC_Indent, "Kr", auml, "fte. Mit evidenzbasierter Wissenschaft kommst", CC_NewLine
	.DB CC_Indent, "du bei niemandem mehr weit. Also dachte ich ...", CC_End

STR_DialogGer0033:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... ein Profi-J", auml, "ger k", ouml, "nnte dir da behilflich", CC_NewLine
	.DB CC_Indent, "sein?", CC_End

STR_DialogGer0034:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Nicht irgendeiner, versteht sich. ", SYM_heart, CC_End

STR_DialogGer0035:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Worin besteht die Belohnung?", CC_NewLine
	.DB CC_Selection, CC_Indent, "Allzeit bereit f", uuml, "r die Geisterjagd!", CC_End

STR_DialogGer0036:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Willst du denn gar nicht wissen, worin die Belohnung", CC_NewLine
	.DB CC_Indent, "des B", uuml, "rgermeisters besteht?", CC_End

STR_DialogGer0037:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Hm? Was ist es denn?", CC_End

STR_DialogGer0038:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ein Haufen Gold, jede Menge Naturalien und", CC_NewLine
	.DB CC_Indent, "ewiger Ruhm, hab ich geh", ouml, "rt.", CC_End

STR_DialogGer0039:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Gold brauch' ich nicht. Das mit dem Ruhm klingt", CC_NewLine
	.DB CC_Indent, "ganz in Ordnung. Schade, dass kein Feuerholz", CC_NewLine
	.DB CC_Indent, "dabei ist ...", CC_End

STR_DialogGer0040:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, ist es aber ... hab ich doch glatt vergessen", CC_NewLine
	.DB CC_Indent, "zu sagen! Drei Ster Feuerholz. Mindestens. Das", CC_NewLine
	.DB CC_Indent, "ist eigentlich sogar der Hauptpreis!", CC_End

STR_DialogGer0041:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Also los, worauf warten wir noch?", CC_NewLine
	.DB CC_Indent, "Schlie", szlig, "lich will ich heute fr", uuml, "h am Abend", CC_NewLine
	.DB CC_Indent, "wieder zu Hause sein!", CC_End

STR_DialogGer0042:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Klar doch. ", SYM_heart, CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxBlue
	.DB CC_Indent, Uuml, "brigens, ich kenne jemanden, der uns helfen", CC_NewLine
	.DB CC_Indent, "kann. Bevor wir den B", uuml, "rgermeister besuchen,", CC_NewLine
	.DB CC_Indent, "sollten wir mit ihm sprechen.", CC_End

STR_DialogGer0043:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_NewLine, CC_Indent, CC_Indent, CC_Indent, CC_Indent, "<1> schlie", szlig, "t sich der Gruppe an!", CC_End

STR_DialogGer0044:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Da sind wir endlich.", CC_NewLine
	.DB CC_Indent, "Ach du liebes Bisschen ...", CC_End

STR_DialogGer0045:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Stimmt was nicht?", CC_End

STR_DialogGer0046:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ich hab v", ouml, "llig vergessen, meinem Onkel Bescheid zu", CC_NewLine
	.DB CC_Indent, "sagen, dass ich eine Weile weg sein werde. Treffen", CC_NewLine
	.DB CC_Indent, "wir uns doch nachher in Tuskers Sch", auml, "nke, okay?", CC_End

STR_DialogGer0047:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ich geh auch gern mit dir mit!", CC_End

STR_DialogGer0048:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Das ist echt nett von dir, Alec. ", SYM_heart, CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxBlue
	.DB CC_Indent, "... Aber du wei", szlig, "t ja, mein Onkel ist ein bisschen senil.", CC_NewLine
	.DB CC_Indent, "In seinem Zustand will er lieber keinen Besuch von", CC_NewLine
	.DB CC_Indent, "Fremden.", CC_End

STR_DialogGer0049:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Okay. Dann bis sp", auml, "ter.", CC_End

STR_DialogGer0050:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB CC_NewLine, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, CC_Indent, "<1> verl", auml, "sst die Gruppe!", CC_End

STR_DialogGer0051:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FREMDER WOLF:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_NewLine
	.DB CC_Indent, "Anscheinend sucht hier jemand ", Auml, "rger, das", CC_NewLine
	.DB CC_Indent, "bist nicht zuf", auml, "llig du?", CC_End

STR_DialogGer0052:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nenn mich nicht ,,Leonido\"!", CC_End

STR_DialogGer0053:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FREMDER WOLF:", CC_NewLine
	.DB CC_Indent, "Gebongt-ido, Leonido ...", CC_End

STR_DialogGer0054:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Hey-ho, Leonido ...", CC_End

STR_DialogGer0055:
	.DB CC_Portrait, 2, CC_BoxAlert
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Was BITTESCH", Ouml, "N macht ihr zwei da!?", CC_End

STR_DialogGer0056:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Argh ... KERLE!", CC_NewLine
	.DB CC_Indent, "Entweder sie kabbeln sich oder ...", CC_End

STR_DialogGer0057:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oder was?", CC_End

STR_DialogGer0058:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER WOLF:", CC_NewLine
	.DB CC_Indent, "Ich bin Soldat. Mich mit anderen zu kabbeln", CC_NewLine
	.DB CC_Indent, "ist mein Beruf.", CC_End

STR_DialogGer0059:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Aber das hier ist der Typ, der dir bei deiner", CC_NewLine
	.DB CC_Indent, "Mission am ehesten helfen kann, wie gesagt!", CC_End

STR_DialogGer0060:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Aha, du bist also Alec Marlowe, der J", auml, "ger?", CC_NewLine
	.DB CC_Indent, "Dann muss ich mich entschuldigen. Freut mich,", CC_NewLine
	.DB CC_Indent, "dich kennenzulernen.", CC_End

STR_DialogGer0061:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was sollte das alles?", CC_End

STR_DialogGer0062:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Kleiner Tipp f", uuml, "r's n", auml, "chste Mal ...", CC_NewLine
	.DB CC_Indent, "Erst fragen, wen du vor dir hast, bevor du", CC_NewLine
	.DB CC_Indent, "wildfremde Leute anschnauzt!", CC_End

STR_DialogGer0063:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Das nennst du anschnauzen, ,,Leonido\"?", CC_End

STR_DialogGer0064:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Schluss damit, oder ich versohl' dir deinen", CC_NewLine
	.DB CC_Indent, "Wolfen...", CC_End

STR_DialogGer0065:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ruhig Blut, Alec! Er hat sich doch nur", CC_NewLine
	.DB CC_Indent, "selbst zitiert!", CC_End

STR_DialogGer0066:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Da h", ouml, "rst du's, ,,Leonido\". Wieder ein", CC_NewLine
	.DB CC_Indent, "Zitat, versteht sich ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, Uuml, "brigens bin ich selber schon oft genug", CC_NewLine
	.DB CC_Indent, ",,angeschnauzt\" worden, wenn auch aus anderen", CC_NewLine
	.DB CC_Indent, "Gr", uuml, "nden.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Um ehrlich zu sein, ist mir das v", ouml, "llig schnuppe.", CC_NewLine
	.DB CC_Indent, "Seit meiner Welpenzeit hab ich ein dickes Fell ...", CC_End

STR_DialogGer0067:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Du bist echt ein Spinner.", CC_End

STR_DialogGer0068:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "WOLFENSOLDAT:", CC_NewLine
	.DB CC_Indent, "Nein, ich bin Primus Greyfur, zu deinen Diensten.", CC_End

STR_DialogGer0069:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Er ist Soldat des Furderal Empire, Alec!", CC_End

STR_DialogGer0070:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Na dann ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "Was hat dich hierher nach Librefur verschlagen?", CC_NewLine
	.DB CC_Selection, CC_Indent, "Du bist also ein Deserteur?", CC_End

STR_DialogGer0071:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Wenn ich ein Deserteur bin, dann bist du ein", CC_NewLine
	.DB CC_Indent, "Wilderer, Leonido.", CC_End

STR_DialogGer0072:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Ich hatte keine Lust mehr auf muffige Baracken", CC_NewLine
	.DB CC_Indent, "und besoffene Hauptleute und bin neuerdings", CC_NewLine
	.DB CC_Indent, "Freiberufler. Soll hei", szlig, "en, ich arbeite f", uuml, "r Geld.", CC_End

STR_DialogGer0073:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Klingt nach ziemlich hartem Brot ...", CC_End

STR_DialogGer0074:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Zugegeben, manchmal kann es hart sein.", CC_NewLine
	.DB CC_Indent, "Aber gerade heute ist es das nicht ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Wenn ihr mich jetzt bitte entschuldigen wollt?", CC_NewLine
	.DB CC_Indent, "Ich habe einen Termin beim B", uuml, "rgermeister. Nur falls ihr", CC_NewLine
	.DB CC_Indent, "es ernst meint und mich wirklich auf der Jagd nach dem", CC_NewLine
	.DB CC_Indent, "angeblichen Geist begleiten wollt.", CC_End

STR_DialogGer0075:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "H", auml, "h? Augenblick mal ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Lily!", CC_NewLine
	.DB CC_Indent, "Das da gerade war doch MEIN Job!", CC_End

STR_DialogGer0076:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Und dein Job plus sein Job ergibt unseren Job,", CC_NewLine
	.DB CC_Indent, "stimmt's?", CC_NewLine
	.DB CC_Indent, "Also ... Sollen wir langsam aufbrechen?", CC_End

STR_DialogGer0077:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "JUGENDLICHE WOLFEN:", CC_NewLine
	.DB CC_Indent, "La ~ di ~ da ~", CC_NewLine
	.DB CC_Indent, "Ich find', dass dieser graufellige Soldat", CC_NewLine
	.DB CC_Indent, "mich mag. ", SYM_heart, CC_End

STR_DialogGer0078:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Willkommen zu Ihrem Briefing, Primus Greyfur.", CC_End

STR_DialogGer0079:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Danke, B", uuml, "rgermeister. Diese beiden hier geh", ouml, "ren", CC_NewLine
	.DB CC_Indent, "zu mir.", CC_End

STR_DialogGer0080:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Fr", auml, "ulein Lilac Pondicherry ... Ich bin entz", uuml, "ckt.", CC_End

STR_DialogGer0081:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, CC_Selection, "Wirklich?", CC_NewLine
	.DB CC_Indent, CC_Selection, "Und was ist mit mir?", CC_End

STR_DialogGer0082:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Im Namen aller Bewohner unseres Dorfes Furlorn", CC_NewLine
	.DB CC_Indent, "danke ich Ihnen daf", uuml, "r, dass Sie uns Ihre", CC_NewLine
	.DB CC_Indent, "Unterst", uuml, "tzung anbieten, Sir Greyfur.", CC_End

STR_DialogGer0083:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Einfach Primus, wenn es recht ist.", CC_End

STR_DialogGer0084:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Ja, nat", uuml, "rlich ... Sir Greyfur, wie Sie wahrscheinlich", CC_NewLine
	.DB CC_Indent, "wissen, erwartet denjenigen, der uns dieser", CC_NewLine
	.DB CC_Indent, "schrecklichen Bedrohung entledigt, ewiger Ruhm ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "... zumal sie unser Dorf betrifft, seit Sie hier", CC_NewLine
	.DB CC_Indent, "eingetroffen sind.", CC_End

STR_DialogGer0085:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Ja, ich ... Moment, wie war das? Nur Ruhm? Kein Gold?", CC_End

STR_DialogGer0086:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Seien Sie unbesorgt. Nat", uuml, "rlich werden Sie in jeder", CC_NewLine
	.DB CC_Indent, "erdenklichen Form zeitnah und gro", szlig, "z", uuml, "gig entlohnt", CC_NewLine
	.DB CC_Indent, "werden. Darauf gebe ich Ihnen mein Wort.", CC_End

STR_DialogGer0087:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Verstanden.", CC_End

STR_DialogGer0088:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Dann ist es also abgemacht.", CC_ClearTextBox
; --------------------------------------------------------------------------------

STR_DialogGer0089:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GEISSENB", Uuml, "RGERMEISTER:", CC_NewLine
	.DB CC_Indent, "Reden Sie unbedingt mit allen Dorfbewohnern. Irgend", CC_NewLine
	.DB CC_Indent, "jemand unter uns muss einen Hinweis darauf haben,", CC_NewLine
	.DB CC_Indent, "wo Sie am besten anfangen zu suchen. Viel Gl", uuml, "ck!", CC_End

STR_DialogGer0090:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Das war's dann mit meinem Extrastapel Feuerholz.", CC_NewLine
	.DB CC_Indent, "Lily, wir m", uuml, "ssen mal reden, du und ich.", CC_End

STR_DialogGer0091:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Denk doch an das Gold! Damit kannst du dir Feuerholz", CC_NewLine
	.DB CC_Indent, "kaufen, so viel du willst, oder etwa nicht?", CC_End

STR_DialogGer0092:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oh. Stimmt ...", CC_NewLine
	.DB CC_Indent, "Aber warum dann das ganze Theater?", CC_End

STR_DialogGer0093:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Entschuldige, Alec ... Du wolltest doch fr", uuml, "h wieder zu", CC_NewLine
	.DB CC_Indent, "Hause sein. Ich f", uuml, "rchte, es k", ouml, "nnte doch sp", auml, "ter", CC_NewLine
	.DB CC_Indent, "werden.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Trotzdem, ich kenn' dich doch. Ich wusste, du w", uuml, "rdest", CC_NewLine
	.DB CC_Indent, "mir noch danken, dass ich dir einen Impuls gab, deine", CC_NewLine
	.DB CC_Indent, "H", ouml, "hle zu verlassen, und ...", CC_End

STR_DialogGer0094:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Wenn ich kurz unterbrechen darf ... Seid ihr zwei", CC_NewLine
	.DB CC_Indent, "verwandt?", CC_End

STR_DialogGer0095:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "N", ouml, ", wir sind nat", uuml, "rlich ein Paar.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Sie hat mir mal Lesen und Schreiben beigebracht ...", CC_End

STR_DialogGer0096:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "In Ordnung ...", CC_End

STR_DialogGer0097:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Dem B", uuml, "rgermeister zufolge sollen wir mit allen", CC_NewLine
	.DB CC_Indent, "Dorfbewohnern sprechen. Auf geht's!", CC_End

STR_DialogGer0098:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "GORILLA 1:", CC_NewLine
	.DB CC_Indent, "G'day, mate.", CC_NewLine
	.DB CC_Indent, "Very pleased ter meetcha, me is ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxEvil
	.DB CC_Indent, "... 'cuz me main hobby is turning lions into", CC_NewLine
	.DB CC_Indent, "sausage!", CC_NewLine
	.DB CC_Indent, "Oh, me name's Joe. Joe Lion-Trapper ...", CC_End

STR_DialogGer0099:
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

STR_DialogGer0100:
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

STR_DialogGer0101:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Kleiner Tipp, ihr drei Affen ...", CC_NewLine
	.DB CC_Indent, "I won't be flayed by any Tom, Dick or Harry!", CC_End

STR_DialogGer0102:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Tja, ich nehme alles zur", uuml, "ck.", CC_NewLine
	.DB CC_Indent, "Ich hatte nicht den leisesten Schimmer, dass", CC_NewLine
	.DB CC_Indent, "Wildschwein-Rostbraten SO lecker schmeckt.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxPink
	.DB CC_Indent, "Danke, Alec! ", SYM_heart, CC_End

STR_DialogGer0103:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Schmeckt wirklich gut ...", CC_NewLine
	.DB CC_Indent, "*schn", uuml, "ffel*", CC_NewLine
	.DB CC_Indent, "... aber ist ganz sicher kein Wildschweinbraten.", CC_End

STR_DialogGer0104:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Schleck! ", SYM_heart, CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Ich wusste gar nicht, dass frische Primatenleber", CC_NewLine
	.DB CC_Indent, "ein bisschen wie R", auml, "ucherschinken schmeckt ...!", CC_End

STR_DialogGer0105:
	.DB CC_Portrait, 2, CC_BoxAlert
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "W...was?", CC_NewLine
	.DB CC_Indent, "Soll das hei", szlig, "en, ich esse hier gerade ...", CC_NewLine
	.DB CC_Indent, "... die sterblichen ", Uuml, "berreste ...", CC_End

STR_DialogGer0106:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "... von drei streits", uuml, "chtigen Gorillas?", CC_NewLine
	.DB CC_Indent, "Hehe ... Wer wei", szlig, "!?", CC_End

STR_DialogGer0107:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Alec, du ... du ... *schnief*", CC_End

STR_DialogGer0108:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sag ihr mal die Wahrheit, ja?", CC_End

STR_DialogGer0109:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Welche? Dass wir in Wirklichkeit gerade", CC_NewLine
	.DB CC_Indent, "Hirschragout gefuttert haben?", CC_End

STR_DialogGer0110:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Nein, Leonido.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Sag ihr, dass du nicht auch in sie verliebt bist.", CC_End

STR_DialogGer0111:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Das geht dich ", uuml, "berhaupt nichts an.", CC_End

STR_DialogGer0112:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Wie auch immer, ich geh jetzt schlafen.", CC_End

STR_DialogGer0113:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wie auch immer, worauf wartest du noch?", CC_End

STR_DialogGer0114:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Jetzt wo er weg ist ...", CC_NewLine
	.DB CC_Selection, CC_Indent, "(... schleich' ich mich an und kitzel ihn durch! ", SYM_heart, ")", CC_NewLine
	.DB CC_Selection, CC_Indent, "(... stelle ich mich lieber mit Lily wieder gut.)", CC_End

STR_DialogGer0115:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Da ist sie ja ...", CC_End

STR_DialogGer0116:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "H", ouml, "r mal, ", auml, "hm ... Ich hab nur Spa", szlig, " gemacht.", CC_End

STR_DialogGer0117:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ja, ich wei", szlig, ".", CC_End

STR_DialogGer0118:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was?", CC_End

STR_DialogGer0119:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wir kennen uns von Welpenpfoten an. In all den", CC_NewLine
	.DB CC_Indent, "Jahren hast du mich nicht ein einziges Mal in", CC_NewLine
	.DB CC_Indent, "Verlegenheit gebracht ...", CC_End

STR_DialogGer0120:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ich ... echt nicht?", CC_End

STR_DialogGer0121:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ehrenwort.", CC_End

STR_DialogGer0122:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Na, dann seh' ich lieber zu, dass das so bleibt.", CC_End

STR_DialogGer0123:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "K", ouml, "nntest du ... Also, w", uuml, "rdest du uns morgen", CC_NewLine
	.DB CC_Indent, "dein Lieblingsessen machen?", CC_NewLine
	.DB CC_Indent, "Ich meine ... bitte?", CC_End

STR_DialogGer0124:
	.DB CC_Portrait, 2, CC_BoxPink
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oh, Alec ... Du bist so lieb. ", SYM_heart, CC_End

STR_DialogGer0125:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Da bist du ja.", CC_End

STR_DialogGer0126:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wie hast du mich ...?", CC_End

STR_DialogGer0127:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Heh. Du bist nicht der Einzige hier, der", CC_NewLine
	.DB CC_Indent, "eine feine Nase hat.", CC_End

STR_DialogGer0128:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ein sch", ouml, "nes Pl", auml, "tzchen zum Schlafen hast du da", CC_NewLine
	.DB CC_Indent, "gefunden. Was dagegen, wenn ich mich zu dir", CC_NewLine
	.DB CC_Indent, "geselle?", CC_End

STR_DialogGer0129:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Ich habe etwas dagegen, falls du schnarchst.", CC_End

STR_DialogGer0130:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Keine Sorge, Kumpel.", CC_End

STR_DialogGer0131:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Dann also ...", CC_End

STR_DialogGer0132:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Was ist noch?", CC_End

STR_DialogGer0133:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Gute Nacht, Primus. Schlaf gut.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Wie deine Ohren im Mondlicht schimmern ...", CC_End

STR_DialogGer0134:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Gute Nacht, Leonido.", CC_End

STR_DialogGer0135:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogGer0136:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Du auch, Alec.", CC_End

STR_DialogGer0137:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "*G", auml, auml, auml, auml, "hn*", CC_End

STR_DialogGer0138:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "H", ouml, "h!? Was ist das?", CC_End

STR_DialogGer0139:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Pastinakensuppe. Lily steht da total drauf.", CC_NewLine
	.DB CC_Indent, "Einfach Nase zuhalten und ausl", ouml, "ffeln.", CC_End

STR_DialogGer0140:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "*murmel* *schmecktjawiefuchsenpisse* *grummel*", CC_End

STR_DialogGer0141:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Pst, sei blo", szlig, " still!", CC_End

STR_DialogGer0142:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Oje ...", CC_NewLine
	.DB CC_Indent, "Wie's aussieht, sitzen wir hier erst mal fest.", CC_End

STR_DialogGer0143:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Keine Sorge. Ich r", auml, "um' das Ger", uuml, "mpel hier weg,", CC_NewLine
	.DB CC_Indent, "und schon k", ouml, "nnen wir wieder verschwinden.", CC_End

STR_DialogGer0144:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Warte mal!", CC_End

STR_DialogGer0145:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Was ist los?", CC_End

STR_DialogGer0146:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wo wir schon hier sind, k", ouml, "nnten wir uns", CC_NewLine
	.DB CC_Indent, "mal umsehen, meinst du nicht?", CC_End

STR_DialogGer0147:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Sie hat recht, Leonido.", CC_NewLine
	.DB CC_Indent, "Meine Nase sagt mir, dass dieser Ort nicht ganz", CC_NewLine
	.DB CC_Indent, "fuchsenrein ist ...", CC_End

STR_DialogGer0148:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "...", CC_End

STR_DialogGer0149:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Also? Was tun wir?", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Schleunigst abhauen!)", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Bleiben und mal umschauen)", CC_End

STR_DialogGer0150:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Hier war seit Ewigkeiten keiner mehr.", CC_End

STR_DialogGer0151:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Eine Puppe in Gestalt eines Fenneks.", CC_NewLine
	.DB CC_Indent, "Allerdings fehlen ihr die Augen.", CC_End

STR_DialogGer0152:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Ein unheimlicher Ort.", CC_NewLine
	.DB CC_Indent, "Langsam denke ich, wir h", auml, "tten lieber doch nicht", CC_NewLine
	.DB CC_Indent, "herkommen sollen ...", CC_End

STR_DialogGer0153:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "FENNEK-PUPPE:", CC_NewLine
	.DB CC_Indent, "Ich kann dich nicht sehen ...", CC_NewLine
	.DB CC_Indent, "... aber ich h", ouml, "re dein Herz schlagen!", CC_End

STR_DialogGer0154:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Achtung! Weiterer Feind im Anmarsch!", CC_End

STR_DialogGer0155:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MELODISCHE STIMME:", CC_NewLine
	.DB CC_Indent, "Ich habe keine b", ouml, "sen Absichten ...", CC_End

STR_DialogGer0156:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER FUCHS:", CC_NewLine
	.DB CC_Indent, "Ihr habt tapfer gek", auml, "mpft.", CC_NewLine
	.DB CC_Indent, "Wer seid ihr?", CC_End

STR_DialogGer0157:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Ich bin Alec, und das sind meine Freunde.", CC_NewLine
	.DB CC_Selection, CC_Indent, "Dasselbe m", ouml, "chte ich dich fragen, Rotpelz!", CC_NewLine
	.DB CC_Selection, CC_Indent, "(Stattdessen Lily antworten lassen)", CC_End

STR_DialogGer0158:
	.DB CC_Portrait, 2, CC_BoxAlert
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Warum habt ihr uns angegriffen?", CC_End

STR_DialogGer0159:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER FUCHS:", CC_NewLine
	.DB CC_Indent, "Ich wollte euch kein Leid zuf", uuml, "gen, und das gilt auch", CC_NewLine
	.DB CC_Indent, "f", uuml, "r Dorothy.", CC_End

STR_DialogGer0160:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER FUCHS:", CC_NewLine
	.DB CC_Indent, "Willkommen in meinem Bau, Alec.", CC_End

STR_DialogGer0161:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER FUCHS:", CC_NewLine
	.DB CC_Indent, "Es tut mir aufrichtig leid, dass ich so unh", ouml, "flich", CC_NewLine
	.DB CC_Indent, "gewesen bin.", CC_End

STR_DialogGer0162:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FREMDER FUCHS:", CC_NewLine
	.DB CC_Indent, "Mein Name ist Reinhold von Pappenheim. Ich bin", CC_NewLine
	.DB CC_Indent, "Bauchredner von Beruf. Ich entschuldige mich", CC_NewLine
	.DB CC_Indent, "daf", uuml, "r, euch ge", auml, "ngstigt zu haben ...", CC_End

STR_DialogGer0163:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "REINHOLD:", CC_NewLine
	.DB CC_Indent, "Ich wollte euch kein Leid zuf", uuml, "gen, und das gilt auch", CC_NewLine
	.DB CC_Indent, "f", uuml, "r Dorothy.", CC_End

STR_DialogGer0164:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Schon mal zuf", auml, "lligerweise im Dorf Furlorn gewesen?", CC_End


STR_DialogGer0165:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "War er definitiv. Habt ihr nicht auch diesen Duft", CC_NewLine
	.DB CC_Indent, "von R", auml, "ucherwurst in der Nase, wie sie Tusker abhanden", CC_NewLine
	.DB CC_Indent, "gekommen ist?", CC_End

STR_DialogGer0166:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "REINHOLD:", CC_NewLine
	.DB CC_Indent, "Ich gestehe ein, dass ich aus D", ouml, "rfern in der N", auml, "he", CC_NewLine
	.DB CC_Indent, "Nahrung stibitzt habe. Hier drau", szlig, "en in der Wildnis", CC_NewLine
	.DB CC_Indent, "gibt es nichts zu essen.", CC_End

STR_DialogGer0167:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Da haben wir also unseren ,,Geist\".", CC_End

STR_DialogGer0168:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Nichts zu essen, sagst du? Aber die W", auml, "lder in dieser", CC_NewLine
	.DB CC_Indent, "Gegend sind voller Beute!", CC_End

STR_DialogGer0169:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "DOROTHY:", CC_NewLine
	.DB CC_Indent, "Er ist kein J", auml, "ger, wisst ihr. Und kein Sammler. Er ist nur", CC_NewLine
	.DB CC_Indent, "ein Bauernf", auml, "nger. Ein Trickbetr", uuml, "ger, wenn man so will.", CC_NewLine
	.DB CC_Indent, "Ohne zu klauen w", auml, "re er in kurzer Zeit verhungert.", CC_End

STR_DialogGer0170:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Halt mal! Wieso kann dieses Ding eigentlich sprechen!?", CC_End

STR_DialogGer0171:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Lass dich nicht von ihm reinlegen. Ein Bauchredner", CC_NewLine
	.DB CC_Indent, "kann sprechen, ohne den Mund zu bewegen.", CC_End

STR_DialogGer0172:
	.DB CC_Portrait, 0, CC_BoxPink
	.DB "DOROTHY:", CC_NewLine
	.DB CC_Indent, "Stimmt genau. ", SYM_heart, CC_End

STR_DialogGer0173:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, CC_Selection, "Krallenstark!", CC_NewLine
	.DB CC_Indent, CC_Selection, "Das ist ... gruselig.", CC_End

STR_DialogGer0174:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Leute, eins kapier' ich nicht. Mit solchen Tricks", CC_NewLine
	.DB CC_Indent, "k", ouml, "nnte man doch in jeder gr", ouml, szlig, "eren Stadt ein", CC_NewLine
	.DB CC_Indent, "Verm", ouml, "gen als Stra", szlig, "enk", uuml, "nstler verdienen.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Stattdessen lebst du hier drau", szlig, "en, ganz im Geheimen.", CC_NewLine
	.DB CC_Indent, "Es erscheint mir fast so, als ob du dich vor", CC_NewLine
	.DB CC_Indent, "irgendwem versteckst.", CC_End

STR_DialogGer0175:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Bleib sofort stehen, du kleiner Bastard!", CC_End

STR_DialogGer0176:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FUCHSENWELPE:", CC_NewLine
	.DB CC_Indent, "Wr", auml, "ffs! Ich h", auml, "ng' fest!!", CC_End

STR_DialogGer0177:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Hab ich dich endlich!", CC_End

STR_DialogGer0178:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Also nochmal, WO IST MEINE MAHLZEIT?", CC_End

STR_DialogGer0179:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "FUCHSENWELPE:", CC_NewLine
	.DB CC_Indent, "Echt jetzt, keine Ahnung!", CC_End

STR_DialogGer0180:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Wer's glaubt!? Pass auf, wenn du mir nicht SOFORT", CC_NewLine
	.DB CC_Indent, "Antwort gibst, mach ich dir einen Knoten in den", CC_NewLine
	.DB CC_Indent, "Schwanz! Kapiert?", CC_End

STR_DialogGer0181:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "FUCHSENWELPE:", CC_NewLine
	.DB CC_Indent, "Hiiiilfe!!", CC_NewLine
	.DB CC_Indent, "*quiek*", CC_End

STR_DialogGer0182:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Wir sollten dem Kleinen helfen!", CC_End

STR_DialogGer0183:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Unbedingt!", CC_End

STR_DialogGer0184:
	.DB CC_Portrait, 0, CC_BoxRed
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "H", auml, "h?", CC_NewLine
	.DB CC_Indent, "Was f", uuml, "r r", auml, "udige Schakale seid ihr?", CC_End

STR_DialogGer0185:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "*Keuch, schnauf*", CC_NewLine
	.DB CC_Indent, "Deppen! Ihr seid schuld, dass der kleine Dieb fliehen", CC_NewLine
	.DB CC_Indent, "konnte.", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Ich h", auml, "tte ihn verm", ouml, "beln sollen, solange ich", CC_NewLine
	.DB CC_Indent, "Gelegenheit hatte!", CC_End

STR_DialogGer0186:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "PRIMUS:", CC_NewLine
	.DB CC_Indent, "Moment mal ... Hat er dir was gestohlen?", CC_End

STR_DialogGer0187:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Ja, verdammt! Fressalien! EIER!!", CC_End

STR_DialogGer0188:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Oha ... Das klingt nicht gut.", CC_End

STR_DialogGer0189:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Entschuldige das Missverst", auml, "ndnis. Wir nahmen an ...", CC_End

STR_DialogGer0190:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Mir doch schnuppe!", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_BoxBlue
	.DB CC_Indent, "Meine Eier sind weg, darum geht's!", CC_NewLine
	.DB CC_Indent, "Waren "uuml, "brigens Fasaneneier. Sehr nahrhaft.", CC_NewLine
	.DB CC_Indent, "Und jetzt sind sie EINFACH WEG!", CC_End

STR_DialogGer0191:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Als J", auml, "ger wei", szlig, " ich, wo Fasane br", uuml, "ten.", CC_NewLine
	.DB CC_Indent, "Ich kann dir helfen, frischen Ersatz zu besorgen.", CC_End

STR_DialogGer0192:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Wirklich?", CC_End

STR_DialogGer0193:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Ja doch.", CC_End

STR_DialogGer0194:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Warum willst du das f", uuml, "r mich tun?", CC_End

STR_DialogGer0195:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Wir schulden dir immerhin was.", CC_NewLine						; skip 0187, 0189
	.DB CC_Selection, CC_Indent, "Ich g", ouml, "nn' dir was Leckeres zum Aufschl", uuml, "rfen. ", SYM_heart, CC_NewLine	; skip 0187, 0188
	.DB CC_Selection, CC_Indent, "(Stattdessen Lily antworten lassen)", CC_End							; skip 0189

STR_DialogGer0196:
	.DB CC_Portrait, 2, CC_BoxBlue
	.DB "LILY:", CC_NewLine
	.DB CC_Indent, "Alec hat recht. Schlie", szlig, "lich sind wir schuld an", CC_NewLine
	.DB CC_Indent, "deinem Verlust und daher verpflichtet, dir Ersatz", CC_NewLine
	.DB CC_Indent, "zu beschaffen.", CC_End

STR_DialogGer0197:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Stimmt. Also gehen wir.", CC_End

STR_DialogGer0198:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "Werd' ich, verlass dich drauf. ", SYM_heart, CC_NewLine
	.DB CC_Indent, "Joa, dann los.", CC_End

STR_DialogGer0199:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Indent, "Wie hei", szlig, "t du eigentlich?", CC_End

STR_DialogGer0200:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "MUSKELPARDE:", CC_NewLine
	.DB CC_Indent, "...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Nennt mich Mickey.", CC_End

STR_DialogGer0201:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "ALEC:", CC_NewLine
	.DB CC_Selection, CC_Indent, "Ich bin Alec, und das sind meine Freunde.", CC_NewLine		; only affect sympathy levels
	.DB CC_Selection, CC_Indent, "Nenn mich Leonido. ", SYM_heart, CC_End

STR_DialogGer0202:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "BRAUNB", Auml, "R:", CC_NewLine
	.DB CC_Indent, "Habe die Ehre. ", Auml, "hem ...", CC_ClearTextBox
; --------------------------------------------------------------------------------
	.DB CC_Indent, "Mein Name ist Gregory Perpetuus Ebenezer", CC_NewLine
	.DB CC_Indent, "Hrabanus Eindhoven Dubois Quaoar van der", CC_NewLine
	.DB CC_Indent, "Muhlhausen Nido sulle Colline ... Junior.", CC_End

STR_DialogGer0203:
	.DB CC_Portrait, 0, CC_BoxAlert
	.DB "TARA:", CC_NewLine
	.DB CC_Indent, "Nimm ja deine Pfote von mir!", CC_End

/*
STR_DialogGer0204:
	.DB CC_Portrait, 0, CC_BoxBlue
	.DB "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_NewLine
	.DB CC_Indent, "", CC_End
*/



; ******************************** EOF *********************************
