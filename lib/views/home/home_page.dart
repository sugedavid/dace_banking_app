import 'package:banking_app/models/user.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/views/accounts/accounts_page.dart';
import 'package:banking_app/views/deposit/deposit_page.dart';
import 'package:banking_app/views/home/components/account_card.dart';
import 'package:banking_app/views/home/components/service_card.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.userData});

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    var accountData = AccountModel.toEmpty();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            // Account balance
            FutureBuilder(
                future: authUserInfo(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AccountCard(accountData: userData.accounts[0]);
                  } else {
                    final userSnapshot = snapshot.data as UserModel;
                    accountData = userSnapshot.accounts[0];
                    return AccountCard(accountData: accountData);
                  }
                }),
            const SizedBox(height: 20.0),

            // service tiles
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              children: <Widget>[
                // deposit
                ServiceCard(
                  icon: const Icon(
                    Icons.upload_rounded,
                    size: 32.0,
                    color: Colors.green,
                  ),
                  title: 'Deposit',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DepositPage(
                        userData: userData,
                        accountData: accountData,
                      ),
                    ),
                  ),
                ),

                // withdraw
                ServiceCard(
                  icon: const Icon(
                    Icons.download_rounded,
                    size: 32.0,
                    color: Colors.redAccent,
                  ),
                  title: 'Withdraw',
                  onPressed: () {},
                ),

                // transfer
                ServiceCard(
                  icon: const Icon(
                    Icons.swap_horiz_rounded,
                    size: 32.0,
                    color: Colors.blue,
                  ),
                  title: 'Transfer',
                  onPressed: () {},
                ),

                // accounts
                ServiceCard(
                  icon: const Icon(
                    Icons.account_balance_rounded,
                    size: 32.0,
                    color: Colors.orange,
                  ),
                  title: 'My Accounts',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountsPage(
                        userData: userData,
                      ),
                    ),
                  ),
                ),

                // checkbook
                ServiceCard(
                  icon: const Icon(
                    Icons.book_rounded,
                    size: 32.0,
                    color: Colors.purple,
                  ),
                  title: 'Checkbooks',
                  onPressed: () {},
                ),

                // debit card
                ServiceCard(
                  icon: const Icon(
                    Icons.credit_card_rounded,
                    size: 32.0,
                    color: Colors.blueGrey,
                  ),
                  title: 'Debit/ Credit Cards',
                  onPressed: () {},
                ),

                // recurring payment
                ServiceCard(
                  icon: const Icon(
                    Icons.replay_rounded,
                    size: 32.0,
                    color: Colors.teal,
                  ),
                  title: 'Recurring Payments',
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
