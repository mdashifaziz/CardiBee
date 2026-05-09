import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/widgets/credit_card_visual.dart';
import 'package:cardibee_flutter/core/widgets/network_logo.dart';
import 'package:cardibee_flutter/features/cards/domain/models/user_card.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';

// ── Wizard state ──────────────────────────────────────────────────────────────

class _WizardState {
  const _WizardState({
    this.step = 0,
    this.bankId,
    this.bankName,
    this.cardTypeId,
    this.productName,
    this.network = 'Visa',
    this.type = 'credit',
    this.nickname = '',
    this.lastDigits = '',
    this.gradient = 'navy',
  });
  final int step;
  final String? bankId;
  final String? bankName;
  final String? cardTypeId;
  final String? productName;
  final String network;
  final String type;
  final String nickname;
  final String lastDigits;
  final String gradient;

  _WizardState copyWith({
    int? step, String? bankId, String? bankName,
    String? cardTypeId, String? productName,
    String? network, String? type,
    String? nickname, String? lastDigits, String? gradient,
  }) => _WizardState(
    step:        step        ?? this.step,
    bankId:      bankId      ?? this.bankId,
    bankName:    bankName    ?? this.bankName,
    cardTypeId:  cardTypeId  ?? this.cardTypeId,
    productName: productName ?? this.productName,
    network:     network     ?? this.network,
    type:        type        ?? this.type,
    nickname:    nickname    ?? this.nickname,
    lastDigits:  lastDigits  ?? this.lastDigits,
    gradient:    gradient    ?? this.gradient,
  );
}

// ── Screen ────────────────────────────────────────────────────────────────────

class AddCardScreen extends ConsumerStatefulWidget {
  const AddCardScreen({super.key});

