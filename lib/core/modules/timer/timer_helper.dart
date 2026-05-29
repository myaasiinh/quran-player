/* author
   06/11/2022
   myaasiinh@gmail.com
*/

class TimeLeftData {
  TimeLeftData({
    required this.hour,
    required this.minutes,
    required this.second,
  });
  final String hour;
  final String minutes;
  final String second;
}

class TimerHelper {
  static int startTimer({
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
  }) {
    return seconds + (minutes * 60) + (hours * 60 * 60);
  }

  static String intToTimeLeft(int value) {
    int h;
    int m;
    int s;
    h = value ~/ 3600;
    m = (value - h * 3600) ~/ 60;
    s = value - (h * 3600) - (m * 60);

    final hourLeft = convertIntToTimeString(h);
    final minuteLeft = convertIntToTimeString(m);
    final secondsLeft = convertIntToTimeString(s);
    final result = '$hourLeft:$minuteLeft:$secondsLeft';
    return result;
  }

  static TimeLeftData intToTimeLeftData(int value) {
    int h;
    int m;
    int s;
    h = value ~/ 3600;
    m = (value - h * 3600) ~/ 60;
    s = value - (h * 3600) - (m * 60);

    final hourLeft = convertIntToTimeString(h);
    final minuteLeft = convertIntToTimeString(m);
    final secondsLeft = convertIntToTimeString(s);

    return TimeLeftData(
      hour: hourLeft,
      minutes: minuteLeft,
      second: secondsLeft,
    );
  }

  static String convertIntToTimeString(int time, {int maxLength = 2}) {
    return time.toString().padLeft(maxLength, '0');
  }
}
