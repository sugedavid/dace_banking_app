import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/views/transactions/transactions_page.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/firebase_utils/user_utils.dart';
import '../models/user.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  // fetch user data
  void fetchUserData() async {
    toggleLoading();
    UserModel fetchedUserData = await authUserInfo(context);
    setState(() {
      userData = fetchedUserData;
      _widgetOptions = <Widget>[
        const HomePage(),
        const TransactionsPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          AppAssets.logoImg,
          height: 44,
        ),
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
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.history : Icons.history_outlined,
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 2 ? Icons.settings : Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
