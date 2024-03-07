// update account balance
import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';
import '../../shared/ba_toast_notification.dart';

// update account balance
Future<void> updateAccountBalance(
    {required String userId,
    required String accountId,
    required String accountNumber,
    required String amount,
    required String newBalance,
    required String transactionDescription,
    required BuildContext context}) async {
  try {
    String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await dbInstance
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .doc(accountId)
        .update({
      'amount': newBalance,
      'updatedAt': createdAt,
    }).then((value) async {
      // generate transaction
      var transactionId = dbInstance.collection('transactions').doc().id;
      var transactionRef =
          dbInstance.collection('transactions').doc(transactionId);
      var transaction = TransactionModel(
        transactionId: transactionRef.id,
        transactionType: 'Deposit',
        transactionStatus: 'completed',
        transactionDescription: transactionDescription,
        userId: userId,
        accountId: accountId,
        accountNumber: accountNumber,
        createdAt: createdAt,
        amount: amount,
      );
      await transactionRef.set(transaction.toMap());

      if (context.mounted) {
        showToast('Account balance updated sucessfully!', context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainScaffold(),
            ),
            (route) => false);
      }
    });
  } catch (error) {
    // error updating account balance
    showToast('Error updating account balance: $error', context);
  }
}

// generate transaction
Future<void> generateTransaction(
    {required TransactionModel transaction,
    required BuildContext context}) async {
  try {
    var transactionRef = dbInstance.collection('transactions');
    await transactionRef.add(transaction.toMap()).then((value) {
      showToast('Transaction generated sucessfully!', context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScaffold(),
          ),
          (route) => false);
    });
  } catch (error) {
    // error generating transaction
    showToast('Error generating transaction: $error', context);
  }
}
