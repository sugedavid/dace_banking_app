import 'package:flutter/material.dart';

class BaDateTimePicker {
  // date picker
  static Future<DateTime?> showBaDatePicker({
    required BuildContext context,
    required String title,
    String? cancelText,
    String? okText,
    Function()? onCancel,
    Function(DateTime)? onOk,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      cancelText: cancelText ?? 'Cancel',
      confirmText: okText ?? 'OK',
      helpText: title,
    );

    if (pickedDate != null && onOk != null) {
      onOk(pickedDate);
    }

    return pickedDate;
  }

// time picker
  static Future<TimeOfDay?> showBaTimePicker({
    required BuildContext context,
    required String title,
    String? cancelText,
    String? okText,
    Function()? onCancel,
    Function(TimeOfDay)? onOk,
  }) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: cancelText ?? 'Cancel',
      confirmText: okText ?? 'OK',
      helpText: title,
    );

    if (pickedTime != null && onOk != null) {
      onOk(pickedTime);
    }

    return pickedTime;
  }
}
