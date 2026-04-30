import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_provider.dart';
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
  ];
}
