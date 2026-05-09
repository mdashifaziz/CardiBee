// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:cardibee_flutter/core/routing/app_routes.dart';
// import 'package:cardibee_flutter/core/theme/app_tokens.dart';
// import 'package:cardibee_flutter/core/widgets/app_logo.dart';
// import 'package:cardibee_flutter/features/auth/providers/auth_notifier.dart';
// import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

// const _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

// class SignupScreen extends ConsumerStatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   ConsumerState<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends ConsumerState<SignupScreen> {
//   final _usernameCtrl = TextEditingController();
//   final _emailCtrl    = TextEditingController();
//   final _ageCtrl      = TextEditingController();
//   final _usernameFocus = FocusNode();
//   String? _selectedGender;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _usernameFocus.requestFocus());
//   }

//   @override
//   void dispose() {
//     _usernameCtrl.dispose();
//     _emailCtrl.dispose();
//     _ageCtrl.dispose();
//     _usernameFocus.dispose();
//     super.dispose();
//   }

//   void _sendOtp() {
//     final username = _usernameCtrl.text.trim();
//     final email    = _emailCtrl.text.trim();
//     final age      = int.tryParse(_ageCtrl.text.trim());
//     final gender   = _selectedGender;

//     if (username.isEmpty || email.isEmpty || age == null || gender == null) return;
//     if (!email.contains('@') || !email.contains('.')) return;

//     ref.read(authNotifierProvider.notifier).requestSignupOtp(
//       username: username,
//       email: email,
//       age: age,
//       gender: gender,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen(authNotifierProvider, (_, next) {
//       if (next is AuthOtpSent) context.go(AppRoutes.otp);
//     });

//     final authState = ref.watch(authNotifierProvider);
//     final isLoading = authState is AuthLoading;
//     final error     = authState is AuthError ? authState.message : null;

//     final theme  = Theme.of(context);
//     final cs     = theme.colorScheme;
//     final tokens = theme.tokens;

//     return Scaffold(
//       backgroundColor: cs.surface,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(tokens.s24, tokens.s8, tokens.s24, tokens.s24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back button
//               _CircleIconBtn(
//                 icon: Icons.arrow_back_rounded,
//                 onTap: () {
//                   ref.read(authNotifierProvider.notifier).reset();
//                   context.go(AppRoutes.auth);
//                 },
//               ),
//               SizedBox(height: tokens.s24),

//               // Header
//               Row(
//                 children: [
//                   const AppLogo(size: 36),
//                   SizedBox(width: tokens.s12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Create account', style: theme.textTheme.headlineMedium),
//                       Text(
//                         'Start saving on every swipe',
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           color: cs.onSurfaceVariant,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ).animate().fadeIn(duration: 300.ms),

//               SizedBox(height: tokens.s32),

//               // Username
//               const _FieldLabel('Username'),
//               SizedBox(height: tokens.s6),
//               TextField(
//                 controller: _usernameCtrl,
//                 focusNode: _usernameFocus,
//                 autocorrect: false,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
//                 ],
//                 decoration: const InputDecoration(
//                   hintText: 'arif_hossain',
//                   prefixIcon: Icon(Icons.alternate_email_rounded, size: 18),
//                 ),
//                 onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//               ),

//               SizedBox(height: tokens.s16),

//               // Email
//               const _FieldLabel('Email'),
//               SizedBox(height: tokens.s6),
//               TextField(
//                 controller: _emailCtrl,
//                 keyboardType: TextInputType.emailAddress,
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   hintText: 'you@example.com',
//                   prefixIcon: Icon(Icons.email_outlined, size: 18),
//                 ),
//                 onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//               ),

//               SizedBox(height: tokens.s16),

//               // Age
//               const _FieldLabel('Age'),
//               SizedBox(height: tokens.s6),
//               TextField(
//                 controller: _ageCtrl,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 decoration: const InputDecoration(
//                   hintText: '25',
//                   prefixIcon: Icon(Icons.cake_outlined, size: 18),
//                 ),
//                 onSubmitted: (_) => FocusScope.of(context).unfocus(),
//               ),

//               SizedBox(height: tokens.s16),

//               // Gender
//               const _FieldLabel('Gender'),
//               SizedBox(height: tokens.s10),
//               Wrap(
//                 spacing: tokens.s8,
//                 runSpacing: tokens.s8,
//                 children: _genders.map((g) => FilterChip(
//                   label: Text(g),
//                   selected: _selectedGender == g,
//                   onSelected: isLoading
//                       ? null
//                       : (_) => setState(() => _selectedGender = g),
//                 )).toList(),
//               ),

//               if (error != null) ...[
//                 SizedBox(height: tokens.s12),
//                 _ErrorBanner(error),
//               ],

//               SizedBox(height: tokens.s24),

//               // Send OTP button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : _sendOtp,
//                   child: isLoading
//                       ? const SizedBox(
//                           width: 20, height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text('Send OTP'),
//                 ),
//               ),

//               SizedBox(height: tokens.s24),

//               // Login link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Already have an account?',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: cs.onSurfaceVariant,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: isLoading
//                         ? null
//                         : () {
//                             ref.read(authNotifierProvider.notifier).reset();
//                             context.go(AppRoutes.auth);
//                           },
//                     child: const Text('Log in'),
//                   ),
//                 ],
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
//           ),
//         ),
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

