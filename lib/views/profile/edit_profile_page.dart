import 'package:banking_app/models/user.dart';
import 'package:flutter/material.dart';

import '../../firebase_utils/user_utils.dart';
import '../../shared/ba_dropdown_button.dart';
import '../../shared/ba_primary_button.dart';
import '../../shared/ba_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.userData});

  final UserModel userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final accountTypeController = TextEditingController();

  final ValueNotifier<bool> _isFirstNameChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLastNameChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isAccountTypeChanged = ValueNotifier<bool>(false);

  String? initialFirstName;
  String? initialLastName;
  String? initialAccountType;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // fetch user data
  void getUserData() async {
    UserModel userData = widget.userData;
    firstNameController.text = userData.firstName;
    lastNameController.text = userData.lastName;
    emailController.text = userData.email;
    accountTypeController.text = userData.accountType;

    // store initial values
    initialFirstName = userData.firstName;
    initialLastName = userData.lastName;
    initialAccountType = userData.accountType;

    addTextControllerListener();
  }

  // add listener to text controllers
  void addTextControllerListener() {
    firstNameController.addListener(_onFirstNameTextChanged);
    lastNameController.addListener(_onLastNameTextChanged);
    // emailController.addListener(_onTextChanged);
    accountTypeController.addListener(_onAccountTypeTextChanged);
  }

  // remove listener from text controllers
  void removeTextControllerListener() {
    firstNameController.removeListener(_onFirstNameTextChanged);
    lastNameController.removeListener(_onLastNameTextChanged);
    // emailController.removeListener(_onTextChanged);
    accountTypeController.removeListener(_onAccountTypeTextChanged);
  }

  // check if first name is changed
  void _onFirstNameTextChanged() {
    setState(() {
      _isFirstNameChanged.value = firstNameController.text != initialFirstName;
    });
  }

  // check if last name is changed
  void _onLastNameTextChanged() {
    setState(() {
      _isLastNameChanged.value = lastNameController.text != initialLastName;
    });
  }

  // check if account type is changed
  void _onAccountTypeTextChanged() {
    setState(() {
      _isAccountTypeChanged.value =
          accountTypeController.text != initialAccountType;
    });
  }

  // dispose text controllers
  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    accountTypeController.dispose();
  }

  @override
  void dispose() {
    removeTextControllerListener();
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
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

                      // account type
                      BADropdownButton(
                        labelText: 'Account Type',
                        list: const ['Personal', 'Business'],
                        controller: accountTypeController,
                      ),
                      const SizedBox(height: 40),

                      // continue cta
                      BAPrimaryButton(
                        text: 'Save',
                        isTextChanged: (_isFirstNameChanged.value ||
                            _isLastNameChanged.value ||
                            _isAccountTypeChanged.value),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await updateUserInfo(
                              firstNameController.text,
                              lastNameController.text,
                              accountTypeController.text,
                              context,
                            );
                            if (mounted) Navigator.of(context).pop(true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
