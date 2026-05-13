// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cardibee_flutter/core/routing/app_routes.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
// import 'package:cardibee_flutter/features/offers/providers/favorites_notifier.dart';
// import 'package:go_router/go_router.dart';

// enum OfferCardVariant { defaultCard, featured }

// class OfferCardWidget extends StatelessWidget {
//   const OfferCardWidget({
//     required this.offer,
//     this.variant = OfferCardVariant.defaultCard,
//     super.key,
//   });

//   final Offer offer;
//   final OfferCardVariant variant;

//   @override
//   Widget build(BuildContext context) {
//     return switch (variant) {
//       OfferCardVariant.featured    => _FeaturedOfferCard(offer: offer),
//       OfferCardVariant.defaultCard => _DefaultOfferCard(offer: offer),
//     };
//   }
// }

// // ── Featured card ─────────────────────────────────────────────────────────────

// class _FeaturedOfferCard extends StatelessWidget {
//   const _FeaturedOfferCard({required this.offer});
//   final Offer offer;

//   @override
//   Widget build(BuildContext context) {
//     final tokens = Theme.of(context).tokens;
//     final gradient = LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}')),
//         Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}')),
//       ],
//     );

//     return Semantics(
//       label: '${offer.merchantName}: ${offer.discountLabel}. ${offer.title}',
//       button: true,
//       child: GestureDetector(
//         onTap: () => context.push(AppRoutes.offerDetailPath(offer.id)),
//         child: Container(
//           width: 272,
//           height: 168,
//           decoration: BoxDecoration(
//             gradient: gradient,
//             borderRadius: tokens.brLg,
//             boxShadow: tokens.shadowLg,
//           ),
//           clipBehavior: Clip.hardEdge,
//           child: Stack(
//             children: [
//               const Positioned.fill(child: _GradientOverlay()),
//               // Category badge — top right
//               Positioned(
//                 top: 12, right: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.95),
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                   child: Text(
//                     offer.category,
//                     style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               // Heart — top left
//               Positioned(
//                 top: 8, left: 8,
//                 child: _HeartButton(offerId: offer.id, onDarkBg: true),
//               ),
//               // Info — bottom
//               Positioned(
//                 left: 16, right: 16, bottom: 16,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       offer.merchantName.toUpperCase(),
//                       style: const TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 1.5,
//                         color: Colors.white70,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       offer.discountLabel,
//                       style: const TextStyle(
//                         fontFamily: 'SpaceGrotesk',
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         height: 1.1,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       offer.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontSize: 11, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Default card ──────────────────────────────────────────────────────────────

// class _DefaultOfferCard extends StatelessWidget {
//   const _DefaultOfferCard({required this.offer});
//   final Offer offer;

//   @override
//   Widget build(BuildContext context) {
//     final theme  = Theme.of(context);
//     final cs     = theme.colorScheme;
//     final tokens = theme.tokens;
//     final expiringSoon = offer.daysLeft <= 7;

//     final logoGradient = LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}')),
//         Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}')),
//       ],
//     );

//     return Semantics(
//       label: '${offer.merchantName}: ${offer.discountLabel}. ${offer.title}',
//       button: true,
//       child: GestureDetector(
//         onTap: () => context.push(AppRoutes.offerDetailPath(offer.id)),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             // Card body
//             Container(
//               decoration: BoxDecoration(
//                 color: cs.surface,
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0x0F000000),
//                     blurRadius: 20,
//                     offset: Offset(0, 4),
//                     spreadRadius: 0,
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(14),
//                 child: Row(
//                   children: [
//                     // Logo box — gradient, very rounded
//                     Container(
//                       width: 56,
//                       height: 56,
//                       decoration: BoxDecoration(
//                         gradient: logoGradient,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         offer.merchantInitial,
//                         style: const TextStyle(
//                           fontFamily: 'SpaceGrotesk',
//                           fontSize: 18,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     // Info
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 32),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               offer.merchantName,
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFF9CA3AF),
//                                 letterSpacing: 0.1,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 3),
//                             Text(
//                               offer.title,
//                               style: theme.textTheme.titleSmall?.copyWith(
//                                 fontWeight: FontWeight.w700,
//                                 color: cs.onSurface,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 8),
//                             Wrap(
//                               spacing: 6,
//                               runSpacing: 4,
//                               children: [
//                                 _Badge(
//                                   label: offer.discountLabel,
//                                   bgColor: const Color(0x1A00A86B),
//                                   textColor: const Color(0xFF00875A),
//                                 ),
//                                 if (expiringSoon)
//                                   _Badge(
//                                     icon: Icons.access_time_rounded,
//                                     label: '${offer.daysLeft}d left',
//                                     bgColor: const Color(0x1AF46B10),
//                                     textColor: const Color(0xFFF46B10),
//                                   )
//                                 else
//                                   Text(
//                                     'Until ${offer.validUntil}',
//                                     style: const TextStyle(
//                                       fontSize: 10,
//                                       color: Color(0xFF9CA3AF),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Heart — top right, white circle
//             Positioned(
//               top: 10, right: 10,
//               child: _HeartButton(offerId: offer.id),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Heart button ──────────────────────────────────────────────────────────────

