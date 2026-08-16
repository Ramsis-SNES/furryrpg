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
;	d_string "<END>"
;
; Example for including a sub-string:
;	d_string "This is a sub-string: <SUBSTR>"
;	.DL <sub-string label>
;
; Things to keep in mind:
; - Sub-strings must have a proper NUL terminator.
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

.REPEAT 204 INDEX COUNT
	.DW STR_DialogueDEU{%.4d{COUNT}}				; create pointers for German dialogue strings
.ENDR



; GERMAN DIALOGUE
; --------------------------------------------------------------------------------------------------

.REDEFINE COUNT = 0							; 4-digit string numbers for reference. Regex search: \d{4}$ Insert Nums command: Ctrl+Alt+N, 0:1~04

	d_init kLangDEU, kPortrait_KIMAHRI, kBG_Blue			; 0000
	d_string "JÖRG BÄCKT QUASI ZWEI HAXENFÜSSE VOM WILDPONY.<NL>"
	d_string "jörg bäckt quasi zwei haxenfüße vom wildpony.<NL>"
	d_string "0123456789 ÄÖÜäëïöüß <B>Fetter Text<B><NL>"
	d_string "!“#$%&’()*+,-./:;<=>?@[\]^_`{|}~♥×♫<END>"

	d_init kLangDEU, kPortrait_GENGEN, kBG_Blue			; 0001
	d_string "GENGEN:<NL>"
	d_string "<IND>Ich Kobold!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Black			; 0002
	d_string "Beispieltext mit schwarzem Textbox-Hintergrund. Kann für<NL>"
	d_string "Erzähltext oder spezielle Benachrichtigungen benutzt<NL>"
	d_string "werden.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0003
	d_string "<ALEC>:<NL>"
	d_string "<IND>Uff, was für ein Traum!<CLR>"
	d_string "<IND>Ich habe die Fährte eines seltenen Mähnen-<NL>"
	d_string "<IND>Schneeleoparden verfolgt. Als ich ihn stellte,<NL>"
	d_string "<IND>hat er sich umgedreht und zu mir gesprochen ...<CLR>"
	d_string "<IND>Ich weiß nicht mehr, was er sagte, nur<NL>"
	d_string "<IND>dass es mich total mitgenommen hat.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0004
	d_string "<ALEC>:<NL>"
	d_string "<IND>Puh! Zum Glück war’s nur ein Traum.<CLR>"
	d_string "<IND>Warum führ ich eigentlich Selbstgespräche?<NL>"
	d_string "<IND>Ich sollte mich an die Arbeit machen!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0005
	d_string "<ALEC>:<NL>"
	d_string "<IND>Das ist mein Haus.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0006
	d_string "<ALEC>:<NL>"
	d_string "<IND>Meine Feuerstelle.<NL>"
	d_string "<IND>Vielleicht sollte ich heute noch etwas Feuerholz<NL>"
	d_string "<IND>sammeln ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0007
	d_string "<ALEC>:<NL>"
	d_string "<IND>Lecker, das Zeug. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0008
	d_string "<ALEC>:<NL>"
	d_string "<IND>Mein ganzes Feuerholz. Reicht aber noch nicht.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0009
	d_string "<ALEC>:<NL>"
	d_string "<IND>Was zum ...!?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Red			; 0010
	d_string "TIGRAN:<NL>"
	d_string "<IND>Kein Wunder, wenn du deine Deckung<NL>"
	d_string "<IND>aufgibst ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0011
	d_string "<ALEC>:<NL>"
	d_string "<IND>Och, hör doch auf, <Lily>.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0012
	d_string "<LILY>:<NL>"
	d_string "<IND>Tschuldige, <Alec>. Das konnte ich mir einfach<NL>"
	d_string "<IND>nicht verkneifen. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0013
	d_string "<ALEC>:<NL>"
	d_string "<IND>Was willst du?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0014
	d_string "<LILY>:<NL>"
	d_string "<IND>Sei nicht so schroff, ja!<NL>"
	d_string "<IND>Ich hab dir Kokosmilch mitgebracht.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0015
	d_string "<ALEC>:<NL>"
	d_string "<IND>Wozu das denn?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0016
	d_string "<LILY>:<NL>"
	d_string "<IND>Nun frag doch nicht dauernd so dummes Zeug,<NL>"
	d_string "<IND>sondern koste lieber mal.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0017
	d_string "<ALEC>:<NL>"
	d_string "<IND>Na gut, okay. Aber nur dir zuliebe.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0018
	d_string "<ALEC>:<NL>"
	d_string "<IND>Urgs ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0019
	d_string "<LILY>:<NL>"
	d_string "<IND>Die ist einfach köstlich, oder?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0020
	d_string "<ALEC>:<NL>"
	d_string "<IND>Ähmmmmm ...<NL>"
	d_string "<SEL><IND>Na ja, wie gesagt, ist halt Kokosmilch.<NL>"
	d_string "<SEL><IND>Igitt. Was gibt’s als nächstes, Pastinakensuppe?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0021
	d_string "<LILY>:<NL>"
	d_string "<IND>Ich wusste doch, dass du begeistert sein<NL>"
	d_string "<IND>würdest. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0022
	d_string "<LILY>:<NL>"
	d_string "<IND>Tut mir leid, <Alec>. Ich wollte dich nicht<NL>"
	d_string "<IND>ärgern.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0023
	d_string "<ALEC>:<NL>"
	d_string "<IND>Sorry ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0024
	d_string "<LILY>:<NL>"
	d_string "<IND>Keine Sorge, ist schon okay. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0025
	d_string "<ALEC>:<NL>"
	d_string "<IND>Aber bestimmt bist du nicht nur deshalb heute<NL>"
	d_string "<IND>so früh hergekommen, oder?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0026
	d_string "<LILY>:<NL>"
	d_string "<IND>Richtig, pass mal auf ...<CLR>"
	d_string kBG_Alert, "<IND>Das Schicksal der ganzen Welt hängt nur<NL>"
	d_string "<IND>von dir ab!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0027
	d_string "<LILY>:<NL>"
	d_string "<IND>Tihi, jetzt solltest du mal dein Gesicht<NL>"
	d_string "<IND>sehen ... ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0028
	d_string "<ALEC>:<NL>"
	d_string "<IND>Für ’ne Sekunde hab’ ich echt gedacht ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0029
	d_string "<LILY>:<NL>"
	d_string "<IND>Nee, aber du wirst Augen machen, wenn du erst<NL>"
	d_string "<IND>mal das hier hörst ...<CLR>"
	d_string "<IND>Der Bürgermeister verspricht demjenigen eine<NL>"
	d_string "<IND>Belohnung, der rausfindet, was es mit diesem<NL>"
	d_string "<IND>,,Geist“ auf sich hat, von dem alle reden. Ich hab<NL>"
	d_string "<IND>dir ja davon erzählt, weißt du noch?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0030
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Na klar!<NL>"
	d_string "<SEL><IND>Keine Ahnung, was du meinst!<NL>"
	d_string "<SEL><IND>Hilf mir mal auf die Sprünge ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0031
	d_string "<ALEC>:<NL>"
	d_string "<IND>Nicht nur du. Tusker hat neulich erzählt, aus<NL>"
	d_string "<IND>der Vorratskammer seiner Schänke sei ein<NL>"
	d_string "<IND>Dutzend Ringe Dauerwurst geklaut worden.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0032
	d_string "<LILY>:<NL>"
	d_string "<IND>Du lebst aber auch echt hinter dem Mond!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0033
	d_string "<ALEC>:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Hab mich halt um meinen eigenen Kram gekümmert.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0034
	d_string "<LILY>:<NL>"
	d_string "<IND>Also gut. Um es kurz zu machen, in letzter Zeit<NL>"
	d_string "<IND>verschwinden ständig spurlos irgendwelche Sachen.<CLR>"
	d_string "<IND>Dauerwurst verschwindet aus den Vorratskammern,<NL>"
	d_string "<IND>Wäsche und Schuhe sind abhandengekommen, und<NL>"
	d_string "<IND>sogar Werkzeuge und Angelruten lösen sich in Luft auf,<NL>"
	d_string "<IND>wenn kurz niemand hinschaut.<CLR>"
