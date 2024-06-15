import 'dart:convert';

class Estadist1Model {
  final int id;
  final String clientName;
  final String client_image;
  final String date;
  final String? time; // Make it nullable
  final String? servicesRealizated; // Make it nullable
  final String? choice; // Make it nullable
  final String? tips;
  final String? tips80;
  final int? Services;
  final String? totalServices;
  final int? Products;
  final int? totalProducts;
  final int? serviceSpecial;
  final String? SpecialAmount;
  final int? serviceRegular;
  final int? pay;
  final String? totalRetention;
  final int? totalGeneral;
  final int? amountGenerate;
  final int? metacant;
  final int? metaamount;
  final String? amountTotal;
  final String? winPay;

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
      tips: json['tips'],
      tips80: json['tips80'],
      Services: json['Services'],
      totalServices: json['totalServices'],
      Products: json['Products'],
      totalProducts: (json['totalProducts'] is int)
          ? json['totalProducts']
          : (json['totalProducts'] as double?)?.toInt(),
      serviceSpecial: json['serviceSpecial'],
      SpecialAmount: json['SpecialAmount'],
      serviceRegular: json['serviceRegular'],
      pay: json['pay'],
      totalRetention: json['totalRetention'],
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
