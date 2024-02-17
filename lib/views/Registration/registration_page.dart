import 'package:banking_app/firebase_utils/authentication_utils.dart';
import 'package:banking_app/shared/ba_dropdown_button.dart';
import 'package:banking_app/shared/onboarding_scaffold.dart';
import 'package:banking_app/shared/ba_text_field.dart';
import 'package:flutter/material.dart';

import '../../shared/ba_primary_button.dart';

class ResgistrationPage extends StatelessWidget {
  const ResgistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final accountTypeController = TextEditingController();

    return OnBoardingScaffold(
        title: 'Register',
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // first name
              BATextField(
                labelText: 'First Name',
                controller: firstNameController,
                textInputType: TextInputType.name,
              ),

              // last name
              BATextField(
                labelText: 'Last Name',
                controller: lastNameController,
                textInputType: TextInputType.name,
              ),

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
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
              ),

              // account type
              BADropdownButton(
                labelText: 'What type of account would you like to create?',
                list: const ['Personal', 'Business'],
                controller: accountTypeController,
              ),

              const SizedBox(
                height: 40,
              ),

              // continue cta
              BAPrimaryButton(
                text: 'Continue',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await registerUser(
                      firstNameController.text,
                      lastNameController.text,
                      emailController.text,
                      passwordController.text,
                      accountTypeController.text,
                      context,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        richActionText: "Already have an account? ",
        richText: 'Login',
        onRichCallTap: () => Navigator.of(context).pop());
  }
}
