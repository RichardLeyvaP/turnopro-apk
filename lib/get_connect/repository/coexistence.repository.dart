// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';

class CoexistenceRepository extends GetConnect {
  Future<List<CoexistenceModel>> getCoexistenceList() async {
    List<CoexistenceModel> coexistenceList = [];
    var url =
        'http://10.0.2.2:8000/api/rule'; //cambiar aqui por servicios en la api   http://10.0.2.2:8000

    final response = await get(url);
    if (response.statusCode == 200) {
      final coexistences = response.body['rules'];
      for (Map coexistence in coexistences) {
        CoexistenceModel u = CoexistenceModel.fromJson(jsonEncode(coexistence));
        coexistenceList.add(u);
      }
      return coexistenceList;
    } else {
      return coexistenceList;
    }
  }
}
