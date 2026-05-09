import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/network/api_endpoints.dart';
import 'package:cardibee_flutter/core/network/dio_client.dart';
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

// ── Bank / card-type models for AddCard wizard ────────────────────────────────

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

// ── Paginated banks notifier ──────────────────────────────────────────────────

class BanksNotifier extends AsyncNotifier<List<BankInfo>> {
  static const _pageLimit = 20;
  String? _cursor;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  Future<List<BankInfo>> build() async {
    _cursor = null;
    _hasMore = true;
    return _fetchPage();
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    final current = state.valueOrNull ?? [];
    state = await AsyncValue.guard(() async {
      final more = await _fetchPage();
      return [...current, ...more];
    });
  }

  Future<List<BankInfo>> _fetchPage() async {
    final dio = ref.read(dioProvider);
    final res = await dio.get<dynamic>(ApiEndpoints.banks, queryParameters: {
      'limit': _pageLimit,
      if (_cursor != null) 'cursor': _cursor,
    });
    final raw = res.data;
    List<dynamic> items;
    if (raw is List) {
      items = raw;
      _cursor = null;
      _hasMore = false;
    } else {
      final m = raw as Map<String, dynamic>;
      items = (m['data'] ?? m['items'] ?? const <dynamic>[]) as List<dynamic>;
      _cursor = m['next_cursor'] as String?;
      _hasMore = _cursor != null;
    }
    return items
        .map((e) => BankInfo(
              id:        e['id'] as String,
              name:      e['name'] as String,
              shortCode: e['short_code'] as String,
            ))
        .toList();
  }
}

final banksProvider =
    AsyncNotifierProvider<BanksNotifier, List<BankInfo>>(BanksNotifier.new);

// ── Card types per bank ───────────────────────────────────────────────────────

final cardTypesProvider =
    FutureProvider.family<List<CardTypeInfo>, String>((ref, bankId) async {
  final dio = ref.read(dioProvider);
  final res = await dio.get<dynamic>(ApiEndpoints.bankCardTypes(bankId));
  final raw = res.data;
  final list = raw is List
      ? raw
      : ((raw as Map<String, dynamic>)['data'] ??
              raw['items'] ??
              const <dynamic>[])
          as List<dynamic>;
  return list
      .map((e) => CardTypeInfo(
            id:          e['id'] as String,
            bankId:      bankId,
            productName: e['product_name'] as String,
            network:     e['network'] as String,
            defaultType: (e['type'] ?? e['default_type'] ?? 'credit') as String,
          ))
      .toList();
});
