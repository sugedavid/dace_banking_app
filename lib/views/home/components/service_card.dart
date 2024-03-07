import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.onPressed});

  final Widget icon;
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            icon,
            AppSpacing.xSmall,

            // title
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
