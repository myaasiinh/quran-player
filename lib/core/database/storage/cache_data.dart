/// Model generic untuk menyimpan data dalam cache beserta waktu kedaluwarsanya.
/// 
/// Menggunakan tipe generik [T] agar dapat menyimpan berbagai jenis data.
class CacheData<T> {
  /// Membuat instance [CacheData].
  /// 
  /// Parameter [value] adalah data yang akan disimpan.
  /// Parameter [expiredDate] adalah batas waktu kedaluwarsa data.
  /// Jika [expiredDate] tidak diberikan, maka secara bawaan diatur 10 hari dari waktu sekarang.
  CacheData({required this.value, DateTime? expiredDate})
      : expiredDate = expiredDate ??
            DateTime.now().add(
              const Duration(days: 10),
            );

  /// Membuat instance [CacheData] dari representasi JSON.
  /// 
  /// Parameter [json] adalah peta data JSON yang berisi `value` dan `expiredDate`.
  factory CacheData.fromJson(Map<String, dynamic> json) => CacheData(
        value: json['value'] as T,
        expiredDate: DateTime.parse(json['expiredDate'] as String),
      );

  /// Nilai data yang disimpan dalam cache.
  final T value;
  
  /// Waktu kedaluwarsa dari data dalam cache.
  final DateTime expiredDate;

  /// Mengubah objek [CacheData] menjadi representasi JSON.
  /// 
  /// Mengembalikan peta ([Map]) yang bisa digunakan untuk penyimpanan.
  Map<String, dynamic> toJson() => {
        'value': value,
        'expiredDate': expiredDate.toIso8601String(),
      };
}
