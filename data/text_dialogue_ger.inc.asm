;==========================================================================================
;
;   "FURRY RPG" (WORKING TITLE)
;   (c) 2023 by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	*** DIALOGUE STRINGS (GERMAN) ***
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



; ************************** German Dialogue ***************************

STR_DialogGer0000:
	.STRINGMAP ctrl, "<PORTRAIT>$02<BG>$01"
	.STRINGMAP diag, "JÖRG BÄCKT QUASI ZWEI HAXENFÜSSE VOM WILDPONY.<NL>"
	.STRINGMAP diag, "jörg bäckt quasi zwei haxenfüße vom wildpony.<NL>"
	.STRINGMAP diag, "0123456789 ÄÖÜäëïöüß <B>Fetter Text<B><NL>"
	.STRINGMAP diag, "!“#$%&’()*+,-./:;<=>?@[\]^_`{|}~♥×♫<END>"

STR_DialogGer0001:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Uff, was für ein Traum!<CLR>"

	.STRINGMAP diag, "<IND>Ich habe die Fährte eines seltenen Mähnen-<NL>"
	.STRINGMAP diag, "<IND>Schneeleoparden verfolgt. Als ich ihn stellte,<NL>"
	.STRINGMAP diag, "<IND>hat er sich umgedreht und zu mir gesprochen ...<CLR>"

	.STRINGMAP diag, "<IND>Ich weiß nicht mehr, was er sagte, nur<NL>"
	.STRINGMAP diag, "<IND>dass es mich total mitgenommen hat.<END>"

STR_DialogGer0002:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Puh! Zum Glück war’s nur ein Traum.<CLR>"

	.STRINGMAP diag, "<IND>Warum führ’ ich eigentlich Selbstgespräche?<NL>"
	.STRINGMAP diag, "<IND>Ich sollte mich an die Arbeit machen!<END>"

STR_DialogGer0003:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Das ist mein Haus.<END>"

STR_DialogGer0004:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Meine Feuerstelle.<NL>"
	.STRINGMAP diag, "<IND>Vielleicht sollte ich heute noch etwas Feuerholz<NL>"
	.STRINGMAP diag, "<IND>sammeln ...<END>"

STR_DialogGer0005:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Lecker, das Zeug. ♥<END>"

STR_DialogGer0006:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Mein ganzes Feuerholz. Reicht aber noch nicht.<END>"

STR_DialogGer0007:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Was in aller ...!?<END>"

STR_DialogGer0008:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "TIGERFRAU:<NL>"
	.STRINGMAP diag, "<IND>Kein Wunder, wenn du deine Deckung<NL>"
	.STRINGMAP diag, "<IND>aufgibst ...<END>"

STR_DialogGer0009:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Och, hör doch auf, Lily.<END>"

STR_DialogGer0010:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Tschuldige, Alec. Ich konnte einfach nicht<NL>"
	.STRINGMAP diag, "<IND>widerstehen. ♥<END>"

STR_DialogGer0011:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Was willst du?<END>"

STR_DialogGer0012:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Sei nicht so schroff, ja!<NL>"
	.STRINGMAP diag, "<IND>Ich hab dir ein bisschen Milch mitgebracht.<END>"

STR_DialogGer0013:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Wozu das denn?<END>"

STR_DialogGer0014:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Nun frag doch nicht dauernd so dummes Zeug,<NL>"
	.STRINGMAP diag, "<IND>sondern koste lieber mal.<END>"

STR_DialogGer0015:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Na gut, okay. Aber nur dir zuliebe.<END>"

STR_DialogGer0016:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Urgs ...<END>"

STR_DialogGer0017:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Die ist einfach köstlich, oder?<END>"

STR_DialogGer0018:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ähmmmmm ...<NL>"
	.STRINGMAP diag, "<SEL><IND>Na ja, wie gesagt, ist halt bloß Milch.<NL>"
	.STRINGMAP diag, "<SEL><IND>Igitt. Was gibt’s als nächstes, Pastinakensuppe?<END>"

STR_DialogGer0019:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Ich wusste doch, dass du begeistert sein<NL>"
	.STRINGMAP diag, "<IND>würdest. ♥<END>"

STR_DialogGer0020:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Tut mir leid, Alec. Ich wollte dich nicht<NL>"
	.STRINGMAP diag, "<IND>ärgern.<END>"

STR_DialogGer0021:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Sorry ...<END>"

STR_DialogGer0022:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Keine Sorge, ist schon okay. ♥<END>"

STR_DialogGer0023:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Aber bestimmt bist du nicht nur hergekommen,<NL>"
	.STRINGMAP diag, "<IND>um mir Milch zu liefern, oder?<END>"

STR_DialogGer0024:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Stimmt, bin ich nicht.<CLR>"

	.STRINGMAP ctrl, "<BG>$05"
	.STRINGMAP diag, "<IND>Das Schicksal der ganzen Welt hängt nur<NL>"
	.STRINGMAP diag, "<IND>von dir ab!<END>"

STR_DialogGer0025:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Tihi, jetzt solltest du mal dein Gesicht<NL>"
	.STRINGMAP diag, "<IND>sehen ... ♥<END>"

STR_DialogGer0026:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Für ’ne Sekunde hab’ ich echt geglaubt ...<END>"

STR_DialogGer0027:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Nee, aber du wirst Augen machen, wenn du erst<NL>"
	.STRINGMAP diag, "<IND>mal das hier hörst ...<CLR>"

	.STRINGMAP diag, "<IND>Der Bürgermeister verspricht demjenigen eine<NL>"
	.STRINGMAP diag, "<IND>Belohnung, der rausfindet, was es mit diesem<NL>"
	.STRINGMAP diag, "<IND>,,Geist“ auf sich hat, von dem alle reden. Ich hab<NL>"
	.STRINGMAP diag, "<IND>dir doch davon erzählt, weißt du noch?<END>"

