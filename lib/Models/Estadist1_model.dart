import 'dart:convert';

// {
//           "id": 167,
//          // "clientName": "Aldo Marion",
//           "client_image": "comments/default.jpg",
//         //  "data": "2024-04-14 17:34:40",
//         //  "time": "01:25:00",
//          // "servicesRealizated": "Barba, , Corte de cabello",
//           "tips": 10000,
//           "tips80%": 8000,
//          // "Services": 3,
//         //  "totalServices": 75000,
//          // "Products": 0,
//         //  "totalProducts": 12000,
//          // "choice": "Seleccionado",
//          // "serviceSpecial": 0,
//          // "SpecialAmount": 0,
//          // "serviceRegular": 2,
//         //  "pay": 1,
//           "totalRetention": 10220,
//          // "totalGeneral": 87000,
//          // "amountGenerate": 51100
//       }
class Estadist1Model {
  final int id;
  final String clientName;
  final String client_image;
  final String date;
  final String time;
  final String servicesRealizated;
  final String choice;
  final int? tips;
  final int? tips80;
  final int? Services;
  final int? totalServices;
  final int? Products;
  final int? totalProducts;
  final int? serviceSpecial;
  final int? SpecialAmount;
  final int? serviceRegular;
  final int? pay;
  final int? totalRetention;
  final int? totalGeneral;
  final int? amountGenerate;

  Estadist1Model({
    required this.id,
    required this.clientName,
    required this.client_image,
    required this.date,
    required this.time,
    required this.servicesRealizated,
    required this.choice,
    this.tips,
    this.tips80,
    this.Services,
    this.totalServices,
    this.Products,
    this.totalProducts,
    this.serviceSpecial,
    this.SpecialAmount,
    this.serviceRegular,
    this.pay,
    this.totalRetention,
    this.totalGeneral,
    this.amountGenerate,
  });

  factory Estadist1Model.fromJson(Map<String, dynamic> json) {
    return Estadist1Model(
      id: json['id'],
      clientName: json['clientName'],
      client_image: json['client_image'],
      date: json['data'],
      time: json['time'],
      servicesRealizated: json['servicesRealizated'],
      tips: json['tips'],
      tips80: json['tips80%'],
      Services: json['Services'],
      totalServices: json['totalServices'],
      Products: json['Products'],
      totalProducts: json['totalProducts'],
      choice: json['choice'],
      serviceSpecial: json['serviceSpecial'],
      SpecialAmount: json['SpecialAmount'],
      serviceRegular: json['serviceRegular'],
      pay: json['pay'],
      totalRetention: json['totalRetention'],
      totalGeneral: json['totalGeneral'],
      amountGenerate: json['amountGenerate'],
    );
  }

  static List<Estadist1Model> listFromJson(String jsonString) {
    final parsed = jsonDecode(jsonString)['car'].cast<Map<String, dynamic>>();
    return parsed
        .map<Estadist1Model>((json) => Estadist1Model.fromJson(json))
        .toList();
  }
}
