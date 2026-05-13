import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/core/widgets/merchant_logo.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/favorites_notifier.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class OfferDetailScreen extends ConsumerWidget {
  const OfferDetailScreen({required this.offerId, super.key});
  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;

    return FutureBuilder<Offer>(
      future: ref.read(offersRepositoryProvider).getOffer(offerId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError || !snap.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(snap.error?.toString() ?? 'Offer not found')),
          );
        }
        final offer = snap.data!;
        return _OfferDetailBody(offer: offer);
      },
    );
  }
}

class _OfferDetailBody extends ConsumerStatefulWidget {
  const _OfferDetailBody({required this.offer});
  final Offer offer;

  @override
  ConsumerState<_OfferDetailBody> createState() => _OfferDetailBodyState();
}

class _OfferDetailBodyState extends ConsumerState<_OfferDetailBody> {
  late Offer _offer;
  late final PageController _eligibleController;

  @override
  void initState() {
    super.initState();
    _offer = widget.offer;
    _eligibleController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _eligibleController.dispose();
    super.dispose();
  }

  void _toggleSave() {
    ref.read(favoritesProvider.notifier).toggle(_offer.id);
  }

  // Build a UserCard suitable for visual rendering. If the user owns this
  // card type, return their actual UserCard (with image / lastDigits). Else
  // synthesize a placeholder so CreditCardVisual can render bank/product.
  UserCard _cardForEligible(EligibleCard ec, List<UserCard> owned) {
    final match = owned.where((uc) => uc.cardTypeId == ec.cardTypeId);
    if (match.isNotEmpty) return match.first;
    return UserCard(
      id: 'eligible_${ec.cardTypeId}',
      bankId: ec.bankId,
      bankName: ec.bankName,
      cardTypeId: ec.cardTypeId,
      productName: ec.productName,
      network: ec.network,
      type: 'credit',
      gradient: 'navy',
      createdAt: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final cs       = theme.colorScheme;
    final tokens   = theme.tokens;
    final cards    = ref.watch(cardsNotifierProvider).valueOrNull ?? [];
    final savedIds = ref.watch(favoritesProvider).valueOrNull ?? {};
    final isSaved  = savedIds.contains(_offer.id);

    // Find which of the user's cards qualify for this offer
    final qualifying = cards.where((uc) => _offer.eligibleCards.any(
      (ec) => ec.cardTypeId == uc.cardTypeId,
    )).toList();

    Color bannerStart() {
      try {
        return Color(int.parse('0xFF${_offer.bannerStart.replaceAll('#', '')}'));
      } catch (_) {
        return cs.primary;
      }
    }
    Color bannerEnd() {
      try {
        return Color(int.parse('0xFF${_offer.bannerEnd.replaceAll('#', '')}'));
      } catch (_) {
        return cs.primaryContainer;
      }
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // ── Banner ────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: bannerStart(),
            leadingWidth: 56,
            leading: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: _GlassBtn(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              _GlassBtn(
                icon: Icons.share_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 4),
              _GlassBtn(
                icon: isSaved
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isSaved ? cs.error : Colors.white,
                onTap: _toggleSave,
              ),
              const SizedBox(width: 14),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [bannerStart(), bannerEnd()],
                      ),
                    ),
                  ),
                  // Scrim
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xB3000000)],
                        stops: [0.3, 1.0],
                      ),
                    ),
                  ),
                  // Info overlay
                  Positioned(
                    left: 20, right: 20, bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Brand logo (gradient square + image / initial fallback)
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [bannerStart(), bannerEnd()],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          child: MerchantLogo(
                            logoUrl: _offer.merchantLogoUrl,
                            initial: _offer.merchantInitial,
                            size: 56,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _offer.merchantName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          _offer.discountLabel,
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          _offer.title,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        // Category chip — solid dark bg so text is always readable
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: Text(
                            _offer.category,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.all(tokens.s20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats grid
                Row(
                  children: [
                    _StatTile(
                      icon: Icons.calendar_today_rounded,
                      label: 'Valid until',
                      value: _offer.validUntil,
                    ),
                    SizedBox(width: tokens.s8),
                    _StatTile(
                      icon: Icons.wallet_rounded,
                      label: 'Min spend',
                      value: _offer.minSpendBdt != null
                          ? '৳${_offer.minSpendBdt}'
                          : 'None',
                    ),
                    SizedBox(width: tokens.s8),
                    _StatTile(
                      icon: Icons.discount_rounded,
                      label: 'Max off',
                      value: _offer.maxDiscountBdt != null
                          ? '৳${_offer.maxDiscountBdt}'
                          : '—',
                    ),
                  ],
                ),

                SizedBox(height: tokens.s24),

                // Qualifying cards
                Text('Applicable on', style: theme.textTheme.titleLarge),
                SizedBox(height: tokens.s8),
                if (qualifying.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 14, color: const Color(0xFF277A50)),
                      SizedBox(width: tokens.s6),
                      Text(
                        '${qualifying.length} of your cards qualify',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF277A50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.s12),
                ],
                if (_offer.eligibleCards.isNotEmpty)
                  _EligibleCardsCarousel(
                    controller: _eligibleController,
                    eligibleCards: _offer.eligibleCards,
                    ownedCards: qualifying,
                    cardForEligible: _cardForEligible,
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: tokens.s16, vertical: tokens.s20),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: tokens.brMd,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card_off_rounded,
                            size: 18, color: cs.onSurfaceVariant),
                        SizedBox(width: tokens.s8),
                        Text(
                          'No cards available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: tokens.s24),

                // Description
                Text('About this offer', style: theme.textTheme.titleLarge),
                SizedBox(height: tokens.s8),
                Text(
                  _offer.description,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant, height: 1.6),
                ),

                SizedBox(height: tokens.s24),

                // Terms
                Text('Terms & conditions', style: theme.textTheme.titleLarge),
                SizedBox(height: tokens.s8),
                ..._offer.terms.map((t) => Padding(
                  padding: EdgeInsets.only(bottom: tokens.s6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          width: 4, height: 4,
                          decoration: BoxDecoration(
                            color: cs.onSurfaceVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: tokens.s8),
                      Expanded(
                        child: Text(
                          t,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )),

                SizedBox(height: tokens.s16),

                // Security note
                Container(
                  padding: EdgeInsets.all(tokens.s12),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: tokens.brMd,
                    border: Border.all(color: cs.outlineVariant, style: BorderStyle.solid),
                  ),
                  child: Text(
                    '🔒 CardiBee never processes payments or connects to your bank. Apply this offer at the merchant using your card.',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
                  ),
                ),

                SizedBox(height: tokens.s24),

                // CTA
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.tertiary,
                      foregroundColor: cs.onTertiary,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Visit merchant'),
                  ),
                ),
                SizedBox(height: tokens.s16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat tile ─────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(tokens.s12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: tokens.brMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: cs.onSurfaceVariant),
            SizedBox(height: tokens.s6),
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            SizedBox(height: tokens.s2),
            Text(value,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Eligible cards carousel ──────────────────────────────────────────────────

class _EligibleCardsCarousel extends StatelessWidget {
  const _EligibleCardsCarousel({
    required this.controller,
    required this.eligibleCards,
    required this.ownedCards,
    required this.cardForEligible,
  });

  final PageController controller;
  final List<EligibleCard> eligibleCards;
  final List<UserCard> ownedCards;
  final UserCard Function(EligibleCard ec, List<UserCard> owned) cardForEligible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: controller,
        clipBehavior: Clip.none,
        padEnds: false,
        physics: const BouncingScrollPhysics(),
        itemCount: eligibleCards.length,
        itemBuilder: (context, index) {
          final ec    = eligibleCards[index];
          final isOwned = ownedCards.any((uc) => uc.cardTypeId == ec.cardTypeId);
          final card  = cardForEligible(ec, ownedCards);

          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double page = index.toDouble();
              if (controller.position.haveDimensions) {
                page = controller.page ?? index.toDouble();
              }
              final delta   = page - index;
              final scale   = 1.0 - (delta.abs() * 0.08).clamp(0.0, 0.15);
              final opacity = 1.0 - (delta.abs() * 0.4).clamp(0.0, 0.5);
              return Transform.scale(
                scale: scale,
                alignment: Alignment.centerLeft,
                child: Opacity(opacity: opacity, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 272,
                  height: 168,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      CreditCardVisual(card: card, size: CardSize.md),
                      if (isOwned)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF277A50),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 10, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'YOUR CARD',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Glass button (on banner) ──────────────────────────────────────────────────

class _GlassBtn extends StatelessWidget {
  const _GlassBtn({required this.icon, required this.onTap, this.iconColor});
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: iconColor ?? Colors.white),
      ),
    ),
  );
}
