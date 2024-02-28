import 'package:flutter/material.dart';

class BADivider extends StatelessWidget {
  const BADivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.black12,
      height: 0.5,
      thickness: 0.5,
      indent: 56,
      endIndent: 0,
    );
  }
}
