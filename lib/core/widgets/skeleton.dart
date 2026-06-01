import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';

// Skeleton placeholder primitives + presets used while data is fetching.
// All variants share a soft fade-pulse animation (0.5 → 1.0, 700ms, repeat
// reverse) so they feel alive without the heavier shimmer-sweep effect.

// ── Primitives ───────────────────────────────────────────────────────────────

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.color,
  });

  final double? width;
  final double? height;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius ?? 8),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 700.ms, begin: 0.5);
  }
}

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.width,
    this.height = 12,
    this.radius = 6,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkeletonBox(
      width: width,
      height: height,
      radius: radius,
      color: cs.surfaceContainerLow,
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      radius: size / 2,
      color: color,
    );
  }
}

// ── Offer card skeletons ─────────────────────────────────────────────────────

// Mirrors lib/core/widgets/offer_card_widget.dart -> _DefaultOfferCard
class SkeletonOfferCard extends StatelessWidget {
  const SkeletonOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? const Color(0xFF181B31) : Colors.white;
    final border = isDark ? const Color(0xFF2A2E45) : const Color(0xFFE6E8F0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SkeletonBox(width: 72, height: 72, radius: 16, color: cs.surfaceContainerHigh),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SkeletonLine(width: 100, height: 12),
                SizedBox(height: 10),
                SkeletonLine(width: 180, height: 16),
                SizedBox(height: 14),
                Row(children: [
                  SkeletonBox(width: 60, height: 20, radius: 8),
                  SizedBox(width: 8),
                  SkeletonBox(width: 72, height: 20, radius: 8),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mirrors _FeaturedOfferCard — 272x168 gradient banner placeholder.
class SkeletonFeaturedOfferCard extends StatelessWidget {
  const SkeletonFeaturedOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    return SkeletonBox(
      width: 272,
      height: 168,
      radius: tokens.radiusLg,
    );
  }
}

// ── Credit card visual skeleton ──────────────────────────────────────────────

class SkeletonCreditCard extends StatelessWidget {
  const SkeletonCreditCard({super.key, this.height = 196});

  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: tokens.brLg,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 700.ms, begin: 0.5);
  }
}

// ── List skeleton helper ─────────────────────────────────────────────────────

class SkeletonOfferList extends StatelessWidget {
  const SkeletonOfferList({super.key, this.count = 5, this.padding});

  final int count;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    return ListView.separated(
      padding: padding ??
          EdgeInsets.fromLTRB(tokens.s20, 0, tokens.s20, tokens.s24),
      itemCount: count,
      separatorBuilder: (_, __) => SizedBox(height: tokens.s8),
      itemBuilder: (_, __) => const SkeletonOfferCard(),
    );
  }
}
