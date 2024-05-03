import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_dialog.dart';
import 'package:banking_app/shared/ba_toast_notification.dart';
import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/views/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../views/phone_enrollment/phone_enrollment_page.dart';

// register a new user
Future<void> registerUser(
    String firstName,
    String lastName,
    String emailAddress,
    String password,
    String accountType,
    String phoneNumber,
    BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailAddress, password: password)
        .then((UserCredential credential) {
      // update user details
      updateUser(
          credential, firstName, lastName, accountType, phoneNumber, context);
    });
  } on FirebaseAuthException catch (e) {
    // error handling
    if (e.code == 'weak-password') {
      if (context.mounted) {
        showToast('The password provided is too weak.', context,
            status: Status.error);
      }
    } else if (e.code == 'email-already-in-use') {
      if (context.mounted) {
        showToast('The account already exists for that email.', context,
            status: Status.error);
      }
    } else {
      if (context.mounted) {
        showToast(e.message ?? 'Oops! Something went wrong', context,
            status: Status.error);
      }
    }
  } catch (e) {
    // error handling
    if (context.mounted) {
      showToast(
          'Oops! Could not register your account: ${e.toString()}', context,
          status: Status.error);
    }
  }
}

// login a user
Future<void> logInUser(
    String emailAddress, String password, BuildContext context) async {
  UserModel user = await authUserInfo(context);
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    )
        .then((UserCredential value) {
      // navigate to home page
      showToast('Signed in', context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScaffold(),
          ),
          (route) => false);
    });
  } on FirebaseAuthMultiFactorException catch (e) {
    // verify second factor
    if (context.mounted) {
      verifySecondFactor(e, user, context);
    }
  } on FirebaseAuthException catch (e) {
    // firebase error handling
    if (e.code == 'user-not-found') {
      if (context.mounted) {
        showToast('No user found for that email.', context,
            status: Status.error);
      }
    } else if (e.code == 'wrong-password') {
      if (context.mounted) {
        {
          showToast('Wrong password provided for that user.', context,
              status: Status.error);
        }
      }
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      if (context.mounted) {
        showToast('Invalid login credentials', context, status: Status.error);
      }
    } else {
      if (context.mounted) {
        {
          showToast(e.message ?? 'Oops! Something went wrong', context,
              status: Status.error);
        }
      }
    }
  } catch (e) {
    // error handling
    if (context.mounted) {
      showToast('Oops! Something went wrong: ${e.toString()}', context);
    }
  }
}

// handle phone enrollment
Future<void> handlePhoneEnrollment(
    UserModel userModel, BuildContext context) async {
  User? currUser = authUser();
  await currUser!.reload();
  if (currUser.emailVerified) {
    // proceed to main page
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScaffold(),
          ),
          (route) => false);
    }
  } else {
    // proceed with phone number enrollment
    if (context.mounted) {
      BaDialog.showBaDialog(
          context: context,
          title: 'Two Factor Authentication',
          content: PhoneEnrollmentPage(
            userModel: userModel,
          ));
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => PhoneEnrollmentPage(
      //         userModel: userModel,
      //       ),
      //     ),
      //     (route) => false);
    }
  }
}

// enrol second factor
Future<void> enrollSecondFactor(
  String phoneNumber,
  UserModel userModel,
  BuildContext context,
) async {
  final user = authUser();
  final session = await user?.multiFactor.getSession();
  final auth = FirebaseAuth.instance;
  await auth.verifyPhoneNumber(
    multiFactorSession: session,
    phoneNumber: phoneNumber,
    verificationCompleted: (_) {
      showToast('Phone number enrolled successfully', context,
          status: Status.success);
    },
    verificationFailed: (e) {
      showToast('${e.message}', context,
          action: SnackBarAction(
            label: 'Sign out',
            onPressed: () async => await signOutUser(context),
          ));
    },
    codeSent: (String verificationId, int? resendToken) async {
      showToast('Code sent successfully', context, status: Status.success);

      String smsCode = await getSmsCodeFromUser(null, userModel, context) ?? '';

      if (smsCode.isNotEmpty) {
        // create a PhoneAuthCredential with the code
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        try {
          await user?.multiFactor.enroll(
            PhoneMultiFactorGenerator.getAssertion(
              credential,
            ),
          );
          // update phone
          final usersCollection = dbInstance.collection('users');
          usersCollection.doc(user?.uid).update({
            'phoneNumber': phoneNumber,
            'phoneEnrolled': true,
            'emailVerified': true,
          });

          // navigate to main page
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainScaffold(),
                ),
                (route) => false);
          }
        } on FirebaseAuthException catch (e) {
          if (context.mounted) {
            showToast('${e.message}', context, status: Status.error);
          }
        }
      }
    },
    codeAutoRetrievalTimeout: (_) {},
  );
}

