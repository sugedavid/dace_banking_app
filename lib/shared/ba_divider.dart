import 'package:flutter/material.dart';

class BADivider extends StatelessWidget {
  const BADivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.grey,
      height: 1,
      thickness: 0.5,
      indent: 20,
      endIndent: 20,
    );
  }
}
