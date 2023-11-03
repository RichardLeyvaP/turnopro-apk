// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/env.dart';

class CoexistenceRepository extends GetConnect {
  Future<List<CoexistenceModel>> getCoexistenceList() async {
    List<CoexistenceModel> coexistenceList = [];
    try {
      var url = '${Env.apiEndpoint}/rule';

      final response = await get(url);
      if (response.statusCode == 200) {
        final coexistences = response.body['rules'];
        for (Map coexistence in coexistences) {
          CoexistenceModel u =
              CoexistenceModel.fromJson(jsonEncode(coexistence));
          coexistenceList.add(u);
        }
        return coexistenceList;
      } else {
        return coexistenceList;
      }
    } catch (e) {
      print('Error:$e');
      return coexistenceList;
    }
  }
}
