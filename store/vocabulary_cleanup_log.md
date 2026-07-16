# Vocabulary cleanup & generation log

_Template M - build language-pair JSON files from the source Excel workbooks._

## 0. Summary

- **Languages delivered (10, all Latin-script):** `it, en, es, fr, pt, ro, de, da, pl, hu`.
- **Pair files produced:** 45 = C(10,2), one per unordered pair, filenames in sorted code order (`<a>_<b>.json`, a<b).
- **Each file:** exactly 1000 aligned 1:1 entries across 10 complete levels of 100.
- **Sources:** `assets/1000_words.xlsx` (Italian anchor + en/es/fr/pt/ro/de/da/pl) and `assets/1000_hu.xlsx` (Hungarian).
- Master table built once; all 45 files generated mechanically from it, so any given `id` is mutually consistent across every file.

## 1. Scope decision - why 10 languages, not 17

The template assumed *every* sheet in `1000_words.xlsx` shares the same Italian word in column B. **This is only true for 8 of the 16 sheets.** Verified structure:

- **Italian-anchored (8 sheets, 0 row differences vs. the Italian column):** INGLESE(en), SPAGNOLO(es), FRANCESE(fr), PORTOGHESE(pt), ROMENO(ro), TEDESCO(de), DANESE(da), POLACCO(pl).
- **English-keyed, NOT Italian-anchored (8 sheets):** GRECO(el), RUSSO(ru), GIAPPONESE(ja), COREANO(ko), THAI(th), ARABO(ar), CINESE(zh), HINDI(hi). English keys in their own orderings (HINDI is alphabetical), differing row counts (el=890, ar=988, th=999, zh=991 data rows), and for ja/ko/th/zh the target column is a **romanized transliteration only** (no native script). They cannot be row-aligned to the Italian anchor without inventing most of their translations.

Per user direction, the 8 non-Latin/misaligned languages were **dropped for now**, and **Hungarian was added** from `assets/1000_hu.xlsx`.

- **Hungarian** (`UNGHERESE` sheet) is Italian-anchored in column B but in a **different row order**, so it was joined by **Italian word text** (not row position). Coverage: 992/1000; the 8 misses were all rows with defective Italian anchors (see 4.1), which were corrected and thus resolved.

## 2. Function-word exclusions

Function words are excluded per the task (articles, pronouns, prepositions, conjunctions, auxiliary/modal verbs, closed-class determiners/quantifiers/grammatical adverbs). **133 rows** were excluded, identified by the Italian anchor's grammatical class. The 70 cells the workbook pre-marked yellow (`FFFFFF00`) are a subset; the yellow marking stops after ~row 208, so the rest were self-identified. (Yellow markings were inconsistent across sheets - POLACCO carried none - so used only as a cross-check.)

Because the same Italian word can appear with different senses, exclusion is **by row/sense, not by word**: e.g. `cosa`=what (row 21) excluded but `cosa`=thing (row 161) kept; `ora`=now excluded, `ora`=hour kept; `stato`=been excluded, `stato`=state kept; `spesso`=often excluded, `spesso`=thick kept.

**Kept as content (judgment calls):** copulas/main verbs `essere`, `avere` and verb participles (`detto`, `stato`=state, past forms) - the source left them unmarked and they are taught as vocabulary. Cardinal numbers are kept (source did not mark them).

**Borderline grammatical adverbs - excluded, flagged for review:** `bene/well`, `tardi/late`, `una volta/once`, `insieme/together`, `presto/soon`, `presto/early`, `forse/perhaps`, `piuttosto/rather`, `piuttosto/pretty`, `avanti/forward`.

<details><summary>Full list of excluded rows (Excel row / Italian / English / Y=yellow)</summary>

