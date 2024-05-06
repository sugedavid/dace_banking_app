import 'dart:math';

import 'package:banking_app/models/user.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
import 'package:banking_app/views/email_verification/email_verification_page.dart';
import 'package:banking_app/views/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/account.dart';
import '../../shared/ba_toast_notification.dart';

// db reference
final dbInstance = FirebaseFirestore.instance;

// update user
Future<void> updateUser(
    UserCredential credential,
    String firstName,
    String lastName,
    String accountType,
    String phoneNumber,
    BuildContext context) async {
  try {
    String accountNumber = await generateUniqueAccountNumber();
    String sortCode = await generateSortCode();

    final user = UserModel(
      userId: credential.user?.uid ?? '',
      firstName: firstName,
      lastName: lastName,
      email: credential.user?.email ?? '',
      phoneNumber: phoneNumber,
      emailVerified: credential.user?.emailVerified ?? false,
      phoneEnrolled: false,
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
          bankName: 'DACE',
          status: 'Active');

      // add a new document to the accounts subcollection
      bankAccountsCollectionRef.set(account.toMap()).then((value) {
        // verify email
        if (context.mounted) {
          verifyUserEmail(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => EmailVerificationPage(
                  userModel: user,
                ),
              ),
              (route) => false);
        }
      });
    });
  } catch (error) {
    // error handling
    if (context.mounted) {
      showToast('Oops! Something went wrong: $error', context,
          status: Status.error);
    }
  }
}

// function to generate a unique account number
Future<String> generateUniqueAccountNumber() async {
  var rng = Random();

  while (true) {
    var digits =
        List<int>.generate(10, (_) => rng.nextInt(10)); // for 10 digits
    String accountNumber = digits.join();

    // query all bankAccounts subcollections of all users for the generated account number
    var querySnapshot = await dbInstance
        .collection('bankAccounts')
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

    // query all bankAccounts subcollections of all users for the generated sort code
    var querySnapshot = await dbInstance
        .collection('bankAccounts')
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
  User? user = FirebaseAuth.instance.currentUser;
  user?.reload();

  return user;
}

// reauthenticate user
// reauthenticate user
Future<void> reAuthUser(
  String email,
  String password,
  UserModel? userModel,
  BuildContext context,
) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    // reauthenticate user
    await user?.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );

    // enroll second factor
    if (context.mounted) {
      enrollSecondFactor(
        userModel?.phoneNumber ?? '',
        userModel ?? UserModel.toEmpty(),
        context,
      );
    }
  } catch (error) {
    if (context.mounted) {
      showToast('Oops! Something went wrong: $error', context,
          status: Status.error);
    }
  }
}

// user information
Future<UserModel> authUserInfo(BuildContext context) async {
  var user = authUser();
  if (user != null) {
    UserModel data = UserModel.toEmpty();
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
      if (context.mounted) {
        showToast('Error getting your information: $error', context,
            status: Status.error);
      }
      return data;
    }
  } else {
    // user is not authenticated
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
        showToast('Profile updated successfully!', context,
            status: Status.success);
      });
    } catch (error) {
      // error updating user profile
      if (context.mounted) {
        showToast('Error updating your profile: $error', context,
            status: Status.error);
      }
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context, status: Status.error);
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
      final accountsQuery = userRef.collection('bankAccounts');

      // delete each document individually
      await accountsQuery.get().then((querySnapshot) async {
        for (final doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      });
      // delete the user document
      await dbInstance.collection('users').doc(user.uid).delete();

      // delete the user account
      await user.delete();

      if (context.mounted) {
        showToast('Account closed successfully!', context,
            status: Status.error);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LogInPage(),
          ),
        );
      }
    } catch (error) {
      // error deleting user
      if (context.mounted) {
        showToast('Error closing your account: $error', context,
            status: Status.error);
      }
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context, status: Status.error);
  }
}

// close bank account
Future<void> closeBankAccount(
    AccountModel account, BuildContext context) async {
  var user = authUser();
  if (user != null) {
    try {
      // update account
      await dbInstance
          .collection('bankAccounts')
          .doc(account.accountId)
          .update({
        'status': 'Closed',
      }).then((value) async {
        // update bank account
        if (context.mounted) {
          showToast('Bank account closed successfully!', context,
              status: Status.success);
          Navigator.of(context).pop();
        }
      });
    } catch (error) {
      // error deleting user
      if (context.mounted) {
        showToast('Error closing your account: $error', context,
            status: Status.error);
      }
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context, status: Status.error);
  }
}

// reset password
Future<void> resetPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      showToast('Password reset email sent', context, status: Status.success);
    });
  } catch (error) {
    // error sending password reset email
    if (context.mounted) {
      showToast('Error sending password reset email: $error', context,
          status: Status.error);
    }
  }
}

// fetch user details by id
Future<UserModel> getUserById(String userId, BuildContext context) async {
  UserModel data = UserModel.toEmpty();
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
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
    if (context.mounted) {
      showToast('Error getting your information: $error', context,
          status: Status.error);
    }
    return data;
  }
}
