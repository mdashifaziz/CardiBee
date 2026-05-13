import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cardibee_flutter/core/network/api_endpoints.dart';
import 'package:cardibee_flutter/core/network/dio_client.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/core/theme/app_colors.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';
import 'package:cardibee_flutter/core/theme/app_typography.dart';
import 'package:cardibee_flutter/core/theme/theme_provider.dart';
import 'package:cardibee_flutter/features/auth/domain/models/user_profile.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/cards/providers/cards_notifier.dart';
import 'package:cardibee_flutter/features/offers/providers/favorites_notifier.dart';
import 'package:cardibee_flutter/features/offers/providers/offers_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchProfile());
  }

  Future<void> _fetchProfile() async {
    try {
      final dio = ref.read(dioProvider);
      final res  = await dio.get<dynamic>(ApiEndpoints.profile);
      final body = res.data;
      final data = body is Map<String, dynamic>
          ? ((body['data'] as Map<String, dynamic>?) ?? body)
          : null;
      if (data != null && mounted) {
        ref.read(currentUserProvider.notifier).state = UserProfile.fromJson(data);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme      = Theme.of(context);
    final cs         = theme.colorScheme;
    final tokens     = theme.tokens;
    final user       = ref.watch(currentUserProvider);
    final themeMode  = ref.watch(themeProvider);
    final isDark     = themeMode == ThemeMode.dark;
    final cards      = ref.watch(cardsNotifierProvider).valueOrNull ?? [];
    final savedCount = ref.watch(favoritesProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: tokens.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s8, tokens.s20, 0),
                child: Row(
                  children: [
                    Expanded(child: Text('Profile', style: theme.textTheme.headlineLarge)),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      tooltip: 'Edit profile',
                      onPressed: () => _showEditSheet(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: tokens.s16),

              // ── Hero card ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: Container(
                  padding: EdgeInsets.all(tokens.s20),
                  decoration: BoxDecoration(
                    gradient: tokens.gradientHero,
                    borderRadius: tokens.brXl,
                    boxShadow: tokens.shadowLg,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _AvatarCircle(
                            radius: 28,
                            url: user?.avatarUrl,
                            backgroundColor: AppColors.beeYellow,
                            fallbackText: user?.initials ?? '?',
                            fallbackStyle: TextStyle(
                              fontFamily: AppFonts.display,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyDeep,
                            ),
                          ),
                          SizedBox(width: tokens.s16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'CardiBee User',
                                style: const TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              if (user?.username != null)
                                Text(
                                  '@${user!.username}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                )
                              else if (user?.phone != null)
                                Text(
                                  user!.phone!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.s20),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      SizedBox(height: tokens.s16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCol(
                            value: '${cards.length}',
                            label: 'Cards',
                          ),
                          _StatCol(
                            value: '$savedCount',
                            label: 'Saved',
                          ),
                          _StatCol(
                            value: '৳${_fmt(user?.savingsYtdBdt ?? 0)}',
                            label: 'Saved YTD',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: tokens.s16),

              // ── Dark mode toggle ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: GestureDetector(
                  onTap: () => ref.read(themeProvider.notifier).toggle(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: tokens.s16, vertical: tokens.s12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: tokens.brLg,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: cs.tertiary.withOpacity(0.15),
                            borderRadius: tokens.brMd,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            size: 18, color: cs.tertiary,
                          ),
                        ),
                        SizedBox(width: tokens.s12),
                        Expanded(
                          child: Text(
                            isDark ? 'Light mode' : 'Dark mode',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          isDark ? 'On' : 'Off',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: tokens.s12),

              // ── Settings menu ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLowest,
                    borderRadius: tokens.brLg,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Builder(builder: (context) {
                    final items = _menuItems(context, cards.length, savedCount);
                    return Column(
                      children: List.generate(items.length, (i) {
                        final item = items[i];
                        return _MenuItem(
                          icon:    item.$1,
                          label:   item.$2,
                          badge:   item.$3,
                          onTap:   item.$4,
                          divider: i < items.length - 1,
                        );
                      }),
                    );
                  }),
                ),
              ),

              SizedBox(height: tokens.s12),

              // ── Logout ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.s20),
                child: GestureDetector(
                  onTap: () => _logout(context),
                  child: Container(
                    padding: EdgeInsets.all(tokens.s16),
                    decoration: BoxDecoration(
                      color: cs.errorContainer.withOpacity(0.3),
                      borderRadius: tokens.brLg,
                      border: Border.all(
                          color: cs.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            size: 18, color: cs.error),
                        SizedBox(width: tokens.s8),
                        Text(
                          'Log out',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: tokens.s24),

              // Version
              Center(
                child: Text(
                  'CardiBee v1.0 · Made in 🇧🇩',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<(IconData, String, String?, VoidCallback?)> _menuItems(
    BuildContext context,
    int cardCount,
    int savedCount,
  ) => [
    (Icons.credit_card_rounded,       'My cards',           '$cardCount',                          () => context.go(AppRoutes.cards)),
    (Icons.compare_arrows_rounded,    'Compare cards',      null,                                  () => context.push(AppRoutes.compare)),
    (Icons.favorite_border_rounded,   'Favorites',          savedCount > 0 ? '$savedCount' : null, () => context.push(AppRoutes.favorites)),
    (Icons.notifications_outlined,    'Notifications',      null,         () => context.push(AppRoutes.notifications)),
    (Icons.shield_outlined,           'Privacy & security', null,         null),
    (Icons.description_outlined,      'Terms of service',   null,         () => context.push(AppRoutes.terms)),
    (Icons.info_outline_rounded,      'About CardiBee',     null,         () => context.push(AppRoutes.about)),
  ];

  void _showEditSheet(BuildContext context) {
    final user = ref.read(currentUserProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        initialName:      user?.fullName ?? '',
        initialAvatarUrl: user?.avatarUrl,
        onSaved: (name, avatarUrl, raw) {
          final updated = raw != null
              ? UserProfile.fromJson(raw)
              : user?.copyWith(fullName: name, avatarUrl: avatarUrl);
          ref.read(currentUserProvider.notifier).state = updated;
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await ref.read(tokenStorageProvider).clearTokens();
    ref.read(currentUserProvider.notifier).state = null;
    if (context.mounted) context.go(AppRoutes.auth);
  }

  static String _fmt(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toString();
  }
}

// ── Edit profile bottom sheet ─────────────────────────────────────────────────

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet({
    required this.initialName,
    required this.initialAvatarUrl,
    required this.onSaved,
  });
  final String initialName;
  final String? initialAvatarUrl;
  final void Function(String name, String? avatarUrl, Map<String, dynamic>? raw) onSaved;

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  File? _pickedImage;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Name cannot be empty.');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final dio = ref.read(dioProvider);
      String? newAvatarUrl = widget.initialAvatarUrl;

      Response<dynamic> res;
      if (_pickedImage != null) {
        final formData = FormData.fromMap({
          'full_name': name,
          'avatar': await MultipartFile.fromFile(
            _pickedImage!.path,
            filename: 'avatar.jpg',
          ),
        });
        res = await dio.patch<dynamic>(
          ApiEndpoints.profile,
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );
      } else {
        res = await dio.patch<dynamic>(ApiEndpoints.profile, data: {'full_name': name});
      }

      final raw  = res.data;
      final body = raw is Map<String, dynamic>
          ? ((raw['data'] as Map<String, dynamic>?) ?? raw)
          : null;
      if (body != null) newAvatarUrl = body['avatar_url'] as String?;
      widget.onSaved(name, newAvatarUrl, body);
      if (mounted) Navigator.pop(context);
    } on DioException catch (e) {
      final body = e.response?.data;
      final msg  = (body is Map ? (body['detail'] ?? body['message']) : null)
                   as String? ?? 'Failed to save. Try again.';
      setState(() => _error = msg);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(tokens.s20, tokens.s16, tokens.s20, tokens.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: tokens.s16),
            Text('Edit profile', style: theme.textTheme.titleLarge),
            SizedBox(height: tokens.s24),

            // Avatar picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    _AvatarCircle(
                      radius: 44,
                      url: widget.initialAvatarUrl,
                      file: _pickedImage,
                      backgroundColor: AppColors.beeYellow,
                      fallbackText: widget.initialName.isNotEmpty
                          ? widget.initialName[0].toUpperCase()
                          : '?',
                      fallbackStyle: TextStyle(
                        fontFamily: AppFonts.display,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navyDeep,
                      ),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.surface, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.camera_alt_rounded, size: 14, color: cs.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: tokens.s20),

            TextField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
              ),
            ),
            if (_error != null) ...[
              SizedBox(height: tokens.s8),
              Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: cs.error)),
            ],
            SizedBox(height: tokens.s20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    ],
  );
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.divider,
    this.badge,
  });
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: tokens.s16, vertical: tokens.s12),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: tokens.brMd,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18, color: cs.onSurface),
                ),
                SizedBox(width: tokens.s12),
                Expanded(
                  child: Text(label, style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
                ),
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.tertiary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cs.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.s8),
                ],
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
        if (divider) Divider(height: 1, color: cs.outlineVariant),
      ],
    );
  }
}

// Circle avatar with graceful fallback when a network image 404s or fails to load.
class _AvatarCircle extends StatefulWidget {
  const _AvatarCircle({
    required this.radius,
    required this.fallbackText,
    required this.fallbackStyle,
    this.url,
    this.file,
    this.backgroundColor,
  });

  final double radius;
  final String fallbackText;
  final TextStyle fallbackStyle;
  final String? url;
  final File? file;
  final Color? backgroundColor;

  @override
  State<_AvatarCircle> createState() => _AvatarCircleState();
}

class _AvatarCircleState extends State<_AvatarCircle> {
  bool _networkFailed = false;

  @override
  void didUpdateWidget(_AvatarCircle old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) _networkFailed = false;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    var isNetwork = false;
    if (widget.file != null) {
      image = FileImage(widget.file!);
    } else if (widget.url != null && !_networkFailed) {
      image = NetworkImage(widget.url!);
      isNetwork = true;
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      backgroundImage: image,
      onBackgroundImageError: isNetwork
          ? (_, __) {
              if (mounted) setState(() => _networkFailed = true);
            }
          : null,
      child: image == null
          ? Text(widget.fallbackText, style: widget.fallbackStyle)
          : null,
    );
  }
}
