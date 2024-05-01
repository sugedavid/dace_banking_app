import 'package:banking_app/shared/ba_toast_notification.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../shared/ba_primary_button.dart';
import '../../shared/main_scaffold.dart';
import '../../utils/colors.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  EmailVerificationPageState createState() => EmailVerificationPageState();
}

class EmailVerificationPageState extends State<EmailVerificationPage>
    with SingleTickerProviderStateMixin {
  UserModel userModel = UserModel.toEmpty();

  bool resend = false;
  int remainingTime = 30;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
  }

  void toggleResendCode() {
    setState(() {
      resend = !resend;
    });
  }

  void startTimer() async {
    toggleResendCode();
    while (remainingTime > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        remainingTime--;
      });
    }
    toggleResendCode();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: 'Account Verification',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.emailVerificationImg,
              width: 70,
              height: 70,
            ),
            AppSpacing.medium,

            // title
            const Text(
              'Verify Email',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // message
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'An email with a verification link has been sent to ',
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                  TextSpan(
                    text: authUser()?.email ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.xxxLarge,

            // continue
            BAPrimaryButton(
              text: 'Continue',
              onPressed: () async {
                if (authUser()?.emailVerified ?? false) {
                  showToast('Signed in', context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MainScaffold(),
                      ),
                      (route) => false);
                } else {
                  showToast('Verify your email to continue', context,
                      status: Status.info);
                }
              },
            ),
            AppSpacing.large,

            // resend
            Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                text: TextSpan(
                  text: "Didn't get the email? ",
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Resend',
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async => await verifyUserEmail(context),
                    ),
                  ],
                ),
              ),
            ),

            // sign out
            TextButton(
              onPressed: () async => signOutUser(context),
              child: const Text(
                'Sign out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
