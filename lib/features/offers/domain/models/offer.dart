class EligibleCard {
  const EligibleCard({
    required this.cardTypeId,
    required this.productName,
    required this.bankId,
    required this.bankName,
    required this.network,
  });

  final String cardTypeId;
  final String productName;
  final String bankId;
  final String bankName;
  final String network;   // 'Visa' | 'Mastercard' | 'Amex'

  factory EligibleCard.fromJson(Map<String, dynamic> j) => EligibleCard(
    cardTypeId:  j['card_type_id'] as String,
    productName: j['product_name'] as String,
    bankId:      j['bank_id']      as String,
    bankName:    j['bank_name']    as String,
    network:     j['network']      as String,
  );
}

class Offer {
  const Offer({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.merchantInitial,
    this.merchantLogoUrl,
    required this.category,
    required this.title,
    this.titleBn,
    required this.discountLabel,
    required this.description,
    this.descriptionBn,
    this.terms = const [],
    this.termsBn = const [],
    required this.validFrom,
    required this.validUntil,
    required this.daysLeft,
    this.minSpendBdt,
    this.maxDiscountBdt,
    this.applicableDays,
    this.eligibleCards = const [],
    this.featured = false,
    required this.bannerStart,
    required this.bannerEnd,
    this.isSaved = false,
    this.userQualifyingCardIds = const [],
  });

  final String id;
  final String merchantId;
  final String merchantName;
  final String merchantInitial;
  final String? merchantLogoUrl;
  final String category;
  final String title;
  final String? titleBn;
  final String discountLabel;
  final String description;
  final String? descriptionBn;
  final List<String> terms;
  final List<String> termsBn;
  final String validFrom;
  final String validUntil;
  final int daysLeft;
  final int? minSpendBdt;
  final int? maxDiscountBdt;
  final String? applicableDays;
  final List<EligibleCard> eligibleCards;
  final bool featured;
  final String bannerStart;  // hex e.g. '#F97316'
  final String bannerEnd;
  final bool isSaved;
  final List<String> userQualifyingCardIds;

  factory Offer.fromJson(Map<String, dynamic> j) => Offer(
    id:              j['id'] as String,
    merchantId:      j['merchant_id'] as String,
    merchantName:    j['merchant_name'] as String,
    merchantInitial: j['merchant_initial'] as String,
    merchantLogoUrl: j['merchant_logo_url'] as String?,
    category:        j['category'] as String,
    title:           j['title'] as String,
    titleBn:         j['title_bn'] as String?,
    discountLabel:   j['discount_label'] as String,
    description:     j['description'] as String,
    descriptionBn:   j['description_bn'] as String?,
    terms:          (j['terms'] as List<dynamic>?)?.cast<String>() ?? [],
    termsBn:        (j['terms_bn'] as List<dynamic>?)?.cast<String>() ?? [],
    validFrom:       j['valid_from'] as String,
    validUntil:      j['valid_until'] as String,
    daysLeft:        j['days_left'] as int,
    minSpendBdt:     j['min_spend_bdt'] as int?,
    maxDiscountBdt:  j['max_discount_bdt'] as int?,
    applicableDays:  j['applicable_days'] as String?,
    eligibleCards:  (j['eligible_cards'] as List<dynamic>?)
        ?.map((e) => EligibleCard.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    featured:        j['featured'] as bool? ?? false,
    bannerStart:     j['banner_gradient_start'] as String,
    bannerEnd:       j['banner_gradient_end'] as String,
    isSaved:         j['is_saved'] as bool? ?? false,
    userQualifyingCardIds: (j['user_qualifying_card_ids'] as List<dynamic>?)
        ?.cast<String>() ?? [],
  );

  Offer copyWith({bool? isSaved}) => Offer(
    id: id, merchantId: merchantId, merchantName: merchantName,
    merchantInitial: merchantInitial, merchantLogoUrl: merchantLogoUrl,
    category: category, title: title, titleBn: titleBn,
    discountLabel: discountLabel, description: description,
    descriptionBn: descriptionBn, terms: terms, termsBn: termsBn,
    validFrom: validFrom, validUntil: validUntil, daysLeft: daysLeft,
    minSpendBdt: minSpendBdt, maxDiscountBdt: maxDiscountBdt,
    applicableDays: applicableDays, eligibleCards: eligibleCards,
    featured: featured, bannerStart: bannerStart, bannerEnd: bannerEnd,
    isSaved: isSaved ?? this.isSaved,
    userQualifyingCardIds: userQualifyingCardIds,
  );
}
