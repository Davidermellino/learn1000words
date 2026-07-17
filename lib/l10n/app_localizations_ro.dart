// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get navHome => 'Acasă';

  @override
  String get navWords => 'Cuvinte';

  @override
  String get navFriends => 'Prieteni';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Anulează';

  @override
  String get confirm => 'Confirmă';

  @override
  String get back => 'Înapoi';

  @override
  String get next => 'Înainte';

  @override
  String get finish => 'Termină';

  @override
  String get retry => 'Reîncearcă';

  @override
  String get logIn => 'Autentificare';

  @override
  String get signUp => 'Înregistrare';

  @override
  String get authCreateAccount => 'Creează-ți contul';

  @override
  String get authWelcomeBack => 'Bine ai revenit';

  @override
  String get authRegisterSubtitle =>
      'Înregistrează-te pentru a-ți salva progresul în cloud și a-l regăsi pe orice dispozitiv.';

  @override
  String get authLoginSubtitle =>
      'Autentifică-te pentru a-ți regăsi progresul.';

  @override
  String get authContinueGoogle => 'Continuă cu Google';

  @override
  String get authContinueApple => 'Continuă cu Apple';

  @override
  String get authOrWithEmail => 'sau cu e-mail';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Parolă';

  @override
  String get authSwitchToLogin => 'Ai deja un cont? Autentifică-te';

  @override
  String get authSwitchToRegister => 'Nu ai un cont? Înregistrează-te';

  @override
  String get authEnterEmailPassword => 'Introdu e-mailul și parola.';

  @override
  String get authSignupPending =>
      'Înregistrare inițiată: confirmă-ți e-mailul, apoi autentifică-te cu datele tale.';

  @override
  String get authGenericError => 'Ceva nu a mers bine. Încearcă din nou.';

  @override
  String get authNotConfigured =>
      'Sincronizarea în cloud nu este configurată în această versiune.\nVezi SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Porecla este deja folosită';

  @override
  String get nicknameTakenBody =>
      'Altcineva a ales deja această poreclă. Alege alta:';

  @override
  String get nicknameLabel => 'Poreclă';

  @override
  String get nicknamePrompt => 'Cum vrei să-ți spunem?';

  @override
  String get nicknameLengthError =>
      'Trebuie să aibă între 3 și 20 de caractere';

  @override
  String get avatarPrompt => 'Alege-ți avatarul';

  @override
  String get dailyGoalPrompt => 'Câte cuvinte pe zi?';

  @override
  String languagesLoadError(Object error) {
    return 'Eroare la încărcarea limbilor:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Nicio limbă disponibilă.';

  @override
  String get pickSourceLanguage => 'Din ce limbă vrei să pornești?';

  @override
  String get pickTargetLanguage => 'Ce limbă vrei să înveți?';

  @override
  String levelsLoadError(Object error) {
    return 'Eroare la încărcarea nivelurilor:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Termină mai întâi nivelul $level';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Nivelul $level, blocat';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Nivelul $level, $memorized din $total cuvinte';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get noProfileYet => 'Încă niciun profil.';

  @override
  String memorizedWordsCount(int count) {
    return 'Cuvinte memorate: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Nivel actual: $level';
  }

  @override
  String get languageTileTitle => 'Limbă';

  @override
  String get account => 'Cont';

  @override
  String get accountLinked => 'Cont conectat';

  @override
  String get signOut => 'Deconectare';

  @override
  String get deleteAccount => 'Șterge contul';

  @override
  String get deleteAccountSubtitle =>
      'Îți elimină definitiv contul și toate datele.';

  @override
  String get signOutConfirmTitle => 'Te deconectezi de la cont?';

  @override
  String get signOutConfirmBody =>
      'Datele de pe acest dispozitiv vor fi eliminate. Progresul tău rămâne în siguranță în cloud și este restaurat la următoarea autentificare.';

  @override
  String get deleteAccountConfirmTitle => 'Ștergi contul?';

  @override
  String get deleteAccountConfirmBody =>
      'Această acțiune este imediată și ireversibilă. Contul tău, progresul tău și toate datele asociate vor fi șterse definitiv din cloud și de pe acest dispozitiv. Nu poate fi anulată și nici recuperată.';

  @override
  String get deleteAccountConfirmButton => 'Șterge definitiv';

  @override
  String get todayLabel => 'Astăzi';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak de zile',
      few: '$streak zile',
      one: '$streak zi',
    );
    return '$count/$goal cuvinte azi · 🔥 serie de $_temp0';
  }

  @override
  String get goalReached => 'Obiectiv atins! 🎉';

  @override
  String get settingsTitle => 'Setări';

  @override
  String get dailyGoalLabel => 'Obiectiv zilnic';

  @override
  String goalWordsSegment(int goal) {
    return '$goal cuvinte';
  }

  @override
  String get reminderTitle => 'Memento zilnic';

  @override
  String get appLanguageTitle => 'Limba aplicației';

  @override
  String get systemDefaultLanguage => 'Implicită din sistem';

  @override
  String flashcardsTitle(int level) {
    return 'Cartonașe · Nivelul $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Eroare la încărcarea cuvintelor:\n$error';
  }

  @override
  String get noWordsInLevel => 'Niciun cuvânt la acest nivel.';

  @override
  String get flashcardsOrdered => 'În ordine';

  @override
  String get flashcardsOrderedSubtitle =>
      'Pentru a învăța cuvintele prima dată';

  @override
  String get flashcardsRandom => 'Aleatoriu';

  @override
  String get flashcardsRandomSubtitle =>
      'Pentru a recapitula în ordine aleatorie';

  @override
  String get flashcardPrevious => 'Anterior';

  @override
  String get flashcardNext => 'Următor';

  @override
  String get tapToReturn => 'Atinge pentru a reveni';

  @override
  String get tapForTranslation => 'Atinge pentru traducere';

  @override
  String testTitle(int level) {
    return 'Test · Nivelul $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Eroare la încărcarea testului:\n$error';
  }

  @override
  String get answerWrong => 'Greșit';

  @override
  String get correctAnswerPrefix => 'Răspuns corect: ';

  @override
  String get check => 'Verifică';

  @override
  String get answerCorrect => 'Corect';

  @override
  String get testCompleted => 'Test finalizat!';

  @override
  String testScore(int correct, int total) {
    return '$correct din $total cuvinte memorate.';
  }

  @override
  String get retryRemaining => 'Reîncearcă cuvintele rămase';

  @override
  String get backToLevel => 'Înapoi la nivel';

  @override
  String get levelCompleted => 'Nivel finalizat!';

  @override
  String get allWordsMemorized =>
      'Ai memorat deja toate cuvintele de la acest nivel.';

  @override
  String usageTitle(int level) {
    return 'Utilizare · Nivelul $level';
  }

  @override
  String get yourSentences => 'Propozițiile tale';

  @override
  String loadErrorGeneric(Object error) {
    return 'Eroare la încărcare:\n$error';
  }

  @override
  String get sentenceSaved => 'Propoziție salvată!';

  @override
  String get writeSentenceHint => 'Scrie o propoziție cu acest cuvânt…';

  @override
  String get done => 'Gata';

  @override
  String get anotherWord => 'Alt cuvânt';

  @override
  String get noMemorizedInLevel =>
      'Niciun cuvânt memorat la acest nivel.\nTermină mai întâi un test pentru a debloca exercițiul de utilizare.';

  @override
  String get noSentencesYet =>
      'Încă nicio propoziție.\nScrie una în exercițiul de utilizare!';

  @override
  String wordNumber(int id) {
    return 'Cuvântul nr. $id';
  }

  @override
  String get knownWordsTitle => 'Cuvinte cunoscute';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Cuvinte cunoscute · Nivelul $level';
  }

  @override
  String get searchWordHint => 'Caută un cuvânt…';

  @override
  String knownWordsCount(int count) {
    return '$count cuvinte cunoscute';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible din $total cuvinte';
  }

  @override
  String levelAbbr(int level) {
    return 'Niv. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Încă niciun cuvânt memorat.\nTreci testele pentru a completa această listă!';

  @override
  String levelTitle(int level) {
    return 'Nivelul $level';
  }

  @override
  String get level => 'NIVEL';

  @override
  String levelLoadError(Object error) {
    return 'Eroare la încărcarea nivelului:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Cartonașe';

  @override
  String get modeFlashcardsSubtitle => 'Învață cuvintele cu cartonașe';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Pune-te la încercare';

  @override
  String get modeUsageTitle => 'Utilizare';

  @override
  String get modeUsageSubtitle => 'Cuvintele în propoziții';

  @override
  String get modeKnownSubtitle => 'Cuvintele memorate de la acest nivel';

  @override
  String get memorizedWordsCaption => 'cuvinte memorate';

  @override
  String requestSentTo(Object nickname) {
    return 'Cerere trimisă către $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Tu și $nickname sunteți acum prieteni!';
  }

  @override
  String get requestRejected => 'Cerere respinsă';

  @override
  String get searchByNickname => 'Caută după poreclă';

  @override
  String get receivedRequests => 'Cereri primite';

  @override
  String get wantsToBeFriend => 'Vrea să-ți fie prieten';

  @override
  String get accept => 'Acceptă';

  @override
  String get reject => 'Respinge';

  @override
  String get yourFriends => 'Prietenii tăi';

  @override
  String get signInToFindFriends =>
      'Autentifică-te pentru a-ți găsi prietenii\nși a compara progresul.';

  @override
  String get noUsersFound => 'Niciun utilizator găsit.';

  @override
  String get alreadyFriends => 'Deja prieteni';

  @override
  String get requestSentLabel => 'Cerere trimisă';

  @override
  String get add => 'Adaugă';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Nivelul $level · $count cuvinte memorate';
  }

  @override
  String get noFriendsYet =>
      'Încă niciun prieten. Caută o poreclă mai sus pentru a trimite prima cerere.';

  @override
  String get errorNetwork =>
      'Serverul nu a putut fi contactat. Verifică-ți conexiunea și încearcă din nou.';

  @override
  String get errorSession =>
      'Sesiune expirată sau nevalidă. Autentifică-te din nou.';

  @override
  String get errorGeneric => 'A apărut o eroare. Încearcă din nou.';
}
