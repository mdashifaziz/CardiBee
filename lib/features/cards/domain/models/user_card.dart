class UserCard {
  const UserCard({
    required this.id,
    required this.bankId,
    required this.bankName,
    required this.cardTypeId,
    required this.productName,
    required this.network,
    required this.type,
    this.nickname,
    this.lastDigits,        // 4–6 digits only — never full card number
    this.gradient = 'navy',
    this.isDefault = false,
    this.activeOfferCount = 0,
    required this.createdAt,
  });

  final String id;
  final String bankId;
  final String bankName;
  final String cardTypeId;
  final String productName;
  final String network;    // 'Visa' | 'Mastercard' | 'Amex'
  final String type;       // 'credit' | 'debit'
  final String? nickname;
  final String? lastDigits;
  final String gradient;   // 'navy' | 'emerald' | 'burgundy' | 'graphite'
  final bool isDefault;
  final int activeOfferCount;
  final String createdAt;

  String get displayName => nickname ?? productName;

  factory UserCard.fromJson(Map<String, dynamic> j) => UserCard(
    id:               j['id'] as String,
    bankId:           j['bank_id'] as String,
    bankName:         j['bank_name'] as String,
    cardTypeId:       j['card_type_id'] as String,
    productName:      j['product_name'] as String,
    network:          j['network'] as String,
    type:             j['type'] as String,
    nickname:         j['nickname'] as String?,
    lastDigits:       j['last_digits'] as String?,
    gradient:         j['gradient'] as String? ?? 'navy',
    isDefault:        j['is_default'] as bool? ?? false,
    activeOfferCount: j['active_offer_count'] as int? ?? 0,
    createdAt:        j['created_at'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'bank_id': bankId, 'bank_name': bankName,
    'card_type_id': cardTypeId, 'product_name': productName,
    'network': network, 'type': type,
    if (nickname != null) 'nickname': nickname,
    if (lastDigits != null) 'last_digits': lastDigits,
    'gradient': gradient, 'is_default': isDefault,
    'active_offer_count': activeOfferCount, 'created_at': createdAt,
  };

  UserCard copyWith({
    String? nickname,
    String? gradient,
    bool? isDefault,
    int? activeOfferCount,
  }) => UserCard(
    id: id, bankId: bankId, bankName: bankName,
    cardTypeId: cardTypeId, productName: productName,
    network: network, type: type,
    nickname: nickname ?? this.nickname,
    lastDigits: lastDigits,
    gradient: gradient ?? this.gradient,
    isDefault: isDefault ?? this.isDefault,
    activeOfferCount: activeOfferCount ?? this.activeOfferCount,
    createdAt: createdAt,
  );
}
