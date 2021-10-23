import "package:intl/intl.dart";

class Functions {
  static String dateToString(DateTime date) {
    DateFormat formatter = DateFormat('yyyy年MM月dd日');
    String formatted = formatter.format(date);
    return formatted;
  }

  static String dateToStringTime(DateTime date) {
    DateFormat formatter = DateFormat('yyyy年MM月dd日 HH:mm');
    String formatted = formatter.format(date);
    return formatted;
  }
}
