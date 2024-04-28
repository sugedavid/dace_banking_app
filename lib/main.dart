import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/utils/colors.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/views/login/login_page.dart';
import 'package:banking_app/views/phone_enrollment/phone_enrollment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _userLoggedIn = false;
  late User? authUser;
  UserModel userModel = UserModel.toEmpty();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    // check if user is logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        if (user == null) {
          _userLoggedIn = false;
        } else {
          authUser = user;
          _userLoggedIn = true;
        }
      });
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DACE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor, surface: Colors.white),
        useMaterial3: true,
      ),
      home: _userLoggedIn
          ? !authUser!.emailVerified || !userModel.phoneEnrolled
              ? PhoneEnrollmentPage(
                  userModel: userModel,
                )
              : const MainScaffold()
          : const LogInPage(),
    );
  }
}
