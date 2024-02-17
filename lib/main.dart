import 'package:banking_app/shared/main_scaffold.dart';
import 'package:banking_app/views/Login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
  @override
  Widget build(BuildContext context) {
    // check if user is logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        if (user == null) {
          _userLoggedIn = false;
        } else {
          _userLoggedIn = true;
        }
      });
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber[800]!),
        useMaterial3: true,
      ),
      home: _userLoggedIn ? const MainScaffold() : const LogInPage(),
    );
  }
}
