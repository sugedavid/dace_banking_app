import 'dart:math';

import 'package:banking_app/views/Login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/ba_toast_notification.dart';

final db = FirebaseFirestore.instance;

// update user
Future<void> updateUser(UserCredential credential, String firstName,
    String lastName, String accountType, BuildContext context) async {
  String accountNumber = await generateUniqueAccountNumber();
  final user = <String, dynamic>{
    'firstName': firstName,
    'lastName': lastName,
    'email': credential.user?.email,
  };
  // reference to the Firestore collection for user accounts
  CollectionReference usersCollection = db.collection('users');
  // reference to the bank_accounts subcollection for the specified user
  CollectionReference bankAccountsCollection =
      usersCollection.doc(credential.user?.uid).collection('bank_accounts');

  usersCollection.doc(credential.user?.uid).set(user).then((value) {
    // add a new document to the bank_accounts subcollection
    bankAccountsCollection.add({
      'accountNumber': accountNumber,
      'accountType': accountType,
      // add other fields as needed
    }).then((value) {
      showToast('Account created sucessfully!', context);
      // TODO: Navigate to Home page
      MaterialPageRoute(
        builder: (context) => const LogInPage(),
      );
    }).catchError((error) {
      showToast('Oops! Something went wrong: $error', context);
      print(error);
    });
  }).catchError((error) {
    showToast('Oops! Something went wrong: $error', context);
    print(error);
  });
}

// function to generate a unique account number
Future<String> generateUniqueAccountNumber() async {
  var rng = Random();

  while (true) {
    var digits =
        List<int>.generate(10, (_) => rng.nextInt(10)); // for 10 digits
    String accountNumber = digits.join();

    // Query all bank_accounts subcollections of all users for the generated account number
    var querySnapshot = await db
        .collectionGroup('bank_accounts')
        .where('accountNumber', isEqualTo: accountNumber)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // If the account number does not exist in the database, it's unique and we can use it
      return accountNumber;
    }
  }
}
