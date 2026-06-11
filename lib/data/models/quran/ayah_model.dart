/// Model data untuk merepresentasikan sebuah ayat secara utuh dalam Al-Quran.
class AyahModel {
  /// Konstruktor utama untuk membuat instance dari objek [AyahModel].
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

  /// Factory constructor untuk membuat instance [AyahModel] dari format map/JSON.
  factory AyahModel.fromJson(Map<String, dynamic> json) {
    // Mengembalikan objek AyahModel baru
    return AyahModel(
      // Mengambil dan melakukan parsing nilai number sebagai int
      number: json['number'] as int?,
      // Mengambil dan melakukan parsing nilai text sebagai String
      text: json['text'] as String?,
      // Mengambil dan melakukan parsing nilai numberInSurah sebagai int
      numberInSurah: json['numberInSurah'] as int?,
      // Mengambil dan melakukan parsing nilai juz sebagai int
      juz: json['juz'] as int?,
      // Mengambil dan melakukan parsing nilai manzil sebagai int
      manzil: json['manzil'] as int?,
      // Mengambil dan melakukan parsing nilai page sebagai int
      page: json['page'] as int?,
      // Mengambil dan melakukan parsing nilai ruku sebagai int
      ruku: json['ruku'] as int?,
      // Mengambil dan melakukan parsing nilai hizbQuarter sebagai int
      hizbQuarter: json['hizbQuarter'] as int?,
      // Mengambil nilai sajda tanpa parsing tipe data spesifik (dynamic)
      sajda: json['sajda'],
      // Mengambil dan melakukan parsing nilai audio utama sebagai String
      audio: json['audio'] as String?,
      // Melakukan parsing array audioSecondary menjadi List<String>
      audioSecondary: (json['audioSecondary'] as List<dynamic>?)
          // Map masing-masing elemen ke dalam tipe String
          ?.map((e) => e as String)
          // Mengubah iterable hasil map menjadi bentuk List
          .toList(),
    );
  }

  /// Nomor urut ayat secara keseluruhan di dalam Al-Quran (1-6236).
  final int? number;

  /// Teks bahasa Arab dari ayat tersebut.
  final String? text;

  /// Nomor urut ayat secara spesifik di dalam surah tempatnya berada.
  final int? numberInSurah;

  /// Nomor juz tempat ayat ini berada di dalam Al-Quran (1-30).
  final int? juz;

  /// Nomor manzil tempat ayat ini berada di dalam Al-Quran (1-7).
  final int? manzil;

  /// Nomor halaman mushaf tempat ayat ini dicetak.
  final int? page;

  /// Nomor ruku tempat ayat ini berada.
  final int? ruku;

  /// Nomor hizb quarter tempat ayat ini berada.
  final int? hizbQuarter;

  /// Informasi sajadah tilawah (bisa berupa nilai boolean atau objek detail sajadah).
  final dynamic sajda;

  /// URL audio utama yang berisi lantunan ayat ini.
  final String? audio;

  /// Daftar URL audio alternatif yang juga berisi lantunan ayat ini.
  final List<String>? audioSecondary;

  /// Metode untuk mengonversi instance [AyahModel] ini menjadi bentuk map/JSON.
  Map<String, dynamic> toJson() {
    // Mengembalikan objek Map yang berisi pasangan key-value dari properti model
    return {
      // Menyimpan nilai number
      'number': number,
      // Menyimpan nilai text
      'text': text,
      // Menyimpan nilai numberInSurah
      'numberInSurah': numberInSurah,
      // Menyimpan nilai juz
      'juz': juz,
      // Menyimpan nilai manzil
      'manzil': manzil,
      // Menyimpan nilai page
      'page': page,
      // Menyimpan nilai ruku
      'ruku': ruku,
      // Menyimpan nilai hizbQuarter
      'hizbQuarter': hizbQuarter,
      // Menyimpan nilai sajda
      'sajda': sajda,
      // Menyimpan nilai audio utama
      'audio': audio,
      // Menyimpan nilai daftar audio sekunder
      'audioSecondary': audioSecondary,
    };
  }
}
