/// Merepresentasikan model data untuk sebuah Surah (bab) dalam Al-Qur'an.
///
/// Kelas ini digunakan untuk menyimpan informasi detail tentang sebuah Surah,
/// seperti nomor, nama, nama dalam bahasa Inggris, terjemahan nama,
/// jumlah ayat, dan tipe wahyu (Makkiyah/Madaniyah).
class SurahModel {
  /// Konstruktor default untuk membuat instance [SurahModel].
  ///
  /// [number] : Nomor urut Surah.
  /// [name] : Nama Surah dalam bahasa Arab.
  /// [englishName] : Nama Surah dalam bahasa Inggris.
  /// [englishNameTranslation] : Terjemahan nama Surah dalam bahasa Inggris.
  /// [numberOfAyahs] : Jumlah ayat dalam Surah ini.
  /// [revelationType] : Tipe wahyu Surah (misalnya, "Meccan" atau "Medinan").
  SurahModel({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.numberOfAyahs,
    this.revelationType,
  });

  /// Membuat instance [SurahModel] dari sebuah objek JSON (Map).
  ///
  /// Metode factory ini digunakan untuk mendeserialisasi data JSON
  /// menjadi objek [SurahModel].
  ///
  /// [json] : Sebuah Map yang berisi data Surah dalam format JSON.
  ///
  /// Mengembalikan instance [SurahModel] yang telah diisi dengan data dari [json].
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      // Mengambil nomor Surah dari JSON.
      number: json['number'] as int?,
      // Mengambil nama Surah dari JSON.
      name: json['name'] as String?,
      // Mengambil nama Surah dalam bahasa Inggris dari JSON.
      englishName: json['englishName'] as String?,
      // Mengambil terjemahan nama Surah dalam bahasa Inggris dari JSON.
      englishNameTranslation: json['englishNameTranslation'] as String?,
      // Mengambil jumlah ayat dari JSON.
      numberOfAyahs: json['numberOfAyahs'] as int?,
      // Mengambil tipe wahyu dari JSON.
      revelationType: json['revelationType'] as String?,
    );
  }

  /// Nomor urut Surah.
  final int? number;

  /// Nama Surah dalam bahasa Arab.
  final String? name;

  /// Nama Surah dalam bahasa Inggris.
  final String? englishName;

  /// Terjemahan nama Surah dalam bahasa Inggris.
  final String? englishNameTranslation;

  /// Jumlah ayat dalam Surah ini.
  final int? numberOfAyahs;

  /// Tipe wahyu Surah (misalnya, "Meccan" atau "Medinan").
  final String? revelationType;

  /// Mengonversi instance [SurahModel] ini menjadi sebuah Map yang merepresentasikan JSON.
  ///
  /// Metode ini digunakan untuk menserialisasi objek [SurahModel]
  /// menjadi format yang dapat dengan mudah diubah menjadi JSON.
  ///
  /// Mengembalikan sebuah Map yang berisi data Surah.
  Map<String, dynamic> toJson() {
    return {
      // Nomor Surah.
      'number': number,
      // Nama Surah.
      'name': name,
      // Nama Surah dalam bahasa Inggris.
      'englishName': englishName,
      // Terjemahan nama Surah dalam bahasa Inggris.
      'englishNameTranslation': englishNameTranslation,
      // Jumlah ayat.
      'numberOfAyahs': numberOfAyahs,
      // Tipe wahyu.
      'revelationType': revelationType,
    };
  }
}