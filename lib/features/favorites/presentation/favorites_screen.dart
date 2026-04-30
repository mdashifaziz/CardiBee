import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<Offer> _saved = [];
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
      setState(() => _saved = result.items);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favorites'),
            Text(
              '${_saved.length} saved offers',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _saved.isEmpty
              ? _EmptyFavorites()
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                      tokens.s20, tokens.s16, tokens.s20, tokens.s24),
                  itemCount: _saved.length,
                  separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                  itemBuilder: (_, i) => OfferCardWidget(
                    offer: _saved[i],
                    onFavoriteToggle: () => _unsave(_saved[i].id),
                  ),
                ),
    );
  }

  Future<void> _unsave(String id) async {
    await ref.read(offersRepositoryProvider).unsaveOffer(id);
    setState(() => _saved.removeWhere((o) => o.id == id));
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
