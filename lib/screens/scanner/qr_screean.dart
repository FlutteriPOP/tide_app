import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/colors.dart';
import '../../controller/location.dart';
import '../../model/dashbord.dart';
import '../../model/qr.dart';
import '../../services/qr_api.dart';
import '../../widgets/circuler.dart';
import '../../widgets/toast_widget.dart';
import '../other/home.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  QrScreenState createState() => QrScreenState();
}

class QrScreenState extends State<QrScreen> {
  final LocationController locationController = Get.find<LocationController>();
  DashboardModel? dashboardFuture;
  Barcode? _result;
  QRViewController? _controller;
  bool _isLoading = false;
  bool _isBackCamera = true;
  bool _isFlashOn = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(),
            const SizedBox(height: 5),
            Expanded(flex: 6, child: buildQRScanner()),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 30),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan Barcode',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: tsecondaryColor),
              ),
              const SizedBox(height: 2),
              const Text(
                'Place the Barcode within the box to scan',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildQRScanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(55)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          alignment: Alignment.center,
          children: [
            QRView(
              key: qrKey,
              cameraFacing:
                  _isBackCamera ? CameraFacing.back : CameraFacing.front,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: const Color(0xff2ff7df),
                borderRadius: 30,
                borderLength: 40,
                borderWidth: 7,
                cutOutSize: _getScanArea(context),
              ),
            ),
            if (_isLoading) const MyCircularIndicator(color: tContainerColor),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildFlashButton(),
          const SizedBox(width: 20),
          buildCameraFlipButton(),
          const SizedBox(width: 20),
          buildLocationButton(),
        ],
      ),
    );
  }

  Widget buildFlashButton() {
    return IconButton(
      icon: const CircleAvatar(
        backgroundColor: tContainerColor,
        child: Icon(Icons.flash_on, color: tTextwhiteColor),
      ),
      onPressed: () async {
        setState(() {
          _isFlashOn = !_isFlashOn;
        });
        await _controller?.toggleFlash();
      },
    );
  }

  Widget buildCameraFlipButton() {
    return IconButton(
      icon: const CircleAvatar(
        backgroundColor: tContainerColor,
        child: Icon(Icons.flip_camera_android, color: tTextwhiteColor),
      ),
      onPressed: () async {
        setState(() {
          _isBackCamera = !_isBackCamera;
        });
        await _controller?.flipCamera();
      },
    );
  }

  Widget buildLocationButton() {
    return IconButton(
      onPressed: () {
        locationController.getCurrentPosition();
      },
      icon: const CircleAvatar(
        backgroundColor: tContainerColor,
        radius: 24,
        child: Icon(Icons.location_pin, color: tTextwhiteColor),
      ),
    );
  }

  double _getScanArea(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
    return screenSize < 400 ? 200.0 : 250.0;
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      log('Scanned data: ${scanData.code}');
      setState(() {
        _result = scanData;
      });
      if (_result?.code?.isNotEmpty ?? false) {
        _controller?.stopCamera();
        await _sendScannedData(_result!.code.toString());
      }
    });
  }

  Future<void> _sendScannedData(String qrCode) async {
    final prefs = await SharedPreferences.getInstance();
    final permission = prefs.getString('permission');
    setState(() {
      _isLoading = true;
    });

    double? latitude;
    double? longitude;

    if (permission == '1') {
      try {
        Position? position = locationController.currentPosition;
        latitude = position?.latitude;
        longitude = position?.longitude;
      } catch (e) {
        log('Error getting location: $e');
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } else {
      latitude = 0.0;
      longitude = 0.0;
    }

    log('Qr code: $qrCode');
    log('Latitude: $latitude');
    log('Longitude: $longitude');

    try {
      final qrModel = await QrClient().postQrApi(
        latitude: latitude,
        longitude: longitude,
        qrCode: qrCode,
      );

      setState(() {
        _isLoading = false;
      });

      _showDialog(qrModel!);
    } catch (e) {
      log('Error sending scanned data: $e');
      setState(() {
        _isLoading = false;
      });
      showToast('Error sending scanned data.');
    }
  }

  void _showDialog(QrModel qrModel) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // final currentPosition = locationController.currentPosition;
        return AlertDialog(
          title: Text(
            'QR Scanned',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: tsecondaryColor,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                qrModel.message.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: tTextblackColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 10),
              // if (_result != null) Text('QR Code: ${_result!.code}'),
              // if (currentPosition != null) ...[
              //   Text('Latitude: ${currentPosition.latitude}'),
              //   Text('Longitude: ${currentPosition.longitude}'),
              //   Text(
              //       'Accuracy: ${currentPosition.accuracy.toStringAsFixed(2)} m'),
              // ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.to(() => const HomeScreen()),
              child: Container(
                decoration: BoxDecoration(
                  color: tContainerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tTextwhiteColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
