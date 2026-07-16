import 'package:flutter/material.dart';

/// The "Ink & Highlighter" design system's single source of truth for the
/// pieces Material's [ColorScheme] can't express cleanly.
///
/// Everything else (page/paper, ink text, graphite secondary, hairline
/// borders, error) is mapped onto standard [ColorScheme] roles in
/// `app_theme.dart`, so ordinary widgets pick it up for free:
///   surface          → paper (page background)
///   onSurface        → ink (primary text)
///   onSurfaceVariant → graphite (secondary text/icons)
///   outlineVariant   → hairline (0.5px borders, dividers)
///   error / onError  → wrong answers only
///
/// The amber highlighter has exactly one meaning — known / correct — and never
/// leaks through a Material role, which is why it lives here and is only ever
/// used deliberately.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.card,
    required this.hairline,
    required this.highlighter,
    required this.onHighlighter,
  });

  /// Raised surface for cards / list rows, sitting above [ColorScheme.surface]
  /// (the page). Distinct from the page so cards read without a shadow.
  final Color card;

  /// 0.5px borders and dividers. Mirrors [ColorScheme.outlineVariant].
  final Color hairline;

  /// The one accent: "known" / "correct". Never text colour on a light
  /// surface — it is a fill that ink sits on.
  final Color highlighter;

  /// Ink that reads on top of [highlighter].
  final Color onHighlighter;

  static const light = AppTokens(
    card: Color(0xFFFFFFFF),
    hairline: Color(0xFFE4E6E2),
    highlighter: Color(0xFFF2C230),
    onHighlighter: Color(0xFF412402),
  );

  static const dark = AppTokens(
    card: Color(0xFF191C21),
    hairline: Color(0xFF262B31),
    highlighter: Color(0xFFF2C230),
    onHighlighter: Color(0xFF412402),
  );

  /// Reads the tokens off the ambient theme.
  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>()!;

  @override
  AppTokens copyWith({
    Color? card,
    Color? hairline,
    Color? highlighter,
    Color? onHighlighter,
  }) {
    return AppTokens(
      card: card ?? this.card,
      hairline: hairline ?? this.hairline,
      highlighter: highlighter ?? this.highlighter,
      onHighlighter: onHighlighter ?? this.onHighlighter,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      card: Color.lerp(card, other.card, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      highlighter: Color.lerp(highlighter, other.highlighter, t)!,
      onHighlighter: Color.lerp(onHighlighter, other.onHighlighter, t)!,
    );
  }
}

/// The three bundled families. Referenced by name so no widget hardcodes a
/// font string. Space Grotesk and Inter are variable fonts (Flutter maps
/// [FontWeight] onto the wght axis); IBM Plex Mono ships discrete weights.
abstract final class AppFonts {
  /// Level numbers, counts, headings. Used with restraint.
  static const display = 'Space Grotesk';

  /// Labels, buttons, list rows — the default UI face.
  static const ui = 'Inter';

  /// The vocabulary itself: flashcard faces, test letter cells, known words.
  static const mono = 'IBM Plex Mono';
}

/// 4px spacing scale.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Corner radii. Cards 16, controls 12, small chips 10.
abstract final class AppRadii {
  static const card = 16.0;
  static const control = 12.0;
  static const small = 10.0;

  /// Hairline stroke width (logical px; renders as a fine 0.5px-feel line).
  static const hairlineWidth = 1.0;
}
