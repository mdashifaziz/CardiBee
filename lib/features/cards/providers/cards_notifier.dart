import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_provider.dart';

final cardsNotifierProvider =
    AsyncNotifierProvider<CardsNotifier, List<UserCard>>(CardsNotifier.new);

class CardsNotifier extends AsyncNotifier<List<UserCard>> {
  @override
  Future<List<UserCard>> build() =>
      ref.watch(cardsRepositoryProvider).listCards();

  Future<void> deleteCard(String cardId) async {
    await ref.read(cardsRepositoryProvider).deleteCard(cardId);
    state = AsyncData((state.valueOrNull ?? [])
        .where((c) => c.id != cardId)
        .toList());
  }

  Future<UserCard?> addCard({
    required String bankId,
    required String cardTypeId,
    required String type,
    String? nickname,
    String? lastDigits,
    required String gradient,
  }) async {
    try {
      final card = await ref.read(cardsRepositoryProvider).addCard(
        bankId: bankId,
        cardTypeId: cardTypeId,
        type: type,
        nickname: nickname,
        lastDigits: lastDigits,
        gradient: gradient,
      );
      state = AsyncData([...(state.valueOrNull ?? []), card]);
      return card;
    } catch (_) {
      return null;
    }
  }
}

// ── Static bank/card-type data for AddCard wizard ────────────────────────────

class BankInfo {
  const BankInfo({required this.id, required this.name, required this.shortCode});
  final String id;
  final String name;
  final String shortCode;
}

class CardTypeInfo {
  const CardTypeInfo({
    required this.id,
    required this.bankId,
    required this.productName,
    required this.network,
    required this.defaultType,
  });
  final String id;
  final String bankId;
  final String productName;
  final String network;
  final String defaultType;
}

final banksProvider = FutureProvider<List<BankInfo>>((ref) async {
  final raw  = await rootBundle.loadString('lib/mock/fixtures/banks.json');
  final list = json.decode(raw) as List<dynamic>;
  return list.map((e) => BankInfo(
    id:        e['id'] as String,
    name:      e['name'] as String,
    shortCode: e['short_code'] as String,
  )).toList();
});

final cardTypesProvider = FutureProvider.family<List<CardTypeInfo>, String>((ref, bankId) async {
  final raw = await rootBundle.loadString('lib/mock/fixtures/card_types.json');
  final map = json.decode(raw) as Map<String, dynamic>;
  final list = (map[bankId] as List<dynamic>?) ?? [];
  return list.map((e) => CardTypeInfo(
    id:          e['id'] as String,
    bankId:      bankId,
    productName: e['product_name'] as String,
    network:     e['network'] as String,
    defaultType: e['default_type'] as String,
  )).toList();
});
