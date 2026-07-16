/// Build-time configuration, injected via `--dart-define` (never hardcoded):
///
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://<project>.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=<anon key> \
///   --dart-define=GOOGLE_WEB_CLIENT_ID=<web client id>.apps.googleusercontent.com
/// ```
///
/// See SUPABASE_SETUP.md for where each value comes from. When the Supabase
/// defines are absent the app runs fully local (no auth, no cloud sync) —
/// nothing may assume they are present.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// OAuth 2.0 *web* client id of the Google Cloud project — used as
  /// `serverClientId` so Google issues an ID token Supabase can verify.
  static const googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  /// OAuth 2.0 *iOS* client id — only needed on iOS (P5.5).
  static const googleIosClientId =
      String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  /// Whether cloud sync (Supabase) is configured for this build.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Whether native Google Sign-In can be attempted.
  static bool get hasGoogleSignIn => googleWebClientId.isNotEmpty;
}
