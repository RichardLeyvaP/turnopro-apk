// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ProductModel {
  //todo REVISAR aqui los datos enteros estan estaticos
  int id;
  String name;
  String code;
  String description;
  int product_exit;
  String status_product;
  String purchase_price;
  String sale_price;
  String created_at;
  String updated_at;
  int? request_delete;
  int? is_product;

  ProductModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.product_exit,
    required this.status_product,
    required this.purchase_price,
    required this.sale_price,
    required this.created_at,
    required this.updated_at,
    this.request_delete,
    this.is_product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'product_exit': product_exit,
      'status_product': status_product,
      'purchase_price': purchase_price,
      'sale_price': sale_price,
      'created_at': created_at,
      'updated_at': updated_at,
      'request_delete': request_delete,
      'is_product': is_product,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      product_exit: 5,
      // product_exit: map['product_exit'] ?? 0,
      status_product: map['status_product'] ?? '',
      purchase_price: map['purchase_price'] ?? '',
      sale_price: map['sale_price'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
      request_delete: 0,
      is_product: 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
