// import 'dart:convert';

// class Estadist1Model {
//   final int id;
//   final String clientName;
//   final String client_image;
//   final String date;
//   final String time;
//   final String servicesRealizated;
//   final String choice;
//   final int? tips;
//   final int? tips80;
//   final int? Services;
//   final int? totalServices;
//   final int? Products;
//   final int? totalProducts;
//   final int? serviceSpecial;
//   final int? SpecialAmount;
//   final int? serviceRegular;
//   final int? pay;
//   final int? totalRetention;
//   final int? totalGeneral;
//   final int? amountGenerate;
//   final int? metacant;
//   final int? metaamount; //duda si es entero o double
//   final int? amountTotal; //duda si es entero o double

//   Estadist1Model({
//     required this.id,
//     required this.clientName,
//     required this.client_image,
//     required this.date,
//     required this.time,
//     required this.servicesRealizated,
//     required this.choice,
//     this.tips,
//     this.tips80,
//     this.Services,
//     this.totalServices,
//     this.Products,
//     this.totalProducts,
//     this.serviceSpecial,
//     this.SpecialAmount,
//     this.serviceRegular,
//     this.pay,
//     this.totalRetention,
//     this.totalGeneral,
//     this.amountGenerate,
//     this.metacant,
//     this.metaamount,
//     this.amountTotal,
//   });

//   factory Estadist1Model.fromJson(Map<String, dynamic> json) {
//     return Estadist1Model(
//       id: json['id'],
//       clientName: json['clientName'],
//       client_image: json['client_image'],
//       date: json['data'],
//       time: json['time'],
//       servicesRealizated: json['servicesRealizated'],
//       tips: json['tips'],
//       tips80: json['tips80'],
//       Services: json['Services'],
//       totalServices: json['totalServices'],
//       Products: json['Products'],
//       totalProducts: json['totalProducts'],
//       choice: json['choice'],
//       serviceSpecial: json['serviceSpecial'],
//       SpecialAmount: json['SpecialAmount'],
//       serviceRegular: json['serviceRegular'],
//       pay: json['pay'],
//       totalRetention: json['totalRetention'],
//       totalGeneral: json['totalGeneral'],
//       amountGenerate: json['amountGenerate'],
//       metacant: json['metaCant'],
//       metaamount: json['metaAmount'],
//       amountTotal: json['amountTotal'],
//     );
//   }

//   static List<Estadist1Model> listFromJson(String jsonString) {
//     final parsed = jsonDecode(jsonString)['car'].cast<Map<String, dynamic>>();
//     return parsed
//         .map<Estadist1Model>((json) => Estadist1Model.fromJson(json))
//         .toList();
//   }
// }

import 'dart:convert';

class Estadist1Model {
  final int id;
  final String clientName;
  final String client_image;
  final String date;
  final String? time; // Make it nullable
  final String? servicesRealizated; // Make it nullable
  final String? choice; // Make it nullable
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
  final int? metacant;
  final int? metaamount;
  final int? amountTotal;
  final int? winPay;

  Estadist1Model({
    required this.id,
    required this.clientName,
    required this.client_image,
    required this.date,
    this.time,
    this.servicesRealizated,
    this.choice,
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
    this.metacant,
    this.metaamount,
    this.amountTotal,
    this.winPay,
  });

  factory Estadist1Model.fromJson(Map<String, dynamic> json) {
    return Estadist1Model(
      id: json['id'],
      clientName: json['clientName'],
      client_image: json['client_image'],
      date: json['date'], // Correct the typo here
      time: json['time'], // Make it nullable
      servicesRealizated: json['servicesRealizated'], // Make it nullable
      choice: json['choice'], // Make it nullable
      tips: json['tips'],
      tips80: json['tips80'],
      Services: json['Services'],
      totalServices: json['totalServices'],
      Products: json['Products'],
      totalProducts: json['totalProducts'],
      serviceSpecial: json['serviceSpecial'],
      SpecialAmount: json['SpecialAmount'],
      serviceRegular: json['serviceRegular'],
      pay: json['pay'],
      totalRetention: json['totalRetention'],
      totalGeneral: json['totalGeneral'],
      amountGenerate: json['amountGenerate'],
      metacant: json['metaCant'],
      metaamount: json['metaAmount'],
      amountTotal: json['amountTotal'],
      winPay: json['winPay'],
    );
  }

  static List<Estadist1Model> listFromJson(String jsonString) {
    final parsed = jsonDecode(jsonString)['car'].cast<Map<String, dynamic>>();
    return parsed
        .map<Estadist1Model>((json) => Estadist1Model.fromJson(json))
        .toList();
  }
}
