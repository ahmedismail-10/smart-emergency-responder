// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _nextConditionId = 4;
  String _displayName = 'Marcus Sterling';
  String _rescueId = '#44920';
  String _fullName = 'Marcus Avery Sterling';
  String _address = '1224 Maritime Dr, Seattle, WA';
  String _bloodType = 'O+';
  int _age = 34;

  final List<_MedicalCondition> _conditions = [
    const _MedicalCondition(
      id: 1,
      status: 'Active',
      title: 'Latex Allergy',
      description: 'Severe reaction to surgical gloves and equipment.',
      color: AppColors.error,
    ),
    const _MedicalCondition(
      id: 2,
      status: 'Chronic',
      title: 'Asthma',
      description: 'Exercise induced. Rescue inhaler in left side pocket.',
      color: AppColors.onSurfaceVariant,
    ),
    const _MedicalCondition(
      id: 3,
      status: 'Managed',
      title: 'Nearsightedness',
      description: 'Requires corrective lenses for navigation.',
      color: AppColors.secondary,
    ),
  ];

  Color _colorForStatus(String status) {
    return switch (status) {
      'Active' => AppColors.error,
      'Chronic' => AppColors.onSurfaceVariant,
      'Managed' => AppColors.secondary,
      _ => AppColors.onSurfaceVariant,
    };
  }

  Future<void> _editProfile() async {
    final displayNameController = TextEditingController(text: _displayName);
    final rescueIdController = TextEditingController(text: _rescueId);
    final fullNameController = TextEditingController(text: _fullName);
    final addressController = TextEditingController(text: _address);
    final bloodTypeController = TextEditingController(text: _bloodType);
    final ageController = TextEditingController(text: _age.toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: displayNameController,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: rescueIdController,
                  decoration: const InputDecoration(labelText: 'Rescue ID'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: bloodTypeController,
                  decoration: const InputDecoration(labelText: 'Blood Type'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) {
      displayNameController.dispose();
      rescueIdController.dispose();
      fullNameController.dispose();
      addressController.dispose();
      bloodTypeController.dispose();
      ageController.dispose();
      return;
    }

    final parsedAge = int.tryParse(ageController.text.trim());
    if (parsedAge == null || parsedAge <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Please enter a valid age.')),
          );
      }
      displayNameController.dispose();
      rescueIdController.dispose();
      fullNameController.dispose();
      addressController.dispose();
      bloodTypeController.dispose();
      ageController.dispose();
      return;
    }

    setState(() {
      _displayName = displayNameController.text.trim();
      _rescueId = rescueIdController.text.trim();
      _fullName = fullNameController.text.trim();
      _address = addressController.text.trim();
      _bloodType = bloodTypeController.text.trim();
      _age = parsedAge;
    });

    displayNameController.dispose();
    rescueIdController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    bloodTypeController.dispose();
    ageController.dispose();
  }

  Future<void> _editSimpleField({
    required String title,
    required String value,
    required ValueChanged<String> onSave,
  }) async {
    final controller = TextEditingController(text: value);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (result == null || result.isEmpty) {
      return;
    }

    setState(() => onSave(result));
  }

  Future<void> _editCondition({_MedicalCondition? condition}) async {
    final titleController = TextEditingController(text: condition?.title ?? '');
    final descriptionController = TextEditingController(
      text: condition?.description ?? '',
    );
    var selectedStatus = condition?.status ?? 'Active';

    final result = await showDialog<_ConditionFormResult>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                condition == null ? 'Add Condition' : 'Edit Condition',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const ['Active', 'Chronic', 'Managed']
                          .map(
                            (status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setDialogState(() => selectedStatus = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      minLines: 2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();
                    if (title.isEmpty || description.isEmpty) {
                      return;
                    }
                    Navigator.of(dialogContext).pop(
                      _ConditionFormResult(
                        status: selectedStatus,
                        title: title,
                        description: description,
                      ),
                    );
                  },
                  child: Text(condition == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();

    if (result == null) {
      return;
    }

    setState(() {
      if (condition == null) {
        _conditions.add(
          _MedicalCondition(
            id: _nextConditionId++,
            status: result.status,
            title: result.title,
            description: result.description,
            color: _colorForStatus(result.status),
          ),
        );
      } else {
        final index = _conditions.indexWhere((item) => item.id == condition.id);
        if (index != -1) {
          _conditions[index] = _conditions[index].copyWith(
            status: result.status,
            title: result.title,
            description: result.description,
            color: _colorForStatus(result.status),
          );
        }
      }
    });
  }

  Future<void> _deleteCondition(_MedicalCondition condition) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Condition'),
          content: Text('Delete "${condition.title}" from profile?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _conditions.removeWhere((item) => item.id == condition.id));
  }

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
                onPressed: _editProfile,
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
                Text(
                  _displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'Rescue ID: $_rescueId',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ProfileStatCard(
                  icon: Icons.bloodtype_rounded,
                  title: 'Blood Type',
                  value: _bloodType,
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileStatCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'Age',
                  value: '$_age yrs',
                  iconColor: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRowCard(
            icon: Icons.person_outline_rounded,
            title: 'Full Name',
            value: _fullName,
            onTap: () => _editSimpleField(
              title: 'Full Name',
              value: _fullName,
              onSave: (value) => _fullName = value,
            ),
          ),
          const SizedBox(height: 10),
          _InfoRowCard(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: _address,
            onTap: () => _editSimpleField(
              title: 'Address',
              value: _address,
              onSave: (value) => _address = value,
            ),
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
                Row(
                  children: [
                    const Icon(
                      Icons.medical_services_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Medical Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.errorContainer,
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () => _editCondition(),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        'Add',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_conditions.isEmpty)
                  const Text(
                    'No conditions added yet.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                else
                  ..._conditions.map(
                    (condition) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ConditionCard(
                        condition: condition,
                        onEdit: () => _editCondition(condition: condition),
                        onDelete: () => _deleteCondition(condition),
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
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
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
                Icons.edit_outlined,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.condition,
    required this.onEdit,
    required this.onDelete,
  });

  final _MedicalCondition condition;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
                condition.status.toUpperCase(),
                style: TextStyle(
                  color: condition.color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.onSurfaceVariant,
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            condition.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            condition.description,
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

class _MedicalCondition {
  const _MedicalCondition({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.color,
  });

  final int id;
  final String status;
  final String title;
  final String description;
  final Color color;

  _MedicalCondition copyWith({
    String? status,
    String? title,
    String? description,
    Color? color,
  }) {
    return _MedicalCondition(
      id: id,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }
}

class _ConditionFormResult {
  const _ConditionFormResult({
    required this.status,
    required this.title,
    required this.description,
  });

  final String status;
  final String title;
  final String description;
}
