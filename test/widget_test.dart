import 'package:emergency_responder/core/app/emergency_responder_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows startup splash then onboarding', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: EmergencyResponderApp()),
    );
    await tester.pump();

    expect(find.textContaining('GUARDIAN'), findsOneWidget);
    expect(find.text('Next'), findsNothing);

    await tester.pump(const Duration(seconds: 4));
    await tester.pump();

    expect(find.text('Emergency help instantly'), findsOneWidget);
  });
}
