import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';

class LoadingErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLoadingErrorPage(),
    );
  }
}

class MyLoadingErrorPage extends StatefulWidget {
  @override
  _MyLoadingErrorPageState createState() => _MyLoadingErrorPageState();
}

class _MyLoadingErrorPageState extends State<MyLoadingErrorPage> {
  final LoginController controllerLogin = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () async {
//VERIFICAR QUE ESTE TODO BIEN

      if (controllerLogin.chargeUserLoggedIn == "Barbero") {
        Get.offAllNamed('/Professional');
      } else if (controllerLogin.chargeUserLoggedIn == "Encargado") {
        Get.offAllNamed('/HomeResponsible');
      } else if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
        Get.offAllNamed('/HomeTecnico');
      } else if (controllerLogin.chargeUserLoggedIn == "Cordinador") {
        Get.offAllNamed('/HomeCordinador');
      } else {
        Get.offAllNamed('/LoginFormPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF18254)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFF18254),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
