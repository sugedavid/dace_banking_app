// update account balance
import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/chequebook.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_toast_notification.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/views/sucess/sucess_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// request chequebook
Future<void> requestChequeBook({
  required String accountNumber,
  required String title,
  required String address,
  required String postCode,
  required UserModel userData,
  required AccountModel currentAccount,
  required List<AccountModel> bankAccounts,
  required BuildContext context,
}) async {
  try {
    final user = authUser();
    String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    final collection = dbInstance.collection('chequeBooks');
    final collectionId = collection.doc().id;
    final collectionRef = collection.doc(collectionId);

    final chequeBook = ChequeBookModel(
        id: collectionId,
        accountNumber: accountNumber,
        createdAt: createdAt,
        title: title,
        address: address,
        postCode: postCode,
        userId: user?.uid ?? '');

    collectionRef.set(chequeBook.toMap()).then((value) async {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SuccessPage(
              message: 'Chequebook requested successfully',
              secondaryBtnTxt: 'View requested chequebooks',
              secondaryBtnCallback: () => Navigator.of(context).pop(),
            ),
          ),
        );
      }
    });
  } catch (error) {
    // error
    if (context.mounted) {
      showToast('Error requesting chequebook: $error', context,
          status: Status.error);
    }
  }
}

// fetch chequebooks
Future<List<ChequeBookModel>> fetchChequeBooks(
    {required String userId,
    required String accountId,
    required BuildContext context}) async {
  var chequeBooks = <ChequeBookModel>[];
  try {
    var chequeBookRef = dbInstance
        .collection('chequeBooks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    var querySnapshot = await chequeBookRef.get();
    for (var chequeBook in querySnapshot.docs) {
      chequeBooks.add(ChequeBookModel.fromMap(chequeBook.data()));
    }
  } catch (error) {
    // error fetching chequebooks
    if (context.mounted) {
      showToast('Error fetching chequebooks: $error', context,
          status: Status.error);
    }
  }
  return chequeBooks;
}
