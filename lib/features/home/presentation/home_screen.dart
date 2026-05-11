// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:cardibee_flutter/core/routing/app_routes.dart';
// import 'package:cardibee_flutter/core/theme/app_colors.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/core/theme/app_typography.dart';
// import 'package:cardibee_flutter/core/theme/theme_provider.dart';
// import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
// import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
// import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
// import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
// import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
// import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
// import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

// // ── Category metadata ─────────────────────────────────────────────────────────
// const _categories = [
//   (name: 'Food',          emoji: '🍽️', key: 'Food'),
//   (name: 'Travel',        emoji: '✈️', key: 'Travel'),
//   (name: 'Shopping',      emoji: '🛍️', key: 'Shopping'),
//   (name: 'Groceries',     emoji: '🛒', key: 'Groceries'),
//   (name: 'Entertainment', emoji: '🎬', key: 'Entertainment'),
//   (name: 'Health',        emoji: '💊', key: 'Health'),
// ];

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   List<Offer> _allOffers = [];
//   bool _offersLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadOffers());
//   }

//   Future<void> _loadOffers() async {
//     final repo = ref.read(offersRepositoryProvider);
//     try {
//       final result = await repo.listOffers(myCardsOnly: false);
//       if (mounted) setState(() { _allOffers = result.items; _offersLoaded = true; });
//     } catch (_) {
//       if (mounted) setState(() => _offersLoaded = true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme      = Theme.of(context);
//     final cs         = theme.colorScheme;
//     final tokens     = theme.tokens;
//     final themeMode  = ref.watch(themeProvider);
//     final isDark     = themeMode == ThemeMode.dark;
//     final user       = ref.watch(currentUserProvider);
//     final cardsAsync = ref.watch(cardsNotifierProvider);

//     return Scaffold(
//       backgroundColor: cs.surface,
//       body: SafeArea(
//         child: cardsAsync.when(
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (e, _) => Center(child: Text(e.toString())),
//           data: (cards) {
//             final featured = _allOffers.where((o) => o.featured).toList();
//             final expiring = _allOffers.where((o) => o.daysLeft <= 7).take(3).toList();

//             return CustomScrollView(
//               slivers: [
//                 // ── Header ────────────────────────────────────────────────
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s8, tokens.s20, 0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Hello, welcome back',
//                                 style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
//                               ),
//                               Text(
//                                 'Hi, ${user?.fullName.split(' ').first ?? 'there'} 👋',
//                                 style: theme.textTheme.headlineSmall,
//                               ),
//                             ],
//                           ),
//                         ),
//                         _HeaderBtn(
//                           icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
//                           semanticLabel: 'Toggle theme',
//                           onTap: () => ref.read(themeProvider.notifier).toggle(),
//                         ),
//                         SizedBox(width: tokens.s8),
//                         _HeaderBtn(
//                           icon: Icons.notifications_outlined,
//                           semanticLabel: 'Notifications',
//                           badge: true,
//                           onTap: () => context.push(AppRoutes.notifications),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // ── Search bar ─────────────────────────────────────────────
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s16, tokens.s20, 0),
//                     child: Semantics(
//                       label: 'Search merchants, banks or offers',
//                       button: true,
//                       child: GestureDetector(
//                         onTap: () => context.push(AppRoutes.browse),
//                         child: Container(
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: cs.surfaceContainerLowest,
//                             borderRadius: tokens.brLg,
//                             border: Border.all(color: cs.outlineVariant),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: tokens.s16),
//                           child: Row(
//                             children: [
//                               Icon(Icons.search_rounded, size: 18, color: cs.onSurfaceVariant),
//                               SizedBox(width: tokens.s8),
//                               Text(
//                                 'Search merchants, banks or offers',
//                                 style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // ── Hero wallet card ───────────────────────────────────────
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s20, tokens.s20, 0),
//                     child: _HeroCard(
//                       cards: cards,
//                       activeOfferCount: _allOffers.length,
//                       onViewCards: () => context.go(AppRoutes.cards),
//                     ),
//                   ),
//                 ),

