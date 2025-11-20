import 'dart:convert';



class ServiceHistoryModel {
  final int id;
  final String name;
  final int simultaneou;
  final int price_service;
  final String type_service;
  final int profit_percentaje;
  final int duration_service;
  final String image_service;
  final String service_comment;
  final int cant;

  ServiceHistoryModel({
    required this.id,
    required this.name,
    required this.simultaneou,
    required this.price_service,
    required this.type_service,
    required this.profit_percentaje,
    required this.duration_service,
    required this.image_service,
    required this.service_comment,
    required this.cant,
  });

  factory ServiceHistoryModel.fromMap(Map<String, dynamic> map) {
    return ServiceHistoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      simultaneou: map['simultaneou'] ?? 0,
      price_service: map['price_service'] ?? 0,
      type_service: map['type_service'] ?? '',
      profit_percentaje: map['profit_percentaje'] ?? 0,
      duration_service: map['duration_service'] ?? 0,
      image_service: map['image_service'] ?? '',
      service_comment: map['service_comment'] ?? '',
      cant: map['cant'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
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
      'cant': cant,
    };
  }
}