@Jump01:
	d_string "<IND>Der Kleine meiner Fuchsennachbarn behauptet<NL>"
	d_string "<IND>sogar, er hätte den ,,Geist“, der dafür verantwortlich<NL>"
	d_string "<IND>ist, mit seinen eigenen Augen gesehen ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0035
	d_string "<LILY>:<NL>"
	d_string "<IND>Abgesehen von Tuskers verschwundenen Würsten<NL>"
	d_string "<IND>sind im Dorf in letzter Zeit noch mehr komische<NL>"
	d_string "<IND>Sachen passiert.<CLR>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-2}}@Jump01

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0036
	d_string "<ALEC>:<NL>"
	d_string "<IND>Mit wessen Augen hätte er ihn auch sonst sehen<NL>"
	d_string "<IND>sollen?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0037
	d_string "<LILY>:<NL>"
	d_string "<IND>Genau das hab ich meinen Nachbarn auch gesagt.<NL>"
	d_string "<IND>Aber die sind mittlerweile alle drei zu Tode<NL>"
	d_string "<IND>verängstigt.<CLR>"
	d_string "<IND>Sogar Tusker, eigentlich ein vernünftiger Kerl,<NL>"
	d_string "<IND>glaubt mittlerweile lieber an übernatürliche<NL>"
	d_string "<IND>Kräfte. Mit evidenzbasierter Wissenschaft kommst<NL>"
	d_string "<IND>du bei niemandem mehr weit. Also dachte ich ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0038
	d_string "<ALEC>:<NL>"
	d_string "<IND>... ein Profi-Jäger könnte dir da behilflich<NL>"
	d_string "<IND>sein?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0039
	d_string "<LILY>:<NL>"
	d_string "<IND>Nicht irgendeiner, versteht sich. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0040
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Worin besteht die Belohnung?<NL>"
	d_string "<SEL><IND>Allzeit bereit für die Geisterjagd!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0041
	d_string "<LILY>:<NL>"
	d_string "<IND>Willst du denn gar nicht wissen, worin die Belohnung<NL>"
	d_string "<IND>des Bürgermeisters besteht?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0042
	d_string "<ALEC>:<NL>"
	d_string "<IND>Hm? Was ist es denn?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0043
	d_string "<LILY>:<NL>"
	d_string "<IND>Ein Haufen Gold, jede Menge Naturalien und<NL>"
	d_string "<IND>ewiger Ruhm, hab ich gehört.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0044
	d_string "<ALEC>:<NL>"
	d_string "<IND>Gold brauch’ ich nicht. Das mit dem Ruhm klingt<NL>"
	d_string "<IND>ganz in Ordnung. Schade, dass kein Feuerholz<NL>"
	d_string "<IND>dabei ist ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0045
	d_string "<LILY>:<NL>"
	d_string "<IND>Oh, ist es aber ... hab ich doch glatt vergessen<NL>"
	d_string "<IND>zu sagen! Drei, äh, Ster Feuerholz. Mindestens. Das<NL>"
	d_string "<IND>ist eigentlich sogar der Hauptpreis!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0046
	d_string "<ALEC>:<NL>"
	d_string "<IND>Also los, worauf warten wir noch?<NL>"
	d_string "<IND>Schließlich will ich heute früh am Abend<NL>"
	d_string "<IND>wieder zu Hause sein!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0047
	d_string "<LILY>:<NL>"
	d_string "<IND>Klar doch. ♥<CLR>"
	d_string kBG_Blue, "<IND>Übrigens, ich kenne jemanden, der uns helfen<NL>"
	d_string "<IND>kann. Bevor wir den Bürgermeister besuchen,<NL>"
	d_string "<IND>sollten wir mit ihm sprechen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Black			; 0048
	d_string "<NL><IND><IND><IND><IND><Lily><NL>"
	d_string "<IND><IND><IND><IND>schließt sich der Gruppe an!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0049
	d_string "<LILY>:<NL>"
	d_string "<IND>Da sind wir endlich.<NL>"
	d_string "<IND>Ach du liebes Bisschen ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0050
	d_string "<ALEC>:<NL>"
	d_string "<IND>Stimmt was nicht?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0051
	d_string "<LILY>:<NL>"
	d_string "<IND>Ich hab völlig vergessen, meinem Onkel Bescheid zu<NL>"
	d_string "<IND>sagen, dass ich eine Weile weg sein werde. Treffen<NL>"
	d_string "<IND>wir uns doch nachher in Tuskers Schänke, okay?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0052
	d_string "<ALEC>:<NL>"
	d_string "<IND>Ich geh auch gern mit dir mit!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0053
	d_string "<LILY>:<NL>"
	d_string "<IND>Das ist echt nett von dir, <Alec>. ♥<CLR>"
	d_string kBG_Blue, "<IND>... Aber du weißt ja, mein Onkel ist ein bisschen senil.<NL>"
	d_string "<IND>In seinem Zustand will er lieber keinen Besuch von<NL>"
	d_string "<IND>Fremden.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0054
	d_string "<ALEC>:<NL>"
	d_string "<IND>Okay. Dann bis später.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Black			; 0055
	d_string "<NL><IND><IND><IND><IND><Lily><NL>"
	d_string "<IND><IND><IND><IND>verlässt die Gruppe!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0056
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Hey-ho, Leonido ...<NL>"
	d_string "<IND>Für einen von deiner Sorte bist du aber ziemlich<NL>"
	d_string "<IND>klein. Du bist nicht zufällig ein Jäger, oder?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0057
	d_string "<ALEC>:<NL>"
	d_string "<IND>Nenn mich nicht ,,Leonido“!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Red			; 0058
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Okay-o, Leonido ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0059
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Hey-ho, Leonido ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0060
	d_string "<LILY>:<NL>"
	d_string "<IND>Was MACHT ihr zwei denn da!?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0061
	d_string "<LILY>:<NL>"
	d_string "<IND>Argh ... KERLE!<NL>"
	d_string "<IND>Entweder sie kabbeln sich oder ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0062
	d_string "<ALEC>:<NL>"
	d_string "<IND>Oder was?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0063
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Ich bin Soldat. Mich mit anderen zu kabbeln<NL>"
	d_string "<IND>ist mein Beruf.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0064
	d_string "<LILY>:<NL>"
	d_string "<IND>Aber das hier ist der Typ, der dir bei deiner<NL>"
	d_string "<IND>Mission am ehesten helfen kann, wie gesagt!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0065
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Aha, du bist also <Alec> Marlowe, der Jäger?<NL>"
	d_string "<IND>Dann muss ich mich entschuldigen. Freut mich,<NL>"
	d_string "<IND>dich kennenzulernen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0066
	d_string "<ALEC>:<NL>"
	d_string "<IND>Was sollte das alles?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0067
	d_string "<ALEC>:<NL>"
	d_string "<IND>Kleiner Tipp für’s nächste Mal ...<NL>"
	d_string "<IND>Erst fragen, wen du vor dir hast, bevor du<NL>"
	d_string "<IND>wildfremde Furros anschnauzt!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0068
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Das nennst du anschnauzen, ,,Leonido“?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0069
	d_string "<ALEC>:<NL>"
	d_string "<IND>Schluss damit!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0070
	d_string "<LILY>:<NL>"
	d_string "<IND>Nicht ärgern, <Alec>. Er hat sich ja nur<NL>"
	d_string "<IND>selbst zitiert.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0071
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Da hörst du’s, ,,Leonido“. Wieder ein<NL>"
	d_string "<IND>Zitat, versteht sich ...<CLR>"
	d_string "<IND>Übrigens bin ich selber schon oft genug<NL>"
	d_string "<IND>,,angeschnauzt“ worden, wenn auch aus anderen<NL>"
	d_string "<IND>Gründen.<CLR>"
	d_string "<IND>Um ehrlich zu sein, ist mir das völlig schnuppe.<NL>"
	d_string "<IND>Seit meiner Welpenzeit hab ich ein dickes Fell ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0072
	d_string "<ALEC>:<NL>"
	d_string "<IND>Du bist echt ein Spinner.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0073
	d_string "WOLFENSOLDAT:<NL>"
	d_string "<IND>Nein, ich bin <Primus> Greyfur, zu deinen Diensten.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0074
	d_string "<LILY>:<NL>"
	d_string "<IND>Er ist Soldat des Furderal Empire, <Alec>!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0075
	d_string "<ALEC>:<NL>"
	d_string "<IND>Na dann ...<NL>"
	d_string "<SEL><IND>Was hat dich hierher nach Librefur verschlagen?<NL>"
	d_string "<SEL><IND>Du bist also ein Deserteur?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0076
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Wenn ich ein Deserteur bin, dann bist du ein<NL>"
	d_string "<IND>Wilderer, Leonido.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0077
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Ich hatte keine Lust mehr auf muffige Baracken<NL>"
	d_string "<IND>und besoffene Hauptleute und bin neuerdings<NL>"
	d_string "<IND>Freiberufler. Soll heißen, ich arbeite für Geld.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0078
	d_string "<ALEC>:<NL>"
	d_string "<IND>Klingt nach ziemlich hartem Brot ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0079
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Zugegeben, manchmal kann es hart sein.<NL>"
	d_string "<IND>Aber gerade heute ist es das nicht ...<CLR>"
	d_string "<IND>Wenn ihr mich jetzt bitte entschuldigen wollt?<NL>"
	d_string "<IND>Ich habe einen Termin beim Bürgermeister. Nur falls ihr<NL>"
	d_string "<IND>es ernst meint und mich wirklich auf der Jagd nach dem<NL>"
	d_string "<IND>angeblichen Geist begleiten wollt.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0080
	d_string "<ALEC>:<NL>"
	d_string "<IND>Häh? Augenblick mal ...<CLR>"
	d_string "<IND><Lily>!<NL>"
	d_string "<IND>Das da gerade war doch MEIN Job!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0081
	d_string "<LILY>:<NL>"
	d_string "<IND>Und dein Job plus sein Job ergibt unseren Job,<NL>"
	d_string "<IND>stimmt’s?<NL>"
	d_string "<IND>Also ... Sollen wir langsam aufbrechen?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0082
	d_string "JUGENDLICHE WOLFEN:<NL>"
	d_string "<IND>La ♫ di ♫ da ♫<NL>"
	d_string "<IND>Ich glaub, dass dieser graufellige Soldat<NL>"
	d_string "<IND>mich mag. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0083
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Willkommen zu Ihrem Briefing, <Primus> Greyfur.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0084
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Danke, Bürgermeister. Diese beiden hier gehören<NL>"
	d_string "<IND>zu mir.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0085
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Fräulein Lilac Pondicherry ... Ich bin entzückt.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0086
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Wirklich?<NL>"
	d_string "<SEL><IND>Und was ist mit mir?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0087
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Und Alexis Moorflau, lange nicht gesehen ... Sir Greyfur,<NL>"
	d_string "<IND>jede Gefellschaft hat nun einmal ihren eigenen Bajazzo,<NL>"
	d_string "<IND>da stellt unser Dorf keine Ausnahme dar.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0088
	d_string "<ALEC>:<NL>"
	d_string "<IND>Ich heiße immer noch ALEC MARLOWE!<NL>"
	d_string "<IND>Und was zum Geier ist ein ,,Palazzo“!?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0089
	d_string "<LILY>:<NL>"
	d_string "<IND>Pssst ... Mach dir nix draus, <Alec>.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0090
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Im Namen aller Bewohner unseres Dorfes Furlorn<NL>"
	d_string "<IND>danke ich Ihnen dafür, dass Sie uns Ihre<NL>"
	d_string "<IND>Unterstützung anbieten, Sir Greyfur.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0091
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Einfach <Primus>, wenn es recht ist.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0092
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Ja, natürlich ... Sir Greyfur, wie Sie wahrscheinlich<NL>"
	d_string "<IND>wissen, erwartet denjenigen, der uns dieser<NL>"
	d_string "<IND>schrecklichen Bedrohung entledigt, ewiger Ruhm ...<CLR>"
	d_string "<IND>... zumal sie unser Dorf betrifft, seit Sie hier<NL>"
	d_string "<IND>eingetroffen sind.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0093
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Ja, ich ... Moment, wie war das? Nur Ruhm? Kein Gold?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0094
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Seien Sie unbesorgt. Natürlich werden Sie in jeder<NL>"
	d_string "<IND>erdenklichen Form zeitnah und großzügig entlohnt<NL>"
	d_string "<IND>werden. Darauf gebe ich Ihnen mein Wort.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0095
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Verstanden.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0096
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<IND>Dann ist es also abgemacht.<CLR>"
@Jump01:
	d_string "<IND>Reden Sie unbedingt mit allen Dorfbewohnern. Irgend<NL>"
	d_string "<IND>jemand unter uns muss einen Hinweis darauf haben,<NL>"
	d_string "<IND>wo Sie am besten anfangen zu suchen. Viel Glück!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0097
	d_string "GEISSENBÜRGERMEISTER:<NL>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-2}}@Jump01

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0098
	d_string "<ALEC>:<NL>"
	d_string "<IND>Das war’s dann mit meinem Extrastapel Feuerholz.<NL>"
	d_string "<IND><Lily>, wir müssen mal reden, du und ich.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0099
	d_string "<LILY>:<NL>"
	d_string "<IND>Denk doch an das Gold! Damit kannst du dir Feuerholz<NL>"
	d_string "<IND>kaufen, so viel du willst, oder etwa nicht?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0100
	d_string "<ALEC>:<NL>"
	d_string "<IND>Oh. Stimmt ...<NL>"
	d_string "<IND>Aber warum dann das ganze Theater?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0101
	d_string "<LILY>:<NL>"
	d_string "<IND>Entschuldige, <Alec> ... Du wolltest doch früh wieder zu<NL>"
	d_string "<IND>Hause sein. Ich fürchte, es könnte doch später<NL>"
	d_string "<IND>werden.<CLR>"
	d_string "<IND>Trotzdem, ich kenn’ dich doch. Ich wusste, du würdest<NL>"
	d_string "<IND>mir noch danken, dass ich dir einen Impuls gab, deine<NL>"
	d_string "<IND>Höhle zu verlassen, und ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0102
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Wenn ich kurz unterbrechen darf ... Seid ihr zwei<NL>"
	d_string "<IND>verwandt?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0103
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Nö, wir sind natürlich ein Paar.<NL>"
	d_string "<SEL><IND>Sie hat mir mal Lesen und Schreiben beigebracht ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0104
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>In Ordnung ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0105
	d_string "<LILY>:<NL>"
	d_string "<IND>Dem Bürgermeister zufolge sollen wir mit allen<NL>"
	d_string "<IND>Dorfbewohnern sprechen. Auf geht’s!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0106
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Wie auch immer, ich geh jetzt schlafen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0107
	d_string "<ALEC>:<NL>"
	d_string "<IND>Wie auch immer, worauf wartest du noch?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0108
	d_string "<ALEC>:<NL>"
	d_string "<IND>Jetzt wo er weg ist ...<NL>"
	d_string "<SEL><IND>(... schleich’ ich mich an und kitzele ihn durch! ♥)<NL>"
	d_string "<SEL><IND>(... stelle ich mich lieber mit <Lily> wieder gut.)<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0109
	d_string "<ALEC>:<NL>"
	d_string "<IND>Da ist sie ja ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0110
	d_string "<ALEC>:<NL>"
	d_string "<IND>Hör mal, ähm ... Ich hab nur Spaß gemacht.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0111
	d_string "<LILY>:<NL>"
	d_string "<IND>Ja, ich weiß.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0112
	d_string "<ALEC>:<NL>"
	d_string "<IND>Was?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0113
	d_string "<LILY>:<NL>"
	d_string "<IND>Wir kennen uns von Welpenpfoten an. In all den<NL>"
	d_string "<IND>Jahren hast du mich nicht ein einziges Mal in<NL>"
	d_string "<IND>Verlegenheit gebracht ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0114
	d_string "<ALEC>:<NL>"
	d_string "<IND>Ich ... echt nicht?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0115
	d_string "<LILY>:<NL>"
	d_string "<IND>Ehrenwort.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0116
	d_string "<ALEC>:<NL>"
	d_string "<IND>Na, dann seh’ ich lieber zu, dass das so bleibt.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0117
	d_string "<ALEC>:<NL>"
	d_string "<IND>Könntest du ... Also, würdest du uns morgen<NL>"
	d_string "<IND>dein Lieblingsessen machen?<NL>"
	d_string "<IND>Ich meine ... bitte?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0118
	d_string "<LILY>:<NL>"
	d_string "<IND>Oh, <Alec> ... Du bist so lieb. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0119
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Da bist du ja.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0120
	d_string "<ALEC>:<NL>"
	d_string "<IND>Wie hast du mich ...?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0121
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Heh. Du bist nicht der Einzige hier, der<NL>"
	d_string "<IND>eine feine Nase hat.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0122
	d_string "<ALEC>:<NL>"
	d_string "<IND>Ein schönes Plätzchen zum Schlafen hast du da<NL>"
	d_string "<IND>gefunden. Was dagegen, wenn ich mich zu dir<NL>"
	d_string "<IND>geselle?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0123
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Ich habe etwas dagegen, falls du schnarchst.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0124
	d_string "<ALEC>:<NL>"
	d_string "<IND>Keine Sorge, Kumpel.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0125
	d_string "<ALEC>:<NL>"
	d_string "<IND>Dann also ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0126
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Was ist noch?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0127
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Gute Nacht, <Primus>. Schlaf gut.<NL>"
	d_string "<SEL><IND>Wie deine Ohren im Mondlicht schimmern ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0128
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Gute Nacht, Leonido.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0129
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Du auch, <Alec>.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0130
	d_string "<ALEC>:<NL>"
	d_string "<IND>*Gäääähn*<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0131
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Höh!? Was ist das?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0132
	d_string "<ALEC>:<NL>"
	d_string "<IND>Pastinakensuppe. <Lily> steht da total drauf.<NL>"
	d_string "<IND>Einfach Nase zuhalten und auslöffeln.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0133
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>*murmel* *schmecktjawiefuchsenpisse* *grummel*<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0134
	d_string "<ALEC>:<NL>"
	d_string "<IND>Pst, sei bloß still!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0135
	d_string "<LILY>:<NL>"
	d_string "<IND>Oje ...<NL>"
	d_string "<IND>Wie’s aussieht, sitzen wir hier erst mal fest.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0136
	d_string "<ALEC>:<NL>"
	d_string "<IND>Keine Sorge. Ich räum’ das Gerümpel hier weg,<NL>"
	d_string "<IND>und schon können wir wieder verschwinden.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0137
	d_string "<LILY>:<NL>"
	d_string "<IND>Warte mal!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0138
	d_string "<ALEC>:<NL>"
	d_string "<IND>Was ist los?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0139
	d_string "<LILY>:<NL>"
	d_string "<IND>Wo wir schon hier sind, könnten wir uns<NL>"
	d_string "<IND>mal umsehen, meinst du nicht?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0140
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Sie hat recht, Leonido.<NL>"
	d_string "<IND>Meine Nase sagt mir, dass dieser Ort nicht ganz<NL>"
	d_string "<IND>fuchsenrein ist ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0141
	d_string "<ALEC>:<NL>"
	d_string "<IND>...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0142
	d_string "<ALEC>:<NL>"
	d_string "<IND>Also? Was tun wir?<NL>"
	d_string "<SEL><IND>(Schleunigst abhauen!)<NL>"
	d_string "<SEL><IND>(Bleiben und mal umschauen)<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0143
	d_string "<ALEC>:<NL>"
	d_string "<IND>Hier war seit Ewigkeiten keiner mehr.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0144
	d_string "<ALEC>:<NL>"
	d_string "<IND>Eine Puppe in Gestalt eines Fenneks.<NL>"
	d_string "<IND>Allerdings fehlen ihr die Augen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0145
	d_string "<LILY>:<NL>"
	d_string "<IND>Ein unheimlicher Ort.<NL>"
	d_string "<IND>Langsam denke ich, wir hätten lieber doch nicht<NL>"
	d_string "<IND>herkommen sollen ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Red			; 0146
	d_string "FENNEK-PUPPE:<NL>"
	d_string "<IND>Ich kann dich nicht sehen ...<NL>"
	d_string "<IND>... aber ich höre dein Herz schlagen!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0147
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Achtung! Weiterer Feind im Anmarsch!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0148
	d_string "MELODISCHE STIMME:<NL>"
	d_string "<IND>Ich habe keine bösen Absichten ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0149
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Ihr habt tapfer gekämpft.<NL>"
	d_string "<IND>Wer seid ihr?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0150
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Ich bin <Alec>, und das sind meine Freunde.<NL>"
	d_string "<SEL><IND>Dasselbe möchte ich dich fragen, Rotpelz!<NL>"
	d_string "<SEL><IND>(Stattdessen <Lily> antworten lassen)<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0151
	d_string "<LILY>:<NL>"
	d_string "<IND>Warum habt ihr uns angegriffen?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0152
	d_string "FREMDER FUCHS:<NL>"
