import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../shared/auth_form_fields.dart';
import '../shared/forgot_password_scaffold.dart';

class ForgotPasswordNewPasswordScreen extends StatelessWidget {
  const ForgotPasswordNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
      title: 'New Password',
      subtitle: 'Create a strong password to secure your account.',
      icon: Icons.shield_outlined,
      child: Column(
        children: [
          const LabeledField(
            label: 'New Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          const LabeledField(
            label: 'Confirm Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: RequirementChip(label: '8+ Characters', done: true),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RequirementChip(label: 'One Special', done: false),
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
