import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final result = await ref.read(offersRepositoryProvider).listSavedOffers();
    return result.items.map((o) => o.id).toSet();
  }

  Future<void> toggle(String offerId) async {
    final current = {...(state.valueOrNull ?? {})};
    final wasSaved = current.contains(offerId);

    // Optimistic update
    if (wasSaved) { current.remove(offerId); } else { current.add(offerId); }
    state = AsyncData(current);

    try {
      final repo = ref.read(offersRepositoryProvider);
      if (wasSaved) {
        await repo.unsaveOffer(offerId);
      } else {
        await repo.saveOffer(offerId);
      }
    } catch (_) {
      // Revert on error
      final reverted = {...(state.valueOrNull ?? {})};
      if (wasSaved) { reverted.add(offerId); } else { reverted.remove(offerId); }
      state = AsyncData(reverted);
    }
  }
}
