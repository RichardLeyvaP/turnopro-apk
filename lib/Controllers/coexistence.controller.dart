// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/get_connect/repository/coexistence.repository.dart';

class CoexistenceController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  CoexistenceController() {
    getTotalSum();
    calculateTime();
    if (yaEntre == false) {
      _fetchCoexistenceList(); // Llamar al método asincrónico en el constructor
      getTotalSum();
      yaEntre = true;
      update();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  CoexistenceRepository repository = CoexistenceRepository();
  bool yaEntre = false;
  double getTotal = 20.0;
  int numero = 5;
  int coexistenceListLength = 0;
  int primero = 1;
  List<CoexistenceModel> coexistence = []; // Lista de Notificaciones
  List<CoexistenceModel> selectCoexistence =
      []; // Lista de Notificaciones seleccionados vacia
  int time = 30;
  bool isLoading = true;

  void seleccStars() {
    primero++;
    update();
  }

  void calculateTime() {
    if (time > 60) {
      //controlando que el tiempo no sea mayor que 60 min
      time = 60;
    }
    if (time < 0) {
      //controlando que el tiempo no sea negativo
      time = 0;
    }
    update();
  }

  getList() {
    return coexistence;
  }

  getSelectCoexistence(index) {
    (selectCoexistence.contains(coexistence[index]))
        ? selectCoexistence.remove(coexistence[index])
        : selectCoexistence.add(coexistence[index]);
    update();
  }

  getTotalSum() {
    getTotal = getTotal + 5;

    // getTotal = coexistence
    //     .map((coexistence) => coexistence.id)
    //     .fold(0.0, (sum, id) => sum + id)
    //     .toDouble();
    // print(getTotal);
    update();
  }

  //Future<List<UserModel>> userList() async => await repository.getUserList();

  Future<void> _fetchCoexistenceList() async {
    coexistence = await repository.getCoexistenceList();
    coexistenceListLength = coexistence.length;
    update();
  }

  void addCoexistence() {
    CoexistenceModel newCoexistence = CoexistenceModel(
        id: 12,
        name: "Convivencia $coexistenceListLength",
        username: "Nueva Convivencia");
    coexistence.add(newCoexistence);
    coexistenceListLength =
        coexistence.length; //actualizo la logitud de la lista
    getTotalSum();
    update();
  }

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
  void deleteCoexistence(int index) {
    if (index >= 0 && index < coexistence.length) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

      if (selectCoexistence.contains(coexistence[index])) {
        selectCoexistence
            .removeWhere((coexistences) => coexistences == coexistence[index]);
        getTotal = getTotal - 5;
      }
    }
    coexistence.removeAt(index);
    coexistenceListLength = coexistence.length;

    update();
  }

  //*ELIMINAR  ELEMENTOS SELECCIONADOS
  void deleteMultipleCoexistence() {
    if (selectCoexistence.isNotEmpty) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
      coexistence.removeWhere((element) => selectCoexistence.contains(element));
      coexistenceListLength = coexistence.length;
      selectCoexistence = [];
      getTotal = getTotal - 5;
      update();
    }
  }

  void deleteAll() {
    coexistence = [];
    selectCoexistence = [];
    coexistenceListLength = coexistence.length;
    getTotal = 0.0;
    update();
  }
}