//                 // ── Categories ─────────────────────────────────────────────
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s28, tokens.s20, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Offers by category', style: theme.textTheme.headlineSmall),
//                         SizedBox(height: tokens.s12),
//                         GridView.count(
//                           crossAxisCount: 3,
//                           mainAxisSpacing: tokens.s12,
//                           crossAxisSpacing: tokens.s12,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           childAspectRatio: 1.1,
//                           children: _categories.map((cat) {
//                             return Semantics(
//                               label: cat.name,
//                               button: true,
//                               child: GestureDetector(
//                                 onTap: () => context.push('${AppRoutes.browse}?cat=${cat.key}'),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: cs.surface,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const [
//                                       BoxShadow(
//                                         color: Color(0x0A000000),
//                                         blurRadius: 12,
//                                         offset: Offset(0, 3),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 56, height: 56,
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFFFFF5EC),
//                                           borderRadius: BorderRadius.circular(18),
//                                         ),
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           cat.emoji,
//                                           style: const TextStyle(fontSize: 22),
//                                         ),
//                                       ),
//                                       SizedBox(height: tokens.s8),
//                                       Text(
//                                         cat.name,
//                                         style: theme.textTheme.labelSmall?.copyWith(
//                                           fontWeight: FontWeight.w600,
//                                           color: cs.onSurface,
//                                           letterSpacing: 0,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // ── Featured offers ────────────────────────────────────────
//                 if (featured.isNotEmpty) ...[
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s28, 0, tokens.s12),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text('Featured offers ✨', style: theme.textTheme.headlineSmall),
//                           ),
//                           TextButton(
//                             onPressed: () => context.push(AppRoutes.browse),
//                             child: Padding(
//                               padding: EdgeInsets.only(right: tokens.s20),
//                               child: const Text('See all'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverToBoxAdapter(
//                     child: SizedBox(
//                       height: 180,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: EdgeInsets.symmetric(horizontal: tokens.s20),
//                         itemCount: featured.length,
//                         itemBuilder: (_, i) => Padding(
//                           padding: EdgeInsets.only(right: tokens.s12),
//                           child: OfferCardWidget(
//                             offer: featured[i],
//                             variant: OfferCardVariant.featured,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],

//                 // ── Expiring soon ──────────────────────────────────────────
//                 if (expiring.isNotEmpty) ...[
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s28, tokens.s20, tokens.s12),
//                       child: Row(
//                         children: [
//                           Text('Expiring soon', style: theme.textTheme.headlineSmall),
//                           SizedBox(width: tokens.s8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF46B10).withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(999),
//                             ),
//                             child: Text(
//                               '⏰ ${expiring.length}',
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFFF46B10),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           TextButton(
//                             onPressed: () => context.go(AppRoutes.myOffers),
//                             child: const Text('See all'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverPadding(
//                     padding: EdgeInsets.fromLTRB(tokens.s20, 0, tokens.s20, tokens.s24),
//                     sliver: SliverList.separated(
//                       itemCount: expiring.length,
//                       separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
//                       itemBuilder: (_, i) => OfferCardWidget(offer: expiring[i]),
//                     ),
//                   ),
//                 ] else if (_offersLoaded)
//                   SliverToBoxAdapter(child: SizedBox(height: tokens.s24)),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // ── Hero wallet card ──────────────────────────────────────────────────────────

// class _HeroCard extends StatelessWidget {
//   const _HeroCard({
//     required this.cards,
//     required this.activeOfferCount,
//     required this.onViewCards,
//   });
//   final List<UserCard> cards;
//   final int activeOfferCount;
//   final VoidCallback onViewCards;

//   @override
//   Widget build(BuildContext context) {
//     final tokens = Theme.of(context).tokens;

//     return Container(
//       padding: EdgeInsets.all(tokens.s20),
//       decoration: BoxDecoration(
//         gradient: tokens.gradientHero,
//         borderRadius: tokens.brXl,
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x33000000),
//             blurRadius: 20,
//             offset: Offset(0, 8),
//             spreadRadius: -4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'YOUR WALLET',
//                       style: TextStyle(
//                         fontFamily: AppFonts.sans,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 1.5,
//                         color: Colors.white.withOpacity(0.6),
//                       ),
//                     ),
//                     SizedBox(height: tokens.s4),
//                     Text(
//                       '${cards.length} cards',
//                       style: TextStyle(
//                         fontFamily: AppFonts.display,
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: tokens.s4),
//                     Text(
//                       '$activeOfferCount offers active for you',
//                       style: TextStyle(
//                         fontFamily: AppFonts.sans,
//                         fontSize: 12,
//                         color: Colors.white.withOpacity(0.7),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: onViewCards,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: AppColors.beeYellow,
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'View',
//                         style: TextStyle(
//                           fontFamily: AppFonts.sans,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.navyDeep,
//                         ),
//                       ),
//                       const SizedBox(width: 2),
//                       Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.navyDeep),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: tokens.s16),
//           // Stacked mini cards
//           if (cards.isNotEmpty)
//             SizedBox(
//               height: 132,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: cards.take(3).toList().asMap().entries.map((e) {
//                   final i    = e.key;
//                   final card = e.value;
//                   return Positioned(
//                     left: i * 24.0,
//                     child: Transform.rotate(
//                       angle: i * -0.035,
//                       child: CreditCardVisual(
//                         card: card,
//                         size: CardSize.sm,
//                         onTap: onViewCards,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ),
//     )
//         .animate()
//         .fadeIn(duration: 400.ms)
//         .slideY(begin: 0.05, end: 0);
//   }
// }

