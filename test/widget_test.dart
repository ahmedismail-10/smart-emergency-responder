import 'package:emergency_responder/src/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows onboarding splash', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: EmergencyResponderApp()),
    );
    await tester.pump();

    expect(find.textContaining('GUARDIAN'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
