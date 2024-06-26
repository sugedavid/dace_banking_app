import 'package:banking_app/utils/assets.dart';
import 'package:banking_app/utils/responsiveness.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../shared/ba_primary_button.dart';
import '../../shared/main_scaffold.dart';
import '../../utils/colors.dart';

class SuccessPage extends StatefulWidget {
  final String message;
  final String? secondaryBtnTxt;
  final Function()? primaryBtnCallback;
  final Function()? secondaryBtnCallback;
  const SuccessPage({
    super.key,
    required this.message,
    this.secondaryBtnTxt,
    this.primaryBtnCallback,
    this.secondaryBtnCallback,
  });

  @override
  SuccessPageState createState() => SuccessPageState();
}

class SuccessPageState extends State<SuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        alignment: kIsWeb && isLargeScreen(context) ? Alignment.center : null,
        child: Center(
          child: SizedBox(
            width: kIsWeb ? 400 : null,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.successImg,
                      width: 70,
                      height: 70,
                    ),
                    AppSpacing.medium,

                    // title
                    const Text(
                      'Success',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    // message
                    Text(
                      widget.message,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.blueGrey),
                    ),
                    AppSpacing.large,

                    // continue
                    BAPrimaryButton(
                        text: 'Continue',
                        onPressed: () async => widget.primaryBtnCallback != null
                            ? widget.primaryBtnCallback!()
                            : Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const MainScaffold(),
                                ),
                                (route) => false)),

                    // another
                    if (widget.secondaryBtnTxt != null)
                      TextButton(
                        onPressed: () => widget.secondaryBtnCallback != null
                            ? widget.secondaryBtnCallback!()
                            : Navigator.of(context).pop(),
                        child: Text(widget.secondaryBtnTxt!),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
