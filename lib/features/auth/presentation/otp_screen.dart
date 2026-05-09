// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:cardibee_flutter/core/routing/app_routes.dart';
// import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/features/auth/providers/auth_notifier.dart';
// import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

// class OtpScreen extends ConsumerStatefulWidget {
//   const OtpScreen({super.key});

//   @override
//   ConsumerState<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends ConsumerState<OtpScreen> {
//   final List<TextEditingController> _cells =
//       List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _foci = List.generate(6, (_) => FocusNode());

//   // Cached so data remains visible during AuthLoading
//   AuthOtpSent? _otpData;

//   @override
//   void dispose() {
//     for (final c in _cells) { c.dispose(); }
//     for (final f in _foci) { f.dispose(); }
//     super.dispose();
//   }

//   void _onCellChanged(int i, String val) {
//     if (val.length == 1 && i < 5) _foci[i + 1].requestFocus();
//     if (val.isEmpty && i > 0) _foci[i - 1].requestFocus();
//     _tryAutoVerify();
//   }

//   void _tryAutoVerify() {
//     final otp = _otp;
//     if (otp.length == 6) _verify(otp);
//   }

//   String get _otp => _cells.map((c) => c.text).join();

//   void _verify(String otp) {
//     final data = _otpData;
//     if (data == null) return;
//     ref.read(authNotifierProvider.notifier).verifySignupOtp(
//       requestId: data.requestId,
//       otp: otp,
//     );
//   }

//   void _resend() {
//     final data = _otpData;
//     if (data == null) return;
//     for (final c in _cells) { c.clear(); }
//     _foci[0].requestFocus();
//     ref.read(authNotifierProvider.notifier).requestSignupOtp(
//       username: data.username,
//       email: data.email,
//       age: data.age,
//       gender: data.gender,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen(authNotifierProvider, (_, next) {
//       if (next is AuthSuccess) {
//         ref.read(prefsStorageProvider).setOnboarded(true);
//         context.go(AppRoutes.home);
//       }
//     });

//     final authState = ref.watch(authNotifierProvider);
//     if (authState is AuthOtpSent) _otpData = authState;

//     final data      = _otpData;
//     final isLoading = authState is AuthLoading;
//     final hasError  = data?.error != null;

//     if (data == null) {
//       // Shouldn't happen in normal flow; go back if it does
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) context.go(AppRoutes.signup);
//       });
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final theme  = Theme.of(context);
//     final cs     = theme.colorScheme;
//     final tokens = theme.tokens;

//     return Scaffold(
//       backgroundColor: cs.surface,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           padding: EdgeInsets.symmetric(horizontal: tokens.s24, vertical: tokens.s24),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.sizeOf(context).height,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//               // Back button
//               _CircleIconBtn(
//                 icon: Icons.arrow_back_rounded,
//                 onTap: () => context.go(AppRoutes.signup),
//               ),
//               SizedBox(height: tokens.s24),

//               Text('Check your inbox', style: theme.textTheme.headlineMedium),
//               SizedBox(height: tokens.s8),
//               Text(
//                 'OTP sent to ${data.maskedEmail}',
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: cs.onSurfaceVariant,
//                 ),
//               ),
//               SizedBox(height: tokens.s32),