- 3 / io / I / Y
- 4 / il suo / his / Y
- 5 / che / that / Y
- 6 / lui / he / Y
- 7 / per / for / Y
- 8 / su / on / Y
- 9 / come / as/like / Y
- 10 / con / with / Y
- 11 / loro / they / Y
- 12 / a / at / Y
- 15 / questo / this / Y
- 16 / da / from / Y
- 17 / di / by / Y
- 20 / ma / but / Y
- 21 / cosa / what / Y
- 22 / alcuni / some / Y
- 23 / quello / that / Y
- 24 / voi / you (plural) / Y
- 25 / o / or / Y
- 26 / il / the / Y
- 27 / di / of / Y
- 28 / a / to / Y
- 29 / e / and / Y
- 30 / un / a / an / Y
- 31 / in / in / Y
- 32 / noi / we / Y
- 34 / fuori / out / Y
- 35 / altro / other / Y
- 36 / che / quale / which / Y
- 38 / loro / their / Y
- 40 / se / if / Y
- 42 / come / how / Y
- 44 / ogni / each / Y
- 51 / anche / also
- 63 / anche / even/also
- 65 / qui / here / Y
- 66 / devo / I must
- 69 / tale / such
- 72 / perché / why
- 83 / noi / us / Y
- 84 / di nuovo / again / Y
- 91 / se stesso / himself / Y
- 94 / qualsiasi / any / Y
- 102 / dove / where
- 103 / dopo / after
- 104 / indietro / back
- 105 / poco / little
- 106 / solo / only
- 111 / ogni / every / Y
- 113 / me / me / Y
- 115 / il nostro / our / Y
- 116 / sotto / under / Y
- 118 / molto / very / Y
- 119 / attraverso / through / Y
- 120 / solo / just / Y
- 132 / molto / much
- 134 / prima / before / Y
- 139 / troppo / too / Y
- 140 / stesso / same / Y
- 141 / lei / she / Y
- 142 / tutto / all / Y
- 143 / ci / there / Y
- 144 / quando / when / Y
- 145 / su / up / Y
- 147 / il tuo / your / Y
- 149 / circa / about
- 150 / molti / many / Y
- 151 / allora / then / Y
- 152 / loro / them / Y
- 154 / sarebbe / would
- 155 / come / like / Y
- 156 / così / so / Y
- 157 / queste / these / Y
- 158 / lei / her / Y
- 163 / lui / him / Y
- 166 / di più / more / Y
- 168 / potuto / could
- 173 / no / no / Y
- 174 / più / most / Y
- 176 / il mio / my / Y
- 177 / oltre / over / Y
- 180 / di / than / Y
- 183 / che / who / Y
- 184 / può / may
- 185 / giù / down
- 187 / stato / been
- 188 / ora / now
- 194 / dovrebbe / should
- 201 / ancora / still
- 208 / fra / between / Y
- 212 / mai / never
- 229 / tardi / late
- 231 / non / don’t
- 232 / mentre / while
- 238 / pochi / few
- 251 / una volta / once
- 264 / insieme / together
- 274 / sempre / always
- 276 / quelli / those
- 277 / entrambi / both
- 279 / spesso / often
- 281 / fino a quando / until
- 288 / abbastanza / enough
- 294 / sopra / above
- 295 / mai / ever
- 298 / anche se / though
- 302 / presto / soon
- 332 / da / since
- 339 / niente / nothing
- 380 / sì / yes
- 386 / tra / among
- 430 / dietro / behind
- 441 / durante / during
- 446 / presto / early
- 459 / meno / less
- 463 / alcuni / several
- 465 / verso / toward
- 468 / contro / against
- 494 / forse / perhaps
- 521 / ancora / yet
- 592 / meno / least
- 595 / tranne / except
- 633 / altro / else
- 634 / abbastanza / quite
- 691 / se / whether
- 696 / deve / shall
- 702 / o / either
- 755 / la cui / whose
- 776 / così / thus
- 788 / piuttosto / rather
- 883 / piuttosto / pretty
- 901 / avanti / forward
- 926 / né / nor

</details>

## 3. Multi-value resolution (-> strictly 1:1)