@Jump01:
	d_string "<IND>Ich wollte euch kein Leid zufügen, und das gilt auch<NL>"
	d_string "<IND>für Dorothy.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0153
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Willkommen in meinem Bau, <Alec>.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0154
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Es tut mir aufrichtig leid, dass ich so unhöflich<NL>"
	d_string "<IND>gewesen bin.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0155
	d_string "FREMDER FUCHS:<NL>"
	d_string "<IND>Mein Name ist <Reinhold> von Pappenheim. Ich bin<NL>"
	d_string "<IND>Bauchredner von Beruf. Ich entschuldige mich<NL>"
	d_string "<IND>dafür, euch geängstigt zu haben ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0156
	d_string "<REINHOLD>:<NL>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-5}}@Jump01

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0157
	d_string "<ALEC>:<NL>"
	d_string "<IND>Schon mal zufälligerweise im Dorf Furlorn gewesen?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0158
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>War er definitiv. Habt ihr nicht auch diesen Duft<NL>"
	d_string "<IND>von Räucherwurst in der Nase, wie sie Tusker<NL>"
	d_string "<IND>vermisst hat?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0159
	d_string "<REINHOLD>:<NL>"
	d_string "<IND>Ich gestehe ein, dass ich aus Dörfern in der Nähe<NL>"
	d_string "<IND>Nahrung stibitzt habe. Hier draußen in der Wildnis<NL>"
	d_string "<IND>gibt es nichts zu essen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0160
	d_string "<LILY>:<NL>"
	d_string "<IND>Da haben wir also unseren ,,Geist“.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0161
	d_string "<ALEC>:<NL>"
	d_string "<IND>Nichts zu essen, sagst du? Aber die Wälder in dieser<NL>"
	d_string "<IND>Gegend sind voller Beute!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0162
	d_string "DOROTHY:<NL>"
	d_string "<IND>Er ist kein Jäger, wisst ihr. Und kein Sammler. Er ist nur<NL>"
	d_string "<IND>ein Bauernfänger. Ein Trickbetrüger, wenn man so will.<NL>"
	d_string "<IND>Ohne zu klauen wäre er in kurzer Zeit verhungert.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0163
	d_string "<ALEC>:<NL>"
	d_string "<IND>Halt mal! Wieso kann dieses Ding eigentlich sprechen!?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0164
	d_string "<LILY>:<NL>"
	d_string "<IND>Lass dich nicht von ihm reinlegen. Ein Bauchredner<NL>"
	d_string "<IND>kann sprechen, ohne den Mund zu bewegen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Pink			; 0165
	d_string "DOROTHY:<NL>"
	d_string "<IND>Stimmt genau. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0166
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Krallenstark!<NL>"
	d_string "<SEL><IND>Das ist ... gruselig.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0167
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Leute, eins kapier’ ich nicht. Mit solchen Tricks<NL>"
	d_string "<IND>könnte man doch in jeder größeren Stadt ein<NL>"
	d_string "<IND>Vermögen als Straßenkünstler verdienen.<CLR>"
	d_string "<IND>Stattdessen lebst du hier draußen, ganz im Geheimen.<NL>"
	d_string "<IND>Es erscheint mir fast so, als ob du dich vor<NL>"
	d_string "<IND>irgendwem versteckst.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0168
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Bleib sofort stehen, du kleiner Bastard!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0169
	d_string "FUCHSENWELPE:<NL>"
	d_string "<IND>Wräffs! Ich häng’ fest!!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0170
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Hab ich dich endlich!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0171
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Also nochmal, WO IST MEINE MAHLZEIT?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0172
	d_string "FUCHSENWELPE:<NL>"
	d_string "<IND>Echt jetzt, keine Ahnung!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0173
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Wer’s glaubt!? Pass auf, wenn du mir nicht SOFORT<NL>"
	d_string "<IND>antwortest, mach ich dir einen Knoten in den<NL>"
	d_string "<IND>Schwanz! Kapiert?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0174
	d_string "FUCHSENWELPE:<NL>"
	d_string "<IND>Hiiiilfe!!<NL>"
	d_string "<IND>*quiek*<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0175
	d_string "<LILY>:<NL>"
	d_string "<IND>Wir sollten dem Kleinen helfen!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0176
	d_string "<ALEC>:<NL>"
	d_string "<IND>Unbedingt!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Red			; 0177
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Häh?<NL>"
	d_string "<IND>Was für räudige Schakale seid ihr?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0178
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>*Keuch, schnauf*<NL>"
	d_string "<IND>Deppen! Ihr seid schuld, dass der kleine Dieb fliehen<NL>"
	d_string "<IND>konnte.<CLR>"
	d_string "<IND>Ich hätte ihn vermöbeln sollen, solange ich<NL>"
	d_string "<IND>Gelegenheit hatte!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0179
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Moment mal ... Hat er dir was gestohlen?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0180
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Ja, verdammt! FRESSEN! <B>EIER!!<B><END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0181
	d_string "<ALEC>:<NL>"
	d_string "<IND>Oha ... Das klingt nicht gut.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0182
	d_string "<LILY>:<NL>"
	d_string "<IND>Entschuldige das Missverständnis. Wir nahmen an ...<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0183
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND><B>Mir doch schnuppe!<B><CLR>"
	d_string kBG_Blue, "<IND>Meine Eier sind weg, darum geht’s!<NL>"
	d_string "<IND>Waren übrigens Fasaneneier. Sehr nahrhaft.<NL>"
	d_string "<IND>Und jetzt sind sie EINFACH WEG!<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0184
	d_string "<ALEC>:<NL>"
	d_string "<IND>Als Jäger weiß ich, wo Fasane brüten.<NL>"
	d_string "<IND>Ich kann dir helfen, frischen Ersatz zu besorgen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0185
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Wirklich?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0186
	d_string "<ALEC>:<NL>"
	d_string "<IND>Ja doch.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0187
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Warum willst du das für mich tun?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0188
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Wir schulden dir immerhin was.<NL>"
	d_string "<SEL><IND>Ich gönn’ dir was Leckeres zum Aufschlürfen. ♥<NL>"
	d_string "<SEL><IND>(Stattdessen <Lily> antworten lassen)<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0189
	d_string "<LILY>:<NL>"
	d_string "<IND><Alec> hat recht. Schließlich sind wir schuld an<NL>"
	d_string "<IND>deinem Verlust und daher verpflichtet, dir Ersatz<NL>"
	d_string "<IND>zu beschaffen.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0190
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Stimmt. Also gehen wir.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0191
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>Werd’ ich, verlass dich drauf. ♥<NL>"
	d_string "<IND>Joa, dann los.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0192
	d_string "<ALEC>:<NL>"
	d_string "<IND>Wie heißt du eigentlich?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0193
	d_string "MUSKELPARDE:<NL>"
	d_string "<IND>...<CLR>"
	d_string "<IND>Nennt mich <Mickey>.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0194
	d_string "<ALEC>:<NL>"
	d_string "<SEL><IND>Ich bin <Alec>, und das sind meine Freunde.<NL>"
	d_string "<SEL><IND>Nenn mich Leonido. ♥<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0195
	d_string "BRAUNBÄR:<NL>"
	d_string "<IND>Habe die Ehre. Ähem ...<CLR>"
