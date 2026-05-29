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

abstract class PaginationController<T> extends GetxController
    with ConnectivityMixin, CacheMixin {
  late RequestParams requestParams;

  CancelToken cancelToken = CancelToken();
  int perPage = 20;
  int page = 1;

  late final pagingController = PagingController<int, T>(
    getNextPageKey: (state) =>
        state.hasNextPage ? ((state.keys?.last ?? 0) + 1) : null,
    fetchPage: (pageKey) async {
      if (_onLoad != null) {
        page = pageKey;
        await _onLoad!();
      }
      return [];
    },
  );

  final scrollController = ScrollController();

  bool get keepAlive => false;

  String get cachedKey => '';

  Future Function()? _onLoad;

  @mustCallSuper
  @override
  void onInit() {
    requestParams = RequestParams(
      cancelToken: cancelToken,
      cachedKey: cachedKey,
    );

    listenConnectivity(() async {
      if (pagingController.value.status == PagingStatus.firstPageError) {
        await onRefresh();
      }
    });
    super.onInit();
  }

  @mustCallSuper
  Future<void> onRefresh() async {
    if (_onLoad != null) {
      if (cachedKey.isNotEmpty) await deleteCached(cachedKey);
      if (page > 1) await resetState(keepAlive: keepAlive);
      pagingController.refresh();
    }
  }

  @mustCallSuper
  @override
  Future<void> onClose() async {
    await cancelConnectivity();
    pagingController.dispose();
    scrollController.dispose();
    cancelToken.cancel();
    super.onClose();
  }

  /// if keepAlive = true the loading state never show
  Future<void> resetState({bool keepAlive = false}) async {
    page = 1;
    final keepData = _keepAliveData();
    pagingController.value = PagingState(
      keys: keepAlive && keepData.isNotEmpty ? [page] : [],
      pages: keepAlive && keepData.isNotEmpty ? [keepData] : [],
    );
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> loadData(Future Function() onLoad) async {
    _onLoad = onLoad;
    // Initial fetch happens automatically by the controller
  }

  void loadError(Object error) {
    pagingController.value = pagingController.value.copyWith(
      error: error,
      isLoading: false,
    );
  }

  void loadNextData({required List<T> data}) {
    final hasNextPage = data.length >= perPage;
    final nextKey = hasNextPage ? page + 1 : null;

    pagingController.value = pagingController.value.copyWith(
      pages: [...?pagingController.value.pages, data],
      keys: nextKey != null
          ? [...?pagingController.value.keys, nextKey]
          : pagingController.value.keys,
      hasNextPage: hasNextPage,
      isLoading: false,
    );
    if (hasNextPage) page++;
  }

  List<T> _keepAliveData() {
    final dataList = pagingController.value.items ?? [];
    if (dataList.length >= perPage) {
      return dataList.sublist(0, perPage);
    } else {
      return dataList;
    }
  }
}
