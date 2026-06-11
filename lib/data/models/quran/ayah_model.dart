/// Model data untuk merepresentasikan sebuah ayat dalam Al-Quran.
class AyahModel {
  /// Konstruktor untuk membuat instance dari [AyahModel].
  AyahModel({
    this.number,
    this.text,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
    this.audio,
    this.audioSecondary,
  });

  /// Membuat instance [AyahModel] dari format JSON.
  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int?,
      text: json['text'] as String?,
      numberInSurah: json['numberInSurah'] as int?,
      juz: json['juz'] as int?,
      manzil: json['manzil'] as int?,
      page: json['page'] as int?,
      ruku: json['ruku'] as int?,
      hizbQuarter: json['hizbQuarter'] as int?,
      sajda: json['sajda'],
      audio: json['audio'] as String?,
      audioSecondary: (json['audioSecondary'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Nomor urut ayat secara keseluruhan dalam Al-Quran.
  final int? number;

  /// Teks bahasa Arab dari ayat.
  final String? text;

  /// Nomor urut ayat di dalam surah.
  final int? numberInSurah;

  /// Juz tempat ayat ini berada.
  final int? juz;

  /// Manzil tempat ayat ini berada.
  final int? manzil;

  /// Halaman tempat ayat ini berada dalam mushaf.
  final int? page;

  /// Ruku tempat ayat ini berada.
  final int? ruku;

  /// Hizb quarter tempat ayat ini berada.
  final int? hizbQuarter;

  /// Informasi sajadah (bisa berupa boolean atau objek).
  final dynamic sajda;

  /// URL audio utama untuk ayat ini.
  final String? audio;

  /// Daftar URL audio alternatif untuk ayat ini.
  final List<String>? audioSecondary;

  /// Mengonversi instance [AyahModel] menjadi bentuk map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
      'audio': audio,
      'audioSecondary': audioSecondary,
    };
  }
}
