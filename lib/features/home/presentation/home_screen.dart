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
import 'package:cardibee_flutter/core/widgets/error_retry_view.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/core/widgets/skeleton.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

const _categories = [
  (name: 'Food',          icon: Icons.restaurant,       key: 'Food'),
  (name: 'Travel',        icon: Icons.flight,           key: 'Travel'),
  (name: 'Shopping',      icon: Icons.shopping_bag,     key: 'Shopping'),
  (name: 'Groceries',     icon: Icons.shopping_cart,    key: 'Groceries'),
  (name: 'Entertainment', icon: Icons.movie,            key: 'Entertainment'),
  (name: 'Health',        icon: Icons.medical_services, key: 'Health'),
  (name: 'Hotel',         icon: Icons.night_shelter,    key: 'Hotel'),
  (name: 'Airport Lounge',icon: Icons.chair,            key: 'Lounge'),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Offer> _featured = [];
  List<Offer> _expiring = [];
  bool _offersLoaded = false;
  bool _offersError  = false;
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
    if (mounted) setState(() => _offersError = false);
    try {
      final results = await Future.wait([
        repo.listOffers(myCardsOnly: false, featured: true, limit: 16),
        repo.listOffers(myCardsOnly: false, featured: true, limit: 12),
      ]);
      if (mounted) {
        setState(() {
          _featured = results[0].items;
          _expiring = results[1].items;
          _offersLoaded = true;
        });
        _startFeaturedAutoSlide(_featured.length);
      }
    } catch (_) {
      if (mounted) setState(() { _offersLoaded = true; _offersError = true; });
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(cardsNotifierProvider);
    await _loadOffers();
  }

  @override
  Widget build(BuildContext context) {
    final theme      = Theme.of(context);
    final cs         = theme.colorScheme;
    final tokens     = theme.tokens;
    ref.watch(themeProvider); // rebuild when the user toggles
    final isDark     = theme.brightness == Brightness.dark;
    final user       = ref.watch(currentUserProvider);
    final cardsAsync = ref.watch(cardsNotifierProvider);
    final unread     = ref.watch(unreadCountProvider);

    final cards    = cardsAsync.valueOrNull ?? const <UserCard>[];
    final featured = _featured;
    final expiring = _expiring;

    if (cardsAsync.isLoading && !cardsAsync.hasValue) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                tokens.s16, tokens.s8, tokens.s16, tokens.s24),
            children: [
              // Header placeholder
              Row(
                children: [
                  const SkeletonCircle(size: 40),
                  SizedBox(width: tokens.s12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 120, height: 14),
                        SizedBox(height: 6),
                        SkeletonLine(width: 80, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: tokens.s24),
              // Hero wallet card placeholder
              SkeletonBox(height: 220, radius: tokens.radiusXl),
              SizedBox(height: tokens.s24),
              // Section title
              const SkeletonLine(width: 140, height: 18),
              SizedBox(height: tokens.s12),
              // Offer list placeholders
              for (int i = 0; i < 3; i++) ...[
                const SkeletonOfferCard(),
                SizedBox(height: tokens.s8),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s8, tokens.s16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      semanticLabel: unread > 0
                          ? 'Notifications, $unread unread'
                          : 'Notifications',
                      badgeCount: unread,
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                  ],
                ),
              ),
            ),

            // ── Search bar ──────────────────────────────────────────────
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
                        children: [
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

            // ── Hero wallet card ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, tokens.s16, 0),
                child: _HeroCard(
                  cards: cards,
                  activeOfferCount: _featured.length,
                  onViewCards: () => context.go(AppRoutes.cards),
                  onCompare: () => context.push(AppRoutes.compare),
                ),
              ),
            ),

            // ── Featured offers ──────────────────────────────────────────
            if (featured.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, 0, tokens.s12),
                  child: Row(
                    children: [
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

            // ── Categories ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, tokens.s16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offers by category',
                      style: theme.textTheme.titleLarge?.copyWith(
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
                                gradient: isDark ? null : tokens.gradientHoney,
                                color: isDark ? const Color(0xFF181B31) : null,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF2A2E45) : const Color(0xFFEAD08A),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.white : const Color(0xFF131B4D),
                                      letterSpacing: -0.25,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // ── Offers failed to load ────────────────────────────────────
            if (_offersError && _featured.isEmpty && _expiring.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: tokens.s24),
                  child: ErrorRetryView(
                    title: 'Couldn\'t load offers',
                    onRetry: _loadOffers,
                  ),
                ),
              ),

            // ── Expiring soon ────────────────────────────────────────────
            if (expiring.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(tokens.s16, tokens.s24, tokens.s16, tokens.s12),
                  child: Row(
                    children: [
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
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.tokens;
    final isDark = theme.brightness == Brightness.dark;
    final onCard = isDark ? Colors.white : const Color(0xFF131B4D);

    return Container(
      padding: EdgeInsets.symmetric(vertical: tokens.s20),
      decoration: BoxDecoration(
        gradient: isDark ? tokens.gradientHero : tokens.gradientHoney,
        borderRadius: tokens.brXl,
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x33000000) : const Color(0x1F182040),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.s24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR WALLET',
                        style: TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: onCard.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: tokens.s4),
                      Text(
                        '${widget.cards.length} cards',
                        style: TextStyle(
                          fontFamily: AppFonts.display,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: onCard,
                        ),
                      ),
                      SizedBox(height: tokens.s4),
                      Text(
                        '${widget.activeOfferCount} offers active for you',
                        style: TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 12,
                          color: onCard.withOpacity(0.7),
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
                          color: onCard.withOpacity(isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: onCard.withOpacity(isDark ? 0.3 : 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.compare_arrows_rounded, size: 13, color: onCard),
                            const SizedBox(width: 4),
                            Text(
                              'Compare',
                              style: TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: onCard,
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
                          color: isDark ? const Color(0xFFF7B638) : const Color(0xFF131B4D),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View',
                              style: TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF131B4D) : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded, size: 16,
                                color: isDark ? const Color(0xFF131B4D) : Colors.white),
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
    this.badgeCount = 0,
  });
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;
  final int badgeCount;

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
          clipBehavior: Clip.none,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 18, color: cs.onSurface),
              if (badgeCount > 0)
                Positioned(
                  right: 4, top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF46B10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: cs.surfaceContainerLow, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
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
