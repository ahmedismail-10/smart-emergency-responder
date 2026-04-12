import 'package:flutter_riverpod/legacy.dart';

enum AppTab { home, map, contacts, profile }

final onboardingPageProvider = StateProvider<int>((ref) => 0);
final appTabProvider = StateProvider<AppTab>((ref) => AppTab.home);
final drawerOpenProvider = StateProvider<bool>((ref) => false);

final emergencyNotificationsProvider = StateProvider<bool>((ref) => true);
final audibleTonesProvider = StateProvider<bool>((ref) => true);
final darkModeProvider = StateProvider<bool>((ref) => false);