  @override
  ConsumerState<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends ConsumerState<AddCardScreen> {
  _WizardState _w = const _WizardState();
  final _nickCtrl   = TextEditingController();
  final _digitsCtrl = TextEditingController();
  bool _saving = false;

  static const _stepLabels = ['Bank', 'Product', 'Details', 'Style'];
  static const _gradients  = ['navy', 'emerald', 'burgundy', 'graphite'];

  @override
  void dispose() {
    _nickCtrl.dispose();
    _digitsCtrl.dispose();
    super.dispose();
  }

  void _back() {
    if (_w.step == 0) {
      context.pop();
    } else {
      setState(() => _w = _w.copyWith(step: _w.step - 1));
    }
  }

  Future<void> _save() async {
    if (_w.bankId == null || _w.cardTypeId == null) return;
    setState(() => _saving = true);
    await ref.read(cardsNotifierProvider.notifier).addCard(
      bankId:     _w.bankId!,
      cardTypeId: _w.cardTypeId!,
      type:       _w.type,
      nickname:   _nickCtrl.text.trim().isEmpty ? null : _nickCtrl.text.trim(),
      lastDigits: _digitsCtrl.text.trim().isEmpty ? null : _digitsCtrl.text.trim(),
      gradient:   _w.gradient,
    );
    if (mounted) context.go(AppRoutes.cards);
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s8, tokens.s20, 0),
              child: Row(
                children: [
                  _CircleBtn(
                    icon: Icons.arrow_back_rounded,
                    onTap: _back,
                    bg: cs.surfaceContainerLow,
                    fg: cs.onSurface,
                  ),
                  SizedBox(width: tokens.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${_w.step + 1} of ${_stepLabels.length}',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      Text('Add a new card', style: theme.textTheme.headlineSmall),
                    ],
                  ),
                ],
              ),
            ),
            // Progress bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.s20, vertical: tokens.s12),
              child: Row(
                children: List.generate(_stepLabels.length, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: i < _stepLabels.length - 1
                          ? EdgeInsets.only(right: tokens.s4)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: i <= _w.step ? cs.primary : cs.outlineVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Step body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    tokens.s20, tokens.s4, tokens.s20, tokens.s24),
                child: switch (_w.step) {
                  0 => _StepBank(
                    selected: _w.bankId,
                    onSelect: (id, name) => setState(() =>
                        _w = _w.copyWith(bankId: id, bankName: name, step: 1)),
                  ),
                  1 => _StepProduct(
                    bankId: _w.bankId!,
                    selected: _w.cardTypeId,
                    onSelect: (ctId, pName, network) => setState(() => _w = _w.copyWith(
                      cardTypeId: ctId,
                      productName: pName,
                      network: network,
                      step: 2,
                    )),
                  ),
                  2 => _StepDetails(
                    w: _w,
                    nickCtrl: _nickCtrl,
                    digitsCtrl: _digitsCtrl,
                    onNetworkChanged: (n) => setState(() => _w = _w.copyWith(network: n)),
                    onTypeChanged:    (t) => setState(() => _w = _w.copyWith(type: t)),
                    onContinue: () => setState(() => _w = _w.copyWith(step: 3)),
                  ),
                  _ => _StepStyle(
                    w: _w,
                    nickCtrl: _nickCtrl,
                    digitsCtrl: _digitsCtrl,
                    gradients: _gradients,
                    saving: _saving,
                    onGradientChanged: (g) => setState(() => _w = _w.copyWith(gradient: g)),
                    onSave: _save,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Bank ──────────────────────────────────────────────────────────────

class _StepBank extends ConsumerWidget {
  const _StepBank({required this.selected, required this.onSelect});
  final String? selected;
  final void Function(String id, String name) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final banks  = ref.watch(banksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose your bank', style: theme.textTheme.headlineSmall),
        SizedBox(height: tokens.s16),
        banks.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ApiUnavailable(onRetry: () => ref.invalidate(banksProvider)),
          data: (list) => list.isEmpty
              ? const _ApiUnavailable()
              : Column(
            children: list.map((b) {
              final active = selected == b.id;
              return Padding(
                padding: EdgeInsets.only(bottom: tokens.s8),
                child: GestureDetector(
                  onTap: () => onSelect(b.id, b.shortCode),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.all(tokens.s16),
                    decoration: BoxDecoration(
                      color: active
                          ? cs.tertiary.withOpacity(0.1)
                          : cs.surfaceContainerLowest,
                      border: Border.all(
                        color: active ? cs.primary : cs.outlineVariant,
                        width: active ? 1.5 : 1,
                      ),
                      borderRadius: tokens.brLg,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: tokens.brMd,
                          ),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                b.shortCode,
                                style: TextStyle(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: tokens.s12),
                        Expanded(
                          child: Text(b.name, style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                        ),
                        if (active)
                          Icon(Icons.check_circle_rounded,
                              color: cs.primary, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Step 2: Product ───────────────────────────────────────────────────────────

class _StepProduct extends ConsumerWidget {
  const _StepProduct({
    required this.bankId,
    required this.selected,
    required this.onSelect,
  });
  final String bankId;
  final String? selected;
  final void Function(String id, String name, String network) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;
    final types  = ref.watch(cardTypesProvider(bankId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick your card product', style: theme.textTheme.headlineSmall),
        SizedBox(height: tokens.s16),
        types.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ApiUnavailable(onRetry: () => ref.invalidate(cardTypesProvider(bankId))),
          data: (list) => list.isEmpty
              ? const _ApiUnavailable()
              : Column(
            children: list.map((ct) {
              final active = selected == ct.id;
              return Padding(
                padding: EdgeInsets.only(bottom: tokens.s8),
                child: GestureDetector(
                  onTap: () => onSelect(ct.id, ct.productName, ct.network),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.all(tokens.s16),
                    decoration: BoxDecoration(
                      color: active
                          ? cs.tertiary.withOpacity(0.1)
                          : cs.surfaceContainerLowest,
                      border: Border.all(
                        color: active ? cs.primary : cs.outlineVariant,
                        width: active ? 1.5 : 1,
                      ),
                      borderRadius: tokens.brLg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(ct.productName,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                        ),
                        NetworkLogo(network: ct.network, size: 'sm'),
                        if (active) ...[
                          SizedBox(width: tokens.s8),
                          Icon(Icons.check_circle_rounded,
                              color: cs.primary, size: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Step 3: Details ───────────────────────────────────────────────────────────

class _StepDetails extends StatelessWidget {
  const _StepDetails({
    required this.w,
    required this.nickCtrl,
    required this.digitsCtrl,
    required this.onNetworkChanged,
    required this.onTypeChanged,
    required this.onContinue,
  });
  final _WizardState w;
  final TextEditingController nickCtrl;
  final TextEditingController digitsCtrl;
  final ValueChanged<String> onNetworkChanged;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card details', style: theme.textTheme.headlineSmall),
        SizedBox(height: tokens.s20),

        // Network
        Text('Network', style: theme.textTheme.labelMedium),
        SizedBox(height: tokens.s8),
        Row(
          children: ['Visa', 'Mastercard', 'Amex'].map((n) {
            final active = w.network == n;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: n != 'Amex' ? tokens.s8 : 0),
                child: GestureDetector(
                  onTap: () => onNetworkChanged(n),
                  child: AnimatedContainer(
                    duration: 150.ms,
                    height: 56,
                    decoration: BoxDecoration(
                      color: active ? cs.primary : cs.surfaceContainerLowest,
                      border: Border.all(
                          color: active ? cs.primary : cs.outlineVariant),
                      borderRadius: tokens.brMd,
                    ),
                    alignment: Alignment.center,
                    child: NetworkLogo(
                        network: n,
                        size: active ? 'md' : 'sm'),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: tokens.s20),

        // Type
        Text('Type', style: theme.textTheme.labelMedium),
        SizedBox(height: tokens.s8),
        Row(
          children: ['credit', 'debit'].map((t) {
            final active = w.type == t;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: t == 'credit' ? tokens.s8 : 0),
                child: GestureDetector(
                  onTap: () => onTypeChanged(t),
                  child: AnimatedContainer(
                    duration: 150.ms,
                    height: 48,
                    decoration: BoxDecoration(
                      color: active ? cs.primary : cs.surfaceContainerLowest,
                      border: Border.all(
                          color: active ? cs.primary : cs.outlineVariant),
                      borderRadius: tokens.brMd,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t[0].toUpperCase() + t.substring(1),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: active ? cs.onPrimary : cs.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: tokens.s20),

        // Nickname
        Text('Nickname (optional)', style: theme.textTheme.labelMedium),
        SizedBox(height: tokens.s8),
        TextField(
          controller: nickCtrl,
          decoration: const InputDecoration(hintText: 'e.g. Daily Driver'),
          textCapitalization: TextCapitalization.words,
          maxLength: 30,
          buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) => null,
        ),
        SizedBox(height: tokens.s16),

        // Last 4–6 digits
        Text('Last 4–6 digits (optional)', style: theme.textTheme.labelMedium),
        SizedBox(height: tokens.s8),
        TextField(
          controller: digitsCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: const InputDecoration(
            hintText: '0000',
            // monospace feel
          ),
          style: const TextStyle(fontFamily: 'monospace', letterSpacing: 4),
        ),
        Padding(
          padding: EdgeInsets.only(top: tokens.s6),
          child: Text(
            '🔒 We never ask for full card numbers, CVV or PIN.',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        SizedBox(height: tokens.s24),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onContinue,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

// ── Step 4: Style ─────────────────────────────────────────────────────────────

class _StepStyle extends StatelessWidget {
  const _StepStyle({
    required this.w,
    required this.nickCtrl,
    required this.digitsCtrl,
    required this.gradients,
    required this.saving,
    required this.onGradientChanged,
    required this.onSave,
  });
  final _WizardState w;
  final TextEditingController nickCtrl;
  final TextEditingController digitsCtrl;
  final List<String> gradients;
  final bool saving;
  final ValueChanged<String> onGradientChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    // Build preview card
    final previewCard = UserCard(
      id: 'preview',
      bankId: w.bankId ?? '',
      bankName: w.bankName ?? 'Bank',
      cardTypeId: w.cardTypeId ?? '',
      productName: w.productName ?? 'Card',
      network: w.network,
      type: w.type,
      nickname: nickCtrl.text.trim().isEmpty ? null : nickCtrl.text.trim(),
      lastDigits: digitsCtrl.text.trim().isEmpty ? null : digitsCtrl.text.trim(),
      gradient: w.gradient,
      createdAt: '',
    );

    final gradientColors = {
      'navy':     AppColors.gradientNavy,
      'emerald':  AppColors.gradientEmerald,
      'burgundy': AppColors.gradientBurgundy,
      'graphite': AppColors.gradientGraphite,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick a style', style: theme.textTheme.headlineSmall),
        SizedBox(height: tokens.s20),

        // Live preview
        Center(
          child: CreditCardVisual(card: previewCard, size: CardSize.lg),
        ),
        SizedBox(height: tokens.s20),

        // Gradient picker
        Row(
          children: gradients.map((g) {
            final active = w.gradient == g;
            final colors = gradientColors[g]!;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: g != gradients.last ? tokens.s8 : 0),
                child: GestureDetector(
                  onTap: () => onGradientChanged(g),
                  child: AnimatedContainer(
                    duration: 150.ms,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: tokens.brMd,
                      border: Border.all(
                        color: active ? cs.primary : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: active
                        ? Icon(Icons.check_rounded,
                            color: Colors.white, size: 20)
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: tokens.s24),

        // Save button (accent yellow)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: saving ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.tertiary,
              foregroundColor: cs.onTertiary,
            ),
            icon: saving
                ? SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: cs.onTertiary))
                : const Icon(Icons.check_rounded, size: 18),
            label: const Text('Save card'),
          ),
        ),
      ],
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────

class _ApiUnavailable extends StatelessWidget {
  const _ApiUnavailable({this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 40, color: cs.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'Could not load data.\nCheck that your backend is running.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({
    required this.icon,
    required this.onTap,
    required this.bg,
    required this.fg,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: fg),
    ),
  );
}
