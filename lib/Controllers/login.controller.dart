// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/get_connect/repository/user.repository.dart';

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

  UserRepository usuarioLg = UserRepository();
  //*************************/
  String nameUserLoggedIn = '';
  String tokenUserLoggedIn = '';
  int idUserLoggedIn = -2023991991;
  String emailUserLoggedIn = '';
  //*************************/
  bool isLoading = true;
  String pagina = 'nothing';
  bool obscureText = true;

  Future<void> loginGetIn(String u, String p) async {
    String email = u.toString(), pass = p.toString();
    try {
      Map<String, dynamic>? result; //INICIALIZANDO A NULL
      result = await usuarioLg.getUserLoggedIn(email, pass);

      if (result != null) {
        //*******Asignando Valores*****/
        nameUserLoggedIn = result['name'];
        tokenUserLoggedIn = result['token'];
        idUserLoggedIn = result['id'];
        emailUserLoggedIn = result['email'];
        //*******Asignando Valores*****/
        print('TOKEN***************************: $tokenUserLoggedIn');
      }

      if (tokenUserLoggedIn != '' &&
          nameUserLoggedIn != '' &&
          emailUserLoggedIn != '') {
        pagina = '/Professional';
        print('PAGINA:$pagina');
        Get.offAllNamed('/Professional');
      } else if (email == 'responsable' && pass == '123') {
        pagina = '/HomeResponsible';
        // Get.offAllNamed(pagina);
      }
      update();
      // Get.offAllNamed(pagina);
    } catch (e) {
      // print('errorrrrrr:$e');
    }
  }

  Future<void> exit(String token) async {
    try {
      if (token != '') {
        Map<String, dynamic>? result; //INICIALIZANDO A NULL
        result = await usuarioLg.userLogout(token);
        if (result != null) {
          await clearSessionData();
          Get.offAllNamed('/loginNewPage');
        } else {
          print('NO CERRO SECION');
        }
      } else
        print('ERROR: -----> Revisar que el token esta llegando aqui vacio');
    } catch (e) {
      print('Erroor:$e');
    }
  }

  Future<void> clearSessionData() async {
    nameUserLoggedIn = '';
    tokenUserLoggedIn = '';
    idUserLoggedIn = -2023023;
    emailUserLoggedIn = '';
    pagina = 'nothing';
    update();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    update();
  }
}
