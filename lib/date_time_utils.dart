import 'package:intl/intl.dart';

class DateTimeUtils {
  static String dateStringToDisplayString(String dateString) {
    final date = DateTime.parse(dateString);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return dateFormat.format(date);
  }
}
