import 'dart:convert';

class Estadist1Model {
  final int id;
  final String clientName;
  final String client_image;
  final String date;
  final String time;
  final String servicesRealizated;
  final num amountTotal; // Cambiar de int a num
  final num amountWin; // Cambiar de int a num
  final String choice;
  final int serviceSpecial;
  final int pay;
  final num specialAmount; // Cambiar de int a num

  Estadist1Model({
    required this.id,
    required this.clientName,
    required this.client_image,
    required this.date,
    required this.time,
    required this.servicesRealizated,
    required this.amountTotal,
    required this.amountWin,
    required this.choice,
    required this.serviceSpecial,
    required this.specialAmount,
    required this.pay,
  });

  factory Estadist1Model.fromJson(Map<String, dynamic> json) {
    return Estadist1Model(
      id: json['id'],
      clientName: json['clientName'],
      client_image: json['client_image'],
      date: json['data'],
      time: json['time'],
      servicesRealizated: json['servicesRealizated'],
      amountTotal: json['amountTotal'],
      amountWin: json['amountWin'],
      choice: json['choice'],
      serviceSpecial: json['serviceSpecial'],
      specialAmount: json['SpecialAmount'],
      pay: json['pay'],
    );
  }

  static List<Estadist1Model> listFromJson(String jsonString) {
    final parsed = jsonDecode(jsonString)['car'] as List<dynamic>;
    return parsed
        .map<Estadist1Model>((json) => Estadist1Model.fromJson(json))
        .toList();
  }
}
