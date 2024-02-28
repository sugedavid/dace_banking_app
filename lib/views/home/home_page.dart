import 'package:banking_app/utils/colors.dart';
import 'package:banking_app/views/home/components/service_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            // Account balance
            Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const ListTile(
                  title: Text(
                    'Personal Account',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    '1234567890',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    '£12,345.67',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
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
              children: const <Widget>[
                // deposit
                ServiceCard(
                  icon: Icon(
                    Icons.upload_rounded,
                    size: 32.0,
                    color: Colors.green,
                  ),
                  title: 'Deposit',
                ),

                // withdraw
                ServiceCard(
                  icon: Icon(
                    Icons.download_rounded,
                    size: 32.0,
                    color: Colors.redAccent,
                  ),
                  title: 'Withdraw',
                ),

                // transfer
                ServiceCard(
                  icon: Icon(
                    Icons.swap_horiz_rounded,
                    size: 32.0,
                    color: Colors.blue,
                  ),
                  title: 'Transfer',
                ),

                // accounts
                ServiceCard(
                  icon: Icon(
                    Icons.account_balance_rounded,
                    size: 32.0,
                    color: Colors.orange,
                  ),
                  title: 'My Accounts',
                ),

                // checkbook
                ServiceCard(
                  icon: Icon(
                    Icons.book_rounded,
                    size: 32.0,
                    color: Colors.purple,
                  ),
                  title: 'Checkbooks',
                ),

                // debit card
                ServiceCard(
                  icon: Icon(
                    Icons.credit_card_rounded,
                    size: 32.0,
                    color: Colors.blueGrey,
                  ),
                  title: 'Debit/ Credit Cards',
                ),

                // recurring payment
                ServiceCard(
                  icon: Icon(
                    Icons.replay_rounded,
                    size: 32.0,
                    color: Colors.teal,
                  ),
                  title: 'Recurring Payments',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
