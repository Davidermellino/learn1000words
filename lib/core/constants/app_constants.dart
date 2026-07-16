/// App-wide constants for learn1000words.
abstract final class AppConstants {
  static const String appName = 'learn1000words';

  /// Folder scanned at runtime for language files. Every `*.json` here is a
  /// self-describing language pair — see [LanguageRepository].
  static const String wordsAssetFolder = 'assets/words/';

  static const int levelCount = 10;

  /// Words per level in a full 1000-word dataset. Bundled files may ship
  /// fewer (the placeholder ships 2 per level), so this is not enforced.
  static const int wordsPerLevel = 100;
}
