import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/models/word.dart';
import '../../data/progress_provider.dart';

/// How the flashcards deck is ordered.
enum FlashcardsMode {
  /// Id ascending — for learning the level the first time.
  ordered,

  /// Shuffled — for revision.
  random,
}

/// Flashcards for one level: pick ordered/random, then flip through the
/// level's words. Learning only — nothing is written to the database.
class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key, required this.level});

  final int level;

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  FlashcardsMode? _mode;

  /// Deck snapshot for the chosen mode, so a random deck keeps its order
  /// while the user browses it.
  List<Word>? _deck;

  void _start(FlashcardsMode mode, List<Word> levelWords) {
    final deck = [...levelWords]..sort((a, b) => a.id.compareTo(b.id));
    if (mode == FlashcardsMode.random) deck.shuffle(Random());
    setState(() {
      _mode = mode;
      _deck = deck;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);
    final pair = ref.watch(activePairProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Flashcard · Livello ${widget.level}')),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Errore nel caricamento delle parole:\n$error'),
          ),
        ),
        data: (words) {
          if (pair == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final levelWords =
              words.where((word) => word.level == widget.level).toList();
          if (levelWords.isEmpty) {
            return const Center(
              child: Text('Nessuna parola in questo livello.'),
            );
          }
          if (_mode == null) {
            return _ModePicker(
              onOrdered: () => _start(FlashcardsMode.ordered, levelWords),
              onRandom: () => _start(FlashcardsMode.random, levelWords),
            );
          }
          return _Deck(deck: _deck!, pair: pair);
        },
      ),
    );
  }
}

class _ModePicker extends StatelessWidget {
  const _ModePicker({required this.onOrdered, required this.onRandom});

  final VoidCallback onOrdered;
  final VoidCallback onRandom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: const Icon(Icons.format_list_numbered),
            title: const Text('In ordine'),
            subtitle: const Text('Per imparare le parole la prima volta'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOrdered,
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: const Icon(Icons.shuffle),
            title: const Text('Casuale'),
            subtitle: const Text('Per ripassare in ordine sparso'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onRandom,
          ),
        ),
      ],
    );
  }
}

/// Swipeable deck with a flippable card per word and previous/next controls.
class _Deck extends StatefulWidget {
  const _Deck({required this.deck, required this.pair});

  final List<Word> deck;
  final LanguagePairInfo pair;

  @override
  State<_Deck> createState() => _DeckState();
}

class _DeckState extends State<_Deck> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.deck.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '${_page + 1} / $total',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) {
              final word = widget.deck[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: _FlipCard(
                  // New state (unflipped) per word, also when re-shuffled.
                  key: ValueKey('${word.id}-$index'),
                  front: word.promptFor(widget.pair),
                  back: word.answerFor(widget.pair),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: _page > 0 ? () => _goTo(_page - 1) : null,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Precedente',
              ),
              const SizedBox(width: 24),
              IconButton.filledTonal(
                onPressed: _page < total - 1 ? () => _goTo(_page + 1) : null,
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Successiva',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Card showing the prompt; tap to flip and reveal the answer.
class _FlipCard extends StatefulWidget {
  const _FlipCard({super.key, required this.front, required this.back});

  final String front;
  final String back;

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = AppTokens.of(context);
    final animate = !MediaQuery.of(context).disableAnimations;

    return GestureDetector(
      onTap: () => setState(() => _flipped = !_flipped),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _flipped ? 1 : 0),
        duration:
            animate ? const Duration(milliseconds: 300) : Duration.zero,
        curve: Curves.easeInOut,
        builder: (context, value, _) {
          final showBack = value > 0.5;
          // The back flips to ink (inverse surface) so the reveal reads
          // clearly without borrowing the amber, which means "known".
          final background = showBack ? scheme.inverseSurface : tokens.card;
          final foreground =
              showBack ? scheme.onInverseSurface : scheme.onSurface;
          final muted = foreground.withValues(alpha: 0.6);
          // Rotate around Y; mirror the back half so its text reads normally.
          final angle = value * pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(showBack ? angle - pi : angle),
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(
                  color: showBack ? background : tokens.hairline,
                  width: AppRadii.hairlineWidth,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showBack ? widget.back : widget.front,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontFamily: AppFonts.mono,
                              color: foreground,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        showBack
                            ? 'Tocca per tornare'
                            : 'Tocca per la traduzione',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: muted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
