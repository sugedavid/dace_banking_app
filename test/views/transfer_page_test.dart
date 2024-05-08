import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:banking_app/views/transfer/transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TransferPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: TransferPage(
            userData: UserModel.toEmpty(),
            currentAccount: AccountModel.toEmpty(),
            bankAccounts: <AccountModel>[AccountModel.toEmpty()])));

    await tester.pump();
    expect(find.text('Transfer Cash'), findsOneWidget);
    expect(find.byType(BAPrimaryButton), findsOneWidget);
  });
}
