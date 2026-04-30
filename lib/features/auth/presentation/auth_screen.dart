import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';
import 'package:cardibee_flutter/core/widgets/app_logo.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_notifier.dart';
import 'package:cardibee_flutter/features/auth/state/auth_state.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({this.initialMode = 'signup', super.key});
  final String initialMode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late String _mode;
  final _phoneCtrl = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _otpCtrl   = TextEditingController();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocus.requestFocus();
      // Reset any previous auth state
      ref.read(authNotifierProvider.notifier).backToPhone();
    });
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _nameCtrl.dispose();
    _otpCtrl.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Navigate on success
    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthSuccess) {
        ref.read(prefsStorageProvider).setOnboarded(true);
        context.go(AppRoutes.home);
      }
    });

    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: 350.ms,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
          ),
          child: switch (authState) {
            AuthOtpSent(:final requestId, :final maskedPhone, :final isSignup, :final error) =>
              _OtpView(
                key: const ValueKey('otp'),
                requestId: requestId,
                maskedPhone: maskedPhone,
                isSignup: isSignup,
                inlineError: error,
                nameCtrl: _nameCtrl,
                otpCtrl: _otpCtrl,
                onBack: () => ref.read(authNotifierProvider.notifier).backToPhone(),
                onVerify: (otp) => ref.read(authNotifierProvider.notifier).verifyOtp(
                  requestId: requestId,
                  otp: otp,
                  fullName: isSignup ? _nameCtrl.text.trim() : null,
                ),
                onResend: () => ref.read(authNotifierProvider.notifier).requestOtp(
                  phone: _phoneCtrl.text.trim(),
                  isSignup: isSignup,
                ),
                isLoading: false,
              ),
            AuthLoading() => _PhoneView(
              key: const ValueKey('phone_loading'),
              mode: _mode,
              phoneCtrl: _phoneCtrl,
              nameCtrl: _nameCtrl,
              phoneFocus: _phoneFocus,
              isLoading: true,
              error: null,
              onModeSwitch: (_) {},
              onSend: () {},
            ),
            AuthError(:final message) => _PhoneView(
              key: const ValueKey('phone_err'),
              mode: _mode,
              phoneCtrl: _phoneCtrl,
              nameCtrl: _nameCtrl,
              phoneFocus: _phoneFocus,
              isLoading: false,
              error: message,
              onModeSwitch: (m) => setState(() => _mode = m),
              onSend: _sendOtp,
            ),
            _ => _PhoneView(
              key: const ValueKey('phone'),
              mode: _mode,
              phoneCtrl: _phoneCtrl,
              nameCtrl: _nameCtrl,
              phoneFocus: _phoneFocus,
              isLoading: false,
              error: null,
              onModeSwitch: (m) => setState(() => _mode = m),
              onSend: _sendOtp,
            ),
          },
        ),
      ),
    );
  }

  void _sendOtp() {
    final phone = _phoneCtrl.text.trim();
    if (phone.length < 10) return;
    ref.read(authNotifierProvider.notifier).requestOtp(
      phone: phone,
      isSignup: _mode == 'signup',
    );
  }
}

// ── Phone entry view ──────────────────────────────────────────────────────────

class _PhoneView extends StatelessWidget {
  const _PhoneView({
    required this.mode,
    required this.phoneCtrl,
    required this.nameCtrl,
    required this.phoneFocus,
    required this.isLoading,
    required this.error,
    required this.onModeSwitch,
    required this.onSend,
    super.key,
  });

