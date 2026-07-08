; ==================================================================================================
;
;	"FURRY RPG" (WORKING TITLE)
;	(c) by Ramsis a.k.a. ManuLöwe (https://manuloewe.de/)
;
;	DIALOGUE STRINGS (GERMAN/DEU)
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



; POINTER TABLE FOR GERMAN DIALOGUE
; --------------------------------------------------------------------------------------------------

SRC_DialoguePointerTableDEU:

; IMPORTANT: If multiple pointer blocks are needed later on, use START <value> in the subsequent
; .REPEAT directive(s).

.REPEAT 202 INDEX COUNT
	.DW STR_DialogueDEU{%.4d{COUNT}}				; create pointers for German dialogue strings
.ENDR



; GERMAN DIALOGUE
; --------------------------------------------------------------------------------------------------

.REDEFINE COUNT = 0							; 4-digit string numbers for reference. Regex search: \d{4}$ Text Pastry command: Ctrl+Alt+N, \i 0 1 4

	d_string kLangDEU, "<PORTRAIT><02><BG><01>"			; 0000
	d_string "JÖRG BÄCKT QUASI ZWEI HAXENFÜSSE VOM WILDPONY.<NL>"
	d_string "jörg bäckt quasi zwei haxenfüße vom wildpony.<NL>"
	d_string "0123456789 ÄÖÜäëïöüß <B>Fetter Text<B><NL>"
	d_string "!“#$%&’()*+,-./:;<=>?@[\]^_`{|}~♥×♫<00>"

;	d_string kLangDEU, "<PORTRAIT><01><BG><01>"			; 0000
;	d_string "GENGEN:<NL>"
;	d_string "Ich Kobold!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0001
	d_string "ALEC:<NL>"
	d_string "<IND>Uff, was für ein Traum!<CLR>"
	d_string "<IND>Ich habe die Fährte eines seltenen Mähnen-<NL>"
	d_string "<IND>Schneeleoparden verfolgt. Als ich ihn stellte,<NL>"
	d_string "<IND>hat er sich umgedreht und zu mir gesprochen ...<CLR>"
	d_string "<IND>Ich weiß nicht mehr, was er sagte, nur<NL>"
	d_string "<IND>dass es mich total mitgenommen hat.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0002
	d_string "ALEC:<NL>"
	d_string "<IND>Puh! Zum Glück war’s nur ein Traum.<CLR>"
	d_string "<IND>Warum führ ich eigentlich Selbstgespräche?<NL>"
	d_string "<IND>Ich sollte mich an die Arbeit machen!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0003
	d_string "ALEC:<NL>"
	d_string "<IND>Das ist mein Haus.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0004
	d_string "ALEC:<NL>"
	d_string "<IND>Meine Feuerstelle.<NL>"
	d_string "<IND>Vielleicht sollte ich heute noch etwas Feuerholz<NL>"
	d_string "<IND>sammeln ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0005
	d_string "ALEC:<NL>"
	d_string "<IND>Lecker, das Zeug. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0006
	d_string "ALEC:<NL>"
	d_string "<IND>Mein ganzes Feuerholz. Reicht aber noch nicht.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0007
	d_string "ALEC:<NL>"
	d_string "<IND>Was zum ...!?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><02>"			; 0008
	d_string "TIGRAN:<NL>"
	d_string "<IND>Kein Wunder, wenn du deine Deckung<NL>"
	d_string "<IND>aufgibst ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0009
	d_string "ALEC:<NL>"
	d_string "<IND>Och, hör doch auf, Lily.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0010
	d_string "LILY:<NL>"
	d_string "<INDs>Tschuldige, Alec. Das konnte ich mir einfach<NL>"
	d_string "<IND>nicht verkneifen. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0011
	d_string "ALEC:<NL>"
	d_string "<IND>Was willst du?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0012
	d_string "LILY:<NL>"
	d_string "<IND>Sei nicht so schroff, ja!<NL>"
	d_string "<IND>Ich hab dir Kokosmilch mitgebracht.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0013
	d_string "ALEC:<NL>"
	d_string "<IND>Wozu das denn?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0014
	d_string "LILY:<NL>"
	d_string "<IND>Nun frag doch nicht dauernd so dummes Zeug,<NL>"
	d_string "<IND>sondern koste lieber mal.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0015
	d_string "ALEC:<NL>"
	d_string "<IND>Na gut, okay. Aber nur dir zuliebe.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0016
	d_string "ALEC:<NL>"
	d_string "<IND>Urgs ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0017
	d_string "LILY:<NL>"
	d_string "<IND>Die ist einfach köstlich, oder?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0018
	d_string "ALEC:<NL>"
	d_string "<IND>Ähmmmmm ...<NL>"
	d_string "<SEL><IND>Na ja, wie gesagt, ist halt Kokosmilch.<NL>"
	d_string "<SEL><IND>Igitt. Was gibt’s als nächstes, Pastinakensuppe?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0019
	d_string "LILY:<NL>"
	d_string "<IND>Ich wusste doch, dass du begeistert sein<NL>"
	d_string "<IND>würdest. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0020
	d_string "LILY:<NL>"
	d_string "<IND>Tut mir leid, Alec. Ich wollte dich nicht<NL>"
	d_string "<IND>ärgern.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0021
	d_string "ALEC:<NL>"
	d_string "<IND>Sorry ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0022
	d_string "LILY:<NL>"
	d_string "<IND>Keine Sorge, ist schon okay. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0023
	d_string "ALEC:<NL>"
	d_string "<IND>Aber bestimmt bist du nicht nur deshalb heute<NL>"
	d_string "<IND>so früh hergekommen, oder?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0024
	d_string "LILY:<NL>"
	d_string "<IND>Stimmt, bin ich nicht.<CLR>"
	d_string "<BG><05>"
	d_string "<IND>Das Schicksal der ganzen Welt hängt nur<NL>"
	d_string "<IND>von dir ab!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0025
	d_string "LILY:<NL>"
	d_string "<IND>Tihi, jetzt solltest du mal dein Gesicht<NL>"
	d_string "<IND>sehen ... ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0026
	d_string "ALEC:<NL>"
	d_string "<IND>Für ’ne Sekunde hab’ ich echt gedacht ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0027
	d_string "LILY:<NL>"
	d_string "<IND>Nee, aber du wirst Augen machen, wenn du erst<NL>"
	d_string "<IND>mal das hier hörst ...<CLR>"
	d_string "<IND>Der Bürgermeister verspricht demjenigen eine<NL>"
	d_string "<IND>Belohnung, der rausfindet, was es mit diesem<NL>"
	d_string "<IND>,,Geist“ auf sich hat, von dem alle reden. Ich hab<NL>"
	d_string "<IND>dir ja davon erzählt, weißt du noch?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0028
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Na klar!<NL>"
	d_string "<SEL><IND>Keine Ahnung, was du meinst!<NL>"
	d_string "<SEL><IND>Hilf mir mal auf die Sprünge ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0029
	d_string "ALEC:<NL>"
	d_string "<IND>Nicht nur du. Tusker hat neulich erzählt, aus<NL>"
	d_string "<IND>der Vorratskammer seiner Schänke sei ein<NL>"
	d_string "<IND>Dutzend Ringe Dauerwurst geklaut worden.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0030
	d_string "LILY:<NL>"
	d_string "<IND>Du lebst aber auch echt hinter dem Mond!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0031
	d_string "ALEC:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Hab mich halt um meinen eigenen Kram gekümmert.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0032
	d_string "LILY:<NL>"
	d_string "<IND>Also gut. Um es kurz zu machen, in letzter Zeit<NL>"
	d_string "<IND>verschwinden ständig spurlos irgendwelche Sachen.<CLR>"
	d_string "<IND>Dauerwurst verschwindet aus den Vorratskammern,<NL>"
	d_string "<IND>Wäsche und Schuhe sind abhandengekommen, und<NL>"
	d_string "<IND>sogar Werkzeuge und Angelruten lösen sich in Luft auf,<NL>"
	d_string "<IND>wenn kurz niemand hinschaut.<CLR>"
@Jump01:
	d_string "<IND>Der Kleine meiner Fuchsennachbarn behauptet<NL>"
	d_string "<IND>sogar, er hätte den ,,Geist“, der dafür verantwortlich<NL>"
	d_string "<IND>ist, mit seinen eigenen Augen gesehen ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0033
	d_string "LILY:<NL>"
	d_string "<IND>Abgesehen von Tuskers verschwundenen Würsten<NL>"
	d_string "<IND>sind im Dorf in letzter Zeit noch mehr komische<NL>"
	d_string "<IND>Sachen passiert.<CLR>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-2}}@Jump01

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0034
	d_string "ALEC:<NL>"
	d_string "<IND>Mit wessen Augen hätte er ihn auch sonst sehen<NL>"
	d_string "<IND>sollen?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0035
	d_string "LILY:<NL>"
	d_string "<IND>Genau das hab ich meinen Nachbarn auch gesagt.<NL>"
	d_string "<IND>Aber die sind mittlerweile alle drei zu Tode<NL>"
	d_string "<IND>verängstigt.<CLR>"
	d_string "<IND>Sogar Tusker, eigentlich ein vernünftiger Kerl,<NL>"
	d_string "<IND>glaubt mittlerweile lieber an übernatürliche<NL>"
	d_string "<IND>Kräfte. Mit evidenzbasierter Wissenschaft kommst<NL>"
	d_string "<IND>du bei niemandem mehr weit. Also dachte ich ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0036
	d_string "ALEC:<NL>"
	d_string "<IND>... ein Profi-Jäger könnte dir da behilflich<NL>"
	d_string "<IND>sein?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0037
	d_string "LILY:<NL>"
	d_string "<IND>Nicht irgendeiner, versteht sich. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0038
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Worin besteht die Belohnung?<NL>"
	d_string "<SEL><IND>Allzeit bereit für die Geisterjagd!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0039
	d_string "LILY:<NL>"
	d_string "<IND>Willst du denn gar nicht wissen, worin die Belohnung<NL>"
	d_string "<IND>des Bürgermeisters besteht?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0040
	d_string "ALEC:<NL>"
	d_string "<IND>Hm? Was ist es denn?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0041
	d_string "LILY:<NL>"
	d_string "<IND>Ein Haufen Gold, jede Menge Naturalien und<NL>"
	d_string "<IND>ewiger Ruhm, hab ich gehört.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0042
	d_string "ALEC:<NL>"
	d_string "<IND>Gold brauch’ ich nicht. Das mit dem Ruhm klingt<NL>"
	d_string "<IND>ganz in Ordnung. Schade, dass kein Feuerholz<NL>"
	d_string "<IND>dabei ist ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0043
	d_string "LILY:<NL>"
	d_string "<IND>Oh, ist es aber ... hab ich doch glatt vergessen<NL>"
	d_string "<IND>zu sagen! Drei, äh, Ster Feuerholz. Mindestens. Das<NL>"
	d_string "<IND>ist eigentlich sogar der Hauptpreis!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0044
	d_string "ALEC:<NL>"
	d_string "<IND>Also los, worauf warten wir noch?<NL>"
	d_string "<IND>Schließlich will ich heute früh am Abend<NL>"
	d_string "<IND>wieder zu Hause sein!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0045
	d_string "LILY:<NL>"
	d_string "<IND>Klar doch. ♥<CLR>"
	d_string "<BG><01>"
	d_string "<IND>Übrigens, ich kenne jemanden, der uns helfen<NL>"
	d_string "<IND>kann. Bevor wir den Bürgermeister besuchen,<NL>"
	d_string "<IND>sollten wir mit ihm sprechen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0046
	d_string "<NL><IND><IND><IND><IND><1> schließt sich der Gruppe an!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0047
	d_string "LILY:<NL>"
	d_string "<IND>Da sind wir endlich.<NL>"
	d_string "<IND>Ach du liebes Bisschen ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0048
	d_string "ALEC:<NL>"
	d_string "<IND>Stimmt was nicht?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0049
	d_string "LILY:<NL>"
	d_string "<IND>Ich hab völlig vergessen, meinem Onkel Bescheid zu<NL>"
	d_string "<IND>sagen, dass ich eine Weile weg sein werde. Treffen<NL>"
	d_string "<IND>wir uns doch nachher in Tuskers Schänke, okay?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0050
	d_string "ALEC:<NL>"
	d_string "<IND>Ich geh auch gern mit dir mit!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0051
	d_string "LILY:<NL>"
	d_string "<IND>Das ist echt nett von dir, Alec. ♥<CLR>"
	d_string "<BG><01>"
	d_string "<IND>... Aber du weißt ja, mein Onkel ist ein bisschen senil.<NL>"
	d_string "<IND>In seinem Zustand will er lieber keinen Besuch von<NL>"
	d_string "<IND>Fremden.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0052
	d_string "ALEC:<NL>"
	d_string "<IND>Okay. Dann bis später.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0053
	d_string "<NL><IND><IND><IND><IND><IND><IND><1> verlässt die Gruppe!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0054
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Hey-ho, Leonido ...<NL>"
	d_string "<IND>Für einen von deiner Sorte bist du aber ziemlich<NL>"
	d_string "<IND>klein. Du bist nicht zufällig ein Jäger, oder?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0055
	d_string "ALEC:<NL>"
	d_string "<IND>Nenn mich nicht ,,Leonido“!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><02>"			; 0056
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Okay-o, Leonido ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0057
	d_string "PRIMUS:<NL>"
	d_string "<IND>Hey-ho, Leonido ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0058
	d_string "LILY:<NL>"
	d_string "<IND>Was MACHT ihr zwei denn da!?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0059
	d_string "LILY:<NL>"
	d_string "<IND>Argh ... KERLE!<NL>"
	d_string "<IND>Entweder sie kabbeln sich oder ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0060
	d_string "ALEC:<NL>"
	d_string "<IND>Oder was?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0061
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Ich bin Soldat. Mich mit anderen zu kabbeln<NL>"
	d_string "<IND>ist mein Beruf.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0062
	d_string "LILY:<NL>"
	d_string "<IND>Aber das hier ist der Typ, der dir bei deiner<NL>"
	d_string "<IND>Mission am ehesten helfen kann, wie gesagt!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0063
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Aha, du bist also Alec Marlowe, der Jäger?<NL>"
	d_string "<IND>Dann muss ich mich entschuldigen. Freut mich,<NL>"
	d_string "<IND>dich kennenzulernen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0064
	d_string "ALEC:<NL>"
	d_string "<IND>Was sollte das alles?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0065
	d_string "ALEC:<NL>"
	d_string "<IND>Kleiner Tipp für’s nächste Mal ...<NL>"
	d_string "<IND>Erst fragen, wen du vor dir hast, bevor du<NL>"
	d_string "<IND>wildfremde Furros anschnauzt!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0066
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Das nennst du anschnauzen, ,,Leonido“?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0067
	d_string "ALEC:<NL>"
	d_string "<IND>Schluss damit!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0068
	d_string "LILY:<NL>"
	d_string "<IND>Nicht ärgern, Alec. Er hat sich ja nur<NL>"
	d_string "<IND>selbst zitiert.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0069
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Da hörst du’s, ,,Leonido“. Wieder ein<NL>"
	d_string "<IND>Zitat, versteht sich ...<CLR>"
	d_string "<IND>Übrigens bin ich selber schon oft genug<NL>"
	d_string "<IND>,,angeschnauzt“ worden, wenn auch aus anderen<NL>"
	d_string "<IND>Gründen.<CLR>"
	d_string "<IND>Um ehrlich zu sein, ist mir das völlig schnuppe.<NL>"
	d_string "<IND>Seit meiner Welpenzeit hab ich ein dickes Fell ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0070
	d_string "ALEC:<NL>"
	d_string "<IND>Du bist echt ein Spinner.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0071
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Nein, ich bin Primus Greyfur, zu deinen Diensten.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0072
	d_string "LILY:<NL>"
	d_string "<IND>Er ist Soldat des Furderal Empire, Alec!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0073
	d_string "ALEC:<NL>"
	d_string "<IND>Na dann ...<NL>"
	d_string "<SEL><IND>Was hat dich hierher nach Librefur verschlagen?<NL>"
	d_string "<SEL><IND>Du bist also ein Deserteur?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0074
	d_string "PRIMUS:<NL>"
	d_string "<IND>Wenn ich ein Deserteur bin, dann bist du ein<NL>"
	d_string "<IND>Wilderer, Leonido.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0075
	d_string "PRIMUS:<NL>"
	d_string "<IND>Ich hatte keine Lust mehr auf muffige Baracken<NL>"
	d_string "<IND>und besoffene Hauptleute und bin neuerdings<NL>"
	d_string "<IND>Freiberufler. Soll heißen, ich arbeite für Geld.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0076
	d_string "ALEC:<NL>"
	d_string "<IND>Klingt nach ziemlich hartem Brot ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0077
	d_string "PRIMUS:<NL>"
	d_string "<IND>Zugegeben, manchmal kann es hart sein.<NL>"
	d_string "<IND>Aber gerade heute ist es das nicht ...<CLR>"
	d_string "<IND>Wenn ihr mich jetzt bitte entschuldigen wollt?<NL>"
	d_string "<IND>Ich habe einen Termin beim Bürgermeister. Nur falls ihr<NL>"
	d_string "<IND>es ernst meint und mich wirklich auf der Jagd nach dem<NL>"
	d_string "<IND>angeblichen Geist begleiten wollt.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0078
	d_string "ALEC:<NL>"
	d_string "<IND>Häh? Augenblick mal ...<CLR>"
	d_string "<IND>Lily!<NL>"
	d_string "<IND>Das da gerade war doch MEIN Job!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0079
	d_string "LILY:<NL>"
	d_string "<IND>Und dein Job plus sein Job ergibt unseren Job,<NL>"
	d_string "<IND>stimmt’s?<NL>"
	d_string "<IND>Also ... Sollen wir langsam aufbrechen?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0080
	d_string "JUGENDLICHE WOLFEN:<NL>"
	d_string "<IND>La ♫ di ♫ da ♫<NL>"
	d_string "<IND>Ich glaub, dass dieser graufellige Soldat<NL>"
	d_string "<IND>mich mag. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0081
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Willkommen zu Ihrem Briefing, Primus Greyfur.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0082
	d_string "PRIMUS:<NL>"
	d_string "<IND>Danke, Bürgermeister. Diese beiden hier gehören<NL>"
	d_string "<IND>zu mir.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0083
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Fräulein Lilac Pondicherry ... Ich bin entzückt.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0084
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Wirklich?<NL>"
	d_string "<SEL><IND>Und was ist mit mir?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0085
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Und Alexis Moorflau, lange nicht gesehen ... Sir Greyfur,<NL>"
	d_string "<IND>jede Gefellschaft hat nun einmal ihren eigenen Bajazzo,<NL>"
	d_string "<IND>da stellt unser Dorf keine Ausnahme dar.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0086
	d_string "ALEC:<NL>"
	d_string "<IND>Ich heiße immer noch ALEC MARLOWE!<NL>"
	d_string "<IND>Und was zum Geier ist ein ,,Palazzo“!?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0087
	d_string "LILY:<NL>"
	d_string "<IND>Pssst ... Mach dir nix draus, Alec.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0088
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Im Namen aller Bewohner unseres Dorfes Furlorn<NL>"
	d_string "<IND>danke ich Ihnen dafür, dass Sie uns Ihre<NL>"
	d_string "<IND>Unterstützung anbieten, Sir Greyfur.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0089
	d_string "PRIMUS:<NL>"
	d_string "<IND>Einfach Primus, wenn es recht ist.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0090
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Ja, natürlich ... Sir Greyfur, wie Sie wahrscheinlich<NL>"
	d_string "<IND>wissen, erwartet denjenigen, der uns dieser<NL>"
	d_string "<IND>schrecklichen Bedrohung entledigt, ewiger Ruhm ...<CLR>"
	d_string "<IND>... zumal sie unser Dorf betrifft, seit Sie hier<NL>"
	d_string "<IND>eingetroffen sind.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0091
	d_string "PRIMUS:<NL>"
	d_string "<IND>Ja, ich ... Moment, wie war das? Nur Ruhm? Kein Gold?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0092
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Seien Sie unbesorgt. Natürlich werden Sie in jeder<NL>"
	d_string "<IND>erdenklichen Form zeitnah und großzügig entlohnt<NL>"
	d_string "<IND>werden. Darauf gebe ich Ihnen mein Wort.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0093
	d_string "PRIMUS:<NL>"
	d_string "<IND>Verstanden.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0094
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Dann ist es also abgemacht.<CLR>"
@Jump01:
	d_string "<IND>Reden Sie unbedingt mit allen Dorfbewohnern. Irgend<NL>"
	d_string "<IND>jemand unter uns muss einen Hinweis darauf haben,<NL>"
	d_string "<IND>wo Sie am besten anfangen zu suchen. Viel Glück!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0095
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-2}}@Jump01

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0096
	d_string "ALEC:<NL>"
	d_string "<IND>Das war’s dann mit meinem Extrastapel Feuerholz.<NL>"
	d_string "<IND>Lily, wir müssen mal reden, du und ich.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0097
	d_string "LILY:<NL>"
	d_string "<IND>Denk doch an das Gold! Damit kannst du dir Feuerholz<NL>"
	d_string "<IND>kaufen, so viel du willst, oder etwa nicht?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0098
	d_string "ALEC:<NL>"
	d_string "<IND>Oh. Stimmt ...<NL>"
	d_string "<IND>Aber warum dann das ganze Theater?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0099
	d_string "LILY:<NL>"
	d_string "<IND>Entschuldige, Alec ... Du wolltest doch früh wieder zu<NL>"
	d_string "<IND>Hause sein. Ich fürchte, es könnte doch später<NL>"
	d_string "<IND>werden.<CLR>"
	d_string "<IND>Trotzdem, ich kenn’ dich doch. Ich wusste, du würdest<NL>"
	d_string "<IND>mir noch danken, dass ich dir einen Impuls gab, deine<NL>"
	d_string "<IND>Höhle zu verlassen, und ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0100
	d_string "PRIMUS:<NL>"
	d_string "<IND>Wenn ich kurz unterbrechen darf ... Seid ihr zwei<NL>"
	d_string "<IND>verwandt?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0101
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Nö, wir sind natürlich ein Paar.<NL>"
	d_string "<SEL><IND>Sie hat mir mal Lesen und Schreiben beigebracht ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0102
	d_string "PRIMUS:<NL>"
	d_string "<IND>In Ordnung ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0103
	d_string "LILY:<NL>"
	d_string "<IND>Dem Bürgermeister zufolge sollen wir mit allen<NL>"
	d_string "<IND>Dorfbewohnern sprechen. Auf geht’s!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0104
	d_string "PRIMUS:<NL>"
	d_string "<IND>Wie auch immer, ich geh jetzt schlafen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0105
	d_string "ALEC:<NL>"
	d_string "<IND>Wie auch immer, worauf wartest du noch?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0106
	d_string "ALEC:<NL>"
	d_string "<IND>Jetzt wo er weg ist ...<NL>"
	d_string "<SEL><IND>(... schleich’ ich mich an und kitzele ihn durch! ♥)<NL>"
	d_string "<SEL><IND>(... stelle ich mich lieber mit Lily wieder gut.)<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0107
	d_string "ALEC:<NL>"
	d_string "<IND>Da ist sie ja ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0108
	d_string "ALEC:<NL>"
	d_string "<IND>Hör mal, ähm ... Ich hab nur Spaß gemacht.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0109
	d_string "LILY:<NL>"
	d_string "<IND>Ja, ich weiß.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0110
	d_string "ALEC:<NL>"
	d_string "<IND>Was?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0111
	d_string "LILY:<NL>"
	d_string "<IND>Wir kennen uns von Welpenpfoten an. In all den<NL>"
	d_string "<IND>Jahren hast du mich nicht ein einziges Mal in<NL>"
	d_string "<IND>Verlegenheit gebracht ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0112
	d_string "ALEC:<NL>"
	d_string "<IND>Ich ... echt nicht?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0113
	d_string "LILY:<NL>"
	d_string "<IND>Ehrenwort.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0114
	d_string "ALEC:<NL>"
	d_string "<IND>Na, dann seh’ ich lieber zu, dass das so bleibt.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0115
	d_string "ALEC:<NL>"
	d_string "<IND>Könntest du ... Also, würdest du uns morgen<NL>"
	d_string "<IND>dein Lieblingsessen machen?<NL>"
	d_string "<IND>Ich meine ... bitte?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0116
	d_string "LILY:<NL>"
	d_string "<IND>Oh, Alec ... Du bist so lieb. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0117
	d_string "PRIMUS:<NL>"
	d_string "<IND>Da bist du ja.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0118
	d_string "ALEC:<NL>"
	d_string "<IND>Wie hast du mich ...?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0119
	d_string "PRIMUS:<NL>"
	d_string "<IND>Heh. Du bist nicht der Einzige hier, der<NL>"
	d_string "<IND>eine feine Nase hat.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0120
	d_string "ALEC:<NL>"
	d_string "<IND>Ein schönes Plätzchen zum Schlafen hast du da<NL>"
	d_string "<IND>gefunden. Was dagegen, wenn ich mich zu dir<NL>"
	d_string "<IND>geselle?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0121
	d_string "PRIMUS:<NL>"
	d_string "<IND>Ich habe etwas dagegen, falls du schnarchst.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0122
	d_string "ALEC:<NL>"
	d_string "<IND>Keine Sorge, Kumpel.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0123
	d_string "ALEC:<NL>"
	d_string "<IND>Dann also ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0124
	d_string "PRIMUS:<NL>"
	d_string "<IND>Was ist noch?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0125
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Gute Nacht, Primus. Schlaf gut.<NL>"
	d_string "<SEL><IND>Wie deine Ohren im Mondlicht schimmern ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0126
	d_string "PRIMUS:<NL>"
	d_string "<IND>Gute Nacht, Leonido.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0127
	d_string "PRIMUS:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Du auch, Alec.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0128
	d_string "ALEC:<NL>"
	d_string "<IND>*Gäääähn*<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0129
	d_string "PRIMUS:<NL>"
	d_string "<IND>Höh!? Was ist das?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0130
	d_string "ALEC:<NL>"
	d_string "<IND>Pastinakensuppe. Lily steht da total drauf.<NL>"
	d_string "<IND>Einfach Nase zuhalten und auslöffeln.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0131
	d_string "PRIMUS:<NL>"
	d_string "<IND>*murmel* *schmecktjawiefuchsenpisse* *grummel*<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0132
	d_string "ALEC:<NL>"
	d_string "<IND>Pst, sei bloß still!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0133
	d_string "LILY:<NL>"
	d_string "<IND>Oje ...<NL>"
	d_string "<IND>Wie’s aussieht, sitzen wir hier erst mal fest.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0134
	d_string "ALEC:<NL>"
	d_string "<IND>Keine Sorge. Ich räum’ das Gerümpel hier weg,<NL>"
	d_string "<IND>und schon können wir wieder verschwinden.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0135
	d_string "LILY:<NL>"
	d_string "<IND>Warte mal!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0136
	d_string "ALEC:<NL>"
	d_string "<IND>Was ist los?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0137
	d_string "LILY:<NL>"
	d_string "<IND>Wo wir schon hier sind, könnten wir uns<NL>"
	d_string "<IND>mal umsehen, meinst du nicht?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0138
	d_string "PRIMUS:<NL>"
	d_string "<IND>Sie hat recht, Leonido.<NL>"
	d_string "<IND>Meine Nase sagt mir, dass dieser Ort nicht ganz<NL>"
	d_string "<IND>fuchsenrein ist ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0139
	d_string "ALEC:<NL>"
	d_string "<IND>...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0140
	d_string "ALEC:<NL>"
	d_string "<IND>Also? Was tun wir?<NL>"
	d_string "<SEL><IND>(Schleunigst abhauen!)<NL>"
	d_string "<SEL><IND>(Bleiben und mal umschauen)<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0141
	d_string "ALEC:<NL>"
	d_string "<IND>Hier war seit Ewigkeiten keiner mehr.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0142
	d_string "ALEC:<NL>"
	d_string "<IND>Eine Puppe in Gestalt eines Fenneks.<NL>"
	d_string "<IND>Allerdings fehlen ihr die Augen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0143
	d_string "LILY:<NL>"
	d_string "<IND>Ein unheimlicher Ort.<NL>"
	d_string "<IND>Langsam denke ich, wir hätten lieber doch nicht<NL>"
	d_string "<IND>herkommen sollen ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><02>"			; 0144
	d_string "FENNEK-PUPPE:<NL>"
	d_string "<IND>Ich kann dich nicht sehen ...<NL>"
	d_string "<IND>... aber ich höre dein Herz schlagen!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0145
	d_string "PRIMUS:<NL>"
	d_string "<IND>Achtung! Weiterer Feind im Anmarsch!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0146
	d_string "MELODISCHE STIMME:<NL>"
	d_string "<IND>Ich habe keine bösen Absichten ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0147
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Ihr habt tapfer gekämpft.<NL>"
	d_string "<IND>Wer seid ihr?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0148
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Ich bin Alec, und das sind meine Freunde.<NL>"
	d_string "<SEL><IND>Dasselbe möchte ich dich fragen, Rotpelz!<NL>"
	d_string "<SEL><IND>(Stattdessen Lily antworten lassen)<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0149
	d_string "LILY:<NL>"
	d_string "<IND>Warum habt ihr uns angegriffen?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0150
	d_string "FREMDER FUCHS:<NL>"
