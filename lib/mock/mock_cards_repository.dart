import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cardibee_flutter/features/cards/domain/cards_repository.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

final class MockCardsRepository implements CardsRepository {
  List<UserCard>? _cards;

  Future<void> _ensureLoaded() async {
    if (_cards != null) return;
    final raw = await rootBundle.loadString('lib/mock/fixtures/cards.json');
    final list = json.decode(raw) as List<dynamic>;
    _cards = list.map((e) => UserCard.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<UserCard>> listCards() async {
    await _ensureLoaded();
    return List.unmodifiable(_cards!);
  }

  @override
  Future<UserCard> addCard({
    required String bankId,
    required String cardTypeId,
    required String type,
    String? nickname,
    String? lastDigits,
    required String gradient,
  }) async {
    await _ensureLoaded();
    // Derive bank name from id for mock
    final bankName = _bankNameFromId(bankId);
    final newCard = UserCard(
      id: 'uc_mock_${DateTime.now().millisecondsSinceEpoch}',
      bankId: bankId,
      bankName: bankName,
      cardTypeId: cardTypeId,
      productName: cardTypeId.replaceAll('_', ' '),
      network: _networkFromCardTypeId(cardTypeId),
      type: type,
      nickname: nickname,
      lastDigits: lastDigits,
      gradient: gradient,
      isDefault: false,
      activeOfferCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    );
    _cards!.add(newCard);
    return newCard;
  }

  @override
  Future<UserCard> updateCard(
    String cardId, {
    String? nickname,
    String? gradient,
    bool? isDefault,
  }) async {
    await _ensureLoaded();
    final idx = _cards!.indexWhere((c) => c.id == cardId);
    if (idx == -1) throw Exception('Card not found');
    final updated = _cards![idx].copyWith(
      nickname: nickname,
      gradient: gradient,
      isDefault: isDefault,
    );
    _cards![idx] = updated;
    return updated;
  }

  @override
  Future<void> deleteCard(String cardId) async {
    await _ensureLoaded();
    _cards!.removeWhere((c) => c.id == cardId);
  }

  @override
  Future<void> setDefaultCard(String cardId) async {
    await _ensureLoaded();
    _cards = _cards!
        .map((c) => c.copyWith(isDefault: c.id == cardId))
        .toList();
  }

  static String _bankNameFromId(String id) => switch (id) {
    'bank_ebl'   => 'EBL',
    'bank_brac'  => 'BRAC Bank',
    'bank_city'  => 'City Bank',
    'bank_dbbl'  => 'Dutch-Bangla',
    'bank_scb'   => 'Standard Chartered',
    'bank_hsbc'  => 'HSBC',
    'bank_prime' => 'Prime Bank',
    _            => id,
  };

  static String _networkFromCardTypeId(String id) {
    if (id.contains('visa'))  return 'Visa';
    if (id.contains('amex'))  return 'Amex';
    return 'Mastercard';
  }
}
