import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

abstract interface class CardsRepository {
  Future<List<UserCard>> listCards();

  Future<UserCard> addCard({
    required String bankId,
    required String cardTypeId,
    required String type,
    String? nickname,
    String? lastDigits,
    required String gradient,
  });

  Future<UserCard> updateCard(
    String cardId, {
    String? nickname,
    String? gradient,
    bool? isDefault,
  });

  Future<void> deleteCard(String cardId);

  Future<void> setDefaultCard(String cardId);
}
