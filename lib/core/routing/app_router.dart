import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cardibee_flutter/core/network/dio_client.dart';
import 'package:cardibee_flutter/core/routing/app_routes.dart';
import 'package:cardibee_flutter/core/storage/token_storage.dart';
import 'package:cardibee_flutter/core/storage/prefs_storage.dart';
import 'package:cardibee_flutter/features/auth/presentation/auth_screen.dart';
import 'package:cardibee_flutter/features/auth/presentation/signup_screen.dart';
import 'package:cardibee_flutter/features/auth/presentation/otp_screen.dart';
import 'package:cardibee_flutter/features/auth/providers/auth_provider.dart';
import 'package:cardibee_flutter/features/onboarding/presentation/onboarding_screen.dart';
import 'package:cardibee_flutter/features/splash/presentation/splash_screen.dart';
import 'package:cardibee_flutter/features/home/presentation/home_screen.dart';
import 'package:cardibee_flutter/features/cards/presentation/cards_screen.dart';
import 'package:cardibee_flutter/features/cards/presentation/add_card_screen.dart';
import 'package:cardibee_flutter/features/offers/presentation/my_offers_screen.dart';
import 'package:cardibee_flutter/features/browse/presentation/browse_screen.dart';
import 'package:cardibee_flutter/features/offer_detail/presentation/offer_detail_screen.dart';
import 'package:cardibee_flutter/features/favorites/presentation/favorites_screen.dart';
import 'package:cardibee_flutter/features/profile/presentation/profile_screen.dart';
import 'package:cardibee_flutter/features/best_card/presentation/best_card_screen.dart';
import 'package:cardibee_flutter/features/compare/presentation/compare_screen.dart';
import 'package:cardibee_flutter/features/notifications/presentation/notifications_screen.dart';
import 'package:cardibee_flutter/features/subscription/presentation/subscription_screen.dart';
import 'package:cardibee_flutter/features/terms/presentation/terms_screen.dart';
import 'package:cardibee_flutter/features/about/presentation/about_screen.dart';
import 'package:cardibee_flutter/core/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RefreshListenable();

  ref.listen(isAuthenticatedProvider, (_, __) => notifier.refresh());

  // On expired session: clear user → triggers isAuthenticatedProvider listener
  // → router refresh → redirect kicks user to /auth.
  registerForceLogoutCallback(() {
    ref.read(currentUserProvider.notifier).state = null;
  });

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) async {
      final container  = ProviderScope.containerOf(context);
      final prefs      = container.read(prefsStorageProvider);
      final storage    = container.read(tokenStorageProvider);
      final authed     = container.read(isAuthenticatedProvider) ||
                         await storage.hasTokens();
      final onboarded  = prefs.hasOnboarded;
      final location   = state.matchedLocation;

      final isPreAuth = location == AppRoutes.splash ||
          location == AppRoutes.onboarding ||
          location == AppRoutes.auth ||
          location == AppRoutes.signup ||
          location == AppRoutes.otp;

      if (!onboarded && !isPreAuth) return AppRoutes.onboarding;
      if (!authed   && !isPreAuth) return AppRoutes.auth;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash,     builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.auth,       builder: (_, __) => const AuthScreen()),
      GoRoute(path: AppRoutes.signup,     builder: (_, __) => const SignupScreen()),
      GoRoute(path: AppRoutes.otp,        builder: (_, __) => const OtpScreen()),

      // Bottom-nav shell — all /app/* sub-routes
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/app',
            redirect: (_, __) => AppRoutes.home,
          ),
          GoRoute(path: AppRoutes.home,     builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.myOffers, builder: (_, __) => const MyOffersScreen()),
          GoRoute(
            path: AppRoutes.browse,
            builder: (_, s) => BrowseScreen(
              initialCategory: s.uri.queryParameters['cat'],
            ),
          ),
          GoRoute(path: AppRoutes.cards,   builder: (_, __) => const CardsScreen()),
          GoRoute(path: AppRoutes.addCard, builder: (_, __) => const AddCardScreen()),
          GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
        ],
      ),

      // Full-screen detail routes (no bottom nav)
      GoRoute(
        path: AppRoutes.offerDetail,
        builder: (_, state) =>
            OfferDetailScreen(offerId: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.favorites,     builder: (_, __) => const FavoritesScreen()),
      GoRoute(path: AppRoutes.bestCard,      builder: (_, __) => const BestCardScreen()),
      GoRoute(path: AppRoutes.compare,       builder: (_, __) => const CompareScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: AppRoutes.subscription,  builder: (_, __) => const SubscriptionScreen()),
      GoRoute(path: AppRoutes.terms,         builder: (_, __) => const TermsScreen()),
      GoRoute(path: AppRoutes.about,         builder: (_, __) => const AboutScreen()),
    ],
  );
});

class _RefreshListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}
