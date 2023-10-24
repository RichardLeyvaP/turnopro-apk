// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/get_connect/repository/coexistence.repository.dart';

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
    _fetchCoexistenceList();
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
    coexistence = await repository.getCoexistenceList();
    coexistenceListLength = coexistence.length;
    update();
  }
}