STR_DialogGer0028:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Na klar!<NL>"
	.STRINGMAP diag, "<SEL><IND>Keine Ahnung, was du meinst!<NL>"
	.STRINGMAP diag, "<SEL><IND>Hilf mir mal auf die Sprünge ...<END>"

STR_DialogGer0029:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Nicht nur du. Tusker hat neulich erzählt, aus<NL>"
	.STRINGMAP diag, "<IND>der Vorratskammer seiner Schänke sei ein<NL>"
	.STRINGMAP diag, "<IND>Dutzend Ringe Dauerwurst geklaut worden.<END>"

STR_DialogGer0030:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Du lebst aber auch echt hinter dem Mond!<END>"

STR_DialogGer0031:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>...<CLR>"

	.STRINGMAP diag, "<IND>Hab mich halt um meinen eigenen Kram gekümmert.<END>"

STR_DialogGer0032:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Also gut. Um es kurz zu machen, in letzter Zeit<NL>"
	.STRINGMAP diag, "<IND>verschwinden ständig spurlos irgendwelche Sachen.<CLR>"

	.STRINGMAP diag, "<IND>Dauerwurst verschwindet aus den Vorratskammern,<NL>"
	.STRINGMAP diag, "<IND>Wäsche und Schuhe sind abhandengekommen, und<NL>"
	.STRINGMAP diag, "<IND>sogar Werkzeuge und Angelruten lösen sich in Luft auf,<NL>"
	.STRINGMAP diag, "<IND>wenn kurz niemand hinschaut.<CLR>"

@Jump01:
	.STRINGMAP diag, "<IND>Der Kleine meiner Fuchsennachbarn behauptet<NL>"
	.STRINGMAP diag, "<IND>sogar, er hätte den ,,Geist“, der dafür verantwortlich<NL>"
	.STRINGMAP diag, "<IND>ist, mit seinen eigenen Augen gesehen ...<END>"

STR_DialogGer0033:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Abgesehen von Tuskers verschwundenen Würsten<NL>"
	.STRINGMAP diag, "<IND>sind im Dorf in letzter Zeit noch mehr komische<NL>"
	.STRINGMAP diag, "<IND>Sachen passiert.<CLR>"

	.STRINGMAP ctrl, "<JMP>"
	.DL STR_DialogGer0032@Jump01

STR_DialogGer0034:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Mit wessen Augen hätte er ihn auch sonst sehen<NL>"
	.STRINGMAP diag, "<IND>sollen?<END>"

STR_DialogGer0035:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Genau das hab ich meinen Nachbarn auch gesagt.<NL>"
	.STRINGMAP diag, "<IND>Aber die sind mittlerweile alle drei zu Tode<NL>"
	.STRINGMAP diag, "<IND>verängstigt.<CLR>"

	.STRINGMAP diag, "<IND>Sogar Tusker, eigentlich ein vernünftiger Kerl,<NL>"
	.STRINGMAP diag, "<IND>glaubt mittlerweile lieber an übernatürliche<NL>"
	.STRINGMAP diag, "<IND>Kräfte. Mit evidenzbasierter Wissenschaft kommst<NL>"
	.STRINGMAP diag, "<IND>du bei niemandem mehr weit. Also dachte ich ...<END>"

STR_DialogGer0036:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>... ein Profi-Jäger könnte dir da behilflich<NL>"
	.STRINGMAP diag, "<IND>sein?<END>"

STR_DialogGer0037:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Nicht irgendeiner, versteht sich. ♥<END>"

STR_DialogGer0038:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Worin besteht die Belohnung?<NL>"
	.STRINGMAP diag, "<SEL><IND>Allzeit bereit für die Geisterjagd!<END>"

STR_DialogGer0039:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Willst du denn gar nicht wissen, worin die Belohnung<NL>"
	.STRINGMAP diag, "<IND>des Bürgermeisters besteht?<END>"

STR_DialogGer0040:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Hm? Was ist es denn?<END>"

STR_DialogGer0041:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Ein Haufen Gold, jede Menge Naturalien und<NL>"
	.STRINGMAP diag, "<IND>ewiger Ruhm, hab ich gehört.<END>"

STR_DialogGer0042:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Gold brauch’ ich nicht. Das mit dem Ruhm klingt<NL>"
	.STRINGMAP diag, "<IND>ganz in Ordnung. Schade, dass kein Feuerholz<NL>"
	.STRINGMAP diag, "<IND>dabei ist ...<END>"

STR_DialogGer0043:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Oh, ist es aber ... hab ich doch glatt vergessen<NL>"
	.STRINGMAP diag, "<IND>zu sagen! Drei Ster Feuerholz. Mindestens. Das<NL>"
	.STRINGMAP diag, "<IND>ist eigentlich sogar der Hauptpreis!<END>"

STR_DialogGer0044:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Also los, worauf warten wir noch?<NL>"
	.STRINGMAP diag, "<IND>Schließlich will ich heute früh am Abend<NL>"
	.STRINGMAP diag, "<IND>wieder zu Hause sein!<END>"

STR_DialogGer0045:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Klar doch. ♥<CLR>"

	.STRINGMAP ctrl, "<BG>$01"
	.STRINGMAP diag, "<IND>Übrigens, ich kenne jemanden, der uns helfen<NL>"
	.STRINGMAP diag, "<IND>kann. Bevor wir den Bürgermeister besuchen,<NL>"
	.STRINGMAP diag, "<IND>sollten wir mit ihm sprechen.<END>"

