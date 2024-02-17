import 'package:banking_app/views/Login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/ba_toast_notification.dart';

final db = FirebaseFirestore.instance;

// update user
Future<void> updateUser(UserCredential credential, String firstName,
    String lastName, String accountType, BuildContext context) async {
  try {
    final user = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': credential.user?.email,
      'accountType': accountType
    };
    db.collection("users").doc(credential.user?.uid).set(user).then(
        (value) => print('Document added with ID: ${credential.user?.uid}'));

    showToast('Account created sucessfully!', context);
    // TODO: Navigate to Home page
    MaterialPageRoute(
      builder: (context) => const LogInPage(),
    );
  } on FirebaseAuthException catch (e) {
    showToast('Oops! Something went wrong: ${e.message}', context);
  } catch (e) {
    showToast('Oops! Something went wrong: ${e.toString()}', context);
  }
}
