import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  final List<UserCard> _selected = [];
  List<Offer> _allOffers = [];
  bool _offersLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        final result = await ref.read(offersRepositoryProvider).listOffers(
          myCardsOnly: false,
          limit: 50,
        );
        if (mounted) {
          setState(() { _allOffers = result.items; _offersLoaded = true; });
        }
      } catch (_) {
        if (mounted) setState(() => _offersLoaded = true);
      }
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

  List<Offer> _offersFor(UserCard card) =>
      (_allOffers.where((o) => _offerMatchesCard(o, card)).toList()
        ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft)));

  void _toggle(UserCard card) {
    setState(() {
      if (_selected.any((c) => c.id == card.id)) {
        _selected.removeWhere((c) => c.id == card.id);
      } else if (_selected.length < 2) {
        _selected.add(card);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final cards  = ref.watch(cardsNotifierProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Compare Cards'),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s16, tokens.s20, tokens.s8),
            child: Text('Select 2 cards to compare', style: theme.textTheme.titleSmall),
          ),
          if (cards.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.s20),
              child: Text(
                'Add cards to your wallet first.',
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            )
          else
            SizedBox(
              height: 248, // 2 × 120 (CardSize.sm) + 8 gap
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    (cards.length / 2).ceil(),
                    (colIdx) {
                      final top    = cards[colIdx * 2];
                      final bottom = colIdx * 2 + 1 < cards.length
                          ? cards[colIdx * 2 + 1]
                          : null;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _CardSelectItem(
                              card: top,
                              isSelected: _selected.any((c) => c.id == top.id),
                              isDisabled: !_selected.any((c) => c.id == top.id) &&
                                  _selected.length >= 2,
                              onTap: () => _toggle(top),
                              tokens: tokens,
                            ),
                            if (bottom != null) ...[
                              const SizedBox(height: 8),
                              _CardSelectItem(
                                card: bottom,
                                isSelected:
                                    _selected.any((c) => c.id == bottom.id),
                                isDisabled:
                                    !_selected.any((c) => c.id == bottom.id) &&
                                        _selected.length >= 2,
                                onTap: () => _toggle(bottom),
                                tokens: tokens,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          SizedBox(height: tokens.s16),
          Divider(height: 1, color: cs.outlineVariant),
          Expanded(
            child: switch (_selected.length) {
              0 => const _CompareEmptyState(),
              1 => _OneCardState(card: _selected.first),
              _ => !_offersLoaded
                  ? const Center(child: CircularProgressIndicator())
                  : _CompareResult(
                      cardA: _selected[0],
                      cardB: _selected[1],
                      offersA: _offersFor(_selected[0]),
                      offersB: _offersFor(_selected[1]),
                    ),
            },
          ),
        ],
      ),
    );
  }
}

// ── Card selector item ────────────────────────────────────────────────────────

class _CardSelectItem extends StatelessWidget {
  const _CardSelectItem({
    required this.card,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
    required this.tokens,
  });

  final UserCard card;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;
  final CardiBeeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.4 : 1.0,
        duration: tokens.durationFast,
        child: Stack(
          children: [
            CreditCardVisual(card: card, size: CardSize.sm),
            if (isSelected)
              Positioned.fill(
                child: AnimatedContainer(
                  duration: tokens.durationFast,
                  decoration: BoxDecoration(
                    borderRadius: tokens.brLg,
                    border: Border.all(
                      color: AppColors.beeYellow,
                      width: 3,
                    ),
                  ),
                ),
              ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.beeYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: AppColors.navyDeep,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Empty / single-card states ─────────────────────────────────────────────────

class _CompareEmptyState extends StatelessWidget {
  const _CompareEmptyState();

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
            Icon(Icons.compare_arrows_rounded, size: 48, color: cs.onSurfaceVariant),
            SizedBox(height: tokens.s16),
            Text(
              'Pick two cards above',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tokens.s8),
            Text(
              'See which card unlocks more offers for you.',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OneCardState extends StatelessWidget {
  const _OneCardState({required this.card});
  final UserCard card;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.tokens;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CreditCardVisual(card: card, size: CardSize.sm),
            SizedBox(height: tokens.s16),
            Text(
              'Now pick one more card',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Side-by-side result ────────────────────────────────────────────────────────

class _CompareResult extends StatelessWidget {
  const _CompareResult({
    required this.cardA,
    required this.cardB,
    required this.offersA,
    required this.offersB,
  });
  final UserCard cardA;
  final UserCard cardB;
  final List<Offer> offersA;
  final List<Offer> offersB;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    final aMore  = offersA.length > offersB.length;
    final bMore  = offersB.length > offersA.length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(tokens.s16),
      child: Column(
        children: [
          // Score banner
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: tokens.s16, vertical: tokens.s20),
            decoration: BoxDecoration(
              gradient: tokens.gradientHero,
              borderRadius: tokens.brLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ScoreColumn(
                    card: cardA,
                    count: offersA.length,
                    winner: aMore,
                  ),
                ),
                Container(
                  width: 1,
                  height: 48,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _ScoreColumn(
                    card: cardB,
                    count: offersB.length,
                    winner: bMore,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.s20),

          // Two-column offer lists
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _OfferColumn(card: cardA, offers: offersA)),
                SizedBox(width: tokens.s12),
                Expanded(child: _OfferColumn(card: cardB, offers: offersB)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.card,
    required this.count,
    required this.winner,
  });
  final UserCard card;
  final int count;
  final bool winner;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    return Column(
      children: [
        if (winner)
          Container(
            margin: EdgeInsets.only(bottom: tokens.s4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.beeYellow,
              borderRadius: tokens.brFull,
            ),
            child: const Text(
              'MORE OFFERS',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.navyDeep,
                letterSpacing: 0.5,
              ),
            ),
          ),
        Text(
          '$count',
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          card.displayName,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OfferColumn extends StatelessWidget {
  const _OfferColumn({required this.card, required this.offers});
  final UserCard card;
  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.displayName,
          style: theme.textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          card.bankName,
          style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        SizedBox(height: tokens.s12),
        if (offers.isEmpty)
          Text(
            'No matching offers',
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          )
        else
          ...offers.map((offer) => Padding(
            padding: EdgeInsets.only(bottom: tokens.s8),
            child: _MiniOfferTile(offer: offer),
          )),
      ],
    );
  }
}

class _MiniOfferTile extends StatelessWidget {
  const _MiniOfferTile({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final c1 = Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}'));
    final c2 = Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}'));

    return GestureDetector(
      onTap: () => context.push(AppRoutes.offerDetailPath(offer.id)),
      child: Container(
        padding: EdgeInsets.all(tokens.s10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: tokens.brMd,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [c1, c2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: tokens.brSm,
              ),
              alignment: Alignment.center,
              child: Text(
                offer.merchantInitial,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: tokens.s8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.discountLabel,
                    style: theme.textTheme.labelMedium?.copyWith(color: cs.primary),
                  ),
                  Text(
                    offer.merchantName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
