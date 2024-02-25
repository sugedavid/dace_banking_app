import 'dart:math';

import 'package:banking_app/models/user.dart';
import 'package:banking_app/views/Login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/ba_toast_notification.dart';
import '../../shared/main_scaffold.dart';

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
  final usersCollection = db.collection('users');
  // reference to the accounts subcollection for the specified user
  final bankAccountsCollection =
      usersCollection.doc(credential.user?.uid).collection('accounts');

  usersCollection.doc(credential.user?.uid).set(user).then((value) {
    // add a new document to the accounts subcollection
    bankAccountsCollection.add({
      'accountNumber': accountNumber,
      'accountType': accountType,
      // add other fields as needed
    }).then((value) {
      showToast('Account created sucessfully!', context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScaffold(),
        ),
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

    // Query all accounts subcollections of all users for the generated account number
    var querySnapshot = await db
        .collectionGroup('accounts')
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
  var user = authUser();
  if (user != null) {
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
  var user = authUser();
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
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
      await db.collection('users').doc(user.uid).delete().then((value) async {
        // delete the user account
        await user.delete();
      }).catchError((error) {
        showToast('Error closing your account: $error', context);
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
    }).catchError((error) {
      showToast('Error sending password reset email: $error', context);
    });
  } catch (error) {
    // error sending password reset email
    showToast('Error sending password reset email: $error', context);
  }
}
