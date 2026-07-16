import 'package:flutter/material.dart';

/// Step 1: enter a nickname. Validated as non-empty, 3–20 chars (trimmed).
class NicknameStep extends StatelessWidget {
  const NicknameStep({
    super.key,
    required this.controller,
    required this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Come vuoi essere chiamato?',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 20,
            decoration: InputDecoration(
              labelText: 'Nickname',
              border: const OutlineInputBorder(),
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Whether [nickname] passes validation: non-empty, 3–20 chars (trimmed).
bool isValidNickname(String nickname) {
  final trimmed = nickname.trim();
  return trimmed.length >= 3 && trimmed.length <= 20;
}

/// Error message to show below the field, or `null` if there's nothing to
/// report yet (field is empty) or the nickname is valid.
String? nicknameErrorText(String nickname) {
  final trimmed = nickname.trim();
  if (trimmed.isEmpty || isValidNickname(nickname)) return null;
  return 'Deve avere tra 3 e 20 caratteri';
}
