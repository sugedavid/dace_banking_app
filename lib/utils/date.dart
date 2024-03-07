import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final now = DateTime.now();
  final yearFormatter = DateFormat("y");
  final currYearFormatter = DateFormat("d MMM 'at' hh:mm a");
  final prevYearFormatter = DateFormat("d MMM y 'at' hh:mm a");

  // check if the year is the same as the current year
  final year = yearFormatter.format(dateTime);
  final currentYear = yearFormatter.format(now);

  // format the date according to the condition
  if (year == currentYear) {
    return currYearFormatter.format(dateTime);
  } else {
    return prevYearFormatter.format(dateTime);
  }
}
