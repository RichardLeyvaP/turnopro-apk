// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

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
    //todo asi mapea bien

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