//               // 6-cell OTP input
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(6, (i) => _OtpCell(
//                   controller: _cells[i],
//                   focusNode: _foci[i],
//                   hasError: hasError,
//                   onChanged: (v) => _onCellChanged(i, v),
//                 )),
//               ),

//               if (data.error != null) ...[
//                 SizedBox(height: tokens.s8),
//                 _ErrorBanner(data.error!),
//               ],

//               SizedBox(height: tokens.s24),

//               // Verify button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : () => _verify(_otp),
//                   child: isLoading
//                       ? SizedBox(
//                           width: 20, height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2, color: cs.onPrimary,
//                           ),
//                         )
//                       : const Text('Verify OTP'),
//                 ),
//               ),

//               SizedBox(height: tokens.s16),

//               Center(
//                 child: TextButton(
//                   onPressed: isLoading ? null : _resend,
//                   child: const Text('Resend OTP'),
//                 ),
//               ),

//               SizedBox(height: tokens.s8),

//               Text(
//                 '🔒 We never share your data or ask for card credentials.',
//                 style: theme.textTheme.labelSmall?.copyWith(
//                   color: cs.onSurfaceVariant,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _OtpCell extends StatelessWidget {
//   const _OtpCell({
//     required this.controller,
//     required this.focusNode,
//     required this.hasError,
//     required this.onChanged,
//   });

//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final bool hasError;
//   final ValueChanged<String> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return SizedBox(
//       width: 44, height: 56,
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         style: const TextStyle(
//           fontFamily: 'SpaceGrotesk',
//           fontSize: 22,
//           fontWeight: FontWeight.w700,
//         ),
//         decoration: InputDecoration(
//           counterText: '',
//           contentPadding: EdgeInsets.zero,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: hasError ? cs.error : cs.outlineVariant,
//               width: 1.5,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: hasError ? cs.error : cs.primary,
//               width: 2,
//             ),
//           ),
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }

// class _CircleIconBtn extends StatelessWidget {
//   const _CircleIconBtn({required this.icon, required this.onTap});
//   final IconData icon;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40, height: 40,
//         decoration: BoxDecoration(
//           color: cs.surfaceContainerLow,
//           shape: BoxShape.circle,
//         ),
//         alignment: Alignment.center,
//         child: Icon(icon, size: 18),
//       ),
//     );
//   }
// }

// class _ErrorBanner extends StatelessWidget {
//   const _ErrorBanner(this.message);
//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: cs.errorContainer,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         message,
//         style: TextStyle(fontSize: 12, color: cs.onErrorContainer),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_notifier.dart';
import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

// Brand accent color for OTP focus
const Color brandGold = Color(0xFFF0B41D);

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _cells =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _foci = List.generate(6, (_) => FocusNode());

  AuthOtpSent? _otpData;

  @override
  void dispose() {
    for (final c in _cells) {
      c.dispose();
    }
    for (final f in _foci) {
      f.dispose();
    }
    super.dispose();
  }

  void _onCellChanged(int i, String val) {
    // Auto-focus logic
    if (val.length == 1 && i < 5) _foci[i + 1].requestFocus();
    if (val.isEmpty && i > 0) _foci[i - 1].requestFocus();
    _tryAutoVerify();
  }

  void _tryAutoVerify() {
    final otp = _otp;
    if (otp.length == 6) _verify(otp);
  }

  String get _otp => _cells.map((c) => c.text).join();

  void _verify(String otp) {
    if (_otpData == null) return;
    ref.read(authNotifierProvider.notifier).verifyOtpAndSignup(otp);
  }

  void _resend() {
    final data = _otpData;
    if (data == null) return;
    for (final c in _cells) {
      c.clear();
    }
    _foci[0].requestFocus();
    ref.read(authNotifierProvider.notifier).sendOtp(
          contact:  data.contact,
          fullName: data.fullName,
          username: data.username,
          password: data.password,
          groupId:  data.groupId,
          age:      data.age,
          gender:   data.gender,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for navigation on success
    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthSuccess) {
        ref.read(prefsStorageProvider).setOnboarded(true);
        context.go(AppRoutes.home);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    if (authState is AuthOtpSent) _otpData = authState;

    final data = _otpData;
    final isLoading = authState is AuthLoading;
    final hasError = data?.error != null;

    // Safety fallback if state is lost
    if (data == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.signup);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: tokens.s16),
          child: _CircleIconBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.go(AppRoutes.signup),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: tokens.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: tokens.s24),

              // Visual Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: brandGold.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 32,
                  color: brandGold,
                ),
              ),

              SizedBox(height: tokens.s24),
              Text(
                'Verify your email',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: tokens.s8),
              Text(
                'Enter the 6-digit code sent to ${data.contact}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),

              SizedBox(height: tokens.s40),

              // 6-cell OTP input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (i) => _OtpCell(
                    controller: _cells[i],
                    focusNode: _foci[i],
                    hasError: hasError,
                    onChanged: (v) => _onCellChanged(i, v),
                  ),
                ),
              ),

              // Error Display
              if (hasError) ...[
                SizedBox(height: tokens.s24),
                _ErrorBanner(data.error!),
              ],

              SizedBox(height: tokens.s40),

              // Verify button (Using Theme Primary Color)
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: isLoading ? null : () => _verify(_otp),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: cs.onPrimary,
                          ),
                        )
                      : const Text(
                          'Verify Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: tokens.s16),

              Center(
                child: TextButton(
                  onPressed: isLoading ? null : _resend,
                  style: TextButton.styleFrom(
                    foregroundColor: cs.primary,
                  ),
                  child: const Text('Didn’t receive a code? Resend'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpCell extends StatefulWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  State<_OtpCell> createState() => _OtpCellState();
}

class _OtpCellState extends State<_OtpCell> {
  @override
  void initState() {
    super.initState();
    // Ensure the widget rebuilds when focus changes to show the gold shadow
    widget.focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFocused = widget.focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 62,
      decoration: BoxDecoration(
        // Subtle Gold Hue when focused
        color: isFocused ? brandGold.withOpacity(0.08) : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.hasError
              ? cs.error
              : (isFocused ? brandGold : cs.outlineVariant.withOpacity(0.4)),
          width: isFocused ? 2 : 1,
        ),
        // Golden Glow Shadow
        boxShadow: isFocused && !widget.hasError
            ? [
                BoxShadow(
                  color: brandGold.withOpacity(0.25),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.hasError ? cs.error : cs.onSurface,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: cs.surfaceContainerHighest,
        shape: const CircleBorder(),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 20, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: cs.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}