import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Renders one of the 12 preset in-app avatars: a flat ink glyph on a soft
/// neutral disc with a hairline edge. Deliberately monochrome — amber belongs
/// to progress, so avatars stay out of its way. No external image assets.
class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    required this.avatarId,
    this.size = 56,
    this.selected = false,
  }) : assert(avatarId >= 0 && avatarId < _glyphs.length);

  /// 0–11, indexing into the preset avatar list.
  final int avatarId;
  final double size;
  final bool selected;

  /// Distinct, flat Material glyphs — recognizable at 40px, all one weight.
  static const _glyphs = <IconData>[
    Icons.pets,
    Icons.cruelty_free,
    Icons.flutter_dash,
    Icons.eco,
    Icons.local_florist,
    Icons.spa,
    Icons.bolt,
    Icons.star,
    Icons.favorite,
    Icons.cloud,
    Icons.ac_unit,
    Icons.rocket_launch,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = AppTokens.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // A faint ink wash so the disc reads on both the page and a card.
        color: scheme.onSurface.withValues(alpha: 0.06),
        // Selection is not "known", so the ring is ink — never amber.
        border: Border.all(
          color: selected ? scheme.onSurface : tokens.hairline,
          width: selected ? 2 : AppRadii.hairlineWidth,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        _glyphs[avatarId],
        size: size * 0.5,
        color: scheme.onSurface,
      ),
    );
  }
}