// class _HeartButton extends ConsumerWidget {
//   const _HeartButton({required this.offerId, this.onDarkBg = false, super.key});
//   final String offerId;
//   final bool onDarkBg;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cs = Theme.of(context).colorScheme;
//     final savedIds = ref.watch(favoritesProvider).valueOrNull ?? {};
//     final isSaved  = savedIds.contains(offerId);

//     return Semantics(
//       label: isSaved ? 'Remove from favorites' : 'Add to favorites',
//       button: true,
//       child: GestureDetector(
//         onTap: () => ref.read(favoritesProvider.notifier).toggle(offerId),
//         behavior: HitTestBehavior.opaque,
//         child: Container(
//           width: 34, height: 34,
//           decoration: BoxDecoration(
//             color: onDarkBg
//                 ? Colors.black.withValues(alpha: 0.40)
//                 : Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: const [
//               BoxShadow(
//                 color: Color(0x1A000000),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           alignment: Alignment.center,
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 220),
//             switchInCurve: Curves.elasticOut,
//             switchOutCurve: Curves.easeIn,
//             transitionBuilder: (child, anim) => ScaleTransition(
//               scale: anim,
//               child: child,
//             ),
//             child: Icon(
//               isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//               key: ValueKey(isSaved),
//               size: 16,
//               color: isSaved
//                   ? const Color(0xFFE53935)
//                   : const Color(0xFFBDBDBD),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Shared helpers ────────────────────────────────────────────────────────────

// class _Badge extends StatelessWidget {
//   const _Badge({
//     required this.label,
//     required this.bgColor,
//     required this.textColor,
//     this.icon,
//   });
//   final String label;
//   final Color bgColor;
//   final Color textColor;
//   final IconData? icon;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null) ...[
//             Icon(icon, size: 10, color: textColor),
//             const SizedBox(width: 3),
//           ],
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w700,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GradientOverlay extends StatelessWidget {
//   const _GradientOverlay();

//   @override
//   Widget build(BuildContext context) => const DecoratedBox(
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [Colors.transparent, Color(0xB3000000)],
//         stops: [0.3, 1.0],
//       ),
//     ),
//   );
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/merchant_logo.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/favorites_notifier.dart';

enum OfferCardVariant { defaultCard, featured }

class OfferCardWidget extends StatelessWidget {
  const OfferCardWidget({
    required this.offer,
    this.variant = OfferCardVariant.defaultCard,
    super.key,
  });

  final Offer offer;
  final OfferCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      OfferCardVariant.featured    => _FeaturedOfferCard(offer: offer),
      OfferCardVariant.defaultCard => _DefaultOfferCard(offer: offer),
    };
  }
}

// ── Featured card (Original Design) ──────────────────────────────────────────

