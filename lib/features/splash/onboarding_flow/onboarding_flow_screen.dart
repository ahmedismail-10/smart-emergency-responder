// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/progress_line.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _autoAdvanceController;
  static const _onboardingPageCount = 3;

  static const _pageImages = <String>[
    'assets/images/spash1.png',
    'assets/images/spash2.png',
    'assets/images/spash3.png',
  ];

  @override
  void initState() {
    super.initState();
    ref.read(onboardingPageProvider.notifier).state = 0;
    _autoAdvanceController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              _goToNext(context);
            }
          });
    _restartAutoAdvance();
  }

  void _restartAutoAdvance() {
    _autoAdvanceController
      ..reset()
      ..forward();
  }

  void _onPageChanged(int index) {
    ref.read(onboardingPageProvider.notifier).state = index;
    _restartAutoAdvance();
  }

  void _goToNext(BuildContext context) {
    final page = ref.read(onboardingPageProvider);
    if (page >= _onboardingPageCount - 1) {
      _autoAdvanceController.stop();
      context.go('/login');
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onSkip(BuildContext context) {
    _autoAdvanceController.stop();
    context.go('/login');
  }

  void _onManualNext(BuildContext context) {
    _autoAdvanceController.stop();
    _goToNext(context);
  }

  @override
  void dispose() {
    _autoAdvanceController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(onboardingPageProvider);

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
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _OnboardingContentPage(
                        imagePath: _pageImages[0],
                        title: 'Emergency help instantly',
                        subtitle:
                            'Connect with professional responders and emergency services in less than 3 seconds.',
                        showStatusBadge: true,
                      ),
                      _OnboardingContentPage(
                        imagePath: _pageImages[1],
                        title: 'SOS and location sharing',
                        subtitle:
                            'Instantly broadcast your precise location to emergency responders and trusted contacts.',
                        showLocationOverlay: true,
                      ),
                      _OnboardingContentPage(
                        imagePath: _pageImages[2],
                        title: 'First aid guidance',
                        subtitle:
                            'Step-by-step clinical instructions for critical moments.',
                        circleImage: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ProgressLine(progress: _autoAdvanceController.value),
                const SizedBox(height: 16),
                _PageIndicator(
                  currentPage: page,
                  pageCount: _onboardingPageCount,
                ),
                const SizedBox(height: 20),
                if (page == _onboardingPageCount - 1)
                  _PrimaryActionButton(
                    label: 'Get Started',
                    icon: Icons.chevron_right_rounded,
                    onPressed: () => _onSkip(context),
                  )
                else
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _onSkip(context),
                        child: const Text('Skip'),
                      ),
                      const Spacer(),
                      _PrimaryActionButton(
                        label: 'Next',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => _onManualNext(context),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingContentPage extends StatelessWidget {
  const _OnboardingContentPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.showStatusBadge = false,
    this.showLocationOverlay = false,
    this.circleImage = false,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final bool showStatusBadge;
  final bool showLocationOverlay;
  final bool circleImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(circleImage ? 220 : 40),
            child: SizedBox(
              width: double.infinity,
              height: circleImage ? 320 : 360,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 46,
                      ),
                    ),
                  ),
                  if (showStatusBadge)
                    Positioned(
                      right: 18,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emergency_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Standby Active',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showLocationOverlay)
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage, required this.pageCount});

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 30 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      iconAlignment: IconAlignment.end,
    );
  }
}
