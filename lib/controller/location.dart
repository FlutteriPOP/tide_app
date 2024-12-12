import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../widgets/toast_widget.dart';

class LocationController extends GetxController {
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<LocationPermission> _permissionStatus =
      Rx<LocationPermission>(LocationPermission.denied);
  StreamSubscription<Position>? _positionStreamSubscription;

  Position? get currentPosition => _currentPosition.value;

  set currentPosition(Position? position) {
    _currentPosition.value = position;
    log('Current Position: ${position?.latitude}, ${position?.longitude} '
        'Accuracy: ${position?.accuracy}');
  }

  LocationPermission get permissionStatus => _permissionStatus.value;

  @override
  void onInit() {
    super.onInit();
    getCurrentPosition();
  }

  @override
  void onClose() {
    stopLocationUpdates();
    super.onClose();
  }

  /// Check and request location permissions based on platform
  Future<void> checkAndRequestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _checkAndRequestAndroidPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _checkAndRequestIOSPermission();
    } else if (kIsWeb) {
      await _checkAndRequestWebPermission();
    } else {
      log('Unsupported platform for location permissions');
    }
  }

  /// Android-specific permission handling
  Future<void> _checkAndRequestAndroidPermission() async {
    LocationPermission status = await Geolocator.checkPermission();

    // Handle permission results for Android
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      log('Location permission denied on Android');
    } else if (status == LocationPermission.deniedForever) {
      log('Location permission permanently denied on Android');
      await Geolocator.openAppSettings();
    }
    _permissionStatus.value = status;
    showToast('Location Fetch Sucessfully', position: false);
  }

  /// iOS-specific permission handling
  Future<void> _checkAndRequestIOSPermission() async {
    LocationPermission status = await Geolocator.checkPermission();

    // If locationWhenInUse is granted, request locationAlways permission
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status == LocationPermission.deniedForever) {
        log('Location permission permanently denied on iOS');
        await Geolocator.openAppSettings();
      }
    }

    if (status == LocationPermission.always ||
        status == LocationPermission.whileInUse) {
      _permissionStatus.value = status;

      showToast('Location Fetch Sucessfully', position: false);
    } else {
      log('Permission denied or permanently denied on iOS');
      showToast('Location permission denied.', position: false);
    }
  }

  /// Web-specific permission handling
  Future<void> _checkAndRequestWebPermission() async {
    // For Web, permissions are handled automatically
    log('Web platform, location permissions handled automatically');
    _permissionStatus.value = LocationPermission.always;
  }

  /// Fetch the current location and subscribe to location updates
  Future<void> getCurrentPosition() async {
    await checkAndRequestPermission();

    if (_permissionStatus.value == LocationPermission.always ||
        _permissionStatus.value == LocationPermission.whileInUse) {
      await _fetchLocation();
    } else {
      log('Location permission denied');
      showToast('Location permission denied.', position: false);
    }
  }

  /// Private method to fetch the location
  Future<void> _fetchLocation() async {
    try {
      late LocationSettings locationSettings;

      // Configure platform-specific location settings
      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          distanceFilter: 1,
          pauseLocationUpdatesAutomatically: true,
          // showBackgroundLocationIndicator: false,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
        );
      }

      // Fetch current location once
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      currentPosition = position;

      // Start listening to location updates
      _positionStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (position != null) {
          currentPosition = position;
        }
      });
    } catch (e) {
      log('Error fetching location: $e');
      showToast('Failed to fetch location.', position: false);
      currentPosition = null;
    }
  }

  /// Stop receiving location updates
  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    showToast('Location updates stopped.', position: false);
  }
}
