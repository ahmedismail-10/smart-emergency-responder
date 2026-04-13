import 'package:flutter/material.dart';

Future<bool> showLogoutConfirmationDialog(
  BuildContext context, {
  String title = 'Log Out',
  String message = 'Are you sure you want to log out?',
  String confirmLabel = 'Log Out',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
