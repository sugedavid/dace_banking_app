import 'package:banking_app/utils/responsiveness.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SinglePageScaffold extends StatefulWidget {
  const SinglePageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingActionButton;

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
        actions: widget.actions,
      ),
      body: Container(
        alignment: kIsWeb && isLargeScreen(context) ? Alignment.center : null,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(24.0),
              width: kIsWeb ? 400 : null,
              child: widget.child,
            ),
          ),
        ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
