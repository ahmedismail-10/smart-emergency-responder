import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AppSectionThemeWrapper extends ConsumerWidget {
  const AppSectionThemeWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final themedChild = Theme(
      data: darkMode ? AppTheme.dark : AppTheme.light,
      child: child,
    );

    if (!darkMode) {
      return themedChild;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        themedChild,
        const IgnorePointer(child: ColoredBox(color: Color(0x66000000))),
      ],
    );
  }
}
