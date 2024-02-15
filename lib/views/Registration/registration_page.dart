import 'package:banking_app/firebase_utils/authentication_utils.dart';
import 'package:banking_app/shared/ba_dropdown_button.dart';
import 'package:banking_app/shared/onboarding_scaffold.dart';
import 'package:banking_app/shared/ba_text_field.dart';
import 'package:flutter/material.dart';

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
              BaTextField(
                labelText: 'First Name',
                textEditingController: firstNameController,
                textInputType: TextInputType.name,
              ),

              // last name
              BaTextField(
                labelText: 'Last Name',
                textEditingController: lastNameController,
                textInputType: TextInputType.name,
              ),

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
              ),

              // account type
              BaDropdownButton(
                labelText: 'What type of account would you like to create?',
                list: const ['Personal', 'Business'],
                textEditingController: accountTypeController,
              ),

              const SizedBox(
                height: 40,
              ),

              // continue cta
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    registerUser(
                      firstNameController.text,
                      lastNameController.text,
                      emailController.text,
                      passwordController.text,
                      accountTypeController.text,
                      context,
                    );
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
        richActionText: "Already have an account? ",
        richText: 'Login',
        onRichCallTap: () => Navigator.of(context).pop());
  }
}
