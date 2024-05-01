import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final now = DateTime.now();
  final yearFormatter = DateFormat("y");
  final ordinalSuffix = getOrdinalSuffix(dateTime.day);
  final currYearFormatter = DateFormat("d'$ordinalSuffix' MMM 'at' hh:mm a");
  final prevYearFormatter = DateFormat("d'$ordinalSuffix' MMM y 'at' hh:mm a");

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

String getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
