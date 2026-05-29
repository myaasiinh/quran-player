import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:json_annotation/json_annotation.dart';

/// [typeEqual] mengecek kesamaan tipe data antara dua generic S dan T.
bool typeEqual<S, T>() => S == T;

/// [typeEqualN] mengecek kesamaan tipe data termasuk varian nullable.
bool typeEqualN<S, T>() {
  return typeEqual<S, T>() || typeEqual<S?, T?>();
}

/// [CachedModelConverter] adalah konverter JSON custom untuk mekanisme caching.
/// Principal Note: Digunakan untuk mendeserialisasi data dari storage lokal ke model objek.
class CachedModelConverter<T> implements JsonConverter<T, Object> {
  const CachedModelConverter();

  @override
  T fromJson(Object? json) {
    final data = json! as Map<String, dynamic>;

    // Registrasi model Surah untuk konversi balik dari cache.
    if (typeEqualN<T, SurahModel>()) {
      return SurahModel.fromJson(data) as T;
    }
    // Registrasi model Ayah untuk konversi balik dari cache.
    else if (typeEqualN<T, AyahModel>()) {
      return AyahModel.fromJson(data) as T;
    }

    throw UnimplementedError('`$T` fromJson factory unimplemented.');
  }

  @override
  Map<String, dynamic> toJson(T obj) {
    // Konversi objek Surah ke Map JSON untuk disimpan ke cache.
    if (typeEqualN<T, SurahModel>()) {
      return (obj as SurahModel).toJson();
    }
    // Konversi objek Ayah ke Map JSON untuk disimpan ke cache.
    else if (typeEqualN<T, AyahModel>()) {
      return (obj as AyahModel).toJson();
    }

    throw UnimplementedError('`$T` toJson factory unimplemented.');
  }
}
