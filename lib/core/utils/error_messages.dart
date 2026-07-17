import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';

/// Maps an arbitrary exception to a short, localized message safe to show in
/// the UI, so raw exception dumps (socket errors, stack-ish text) never reach
/// users. Pass the caller's [AppLocalizations] (via `AppLocalizations.of`).
String friendlyErrorMessage(AppLocalizations l10n, Object error) {
  if (_isNetworkError(error)) {
    return l10n.errorNetwork;
  }
  if (error is AuthException) {
    return l10n.errorSession;
  }
  return l10n.errorGeneric;
}

bool _isNetworkError(Object error) {
  if (error is SocketException || error is AuthRetryableFetchException) {
    return true;
  }
  // Supabase/http wrap the socket error (e.g. ClientException with
  // SocketException: Failed host lookup) without exposing a typed cause.
  final text = error.toString();
  return text.contains('SocketException') ||
      text.contains('Failed host lookup') ||
      text.contains('ClientException') ||
      text.contains('Connection refused') ||
      text.contains('Connection timed out');
}
