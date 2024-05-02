import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/utils/colors.dart';
import 'package:banking_app/utils/firebase_utils/user_utils.dart';
import 'package:banking_app/views/email_verification/email_verification_page.dart';
import 'package:banking_app/views/login/login_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserModel userModel = UserModel.toEmpty();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
  }

  Widget mainPage() {
    if (authUser() != null) {
      if (!(authUser()?.emailVerified ?? false)) {
        return EmailVerificationPage(
          userModel: userModel,
        );
      } else {
        return const MainScaffold();
      }
    } else {
      return const LogInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DACE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor, surface: Colors.white),
        useMaterial3: true,
      ),
      home: mainPage(),
    );
  }
}
