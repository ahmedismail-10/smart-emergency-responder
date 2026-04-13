import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/app_section_theme_wrapper.dart';
import '../../features/app/ai_chat/ai_chat_screen.dart';
import '../../features/app/analyze_symptoms/analyze_symptoms_screen.dart';
import '../../features/app/main_navigation_menu/main_navigation_menu_screen.dart';
import '../../features/app/menu_modules/menu_module_screen.dart';
import '../../features/app/settings/settings_screen.dart';
import '../../features/app/sos_center/sos_center_screen.dart';
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
      GoRoute(
        path: '/sos',
        builder: (_, _) =>
            const AppSectionThemeWrapper(child: SosCenterScreen()),
      ),
      GoRoute(
        path: '/analyze-symptoms',
        builder: (_, _) =>
            const AppSectionThemeWrapper(child: AnalyzeSymptomsScreen()),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (_, _) => const AppSectionThemeWrapper(child: AiChatScreen()),
      ),
      GoRoute(
        path: '/module/incident-history',
        builder: (_, _) => const AppSectionThemeWrapper(
          child: MenuModuleScreen.incidentHistory(),
        ),
      ),
      GoRoute(
        path: '/module/training-modules',
        builder: (_, _) => const AppSectionThemeWrapper(
          child: MenuModuleScreen.trainingModules(),
        ),
      ),
      GoRoute(
        path: '/module/equipment-status',
        builder: (_, _) => const AppSectionThemeWrapper(
          child: MenuModuleScreen.equipmentStatus(),
        ),
      ),
      GoRoute(
        path: '/module/medical-records',
        builder: (_, _) => const AppSectionThemeWrapper(
          child: MenuModuleScreen.medicalRecords(),
        ),
      ),
      GoRoute(
        path: '/module/insurance-info',
        builder: (_, _) => const AppSectionThemeWrapper(
          child: MenuModuleScreen.insuranceInfo(),
        ),
      ),
      GoRoute(
        path: '/app',
        builder: (_, _) =>
            const AppSectionThemeWrapper(child: AppShellScreen()),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, _) =>
            const AppSectionThemeWrapper(child: SettingsScreen()),
      ),
    ],
  );
});
