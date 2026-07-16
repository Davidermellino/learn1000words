import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/progress_provider.dart';

/// One level in the Home stack: a wide card whose background fills with
/// highlighter left→right in proportion to the words memorized. The level
/// number (Space Grotesk) and the count (mono "42 / 100") sit on top; where
/// they cross the amber fill they switch to [AppTokens.onHighlighter] so they
/// read in both light and dark. Locked levels show no fill — a recessed
/// graphite number and a small lock.
///
/// Ten of these stacked are the 1000 words visibly filling.
class LevelCard extends StatelessWidget {
  const LevelCard({super.key, required this.progress, required this.onTap});

  final LevelProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locked = !progress.unlocked;

    // The fill animates in on load and on progress change; honour the OS
    // "reduce motion" setting by collapsing the animation to nothing.
    final animate = !MediaQuery.of(context).disableAnimations;
    final target = locked ? 0.0 : progress.fraction;

    return Semantics(
      button: true,
      label: locked
          ? 'Livello ${progress.level}, bloccato'
          : 'Livello ${progress.level}, '
              '${progress.memorizedWords} di ${progress.totalWords} parole',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: SizedBox(
          height: 84,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: target),
            duration:
                animate ? const Duration(milliseconds: 650) : Duration.zero,
            curve: Curves.easeOutCubic,
            builder: (context, fill, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // 1) Base card surface.
                      ColoredBox(color: tokens.card),
                      // 2) The highlighter fill, left→right.
                      if (!locked && fill > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: fill.clamp(0.0, 1.0),
                            heightFactor: 1,
                            child: ColoredBox(color: tokens.highlighter),
                          ),
                        ),
                      // 3) Content in its normal (off-amber) colours.
                      _CardContent(
                        progress: progress,
                        locked: locked,
                        foreground: locked
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                        caption: scheme.onSurfaceVariant,
                      ),
                      // 4) The same content, clipped to the fill and
                      // recoloured so it reads on the amber.
                      if (!locked && fill > 0)
                        ClipRect(
                          clipper: _LeftClipper(width * fill),
                          child: _CardContent(
                            progress: progress,
                            locked: false,
                            foreground: tokens.onHighlighter,
                            caption:
                                tokens.onHighlighter.withValues(alpha: 0.75),
                          ),
                        ),
                      // 5) Hairline border, above the fill.
                      IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadii.card),
                            border: Border.all(
                              color: tokens.hairline,
                              width: AppRadii.hairlineWidth,
                            ),
                          ),
                        ),
                      ),
                      // 6) Ripple + tap target on top.
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(onTap: onTap),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Clips its child to a left-hand column [width] wide — the amber region.
class _LeftClipper extends CustomClipper<Rect> {
  const _LeftClipper(this.width);

  final double width;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, size.height);

  @override
  bool shouldReclip(_LeftClipper oldClipper) => oldClipper.width != width;
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.progress,
    required this.locked,
    required this.foreground,
    required this.caption,
  });

  final LevelProgress progress;
  final bool locked;
  final Color foreground;
  final Color caption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final complete = progress.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LIVELLO',
                style: textTheme.labelSmall?.copyWith(
                  color: caption,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${progress.level}',
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontSize: 34,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (locked)
            Icon(Icons.lock_outline, size: 22, color: foreground)
          else ...[
            Text(
              '${progress.memorizedWords} / ${progress.totalWords}',
              style: textTheme.titleMedium?.copyWith(
                fontFamily: AppFonts.mono,
                fontWeight: FontWeight.w500,
                color: foreground,
              ),
            ),
            if (complete) ...[
              const SizedBox(width: 10),
              Icon(Icons.check_rounded, size: 22, color: foreground),
            ],
          ],
        ],
      ),
    );
  }
}
