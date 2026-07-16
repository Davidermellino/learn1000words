import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/answer_match.dart';

/// Segmented per-letter answer input: one cell per letter of the target,
/// with the target's spaces / hyphens / apostrophes rendered as fixed,
/// non-editable separators in their positions.
///
/// A single hidden [TextField] backs all cells, so typing fills the next
/// empty cell (auto-advance), backspace empties the previous one, and the
/// platform IME handles accented letters (á é í ó ö ő ú ü ű) natively.
/// Separator characters are filtered out of the input — the user only ever
/// types letters.
class SegmentedAnswerField extends StatefulWidget {
  const SegmentedAnswerField({
    super.key,
    required this.template,
    this.enabled = true,
    this.autofocus = false,
    this.cellResults,
    this.onChanged,
    this.onSubmitted,
  });

  final AnswerTemplate template;

  /// When false the keyboard is dismissed and cells stop accepting input
  /// (used while showing feedback).
  final bool enabled;

  final bool autofocus;

  /// After checking: per-letter correctness from [matchLetterCells], used to
  /// color each cell. Null while the user is still typing.
  final List<bool>? cellResults;

  /// The letters currently typed, one entry per filled cell.
  final ValueChanged<List<String>>? onChanged;

  /// Keyboard "done" action.
  final VoidCallback? onSubmitted;

  @override
  State<SegmentedAnswerField> createState() => _SegmentedAnswerFieldState();
}

