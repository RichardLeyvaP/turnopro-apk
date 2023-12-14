// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/env.dart';

class CoexistenceRepository extends GetConnect {
  Future<List<CoexistenceModel>> getCoexistenceList(
      idProfessional, idBranch) async {
    List<CoexistenceModel> coexistenceList = [];
    try {
      var url =
          '${Env.apiEndpoint}/rules_professional?professional_id=$idProfessional&branch_id=$idBranch';

      final response = await get(url);
      if (response.statusCode == 200) {
        final coexistences = response.body['rules'];
        print(coexistences);
        for (Map coexistence in coexistences) {
          CoexistenceModel u =
              CoexistenceModel.fromJson(jsonEncode(coexistence));
          coexistenceList.add(u);
        }
        print('*************coexistenceList.length*************');
        print(coexistenceList.length);
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