Cells offering multiple options (separated by `/`, `,`, `or`, `oppure`, `;`) or carrying parenthetical annotations were reduced to a **single value = the first listed option**, and parenthetical glosses were stripped. Cells reduced by language in the source: Hungarian 305 (mostly grammatical-suffix variants on function words, later excluded), ~6 each in en/fr/pt/ro/de/da/pl (Spanish had none). Hungarian suffix-only variants like `-nak/-nek` occurred only on excluded function words; no content row retained a suffix fragment.

## 4. Corrections (objectively wrong / suboptimal -> corrected)

### 4.1 Defective source rows (Italian anchor broken)
The main workbook's Italian column itself contained typos, stray English, and multi-values. These rows were corrected across all languages:

| Excel row | was (it) | corrected it | note |
|---|---|---|---|
| 324 | rock | roccia | stray English "rock"; de had "Rock"=skirt, da "bly"=lead-metal |
| 410 | done | fatto | stray English "done" |
| 830 | master | maestro | stray English "master" |
| 440 | veroo | vero | typo "veroo"->vero |
| 394 | giuidare / dirigere | condurre | typo "giuidare"; fr had "Lire"=read |
| 458 | viaggi | viaggiare | plural "viaggi"->verb viaggiare |
| 300 | conversare / parlare | parlare | multi-value conversare/parlare |
| 56 | casa (...contesto...) | casa | annotation stripped; casa (home) |
| 37 | fare | fare | multi-value fare |
| 68 | alto | alto | multi-value alto |
| 336 | strada | strada | multi-value/ambiguous strada->street |
| 413 | sorgere / stare in piedi | alzarsi | multi-value sorgere/stare in piedi->stand up |
| 664 | salita / scalata | scalare | multi-value salita/scalata->climb |

### 4.2 Untranslated-English leaks corrected
The de/da/ro/pt/fr (and a few pl/hu) columns left many words **untranslated in English**. 332 cells across 153 rows were corrected to the proper native word. Genuine cognates / international loanwords that legitimately share the English spelling (e.g. `radio`, `test`, `team`, `bar`, `design`, `computer`, `atom`, `moment`, `bank`, German `Hand/Gold/Wind/Finger`, French `air/image/table/six`) were **kept**. Spanish required 0 leak-fixes; French only 3.

<details><summary>Full leak-correction table (Excel row -> {lang: value})</summary>

