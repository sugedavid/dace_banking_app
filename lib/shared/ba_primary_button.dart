import 'package:flutter/material.dart';

class BAPrimaryButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;

  const BAPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

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

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      onPressed: isLoading
          ? null
          : () async {
              toggleLoading(true);
              await widget.onPressed();
              if (mounted) {
                toggleLoading(false);
              }
            },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.purple,
              )
            : Text(
                widget.text,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}
