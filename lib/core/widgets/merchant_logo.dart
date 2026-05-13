import 'package:flutter/material.dart';

// Merchant logo box with graceful fallback.
//
// If [logoUrl] is provided and loads successfully, renders the image with
// BoxFit.cover. Otherwise (null, empty, load error) falls back to a centered
// uppercase [initial] text. Caller is expected to wrap this in a sized,
// gradient-filled, clipped Container if a coloured backdrop is desired.
class MerchantLogo extends StatelessWidget {
  const MerchantLogo({
    required this.logoUrl,
    required this.initial,
    required this.size,
    super.key,
  });

  final String? logoUrl;
  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initialText = Text(
      initial,
      style: TextStyle(
        color: Colors.white,
        fontSize: size * 0.25,
        fontWeight: FontWeight.bold,
      ),
    );

    if (logoUrl == null || logoUrl!.isEmpty) return initialText;

    return Padding(
      padding: EdgeInsets.all(size * 0.12),
      child: Image.network(
        logoUrl!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => initialText,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : initialText,
      ),
    );
  }
}
