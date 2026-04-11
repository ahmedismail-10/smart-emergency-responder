// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

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
                AppTab.home => _HomeTab(
                  onOpenMap: () =>
                      ref.read(appTabProvider.notifier).state = AppTab.map,
                  onOpenContacts: () =>
                      ref.read(appTabProvider.notifier).state = AppTab.contacts,
                ),
                AppTab.map => const _MapTab(),
                AppTab.contacts => const _ContactsTab(),
                AppTab.profile => const _ProfileTab(),
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

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.onOpenMap, required this.onOpenContacts});

  final VoidCallback onOpenMap;
  final VoidCallback onOpenContacts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.15),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PulsingDot(color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Status: Safe',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF005312),
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
                onPressed: () {},
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
                    color: AppColors.surfaceContainerHighest,
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
                iconBg: AppColors.primary.withOpacity(0.08),
                iconColor: AppColors.primary,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.explore_outlined,
                title: 'Nearby Help',
                subtitle: 'Map & Hospitals',
                iconBg: Colors.blue.withOpacity(0.08),
                iconColor: Colors.blue.shade700,
                onTap: onOpenMap,
              ),
              _QuickActionCard(
                icon: Icons.call_outlined,
                title: 'Contacts',
                subtitle: 'Emergency Circle',
                iconBg: Colors.orange.withOpacity(0.12),
                iconColor: Colors.orange.shade700,
                onTap: onOpenContacts,
              ),
              _QuickActionCard(
                icon: Icons.smart_toy_outlined,
                title: 'AI First Aid',
                subtitle: 'Instant Guidance',
                iconBg: Colors.black.withOpacity(0.06),
                iconColor: AppColors.onSurface,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
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
                      color: AppColors.surfaceContainerHighest,
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
                          color: AppColors.onSurfaceVariant,
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

class _MapTab extends StatelessWidget {
  const _MapTab();

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
                const _PulsingDot(color: AppColors.primary),
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
        Positioned(
          top: 190,
          right: 30,
          child: _ServiceChip(
            label: 'St. Jude Medical',
            icon: Icons.local_hospital_rounded,
            color: AppColors.errorContainer,
            iconColor: AppColors.error,
          ),
        ),
        Positioned(
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

class _ContactsTab extends StatelessWidget {
  const _ContactsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMERGENCY PROTOCOL',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Trusted Contacts',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        letterSpacing: -0.8,
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Contact'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _ContactTile(
            name: 'Dr. James Wilson',
            role: 'Family Physician',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCxMa_3YoVsxhkv2VIptqknuxljQbxLxucLu7kC6ZOftokxhzd5tUZQptcTK21kapAxBJxFyV-9drEZsJL8TJ1s8SNKCNselwolrnYquLxlJ_hD4L7F8N0mv2laB5p9H0IQVcYDSFXgO7D8bEbJ3DWfCTjFA4z_p690UiejRiJe91W92hU_lsTV1D6AJCN_bNL3txPzR9u15K_CFbOzsujMA1qquu5bgtS0AY_KYF_DD8A45xOZJDsMqu7S08FtUqeLlR9k9sgix9-Q',
            primary: true,
          ),
          const SizedBox(height: 10),
          const _ContactTile(
            name: 'Sarah Mitchell',
            role: 'Spouse',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCWzo8vdTBEvqlXqQgLOTD9oAw5py9b3fIhNY8AC1aUBBnwA_rrpe7TcF1rcPaq_kuOKFGIJFtXFCD8XFzzsWZXcS1q0kBQXiXvnyLheI8H97PC6WuZQM4LU3kFJIhzpxjaQzTwWGOJ9pMVsZLvWA4zDOrPjV7DqqenVDpCXJ3iio33GV_xYq9h0y-xo2hBfi7Ay_kOJPwT2B3quBVHzIN7lXDEj5fFXHB6-ZbqgvA_DnVS1WxLGafHK3yGcHf7-VLtSX60-TdHCvPY',
          ),
          const SizedBox(height: 10),
          const _ContactTile(
            name: 'Robert Chen',
            role: 'Neighbor',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDBhqi-h7ytZVTBbwA1x-sZAPVFrcVHtrEjypkRp-YkKG_Iesbgz-dUs9wY1DWQYjEW6qFRGGmvIkbBdW_18Sjujuc4RwvWL8K9iPYYaNlsLjZPfp34ibjdKR2Fr8Ab-0hUGRtG5-GUt3uxGJUlOwCfplSiE02IUCfHuTlniDAhMPGTuQct2fhLNJCraydZpqxt-v--gNNnUTD8Q96Ar3GYqgLCQHxI_KkvCkOCzxWx9fc_qqZD2kfTDtINiskM50IbPigAx2UCxj7U',
          ),
          const SizedBox(height: 10),
          const _ContactTile(
            name: 'Emma Davis',
            role: 'Daughter',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuB5C464s0QjsphjQGalOEEKzheqQMBjjIm7TGvS2xtQIdZyDDu9QqT5WDD08f3O9QNQjbAScjdLnVFHU8dAz7AMW4QUyd-Wdsv5fB1YOtL1Hepg9O3dn1mfihLiw-83kMTFynbIun4qT63O2AtTo8TrktAHflvM8RL4ePwbZPEabJaXpetimB8ERbuNmktyHKcOEFQT_Blkt5hFTY7s76AiI5TnmFWincsc_gkPNP9KtAKNiVMoikBLwRHNm3fvvytVG8xzHVyTjrFS',
            deleteVisible: true,
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Emergency Tip',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ensure your primary contacts have the Smart Responder app installed to receive real-time location data when you trigger an alert.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
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

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

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
          Row(
            children: const [
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
          _InfoRowCard(
            icon: Icons.person_outline_rounded,
            title: 'Full Name',
            value: 'Marcus Avery Sterling',
          ),
          const SizedBox(height: 10),
          _InfoRowCard(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                const SizedBox(height: 14),
                const _ConditionCard(
                  status: 'Active',
                  title: 'Latex Allergy',
                  description:
                      'Severe reaction to surgical gloves and equipment.',
                  color: AppColors.error,
                ),
                const SizedBox(height: 8),
                const _ConditionCard(
                  status: 'Chronic',
                  title: 'Asthma',
                  description:
                      'Exercise induced. Rescue inhaler in left side pocket.',
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                const _ConditionCard(
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
    return Material(
      color: AppColors.surfaceContainerLowest,
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
                  color: AppColors.onSurfaceVariant.withOpacity(0.7),
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

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.name,
    required this.role,
    required this.imageUrl,
    this.primary = false,
    this.deleteVisible = false,
  });

  final String name;
  final String role;
  final String imageUrl;
  final bool primary;
  final bool deleteVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: AppColors.surfaceContainerHighest,
                alignment: Alignment.center,
                child: const Icon(Icons.person_rounded),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    if (primary)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: const Text(
                          'PRIMARY',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              deleteVisible
                  ? Icons.delete_outline_rounded
                  : Icons.edit_outlined,
            ),
            color: deleteVisible ? AppColors.error : AppColors.onSurfaceVariant,
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              minimumSize: const Size(42, 42),
              backgroundColor: primary
                  ? AppColors.primary
                  : AppColors.secondary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {},
            child: const Icon(Icons.call_rounded, size: 19),
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

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});

  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = Curves.easeOut.transform(_controller.value);
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 13 + value * 8,
              height: 13 + value * 8,
              decoration: BoxDecoration(
                color: widget.color.withOpacity((1 - value) * 0.3),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
    );
  }
}
