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
  int quantityDatesDia = 0;
  int quantityDatesSem = 0;
  int numberdayWeek = -99099;
  String dateRange = '';
  String dateRangeSem = '';
  String dateRangeDia = '';
  List<num> earningByDays = [];
  List<num> earningByDaysSem = [];
  List<num> earningByDaysDia = [];
  List<num> earningByDaysMen = [];
  double totalEarnings = 0.0;
  double totalEarningsSem = 0.0;
  double totalEarningsMen = 0.0;
  double totalEarningsDia = 0.0;
  double? averageEarnings = 0.0;
  double? averageEarningsSem = 0.0;
  double? averageEarningsMen = 0.0;
  double? averageEarningsDia = 0.0;
  //*********************** */
  Map<String, dynamic> statisticsGeneral = {};
  Map<String, dynamic> statisticsGeneralSem = {};
  Map<String, dynamic> statisticsGeneralMen = {};
  Map<String, dynamic> statisticsGeneralDia = {};
  Map<String, dynamic> statisticsGeneralRespon1 = {};
  Map<String, dynamic> statisticsGeneralRespon2 = {};
  Map<String, dynamic> statisticsGeneralRespon3 = {};

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
      //todo agregadas variables del dia
      startDateIn,
      endDateIn,
      numberdayWeekIn,
      quantityDatesIn) async {
    //todo asi mapea bien
    print('111111 getDataStatisticDay');
    final LoginController controllerLogin = Get.find<LoginController>();
    earningByDaysDia.clear();
    averageEarningsDia = 0.0;
    totalEarningsDia = 0.0;

    dateRangeDia = '';
    if (quantityDatesIn > 7) {
      quantityDatesDia = 7;
    } else {
      quantityDatesDia = quantityDatesIn;
    }
    dateRangeDia = '   $startDateIn  -  $endDateIn';
    try {
      var responseId = await weeklyStatisticsRepository.getDayStatisticsList(
          controllerLogin.idProfessionalLoggedIn,
          controllerLogin.branchIdLoggedIn,
          startDateIn,
          endDateIn,
          controllerLogin.chargeUserLoggedIn,
          controllerLogin.tokenUserLoggedIn);
      print('respuest getDayStatisticsList----$responseId');

      if (responseId['Monto Generado'] != 0) {
        statisticsGeneralDia = responseId;
        update();
      } else {
        statisticsGeneralDia = {};
        print('Resultados correctos pero vacio');
      }
      update();
    } catch (e) {
      print('Error StatisticController en getDataStatistic nueva :1111$e');
    }
  }

  Future<void> getDataStatisticSem(
      //todo agregadas variables del dia
      startDateIn,
      endDateIn,
      numberdayWeekIn,
      quantityDatesIn) async {
    //todo asi mapea bien
    print('111111 getDataStatisticDay');
    final LoginController controllerLogin = Get.find<LoginController>();
    earningByDaysSem.clear();
    averageEarningsSem = 0.0;
    totalEarningsSem = 0.0;
    dateRangeSem = '';
    if (quantityDatesIn > 7) {
      quantityDatesSem = 7;
    } else {
      quantityDatesSem = quantityDatesIn;
    }
    dateRangeSem = '   $startDateIn  -  $endDateIn';
    try {
      var responseId = await weeklyStatisticsRepository.getDayStatisticsList(
          controllerLogin.idProfessionalLoggedIn,
          controllerLogin.branchIdLoggedIn,
          startDateIn,
          endDateIn,
          controllerLogin.chargeUserLoggedIn,
          controllerLogin.tokenUserLoggedIn);
      print('respuest getDayStatisticsList----$responseId');

      if (responseId['Monto Generado'] != 0) {
        statisticsGeneralSem = responseId;
        update();
      } else {
        statisticsGeneralSem = {};
        print('Resultados correctos pero vacio');
      }
      update();
    } catch (e) {
      print('Error StatisticController en getDataStatistic nueva :222:$e');
    }
  }

  Future<void> getDataStatisticMen(mes, year) async {
    //todo asi mapea bien

    final LoginController controllerLogin = Get.find<LoginController>();
    print(
        '111111 getDataStatisticDay -mes:$mes...year:$year..idProf:${controllerLogin.idProfessionalLoggedIn}');
    earningByDaysMen.clear();
    averageEarningsMen = 0.0;
    totalEarningsMen = 0.0;

    try {
      var responseId = await weeklyStatisticsRepository.getDayStatisticsListMen(
          controllerLogin.idProfessionalLoggedIn,
          controllerLogin.branchIdLoggedIn,
          mes,
          year,
          controllerLogin.tokenUserLoggedIn);
      print('respuest getDayStatisticsList----$responseId');

      if (responseId['Monto Generado'] != 0) {
        statisticsGeneralMen = responseId;
        update();
      } else {
        statisticsGeneralMen = {};
        print('Resultados correctos pero vacio');
      }
      update();
    } catch (e) {
      print('Error StatisticController en getDataStatistic otra :$e');
    }
  }

  Future<void> getDataStatisticRespon(page, startDateIn, endDateIn,
      numberdayWeekIn, quantityDatesIn, mes, year) async {
    //todo asi mapea bien
    print('111111 getDataStatisticRespon');
    final LoginController controllerLogin = Get.find<LoginController>();
    earningByDays.clear();
    averageEarnings = 0.0;
    totalEarnings = 0.0;

    if (page == 1) {
      dateRangeDia = '   $startDateIn  -  $endDateIn';
    } else if (page == 2) {
      dateRangeSem = '   $startDateIn  -  $endDateIn';
    } else if (page == 3) {
      dateRange = '   $startDateIn  -  $endDateIn';
    }

    if (mes == -99 && year == -99) {
      if (quantityDatesIn > 7) {
        quantityDates = 7;
      } else {
        quantityDates = quantityDatesIn;
      }
    }

    try {
      var responStad = await weeklyStatisticsRepository.getDayStatisticsRespon(
          controllerLogin.branchIdLoggedIn,
          startDateIn,
          endDateIn,
          mes,
          year,
          controllerLogin.tokenUserLoggedIn);
      print('respuest getDataStatisticRespon----$responStad');

      if (responStad['Monto Generado'] != 0) {
        if (page == 1) {
          statisticsGeneralRespon1 = responStad;
        } else if (page == 2) {
          statisticsGeneralRespon2 = responStad;
        } else if (page == 3) {
          statisticsGeneralRespon3 = responStad;
        }
      } else {
        if (page == 1) {
          statisticsGeneralRespon1 = {};
        } else if (page == 2) {
          statisticsGeneralRespon2 = {};
        } else if (page == 3) {
          statisticsGeneralRespon3 = {};
        }
        print('Resultados getDataStatisticRespon CORRECTOS pero vacio');
      }
      update();
    } catch (e) {
      print(
          'Resultados getDataStatisticRespon ERROR StatisticController en getDataStatistic esta otra :$e');
    }
  }

  // Future<void> getDataStatisticRespon(startDateIn, endDateIn, numberdayWeekIn,
  //     quantityDatesIn, mes, year) async {
  //   //todo asi mapea bien
  //   print('111111 getDataStatisticRespon');
  //   final LoginController controllerLogin = Get.find<LoginController>();
  //   earningByDays.clear();
  //   averageEarnings = 0.0;
  //   totalEarnings = 0.0;
  //   if (mes == -99 && year == -99) {
  //     dateRange = '';
  //     if (quantityDatesIn > 7) {
  //       quantityDates = 7;
  //     } else {
  //       quantityDates = quantityDatesIn;
  //     }
  //     dateRange = '   $startDateIn  -  $endDateIn';
  //   }

  //   try {
  //     var responStad = await weeklyStatisticsRepository.getDayStatisticsRespon(
  //         controllerLogin.branchIdLoggedIn, startDateIn, endDateIn, mes, year);
  //     print('respuest getDataStatisticRespon----$responStad');

  //     if (responStad['Monto Generado'] != 0) {
  //       statisticsGeneralRespon1 = responStad;
  //       update();
  //     } else {
  //       statisticsGeneralRespon1 = {};
  //       print('Resultados getDataStatisticRespon CORRECTOS pero vacio');
  //     }
  //     update();
  //   } catch (e) {
  //     print(
  //         'Resultados getDataStatisticRespon ERROR StatisticController en getDataStatistic esta otra :$e');
  //   }
  // }

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
              numberdayWeekIn,
              controllerLogin.tokenUserLoggedIn);

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
