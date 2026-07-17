// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get navWords => 'Szavak';

  @override
  String get navFriends => 'Barátok';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Mégse';

  @override
  String get confirm => 'Megerősítés';

  @override
  String get back => 'Vissza';

  @override
  String get next => 'Tovább';

  @override
  String get finish => 'Kész';

  @override
  String get retry => 'Újra';

  @override
  String get logIn => 'Bejelentkezés';

  @override
  String get signUp => 'Regisztráció';

  @override
  String get authCreateAccount => 'Hozd létre a fiókodat';

  @override
  String get authWelcomeBack => 'Üdv újra itt';

  @override
  String get authRegisterSubtitle =>
      'Regisztrálj, hogy elmentsd a fejlődésed a felhőbe, és bármely eszközön megtaláld.';

  @override
  String get authLoginSubtitle => 'Jelentkezz be, hogy folytasd a fejlődésed.';

  @override
  String get authContinueGoogle => 'Folytatás Google-fiókkal';

  @override
  String get authContinueApple => 'Folytatás Apple-fiókkal';

  @override
  String get authOrWithEmail => 'vagy e-maillel';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Jelszó';

  @override
  String get authSwitchToLogin => 'Van már fiókod? Jelentkezz be';

  @override
  String get authSwitchToRegister => 'Nincs még fiókod? Regisztrálj';

  @override
  String get authEnterEmailPassword =>
      'Add meg az e-mail-címed és a jelszavad.';

  @override
  String get authSignupPending =>
      'Regisztráció elindítva: erősítsd meg az e-mail-címed, majd jelentkezz be az adataiddal.';

  @override
  String get authGenericError => 'Valami elromlott. Próbáld újra.';

  @override
  String get authNotConfigured =>
      'A felhőalapú szinkronizálás nincs beállítva ebben a buildben.\nLásd: SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'A becenév már foglalt';

  @override
  String get nicknameTakenBody =>
      'Valaki más már választotta ezt a becenevet. Válassz másikat:';

  @override
  String get nicknameLabel => 'Becenév';

  @override
  String get nicknamePrompt => 'Hogy szólíthatunk?';

  @override
  String get nicknameLengthError => '3 és 20 karakter között kell lennie';

  @override
  String get avatarPrompt => 'Válaszd ki az avatarodat';

  @override
  String get dailyGoalPrompt => 'Hány szó naponta?';

  @override
  String languagesLoadError(Object error) {
    return 'Hiba a nyelvek betöltésekor:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Nincs elérhető nyelv.';

  @override
  String get pickSourceLanguage => 'Melyik nyelvből szeretnél kiindulni?';

  @override
  String get pickTargetLanguage => 'Melyik nyelvet szeretnéd tanulni?';

  @override
  String levelsLoadError(Object error) {
    return 'Hiba a szintek betöltésekor:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Előbb teljesítsd a(z) $level. szintet';
  }

  @override
  String levelLockedSemantic(int level) {
    return '$level. szint, zárolva';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return '$level. szint, $total szóból $memorized';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get noProfileYet => 'Még nincs profil.';

  @override
  String memorizedWordsCount(int count) {
    return 'Megjegyzett szavak: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Jelenlegi szint: $level';
  }

  @override
  String get languageTileTitle => 'Nyelv';

  @override
  String get account => 'Fiók';

  @override
  String get accountLinked => 'Fiók összekapcsolva';

  @override
  String get signOut => 'Kijelentkezés';

  @override
  String get deleteAccount => 'Fiók törlése';

  @override
  String get deleteAccountSubtitle =>
      'Véglegesen eltávolítja a fiókodat és minden adatot.';

  @override
  String get signOutConfirmTitle => 'Kijelentkezel a fiókodból?';

  @override
  String get signOutConfirmBody =>
      'Az ezen az eszközön lévő adatok törlődnek. A fejlődésed biztonságban marad a felhőben, és a következő bejelentkezéskor visszaáll.';

  @override
  String get deleteAccountConfirmTitle => 'Törlöd a fiókodat?';

  @override
  String get deleteAccountConfirmBody =>
      'Ez a művelet azonnali és visszavonhatatlan. A fiókod, a fejlődésed és minden kapcsolódó adat véglegesen törlődik a felhőből és erről az eszközről. Nem vonható vissza, és az adatok nem állíthatók helyre.';

  @override
  String get deleteAccountConfirmButton => 'Végleges törlés';

  @override
  String get todayLabel => 'Ma';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak napos sorozat',
      one: '$streak napos sorozat',
    );
    return '$count/$goal szó ma · 🔥 $_temp0';
  }

  @override
  String get goalReached => 'Cél elérve! 🎉';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get dailyGoalLabel => 'Napi cél';

  @override
  String goalWordsSegment(int goal) {
    return '$goal szó';
  }

  @override
  String get reminderTitle => 'Napi emlékeztető';

  @override
  String get appLanguageTitle => 'Alkalmazás nyelve';

  @override
  String get systemDefaultLanguage => 'Rendszer alapértelmezett';

  @override
  String flashcardsTitle(int level) {
    return 'Kártyák · $level. szint';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Hiba a szavak betöltésekor:\n$error';
  }

  @override
  String get noWordsInLevel => 'Nincs szó ezen a szinten.';

  @override
  String get flashcardsOrdered => 'Sorrendben';

  @override
  String get flashcardsOrderedSubtitle => 'A szavak első megtanulásához';

  @override
  String get flashcardsRandom => 'Véletlenszerű';

  @override
  String get flashcardsRandomSubtitle => 'Ismétléshez véletlenszerű sorrendben';

  @override
  String get flashcardPrevious => 'Előző';

  @override
  String get flashcardNext => 'Következő';

  @override
  String get tapToReturn => 'Koppints a visszatéréshez';

  @override
  String get tapForTranslation => 'Koppints a fordításért';

  @override
  String testTitle(int level) {
    return 'Teszt · $level. szint';
  }

  @override
  String testLoadError(Object error) {
    return 'Hiba a teszt betöltésekor:\n$error';
  }

  @override
  String get answerWrong => 'Hibás';

  @override
  String get correctAnswerPrefix => 'Helyes válasz: ';

  @override
  String get check => 'Ellenőrzés';

  @override
  String get answerCorrect => 'Helyes';

  @override
  String get testCompleted => 'Teszt kész!';

  @override
  String testScore(int correct, int total) {
    return '$total szóból $correct megjegyezve.';
  }

  @override
  String get retryRemaining => 'Próbáld újra a hátralévő szavakat';

  @override
  String get backToLevel => 'Vissza a szinthez';

  @override
  String get levelCompleted => 'Szint teljesítve!';

  @override
  String get allWordsMemorized =>
      'Már megjegyezted ennek a szintnek az összes szavát.';

  @override
  String usageTitle(int level) {
    return 'Használat · $level. szint';
  }

  @override
  String get yourSentences => 'A mondataid';

  @override
  String loadErrorGeneric(Object error) {
    return 'Hiba a betöltéskor:\n$error';
  }

  @override
  String get sentenceSaved => 'Mondat mentve!';

  @override
  String get writeSentenceHint => 'Írj egy mondatot ezzel a szóval…';

  @override
  String get done => 'Kész';

  @override
  String get anotherWord => 'Másik szó';

  @override
  String get noMemorizedInLevel =>
      'Nincs megjegyzett szó ezen a szinten.\nElőbb teljesíts egy tesztet a használati gyakorlat feloldásához.';

  @override
  String get noSentencesYet =>
      'Még nincs mondat.\nÍrj egyet a használati gyakorlatban!';

  @override
  String wordNumber(int id) {
    return '$id. szó';
  }

  @override
  String get knownWordsTitle => 'Ismert szavak';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Ismert szavak · $level. szint';
  }

  @override
  String get searchWordHint => 'Keress egy szót…';

  @override
  String knownWordsCount(int count) {
    return '$count ismert szó';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible / $total szó';
  }

  @override
  String levelAbbr(int level) {
    return '$level. sz.';
  }

  @override
  String get noWordsMemorizedYet =>
      'Még nincs megjegyzett szó.\nTeljesítsd a teszteket, hogy feltöltsd ezt a listát!';

  @override
  String levelTitle(int level) {
    return '$level. szint';
  }

  @override
  String get level => 'SZINT';

  @override
  String levelLoadError(Object error) {
    return 'Hiba a szint betöltésekor:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Kártyák';

  @override
  String get modeFlashcardsSubtitle => 'Tanuld a szavakat kártyákkal';

  @override
  String get modeTestTitle => 'Teszt';

  @override
  String get modeTestSubtitle => 'Tedd próbára magad';

  @override
  String get modeUsageTitle => 'Használat';

  @override
  String get modeUsageSubtitle => 'A szavak mondatokban';

  @override
  String get modeKnownSubtitle => 'Ennek a szintnek a megjegyzett szavai';

  @override
  String get memorizedWordsCaption => 'megjegyzett szó';

  @override
  String requestSentTo(Object nickname) {
    return 'Kérés elküldve neki: $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Te és $nickname mostantól barátok vagytok!';
  }

  @override
  String get requestRejected => 'Kérés elutasítva';

  @override
  String get searchByNickname => 'Keresés becenév alapján';

  @override
  String get receivedRequests => 'Beérkezett kérések';

  @override
  String get wantsToBeFriend => 'Barátod szeretne lenni';

  @override
  String get accept => 'Elfogadás';

  @override
  String get reject => 'Elutasítás';

  @override
  String get yourFriends => 'A barátaid';

  @override
  String get signInToFindFriends =>
      'Jelentkezz be, hogy megtaláld a barátaidat\nés összehasonlítsd a fejlődést.';

  @override
  String get noUsersFound => 'Nem található felhasználó.';

  @override
  String get alreadyFriends => 'Már barátok';

  @override
  String get requestSentLabel => 'Kérés elküldve';

  @override
  String get add => 'Hozzáadás';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · $level. szint · $count megjegyzett szó';
  }

  @override
  String get noFriendsYet =>
      'Még nincs barátod. Keress egy becenevet fent az első kérés elküldéséhez.';

  @override
  String get errorNetwork =>
      'Nem sikerült elérni a szervert. Ellenőrizd a kapcsolatot, és próbáld újra.';

  @override
  String get errorSession =>
      'A munkamenet lejárt vagy érvénytelen. Jelentkezz be újra.';

  @override
  String get errorGeneric => 'Hiba történt. Próbáld újra.';
}
