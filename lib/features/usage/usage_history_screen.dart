import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/models/word.dart';
import '../../data/progress_provider.dart';
import 'usage_repository.dart';

/// All sentences the user saved in the Usage mode, newest first, across
/// every level.
class UsageHistoryScreen extends ConsumerWidget {
  const UsageHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentencesAsync = ref.watch(usageSentencesProvider);
    final wordsAsync = ref.watch(wordsProvider);
    final pair = ref.watch(activePairProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Le tue frasi')),
      body: Builder(
        builder: (context) {
          final error = sentencesAsync.error ?? wordsAsync.error;
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Errore nel caricamento:\n$error'),
              ),
            );
          }
          if (!sentencesAsync.hasValue || !wordsAsync.hasValue ||
              pair == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final sentences = sentencesAsync.requireValue;
          if (sentences.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Ancora nessuna frase.\n'
                  'Scrivine una nell\'esercizio di uso!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final wordsById = {
            for (final word in wordsAsync.requireValue) word.id: word,
          };

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sentences.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final row = sentences[index];
              final Word? word = wordsById[row.wordId];
              final label = word == null
                  ? 'Parola #${row.wordId}'
                  : '${word.answerFor(pair)} · ${word.promptFor(pair)}';
              return Card(
                child: ListTile(
                  title: Text(row.sentence),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('$label · ${_formatDate(row.createdAt)}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _formatDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year} '
      '${two(date.hour)}:${two(date.minute)}';
}
