import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AnalyzeSymptomsScreen extends StatefulWidget {
  const AnalyzeSymptomsScreen({super.key});

  @override
  State<AnalyzeSymptomsScreen> createState() => _AnalyzeSymptomsScreenState();
}

class _AnalyzeSymptomsScreenState extends State<AnalyzeSymptomsScreen> {
  static const List<String> _symptoms = [
    'Chest Pain',
    'Shortness of Breath',
    'High Fever',
    'Severe Headache',
    'Dizziness',
    'Nausea',
    'Severe Bleeding',
    'Loss of Consciousness',
    'Rapid Heart Rate',
    'Allergic Reaction',
  ];

  final TextEditingController _notesController = TextEditingController();
  final Set<String> _selectedSymptoms = <String>{};
  double _severity = 5;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _canAnalyze => _selectedSymptoms.isNotEmpty;

  void _toggleSymptom(String symptom, bool selected) {
    setState(() {
      if (selected) {
        _selectedSymptoms.add(symptom);
      } else {
        _selectedSymptoms.remove(symptom);
      }
    });
  }

  _AssessmentResult _buildResult() {
    const highRiskSymptoms = <String>{
      'Chest Pain',
      'Shortness of Breath',
      'Severe Bleeding',
      'Loss of Consciousness',
    };
    final hasHighRiskSymptom = _selectedSymptoms.any(highRiskSymptoms.contains);

    if (hasHighRiskSymptom || _severity >= 8) {
      return const _AssessmentResult(
        level: 'High Priority',
        title: 'Immediate medical attention recommended',
        details:
            'Your reported symptoms suggest a potentially critical condition. Contact emergency services immediately.',
        color: AppColors.error,
        icon: Icons.warning_amber_rounded,
      );
    }

    if (_severity >= 5 || _selectedSymptoms.length >= 3) {
      return const _AssessmentResult(
        level: 'Moderate Priority',
        title: 'Please seek medical guidance soon',
        details:
            'Your symptoms should be reviewed by a healthcare professional as soon as possible.',
        color: AppColors.tertiary,
        icon: Icons.health_and_safety_rounded,
      );
    }

    return const _AssessmentResult(
      level: 'Low Priority',
      title: 'Monitor your condition',
      details:
          'Current signs look manageable, but keep monitoring your symptoms and escalate if they worsen.',
      color: AppColors.secondary,
      icon: Icons.check_circle_rounded,
    );
  }

  void _analyze() {
    final result = _buildResult();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: result.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(result.icon, color: result.color),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.level.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: result.color,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        result.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                result.details,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analyze Symptoms')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Choose your symptoms and severity to get a quick triage recommendation.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SYMPTOMS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptoms.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) => _toggleSymptom(symptom, selected),
                  selectedColor: AppColors.errorContainer,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.35)
                        : AppColors.outline.withValues(alpha: 0.25),
                  ),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'SEVERITY',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _severity.toStringAsFixed(0),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _severity,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _severity.toStringAsFixed(0),
                    activeColor: AppColors.primary,
                    onChanged: (value) => setState(() => _severity = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _notesController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Additional Notes (optional)',
                hintText: 'Add context like medication, time of symptoms, etc.',
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _canAnalyze ? _analyze : null,
                icon: const Icon(Icons.analytics_outlined),
                label: const Text(
                  'Analyze Now',
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

class _AssessmentResult {
  const _AssessmentResult({
    required this.level,
    required this.title,
    required this.details,
    required this.color,
    required this.icon,
  });

  final String level;
  final String title;
  final String details;
  final Color color;
  final IconData icon;
}
