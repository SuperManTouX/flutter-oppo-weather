import 'package:jiffy/jiffy.dart';

class OppoDateUtils {
  static String getWeekdayText(Jiffy targetDate) {
    Jiffy today = Jiffy.parse(DateTime.now().toString()).startOf(Unit.day);
    Jiffy target = targetDate.startOf(Unit.day);
    Jiffy tomorrow = today.add(days: 1).startOf(Unit.day);

    if (target.isSame(today, unit: Unit.day)) {
      return "今天";
    } else if (target.isSame(tomorrow, unit: Unit.day)) {
      return "明天";
    } else {
      String fullWeekday = target.format(pattern: "EEEE");
      return fullWeekday.replaceFirst("星期", "周");
    }
  }
}
