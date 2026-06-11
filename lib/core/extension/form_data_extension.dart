import 'dart:io';

import 'package:dio/dio.dart';

/// Ekstensi pada [File] (nullable) untuk mengubah file menjadi [MultipartFile].
/// Hal ini berguna saat ingin mengunggah file menggunakan [Dio].
extension FileExtension on File? {
  /// Mengembalikan objek [MultipartFile] jika file tidak bernilai null, 
  /// jika file null, maka akan mengembalikan null.
  MultipartFile? get toFormDataFile {
    return this != null ? MultipartFile.fromFileSync(this!.path) : null;
  }
}

/// Ekstensi pada `List<File>` (nullable) untuk mengubah list of file menjadi list of [MultipartFile].
extension FileNullListExtension on List<File>? {
  /// Mengembalikan list dari [MultipartFile] jika list of file tidak bernilai null,
  /// jika null, maka akan mengembalikan null.
  List<MultipartFile>? get toFormDataFiles {
    return this?.map((e) => MultipartFile.fromFileSync(e.path)).toList();
  }
}
