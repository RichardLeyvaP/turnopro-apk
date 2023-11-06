// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';

class StatisticController extends GetxController {
  //DECLARACION DE VARIABLES
  //*********************** */
  int quantityDates = 0;
  int numberdayWeek = -99099;
  String dateRange = '';
  //*********************** */

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  bool isLoading = true;

  Future<void> getDataStatistic(
      startDateIn, endDateIn, numberdayWeekIn, quantityDatesIn) async {
    final LoginController controllerLogin = Get.find<LoginController>();

    if (quantityDatesIn > 7) {
      quantityDates = 7;
    } else {
      quantityDates = quantityDatesIn;
    }
    numberdayWeek = numberdayWeekIn;
    print(numberdayWeek);
    dateRange = '  ' + startDateIn + '  -  ' + endDateIn;
    update();

    print(
        'Id Profesional : ${controllerLogin.idProfessionalLoggedIn}  fechaIni: $startDateIn  fechaFin: $endDateIn  diaSemana: $numberdayWeekIn  cantidad de fechas: $quantityDatesIn');
    try {} catch (e) {
      // print('Erroor:$e');
    }
  }
}
