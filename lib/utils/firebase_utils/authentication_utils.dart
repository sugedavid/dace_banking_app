import 'package:banking_app/shared/ba_toast_notification.dart';
import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// register a new user
Future<void> registerUser(
    String firstName,
    String lastName,
    String emailAddress,
    String password,
    String accountType,
    BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    )
        .then((UserCredential credential) {
      // update user details
      updateUser(credential, firstName, lastName, accountType, context);
    });
  } on FirebaseAuthException catch (e) {
    // error handling
    if (e.code == 'weak-password') {
      showToast('The password provided is too weak.', context);
    } else if (e.code == 'email-already-in-use') {
      showToast('The account already exists for that email.', context);
    } else {
      showToast(e.message ?? 'Oops! Something went wrong', context);
    }
  } catch (e) {
    // error handling
    showToast(
        'Oops! Could not register your account: ${e.toString()}', context);
  }
}

// login a user
Future<void> logInUser(
    String emailAddress, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    )
        .then((UserCredential value) {
      // navigate to home page
      showToast('Signed in sucessfully.', context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScaffold(),
        ),
      );
    });
  } on FirebaseAuthException catch (e) {
    // firebase error handling
    if (e.code == 'user-not-found') {
      showToast('No user found for that email.', context);
    } else if (e.code == 'wrong-password') {
      showToast('Wrong password provided for that user.', context);
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      showToast('Invalid login credentials', context);
    } else {
      showToast(e.message ?? 'Oops! Something went wrong', context);
    }
  } catch (e) {
    // error handling
    showToast('Oops! Something went wrong: ${e.toString()}', context);
  }
}

// sign out a user
Future<void> signOutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut().then((value) {
    showToast('Logged out sucessfully.', context);
  }).catchError((error) {
    // error handling
    showToast('Oops! Something went wrong: $error', context);
  });
}
