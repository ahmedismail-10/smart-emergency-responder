// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../emergency_contacts/emergency_contacts_screen.dart';
import '../home_screen/home_screen.dart';
import '../map_nearby_services/map_nearby_services_screen.dart';
import '../user_profile/user_profile_screen.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(appTabProvider);
    final drawerOpen = ref.watch(drawerOpenProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForTab(tab)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => ref.read(drawerOpenProvider.notifier).state = true,
        ),
        actions: [
          IconButton(
            icon: Icon(
              tab == AppTab.profile
                  ? Icons.settings_outlined
                  : Icons.account_circle_outlined,
            ),
            onPressed: () {
              if (tab == AppTab.profile) {
                context.go('/settings');
                return;
              }
              ref.read(appTabProvider.notifier).state = AppTab.profile;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(tab.name),
              child: switch (tab) {
                AppTab.home => HomeScreen(
                  onOpenMap: () =>
                      ref.read(appTabProvider.notifier).state = AppTab.map,
                  onOpenContacts: () =>
                      ref.read(appTabProvider.notifier).state = AppTab.contacts,
                ),
                AppTab.map => const MapNearbyServicesScreen(),
                AppTab.contacts => const EmergencyContactsScreen(),
                AppTab.profile => const UserProfileScreen(),
              },
            ),
          ),
          if (drawerOpen)
            _MainDrawerOverlay(
              onClose: () =>
                  ref.read(drawerOpenProvider.notifier).state = false,
              onOpenSettings: () {
                ref.read(drawerOpenProvider.notifier).state = false;
                context.go('/settings');
              },
            ),
        ],
      ),
      bottomNavigationBar: _BottomTabBar(
        tab: tab,
        onChanged: (nextTab) {
          ref.read(appTabProvider.notifier).state = nextTab;
          ref.read(drawerOpenProvider.notifier).state = false;
        },
      ),
    );
  }

  String _titleForTab(AppTab tab) {
    return switch (tab) {
      AppTab.home => 'EMERGENCY RESPONSE',
      AppTab.map => 'Nearby Services Map',
      AppTab.contacts => 'Emergency Contacts',
      AppTab.profile => 'User Profile',
    };
  }
}

class _MainDrawerOverlay extends StatelessWidget {
  const _MainDrawerOverlay({
    required this.onClose,
    required this.onOpenSettings,
  });

  final VoidCallback onClose;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Container(color: Colors.black.withOpacity(0.18)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFCFBFB),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(18, 58, 18, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBgeNCl3aC0qHaVIiaFkhkcaFZ_-m7o7QHc-31jMLqXUqTi9IWFp2m8PK-pjDw_ja4X6bTHkjloI-FcbWyHQsel2cfcDi30CsfiYb0Fd2Xz38EKGRoe5920naTuuFu5U0FP2SzyvdUR3IcavHgjlQ1N8_HrbEXlwQ0JpjQOvmTYfNiH62UKQxXjl8pm95wAqX2mliCMZFk6jfsjBqGEWZ42eVFOQ7kcQfa0QDX98vpaiREZzq5q_bPchxpvoVdPRpug6QdB4ffeBMFA',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 56,
                            height: 56,
                            color: AppColors.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unit 724',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Status: On Call',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _DrawerItem(
                    icon: Icons.history_rounded,
                    title: 'Incident History',
                    active: true,
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.school_outlined,
                    title: 'Training Modules',
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'Equipment Status',
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.note_alt_outlined,
                    title: 'Medical Records',
                    onTap: () {},
                  ),
                  _DrawerItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Insurance Info',
                    onTap: () {},
                  ),
                  const Divider(height: 26),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: onOpenSettings,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text(
                        'End Shift',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: active ? AppColors.errorContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: active
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: active
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({required this.tab, required this.onChanged});

  final AppTab tab;
  final ValueChanged<AppTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              _TabItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                active: tab == AppTab.home,
                onTap: () => onChanged(AppTab.home),
              ),
              _TabItem(
                icon: Icons.map_outlined,
                activeIcon: Icons.map_rounded,
                label: 'Map',
                active: tab == AppTab.map,
                onTap: () => onChanged(AppTab.map),
              ),
              _TabItem(
                icon: Icons.contacts_outlined,
                activeIcon: Icons.contacts_rounded,
                label: 'Contacts',
                active: tab == AppTab.contacts,
                onTap: () => onChanged(AppTab.contacts),
              ),
              _TabItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                active: tab == AppTab.profile,
                onTap: () => onChanged(AppTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? AppColors.errorContainer.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? activeIcon : icon,
                color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