// verify second factor
Future<void> verifySecondFactor(
  FirebaseAuthMultiFactorException? firebaseAuthMultiFactorException,
  UserModel userModel,
  BuildContext context,
) async {
  final user = authUser();
  user?.reload();

  final firstHint = firebaseAuthMultiFactorException?.resolver.hints.first;
  if (firstHint is! PhoneMultiFactorInfo) {
    return;
  }

  await FirebaseAuth.instance.verifyPhoneNumber(
    multiFactorSession: firebaseAuthMultiFactorException?.resolver.session,
    multiFactorInfo: firstHint,
    verificationCompleted: (_) {
      showToast('Phone number verified successfully', context,
          status: Status.success);
    },
    verificationFailed: (e) {
      showToast('${e.message}', context,
          action: SnackBarAction(
            label: 'Sign out',
            onPressed: () async => await signOutUser(context),
          ));
    },
    codeSent: (String verificationId, int? resendToken) async {
      showToast('Code sent successfully', context, status: Status.success);

      String smsCode = await getSmsCodeFromUser(
              firebaseAuthMultiFactorException, userModel, context) ??
          '';

      if (smsCode.isNotEmpty) {
        // PhoneAuthCredential with the code
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        try {
          // verify
          await firebaseAuthMultiFactorException?.resolver.resolveSignIn(
            PhoneMultiFactorGenerator.getAssertion(
              credential,
            ),
          );

          // update phone
          final usersCollection = dbInstance.collection('users');
          usersCollection.doc(user?.uid).update({
            'phoneEnrolled': true,
          });

          // navigate to main page
          if (context.mounted) {
            showToast('Signed in', context, status: Status.success);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainScaffold(),
                ),
                (route) => false);
          }
        } on FirebaseAuthException catch (e) {
          if (context.mounted) {
            showToast('${e.message}', context, status: Status.error);
          }
        }
      }
    },
    codeAutoRetrievalTimeout: (_) {},
  );
}

// get sms code from user
Future<String?> getSmsCodeFromUser(FirebaseAuthMultiFactorException? e,
    UserModel userModel, BuildContext context) async {
  String result = '';
  if (context.mounted) {
    result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PhoneEnrollmentPage(
                firebaseAuthMultiFactorException: e,
                userModel: userModel,
              )),
    );
  }

  return result;
}

// verify email
Future<void> verifyUserEmail(BuildContext context) async {
  try {
    final user = authUser();
    await user?.sendEmailVerification().then((_) {
      // update user
      final usersCollection = dbInstance.collection('users');
      usersCollection.doc(user.uid).update({
        'emailVerified': user.emailVerified,
      });

      showToast('Email verification sent successfully', context,
          status: Status.success);
    });
  } on FirebaseAuthException catch (e) {
    // firebase error handling
    if (e.code == 'user-not-found') {
      if (context.mounted) {
        showToast('No user found for that email.', context,
            status: Status.error);
      }
    } else if (e.code == 'wrong-password') {
      if (context.mounted) {
        showToast('Wrong password provided for that user.', context,
            status: Status.error);
      }
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      if (context.mounted) {
        showToast('Invalid login credentials', context, status: Status.error);
      }
    } else {
      if (context.mounted) {
        showToast(e.message ?? 'Oops! Something went wrong', context,
            status: Status.error);
      }
    }
  } catch (e) {
    // error handling
    if (context.mounted) {
      showToast('Oops! Something went wrong: ${e.toString()}', context,
          status: Status.error);
    }
  }
}

// sign out a user
Future<void> signOutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut().then((value) {
    showToast('Signed out', context, status: Status.success);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LogInPage(),
        ),
        (route) => false);
  }).catchError((error) {
    // error handling
    showToast('Oops! Something went wrong: $error', context,
        status: Status.error);
  });
}
