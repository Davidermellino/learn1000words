import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../utils/language_flags.dart';

/// A Duolingo-style language choice: a full-width button showing the language's
/// flag emoji and its name. Shared by the onboarding language-pair step and the
/// profile "change language" dialogs so both read identically.
///
/// The name always comes from the discovered pairs (the JSON files); only the
/// flag is looked up from [languageFlag], with a globe fallback for any code
/// without a mapped flag.
///
/// Selection is drawn with ink (the theme's interactive colour), never the
/// amber highlighter — amber means "known" and nothing else.
class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.code,
    required this.name,
    required this.onPressed,
    this.selected = false,
  });

  /// Language code used only to pick the flag emoji.
  final String code;

  /// Display name shown on the button — straight from the file.
  final String name;

  /// Whether this is the currently active choice (drawn filled).
  final bool selected;

  /// Tapping always fires, even when [selected] — re-choosing the active
  /// language is a harmless no-op for the caller, never a dead button.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadii.control);

    return Material(
      color: selected ? scheme.primary : tokens.card,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? scheme.primary : tokens.hairline,
              width: AppRadii.hairlineWidth,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Text(
                  languageFlag(code),
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: selected ? scheme.onPrimary : scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check, size: 20, color: scheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
