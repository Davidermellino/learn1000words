import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_providers.dart';

/// The public identity of another user, as returned by nickname search and
/// the incoming-requests RPC: never more than id + nickname + avatar.
class PublicProfile {
  const PublicProfile({
    required this.id,
    required this.nickname,
    required this.avatarId,
  });

  factory PublicProfile.fromJson(Map<String, dynamic> json) => PublicProfile(
        id: json['id'] as String,
        nickname: json['nickname'] as String,
        avatarId: json['avatar_id'] as int,
      );

  final String id;
  final String nickname;
  final int avatarId;
}

/// An accepted friend, with the aggregate progress fields friends may see
/// (their ACTIVE pair's language + level + memorized count — never
/// word-level data). All three describe the friend's currently active pair.
class FriendProfile {
  const FriendProfile({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.languagePairId,
    required this.currentLevel,
    required this.memorizedCount,
  });

  factory FriendProfile.fromJson(Map<String, dynamic> json) => FriendProfile(
        id: json['id'] as String,
        nickname: json['nickname'] as String,
        avatarId: json['avatar_id'] as int,
        languagePairId: json['language_pair'] as String,
        currentLevel: json['current_level'] as int,
        memorizedCount: json['memorized_count'] as int,
      );

  final String id;
  final String nickname;
  final int avatarId;

  /// The friend's active pair id (e.g. `it_hu`); resolved to a display label
  /// against the local discovered pairs by the UI.
  final String languagePairId;

  final int currentLevel;
  final int memorizedCount;
}

/// A pending request addressed to the current user.
class IncomingRequest {
  const IncomingRequest({
    required this.requestId,
    required this.sender,
    required this.createdAt,
  });

  factory IncomingRequest.fromJson(Map<String, dynamic> json) =>
      IncomingRequest(
        requestId: json['request_id'] as String,
        sender: PublicProfile(
          id: json['from_user'] as String,
          nickname: json['nickname'] as String,
          avatarId: json['avatar_id'] as int,
        ),
        createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      );

  final String requestId;
  final PublicProfile sender;
  final DateTime createdAt;
}

/// How the current user relates to a searched profile; drives the action
/// button shown on a search result.
enum FriendLinkStatus { none, requestSent, requestReceived, friends }

/// Supabase-backed friends data: search, requests, and the friends list.
/// Cloud-only (no local mirror) — the Friends tab requires a signed-in
/// session anyway, and this data is meaningless offline.
class FriendsRepository {
  FriendsRepository(this._client);

  final SupabaseClient _client;

  String get _uid => _client.auth.currentUser!.id;

  /// Case-insensitive prefix search by nickname. Returns public fields only
  /// (enforced server-side by the `search_profiles` RPC).
  Future<List<PublicProfile>> searchByNickname(String query) async {
    if (query.trim().length < 2) return const [];
    final rows = await _client
        .rpc('search_profiles', params: {'query': query.trim()}) as List;
    return [
      for (final row in rows)
        PublicProfile.fromJson(row as Map<String, dynamic>),
    ];
  }

  /// All accepted friends with their aggregate progress, sorted by nickname.
  Future<List<FriendProfile>> fetchFriends() async {
    final links = await _client
        .from('friendships')
        .select('user_a, user_b')
        .or('user_a.eq.$_uid,user_b.eq.$_uid');
    final friendIds = [
      for (final link in links)
        link['user_a'] == _uid
            ? link['user_b'] as String
            : link['user_a'] as String,
    ];
    if (friendIds.isEmpty) return const [];

    final rows = await _client
        .from('profiles')
        .select(
            'id, nickname, avatar_id, language_pair, current_level, memorized_count')
        .inFilter('id', friendIds)
        .order('nickname', ascending: true);
    return [for (final row in rows) FriendProfile.fromJson(row)];
  }

  /// Pending requests addressed to the current user, newest first.
  Future<List<IncomingRequest>> fetchIncomingRequests() async {
    final rows = await _client.rpc('incoming_friend_requests') as List;
    return [
      for (final row in rows)
        IncomingRequest.fromJson(row as Map<String, dynamic>),
    ];
  }

  /// Ids of users the current user has already sent a pending request to.
  Future<Set<String>> fetchOutgoingPendingIds() async {
    final rows = await _client
        .from('friend_requests')
        .select('to_user')
        .eq('from_user', _uid)
        .eq('status', 'pending');
    return {for (final row in rows) row['to_user'] as String};
  }

  /// Sends a friend request. If the other user already has a pending request
  /// TO us, accepts that one instead — tapping "add" on someone who already
  /// asked should just make you friends, not create a crossed second request.
  Future<void> sendRequest(String toUserId) async {
    final existing = await _client
        .from('friend_requests')
        .select('id')
        .eq('from_user', toUserId)
        .eq('to_user', _uid)
        .eq('status', 'pending')
        .maybeSingle();
    if (existing != null) {
      await respondToRequest(existing['id'] as String, accept: true);
      return;
    }
    await _client.from('friend_requests').insert({
      'from_user': _uid,
      'to_user': toUserId,
    });
  }

  /// Accepts or declines a pending request addressed to the current user.
  /// Accepting also creates the friendship (server-side trigger).
  Future<void> respondToRequest(String requestId, {required bool accept}) {
    return _client
        .from('friend_requests')
        .update({'status': accept ? 'accepted' : 'declined'})
        .eq('id', requestId)
        .eq('to_user', _uid);
  }
}

/// Null when Supabase is unconfigured or nobody is signed in — the Friends
/// UI shows a sign-in prompt in that case.
final friendsRepositoryProvider = Provider<FriendsRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null || ref.watch(currentUserProvider) == null) return null;
  return FriendsRepository(client);
});
