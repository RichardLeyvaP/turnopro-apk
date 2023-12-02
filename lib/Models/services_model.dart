// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
//todo REVISAR -Revisado y arreglado

class ServiceModel {
  int id;
  String name;
  int simultaneou;
  double price_service;
  String type_service;
  double profit_percentaje;
  int duration_service;
  String image_service;
  String service_comment;
  String? nameService;
  int? request_delete;
  int? is_product;

  ServiceModel({
    required this.id,
    required this.name,
    required this.simultaneou,
    required this.price_service,
    required this.type_service,
    required this.profit_percentaje,
    required this.duration_service,
    required this.image_service,
    required this.service_comment,
    this.nameService,
    this.request_delete,
    this.is_product,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'simultaneou': simultaneou,
      'price_service': price_service,
      'type_service': type_service,
      'profit_percentaje': profit_percentaje,
      'duration_service': duration_service,
      'image_service': image_service,
      'service_comment': service_comment,
      'nameService': nameService,
      'request_delete': request_delete,
      'is_product': is_product,
    };
  }

  factory ServiceModel.fromMap(Map<dynamic, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      simultaneou: map['simultaneou'] ?? 0,
      price_service: (map['price_service'] ?? 0.0).toDouble(),
      type_service: map['type_service'] ?? '',
      profit_percentaje: (map['profit_percentaje'] ?? 0.0).toDouble(),
      duration_service: map['duration_service'] ?? 0,
      image_service: map['image_service'] ?? '',
      service_comment: map['service_comment'] ?? '',
      nameService: map['nameService'] ?? '',
      request_delete: map['request_delete'] ?? 0,
      is_product: map['is_product'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) =>
      ServiceModel.fromMap(json.decode(source));
}