STR_DialogGer0046:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "<NL><IND><IND><IND><IND><1> schließt sich der Gruppe an!<END>"

STR_DialogGer0047:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Da sind wir endlich.<NL>"
	.STRINGMAP diag, "<IND>Ach du liebes Bisschen ...<END>"

STR_DialogGer0048:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Stimmt was nicht?<END>"

STR_DialogGer0049:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Ich hab völlig vergessen, meinem Onkel Bescheid zu<NL>"
	.STRINGMAP diag, "<IND>sagen, dass ich eine Weile weg sein werde. Treffen<NL>"
	.STRINGMAP diag, "<IND>wir uns doch nachher in Tuskers Schänke, okay?<END>"

STR_DialogGer0050:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ich geh auch gern mit dir mit!<END>"

STR_DialogGer0051:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Das ist echt nett von dir, Alec. ♥<CLR>"

	.STRINGMAP ctrl, "<BG>$01"
	.STRINGMAP diag, "<IND>... Aber du weißt ja, mein Onkel ist ein bisschen senil.<NL>"
	.STRINGMAP diag, "<IND>In seinem Zustand will er lieber keinen Besuch von<NL>"
	.STRINGMAP diag, "<IND>Fremden.<END>"

STR_DialogGer0052:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Okay. Dann bis später.<END>"

STR_DialogGer0053:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "<NL><IND><IND><IND><IND><IND><IND><1> verlässt die Gruppe!<END>"

STR_DialogGer0054:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER WOLF:<NL>"
	.STRINGMAP diag, "<IND>Hey-ho, Leonido ...<NL>"
	.STRINGMAP diag, "<IND>Für einen von deiner Sorte bist du aber ziemlich<NL>"
	.STRINGMAP diag, "<IND>klein. Du bist nicht zufällig ein Jäger, oder?<END>"

STR_DialogGer0055:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Nenn mich nicht ,,Leonido“!<END>"

STR_DialogGer0056:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "FREMDER WOLF:<NL>"
	.STRINGMAP diag, "<IND>Okay-o, Leonido ...<END>"

STR_DialogGer0057:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Hey-ho, Leonido ...<END>"

STR_DialogGer0058:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Was MACHT ihr zwei denn da!?<END>"

STR_DialogGer0059:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Argh ... KERLE!<NL>"
	.STRINGMAP diag, "<IND>Entweder sie kabbeln sich oder ...<END>"

STR_DialogGer0060:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Oder was?<END>"

STR_DialogGer0061:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER WOLF:<NL>"
	.STRINGMAP diag, "<IND>Ich bin Soldat. Mich mit anderen zu kabbeln<NL>"
	.STRINGMAP diag, "<IND>ist mein Beruf.<END>"

STR_DialogGer0062:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Aber das hier ist der Typ, der dir bei deiner<NL>"
	.STRINGMAP diag, "<IND>Mission am ehesten helfen kann, wie gesagt!<END>"

STR_DialogGer0063:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFENSOLDAT:<NL>"
	.STRINGMAP diag, "<IND>Aha, du bist also Alec Marlowe, der Jäger?<NL>"
	.STRINGMAP diag, "<IND>Dann muss ich mich entschuldigen. Freut mich,<NL>"
	.STRINGMAP diag, "<IND>dich kennenzulernen.<END>"

STR_DialogGer0064:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Was sollte das alles?<END>"

STR_DialogGer0065:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Kleiner Tipp für’s nächste Mal ...<NL>"
	.STRINGMAP diag, "<IND>Erst fragen, wen du vor dir hast, bevor du<NL>"
	.STRINGMAP diag, "<IND>wildfremde Furros anschnauzt!<END>"

STR_DialogGer0066:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFENSOLDAT:<NL>"
	.STRINGMAP diag, "<IND>Das nennst du anschnauzen, ,,Leonido“?<END>"

STR_DialogGer0067:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Schluss damit!<END>"

STR_DialogGer0068:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Nicht ärgern, Alec. Er hat sich ja nur<NL>"
	.STRINGMAP diag, "<IND>selbst zitiert.<END>"

STR_DialogGer0069:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFENSOLDAT:<NL>"
	.STRINGMAP diag, "<IND>Da hörst du’s, ,,Leonido“. Wieder ein<NL>"
	.STRINGMAP diag, "<IND>Zitat, versteht sich ...<CLR>"

	.STRINGMAP diag, "<IND>Übrigens bin ich selber schon oft genug<NL>"
	.STRINGMAP diag, "<IND>,,angeschnauzt“ worden, wenn auch aus anderen<NL>"
	.STRINGMAP diag, "<IND>Gründen.<CLR>"

	.STRINGMAP diag, "<IND>Um ehrlich zu sein, ist mir das völlig schnuppe.<NL>"
	.STRINGMAP diag, "<IND>Seit meiner Welpenzeit hab ich ein dickes Fell ...<END>"

STR_DialogGer0070:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Du bist echt ein Spinner.<END>"

STR_DialogGer0071:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "WOLFENSOLDAT:<NL>"
	.STRINGMAP diag, "<IND>Nein, ich bin Primus Greyfur, zu deinen Diensten.<END>"

STR_DialogGer0072:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Er ist Soldat des Furderal Empire, Alec!<END>"

STR_DialogGer0073:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Na dann ...<NL>"
	.STRINGMAP diag, "<SEL><IND>Was hat dich hierher nach Librefur verschlagen?<NL>"
	.STRINGMAP diag, "<SEL><IND>Du bist also ein Deserteur?<END>"

