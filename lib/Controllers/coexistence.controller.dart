// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:turnopro_apk/Models/branch_model.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/get_connect/repository/coexistence.repository.dart';
import 'package:intl/intl.dart';

class CoexistenceController extends GetxController {
  //DECLARACION DE VARIABLES
  CoexistenceRepository repository = CoexistenceRepository();
  double getTotal = 20.0;
  int coexistenceListLength = 0;
  List<CoexistenceModel> coexistence = [];
  int professionalListLength = 0;
  int branchProfessionalListLength = 0;
  List<ProfessionalModel> professional = []; // Lista de Notificaciones
  List<BranchModel> branchProfessional = []; // Lista de Notificaciones
  ProfessionalModel? selectedProfessional; // Lista de Notificaciones
  BranchModel? selectedBranch; // Lista de Notificaciones
  List<CoexistenceModel> selectCoexistence = [];
  bool isLoading = true;
  //LLAMANDO AL CONTROLADOR
  CoexistenceController() {
    print('estoy inicializando CoexistenceController ');
    final StatisticController controllerStad = Get.find<StatisticController>();
    final LoginController controllerLogin = Get.find<LoginController>();
    if (controllerLogin.chargeUserLoggedIn == "Barbero") {
      print('llamando fetchCoexistenceList(); porque soy Barbero');
      fetchCoexistenceList();
    }
    if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
      print('llamando fetchCoexistenceList(); porque soy Tecnico');
      fetchCoexistenceList();
    }

    //todo esto solo cargarlo cuando sea un Responsable
    if (controllerLogin.chargeUserLoggedIn == "Encargado") {
      print('llamando fetchCoexistenceList(); porque soy Encargado');
      fetchBranchProfessionals();
    }

    if (controllerLogin.chargeUserLoggedIn == "Cordinador") {
      print('llamando fetchCoexistenceList(); porque soy Cordinador');
      fetchBranchProfessionals();
    }
    //esto CARGAR este metodo si es RESPONSABLE

    //AQUI CARGO LA Estadística DEL DIA DE HOY INICIALMENTE JASTA QUE SELECCIONES ALGUNA FECHA
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

  Future<void> fetchCoexistenceList() async {
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idProfessional = controllerLogin.idProfessionalLoggedIn;
    int? idBranch = controllerLogin.branchIdLoggedIn;
    coexistence = await repository.getCoexistenceList(idProfessional, idBranch);
    print(coexistence.length);
    coexistenceListLength = coexistence.length;
    print('a15627 coexistenceListLength:${coexistenceListLength}');

    update();
    controllerLogin.setIsLoadingFor(false);
  }

  Future<void> specificCoexistenceList(idProfessional) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idBranch = controllerLogin.branchIdLoggedIn;
    coexistence = await repository.getCoexistenceList(idProfessional, idBranch);
    print(coexistence.length);
    coexistenceListLength = coexistence.length;
    update();
  }

  Future<void> fetchBranchProfessionals() async {
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idBranch = controllerLogin.branchIdLoggedIn;
    professional = await repository.getBranchProfessionals(idBranch);
    print(
        'actualizando las convivencias iniciales.RLP- getCoexistenceList111111 %%%%%%%%%%%%%%%%% Profesionales por branch %%%%%%%%%%%%%%%%%%%%');
    print(professional.length);
    professionalListLength = professional.length;
//todo agregue esto nuevo
    print(
        'actualizando las convivencias iniciales.RLP- getCoexistenceList222222222 %%%%%%%%%%%%%%%%% Profesionales por branch %%%%%%%%%%%%%%%%%%%%');
    update();
  }

  Future<void> getBranchProfessionals(String email, String password) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    controllerLogin.uss = email;
    controllerLogin.pass = password;

    branchProfessional =
        await repository.getBranchProfessionals2(email, password);
    print('aqui estoy devFuture<void> getBranchProfessionals');
    print(branchProfessional.length);
    branchProfessionalListLength = branchProfessional.length;
    if (branchProfessionalListLength > 0) {
      controllerLogin.loadingValue(false);
      Get.toNamed('/LoginFormPage2');
    } else {
      print(
          'ya tengo la cola de la api es estaa Tipos de dato No hay sucursales');
    }
    print(
        'aqui estoy devFuture<void> branchProfessionalListLength:$branchProfessionalListLength');
    update();
  }
}
