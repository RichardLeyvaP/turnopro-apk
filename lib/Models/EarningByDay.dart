// ignore_for_file: file_names

// Suponiendo que EarningByDay tiene un constructor fromJson
class EarningByDay {
  final String date;
  final int dayOfWeek;
  final num earnings;

  EarningByDay(
      {required this.date, required this.dayOfWeek, required this.earnings});

  factory EarningByDay.fromJson(Map<String, dynamic> json) {
    return EarningByDay(
      date: json['date'],
      dayOfWeek: json['day_week'],
      earnings: json['earnings'],
    );
  }
}
