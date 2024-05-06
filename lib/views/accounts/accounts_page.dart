import 'package:banking_app/shared/ba_dialog.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/views/home/components/account_card.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../models/user.dart';
import '../../utils/date.dart';
import '../../utils/spacing.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage(
      {super.key, required this.userData, required this.accountModel});

  final UserModel userData;
  final AccountModel accountModel;

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final formKey = GlobalKey<FormState>();
  final accountController = TextEditingController();
  final amountController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // toggle loading
  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: 'My Account',
      child: Column(
        children: [
          AccountCard(
            accountData: widget.accountModel,
            isLoading: false,
          ),
          AppSpacing.medium,

          // sort code
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Sort Code',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              widget.accountModel.sortCode,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // name
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Name',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              '${widget.accountModel.firstName} ${widget.accountModel.lastName}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // currency
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Currency',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              widget.accountModel.currency,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // created
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Created',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              formatDateString(widget.accountModel.createdAt),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // updated
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Updated',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              formatDateString(widget.accountModel.updatedAt),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // status
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Status',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              widget.accountModel.status,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // close account
          if (widget.accountModel.status != 'Closed') ...{
            AppSpacing.medium,
            const BADivider(),
            AppSpacing.small,
            TextButton(
              onPressed: () {
                BaDialog.showBaDialog(
                  context: context,
                  title: 'Close Account',
                  content: const Text(
                      'Are you sure you want to close your bank account? This action cannot be undone.'),
                  okText: 'ClOSE ACCOUNT',
                  cancelText: 'CANCEL',
                  onOk: () async {
                    Navigator.pop(context);
                    toggleLoading();
                    await closeBankAccount(widget.accountModel, context);
                    toggleLoading();
                  },
                  onCancel: () => Navigator.pop(context),
                );
              },
              child: const Text(
                'Close Account',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          },
        ],
      ),
    );
  }
}
