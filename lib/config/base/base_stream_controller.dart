import 'dart:async';

import '/config/base/request_state.dart';
import '/core/mixin/connectivity_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/

abstract class BaseStreamController<T> extends GetxController
    with ConnectivityMixin {
  Rx<RequestState> state = RequestState.initial.obs;
  final errorMessage = Rxn<String>();

  final dataObj = Rxn<T>();
  RxList<T> dataList = RxList<T>([]);

  StreamSubscription? _subscription;

  bool get isInitial => state.value.isInitial;
  bool get isLoading => state.value.isLoading;
  bool get isError => state.value.isError;
  bool get isEmpty => state.value.isEmpty;
  bool get isSuccess => state.value.isSuccess;

  @mustCallSuper
  @override
  void onInit() {
    listenConnectivity(() async {
      if (isError && !isLoading) await onRefresh();
    });
    super.onInit();
  }

  Future<void> onRefresh() async {
    // Override this in child class if needed
  }

  @mustCallSuper
  @override
  Future<void> onClose() async {
    await cancelConnectivity();
    await _subscription?.cancel();
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

  /// Use this to bind a stream to the controller
  Future<void> bindDataStream(Stream<T> stream) async {
    showLoading();
    await _subscription?.cancel();
    _subscription = stream.listen(
      (data) {
        dataObj.value = data;
        if (data == null) {
          state.value = RequestState.empty;
        } else {
          state.value = RequestState.success;
        }
      },
      onError: (Object err) {
        loadError(err.toString());
      },
      cancelOnError: false,
    );
  }

  /// Use this to bind a list stream to the controller
  Future<void> bindListDataStream(Stream<List<T>> stream) async {
    showLoading();
    await _subscription?.cancel();
    _subscription = stream.listen(
      (list) {
        dataList.assignAll(list);
        if (list.isEmpty) {
          state.value = RequestState.empty;
        } else {
          state.value = RequestState.success;
        }
      },
      onError: (Object err) {
        loadError(err.toString());
      },
      cancelOnError: false,
    );
  }
}