// class _FieldLabel extends StatelessWidget {
//   const _FieldLabel(this.label);
//   final String label;

//   @override
//   Widget build(BuildContext context) => Text(
//     label,
//     style: Theme.of(context).textTheme.labelMedium?.copyWith(
//       color: Theme.of(context).colorScheme.onSurface,
//     ),
//   );
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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/app_logo.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_notifier.dart';
import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

const _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _fullNameCtrl  = TextEditingController();
  final _usernameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _ageCtrl       = TextEditingController();
  final _fullNameFocus = FocusNode();
  bool _obscurePassword = true;
  String? _selectedGender;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fullNameFocus.requestFocus());
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _ageCtrl.dispose();
    _fullNameFocus.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() => _validationError = null);

    final fullName = _fullNameCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final ageStr   = _ageCtrl.text.trim();
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

    if (fullName.isEmpty) {
      setState(() => _validationError = 'Please enter your full name');
      return false;
    }
    if (username.isEmpty) {
      setState(() => _validationError = 'Please enter a username');
      return false;
    }
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      setState(() => _validationError = 'Please enter a valid email address');
      return false;
    }
    if (password.length < 8) {
      setState(() => _validationError = 'Password must be at least 8 characters');
      return false;
    }
    if (ageStr.isEmpty) {
      setState(() => _validationError = 'Please enter your age');
      return false;
    }
    if (_selectedGender == null) {
      setState(() => _validationError = 'Please select your gender');
      return false;
    }
    return true;
  }

  void _sendOtp() {
    if (!_validateForm()) return;

    ref.read(authNotifierProvider.notifier).sendOtp(
          contact:  _emailCtrl.text.trim(),
          fullName: _fullNameCtrl.text.trim(),
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
          groupId:  1,
          age:      _ageCtrl.text.trim(),
          gender:   _selectedGender!,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthOtpSent) context.go(AppRoutes.otp);
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;
    
    // Determine which error to show: Local validation or Server error
    final backendError = authState is AuthError ? authState.message : null;
    final displayError = _validationError ?? backendError;

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: tokens.s24, vertical: tokens.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to top
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Back button pinned to the left
              Align(
                alignment: Alignment.centerLeft,
                child: _CircleIconBtn(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    ref.read(authNotifierProvider.notifier).reset();
                    context.go(AppRoutes.auth);
                  },
                ),
              ),
              
              SizedBox(height: tokens.s24),

              // 2. Header
              Row(
                children: [
                  const AppLogo(size: 36),
                  SizedBox(width: tokens.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create account', style: theme.textTheme.headlineMedium),
                      Text(
                        'Start saving on every swipe',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),

              SizedBox(height: tokens.s32),

              // 3. Full Name
              const _FieldLabel('Full Name'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _fullNameCtrl,
                focusNode: _fullNameFocus,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() => _validationError = null),
                decoration: const InputDecoration(
                  hintText: 'Arif Hossain',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                ),
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),

              SizedBox(height: tokens.s16),

              // 4. Username
              const _FieldLabel('Username'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _usernameCtrl,
                autocorrect: false,
                onChanged: (_) => setState(() => _validationError = null),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'arif_hossain',
                  prefixIcon: Icon(Icons.alternate_email_rounded, size: 18),
                ),
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),

              SizedBox(height: tokens.s16),

              // 5. Email
              const _FieldLabel('Email'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (_) => setState(() => _validationError = null),
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 18),
                ),
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),

              SizedBox(height: tokens.s16),

              // 6. Password
              const _FieldLabel('Password'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                onChanged: (_) => setState(() => _validationError = null),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),

              SizedBox(height: tokens.s16),

              // 8. Age Field
              const _FieldLabel('Age'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() => _validationError = null),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '25',
                  prefixIcon: Icon(Icons.cake_outlined, size: 18),
                ),
              ),

              SizedBox(height: tokens.s16),

              // 9. Gender Selection (Yellow Theme)
              const _FieldLabel('Gender'),
              SizedBox(height: tokens.s10),
              Wrap(
                spacing: tokens.s8,
                runSpacing: tokens.s8,
                children: _genders.map((g) {
                  final isSelected = _selectedGender == g;
                  return FilterChip(
                    label: Text(g),
                    selected: isSelected,
                    onSelected: isLoading
                        ? null
                        : (_) {
                            setState(() {
                              _selectedGender = g;
                              _validationError = null;
                            });
                          },
                    selectedColor: const Color(0xFFFEF9C3), // Light Yellow
                    checkmarkColor: const Color(0xFF854D0E), // Amber
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected ? const Color(0xFF854D0E) : cs.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFFDE047) : cs.outlineVariant,
                      width: 1,
                    ),
                  );
                }).toList(),
              ),

              // 10. Validation / Server Error Banner
              if (displayError != null) ...[
                SizedBox(height: tokens.s16),
                _ErrorBanner(displayError),
              ],

              SizedBox(height: tokens.s24),

              // 11. Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _sendOtp,
                  child: isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send OTP'),
                ),
              ),

              SizedBox(height: tokens.s24),

              // 12. Bottom Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            ref.read(authNotifierProvider.notifier).reset();
                            context.go(AppRoutes.auth);
                          },
                    child: const Text('Log in'),
                  ),
                ],
              ),

              SizedBox(height: tokens.s8),

              Text(
                '🔒 We never share your data or ask for card credentials.',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 16, color: cs.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12, color: cs.onErrorContainer, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}