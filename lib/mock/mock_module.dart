import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_provider.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';
import 'package:cardibee_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:cardibee_flutter/mock/mock_auth_repository.dart';
import 'package:cardibee_flutter/mock/mock_cards_repository.dart';
import 'package:cardibee_flutter/mock/mock_offers_repository.dart';
import 'package:cardibee_flutter/mock/mock_notifications_repository.dart';

abstract final class MockModule {
  static List<Override> get overrides => [
    authRepositoryProvider.overrideWith((_) => MockAuthRepository()),
    cardsRepositoryProvider.overrideWith((_) => MockCardsRepository()),
    offersRepositoryProvider.overrideWith((_) => MockOffersRepository()),
    notificationsRepositoryProvider.overrideWith((_) => MockNotificationsRepository()),
    // Banks: load from fixture instead of hitting the API
    banksProvider.overrideWith(() => _MockBanksNotifier()),
    // Card types: load from fixture keyed by bankId
    cardTypesProvider.overrideWith((ref, bankId) async {
      final raw = await rootBundle.loadString('lib/mock/fixtures/card_types.json');
      final map = json.decode(raw) as Map<String, dynamic>;
      final list = (map[bankId] as List<dynamic>?) ?? [];
      return list
          .map((e) => CardTypeInfo(
                id:          e['id'] as String,
                bankId:      bankId,
                productName: e['product_name'] as String,
                network:     e['network'] as String,
                defaultType: (e['default_type'] ?? 'credit') as String,
              ))
          .toList();
    }),
  ];
}

class _MockBanksNotifier extends BanksNotifier {
  @override
  Future<List<BankInfo>> build() async {
    final raw  = await rootBundle.loadString('lib/mock/fixtures/banks.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => BankInfo(
              id:        e['id'] as String,
              name:      e['name'] as String,
              shortCode: e['short_code'] as String,
            ))
        .toList();
  }
}
