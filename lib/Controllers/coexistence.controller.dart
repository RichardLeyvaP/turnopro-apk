// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/get_connect/repository/coexistence.repository.dart';
import 'package:intl/intl.dart';

class CoexistenceController extends GetxController {
  //DECLARACION DE VARIABLES
  CoexistenceRepository repository = CoexistenceRepository();
  double getTotal = 20.0;
  int coexistenceListLength = 0;
  List<CoexistenceModel> coexistence = []; // Lista de Notificaciones
  List<CoexistenceModel> selectCoexistence = [];
  bool isLoading = true;
  //LLAMANDO AL CONTROLADOR
  CoexistenceController() {
    final StatisticController controllerStad = Get.find<StatisticController>();
    _fetchCoexistenceList();

    //AQUI CARGO LA ESTADISTICA DEL DIA DE HOY INICIALMENTE JASTA QUE SELECCIONES ALGUNA FECHA
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
    controllerStad.getDataStatisticDay(dateAct, dateAct, 1, 1);
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  getList() {
    return coexistence;
  }

  Future<void> _fetchCoexistenceList() async {
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idProfessional = controllerLogin.idProfessionalLoggedIn;
    int? idBranch = controllerLogin.branchIdLoggedIn;
    coexistence = await repository.getCoexistenceList(idProfessional, idBranch);
    print(coexistence.length);
    coexistenceListLength = coexistence.length;
    update();
  }
}
