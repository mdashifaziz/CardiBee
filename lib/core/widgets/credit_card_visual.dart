// import 'package:flutter/material.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/core/widgets/network_logo.dart';
// import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

// enum CardSize { sm, md, lg }

// class CreditCardVisual extends StatelessWidget {
//   const CreditCardVisual({
//     required this.card,
//     this.size = CardSize.md,
//     this.onTap,
//     super.key,
//   });

//   final UserCard card;
//   final CardSize size;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final tokens = Theme.of(context).tokens;
//     final (w, h) = switch (size) {
//       CardSize.sm => (200.0, 120.0),
//       CardSize.md => (272.0, 168.0),
//       CardSize.lg => (320.0, 196.0),
//     };
//     final gradient = tokens.cardGradient(card.gradient);

//     return Semantics(
//       label: '${card.bankName} ${card.productName} ending in ${card.lastDigits ?? "••••"}',
//       button: onTap != null,
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedScale(
//           scale: 1.0,
//           duration: tokens.durationFast,
//           child: Container(
//             width: w,
//             height: h,
//             decoration: BoxDecoration(
//               gradient: gradient,
//               borderRadius: tokens.brLg,
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0x33000000),
//                   blurRadius: 16,
//                   offset: Offset(0, 8),
//                   spreadRadius: -4,
//                 ),
//               ],
//             ),
//             clipBehavior: Clip.hardEdge,
//             child: Stack(
//               children: [
//                 // Decorative blobs
//                 Positioned(
//                   right: -40,
//                   top: -40,
//                   child: Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.08),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: -30,
//                   bottom: -50,
//                   child: Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//                 // Content
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Bank + chip
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 card.bankName.toUpperCase(),
//                                 style: TextStyle(
//                                   fontSize: 9,
//                                   fontWeight: FontWeight.w500,
//                                   letterSpacing: 1.5,
//                                   color: Colors.white.withOpacity(0.6),
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 card.nickname ?? card.productName,
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // EMV chip
//                           Container(
//                             width: 32,
//                             height: 24,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFFDAAB30), Color(0xFFF5D060)],
//                               ),
//                             ),
//                             child: Center(
//                               child: Container(
//                                 width: 22,
//                                 height: 14,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(2),
//                                   border: Border.all(
//                                     color: Colors.amber.shade700.withOpacity(0.4),
//                                   ),
//                                   color: Colors.amber.shade300.withOpacity(0.5),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       // Number + network
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${card.type.toUpperCase()} · ${card.productName}',
//                                 style: TextStyle(
//                                   fontSize: 9,
//                                   letterSpacing: 1.2,
//                                   color: Colors.white.withOpacity(0.5),
//                                 ),
//                               ),
//                               const SizedBox(height: 3),
//                               Text(
//                                 '•••• ${card.lastDigits ?? '••••'}',
//                                 style: const TextStyle(
//                                   fontFamily: 'monospace',
//                                   fontSize: 13,
//                                   letterSpacing: 2,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           NetworkLogo(
//                             network: card.network,
//                             size: size == CardSize.sm ? 'sm' : 'md',
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// 2nd version

// import 'package:flutter/material.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

// // Note: Removed the unused NetworkLogo import to match your target layout's 
// // text-based network display. If you want the visual network logos back, 
// // you can replace the Text at the bottom right with your NetworkLogo widget.

// enum CardSize { sm, md, lg }

// class CreditCardVisual extends StatelessWidget {
//   const CreditCardVisual({
//     required this.card,
//     this.size = CardSize.md,
//     this.onTap,
//     super.key,
//   });

//   final UserCard card;
//   final CardSize size;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final tokens = theme.tokens;
    
//     // Original exact sizing mapping
//     final (w, h) = switch (size) {
//       CardSize.sm => (200.0, 120.0),
//       CardSize.md => (272.0, 168.0),
//       CardSize.lg => (320.0, 196.0),
//     };

//     // Responsive padding/spacing based on the size context
//     final double p = switch (size) {
//       CardSize.sm => 16.0,
//       CardSize.md => 20.0,
//       CardSize.lg => 24.0,
//     };

//     // Keeps gradient as a fallback if the image fails or isn't loaded
//     final fallbackGradient = tokens.cardGradient(card.gradient);

