import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/core/theme/app_theme.dart';
import 'package:learn1000words/core/widgets/language_button.dart';
import 'package:learn1000words/data/language_providers.dart';
import 'package:learn1000words/data/repositories/language_repository.dart';
import 'package:learn1000words/features/onboarding/widgets/language_pair_step.dart';
import 'package:learn1000words/l10n/app_localizations.dart';

/// The language step is a two-step, Duolingo-style flow driven entirely by the
/// files — no hardcoded language names. Step 1 shows the deduplicated sources,
/// step 2 the targets that pair with the chosen source.
///
/// One test uses the real asset bundle to prove the discovered pairs flow into
/// the UI unchanged; the interaction tests override the provider with pairs
/// parsed from file bodies (still no hardcoded names) for determinism.
void main() {
  // A minimal valid file body (one word per level) with file-supplied names.
  String file({
    required String source,
    required String target,
    required String sourceName,
    required String targetName,
  }) {
    final words = [
      for (var level = 1; level <= 10; level++)
        '{ "id": $level, "level": $level, "source": "s$level", "target": "t$level" }',
    ].join(',');
    return '{ "source": "$source", "target": "$target", '
        '"sourceName": "$sourceName", "targetName": "$targetName", '
        '"version": 1, "words": [ $words ] }';
  }

  // Two files sharing the source "it": it→hu and it→es (plus their reverses).
  // "it" therefore dedupes to a single source with two targets; "hu"/"es" each
  // have a single target.
  final pairs = [
    ...LanguageRepository.parseLanguageFile(
      file(source: 'it', target: 'hu', sourceName: 'Italiano', targetName: 'Magyar'),
    ),
    ...LanguageRepository.parseLanguageFile(
      file(source: 'it', target: 'es', sourceName: 'Italiano', targetName: 'Español'),
    ),
  ];

  Future<void> pumpWith(
    WidgetTester tester, {
    required List<Override> overrides,
    required void Function(String) onSelected,
    String? selectedPairId,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('it'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: LanguagePairStep(
              selectedPairId: selectedPairId,
              onSelected: onSelected,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpOverridden(
    WidgetTester tester, {
    required void Function(String) onSelected,
    String? selectedPairId,
  }) {
    return pumpWith(
      tester,
      overrides: [languagePairsProvider.overrideWith((ref) async => pairs)],
      onSelected: onSelected,
      selectedPairId: selectedPairId,
    );
  }

  testWidgets('step 1 lists the deduplicated sources from the real bundle',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('it'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: LanguagePairStep(selectedPairId: null, onSelected: (_) {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Bundle ships it_hu + the it_es demo; both share source "it", so it shows
    // once (labelled from whichever sorts first — the demo). Names are from the
    // files: no Dart change was needed to pick them up.
    expect(find.text('Italiano (demo)'), findsOneWidget);
    expect(find.text('Magyar'), findsOneWidget);
    expect(find.text('Español (demo)'), findsOneWidget);
    // Still the source step — no targets yet.
    expect(find.text('Quale lingua vuoi imparare?'), findsNothing);
  });

  testWidgets('choosing a source shows only its paired targets',
      (tester) async {
    await pumpOverridden(tester, onSelected: (_) {});

    await tester.tap(find.text('Italiano')); // source "it"
    await tester.pumpAndSettle();

    expect(find.text('Quale lingua vuoi imparare?'), findsOneWidget);
    // Both targets paired with "it", and nothing unrelated.
    expect(find.text('Magyar'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
  });

  testWidgets('step 2 is shown even when a single target pairs with the source',
      (tester) async {
    await pumpOverridden(tester, onSelected: (_) {});

    await tester.tap(find.text('Magyar')); // source "hu" pairs only with "it"
    await tester.pumpAndSettle();

    expect(find.text('Quale lingua vuoi imparare?'), findsOneWidget);
    expect(find.byType(LanguageButton), findsOneWidget);
    expect(find.text('Italiano'), findsOneWidget);
  });

  testWidgets('selecting a target reports the correct pairId', (tester) async {
    String? selected;
    await pumpOverridden(tester, onSelected: (id) => selected = id);

    await tester.tap(find.text('Italiano')); // source "it"
    await tester.pumpAndSettle();
    await tester.tap(find.text('Magyar')); // target → it_hu
    await tester.pumpAndSettle();

    expect(selected, 'it_hu');
  });

  testWidgets('the back control returns to the source step', (tester) async {
    await pumpOverridden(tester, onSelected: (_) {});

    await tester.tap(find.text('Italiano'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Da quale lingua vuoi partire?'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
  });

  testWidgets('a preselected pair opens directly on its target step',
      (tester) async {
    await pumpOverridden(tester, onSelected: (_) {}, selectedPairId: 'it_es');

    // Lands on step 2 for source "it" with the target preselected.
    expect(find.text('Quale lingua vuoi imparare?'), findsOneWidget);
    expect(find.text('Magyar'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
  });

  testWidgets(
      'the already-active source can be reselected to reach a different target',
      (tester) async {
    // it_hu is active (source "it" is already in use). The user must still be
    // able to go back, pick "it" again, and switch to the OTHER "it" target.
    String? selected;
    await pumpOverridden(
      tester,
      onSelected: (id) => selected = id,
      selectedPairId: 'it_hu',
    );

    // Opens on step 2 for "it"; go back to the source list.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Da quale lingua vuoi partire?'), findsOneWidget);

    // Reselect the already-active source — must proceed, not be blocked.
    await tester.tap(find.text('Italiano'));
    await tester.pumpAndSettle();
    expect(find.text('Quale lingua vuoi imparare?'), findsOneWidget);
    expect(find.text('Magyar'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);

    // Switch to the different target.
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();
    expect(selected, 'it_es');
  });
}
