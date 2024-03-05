import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';

enum TextFieldType { email, name, password }

class BATextField extends StatelessWidget {
  const BATextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.hintText,
    this.textInputType,
    this.obscureText = false,
    this.validate = true,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.inputFormatters,
  });

  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool? obscureText;
  final bool? validate;
  final bool? enabled;
  final bool? readOnly;
  final Function()? validator;
  final List<TextInputFormatter>? inputFormatters;

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

    // custom validation
    else if (validator != null) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        } else {
          return validator!();
        }
      };
    }
    // no validation
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String hint = hintText ?? 'Enter $labelText';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        if (labelText.isNotEmpty) ...{
          Row(
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              if (validate!)
                const Text(
                  '*',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          AppSpacing.xSmall
        },

        // text field
        SizedBox(
          width: 395,
          child: TextFormField(
            enabled: enabled,
            readOnly: readOnly!,
            obscureText: obscureText!,
            controller: controller,
            keyboardType: textInputType,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  color: readOnly! ? Colors.black45 : AppColors.primaryColor,
                ), // Set focused border color to transparent
              ),
            ),
            validator: validate! ? _validator() : null,
            inputFormatters: inputFormatters,
          ),
        ),
        AppSpacing.large,
      ],
    );
  }
}