// // ── Header icon button ────────────────────────────────────────────────────────

// class _HeaderBtn extends StatelessWidget {
//   const _HeaderBtn({
//     required this.icon,
//     required this.semanticLabel,
//     required this.onTap,
//     this.badge = false,
//   });
//   final IconData icon;
//   final String semanticLabel;
//   final VoidCallback onTap;
//   final bool badge;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Semantics(
//       label: semanticLabel,
//       button: true,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 40, height: 40,
//           decoration: BoxDecoration(color: cs.surfaceContainerLow, shape: BoxShape.circle),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Icon(icon, size: 18, color: cs.onSurface),
//               if (badge)
//                 Positioned(
//                   right: 8, top: 8,
//                   child: Container(
//                     width: 8, height: 8,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFF46B10),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';
import 'package:cardibee_flutter/core/theme/theme_provider.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

// ── Category metadata ─────────────────────────────────────────────────────────
// const _categories =[
//   (name: 'Food',          emoji: '🍽️', key: 'Food'),
//   (name: 'Travel',        emoji: '✈️', key: 'Travel'),
//   (name: 'Shopping',      emoji: '🛍️', key: 'Shopping'),
//   (name: 'Groceries',     emoji: '🛒', key: 'Groceries'),
//   (name: 'Entertainment', emoji: '🎬', key: 'Entertainment'),
//   (name: 'Health',        emoji: '💊', key: 'Health'),
// ];

