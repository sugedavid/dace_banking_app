import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import '../../shared/ba_toast_notification.dart';

// fetch transactions
Future<List<TransactionModel>> fetchTransactions(
    {required String userId,
    required String accountId,
    required BuildContext context}) async {
  var transactionList = <TransactionModel>[];
  try {
    var transactionRef = dbInstance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('accountId', isEqualTo: accountId)
        .orderBy('createdAt', descending: true);

    var receipientTransactionRef = dbInstance
        .collection('transactions')
        .where('recipient.userId', isEqualTo: userId)
        .where('recipient.accountId', isEqualTo: accountId)
        .orderBy('createdAt', descending: true);

    var transactionSnapshot = await transactionRef.get();
    for (var transaction in transactionSnapshot.docs) {
      transactionList.add(TransactionModel.fromMap(transaction.data()));
    }

    // user as receipient
    var receipientTransactionSnapshot = await receipientTransactionRef.get();
    for (var transaction in receipientTransactionSnapshot.docs) {
      transactionList.add(TransactionModel.fromMap(transaction.data()));
    }
  } catch (error) {
    // error fetching transaction data
    showToast('Error fetching transaction data: $error', context,
        status: Status.error);
  }
  transactionList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return transactionList;
}
