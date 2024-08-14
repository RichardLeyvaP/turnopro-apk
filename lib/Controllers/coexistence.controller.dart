// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:turnopro_apk/Models/Estadist0_model.dart';
import 'package:turnopro_apk/Models/Estadist1_model.dart';
import 'package:turnopro_apk/Models/Payment_model.dart';
import 'package:turnopro_apk/Models/branch_model.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/get_connect/repository/coexistence.repository.dart';
import 'package:intl/intl.dart';

class CoexistenceController extends GetxController {
  //DECLARACION DE VARIABLES
  CoexistenceRepository repository = CoexistenceRepository();
  final LoginController controllerLogin = Get.find<LoginController>();
  double getTotal = 20.0;
  int coexistenceListLength = 0;
  int estadist1Length = 0;
  int estadistPagosLength = 0;
  int estadist0Length = 0;
  Map<String, String> estadistPagosFijo = {
    'pendiente': '0',
    'pagado': '0',
    'clientAtended': '0',
    'servCant': '0',
    'amountGenerate': '0',
    'propina80': '0',
    'metaCant': '0',
    'metaAmount': '0',
    'retention': '0',
    'winnerRetention': '0',
    'winnerAmount': '0',
    'productCant': '0',
    'productAmount': '0',
    'servAmount': '0',
  };

  //VARIABLES DE ESTADIDSTICA ANUAL

  //VARIABLES DE ESTADIDSTICA ANUAL
  List<CoexistenceModel> coexistence = [];
  List<Estadist1Model> estadist1 = [];
  List<Estadist0Model> estadist0 = [];
  List<PaymentModel> estadistPagos = [];
  int professionalListLength = 0;
  int branchProfessionalListLength = 0;
  List<ProfessionalModel> professional = []; // Lista de Notificaciones
  List<BranchModel> branchProfessional = []; // Lista de Notificaciones
  ProfessionalModel? selectedProfessional; // Lista de Notificaciones
  BranchModel? selectedBranch; // Lista de Notificaciones
  List<CoexistenceModel> selectCoexistence = [];
  bool isLoading = true;
  bool retriesResult = false;
  String? chargeSave;
  //LLAMANDO AL CONTROLADOR

  CoexistenceController() {
    /*
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

    if (controllerLogin.chargeUserLoggedIn == "Coordinador") {
      print('llamando fetchCoexistenceList(); porque soy Coordinador');
      fetchBranchProfessionals();
    }
    //esto CARGAR este metodo si es RESPONSABLE

    //AQUI CARGO LA Estadística DEL DIA DE HOY INICIALMENTE JASTA QUE SELECCIONES ALGUNA FECHA
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
    controllerStad.getDataStatisticDay(dateAct, dateAct, 1, 1);
    */
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
    try {
      coexistence = await repository.getCoexistenceList(idProfessional, idBranch, controllerLogin.tokenUserLoggedIn);
      print(coexistence.length);
      coexistenceListLength = coexistence.length;
      print('a15627 coexistenceListLength:${coexistenceListLength}');

      update();
    } catch (e) {
      print(e);
    } finally {
      controllerLogin.setIsLoadingFor(false);
      Get.back();
    }
  }

  String averageEarnings = '0', totalEarnings = '0';
  List<double> meses = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  //todo nuevaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  Future<void> getStadistAno(int ano) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idProfessional = controllerLogin.idProfessionalLoggedIn;
    int? idBranch = controllerLogin.branchIdLoggedIn;
    Map<String, dynamic> resultList =
        await repository.getAnoStadist(idProfessional, idBranch, ano, controllerLogin.tokenUserLoggedIn);
    meses[0] = double.parse(resultList['stadist']['enero'].toString());
    print('resultadosssssss 4');
    meses[1] = double.parse(resultList['stadist']['febrero'].toString());
    print('resultadosssssss 5');
    meses[2] = double.parse(resultList['stadist']['marzo'].toString());
    print('resultadosssssss 6');
    meses[3] = double.parse(resultList['stadist']['abril'].toString());
    print('resultadosssssss 7');
    meses[4] = double.parse(resultList['stadist']['mayo'].toString());
    print('resultadosssssss 8');
    meses[5] = double.parse(resultList['stadist']['junio'].toString());
    print('resultadosssssss 9');
    meses[6] = double.parse(resultList['stadist']['julio'].toString());
    meses[7] = double.parse(resultList['stadist']['agosto'].toString());
    meses[8] = double.parse(resultList['stadist']['septiembre'].toString());
    meses[9] = double.parse(resultList['stadist']['octubre'].toString());
    meses[10] = double.parse(resultList['stadist']['noviembre'].toString());
    meses[11] = double.parse(resultList['stadist']['diciembre'].toString());
    print('resultadosssssss 15');

    //   averageEarnings = resultList['averageEarnings'];

    averageEarnings = resultList['averageEarnings'].toString();
    totalEarnings = resultList['totalEarnings'].toString();
    //   totalEarnings = resultList['totalEarnings'];

