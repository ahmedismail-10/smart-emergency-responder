// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MEDICAL IDENTITY',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.9,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'User Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Profile'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB7fNiFL9UcN80s-wfNhPCi8uuzGwfp3c652y4VruWOWcnc-JdKcYu3HzZMFgDDlksqgD8COlldvXlNNAeIFmpTyFMdsw5i2mmDu5kg3jY2c165uL_ttPTkSAgsyuA1VYqAZxxJKPceuJgw4JgAATJRzuGogSYzGkIbCVGRMcBjvPWsU8NYvEQD3nXPy2sC2VIaqqqh0ZTl6FxOfx1yauxkeYW-KzYbK2MwVFy01Qj1uMi-YIVKiI3-fhVruDmF6S7OxcXDRshGN4YU',
                        width: 126,
                        height: 126,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 126,
                          height: 126,
                          color: AppColors.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: const Icon(Icons.person, size: 56),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Marcus Sterling',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                ),
                Text(
                  'Rescue ID: #44920',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _ProfileStatCard(
                  icon: Icons.bloodtype_rounded,
                  title: 'Blood Type',
                  value: 'O+',
                  iconColor: AppColors.primary,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ProfileStatCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'Age',
                  value: '34 yrs',
                  iconColor: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _InfoRowCard(
            icon: Icons.person_outline_rounded,
            title: 'Full Name',
            value: 'Marcus Avery Sterling',
          ),
          const SizedBox(height: 10),
          const _InfoRowCard(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: '1224 Maritime Dr, Seattle, WA',
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.all(18),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Medical Conditions',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                _ConditionCard(
                  status: 'Active',
                  title: 'Latex Allergy',
                  description:
                      'Severe reaction to surgical gloves and equipment.',
                  color: AppColors.error,
                ),
                SizedBox(height: 8),
                _ConditionCard(
                  status: 'Chronic',
                  title: 'Asthma',
                  description:
                      'Exercise induced. Rescue inhaler in left side pocket.',
                  color: AppColors.onSurfaceVariant,
                ),
                SizedBox(height: 8),
                _ConditionCard(
                  status: 'Managed',
                  title: 'Nearsightedness',
                  description: 'Requires corrective lenses for navigation.',
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 10),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowCard extends StatelessWidget {
  const _InfoRowCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.status,
    required this.title,
    required this.description,
    required this.color,
  });

  final String status;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outline.withOpacity(0.12)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: color.withOpacity(0.75),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