@Jump01:
	d_string "<IND>Ich wollte euch kein Leid zufügen, und das gilt auch<NL>"
	d_string "<IND>für Dorothy.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0151
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Willkommen in meinem Bau, Alec.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0152
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Es tut mir aufrichtig leid, dass ich so unhöflich<NL>"
	d_string "<IND>gewesen bin.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0153
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Mein Name ist Reinhold von Pappenheim. Ich bin<NL>"
	d_string "<IND>Bauchredner von Beruf. Ich entschuldige mich<NL>"
	d_string "<IND>dafür, euch geängstigt zu haben ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0154
	d_string "REINHOLD:<NL>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-5}}@Jump01

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0155
	d_string "ALEC:<NL>"
	d_string "<IND>Schon mal zufälligerweise im Dorf Furlorn gewesen?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0156
	d_string "PRIMUS:<NL>"
	d_string "<IND>War er definitiv. Habt ihr nicht auch diesen Duft<NL>"
	d_string "<IND>von Räucherwurst in der Nase, wie sie Tusker<NL>"
	d_string "<IND>vermisst hat?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0157
	d_string "REINHOLD:<NL>"
	d_string "<IND>Ich gestehe ein, dass ich aus Dörfern in der Nähe<NL>"
	d_string "<IND>Nahrung stibitzt habe. Hier draußen in der Wildnis<NL>"
	d_string "<IND>gibt es nichts zu essen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0158
	d_string "LILY:<NL>"
	d_string "<IND>Da haben wir also unseren ,,Geist“.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0159
	d_string "ALEC:<NL>"
	d_string "<IND>Nichts zu essen, sagst du? Aber die Wälder in dieser<NL>"
	d_string "<IND>Gegend sind voller Beute!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0160
	d_string "DOROTHY:<NL>"
	d_string "<IND>Er ist kein Jäger, wisst ihr. Und kein Sammler. Er ist nur<NL>"
	d_string "<IND>ein Bauernfänger. Ein Trickbetrüger, wenn man so will.<NL>"
	d_string "<IND>Ohne zu klauen wäre er in kurzer Zeit verhungert.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0161
	d_string "ALEC:<NL>"
	d_string "<IND>Halt mal! Wieso kann dieses Ding eigentlich sprechen!?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0162
	d_string "LILY:<NL>"
	d_string "<IND>Lass dich nicht von ihm reinlegen. Ein Bauchredner<NL>"
	d_string "<IND>kann sprechen, ohne den Mund zu bewegen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><03>"			; 0163
	d_string "DOROTHY:<NL>"
	d_string "<IND>Stimmt genau. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0164
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Krallenstark!<NL>"
	d_string "<SEL><IND>Das ist ... gruselig.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0165
	d_string "PRIMUS:<NL>"
	d_string "<IND>Leute, eins kapier’ ich nicht. Mit solchen Tricks<NL>"
	d_string "<IND>könnte man doch in jeder größeren Stadt ein<NL>"
	d_string "<IND>Vermögen als Straßenkünstler verdienen.<CLR>"
	d_string "<IND>Stattdessen lebst du hier draußen, ganz im Geheimen.<NL>"
	d_string "<IND>Es erscheint mir fast so, als ob du dich vor<NL>"
	d_string "<IND>irgendwem versteckst.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0166
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Bleib sofort stehen, du kleiner Bastard!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0167
	d_string "FUCHSENWELPE:<NL>"
	d_string "<IND>Wräffs! Ich häng’ fest!!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0168
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Hab ich dich endlich!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0169
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Also nochmal, WO IST MEINE MAHLZEIT?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0170
	d_string "FUCHSENWELPE:<NL>"
	d_string "<IND>Echt jetzt, keine Ahnung!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0171
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Wer’s glaubt!? Pass auf, wenn du mir nicht SOFORT<NL>"
	d_string "<IND>antwortest, mach ich dir einen Knoten in den<NL>"
	d_string "<IND>Schwanz! Kapiert?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0172
	d_string "FUCHSENWELPE:<NL>"
	d_string "<IND>Hiiiilfe!!<NL>"
	d_string "<IND>*quiek*<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0173
	d_string "LILY:<NL>"
	d_string "<IND>Wir sollten dem Kleinen helfen!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0174
	d_string "ALEC:<NL>"
	d_string "<IND>Unbedingt!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><02>"			; 0175
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Häh?<NL>"
	d_string "<IND>Was für räudige Schakale seid ihr?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0176
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>*Keuch, schnauf*<NL>"
	d_string "<IND>Deppen! Ihr seid schuld, dass der kleine Dieb fliehen<NL>"
	d_string "<IND>konnte.<CLR>"
	d_string "<IND>Ich hätte ihn vermöbeln sollen, solange ich<NL>"
	d_string "<IND>Gelegenheit hatte!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0177
	d_string "PRIMUS:<NL>"
	d_string "<IND>Moment mal ... Hat er dir was gestohlen?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0178
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Ja, verdammt! FRESSEN! <B>EIER!!<B><00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0179
	d_string "ALEC:<NL>"
	d_string "<IND>Oha ... Das klingt nicht gut.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0180
	d_string "LILY:<NL>"
	d_string "<IND>Entschuldige das Missverständnis. Wir nahmen an ...<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0181
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND><B>Mir doch schnuppe!<B><CLR>"
	d_string "<BG><01>"
	d_string "<IND>Meine Eier sind weg, darum geht’s!<NL>"
	d_string "<IND>Waren übrigens Fasaneneier. Sehr nahrhaft.<NL>"
	d_string "<IND>Und jetzt sind sie EINFACH WEG!<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0182
	d_string "ALEC:<NL>"
	d_string "<IND>Als Jäger weiß ich, wo Fasane brüten.<NL>"
	d_string "<IND>Ich kann dir helfen, frischen Ersatz zu besorgen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0183
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Wirklich?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0184
	d_string "ALEC:<NL>"
	d_string "<IND>Ja doch.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0185
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Warum willst du das für mich tun?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0186
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Wir schulden dir immerhin was.<NL>"
	d_string "<SEL><IND>Ich gönn’ dir was Leckeres zum Aufschlürfen. ♥<NL>"
	d_string "<SEL><IND>(Stattdessen Lily antworten lassen)<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0187
	d_string "LILY:<NL>"
	d_string "<IND>Alec hat recht. Schließlich sind wir schuld an<NL>"
	d_string "<IND>deinem Verlust und daher verpflichtet, dir Ersatz<NL>"
	d_string "<IND>zu beschaffen.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0188
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Stimmt. Also gehen wir.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0189
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Werd’ ich, verlass dich drauf. ♥<NL>"
	d_string "<IND>Joa, dann los.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0190
	d_string "ALEC:<NL>"
	d_string "<IND>Wie heißt du eigentlich?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0191
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Nennt mich Mickey.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0192
	d_string "ALEC:<NL>"
	d_string "<SEL><IND>Ich bin Alec, und das sind meine Freunde.<NL>"
	d_string "<SEL><IND>Nenn mich Leonido. ♥<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0193
	d_string "BRAUNBÄR:<NL>"
	d_string "<IND>Habe die Ehre. Ähem ...<CLR>"
