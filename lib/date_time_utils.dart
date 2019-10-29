import 'package:intl/intl.dart';

class DateTimeUtils {
  static String dateStringToDisplayString(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

    return dateFormat.format(date);
  }
}
