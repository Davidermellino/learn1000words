// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navWords => 'Słowa';

  @override
  String get navFriends => 'Znajomi';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get back => 'Wstecz';

  @override
  String get next => 'Dalej';

  @override
  String get finish => 'Zakończ';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get logIn => 'Zaloguj się';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get authCreateAccount => 'Utwórz konto';

  @override
  String get authWelcomeBack => 'Witaj ponownie';

  @override
  String get authRegisterSubtitle =>
      'Zarejestruj się, aby zapisać swoje postępy w chmurze i mieć do nich dostęp na każdym urządzeniu.';

  @override
  String get authLoginSubtitle => 'Zaloguj się, aby odzyskać swoje postępy.';

  @override
  String get authContinueGoogle => 'Kontynuuj z Google';

  @override
  String get authContinueApple => 'Kontynuuj z Apple';

  @override
  String get authOrWithEmail => 'lub e-mailem';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get authSwitchToLogin => 'Masz już konto? Zaloguj się';

  @override
  String get authSwitchToRegister => 'Nie masz konta? Zarejestruj się';

  @override
  String get authEnterEmailPassword => 'Wprowadź e-mail i hasło.';

  @override
  String get authSignupPending =>
      'Rejestracja rozpoczęta: potwierdź swój e-mail, a następnie zaloguj się swoimi danymi.';

  @override
  String get authGenericError => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get authNotConfigured =>
      'Synchronizacja w chmurze nie jest skonfigurowana w tej wersji.\nZobacz SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Pseudonim jest już zajęty';

  @override
  String get nicknameTakenBody =>
      'Ktoś inny wybrał już ten pseudonim. Wybierz inny:';

  @override
  String get nicknameLabel => 'Pseudonim';

  @override
  String get nicknamePrompt => 'Jak mamy się do Ciebie zwracać?';

  @override
  String get nicknameLengthError => 'Musi mieć od 3 do 20 znaków';

  @override
  String get avatarPrompt => 'Wybierz swój awatar';

  @override
  String get dailyGoalPrompt => 'Ile słów dziennie?';

  @override
  String languagesLoadError(Object error) {
    return 'Błąd podczas ładowania języków:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Brak dostępnych języków.';

  @override
  String get pickSourceLanguage => 'Od którego języka chcesz zacząć?';

  @override
  String get pickTargetLanguage => 'Którego języka chcesz się uczyć?';

  @override
  String levelsLoadError(Object error) {
    return 'Błąd podczas ładowania poziomów:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Najpierw ukończ poziom $level';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Poziom $level, zablokowany';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Poziom $level, $memorized z $total słów';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get noProfileYet => 'Brak profilu.';

  @override
  String memorizedWordsCount(int count) {
    return 'Zapamiętane słowa: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Aktualny poziom: $level';
  }

  @override
  String get languageTileTitle => 'Język';

  @override
  String get account => 'Konto';

  @override
  String get accountLinked => 'Konto połączone';

  @override
  String get signOut => 'Wyloguj się';

  @override
  String get deleteAccount => 'Usuń konto';

  @override
  String get deleteAccountSubtitle =>
      'Trwale usuwa Twoje konto i wszystkie dane.';

  @override
  String get signOutConfirmTitle => 'Wylogować się z konta?';

  @override
  String get signOutConfirmBody =>
      'Dane na tym urządzeniu zostaną usunięte. Twoje postępy pozostają bezpieczne w chmurze i zostaną przywrócone przy następnym logowaniu.';

  @override
  String get deleteAccountConfirmTitle => 'Usunąć konto?';

  @override
  String get deleteAccountConfirmBody =>
      'Ta czynność jest natychmiastowa i nieodwracalna. Twoje konto, postępy i wszystkie powiązane dane zostaną trwale usunięte z chmury i z tego urządzenia. Nie można tego cofnąć ani odzyskać danych.';

  @override
  String get deleteAccountConfirmButton => 'Usuń trwale';

  @override
  String get todayLabel => 'Dziś';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak dnia',
      many: '$streak dni',
      few: '$streak dni',
      one: '$streak dzień',
    );
    return '$count/$goal słów dziś · 🔥 seria $_temp0';
  }

  @override
  String get goalReached => 'Cel osiągnięty! 🎉';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get dailyGoalLabel => 'Cel dzienny';

  @override
  String goalWordsSegment(int goal) {
    return '$goal słów';
  }

  @override
  String get reminderTitle => 'Codzienne przypomnienie';

  @override
  String get appLanguageTitle => 'Język aplikacji';

  @override
  String get systemDefaultLanguage => 'Domyślny systemu';

  @override
  String flashcardsTitle(int level) {
    return 'Fiszki · Poziom $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Błąd podczas ładowania słów:\n$error';
  }

  @override
  String get noWordsInLevel => 'Brak słów na tym poziomie.';

  @override
  String get flashcardsOrdered => 'Po kolei';

  @override
  String get flashcardsOrderedSubtitle =>
      'Aby nauczyć się słów po raz pierwszy';

  @override
  String get flashcardsRandom => 'Losowo';

  @override
  String get flashcardsRandomSubtitle => 'Aby powtarzać w losowej kolejności';

  @override
  String get flashcardPrevious => 'Poprzednia';

  @override
  String get flashcardNext => 'Następna';

  @override
  String get tapToReturn => 'Dotknij, aby wrócić';

  @override
  String get tapForTranslation => 'Dotknij, aby zobaczyć tłumaczenie';

  @override
  String testTitle(int level) {
    return 'Test · Poziom $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Błąd podczas ładowania testu:\n$error';
  }

  @override
  String get answerWrong => 'Błędnie';

  @override
  String get correctAnswerPrefix => 'Poprawna odpowiedź: ';

  @override
  String get check => 'Sprawdź';

  @override
  String get answerCorrect => 'Poprawnie';

  @override
  String get testCompleted => 'Test ukończony!';

  @override
  String testScore(int correct, int total) {
    return 'Zapamiętano $correct z $total słów.';
  }

  @override
  String get retryRemaining => 'Powtórz pozostałe słowa';

  @override
  String get backToLevel => 'Powrót do poziomu';

  @override
  String get levelCompleted => 'Poziom ukończony!';

  @override
  String get allWordsMemorized =>
      'Zapamiętałeś już wszystkie słowa na tym poziomie.';

  @override
  String usageTitle(int level) {
    return 'Użycie · Poziom $level';
  }

  @override
  String get yourSentences => 'Twoje zdania';

  @override
  String loadErrorGeneric(Object error) {
    return 'Błąd podczas ładowania:\n$error';
  }

  @override
  String get sentenceSaved => 'Zdanie zapisane!';

  @override
  String get writeSentenceHint => 'Napisz zdanie z tym słowem…';

  @override
  String get done => 'Gotowe';

  @override
  String get anotherWord => 'Inne słowo';

  @override
  String get noMemorizedInLevel =>
      'Brak zapamiętanych słów na tym poziomie.\nNajpierw ukończ test, aby odblokować ćwiczenie użycia.';

  @override
  String get noSentencesYet => 'Brak zdań.\nNapisz jedno w ćwiczeniu użycia!';

  @override
  String wordNumber(int id) {
    return 'Słowo nr $id';
  }

  @override
  String get knownWordsTitle => 'Znane słowa';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Znane słowa · Poziom $level';
  }

  @override
  String get searchWordHint => 'Szukaj słowa…';

  @override
  String knownWordsCount(int count) {
    return '$count znanych słów';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible z $total słów';
  }

  @override
  String levelAbbr(int level) {
    return 'Poz. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Brak zapamiętanych słów.\nZalicz testy, aby wypełnić tę listę!';

  @override
  String levelTitle(int level) {
    return 'Poziom $level';
  }

  @override
  String get level => 'POZIOM';

  @override
  String levelLoadError(Object error) {
    return 'Błąd podczas ładowania poziomu:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Fiszki';

  @override
  String get modeFlashcardsSubtitle => 'Ucz się słów z fiszkami';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Sprawdź się';

  @override
  String get modeUsageTitle => 'Użycie';

  @override
  String get modeUsageSubtitle => 'Słowa w zdaniach';

  @override
  String get modeKnownSubtitle => 'Zapamiętane słowa na tym poziomie';

  @override
  String get memorizedWordsCaption => 'zapamiętanych słów';

  @override
  String requestSentTo(Object nickname) {
    return 'Zaproszenie wysłane do $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Ty i $nickname jesteście teraz znajomymi!';
  }

  @override
  String get requestRejected => 'Zaproszenie odrzucone';

  @override
  String get searchByNickname => 'Szukaj po pseudonimie';

  @override
  String get receivedRequests => 'Otrzymane zaproszenia';

  @override
  String get wantsToBeFriend => 'Chce zostać Twoim znajomym';

  @override
  String get accept => 'Akceptuj';

  @override
  String get reject => 'Odrzuć';

  @override
  String get yourFriends => 'Twoi znajomi';

  @override
  String get signInToFindFriends =>
      'Zaloguj się, aby znaleźć znajomych\ni porównać postępy.';

  @override
  String get noUsersFound => 'Nie znaleziono użytkowników.';

  @override
  String get alreadyFriends => 'Już znajomi';

  @override
  String get requestSentLabel => 'Zaproszenie wysłane';

  @override
  String get add => 'Dodaj';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Poziom $level · $count zapamiętanych słów';
  }

  @override
  String get noFriendsYet =>
      'Brak znajomych. Wyszukaj pseudonim powyżej, aby wysłać pierwsze zaproszenie.';

  @override
  String get errorNetwork =>
      'Nie można połączyć się z serwerem. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get errorSession =>
      'Sesja wygasła lub jest nieprawidłowa. Zaloguj się ponownie.';

  @override
  String get errorGeneric => 'Wystąpił błąd. Spróbuj ponownie.';
}