@Jump01:
	d_string "<IND>Mein Name ist Gregory Perpetuus Ebenezer<NL>"
	d_string "<IND>Hrabanus Eindhoven Dubois Quaoar van der<NL>"
	d_string "<IND>Mühlhausen Nido sulle Colline ... Junior.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0194
	d_string "LILY:<NL>"
	d_string "<IND>Oh. Tatsächlich.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0195
	d_string "PRIMUS:<NL>"
	d_string "<IND>Junior, heh.<NL>"
	d_string "<IND>I wonder what the senior’s names might have been<NL>"
	d_string "<IND>then.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0196
	d_string "ALEC:<NL>"
	d_string "<IND>Gregory ...<NL>"
	d_string "<SEL><IND>Say that again?<NL>"
	d_string "<SEL><IND>Can I call you Greg?<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0197
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>Selbstverständlich. Ähem ...<CLR>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-5}}@Jump01

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0198
	d_string "LILY:<NL>"
	d_string "<IND>That’s a mouthful.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0199
	d_string "BROWN BEAR:<NL>"
@Jump01:
	d_string "<IND>I prefer to go by Greg anyway.<00>"

	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0200
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>That’s fine.<NL>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-2}}@Jump01

	d_string kLangDEU, "<PORTRAIT><00><BG><05>"			; 0201
	d_string "TARA:<NL>"
	d_string "<IND>Nimm ja deine Pfote von mir!<00>"

/*
	d_string kLangDEU, "<PORTRAIT><00><BG><01>"			; 0202
	d_string "<NL>"
	d_string "<IND><NL>"
	d_string "<IND><NL>"
	d_string "<IND><00>"
*/

; test strings

;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa"
;	d_string "l<NL>"
;	d_string "i1<NL>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<CLR>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<NL>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<00>"



; EOF
