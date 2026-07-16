import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';

/// Reads and writes the single local [Profile] row.
class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  /// Emits the current profile, or `null` before onboarding completes.
  Stream<Profile?> watchProfile() =>
      _db.select(_db.profiles).watchSingleOrNull();

  Future<void> createProfile({
    required String nickname,
    required int avatarId,
    required String languagePairId,
    required int dailyGoal,
  }) {
    return _db.into(_db.profiles).insert(
          ProfilesCompanion.insert(
            nickname: nickname,
            avatarId: avatarId,
            languagePair: languagePairId,
            dailyGoal: Value(dailyGoal),
          ),
        );
  }

  /// Switches the active language pair. Progress is keyed by pairId, so the
  /// other pair's progress is untouched and restored on switching back. The
  /// caller refreshes the profile's per-pair aggregates afterwards.
  Future<void> updateLanguagePair(String pairId) {
    return _db
        .update(_db.profiles)
        .write(ProfilesCompanion(languagePair: Value(pairId)));
  }

  /// Updates the daily goal (words newly memorized per day).
  Future<void> updateDailyGoal(int dailyGoal) {
    // Single-profile app: the update targets the only row.
    return _db
        .update(_db.profiles)
        .write(ProfilesCompanion(dailyGoal: Value(dailyGoal)));
  }

  /// Updates the daily-reminder time; the notification is rescheduled
  /// reactively by `reminderSchedulerProvider`.
  Future<void> updateReminderTime({required int hour, required int minute}) {
    return _db.update(_db.profiles).write(
          ProfilesCompanion(
            reminderHour: Value(hour),
            reminderMinute: Value(minute),
          ),
        );
  }

  /// Links the profile to the signed-in Supabase user. Set only after the
  /// nickname claim / restore succeeds (see AccountLinker).
  Future<void> linkRemoteUser(String remoteUserId) {
    return _db
        .update(_db.profiles)
        .write(ProfilesCompanion(remoteUserId: Value(remoteUserId)));
  }

  /// Adopts the nickname that was actually claimed in the cloud (the local
  /// choice may have been taken globally).
  Future<void> updateNickname(String nickname) {
    return _db
        .update(_db.profiles)
        .write(ProfilesCompanion(nickname: Value(nickname)));
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(appDatabaseProvider)),
);

/// The current local profile, reactively updated from Drift. `null` means
/// onboarding has not been completed yet.
final profileProvider = StreamProvider<Profile?>(
  (ref) => ref.watch(profileRepositoryProvider).watchProfile(),
);
