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
      date: json['date'],
      time: json['time'],
      servicesRealizated: json['servicesRealizated'],
      choice: json['choice'],
      tips: (json['tips'] is int)
          ? json['tips']
          : (json['tips'] as double?)?.toInt(),
      tips80: (json['tips80'] is int)
          ? json['tips80']
          : (json['tips80'] as double?)?.toInt(),
      Services: json['Services'],
      totalServices: (json['totalServices'] is int)
          ? json['totalServices']
          : (json['totalServices'] as double?)?.toInt(),
      Products: json['Products'],
      totalProducts: (json['totalProducts'] is int)
          ? json['totalProducts']
          : (json['totalProducts'] as double?)?.toInt(),
      serviceSpecial: json['serviceSpecial'],
      SpecialAmount: (json['SpecialAmount'] is int)
          ? json['SpecialAmount']
          : (json['SpecialAmount'] as double?)?.toInt(),
      serviceRegular: json['serviceRegular'],
      pay: json['pay'],
      totalRetention: (json['totalRetention'] is int)
          ? json['totalRetention']
          : (json['totalRetention'] as double?)?.toInt(),
      totalGeneral: (json['totalGeneral'] is int)
          ? json['totalGeneral']
          : (json['totalGeneral'] as double?)?.toInt(),
      amountGenerate: (json['amountGenerate'] is int)
          ? json['amountGenerate']
          : (json['amountGenerate'] as double?)?.toInt(),
      metacant: json['metaCant'],
      metaamount: (json['metaAmount'] is int)
          ? json['metaAmount']
          : (json['metaAmount'] as double?)?.toInt(),
      amountTotal: json['amountTotal'],
      winPay: (json['winPay'] is int)
          ? json['winPay']
          : (json['winPay'] as double?)?.toInt(),
    );
  }

  static List<Estadist1Model> listFromJson(String jsonString) {
    final parsed = jsonDecode(jsonString)['car'].cast<Map<String, dynamic>>();
    return parsed
        .map<Estadist1Model>((json) => Estadist1Model.fromJson(json))
        .toList();
  }
}
