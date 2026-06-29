import 'package:flutter/material.dart';
import 'package:cardibee_flutter/core/theme/app_tokens.dart';

/// Makes a non-scrolling [child] over-scrollable so a parent [RefreshIndicator]
/// can trigger a pull-to-refresh even on empty / error states.
class ScrollFill extends StatelessWidget {
  const ScrollFill({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, c) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: c.maxHeight),
            child: child,
          ),
        ),
      );
}

/// Centered error "popup" card with a Try again button.
///
/// Sits in the middle of its parent (not pinned to the bottom). Wrap in a
/// scrollable with [AlwaysScrollableScrollPhysics] if you want pull-to-refresh
/// to work while this is shown.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    required this.onRetry,
    this.title = 'Couldn\'t load',
    this.message,
    super.key,
  });

  final VoidCallback onRetry;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final tokens = theme.tokens;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.s24),
        child: Container(
          padding: EdgeInsets.all(tokens.s24),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: tokens.brXl,
            border: Border.all(color: cs.outlineVariant),
            boxShadow: tokens.shadowMd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: cs.error.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.cloud_off_rounded, size: 32, color: cs.error),
              ),
              SizedBox(height: tokens.s16),
              Text(title, style: theme.textTheme.titleMedium),
              SizedBox(height: tokens.s8),
              Text(
                message ?? 'The server may be waking up. Pull down or tap to retry.',
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.s20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try again'),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
