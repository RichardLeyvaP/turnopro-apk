import 'dart:convert';

class Estadist0Model {
  final int professional_id;
  final int branch_id;
  final String data;
  final String day_of_week;
  final int? attendedClient;
  final int? services;
  final int? totalGeneral;
  final int? totalServices;
  final int? totalProducts;
  final int? tips;
  final int? tips80;
  final int? clientAleator;
  final int? amountGenerate;
  final int? totalRetention;
  final int? metacant;
  final int? metaamount; //duda si es entero o double

  Estadist0Model({
    required this.professional_id,
    required this.branch_id,
    required this.data,
    required this.day_of_week,
    this.attendedClient,
    this.services,
    this.totalGeneral,
    this.totalServices,
    this.totalProducts,
    this.tips,
    this.tips80,
    this.clientAleator,
    this.amountGenerate,
    this.totalRetention,
    this.metacant,
    this.metaamount,
  });

  factory Estadist0Model.fromJson(Map<String, dynamic> json) {
    return Estadist0Model(
      professional_id: json['professional_id'],
      branch_id: json['branch_id'],
      data: json['data'],
      day_of_week: json['day_of_week'],
      attendedClient: json['attendedClient'],
      services: json['services'],
      totalGeneral: json['totalGeneral'],
      totalServices: json['totalServices'],
      totalProducts: json['totalProducts'],
      tips: json['tips'],
      tips80: json['tips80'],
      clientAleator: json['clientAleator'],
      amountGenerate: json['amountGenerate'],
      totalRetention: json['totalRetention'],
      metacant: json['metaCant'],
      metaamount: json['metaAmount'],
    );
  }

  static List<Estadist0Model> listFromJson(String jsonString) {
    final parsed = jsonDecode(jsonString)['car'].cast<Map<String, dynamic>>();
    return parsed
        .map<Estadist0Model>((json) => Estadist0Model.fromJson(json))
        .toList();
  }
}