STR_DialogGer0074:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Wenn ich ein Deserteur bin, dann bist du ein<NL>"
	.STRINGMAP diag, "<IND>Wilderer, Leonido.<END>"

STR_DialogGer0075:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Ich hatte keine Lust mehr auf muffige Baracken<NL>"
	.STRINGMAP diag, "<IND>und besoffene Hauptleute und bin neuerdings<NL>"
	.STRINGMAP diag, "<IND>Freiberufler. Soll heißen, ich arbeite für Geld.<END>"

STR_DialogGer0076:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Klingt nach ziemlich hartem Brot ...<END>"

STR_DialogGer0077:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Zugegeben, manchmal kann es hart sein.<NL>"
	.STRINGMAP diag, "<IND>Aber gerade heute ist es das nicht ...<CLR>"

	.STRINGMAP diag, "<IND>Wenn ihr mich jetzt bitte entschuldigen wollt?<NL>"
	.STRINGMAP diag, "<IND>Ich habe einen Termin beim Bürgermeister. Nur falls ihr<NL>"
	.STRINGMAP diag, "<IND>es ernst meint und mich wirklich auf der Jagd nach dem<NL>"
	.STRINGMAP diag, "<IND>angeblichen Geist begleiten wollt.<END>"

STR_DialogGer0078:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Häh? Augenblick mal ...<CLR>"

	.STRINGMAP diag, "<IND>Lily!<NL>"
	.STRINGMAP diag, "<IND>Das da gerade war doch MEIN Job!<END>"

STR_DialogGer0079:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Und dein Job plus sein Job ergibt unseren Job,<NL>"
	.STRINGMAP diag, "<IND>stimmt’s?<NL>"
	.STRINGMAP diag, "<IND>Also ... Sollen wir langsam aufbrechen?<END>"

STR_DialogGer0080:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "JUGENDLICHE WOLFEN:<NL>"
	.STRINGMAP diag, "<IND>La ♫ di ♫ da ♫<NL>"
	.STRINGMAP diag, "<IND>Ich glaub, dass dieser graufellige Soldat<NL>"
	.STRINGMAP diag, "<IND>mich mag. ♥<END>"

STR_DialogGer0081:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Willkommen zu Ihrem Briefing, Primus Greyfur.<END>"

STR_DialogGer0082:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Danke, Bürgermeister. Diese beiden hier gehören<NL>"
	.STRINGMAP diag, "<IND>zu mir.<END>"

STR_DialogGer0083:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Fräulein Lilac Pondicherry ... Ich bin entzückt.<END>"

STR_DialogGer0084:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Wirklich?<NL>"
	.STRINGMAP diag, "<SEL><IND>Und was ist mit mir?<END>"

STR_DialogGer0085:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Und Alexis Moreflaw, lange nicht gesehen ... Sir Greyfur,<NL>"
	.STRINGMAP diag, "<IND>jede Gefellschaft hat nun einmal ihren eigenen Bajazzo,<NL>"
	.STRINGMAP diag, "<IND>da stellt unser Dorf keine Ausnahme dar.<END>"

STR_DialogGer0086:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ich heiße immer noch ALEC MARLOWE!<NL>"
	.STRINGMAP diag, "<IND>Und was zum Geier ist ein ,,Palazzo“!?<END>"

STR_DialogGer0087:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Pssst ... Mach dir nix draus, Alec.<END>"

STR_DialogGer0088:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Im Namen aller Bewohner unseres Dorfes Furlorn<NL>"
	.STRINGMAP diag, "<IND>danke ich Ihnen dafür, dass Sie uns Ihre<NL>"
	.STRINGMAP diag, "<IND>Unterstützung anbieten, Sir Greyfur.<END>"

STR_DialogGer0089:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Einfach Primus, wenn es recht ist.<END>"

STR_DialogGer0090:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Ja, natürlich ... Sir Greyfur, wie Sie wahrscheinlich<NL>"
	.STRINGMAP diag, "<IND>wissen, erwartet denjenigen, der uns dieser<NL>"
	.STRINGMAP diag, "<IND>schrecklichen Bedrohung entledigt, ewiger Ruhm ...<CLR>"

	.STRINGMAP diag, "<IND>... zumal sie unser Dorf betrifft, seit Sie hier<NL>"
	.STRINGMAP diag, "<IND>eingetroffen sind.<END>"

STR_DialogGer0091:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Ja, ich ... Moment, wie war das? Nur Ruhm? Kein Gold?<END>"

STR_DialogGer0092:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Seien Sie unbesorgt. Natürlich werden Sie in jeder<NL>"
	.STRINGMAP diag, "<IND>erdenklichen Form zeitnah und großzügig entlohnt<NL>"
	.STRINGMAP diag, "<IND>werden. Darauf gebe ich Ihnen mein Wort.<END>"

STR_DialogGer0093:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Verstanden.<END>"

STR_DialogGer0094:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP diag, "<IND>Dann ist es also abgemacht.<CLR>"

@Jump01:
	.STRINGMAP diag, "<IND>Reden Sie unbedingt mit allen Dorfbewohnern. Irgend<NL>"
	.STRINGMAP diag, "<IND>jemand unter uns muss einen Hinweis darauf haben,<NL>"
	.STRINGMAP diag, "<IND>wo Sie am besten anfangen zu suchen. Viel Glück!<END>"

STR_DialogGer0095:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GEISSENBÜRGERMEISTER:<NL>"
	.STRINGMAP ctrl, "<JMP>"
	.DL STR_DialogGer0094@Jump01

STR_DialogGer0096:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Das war’s dann mit meinem Extrastapel Feuerholz.<NL>"
	.STRINGMAP diag, "<IND>Lily, wir müssen mal reden, du und ich.<END>"

