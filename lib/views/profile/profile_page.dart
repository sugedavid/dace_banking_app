import 'package:banking_app/firebase_utils/authentication_utils.dart';
import 'package:banking_app/firebase_utils/user_utils.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/views/profile/edit_profile_page.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  UserModel userData = UserModel(
    firstName: '',
    lastName: '',
    email: '',
    accountType: '',
  );

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // fetch user data
  void fetchUserData() async {
    toggleLoading();
    UserModel fetchedUserData = await authUserInfo(context);
    setState(() {
      userData = fetchedUserData;
    });
    toggleLoading();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator(
            color: Colors.amber[800],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              userData: userData,
                            ),
                          ),
                        );

                        if (result != null && result) {
                          fetchUserData();
                        }
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),

              // personal information
              Card(
                child: Column(
                  children: [
                    // name
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Name'),
                      subtitle:
                          Text('${userData.firstName} ${userData.lastName}'),
                    ),
                    const BADivider(),

                    // email
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(userData.email),
                    ),
                    const BADivider(),

                    // accounts
                    const ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text('My Accounts'),
                      subtitle: Text('View accounts'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    const BADivider(),

                    // account type
                    ListTile(
                      leading: const Icon(Icons.price_change),
                      title: const Text('Account Type'),
                      subtitle: Text(userData.accountType),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // general
              const Text(
                'General',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              Card(
                child: Column(
                  children: [
                    // close account
                    const ListTile(
                      leading: Icon(Icons.delete_forever, color: Colors.red),
                      title: Text(
                        'Close Account',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const BADivider(),

                    // phone number
                    ListTile(
                      onTap: () async {
                        toggleLoading();
                        await signOutUser(context);
                        toggleLoading();
                      },
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
