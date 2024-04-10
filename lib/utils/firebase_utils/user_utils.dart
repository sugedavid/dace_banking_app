import 'dart:math';

import 'package:banking_app/models/user.dart';
import 'package:banking_app/views/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/account.dart';
import '../../shared/ba_toast_notification.dart';
import '../../shared/main_scaffold.dart';

// db reference
final dbInstance = FirebaseFirestore.instance;

// update user
Future<void> updateUser(UserCredential credential, String firstName,
    String lastName, String accountType, BuildContext context) async {
  try {
    String accountNumber = await generateUniqueAccountNumber();
    final user = UserModel(
      userId: credential.user?.uid ?? '',
      firstName: firstName,
      lastName: lastName,
      email: credential.user?.email ?? '',
      accountType: accountType,
      accounts: [],
    );
    // reference to the Firestore collection for user accounts
    final usersCollection = dbInstance.collection('users');
    // reference to the accounts subcollection for the specified user
    final bankAccountsCollectionId = usersCollection
        .doc(credential.user?.uid)
        .collection('accounts')
        .doc()
        .id;
    final bankAccountsCollectionRef = usersCollection
        .doc(credential.user?.uid)
        .collection('accounts')
        .doc(bankAccountsCollectionId);

    usersCollection
        .doc(credential.user?.uid)
        .set(user.toFirestore())
        .then((value) {
      String createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      final account = AccountModel(
        accountId: bankAccountsCollectionId,
        amount: '0.00', // initial balance
        accountNumber: accountNumber,
        accountType: accountType, createdAt: createdAt, updatedAt: createdAt,
      );

      // add a new document to the accounts subcollection
      bankAccountsCollectionRef.set(account.toMap()).then((value) {
        showToast('Account created sucessfully!', context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainScaffold(),
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

    // Query all accounts subcollections of all users for the generated account number
    var querySnapshot = await dbInstance
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
    UserModel data = UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
      accountType: '',
      accounts: [],
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

        // fetch accounts from subcollection
        QuerySnapshot accountsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('accounts')
            .get();

        // convert account documents to AccountModel objects
        List<AccountModel> accounts = accountsSnapshot.docs
            .map(
              (doc) =>
                  AccountModel.fromMap(doc.data()! as Map<String, dynamic>),
            )
            .toList();

        // update UserModel with fetched accounts
        data = data.copyWith(accounts: accounts);

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
    return UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
      accountType: '',
      accounts: [],
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
