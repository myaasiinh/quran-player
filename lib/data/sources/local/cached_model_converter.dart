import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:json_annotation/json_annotation.dart';

/// Helper [typeEqual] berfungsi mengecek komparasi kesamaan tipe data asli 
/// secara harafiah di antara dua variabel penampung generic [S] dan [T].
bool typeEqual<S, T>() => S == T;

/// Helper [typeEqualN] bertindak sama seperti atas, namun mencakup pembandingan ekstra 
/// untuk menyamakan tipe data yang mengandung status penanda nullable (opsional `?`).
bool typeEqualN<S, T>() {
  // Return kondisi or: apakah identik standar, ataukah identik walau diwacanakan sebagai opsional
  return typeEqual<S, T>() || typeEqual<S?, T?>();
}

/// [CachedModelConverter] mendefinisikan standar penterjemah model bersambung ke format JSON buatan khusus (custom).
/// Principal Note: Perangkat ini dirancang penting guna mewadahi rutinitas 
/// serialisasi & deserialisasi model berorientasi objek dalam siklus penarikan data ke dan dari memori lokal (storage).
class CachedModelConverter<T> implements JsonConverter<T, Object> {
  /// Konstruktor standar untuk konverter JSON berwujud konstan konfigurasional.
  const CachedModelConverter();

  /// Mengonversi nilai balik JSON raw mentah bawaan dari Object penyimpanan menjadi model dart ber-tipe [T].
  @override
  T fromJson(Object? json) {
    // Memaksakan (casting) tipe Object menjadi tatanan kunci Map String konvensional.
    final data = json! as Map<String, dynamic>;

    // Melakukan pendaftaran/inspeksi pencocokan spesifik bagi model tipe `SurahModel` guna diubah balik.
    if (typeEqualN<T, SurahModel>()) {
      // Apabila terbukti cocok, rakit objek map json menjadi SurahModel, lalu lemparkan balik sebagai T.
      return SurahModel.fromJson(data) as T;
    }
    // Melakukan pengecekan susulan registrasi untuk pengenalan bentuk `AyahModel`.
    else if (typeEqualN<T, AyahModel>()) {
      // Membina konstruktor AyahModel menggunakan ekstraksi factory method.
      return AyahModel.fromJson(data) as T;
    }

    // Jika objek yang direquest tak ada di jajaran pemetaan tipe yang diketahui, lontarkan interupsi peringatan gagal/tak ditemukan
    throw UnimplementedError('`$T` fromJson factory unimplemented.');
  }

  /// Mengemas instansi sebuah model kompleks menjadi Map JSON bertipe string agar kompatibel direkam dalam disk storage.
  @override
  Map<String, dynamic> toJson(T obj) {
    // Mendeteksi pengemasan untuk obyek keluarga dari [SurahModel].
    if (typeEqualN<T, SurahModel>()) {
      // Melakukan parsing object kembali jadi dictionary list json string untuk persiapan di simpan.
      return (obj as SurahModel).toJson();
    }
    // Mendeteksi pengemasan objek turunan untuk entitas keluarga [AyahModel].
    else if (typeEqualN<T, AyahModel>()) {
      // Konversikan wujud AyahModel jadi representatif Map yang disepakati.
      return (obj as AyahModel).toJson();
    }

    // Menghasilkan lontaran pelaporan error apabila terpaksa ada tipe nyasar yang belum didukung algoritma di atas
    throw UnimplementedError('`$T` toJson factory unimplemented.');
  }
}
