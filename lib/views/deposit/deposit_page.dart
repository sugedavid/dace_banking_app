import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_dropdown_button.dart';
import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:banking_app/shared/ba_text_field.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/firebase_utils/account_utils.dart';
import '../../utils/spacing.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({
    super.key,
    required this.userData,
    required this.currentAccount,
    required this.bankAccounts,
  });

  final UserModel userData;
  final AccountModel currentAccount;
  final List<AccountModel> bankAccounts;

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final formKey = GlobalKey<FormState>();
  final accountController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: 'Deposit Cash',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppSpacing.medium,

            // account
            BADropdownButton(
              labelText: 'Account',
              list: widget.bankAccounts.map((e) => e.accountNumber).toList(),
              controller: accountController,
            ),

            // amount
            BATextField(
              labelText: 'Amount',
              hintText: 'Minimum £5  - Maximum £5000',
              controller: amountController,
              textInputType: TextInputType.number,
              validator: () {
                if (double.parse(amountController.text) < 5 ||
                    double.parse(amountController.text) > 5000) {
                  return 'Minimum £5 - Maximum £5000';
                }
                return null;
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
              ],
            ),

            // description
            BATextField(
              labelText: 'Description',
              validate: false,
              controller: descriptionController,
              textInputType: TextInputType.text,
            ),

            AppSpacing.large,

            // deposit button
            BAPrimaryButton(
                text: 'Deposit',
                enable: amountController.text.isNotEmpty,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final account = widget.bankAccounts.firstWhere(
                        (e) => e.accountNumber == accountController.text);
                    final currentBalance = double.parse(account.amount);
                    final newBalance =
                        currentBalance + double.parse(amountController.text);

                    await depositCash(
                      userId: authUser()?.uid ?? '',
                      accountId: account.accountId,
                      accountNumber: account.accountNumber,
                      amount: amountController.text,
                      newBalance: newBalance.toStringAsFixed(2),
                      transactionDescription: descriptionController.text,
                      context: context,
                    );

                    amountController.clear();
                    descriptionController.clear();
                  }
                })
          ],
        ),
      ),
    );
  }
}
