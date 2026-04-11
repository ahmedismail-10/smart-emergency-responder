import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/app_shell_screen.dart';
import '../screens/auth_screens.dart';
import '../screens/onboarding_flow_screen.dart';
import '../screens/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const OnboardingFlowScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),
      GoRoute(
        path: '/forgot/email',
        builder: (_, _) => const ForgotEmailScreen(),
      ),
      GoRoute(path: '/forgot/otp', builder: (_, _) => const ForgotOtpScreen()),
      GoRoute(
        path: '/forgot/new',
        builder: (_, _) => const ForgotNewPasswordScreen(),
      ),
      GoRoute(path: '/app', builder: (_, _) => const AppShellScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    ],
  );
});
