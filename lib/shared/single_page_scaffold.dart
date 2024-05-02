import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SinglePageScaffold extends StatefulWidget {
  const SinglePageScaffold(
      {super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<SinglePageScaffold> createState() => _SinglePageScaffoldState();
}

class _SinglePageScaffoldState extends State<SinglePageScaffold>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(24.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
