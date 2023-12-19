// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class CoexistenceModel {
  String name;
  String description;
  String type;
  int state;

  CoexistenceModel({
    required this.name,
    required this.description,
    required this.state,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'state': state,
      'type': type,
    };
  }

  factory CoexistenceModel.fromMap(Map<String, dynamic> map) {
    return CoexistenceModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      state: map['state'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CoexistenceModel.fromJson(String source) =>
      CoexistenceModel.fromMap(json.decode(source));
}
