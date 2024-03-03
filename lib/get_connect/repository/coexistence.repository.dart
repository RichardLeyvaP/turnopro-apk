// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/env.dart';

class CoexistenceRepository extends GetConnect {
  final ClientsScheduledController controllerClient =
      Get.find<ClientsScheduledController>();
  final ClientsTechnicalController controllerClientTecn =
      Get.find<ClientsTechnicalController>();
  final LoginController controllerLogin = Get.find<LoginController>();

  Future<List<CoexistenceModel>> getCoexistenceList(
      idProfessional, idBranch) async {
    print('actualizando las convivencias iniciales.RLP- getCoexistenceList');
    List<CoexistenceModel> coexistenceList = [];
    try {
      print('a15627 idProfessional:$idProfessional');
      var url =
          '${Env.apiEndpoint}/rules_professional?professional_id=$idProfessional&branch_id=$idBranch';
      print('a15627 siiiiiiii 0');
      final response = await get(url);
      if (response.statusCode == 200) {
        print('a15627 siiiiiiii 1');
        final coexistences = response.body['rules'];
        print(coexistences);
        for (Map coexistence in coexistences) {
          print('a15627 siiiiiiii 2');
          CoexistenceModel u =
              CoexistenceModel.fromJson(jsonEncode(coexistence));
          coexistenceList.add(u);
          if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
            print('a15627 siiiiiiii 3-1');
            controllerClientTecn.noncomplianceProfessional[u.type] = u.state;
          }
          if (controllerLogin.chargeUserLoggedIn == "Barbero") {
            print('a15627 siiiiiiii 3-2');
            controllerClient.noncomplianceProfessional[u.type] = u.state;
          }
          controllerClient.noncomplianceProfessional[u.type] = u.state;
          print('a15627 siiiiiiii 1');
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

  Future<List<ProfessionalModel>> getBranchProfessionals(idBranch) async {
    List<ProfessionalModel> professionalList = [];
    print('estoy en getBranchProfessionals');
    try {
      var url = '${Env.apiEndpoint}/branch_professionals?branch_id=$idBranch';

      final response = await get(url);
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        print(professionals);
        for (Map professional in professionals) {
          ProfessionalModel u =
              ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          if (u.charge_id != 3 && u.charge_id != 8) {
            //charge_id=3 es un responsable
            professionalList.add(u);
          }
        }
        print('*************coexistenceList.length*************');
        print(professionalList.length);
        return professionalList;
      } else {
        return professionalList;
      }
    } catch (e) {
      print('Error:$e');
      return professionalList;
    }
  }
}
