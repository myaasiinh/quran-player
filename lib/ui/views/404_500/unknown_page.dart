import 'dart:io';

import '/core/extension/string_extension.dart';
import '/ui/widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetPage<dynamic>? get unknownPage {
  if (Platform.isAndroid) {
    return GetPage(
      name: '/unknown',
      page: () {
        if (Get.previousRoute.isNotNullAndNotEmpty) Get.back();
        return const Scaffold(body: PlatformLoadingIndicator());
      },
    );
  }
  return null;
}
