import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hu'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get navWords;

  /// No description provided for @navFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get navFriends;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authCreateAccount;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save your progress to the cloud and find it on every device.'**
  String get authRegisterSubtitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to pick up your progress.'**
  String get authLoginSubtitle;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authContinueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueApple;

  /// No description provided for @authOrWithEmail.
  ///
  /// In en, this message translates to:
  /// **'or with email'**
  String get authOrWithEmail;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @authSwitchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get authSwitchToLogin;

  /// No description provided for @authSwitchToRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get authSwitchToRegister;

  /// No description provided for @authEnterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password.'**
  String get authEnterEmailPassword;

  /// No description provided for @authSignupPending.
  ///
  /// In en, this message translates to:
  /// **'Registration started: confirm your email, then log in with your credentials.'**
  String get authSignupPending;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authGenericError;

  /// No description provided for @authNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is not configured in this build.\nSee SUPABASE_SETUP.md.'**
  String get authNotConfigured;

  /// No description provided for @nicknameTakenTitle.
  ///
  /// In en, this message translates to:
  /// **'Nickname already in use'**
  String get nicknameTakenTitle;

  /// No description provided for @nicknameTakenBody.
  ///
  /// In en, this message translates to:
  /// **'Someone else has already chosen this nickname. Please pick another one:'**
  String get nicknameTakenBody;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknamePrompt.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get nicknamePrompt;

  /// No description provided for @nicknameLengthError.
  ///
  /// In en, this message translates to:
  /// **'Must be between 3 and 20 characters'**
  String get nicknameLengthError;

  /// No description provided for @avatarPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose your avatar'**
  String get avatarPrompt;

  /// No description provided for @dailyGoalPrompt.
  ///
  /// In en, this message translates to:
  /// **'How many words per day?'**
  String get dailyGoalPrompt;

  /// No description provided for @languagesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the languages:\n{error}'**
  String languagesLoadError(Object error);

  /// No description provided for @noLanguagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No languages available.'**
  String get noLanguagesAvailable;

  /// No description provided for @pickSourceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Which language do you want to start from?'**
  String get pickSourceLanguage;

  /// No description provided for @pickTargetLanguage.
  ///
  /// In en, this message translates to:
  /// **'Which language do you want to learn?'**
  String get pickTargetLanguage;

  /// No description provided for @levelsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the levels:\n{error}'**
  String levelsLoadError(Object error);

  /// No description provided for @completeLevelFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete level {level} first'**
  String completeLevelFirst(int level);

  /// No description provided for @levelLockedSemantic.
  ///
  /// In en, this message translates to:
  /// **'Level {level}, locked'**
  String levelLockedSemantic(int level);

  /// No description provided for @levelProgressSemantic.
  ///
  /// In en, this message translates to:
  /// **'Level {level}, {memorized} of {total} words'**
  String levelProgressSemantic(int level, int memorized, int total);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @noProfileYet.
  ///
  /// In en, this message translates to:
  /// **'No profile yet.'**
  String get noProfileYet;

  /// No description provided for @memorizedWordsCount.
  ///
  /// In en, this message translates to:
  /// **'Memorized words: {count}'**
  String memorizedWordsCount(int count);

  /// No description provided for @currentLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Current level: {level}'**
  String currentLevelLabel(int level);

  /// No description provided for @languageTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTileTitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account linked'**
  String get accountLinked;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently removes your account and all data.'**
  String get deleteAccountSubtitle;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The data on this device will be removed. Your progress stays safe in the cloud and is restored the next time you log in.'**
  String get signOutConfirmBody;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action is immediate and irreversible. Your account, your progress and all associated data will be permanently deleted from the cloud and from this device. This cannot be undone or recovered.'**
  String get deleteAccountConfirmBody;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deleteAccountConfirmButton;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'{count}/{goal} words today · 🔥 {streak, plural, one{{streak}-day streak} other{{streak}-day streak}}'**
  String todaySummary(int count, int goal, int streak);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached! 🎉'**
  String get goalReached;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @dailyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoalLabel;

  /// No description provided for @goalWordsSegment.
  ///
  /// In en, this message translates to:
  /// **'{goal} words'**
  String goalWordsSegment(int goal);

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderTitle;

  /// No description provided for @appLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguageTitle;

  /// No description provided for @systemDefaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefaultLanguage;

  /// No description provided for @flashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards · Level {level}'**
  String flashcardsTitle(int level);

  /// No description provided for @wordsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the words:\n{error}'**
  String wordsLoadError(Object error);

  /// No description provided for @noWordsInLevel.
  ///
  /// In en, this message translates to:
  /// **'No words in this level.'**
  String get noWordsInLevel;

  /// No description provided for @flashcardsOrdered.
  ///
  /// In en, this message translates to:
  /// **'In order'**
  String get flashcardsOrdered;

  /// No description provided for @flashcardsOrderedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To learn the words for the first time'**
  String get flashcardsOrderedSubtitle;

  /// No description provided for @flashcardsRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get flashcardsRandom;

  /// No description provided for @flashcardsRandomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To revise in shuffled order'**
  String get flashcardsRandomSubtitle;

  /// No description provided for @flashcardPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get flashcardPrevious;

  /// No description provided for @flashcardNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get flashcardNext;

  /// No description provided for @tapToReturn.
  ///
  /// In en, this message translates to:
  /// **'Tap to go back'**
  String get tapToReturn;

  /// No description provided for @tapForTranslation.
  ///
  /// In en, this message translates to:
  /// **'Tap for the translation'**
  String get tapForTranslation;

  /// No description provided for @testTitle.
  ///
  /// In en, this message translates to:
  /// **'Test · Level {level}'**
  String testTitle(int level);

  /// No description provided for @testLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the test:\n{error}'**
  String testLoadError(Object error);

  /// No description provided for @answerWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get answerWrong;

  /// No description provided for @correctAnswerPrefix.
  ///
  /// In en, this message translates to:
  /// **'Correct answer: '**
  String get correctAnswerPrefix;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @answerCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get answerCorrect;

  /// No description provided for @testCompleted.
  ///
  /// In en, this message translates to:
  /// **'Test complete!'**
  String get testCompleted;

  /// No description provided for @testScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} words memorized.'**
  String testScore(int correct, int total);

  /// No description provided for @retryRemaining.
  ///
  /// In en, this message translates to:
  /// **'Retry the remaining words'**
  String get retryRemaining;

  /// No description provided for @backToLevel.
  ///
  /// In en, this message translates to:
  /// **'Back to the level'**
  String get backToLevel;

  /// No description provided for @levelCompleted.
  ///
  /// In en, this message translates to:
  /// **'Level complete!'**
  String get levelCompleted;

  /// No description provided for @allWordsMemorized.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already memorized all the words in this level.'**
  String get allWordsMemorized;

  /// No description provided for @usageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage · Level {level}'**
  String usageTitle(int level);

  /// No description provided for @yourSentences.
  ///
  /// In en, this message translates to:
  /// **'Your sentences'**
  String get yourSentences;

  /// No description provided for @loadErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Loading failed:\n{error}'**
  String loadErrorGeneric(Object error);

  /// No description provided for @sentenceSaved.
  ///
  /// In en, this message translates to:
  /// **'Sentence saved!'**
  String get sentenceSaved;

  /// No description provided for @writeSentenceHint.
  ///
  /// In en, this message translates to:
  /// **'Write a sentence with this word…'**
  String get writeSentenceHint;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @anotherWord.
  ///
  /// In en, this message translates to:
  /// **'Another word'**
  String get anotherWord;

  /// No description provided for @noMemorizedInLevel.
  ///
  /// In en, this message translates to:
  /// **'No memorized words in this level.\nComplete a test first to unlock the usage exercise.'**
  String get noMemorizedInLevel;

  /// No description provided for @noSentencesYet.
  ///
  /// In en, this message translates to:
  /// **'No sentences yet.\nWrite one in the usage exercise!'**
  String get noSentencesYet;

  /// No description provided for @wordNumber.
  ///
  /// In en, this message translates to:
  /// **'Word #{id}'**
  String wordNumber(int id);

  /// No description provided for @knownWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Known words'**
  String get knownWordsTitle;

  /// No description provided for @knownWordsTitleLevel.
  ///
  /// In en, this message translates to:
  /// **'Known words · Level {level}'**
  String knownWordsTitleLevel(int level);

  /// No description provided for @searchWordHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a word…'**
  String get searchWordHint;

  /// No description provided for @knownWordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} known words'**
  String knownWordsCount(int count);

  /// No description provided for @knownWordsFiltered.
  ///
  /// In en, this message translates to:
  /// **'{visible} of {total} words'**
  String knownWordsFiltered(int visible, int total);

  /// No description provided for @levelAbbr.
  ///
  /// In en, this message translates to:
  /// **'Lvl {level}'**
  String levelAbbr(int level);

  /// No description provided for @noWordsMemorizedYet.
  ///
  /// In en, this message translates to:
  /// **'No words memorized yet.\nPass the tests to fill this list!'**
  String get noWordsMemorizedYet;

  /// No description provided for @levelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelTitle(int level);

  /// Standalone 'level' word used as the small-caps label on the home level cards; the level number is shown separately.
  ///
  /// In en, this message translates to:
  /// **'LEVEL'**
  String get level;

  /// No description provided for @levelLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the level:\n{error}'**
  String levelLoadError(Object error);

  /// No description provided for @modeFlashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get modeFlashcardsTitle;

  /// No description provided for @modeFlashcardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn the words with cards'**
  String get modeFlashcardsSubtitle;

  /// No description provided for @modeTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get modeTestTitle;

  /// No description provided for @modeTestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Put yourself to the test'**
  String get modeTestSubtitle;

  /// No description provided for @modeUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get modeUsageTitle;

  /// No description provided for @modeUsageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Words in sentences'**
  String get modeUsageSubtitle;

  /// No description provided for @modeKnownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The memorized words in this level'**
  String get modeKnownSubtitle;

  /// No description provided for @memorizedWordsCaption.
  ///
  /// In en, this message translates to:
  /// **'memorized words'**
  String get memorizedWordsCaption;

  /// No description provided for @requestSentTo.
  ///
  /// In en, this message translates to:
  /// **'Request sent to {nickname}'**
  String requestSentTo(Object nickname);

  /// No description provided for @nowFriendsWith.
  ///
  /// In en, this message translates to:
  /// **'You and {nickname} are now friends!'**
  String nowFriendsWith(Object nickname);

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get requestRejected;

  /// No description provided for @searchByNickname.
  ///
  /// In en, this message translates to:
  /// **'Search by nickname'**
  String get searchByNickname;

  /// No description provided for @receivedRequests.
  ///
  /// In en, this message translates to:
  /// **'Received requests'**
  String get receivedRequests;

  /// No description provided for @wantsToBeFriend.
  ///
  /// In en, this message translates to:
  /// **'Wants to be your friend'**
  String get wantsToBeFriend;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @yourFriends.
  ///
  /// In en, this message translates to:
  /// **'Your friends'**
  String get yourFriends;

  /// No description provided for @signInToFindFriends.
  ///
  /// In en, this message translates to:
  /// **'Log in to find your friends\nand compare your progress.'**
  String get signInToFindFriends;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUsersFound;

  /// No description provided for @alreadyFriends.
  ///
  /// In en, this message translates to:
  /// **'Already friends'**
  String get alreadyFriends;

  /// No description provided for @requestSentLabel.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSentLabel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @friendSummary.
  ///
  /// In en, this message translates to:
  /// **'{pair} · Level {level} · {count} memorized words'**
  String friendSummary(Object pair, int level, int count);

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet. Search a nickname above to send your first request.'**
  String get noFriendsYet;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorSession.
  ///
  /// In en, this message translates to:
  /// **'Session expired or invalid. Please log in again.'**
  String get errorSession;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'da',
    'de',
    'en',
    'es',
    'fr',
    'hu',
    'it',
    'pl',
    'pt',
    'ro',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
