// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ProductModel {
  int id;
  String name;
  String code;
  String description;
  String status_product;
  String purchase_price;
  String sale_price;
  String created_at;
  String updated_at;

  ProductModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.status_product,
    required this.purchase_price,
    required this.sale_price,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'status_product': status_product,
      'purchase_price': purchase_price,
      'sale_price': sale_price,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      status_product: map['status_product'] ?? '',
      purchase_price: map['purchase_price'] ?? '',
      sale_price: map['sale_price'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
