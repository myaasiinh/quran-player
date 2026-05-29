import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:json_annotation/json_annotation.dart';

bool typeEqual<S, T>() => S == T;

bool typeEqualN<S, T>() {
  return typeEqual<S, T>() || typeEqual<S?, T?>();
}

class CachedModelConverter<T> implements JsonConverter<T, Object> {
  const CachedModelConverter();

  @override
  T fromJson(Object? json) {
    final data = json! as Map<String, dynamic>;
    if (typeEqualN<T, SurahModel>()) {
      return SurahModel.fromJson(data) as T;
    } else if (typeEqualN<T, AyahModel>()) {
      return AyahModel.fromJson(data) as T;
    }

    throw UnimplementedError('`$T` fromJson factory unimplemented.');
  }

  @override
  Map<String, dynamic> toJson(T obj) {
    if (typeEqualN<T, SurahModel>()) {
      return (obj as SurahModel).toJson();
    } else if (typeEqualN<T, AyahModel>()) {
      return (obj as AyahModel).toJson();
    }

    throw UnimplementedError('`$T` toJson factory unimplemented.');
  }
}
