import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state  = ref.watch(cardsNotifierProvider);
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:   (e, _) => Center(child: Text(e.toString())),
          data:    (cards) => Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          tokens.s20, tokens.s8, tokens.s20, tokens.s8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My cards', style: theme.textTheme.headlineLarge),
                          Text(
                            '${cards.length} cards saved · No card numbers stored',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                        tokens.s20, tokens.s8, tokens.s20, 100),
                    sliver: SliverList.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, i) => Padding(
                        padding: EdgeInsets.only(bottom: tokens.s20),
                        child: _CardTile(card: cards[i], index: i),
                      ),
                    ),
                  ),
                ],
              ),
              // FAB
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.addCard),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add card'),
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: const StadiumBorder(),
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

class _CardTile extends ConsumerWidget {
  const _CardTile({required this.card, required this.index});
  final UserCard card;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      children: [
        // Card visual — tappable to view offers
        Center(
          child: CreditCardVisual(
            card: card,
            size: CardSize.lg,
            onTap: () => context.go('${AppRoutes.myOffers}?card=${card.id}'),
          ),
        ),
        SizedBox(height: tokens.s8),
        // Info row
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: tokens.brLg,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: tokens.s16, vertical: tokens.s10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${card.activeOfferCount} active offers',
                      style: theme.textTheme.labelLarge,
                    ),
                    Text(
                      'Tap card to view',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              // Delete
              Semantics(
                label: 'Delete ${card.displayName}',
                button: true,
                child: IconButton(
                  onPressed: () => _confirmDelete(context, ref),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: cs.onSurfaceVariant,
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                ),
              ),
              SizedBox(width: tokens.s4),
              // Navigate
              Semantics(
                label: 'View offers for ${card.displayName}',
                button: true,
                child: IconButton(
                  onPressed: () =>
                      context.go('${AppRoutes.myOffers}?card=${card.id}'),
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: cs.onPrimary,
                  style: IconButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 60), duration: 300.ms)
        .slideY(begin: 0.08, end: 0);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove card?'),
        content: Text(
            'Remove ${card.displayName} from your wallet? This won\'t affect your bank account.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error),
              child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(cardsNotifierProvider.notifier).deleteCard(card.id);
    }
  }
}
