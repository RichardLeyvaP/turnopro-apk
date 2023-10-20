// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class CoexistenceModel {
  int id;
  String name;
  String description;
  String created_at;
  String updated_at;

  CoexistenceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory CoexistenceModel.fromMap(Map<String, dynamic> map) {
    return CoexistenceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CoexistenceModel.fromJson(String source) =>
      CoexistenceModel.fromMap(json.decode(source));
}
