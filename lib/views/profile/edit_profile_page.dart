import 'package:banking_app/models/user.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/material.dart';

import '../../shared/ba_dropdown_button.dart';
import '../../shared/ba_primary_button.dart';
import '../../shared/ba_text_field.dart';
import '../../shared/single_page_scaffold.dart';
import '../../utils/firebase_utils/user_utils.dart';

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

    // store initial values
    initialFirstName = userData.firstName;
    initialLastName = userData.lastName;

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
    return SinglePageScaffold(
      title: 'Edit Profile',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacing.medium,

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

            AppSpacing.large,

            // continue cta
            BAPrimaryButton(
              text: 'Save',
              enable: (_isFirstNameChanged.value ||
                  _isLastNameChanged.value ||
                  _isAccountTypeChanged.value),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await updateUserInfo(
                    firstNameController.text,
                    lastNameController.text,
                    context,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
