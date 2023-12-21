// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/weekly_statistics_model.dart';
import 'package:turnopro_apk/get_connect/repository/statistics.repository.dart';

class StatisticController extends GetxController {
  WeeklyStatisticsRepository weeklyStatisticsRepository =
      WeeklyStatisticsRepository();
  //DECLARACION DE VARIABLES
  //*********************** */
  int quantityDates = 0;
  int numberdayWeek = -99099;
  String dateRange = '';
  List<num> earningByDays = [];
  double totalEarnings = 0.0;
  double? averageEarnings = 0.0;
  //*********************** */
  Map<String, dynamic> statisticsGeneral = {};
  Map<String, dynamic> statisticsGeneralRespon = {};

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  bool isLoading = true;

  Future<void> getDataStatisticDay(
      startDateIn, endDateIn, numberdayWeekIn, quantityDatesIn) async {
    //todo asi mapea bien
    print('111111 getDataStatisticDay');
    final LoginController controllerLogin = Get.find<LoginController>();
    earningByDays.clear();
    averageEarnings = 0.0;
    totalEarnings = 0.0;
    dateRange = '';
    if (quantityDatesIn > 7) {
      quantityDates = 7;
    } else {
      quantityDates = quantityDatesIn;
    }
    dateRange = '   $startDateIn  -  $endDateIn';
    try {
      var responseId = await weeklyStatisticsRepository.getDayStatisticsList(
          controllerLogin.idProfessionalLoggedIn,
          controllerLogin.branchIdLoggedIn,
          startDateIn,
          endDateIn);
      print('respuest getDayStatisticsList----$responseId');

      if (responseId['Monto Generado'] != 0) {
        statisticsGeneral = responseId;
        update();
      } else {
        statisticsGeneral = {};
        print('Resultados correctos pero vacio');
      }
      update();
    } catch (e) {
      // print('Error StatisticController en getDataStatistic :$e');
    }
  }

  Future<void> getDataStatisticRespon(
      startDateIn, endDateIn, numberdayWeekIn, quantityDatesIn, mes) async {
    //todo asi mapea bien
    print('111111 getDataStatisticRespon');
    final LoginController controllerLogin = Get.find<LoginController>();
    earningByDays.clear();
    averageEarnings = 0.0;
    totalEarnings = 0.0;
    dateRange = '';
    if (quantityDatesIn > 7) {
      quantityDates = 7;
    } else {
      quantityDates = quantityDatesIn;
    }
    dateRange = '   $startDateIn  -  $endDateIn';
    try {
      var responStad = await weeklyStatisticsRepository.getDayStatisticsRespon(
          controllerLogin.branchIdLoggedIn, startDateIn, endDateIn, mes);
      print('respuest getDataStatisticRespon----$responStad');

      if (responStad['Monto Generado'] != 0) {
        statisticsGeneralRespon = responStad;
        update();
      } else {
        statisticsGeneralRespon = {};
        print('Resultados correctos pero vacio');
      }
      update();
    } catch (e) {
      // print('Error StatisticController en getDataStatistic :$e');
    }
  }

  Future<void> getDataStatistic(
      startDateIn, endDateIn, numberdayWeekIn, quantityDatesIn) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    earningByDays.clear();
    averageEarnings = 0.0;
    totalEarnings = 0.0;
    dateRange = '';
    if (quantityDatesIn > 7) {
      quantityDates = 7;
    } else {
      quantityDates = quantityDatesIn;
    }
    // numberdayWeek = numberdayWeekIn;
    // print(
    //     'Id Profesional : ${controllerLogin.idProfessionalLoggedIn}  fechaIni: $startDateIn  fechaFin: $endDateIn  diaSemana: $numberdayWeekIn  cantidad de fechas: $quantityDatesIn');

    try {
      WeeklyStatisticsModel responseId =
          await weeklyStatisticsRepository.getWeeklyStatisticsList(
              controllerLogin.idProfessionalLoggedIn,
              controllerLogin.branchIdLoggedIn,
              startDateIn,
              endDateIn,
              numberdayWeekIn);

      if (responseId.averageEarnings != null) {
        numberdayWeek = -99099;
        // Recorrer la lista earningByDay
        for (var entry in responseId.earningByDay) {
          // String date = entry.date;
          int dayOfWeek = entry.dayOfWeek;
          num earnings = entry.earnings;

          earningByDays.add(earnings);

          //todo actualizando variables globales *****
          if (numberdayWeek == -99099) {
            numberdayWeek =
                dayOfWeek; //todo ya aqui actualiza el dia de la semana en el grafico
          }
        }

        //todo ****ACTUALIZANDO VARIABLES PARA EL GRAFICO****************
        totalEarnings = responseId.totalEarnings;
        averageEarnings = responseId.averageEarnings;
        dateRange = '   $startDateIn  -  $endDateIn';
        //todo **********************************************************

        update();
      } else {
        // print('Resultados correctos pero vacio');
      }
      update();
    } catch (e) {
      // print('Error StatisticController en getDataStatistic :$e');
    }
  }
}
