import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/offer_card_widget.dart';
import 'package:cardibee_flutter/features/offers/domain/models/offer.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({this.initialCategory, super.key});
  final String? initialCategory;

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  late String _category;
  String _query    = '';
  List<Offer> _all = [];
  bool _loading    = true;
  final _queryCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory ?? 'All';
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _loadAll(); });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final routerState = GoRouterState.of(context);
      final cat = routerState.uri.queryParameters['cat'];
      if (cat != null && cat != _category) setState(() => _category = cat);
    } catch (_) {
      // GoRouterState may not be available in all contexts
    }
  }

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(offersRepositoryProvider).listOffers(
        myCardsOnly: false,
        limit: 100,
      );
      setState(() => _all = result.items);
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Offer> get _filtered {
    var list = _all;
    if (_category != 'All') list = list.where((o) => o.category == _category).toList();
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((o) =>
          o.merchantName.toLowerCase().contains(q) ||
          o.title.toLowerCase().contains(q) ||
          o.category.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final cs      = theme.colorScheme;
    final tokens  = theme.tokens;
    final results = _filtered;
    const cats    = ['All', 'Food', 'Travel', 'Shopping', 'Groceries', 'Entertainment', 'Health'];

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
                  Text('Browse all offers', style: theme.textTheme.headlineLarge),
                  Text('Discover every deal in the catalog',
                      style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  SizedBox(height: tokens.s16),
                  // Search input
                  TextField(
                    controller: _queryCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search merchants or categories',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              onPressed: () {
                                _queryCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                    ),
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
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? cs.primary : cs.surfaceContainerLowest,
                        border: Border.all(color: active ? cs.primary : cs.outlineVariant),
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
            SizedBox(height: tokens.s12),

            // Offer list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : results.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(tokens.s32),
                            child: Container(
                              padding: EdgeInsets.all(tokens.s24),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: cs.outlineVariant,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: tokens.brXl,
                              ),
                              child: Text(
                                'No offers match your search.',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: cs.onSurfaceVariant),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                              tokens.s20, 0, tokens.s20, tokens.s24),
                          itemCount: results.length,
                          separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                          itemBuilder: (_, i) => OfferCardWidget(offer: results[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
