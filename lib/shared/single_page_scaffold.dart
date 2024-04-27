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
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
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
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FadeTransition(
            opacity: _animation,
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
      ),
    );
  }
}
