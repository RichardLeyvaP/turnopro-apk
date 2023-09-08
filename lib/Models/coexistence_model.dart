import 'dart:convert';

class CoexistenceModel {
  int id;
  String name;
  String username;

  CoexistenceModel({
    required this.id,
    required this.name,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
    };
  }

  factory CoexistenceModel.fromMap(Map<String, dynamic> map) {
    return CoexistenceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CoexistenceModel.fromJson(String source) =>
      CoexistenceModel.fromMap(json.decode(source));
}
