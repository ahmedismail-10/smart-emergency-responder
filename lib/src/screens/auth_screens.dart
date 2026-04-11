// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(42),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: isWide
                        ? Row(
                            children: const [
                              Expanded(child: _AuthHeroPanel()),
                              Expanded(child: _LoginFormPanel()),
                            ],
                          )
                        : const _LoginFormPanel(showLogo: true),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(42),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: isWide
                        ? Row(
                            children: const [
                              Expanded(child: _AuthHeroPanel(signupMode: true)),
                              Expanded(child: _SignupFormPanel()),
                            ],
                          )
                        : const _SignupFormPanel(showLogo: true),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotEmailScreen extends StatelessWidget {
  const ForgotEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ForgotScaffold(
      title: 'Forgot Password?',
      subtitle:
          'Enter your email address and we\'ll send you a 4-digit verification code.',
      icon: Icons.lock_reset_rounded,
      child: Column(
        children: [
          const _LabeledField(
            label: 'Email Address',
            hint: 'name@vitalpulse.com',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => context.go('/forgot/otp'),
              icon: const Icon(Icons.send_rounded),
              label: const Text(
                'Send Code',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.keyboard_backspace_rounded),
            label: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}

class ForgotOtpScreen extends StatelessWidget {
  const ForgotOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ForgotScaffold(
      title: 'Verification',
      subtitle: 'Enter the 4-digit code sent to user@email.com',
      icon: Icons.mark_email_read_rounded,
      child: Column(
        children: [
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 10),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => context.go('/forgot/new'),
              child: const Text(
                'Verify Code',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Resend Code in 00:59',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotNewPasswordScreen extends StatelessWidget {
  const ForgotNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ForgotScaffold(
      title: 'New Password',
      subtitle: 'Create a strong password to secure your account.',
      icon: Icons.shield_outlined,
      child: Column(
        children: [
          const _LabeledField(
            label: 'New Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          const _LabeledField(
            label: 'Confirm Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _RequirementChip(label: '8+ Characters', done: true),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _RequirementChip(label: 'One Special', done: false),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.arrow_forward_rounded),
              iconAlignment: IconAlignment.end,
              label: const Text(
                'Update Password',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthHeroPanel extends StatelessWidget {
  const _AuthHeroPanel({this.signupMode = false});

  final bool signupMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            signupMode
                ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-9_7jbRpM1VMxBXSkS6NkkKZxHTl5NBjJ1GSDV3xSVW68UdCr3AkcUhCQnq2BDFDO2zMNvn3O3mjvcdYCxCZzEFNGAgJdYGpE5nbHWzEdOsyKMnyuISPpMPxrCrd7ah4FEpm3Q_GEWcY73HzB5RAMrDyivMl6sp87v_JHhTYJ4jpbSzKlLWT_zzKHwqQINrr2DpCgZ8jjxYNM2t-8Xk0FULjYeDoZ21CtInFaz43rx6-PlPZBD2DJQxp90RvQ0JpR3BXEulfrjbZZ'
                : 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQHQKDU-XLzo-r4oKJPDJQLsju8xL14vpzxRP0j_pwZwQ7dE-tNFNsqgISI08KdVV1tg3pCb-IpdWiaMQRzVfxFvvGaMTzvlAQOPtJJ-45Rlm8PFSJ-VHqOuulT8vLLmPyzNHtCJqrAwMRFJIvF5NHJmsOW4PmepjtHtMPJ_bwY6mI60onogY_9w_rFDZFPZDngjQpjx5hZES-_jO6FurHpWSWYLfkvQ-x3ddiZGvieoXq6egrtcdgPQNvFm4nZ5vPzCBjgf18o0-1',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.08),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          Container(color: AppColors.primary.withOpacity(0.65)),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.emergency_share_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Smart Emergency Responder',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  signupMode
                      ? 'The Calm Authority\nIn Every Second.'
                      : 'Mission Critical\nPrecision.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 44,
                    height: 1.08,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  signupMode
                      ? 'Designed for precision. Built for responders. Join the emergency coordination network.'
                      : 'Equipping first responders with the data-driven authority required for high-stakes environments.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFormPanel extends StatelessWidget {
  const _LoginFormPanel({this.showLogo = false});

  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLogo)
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.emergency_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Smart Emergency Responder',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ],
              ),
            ),
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Please enter your credentials to access the dispatch dashboard.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 28),
          const _LabeledField(
            label: 'Email Address',
            hint: 'responder@agency.gov',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 12),
          const _LabeledField(
            label: 'Password',
            hint: '••••••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go('/forgot/email'),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: () => context.go('/app'),
              icon: const Icon(Icons.chevron_right_rounded),
              iconAlignment: IconAlignment.end,
              label: const Text(
                'Login to Dashboard',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or continue with',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.surfaceContainerHighest.withOpacity(0.6),
                ),
                backgroundColor: AppColors.surfaceContainerLowest,
                foregroundColor: AppColors.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata_rounded, size: 30),
              label: const Text('Google sign-in'),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignupFormPanel extends StatelessWidget {
  const _SignupFormPanel({this.showLogo = false});

  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLogo)
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.emergency_share_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Smart Emergency Responder',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ],
              ),
            ),
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Equip yourself with the tools of mission control.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          const _LabeledField(
            label: 'Full Name',
            hint: 'Johnathan Doe',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          const _LabeledField(
            label: 'Email Address',
            hint: 'responder.one@agency.gov',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _LabeledField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _LabeledField(
                  label: 'Confirm',
                  hint: '••••••••',
                  icon: Icons.security_rounded,
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => context.go('/app'),
              icon: const Icon(Icons.arrow_forward_rounded),
              iconAlignment: IconAlignment.end,
              label: const Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.surfaceContainerHighest.withOpacity(0.6),
                ),
                foregroundColor: AppColors.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata_rounded, size: 30),
              label: const Text('Continue with Google'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForgotScaffold extends StatelessWidget {
  const _ForgotScaffold({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Vital Pulse'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: AppColors.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 34),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant),
            suffixIcon: obscureText
                ? const Icon(Icons.visibility_outlined)
                : null,
          ),
        ),
      ],
    );
  }
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: done
                ? AppColors.secondary
                : AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