@Jump01:
	d_string "<IND>Mein Name ist Gregory Perpetuus Ebenezer<NL>"
	d_string "<IND>Hrabanus Eindhoven Dubois Quaoar van der<NL>"
	d_string "<IND>Mühlhausen Nido sulle Colline ... Junior.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0196
	d_string "<LILY>:<NL>"
	d_string "<IND>Oh. Tatsächlich.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0197
	d_string "<PRIMUS>:<NL>"
	d_string "<IND>Junior, heh.<NL>"
	d_string "<IND>I wonder what the senior’s names might have been<NL>"
	d_string "<IND>then.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0198
	d_string "<ALEC>:<NL>"
	d_string "<IND>Gregory ...<NL>"
	d_string "<SEL><IND>Say that again?<NL>"
	d_string "<SEL><IND>Can I call you <Greg>?<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0199
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>Selbstverständlich. Ähem ...<CLR>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-5}}@Jump01

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0200
	d_string "<LILY>:<NL>"
	d_string "<IND>That’s a mouthful.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0201
	d_string "BROWN BEAR:<NL>"
@Jump01:
	d_string "<IND>I prefer to go by <Greg> anyway.<END>"

	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0202
	d_string "BROWN BEAR:<NL>"
	d_string "<IND>That’s fine.<NL>"
	d_string "<JMP>"
	.DL STR_DialogueDEU{%.4d{COUNT-2}}@Jump01

	d_init kLangDEU, kPortrait_NONE, kBG_Alert			; 0203
	d_string "TARA:<NL>"
	d_string "<IND>Nimm ja deine Pfote von mir!<END>"

/*
	d_init kLangDEU, kPortrait_NONE, kBG_Blue			; 0204
	d_string "<NL>"
	d_string "<IND><NL>"
	d_string "<IND><NL>"
	d_string "<IND><END>"
*/

; test strings

;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<NL>"
;	d_string "l<NL>"
;	d_string "i1<NL>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<CLR>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<NL>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<CLR>"
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaagga<NL>"	; unfinished last tile
;	d_string "aaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaaggaa<END>"

;	d_string "<SEL>Test1<NL>"
;	d_string "<SEL>Test2<NL>"
;	d_string "<SEL>Test3<NL>"
;	d_string "<SEL>Test4<END>"

;	d_string "<SUBSTR>"
;	.DL STR_SoftwareBuild
;	.DB $00



; EOF
