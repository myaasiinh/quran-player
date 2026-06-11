import 'dart:convert';

import 'package:quran_player/core/helper/app_logger.dart';

import '/core/database/storage/storage_key.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/* penulis
   myaasiinh@gmail.com
*/

/// ----Pengelola Penyimpanan GetX (GetX Storage)----
///
/// Kelas [StorageManager] berfungsi untuk mengelola interaksi baca/tulis ke dalam disk/cache lokal.
/// Memanfaatkan [GetStorage] yang sangat ringan dan disinkronkan.
/// 
/// Format Data -> Kunci (Key) bertindak layaknya Nama Kotak (BoxName).
/// Dengan demikian, satu nama kunci merepresentasikan satu set data.
/// (Satu Kotak = Satu Data).
class StorageManager {
  /// Mempermudah pengambilan objek [StorageManager] yang terdaftar dalam dependensi `Get`.
  static StorageManager get find => Get.find<StorageManager>();
  
  /// Referensi instans (instance) bawaan [GetStorage] untuk mengeksekusi operasi baca tulis penyimpanan.
  final GetStorage box = Get.find<GetStorage>();

  /// Menyimpan sebuah data (nilai) dengan [name] (kunci/key) tertentu ke dalam media penyimpanan lokal.
  /// 
  /// Jika Anda ingin menyimpan tipe Objek/Model, pastikan Anda mengubahnya 
  /// (encode) ke dalam format JSON/String sebelum memanggil fungsi ini (contoh: objek.toJson()).
  Future<void> save<T>(String name, T value) async {
    // Meminta GetStorage untuk menulis nilai dengan kunci tertentu secara asinkron
    await box.write(name, value);
  }

  /// Menghapus data spesifik dari media penyimpanan lokal yang merujuk pada nama kunci [name].
  Future<void> delete(String name) async {
    // Meminta GetStorage untuk menghapus entri dengan kunci tertentu
    await box.remove(name);
  }

  /// Mengambil suatu data dari dalam media penyimpanan lokal berdasarkan kuncinya.
  /// 
  /// Jika Anda menginginkan hasil balikan sebagai sebuah tipe Objek/Model tertentu,
  /// Anda tidak boleh lupa untuk mengonversi (decode) string JSON yang kembali (contoh: Model.fromJson(..)).
  dynamic get<T>(String name) {
    // Mengembalikan nilai yang tersimpan secara sinkron
    return box.read<T>(name);
  }

  /// Mengecek apakah penyimpanan lokal memiliki (berisi) data pada nama kunci [name].
  /// 
  /// Mengembalikan nilai `true` jika data ada, dan `false` jika data kosong/tidak ada.
  bool has(String name) {
    return box.hasData(name);
  }

  /// Membungkus dan mengkodekan sebuah list (kumpulan objek) [data] ke dalam representasi format teks (JSON string).
  /// 
  /// Biasanya difungsikan untuk membantu penyimpanan list ke dalam [GetStorage] (karena bentuk yang disimpan string).
  String encodeList<T>(List<T> data) {
    return json.encode(data);
  }

  /// Mengurai (decode) format teks JSON kembali menjadi bentuk daftar asli (list).
  /// 
  /// Digunakan ketika mengambil data bentuk array JSON dari penyimpanan agar siap digunakan sebagai List Dart.
  List<T> decodeList<T>(String data) {
    // Parsing string teks sebagai JSON lalu menyusun ulang (cast) menjadi tipe T
    return (json.decode(data) as List).cast<T>();
  }

  /// Secara khusus mengambil nilai dari penyimpanan secara asinkronus (menunggu hasil proses disk).
  /// Berguna bila aplikasi membutuhkan jaminan agar data benar-benar siap terambil secara utuh sebelum mengeksekusi baris berikutnya.
  dynamic getAwait(String name) async {
    return await box.read(name);
  }

  /// Fungsi [logout] digunakan untuk menangani skenario "keluar sesi",
  /// yang mana bertugas menghapus segala riwayat / state sementara.
  /// 
  /// Prosedur ini akan mencari seluruh entri/kunci yang tersimpan dan MENGHAPUSNYA,
  /// terkecuali kunci tersebut masuk dalam kategori [StorageKey.permanentKeys] (Misalnya: Tema Gelap Terang, Bahasa).
  Future<void> logout() async {
    try {
      // Mengambil daftar kunci yang berstatus permanen (tidak boleh dihapus)
      final permanentKeys = StorageKey.permanentKeys;
      
      // Mengambil semua kunci yang sedang tersimpan lalu menyaringnya:
      // Simpan kunci-kunci yang BUKAN merupakan bagian dari kumpulan kunci permanen ke dalam deleteKeys.
      final deleteKeys = (box.getKeys() as Iterable<String>).where((key) {
        return !permanentKeys.contains(key);
      }).toList();

      // Mulai iterasi ke setiap kunci yang dikategorikan akan dihapus
      for (final key in deleteKeys) {
        // Melakukan penghapusan secara tuntas (asinkron) untuk kunci yang bersangkutan
        await box.remove(key);
      }
    } catch (e) {
      // Jika terjadi kesalahan operasi selama penghapusan iteratif, catat dalam jurnal (logger)
      AppLogger.debug(e.toString());
    }
  }
}
