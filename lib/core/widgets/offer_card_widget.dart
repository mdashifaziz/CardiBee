import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:go_router/go_router.dart';

enum OfferCardVariant { defaultCard, featured }

class OfferCardWidget extends StatelessWidget {
  const OfferCardWidget({
    required this.offer,
    this.variant = OfferCardVariant.defaultCard,
    this.onFavoriteToggle,
    super.key,
  });

  final Offer offer;
  final OfferCardVariant variant;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      OfferCardVariant.featured     => _FeaturedOfferCard(offer: offer),
      OfferCardVariant.defaultCard  => _DefaultOfferCard(
          offer: offer,
          onFavoriteToggle: onFavoriteToggle,
        ),
    };
  }
}

class _FeaturedOfferCard extends StatelessWidget {
  const _FeaturedOfferCard({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}')),
               Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}'))],
    );

    return Semantics(
      label: '${offer.merchantName}: ${offer.discountLabel}. ${offer.title}',
      button: true,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.offerDetailPath(offer.id)),
        child: Container(
          width: 272,
          height: 168,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: tokens.brLg,
            boxShadow: tokens.shadowLg,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              const Positioned.fill(
                child: _GradientOverlay(),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    offer.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.merchantName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.discountLabel,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultOfferCard extends StatelessWidget {
  const _DefaultOfferCard({required this.offer, this.onFavoriteToggle});
  final Offer offer;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final expiringSoon = offer.daysLeft <= 7;

    final avatarGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}')),
               Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}'))],
    );

    return Semantics(
      label: '${offer.merchantName}: ${offer.discountLabel}. ${offer.title}',
      button: true,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.offerDetailPath(offer.id)),
        child: AnimatedContainer(
          duration: tokens.durationFast,
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: tokens.brLg,
            border: Border.all(color: cs.outlineVariant),
            boxShadow: tokens.shadowSm,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Merchant avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: avatarGradient,
                    borderRadius: tokens.brMd,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    offer.merchantInitial,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              offer.merchantName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onFavoriteToggle != null)
                            Semantics(
                              label: offer.isSaved ? 'Remove from favorites' : 'Add to favorites',
                              button: true,
                              child: GestureDetector(
                                onTap: onFavoriteToggle,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    offer.isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 18,
                                    color: offer.isSaved ? cs.error : cs.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        offer.title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [
                          _Badge(
                            label: offer.discountLabel,
                            bgColor: cs.tertiary.withOpacity(0.2),
                            textColor: cs.onTertiary == Colors.white
                                ? cs.tertiary
                                : cs.onTertiary,
                          ),
                          if (expiringSoon)
                            _Badge(
                              icon: Icons.access_time_rounded,
                              label: '${offer.daysLeft}d left',
                              bgColor: const Color(0xFFF46B10).withOpacity(0.15),
                              textColor: const Color(0xFFF46B10),
                            )
                          else
                            Text(
                              'Until ${offer.validUntil}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.icon,
  });
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Color(0xB3000000)],
        stops: [0.3, 1.0],
      ),
    ),
  );
}
