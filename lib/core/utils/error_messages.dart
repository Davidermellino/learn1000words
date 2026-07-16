import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps an arbitrary exception to a short message safe to show in the UI,
/// so raw exception dumps (socket errors, stack-ish text) never reach users.
String friendlyErrorMessage(Object error) {
  if (_isNetworkError(error)) {
    return 'Impossibile contattare il server. '
        'Controlla la connessione e riprova.';
  }
  if (error is AuthException) {
    return 'Sessione scaduta o non valida. Accedi di nuovo.';
  }
  return 'Si è verificato un errore. Riprova.';
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
