import 'package:flutter/material.dart';

/// Step 4: pick a daily word goal.
class DailyGoalStep extends StatelessWidget {
  const DailyGoalStep({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  static const _options = [5, 10, 20];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quante parole al giorno?',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (final goal in _options)
                ChoiceChip(
                  label: Text('$goal'),
                  selected: goal == selected,
                  onSelected: (_) => onSelected(goal),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
