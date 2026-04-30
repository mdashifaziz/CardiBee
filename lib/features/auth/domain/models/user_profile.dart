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

  factory SubscriptionStatus.fromJson(Map<String, dynamic> j) => SubscriptionStatus(
    plan:              j['plan'] as String? ?? 'free',
    status:            j['status'] as String? ?? 'active',
    currentPeriodEnd:  j['current_period_end'] as String?,
    cardLimit:         j['card_limit'] as int? ?? 3,
    cardsUsed:         j['cards_used'] as int? ?? 0,
  );
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.language = 'en',
    this.avatarUrl,
    this.savingsYtdBdt = 0,
    required this.createdAt,
    required this.subscription,
  });

  final String id;
  final String fullName;
  final String phone;      // masked E.164 e.g. '+880 17XX XXXX 71'
  final String? email;
  final String language;
  final String? avatarUrl;
  final int savingsYtdBdt;
  final String createdAt;
  final SubscriptionStatus subscription;

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    id:             j['id'] as String,
    fullName:       j['full_name'] as String,
    phone:          j['phone'] as String,
    email:          j['email'] as String?,
    language:       j['language'] as String? ?? 'en',
    avatarUrl:      j['avatar_url'] as String?,
    savingsYtdBdt:  j['savings_ytd_bdt'] as int? ?? 0,
    createdAt:      j['created_at'] as String,
    subscription:   SubscriptionStatus.fromJson(j['subscription'] as Map<String, dynamic>),
  );

  UserProfile copyWith({String? fullName, String? email, String? language}) => UserProfile(
    id: id,
    fullName: fullName ?? this.fullName,
    phone: phone,
    email: email ?? this.email,
    language: language ?? this.language,
    avatarUrl: avatarUrl,
    savingsYtdBdt: savingsYtdBdt,
    createdAt: createdAt,
    subscription: subscription,
  );
}
