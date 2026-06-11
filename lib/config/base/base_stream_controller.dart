import 'dart:async';

import '/config/base/request_state.dart';
import '/core/mixin/connectivity_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

/// Kontroler abstrak berbasis [GetxController] yang dirancang khusus untuk menangani aliran data ([Stream]).
///
/// Menyediakan fitur pemantauan status koneksi secara otomatis melalui [ConnectivityMixin],
/// pengelolaan indikator state (memuat, ralat, sukses, kosong), serta memori untuk 
/// menyetel langganan stream. Sangat cocok digunakan untuk stream dari Firebase/Supabase.
abstract class BaseStreamController<T> extends GetxController
    with ConnectivityMixin {
  /// Status permintaan / aliran data saat ini, dibungkus sebagai rx reaktif.
  Rx<RequestState> state = RequestState.initial.obs;
  /// Pesan ralat (error) jika terjadi kesalahan dari stream.
  final errorMessage = Rxn<String>();

  /// Objek data reaktif untuk aliran yang me-return satu objek (bukan daftar).
  final dataObj = Rxn<T>();
  /// Objek daftar (list) reaktif untuk aliran yang me-return sekumpulan objek list.
  RxList<T> dataList = RxList<T>([]);

  /// Mengelola penyetelan pendaftaran berlangganan aliran data.
  StreamSubscription? _subscription;

  /// Memeriksa apakah status saat ini masih dalam tahapan inisialisasi awal.
  bool get isInitial => state.value.isInitial;
  /// Memeriksa apakah status saat ini sedang memuat data pertama kali.
  bool get isLoading => state.value.isLoading;
  /// Memeriksa apakah status saat ini mendeteksi error/kesalahan jaringan.
  bool get isError => state.value.isError;
  /// Memeriksa apakah data yang dimuat dari stream ternyata kosong.
  bool get isEmpty => state.value.isEmpty;
  /// Memeriksa apakah data berhasil dimuat dengan baik.
  bool get isSuccess => state.value.isSuccess;

  @mustCallSuper
  @override
  void onInit() {
    // Terus mendengarkan perubahan pada konektivitas jaringan
    listenConnectivity(() async {
      // Jika sebelumnya error namun bukan sedang memuat, 
      // dan koneksi kembali terhubung, muat ulang.
      if (isError && !isLoading) await onRefresh();
    });
    super.onInit();
  }

  /// Fungsi pemuatan ulang standar, wajib di-override oleh kelas turunannya.
  Future<void> onRefresh() async {
    // Override ini pada child class jika diperlukan untuk muat ulang manual
  }

  @mustCallSuper
  @override
  Future<void> onClose() async {
    // Batalkan memantau sambungan koneksi jaringan internet
    await cancelConnectivity();
    // Tutup atau batalkan ikatan aliran data agar tidak memory leak
    await _subscription?.cancel();
    super.onClose();
  }

  /// Mengubah stat menjadi proses pemuatan.
  void showLoading() {
    state.value = RequestState.loading;
    errorMessage.value = null; // Menghapus memori pesan error sebelumnya
  }

  /// Mengubah stat menjadi tipe error dan menyimpan pesan kesalahan spesifik.
  void loadError(String message) {
    errorMessage.value = message;
    state.value = RequestState.error;
  }

  /// Memulai pengikatan langganan ke sebuah [Stream] yang menghasilkan data tunggal.
  Future<void> bindDataStream(Stream<T> stream) async {
    showLoading();
    // Pastikan tidak ada stream double yang didengar
    await _subscription?.cancel();
    
    // Terapkan aksi pemantauan kedalam memori _subscription
    _subscription = stream.listen(
      (data) {
        dataObj.value = data;
        // Ganti status menjadi empty atau success berdasarkan objek
        if (data == null) {
          state.value = RequestState.empty;
        } else {
          state.value = RequestState.success;
        }
      },
      onError: (Object err) {
        // Alihkan kesalahan ke variabel status yang telah dipersiapkan
        loadError(err.toString());
      },
      // Jangan langsung hentikan langganan walau ada exception sementara
      cancelOnError: false,
    );
  }

  /// Memulai pengikatan langganan ke sebuah [Stream] yang menghasilkan daftar berurutan.
  Future<void> bindListDataStream(Stream<List<T>> stream) async {
    showLoading();
    // Putuskan langganan sebelumnya agar tidak terjadi kebocoran (leak)
    await _subscription?.cancel();
    
    // Terapkan memantau stream baru
    _subscription = stream.listen(
      (list) {
        // Langsung tetapkan (assign) list observasi dengan yang baru
        dataList.assignAll(list);
        
        // Memutuskan apakah list ini kosong atau ada isi
        if (list.isEmpty) {
          state.value = RequestState.empty;
        } else {
          state.value = RequestState.success;
        }
      },
      onError: (Object err) {
        // Laporkan kesalahan apabila stream mendeteksi anomali
        loadError(err.toString());
      },
      cancelOnError: false,
    );
  }
}
