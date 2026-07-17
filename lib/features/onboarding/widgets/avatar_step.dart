import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../profile/avatar_view.dart';

/// Step 2: pick one of the 12 preset avatars.
class AvatarStep extends StatelessWidget {
  const AvatarStep({
    super.key,
    required this.selectedAvatarId,
    required this.onSelected,
  });

  final int? selectedAvatarId;
  final ValueChanged<int> onSelected;

  static const _avatarCount = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).avatarPrompt,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              for (var id = 0; id < _avatarCount; id++)
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => onSelected(id),
                  child: AvatarView(
                    avatarId: id,
                    size: 64,
                    selected: id == selectedAvatarId,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
