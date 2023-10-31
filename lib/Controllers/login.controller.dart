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
  String userLoggedIn = '';
  String tokenUserLoggedIn = '';
  int idUserLoggedIn = -2023991991;
  String emailUserLoggedIn = '';
  String chargeUserLoggedIn = '';
  int? idProfessionalLoggedIn;
  int? branchIdLoggedIn;
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
        nameUserLoggedIn = result['nameProfessional'];
        userLoggedIn = result['userName'];
        tokenUserLoggedIn = result['token'];
        idUserLoggedIn = result['id'];
        emailUserLoggedIn = result['email'];
        chargeUserLoggedIn = result['charge'];
        idProfessionalLoggedIn = result['professional_id'];
        branchIdLoggedIn = result['branch_id'];

        //*******Asignando Valores*****/
        print('TOKEN***************************: $tokenUserLoggedIn');

        if (tokenUserLoggedIn != '' &&
            nameUserLoggedIn != '' &&
            emailUserLoggedIn != '') {
          pagina = '/Professional';
          if (chargeUserLoggedIn == "Barbero") {
            pagina = '/Professional';
            Get.offAllNamed('/Professional');
          } else if (chargeUserLoggedIn == "Encargado") {
            pagina = '/HomeResponsible';
            Get.offAllNamed('/HomeResponsible');
          }
        }
        update();
      } //cierre if (result != null) {
      else {
        print(' result == null por eso no entro');
      }
    } catch (e) {
      print('errorrrrrr:$e');
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
