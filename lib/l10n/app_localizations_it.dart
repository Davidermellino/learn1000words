// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navWords => 'Parole';

  @override
  String get navFriends => 'Amici';

  @override
  String get navProfile => 'Profilo';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get back => 'Indietro';

  @override
  String get next => 'Avanti';

  @override
  String get finish => 'Fine';

  @override
  String get retry => 'Riprova';

  @override
  String get logIn => 'Accedi';

  @override
  String get signUp => 'Registrati';

  @override
  String get authCreateAccount => 'Crea il tuo account';

  @override
  String get authWelcomeBack => 'Bentornato';

  @override
  String get authRegisterSubtitle =>
      'Registrati per salvare i tuoi progressi nel cloud e ritrovarli su ogni dispositivo.';

  @override
  String get authLoginSubtitle => 'Accedi per ritrovare i tuoi progressi.';

  @override
  String get authContinueGoogle => 'Continua con Google';

  @override
  String get authContinueApple => 'Continua con Apple';

  @override
  String get authOrWithEmail => 'oppure con email';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get authSwitchToLogin => 'Hai già un account? Accedi';

  @override
  String get authSwitchToRegister => 'Non hai un account? Registrati';

  @override
  String get authEnterEmailPassword => 'Inserisci email e password.';

  @override
  String get authSignupPending =>
      'Registrazione avviata: conferma la tua email, poi accedi con le tue credenziali.';

  @override
  String get authGenericError => 'Qualcosa è andato storto. Riprova.';

  @override
  String get authNotConfigured =>
      'La sincronizzazione cloud non è configurata in questa build.\nVedi SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Nickname già in uso';

  @override
  String get nicknameTakenBody =>
      'Questo nickname è già stato scelto da qualcun altro. Scegline un altro:';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknamePrompt => 'Come vuoi essere chiamato?';

  @override
  String get nicknameLengthError => 'Deve avere tra 3 e 20 caratteri';

  @override
  String get avatarPrompt => 'Scegli il tuo avatar';

  @override
  String get dailyGoalPrompt => 'Quante parole al giorno?';

  @override
  String languagesLoadError(Object error) {
    return 'Errore nel caricamento delle lingue:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Nessuna lingua disponibile.';

  @override
  String get pickSourceLanguage => 'Da quale lingua vuoi partire?';

  @override
  String get pickTargetLanguage => 'Quale lingua vuoi imparare?';

  @override
  String levelsLoadError(Object error) {
    return 'Errore nel caricamento dei livelli:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Completa prima il livello $level';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Livello $level, bloccato';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Livello $level, $memorized di $total parole';
  }

  @override
  String get profileTitle => 'Profilo';

  @override
  String get noProfileYet => 'Nessun profilo ancora.';

  @override
  String memorizedWordsCount(int count) {
    return 'Parole memorizzate: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Livello attuale: $level';
  }

  @override
  String get languageTileTitle => 'Lingua';

  @override
  String get account => 'Account';

  @override
  String get accountLinked => 'Account collegato';

  @override
  String get signOut => 'Esci';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountSubtitle =>
      'Rimuove definitivamente il tuo account e tutti i dati.';

  @override
  String get signOutConfirmTitle => 'Uscire dall’account?';

  @override
  String get signOutConfirmBody =>
      'I dati su questo dispositivo verranno rimossi. I tuoi progressi restano al sicuro nel cloud e vengono ripristinati al prossimo accesso.';

  @override
  String get deleteAccountConfirmTitle => 'Eliminare l’account?';

  @override
  String get deleteAccountConfirmBody =>
      'Questa azione è immediata e irreversibile. Il tuo account, i tuoi progressi e tutti i dati associati verranno eliminati definitivamente dal cloud e da questo dispositivo. Non è possibile annullare né recuperare i dati.';

  @override
  String get deleteAccountConfirmButton => 'Elimina definitivamente';

  @override
  String get todayLabel => 'Oggi';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak giorni',
      one: '$streak giorno',
    );
    return '$count/$goal parole oggi · 🔥 serie di $_temp0';
  }

  @override
  String get goalReached => 'Obiettivo raggiunto! 🎉';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get dailyGoalLabel => 'Obiettivo giornaliero';

  @override
  String goalWordsSegment(int goal) {
    return '$goal parole';
  }

  @override
  String get reminderTitle => 'Promemoria giornaliero';

  @override
  String get appLanguageTitle => 'Lingua dell’app';

  @override
  String get systemDefaultLanguage => 'Predefinita del sistema';

  @override
  String flashcardsTitle(int level) {
    return 'Flashcard · Livello $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Errore nel caricamento delle parole:\n$error';
  }

  @override
  String get noWordsInLevel => 'Nessuna parola in questo livello.';

  @override
  String get flashcardsOrdered => 'In ordine';

  @override
  String get flashcardsOrderedSubtitle =>
      'Per imparare le parole la prima volta';

  @override
  String get flashcardsRandom => 'Casuale';

  @override
  String get flashcardsRandomSubtitle => 'Per ripassare in ordine sparso';

  @override
  String get flashcardPrevious => 'Precedente';

  @override
  String get flashcardNext => 'Successiva';

  @override
  String get tapToReturn => 'Tocca per tornare';

  @override
  String get tapForTranslation => 'Tocca per la traduzione';

  @override
  String testTitle(int level) {
    return 'Test · Livello $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Errore nel caricamento del test:\n$error';
  }

  @override
  String get answerWrong => 'Sbagliato';

  @override
  String get correctAnswerPrefix => 'Risposta corretta: ';

  @override
  String get check => 'Verifica';

  @override
  String get answerCorrect => 'Corretto';

  @override
  String get testCompleted => 'Test completato!';

  @override
  String testScore(int correct, int total) {
    return '$correct parole memorizzate su $total.';
  }

  @override
  String get retryRemaining => 'Riprova le parole rimaste';

  @override
  String get backToLevel => 'Torna al livello';

  @override
  String get levelCompleted => 'Livello completato!';

  @override
  String get allWordsMemorized =>
      'Hai già memorizzato tutte le parole di questo livello.';

  @override
  String usageTitle(int level) {
    return 'Uso · Livello $level';
  }

  @override
  String get yourSentences => 'Le tue frasi';

  @override
  String loadErrorGeneric(Object error) {
    return 'Errore nel caricamento:\n$error';
  }

  @override
  String get sentenceSaved => 'Frase salvata!';

  @override
  String get writeSentenceHint => 'Scrivi una frase con questa parola…';

  @override
  String get done => 'Fatto';

  @override
  String get anotherWord => 'Un’altra parola';

  @override
  String get noMemorizedInLevel =>
      'Nessuna parola memorizzata in questo livello.\nCompleta prima un test per sbloccare l’esercizio di uso.';

  @override
  String get noSentencesYet =>
      'Ancora nessuna frase.\nScrivine una nell’esercizio di uso!';

  @override
  String wordNumber(int id) {
    return 'Parola #$id';
  }

  @override
  String get knownWordsTitle => 'Parole conosciute';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Parole conosciute · Livello $level';
  }

  @override
  String get searchWordHint => 'Cerca una parola…';

  @override
  String knownWordsCount(int count) {
    return '$count parole conosciute';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible di $total parole';
  }

  @override
  String levelAbbr(int level) {
    return 'Liv. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Ancora nessuna parola memorizzata.\nSupera i test per riempire questo elenco!';

  @override
  String levelTitle(int level) {
    return 'Livello $level';
  }

  @override
  String get level => 'LIVELLO';

  @override
  String levelLoadError(Object error) {
    return 'Errore nel caricamento del livello:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Flashcard';

  @override
  String get modeFlashcardsSubtitle => 'Impara le parole con le carte';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Mettiti alla prova';

  @override
  String get modeUsageTitle => 'Uso';

  @override
  String get modeUsageSubtitle => 'Le parole nelle frasi';

  @override
  String get modeKnownSubtitle => 'Le parole memorizzate di questo livello';

  @override
  String get memorizedWordsCaption => 'parole memorizzate';

  @override
  String requestSentTo(Object nickname) {
    return 'Richiesta inviata a $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Ora tu e $nickname siete amici!';
  }

  @override
  String get requestRejected => 'Richiesta rifiutata';

  @override
  String get searchByNickname => 'Cerca per nickname';

  @override
  String get receivedRequests => 'Richieste ricevute';

  @override
  String get wantsToBeFriend => 'Vuole diventare tuo amico';

  @override
  String get accept => 'Accetta';

  @override
  String get reject => 'Rifiuta';

  @override
  String get yourFriends => 'I tuoi amici';

  @override
  String get signInToFindFriends =>
      'Accedi per trovare i tuoi amici\ne confrontare i progressi.';

  @override
  String get noUsersFound => 'Nessun utente trovato.';

  @override
  String get alreadyFriends => 'Già amici';

  @override
  String get requestSentLabel => 'Richiesta inviata';

  @override
  String get add => 'Aggiungi';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Livello $level · $count parole memorizzate';
  }

  @override
  String get noFriendsYet =>
      'Nessun amico ancora. Cerca un nickname qui sopra per inviare la prima richiesta.';

  @override
  String get errorNetwork =>
      'Impossibile contattare il server. Controlla la connessione e riprova.';

  @override
  String get errorSession => 'Sessione scaduta o non valida. Accedi di nuovo.';

  @override
  String get errorGeneric => 'Si è verificato un errore. Riprova.';
}
