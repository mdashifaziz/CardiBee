import 'package:dio/dio.dart';
import 'package:cardibee_flutter/core/network/error_mapper.dart';
import 'package:cardibee_flutter/features/cards/domain/cards_repository.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

final class ApiCardsRepository implements CardsRepository {
  ApiCardsRepository(this._dio);
  final Dio _dio;

  @override
  Future<List<UserCard>> listCards() async {
    try {
      final res = await _dio.get<dynamic>('/cards');
      return _unwrapList(res.data)
          .map((e) => UserCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<UserCard> addCard({
    required String bankId,
    required String cardTypeId,
    required String type,
    String? nickname,
    String? lastDigits,
    required String gradient,
  }) async {
    try {
      final res = await _dio.post<dynamic>('/cards', data: {
        'bank_id': bankId,
        'card_type_id': cardTypeId,
        'type': type,
        'gradient': gradient,
        if (nickname != null) 'nickname': nickname,
        if (lastDigits != null) 'last_digits': lastDigits,
      });
      return UserCard.fromJson(_unwrapSingle(res.data));
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<UserCard> updateCard(
    String cardId, {
    String? nickname,
    String? gradient,
    bool? isDefault,
  }) async {
    try {
      final res = await _dio.patch<dynamic>('/cards/$cardId', data: {
        if (nickname != null) 'nickname': nickname,
        if (gradient != null) 'gradient': gradient,
        if (isDefault != null) 'is_default': isDefault,
      });
      return UserCard.fromJson(_unwrapSingle(res.data));
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> deleteCard(String cardId) async {
    try {
      await _dio.delete<void>('/cards/$cardId');
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> setDefaultCard(String cardId) async {
    try {
      await _dio.post<void>('/cards/$cardId/default');
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  List<dynamic> _unwrapList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      return (raw['data'] ?? raw['items'] ?? raw['results'] ?? const <dynamic>[])
          as List<dynamic>;
    }
    return const [];
  }

  Map<String, dynamic> _unwrapSingle(dynamic raw) {
    if (raw is Map<String, dynamic> &&
        raw.containsKey('data') &&
        raw['data'] is Map) {
      return raw['data'] as Map<String, dynamic>;
    }
    return raw as Map<String, dynamic>;
  }
}
