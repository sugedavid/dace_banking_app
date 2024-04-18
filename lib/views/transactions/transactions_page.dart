import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/utils/date.dart';
import 'package:banking_app/utils/firebase_utils/transaction_utils.dart';
import 'package:flutter/material.dart';

import '../../models/transaction.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage(
      {super.key, required this.userData, required this.bankAccounts});

  final UserModel userData;
  final List<AccountModel> bankAccounts;

  Widget trailingIcon(type) {
    switch (type) {
      case 'Deposit':
        return const Icon(
          Icons.upload_outlined,
          size: 20.0,
          color: Colors.green,
        );

      case 'Withdrawal':
        return const Icon(
          Icons.download_outlined,
          size: 20.0,
          color: Colors.redAccent,
        );

      case 'Transfer':
        return const Icon(
          Icons.swap_horiz_outlined,
          size: 20.0,
          color: Colors.blue,
        );

      default:
        return const Icon(
          Icons.image_not_supported_outlined,
          size: 32.0,
          color: Colors.blue,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchTransactions(
            userId: userData.userId,
            accountId: bankAccounts[0].accountId,
            context: context),
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          // error state
          else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching transaction data: ${snapshot.error}'),
            );
          }
          // success state
          else {
            final transactionData = snapshot.data as List<TransactionModel>;
            return transactionData.isEmpty
                ? const Center(
                    child: ListTile(
                      title: Text(
                        'Transactions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Your recent transactions will appear here.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const BADivider(),
                      itemCount: transactionData.length,
                      itemBuilder: (context, index) {
                        final transaction =
                            snapshot.data?[index] as TransactionModel;
                        final transactionType = transaction.transactionType;
                        final transactionAmount = transactionType == 'Deposit'
                            ? '+£${transaction.amount}'
                            : '-£${transaction.amount}';

                        return ListTile(
                          leading: trailingIcon(transactionType),
                          title: Text(
                            transaction.transactionType,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            formatDateString(transaction.createdAt),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          trailing: Text(
                            transactionAmount,
                            style: TextStyle(
                                fontSize: 16,
                                color: transaction.transactionType == 'Deposit'
                                    ? Colors.green
                                    : Colors.redAccent),
                          ),
                        );
                      },
                    ),
                  );
          }
        });
  }
}
