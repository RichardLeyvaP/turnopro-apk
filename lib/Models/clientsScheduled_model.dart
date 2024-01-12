// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

class ClientsScheduledModel {
  int reservation_id;
  int car_id;
  String start_time;
  String final_hour;
  String total_time;
  String client_name;
  int client_id;
  int attended;
  DateTime updated_at;
  int total_services;
  int? clock;
  int? timeClock;
  bool? detached;

  ClientsScheduledModel({
    required this.reservation_id,
    required this.car_id,
    required this.start_time,
    required this.final_hour,
    required this.total_time,
    required this.client_name,
    required this.client_id,
    required this.attended,
    required this.updated_at,
    required this.total_services,
    this.clock,
    this.timeClock,
    this.detached,
  });

  Map<String, dynamic> toMap() {
    return {
      'reservation_id': reservation_id,
      'car_id': car_id,
      'start_time': start_time,
      'final_hour': final_hour,
      'total_time': total_time,
      'client_name': client_name,
      'client_id': client_id,
      'attended': attended,
      'updated_at': updated_at,
      'clock': clock,
      'timeClock': timeClock,
      'detached': detached,
    };
  }

  factory ClientsScheduledModel.fromMap(Map<String, dynamic> map) {
    return ClientsScheduledModel(
      reservation_id: map['reservation_id'],
      car_id: map['car_id'],
      start_time: map['start_time'],
      final_hour: map['final_hour'],
      total_time: map['total_time'],
      client_name: map['client_name'],
      client_id: map['client_id'],
      attended: map['attended'] ?? 0,
      updated_at: map['updated_at'],
      total_services: map['total_services'] ?? 0,
      clock: map['clock'] ?? 0,
      timeClock: map['timeClock'] ?? 0,
      detached: map['detached'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientsScheduledModel.fromJson(String source) =>
      ClientsScheduledModel.fromMap(json.decode(source));
}
