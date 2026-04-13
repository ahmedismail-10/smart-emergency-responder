import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../shared/auth_form_fields.dart';
import '../shared/forgot_password_scaffold.dart';

class ForgotPasswordEmailInputScreen extends StatefulWidget {
  const ForgotPasswordEmailInputScreen({super.key});

  @override
  State<ForgotPasswordEmailInputScreen> createState() =>
      _ForgotPasswordEmailInputScreenState();
}

class _ForgotPasswordEmailInputScreenState
    extends State<ForgotPasswordEmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  static final RegExp _gmailRegex = RegExp(r'^[A-Za-z0-9._%+-]+@gmail\.com$');

  bool get _isGmailAddress =>
      _gmailRegex.hasMatch(_emailController.text.trim());

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
      title: 'Forgot Password?',
      subtitle:
          'Enter your email address and we\'ll send you a 4-digit verification code.',
      icon: Icons.lock_reset_rounded,
      onBackPressed: () => context.go('/login'),
      child: Column(
        children: [
          LabeledField(
            label: 'Email Address',
            hint: 'name@gmail.com',
            icon: Icons.mail_outline_rounded,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Use a valid Gmail address ending with @gmail.com',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              onPressed: _isGmailAddress
                  ? () => context.go('/forgot/otp')
                  : null,
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
