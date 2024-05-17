// ignore_for_file: non_constant_identifier_names
//ultimo cambio agregue professional_name
import 'dart:convert';

class ClientsScheduledModel {
  int? reservation_id;
  int? idBarber;
  int? car_id;
  String? start_time;
  String? nameBarber;
  String? final_hour;
  String? total_time;
  String? client_name;
  String? client_image;
  int? client_id;
  int? attended;
  String? updated_at;
  String? professional_name;
  int? professional_id;
  int total_services;
  int? clock;
  int? timeClock;
  int? detached;
  String? time;
  String? charge;

  ClientsScheduledModel({
    this.reservation_id,
    this.idBarber,
    this.car_id,
    this.start_time,
    this.nameBarber,
    this.final_hour,
    this.total_time,
    this.client_name,
    this.client_image,
    this.client_id,
    this.attended,
    this.updated_at,
    this.professional_name,
    this.professional_id,
    required this.total_services,
    this.clock,
    this.timeClock,
    this.detached,
    this.time,
    this.charge,
  });

  Map<String, dynamic> toMap() {
    return {
      'reservation_id': reservation_id,
      'idBarber': idBarber,
      'car_id': car_id,
      'start_time': start_time,
      'final_hour': final_hour,
      'total_time': total_time,
      'client_name': client_name,
      'nameBarber': nameBarber,
      'client_image': client_image,
      'client_id': client_id,
      'attended': attended,
      'updated_at': updated_at,
      'professional_name': professional_name,
      'professional_id': professional_id,
      'clock': clock,
      'timeClock': timeClock,
      'detached': detached,
      'time': time,
      'charge': charge,
    };
  }

  factory ClientsScheduledModel.fromMap(Map<String, dynamic> map) {
    return ClientsScheduledModel(
      reservation_id: map['reservation_id'],
      idBarber: map['idBarber'],
      car_id: map['car_id'],
      start_time: map['start_time'],
      final_hour: map['final_hour'],
      total_time: map['total_time'],
      client_name: map['client_name'],
      nameBarber: map['nameBarber'],
      client_image: map['client_image'] ?? '',
      client_id: map['client_id'],
      attended: map['attended'] ?? 0,
      updated_at: map['updated_at'],
      professional_name:
          map['professional_name'] ?? '', // Manejar nulo con cadena vacía
      professional_id: map['professional_id'] ?? 0,
      total_services: map['total_services'] ?? 0,
      clock: map['clock'] ?? 0,
      timeClock: map['timeClock'] ?? 0,
      detached: map['detached'] ?? 0,
      time: map['time'] ?? '',
      charge: map['charge'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientsScheduledModel.fromJson(String source) =>
      ClientsScheduledModel.fromMap(json.decode(source));
}
