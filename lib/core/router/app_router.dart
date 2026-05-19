import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/customer/presentation/pages/customer_home_page.dart';
import '../../features/customer/presentation/pages/providers_list_page.dart';
import '../../features/customer/presentation/pages/provider_details_page.dart';
import '../../features/provider/presentation/pages/provider_home_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../constants/app_constants.dart';

class AppRouter {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String customerHome = '/customer/home';
  static const String providerHome = '/provider/home';
  static const String providersByService = '/customer/providers';
  static const String providerDetails = '/customer/provider-details';
  static const String profile = '/profile';

  static GoRouter router(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final notifier = _AuthStateNotifier(authBloc);
    return GoRouter(
      refreshListenable: notifier,
      initialLocation: splash,
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isLoggedIn = authState is AuthAuthenticated;
        final isLoggingIn =
            state.matchedLocation == login ||
            state.matchedLocation == register ||
            state.matchedLocation == roleSelection ||
            state.matchedLocation == splash;

        if (!isLoggedIn && !isLoggingIn) return roleSelection;
        if (isLoggedIn && isLoggingIn) {
          final role = authState.user.role;
          return role == UserRole.provider ? providerHome : customerHome;
        }
        return null;
      },
      routes: [
        GoRoute(path: splash, builder: (_, _) => const SplashPage()),
        GoRoute(
          path: roleSelection,
          builder: (_, _) => const RoleSelectionPage(),
        ),
        GoRoute(
          path: login,
          builder: (_, state) {
            final role = state.uri.queryParameters['role'] ?? 'customer';
            return LoginPage(role: role);
          },
        ),
        GoRoute(
          path: register,
          builder: (_, state) {
            final role = state.uri.queryParameters['role'] ?? 'customer';
            return RegisterPage(role: role);
          },
        ),
        GoRoute(
          path: customerHome,
          builder: (_, __) => const CustomerHomePage(),
        ),
        GoRoute(
          path: providersByService,
          builder: (_, state) {
            final service = state.uri.queryParameters['service'] ?? 'Service';
            return ProvidersListPage(service: service);
          },
        ),
        GoRoute(
          path: providerDetails,
          builder: (_, state) {
            final uid = state.uri.queryParameters['uid'] ?? '';
            return ProviderDetailsPage(uid: uid);
          },
        ),
        GoRoute(
          path: providerHome,
          builder: (_, __) => const ProviderHomePage(),
        ),
        GoRoute(path: profile, builder: (_, __) => const ProfilePage()),
      ],
    );
  }
}
  
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
