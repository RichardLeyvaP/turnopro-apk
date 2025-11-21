// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';


class OrderDeleteModel {
  int id;
  int profesional_id;
  int reservation_id;
  String nameClient;
  String nameProfesional;
  String hora;
  String? nameProduct;
  String? nameService;
  int? duration_service;
  String updated_at;
  int is_product;

  OrderDeleteModel({
    required this.id,
    required this.profesional_id,
    required this.reservation_id,
    required this.nameClient,
    required this.nameProfesional,
    required this.hora,
    this.nameProduct,
    this.nameService,
    this.duration_service,
    required this.updated_at,
    required this.is_product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profesional_id': profesional_id,
      'reservation_id': reservation_id,
      'nombreClients': nameClient,
      'surname': nameProfesional,
      'hora': hora,
      'nameProduct': nameProduct,
      'nameService': nameService,
      'duration_service': duration_service,
      'updated_at': updated_at,
      'is_product': is_product,
    };
  }

  factory OrderDeleteModel.fromMap(Map<String, dynamic> map) {
    return OrderDeleteModel(
      id: map['id'] ?? 0,
      profesional_id: map['profesional_id'] ?? 0,
      reservation_id: map['reservation_id'] ?? 0,
      nameClient: map['nameClient'] ?? '',
      nameProfesional: map['nameProfesional'] ?? '',
      hora: map['hora'] ?? '',
      nameProduct: map['nameProduct'],
      nameService: map['nameService'] ?? '',
      duration_service: map['duration_service'] ?? 0,
      updated_at: map['updated_at'] ?? '',
      is_product: map['is_product'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDeleteModel.fromJson(String source) =>
      OrderDeleteModel.fromMap(json.decode(source));
}
