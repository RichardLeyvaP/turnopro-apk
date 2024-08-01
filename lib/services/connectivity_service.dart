import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final _connectionStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }

    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectionStatus.value = result;
  }

  ConnectivityResult get connectionStatus => _connectionStatus.value;

  Future<void> fetchData() async {
    if (_connectionStatus.value == ConnectivityResult.none) {
      shoNotConnected('No está conectado a Internet');
      await Future.delayed(const Duration(seconds: 3));
    } else if (_connectionStatus.value == ConnectivityResult.wifi) {
      print('Conectado por Wi-Fi');
    } else if (_connectionStatus.value == ConnectivityResult.mobile) {
      print('Conectado por datos móviles');
      return;
    } else {
      print('Conexión desconocida');
    }

    // Aquí puedes realizar la llamada a tu API
  }
}

void shoNotConnected(String msj) {
  showSimpleNotification(
    Text(
      msj,
      style: const TextStyle(color: Color(0xFF4470F3)),
    ),
    background: Colors.white,
    // position: NotificationPosition.top,
    position: NotificationPosition.bottom,
    slideDismiss: true, // para que se pueda deslizar para cerrar
  );
}
//ejemplo
// String verificate = await loginController
//                                           .checkConnection();
