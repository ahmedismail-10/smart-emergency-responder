// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

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
