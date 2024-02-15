import 'package:flutter/material.dart';

enum TextFieldType { email, name, password }

class BaTextField extends StatelessWidget {
  const BaTextField(
      {super.key,
      required this.labelText,
      required this.textEditingController,
      this.textInputType,
      this.obscureText = false,
      this.validate = true});

  final String labelText;
  final TextEditingController textEditingController;
  final TextInputType? textInputType;
  final bool? obscureText;
  final bool? validate;

  String? Function(String?)? _validator() {
    // email validation
    if (textInputType == TextInputType.emailAddress) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      };
    }
    // text validation
    else if (textInputType == TextInputType.text ||
        textInputType == TextInputType.name) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        } else if (value.length < 2) {
          return 'Name must be at least 2 characters long';
        }
        return null;
      };
    }
    // password validation
    else if (obscureText == true) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (validate! && value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      };
    }
    // no validation
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 395,
          child: TextFormField(
            obscureText: obscureText!,
            controller: textEditingController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText,
            ),
            validator: _validator(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
