import 'package:banking_app/shared/ba_dialog.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../shared/ba_text_field.dart';
import '../../shared/ba_toast_notification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  final UserModel userData;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  // toggle loading
  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = authUser();
    return SingleChildScrollView(
      child: Column(
        children: [
          // profile
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    size: 20,
                  ),
                  title: Text(
                      '${widget.userData.firstName} ${widget.userData.lastName}'),
                ),
                const BADivider(indent: 56),

                // email
                ListTile(
                  leading: const Icon(
                    Icons.email_outlined,
                    size: 20,
                  ),
                  title: Text(widget.userData.email),
                  trailing: ActionChip(
                    label: Text(user?.emailVerified ?? false
                        ? 'Verified'
                        : 'Not Verified'),
                    padding: EdgeInsets.zero,
                    backgroundColor: user?.emailVerified ?? false
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    labelStyle: TextStyle(
                        color: user?.emailVerified ?? false
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12),
                    side: BorderSide.none,
                    onPressed: () async => user?.emailVerified ?? false
                        ? showToast('Email verified', context,
                            status: Status.info)
                        : await verifyUserEmail(context),
                  ),
                ),
                const BADivider(indent: 56),

                // two factor
                ListTile(
                  onTap: () => showReAuthDialog(context),
                  leading: const Icon(
                    Icons.phone_locked_outlined,
                    size: 20,
                  ),
                  title: Text(!widget.userData.phoneEnrolled
                      ? 'Setup two factor'
                      : widget.userData.phoneNumber),
                  trailing: ActionChip(
                      label: Text(widget.userData.phoneEnrolled
                          ? 'Two factor Enabled'
                          : 'Not setup'),
                      padding: EdgeInsets.zero,
                      backgroundColor: widget.userData.phoneEnrolled
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      labelStyle: TextStyle(
                          color: widget.userData.phoneEnrolled
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12),
                      side: BorderSide.none,
                      onPressed: () async {
                        if (widget.userData.phoneEnrolled) {
                          showToast('Two factor enabled', context,
                              status: Status.info);
                        } else {
                          showReAuthDialog(context);
                        }
                      }),
                  // trailing:
                  //     const Icon(Icons.chevron_right, color: Colors.black26),
                ),
                const BADivider(indent: 56),

                // account type
                // ListTile(
                //   leading: const Icon(Icons.account_balance_outlined),
                //   title: Text(widget.userData.accountType),
                // ),
                // const BADivider(indent: 56),

                // reset email
                ListTile(
                  onTap: () => BaDialog.showBaDialog(
                    context: context,
                    title: 'Reset Password',
                    content: const Text(
                        'We will send a password reset link to your email address.'),
                    okText: 'RESET',
                    cancelText: 'CANCEL',
                    onOk: () async {
                      Navigator.pop(context);
                      toggleLoading();
                      await resetPassword(widget.userData.email, context);
                      toggleLoading();
                    },
                    onCancel: () => Navigator.pop(context),
                  ),
                  leading: const Icon(
                    Icons.send_to_mobile_outlined,
                    size: 20,
                  ),
                  title: const Text('Reset Password'),
                ),
              ],
            ),
          ),
          AppSpacing.large,

          // settings
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                // about
                ListTile(
                  onTap: () => showAboutDialog(context: context),
                  leading: const Icon(
                    Icons.info_outlined,
                    size: 20,
                  ),
                  title: const Text('About'),
                ),
                const BADivider(indent: 16),

                // close account
                ListTile(
                  onTap: () {
                    BaDialog.showBaDialog(
                      context: context,
                      title: 'Close Account',
                      content: const Text(
                          'Are you sure you want to close your account? This action cannot be undone.'),
                      okText: 'ClOSE ACCOUNT',
                      cancelText: 'CANCEL',
                      onOk: () async {
                        Navigator.pop(context);
                        toggleLoading();
                        await closeUserAccount(context);
                        toggleLoading();
                      },
                      onCancel: () => Navigator.pop(context),
                    );
                  },
                  leading: const Icon(
                    Icons.no_accounts_outlined,
                    color: Colors.red,
                    size: 20,
                  ),
                  title: const Text(
                    'Close Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const BADivider(indent: 16),

                // sign out
                ListTile(
                  onTap: () async {
                    BaDialog.showBaDialog(
                      context: context,
                      title: 'Sign out',
                      content: const Text('Are you sure you want to sign out?'),
                      okText: 'SIGN OUT',
                      cancelText: 'CANCEL',
                      onOk: () async {
                        Navigator.pop(context);
                        toggleLoading();
                        await signOutUser(context);
                        toggleLoading();
                      },
                      onCancel: () => Navigator.pop(context),
                    );
                  },
                  leading: const Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.red,
                    size: 20,
                  ),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showReAuthDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: widget.userData.email);
    final passwordController = TextEditingController();

    BaDialog.showBaDialog(
        context: context,
        title: 'Sign In',
        cancelText: 'Cancel',
        onCancel: () => Navigator.of(context).pop(),
        okText: 'Continue',
        onOk: () async {
          if (formKey.currentState!.validate()) {
            Navigator.of(context).pop();
            await reAuthUser(
              emailController.text,
              passwordController.text,
              widget.userData,
              context,
            );
          }
        },
        content: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSpacing.large,
              // email
              BATextField(
                labelText: 'Email',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
              ),

              // password
              BATextField(
                labelText: 'Password',
                controller: passwordController,
                obscureText: true,
                showOptional: false,
              ),
            ],
          ),
        ));
  }
}
