import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class _CardResult {
  const _CardResult({required this.card, required this.matchingOffers});
  final UserCard card;
  final List<Offer> matchingOffers;
  int get score => matchingOffers.length;
  String? get topDiscount => matchingOffers.isNotEmpty ? matchingOffers.first.discountLabel : null;
}

class BestCardScreen extends ConsumerStatefulWidget {
  const BestCardScreen({super.key});

  @override
  ConsumerState<BestCardScreen> createState() => _BestCardScreenState();
}

class _BestCardScreenState extends ConsumerState<BestCardScreen> {
  static const _categories = [
    'Food', 'Travel', 'Shopping', 'Groceries', 'Entertainment', 'Health',
  ];

  String? _selectedCategory;
  List<_CardResult>? _results;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _search();
    });
  }

  bool _offerMatchesCard(Offer offer, UserCard card) {
    if (offer.eligibleCards.isEmpty) return true;
    return offer.eligibleCards.any(
      (ec) => ec.bankId == card.bankId &&
              ec.network == card.network &&
              ec.cardType == card.type,
    );
  }

  Future<void> _search() async {
    final cards = ref.read(cardsNotifierProvider).valueOrNull ?? [];
    if (cards.isEmpty) {
      setState(() { _results = []; _loading = false; });
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await ref.read(offersRepositoryProvider).listOffers(
        myCardsOnly: false,
        category: _selectedCategory,
        limit: 50,
      );
      final allOffers = result.items;
      final ranked = cards.map((card) {
        final matching = allOffers.where((o) => _offerMatchesCard(o, card)).toList()
          ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
        return _CardResult(card: card, matchingOffers: matching);
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      if (mounted) setState(() { _results = ranked; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
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
        title: const Text('Best Card'),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s16, tokens.s20, tokens.s8),
            child: Text('Filter by category', style: theme.textTheme.titleSmall),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: tokens.s20),
            child: Row(
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  onTap: () { setState(() => _selectedCategory = null); _search(); },
                ),
                ..._categories.map((cat) => _CategoryChip(
                  label: cat,
                  selected: _selectedCategory == cat,
                  onTap: () { setState(() => _selectedCategory = cat); _search(); },
                )),
              ],
            ),
          ),
          SizedBox(height: tokens.s16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (_results == null || _results!.isEmpty)
                    ? _EmptyState()
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                            tokens.s20, 0, tokens.s20, tokens.s24),
                        itemCount: _results!.length,
                        separatorBuilder: (_, __) => SizedBox(height: tokens.s12),
                        itemBuilder: (context, i) => _CardResultTile(
                          result: _results![i],
                          rank: i + 1,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Category chip ──────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final tokens = Theme.of(context).tokens;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: tokens.durationFast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surfaceContainerLowest,
            borderRadius: tokens.brFull,
            border: Border.all(
              color: selected ? cs.primary : cs.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Result tile ────────────────────────────────────────────────────────────────

class _CardResultTile extends StatelessWidget {
  const _CardResultTile({required this.result, required this.rank});
  final _CardResult result;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final isBest = rank == 1 && result.score > 0;

    return Container(
      padding: EdgeInsets.all(tokens.s16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: tokens.brLg,
        border: Border.all(
          color: isBest ? AppColors.beeYellow.withOpacity(0.6) : cs.outlineVariant,
          width: isBest ? 1.5 : 1,
        ),
        boxShadow: isBest ? tokens.shadowMd : tokens.shadowSm,
      ),
      child: Row(
        children: [
          CreditCardVisual(card: result.card, size: CardSize.sm),
          SizedBox(width: tokens.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBest)
                  Padding(
                    padding: EdgeInsets.only(bottom: tokens.s6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.beeYellow,
                        borderRadius: tokens.brFull,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 10, color: AppColors.navyDeep),
                          SizedBox(width: 3),
                          Text(
                            'BEST MATCH',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyDeep,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Text(
                  result.card.displayName,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: tokens.s4),
                Text(
                  result.card.bankName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: tokens.s8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        borderRadius: tokens.brFull,
                      ),
                      child: Text(
                        '${result.score} offer${result.score == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    if (result.topDiscount != null) ...[
                      SizedBox(width: tokens.s8),
                      Text(
                        'Top: ${result.topDiscount}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.credit_card_off_rounded, size: 48, color: cs.onSurfaceVariant),
            SizedBox(height: tokens.s16),
            Text(
              'No cards in your wallet yet',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tokens.s8),
            Text(
              'Add a card to see which one gives you the most offers.',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
