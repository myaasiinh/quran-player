/* author
   myaasiinh@gmail.com
*/

import '/config/base/request_param.dart';
import '/core/mixin/cache_mixin.dart';
import '/core/mixin/connectivity_mixin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Kontroler abstrak berbasis [GetxController] yang menangani operasi penyerantaan (pagination).
///
/// Menyediakan fitur pemuatan data bertahap, status halaman, pengecekan
/// konektivitas ([ConnectivityMixin]), serta manajemen memori ter-cache ([CacheMixin]).
abstract class PaginationController<T> extends GetxController
    with ConnectivityMixin, CacheMixin {
  /// Parameter HTTP khusus yang bisa diteruskan ke API layanan.
  late RequestParams requestParams;

  /// Token pembatalan (cancel token) untuk membatalkan koneksi HTTP di tengah jalan.
  CancelToken cancelToken = CancelToken();
  /// Batas data yang diambil tiap halaman (per page). Default adalah 20.
  int perPage = 20;
  /// Status index halaman terkini. Dimulai dari 1.
  int page = 1;

  /// Kontroler utama Paging yang mengatur state list (keys & items).
  late final pagingController = PagingController<int, T>(
    // Mendapatkan kunci (key) halaman selanjutnya berdasarkan item terakhir.
    getNextPageKey: (state) =>
        state.hasNextPage ? ((state.keys?.last ?? 0) + 1) : null,
    // Eksekusi fungsi muat data berdasarkan pergantian pageKey.
    fetchPage: (pageKey) async {
      if (_onLoad != null) {
        // Simpan pageKey terkini
        page = pageKey;
        // Jalankan fungsi asinkron luar
        await _onLoad!();
      }
      return [];
    },
  );

  /// Kontroler pengguliran daftar untuk kebutuhan scroll spesifik.
  final scrollController = ScrollController();

  /// Bendera status untuk menentukan apakah memuat data harus menimpa data saat ini atau menjaganya.
  bool get keepAlive => false;

  /// Identitas kunci cache untuk data halaman ini. Dapat di-override.
  String get cachedKey => '';

  /// Fungsi pemuatan asinkron untuk dieksekusi.
  Future Function()? _onLoad;

  @mustCallSuper
  @override
  void onInit() {
    // Inisialisasi param dasar request ketika awal dibuat.
    requestParams = RequestParams(
      cancelToken: cancelToken,
      cachedKey: cachedKey,
    );

    // Memantau perubahan koneksi. Jika terkoneksi lagi dan halaman pertama error, maka refresh.
    listenConnectivity(() async {
      if (pagingController.value.status == PagingStatus.firstPageError) {
        await onRefresh();
      }
    });
    super.onInit();
  }

  /// Aksi melakukan segarkan ulang daftar dari awal.
  @mustCallSuper
  Future<void> onRefresh() async {
    if (_onLoad != null) {
      // Hapus data cache jika tersimpan
      if (cachedKey.isNotEmpty) await deleteCached(cachedKey);
      // Riset state tanpa menghapus antarmuka daftar jika keepAlive digunakan
      if (page > 1) await resetState(keepAlive: keepAlive);
      // Segarkan paksa
      pagingController.refresh();
    }
  }

  @mustCallSuper
  @override
  Future<void> onClose() async {
    // Batalkan pantauan jaringan
    await cancelConnectivity();
    // Bersihkan kontroler dari memori
    pagingController.dispose();
    scrollController.dispose();
    // Batalkan semua pemuatan HTTP yang aktif
    cancelToken.cancel();
    super.onClose();
  }

  /// Mereset kembali status ke halaman awal (page = 1).
  ///
  /// Jika [keepAlive] bernilai true, maka state loading pertama tidak muncul,
  /// data akan tetap tampil dilayar sementara memuat senyap dibelakang layar.
  Future<void> resetState({bool keepAlive = false}) async {
    page = 1;
    // Mengamankan data dari daftar supaya layar tak berkedip bila keepAlive aktif
    final keepData = _keepAliveData();
    pagingController.value = PagingState(
      keys: keepAlive && keepData.isNotEmpty ? [page] : [],
      pages: keepAlive && keepData.isNotEmpty ? [keepData] : [],
    );
    // Mengembalikan posisi list ke atas
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Memulai panggilan untuk menyiapkan muatan data baru.
  Future<void> loadData(Future Function() onLoad) async {
    _onLoad = onLoad;
    // Pemuatan awal akan tertrigger langsung oleh PagingController secara default
  }

  /// Menugaskan error pada status state list ketika API gagal di muat.
  void loadError(Object error) {
    pagingController.value = pagingController.value.copyWith(
      error: error,
      isLoading: false,
    );
  }

  /// Menambahkan blok data baru ke status list dan melanjutkan nomor halaman.
  void loadNextData({required List<T> data}) {
    // Memeriksa apakah data hasil muat ini cukup besar untuk lanjut halaman lagi
    final hasNextPage = data.length >= perPage;
    final nextKey = hasNextPage ? page + 1 : null;

    // Memperbaharui state keseluruhan
    pagingController.value = pagingController.value.copyWith(
      pages: [...?pagingController.value.pages, data],
      keys: nextKey != null
          ? [...?pagingController.value.keys, nextKey]
          : pagingController.value.keys,
      hasNextPage: hasNextPage,
      isLoading: false,
    );
    // Tingkatkan nomor halaman
    if (hasNextPage) page++;
  }

  /// Mengambil potongan data secukupnya (maksimal perPage) untuk diselamatkan di memori.
  List<T> _keepAliveData() {
    final dataList = pagingController.value.items ?? [];
    if (dataList.length >= perPage) {
      return dataList.sublist(0, perPage);
    } else {
      return dataList;
    }
  }
}
