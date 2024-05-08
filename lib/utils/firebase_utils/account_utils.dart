// update account balance
import 'dart:math';

import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/recipient.dart';
import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';
import '../../shared/ba_toast_notification.dart';
import '../../views/sucess/sucess_page.dart';

// update account balance
Future<void> depositCash(
    {required String userId,
    required String accountId,
    required String accountNumber,
    required String amount,
    required String newBalance,
    required String transactionDescription,
    required BuildContext context}) async {
  try {
    String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await dbInstance.collection('bankAccounts').doc(accountId).update({
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
        transactionStatus: 'Completed',
        transactionDescription: transactionDescription,
        transactionRef: generateTransactionReceipt('DEP'),
        userId: userId,
        accountId: accountId,
        accountNumber: accountNumber,
        createdAt: createdAt,
        amount: amount,
      );
      await transactionRef.set(transaction.toMap());

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SuccessPage(
              message: 'Amount deposited successfully',
              secondaryBtnTxt: 'Make another transaction',
            ),
          ),
        );
      }
    });
  } catch (error) {
    // error
    if (context.mounted) {
      showToast('Error crediting account: $error', context,
          status: Status.error);
    }
  }
}

// withdraw cash
Future<void> withdrawCash(
    {required String userId,
    required String accountId,
    required String accountNumber,
    required String amount,
    required String newBalance,
    required BuildContext context}) async {
  try {
    String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await dbInstance.collection('bankAccounts').doc(accountId).update({
      'amount': newBalance,
      'updatedAt': createdAt,
    }).then((value) async {
      // generate transaction
      var transactionId = dbInstance.collection('transactions').doc().id;
      var transactionRef =
          dbInstance.collection('transactions').doc(transactionId);
      var transaction = TransactionModel(
        transactionId: transactionRef.id,
        transactionType: 'Withdrawal',
        transactionStatus: 'Completed',
        transactionRef: generateTransactionReceipt('WITH'),
        userId: userId,
        accountId: accountId,
        accountNumber: accountNumber,
        createdAt: createdAt,
        amount: amount,
      );
      await transactionRef.set(transaction.toMap());

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SuccessPage(
              message: 'Amount withdrawn successfully',
              secondaryBtnTxt: 'Make another transaction',
            ),
          ),
        );
      }
    });
  } catch (error) {
    // error
    if (context.mounted) {
      showToast('Error withdrawing cash: $error', context,
          status: Status.error);
    }
  }
}

// transfer cash
Future<void> transferCash(
    {required String userId,
    required String accountId,
    required String accountNumber,
    required String recipientsortCode,
    required String recipientAccountNumber,
    required String recipientFirstName,
    required String recipientLastName,
    required String amount,
    required String newBalance,
    required DateTime? recurring,
    required BuildContext context}) async {
  try {
    String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    // fetch receipient's info
    var recipientAccount = await fetchUserAccount(
      sortCode: recipientsortCode,
      accountNumber: recipientAccountNumber,
      context: context,
    );
    // exit fun if account isn't found
    if (recipientAccount.accountId.isEmpty) return;

    var newReceipientBalance =
        double.parse(recipientAccount.amount) + double.parse(amount);

    // update sender's account
    await dbInstance.collection('bankAccounts').doc(accountId).update({
      'amount': newBalance,
      'updatedAt': createdAt,
    }).then((value) async {
      // update recipient's account
      await dbInstance
          .collection('bankAccounts')
          .doc(recipientAccount.accountId)
          .update({
        'amount': newReceipientBalance.toStringAsFixed(2),
        'updatedAt': createdAt,
      }).then((value) async {
        // generate transaction
        var transactionId = dbInstance.collection('transactions').doc().id;
        var transactionRef =
            dbInstance.collection('transactions').doc(transactionId);
        var transaction = TransactionModel(
          transactionId: transactionRef.id,
          transactionType: recurring != null ? 'Recurring Payment' : 'Transfer',
          transactionStatus: 'Completed',
          transactionRef: generateTransactionReceipt('TRA'),
          userId: userId,
          accountId: accountId,
          accountNumber: accountNumber,
          recipient: RecipientModel(
            userId: recipientAccount.userId,
            firstName: recipientAccount.firstName,
            lastName: recipientAccount.lastName,
            sortCode: recipientAccount.sortCode,
            accountNumber: recipientAccount.accountNumber,
            accountId: recipientAccount.accountId,
            email: recipientAccount.email,
          ),
          recurring: recurring.toString(),
          createdAt: createdAt,
          amount: amount,
        );
        await transactionRef.set(transaction.toMap());

        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SuccessPage(
                message: 'Amount transfered successfully',
                secondaryBtnTxt: 'Make another transaction',
              ),
            ),
          );
        }
      });
    });
  } catch (error) {
    // error
    if (context.mounted) {
      showToast('Error transfering cash: $error', context,
          status: Status.error);
    }
  }
}

// cancel recurring transfer
Future<void> cancelRecurringTransfer({
  required TransactionModel transaction,
  required BuildContext context,
}) async {
  try {
    if (transaction.transactionId.isEmpty || transaction.recurring == null) {
      return;
    }

    // update transaction
    await dbInstance
        .collection('transactions')
        .doc(transaction.transactionId)
        .update({
      'transactionStatus': 'Cancelled',
    }).then((value) async {
      if (context.mounted) {
        showToast('Recurring transfer cancelled', context,
            status: Status.success);
        Navigator.of(context).pop();
      }
    });
  } catch (error) {
    // error
    if (context.mounted) {
      showToast('Error transfering cash: $error', context,
          status: Status.error);
    }
  }
}

// fetch user account
Future<AccountModel> fetchUserAccount({
  required String sortCode,
  required String accountNumber,
  required BuildContext context,
}) async {
  var recipient = AccountModel.toEmpty();
  try {
    var bankRef = dbInstance
        .collection('bankAccounts')
        .where('sortCode', isEqualTo: sortCode)
        .where('accountNumber', isEqualTo: accountNumber);
    var bankSnapshot = await bankRef.get();
    if (bankSnapshot.docs.isEmpty) {
      if (context.mounted) {
        showToast("Recipient's bank details not found", context,
            status: Status.warning);
      }
    } else {
      recipient = AccountModel.fromDocument(bankSnapshot.docs[0]);
    }
  } catch (error) {
    // error fetching transaction data
    if (context.mounted) {
      showToast("Error fetching recipient's info: $error", context,
          status: Status.error);
    }
  }
  return recipient;
}

// generate transaction
Future<void> generateTransaction(
    {required TransactionModel transaction,
    required BuildContext context}) async {
  try {
    var transactionRef = dbInstance.collection('transactions');
    await transactionRef.add(transaction.toMap()).then((value) {
      showToast('Transaction generated successfully!', context,
          status: Status.success);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScaffold(),
          ),
          (route) => false);
    });
  } catch (error) {
    // error generating transaction
    if (context.mounted) {
      showToast('Error generating transaction: $error', context,
          status: Status.error);
    }
  }
}

// generate transaction ref
String generateTransactionReceipt(String transactionType) {
  String randomString = "";
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  for (int i = 0; i < 10; i++) {
    randomString += chars[Random().nextInt(chars.length)];
  }
  return '$transactionType-$randomString';
}
