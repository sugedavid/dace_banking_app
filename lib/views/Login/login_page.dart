import 'package:banking_app/shared/ba_primary_button.dart';
import 'package:banking_app/shared/onboarding_scaffold.dart';
import 'package:banking_app/utils/firebase_utils/authentication_utils.dart';
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
      title: 'Welcome',
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // email
            BATextField(
              labelText: 'Email',
              controller: emailController,
              textInputType: TextInputType.emailAddress,
            ),

            // password
            BATextField(
              labelText: 'Password',
              controller: passwordController,
              obscureText: true,
              validate: false,
            ),

            const SizedBox(
              height: 20,
            ),

            // continue cta
            BAPrimaryButton(
              text: 'Sign in',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await logInUser(
                      emailController.text, passwordController.text, context);
                }
              },
            ),
          ],
        ),
      ),
      richActionText: "Don't have an account? ",
      richText: 'Sign Up',
      onRichCallTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResgistrationPage(),
        ),
      ),
    );
  }
}
