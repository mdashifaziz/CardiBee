import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/offers/domain/offers_repository.dart';

// Overridden by MockModule (mock) or ApiModule (live) in main.dart
final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  throw UnimplementedError('offersRepositoryProvider must be overridden');
});
