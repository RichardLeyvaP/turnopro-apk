// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Models/Estadist0_model.dart';
import 'package:turnopro_apk/Models/Estadist1_model.dart';
import 'package:turnopro_apk/Models/Payment_model.dart';
import 'package:turnopro_apk/Models/branch_model.dart';
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
    // todo esta es la que carga a los profesionales y a los tecnicos
    final LoginController controllerLogin = Get.find<LoginController>();
    List<ProfessionalModel> professionalList = [];
    print('estoy en getBranchProfessionals');
    try {
      var url = '${Env.apiEndpoint}/branch_professionals?branch_id=$idBranch';

      final response = await get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        print(
            'ESTOY ENTRANDO AQUI A CONVIVENCIAS estoy en professionals:$professionals');
        for (int i = 0; i < professionals.length; i++) {
          print('ESTOY ENTRANDO AQUI A CONVIVENCIAS  para el objeto ${i + 1}:');
          professionals[i].forEach((key, value) {
            print(
                'ESTOY ENTRANDO AQUI A CONVIVENCIAS  es estaa $key: ${value.runtimeType}');
            print('********************i:$i');
          });
        }
        print(professionals);
        for (Map professional in professionals) {
          print('ESTOY ENTRANDO AQUI A CONVIVENCIAS MAP()');
          ProfessionalModel u =
              ProfessionalModel.fromJson(jsonEncode(professional));
          //AQUI SOLO COJO QUE NO SEAN RESPONSABLES
          //todo cambiar por el nombre del cargo YASMANY TIENE QUE MANDARLO
          if ((u.charge_id == 'Barbero' ||
                  u.charge_id == 'Tecnico' ||
                  u.charge_id == 'Barbero y Encargado') &&
              (u.id != controllerLogin.idProfessionalLoggedIn)) {
            //charge_id=1 es un BARBERO
            //charge_id=7 es un TECNICO
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

//
//
  Future<List<Estadist1Model>> fetchEstadist1(
      professional_id, branch_id, data) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    List<Estadist1Model> branchProf = [];
    print('werya tengo repositorio11 estoy en getBranchProfessionals');
    try {
      var url =
          '${Env.apiEndpoint}/professional-car-date?branch_id=$branch_id&professional_id=$professional_id&data=$data';

      final response = await get(url).timeout(Duration(seconds: 10));
      print('werya tengo repositorio22 estoy en getBranchProfessionals');
      if (response.statusCode == 200) {
        print(
            'werya tengo repositorio33 response.statusCode == 200 estoy en getBranchProfessionals');
        // Parsear el body como una cadena JSON
        final jsonResponse = response.body['car'];
        print(
            'werya tengo repositorio----------------33 response.statusCode == 200 estoy en getBranchProfessionals');

        final List<dynamic> branchP = jsonResponse;

        for (int i = 0; i < branchP.length; i++) {
          final Map<String, dynamic> branch = branchP[i];

          // Crear una instancia de Estadist1Model
          Estadist1Model u = Estadist1Model.fromJson(branch);

          // Agregar la instancia a la lista branchProf
          branchProf.add(u);
        }

        print(
            'werya tengo repositorio44 response.statusCode == 200 estoy en branchProf:${branchProf.length}');
        return branchProf;
      } else {
        return branchProf;
        // Si ocurre algún error con la solicitud HTTP
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('werya tengo Error1 :$e');
      return branchProf;
    }
  }

//
  ///
//
//
  Future<List<PaymentModel>> fetchEstadistPagos(
      professional_id, branch_id) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    List<PaymentModel> branchProf = [];
    /* String jsonExample = '''
    [
      {
        "id": 2,
        "branch_id": 15,
        "professional_id": 67,
        "date": "2024-04-10 05:03:37",
        "type": "Quincena",
        "amount": "50634.09"
      },
      {
        "id": 3,
        "branch_id": 15,
        "professional_id": 68,
        "date": "2024-04-11 09:15:22",
        "type": "Quincena",
        "amount": "60000.0"
      },
      {
        "id": 4,
        "branch_id": 16,
        "professional_id": 70,
        "date": "2024-04-12 14:30:45",
        "type": "Mensual",
        "amount": "75000.0"
      },
      {
        "id": 5,
        "branch_id": 17,
        "professional_id": 71,
        "date": "2024-04-13 11:20:10",
        "type": "Quincena",
        "amount": "45000.0"
      },
      {
        "id": 6,
        "branch_id": 18,
        "professional_id": 72,
        "date": "2024-04-14 16:45:55",
        "type": "Mensual",
        "amount": "80000.0"
      },
      {
        "id": 7,
        "branch_id": 19,
        "professional_id": 73,
        "date": "2024-04-15 08:00:30",
        "type": "Quincena",
        "amount": "55000.0"
      },
      {
        "id": 8,
        "branch_id": 20,
        "professional_id": 75,
        "date": "2024-04-16 10:10:15",
        "type": "Mensual",
        "amount": "70000.0"
      },
      {
        "id": 9,
        "branch_id": 21,
        "professional_id": 77,
        "date": "2024-04-17 13:55:20",
        "type": "Quincena",
        "amount": "48000.0"
      },
      {
        "id": 10,
        "branch_id": 22,
        "professional_id": 78,
        "date": "2024-04-18 17:25:40",
        "type": "Mensual",
        "amount": "85000.0"
      },
      {
        "id": 11,
        "branch_id": 23,
        "professional_id": 80,
        "date": "2024-04-19 12:40:18",
        "type": "Quincena",
        "amount": "60000.0"
      },
      {
        "id": 12,
        "branch_id": 24,
        "professional_id": 81,
        "date": "2024-04-20 09:30:55",
        "type": "Mensual",
        "amount": "72000.0"
      }
    ]
  ''';

    List<PaymentModel> branchProfTest = PaymentModel.listFromJson(jsonExample);
    print('werya tengo repositorio11 estoy en getBranchProfessionals');
    return branchProfTest;*/
    try {
      var url =
          '${Env.apiEndpoint}/professional-payment-show?branch_id=$branch_id&professional_id=$professional_id';

      final response = await get(url).timeout(Duration(seconds: 10));
      print('werya tengo repositorio22 estoy en getBranchProfessionals');
      if (response.statusCode == 200) {
        print(
            'werya tengo repositorio33 response.statusCode == 200 estoy en getBranchProfessionals');
        // Parsear el body como una cadena JSON
        final jsonResponse = response.body;
        print(
            'werya tengo repositorio----------------33 response.statusCode == 200 estoy en getBranchProfessionals');

        final List<dynamic> branchP = jsonResponse;

        for (int i = 0; i < branchP.length; i++) {
          final Map<String, dynamic> branch = branchP[i];

          // Crear una instancia de Estadist1Model
          PaymentModel u = PaymentModel.fromJson(branch);

          // Agregar la instancia a la lista branchProf
          branchProf.add(u);
        }

        print(
            'werya tengo repositorio44 response.statusCode == 200 estoy en branchProf:${branchProf.length}');
        return branchProf;
      } else {
        return branchProf;
        // Si ocurre algún error con la solicitud HTTP
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('werya tengo Error2 :$e');
      return branchProf;
    }
  }

//
////
//
  Future<List<Estadist0Model>> fetchEstadist0(
      professional_id, branch_id) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    List<Estadist0Model> branchProf = [];
    print('werya tengo repositorio11 estoy en getBranchProfessionals');
    try {
      var url =
          '${Env.apiEndpoint}/professional-car?branch_id=$branch_id&professional_id=$professional_id';

      final response = await get(url).timeout(Duration(seconds: 10));
      print('werya tengo repositorio22 estoy en getBranchProfessionals');
      if (response.statusCode == 200) {
        print(
            'werya tengo repositorio33 response.statusCode == 200 estoy en getBranchProfessionals');
        // Parsear el body como una cadena JSON
        final jsonResponse = response.body['car'];
        print(
            'werya tengo repositorio----------------33 response.statusCode == 200 estoy en getBranchProfessionals');

        final List<dynamic> branchP = jsonResponse;

        for (int i = 0; i < branchP.length; i++) {
          final Map<String, dynamic> branch = branchP[i];

          // Crear una instancia de Estadist1Model
          Estadist0Model u = Estadist0Model.fromJson(branch);

          // Agregar la instancia a la lista branchProf
          branchProf.add(u);
        }

        print(
            'werya tengo repositorio44 response.statusCode == 200 estoy en branchProf:${branchProf.length}');
        return branchProf;
      } else {
        return branchProf;
        // Si ocurre algún error con la solicitud HTTP
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('werya tengo Error3 :$e');
      return branchProf;
    }
  }

//
//
  Future<List<BranchModel>> getBranchProfessionals2(email, password) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    List<BranchModel> branchProf = [];
    print('estoy en getBranchProfessionals');
    try {
      var url =
          '${Env.apiEndpoint}/login-phone-get-branch?email=$email&password=$password';

      final response = await get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final barnchP = response.body['branches'];
        for (int i = 0; i < barnchP.length; i++) {
          print(
              'ya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
          barnchP[i].forEach((key, value) {
            print(
                'ya tengo la cola de la api es estaa $key: ${value.runtimeType}');
            print('********************i:$i');
          });
        }
        print(barnchP);
        for (Map branch in barnchP) {
          BranchModel u = BranchModel.fromJson(jsonEncode(branch));

          branchProf.add(u);
        }
        print('*************coexistenceList.length*************');
        print(branchProf.length);
        return branchProf;
      } else {
        return branchProf;
      }
    } catch (e) {
      print('Error:$e');
      return branchProf;
    }
  }
//
//
}