STR_DialogGer0097:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Denk doch an das Gold! Damit kannst du dir Feuerholz<NL>"
	.STRINGMAP diag, "<IND>kaufen, so viel du willst, oder etwa nicht?<END>"

STR_DialogGer0098:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Oh. Stimmt ...<NL>"
	.STRINGMAP diag, "<IND>Aber warum dann das ganze Theater?<END>"

STR_DialogGer0099:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Entschuldige, Alec ... Du wolltest doch früh wieder zu<NL>"
	.STRINGMAP diag, "<IND>Hause sein. Ich fürchte, es könnte doch später<NL>"
	.STRINGMAP diag, "<IND>werden.<CLR>"

	.STRINGMAP diag, "<IND>Trotzdem, ich kenn’ dich doch. Ich wusste, du würdest<NL>"
	.STRINGMAP diag, "<IND>mir noch danken, dass ich dir einen Impuls gab, deine<NL>"
	.STRINGMAP diag, "<IND>Höhle zu verlassen, und ...<END>"

STR_DialogGer0100:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Wenn ich kurz unterbrechen darf ... Seid ihr zwei<NL>"
	.STRINGMAP diag, "<IND>verwandt?<END>"

STR_DialogGer0101:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Nö, wir sind natürlich ein Paar.<NL>"
	.STRINGMAP diag, "<SEL><IND>Sie hat mir mal Lesen und Schreiben beigebracht ...<END>"

STR_DialogGer0102:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>In Ordnung ...<END>"

STR_DialogGer0103:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Dem Bürgermeister zufolge sollen wir mit allen<NL>"
	.STRINGMAP diag, "<IND>Dorfbewohnern sprechen. Auf geht’s!<END>"

STR_DialogGer0104:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GORILLA 1:<NL>"
	.STRINGMAP diag, "<IND>G’day, mate.<NL>"
	.STRINGMAP diag, "<IND>Very pleased ter meetcha, me is ...<CLR>"

	.STRINGMAP ctrl, "<BG>$04"
	.STRINGMAP diag, "<IND>... ’cuz me main hobby is turning lions into<NL>"
	.STRINGMAP diag, "<IND>sausage!<NL>"
	.STRINGMAP diag, "<IND>Oh, me name’s Joe. Joe Lion-Trapper ...<END>"

STR_DialogGer0105:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "GORILLA 2:<NL>"
	.STRINGMAP diag, "<IND>Hello there, hunky mane-bearer. ♥<NL>"
	.STRINGMAP diag, "<IND>Your muscled appearance, coated in velvety<NL>"
	.STRINGMAP diag, "<IND>golden fur, is indeed a feast for the eyes ...<CLR>"

	.STRINGMAP ctrl, "<BG>$04"
	.STRINGMAP diag, "<IND>... as it’ll be for my fangs. Too bad you can’t live<NL>"
	.STRINGMAP diag, "<IND>to witness our appreciation of your tasty flesh!<NL>"
	.STRINGMAP diag, "<IND>By the way, they call me Jim. Jim Lion-Slayer ...<END>"

STR_DialogGer0106:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "GORILLA 3:<NL>"
	.STRINGMAP diag, "<IND>Greetings, splendid Leoniden fellow.<NL>"
	.STRINGMAP diag, "<IND>Never mind either of my brothers’ uncouth<NL>"
	.STRINGMAP diag, "<IND>talk ...<CLR>"

	.STRINGMAP ctrl, "<BG>$04"
	.STRINGMAP diag, "<IND>Just rest assured that it will be an honor,<NL>"
	.STRINGMAP diag, "<IND>and a privilege, to take your precious hide.<NL>"
	.STRINGMAP diag, "<IND>For I am known as Jack. Jack Lion-Flayer ...<END>"

STR_DialogGer0107:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Kleiner Tipp, ihr drei Affen ...<NL>"
	.STRINGMAP diag, "<IND>I won’t be flayed by any Tom, Dick or Harry!<END>"

STR_DialogGer0108:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Tja, ich nehme alles zurück.<NL>"
	.STRINGMAP diag, "<IND>Ich hatte nicht den leisesten Schimmer, dass<NL>"
	.STRINGMAP diag, "<IND>Wildschwein-Rostbraten SO lecker schmeckt.<CLR>"

	.STRINGMAP ctrl, "<BG>$03"
	.STRINGMAP diag, "<IND>Danke, Alec! ♥<END>"

STR_DialogGer0109:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Schmeckt wirklich gut ...<NL>"
	.STRINGMAP diag, "<IND>*schnüffel*<NL>"
	.STRINGMAP diag, "<IND>... aber ist ganz sicher kein Wildschweinbraten.<END>"

STR_DialogGer0110:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Schleck! ♥<CLR>"

	.STRINGMAP diag, "<IND>Ich wusste gar nicht, dass frische Primatenleber<NL>"
	.STRINGMAP diag, "<IND>ein bisschen wie Räucherschinken schmeckt ...!<END>"

STR_DialogGer0111:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>W...was?<NL>"
	.STRINGMAP diag, "<IND>Soll das heißen, ich esse hier gerade ...<NL>"
	.STRINGMAP diag, "<IND>... die sterblichen Überreste ...<END>"

STR_DialogGer0112:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>... von drei streitsüchtigen Gorillas?<NL>"
	.STRINGMAP diag, "<IND>Hehe ... Wer weiß!?<END>"

STR_DialogGer0113:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Alec, du ... du ... *schnief*<END>"

STR_DialogGer0114:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Sag ihr mal die Wahrheit, ja?<END>"

