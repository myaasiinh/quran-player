/// Sebuah kelas generik yang merepresentasikan objek global dengan identifikasi unik
/// dan nilai opsional.
///
/// Kelas ini dirancang untuk menyimpan data yang memiliki ID (pengenal) dan
/// nilai terkait, di mana tipe ID dan nilai dapat ditentukan secara fleksibel
/// menggunakan parameter tipe generik [I] dan [V].
///
/// Contoh penggunaan:
/// ```dart
/// GlobalObject<String, int> userScore = GlobalObject(id: 'user123', value: 100);
/// GlobalObject<int, String> productInfo = GlobalObject(id: 456, value: 'Laptop');
/// ```
///
/// Parameter Tipe:
/// - [I] Tipe data untuk ID objek.
/// - [V] Tipe data untuk nilai objek. Nilai ini bersifat opsional (nullable).
class GlobalObject<I, V> {
  /// Membuat instance baru dari [GlobalObject].
  ///
  /// Membutuhkan [id] sebagai pengenal unik untuk objek.
  /// [value] adalah nilai opsional yang terkait dengan objek.
  GlobalObject({
    required this.id, // Pengenal unik untuk objek ini.
    this.value, // Nilai opsional yang terkait dengan objek ini.
  });

  /// Membuat instance [GlobalObject] dari sebuah peta JSON.
  ///
  /// Metode factory ini memungkinkan deserialisasi objek dari format JSON
  /// menjadi instance [GlobalObject].
  ///
  /// Parameter:
  /// - [json] Peta yang berisi data objek, diharapkan memiliki kunci 'id' dan 'value'.
  ///
  /// Mengembalikan:
  /// Sebuah instance [GlobalObject] yang diinisialisasi dengan data dari [json].
  factory GlobalObject.fromJson(Map<String, dynamic> json) => GlobalObject(
        id: json['id'] as I, // Mengambil 'id' dari JSON dan mengkonversinya ke tipe [I].
        value: json['value'] as V?, // Mengambil 'value' dari JSON dan mengkonversinya ke tipe [V] yang nullable.
      );

  I id; // Pengenal unik (ID) untuk objek ini.
  V? value; // Nilai opsional yang terkait dengan objek ini. Bisa null.

  /// Mengkonversi instance [GlobalObject] ini menjadi sebuah peta JSON.
  ///
  /// Metode ini memungkinkan serialisasi objek menjadi format JSON,
  /// yang berguna untuk penyimpanan atau transmisi data.
  ///
  /// Mengembalikan:
  /// Sebuah peta yang merepresentasikan objek ini, dengan kunci 'id' dan 'value'.
  Map<String, dynamic> toJson() => {
        'id': id, // Memasukkan ID objek ke dalam peta JSON.
        'value': value, // Memasukkan nilai objek ke dalam peta JSON.
      };
}