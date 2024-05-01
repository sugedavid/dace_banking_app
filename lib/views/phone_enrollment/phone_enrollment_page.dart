import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../shared/ba_primary_button.dart';
import '../../shared/ba_text_field.dart';

class PhoneEnrollmentPage extends StatefulWidget {
  const PhoneEnrollmentPage({
    super.key,
    this.firebaseAuthMultiFactorException,
    required this.userModel,
  });

  final FirebaseAuthMultiFactorException? firebaseAuthMultiFactorException;
  final UserModel userModel;

  @override
  PhoneEnrollmentPageState createState() => PhoneEnrollmentPageState();
}

class PhoneEnrollmentPageState extends State<PhoneEnrollmentPage>
    with SingleTickerProviderStateMixin {
  UserModel userModel = UserModel.toEmpty();

  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool resend = false;
  int remainingTime = 30;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
    phoneController.text = userModel.phoneNumber.isNotEmpty
        ? userModel.phoneNumber
        : widget.userModel.phoneNumber;
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
      title: 'Two Factor Authentication',
      child: Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.phoneVerificationImg,
                width: 70,
                height: 70,
              ),
              AppSpacing.medium,

              // title
              Text(
                widget.firebaseAuthMultiFactorException != null ||
                        widget.userModel.phoneEnrolled
                    ? 'Verify Phone'
                    : 'Enroll Phone Number',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              // message
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          'An sms with a verification code will be sent to your phone number ',
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                    ),
                    TextSpan(
                      text: userModel.phoneNumber,
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
              AppSpacing.large,

              // phoneNumber
              if (widget.firebaseAuthMultiFactorException == null) ...{
                AppSpacing.medium,
                BATextField(
                  labelText: 'Phone',
                  hintText: 'Enter phone e.g +44123456789',
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                ),
              },

              BATextField(
                labelText: 'Code',
                hintText: '######',
                controller: codeController,
                textInputType: TextInputType.number,
              ),
              AppSpacing.large,

              // continue
              BAPrimaryButton(
                  text: 'Continue',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context, codeController.text);
                      }
                    }
                  }),
              AppSpacing.medium,

              // resend code
              if (widget.firebaseAuthMultiFactorException != null)
                TextButton(
                  onPressed: resend
                      ? null
                      : () async {
                          startTimer();
                          if (userModel.phoneEnrolled) {
                            await verifySecondFactor(
                              widget.firebaseAuthMultiFactorException,
                              widget.userModel,
                              context,
                            );
                          } else {
                            // await enrollSecondFactor(
                            //   phoneController.text,
                            //   widget.userModel,
                            //   user,
                            //   context,
                            // );
                          }
                        },
                  child: Text(resend
                      ? 'Resend Code in $remainingTime secs'
                      : 'Resend Code'),
                ),

              // sign out
              TextButton(
                onPressed: () async => await signOutUser(context),
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
      ),
    );
  }
}
