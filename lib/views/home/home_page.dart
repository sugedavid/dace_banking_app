import 'package:banking_app/models/user.dart';
import 'package:banking_app/views/accounts/accounts_page.dart';
import 'package:banking_app/views/deposit/deposit_page.dart';
import 'package:banking_app/views/home/components/account_card.dart';
import 'package:banking_app/views/home/components/service_card.dart';
import 'package:banking_app/views/transfer/transfer_page.dart';
import 'package:banking_app/views/withdraw/withdraw_page.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../utils/firebase_utils/user_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userData});

  final UserModel userData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchBankAccountsByUserId(widget.userData.userId);
  }

  @override
  Widget build(BuildContext context) {
    var accountData = AccountModel.toEmpty();
    var bankAccounts = <AccountModel>[];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FutureBuilder(
            future: fetchDataFuture,
            builder: (context, snapshot) {
              // loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AccountCard(
                  accountData: accountData,
                  isLoading: true,
                );
              }
              // error state
              else if (snapshot.hasError) {
                return Center(
                  child:
                      Text('Error fetching account details: ${snapshot.error}'),
                );
              }
              // success state
              else {
                bankAccounts = snapshot.data as List<AccountModel>;
                if (bankAccounts.isNotEmpty) accountData = bankAccounts[0];
                return Column(
                  children: [
                    // Account balance
                    AccountCard(
                      accountData: accountData,
                      isLoading: false,
                    ),

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
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.upload_outlined,
                              size: 32.0,
                              color: Colors.green,
                            ),
                          ),
                          title: 'Deposit',
                          onPressed: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => DepositPage(
                                  userData: widget.userData,
                                  currentAccount: accountData,
                                  bankAccounts: bankAccounts),
                            ),
                          )
                              .then((value) {
                            // This function executes on pop back
                            setState(() {
                              fetchDataFuture = fetchBankAccountsByUserId(
                                  widget.userData.userId);
                            });
                          }),
                        ),

                        // withdraw
                        ServiceCard(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.download_outlined,
                              size: 32.0,
                              color: Colors.redAccent,
                            ),
                          ),
                          title: 'Withdraw',
                          onPressed: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => WithdrawPage(
                                userData: widget.userData,
                                currentAccount: accountData,
                                bankAccounts: bankAccounts,
                              ),
                            ),
                          )
                              .then((value) {
                            // This function executes on pop back
                            setState(() {
                              fetchDataFuture = fetchBankAccountsByUserId(
                                  widget.userData.userId);
                            });
                          }),
                        ),

                        // transfer
                        ServiceCard(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.swap_horiz_outlined,
                              size: 32.0,
                              color: Colors.blue,
                            ),
                          ),
                          title: 'Transfer',
                          onPressed: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => TransferPage(
                                userData: widget.userData,
                                currentAccount: accountData,
                                bankAccounts: bankAccounts,
                              ),
                            ),
                          )
                              .then((value) {
                            // This function executes on pop back
                            setState(() {
                              fetchDataFuture = fetchBankAccountsByUserId(
                                  widget.userData.userId);
                            });
                          }),
                        ),

                        // accounts
                        ServiceCard(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.account_balance_outlined,
                              size: 32.0,
                              color: Colors.orange,
                            ),
                          ),
                          title: 'My Account',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AccountsPage(
                                userData: widget.userData,
                                bankAccounts: bankAccounts,
                              ),
                            ),
                          ),
                        ),

                        // checkbook
                        ServiceCard(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.book_outlined,
                              size: 32.0,
                              color: Colors.purple,
                            ),
                          ),
                          title: 'Checkbooks',
                          onPressed: () => {},
                        ),

                        // debit card
                        ServiceCard(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.credit_card_outlined,
                              size: 32.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                          title: 'Debit/ Credit Cards',
                          onPressed: () {},
                        ),

                        // recurring payment
                        ServiceCard(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.replay_outlined,
                              size: 32.0,
                              color: Colors.teal,
                            ),
                          ),
                          title: 'Recurring Payments',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
