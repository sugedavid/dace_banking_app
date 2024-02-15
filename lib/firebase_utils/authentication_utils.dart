// register user
import 'package:banking_app/firebase_utils/user_utils.dart';
import 'package:banking_app/shared/ba_toast_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// register a new user
Future<void> registerUser(
    String firstName,
    String lastName,
    String emailAddress,
    String password,
    String businessType,
    BuildContext context) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    if (context.mounted) {
      updateUser(credential, firstName, lastName, businessType, context);
    }
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
    if (context.mounted) {
      showToast('Logged in sucessfully.', context);
    }
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
