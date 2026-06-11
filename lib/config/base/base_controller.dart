/* author
   myaasiinh@gmail.com
*/

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '/config/base/request_param.dart';
import '/config/base/request_state.dart';
import '/core/error/app_exception.dart';
import '/core/helper/app_logger.dart';
import '/core/mixin/cache_mixin.dart';
import '/core/mixin/connectivity_mixin.dart';

/// Kelas abstrak [BaseController] adalah controller dasar yang menggunakan GetX.
/// Menyediakan fungsionalitas umum seperti manajemen status request API, 
/// pengecekan konektivitas, pagination, serta fitur caching data.
abstract class BaseController<T> extends GetxController
    with ConnectivityMixin, CacheMixin {
  /// Parameter request yang dipakai saat melakukan pemanggilan API.
  late RequestParams requestParams;

  /// Token untuk membatalkan proses request API (misal menggunakan Dio).
  CancelToken cancelToken = CancelToken();
  
  /// Menyimpan pesan error secara reaktif jika terjadi kesalahan.
  final errorMessage = Rxn<String>();

  /// Menyimpan status pemanggilan API (initial, loading, success, dsb) secara reaktif.
  Rx<RequestState> state = RequestState.initial.obs;

  /// Menentukan batas jumlah data yang ingin diambil per halaman untuk pagination.
  int perPage = 20;
  
  /// Menentukan halaman saat ini yang sedang aktif untuk pagination.
  int page = 1;

  /// Variabel reaktif untuk menampung sebuah objek tunggal bertipe [T].
  final dataObj = Rxn<T>();
  
  /// Variabel reaktif berupa daftar data yang berisi elemen bertipe [T].
  RxList<T> dataList = RxList<T>([]);

  /// Fungsi asinkron yang digunakan sebagai penampung logika pemanggilan API.
  Future Function()? _onLoad;

  /// Properti untuk menentukan apakah status loading pada cache harus dipertahankan.
  bool get keepAlive => false;

  /// Kunci (key) string yang digunakan untuk menyimpan atau memanggil cache.
  String get cachedKey => '';

  /// Identifier (id) khusus tambahan yang membedakan satu cache dari cache lain pada key yang sama.
  String get cachedId => '';

  /// Mengembalikan true jika status request saat ini adalah initial.
  bool get isInitial => state.value.isInitial;

  /// Mengembalikan true jika request sedang dalam proses (loading).
  bool get isLoading => state.value.isLoading;

  /// Mengembalikan true jika request mengalami error dan terdapat pesan error.
  bool get isError =>
      errorMessage.value != null &&
      errorMessage.value != '' &&
      state.value.isError;

  /// Mengembalikan true jika hasil dari request tidak memiliki data (kosong).
  bool get isEmpty => state.value.isEmpty;

  /// Mengembalikan true jika request berhasil memuat data dan tidak terjadi error maupun loading.
  bool get isSuccess =>
      !isEmpty && !isError && !isLoading && state.value.isSuccess;

  /// Metode bawaan dari GetX yang dipanggil saat inisialisasi controller.
  /// Digunakan untuk mengatur parameter request dan mendengarkan perubahan koneksi internet.
  @mustCallSuper
  @override
  void onInit() {
    // Inisialisasi parameter request yang akan digunakan.
    requestParams = RequestParams(
      cancelToken: cancelToken,
      cachedKey: cachedKey,
      cachedId: cachedId,
    );
    
    // Mendengarkan perubahan jaringan, dan memuat ulang data jika terjadi error.
    listenConnectivity(() async {
      if (isError && !isLoading) await onRefresh();
    });
    super.onInit();
  }

  /// Berfungsi untuk me-refresh data. Akan menghapus cache yang relevan dan 
  /// melakukan pemuatan data ulang dari fungsi [_onLoad].
  Future<void> onRefresh() async {
    if (_onLoad != null) {
      if (cachedKey.isNotEmpty) await deleteCached('$cachedKey/$cachedId');
      if (!keepAlive) showLoading();
      await _onLoad!();
    }
  }

  /// Metode yang dipanggil sesaat sebelum controller dihapus dari memori.
  /// Menutup listener koneksi dan membatalkan semua request API yang masih berjalan.
  @mustCallSuper
  @override
  Future<void> onClose() async {
    await cancelConnectivity();
    cancelToken.cancel();
    super.onClose();
  }

  /// Mengubah status request menjadi loading dan mengosongkan pesan error sebelumnya.
  void showLoading() {
    state.value = RequestState.loading;
    errorMessage.value = null;
  }

  /// Mengubah status request menjadi error serta menetapkan pesan error dari pemanggilan.
  void loadError(String message) {
    errorMessage.value = message;
    state.value = RequestState.error;
  }

  /// Eksekusi logika fungsi pemuatan data ([onLoad]) yang diteruskan dari antarmuka luar.
  /// Mengatur kondisi loading, penanganan exception, dan menangkap log error jika terjadi kegagalan.
  Future<void> loadData(Future Function() onLoad) async {
    showLoading();
    try {
      await onLoad();
      _onLoad = onLoad;
    } catch (e, stackTrace) {
      final appException = ExceptionMapper.map(e);
      AppLogger.error('Error in loadData', e, stackTrace);
      loadError(appException.message);
    }
  }

  /// Dipanggil untuk mengakhiri proses pemuatan data.
  /// Akan mengatur data object maupun data list serta menentukan status akhir apakah success atau empty.
  void loadFinish({T? data, List<T> list = const []}) {
    if (data != null) dataObj.value = data;
    if (list.isNotEmpty) dataList.value = list;
    
    // Jika list kosong dan object tidak ada datanya, atur state ke empty.
    if (dataList.isEmpty && dataObj.value == null) {
      state.value = RequestState.empty;
    } else {
      state.value = RequestState.success;
    }
  }
}
