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

abstract class BaseController<T> extends GetxController
    with ConnectivityMixin, CacheMixin {
  late RequestParams requestParams;

  CancelToken cancelToken = CancelToken();
  final errorMessage = Rxn<String>();

  Rx<RequestState> state = RequestState.initial.obs;

  int perPage = 20;
  int page = 1;

  final dataObj = Rxn<T>();
  RxList<T> dataList = RxList<T>([]);

  Future Function()? _onLoad;

  bool get keepAlive => false;

  String get cachedKey => '';

  String get cachedId => '';

  bool get isInitial => state.value.isInitial;

  bool get isLoading => state.value.isLoading;

  bool get isError =>
      errorMessage.value != null &&
      errorMessage.value != '' &&
      state.value.isError;

  bool get isEmpty => state.value.isEmpty;

  bool get isSuccess =>
      !isEmpty && !isError && !isLoading && state.value.isSuccess;

  @mustCallSuper
  @override
  void onInit() {
    requestParams = RequestParams(
      cancelToken: cancelToken,
      cachedKey: cachedKey,
      cachedId: cachedId,
    );
    listenConnectivity(() async {
      if (isError && !isLoading) await onRefresh();
    });
    super.onInit();
  }

  Future<void> onRefresh() async {
    if (_onLoad != null) {
      if (cachedKey.isNotEmpty) await deleteCached('$cachedKey/$cachedId');
      if (!keepAlive) showLoading();
      await _onLoad!();
    }
  }

  @mustCallSuper
  @override
  Future<void> onClose() async {
    await cancelConnectivity();
    cancelToken.cancel();
    super.onClose();
  }

  void showLoading() {
    state.value = RequestState.loading;
    errorMessage.value = null;
  }

  void loadError(String message) {
    errorMessage.value = message;
    state.value = RequestState.error;
  }

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

  void loadFinish({T? data, List<T> list = const []}) {
    if (data != null) dataObj.value = data;
    if (list.isNotEmpty) dataList.value = list;
    if (dataList.isEmpty && dataObj.value == null) {
      state.value = RequestState.empty;
    } else {
      state.value = RequestState.success;
    }
  }
}
