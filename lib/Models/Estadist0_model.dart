import 'dart:convert';

class Estadist0Model {
  final int professionalId;
  final String branchId;
  final String data;
  final int attendedClient;
  final int services;
  final int totalServices;
  final String clientAleator;
  final int amountGenerate;
  final int totalServicesRetention;

  Estadist0Model({
    required this.professionalId,
    required this.branchId,
    required this.data,
    required this.attendedClient,
    required this.services,
    required this.totalServices,
    required this.clientAleator,
    required this.amountGenerate,
    required this.totalServicesRetention,
  });

  factory Estadist0Model.fromJson(Map<String, dynamic> json) {
    return Estadist0Model(
      professionalId: json['professional_id'],
      branchId: json['branch_id'],
      data: json['data'],
      attendedClient: json['attendedClient'],
      services: json['services'],
      totalServices: json['totalServices'],
      clientAleator: json['clientAleator'],
      amountGenerate: json['amountGenerate'],
      totalServicesRetention: json['totalServicesRetention'],
    );
  }

  static List<Estadist0Model> listFromJson(String jsonString) {
    final parsed = jsonDecode(jsonString)['car'].cast<Map<String, dynamic>>();
    return parsed
        .map<Estadist0Model>((json) => Estadist0Model.fromJson(json))
        .toList();
  }
}
