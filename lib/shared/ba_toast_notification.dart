import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
