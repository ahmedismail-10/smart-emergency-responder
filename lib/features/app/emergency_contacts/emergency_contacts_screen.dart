// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  int _nextId = 5;
  final List<_EmergencyContact> _contacts = [
    const _EmergencyContact(
      id: 1,
      name: 'Dr. James Wilson',
      role: 'Family Physician',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCxMa_3YoVsxhkv2VIptqknuxljQbxLxucLu7kC6ZOftokxhzd5tUZQptcTK21kapAxBJxFyV-9drEZsJL8TJ1s8SNKCNselwolrnYquLxlJ_hD4L7F8N0mv2laB5p9H0IQVcYDSFXgO7D8bEbJ3DWfCTjFA4z_p690UiejRiJe91W92hU_lsTV1D6AJCN_bNL3txPzR9u15K_CFbOzsujMA1qquu5bgtS0AY_KYF_DD8A45xOZJDsMqu7S08FtUqeLlR9k9sgix9-Q',
      primary: true,
    ),
    const _EmergencyContact(
      id: 2,
      name: 'Sarah Mitchell',
      role: 'Spouse',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCWzo8vdTBEvqlXqQgLOTD9oAw5py9b3fIhNY8AC1aUBBnwA_rrpe7TcF1rcPaq_kuOKFGIJFtXFCD8XFzzsWZXcS1q0kBQXiXvnyLheI8H97PC6WuZQM4LU3kFJIhzpxjaQzTwWGOJ9pMVsZLvWA4zDOrPjV7DqqenVDpCXJ3iio33GV_xYq9h0y-xo2hBfi7Ay_kOJPwT2B3quBVHzIN7lXDEj5fFXHB6-ZbqgvA_DnVS1WxLGafHK3yGcHf7-VLtSX60-TdHCvPY',
    ),
    const _EmergencyContact(
      id: 3,
      name: 'Robert Chen',
      role: 'Neighbor',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDBhqi-h7ytZVTBbwA1x-sZAPVFrcVHtrEjypkRp-YkKG_Iesbgz-dUs9wY1DWQYjEW6qFRGGmvIkbBdW_18Sjujuc4RwvWL8K9iPYYaNlsLjZPfp34ibjdKR2Fr8Ab-0hUGRtG5-GUt3uxGJUlOwCfplSiE02IUCfHuTlniDAhMPGTuQct2fhLNJCraydZpqxt-v--gNNnUTD8Q96Ar3GYqgLCQHxI_KkvCkOCzxWx9fc_qqZD2kfTDtINiskM50IbPigAx2UCxj7U',
    ),
    const _EmergencyContact(
      id: 4,
      name: 'Emma Davis',
      role: 'Daughter',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB5C464s0QjsphjQGalOEEKzheqQMBjjIm7TGvS2xtQIdZyDDu9QqT5WDD08f3O9QNQjbAScjdLnVFHU8dAz7AMW4QUyd-Wdsv5fB1YOtL1Hepg9O3dn1mfihLiw-83kMTFynbIun4qT63O2AtTo8TrktAHflvM8RL4ePwbZPEabJaXpetimB8ERbuNmktyHKcOEFQT_Blkt5hFTY7s76AiI5TnmFWincsc_gkPNP9KtAKNiVMoikBLwRHNm3fvvytVG8xzHVyTjrFS',
    ),
  ];

  Future<void> _openContactEditor({_EmergencyContact? contact}) async {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final roleController = TextEditingController(text: contact?.role ?? '');
    var isPrimary = contact?.primary ?? _contacts.isEmpty;

    final result = await showDialog<_ContactFormResult>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: roleController,
                      decoration: const InputDecoration(labelText: 'Role'),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 6),
                    SwitchListTile(
                      value: isPrimary,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Set as primary contact'),
                      onChanged: (value) =>
                          setDialogState(() => isPrimary = value),
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
                    final name = nameController.text.trim();
                    final role = roleController.text.trim();
                    if (name.isEmpty || role.isEmpty) {
                      return;
                    }
                    Navigator.of(dialogContext).pop(
                      _ContactFormResult(
                        name: name,
                        role: role,
                        primary: isPrimary,
                      ),
                    );
                  },
                  child: Text(contact == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    roleController.dispose();

    if (result == null) {
      return;
    }

    setState(() {
      if (result.primary) {
        for (var i = 0; i < _contacts.length; i++) {
          _contacts[i] = _contacts[i].copyWith(primary: false);
        }
      }

      if (contact == null) {
        _contacts.insert(
          0,
          _EmergencyContact(
            id: _nextId++,
            name: result.name,
            role: result.role,
            primary: result.primary,
          ),
        );
      } else {
        final index = _contacts.indexWhere((item) => item.id == contact.id);
        if (index != -1) {
          _contacts[index] = _contacts[index].copyWith(
            name: result.name,
            role: result.role,
            primary: result.primary,
          );
        }
      }

      if (_contacts.isNotEmpty &&
          !_contacts.any((contact) => contact.primary)) {
        _contacts[0] = _contacts[0].copyWith(primary: true);
      }
    });
  }

  Future<void> _deleteContact(_EmergencyContact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text('Delete ${contact.name} from emergency contacts?'),
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

    setState(() {
      _contacts.removeWhere((item) => item.id == contact.id);
      if (_contacts.isNotEmpty && !_contacts.any((item) => item.primary)) {
        _contacts[0] = _contacts[0].copyWith(primary: true);
      }
    });
  }

  void _callContact(_EmergencyContact contact) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Calling ${contact.name}...')));
  }

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
                onPressed: () => _openContactEditor(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Contact'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_contacts.isEmpty)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                'No contacts yet. Add at least one trusted contact to receive SOS alerts.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          else
            ..._contacts.map(
              (contact) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ContactTile(
                  contact: contact,
                  onEdit: () => _openContactEditor(contact: contact),
                  onDelete: () => _deleteContact(contact),
                  onCall: () => _callContact(contact),
                ),
              ),
            ),
          const SizedBox(height: 8),
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
                  'Keep one primary contact always available for the fastest emergency notification path.',
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
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onCall,
  });

  final _EmergencyContact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCall;

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
            child: contact.imageUrl != null
                ? Image.network(
                    contact.imageUrl!,
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
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: AppColors.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const Icon(Icons.person_rounded),
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
                        contact.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    if (contact.primary)
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
                  contact.role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            color: AppColors.onSurfaceVariant,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.error,
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              minimumSize: const Size(42, 42),
              backgroundColor: contact.primary
                  ? AppColors.primary
                  : AppColors.secondary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            onPressed: onCall,
            child: const Icon(Icons.call_rounded, size: 19),
          ),
        ],
      ),
    );
  }
}

class _ContactFormResult {
  const _ContactFormResult({
    required this.name,
    required this.role,
    required this.primary,
  });

  final String name;
  final String role;
  final bool primary;
}

class _EmergencyContact {
  const _EmergencyContact({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
    this.primary = false,
  });

  final int id;
  final String name;
  final String role;
  final String? imageUrl;
  final bool primary;

  _EmergencyContact copyWith({
    String? name,
    String? role,
    String? imageUrl,
    bool? primary,
  }) {
    return _EmergencyContact(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
      primary: primary ?? this.primary,
    );
  }
}
