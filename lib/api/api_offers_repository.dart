import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/network/error_mapper.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/domain/offers_repository.dart';

final class ApiOffersRepository implements OffersRepository {
  ApiOffersRepository(this._dio);
  final Dio _dio;

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
    try {
      final res = await _dio.post<dynamic>('/offers/search', data: {
        'my_cards_only': myCardsOnly,
        'limit': limit,
        if (category != null) 'category': category,
        if (bankId != null) 'bank_id': bankId,
        if (cardId != null) 'card_id': cardId,
        if (expiringSoon != null) 'expiring_soon': expiringSoon,
        if (featured != null) 'featured': featured,
        if (sort != null) 'sort': sort,
        if (cursor != null) 'cursor': cursor,
      });
      return _parsePage(res.data);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<Offer> getOffer(String offerId) async {
    try {
      final res = await _dio.get<dynamic>('/offers/$offerId');
      return Offer.fromJson(_patchOffer(_unwrapSingle(res.data)));
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<void> saveOffer(String offerId) async {
    try {
      await _dio.post<void>('/offers/$offerId/save');
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<void> unsaveOffer(String offerId) async {
    try {
      await _dio.delete<void>('/offers/$offerId/save');
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<({List<Offer> items, String? nextCursor, int totalCount})> listSavedOffers({
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final res = await _dio.get<dynamic>('/offers/saved', queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      });
      return _parsePage(res.data);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<List<String>> listCategories() async => const [
    'Food', 'Travel', 'Shopping', 'Groceries', 'Entertainment', 'Health',
  ];

  // ── helpers ──────────────────────────────────────────────────────────────────

  ({List<Offer> items, String? nextCursor, int totalCount}) _parsePage(dynamic raw) {
    List<dynamic> list;
    String? nextCursor;
    int totalCount;
    if (raw is List) {
      list = raw;
      nextCursor = null;
      totalCount = list.length;
    } else {
      final m = raw as Map<String, dynamic>;
      list = (m['data'] ?? m['items'] ?? m['results'] ?? const <dynamic>[]) as List<dynamic>;
      nextCursor = m['next_cursor'] as String?;
      totalCount = (m['total_count'] ?? m['total'] ?? list.length) as int;
    }
    final items = list
        .map((e) => Offer.fromJson(_patchOffer(e as Map<String, dynamic>)))
        .toList();
    return (items: items, nextCursor: nextCursor, totalCount: totalCount);
  }

  Map<String, dynamic> _unwrapSingle(dynamic raw) {
    if (raw is Map<String, dynamic> &&
        raw.containsKey('data') &&
        raw['data'] is Map) {
      return raw['data'] as Map<String, dynamic>;
    }
    return raw as Map<String, dynamic>;
  }

  // Fills in fields the API may omit so Offer.fromJson never crashes.
  Map<String, dynamic> _patchOffer(Map<String, dynamic> j) {
    final m = Map<String, dynamic>.from(j);
    if (m['days_left'] == null) {
      final until = DateTime.tryParse(m['valid_until'] as String? ?? '');
      m['days_left'] = until != null
          ? until.difference(DateTime.now()).inDays.clamp(0, 9999)
          : 0;
    }
    if (m['merchant_initial'] == null) {
      final name = (m['merchant_name'] as String? ?? '');
      final parts = name.trim().split(' ');
      m['merchant_initial'] = parts.length >= 2
          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
          : name.isNotEmpty
              ? name[0].toUpperCase()
              : '?';
    }
    m['description'] ??= m['title'] ?? '';
    m['banner_gradient_start'] ??= '#131B4D';
    m['banner_gradient_end'] ??= '#2563EB';
    return m;
  }
}
