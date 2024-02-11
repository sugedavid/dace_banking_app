// register user
import 'package:banking_app/shared/toast_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// register a new user
Future<void> registerUser(
    String emailAddress, String password, BuildContext context) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showToast('The password provided is too weak.', context);
    } else if (e.code == 'email-already-in-use') {
      showToast('The account already exists for that email.', context);
    }
  } catch (e) {
    showToast(
        'Oops! Could not register your account: ${e.toString()}', context);
  }
}

// login a user
Future<void> logInUser(
    String emailAddress, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    print(credential.toString());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showToast('No user found for that email.', context);
    } else if (e.code == 'wrong-password') {
      showToast('Wrong password provided for that user.', context);
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      showToast('Invalid login credentials', context);
    }
  } catch (e) {
    showToast('Oops! Something went wrong: ${e.toString()}', context);
  }
}
