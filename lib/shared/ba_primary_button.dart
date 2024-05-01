import 'package:flutter/material.dart';

import '../utils/colors.dart';

class BAPrimaryButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final bool enable;
  final Color? backgroundColor;

  const BAPrimaryButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.enable = true,
      this.backgroundColor = AppColors.primaryColor})
      : super(key: key);

  @override
  BAPrimaryButtonState createState() => BAPrimaryButtonState();
}

class BAPrimaryButtonState extends State<BAPrimaryButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    void toggleLoading(bool value) {
      setState(() {
        isLoading = value;
      });
    }

    return SizedBox(
      width: 395,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: isLoading || !widget.enable
            ? null
            : () async {
                toggleLoading(true);
                await widget.onPressed();
                toggleLoading(false);
              },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )
              : Text(
                  widget.text,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
