import 'dart:async';

import 'package:quran_player/core/helper/app_logger.dart';

/* author
   06/11/2022
   myaasiinh@gmail.com
*/

/// Kelas `TimerModule` digunakan untuk mengelola fungsionalitas timer (penghitung waktu mundur).
/// Modul ini mendukung operasi start, stop, pause, resume, dan restart.
class TimerModule {
  /// Tag identifier untuk logging modul ini.
  static const String tag = 'TIMER_MODULE';

  /// Menyimpan waktu yang tersisa (dalam detik atau satuan lain yang ditentukan).
  int currentTime = 0;
  
  /// Objek `Timer` dari Dart untuk mengontrol interval waktu.
  Timer? timer;
  
  /// ID update yang disimpan (mungkin digunakan untuk melacak timer spesifik).
  String? savedUpdateId;
  
  /// Menyimpan waktu awal yang diset untuk referensi saat restart/resume.
  int? savedTime;
  
  /// Callback yang dipanggil ketika timer dimulai.
  void Function(int currentTime)? onStartTimer;
  
  /// Callback yang dipanggil ketika timer selesai (mencapai 0).
  void Function()? onFinishedTimer;
  
  /// Callback yang dipanggil setiap kali nilai timer berubah (setiap interval).
  void Function(int currentTime)? onChangedTimer;

  /// Memulai timer dengan waktu yang diberikan.
  ///
  /// [time] adalah durasi waktu awal.
  /// [intervalTime] adalah durasi interval detak timer (default 1 detik).
  /// [onStart] callback saat timer dimulai.
  /// [onFinished] callback saat timer mencapai 0.
  /// [onChanged] callback yang dipanggil setiap kali waktu berkurang.
  void startTimer({
    required int time,
    Duration? intervalTime,
    void Function(int currentTime)? onStart,
    void Function()? onFinished,
    void Function(int currentTime)? onChanged,
  }) {
    // Menyimpan informasi timer untuk keperluan resume/restart
    savedTime = time;
    onStartTimer = onStart;
    onFinishedTimer = onFinished;
    onChangedTimer = onChanged;

    // Mengatur waktu saat ini sesuai input awal
    _setCurrentTime(time);
    
    // Jika callback onStart disediakan, panggil dengan waktu awal
    if (onStart != null) onStart(time);
    
    // Menginisialisasi objek Timer dengan interval yang ditentukan atau default 1 detik
    timer = Timer.periodic(
      intervalTime ?? const Duration(seconds: 1),
      (timerP) {
        // Jika waktu mencapai 0, hentikan timer
        if (currentTime == 0) {
          _stopTimerP(timerP);
          // Panggil callback onFinished jika ada
          if (onFinished != null) onFinished();
        } else {
          // Jika belum 0, kurangi currentTime sebesar 1
          _setCurrentTime(currentTime -= 1);
          // Panggil callback onChanged dengan waktu yang baru
          if (onChanged != null) onChanged(currentTime);
          // Perbarui savedTime agar sinkron dengan currentTime
          savedTime = currentTime;
        }
        // Mencatat log setiap kali timer di-update
        AppLogger.debug('TIMER UPDATE: | $currentTime');
      },
    );
  }

  /// Fungsi internal untuk memperbarui nilai `currentTime`.
  void _setCurrentTime(int time) {
    currentTime = time;
  }

  /// Fungsi internal untuk menghentikan instansi `Timer` yang sedang berjalan
  /// dan membersihkan referensi timer.
  void _stopTimerP(Timer timerP) {
    // Membatalkan instansi timer yang diberikan
    timerP.cancel();
    // Memanggil stopTimer untuk membersihkan state internal
    stopTimer();
  }

  /// Menghentikan timer yang sedang berjalan (jika ada),
  /// kemudian segera memulai timer baru.
  /// Ini mencegah adanya duplikasi timer yang berjalan bersamaan.
  void restartTimer({
    // ID update untuk keperluan tracking/logging
    required String updateId,
    // Waktu mulai yang baru
    required int time,
    // Durasi interval opsional
    Duration? intervalTime,
    // Callback opsional
    void Function(int currentTime)? onStart,
    void Function()? onFinished,
    void Function(int currentTime)? onChanged,
  }) {
    // Mencatat log bahwa timer akan di-restart
    AppLogger.debug('$tag: $savedUpdateId | restart timer');
    // Jika timer masih berjalan (currentTime != 0), hentikan dulu
    if (currentTime != 0) {
      stopTimer();
    }
    // Mulai timer baru dengan parameter yang diberikan
    startTimer(
      time: time,
      intervalTime: intervalTime,
      onStart: onStart,
      onFinished: onFinished,
      onChanged: onChanged,
    );
  }

  /// Menghentikan timer secara manual.
  void stopTimer() {
    // Membatalkan timer jika tidak null
    timer?.cancel();
  }

  /// Menjeda timer. Fungsi ini pada dasarnya hanya membatalkan instance timer
  /// tanpa mereset `savedTime` atau `currentTime`.
  void pauseTimer() {
    timer?.cancel();
  }

  /// Melanjutkan timer dari posisi terakhir yang dijeda.
  /// Menggunakan nilai `savedTime` yang terakhir disimpan.
  void resumeTimer() {
    startTimer(
      // Gunakan waktu terakhir yang tersimpan, atau 0 jika tidak ada
      time: savedTime ?? 0,
      // Pulihkan callback yang tersimpan
      onChanged: onChangedTimer,
      onFinished: onFinishedTimer,
      onStart: onStartTimer,
    );
  }
}
