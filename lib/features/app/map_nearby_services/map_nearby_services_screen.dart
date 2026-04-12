// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pulsing_dot.dart';

class MapNearbyServicesScreen extends StatelessWidget {
  const MapNearbyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: AppColors.surfaceContainerHigh,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBGToaXlWwRfK66bfjJ3sRzrPJ58spCFKO7DskKyJhruHDHSuFSWQxWYcNbyYzX8Lh9PN0sHiMqq51VXOMOmDTTQBdx2Xz9c4VMzP8FWsRz4USjxoQvBk7PbQd1IahBd5CaXcIUD-cxnK8AcUROJTreUk2EslNjj4zAdvU5DmmtcFhhgytvVjN--727sY8B3ps1aD0narQPoym2qfcldPinUdsSvau4Bwd8sw_0stbQ0-2gtkiJsUdO5kfEUbcdcEVi87qbNy2MIC5x',
                  fit: BoxFit.cover,
                  color: Colors.grey.withOpacity(0.2),
                  colorBlendMode: BlendMode.saturation,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.surfaceContainerHigh),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xBFF9F9FC),
                        Color(0x00F9F9FC),
                        Color(0xBFF9F9FC),
                      ],
                      stops: [0, 0.2, 1],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const PulsingDot(color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Status',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Monitoring Local Services',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '00:14',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(left: 210, top: 300, child: _MapPin(active: true)),
        const Positioned(
          top: 190,
          right: 30,
          child: _ServiceChip(
            label: 'St. Jude Medical',
            icon: Icons.local_hospital_rounded,
            color: AppColors.errorContainer,
            iconColor: AppColors.error,
          ),
        ),
        const Positioned(
          top: 430,
          left: 20,
          child: _ServiceChip(
            label: 'North Fire Station',
            icon: Icons.emergency_share_rounded,
            color: AppColors.secondaryContainer,
            iconColor: AppColors.secondary,
          ),
        ),
        Positioned(
          right: 20,
          bottom: 180,
          child: Column(
            children: [
              _RoundFab(
                icon: Icons.filter_list_rounded,
                color: Colors.white,
                iconColor: AppColors.onSurface,
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              _RoundFab(
                icon: Icons.my_location_rounded,
                color: AppColors.primary,
                iconColor: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 90,
          bottom: 170,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: const Text(
                        'Fastest Response',
                        style: TextStyle(
                          color: Color(0xFF1A7425),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '1.2 km',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'General Health Center',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Route Now'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(
                          color: AppColors.outline.withOpacity(0.35),
                        ),
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.call_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outline.withOpacity(0.12)),
      ),
      padding: const EdgeInsets.fromLTRB(5, 5, 12, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (active)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.18),
            ),
          ),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
        ),
      ],
    );
  }
}

class _RoundFab extends StatelessWidget {
  const _RoundFab({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
