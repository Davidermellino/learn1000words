// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navWords => 'Wörter';

  @override
  String get navFriends => 'Freunde';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get finish => 'Fertig';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get logIn => 'Anmelden';

  @override
  String get signUp => 'Registrieren';

  @override
  String get authCreateAccount => 'Erstelle dein Konto';

  @override
  String get authWelcomeBack => 'Willkommen zurück';

  @override
  String get authRegisterSubtitle =>
      'Registriere dich, um deinen Fortschritt in der Cloud zu speichern und auf jedem Gerät wiederzufinden.';

  @override
  String get authLoginSubtitle =>
      'Melde dich an, um deinen Fortschritt wiederzufinden.';

  @override
  String get authContinueGoogle => 'Mit Google fortfahren';

  @override
  String get authContinueApple => 'Mit Apple fortfahren';

  @override
  String get authOrWithEmail => 'oder mit E-Mail';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get authSwitchToLogin => 'Hast du schon ein Konto? Anmelden';

  @override
  String get authSwitchToRegister => 'Noch kein Konto? Registrieren';

  @override
  String get authEnterEmailPassword =>
      'Gib deine E-Mail und dein Passwort ein.';

  @override
  String get authSignupPending =>
      'Registrierung gestartet: Bestätige deine E-Mail und melde dich dann mit deinen Zugangsdaten an.';

  @override
  String get authGenericError =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get authNotConfigured =>
      'Die Cloud-Synchronisierung ist in diesem Build nicht konfiguriert.\nSiehe SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Spitzname bereits vergeben';

  @override
  String get nicknameTakenBody =>
      'Jemand anderes hat diesen Spitznamen bereits gewählt. Bitte wähle einen anderen:';

  @override
  String get nicknameLabel => 'Spitzname';

  @override
  String get nicknamePrompt => 'Wie sollen wir dich nennen?';

  @override
  String get nicknameLengthError => 'Muss zwischen 3 und 20 Zeichen lang sein';

  @override
  String get avatarPrompt => 'Wähle deinen Avatar';

  @override
  String get dailyGoalPrompt => 'Wie viele Wörter pro Tag?';

  @override
  String languagesLoadError(Object error) {
    return 'Fehler beim Laden der Sprachen:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Keine Sprachen verfügbar.';

  @override
  String get pickSourceLanguage => 'Von welcher Sprache möchtest du ausgehen?';

  @override
  String get pickTargetLanguage => 'Welche Sprache möchtest du lernen?';

  @override
  String levelsLoadError(Object error) {
    return 'Fehler beim Laden der Level:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Schließe zuerst Level $level ab';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Level $level, gesperrt';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Level $level, $memorized von $total Wörtern';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get noProfileYet => 'Noch kein Profil.';

  @override
  String memorizedWordsCount(int count) {
    return 'Gemerkte Wörter: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Aktuelles Level: $level';
  }

  @override
  String get languageTileTitle => 'Sprache';

  @override
  String get account => 'Konto';

  @override
  String get accountLinked => 'Konto verknüpft';

  @override
  String get signOut => 'Abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountSubtitle =>
      'Entfernt dein Konto und alle Daten endgültig.';

  @override
  String get signOutConfirmTitle => 'Vom Konto abmelden?';

  @override
  String get signOutConfirmBody =>
      'Die Daten auf diesem Gerät werden entfernt. Dein Fortschritt bleibt sicher in der Cloud und wird bei der nächsten Anmeldung wiederhergestellt.';

  @override
  String get deleteAccountConfirmTitle => 'Konto löschen?';

  @override
  String get deleteAccountConfirmBody =>
      'Diese Aktion erfolgt sofort und ist unwiderruflich. Dein Konto, dein Fortschritt und alle zugehörigen Daten werden endgültig aus der Cloud und von diesem Gerät gelöscht. Ein Rückgängigmachen oder Wiederherstellen ist nicht möglich.';

  @override
  String get deleteAccountConfirmButton => 'Endgültig löschen';

  @override
  String get todayLabel => 'Heute';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak Tage in Folge',
      one: '$streak Tag in Folge',
    );
    return '$count/$goal Wörter heute · 🔥 $_temp0';
  }

  @override
  String get goalReached => 'Ziel erreicht! 🎉';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get dailyGoalLabel => 'Tagesziel';

  @override
  String goalWordsSegment(int goal) {
    return '$goal Wörter';
  }

  @override
  String get reminderTitle => 'Tägliche Erinnerung';

  @override
  String get appLanguageTitle => 'App-Sprache';

  @override
  String get systemDefaultLanguage => 'Systemstandard';

  @override
  String flashcardsTitle(int level) {
    return 'Karteikarten · Level $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Fehler beim Laden der Wörter:\n$error';
  }

  @override
  String get noWordsInLevel => 'Keine Wörter in diesem Level.';

  @override
  String get flashcardsOrdered => 'Der Reihe nach';

  @override
  String get flashcardsOrderedSubtitle =>
      'Um die Wörter zum ersten Mal zu lernen';

  @override
  String get flashcardsRandom => 'Zufällig';

  @override
  String get flashcardsRandomSubtitle =>
      'Zum Wiederholen in zufälliger Reihenfolge';

  @override
  String get flashcardPrevious => 'Zurück';

  @override
  String get flashcardNext => 'Weiter';

  @override
  String get tapToReturn => 'Zum Zurückgehen tippen';

  @override
  String get tapForTranslation => 'Für die Übersetzung tippen';

  @override
  String testTitle(int level) {
    return 'Test · Level $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Fehler beim Laden des Tests:\n$error';
  }

  @override
  String get answerWrong => 'Falsch';

  @override
  String get correctAnswerPrefix => 'Richtige Antwort: ';

  @override
  String get check => 'Prüfen';

  @override
  String get answerCorrect => 'Richtig';

  @override
  String get testCompleted => 'Test abgeschlossen!';

  @override
  String testScore(int correct, int total) {
    return '$correct von $total Wörtern gemerkt.';
  }

  @override
  String get retryRemaining => 'Verbleibende Wörter erneut versuchen';

  @override
  String get backToLevel => 'Zurück zum Level';

  @override
  String get levelCompleted => 'Level abgeschlossen!';

  @override
  String get allWordsMemorized =>
      'Du hast dir bereits alle Wörter dieses Levels gemerkt.';

  @override
  String usageTitle(int level) {
    return 'Anwendung · Level $level';
  }

  @override
  String get yourSentences => 'Deine Sätze';

  @override
  String loadErrorGeneric(Object error) {
    return 'Fehler beim Laden:\n$error';
  }

  @override
  String get sentenceSaved => 'Satz gespeichert!';

  @override
  String get writeSentenceHint => 'Schreibe einen Satz mit diesem Wort…';

  @override
  String get done => 'Fertig';

  @override
  String get anotherWord => 'Ein anderes Wort';

  @override
  String get noMemorizedInLevel =>
      'Keine gemerkten Wörter in diesem Level.\nSchließe zuerst einen Test ab, um die Anwendungsübung freizuschalten.';

  @override
  String get noSentencesYet =>
      'Noch keine Sätze.\nSchreibe einen in der Anwendungsübung!';

  @override
  String wordNumber(int id) {
    return 'Wort Nr. $id';
  }

  @override
  String get knownWordsTitle => 'Bekannte Wörter';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Bekannte Wörter · Level $level';
  }

  @override
  String get searchWordHint => 'Suche ein Wort…';

  @override
  String knownWordsCount(int count) {
    return '$count bekannte Wörter';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible von $total Wörtern';
  }

  @override
  String levelAbbr(int level) {
    return 'Lvl $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Noch keine Wörter gemerkt.\nBestehe die Tests, um diese Liste zu füllen!';

  @override
  String levelTitle(int level) {
    return 'Level $level';
  }

  @override
  String get level => 'LEVEL';

  @override
  String levelLoadError(Object error) {
    return 'Fehler beim Laden des Levels:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Karteikarten';

  @override
  String get modeFlashcardsSubtitle => 'Lerne die Wörter mit Karten';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Stelle dich der Prüfung';

  @override
  String get modeUsageTitle => 'Anwendung';

  @override
  String get modeUsageSubtitle => 'Wörter in Sätzen';

  @override
  String get modeKnownSubtitle => 'Die gemerkten Wörter dieses Levels';

  @override
  String get memorizedWordsCaption => 'gemerkte Wörter';

  @override
  String requestSentTo(Object nickname) {
    return 'Anfrage an $nickname gesendet';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Du und $nickname seid jetzt Freunde!';
  }

  @override
  String get requestRejected => 'Anfrage abgelehnt';

  @override
  String get searchByNickname => 'Nach Spitzname suchen';

  @override
  String get receivedRequests => 'Erhaltene Anfragen';

  @override
  String get wantsToBeFriend => 'Möchte dein Freund werden';

  @override
  String get accept => 'Annehmen';

  @override
  String get reject => 'Ablehnen';

  @override
  String get yourFriends => 'Deine Freunde';

  @override
  String get signInToFindFriends =>
      'Melde dich an, um deine Freunde zu finden\nund den Fortschritt zu vergleichen.';

  @override
  String get noUsersFound => 'Keine Nutzer gefunden.';

  @override
  String get alreadyFriends => 'Bereits Freunde';

  @override
  String get requestSentLabel => 'Anfrage gesendet';

  @override
  String get add => 'Hinzufügen';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Level $level · $count gemerkte Wörter';
  }

  @override
  String get noFriendsYet =>
      'Noch keine Freunde. Suche oben nach einem Spitznamen, um deine erste Anfrage zu senden.';

  @override
  String get errorNetwork =>
      'Server konnte nicht erreicht werden. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get errorSession =>
      'Sitzung abgelaufen oder ungültig. Bitte melde dich erneut an.';

  @override
  String get errorGeneric =>
      'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';
}
