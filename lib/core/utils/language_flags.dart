/// Maps a language code to a flag emoji for the language picker.
///
/// This is a purely visual/typographic detail — the flag glyph shown next to a
/// language name — and is the ONE fixed code→symbol mapping in the app. It is
/// not word data: language names still come entirely from the JSON files (P8),
/// only the decorative flag is looked up here.
///
/// Flags are country symbols, so a language is mapped to a representative
/// country whose regional-indicator pair yields the emoji. Any code not in the
/// table falls back to a globe, so an unmapped language never crashes or leaves
/// a blank button.
library;

/// The globe shown for any language without a mapped flag.
const String _fallbackFlag = '🌐';

/// Language code → representative ISO 3166-1 alpha-2 country code. Kept small
/// and easy to extend; add a row when a new language ships in `assets/words/`.
const Map<String, String> _languageToCountry = {
  'it': 'IT',
  'hu': 'HU',
  'es': 'ES',
  'en': 'GB',
  'fr': 'FR',
  'de': 'DE',
  'pt': 'PT',
  'nl': 'NL',
  'pl': 'PL',
  'ru': 'RU',
  'sv': 'SE',
  'no': 'NO',
  'da': 'DK',
  'fi': 'FI',
  'cs': 'CZ',
  'sk': 'SK',
  'ro': 'RO',
  'el': 'GR',
  'tr': 'TR',
  'uk': 'UA',
  'ja': 'JP',
  'zh': 'CN',
  'ko': 'KR',
  'ar': 'SA',
  'hi': 'IN',
  'he': 'IL',
  'th': 'TH',
  'vi': 'VN',
  'id': 'ID',
  'hr': 'HR',
  'bg': 'BG',
  'sr': 'RS',
  'sl': 'SI',
  'et': 'EE',
  'lv': 'LV',
  'lt': 'LT',
  'ca': 'ES',
  'gl': 'ES',
  'eu': 'ES',
};

/// The flag emoji for [languageCode], or a globe when the code is unmapped.
///
/// The lookup is case-insensitive and tolerates locale suffixes (e.g. `pt-BR`
/// or `en_US`) by matching on the leading language subtag.
String languageFlag(String languageCode) {
  final normalized = languageCode.trim().toLowerCase();
  final base = normalized.split(RegExp('[-_]')).first;
  final country = _languageToCountry[base];
  if (country == null) return _fallbackFlag;
  return _flagFromCountryCode(country);
}

/// Builds a flag emoji from a two-letter country code by mapping each letter to
/// its Unicode regional-indicator symbol (A → 🇦, …).
String _flagFromCountryCode(String countryCode) {
  const regionalIndicatorA = 0x1F1E6;
  const letterA = 0x41;
  final codePoints = countryCode
      .toUpperCase()
      .codeUnits
      .map((unit) => regionalIndicatorA + (unit - letterA));
  return String.fromCharCodes(codePoints);
}