const _categories =[
  (name: 'Food',          icon: Icons.restaurant,       key: 'Food'),
  (name: 'Travel',        icon: Icons.flight,           key: 'Travel'),
  (name: 'Shopping',      icon: Icons.shopping_bag,     key: 'Shopping'),
  (name: 'Groceries',     icon: Icons.shopping_cart,    key: 'Groceries'),
  (name: 'Entertainment', icon: Icons.movie,            key: 'Entertainment'),
  (name: 'Health',        icon: Icons.medical_services, key: 'Health'),
  (name: 'Hotel',        icon: Icons.night_shelter, key: 'Hotel'),
  (name: 'Airport Lounge',        icon: Icons.chair, key: 'Lounge')
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Offer> _allOffers =[];
  bool _offersLoaded = false;
  final _featuredCtrl = PageController(viewportFraction: 0.88);
  Timer? _featuredTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOffers());
  }

  void _startFeaturedAutoSlide(int count) {
    _featuredTimer?.cancel();
    if (count <= 1) return;
    _featuredTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_featuredCtrl.hasClients) return;
      final next = (_featuredCtrl.page!.round() + 1) % count;
      _featuredCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _featuredTimer?.cancel();
    _featuredCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadOffers() async {
    final repo = ref.read(offersRepositoryProvider);
    try {
      final result = await repo.listOffers(myCardsOnly: false, sort: 'expiring_soon');
      if (mounted) {
        setState(() { _allOffers = result.items; _offersLoaded = true; });
        _startFeaturedAutoSlide(result.items.where((o) => o.featured).length);
      }
    } catch (_) {
      if (mounted) setState(() => _offersLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme      = Theme.of(context);
    final cs         = theme.colorScheme;
    final tokens     = theme.tokens;
    final themeMode  = ref.watch(themeProvider);
    final isDark     = themeMode == ThemeMode.dark;
    final user       = ref.watch(currentUserProvider);
    final cardsAsync = ref.watch(cardsNotifierProvider);

    final cards   = cardsAsync.valueOrNull ?? const <UserCard>[];
    final featured = _allOffers.where((o) => o.featured).toList();
    final expiring  = _allOffers.where((o) => o.daysLeft <= 7).take(3).toList();

    // Show spinner only on the very first load (no cached data yet).
    if (cardsAsync.isLoading && !cardsAsync.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
              slivers:[
                // ── Header ────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s8, tokens.s16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(
                                'Hello, welcome back',
                                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                              ),
                              Text(
                                'Hi, ${user?.fullName.split(' ').first ?? 'there'} 👋',
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                        _HeaderBtn(
                          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          semanticLabel: 'Toggle theme',
                          onTap: () => ref.read(themeProvider.notifier).toggle(),
                        ),
                        SizedBox(width: tokens.s8),
                        _HeaderBtn(
                          icon: Icons.notifications_outlined,
                          semanticLabel: 'Notifications',
                          badge: true,
                          onTap: () => context.push(AppRoutes.notifications),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Search bar ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s16, tokens.s16, 0),
                    child: Semantics(
                      label: 'Search merchants, banks or offers',
                      button: true,
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.browse),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerLowest,
                            borderRadius: tokens.brLg,
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: tokens.s16),
                          child: Row(
                            children:[
                              Icon(Icons.search_rounded, size: 18, color: cs.onSurfaceVariant),
                              SizedBox(width: tokens.s8),
                              Text(
                                'Search merchants, banks or offers',
                                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Hero wallet card ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, tokens.s16, 0),
                    child: _HeroCard(
                      cards: cards,
                      activeOfferCount: _allOffers.length,
                      onViewCards: () => context.go(AppRoutes.cards),
                      onCompare: () => context.push(AppRoutes.compare),
                    ),
                  ),
                ),

                // ── Categories ─────────────────────────────────────────────
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s32, tokens.s20, 0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children:[
                //         Text(
                //           'Browse by category', 
                //           style: theme.textTheme.titleLarge?.copyWith(
                //             fontWeight: FontWeight.w700,
                //             color: isDark ? Colors.white : const Color(0xFF131B4D), 
                //           ) ?? TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.w700,
                //             color: isDark ? Colors.white : const Color(0xFF131B4D),
                //           ),
                //         ),
                //         SizedBox(height: tokens.s16),
                //         GridView.count(
                //           crossAxisCount: 3,
                //           mainAxisSpacing: 12,
                //           crossAxisSpacing: 12,
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           childAspectRatio: 0.95,
                //           children: _categories.map((cat) {
                //             return Semantics(
                //               label: cat.name,
                //               button: true,
                //               child: GestureDetector(
                //                 onTap: () => context.go('${AppRoutes.browse}?cat=${cat.key}'),
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     color: isDark ? const Color(0xFF181B31) : Colors.white,
                //                     borderRadius: BorderRadius.circular(24),
                //                     border: Border.all(
                //                       color: isDark ? const Color(0xFF2A2E45) : const Color(0xFFE6E8F0), 
                //                       width: 1,
                //                     ),
                //                   ),
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children:[
                //                       Container(
                //                         width: 52, height: 52,
                //                         decoration: BoxDecoration(
                //                           color: isDark ? const Color(0xFF38312A) : const Color(0xFFFFF6E9), 
                //                           borderRadius: BorderRadius.circular(16),
                //                         ),
                //                         alignment: Alignment.center,
                //                         child: Text(
                //                           cat.emoji,
                //                           style: const TextStyle(fontSize: 24),
                //                         ),
                //                       ),
                //                       const SizedBox(height: 10),
                //                       Text(
                //                         cat.name,
                //                         style: TextStyle(
                //                           fontFamily: AppFonts.sans,
                //                           fontSize: 12,
                //                           fontWeight: FontWeight.w500,
                //                           color: isDark ? Colors.white : const Color(0xFF131B4D), 
                //                           letterSpacing: -0.2,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, tokens.s16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        'Offers by category', 
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF131B4D), 
                        ) ?? TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF131B4D),
                        ),
                      ),
                      SizedBox(height: tokens.s16),
                      GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 6,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 0.95,
                        children: _categories.map((cat) {
                          return Semantics(
                            label: cat.name,
                            button: true,
                            child: GestureDetector(
                              onTap: () => context.push('${AppRoutes.browse}?cat=${cat.key}'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF181B31) : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF2A2E45) : const Color(0xFFE6E8F0), 
                                    width: 1,
                                  ),
                                ),
                                // child: Column(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children:[
                                //     // The inner container has been removed, leaving only the emoji Text widget
                                //     Text(
                                //       cat.emoji,
                                //       style: const TextStyle(fontSize: 32), // You might want to increase the font size slightly (e.g. 32) since the box is gone
                                //     ),
                                //     const SizedBox(height: 10),
                                //     Text(
                                //       cat.name,
                                //       style: TextStyle(
                                //         fontFamily: AppFonts.sans,
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.w500,
                                //         color: isDark ? Colors.white : const Color(0xFF131B4D), 
                                //         letterSpacing: -0.2,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    // Replace the Text emoji with the Icon widget
                                    Icon(
                                      cat.icon,
                                      size: 32,
                                      color: isDark ? const Color(0xFFF7B638) : Colors.black,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        fontFamily: AppFonts.sans,
                                        fontSize: 10
                                        ,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white : const Color(0xFF131B4D), 
                                        letterSpacing: -0.25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Builder(
                      //   builder: (context) {
                      //     const int crossAxisCount = 4;
                      //     const double mainAxisSpacing = 8.0;
                      //     const double crossAxisSpacing = 12.0;
                      //     final List<Widget> rows =[];

                      //     // Chunk the categories list into rows based on crossAxisCount
                      //     for (int i = 0; i < _categories.length; i += crossAxisCount) {
                      //       final rowItems = _categories.skip(i).take(crossAxisCount).toList();

                      //       rows.add(
                      //         Row(
                      //           children: rowItems.asMap().entries.map((entry) {
                      //             final index = entry.key;
                      //             final cat = entry.value;
                      //             final isLast = index == rowItems.length - 1;

                      //             return Expanded(
                      //               child: Padding(
                      //                 // Add right spacing to all items EXCEPT the last one in the row
                      //                 padding: EdgeInsets.only(right: isLast ? 0 : crossAxisSpacing),
                      //                 child: Semantics(
                      //                   label: cat.name,
                      //                   button: true,
                      //                   child: GestureDetector(
                      //                     onTap: () => context.go('${AppRoutes.browse}?cat=${cat.key}'),
                      //                     child: Container(
                      //                       // Fixed height is required here because we aren't using childAspectRatio anymore
                      //                       height: 95, 
                      //                       decoration: BoxDecoration(
                      //                         color: isDark ? const Color(0xFF181B31) : Colors.white,
                      //                         borderRadius: BorderRadius.circular(24),
                      //                         border: Border.all(
                      //                           color: isDark ? const Color(0xFF2A2E45) : const Color(0xFFE6E8F0), 
                      //                           width: 1,
                      //                         ),
                      //                       ),
                      //                       child: Column(
                      //                         mainAxisAlignment: MainAxisAlignment.center,
                      //                         children:[
                      //                           Icon(
                      //                             cat.icon,
                      //                             size: 32,
                      //                             color: isDark ? const Color(0xFFF7B638) : Colors.black,
                      //                           ),
                      //                           const SizedBox(height: 10),
                      //                           Text(
                      //                             cat.name,
                      //                             style: TextStyle(
                      //                               fontFamily: AppFonts.sans,
                      //                               fontSize: 12,
                      //                               fontWeight: FontWeight.w500,
                      //                               color: isDark ? Colors.white : const Color(0xFF131B4D), 
                      //                               letterSpacing: -0.2,
                      //                             ),
                      //                             maxLines: 1,
                      //                             overflow: TextOverflow.ellipsis,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //           }).toList(),
                      //         ),
                      //       );
                      //     }

                      //     // Build the rows vertically with mainAxisSpacing
                      //     return Column(
                      //       children: rows.asMap().entries.map((entry) {
                      //         final isLast = entry.key == rows.length - 1;
                      //         return Padding(
                      //           padding: EdgeInsets.only(bottom: isLast ? 0 : mainAxisSpacing),
                      //           child: entry.value,
                      //         );
                      //       }).toList(),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),

                // ── Featured offers ────────────────────────────────────────
                if (featured.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, 0, tokens.s12),
                      child: Row(
                        children:[
                          Expanded(
                            child: Text(
                              'Featured offers ✨', 
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF131B4D), 
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.browse),
                            child: Padding(
                              padding: EdgeInsets.only(right: tokens.s16),
                              child: const Text('See all'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _featuredCtrl,
                        itemCount: featured.length,
                        itemBuilder: (_, i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: tokens.s8),
                          child: OfferCardWidget(
                            offer: featured[i],
                            variant: OfferCardVariant.featured,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // ── Expiring soon ──────────────────────────────────────────
                if (expiring.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, tokens.s16, tokens.s12),
                      child: Row(
                        children:[
                          Text(
                            'Expiring soon',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF131B4D), 
                            ),
                          ),
                          SizedBox(width: tokens.s8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF46B10).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '⏰ ${expiring.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF46B10),
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.myOffers),
                            child: const Text('See all'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(tokens.s16, 0, tokens.s16, tokens.s24),
                    sliver: SliverList.separated(
                      itemCount: expiring.length,
                      separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                      itemBuilder: (_, i) => OfferCardWidget(offer: expiring[i]),
                    ),
                  ),
                ] else if (_offersLoaded)
                  SliverToBoxAdapter(child: SizedBox(height: tokens.s24)),
              ],
        ),
      ),
    );
  }
}

// ── Hero wallet card ──────────────────────────────────────────────────────────

class _HeroCard extends StatefulWidget {
  const _HeroCard({
    required this.cards,
    required this.activeOfferCount,
    required this.onViewCards,
    required this.onCompare,
  });

  final List<UserCard> cards;
  final int activeOfferCount;
  final VoidCallback onViewCards;
  final VoidCallback onCompare;

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // 0.85 fraction leaves exactly enough room to show the next card peeking perfectly
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;

    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: tokens.s20),
    //   decoration: BoxDecoration(
    //     color: const Color(0xFF131B4D), // Deep navy exact color match
    //     borderRadius: BorderRadius.circular(32), 
    //     boxShadow: const[
    //       BoxShadow(
    //         color: Color(0x33000000),
    //         blurRadius: 20,
    //         offset: Offset(0, 8),
    //         spreadRadius: -4,
    //       ),
    //     ],
    //   ),
    return Container(
      padding: EdgeInsets.symmetric(vertical: tokens.s20),
      decoration: BoxDecoration(
        gradient: tokens.gradientHero,
        borderRadius: tokens.brXl,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.s24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        'YOUR WALLET',
                        style: TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: tokens.s4),
                      Text(
                        '${widget.cards.length} cards',
                        style: const TextStyle(
                          fontFamily: AppFonts.display,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: tokens.s4),
                      Text(
                        '${widget.activeOfferCount} offers active for you',
                        style: TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: widget.onCompare,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.compare_arrows_rounded, size: 13, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Compare',
                              style: TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onViewCards,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7B638),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View',
                              style: TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF131B4D),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF131B4D)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.s20),
          
          if (widget.cards.isNotEmpty)
            SizedBox(
              height: 160, 
              child: Padding(
                padding: EdgeInsets.only(left: tokens.s24),
                child: PageView.builder(
                  controller: _pageController,
                  clipBehavior: Clip.none, 
                  padEnds: false, 
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.cards.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double page = index.toDouble();
                        if (_pageController.position.haveDimensions) {
                          page = _pageController.page ?? index.toDouble();
                        }
                        double delta = page - index;

                        double scale = 1.0 - (delta.abs() * 0.08).clamp(0.0, 0.15);
                        double opacity = 1.0 - (delta.abs() * 0.4).clamp(0.0, 0.5);

                        return Transform.scale(
                          scale: scale,
                          alignment: Alignment.centerLeft, 
                          child: Opacity(
                            opacity: opacity,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CreditCardVisual(
                          card: widget.cards[index],
                          size: CardSize.md,
                          onTap: widget.onViewCards,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

// ── Header icon button ────────────────────────────────────────────────────────

class _HeaderBtn extends StatelessWidget {
  const _HeaderBtn({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.badge = false,
  });
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: cs.surfaceContainerLow, shape: BoxShape.circle),
          child: Stack(
            alignment: Alignment.center,
            children:[
              Icon(icon, size: 18, color: cs.onSurface),
              if (badge)
                Positioned(
                  right: 8, top: 8,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF46B10),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}