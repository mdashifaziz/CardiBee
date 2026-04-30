import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/domain/offers_repository.dart';

final class MockOffersRepository implements OffersRepository {
  List<Offer>? _cache;
  final Set<String> _saved = {'off_02AA3B4C5D6E7F8G9H0I1J2K', 'off_09WD3K2M3N4P5Q6R7WESTIN9'};

  Future<List<Offer>> _load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('lib/mock/fixtures/offers.json');
    final list = json.decode(raw) as List<dynamic>;
    _cache = list
        .map((e) => Offer.fromJson(e as Map<String, dynamic>))
        .map((o) => o.copyWith(isSaved: _saved.contains(o.id)))
        .toList();
    return _cache!;
  }

  @override
  Future<({List<Offer> items, String? nextCursor, int totalCount})> listOffers({
    bool myCardsOnly = true,
    String? category,
    String? bankId,
    String? cardId,
    bool? expiringSoon,
    bool? featured,
    String? sort,
    int limit = 20,
    String? cursor,
  }) async {
    var list = await _load();

    if (category != null) list = list.where((o) => o.category == category).toList();
    if (featured == true) list = list.where((o) => o.featured).toList();
    if (expiringSoon == true) list = list.where((o) => o.daysLeft <= 7).toList();

    final sorted = switch (sort) {
      'newest'           => list.reversed.toList(),
      'highest_discount' => list, // mock: no numeric sort needed
      _                  => (List<Offer>.from(list)..sort((a, b) => a.daysLeft.compareTo(b.daysLeft))),
    };

    return (items: sorted, nextCursor: null, totalCount: sorted.length);
  }

  @override
  Future<Offer> getOffer(String offerId) async {
    final list = await _load();
    return list.firstWhere((o) => o.id == offerId);
  }

  @override
  Future<void> saveOffer(String offerId) async {
    _saved.add(offerId);
    _cache = _cache?.map((o) => o.id == offerId ? o.copyWith(isSaved: true) : o).toList();
  }

  @override
  Future<void> unsaveOffer(String offerId) async {
    _saved.remove(offerId);
    _cache = _cache?.map((o) => o.id == offerId ? o.copyWith(isSaved: false) : o).toList();
  }

  @override
  Future<({List<Offer> items, String? nextCursor, int totalCount})> listSavedOffers({
    int limit = 20,
    String? cursor,
  }) async {
    final list = await _load();
    final saved = list.where((o) => _saved.contains(o.id)).toList();
    return (items: saved, nextCursor: null, totalCount: saved.length);
  }

  @override
  Future<List<String>> listCategories() async => [
    'Food', 'Travel', 'Shopping', 'Groceries', 'Entertainment', 'Health',
  ];
}
