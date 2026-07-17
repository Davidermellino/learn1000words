// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navWords => 'Words';

  @override
  String get navFriends => 'Friends';

  @override
  String get navProfile => 'Profile';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get retry => 'Retry';

  @override
  String get logIn => 'Log in';

  @override
  String get signUp => 'Sign up';

  @override
  String get authCreateAccount => 'Create your account';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authRegisterSubtitle =>
      'Sign up to save your progress to the cloud and find it on every device.';

  @override
  String get authLoginSubtitle => 'Log in to pick up your progress.';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authContinueApple => 'Continue with Apple';

  @override
  String get authOrWithEmail => 'or with email';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get authSwitchToLogin => 'Already have an account? Log in';

  @override
  String get authSwitchToRegister => 'Don\'t have an account? Sign up';

  @override
  String get authEnterEmailPassword => 'Enter your email and password.';

  @override
  String get authSignupPending =>
      'Registration started: confirm your email, then log in with your credentials.';

  @override
  String get authGenericError => 'Something went wrong. Please try again.';

  @override
  String get authNotConfigured =>
      'Cloud sync is not configured in this build.\nSee SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Nickname already in use';

  @override
  String get nicknameTakenBody =>
      'Someone else has already chosen this nickname. Please pick another one:';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknamePrompt => 'What should we call you?';

  @override
  String get nicknameLengthError => 'Must be between 3 and 20 characters';

  @override
  String get avatarPrompt => 'Choose your avatar';

  @override
  String get dailyGoalPrompt => 'How many words per day?';

  @override
  String languagesLoadError(Object error) {
    return 'Couldn\'t load the languages:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'No languages available.';

  @override
  String get pickSourceLanguage => 'Which language do you want to start from?';

  @override
  String get pickTargetLanguage => 'Which language do you want to learn?';

  @override
  String levelsLoadError(Object error) {
    return 'Couldn\'t load the levels:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Complete level $level first';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Level $level, locked';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Level $level, $memorized of $total words';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get noProfileYet => 'No profile yet.';

  @override
  String memorizedWordsCount(int count) {
    return 'Memorized words: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Current level: $level';
  }

  @override
  String get languageTileTitle => 'Language';

  @override
  String get account => 'Account';

  @override
  String get accountLinked => 'Account linked';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently removes your account and all data.';

  @override
  String get signOutConfirmTitle => 'Sign out of your account?';

  @override
  String get signOutConfirmBody =>
      'The data on this device will be removed. Your progress stays safe in the cloud and is restored the next time you log in.';

  @override
  String get deleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirmBody =>
      'This action is immediate and irreversible. Your account, your progress and all associated data will be permanently deleted from the cloud and from this device. This cannot be undone or recovered.';

  @override
  String get deleteAccountConfirmButton => 'Delete permanently';

  @override
  String get todayLabel => 'Today';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak-day streak',
      one: '$streak-day streak',
    );
    return '$count/$goal words today · 🔥 $_temp0';
  }

  @override
  String get goalReached => 'Goal reached! 🎉';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get dailyGoalLabel => 'Daily goal';

  @override
  String goalWordsSegment(int goal) {
    return '$goal words';
  }

  @override
  String get reminderTitle => 'Daily reminder';

  @override
  String get appLanguageTitle => 'App language';

  @override
  String get systemDefaultLanguage => 'System default';

  @override
  String flashcardsTitle(int level) {
    return 'Flashcards · Level $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Couldn\'t load the words:\n$error';
  }

  @override
  String get noWordsInLevel => 'No words in this level.';

  @override
  String get flashcardsOrdered => 'In order';

  @override
  String get flashcardsOrderedSubtitle =>
      'To learn the words for the first time';

  @override
  String get flashcardsRandom => 'Random';

  @override
  String get flashcardsRandomSubtitle => 'To revise in shuffled order';

  @override
  String get flashcardPrevious => 'Previous';

  @override
  String get flashcardNext => 'Next';

  @override
  String get tapToReturn => 'Tap to go back';

  @override
  String get tapForTranslation => 'Tap for the translation';

  @override
  String testTitle(int level) {
    return 'Test · Level $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Couldn\'t load the test:\n$error';
  }

  @override
  String get answerWrong => 'Wrong';

  @override
  String get correctAnswerPrefix => 'Correct answer: ';

  @override
  String get check => 'Check';

  @override
  String get answerCorrect => 'Correct';

  @override
  String get testCompleted => 'Test complete!';

  @override
  String testScore(int correct, int total) {
    return '$correct of $total words memorized.';
  }

  @override
  String get retryRemaining => 'Retry the remaining words';

  @override
  String get backToLevel => 'Back to the level';

  @override
  String get levelCompleted => 'Level complete!';

  @override
  String get allWordsMemorized =>
      'You\'ve already memorized all the words in this level.';

  @override
  String usageTitle(int level) {
    return 'Usage · Level $level';
  }

  @override
  String get yourSentences => 'Your sentences';

  @override
  String loadErrorGeneric(Object error) {
    return 'Loading failed:\n$error';
  }

  @override
  String get sentenceSaved => 'Sentence saved!';

  @override
  String get writeSentenceHint => 'Write a sentence with this word…';

  @override
  String get done => 'Done';

  @override
  String get anotherWord => 'Another word';

  @override
  String get noMemorizedInLevel =>
      'No memorized words in this level.\nComplete a test first to unlock the usage exercise.';

  @override
  String get noSentencesYet =>
      'No sentences yet.\nWrite one in the usage exercise!';

  @override
  String wordNumber(int id) {
    return 'Word #$id';
  }

  @override
  String get knownWordsTitle => 'Known words';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Known words · Level $level';
  }

  @override
  String get searchWordHint => 'Search for a word…';

  @override
  String knownWordsCount(int count) {
    return '$count known words';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible of $total words';
  }

  @override
  String levelAbbr(int level) {
    return 'Lvl $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'No words memorized yet.\nPass the tests to fill this list!';

  @override
  String levelTitle(int level) {
    return 'Level $level';
  }

  @override
  String get level => 'LEVEL';

  @override
  String levelLoadError(Object error) {
    return 'Couldn\'t load the level:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Flashcards';

  @override
  String get modeFlashcardsSubtitle => 'Learn the words with cards';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Put yourself to the test';

  @override
  String get modeUsageTitle => 'Usage';

  @override
  String get modeUsageSubtitle => 'Words in sentences';

  @override
  String get modeKnownSubtitle => 'The memorized words in this level';

  @override
  String get memorizedWordsCaption => 'memorized words';

  @override
  String requestSentTo(Object nickname) {
    return 'Request sent to $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'You and $nickname are now friends!';
  }

  @override
  String get requestRejected => 'Request rejected';

  @override
  String get searchByNickname => 'Search by nickname';

  @override
  String get receivedRequests => 'Received requests';

  @override
  String get wantsToBeFriend => 'Wants to be your friend';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get yourFriends => 'Your friends';

  @override
  String get signInToFindFriends =>
      'Log in to find your friends\nand compare your progress.';

  @override
  String get noUsersFound => 'No users found.';

  @override
  String get alreadyFriends => 'Already friends';

  @override
  String get requestSentLabel => 'Request sent';

  @override
  String get add => 'Add';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Level $level · $count memorized words';
  }

  @override
  String get noFriendsYet =>
      'No friends yet. Search a nickname above to send your first request.';

  @override
  String get errorNetwork =>
      'Couldn\'t reach the server. Check your connection and try again.';

  @override
  String get errorSession => 'Session expired or invalid. Please log in again.';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';
}
