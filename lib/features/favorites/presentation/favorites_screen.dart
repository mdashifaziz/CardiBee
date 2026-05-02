import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/favorites_notifier.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<Offer> _allOffers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(offersRepositoryProvider).listSavedOffers();
      setState(() => _allOffers = result.items);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final cs       = theme.colorScheme;
    final tokens   = theme.tokens;
    // Reactively filter: disappears when user untaps heart
    final savedIds = ref.watch(favoritesProvider).valueOrNull ?? {};
    final visible  = _allOffers.where((o) => savedIds.contains(o.id)).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favorites'),
            Text(
              '${visible.length} saved offers',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : visible.isEmpty
              ? _EmptyFavorites()
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                      tokens.s20, tokens.s16, tokens.s20, tokens.s24),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                  itemBuilder: (_, i) => OfferCardWidget(offer: visible[i]),
                ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.s32),
        child: Container(
          padding: EdgeInsets.all(tokens.s32),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: tokens.brXl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border_rounded,
                  size: 48, color: cs.onSurfaceVariant),
              SizedBox(height: tokens.s12),
              Text(
                'No favorites yet',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: tokens.s6),
              Text(
                'Tap the heart on any offer to save it here.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
