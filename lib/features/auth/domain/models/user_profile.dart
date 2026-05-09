import 'package:json_annotation/json_annotation.dart';

class SubscriptionStatus {
  const SubscriptionStatus({
    this.plan = 'free',
    this.status = 'active',
    this.currentPeriodEnd,
    this.cardLimit = 3,
    this.cardsUsed = 0,
  });

  final String plan;
  final String status;
  final String? currentPeriodEnd;
  final int cardLimit;
  final int cardsUsed;

  bool get isPro => plan != 'free';
  bool get isAtLimit => cardsUsed >= cardLimit;

  /// Build from the backend's flat `is_pro` boolean.
  factory SubscriptionStatus.fromIsPro(bool isPro) => SubscriptionStatus(
        plan:      isPro ? 'pro' : 'free',
        status:    'active',
        cardLimit: isPro ? 999 : 3,
      );

  /// Legacy: build from a full subscription object (mock fixtures, etc.).
  factory SubscriptionStatus.fromJson(Map<String, dynamic> j) =>
      SubscriptionStatus(
        plan:             j['plan']               as String? ?? 'free',
        status:           j['status']             as String? ?? 'active',
        currentPeriodEnd: j['current_period_end'] as String?,
        cardLimit:        j['card_limit']         as int?    ?? 3,
        cardsUsed:        j['cards_used']         as int?    ?? 0,
      );
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.username,
    this.age,
    this.language,
    this.avatarUrl,
    this.savingsYtdBdt,
    this.createdAt,
    required this.subscription,
  });

  /// Backend field: `id` (int)
  @JsonKey(name: 'id')
  final int id;

  /// Backend field: `full_name`
  @JsonKey(name: 'full_name')
  final String fullName;

  /// Backend field: `mobile_no`
  @JsonKey(name: 'mobile_no')
  final String? phone;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'username')
  final String? username;

  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'language')
  final String? language;

  /// Backend field: `avatarUrl`
  @JsonKey(name: 'avatarUrl')
  final String? avatarUrl;

  @JsonKey(name: 'savings_ytd_bdt')
  final int? savingsYtdBdt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// Derived from backend's `is_pro` boolean — not a nested object.
  final SubscriptionStatus subscription;

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        id:            j['id']               as int,
        fullName:      j['full_name']        as String,
        phone:         j['mobile_no']        as String?,
        email:         j['email']            as String?,
        username:      j['username']         as String?,
        age:           j['age']              as int?,
        language:      j['language']         as String?,
        avatarUrl:     j['avatarUrl']        as String?,
        savingsYtdBdt: j['savings_ytd_bdt'] as int?,
        createdAt:     j['created_at']       as String?,
        subscription:  SubscriptionStatus.fromIsPro(j['is_pro'] as bool? ?? false),
      );

  UserProfile copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? username,
    int? age,
    String? language,
  }) =>
      UserProfile(
        id:            id,
        fullName:      fullName      ?? this.fullName,
        phone:         phone         ?? this.phone,
        email:         email         ?? this.email,
        username:      username      ?? this.username,
        age:           age           ?? this.age,
        language:      language      ?? this.language,
        avatarUrl:     avatarUrl,
        savingsYtdBdt: savingsYtdBdt,
        createdAt:     createdAt,
        subscription:  subscription,
      );
}
