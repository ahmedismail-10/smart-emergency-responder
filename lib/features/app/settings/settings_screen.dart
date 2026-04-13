// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../shared/logout_confirmation.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/app');
  }

  Future<void> _selectLanguage(BuildContext context, WidgetRef ref) async {
    final currentLanguage = ref.read(appLanguageProvider);
    final languages = <String>[
      'English (United States)',
      'Arabic (Egypt)',
      'French (France)',
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 8),
                ...languages.map(
                  (language) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: language,
                      groupValue: currentLanguage,
                      onChanged: (_) =>
                          Navigator.of(sheetContext).pop(language),
                    ),
                    title: Text(language),
                    onTap: () => Navigator.of(sheetContext).pop(language),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || selected == currentLanguage) {
      return;
    }

    ref.read(appLanguageProvider.notifier).state = selected;
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Language changed to $selected')));
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showLogoutConfirmationDialog(
      context,
      title: 'Confirm Log Out',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Log Out',
    );

    if (!context.mounted || !confirmed) {
      return;
    }

    ref.read(drawerOpenProvider.notifier).state = false;
    ref.read(appTabProvider.notifier).state = AppTab.home;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(emergencyNotificationsProvider);
    final tones = ref.watch(audibleTonesProvider);
    final darkMode = ref.watch(darkModeProvider);
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _handleBack(context),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDbNva2LWzEdLmaN1sHr3bYZBYFHRHqcq4u7jb1f-_HA9v50yUTq9MXUpCJ4U9F_kUki7K06EbUTnoqPJABsH6lkwF2aOy9cuWidCIJHKkCQnZ3a-VNkEwpWNqLVPrsiLw6wmZDpdBsNswECDWz2OrBw-CTdS1fo4GlYlI6eYrmBjGUsCRB8EouAsryWkdjh4T8-me1_uxGWixVluUkwdLgX5hkZDH-U6AeAtXT9G9mz0tjlBgH7hD6lmx4q5qha_KkWFbvvHb2p6N6',
                          width: 74,
                          height: 74,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 74,
                            height: 74,
                            color: AppColors.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: const Icon(Icons.person_rounded, size: 34),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Officer James Miller',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ID: SR-9402',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'ALERT PREFERENCES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            _SettingsSwitchTile(
              icon: Icons.notifications_outlined,
              iconColor: AppColors.primary,
              title: 'Emergency Notifications',
              subtitle: 'Instant alerts for high-priority dispatches',
              value: notifications,
              onChanged: (value) =>
                  ref.read(emergencyNotificationsProvider.notifier).state =
                      value,
            ),
            const SizedBox(height: 8),
            _SettingsSwitchTile(
              icon: Icons.volume_up_outlined,
              iconColor: AppColors.tertiary,
              title: 'Audible Priority Tones',
              subtitle: 'Override silent mode for SOS signals',
              value: tones,
              onChanged: (value) =>
                  ref.read(audibleTonesProvider.notifier).state = value,
            ),
            const SizedBox(height: 18),
            Text(
              'INTERFACE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            _SettingsSwitchTile(
              icon: Icons.dark_mode_outlined,
              iconColor: AppColors.onSurface,
              title: 'Dark Mode',
              subtitle: 'Reduced glare for night operations',
              value: darkMode,
              onChanged: (value) =>
                  ref.read(darkModeProvider.notifier).state = value,
            ),
            const SizedBox(height: 8),
            _SettingsActionTile(
              icon: Icons.translate_rounded,
              iconColor: AppColors.onSurface,
              title: 'Language Selection',
              subtitle: 'Current: $language',
              onTap: () => _selectLanguage(context, ref),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => _logout(context, ref),
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'Log Out of Responder Shell',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'System Version 4.8.2 (Stable Production)',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
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
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
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
                      subtitle,
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
        ),
      ),
    );
  }
}