- 33: ro=doză, pl=puszka
- 41: ro=voință, de=Wille, da=vilje, pl=wola
- 46: pt=fixo
- 49: de=Luft
- 55: da=lægge
- 58: de=Hand
- 61: pt=soletrar
- 62: ro=adăuga
- 64: pt=terra, ro=pământ, de=Land, da=land
- 74: pt=homens, ro=bărbați, de=Männer, da=mænd
- 99: ro=obține
- 101: ro=trăi, da=leve
- 108: pt=homem, ro=bărbat, de=Mann, da=mand
- 169: pt=ir, ro=merge, de=gehen, da=gå
- 170: pt=vir, ro=veni, de=kommen, da=komme
- 172: de=Klang
- 189: da=finde
- 191: pt=ficar em pé, ro=a sta în picioare
- 219: hu=gazdaság
- 226: pt=mar, de=Meer, da=hav
- 250: da=stoppe
- 252: ro=bază, de=Basis, da=basis
- 258: pt=cor, ro=culoare, de=Farbe, da=farve
- 259: pt=rosto, ro=față, de=Gesicht, da=ansigt
- 261: de=Haupt, da=hoved
- 268: pt=começar, ro=începe, de=beginnen, da=begynde
- 278: de=Marke, da=mærke
- 282: ro=milă
- 283: ro=râu, de=Fluss
- 286: pt=cuidado, ro=grijă, de=Pflege, da=pleje
- 306: pt=direto, de=direkt, da=direkte
- 307: ro=poză, de=Pose, da=positur
- 311: ro=ușă, de=Tür, da=dør
- 328: pt=problema, ro=problemă, de=Problem
- 331: ro=trece, de=passieren
- 333: fr=sommet, pl=szczyt, hu=csúcs
- 337: ro=țol, de=Zoll
- 356: pl=rekord
- 359: de=Gold
- 362: ro=loc
- 364: ro=minune
- 367: pl=temu
- 368: pt=correu, ro=alerga, de=lief
- 378: pt=pneu, ro=anvelopă, de=Reifen, da=dæk
- 390: pt=ótimo, ro=bine, de=fein, da=fin
- 393: pt=cair, ro=cădea, de=fallen, da=falde
- 403: de=Schachtel
- 409: pt=libra
- 412: pt=dirigir
- 418: de=endgültig
- 424: de=warm
- 426: pt=minuto, ro=minut, de=Minute, da=minut
- 429: de=Verstand
- 437: de=beste
- 448: de=Westen
- 451: ro=ajunge, da=nå
- 452: pt=rápido, ro=rapid, de=schnell, da=hurtig
- 453: pt=verbo, de=Verb, da=verbum
- 461: pt=dez, ro=zece, de=zehn, da=ti
- 466: pt=guerra, ro=război, de=Krieg, da=krig
- 467: pt=pôr, de=legen, da=lægge
- 475: pt=servir, ro=servi, de=servieren, da=servere
- 477: de=Karte
- 486: ro=vânătoare
- 487: pt=provável, ro=probabil, de=wahrscheinlich, da=sandsynlig
- 495: de=auswählen
- 498: da=firkant
- 502: ro=artă, pl=sztuka
- 505: pt=tamanho, ro=mărime, de=Größe, da=størrelse
- 519: pt=grande, ro=mare, de=groß, da=stor
- 523: da=dråbe
- 529: de=Position
- 533: da=materiale
- 537: da=løb
- 543: pt=provar, ro=dovedi, de=beweisen, da=bevise
- 544: ro=singur, da=ensom
- 551: ro=cer
- 562: de=Stelle
- 574: de=ertragen
- 581: pt=ir, ro=merge, de=gehen, da=gå
- 584: de=Ausflug
- 589: pt=exato, de=genau, da=nøjagtig
- 591: pt=morrer, ro=muri, de=sterben, da=dø
- 602: da=dame
- 611: pt=centavo
- 613: fr=équipe, pl=drużyna, hu=csapat
- 614: de=Draht
- 615: ro=cost
- 625: da=strøm
- 626: de=Messe, da=marked
- 639: pt=filho, ro=fiu, de=Sohn, da=søn
- 641: pt=momento
- 649: ro=națiune
- 654: pt=órgão
- 659: ro=nor, da=sky
- 665: de=kühl
- 668: da=parti
- 673: pt=único, de=einzeln, da=enkelt
- 674: pt=bastão, ro=băț, de=Stock
- 679: pt=vinco
- 682: pt=bebê, ro=bebeluș
- 686: pt=raiz, de=Wurzel
- 690: de=Metall
- 705: ro=deal, da=bakke
- 707: pt=gato, ro=pisică, de=Katze, da=kat
- 719: pt=rolo, ro=rulou, de=Rolle, da=rulle
- 727: pt=excitar, ro=excita, de=erregen, da=ophidse
- 730: da=sans
- 747: pt=colheita
- 750: pt=atingir, ro=lovi, de=schlagen, da=ramme
- 765: pt=átomo
- 772: de=Schiene
- 787: pt=morcego, ro=liliac, de=Fledermaus, da=flagermus, pl=nietoperz
- 793: pt=corda
- 794: ro=clopot
- 800: pt=dólar, ro=dolar
- 801: da=bæk
- 811: pt=mina, ro=mină
- 814: de=größer, da=større, pl=większy
- 817: da=sende
- 823: fr=tache, ro=pată, de=Fleck, da=plet, pl=plama
- 824: ro=deșert
- 825: pt=fato, ro=costum, de=Anzug, da=jakkesæt
- 827: de=Aufzug
- 829: pt=chegar, ro=sosi, de=ankommen, da=ankomme
- 831: de=Spur
- 833: da=kyst
- 837: pt=favorecer, ro=favoriza, de=begünstigen, da=favorisere
- 839: pt=mensagem, ro=mesaj, da=indlæg
- 841: ro=acord
- 843: pt=contente, ro=bucuros, de=froh
- 856: pt=instante, de=sofortig, da=øjeblik
- 859: ro=popula
- 874: pt=tronco, de=Baumstamm, da=træstamme
- 878: pt=concha
- 892: pt=partida, da=kamp
- 895: pt=figo, ro=smochină, da=figen
- 905: de=Punktzahl
- 906: ro=măr
- 908: pt=conduziu, ro=condus, de=führte, da=førte
- 909: pt=piche
- 913: pt=faixa, ro=bandă, da=bånd
- 925: da=dal
- 931: de=Diagramm
- 932: pt=chapéu, ro=pălărie, de=Hut
- 939: de=Geschäft
- 941: de=Begriff, da=betegnelse
- 953: pt=quarto de galão, ro=sfert de galon
- 963: da=skinne
- 976: da=flertal
- 977: pt=raiva, ro=furie, de=Wut, da=vrede
- 987: pt=caneta, de=Stift, da=kuglepen
- 993: pt=vaso, ro=vază, de=Vase

