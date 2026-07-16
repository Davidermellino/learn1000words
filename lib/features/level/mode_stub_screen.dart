import 'package:flutter/material.dart';

/// Placeholder for a learning mode not built yet (flashcards, test, usage,
/// per-level known words). Replaced screen by screen in later phases.
class ModeStubScreen extends StatelessWidget {
  const ModeStubScreen({super.key, required this.title, required this.level});

  final String title;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title · Livello $level')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '"$title" arriva in una fase successiva.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
