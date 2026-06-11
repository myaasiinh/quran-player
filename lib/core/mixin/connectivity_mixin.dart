/* author
   myaasiinh@gmail.com
*/

import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Mixin [ConnectivityMixin] dapat ditempelkan pada State Controller untuk menyuplai fitur observasi status koneksi internet secara otomatis.
mixin ConnectivityMixin {
  /// Variabel bertipe `StreamSubscription` yang akan menyegel dan memantau siaran streaming indikasi ketersediaan jaringan di latar belakang.
  StreamSubscription<List<ConnectivityResult>>? streamConnectivity;
  
  /// Instance aktif milik library plugin `Connectivity` dari package `connectivity_plus`.
  final Connectivity connectivity = Connectivity();

  /// Metode untuk mendengarkan perubahan status konektivitas internet (Listen Connectivity).
  /// 
  /// **Note:**
  /// Panggil metode pemantau ini sewaktu di dalam blok [onInit] supaya proses request otomatis memulihkan diri (retry request) diaktifkan.
  /// Bilamana koneksi internet kembali sukses direkoneksi, metode pemantau akan secara refleks mengeksekusi parameter callback [onRefresh].
  void listenConnectivity(VoidCallback onRefresh) {
    try {
      // Memulai proses listener asinkronus berlangganan siaran konektivitas perangkat secara terpusat.
      streamConnectivity = connectivity.onConnectivityChanged.listen(
        (connection) {
          // Melakukan validasi cek koneksi, memastikan tipe List hasil deteksi mengandung status 'terputus' murni atau sekadar menyambung dengan 'bluetooth'.
          if (connection.contains(ConnectivityResult.none) ||
              connection.contains(ConnectivityResult.bluetooth)) {
            // Jika valid tak ada koneksi / konektivitas tidak mendukung internet (Bluetooth), cetak pesan log disfungsi jaringan ke layar debug.
            log('Connectivity: Disconnect from internet $connection');
          } else {
            // Sebaliknya, jika internet telah beralih ke mobile (cellular) atau wi-fi kembali, catat sukses penyambungan via log konsole.
            log('Connectivity: Connect to $connection');
            
            // Panggil paksa rutin penyegaran (Refresh) data dari fungsi callback yang disediakan (onRefresh).
            onRefresh();
            // Catatan lama (dikomen): if (isError && !isLoading) refreshPage();
          }
        },
      );
    } catch (e, stackTrace) {
      // Blok penangkap error jika mekanisme setup listener mendadak gagal dikarenakan isu native/platform dan print stack tracenya.
      log('Failed stream connectivity :', error: e, stackTrace: stackTrace);
    }
  }

  /// Metode untuk membatalkan proses berlangganan jaringan (Cancel Connectivity).
  /// 
  /// **Note:**
  /// Harap selalu panggil fungsi ini di dalam siklus [onDispose] atau [onClose] kelas widget/controller.
  /// Hal ini sangat penting dihindari karena akan menyebabkan kebocoran memori (memory leak) yang merugikan.
  Future<void> cancelConnectivity() async {
    // Mematikan aliran stream secara permanen dan asinkronus menggunakan properti method `cancel()`.
    await streamConnectivity?.cancel();
  }
}
