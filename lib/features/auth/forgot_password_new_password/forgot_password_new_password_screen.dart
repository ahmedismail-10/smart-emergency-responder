import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../shared/auth_form_fields.dart';
import '../shared/forgot_password_scaffold.dart';

class ForgotPasswordNewPasswordScreen extends StatefulWidget {
  const ForgotPasswordNewPasswordScreen({super.key});

  @override
  State<ForgotPasswordNewPasswordScreen> createState() =>
      _ForgotPasswordNewPasswordScreenState();
}

class _ForgotPasswordNewPasswordScreenState
    extends State<ForgotPasswordNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String get _newPassword => _newPasswordController.text;
  String get _confirmPassword => _confirmPasswordController.text;

  bool get _hasMinLength => _newPassword.length >= 8;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_newPassword);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_newPassword);
  bool get _hasNumber => RegExp(r'\d').hasMatch(_newPassword);
  bool get _hasSymbol => RegExp(r'[^A-Za-z0-9\s]').hasMatch(_newPassword);
  bool get _passwordsMatch =>
      _newPassword.isNotEmpty && _newPassword == _confirmPassword;

  bool get _canSubmit =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSymbol &&
      _passwordsMatch;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
      title: 'New Password',
      subtitle: 'Create a strong password to secure your account.',
      icon: Icons.shield_outlined,
      onBackPressed: () => context.go('/forgot/otp'),
      child: Column(
        children: [
          LabeledField(
            label: 'New Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            controller: _newPasswordController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Confirm Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            controller: _confirmPasswordController,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password must include:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                _PasswordRequirementItem(
                  label: 'At least 8 characters',
                  done: _hasMinLength,
                ),
                _PasswordRequirementItem(
                  label: 'One uppercase letter',
                  done: _hasUppercase,
                ),
                _PasswordRequirementItem(
                  label: 'One lowercase letter',
                  done: _hasLowercase,
                ),
                _PasswordRequirementItem(label: 'One number', done: _hasNumber),
                _PasswordRequirementItem(label: 'One symbol', done: _hasSymbol),
                _PasswordRequirementItem(
                  label: 'Passwords match',
                  done: _passwordsMatch,
                ),
              ],
            ),
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
              onPressed: _canSubmit ? () => context.go('/login') : null,
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

class _PasswordRequirementItem extends StatelessWidget {
  const _PasswordRequirementItem({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final dotColor = done
        ? AppColors.secondary
        : AppColors.onSurfaceVariant.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: done ? AppColors.secondary : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
