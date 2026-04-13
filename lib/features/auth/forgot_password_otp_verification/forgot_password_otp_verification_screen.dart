import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../shared/forgot_password_scaffold.dart';

class ForgotPasswordOtpVerificationScreen extends StatefulWidget {
  const ForgotPasswordOtpVerificationScreen({super.key});

  @override
  State<ForgotPasswordOtpVerificationScreen> createState() =>
      _ForgotPasswordOtpVerificationScreenState();
}

class _ForgotPasswordOtpVerificationScreenState
    extends State<ForgotPasswordOtpVerificationScreen> {
  static const int _otpLength = 4;
  static const int _resendCountdownSeconds = 59;

  late final List<TextEditingController> _digitControllers;
  late final List<FocusNode> _focusNodes;
  Timer? _countdownTimer;
  int _remainingSeconds = _resendCountdownSeconds;

  bool get _isOtpComplete =>
      _digitControllers.every((controller) => controller.text.length == 1);

  @override
  void initState() {
    super.initState();
    _digitControllers = List.generate(
      _otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remainingSeconds = _resendCountdownSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds == 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _handleDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _resendCode() {
    for (final controller in _digitControllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
    _startCountdown();
    setState(() {});
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final controller in _digitControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
      title: 'Verification',
      subtitle: 'Enter the 4-digit code sent to user@email.com',
      icon: Icons.mark_email_read_rounded,
      onBackPressed: () => context.go('/forgot/email'),
      child: Column(
        children: [
          Row(
            children: List.generate(
              _otpLength,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index == _otpLength - 1 ? 0 : 10,
                  ),
                  child: TextField(
                    controller: _digitControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textInputAction: index == _otpLength - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    onChanged: (value) => _handleDigitChanged(index, value),
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
              onPressed: _isOtpComplete
                  ? () => context.go('/forgot/new')
                  : null,
              child: const Text(
                'Verify Code',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_remainingSeconds > 0)
            Text(
              'Resend Code in 00:${_remainingSeconds.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            TextButton(
              onPressed: _resendCode,
              child: const Text('Resend Code'),
            ),
        ],
      ),
    );
  }
}
