import 'dart:math';

import 'package:banking_app/models/user.dart';
import 'package:banking_app/views/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/account.dart';
import '../../shared/ba_toast_notification.dart';
import '../../views/sucess/sucess_page.dart';

// db reference
final dbInstance = FirebaseFirestore.instance;

// update user
Future<void> updateUser(UserCredential credential, String firstName,
    String lastName, String accountType, BuildContext context) async {
  try {
    String accountNumber = await generateUniqueAccountNumber();
    String sortCode = await generateSortCode();

    final user = UserModel(
      userId: credential.user?.uid ?? '',
      firstName: firstName,
      lastName: lastName,
      email: credential.user?.email ?? '',
    );

    // reference to the Firestore collection
    final usersCollection = dbInstance.collection('users');
    final bankAccountsCollection = dbInstance.collection('bankAccounts');

    // reference to the accounts subcollection for the specified user
    final bankAccountsCollectionId = bankAccountsCollection.doc().id;
    final bankAccountsCollectionRef =
        bankAccountsCollection.doc(bankAccountsCollectionId);

    usersCollection
        .doc(credential.user?.uid)
        .set(user.toFirestore())
        .then((value) {
      String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      final account = AccountModel(
        accountId: bankAccountsCollectionId,
        amount: '0.00', // initial balance
        accountNumber: accountNumber,
        accountType: accountType,
        createdAt: createdAt,
        updatedAt: createdAt,
        sortCode: sortCode,
        currency: '£',
        firstName: firstName,
        lastName: lastName,
        email: credential.user?.email,
        userId: credential.user?.uid ?? '',
      );

      // add a new document to the accounts subcollection
      bankAccountsCollectionRef.set(account.toMap()).then((value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SuccessPage(
              message: 'Account created sucessfully',
            ),
          ),
        );
      });
    });
  } catch (error) {
    // error handling
    showToast('Oops! Something went wrong: $error', context);
  }
}

// function to generate a unique account number
Future<String> generateUniqueAccountNumber() async {
  var rng = Random();

  while (true) {
    var digits =
        List<int>.generate(10, (_) => rng.nextInt(10)); // for 10 digits
    String accountNumber = digits.join();

    // query all accounts subcollections of all users for the generated account number
    var querySnapshot = await dbInstance
        .collectionGroup('accounts')
        .where('accountNumber', isEqualTo: accountNumber)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // if the account number does not exist in the database, it's unique and we can use it
      return accountNumber;
    }
  }
}

// function to generate a unique sort code
Future<String> generateSortCode() async {
  while (true) {
    List<String> parts = [];
    for (var i = 0; i < 3; i++) {
      // generate a random two-digit number between 00 and 99 (inclusive).
      String part = Random().nextInt(100).toString().padLeft(2, '0');
      parts.add(part);
    }
    String sortCode = parts.join('-');

    // query all accounts subcollections of all users for the generated sort code
    var querySnapshot = await dbInstance
        .collectionGroup('accounts')
        .where('sortCode', isEqualTo: sortCode)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // if the account number does not exist in the database, it's unique and we can use it
      return sortCode;
    }
  }
}

// authenticated user
User? authUser() {
  return FirebaseAuth.instance.currentUser;
}

// user information
Future<UserModel> authUserInfo(BuildContext context) async {
  var user = authUser();
  if (user != null) {
    UserModel data = UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
    );
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, _) => user.toFirestore(),
          )
          .get();

      if (documentSnapshot.exists) {
        // user document found
        data = documentSnapshot.data() as UserModel;
        return data;
      } else {
        // user document does not exist
        return data;
      }
    } catch (error) {
      // error fetching user information
      showToast('Error getting your information: $error', context);
      return data;
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context);
    return UserModel.toEmpty();
  }
}

// update user information
Future<void> updateUserInfo(
    String firstName, String lastName, BuildContext context) async {
  var user = authUser();
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': firstName,
        'lastName': lastName,
      }).then((value) {
        showToast('Profile updated sucessfully!', context);
      });
    } catch (error) {
      // error updating user profile
      showToast('Error updating your profile: $error', context);
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context);
  }
}

// fetch user bank accounts
Future<List<AccountModel>> fetchBankAccountsByUserId(String userId) async {
  CollectionReference bankAccountsRef =
      FirebaseFirestore.instance.collection('bankAccounts');
  QuerySnapshot querySnapshot =
      await bankAccountsRef.where('userId', isEqualTo: userId).get();
  List<DocumentSnapshot> documents = querySnapshot.docs;
  List<AccountModel> bankAccounts = documents.map((document) {
    return AccountModel.fromDocument(document);
  }).toList();
  return bankAccounts;
}

// close user account
Future<void> closeUserAccount(BuildContext context) async {
  var user = authUser();
  if (user != null) {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      // get a reference to all documents in the subcollection
      final accountsQuery = userRef.collection('accounts');

      // delete each document individually
      await accountsQuery.get().then((querySnapshot) async {
        for (final doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      });
      // delete the user document
      await dbInstance
          .collection('users')
          .doc(user.uid)
          .delete()
          .then((value) async {
        // delete the user account
        await user.delete();
      });

      if (context.mounted) {
        showToast('Account closed sucessfully!', context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LogInPage(),
          ),
        );
      }
    } catch (error) {
      // error deleting user
      showToast('Error closing your account: $error', context);
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context);
  }
}

// reset password
Future<void> resetPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      showToast('Password reset email sent!', context);
    });
  } catch (error) {
    // error sending password reset email
    showToast('Error sending password reset email: $error', context);
  }
}
