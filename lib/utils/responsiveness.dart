// large screen
import 'package:flutter/material.dart';

bool isLargeScreen(BuildContext context) {
  final screenSizeInches = MediaQuery.of(context).size.shortestSide /
      MediaQuery.of(context).devicePixelRatio;

  // Check if the screen size is greater than 7 inches
  if (screenSizeInches > 7) {
    return true;
  } else {
    return false;
  }
}
