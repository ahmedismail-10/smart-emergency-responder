// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/progress_line.dart';

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _loadingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              context.go('/onboarding');
            }
          })
          ..forward();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9F9FC), Color(0xFFF3F3F6)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              children: [
                const Expanded(child: _SplashBrandPage()),
                AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, _) =>
                      ProgressLine(progress: _loadingController.value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashBrandPage extends StatelessWidget {
  const _SplashBrandPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Spacer(),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 228,
              height: 228,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.06),
              ),
            ),
            Container(
              width: 188,
              height: 188,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.32),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.monitor_heart_outlined,
                color: Colors.white,
                size: 58,
              ),
            ),
            const Positioned(right: 52, bottom: 54, child: _SplashPlusIcon()),
          ],
        ),
        const SizedBox(height: 44),
        Text(
          'GUARDIAN\nPULSE',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: 26,
              color: AppColors.surfaceContainerHighest,
            ),
            const SizedBox(width: 10),
            Text(
              'SAVING LIVES',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.w700,
                letterSpacing: 2.8,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 2,
              width: 26,
              color: AppColors.surfaceContainerHighest,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class _SplashPlusIcon extends StatelessWidget {
  const _SplashPlusIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add_rounded, color: AppColors.primary),
    );
  }
}
