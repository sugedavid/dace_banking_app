import 'package:banking_app/shared/dropdown_button.dart';
import 'package:banking_app/shared/onboarding_scaffold.dart';
import 'package:banking_app/views/Login/login_page.dart';
import 'package:flutter/material.dart';

class ResgistrationPage extends StatelessWidget {
  const ResgistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingScaffold(
      title: 'Register',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // email
          const TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // password
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const BaDropdownButton(
            list: ['Personal', 'Business'],
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
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Continue'),
            ),
          )
        ],
      ),
      richActionText: "Already have an account? ",
      richText: 'Login',
      onRichCallTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LogInPage(),
        ),
      ),
    );
  }
}
