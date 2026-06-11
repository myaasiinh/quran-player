class ApiResponse<T> {
  /// Konstruktor untuk membuat [ApiResponse].
  ApiResponse({
    required this.success,
    required this.message,
    required this.status,
    this.meta,
    this.error,
    this.data,
  });

  /// Factory untuk membuat instance [ApiResponse] dari objek JSON (Map).
  /// Berfungsi sebagai pengurai (parser) data utama, pesan, rincian error, 
  /// status HTTP, serta metadata jika ada.
  factory ApiResponse.fromJson(Map<dynamic, dynamic> json) {
    late bool isErrorNotEmpty;
    // Pengecekan apakah nilai dari atribut error bertipe list dan tidak kosong
    if (json['error'] is List) {
      isErrorNotEmpty = (json['error'] as List).isNotEmpty;
    } else {
      isErrorNotEmpty = json['error'] != null;
    }

    return ApiResponse(
      // Mengambil nilai success, bila null asumsikan keberhasilan jika error bernilai false
      success: (json['success'] as bool?) ?? (json['error'] == false),
      
      // Mendapatkan rincian pesan error apabila isi error terindikasi ada
      error: (isErrorNotEmpty
          ? json['error']
          : (json['message'] ?? json['msg'])) as String?,
          
      // Menyimpan data inti berformat spesifik sesuai tipe [T]
      data: (json['data'] != null) ? json['data'] as T : null,
      
      // Mendapatkan pesan dari respon
      message: (json['message'] ?? json['msg'] ?? '') as String,
      
      // Mendapatkan kode status balasan dari API
      status: (json['status'] as int?) ?? 0,
      
      // Mendapatkan metadata tambahan misal urusan pagination
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
  
  /// Penanda keberhasilan request API.
  final bool success;
  
  /// Pesan balasan dari API server.
  final String message;
  
  /// Kode status HTTP atau balasan kustom API.
  final int status;
  
  /// Rincian spesifik kegagalan / error jika ditemui.
  final String? error;
  
  /// Muatan data inti dari API yang memiliki tipe dinamis [T].
  final T? data;
  
  /// Informasi tambahan seputar data (biasanya berurusan dengan pagination).
  final Meta? meta;
}

/// Kelas [Meta] menyimpan metadata seperti informasi halaman untuk mendukung pagination.
class Meta {
  /// Konstruktor dasar untuk kelas [Meta].
  Meta({
    this.from,
    this.to,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  /// Factory untuk membangun objek [Meta] dengan memetakan JSON yang didapat dari server.
  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        from: json['from'] as int?,
        to: json['to'] as int?,
        currentPage: json['current_page'] as int?,
        lastPage: json['last_page'] as int?,
        perPage: json['per_page'] as int?,
        total: json['total'] as int?,
      );
      
  /// Indeks permulaan data yang dikembalikan.
  final int? from;
  
  /// Indeks akhir data yang dikembalikan.
  final int? to;
  
  /// Indikator halaman yang saat ini aktif.
  final int? currentPage;
  
  /// Nomor halaman terakhir yang tersedia.
  final int? lastPage;
  
  /// Batas angka / kuota maksimum jumlah data yang dirender dalam satu halaman.
  final int? perPage;
  
  /// Total / akumulasi keseluruhan data yang tercatat.
  final int? total;

  /// Membungkus dan menerjemahkan ulang properti pada [Meta] menjadi representasi objek JSON.
  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
      };
}
