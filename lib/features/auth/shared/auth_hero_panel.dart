// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AuthHeroPanel extends StatelessWidget {
  const AuthHeroPanel({super.key, this.signupMode = false});

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