    update();
  }

  Future<void> fetchEstadist1(data) async {
    print('werya tengo1');
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idProfessional = controllerLogin.idProfessionalLoggedIn;
    int? idBranch = controllerLogin.branchIdLoggedIn;
    String? charge = controllerLogin.chargeUserLoggedIn;
    chargeSave = charge;
    estadist1 = await repository.fetchEstadist1(idProfessional, idBranch, data, charge);
    print(estadist1.length);
    estadist1Length = estadist1.length;
    print('werya tengo-result coexistenceListLength:${estadist1Length}');

    update();
    controllerLogin.setIsLoadingFor(false);
  }

  Future<void> fetchEstadistPagos() async {
    retriesResult = false;
    print('werya tengo1');
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idProfessional = controllerLogin.idProfessionalLoggedIn;
    int? idBranch = controllerLogin.branchIdLoggedIn;
    String? charge = controllerLogin.chargeUserLoggedIn;
    if (charge == 'Barbero y Encargado') {
      if (controllerLogin.switchValue == false) {
        charge = 'Barbero';
      } else if (controllerLogin.switchValue == true) {
        charge = 'Encargado';
      }
    }

    Map<String, dynamic> resultList = await repository.fetchEstadistPagos(idProfessional, idBranch, charge);

    estadistPagos = resultList['branchProf'];
    retriesResult = resultList['retries']; //en este controlo si dio error al buscar los datos con true
    print(estadistPagos.length);
    estadistPagosLength = estadistPagos.length;
    print('werya tengo-result coexistenceListLength:${resultList['pendiente']}');
    estadistPagosFijo = {
      'pendiente': resultList['pendiente'].toString(),
      'pagado': resultList['pagado'].toString(),
      'clientAtended': resultList['clientAtended'].toString(),
      'servCant': resultList['servCant'].toString(),
      'amountGenerate': resultList['amountGenerate'].toString(),
      'propina80': resultList['propina80'].toString(),
      'metaCant': resultList['metaCant'].toString(),
      'metaAmount': resultList['metaAmount'].toString(),
      'retention': resultList['retention'].toString(),
      'winnerRetention': resultList['winnerRetention'].toString(),
      'winnerAmount': resultList['winnerAmount'].toString(),
      'productCant': resultList['productCant'].toString(),
      'productAmount': resultList['productAmount'].toString(),
      'servAmount': resultList['servAmount'].toString(),
      //estos 2 son las cantidades de bonos por servicio y por productos
      'productBonoCant': resultList['productBonoCant'].toString(),
      'servBonoCant': resultList['servBonoCant'].toString(),
    };

    update();
    controllerLogin.setIsLoadingFor(false);
  }

  Future<void> fetchEstadist0() async {
    print('werya tengo1');
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idProfessional = controllerLogin.idProfessionalLoggedIn;
    int? idBranch = controllerLogin.branchIdLoggedIn;
    String? charge = controllerLogin.chargeUserLoggedIn;
    chargeSave = charge;
    try {
      estadist0 = await repository.fetchEstadist0(idProfessional, idBranch, charge);
      print(estadist0.length);
      estadist0Length = estadist0.length;
      print('werya tengo-result coexistenceListLength:${estadist0Length}');

      update();
    } catch (e) {
      print(e);
    } finally {
      Get.back();
    }

    //controllerLogin.setIsLoadingFor(false);
  }

  Future<void> specificCoexistenceList(idProfessional) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idBranch = controllerLogin.branchIdLoggedIn;
    coexistence = await repository.getCoexistenceList(idProfessional, idBranch, controllerLogin.tokenUserLoggedIn);
    print(coexistence.length);
    coexistenceListLength = coexistence.length;
    update();
  }

  Future<void> fetchBranchProfessionals() async {
    selectedProfessional = null;
    print('ESTOY ENTRANDO AQUI A CONVIVENCIAS aqui en fetchBranchProfessionals()');
    final LoginController controllerLogin = Get.find<LoginController>();
    int? idBranch = controllerLogin.branchIdLoggedIn;
    print(
        'ESTOY ENTRANDO AQUI A CONVIVENCIAS aqui en controllerLogin.branchIdLoggedIn=${controllerLogin.branchIdLoggedIn}');
    professional = await repository.getBranchProfessionals(idBranch);
    print(
        'actualizando las convivencias iniciales.RLP- getCoexistenceList111111 %%%%%%%%%%%%%%%%% Profesionales por branch %%%%%%%%%%%%%%%%%%%%');
    print(professional.length);
    professionalListLength = professional.length;
//todo agregue esto nuevo
    print(
        'ESTOY ENTRANDO AQUI A CONVIVENCIAS aqui en fetchBranchProfessionals()----professionalListLength-$professionalListLength');
    update();
  }

  Future<int> getBranchProfessionals(String email, String password) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    controllerLogin.uss = email;
    controllerLogin.pass = password;

    final result = await repository.getBranchProfessionals2(email, password);

    if (result == null) {
      print('Result is null');
      return -99;
    }
    // Verifica si result es de tipo List<BranchModel>
    else if (result is List<BranchModel>) {
      branchProfessional = result;
      print('Result is a List<BranchModel>');
      print(branchProfessional.length);
      branchProfessionalListLength = branchProfessional.length;
      if (branchProfessionalListLength > 0) {
        return 1;
      } else {
        print('ya tengo la cola de la api es estaa Tipos de dato No hay sucursales');
        return 0;
      }
    } else {
      print('Result is of an unexpected type: ${result.runtimeType}');
      return -999;
    }
  }
}
