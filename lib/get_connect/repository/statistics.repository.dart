// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/EarningByDay.dart';
import 'package:turnopro_apk/Models/weekly_statistics_model.dart';
import 'package:turnopro_apk/env.dart';
import 'package:http/http.dart' as http; // Asegúrate de importar http

class WeeklyStatisticsRepository extends GetConnect {
  Future getWeeklyStatisticsList(
      idProfessional, startDate, endDate, day) async {
    List<EarningByDay> weeklyStatisticsList = [];
    double totalEarnings = 0.0;
    double? averageEarnings = 0.0;

    try {
      if (idProfessional != null) {
        var url =
            '${Env.apiEndpoint}/professionals_ganancias?professional_id=$idProfessional&startDate=$startDate&endDate=$endDate&day=$day';

        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          if (jsonResponse.containsKey('earningByDay')) {
            // Acceder a la lista de earningByDay
            List<dynamic> earningByDay = jsonResponse['earningByDay'];

            //todo aqui tengo el total y la media
            totalEarnings = (jsonResponse['totalEarnings'] ?? 0).toDouble();
            averageEarnings = (jsonResponse['averageEarnings'] ?? 0).toDouble();

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
