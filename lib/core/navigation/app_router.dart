import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/app/main_navigation_menu/main_navigation_menu_screen.dart';
import '../../features/app/settings/settings_screen.dart';
import '../../features/auth/forgot_password_email_input/forgot_password_email_input_screen.dart';
import '../../features/auth/forgot_password_new_password/forgot_password_new_password_screen.dart';
import '../../features/auth/forgot_password_otp_verification/forgot_password_otp_verification_screen.dart';
import '../../features/auth/login_screen/login_screen.dart';
import '../../features/auth/signup_screen/signup_screen.dart';
import '../../features/splash/onboarding_flow/onboarding_flow_screen.dart';
import '../../features/splash/splash_loading/splash_loading_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashLoadingScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingFlowScreen(),
      ),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),
      GoRoute(
        path: '/forgot/email',
        builder: (_, _) => const ForgotPasswordEmailInputScreen(),
      ),
      GoRoute(
        path: '/forgot/otp',
        builder: (_, _) => const ForgotPasswordOtpVerificationScreen(),
      ),
      GoRoute(
        path: '/forgot/new',
        builder: (_, _) => const ForgotPasswordNewPasswordScreen(),
      ),
      GoRoute(path: '/app', builder: (_, _) => const AppShellScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    ],
  );
});
