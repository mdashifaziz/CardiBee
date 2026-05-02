import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/network_logo.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

enum CardSize { sm, md, lg }

class CreditCardVisual extends StatelessWidget {
  const CreditCardVisual({
    required this.card,
    this.size = CardSize.md,
    this.onTap,
    super.key,
  });

  final UserCard card;
  final CardSize size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).tokens;
    final (w, h) = switch (size) {
      CardSize.sm => (200.0, 120.0),
      CardSize.md => (272.0, 168.0),
      CardSize.lg => (320.0, 196.0),
    };
    final gradient = tokens.cardGradient(card.gradient);

    return Semantics(
      label: '${card.bankName} ${card.productName} ending in ${card.lastDigits ?? "••••"}',
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: 1.0,
          duration: tokens.durationFast,
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: tokens.brLg,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                  spreadRadius: -4,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // Decorative blobs
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -50,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bank + chip
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.bankName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                card.nickname ?? card.productName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          // EMV chip
                          Container(
                            width: 32,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFDAAB30), Color(0xFFF5D060)],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 22,
                                height: 14,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: Colors.amber.shade700.withOpacity(0.4),
                                  ),
                                  color: Colors.amber.shade300.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Number + network
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${card.type.toUpperCase()} · ${card.productName}',
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 1.2,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '•••• ${card.lastDigits ?? '••••'}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          NetworkLogo(
                            network: card.network,
                            size: size == CardSize.sm ? 'sm' : 'md',
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
