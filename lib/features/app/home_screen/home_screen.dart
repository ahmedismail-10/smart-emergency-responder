// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pulsing_dot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenMap,
    required this.onOpenContacts,
  });

  final VoidCallback onOpenMap;
  final VoidCallback onOpenContacts;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBackground = isDark
        ? const Color(0xFF1B2533)
        : AppColors.secondaryContainer;
    final statusTextColor = isDark
        ? const Color(0xFF9DF2AE)
        : const Color(0xFF005312);
    final quickSupportDivider = isDark
        ? const Color(0xFF2A3648)
        : AppColors.surfaceContainerHighest;
    final profileCardColor = isDark
        ? const Color(0xFF161D28)
        : Colors.black.withOpacity(0.03);
    final profileCardBorder = isDark
        ? const Color(0xFF2A3648)
        : Colors.black.withOpacity(0.05);
    final avatarFallback = isDark
        ? const Color(0xFF2A3648)
        : AppColors.surfaceContainerHighest;
    final secondaryText = isDark
        ? const Color(0xFFBAC4D1)
        : AppColors.onSurfaceVariant;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: statusBackground,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.15),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PulsingDot(color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Status: Safe',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: statusTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.34),
                    blurRadius: 32,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
                onPressed: () => context.push('/sos'),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emergency_rounded,
                      size: 78,
                      color: Colors.white,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'HOLD TO SEND',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                'QUICK SUPPORT',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: quickSupportDivider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: [
              _QuickActionCard(
                icon: Icons.medical_services_outlined,
                title: 'Analyze Symptoms',
                subtitle: 'Self Assessment',
                iconBg: isDark
                    ? AppColors.primary.withOpacity(0.24)
                    : AppColors.primary.withOpacity(0.08),
                iconColor: AppColors.primary,
                onTap: () => context.push('/analyze-symptoms'),
              ),
              _QuickActionCard(
                icon: Icons.explore_outlined,
                title: 'Nearby Help',
                subtitle: 'Map & Hospitals',
                iconBg: isDark
                    ? Colors.blue.withOpacity(0.22)
                    : Colors.blue.withOpacity(0.08),
                iconColor: Colors.blue.shade700,
                onTap: onOpenMap,
              ),
              _QuickActionCard(
                icon: Icons.call_outlined,
                title: 'Contacts',
                subtitle: 'Emergency Circle',
                iconBg: isDark
                    ? Colors.orange.withOpacity(0.26)
                    : Colors.orange.withOpacity(0.12),
                iconColor: Colors.orange.shade700,
                onTap: onOpenContacts,
              ),
              _QuickActionCard(
                icon: Icons.smart_toy_outlined,
                title: 'AI First Aid',
                subtitle: 'Instant Guidance',
                iconBg: isDark
                    ? Colors.white.withOpacity(0.16)
                    : Colors.black.withOpacity(0.06),
                iconColor: AppColors.onSurface,
                onTap: () => context.push('/ai-chat'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: profileCardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: profileCardBorder),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDV6bq0VH1jUD7WaeCYg4VtGhL2oGZrKmgHka8xnDzdslsgIu0c86AaUpw46dh0KZAIhHd8ruddVW03M7jreYRFe-gAxMjbmdxgz5xeN3cXrZzZfUSGB37v6LVzojptpECiSzsWaxv5QCL-HesoaLrPGRULpXx4rid4dVRY3ftQSrhEJ8Nai63YuBzipdR6Ikzvr8UcsvH7s5H5sJ98C7-U8slxZ0mMqUGxY0TiPjAUs9JWifZfjKjGTA-jXlBS4N93KSlKp7NV7ph3',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: avatarFallback,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Responder ID: 724',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Last sync: 2 minutes ago • Vitals Stable',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    'Active',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
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

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF161D28)
        : AppColors.surfaceContainerLowest;
    final subtitleColor = isDark
        ? const Color(0xFFBAC4D1)
        : AppColors.onSurfaceVariant.withOpacity(0.7);

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const Spacer(),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: subtitleColor,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
