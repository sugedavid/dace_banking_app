import 'package:banking_app/shared/onboarding_scaffold.dart';
import 'package:banking_app/firebase_utils/authentication_utils.dart';
import 'package:flutter/material.dart';

import '../Registration/registration_page.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return OnBoardingScaffold(
      title: 'Login',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // email
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // password
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),

          const SizedBox(
            height: 40,
          ),

          // cta
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            onPressed: () => logInUser(
                emailController.text, passwordController.text, context),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Continue'),
            ),
          )
        ],
      ),
      richActionText: "Don't have an account? ",
      richText: 'Register',
      onRichCallTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResgistrationPage(),
        ),
      ),
    );
  }
}
