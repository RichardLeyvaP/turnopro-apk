// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/get_connect/repository/user.repository.dart';

class LoginController extends GetxController {
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
  String qrRead = '';
  bool incorrectFields = false;

  void qrReading(String? qr) {
    print('entre aqui a el controlador de lectura del QR${qr.toString()}');
    // Map<String, dynamic> jsonMap = json.decode(qr.toString());
    // print('......................Objeto JSON: $jsonMap');
    // String nombre = jsonMap['nombre']; // Accede al valor del campo "nombre"
    // int edad = jsonMap['edad']; // Accede al valor del campo "edad"
    // print(nombre);
    // print(edad);
  }

  Future<void> loginGetIn(String u, String p) async {
    final ClientsScheduledController clientsScheduledController =
        Get.find<ClientsScheduledController>();
    String email = u.toString(), pass = p.toString();
    incorrectFields = false;
    try {
      Map<String, dynamic>? result; //INICIALIZANDO A NULL
      result = await usuarioLg.getUserLoggedIn(email, pass);

      if (result != null) {
        //*******Asignando Valores*****/
        nameUserLoggedIn = result['name'];
        userLoggedIn = result['userName'];
        tokenUserLoggedIn = result['token'];
        idUserLoggedIn = result['id'];
        emailUserLoggedIn = result['email'];
        chargeUserLoggedIn = result['charge'];
        idProfessionalLoggedIn = result['professional_id'];
        branchIdLoggedIn = result['branch_id'];

        //*******Asignando Valores*****/
        print('branchIdLoggedIn***************************: $branchIdLoggedIn');
        print('TOKEN***************************: $tokenUserLoggedIn');
        print('ID-Profess***************************: $idProfessionalLoggedIn');

        if (tokenUserLoggedIn != '' &&
            nameUserLoggedIn != '' &&
            emailUserLoggedIn != '') {
          pagina = '/Professional';
          if (chargeUserLoggedIn == "Barbero") {
            //aqui cargo la cola del barbero para poder tener en el home al siguiente de la cola inicialmente
            await clientsScheduledController.fetchClientsScheduled(
                idProfessionalLoggedIn, branchIdLoggedIn);

            print('***************SOY BARBERO*************');
            pagina = '/Professional';
            Get.offAllNamed('/Professional');
          } else if (chargeUserLoggedIn == "Encargado") {
            print('***************SOY ENCARGADO*************');
            pagina = '/HomeResponsible';
            Get.offAllNamed('/HomeResponsible');
          }
        }

        update();
      } //cierre if (result != null) {
      else {
        incorrectFields = true;
        update();
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
    userLoggedIn = '';
    tokenUserLoggedIn = '';
    idUserLoggedIn = -2023991991;
    chargeUserLoggedIn = '';
    emailUserLoggedIn = '';
    idProfessionalLoggedIn = null;
    branchIdLoggedIn = null;
    pagina = 'nothing';
    incorrectFields = false;
    update();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    update();
  }
}
