// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ProfessionalModel {
  int id;
  String charge_id;
  int? user_id;
  int? state;
  String name;
  String? surname;
  String? second_surname;
  String? email;
  String? phone;
  String? image_url;
  String? position;

  ProfessionalModel({
    required this.id,
    required this.charge_id,
    this.user_id,
    this.state,
    required this.name,
    this.surname,
    this.second_surname,
    this.email,
    this.phone,
    this.image_url,
    this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'charge_id': charge_id,
      'user_id': user_id,
      'state': state,
      'name': name,
      'surname': surname,
      'second_surname': second_surname,
      'email': email,
      'phone': phone,
      'image_url': image_url,
      'position': position,
    };
  }

  factory ProfessionalModel.fromMap(Map<String, dynamic> map) {
    return ProfessionalModel(
      id: map['id'] ?? 0,
      charge_id: map['charge_id'] ?? '', // Asigna 0 si el valor es null
      user_id: _toInt(map['user_id']),
      state: _toInt(map['state']),
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      second_surname: map['second_surname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'].toString(),
      image_url: map['image_url'].toString(),
      position: map['position'].toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  String toJson() => json.encode(toMap());

  factory ProfessionalModel.fromJson(String source) =>
      ProfessionalModel.fromMap(json.decode(source));
}