STR_DialogGer0115:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Welche? Dass wir in Wirklichkeit gerade<NL>"
	.STRINGMAP diag, "<IND>Hirschragout gefuttert haben?<END>"

STR_DialogGer0116:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Nein, Leonido.<CLR>"

	.STRINGMAP diag, "<IND>Sag ihr, dass du nicht auch in sie verliebt bist.<END>"

STR_DialogGer0117:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Das geht dich überhaupt nichts an.<END>"

STR_DialogGer0118:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Wie auch immer, ich geh jetzt schlafen.<END>"

STR_DialogGer0119:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Wie auch immer, worauf wartest du noch?<END>"

STR_DialogGer0120:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Jetzt wo er weg ist ...<NL>"
	.STRINGMAP diag, "<SEL><IND>(... schleich’ ich mich an und kitzel ihn durch! ♥)<NL>"
	.STRINGMAP diag, "<SEL><IND>(... stelle ich mich lieber mit Lily wieder gut.)<END>"

STR_DialogGer0121:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Da ist sie ja ...<END>"

STR_DialogGer0122:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Hör mal, ähm ... Ich hab nur Spaß gemacht.<END>"

STR_DialogGer0123:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Ja, ich weiß.<END>"

STR_DialogGer0124:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Was?<END>"

STR_DialogGer0125:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Wir kennen uns von Welpenpfoten an. In all den<NL>"
	.STRINGMAP diag, "<IND>Jahren hast du mich nicht ein einziges Mal in<NL>"
	.STRINGMAP diag, "<IND>Verlegenheit gebracht ...<END>"

STR_DialogGer0126:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ich ... echt nicht?<END>"

STR_DialogGer0127:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Ehrenwort.<END>"

STR_DialogGer0128:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Na, dann seh’ ich lieber zu, dass das so bleibt.<END>"

STR_DialogGer0129:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Könntest du ... Also, würdest du uns morgen<NL>"
	.STRINGMAP diag, "<IND>dein Lieblingsessen machen?<NL>"
	.STRINGMAP diag, "<IND>Ich meine ... bitte?<END>"

STR_DialogGer0130:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Oh, Alec ... Du bist so lieb. ♥<END>"

STR_DialogGer0131:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Da bist du ja.<END>"

STR_DialogGer0132:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Wie hast du mich ...?<END>"

STR_DialogGer0133:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Heh. Du bist nicht der Einzige hier, der<NL>"
	.STRINGMAP diag, "<IND>eine feine Nase hat.<END>"

STR_DialogGer0134:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ein schönes Plätzchen zum Schlafen hast du da<NL>"
	.STRINGMAP diag, "<IND>gefunden. Was dagegen, wenn ich mich zu dir<NL>"
	.STRINGMAP diag, "<IND>geselle?<END>"

STR_DialogGer0135:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Ich habe etwas dagegen, falls du schnarchst.<END>"

STR_DialogGer0136:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Keine Sorge, Kumpel.<END>"

STR_DialogGer0137:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Dann also ...<END>"

STR_DialogGer0138:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Was ist noch?<END>"

STR_DialogGer0139:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Gute Nacht, Primus. Schlaf gut.<NL>"
	.STRINGMAP diag, "<SEL><IND>Wie deine Ohren im Mondlicht schimmern ...<END>"

STR_DialogGer0140:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Gute Nacht, Leonido.<END>"

STR_DialogGer0141:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>...<CLR>"

	.STRINGMAP diag, "<IND>Du auch, Alec.<END>"

STR_DialogGer0142:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>*Gäääähn*<END>"

STR_DialogGer0143:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Höh!? Was ist das?<END>"

STR_DialogGer0144:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Pastinakensuppe. Lily steht da total drauf.<NL>"
	.STRINGMAP diag, "<IND>Einfach Nase zuhalten und auslöffeln.<END>"

STR_DialogGer0145:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>*murmel* *schmecktjawiefuchsenpisse* *grummel*<END>"

STR_DialogGer0146:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Pst, sei bloß still!<END>"

STR_DialogGer0147:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Oje ...<NL>"
	.STRINGMAP diag, "<IND>Wie’s aussieht, sitzen wir hier erst mal fest.<END>"

STR_DialogGer0148:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Keine Sorge. Ich räum’ das Gerümpel hier weg,<NL>"
	.STRINGMAP diag, "<IND>und schon können wir wieder verschwinden.<END>"

STR_DialogGer0149:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Warte mal!<END>"

STR_DialogGer0150:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Was ist los?<END>"

STR_DialogGer0151:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Wo wir schon hier sind, könnten wir uns<NL>"
	.STRINGMAP diag, "<IND>mal umsehen, meinst du nicht?<END>"

STR_DialogGer0152:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Sie hat recht, Leonido.<NL>"
	.STRINGMAP diag, "<IND>Meine Nase sagt mir, dass dieser Ort nicht ganz<NL>"
	.STRINGMAP diag, "<IND>fuchsenrein ist ...<END>"

STR_DialogGer0153:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>...<END>"

STR_DialogGer0154:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Also? Was tun wir?<NL>"
	.STRINGMAP diag, "<SEL><IND>(Schleunigst abhauen!)<NL>"
	.STRINGMAP diag, "<SEL><IND>(Bleiben und mal umschauen)<END>"

STR_DialogGer0155:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Hier war seit Ewigkeiten keiner mehr.<END>"

STR_DialogGer0156:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Eine Puppe in Gestalt eines Fenneks.<NL>"
	.STRINGMAP diag, "<IND>Allerdings fehlen ihr die Augen.<END>"

STR_DialogGer0157:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Ein unheimlicher Ort.<NL>"
	.STRINGMAP diag, "<IND>Langsam denke ich, wir hätten lieber doch nicht<NL>"
	.STRINGMAP diag, "<IND>herkommen sollen ...<END>"

