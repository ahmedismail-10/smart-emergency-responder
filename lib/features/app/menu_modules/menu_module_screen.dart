import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MenuModuleScreen extends StatelessWidget {
  const MenuModuleScreen.incidentHistory({super.key})
    : title = 'Incident History',
      subtitle = 'Review previous emergency events and response timelines.',
      icon = Icons.history_rounded,
      accentColor = AppColors.primary,
      highlights = const [
        'Recent incidents and outcomes',
        'Response time trends',
        'Export and report tools',
      ];

  const MenuModuleScreen.trainingModules({super.key})
    : title = 'Training Modules',
      subtitle = 'Skill drills and scenario-based responder training.',
      icon = Icons.school_outlined,
      accentColor = AppColors.tertiary,
      highlights = const [
        'CPR and first-aid refreshers',
        'Monthly readiness challenges',
        'Certification progress tracking',
      ];

  const MenuModuleScreen.equipmentStatus({super.key})
    : title = 'Equipment Status',
      subtitle = 'Track readiness of critical responder devices and kits.',
      icon = Icons.inventory_2_outlined,
      accentColor = AppColors.secondary,
      highlights = const [
        'Battery and connectivity status',
        'Maintenance reminders',
        'Field replacement checklist',
      ];

  const MenuModuleScreen.medicalRecords({super.key})
    : title = 'Medical Records',
      subtitle = 'Access medical notes and case attachments securely.',
      icon = Icons.note_alt_outlined,
      accentColor = AppColors.primaryContainer,
      highlights = const [
        'Attached case documents',
        'Medication and treatment notes',
        'Record timeline review',
      ];

  const MenuModuleScreen.insuranceInfo({super.key})
    : title = 'Insurance Info',
      subtitle = 'Policy references and emergency authorization details.',
      icon = Icons.verified_user_outlined,
      accentColor = AppColors.onSurfaceVariant,
      highlights = const [
        'Policy verification summary',
        'Emergency coverage rules',
        'Provider contact shortcuts',
      ];

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<String> highlights;

  void _showPendingFeature(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Backend actions will be connected in the next phase.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: accentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'READY FEATURES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...highlights.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 19,
                        color: accentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _showPendingFeature(context),
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text(
                  'Open Workspace',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
