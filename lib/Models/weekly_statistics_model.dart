import 'package:turnopro_apk/Models/EarningByDay.dart';

class WeeklyStatisticsModel {
  final List<EarningByDay> earningByDay;
  final double totalEarnings;
  final double? averageEarnings; // Usar double? para admitir valores nulos

  WeeklyStatisticsModel({
    required this.earningByDay,
    required this.totalEarnings,
    this.averageEarnings,
  });

  factory WeeklyStatisticsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> earningByDayList = json['earningByDay'] ?? [];
    final List<EarningByDay> earningByDay =
        earningByDayList.map((day) => EarningByDay.fromJson(day)).toList();

    return WeeklyStatisticsModel(
      earningByDay: earningByDay,
      totalEarnings: json['totalEarnings'] ?? 0.0,
      averageEarnings: json['averageEarnings'], // Puede ser nulo
    );
  }
}
