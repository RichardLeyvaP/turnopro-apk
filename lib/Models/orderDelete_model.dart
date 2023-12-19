// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

//todo REVISAR aqui datos estaticos en el modelo, los valores enteros YAYAAAAA
class OrderDeleteModel {
  int id;
  String nameClient;
  String nameProfesional;
  String hora;
  String? nameProduct;
  String? nameService;
  String updated_at;
  int is_product;

  OrderDeleteModel({
    required this.id,
    required this.nameClient,
    required this.nameProfesional,
    required this.hora,
    this.nameProduct,
    this.nameService,
    required this.updated_at,
    required this.is_product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreClients': nameClient,
      'surname': nameProfesional,
      'hora': hora,
      'nameProduct': nameProduct,
      'nameService': nameService,
      'updated_at': updated_at,
      'is_product': is_product,
    };
  }

  factory OrderDeleteModel.fromMap(Map<String, dynamic> map) {
    return OrderDeleteModel(
      id: map['id'] ?? 0,
      nameClient: map['nameClient'] ?? '',
      nameProfesional: map['nameProfesional'] ?? '',
      hora: map['hora'] ?? '',
      nameProduct: map['nameProduct'] ?? '',
      nameService: map['nameService'] ?? '',
      updated_at: map['updated_at'] ?? '',
      is_product: map['is_product'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDeleteModel.fromJson(String source) =>
      OrderDeleteModel.fromMap(json.decode(source));
}
