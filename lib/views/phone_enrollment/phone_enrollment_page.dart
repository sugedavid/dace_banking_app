import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../shared/ba_primary_button.dart';
import '../../shared/ba_text_field.dart';
import '../../utils/colors.dart';

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
  late User? user;
  UserModel userModel = UserModel.toEmpty();

  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool resend = false;
  int remainingTime = 30;

  @override
  void initState() {
    user = authUser();
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
      title: (user?.emailVerified ?? false) || user == null
          ? 'Two Factor Authentication'
          : 'Account Verification',
      child: Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ((user?.emailVerified ?? false) ||
                        widget.userModel.emailVerified ||
                        widget.firebaseAuthMultiFactorException != null)
                    ? AppAssets.phoneVerificationImg
                    : AppAssets.emailVerificationImg,
                width: 70,
                height: 70,
              ),
              AppSpacing.medium,

              // title
              Text(
                widget.firebaseAuthMultiFactorException != null ||
                        widget.userModel.phoneEnrolled
                    ? 'Verify Phone'
                    : !userModel.phoneEnrolled && (user?.emailVerified ?? false)
                        ? 'Enroll Phone Number'
                        : 'Verify Email',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              // message
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.firebaseAuthMultiFactorException != null ||
                              (!userModel.phoneEnrolled &&
                                  (user?.emailVerified ?? false))
                          ? 'An sms with a code will be sent to your phone number'
                          : 'An email with a verification link will be sent to ',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.blueGrey),
                    ),
                    TextSpan(
                      text:
                          user?.emailVerified ?? false ? '' : user?.email ?? '',
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
              if ((!userModel.phoneEnrolled &&
                  (user?.emailVerified ?? false))) ...{
                AppSpacing.medium,
                BATextField(
                  labelText: 'Phone',
                  hintText: 'Enter phone e.g +44123456789',
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                ),
              },

              if (widget.firebaseAuthMultiFactorException != null ||
                  (user?.emailVerified ?? false)) ...{
                BATextField(
                  labelText: 'Code',
                  hintText: '######',
                  controller: codeController,
                  textInputType: TextInputType.number,
                ),
                AppSpacing.large,
              },

              // continue
              BAPrimaryButton(
                  text: widget.firebaseAuthMultiFactorException != null ||
                          (!userModel.phoneEnrolled &&
                              (user?.emailVerified ?? false))
                      ? 'Continue'
                      : 'Send verification email',
                  onPressed: !(user?.emailVerified ?? false) &&
                          widget.firebaseAuthMultiFactorException == null
                      ? () async => await verifyUserEmail(context)
                      : () async {
                          if (formKey.currentState!.validate()) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context, codeController.text);
                            } else {
                              if (userModel.phoneEnrolled) {
                                await verifySecondFactor(
                                  widget.firebaseAuthMultiFactorException,
                                  widget.userModel,
                                  context,
                                );
                              } else {
                                await enrollSecondFactor(
                                  phoneController.text,
                                  widget.userModel,
                                  context,
                                );
                              }
                            }
                          }
                        }),
              AppSpacing.medium,

              // resend code
              if ((user?.emailVerified ?? false) ||
                  widget.firebaseAuthMultiFactorException != null)
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
                            await enrollSecondFactor(
                              phoneController.text,
                              widget.userModel,
                              context,
                            );
                          }
                        },
                  child: Text(resend
                      ? 'Resend Code in $remainingTime secs'
                      : 'Resend Code'),
                ),

              // verified email
              if (!(user?.emailVerified ?? false) &&
                  widget.firebaseAuthMultiFactorException == null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    text: TextSpan(
                      text: 'Verified already? ',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.blueGrey),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Continue',
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async => await enrollSecondFactor(
                                  phoneController.text,
                                  widget.userModel,
                                  context,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

              // sign out
              TextButton(
                onPressed: () => signOutUser(context),
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
