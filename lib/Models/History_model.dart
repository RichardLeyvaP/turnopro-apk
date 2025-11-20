import 'dart:convert';


import 'ServiceHistory_model.dart';

class HistoryModel {
  final String clientName;
  final String professionalName;
  final String branchName;
  final String image_data;
  final String image_url;
  final String imageLook;
  final int cantVisit;
  final String endLook;
  final String lastDate;
  final String frecuencia;
  final List<ServiceHistoryModel> services;
  final int cantMaxService;

  HistoryModel({
    required this.clientName,
    required this.professionalName,
    required this.branchName,
    required this.image_data,
    required this.image_url,
    required this.imageLook,
    required this.cantVisit,
    required this.endLook,
    required this.lastDate,
    required this.frecuencia,
    required this.services,
    required this.cantMaxService,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      clientName: map['clientName'] ?? '',
      professionalName: map['professionalName'] ?? '',
      branchName: map['branchName'] ?? '',
      image_data: map['image_data'] ?? '',
      image_url: map['image_url'] ?? '',
      imageLook: map['imageLook'] ?? '',
      cantVisit: map['cantVisit'] ?? 0,
      endLook: map['endLook'] ?? '',
      lastDate: map['lastDate'] ?? '',
      frecuencia: map['frecuencia'] ?? '',
      services: List<ServiceHistoryModel>.from(
        (map['services'] ?? []).map((x) => ServiceHistoryModel.fromMap(x)),
      ),
      cantMaxService: map['cantMaxService'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'professionalName': professionalName,
      'branchName': branchName,
      'image_data': image_data,
      'image_url': image_url,
      'imageLook': imageLook,
      'cantVisit': cantVisit,
      'endLook': endLook,
      'lastDate': lastDate,
      'frecuencia': frecuencia,
      'services': services.map((x) => x.toMap()).toList(),
      'cantMaxService': cantMaxService,
    };
  }
}
