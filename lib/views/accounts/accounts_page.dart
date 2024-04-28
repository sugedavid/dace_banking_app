import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/views/home/components/account_card.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../models/user.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage(
      {super.key, required this.userData, required this.bankAccounts});

  final UserModel userData;
  final List<AccountModel> bankAccounts;

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
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.bankAccounts.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          final accountData = widget.bankAccounts[index];
          return AccountCard(
            accountData: accountData,
            isLoading: false,
          );
          // return ListTile(
          //   title: Text(accountNumber),
          //   subtitle: const Text('Account Number'),
          //   trailing: const Icon(Icons.arrow_forward_ios),
          //   onTap: () {
          //     // navigate to account details
          //   },
          // );
        },
      ),
    );
  }
}
