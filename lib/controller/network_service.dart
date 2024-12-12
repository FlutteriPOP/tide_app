import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService extends GetxService {
  static RxBool isConnected = false.obs;
  StreamSubscription? _subscription;
  bool _wasConnected = true;

  @override
  void onInit() {
    super.onInit();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      isConnected.value = status == InternetStatus.connected;

      if (!isConnected.value && _wasConnected) {
        _showNoInternetBanner(Get.overlayContext!);
        _wasConnected = false;
      } else if (isConnected.value && !_wasConnected) {
        _hideNoInternetBanner(Get.overlayContext!);
        _wasConnected = true;
      }
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _showNoInternetBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.white),
        ),
        leading: const Icon(
          Icons.wifi_off_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text(
              'Dismiss',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Hide the MaterialBanner when internet is restored
  void _hideNoInternetBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }
}
