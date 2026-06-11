/// Ekstensi pada boolean yang nullable ([bool?]) untuk konversi ke format integer.
/// Berguna saat mengirimkan data ke API yang menggunakan nilai 1/0.
extension BoolNullQueryExtension on bool? {
  /// Mengonversi nilai boolean ke integer (1 untuk [true], 0 untuk [false]).
  /// Jika bernilai null, akan mengembalikan null.
  int? get toIntCode {
    return switch (this) {
      true => 1,
      false => 0,
      _ => null,
    };
  }
}

/// Ekstensi pada [bool] untuk konversi ke format integer.
extension BoolQueryExtension on bool {
  /// Mengonversi nilai boolean ke integer (1 untuk [true], 0 untuk [false]).
  int get toIntCode => this ? 1 : 0;
}

/// Ekstensi pada [int] untuk mengecek nilai boolean dari sebuah kode integer.
extension IntQueryExtension on int {
  /// Mengembalikan [true] jika nilai integer sama dengan 1.
  bool get isTrue => this == 1;

  /// Mengembalikan [true] jika nilai integer sama dengan 0.
  bool get isFalse => this == 0;
}

/// Ekstensi pada [int] yang nullable untuk mengecek nilai boolean dari sebuah kode integer.
extension IntNullQueryExtension on int? {
  /// Mengembalikan [true] jika nilai integer sama dengan 1.
  bool get isTrue => this == 1;

  /// Mengembalikan [true] jika nilai integer sama dengan 0.
  bool get isFalse => this == 0;
}
