import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database.dart';

/// The UI locales the app ships translations for, in display order. Keep in
/// sync with the `app_<code>.arb` files in `lib/l10n/` and with
/// [AppLocalizations.supportedLocales].
const List<Locale> kSupportedLocales = [
  Locale('it'),
  Locale('en'),
  Locale('es'),
  Locale('fr'),
  Locale('pt'),
  Locale('ro'),
  Locale('de'),
  Locale('da'),
  Locale('pl'),
  Locale('hu'),
];

/// Each supported locale's own-language name, for the language picker (e.g.
/// "Italiano", "Deutsch", "Dansk") — never translated into the current UI
/// language. Keyed by language code.
const Map<String, String> kNativeLanguageNames = {
  'it': 'Italiano',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'pt': 'Português',
  'ro': 'Română',
  'de': 'Deutsch',
  'da': 'Dansk',
  'pl': 'Polski',
  'hu': 'Magyar',
};

/// AppMeta key holding the user's explicit UI-language choice (a language
/// code). Absent means "System default" — fall back to auto-detection. Stored
/// in [AppMeta] (not the profile) so it is a device preference: it survives
/// sign-out, which wipes the profile but not app meta.
const String _localeMetaKey = 'ui_locale';

/// Reads the persisted UI-locale override once, for seeding the controller at
/// startup so [MaterialApp.locale] is correct on the very first frame (no
/// system-default flash). Returns `null` when unset or when the stored code is
/// no longer supported.
Future<Locale?> readPersistedLocale(AppDatabase db) async {
  final row = await (db.select(db.appMeta)
        ..where((r) => r.key.equals(_localeMetaKey)))
      .getSingleOrNull();
  return _localeForCode(row?.value);
}

Locale? _localeForCode(String? code) {
  if (code == null) return null;
  for (final locale in kSupportedLocales) {
    if (locale.languageCode == code) return locale;
  }
  return null;
}

/// Seeded in `main()` with the persisted override read via [readPersistedLocale]
/// so [LocaleController] starts with the right value synchronously. Defaults to
/// `null` (System default) when not overridden — e.g. in tests.
final startupLocaleProvider = Provider<Locale?>((ref) => null);

/// The user's explicit UI-language override, or `null` for "System default".
///
/// When non-null it is used directly as [MaterialApp.locale], bypassing the
/// device-locale auto-detection; when null, auto-detection (via
/// `localeResolutionCallback`) decides. Changes take effect immediately —
/// widgets watching this rebuild — and are persisted to [AppMeta].
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => ref.read(startupLocaleProvider);

  /// Sets (or clears, with `null`) the UI-language override. Updates the app
  /// immediately, then persists the choice.
  Future<void> setLocale(Locale? locale) async {
    if (locale == state) return;
    state = locale;

    final db = ref.read(appDatabaseProvider);
    if (locale == null) {
      await (db.delete(db.appMeta)..where((r) => r.key.equals(_localeMetaKey)))
          .go();
    } else {
      await db.into(db.appMeta).insertOnConflictUpdate(
            AppMetaCompanion(
              key: const Value(_localeMetaKey),
              value: Value(locale.languageCode),
            ),
          );
    }
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);
