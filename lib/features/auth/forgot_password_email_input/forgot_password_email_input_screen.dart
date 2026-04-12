import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../shared/auth_form_fields.dart';
import '../shared/forgot_password_scaffold.dart';

class ForgotPasswordEmailInputScreen extends StatelessWidget {
  const ForgotPasswordEmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
      title: 'Forgot Password?',
      subtitle:
          'Enter your email address and we\'ll send you a 4-digit verification code.',
      icon: Icons.lock_reset_rounded,
      child: Column(
        children: [
          const LabeledField(
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
