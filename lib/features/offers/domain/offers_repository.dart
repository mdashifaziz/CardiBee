import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';

abstract interface class OffersRepository {
  Future<({List<Offer> items, String? nextCursor, int totalCount})> listOffers({
    bool myCardsOnly = true,
    String? category,
    String? bankId,
    String? cardId,
    bool? expiringSoon,
    bool? featured,
    String? sort,         // 'expiring_soon' | 'newest' | 'highest_discount'
    int limit = 20,
    String? cursor,
  });

  Future<Offer> getOffer(String offerId);

  Future<void> saveOffer(String offerId);

  Future<void> unsaveOffer(String offerId);

  Future<({List<Offer> items, String? nextCursor, int totalCount})> listSavedOffers({
    int limit = 20,
    String? cursor,
  });

  Future<List<String>> listCategories(); // returns category names
}