STR_DialogGer0158:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "FENNEK-PUPPE:<NL>"
	.STRINGMAP diag, "<IND>Ich kann dich nicht sehen ...<NL>"
	.STRINGMAP diag, "<IND>... aber ich höre dein Herz schlagen!<END>"

STR_DialogGer0159:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Achtung! Weiterer Feind im Anmarsch!<END>"

STR_DialogGer0160:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MELODISCHE STIMME:<NL>"
	.STRINGMAP diag, "<IND>Ich habe keine bösen Absichten ...<END>"

STR_DialogGer0161:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER FUCHS:<NL>"
	.STRINGMAP diag, "<IND>Ihr habt tapfer gekämpft.<NL>"
	.STRINGMAP diag, "<IND>Wer seid ihr?<END>"

STR_DialogGer0162:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Ich bin Alec, und das sind meine Freunde.<NL>"
	.STRINGMAP diag, "<SEL><IND>Dasselbe möchte ich dich fragen, Rotpelz!<NL>"
	.STRINGMAP diag, "<SEL><IND>(Stattdessen Lily antworten lassen)<END>"

STR_DialogGer0163:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Warum habt ihr uns angegriffen?<END>"

STR_DialogGer0164:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER FUCHS:<NL>"
@Jump01:
	.STRINGMAP diag, "<IND>Ich wollte euch kein Leid zufügen, und das gilt auch<NL>"
	.STRINGMAP diag, "<IND>für Dorothy.<END>"

STR_DialogGer0165:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER FUCHS:<NL>"
	.STRINGMAP diag, "<IND>Willkommen in meinem Bau, Alec.<END>"

STR_DialogGer0166:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER FUCHS:<NL>"
	.STRINGMAP diag, "<IND>Es tut mir aufrichtig leid, dass ich so unhöflich<NL>"
	.STRINGMAP diag, "<IND>gewesen bin.<END>"

STR_DialogGer0167:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FREMDER FUCHS:<NL>"
	.STRINGMAP diag, "<IND>Mein Name ist Reinhold von Pappenheim. Ich bin<NL>"
	.STRINGMAP diag, "<IND>Bauchredner von Beruf. Ich entschuldige mich<NL>"
	.STRINGMAP diag, "<IND>dafür, euch geängstigt zu haben ...<END>"

STR_DialogGer0168:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "REINHOLD:<NL>"
	.STRINGMAP ctrl, "<JMP>"
	.DL STR_DialogGer0164@Jump01

STR_DialogGer0169:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Schon mal zufälligerweise im Dorf Furlorn gewesen?<END>"


STR_DialogGer0170:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>War er definitiv. Habt ihr nicht auch diesen Duft<NL>"
	.STRINGMAP diag, "<IND>von Räucherwurst in der Nase, wie sie Tusker<NL>"
	.STRINGMAP diag, "<IND>vermisst hat?<END>"

STR_DialogGer0171:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "REINHOLD:<NL>"
	.STRINGMAP diag, "<IND>Ich gestehe ein, dass ich aus Dörfern in der Nähe<NL>"
	.STRINGMAP diag, "<IND>Nahrung stibitzt habe. Hier draußen in der Wildnis<NL>"
	.STRINGMAP diag, "<IND>gibt es nichts zu essen.<END>"

STR_DialogGer0172:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Da haben wir also unseren ,,Geist“.<END>"

STR_DialogGer0173:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Nichts zu essen, sagst du? Aber die Wälder in dieser<NL>"
	.STRINGMAP diag, "<IND>Gegend sind voller Beute!<END>"

STR_DialogGer0174:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "DOROTHY:<NL>"
	.STRINGMAP diag, "<IND>Er ist kein Jäger, wisst ihr. Und kein Sammler. Er ist nur<NL>"
	.STRINGMAP diag, "<IND>ein Bauernfänger. Ein Trickbetrüger, wenn man so will.<NL>"
	.STRINGMAP diag, "<IND>Ohne zu klauen wäre er in kurzer Zeit verhungert.<END>"

STR_DialogGer0175:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Halt mal! Wieso kann dieses Ding eigentlich sprechen!?<END>"

STR_DialogGer0176:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Lass dich nicht von ihm reinlegen. Ein Bauchredner<NL>"
	.STRINGMAP diag, "<IND>kann sprechen, ohne den Mund zu bewegen.<END>"

STR_DialogGer0177:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$03"
	.STRINGMAP diag, "DOROTHY:<NL>"
	.STRINGMAP diag, "<IND>Stimmt genau. ♥<END>"

STR_DialogGer0178:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Krallenstark!<NL>"
	.STRINGMAP diag, "<SEL><IND>Das ist ... gruselig.<END>"

STR_DialogGer0179:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Leute, eins kapier’ ich nicht. Mit solchen Tricks<NL>"
	.STRINGMAP diag, "<IND>könnte man doch in jeder größeren Stadt ein<NL>"
	.STRINGMAP diag, "<IND>Vermögen als Straßenkünstler verdienen.<CLR>"

	.STRINGMAP diag, "<IND>Stattdessen lebst du hier draußen, ganz im Geheimen.<NL>"
	.STRINGMAP diag, "<IND>Es erscheint mir fast so, als ob du dich vor<NL>"
	.STRINGMAP diag, "<IND>irgendwem versteckst.<END>"

STR_DialogGer0180:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Bleib sofort stehen, du kleiner Bastard!<END>"

STR_DialogGer0181:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FUCHSENWELPE:<NL>"
	.STRINGMAP diag, "<IND>Wräffs! Ich häng’ fest!!<END>"