</details>

## 5. Added rows to refill to 1000

After excluding function words, 867 source-derived content rows remained. **133 rows of common everyday vocabulary were added** (model-authored, translated in all 10 languages), ordered by rough real-world frequency and appended after the source-derived rows (so they occupy the higher ids/levels). These are the ONLY invented entries; every other row is source-derived. Categories: family, food & drink, animals, body parts, household objects, places, professions, clothing, common adjectives.

<details><summary>Full list of added rows (final id / it / en)</summary>

- 868 / figlia / daughter
- 869 / marito / husband
- 870 / nonna / grandmother
- 871 / nonno / grandfather
- 872 / zio / uncle
- 873 / zia / aunt
- 874 / cugino / cousin
- 875 / autunno / autumn
- 876 / oggi / today
- 877 / domani / tomorrow
- 878 / ieri / yesterday
- 879 / formaggio / cheese
- 880 / burro / butter
- 881 / caffè / coffee
- 882 / tè / tea
- 883 / vino / wine
- 884 / birra / beer
- 885 / riso / rice
- 886 / patata / potato
- 887 / pomodoro / tomato
- 888 / cipolla / onion
- 889 / limone / lemon
- 890 / arancia / orange
- 891 / banana / banana
- 892 / uva / grape
- 893 / carota / carrot
- 894 / fagiolo / bean
- 895 / farina / flour
- 896 / torta / cake
- 897 / biscotto / cookie
- 898 / cioccolato / chocolate
- 899 / gelato / ice cream
- 900 / miele / honey
- 901 / zuppa / soup
- 902 / insalata / salad
- 903 / aceto / vinegar
- 904 / pepe / pepper
- 905 / succo / juice
- 906 / pollo / chicken
- 907 / maiale / pig
- 908 / pecora / sheep
- 909 / capra / goat
- 910 / coniglio / rabbit
- 911 / topo / mouse
- 912 / orso / bear
- 913 / leone / lion
- 914 / lupo / wolf
- 915 / volpe / fox
- 916 / scimmia / monkey
- 917 / elefante / elephant
- 918 / tigre / tiger
- 919 / giraffa / giraffe
- 920 / ape / bee
- 921 / farfalla / butterfly
- 922 / ragno / spider
- 923 / serpente / snake
- 924 / formica / ant
- 925 / mosca / fly
- 926 / zanzara / mosquito
- 927 / rana / frog
- 928 / squalo / shark
- 929 / balena / whale
- 930 / tartaruga / turtle
- 931 / oca / goose
- 932 / gallina / hen
- 933 / tacchino / turkey
- 934 / ginocchio / knee
- 935 / gomito / elbow
- 936 / labbra / lips
- 937 / schiena / back
- 938 / petto / chest
- 939 / stomaco / stomach
- 940 / cervello / brain
- 941 / unghia / nail
- 942 / barba / beard
- 943 / lacrima / tear
- 944 / cucina / kitchen
- 945 / bagno / bathroom
- 946 / specchio / mirror
- 947 / coltello / knife
- 948 / forchetta / fork
- 949 / cucchiaio / spoon
- 950 / piatto / plate
- 951 / tazza / cup
- 952 / tetto / roof
- 953 / sapone / soap
- 954 / asciugamano / towel
- 955 / spazzola / brush
- 956 / ombrello / umbrella
- 957 / valigia / suitcase
- 958 / borsa / bag
- 959 / portafoglio / wallet
- 960 / moneta / coin
- 961 / regalo / gift
- 962 / giocattolo / toy
- 963 / bambola / doll
- 964 / giornale / newspaper
- 965 / rivista / magazine
- 966 / film / movie
- 967 / ospedale / hospital
- 968 / chiesa / church
- 969 / albergo / hotel
- 970 / aeroporto / airport
- 971 / biblioteca / library
- 972 / museo / museum
- 973 / parco / park
- 974 / teatro / theatre
- 975 / farmacia / pharmacy
- 976 / autobus / bus
- 977 / ponte / bridge
- 978 / castello / castle
- 979 / torre / tower
- 980 / fabbrica / factory
- 981 / spiaggia / beach
- 982 / giungla / jungle
- 983 / arcobaleno / rainbow
- 984 / tuono / thunder
- 985 / fumo / smoke
- 986 / cenere / ash
- 987 / infermiere / nurse
- 988 / avvocato / lawyer
- 989 / ingegnere / engineer
- 990 / scrittore / writer
- 991 / cantante / singer
- 992 / pittore / painter
- 993 / cameriere / waiter
- 994 / contadino / farmer
- 995 / poliziotto / policeman
- 996 / camicia / shirt
- 997 / gonna / skirt
- 998 / calzini / socks
- 999 / guanti / gloves
- 1000 / cintura / belt

