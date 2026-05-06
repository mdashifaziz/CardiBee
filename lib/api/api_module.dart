import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/network/dio_client.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_provider.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';
import 'package:cardibee_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:cardibee_flutter/api/api_auth_repository.dart';
import 'package:cardibee_flutter/api/api_cards_repository.dart';
import 'package:cardibee_flutter/api/api_offers_repository.dart';
import 'package:cardibee_flutter/api/api_notifications_repository.dart';

abstract final class ApiModule {
  static List<Override> get overrides => [
    authRepositoryProvider.overrideWith(
      (ref) => ApiAuthRepository(ref.watch(dioProvider)),
    ),
    cardsRepositoryProvider.overrideWith(
      (ref) => ApiCardsRepository(ref.watch(dioProvider)),
    ),
    offersRepositoryProvider.overrideWith(
      (ref) => ApiOffersRepository(ref.watch(dioProvider)),
    ),
    notificationsRepositoryProvider.overrideWith(
      (ref) => ApiNotificationsRepository(ref.watch(dioProvider)),
    ),
  ];
}