//     return Semantics(
//       label: '${card.bankName} ${card.nickname ?? card.productName} ending in ${card.lastDigits ?? "••••"}',
//       button: onTap != null,
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedScale(
//           scale: 1.0,
//           duration: tokens.durationFast,
//           child: Container(
//             width: w,
//             height: h,
//             decoration: BoxDecoration(
//               borderRadius: tokens.brLg,
//               gradient: fallbackGradient, 
//               image: const DecorationImage(
//                 // DYNAMIC: Swap this to your network or asset property if you have one.
//                 // Example: AssetImage(card.imageAsset ?? 'assets/images/default.png'),
//                 // Or:      NetworkImage(card.imageUrl),
//                 image: AssetImage('assets/images/City_Bank_Amex_Gold_Corporate.png'),
//                 fit: BoxFit.fill,
//               ),
//               boxShadow:[
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             // Important: this enforces the rounded corners even for the gradient bottom banner
//             clipBehavior: Clip.hardEdge, 
//             child: Stack(
//               children:[
//                 // 1. Bank and Card Name
//                 Positioned(
//                   top: p,
//                   left: p,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:[
//                       Text(
//                         card.bankName.toUpperCase(),
//                         style: theme.textTheme.labelSmall?.copyWith(
//                           color: Colors.white.withOpacity(0.7),
//                           letterSpacing: 1.5,
//                           fontWeight: FontWeight.w600,
//                           fontSize: size == CardSize.sm ? 9 : null,
//                         ),
//                       ),
//                       Text(
//                         card.nickname ?? card.productName,
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: size == CardSize.sm ? 14 : 18,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // 2. Visual Chip
//                 // Positioned(
//                 //   top: p + (size == CardSize.sm ? 32 : 50),
//                 //   left: p,
//                 //   child: Container(
//                 //     width: size == CardSize.sm ? 32 : 45,
//                 //     height: size == CardSize.sm ? 24 : 35,
//                 //     decoration: BoxDecoration(
//                 //       color: Colors.white.withOpacity(0.2),
//                 //       borderRadius: BorderRadius.circular(6),
//                 //       border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 //     ),
//                 //   ),
//                 // ),

//                 // 3. Card Number Placeholder
//                 Positioned(
//                   bottom: p + (size == CardSize.sm ? 4 : 8) -4,
//                   left: p,
//                   child: Text(
//                     '••••  ${card.lastDigits ?? '****'}',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: Colors.white,
//                       letterSpacing: 2,
//                       fontSize: size == CardSize.sm ? 13 : null,
//                     ),
//                   ),
//                 ),

//                 // 4. Network
//                 Positioned(
//                   bottom: p * 0.5,
//                   right: p,
//                   child: Text(
//                     card.network.toUpperCase(),
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w900,
//                       fontStyle: FontStyle.italic,
//                       fontSize: size == CardSize.sm ? 16 : null,
//                     ),
//                   ),
//                 ),

//                 // 5. Bottom Banner
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: size == CardSize.sm ? 12 : 16,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors:[
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.5),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// third version

// import 'package:flutter/material.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/core/widgets/network_logo.dart';
// import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';

// enum CardSize { sm, md, lg }

// class CreditCardVisual extends StatelessWidget {
//   const CreditCardVisual({
//     required this.card,
//     this.size = CardSize.md,
//     this.onTap,
//     super.key,
//   });

//   final UserCard card;
//   final CardSize size;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final tokens = theme.tokens;
    
//     // Original exact sizing mapping
//     final (w, h) = switch (size) {
//       CardSize.sm => (200.0, 120.0),
//       CardSize.md => (272.0, 168.0),
//       CardSize.lg => (320.0, 196.0),
//     };

//     // Responsive padding/spacing based on the size context
//     final double p = switch (size) {
//       CardSize.sm => 16.0,
//       CardSize.md => 20.0,
//       CardSize.lg => 24.0,
//     };

//     // Keeps gradient as a fallback if the image fails or isn't loaded
//     final fallbackGradient = tokens.cardGradient(card.gradient);

//     return Semantics(
//       label: '${card.bankName} ${card.nickname ?? card.productName} ending in ${card.lastDigits ?? "••••"}',
//       button: onTap != null,
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedScale(
//           scale: 1.0,
//           duration: tokens.durationFast,
//           child: Container(
//             width: w,
//             height: h,
//             decoration: BoxDecoration(
//               borderRadius: tokens.brLg,
//               gradient: fallbackGradient, 
//               image: const DecorationImage(
//                 // DYNAMIC: Swap this to your network or asset property if you have one.
//                 // Example: AssetImage(card.imageAsset ?? 'assets/images/default.png'),
//                 // Or:      NetworkImage(card.imageUrl),
//                 image: AssetImage('assets/images/City_Bank_Amex_Gold_Corporate.png'),
//                 fit: BoxFit.fill,
//               ),
//               boxShadow:[
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             // Important: this enforces the rounded corners even for the gradient bottom banner
//             clipBehavior: Clip.hardEdge, 
//             child: Stack(
//               children:[
//                 // 1. Bank and Card Name
//                 Positioned(
//                   top: p,
//                   left: p,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:[
//                       Text(
//                         card.bankName.toUpperCase(),
//                         style: theme.textTheme.labelSmall?.copyWith(
//                           color: Colors.white.withOpacity(0.7),
//                           letterSpacing: 1.5,
//                           fontWeight: FontWeight.w600,
//                           fontSize: size == CardSize.sm ? 9 : null,
//                         ),
//                       ),
//                       Text(
//                         card.nickname ?? card.productName,
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: size == CardSize.sm ? 14 : 18,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // 2. Card Details + Number + Network Logo
//                 Positioned(
//                   bottom: p + (size == CardSize.sm ? 0 : 4) -18,
//                   left: p,
//                   right: p,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children:[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children:[
//                           // Added Card Type (Credit/Debit) & Product Name back
//                           Text(
//                             '${card.type.toUpperCase()} · ${card.productName}',
//                             style: theme.textTheme.labelSmall?.copyWith(
//                               color: Colors.white.withOpacity(0.6),
//                               letterSpacing: 1.2,
//                               fontSize: size == CardSize.sm ? 8 : 10,
//                             ),
//                           ),
//                           const SizedBox(height: 3),
//                           Text(
//                             '••••  ${card.lastDigits ?? '****'}',
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               color: Colors.white,
//                               letterSpacing: 2,
//                               fontSize: size == CardSize.sm ? 13 : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       NetworkLogo(
//                         network: card.network,
//                         size: size == CardSize.sm ? 'sm' : 'md',
//                       ),
//                     ],
//                   ),
//                 ),

//                 // 3. Bottom Banner
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: size == CardSize.sm ? 12 : 16,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors:[
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.5),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


//glass effect txt
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/network/asset_url.dart';
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
    final theme = Theme.of(context);
    final tokens = theme.tokens;
    
    // Original exact sizing mapping
    final (w, h) = switch (size) {
      CardSize.sm => (200.0, 120.0),
      CardSize.md => (272.0, 168.0),
      CardSize.lg => (320.0, 196.0),
    };

    // Responsive padding/spacing based on the size context
    final double p = switch (size) {
      CardSize.sm => 16.0,
      CardSize.md => 20.0,
      CardSize.lg => 24.0,
    };

    // Keeps gradient as a fallback if the image fails or isn't loaded
    final fallbackGradient = tokens.cardGradient(card.gradient);

    // Helper widget to build the glass effect wrap for individual texts
    Widget buildGlassText(Widget child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6), // Slightly smaller radius for individual lines
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: .0, sigmaY: .0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2), // Tighter padding
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: child,
          ),
        ),
      );
    }

    return Semantics(
      label: '${card.bankName} ${card.nickname ?? card.productName} ending in ${card.lastDigits ?? "••••"}',
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
              borderRadius: tokens.brLg,
              gradient: fallbackGradient,
              boxShadow:[
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children:[
                // 0. Card art from backend — overlays gradient. On null/error → gradient shows through.
                if (card.cardImage != null && card.cardImage!.isNotEmpty)
                  Positioned.fill(
                    child: Image.network(
                      resolveAssetUrl(card.cardImage!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      loadingBuilder: (_, child, progress) =>
                          progress == null ? child : const SizedBox.shrink(),
                    ),
                  ),

                // 1. Bank and Card Name (Individual Glass Effects)
                Positioned(
                  // Offsetting to compensate for the individual glass container's padding
                  top: p - 4,
                  left: p - 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      buildGlassText(
                        Text(
                          card.bankName.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            fontSize: size == CardSize.sm ? 9 : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0), // Space between individual glass pills
                      buildGlassText(
                        Text(
                          card.nickname ?? card.productName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(.8),
                            fontWeight: FontWeight.bold,
                            fontSize: size == CardSize.sm ? 8 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Card Details + Number (Individual Glass Effects)
                Positioned(
                  // Offsetting to compensate for the individual glass container's padding
                  bottom: p + (size == CardSize.sm ? 0 : 4) - 18 - 4,
                  left: p - 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      buildGlassText(
                        Text(
                          '${card.type.toUpperCase()} · ${card.productName}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 1.2,
                            fontSize: size == CardSize.sm ? 8 : 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0), // Space between individual glass pills
                      buildGlassText(
                        Text(
                          '••••  ${card.lastDigits ?? '****'}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: size == CardSize.sm ? 13 : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Network Logo (No glass effect)
                Positioned(
                  bottom: p + (size == CardSize.sm ? 0 : 4) - 18,
                  right: p,
                  child: NetworkLogo(
                    network: card.network,
                    size: size == CardSize.sm ? 'sm' : 'md',
                  ),
                ),

                // 4. Bottom Banner
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: size == CardSize.sm ? 12 : 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors:[
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
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