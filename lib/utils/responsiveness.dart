// large screen
import 'package:flutter/material.dart';

bool isLargeScreen(BuildContext context) {
  final screenSizeInches = MediaQuery.of(context).size.shortestSide /
      MediaQuery.of(context).devicePixelRatio;
  return screenSizeInches > 200;
}
