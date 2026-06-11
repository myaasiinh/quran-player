/* author
   myaasiinh@gmail.com
*/

import 'dart:convert';
import 'dart:developer';

import '/core/database/storage/cache_data.dart';
import '/core/database/storage/storage_manager.dart';
import '/core/extension/string_extension.dart';
import '/data/sources/local/cached_model_converter.dart';

/// Mixin [CacheMixin] yang menyediakan fungsi-fungsi dasar terstruktur untuk mengelola proses cache data lokal.
/// Memudahkan pengembang untuk melakukan aktivitas penyimpanan (save), pengambilan (get), 
/// dan penghapusan data (delete) object cache ke/dari Storage secara konsisten
/// dengan dukungan JSON encoding/decoding penuh untuk tipe data Object generik maupun Lists.
mixin CacheMixin {
  /// Variabel tag konstan yang digunakan khusus untuk melakukan logging dan debug konsol secara mudah dari kelas ini.
  final String _tag = 'CacheMixin::->';

  /// Instance perwakilan (objek turunan) dari [StorageManager] yang diinisiasi untuk mengakses abstraksi dari fungsi penyimpanan fisik perangkat.
  StorageManager storage = StorageManager.find;

  /// Mengambil kumpulan daftar model/objek bertipe T Generik ([T]) dari file cache lokal berdasarkan label kunci pengenal [key].
  /// Mengembalikan nilai Future berupa List bertipe data T. Jika data tidak ada atau tidak valid, list kosong dikembalikan.
  Future<List<T>> getCachedList<T>({required String key}) async {
    // Menge-log ke dalam sistem logger lokal ketika sebuah fungsi pengambilan list cache dipanggil beserta kuncinya.
    log('get cached, key: $key');

    // Mendapatkan bentuk data dinamik cache langsung dari media penyimpanan manager berdasarkan `key`.
    final dynamic cache = storage.get(key);
    
    // Mengecek apabila string cache tersedia, mempunyai key bersangkutan, dan tidak berbentuk kumpulan nilai null atau kosong isinya.
    if (storage.has(key) && cache.toString().isNotEmpty) {
      // Decode dan desialisasi dari format penyimpanan String awal menjadi format model entitas metadata CacheData object yang standar.
      final cacheData = CacheData.fromJson(
        jsonDecode(cache as String) as Map<String, dynamic>,
      );
      
      // Memanggil fungsi logging utilitas helper internal untuk ngeprint detail informasi masa kadaluwarsa dari objek `CacheData`.
      _logging(cacheData, key);
      
      // Mengubah string JSON di atribut `value` menjadi Iterable/List dan mengiterasi baris demi baris, 
      // lalu masing-masing akan dikonversi ke T dengan batuan kelas utilitas `CachedModelConverter`.
      return List<T>.from(
        (jsonDecode(cacheData.value as String) as List).map(
          (x) => CachedModelConverter<T>().fromJson(x),
        ),
      );
    } else {
      // Jika hasil data fetch dari storage awal gagal memenuhi kriteria atau format kosong sama sekali, balikin list baru kosong supaya UI aman dari error null crash.
      return [];
    }
  }

  /// Melakukan penyimpanan daftar list data berstruktur bertipe List objek model T ke dalam penyimpanan file lokal berbasis JSON yang digabungkan [key] nya.
  Future<void> saveCachedList<T>({
    required String key,
    required List<T> list,
  }) async {
    // Menaruh record logging mengenai dimulainya tahap persistensi (menulis/menyimpan) cache memory.
    log('$_tag save cache, key: $key');
    
    // Menyuruh kelas interface abstraksi [storage] untuk membukukan satu baris tipe String entitas Cache.
    // Menjalankan fungsi serialisasi list asli di mana disuntikkan ke payload JSON dan masuk ke format Wrapper metadata dari kelas konverter CacheData.
    await storage.save<String>(
      key,
      jsonEncode(CacheData(value: jsonEncode(list))),
    );
  }

  /// Berfungsi Mengambil sebuah objek atau model individual (tunggal) bertipe [T] dari pangkalan penyimpanan lokal berdasarkan tag [key].
  /// Turut menerapkan mekanisme filtering pencocokan nilai cache ID lokal apakah sama valuenya dengan [cachedId] atau kolom parameter referensi modifikasi khusus [customFieldId].
  Future<T?> getCacheObject<T>({
    required String key,
    required String? cachedId,
    String? customFieldId,
  }) async {
    // Log info debugging kunci awal masuk dari fetch operasi objek list tunggal.
    log('$_tag get cache, key : $key');
    // Log pembantu mengecek validitas status isi cacheId tidak bernilai null & tak nol panjang karakter.
    log('$_tag cache id : ${cachedId != null && cachedId.isNotEmpty}');
    
    // Tarik raw data asinkronus ke variabel cache dinamik.
    final dynamic cache = await storage.get(key);
    
    // Cek apabila dalam media persisten memiliki `key` ini dan dipastikan bukan rentetan string format kosong mengunakan method ekstensi [isNotNullAndNotEmpty].
    if (storage.has(key) && cache.toString().isNotNullAndNotEmpty) {
      // Lakukan decoding data root tersebut ke map json, lalu masukan map itu sebagai properti bangun `CacheData`.
      final cacheData = CacheData.fromJson(
        jsonDecode(cache as String) as Map<String, dynamic>,
      );
      
      // Print kembali record logging masa pemakaian dan batas expired model.
      _logging(cacheData, key);
      
      // Ambil inti datanya di parameter value bertipe Map dan tampung sementara pada cast mapping [cacheMap].
      final cacheMap = cacheData.value as Map<String, dynamic>;
      
      // Memvalidasi apakah primary parameter ID valid yang dititipkan user match sempurna dengan record cache yang ada di sistem ini.
      if (cachedId == _getId(cache: cacheMap, customFieldId: customFieldId)) {
        // Jika cocok seutuhnya IDnya, format ulang string yang tervalidasi json dan lempar balik instance objek T sesungguhnya ke layer depan.
        return CachedModelConverter<T>().fromJson(cacheMap);
      }
    }
    // Jika kondisinya jatuh ke bagian else atau validasi id sama-sama menolak match-nya, otomatis dikembalikan data model kosong (null).
    return null;
  }

  /// Fungsi skrip private internal ini digunakan secara terisolir di class mixin ini guna mengambil properti ID esensial dari sebuah representasi map lokal [cache].
  /// Akan merujuk (override fallback) mengutamakan field milik [customFieldId] jika argumen pemanggil menyuplainya dengan tidak null.
  String _getId({required Map<String, dynamic> cache, String? customFieldId}) {
    // Menitahkan nilai kembalian ke spesifik var field opsional kustom ketika dia disediakan (tidak null), mengacuhkan properti id default dari dictionary [cache].
    if (customFieldId != null) return customFieldId;
    
    // Namun bila field paramnya null (default standard mode), ID akan di ekstrak mentah-mentah dari nama field statik lokal `id` dan di cast sebagai string balikan.
    return cache['id'].toString();
  }

  /// Berfungsi menserialisasi langsung dan menyuntikkan (write) data persistensi memori dalam file yang difasilitasi instance objek tunggal model entitas apa saja [data] bertipe generics [T].
  Future<void> saveCachedObject<T>({
    required String key,
    required T data,
  }) async {
    // Mengeksekusi penulisan sinkron API storage untuk menyimpan kombinasi Wrapper JSON [CacheData] lalu dirangkum sebagai encode string final mentah ke key tujuan di map storage.
    await storage.save<String>(
      key,
      jsonEncode(CacheData(value: data).toJson()),
    );
  }

  /// Mengeksekusi aksi memusnahkan entry metadata file cache dari dalam direktori/record berdasarkan target kunci persis spesifik map storage yaitu parameter [key].
  Future<void> deleteCached(String key) async {
    // Menitahkan layer base backend database core (Hive/SharedPrefs/Lainnya) manager untuk mendelete target bersangkutan dari file atau memori utama.
    await storage.delete(key);
  }

  /// Prosedur metode bantuan private kecil ([_logging]) yang memusatkan print console info mendalam khusus masa berlaku operasional (waktu kedaluarsa / expire duration check) sebuah objek parameter lokal [cacheData].
  void _logging(CacheData cacheData, String key) {
    // Log penanda informasi pengambilan objek data yang dihubungkan parameter identifikasi tag.
    log('$_tag get cache $key');
    // Log mencetak kapan tanggal valid target objek di parameter atribut.
    log('$_tag expiry: ${cacheData.expiredDate}');
    // Mengkalkulasi lalu mencetak margin jarak sisa masa hidup validasi waktu dalam hitungan total kalkulasi rentang satuan _menit_.
    log(
      '$_tag Expired in: ${DateTime.now().difference(cacheData.expiredDate).inMinutes} minutes',
    );
    // Print logika kepastian secara final pengecekan rentang waku, bernilai boolean mendeteksi apakah hari ini sudah melebihi titik expired.
    log('$_tag isExpired: ${cacheData.expiredDate.isBefore(DateTime.now())}');
  }
}
