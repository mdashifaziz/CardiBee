import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

const _sorts = [
  (value: 'expiring_soon',    label: 'Expiring soon'),
  (value: 'newest',           label: 'Newest'),
  (value: 'highest_discount', label: 'Highest discount'),
];

class MyOffersScreen extends ConsumerStatefulWidget {
  const MyOffersScreen({super.key});

  @override
  ConsumerState<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends ConsumerState<MyOffersScreen> {
  String _category = 'All';
  String _sort     = 'expiring_soon';
  List<Offer> _offers = [];
  bool _loading = true;
  String? _cardFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routerState = GoRouterState.of(context);
    _cardFilter = routerState.uri.queryParameters['card'];
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _load(); });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(offersRepositoryProvider).listOffers(
        myCardsOnly: true,
        category: _category == 'All' ? null : _category,
        cardId: _cardFilter,
        sort: _sort,
      );
      setState(() => _offers = result.items);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    const cats = ['All', 'Food', 'Travel', 'Shopping', 'Groceries', 'Entertainment', 'Health'];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s8, tokens.s20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My offers', style: theme.textTheme.headlineLarge),
                  Text(
                    '${_offers.length} deals matched to your cards',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.s12),

            // Category chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                itemCount: cats.length,
                separatorBuilder: (_, __) => SizedBox(width: tokens.s8),
                itemBuilder: (_, i) {
                  final cat    = cats[i];
                  final active = _category == cat;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _category = cat);
                      _load();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? cs.primary : cs.surfaceContainerLowest,
                        border: Border.all(
                          color: active ? cs.primary : cs.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        cat,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: active ? cs.onPrimary : cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: tokens.s8),

            // Sort row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.s20),
              child: Row(
                children: [
                  Text('${_offers.length} results',
                      style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sort,
                      isDense: true,
                      borderRadius: BorderRadius.circular(12),
                      style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
                      items: _sorts.map((s) => DropdownMenuItem(
                        value: s.value,
                        child: Text(s.label),
                      )).toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _sort = v);
                        _load();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.s8),

            // List
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _offers.isEmpty
                      ? _EmptyState(
                          onAddCard: () => context.push(AppRoutes.addCard),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                              tokens.s20, 0, tokens.s20, tokens.s24),
                          itemCount: _offers.length,
                          separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                          itemBuilder: (_, i) => OfferCardWidget(offer: _offers[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddCard});
  final VoidCallback onAddCard;

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
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: cs.tertiary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.credit_card_rounded, size: 36, color: cs.tertiary),
            ),
            SizedBox(height: tokens.s20),
            Text('Add a card to begin', style: theme.textTheme.headlineSmall),
            SizedBox(height: tokens.s8),
            Text(
              'Once you add cards, we\'ll surface every offer that matches your wallet.',
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tokens.s20),
            ElevatedButton.icon(
              onPressed: onAddCard,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add card'),
            ),
          ],
        ),
      ),
    );
  }
}
