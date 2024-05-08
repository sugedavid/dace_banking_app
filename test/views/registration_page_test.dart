import 'package:banking_app/views/registration/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ResgistrationPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ResgistrationPage(),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('First name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
