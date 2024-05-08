import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:banking_app/views/deposit/deposit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DepositPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: DepositPage(
            userData: UserModel.toEmpty(),
            currentAccount: AccountModel.toEmpty(),
            bankAccounts: <AccountModel>[AccountModel.toEmpty()])));

    await tester.pump();
    expect(find.text('Deposit Cash'), findsOneWidget);
    expect(find.byType(BAPrimaryButton), findsOneWidget);
  });
}
