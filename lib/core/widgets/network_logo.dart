import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';

class NetworkLogo extends StatelessWidget {
  const NetworkLogo({required this.network, this.size = 'md', super.key});

  final String network; // 'Visa' | 'Mastercard' | 'Amex'
  final String size;    // 'sm' | 'md'

  @override
  Widget build(BuildContext context) {
    return switch (network) {
      'Visa'       => _VisaLogo(size: size),
      'Mastercard' => _MastercardLogo(size: size),
      _            => _AmexBadge(size: size),
    };
  }
}

class _VisaLogo extends StatelessWidget {
  const _VisaLogo({required this.size});
  final String size;

  @override
  Widget build(BuildContext context) {
    final fontSize = size == 'sm' ? 13.0 : 16.0;
    return Text(
      'VISA',
      style: TextStyle(
        fontFamily: AppFonts.display,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        letterSpacing: 1,
        color: Colors.white.withOpacity(0.95),
      ),
    );
  }
}

class _MastercardLogo extends StatelessWidget {
  const _MastercardLogo({required this.size});
  final String size;

  @override
  Widget build(BuildContext context) {
    final d = size == 'sm' ? 16.0 : 20.0;
    return SizedBox(
      width: d + 8,
      height: d,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: d,
              height: d,
              decoration: const BoxDecoration(
                color: AppColors.mastercardRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 8,
            child: Container(
              width: d,
              height: d,
              decoration: BoxDecoration(
                color: AppColors.mastercardYellow.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmexBadge extends StatelessWidget {
  const _AmexBadge({required this.size});
  final String size;

  @override
  Widget build(BuildContext context) {
    final fontSize = size == 'sm' ? 8.0 : 10.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.amexBlue,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        'AMEX',
        style: TextStyle(
          fontFamily: AppFonts.sans,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Colors.white,
        ),
      ),
    );
  }
}
