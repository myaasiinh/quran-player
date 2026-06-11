import 'package:dio/dio.dart';

/// Kelas [RequestParams] bertugas membungkus beberapa properti penting
/// yang digunakan dalam proses pemanggilan API.
class RequestParams {
  /// Membuat instance [RequestParams].
  /// Properti [cancelToken] wajib disertakan, sementara parameter cache bersifat opsional.
  RequestParams({
    required this.cancelToken,
    this.cachedKey,
    this.cachedId,
  });
  
  /// Token yang dapat dipanggil untuk membatalkan proses request API (misal saat halaman ditutup).
  CancelToken cancelToken;
  
  /// Kunci unik (key) yang digunakan jika respons API akan disimpan di penyimpanan lokal (cache).
  String? cachedKey;
  
  /// Identifier (id) pelengkap yang digunakan bersamaan dengan [cachedKey] untuk keperluan cache data.
  String? cachedId;
}