class _FeaturedOfferCard extends StatelessWidget {
  const _FeaturedOfferCard({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors:[
        Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}')),
        Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}')),
      ],
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
            children:[
              const Positioned.fill(child: _GradientOverlay()),
              // Category badge — top right (dark translucent so text is readable on any banner)
              Positioned(
                top: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    offer.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              // Heart — top left
              Positioned(
                top: 8, left: 8,
                child: _HeartButton(offerId: offer.id, onDarkBg: true),
              ),
              // Info — bottom
              Positioned(
                left: 16, right: 16, bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
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

// ── Default card (New Dark/Light Mode Design) ────────────────────────────────

class _DefaultOfferCard extends StatelessWidget {
  const _DefaultOfferCard({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    // Automatically detect dark mode from the current context!
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Structural Colors based on theme
    final bgColor = isDark ? const Color(0xFF181B31) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2E45) : const Color(0xFFE6E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF131B4D);
    final subtitleColor = isDark ? const Color(0xFF8B95A5) : const Color(0xFF64748B);

    // Pill Badges Colors based on theme
    final valueBadgeBg = isDark ? const Color(0xFF2C2C1D) : const Color(0xFFFFF4CC);
    final valueBadgeText = isDark ? const Color(0xFFA3A849) : const Color(0xFF131B4D);
    final timeBadgeBg = isDark ? const Color(0xFF382318) : const Color(0xFFFEEDE1);
    final timeBadgeText = const Color(0xFFF46B10);

    // Parse the gradients from the backend data
    final logoGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors:[
        Color(int.parse('0xFF${offer.bannerStart.replaceAll('#', '')}')),
        Color(int.parse('0xFF${offer.bannerEnd.replaceAll('#', '')}')),
      ],
    );

    return Semantics(
      label: '${offer.merchantName}: ${offer.discountLabel}. ${offer.title}',
      button: true,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.offerDetailPath(offer.id)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              // ── Gradient Logo Square (logo image if available, else initial) ──
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: logoGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: MerchantLogo(
                  logoUrl: offer.merchantLogoUrl,
                  initial: offer.merchantInitial,
                  size: 64,
                ),
              ),
              const SizedBox(width: 16),
              
              // ── Right Content Column ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    // Merchant Name & Heart Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Expanded(
                          child: Text(
                            offer.merchantName,
                            style: TextStyle(
                              fontSize: 13,
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Beautiful minimal heart button
                        _HeartButton(offerId: offer.id, defaultColor: subtitleColor),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Offer Title
                    Text(
                      offer.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    
                    // Pill Badges Row
                    Row(
                      children:[
                        // 1. Discount Value Badge (Uses backend label)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: valueBadgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            offer.discountLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: valueBadgeText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // 2. Time Left Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: timeBadgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:[
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: timeBadgeText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${offer.daysLeft}d left',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: timeBadgeText,
                                ),
                              ),
                            ],
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
    );
  }
}

// ── Shared Heart Button ──────────────────────────────────────────────────────

class _HeartButton extends ConsumerWidget {
  const _HeartButton({
    required this.offerId,
    this.defaultColor,
    this.onDarkBg = false,
  });
  
  final String offerId;
  final Color? defaultColor;
  final bool onDarkBg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedIds = ref.watch(favoritesProvider).valueOrNull ?? {};
    final isSaved  = savedIds.contains(offerId);

    // If it's on a dark background (like the Featured Card), use the circle background
    if (onDarkBg) {
      return Semantics(
        label: isSaved ? 'Remove from favorites' : 'Add to favorites',
        button: true,
        child: GestureDetector(
          onTap: () => ref.read(favoritesProvider.notifier).toggle(offerId),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.40),
              shape: BoxShape.circle,
              boxShadow: const[
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: child,
              ),
              child: Icon(
                isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isSaved),
                size: 16,
                color: isSaved ? const Color(0xFFE53935) : Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // Otherwise, use the minimal icon design for the Default Card
    return Semantics(
      label: isSaved ? 'Remove from favorites' : 'Add to favorites',
      button: true,
      child: GestureDetector(
        onTap: () => ref.read(favoritesProvider.notifier).toggle(offerId),
        behavior: HitTestBehavior.opaque, 
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0), 
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: child,
            ),
            child: Icon(
              isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isSaved),
              size: 20,
              color: isSaved ? const Color(0xFFE53935) : defaultColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Overlay used in Featured Card ────────────────────────────────────────────

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:[Colors.transparent, Color(0xB3000000)],
        stops: [0.3, 1.0],
      ),
    ),
  );
}