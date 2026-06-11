/* author
   myaasiinh@gmail.com
*/

// Mengimpor library 'dart:developer' yang berguna untuk menampilkan pencatatan log (logging) ke konsol secara aman.
import 'dart:developer';

// Mengimpor mixin 'CacheMixin' yang berada di modul core yang menyimpan implementasi fitur-fitur simpan-baca cache lokal.
import '/core/mixin/cache_mixin.dart';

/// Kelas abstrak [BaseRepository] yang berfungsi sebagai pondasi kerangka (blueprint) 
/// untuk setiap implementasi kelas repository data pada aplikasi.
/// 
/// Secara struktur, kelas ini mewarisi fungsionalitas pengolahan cache memori dengan menggunakan `with CacheMixin`.
/// Pengembang hanya perlu memperluas/mewarisi (extend) kelas abstrak ini pada repository turunannya.
abstract class BaseRepository with CacheMixin {
  /// Variabel tag konstan berjenis String [ _tag ] bertindak sebagai prefix teks penanda letak log.
  /// Tujuannya mempermudah pelacakan error (debugging) melalui konsol log.
  final String _tag = 'BaseRepository::->';

  /// Metode asinkronus `loadCachedList` dirancang khusus untuk memanggil sekumpulan data (list)
  /// dari sumber eksternal / jaringan, dan mengelolanya berdampingan dengan manajemen cache (penyimpanan lokal).
  /// 
  /// Cara kerjanya: jika Anda mengatur nilai [loadWhen] sebagai bernilai true, ia akan berusaha
  /// mendahulukan pencarian ke basis cache memori sebelum meminta dari luar (atau menimpa pembaruannya).
  /// 
  /// Parameter:
  /// * `[T]` : Tipe data generik yang mengisi elemen di list. (contoh: `List<User>`)
  /// * `[cachedKey]` : Kunci identitas string untuk mengenali folder penyimpanannya di penyimpanan sistem lokal.
  /// * `[onLoad]` : Fungsi pemanggil utama yang akan mengembalikan nilai asinkronus (biasanya dari API Call / Server DB).
  /// * `[loadWhen]` : Bendera keputusan apakah fitur cache perlu berjalan atau sekadar bypass panggilan langsung.
  Future<List<T>> loadCachedList<T>({
    required String cachedKey,
    required Future<List<T>> Function() onLoad,
    bool loadWhen = false,
  }) async {
    try {
      // Inisialisasi awal variabel hasil [result] dengan List Kosong untuk penampungan sementaranya.
      var result = <T>[];
      
      // Jika mode load cache (loadWhen) diaktifkan
      if (loadWhen) {
        // Melakukan penarikan hasil (fetch) ke penyimpanan cache secara lokal berdasarkan string 'cachedKey'
        result = await getCachedList(key: cachedKey);
        
        // Cek apabila hasil yang diambil dari cache terbukti berisi (tidak kosong)
        if (result.isNotEmpty) {
          // Sistem secara tidak langsung memperbarui data di memori latar belakang 
          // dengan menjalankan proses fetch onLoad(). Data yang usang kemudian akan di-update oleh saveCachedList.
          await onLoad()
              .then((value) => saveCachedList(key: cachedKey, list: value));
              
          // Lalu, respons kembalikan array dari list data yang bersumber dari cache yang cepat itu ke modul penampil
          return result;
        } else {
          // Apabila ternyata isian cache sama sekali tidak ada / kosong:
          // Panggil langsung dari jaringan lewat 'onLoad()'
          result = await onLoad();
          
          // Setelah jaringan mengembalikannya, simpan/cached data anyar (baru) itu sebagai koleksi masa depan
          await saveCachedList(key: cachedKey, list: result);
          
          // Me-return array list data utama dari load API tersebut
          return result;
        }
      } else {
        // Jika mode pengambilan cache tidak diperlukan alias diabaikan (`loadWhen` = false),
        // langkahi saja mekanisme cache sepenuhnya dan paksa request muatan dari fungsi 'onLoad()'.
        result = await onLoad();
        
        // Me-return kembalian array pemanggilan yang didapat.
        return result;
      }
    } catch (e, stackTrace) {
      // Menangani kegagalan dan menampilkan exception `e` lengkap bersama urutan riwayat terjadinya error (stackTrace).
      // Disertakan juga _tag agar di log terbaca dari area `BaseRepository` mana sumbernya.
      log('$_tag error $e, $stackTrace');
      
      // Mengangkat/meneruskan (rethrow) isu exception ini ke modul pemanggil yang lebih atas di tingkatan UI/State Management.
      rethrow;
    }
  }

