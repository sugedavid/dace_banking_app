import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/utils/date.dart';
import 'package:banking_app/utils/firebase_utils/transaction_utils.dart';
import 'package:banking_app/views/transactions/transaction_detail_page.dart';
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
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.upload_outlined,
            size: 20.0,
            color: Colors.green,
          ),
        );

      case 'Withdrawal':
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.download_outlined,
            size: 20.0,
            color: Colors.redAccent,
          ),
        );

      case 'Transfer' || 'Received':
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.swap_horiz_outlined,
            size: 20.0,
            color: Colors.blue,
          ),
        );

      default:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 32.0,
            color: Colors.blue,
          ),
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
            List<TransactionModel> transactionData =
                snapshot.data as List<TransactionModel>;
            transactionData = transactionData.reversed.toList();
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
                        final transactionAmount = transactionType ==
                                    'Deposit' ||
                                (transaction.transactionType == 'Transfer' &&
                                    transaction.recipient?.userId ==
                                        userData.userId)
                            ? '+£${transaction.amount}'
                            : '-£${transaction.amount}';

                        return ListTile(
                          leading: trailingIcon(transactionType),
                          title: Text(
                            transactionType,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            formatDateString(transaction.createdAt),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                          trailing: Text(
                            transactionAmount,
                            style: TextStyle(
                              fontSize: 16,
                              color: transaction.transactionType == 'Deposit' ||
                                      (transaction.transactionType ==
                                              'Transfer' &&
                                          transaction.recipient?.userId ==
                                              userData.userId)
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailPage(
                                transaction: transaction,
                                user: userData,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }
        });
  }
}
