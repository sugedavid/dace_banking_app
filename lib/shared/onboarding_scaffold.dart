import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OnBoardingScaffold extends StatelessWidget {
  const OnBoardingScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.richText,
    required this.richActionText,
    required this.onRichCallTap,
  });

  final String title;
  final Widget body;
  final String richText;
  final String richActionText;
  final Function() onRichCallTap;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 16.0);
    TextStyle linkStyle =
        const TextStyle(color: Colors.purple, fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: null,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),

            // body
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: body,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            RichText(
              text: TextSpan(
                text: richActionText,
                style: defaultStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: richText,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = onRichCallTap,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            // cta
          ],
        ),
      )),
    );
  }
}
