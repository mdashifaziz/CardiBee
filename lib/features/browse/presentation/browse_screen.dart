import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/error/app_failure.dart';
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
  String _query     = '';
  List<Offer> _all  = [];
  bool _loading     = true;
  bool _loadingMore = false;
  String? _error;
  String? _nextCursor;
  final _queryCtrl  = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory ?? 'All';
    _scrollCtrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _loadAll(); });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final routerState = GoRouterState.of(context);
      final cat = routerState.uri.queryParameters['cat'];
      if (cat != null && cat != _category) setState(() => _category = cat);
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _queryCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingMore || _nextCursor == null) return;
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  String? get _apiCategory => _category == 'All' ? null : _category;

  Future<void> _loadAll() async {
    setState(() { _loading = true; _error = null; _nextCursor = null; _all = []; });
    try {
      final result = await ref.read(offersRepositoryProvider).listOffers(
        myCardsOnly: false,
        category: _apiCategory,
        limit: 16,
      );
      setState(() { _all = result.items; _nextCursor = result.nextCursor; });
    } catch (e) {
      setState(() => _error = e is AppFailure ? e.displayMessage : e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final result = await ref.read(offersRepositoryProvider).listOffers(
        myCardsOnly: false,
        category: _apiCategory,
        limit: 16,
        cursor: _nextCursor,
      );
      setState(() {
        _all = [..._all, ...result.items];
        _nextCursor = result.nextCursor;
      });
    } catch (_) {} finally {
      setState(() => _loadingMore = false);
    }
  }

  List<Offer> get _filtered {
    if (_query.isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all.where((o) =>
        o.merchantName.toLowerCase().contains(q) ||
        o.title.toLowerCase().contains(q) ||
        o.category.toLowerCase().contains(q)).toList();
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
                    onTap: () {
                      if (_category == cat) return;
                      setState(() => _category = cat);
                      _loadAll();
                    },
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
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(tokens.s24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Failed to load offers',
                                    style: theme.textTheme.titleMedium),
                                SizedBox(height: tokens.s8),
                                Text(_error!,
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(color: cs.error),
                                    textAlign: TextAlign.center),
                                SizedBox(height: tokens.s16),
                                FilledButton(
                                    onPressed: _loadAll,
                                    child: const Text('Retry')),
                              ],
                            ),
                          ),
                        )
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
                          controller: _scrollCtrl,
                          padding: EdgeInsets.fromLTRB(
                              tokens.s20, 0, tokens.s20, tokens.s24),
                          itemCount: results.length + (_loadingMore ? 1 : 0),
                          separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
                          itemBuilder: (_, i) {
                            if (i == results.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            return OfferCardWidget(offer: results[i]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
