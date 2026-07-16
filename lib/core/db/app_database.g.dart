// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetaTable extends AppMeta with TableInfo<$AppMetaTable, AppMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetaTable createAlias(String alias) {
    return $AppMetaTable(attachedDatabase, alias);
  }
}

class AppMetaData extends DataClass implements Insertable<AppMetaData> {
  final String key;
  final String value;
  const AppMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetaCompanion toCompanion(bool nullToAbsent) {
    return AppMetaCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetaData copyWith({String? key, String? value}) =>
      AppMetaData(key: key ?? this.key, value: value ?? this.value);
  AppMetaData copyWithCompanion(AppMetaCompanion data) {
    return AppMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetaCompanion extends UpdateCompanion<AppMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<int> avatarId = GeneratedColumn<int>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languagePairMeta = const VerificationMeta(
    'languagePair',
  );
  @override
  late final GeneratedColumn<String> languagePair = GeneratedColumn<String>(
    'language_pair',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remoteUserIdMeta = const VerificationMeta(
    'remoteUserId',
  );
  @override
  late final GeneratedColumn<String> remoteUserId = GeneratedColumn<String>(
    'remote_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memorizedCountMeta = const VerificationMeta(
    'memorizedCount',
  );
  @override
  late final GeneratedColumn<int> memorizedCount = GeneratedColumn<int>(
    'memorized_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentLevelMeta = const VerificationMeta(
    'currentLevel',
  );
  @override
  late final GeneratedColumn<int> currentLevel = GeneratedColumn<int>(
    'current_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _reminderHourMeta = const VerificationMeta(
    'reminderHour',
  );
  @override
  late final GeneratedColumn<int> reminderHour = GeneratedColumn<int>(
    'reminder_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(19),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nickname,
    avatarId,
    languagePair,
    dailyGoal,
    streak,
    remoteUserId,
    memorizedCount,
    currentLevel,
    reminderHour,
    reminderMinute,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarIdMeta);
    }
    if (data.containsKey('language_pair')) {
      context.handle(
        _languagePairMeta,
        languagePair.isAcceptableOrUnknown(
          data['language_pair']!,
          _languagePairMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languagePairMeta);
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('remote_user_id')) {
      context.handle(
        _remoteUserIdMeta,
        remoteUserId.isAcceptableOrUnknown(
          data['remote_user_id']!,
          _remoteUserIdMeta,
        ),
      );
    }
    if (data.containsKey('memorized_count')) {
      context.handle(
        _memorizedCountMeta,
        memorizedCount.isAcceptableOrUnknown(
          data['memorized_count']!,
          _memorizedCountMeta,
        ),
      );
    }
    if (data.containsKey('current_level')) {
      context.handle(
        _currentLevelMeta,
        currentLevel.isAcceptableOrUnknown(
          data['current_level']!,
          _currentLevelMeta,
        ),
      );
    }
    if (data.containsKey('reminder_hour')) {
      context.handle(
        _reminderHourMeta,
        reminderHour.isAcceptableOrUnknown(
          data['reminder_hour']!,
          _reminderHourMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avatar_id'],
      )!,
      languagePair: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_pair'],
      )!,
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      remoteUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_user_id'],
      ),
      memorizedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memorized_count'],
      )!,
      currentLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_level'],
      )!,
      reminderHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_hour'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String nickname;
  final int avatarId;

  /// The active learning pair's stable id (e.g. `it_hu`), discovered from a
  /// bundled language file — never an enum, so new languages need no schema
  /// change. Progress is keyed by this + wordId.
  final String languagePair;
  final int dailyGoal;
  final int streak;
  final String? remoteUserId;
  final int memorizedCount;
  final int currentLevel;
  final int reminderHour;
  final int reminderMinute;
  const Profile({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.languagePair,
    required this.dailyGoal,
    required this.streak,
    this.remoteUserId,
    required this.memorizedCount,
    required this.currentLevel,
    required this.reminderHour,
    required this.reminderMinute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nickname'] = Variable<String>(nickname);
    map['avatar_id'] = Variable<int>(avatarId);
    map['language_pair'] = Variable<String>(languagePair);
    map['daily_goal'] = Variable<int>(dailyGoal);
    map['streak'] = Variable<int>(streak);
    if (!nullToAbsent || remoteUserId != null) {
      map['remote_user_id'] = Variable<String>(remoteUserId);
    }
    map['memorized_count'] = Variable<int>(memorizedCount);
    map['current_level'] = Variable<int>(currentLevel);
    map['reminder_hour'] = Variable<int>(reminderHour);
    map['reminder_minute'] = Variable<int>(reminderMinute);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      avatarId: Value(avatarId),
      languagePair: Value(languagePair),
      dailyGoal: Value(dailyGoal),
      streak: Value(streak),
      remoteUserId: remoteUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUserId),
      memorizedCount: Value(memorizedCount),
      currentLevel: Value(currentLevel),
      reminderHour: Value(reminderHour),
      reminderMinute: Value(reminderMinute),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarId: serializer.fromJson<int>(json['avatarId']),
      languagePair: serializer.fromJson<String>(json['languagePair']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      streak: serializer.fromJson<int>(json['streak']),
      remoteUserId: serializer.fromJson<String?>(json['remoteUserId']),
      memorizedCount: serializer.fromJson<int>(json['memorizedCount']),
      currentLevel: serializer.fromJson<int>(json['currentLevel']),
      reminderHour: serializer.fromJson<int>(json['reminderHour']),
      reminderMinute: serializer.fromJson<int>(json['reminderMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String>(nickname),
      'avatarId': serializer.toJson<int>(avatarId),
      'languagePair': serializer.toJson<String>(languagePair),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'streak': serializer.toJson<int>(streak),
      'remoteUserId': serializer.toJson<String?>(remoteUserId),
      'memorizedCount': serializer.toJson<int>(memorizedCount),
      'currentLevel': serializer.toJson<int>(currentLevel),
      'reminderHour': serializer.toJson<int>(reminderHour),
      'reminderMinute': serializer.toJson<int>(reminderMinute),
    };
  }

  Profile copyWith({
    int? id,
    String? nickname,
    int? avatarId,
    String? languagePair,
    int? dailyGoal,
    int? streak,
    Value<String?> remoteUserId = const Value.absent(),
    int? memorizedCount,
    int? currentLevel,
    int? reminderHour,
    int? reminderMinute,
  }) => Profile(
    id: id ?? this.id,
    nickname: nickname ?? this.nickname,
    avatarId: avatarId ?? this.avatarId,
    languagePair: languagePair ?? this.languagePair,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    streak: streak ?? this.streak,
    remoteUserId: remoteUserId.present ? remoteUserId.value : this.remoteUserId,
    memorizedCount: memorizedCount ?? this.memorizedCount,
    currentLevel: currentLevel ?? this.currentLevel,
    reminderHour: reminderHour ?? this.reminderHour,
    reminderMinute: reminderMinute ?? this.reminderMinute,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      languagePair: data.languagePair.present
          ? data.languagePair.value
          : this.languagePair,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      streak: data.streak.present ? data.streak.value : this.streak,
      remoteUserId: data.remoteUserId.present
          ? data.remoteUserId.value
          : this.remoteUserId,
      memorizedCount: data.memorizedCount.present
          ? data.memorizedCount.value
          : this.memorizedCount,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      reminderHour: data.reminderHour.present
          ? data.reminderHour.value
          : this.reminderHour,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('languagePair: $languagePair, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('streak: $streak, ')
          ..write('remoteUserId: $remoteUserId, ')
          ..write('memorizedCount: $memorizedCount, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nickname,
    avatarId,
    languagePair,
    dailyGoal,
    streak,
    remoteUserId,
    memorizedCount,
    currentLevel,
    reminderHour,
    reminderMinute,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.avatarId == this.avatarId &&
          other.languagePair == this.languagePair &&
          other.dailyGoal == this.dailyGoal &&
          other.streak == this.streak &&
          other.remoteUserId == this.remoteUserId &&
          other.memorizedCount == this.memorizedCount &&
          other.currentLevel == this.currentLevel &&
          other.reminderHour == this.reminderHour &&
          other.reminderMinute == this.reminderMinute);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> nickname;
  final Value<int> avatarId;
  final Value<String> languagePair;
  final Value<int> dailyGoal;
  final Value<int> streak;
  final Value<String?> remoteUserId;
  final Value<int> memorizedCount;
  final Value<int> currentLevel;
  final Value<int> reminderHour;
  final Value<int> reminderMinute;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.languagePair = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.streak = const Value.absent(),
    this.remoteUserId = const Value.absent(),
    this.memorizedCount = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String nickname,
    required int avatarId,
    required String languagePair,
    this.dailyGoal = const Value.absent(),
    this.streak = const Value.absent(),
    this.remoteUserId = const Value.absent(),
    this.memorizedCount = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
  }) : nickname = Value(nickname),
       avatarId = Value(avatarId),
       languagePair = Value(languagePair);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<int>? avatarId,
    Expression<String>? languagePair,
    Expression<int>? dailyGoal,
    Expression<int>? streak,
    Expression<String>? remoteUserId,
    Expression<int>? memorizedCount,
    Expression<int>? currentLevel,
    Expression<int>? reminderHour,
    Expression<int>? reminderMinute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (avatarId != null) 'avatar_id': avatarId,
      if (languagePair != null) 'language_pair': languagePair,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (streak != null) 'streak': streak,
      if (remoteUserId != null) 'remote_user_id': remoteUserId,
      if (memorizedCount != null) 'memorized_count': memorizedCount,
      if (currentLevel != null) 'current_level': currentLevel,
      if (reminderHour != null) 'reminder_hour': reminderHour,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? nickname,
    Value<int>? avatarId,
    Value<String>? languagePair,
    Value<int>? dailyGoal,
    Value<int>? streak,
    Value<String?>? remoteUserId,
    Value<int>? memorizedCount,
    Value<int>? currentLevel,
    Value<int>? reminderHour,
    Value<int>? reminderMinute,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      languagePair: languagePair ?? this.languagePair,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      streak: streak ?? this.streak,
      remoteUserId: remoteUserId ?? this.remoteUserId,
      memorizedCount: memorizedCount ?? this.memorizedCount,
      currentLevel: currentLevel ?? this.currentLevel,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<int>(avatarId.value);
    }
    if (languagePair.present) {
      map['language_pair'] = Variable<String>(languagePair.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (remoteUserId.present) {
      map['remote_user_id'] = Variable<String>(remoteUserId.value);
    }
    if (memorizedCount.present) {
      map['memorized_count'] = Variable<int>(memorizedCount.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<int>(currentLevel.value);
    }
    if (reminderHour.present) {
      map['reminder_hour'] = Variable<int>(reminderHour.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('languagePair: $languagePair, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('streak: $streak, ')
          ..write('remoteUserId: $remoteUserId, ')
          ..write('memorizedCount: $memorizedCount, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute')
          ..write(')'))
        .toString();
  }
}

class $WordProgressTable extends WordProgress
    with TableInfo<$WordProgressTable, WordProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pairIdMeta = const VerificationMeta('pairId');
  @override
  late final GeneratedColumn<String> pairId = GeneratedColumn<String>(
    'pair_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WordStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(WordStatus.learning.name),
      ).withConverter<WordStatus>($WordProgressTable.$converterstatus);
  static const VerificationMeta _memorizedAtMeta = const VerificationMeta(
    'memorizedAt',
  );
  @override
  late final GeneratedColumn<DateTime> memorizedAt = GeneratedColumn<DateTime>(
    'memorized_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [pairId, wordId, status, memorizedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pair_id')) {
      context.handle(
        _pairIdMeta,
        pairId.isAcceptableOrUnknown(data['pair_id']!, _pairIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pairIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('memorized_at')) {
      context.handle(
        _memorizedAtMeta,
        memorizedAt.isAcceptableOrUnknown(
          data['memorized_at']!,
          _memorizedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pairId, wordId};
  @override
  WordProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordProgressRow(
      pairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      status: $WordProgressTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      memorizedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}memorized_at'],
      ),
    );
  }

  @override
  $WordProgressTable createAlias(String alias) {
    return $WordProgressTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WordStatus, String, String> $converterstatus =
      const EnumNameConverter<WordStatus>(WordStatus.values);
}

class WordProgressRow extends DataClass implements Insertable<WordProgressRow> {
  final String pairId;
  final int wordId;
  final WordStatus status;
  final DateTime? memorizedAt;
  const WordProgressRow({
    required this.pairId,
    required this.wordId,
    required this.status,
    this.memorizedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pair_id'] = Variable<String>(pairId);
    map['word_id'] = Variable<int>(wordId);
    {
      map['status'] = Variable<String>(
        $WordProgressTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || memorizedAt != null) {
      map['memorized_at'] = Variable<DateTime>(memorizedAt);
    }
    return map;
  }

  WordProgressCompanion toCompanion(bool nullToAbsent) {
    return WordProgressCompanion(
      pairId: Value(pairId),
      wordId: Value(wordId),
      status: Value(status),
      memorizedAt: memorizedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(memorizedAt),
    );
  }

  factory WordProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordProgressRow(
      pairId: serializer.fromJson<String>(json['pairId']),
      wordId: serializer.fromJson<int>(json['wordId']),
      status: $WordProgressTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      memorizedAt: serializer.fromJson<DateTime?>(json['memorizedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pairId': serializer.toJson<String>(pairId),
      'wordId': serializer.toJson<int>(wordId),
      'status': serializer.toJson<String>(
        $WordProgressTable.$converterstatus.toJson(status),
      ),
      'memorizedAt': serializer.toJson<DateTime?>(memorizedAt),
    };
  }

  WordProgressRow copyWith({
    String? pairId,
    int? wordId,
    WordStatus? status,
    Value<DateTime?> memorizedAt = const Value.absent(),
  }) => WordProgressRow(
    pairId: pairId ?? this.pairId,
    wordId: wordId ?? this.wordId,
    status: status ?? this.status,
    memorizedAt: memorizedAt.present ? memorizedAt.value : this.memorizedAt,
  );
  WordProgressRow copyWithCompanion(WordProgressCompanion data) {
    return WordProgressRow(
      pairId: data.pairId.present ? data.pairId.value : this.pairId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      status: data.status.present ? data.status.value : this.status,
      memorizedAt: data.memorizedAt.present
          ? data.memorizedAt.value
          : this.memorizedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordProgressRow(')
          ..write('pairId: $pairId, ')
          ..write('wordId: $wordId, ')
          ..write('status: $status, ')
          ..write('memorizedAt: $memorizedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pairId, wordId, status, memorizedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordProgressRow &&
          other.pairId == this.pairId &&
          other.wordId == this.wordId &&
          other.status == this.status &&
          other.memorizedAt == this.memorizedAt);
}

class WordProgressCompanion extends UpdateCompanion<WordProgressRow> {
  final Value<String> pairId;
  final Value<int> wordId;
  final Value<WordStatus> status;
  final Value<DateTime?> memorizedAt;
  final Value<int> rowid;
  const WordProgressCompanion({
    this.pairId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.status = const Value.absent(),
    this.memorizedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordProgressCompanion.insert({
    required String pairId,
    required int wordId,
    this.status = const Value.absent(),
    this.memorizedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : pairId = Value(pairId),
       wordId = Value(wordId);
  static Insertable<WordProgressRow> custom({
    Expression<String>? pairId,
    Expression<int>? wordId,
    Expression<String>? status,
    Expression<DateTime>? memorizedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pairId != null) 'pair_id': pairId,
      if (wordId != null) 'word_id': wordId,
      if (status != null) 'status': status,
      if (memorizedAt != null) 'memorized_at': memorizedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordProgressCompanion copyWith({
    Value<String>? pairId,
    Value<int>? wordId,
    Value<WordStatus>? status,
    Value<DateTime?>? memorizedAt,
    Value<int>? rowid,
  }) {
    return WordProgressCompanion(
      pairId: pairId ?? this.pairId,
      wordId: wordId ?? this.wordId,
      status: status ?? this.status,
      memorizedAt: memorizedAt ?? this.memorizedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pairId.present) {
      map['pair_id'] = Variable<String>(pairId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WordProgressTable.$converterstatus.toSql(status.value),
      );
    }
    if (memorizedAt.present) {
      map['memorized_at'] = Variable<DateTime>(memorizedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordProgressCompanion(')
          ..write('pairId: $pairId, ')
          ..write('wordId: $wordId, ')
          ..write('status: $status, ')
          ..write('memorizedAt: $memorizedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageSentencesTable extends UsageSentences
    with TableInfo<$UsageSentencesTable, UsageSentenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageSentencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pairIdMeta = const VerificationMeta('pairId');
  @override
  late final GeneratedColumn<String> pairId = GeneratedColumn<String>(
    'pair_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pairId,
    wordId,
    sentence,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_sentences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageSentenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pair_id')) {
      context.handle(
        _pairIdMeta,
        pairId.isAcceptableOrUnknown(data['pair_id']!, _pairIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pairIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['text']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageSentenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageSentenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      sentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsageSentencesTable createAlias(String alias) {
    return $UsageSentencesTable(attachedDatabase, alias);
  }
}

class UsageSentenceRow extends DataClass
    implements Insertable<UsageSentenceRow> {
  final int id;

  /// The language pair (a [LanguagePairInfo.pairId]) the sentence was written
  /// under; the history is scoped to the active pair.
  final String pairId;

  /// Id of the word (in the pair's bundled file) the sentence had to use.
  final int wordId;
  final String sentence;
  final DateTime createdAt;
  const UsageSentenceRow({
    required this.id,
    required this.pairId,
    required this.wordId,
    required this.sentence,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pair_id'] = Variable<String>(pairId);
    map['word_id'] = Variable<int>(wordId);
    map['text'] = Variable<String>(sentence);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsageSentencesCompanion toCompanion(bool nullToAbsent) {
    return UsageSentencesCompanion(
      id: Value(id),
      pairId: Value(pairId),
      wordId: Value(wordId),
      sentence: Value(sentence),
      createdAt: Value(createdAt),
    );
  }

  factory UsageSentenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageSentenceRow(
      id: serializer.fromJson<int>(json['id']),
      pairId: serializer.fromJson<String>(json['pairId']),
      wordId: serializer.fromJson<int>(json['wordId']),
      sentence: serializer.fromJson<String>(json['sentence']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pairId': serializer.toJson<String>(pairId),
      'wordId': serializer.toJson<int>(wordId),
      'sentence': serializer.toJson<String>(sentence),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UsageSentenceRow copyWith({
    int? id,
    String? pairId,
    int? wordId,
    String? sentence,
    DateTime? createdAt,
  }) => UsageSentenceRow(
    id: id ?? this.id,
    pairId: pairId ?? this.pairId,
    wordId: wordId ?? this.wordId,
    sentence: sentence ?? this.sentence,
    createdAt: createdAt ?? this.createdAt,
  );
  UsageSentenceRow copyWithCompanion(UsageSentencesCompanion data) {
    return UsageSentenceRow(
      id: data.id.present ? data.id.value : this.id,
      pairId: data.pairId.present ? data.pairId.value : this.pairId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageSentenceRow(')
          ..write('id: $id, ')
          ..write('pairId: $pairId, ')
          ..write('wordId: $wordId, ')
          ..write('sentence: $sentence, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pairId, wordId, sentence, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageSentenceRow &&
          other.id == this.id &&
          other.pairId == this.pairId &&
          other.wordId == this.wordId &&
          other.sentence == this.sentence &&
          other.createdAt == this.createdAt);
}

class UsageSentencesCompanion extends UpdateCompanion<UsageSentenceRow> {
  final Value<int> id;
  final Value<String> pairId;
  final Value<int> wordId;
  final Value<String> sentence;
  final Value<DateTime> createdAt;
  const UsageSentencesCompanion({
    this.id = const Value.absent(),
    this.pairId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.sentence = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsageSentencesCompanion.insert({
    this.id = const Value.absent(),
    required String pairId,
    required int wordId,
    required String sentence,
    required DateTime createdAt,
  }) : pairId = Value(pairId),
       wordId = Value(wordId),
       sentence = Value(sentence),
       createdAt = Value(createdAt);
  static Insertable<UsageSentenceRow> custom({
    Expression<int>? id,
    Expression<String>? pairId,
    Expression<int>? wordId,
    Expression<String>? sentence,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pairId != null) 'pair_id': pairId,
      if (wordId != null) 'word_id': wordId,
      if (sentence != null) 'text': sentence,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsageSentencesCompanion copyWith({
    Value<int>? id,
    Value<String>? pairId,
    Value<int>? wordId,
    Value<String>? sentence,
    Value<DateTime>? createdAt,
  }) {
    return UsageSentencesCompanion(
      id: id ?? this.id,
      pairId: pairId ?? this.pairId,
      wordId: wordId ?? this.wordId,
      sentence: sentence ?? this.sentence,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pairId.present) {
      map['pair_id'] = Variable<String>(pairId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (sentence.present) {
      map['text'] = Variable<String>(sentence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageSentencesCompanion(')
          ..write('id: $id, ')
          ..write('pairId: $pairId, ')
          ..write('wordId: $wordId, ')
          ..write('sentence: $sentence, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyActivityTable extends DailyActivity
    with TableInfo<$DailyActivityTable, DailyActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memorizedCountMeta = const VerificationMeta(
    'memorizedCount',
  );
  @override
  late final GeneratedColumn<int> memorizedCount = GeneratedColumn<int>(
    'memorized_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _goalMetMeta = const VerificationMeta(
    'goalMet',
  );
  @override
  late final GeneratedColumn<bool> goalMet = GeneratedColumn<bool>(
    'goal_met',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("goal_met" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [date, memorizedCount, goalMet];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('memorized_count')) {
      context.handle(
        _memorizedCountMeta,
        memorizedCount.isAcceptableOrUnknown(
          data['memorized_count']!,
          _memorizedCountMeta,
        ),
      );
    }
    if (data.containsKey('goal_met')) {
      context.handle(
        _goalMetMeta,
        goalMet.isAcceptableOrUnknown(data['goal_met']!, _goalMetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      memorizedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memorized_count'],
      )!,
      goalMet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}goal_met'],
      )!,
    );
  }

  @override
  $DailyActivityTable createAlias(String alias) {
    return $DailyActivityTable(attachedDatabase, alias);
  }
}

class DailyActivityRow extends DataClass
    implements Insertable<DailyActivityRow> {
  /// Local calendar day as `yyyy-MM-dd`.
  final String date;
  final int memorizedCount;
  final bool goalMet;
  const DailyActivityRow({
    required this.date,
    required this.memorizedCount,
    required this.goalMet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['memorized_count'] = Variable<int>(memorizedCount);
    map['goal_met'] = Variable<bool>(goalMet);
    return map;
  }

  DailyActivityCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityCompanion(
      date: Value(date),
      memorizedCount: Value(memorizedCount),
      goalMet: Value(goalMet),
    );
  }

  factory DailyActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityRow(
      date: serializer.fromJson<String>(json['date']),
      memorizedCount: serializer.fromJson<int>(json['memorizedCount']),
      goalMet: serializer.fromJson<bool>(json['goalMet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'memorizedCount': serializer.toJson<int>(memorizedCount),
      'goalMet': serializer.toJson<bool>(goalMet),
    };
  }

  DailyActivityRow copyWith({
    String? date,
    int? memorizedCount,
    bool? goalMet,
  }) => DailyActivityRow(
    date: date ?? this.date,
    memorizedCount: memorizedCount ?? this.memorizedCount,
    goalMet: goalMet ?? this.goalMet,
  );
  DailyActivityRow copyWithCompanion(DailyActivityCompanion data) {
    return DailyActivityRow(
      date: data.date.present ? data.date.value : this.date,
      memorizedCount: data.memorizedCount.present
          ? data.memorizedCount.value
          : this.memorizedCount,
      goalMet: data.goalMet.present ? data.goalMet.value : this.goalMet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityRow(')
          ..write('date: $date, ')
          ..write('memorizedCount: $memorizedCount, ')
          ..write('goalMet: $goalMet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, memorizedCount, goalMet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityRow &&
          other.date == this.date &&
          other.memorizedCount == this.memorizedCount &&
          other.goalMet == this.goalMet);
}

class DailyActivityCompanion extends UpdateCompanion<DailyActivityRow> {
  final Value<String> date;
  final Value<int> memorizedCount;
  final Value<bool> goalMet;
  final Value<int> rowid;
  const DailyActivityCompanion({
    this.date = const Value.absent(),
    this.memorizedCount = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityCompanion.insert({
    required String date,
    this.memorizedCount = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyActivityRow> custom({
    Expression<String>? date,
    Expression<int>? memorizedCount,
    Expression<bool>? goalMet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (memorizedCount != null) 'memorized_count': memorizedCount,
      if (goalMet != null) 'goal_met': goalMet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityCompanion copyWith({
    Value<String>? date,
    Value<int>? memorizedCount,
    Value<bool>? goalMet,
    Value<int>? rowid,
  }) {
    return DailyActivityCompanion(
      date: date ?? this.date,
      memorizedCount: memorizedCount ?? this.memorizedCount,
      goalMet: goalMet ?? this.goalMet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (memorizedCount.present) {
      map['memorized_count'] = Variable<int>(memorizedCount.value);
    }
    if (goalMet.present) {
      map['goal_met'] = Variable<bool>(goalMet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityCompanion(')
          ..write('date: $date, ')
          ..write('memorizedCount: $memorizedCount, ')
          ..write('goalMet: $goalMet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetaTable appMeta = $AppMetaTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $WordProgressTable wordProgress = $WordProgressTable(this);
  late final $UsageSentencesTable usageSentences = $UsageSentencesTable(this);
  late final $DailyActivityTable dailyActivity = $DailyActivityTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMeta,
    profiles,
    wordProgress,
    usageSentences,
    dailyActivity,
  ];
}

typedef $$AppMetaTableCreateCompanionBuilder =
    AppMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetaTableUpdateCompanionBuilder =
    AppMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetaTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaTable,
          AppMetaData,
          $$AppMetaTableFilterComposer,
          $$AppMetaTableOrderingComposer,
          $$AppMetaTableAnnotationComposer,
          $$AppMetaTableCreateCompanionBuilder,
          $$AppMetaTableUpdateCompanionBuilder,
          (
            AppMetaData,
            BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>,
          ),
          AppMetaData,
          PrefetchHooks Function()
        > {
  $$AppMetaTableTableManager(_$AppDatabase db, $AppMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaTable,
      AppMetaData,
      $$AppMetaTableFilterComposer,
      $$AppMetaTableOrderingComposer,
      $$AppMetaTableAnnotationComposer,
      $$AppMetaTableCreateCompanionBuilder,
      $$AppMetaTableUpdateCompanionBuilder,
      (AppMetaData, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>),
      AppMetaData,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      required String nickname,
      required int avatarId,
      required String languagePair,
      Value<int> dailyGoal,
      Value<int> streak,
      Value<String?> remoteUserId,
      Value<int> memorizedCount,
      Value<int> currentLevel,
      Value<int> reminderHour,
      Value<int> reminderMinute,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> nickname,
      Value<int> avatarId,
      Value<String> languagePair,
      Value<int> dailyGoal,
      Value<int> streak,
      Value<String?> remoteUserId,
      Value<int> memorizedCount,
      Value<int> currentLevel,
      Value<int> reminderHour,
      Value<int> reminderMinute,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languagePair => $composableBuilder(
    column: $table.languagePair,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteUserId => $composableBuilder(
    column: $table.remoteUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memorizedCount => $composableBuilder(
    column: $table.memorizedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languagePair => $composableBuilder(
    column: $table.languagePair,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteUserId => $composableBuilder(
    column: $table.remoteUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memorizedCount => $composableBuilder(
    column: $table.memorizedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<int> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get languagePair => $composableBuilder(
    column: $table.languagePair,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<String> get remoteUserId => $composableBuilder(
    column: $table.remoteUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memorizedCount => $composableBuilder(
    column: $table.memorizedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<int> avatarId = const Value.absent(),
                Value<String> languagePair = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<String?> remoteUserId = const Value.absent(),
                Value<int> memorizedCount = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                nickname: nickname,
                avatarId: avatarId,
                languagePair: languagePair,
                dailyGoal: dailyGoal,
                streak: streak,
                remoteUserId: remoteUserId,
                memorizedCount: memorizedCount,
                currentLevel: currentLevel,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nickname,
                required int avatarId,
                required String languagePair,
                Value<int> dailyGoal = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<String?> remoteUserId = const Value.absent(),
                Value<int> memorizedCount = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                nickname: nickname,
                avatarId: avatarId,
                languagePair: languagePair,
                dailyGoal: dailyGoal,
                streak: streak,
                remoteUserId: remoteUserId,
                memorizedCount: memorizedCount,
                currentLevel: currentLevel,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$WordProgressTableCreateCompanionBuilder =
    WordProgressCompanion Function({
      required String pairId,
      required int wordId,
      Value<WordStatus> status,
      Value<DateTime?> memorizedAt,
      Value<int> rowid,
    });
typedef $$WordProgressTableUpdateCompanionBuilder =
    WordProgressCompanion Function({
      Value<String> pairId,
      Value<int> wordId,
      Value<WordStatus> status,
      Value<DateTime?> memorizedAt,
      Value<int> rowid,
    });

class $$WordProgressTableFilterComposer
    extends Composer<_$AppDatabase, $WordProgressTable> {
  $$WordProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get pairId => $composableBuilder(
    column: $table.pairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WordStatus, WordStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get memorizedAt => $composableBuilder(
    column: $table.memorizedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $WordProgressTable> {
  $$WordProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get pairId => $composableBuilder(
    column: $table.pairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get memorizedAt => $composableBuilder(
    column: $table.memorizedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordProgressTable> {
  $$WordProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get pairId =>
      $composableBuilder(column: $table.pairId, builder: (column) => column);

  GeneratedColumn<int> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WordStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get memorizedAt => $composableBuilder(
    column: $table.memorizedAt,
    builder: (column) => column,
  );
}

class $$WordProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordProgressTable,
          WordProgressRow,
          $$WordProgressTableFilterComposer,
          $$WordProgressTableOrderingComposer,
          $$WordProgressTableAnnotationComposer,
          $$WordProgressTableCreateCompanionBuilder,
          $$WordProgressTableUpdateCompanionBuilder,
          (
            WordProgressRow,
            BaseReferences<_$AppDatabase, $WordProgressTable, WordProgressRow>,
          ),
          WordProgressRow,
          PrefetchHooks Function()
        > {
  $$WordProgressTableTableManager(_$AppDatabase db, $WordProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> pairId = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<WordStatus> status = const Value.absent(),
                Value<DateTime?> memorizedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordProgressCompanion(
                pairId: pairId,
                wordId: wordId,
                status: status,
                memorizedAt: memorizedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String pairId,
                required int wordId,
                Value<WordStatus> status = const Value.absent(),
                Value<DateTime?> memorizedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordProgressCompanion.insert(
                pairId: pairId,
                wordId: wordId,
                status: status,
                memorizedAt: memorizedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordProgressTable,
      WordProgressRow,
      $$WordProgressTableFilterComposer,
      $$WordProgressTableOrderingComposer,
      $$WordProgressTableAnnotationComposer,
      $$WordProgressTableCreateCompanionBuilder,
      $$WordProgressTableUpdateCompanionBuilder,
      (
        WordProgressRow,
        BaseReferences<_$AppDatabase, $WordProgressTable, WordProgressRow>,
      ),
      WordProgressRow,
      PrefetchHooks Function()
    >;
typedef $$UsageSentencesTableCreateCompanionBuilder =
    UsageSentencesCompanion Function({
      Value<int> id,
      required String pairId,
      required int wordId,
      required String sentence,
      required DateTime createdAt,
    });
typedef $$UsageSentencesTableUpdateCompanionBuilder =
    UsageSentencesCompanion Function({
      Value<int> id,
      Value<String> pairId,
      Value<int> wordId,
      Value<String> sentence,
      Value<DateTime> createdAt,
    });

class $$UsageSentencesTableFilterComposer
    extends Composer<_$AppDatabase, $UsageSentencesTable> {
  $$UsageSentencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pairId => $composableBuilder(
    column: $table.pairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageSentencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageSentencesTable> {
  $$UsageSentencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pairId => $composableBuilder(
    column: $table.pairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageSentencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageSentencesTable> {
  $$UsageSentencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pairId =>
      $composableBuilder(column: $table.pairId, builder: (column) => column);

  GeneratedColumn<int> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsageSentencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageSentencesTable,
          UsageSentenceRow,
          $$UsageSentencesTableFilterComposer,
          $$UsageSentencesTableOrderingComposer,
          $$UsageSentencesTableAnnotationComposer,
          $$UsageSentencesTableCreateCompanionBuilder,
          $$UsageSentencesTableUpdateCompanionBuilder,
          (
            UsageSentenceRow,
            BaseReferences<
              _$AppDatabase,
              $UsageSentencesTable,
              UsageSentenceRow
            >,
          ),
          UsageSentenceRow,
          PrefetchHooks Function()
        > {
  $$UsageSentencesTableTableManager(
    _$AppDatabase db,
    $UsageSentencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageSentencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageSentencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageSentencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pairId = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsageSentencesCompanion(
                id: id,
                pairId: pairId,
                wordId: wordId,
                sentence: sentence,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pairId,
                required int wordId,
                required String sentence,
                required DateTime createdAt,
              }) => UsageSentencesCompanion.insert(
                id: id,
                pairId: pairId,
                wordId: wordId,
                sentence: sentence,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageSentencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageSentencesTable,
      UsageSentenceRow,
      $$UsageSentencesTableFilterComposer,
      $$UsageSentencesTableOrderingComposer,
      $$UsageSentencesTableAnnotationComposer,
      $$UsageSentencesTableCreateCompanionBuilder,
      $$UsageSentencesTableUpdateCompanionBuilder,
      (
        UsageSentenceRow,
        BaseReferences<_$AppDatabase, $UsageSentencesTable, UsageSentenceRow>,
      ),
      UsageSentenceRow,
      PrefetchHooks Function()
    >;
typedef $$DailyActivityTableCreateCompanionBuilder =
    DailyActivityCompanion Function({
      required String date,
      Value<int> memorizedCount,
      Value<bool> goalMet,
      Value<int> rowid,
    });
typedef $$DailyActivityTableUpdateCompanionBuilder =
    DailyActivityCompanion Function({
      Value<String> date,
      Value<int> memorizedCount,
      Value<bool> goalMet,
      Value<int> rowid,
    });

class $$DailyActivityTableFilterComposer
    extends Composer<_$AppDatabase, $DailyActivityTable> {
  $$DailyActivityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memorizedCount => $composableBuilder(
    column: $table.memorizedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyActivityTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyActivityTable> {
  $$DailyActivityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memorizedCount => $composableBuilder(
    column: $table.memorizedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyActivityTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyActivityTable> {
  $$DailyActivityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get memorizedCount => $composableBuilder(
    column: $table.memorizedCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get goalMet =>
      $composableBuilder(column: $table.goalMet, builder: (column) => column);
}

class $$DailyActivityTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyActivityTable,
          DailyActivityRow,
          $$DailyActivityTableFilterComposer,
          $$DailyActivityTableOrderingComposer,
          $$DailyActivityTableAnnotationComposer,
          $$DailyActivityTableCreateCompanionBuilder,
          $$DailyActivityTableUpdateCompanionBuilder,
          (
            DailyActivityRow,
            BaseReferences<
              _$AppDatabase,
              $DailyActivityTable,
              DailyActivityRow
            >,
          ),
          DailyActivityRow,
          PrefetchHooks Function()
        > {
  $$DailyActivityTableTableManager(_$AppDatabase db, $DailyActivityTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyActivityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyActivityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyActivityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> memorizedCount = const Value.absent(),
                Value<bool> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion(
                date: date,
                memorizedCount: memorizedCount,
                goalMet: goalMet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int> memorizedCount = const Value.absent(),
                Value<bool> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion.insert(
                date: date,
                memorizedCount: memorizedCount,
                goalMet: goalMet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyActivityTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyActivityTable,
      DailyActivityRow,
      $$DailyActivityTableFilterComposer,
      $$DailyActivityTableOrderingComposer,
      $$DailyActivityTableAnnotationComposer,
      $$DailyActivityTableCreateCompanionBuilder,
      $$DailyActivityTableUpdateCompanionBuilder,
      (
        DailyActivityRow,
        BaseReferences<_$AppDatabase, $DailyActivityTable, DailyActivityRow>,
      ),
      DailyActivityRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetaTableTableManager get appMeta =>
      $$AppMetaTableTableManager(_db, _db.appMeta);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$WordProgressTableTableManager get wordProgress =>
      $$WordProgressTableTableManager(_db, _db.wordProgress);
  $$UsageSentencesTableTableManager get usageSentences =>
      $$UsageSentencesTableTableManager(_db, _db.usageSentences);
  $$DailyActivityTableTableManager get dailyActivity =>
      $$DailyActivityTableTableManager(_db, _db.dailyActivity);
}
