// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/EarningByDay.dart';
import 'package:turnopro_apk/Models/weekly_statistics_model.dart';
import 'package:turnopro_apk/env.dart';
import 'package:http/http.dart' as http; // Asegúrate de importar http

class WeeklyStatisticsRepository extends GetConnect {
  Future getDayStatisticsRespon(idBranch, startDate, endDate, mes) async {
    try {
      if (idBranch != null) {
        var url = '';
        if (mes != -99) {
          //si manda un mes
          url =
              '${Env.apiEndpoint}/branch_winner_products?branch_id=$idBranch&mes=$mes';
        } else {
          //si no manda un mes es porque manda yn rango de fechas
          url =
              '${Env.apiEndpoint}/branch_winner_products?branch_id=$idBranch&startDate=$startDate&endDate=$endDate';
        }

        print(idBranch);
        print(startDate);
        print(endDate);
        final response = await http.get(Uri.parse(url));
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('response.statusCode == 200');
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print('***************************....********:$jsonResponse');
          return jsonResponse;
        }

        return null; // Retornando lista vacía
      }
    } catch (e) {
      print('ERROR WeeklyStatisticsRepository: $e');
    }
  }

  Future getDayStatisticsList(
      idProfessional, idBranch, startDate, endDate) async {
    try {
      if (idProfessional != null) {
        var url =
            '${Env.apiEndpoint}/professionals_ganancias_branch?professional_id=$idProfessional&branch_id=$idBranch&startDate=$startDate&endDate=$endDate';
        print(idProfessional);
        print(idBranch);
        print(startDate);
        print(endDate);
        final response = await http.get(Uri.parse(url));
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('response.statusCode == 200');
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print(
              '***************************....********:${jsonResponse['earningPeriodo']}');
          return jsonResponse['earningPeriodo'];
        }

        return null; // Retornando lista vacía
      }
    } catch (e) {
      print('ERROR WeeklyStatisticsRepository: $e');
    }
  }

  Future getWeeklyStatisticsList(
      idProfessional, idBranch, startDate, endDate, day) async {
    List<EarningByDay> weeklyStatisticsList = [];
    double totalEarnings = 0.0;
    double? averageEarnings = 0.0;

    try {
      if (idProfessional != null) {
        var url =
            '${Env.apiEndpoint}/professionals_ganancias?professional_id=$idProfessional&branch_id=$idBranch&startDate=$startDate&endDate=$endDate&day=$day';

        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print(jsonResponse);
          if (jsonResponse.containsKey('earningByDay')) {
            // Acceder a la lista de earningByDay
            List<dynamic> earningByDay = jsonResponse['earningByDay']['dates'];

            //todo aqui tengo el total y la media
            totalEarnings =
                (jsonResponse['earningByDay']['totalEarnings'] ?? 0).toDouble();
            averageEarnings =
                (jsonResponse['earningByDay']['averageEarnings'] ?? 0)
                    .toDouble();
            print(
                '*****************************************************************************************');
            print(totalEarnings);
            print(averageEarnings);

            // Iterar sobre la lista y acceder a los valores dentro de cada mapa
            for (var entry in earningByDay) {
              EarningByDay u = EarningByDay.fromJson(entry);
              weeklyStatisticsList.add(u);
            }
          }

          return WeeklyStatisticsModel(
            earningByDay: weeklyStatisticsList,
            totalEarnings: totalEarnings,
            averageEarnings: averageEarnings,
          );
        } else {
          return null; // Retornando lista vacía
        }
      }

      return null; // Retornando lista vacía
    } catch (e) {
      print('ERROR WeeklyStatisticsRepository: $e');
    }
  }
}
