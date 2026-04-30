import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/cards/domain/cards_repository.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

final cardsRepositoryProvider = Provider<CardsRepository>((ref) {
  throw UnimplementedError('cardsRepositoryProvider must be overridden');
});

// Async state for the card list — used across home, cards, offer_detail
final userCardsProvider = FutureProvider<List<UserCard>>((ref) {
  return ref.watch(cardsRepositoryProvider).listCards();
});
