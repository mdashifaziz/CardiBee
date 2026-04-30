import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 32, this.withWordmark = false, super.key});

  final double size;
  final bool withWordmark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/cardibee-mark.webp',
          width: size,
          height: size,
          fit: BoxFit.contain,
          // Fallback while asset isn't yet added
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: cs.tertiary,
              borderRadius: BorderRadius.circular(size * 0.22),
            ),
            alignment: Alignment.center,
            child: Text(
              'CB',
              style: TextStyle(
                fontFamily: AppFonts.display,
                fontSize: size * 0.38,
                fontWeight: FontWeight.w800,
                color: cs.onTertiary,
              ),
            ),
          ),
        ),
        if (withWordmark) ...[
          SizedBox(width: size * 0.25),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: AppFonts.display,
                fontSize: size * 0.6,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
              children: [
                const TextSpan(text: 'Cardi'),
                TextSpan(text: 'Bee', style: TextStyle(color: cs.tertiary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
