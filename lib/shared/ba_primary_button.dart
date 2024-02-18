import 'package:flutter/material.dart';

class BAPrimaryButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final bool isTextChanged;

  const BAPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isTextChanged = true,
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

    return SizedBox(
      width: 395,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[800],
          foregroundColor: Colors.white,
        ),
        onPressed: isLoading || !widget.isTextChanged
            ? null
            : () async {
                toggleLoading(true);
                await widget.onPressed();
                toggleLoading(false);
              },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.amber[800],
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
