import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/app_logo.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_notifier.dart';
import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _identifierCtrl  = TextEditingController();
  final _passwordCtrl    = TextEditingController();
  final _identifierFocus = FocusNode();
  bool _obscurePassword  = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).reset();
      _identifierFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    _identifierFocus.dispose();
    super.dispose();
  }

  void _login() {
    final id  = _identifierCtrl.text.trim();
    final pwd = _passwordCtrl.text;
    if (id.isEmpty || pwd.isEmpty) return;
    ref.read(authNotifierProvider.notifier).login(
      username: id,
      password: pwd,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthNewUser) context.go(AppRoutes.signup);
      if (next is AuthSuccess) {
        ref.read(prefsStorageProvider).setOnboarded(true);
        context.go(AppRoutes.home);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;
    final error     = authState is AuthError ? authState.message : null;

    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: tokens.s24, vertical: tokens.s24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Header
              Row(
                children: [
                  const AppLogo(size: 36),
                  SizedBox(width: tokens.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: theme.textTheme.headlineMedium),
                      Text(
                        'Log in to see your deals',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),

              SizedBox(height: tokens.s32),

              // Username / Email
              const _FieldLabel('Username or Email'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _identifierCtrl,
                focusNode: _identifierFocus,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'admin or admin@cardibee.app',
                  prefixIcon: Icon(Icons.alternate_email_rounded, size: 18),
                ),
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),

              SizedBox(height: tokens.s16),

              // Password
              const _FieldLabel('Password'),
              SizedBox(height: tokens.s6),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
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
                onSubmitted: (_) => _login(),
              ),

              if (error != null) ...[
                SizedBox(height: tokens.s8),
                _ErrorBanner(error),
              ],

              SizedBox(height: tokens.s24),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Log in'),
                ),
              ),

              SizedBox(height: tokens.s24),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to CardiBee?',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.go(AppRoutes.signup),
                    child: const Text('Sign up'),
                  ),
                ],
              ),

              SizedBox(height: tokens.s8),

              // Privacy note
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 12, color: cs.onErrorContainer),
      ),
    );
  }
}
