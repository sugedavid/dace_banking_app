import 'package:banking_app/shared/onboarding_scaffold.dart';
import 'package:banking_app/firebase_utils/authentication_utils.dart';
import 'package:flutter/material.dart';

import '../../shared/ba_text_field.dart';
import '../Registration/registration_page.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return OnBoardingScaffold(
      title: 'Login',
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // email
            BaTextField(
              labelText: 'Email',
              textEditingController: emailController,
              textInputType: TextInputType.emailAddress,
            ),

            // password
            BaTextField(
              labelText: 'Password',
              textEditingController: passwordController,
              obscureText: true,
              validate: false,
            ),

            const SizedBox(
              height: 20,
            ),

            // continue cta
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  logInUser(
                      emailController.text, passwordController.text, context);
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
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
