import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_dropdown_button.dart';
import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:banking_app/shared/ba_text_field.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/chequebook_utils.dart';
import 'package:flutter/material.dart';

class RequestCheckBook extends StatefulWidget {
  const RequestCheckBook({
    super.key,
    required this.userData,
    required this.currentAccount,
    required this.bankAccounts,
  });

  final UserModel userData;
  final AccountModel currentAccount;
  final List<AccountModel> bankAccounts;

  @override
  State<RequestCheckBook> createState() => _RequestCheckBookState();
}

class _RequestCheckBookState extends State<RequestCheckBook> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final accountController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();

  List<String> titleList = ['Mr.', 'Mrs.', 'Ms.'];

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: 'Request Chequebook',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // title
            BADropdownButton(
              labelText: 'Title',
              list: titleList,
              controller: titleController,
            ),

            // account
            BADropdownButton(
              labelText: 'Account',
              list: widget.bankAccounts.map((e) => e.accountNumber).toList(),
              controller: accountController,
            ),

            // address
            BATextField(
              labelText: 'Address',
              validate: true,
              controller: addressController,
              textInputType: TextInputType.streetAddress,
            ),

            // post code
            BATextField(
              labelText: 'Post Code',
              validate: true,
              controller: postCodeController,
              textInputType: TextInputType.streetAddress,
            ),

            // request
            BAPrimaryButton(
                text: 'Request',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await requestChequeBook(
                      accountNumber: accountController.text,
                      title: titleController.text,
                      address: addressController.text,
                      postCode: postCodeController.text,
                      userData: widget.userData,
                      currentAccount: widget.currentAccount,
                      bankAccounts: widget.bankAccounts,
                      context: context,
                    );

                    addressController.clear();
                    postCodeController.clear();
                  }
                })
          ],
        ),
      ),
    );
  }
}
