import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

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
    TextStyle linkStyle = const TextStyle(
        color: AppColors.primaryColor, fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  // body
                  Container(
                    color: Colors.white,
                    child: body,
                  ),

                  AppSpacing.veryLarge,

                  // rich text link
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RichText(
                      text: TextSpan(
                        text: richActionText,
                        style: defaultStyle,
                        children: <TextSpan>[
                          TextSpan(
                            text: richText,
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = onRichCallTap,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
