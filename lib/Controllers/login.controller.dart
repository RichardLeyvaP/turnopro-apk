// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/get_connect/repository/services.repository.dart';

class LoginController extends GetxController {
  //LLAMANDO AL CONTROLADOR

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  ServiceRepository repository = ServiceRepository();
  String usuario = '';
  String pass = '';
  bool isLoading = true;
  String pagina = 'nothing';
  bool obscureText = true;
  bool login = true; //sino es register

  void updateData(String u, String p) {
    usuario = u.toString();
    pass = p.toString();
    update();
  }

  void getData() {
    if (usuario == 'usuario' && pass == '123') {
      pagina = '/home';
      update();
    } else if (usuario == 'admin' && pass == '123') {
      pagina = '/HomeResponsible';
      update();
    }
  }

  void exit() {
    pagina = 'nothing';
    update();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    update();
  }

  void changeLoginValue() {
    login = !login;
    update();
  }
}