  final String mode;
  final TextEditingController phoneCtrl;
  final TextEditingController nameCtrl;
  final FocusNode phoneFocus;
  final bool isLoading;
  final String? error;
  final ValueChanged<String> onModeSwitch;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final isSignup = mode == 'signup';

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(tokens.s24, tokens.s8, tokens.s24, tokens.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          _CircleIconBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          SizedBox(height: tokens.s24),

          // Logo + heading
          Row(
            children: [
              const AppLogo(size: 36),
              SizedBox(width: tokens.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSignup ? 'Create your account' : 'Welcome back',
                    style: theme.textTheme.headlineMedium,
                  ),
                  Text(
                    isSignup ? 'Start saving on every swipe' : 'Log in to see your deals',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: tokens.s32),

          // Name field (signup only)
          if (isSignup) ...[
            _FieldLabel('Full name'),
            SizedBox(height: tokens.s6),
            TextField(
              controller: nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Arif Hossain',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
              ),
            ),
            SizedBox(height: tokens.s16),
          ],

          // Phone field
          _FieldLabel('Mobile number'),
          SizedBox(height: tokens.s6),
          TextField(
            controller: phoneCtrl,
            focusNode: phoneFocus,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]'))],
            decoration: const InputDecoration(
              hintText: '+880 1X XXXX XXXX',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '🇧🇩',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            onSubmitted: (_) => onSend(),
          ),

          if (error != null) ...[
            SizedBox(height: tokens.s8),
            _ErrorBanner(error!),
          ],

          SizedBox(height: tokens.s24),

          // Send OTP button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSend,
              child: isLoading
                  ? SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary),
                    )
                  : const Text('Send OTP'),
            ),
          ),

          SizedBox(height: tokens.s20),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: cs.outlineVariant)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s12),
                child: Text(
                  'or continue with',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: cs.onSurfaceVariant,
                    fontFamily: AppFonts.sans,
                  ),
                ),
              ),
              Expanded(child: Divider(color: cs.outlineVariant)),
            ],
          ),
          SizedBox(height: tokens.s16),

          // Google SSO (UI only)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: _GoogleIcon(),
              label: const Text('Continue with Google'),
            ),
          ),

          SizedBox(height: tokens.s24),

          // Mode switch
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSignup ? 'Already have an account?' : 'New to CardiBee?',
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              TextButton(
                onPressed: () => onModeSwitch(isSignup ? 'login' : 'signup'),
                child: Text(isSignup ? 'Log in' : 'Sign up'),
              ),
            ],
          ),

          // Security note
          Padding(
            padding: EdgeInsets.only(top: tokens.s8),
            child: Text(
              '🔒 We never share your data or ask for card credentials.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ── OTP verification view ─────────────────────────────────────────────────────

class _OtpView extends StatefulWidget {
  const _OtpView({
    required this.requestId,
    required this.maskedPhone,
    required this.isSignup,
    required this.nameCtrl,
    required this.otpCtrl,
    required this.onBack,
    required this.onVerify,
    required this.onResend,
    required this.isLoading,
    this.inlineError,
    super.key,
  });

  final String requestId;
  final String maskedPhone;
  final bool isSignup;
  final TextEditingController nameCtrl;
  final TextEditingController otpCtrl;
  final VoidCallback onBack;
  final ValueChanged<String> onVerify;
  final VoidCallback onResend;
  final bool isLoading;
  final String? inlineError;

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final List<TextEditingController> _cells =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _foci = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _cells) c.dispose();
    for (final f in _foci) f.dispose();
    super.dispose();
  }

  void _onCellChanged(int i, String val) {
    if (val.length == 1 && i < 5) _foci[i + 1].requestFocus();
    if (val.isEmpty && i > 0)     _foci[i - 1].requestFocus();
    _tryAutoVerify();
  }

  void _tryAutoVerify() {
    final otp = _cells.map((c) => c.text).join();
    if (otp.length == 6) widget.onVerify(otp);
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(tokens.s24, tokens.s8, tokens.s24, tokens.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CircleIconBtn(icon: Icons.arrow_back_rounded, onTap: widget.onBack),
          SizedBox(height: tokens.s24),

          Text('Verify your number', style: theme.textTheme.headlineMedium),
          SizedBox(height: tokens.s8),
          Text(
            'OTP sent to ${widget.maskedPhone}',
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          SizedBox(height: tokens.s32),

          // Name reminder (signup)
          if (widget.isSignup && widget.nameCtrl.text.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(tokens.s12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: tokens.brMd,
              ),
              child: Row(
                children: [
                  Icon(Icons.person_rounded, size: 16, color: cs.tertiary),
                  SizedBox(width: tokens.s8),
                  Text(widget.nameCtrl.text, style: theme.textTheme.labelLarge),
                ],
              ),
            ),
            SizedBox(height: tokens.s20),
          ],

          // 6-cell OTP input
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) => _OtpCell(
              controller: _cells[i],
              focusNode: _foci[i],
              hasError: widget.inlineError != null,
              onChanged: (v) => _onCellChanged(i, v),
            )),
          ),

          if (widget.inlineError != null) ...[
            SizedBox(height: tokens.s8),
            _ErrorBanner(widget.inlineError!),
          ],

          SizedBox(height: tokens.s24),

          // Verify button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : () {
                final otp = _cells.map((c) => c.text).join();
                if (otp.length == 6) widget.onVerify(otp);
              },
              child: widget.isLoading
                  ? SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary),
                    )
                  : const Text('Verify OTP'),
            ),
          ),

          SizedBox(height: tokens.s16),

          // Resend
          Center(
            child: TextButton(
              onPressed: widget.onResend,
              child: const Text('Resend OTP'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpCell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 44,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? cs.error : cs.outlineVariant,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? cs.error : cs.primary,
              width: 2,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: cs.surfaceContainerLow, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, size: 18),
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

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 18, height: 18,
    child: CustomPaint(painter: _GooglePainter()),
  );
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    // Simplified coloured dot approximation — real SVG requires asset
    p.color = const Color(0xFF4285F4);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, p);
    p.color = Colors.white;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 3, p);
  }
  @override bool shouldRepaint(_) => false;
}
