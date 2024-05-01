import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_dropdown_button.dart';
import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:banking_app/shared/ba_text_field.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/account_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/ba_toast_notification.dart';
import '../../utils/firebase_utils/user_utils.dart';
import '../../utils/spacing.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({
    super.key,
    required this.userData,
    required this.currentAccount,
    required this.bankAccounts,
  });

  final UserModel userData;
  final AccountModel currentAccount;
  final List<AccountModel> bankAccounts;

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final formKey = GlobalKey<FormState>();
  final countryController = TextEditingController();
  final currencyController = TextEditingController(text: 'British Pound');
  final sortCodeController = TextEditingController();
  final accountController = TextEditingController();
  final recipientAccountController = TextEditingController();
  final amountController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const countries = ['United Kingdom'];
    return SinglePageScaffold(
      title: 'Transfer Cash',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppSpacing.medium,

            // account
            BADropdownButton(
              labelText: 'From Account',
              list: widget.bankAccounts.map((e) => e.accountNumber).toList(),
              controller: accountController,
            ),

            // country
            BADropdownButton(
              labelText: 'Country',
              list: countries,
              controller: countryController,
            ),

            // currency
            BATextField(
              labelText: 'Currency',
              validate: true,
              enabled: false,
              controller: currencyController,
              textInputType: TextInputType.text,
            ),

            // sort code
            BATextField(
              labelText: 'Sort code',
              hintText: '##-##-##',
              validate: true,
              controller: sortCodeController,
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
                SortCodeFormatter(),
              ],
            ),

            // account number
            BATextField(
              labelText: 'Account number',
              hintText: '##########',
              validate: true,
              controller: recipientAccountController,
              textInputType: TextInputType.number,
            ),

            // first and last name
            Row(
              children: [
                Expanded(
                  child: BATextField(
                    labelText: 'First Name',
                    controller: firstNameController,
                    textInputType: TextInputType.name,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: BATextField(
                    labelText: 'Last Name',
                    controller: lastNameController,
                    textInputType: TextInputType.name,
                  ),
                ),
              ],
            ),

            // amount
            BATextField(
              labelText: 'Amount',
              hintText: 'Minimum £5  - Maximum £5000',
              controller: amountController,
              textInputType: TextInputType.number,
              validator: () {
                if (double.parse(amountController.text) < 5) {
                  return 'Minimum £5';
                }
                if (double.parse(amountController.text) >
                    double.parse(widget.currentAccount.amount)) {
                  return 'Insufficient balance: £${widget.currentAccount.amount}';
                }
                if (double.parse(amountController.text) > 5000) {
                  return 'Maximum £5000';
                }
                return null;
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
              ],
            ),

            // email
            BATextField(
              labelText: 'Email',
              validate: false,
              controller: emailController,
              textInputType: TextInputType.text,
            ),

            AppSpacing.large,

            // deposit button
            BAPrimaryButton(
                text: 'Transfer',
                onPressed: () async {
                  // check if details entered matches user's account details
                  if (sortCodeController.text ==
                          widget.currentAccount.sortCode ||
                      recipientAccountController.text ==
                          widget.currentAccount.accountNumber) {
                    showToast(
                        "Cannot transfer to your own bank account", context);
                    return;
                  }

                  if (formKey.currentState!.validate()) {
                    final currentBalance =
                        double.parse(widget.currentAccount.amount);
                    final amountToSubtract =
                        double.parse(amountController.text);
                    final newBalance = currentBalance - amountToSubtract;

                    await transferCash(
                      userId: authUser()?.uid ?? '',
                      accountId: widget.currentAccount.accountId,
                      accountNumber: widget.currentAccount.accountNumber,
                      amount: amountToSubtract.toStringAsFixed(0),
                      newBalance: newBalance.toStringAsFixed(2),
                      recipientsortCode: sortCodeController.text,
                      recipientAccountNumber: recipientAccountController.text,
                      recipientFirstName: firstNameController.text,
                      recipientLastName: lastNameController.text,
                      context: context,
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