STR_DialogGer0182:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Hab ich dich endlich!<END>"

STR_DialogGer0183:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Also nochmal, WO IST MEINE MAHLZEIT?<END>"

STR_DialogGer0184:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "FUCHSENWELPE:<NL>"
	.STRINGMAP diag, "<IND>Echt jetzt, keine Ahnung!<END>"

STR_DialogGer0185:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Wer’s glaubt!? Pass auf, wenn du mir nicht SOFORT<NL>"
	.STRINGMAP diag, "<IND>Antwort gibst, mach ich dir einen Knoten in den<NL>"
	.STRINGMAP diag, "<IND>Schwanz! Kapiert?<END>"

STR_DialogGer0186:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "FUCHSENWELPE:<NL>"
	.STRINGMAP diag, "<IND>Hiiiilfe!!<NL>"
	.STRINGMAP diag, "<IND>*quiek*<END>"

STR_DialogGer0187:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Wir sollten dem Kleinen helfen!<END>"

STR_DialogGer0188:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Unbedingt!<END>"

STR_DialogGer0189:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$02"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Häh?<NL>"
	.STRINGMAP diag, "<IND>Was für räudige Schakale seid ihr?<END>"

STR_DialogGer0190:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>*Keuch, schnauf*<NL>"
	.STRINGMAP diag, "<IND>Deppen! Ihr seid schuld, dass der kleine Dieb fliehen<NL>"
	.STRINGMAP diag, "<IND>konnte.<CLR>"

	.STRINGMAP diag, "<IND>Ich hätte ihn vermöbeln sollen, solange ich<NL>"
	.STRINGMAP diag, "<IND>Gelegenheit hatte!<END>"

STR_DialogGer0191:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "PRIMUS:<NL>"
	.STRINGMAP diag, "<IND>Moment mal ... Hat er dir was gestohlen?<END>"

STR_DialogGer0192:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Ja, verdammt! Fressalien! EIER!!<END>"

STR_DialogGer0193:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Oha ... Das klingt nicht gut.<END>"

STR_DialogGer0194:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Entschuldige das Missverständnis. Wir nahmen an ...<END>"

STR_DialogGer0195:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Mir doch schnuppe!<CLR>"

	.STRINGMAP ctrl, "<BG>$01"
	.STRINGMAP diag, "<IND>Meine Eier sind weg, darum geht’s!<NL>"
	.STRINGMAP diag, "<IND>Waren übrigens Fasaneneier. Sehr nahrhaft.<NL>"
	.STRINGMAP diag, "<IND>Und jetzt sind sie EINFACH WEG!<END>"

STR_DialogGer0196:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Als Jäger weiß ich, wo Fasane brüten.<NL>"
	.STRINGMAP diag, "<IND>Ich kann dir helfen, frischen Ersatz zu besorgen.<END>"

STR_DialogGer0197:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Wirklich?<END>"

STR_DialogGer0198:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Ja doch.<END>"

STR_DialogGer0199:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Warum willst du das für mich tun?<END>"

STR_DialogGer0200:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Wir schulden dir immerhin was.<NL>"
	.STRINGMAP diag, "<SEL><IND>Ich gönn’ dir was Leckeres zum Aufschlürfen. ♥<NL>"
	.STRINGMAP diag, "<SEL><IND>(Stattdessen Lily antworten lassen)<END>"

STR_DialogGer0201:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "LILY:<NL>"
	.STRINGMAP diag, "<IND>Alec hat recht. Schließlich sind wir schuld an<NL>"
	.STRINGMAP diag, "<IND>deinem Verlust und daher verpflichtet, dir Ersatz<NL>"
	.STRINGMAP diag, "<IND>zu beschaffen.<END>"

STR_DialogGer0202:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Stimmt. Also gehen wir.<END>"

STR_DialogGer0203:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>Werd’ ich, verlass dich drauf. ♥<NL>"
	.STRINGMAP diag, "<IND>Joa, dann los.<END>"

STR_DialogGer0204:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<IND>Wie heißt du eigentlich?<END>"

STR_DialogGer0205:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "MUSKELPARDE:<NL>"
	.STRINGMAP diag, "<IND>...<CLR>"

	.STRINGMAP diag, "<IND>Nennt mich Mickey.<END>"

STR_DialogGer0206:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "ALEC:<NL>"
	.STRINGMAP diag, "<SEL><IND>Ich bin Alec, und das sind meine Freunde.<NL>"
	.STRINGMAP diag, "<SEL><IND>Nenn mich Leonido. ♥<END>"

STR_DialogGer0207:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "BRAUNBÄR:<NL>"
	.STRINGMAP diag, "<IND>Habe die Ehre. Ähem ...<CLR>"

	.STRINGMAP diag, "<IND>Mein Name ist Gregory Perpetuus Ebenezer<NL>"
	.STRINGMAP diag, "<IND>Hrabanus Eindhoven Dubois Quaoar van der<NL>"
	.STRINGMAP diag, "<IND>Mühlhausen Nido sulle Colline ... Junior.<END>"

STR_DialogGer0208:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$05"
	.STRINGMAP diag, "TARA:<NL>"
	.STRINGMAP diag, "<IND>Nimm ja deine Pfote von mir!<END>"

/*
STR_DialogGer0209:
	.STRINGMAP ctrl, "<PORTRAIT>$00<BG>$01"
	.STRINGMAP diag, "<NL>"
	.STRINGMAP diag, "<IND><NL>"
	.STRINGMAP diag, "<IND><NL>"
	.STRINGMAP diag, "<IND><END>"
*/



; ******************************** EOF *********************************