  /// Metode `loadCached` khusus dipergunakan untuk penyimpanan dan permintaan model objek atau item data tunggal, bukan List.
  ///
  /// Set param opsional **[onlyCacheLast]** ke posisi true jikalau arsitektur Anda 
  /// hanya peduli cache terhadap pencarian halaman (pembacaan) spesifik paling terakhir dibuka secara eksklusif.
  ///
  /// Set param opsional **[customFieldId]** dengan kunci mapping pada sumber data (mapping key).
  /// Diperlukan bila ternyata struktur identifier ID data objek tersebut memiliki penamaan yang berbeda, bukan standar kata sandi ID.
  /// Sebagai rujukan contoh: Identitas unik pemakai dinamai `user_id`, Anda masukkan "user_id".
  /// 
  /// Parameter:
  /// * `[cachedKey]` : Induk penamaan/folder root kunci objek ketika dicaching.
  /// * `[onLoad]` : Algoritma perolehan objek lewat rute panggilan luar.
  /// * `[cachedId]` : Merupakan akhiran pembeda yang sangat penting untuk memberikan keunikan kunci pada objek berparameter sejenis.
  Future<T> loadCached<T>({
    required String cachedKey,
    required Future<T> Function() onLoad,
    required String? cachedId,
    bool onlyCacheLast = false,
    String? customFieldId,
  }) async {
    try {
      // Deklarasi penetapan variabel kunci dinamis. Pada mulanya disamakan dengan rujukan indukannya.
      var key = cachedKey;
      
      // Jika mode `onlyCacheLast` dimatikan (false), yang menandakan butuh histori cache data objek spesifik setiap id,
      // maka bentuklah sebuah kunci penamaan baru yang menyatukan kunci awal (root key) digabung dengan ekstensi nomor ID yang diakses.
      if (!onlyCacheLast) key = '$cachedKey/$cachedId';
      
      // Melaksanakan proses pengambilan (fetching) record rekaman lokal memakai `key` spesifik tadi.
      final cacheData = await getCacheObject(
        key: key,
        cachedId: cachedId,
        customFieldId: customFieldId,
      );
      
      // Jika penarikan berhasil dan datanya tersedia wujudnya (not null) dalam simpanan lokal:
      if (cacheData != null) {
        // Mengeksekusi penarikan penyegaran API (`onLoad()`), dan meresap balikan value mutakhir tersebut
        // ke memori cache (refresh data lokal dari belakang layar agar ter-sinkronisasi di buka aplikasi ke depannya)
        await onLoad().then((value) => saveCachedObject(key: key, data: value));
        
        // Memaksa objek kembalian itu untuk bertipe generik standar [T] seraya me-return nilai lokal tersebut.
        return cacheData as T;
      } else {
        // Akan tetapi, bila penarikan mendapati kekosongan objek di simpanan internal (memang belum ada):
        // Kirimkan request langsung mengambil ke sumber (server).
        final response = await onLoad();
        
        // Amankan nilai keluaran dari tanggapan jaringan server dengan menyimpannya menggunakan kuncinya.
        await saveCachedObject(key: key, data: response);
        
        // Tutup aliran dan kembalikan model hasil response utama tersebut ke logic state.
        return response;
      }
    } catch (e, stackTrace) {
      // Mengirim jejak insiden kerusakan ke papan pencatatan debug (console log) berserta kronologis (stack trace).
      log('$_tag error $e, $stackTrace');
      
      // Melempar kembali hasil tangkapan error / exception ini untuk diselesaikan (handled) di jenjang level atasnya.
      rethrow;
    }
  }
}
