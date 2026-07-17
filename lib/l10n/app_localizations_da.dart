// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get navHome => 'Hjem';

  @override
  String get navWords => 'Ord';

  @override
  String get navFriends => 'Venner';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Annuller';

  @override
  String get confirm => 'Bekræft';

  @override
  String get back => 'Tilbage';

  @override
  String get next => 'Næste';

  @override
  String get finish => 'Færdig';

  @override
  String get retry => 'Prøv igen';

  @override
  String get logIn => 'Log ind';

  @override
  String get signUp => 'Tilmeld dig';

  @override
  String get authCreateAccount => 'Opret din konto';

  @override
  String get authWelcomeBack => 'Velkommen tilbage';

  @override
  String get authRegisterSubtitle =>
      'Tilmeld dig for at gemme dine fremskridt i skyen og finde dem igen på alle enheder.';

  @override
  String get authLoginSubtitle => 'Log ind for at finde dine fremskridt igen.';

  @override
  String get authContinueGoogle => 'Fortsæt med Google';

  @override
  String get authContinueApple => 'Fortsæt med Apple';

  @override
  String get authOrWithEmail => 'eller med e-mail';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Adgangskode';

  @override
  String get authSwitchToLogin => 'Har du allerede en konto? Log ind';

  @override
  String get authSwitchToRegister => 'Har du ikke en konto? Tilmeld dig';

  @override
  String get authEnterEmailPassword => 'Indtast din e-mail og adgangskode.';

  @override
  String get authSignupPending =>
      'Tilmelding startet: bekræft din e-mail, og log derefter ind med dine oplysninger.';

  @override
  String get authGenericError => 'Noget gik galt. Prøv igen.';

  @override
  String get authNotConfigured =>
      'Skysynkronisering er ikke konfigureret i denne build.\nSe SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Kaldenavn allerede i brug';

  @override
  String get nicknameTakenBody =>
      'En anden har allerede valgt dette kaldenavn. Vælg et andet:';

  @override
  String get nicknameLabel => 'Kaldenavn';

  @override
  String get nicknamePrompt => 'Hvad skal vi kalde dig?';

  @override
  String get nicknameLengthError => 'Skal være mellem 3 og 20 tegn';

  @override
  String get avatarPrompt => 'Vælg din avatar';

  @override
  String get dailyGoalPrompt => 'Hvor mange ord om dagen?';

  @override
  String languagesLoadError(Object error) {
    return 'Fejl ved indlæsning af sprogene:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Ingen sprog tilgængelige.';

  @override
  String get pickSourceLanguage => 'Hvilket sprog vil du tage udgangspunkt i?';

  @override
  String get pickTargetLanguage => 'Hvilket sprog vil du lære?';

  @override
  String levelsLoadError(Object error) {
    return 'Fejl ved indlæsning af niveauerne:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Gennemfør niveau $level først';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Niveau $level, låst';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Niveau $level, $memorized af $total ord';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get noProfileYet => 'Ingen profil endnu.';

  @override
  String memorizedWordsCount(int count) {
    return 'Indlærte ord: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Nuværende niveau: $level';
  }

  @override
  String get languageTileTitle => 'Sprog';

  @override
  String get account => 'Konto';

  @override
  String get accountLinked => 'Konto tilknyttet';

  @override
  String get signOut => 'Log ud';

  @override
  String get deleteAccount => 'Slet konto';

  @override
  String get deleteAccountSubtitle =>
      'Fjerner din konto og alle data permanent.';

  @override
  String get signOutConfirmTitle => 'Log ud af din konto?';

  @override
  String get signOutConfirmBody =>
      'Dataene på denne enhed fjernes. Dine fremskridt forbliver sikkert i skyen og gendannes, næste gang du logger ind.';

  @override
  String get deleteAccountConfirmTitle => 'Slet din konto?';

  @override
  String get deleteAccountConfirmBody =>
      'Denne handling er øjeblikkelig og uoprettelig. Din konto, dine fremskridt og alle tilknyttede data slettes permanent fra skyen og fra denne enhed. Det kan ikke fortrydes eller gendannes.';

  @override
  String get deleteAccountConfirmButton => 'Slet permanent';

  @override
  String get todayLabel => 'I dag';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak dages stime',
      one: '$streak dags stime',
    );
    return '$count/$goal ord i dag · 🔥 $_temp0';
  }

  @override
  String get goalReached => 'Mål nået! 🎉';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get dailyGoalLabel => 'Dagligt mål';

  @override
  String goalWordsSegment(int goal) {
    return '$goal ord';
  }

  @override
  String get reminderTitle => 'Daglig påmindelse';

  @override
  String get appLanguageTitle => 'Appens sprog';

  @override
  String get systemDefaultLanguage => 'Systemstandard';

  @override
  String flashcardsTitle(int level) {
    return 'Flashcards · Niveau $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Fejl ved indlæsning af ordene:\n$error';
  }

  @override
  String get noWordsInLevel => 'Ingen ord på dette niveau.';

  @override
  String get flashcardsOrdered => 'I rækkefølge';

  @override
  String get flashcardsOrderedSubtitle => 'For at lære ordene første gang';

  @override
  String get flashcardsRandom => 'Tilfældig';

  @override
  String get flashcardsRandomSubtitle =>
      'For at repetere i tilfældig rækkefølge';

  @override
  String get flashcardPrevious => 'Forrige';

  @override
  String get flashcardNext => 'Næste';

  @override
  String get tapToReturn => 'Tryk for at gå tilbage';

  @override
  String get tapForTranslation => 'Tryk for oversættelsen';

  @override
  String testTitle(int level) {
    return 'Test · Niveau $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Fejl ved indlæsning af testen:\n$error';
  }

  @override
  String get answerWrong => 'Forkert';

  @override
  String get correctAnswerPrefix => 'Rigtigt svar: ';

  @override
  String get check => 'Tjek';

  @override
  String get answerCorrect => 'Rigtigt';

  @override
  String get testCompleted => 'Test gennemført!';

  @override
  String testScore(int correct, int total) {
    return '$correct af $total ord indlært.';
  }

  @override
  String get retryRemaining => 'Prøv de resterende ord igen';

  @override
  String get backToLevel => 'Tilbage til niveauet';

  @override
  String get levelCompleted => 'Niveau gennemført!';

  @override
  String get allWordsMemorized =>
      'Du har allerede lært alle ordene på dette niveau.';

  @override
  String usageTitle(int level) {
    return 'Brug · Niveau $level';
  }

  @override
  String get yourSentences => 'Dine sætninger';

  @override
  String loadErrorGeneric(Object error) {
    return 'Fejl ved indlæsning:\n$error';
  }

  @override
  String get sentenceSaved => 'Sætning gemt!';

  @override
  String get writeSentenceHint => 'Skriv en sætning med dette ord…';

  @override
  String get done => 'Færdig';

  @override
  String get anotherWord => 'Et andet ord';

  @override
  String get noMemorizedInLevel =>
      'Ingen indlærte ord på dette niveau.\nGennemfør først en test for at låse op for brugsøvelsen.';

  @override
  String get noSentencesYet =>
      'Ingen sætninger endnu.\nSkriv en i brugsøvelsen!';

  @override
  String wordNumber(int id) {
    return 'Ord nr. $id';
  }

  @override
  String get knownWordsTitle => 'Kendte ord';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Kendte ord · Niveau $level';
  }

  @override
  String get searchWordHint => 'Søg efter et ord…';

  @override
  String knownWordsCount(int count) {
    return '$count kendte ord';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible af $total ord';
  }

  @override
  String levelAbbr(int level) {
    return 'Niv. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Ingen ord indlært endnu.\nBestå testene for at fylde denne liste!';

  @override
  String levelTitle(int level) {
    return 'Niveau $level';
  }

  @override
  String get level => 'NIVEAU';

  @override
  String levelLoadError(Object error) {
    return 'Fejl ved indlæsning af niveauet:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Flashcards';

  @override
  String get modeFlashcardsSubtitle => 'Lær ordene med kort';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Sæt dig selv på prøve';

  @override
  String get modeUsageTitle => 'Brug';

  @override
  String get modeUsageSubtitle => 'Ordene i sætninger';

  @override
  String get modeKnownSubtitle => 'De indlærte ord på dette niveau';

  @override
  String get memorizedWordsCaption => 'indlærte ord';

  @override
  String requestSentTo(Object nickname) {
    return 'Anmodning sendt til $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Du og $nickname er nu venner!';
  }

  @override
  String get requestRejected => 'Anmodning afvist';

  @override
  String get searchByNickname => 'Søg efter kaldenavn';

  @override
  String get receivedRequests => 'Modtagne anmodninger';

  @override
  String get wantsToBeFriend => 'Vil være din ven';

  @override
  String get accept => 'Accepter';

  @override
  String get reject => 'Afvis';

  @override
  String get yourFriends => 'Dine venner';

  @override
  String get signInToFindFriends =>
      'Log ind for at finde dine venner\nog sammenligne fremskridt.';

  @override
  String get noUsersFound => 'Ingen brugere fundet.';

  @override
  String get alreadyFriends => 'Allerede venner';

  @override
  String get requestSentLabel => 'Anmodning sendt';

  @override
  String get add => 'Tilføj';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Niveau $level · $count indlærte ord';
  }

  @override
  String get noFriendsYet =>
      'Ingen venner endnu. Søg efter et kaldenavn ovenfor for at sende din første anmodning.';

  @override
  String get errorNetwork =>
      'Kunne ikke kontakte serveren. Tjek din forbindelse, og prøv igen.';

  @override
  String get errorSession =>
      'Sessionen er udløbet eller ugyldig. Log ind igen.';

  @override
  String get errorGeneric => 'Der opstod en fejl. Prøv igen.';
}
