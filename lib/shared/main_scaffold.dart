import 'package:banking_app/models/account.dart';
import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/utils/responsiveness.dart';
import 'package:banking_app/views/email_verification/email_verification_page.dart';
import 'package:banking_app/views/transactions/transactions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/firebase_utils/user_utils.dart';
import '../views/home/home_page.dart';
import '../views/profile/edit_profile_page.dart';
import '../views/profile/profile_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [];

  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  UserModel userData = UserModel.toEmpty();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // fetch user data
  void fetchUserData() async {
    toggleLoading();
    UserModel fetchedUserData = await authUserInfo(context);
    List<AccountModel> bankAccounts =
        await fetchBankAccountsByUserId(fetchedUserData.userId);
    User? user = authUser();
    setState(() {
      userData = fetchedUserData;

      if (!(user?.emailVerified ?? false)) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => EmailVerificationPage(
                userModel: userData,
              ),
            ),
            (route) => false);
      }
      _widgetOptions = <Widget>[
        HomePage(
          userData: userData,
        ),
        TransactionsPage(
          userData: userData,
          bankAccounts: bankAccounts,
        ),
        ProfilePage(
          userData: userData,
        ),
      ];
    });
    toggleLoading();
  }

  // toggle loading
  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Widget title() {
    if (_selectedIndex == 0) {
      return Image.asset(
        AppAssets.logoImg,
        height: 44,
      );
    } else if (_selectedIndex == 1) {
      return const Text(
        'Transactions',
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      return const Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: title(),
        actions: [
          // edit profile
          if (_selectedIndex == 2)
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
              icon: const Icon(Icons.edit_square),
            ),
        ],
      ),
      body: _isLoading
          ? const LinearProgressIndicator(
              color: AppColors.primaryColor,
            )
          : Row(
              children: [
                // master
                if (kIsWeb && isLargeScreen(context)) ...{
                  NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(
                            _selectedIndex == 0
                                ? Icons.home
                                : Icons.home_outlined,
                            color: _selectedIndex == 0
                                ? AppColors.primaryColor
                                : Colors.blueGrey,
                          ),
                          label: const Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            _selectedIndex == 1
                                ? Icons.history
                                : Icons.history_outlined,
                            color: _selectedIndex == 1
                                ? AppColors.primaryColor
                                : Colors.blueGrey,
                          ),
                          label: const Text(
                            'Transactions',
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            _selectedIndex == 2
                                ? Icons.settings
                                : Icons.settings_outlined,
                            color: _selectedIndex == 2
                                ? AppColors.primaryColor
                                : Colors.blueGrey,
                          ),
                          label: const Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ]),
                },

                // detail
                Expanded(
                  child: Container(
                    alignment: kIsWeb && isLargeScreen(context)
                        ? Alignment.center
                        : null,
                    child: SizedBox(
                      width: kIsWeb ? 400 : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 20.0),
                        child: _widgetOptions.elementAt(_selectedIndex),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: kIsWeb && isLargeScreen(context)
          ? null
          : NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                  (states) {
                    // Define the text style for different states
                    return TextStyle(
                        color: states.contains(MaterialState.selected)
                            ? AppColors.primaryColor
                            : Colors.blueGrey,
                        fontWeight: states.contains(MaterialState.selected)
                            ? FontWeight.w600
                            : FontWeight.w400);
                  },
                ),
              ),
              child: NavigationBar(
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                      color: _selectedIndex == 0
                          ? AppColors.primaryColor
                          : Colors.blueGrey,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 1
                          ? Icons.history
                          : Icons.history_outlined,
                      color: _selectedIndex == 1
                          ? AppColors.primaryColor
                          : Colors.blueGrey,
                    ),
                    label: 'Transactions',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 2
                          ? Icons.settings
                          : Icons.settings_outlined,
                      color: _selectedIndex == 2
                          ? AppColors.primaryColor
                          : Colors.blueGrey,
                    ),
                    label: 'Settings',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
              ),
            ),
    );
  }
}
