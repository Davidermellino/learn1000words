import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// "Ink & Highlighter": a token-driven, minimal theme in light and dark.
///
/// Concept — studying and marking. Ink on paper; amber highlighter means
/// "known" and nothing else. No shadows, no gradients, 0.5px hairlines,
/// 14–16px radii, generous whitespace.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  // Light palette.
  static const _paper = Color(0xFFF5F6F4);
  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _inkLight = Color(0xFF14161A);
  static const _graphiteLight = Color(0xFF74797F);
  static const _hairlineLight = Color(0xFFE4E6E2);
  static const _errorLight = Color(0xFFE5484D);
  static const _neutralContainerLight = Color(0xFFEDEEEB);

  // Dark palette.
  static const _page = Color(0xFF0E1013);
  static const _surfaceDark = Color(0xFF191C21);
  static const _textDark = Color(0xFFECEDE9);
  static const _graphiteDark = Color(0xFF8A9098);
  static const _hairlineDark = Color(0xFF262B31);
  static const _errorDark = Color(0xFFFF6369);
  static const _neutralContainerDark = Color(0xFF272C33);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final page = isLight ? _paper : _page;
    final card = isLight ? _surfaceLight : _surfaceDark;
    final ink = isLight ? _inkLight : _textDark;
    final graphite = isLight ? _graphiteLight : _graphiteDark;
    final hairline = isLight ? _hairlineLight : _hairlineDark;
    final error = isLight ? _errorLight : _errorDark;
    final neutralContainer =
        isLight ? _neutralContainerLight : _neutralContainerDark;
    final onInk = isLight ? _surfaceLight : _page;

    final scheme = ColorScheme(
      brightness: brightness,
      // Ink is the interactive colour: filled buttons are ink with a light
      // label. Amber is deliberately NOT a Material role.
      primary: ink,
      onPrimary: onInk,
      primaryContainer: neutralContainer,
      onPrimaryContainer: ink,
      secondary: graphite,
      onSecondary: onInk,
      secondaryContainer: neutralContainer,
      onSecondaryContainer: ink,
      tertiary: graphite,
      onTertiary: onInk,
      error: error,
      onError: isLight ? _surfaceLight : _page,
      errorContainer: error.withValues(alpha: 0.14),
      onErrorContainer: error,
      surface: page,
      onSurface: ink,
      onSurfaceVariant: graphite,
      surfaceContainerLowest: card,
      surfaceContainerLow: card,
      surfaceContainer: card,
      surfaceContainerHigh: card,
      surfaceContainerHighest: card,
      outline: graphite,
      outlineVariant: hairline,
      surfaceTint: Colors.transparent,
      inverseSurface: ink,
      onInverseSurface: onInk,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    final textTheme = _textTheme(ink);

    final tokens = isLight ? AppTokens.light : AppTokens.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: page,
      canvasColor: page,
      textTheme: textTheme,
      fontFamily: AppFonts.ui,
      extensions: [tokens],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: page,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: hairline,
        thickness: AppRadii.hairlineWidth,
        space: AppRadii.hairlineWidth,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        iconColor: graphite,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(color: graphite),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(0, 44),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(0, 48),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: textTheme.bodyLarge?.copyWith(color: graphite),
        labelStyle: textTheme.bodyLarge?.copyWith(color: graphite),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: ink, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        elevation: 0,
        height: 64,
        surfaceTintColor: Colors.transparent,
        indicatorColor: neutralContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? ink : graphite,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected) ? ink : graphite,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          side: WidgetStatePropertyAll(
            BorderSide(color: hairline, width: AppRadii.hairlineWidth),
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? ink : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected) ? onInk : ink,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: ink,
        side: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: onInk),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.small),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: onInk),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(AppRadii.card)),
          side: BorderSide(color: hairline, width: AppRadii.hairlineWidth),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ink,
        linearTrackColor: hairline,
        circularTrackColor: hairline,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? ink : graphite,
        ),
      ),
    );
  }

  /// Inter for UI, Space Grotesk for display/headings. Word faces switch to
  /// [AppFonts.mono] at the call site. No style falls below 12px.
  static TextTheme _textTheme(Color ink) {
    const display = AppFonts.display;
    const ui = AppFonts.ui;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: display,
        fontSize: 40,
        height: 1.05,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: ink,
      ),
      displayMedium: TextStyle(
        fontFamily: display,
        fontSize: 32,
        height: 1.1,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: ink,
      ),
      displaySmall: TextStyle(
        fontFamily: display,
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineLarge: TextStyle(
        fontFamily: display,
        fontSize: 26,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: display,
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontFamily: display,
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontFamily: display,
        fontSize: 19,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontFamily: ui,
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleSmall: TextStyle(
        fontFamily: ui,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: ui,
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: ui,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodySmall: TextStyle(
        fontFamily: ui,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      labelLarge: TextStyle(
        fontFamily: ui,
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontFamily: ui,
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
      labelSmall: TextStyle(
        fontFamily: ui,
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: ink,
      ),
    );
  }
}
