// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class NotificationModel {
  int id;
  int professional_id;
  int branch_id;
  int state;
  String description;
  String tittle;
  String created_at;
  String updated_at;

  NotificationModel({
    required this.id,
    required this.professional_id,
    required this.branch_id,
    required this.state,
    required this.description,
    required this.tittle,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'professional_id': professional_id,
      'branch_id': branch_id,
      'state': state,
      'description': description,
      'tittle': tittle,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      professional_id: map['professional_id'] ?? -1,
      branch_id: map['branch_id'] ?? -1,
      state: map['state'] ?? -1,
      description: map['description'] ?? '',
      tittle: map['tittle'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
