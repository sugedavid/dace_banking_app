import 'package:banking_app/shared/ba_dialog.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          AppSpacing.xSmall,

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
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(
                      '${widget.userData.firstName} ${widget.userData.lastName}'),
                ),
                const BADivider(),

                // email
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(widget.userData.email),
                ),
                const BADivider(),

                // // accounts
                // const ListTile(
                //   leading: Icon(Icons.account_balance_outlined),
                //   title: Text('My Accounts'),
                //   subtitle: Text('View accounts'),
                //   trailing: Icon(Icons.chevron_right, color: Colors.black26),
                // ),
                // const BADivider(),

                // account type
                ListTile(
                  leading: const Icon(Icons.price_change_outlined),
                  title: const Text('Account Type'),
                  subtitle: Text(widget.userData.accountType),
                ),
                const BADivider(),

                // reset email
                ListTile(
                  onTap: () => BaDialog.showBaDialog(
                    context: context,
                    title: 'Reset Password',
                    description:
                        'We will send a password reset link to your email address.',
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
                  leading: const Icon(Icons.send_to_mobile_outlined),
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
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                ),
                const BADivider(),

                // close account
                ListTile(
                  onTap: () {
                    BaDialog.showBaDialog(
                      context: context,
                      title: 'Close Account',
                      description:
                          'Are you sure you want to close your account? This action cannot be undone.',
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
                  leading: const Icon(Icons.delete_forever_outlined,
                      color: Colors.red),
                  title: const Text(
                    'Close Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const BADivider(),

                // sign out
                ListTile(
                  onTap: () async {
                    BaDialog.showBaDialog(
                      context: context,
                      title: 'Sign out',
                      description: 'Are you sure you want to sign out?',
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
                  leading: const Icon(Icons.logout_outlined, color: Colors.red),
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
}