</details>

## 6. File generation

- **45 files** written to `assets/words/`, filenames in sorted alphabetical code order (`da_de.json` ... `pt_ro.json`). `source` = alphabetically-first code's column, `target` = the other; identical `id`/`level`/row order in every file.
- **No reverse-order duplicates** - verified every `<a>_<b>.json` has no `<b>_<a>.json`.
- **Removed** the two superseded it-first files: `it_es.json` (placeholder demo data) and `it_hu.json` (20-word stub). Their pairs are now served canonically by `es_it.json` and `hu_it.json`. (Both deletions are git-tracked and trivially revertible.)
- Schema unchanged: `{source,target,sourceName,targetName,version:1,words:[{id,level,source,target}]}`.

## 7. App-logic flag (reversed-pair lookup) - RESOLVED

The task asked whether the app already resolves a reversed user selection (e.g. picking `es` then `it`) to the same canonical file. **It does.** `lib/data/repositories/language_repository.dart` discovers files via `AssetManifest` (filename-agnostic) and emits **both directions** from each file (`pairId` = `src_tgt` AND `tgt_src`, from JSON *content*, not filename). So one file per unordered pair is correct, and sorted-vs-reversed filenames do not affect lookup. No app change needed. Progress is keyed by `(pairId, wordId)`; the `it_es`/`it_hu` pairIds still exist as reversed directions, so no pairId disappears.

## 8. Open items / doubts to review

- **Borderline function words** (2) - grammatical adverbs excluded on a judgment call; revisit if any should be kept as content.
- **Low-confidence translations flagged:** Danish `slittamento`->`slip` (kept; a valid Danish word but the intended sense is a skid/slide); a handful of Danish/Hungarian nuance choices among the added rows. All added-row translations are model-authored and should get a native-speaker pass before release.
- **Dropped languages** (el, ru, ja, ko, th, ar, zh, hi) remain unbuilt pending aligned/native-script source data.