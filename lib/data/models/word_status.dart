/// Learning state of a single word, persisted in the `word_progress` table.
///
/// Stored by name via Drift's `textEnum`, so renaming a value is a breaking
/// schema change.
enum WordStatus {
  learning,
  memorized,
}