class _SegmentedAnswerFieldState extends State<SegmentedAnswerField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> get _typed => _controller.text.split('');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChanged);
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged() {
    final raw = _controller.text;
    final filtered = raw
        .split('')
        .where((char) => !answerSeparators.contains(char))
        .take(widget.template.letterCount)
        .join();
    if (filtered != raw) {
      // Re-entrant: setting the value fires this listener again with clean
      // text, which then falls through to notify.
      _controller.value = TextEditingValue(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
      return;
    }
    setState(() {});
    widget.onChanged?.call(_typed);
  }

  @override
  Widget build(BuildContext context) {
    // Group slots into words (split at spaces) so line breaks fall on word
    // boundaries instead of mid-word.
    final wordGroups = <List<_IndexedSlot>>[[]];
    var letterIndex = 0;
    for (final slot in widget.template.slots) {
      if (slot.char == ' ') {
        wordGroups.add([]);
        continue;
      }
      wordGroups.last.add(
        _IndexedSlot(slot: slot, letterIndex: slot.isLetter ? letterIndex : -1),
      );
      if (slot.isLetter) letterIndex++;
    }

    final typed = _typed;
    final activeIndex =
        widget.enabled && _focusNode.hasFocus ? typed.length : -1;

    return GestureDetector(
      onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
      child: Stack(
        children: [
          // Hidden input backing the cells. Kept 1×1 and invisible but
          // focusable, so the platform keyboard and IME still target it.
          SizedBox(
            width: 1,
            height: 1,
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => widget.onSubmitted?.call(),
              ),
            ),
          ),
          // Cells are sized uniformly so the widest word always fits the
          // available width — a 13-letter Hungarian word shrinks the whole
          // row instead of overflowing.
          LayoutBuilder(
            builder: (context, constraints) {
              final m = _metricsFor(wordGroups, constraints.maxWidth);
              return Wrap(
                spacing: m.wordGap,
                runSpacing: m.wordGap,
                alignment: WrapAlignment.center,
                children: [
                  for (final group in wordGroups)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final indexed in group)
                          indexed.slot.isLetter
                              ? _LetterCell(
                                  char: indexed.letterIndex < typed.length
                                      ? typed[indexed.letterIndex]
                                      : '',
                                  active: indexed.letterIndex == activeIndex,
                                  correct: widget.cellResults == null
                                      ? null
                                      : widget
                                          .cellResults![indexed.letterIndex],
                                  metrics: m,
                                )
                              : _SeparatorCell(
                                  char: indexed.slot.char,
                                  metrics: m,
                                ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Picks a single scale so the widest word group fits [maxWidth]; short
  /// words keep the base size, long ones shrink together.
  static _CellMetrics _metricsFor(
    List<List<_IndexedSlot>> groups,
    double maxWidth,
  ) {
    const base = _CellMetrics.base;
    double groupWidth(List<_IndexedSlot> group) {
      var w = 0.0;
      for (final indexed in group) {
        w += indexed.slot.isLetter ? base.cellWidth : base.separatorWidth;
      }
      return w + math.max(0, group.length - 1) * base.cellGap;
    }

    var widest = 0.0;
    for (final group in groups) {
      if (group.isEmpty) continue;
      widest = math.max(widest, groupWidth(group));
    }
    // 0.98 leaves a hair of breathing room against rounding.
    final scale =
        widest <= 0 ? 1.0 : math.min(1.0, (maxWidth * 0.98) / widest);
    return base.scaled(scale);
  }
}

/// Resolved cell dimensions for the current word length / screen width.
class _CellMetrics {
  const _CellMetrics({
    required this.cellWidth,
    required this.cellHeight,
    required this.cellGap,
    required this.separatorWidth,
    required this.fontSize,
    required this.wordGap,
  });

  final double cellWidth;
  final double cellHeight;
  final double cellGap;
  final double separatorWidth;
  final double fontSize;
  final double wordGap;

  static const base = _CellMetrics(
    cellWidth: 38,
    cellHeight: 48,
    cellGap: 6,
    separatorWidth: 18,
    fontSize: 22,
    wordGap: 16,
  );

  _CellMetrics scaled(double s) => _CellMetrics(
        cellWidth: cellWidth * s,
        cellHeight: cellHeight * s,
        cellGap: cellGap * s,
        separatorWidth: separatorWidth * s,
        // Never below 12px; a single mono glyph still fits the shrunk cell.
        fontSize: math.max(12, fontSize * s),
        wordGap: wordGap * s,
      );
}

class _IndexedSlot {
  const _IndexedSlot({required this.slot, required this.letterIndex});

  final AnswerSlot slot;

  /// Position among the typed cells, or -1 for separators.
  final int letterIndex;
}

class _LetterCell extends StatelessWidget {
  const _LetterCell({
    required this.char,
    required this.active,
    required this.correct,
    required this.metrics,
  });

  final String char;
  final bool active;

  /// Null while typing; true/false once results are shown.
  final bool? correct;

  final _CellMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = AppTokens.of(context);
    final filled = char.isNotEmpty;

    // empty  → hairline outline
    // filled → ink on the surface
    // correct→ amber fill, ink-on-amber text
    // wrong  → error outline
    final Color borderColor;
    final Color fillColor;
    final Color textColor;
    double borderWidth;
    switch (correct) {
      case true:
        borderColor = tokens.highlighter;
        fillColor = tokens.highlighter;
        textColor = tokens.onHighlighter;
        borderWidth = AppRadii.hairlineWidth;
      case false:
        borderColor = scheme.error;
        fillColor = Colors.transparent;
        textColor = scheme.error;
        borderWidth = 1.5;
      case null:
        borderColor = (active || filled) ? scheme.onSurface : tokens.hairline;
        fillColor = tokens.card;
        textColor = scheme.onSurface;
        borderWidth = (active || filled) ? 1.5 : AppRadii.hairlineWidth;
    }

    final settle = !MediaQuery.of(context).disableAnimations;

    return AnimatedContainer(
      duration: settle ? const Duration(milliseconds: 120) : Duration.zero,
      curve: Curves.easeOut,
      width: metrics.cellWidth,
      height: metrics.cellHeight,
      margin: EdgeInsets.symmetric(horizontal: metrics.cellGap / 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(AppRadii.small),
      ),
      child: Text(
        char,
        style: TextStyle(
          fontFamily: AppFonts.mono,
          fontSize: metrics.fontSize,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

class _SeparatorCell extends StatelessWidget {
  const _SeparatorCell({required this.char, required this.metrics});

  final String char;
  final _CellMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: metrics.separatorWidth,
      height: metrics.cellHeight,
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontFamily: AppFonts.mono,
            fontSize: metrics.fontSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
