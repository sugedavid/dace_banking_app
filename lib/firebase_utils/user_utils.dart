import 'dart:math';

import 'package:banking_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/ba_toast_notification.dart';
import '../shared/main_scaffold.dart';

final db = FirebaseFirestore.instance;

// update user
Future<void> updateUser(UserCredential credential, String firstName,
    String lastName, String accountType, BuildContext context) async {
  String accountNumber = await generateUniqueAccountNumber();
  final user = <String, dynamic>{
    'firstName': firstName,
    'lastName': lastName,
    'email': credential.user?.email,
    'accountType': accountType,
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
      MaterialPageRoute(
        builder: (context) => const MainScaffold(),
      );
    }).catchError((error) {
      showToast('Oops! Something went wrong: $error', context);
    });
  }).catchError((error) {
    showToast('Oops! Something went wrong: $error', context);
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

// authenticated user
User? authUser() {
  return FirebaseAuth.instance.currentUser;
}

// user information
Future<UserModel> authUserInfo(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user = authUser();
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, _) => user.toFirestore(),
          )
          .get();

      if (documentSnapshot.exists) {
        // User document found
        UserModel data = documentSnapshot.data() as UserModel;
        return data;
      } else {
        // user document does not exist
        return UserModel(
          firstName: '',
          lastName: '',
          email: '',
          accountType: '',
        );
      }
    } catch (error) {
      // error fetching user information
      showToast('Error getting your information: $error', context);
      return UserModel(
        firstName: '',
        lastName: '',
        email: '',
        accountType: '',
      );
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context);
    return UserModel(
      firstName: '',
      lastName: '',
      email: '',
      accountType: '',
    );
  }
}

// update user information
Future<void> updateUserInfo(String firstName, String lastName,
    String accountType, BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) {
    var user = authUser();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'firstName': firstName,
        'lastName': lastName,
        'accountType': accountType,
      }).then((value) {
        showToast('Profile updated sucessfully!', context);
      }).catchError((error) {
        showToast('Oops! Something went wrong: $error', context);
      });
    } catch (error) {
      // error updating user information
      showToast('Error updating your information: $error', context);
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context);
  }
}
