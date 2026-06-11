/// Merepresentasikan data waktu yang tersisa dalam format jam, menit, dan detik.
///
/// Digunakan untuk menyimpan komponen waktu yang tersisa sebagai string.
class TimeLeftData {
  /// Membuat instance [TimeLeftData] baru.
  ///
  /// Membutuhkan [hour], [minutes], dan [second] sebagai string.
  TimeLeftData({
    required this.hour,
    required this.minutes,
    required this.second,
  });

  /// Jam yang tersisa, direpresentasikan sebagai string (misal: "01", "12").
  final String hour;

  /// Menit yang tersisa, direpresentasikan sebagai string (misal: "05", "30").
  final String minutes;

  /// Detik yang tersisa, direpresentasikan sebagai string (misal: "00", "45").
  final String second;
}

/// Kelas utilitas yang menyediakan fungsi-fungsi terkait manipulasi waktu dan timer.
///
/// Berisi metode statis untuk mengkonversi waktu antar format integer dan string,
/// serta untuk menghitung total detik dari komponen waktu.
class TimerHelper {
  /// Menghitung total detik dari komponen jam, menit, dan detik yang diberikan.
  ///
  /// Mengkonversi waktu yang diberikan ke dalam total detik untuk memulai timer.
  ///
  /// [hours] Jumlah jam. Defaultnya adalah 0.
  /// [minutes] Jumlah menit. Defaultnya adalah 0.
  /// [seconds] Jumlah detik. Defaultnya adalah 0.
  ///
  /// Mengembalikan total detik sebagai integer.
  static int startTimer({
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
  }) {
    // Menghitung total detik: detik + (menit * 60) + (jam * 60 * 60)
    return seconds + (minutes * 60) + (hours * 60 * 60);
  }

  /// Mengkonversi total detik menjadi format string "HH:MM:SS".
  ///
  /// [value] Total detik yang akan dikonversi.
  ///
  /// Mengembalikan string yang diformat "HH:MM:SS".
  static String intToTimeLeft(int value) {
    int h; // Variabel untuk menyimpan jam
    int m; // Variabel untuk menyimpan menit
    int s; // Variabel untuk menyimpan detik

    // Menghitung jam dengan pembagian integer
    h = value ~/ 3600;
    // Menghitung menit setelah mengurangi jam
    m = (value - h * 3600) ~/ 60;
    // Menghitung detik setelah mengurangi jam dan menit
    s = value - (h * 3600) - (m * 60);

    // Mengkonversi jam ke format string dua digit
    final hourLeft = convertIntToTimeString(h);
    // Mengkonversi menit ke format string dua digit
    final minuteLeft = convertIntToTimeString(m);
    // Mengkonversi detik ke format string dua digit
    final secondsLeft = convertIntToTimeString(s);

    // Menggabungkan komponen waktu menjadi string "HH:MM:SS"
    final result = '$hourLeft:$minuteLeft:$secondsLeft';
    return result;
  }

  /// Mengkonversi total detik menjadi objek [TimeLeftData].
  ///
  /// [value] Total detik yang akan dikonversi.
  ///
  /// Mengembalikan objek [TimeLeftData] yang berisi jam, menit, dan detik sebagai string.
  static TimeLeftData intToTimeLeftData(int value) {
    int h; // Variabel untuk menyimpan jam
    int m; // Variabel untuk menyimpan menit
    int s; // Variabel untuk menyimpan detik

    // Menghitung jam dengan pembagian integer
    h = value ~/ 3600;
    // Menghitung menit setelah mengurangi jam
    m = (value - h * 3600) ~/ 60;
    // Menghitung detik setelah mengurangi jam dan menit
    s = value - (h * 3600) - (m * 60);

    // Mengkonversi jam ke format string dua digit
    final hourLeft = convertIntToTimeString(h);
    // Mengkonversi menit ke format string dua digit
    final minuteLeft = convertIntToTimeString(m);
    // Mengkonversi detik ke format string dua digit
    final secondsLeft = convertIntToTimeString(s);

    // Membuat dan mengembalikan objek TimeLeftData
    return TimeLeftData(
      hour: hourLeft,
      minutes: minuteLeft,
      second: secondsLeft,
    );
  }

  /// Mengkonversi integer menjadi string dengan padding nol di depan.
  ///
  /// Berguna untuk memastikan angka selalu memiliki panjang digit tertentu,
  /// misalnya "5" menjadi "05".
  ///
  /// [time] Integer yang akan dikonversi.
  /// [maxLength] Panjang string yang diinginkan. Defaultnya adalah 2.
  ///
  /// Mengembalikan string yang diformat.
  static String convertIntToTimeString(int time, {int maxLength = 2}) {
    // Mengkonversi integer ke string dan menambahkan padding nol di depan
    return time.toString().padLeft(maxLength, '0');
  }
}