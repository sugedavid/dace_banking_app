import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BAPrimaryButton Widget Test', (WidgetTester tester) async {
    Future<void> mockAsyncFunction() async {
      await Future.delayed(const Duration(seconds: 3));
    }

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BAPrimaryButton(
          text: 'Continue',
          onPressed: () async {
            await mockAsyncFunction();
          },
        ),
      ),
    ));

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
