// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  final PageController _pageController = PageController();

  static const _pageImages = <String>[
    '',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDQ8hSUWaJJYKMkVOLlbWgijeER17dk9modx6JFeYw4LSZqbm_lkpM_A1v6nrKdqcnkBxSVISrXiqe-siCKwacvf22pP1JbQTvElhTeOa4LmcqtZAAiSMVm0IFYf_Fz-7YB6Qluqvx_XuzYdIRCiEwnrHFUOx1lR5yCAK9UejBGbCMHrzm_g5WRrmY4UaMe-wj4LSsSYVZR99EL2ysKmZmC7oh27WV9Y1slpq5eCIrr5vXMeFqDSs2Jax23U0w7hGwneptzgMRDplkO',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDaLBH6NYjVd4zEpjYHVfeYrtAixhxiu4hnO1HyCNi_HTiN0bQvugZvN6dI528f6HvRDabMEIj-HomNcIBtuqplt12-GWnmLI8v85MM_4JysTcc5P90lqYx9v3ZviXMNgaxmKVJm9ZhOcppCND_rof77vWMu0dJ-czhP0mFdTDRPx0UyfUMgsPLS3HleSl1Q9GVcNrw3PvgyO5oPUqu6Y5hZ2B7CBspAPibpqwekudgtf3YLBCeGxH7yqponsPVeTt9ObatKs9CF1Lp',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDcIMFkFPERAis59-_CSErQsD1RBjIHTTlxgR6CD0zHkWA8kCdSt6OHQJyWopb2NLOQyZVgTnqVtDecsEpswImxL_m3HEJiB2jFgbWPKjoAlMKZ79NdOr-uRRjtGdmRLYl5mYL3kUFmpQ6Lz2ZoAmVNeX9Vv27wI9PV8rZ5yhKVQ5ymylgZfQBuyX0H_8N7jcWVqwlyQNutMlo75JYVig7fyembTTofRYoK4sXxhf47hTym8BfsD_3Q5-mD5F281j8JxoGiuh1zkmPy',
  ];

  void _goToNext(BuildContext context) {
    final page = ref.read(onboardingPageProvider);
    if (page >= 3) {
      context.go('/login');
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(onboardingPageProvider);
    final theme = Theme.of(context);

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
                    onPageChanged: (index) =>
                        ref.read(onboardingPageProvider.notifier).state = index,
                    children: [
                      _SplashBrandPage(theme: theme),
                      _OnboardingContentPage(
                        imageUrl: _pageImages[1],
                        title: 'Emergency help instantly',
                        subtitle:
                            'Connect with professional responders and emergency services in less than 3 seconds.',
                        showStatusBadge: true,
                      ),
                      _OnboardingContentPage(
                        imageUrl: _pageImages[2],
                        title: 'SOS and location sharing',
                        subtitle:
                            'Instantly broadcast your precise location to emergency responders and trusted contacts.',
                        showLocationOverlay: true,
                      ),
                      _OnboardingContentPage(
                        imageUrl: _pageImages[3],
                        title: 'First aid guidance',
                        subtitle:
                            'Step-by-step clinical instructions for critical moments.',
                        circleImage: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _PageIndicator(currentPage: page),
                const SizedBox(height: 20),
                if (page == 3)
                  _PrimaryActionButton(
                    label: 'Get Started',
                    icon: Icons.chevron_right_rounded,
                    onPressed: () => context.go('/login'),
                  )
                else
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Skip'),
                      ),
                      const Spacer(),
                      _PrimaryActionButton(
                        label: 'Next',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => _goToNext(context),
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

class _SplashBrandPage extends StatelessWidget {
  const _SplashBrandPage({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
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
            Positioned(
              right: 52,
              bottom: 54,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.primary),
              ),
            ),
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

class _OnboardingContentPage extends StatelessWidget {
  const _OnboardingContentPage({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.showStatusBadge = false,
    this.showLocationOverlay = false,
    this.circleImage = false,
  });

  final String imageUrl;
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
                  Image.network(
                    imageUrl,
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
  const _PageIndicator({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
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
