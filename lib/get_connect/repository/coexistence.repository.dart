// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';
import 'package:turnopro_apk/Models/Estadist0_model.dart';
import 'package:turnopro_apk/Models/Estadist1_model.dart';
import 'package:turnopro_apk/Models/Payment_model.dart';
import 'package:turnopro_apk/Models/branch_model.dart';
import 'package:turnopro_apk/Models/coexistence_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';
import 'package:http/http.dart' as http;

class CoexistenceRepository extends GetConnect {
  final ClientsScheduledController controllerClient = Get.find<ClientsScheduledController>();
  final ClientsTechnicalController controllerClientTecn = Get.find<ClientsTechnicalController>();
  final LoginController controllerLogin = Get.find<LoginController>();

  Future<List<CoexistenceModel>> getCoexistenceList(idProfessional, idBranch, token) async {
    print('actualizando las convivencias iniciales.RLP- getCoexistenceList');
    List<CoexistenceModel> coexistenceList = [];
    try {
      print('a15627 idProfessional:$idProfessional');
      var url = '${dotenv.env['API_ENDPOINT']}/rules_professional?professional_id=$idProfessional&branch_id=$idBranch';
      print('a15627 siiiiiiii 0');
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      if (response.statusCode == 200) {
        final coexistences = response.body['rules'];

        for (Map coexistence in coexistences) {
          CoexistenceModel u = CoexistenceModel.fromJson(jsonEncode(coexistence));
          coexistenceList.add(u);
          if (controllerLogin.chargeUserLoggedIn == "Tecnico") {
            controllerClientTecn.noncomplianceProfessional[u.id.toString()] = u.state;
          }
          if (controllerLogin.chargeUserLoggedIn == "Barbero") {
            controllerClient.noncomplianceProfessional[u.id.toString()] = u.state;
          }
          controllerClient.noncomplianceProfessional[u.id.toString()] = u.state;
        }

        return coexistenceList;
      } else if (response.statusCode != 200) {
        controllerLogin.showConnectionError();
        return coexistenceList;
      } else {
        return coexistenceList;
      }
    } catch (e) {
      print('Error:$e');
      return coexistenceList;
    }
  }

  final client = http.Client();

  Future getAnoStadist(idProfessional, idBranch, year, token) async {
    List<CoexistenceModel> coexistenceList = [];
    try {
      final url =
          '${dotenv.env['API_ENDPOINT']}/professional-win-year?professional_id=$idProfessional&branch_id=$idBranch&year=$year';
      print(
          'url de grafico:${dotenv.env['API_ENDPOINT']}/professional-win-year?professional_id=$idProfessional&branch_id=$idBranch&year=$year');

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('esta ruta dice:response.statusCode>${response.statusCode}');
      print('esta ruta dice:response.statusCode>${response.statusCode == 200}');
      print('esta ruta dice:response.statusCode>${response.body}');

      if (response.statusCode == 200) {
        // La respuesta fue exitosa

        final Map<String, dynamic> responseBody = response.body;
        final stadist = responseBody['monthlyEarnings'];
        final stadistVar = responseBody;

        print('resultadosssssss stadist-ENERO:${stadist['abril']}');
        print('resultadosssssss stadist:$stadist');

        print('resultadosssssss 2 -> ${stadistVar['averageEarnings']}');
        print('resultadosssssss 3 -> ${stadistVar['totalEarnings']}');

        return {
          'stadist': stadist,
          'averageEarnings': stadistVar['averageEarnings'],
          'totalEarnings': stadistVar['totalEarnings']
        };
      } else {
        return {};
      }
    } catch (e) {
      print('Error:$e');
      return {};
    }
  }

  Future<List<ProfessionalModel>> getBranchProfessionals(idBranch) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    final LoginController controllerLogin = Get.find<LoginController>();
    List<ProfessionalModel> professionalList = [];

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/branch_professionals?branch_id=$idBranch';
      String token = controllerLogin.tokenUserLoggedIn;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final professionals = response.body['professionals'];
        print(' ENTRANDO A CONVIVENCIAS  en professionals:$professionals');
        for (int i = 0; i < professionals.length; i++) {
          print(' ENTRANDO A CONVIVENCIAS  para el objeto ${i + 1}:');
          professionals[i].forEach((key, value) {
            print(' ENTRANDO A CONVIVENCIAS  es estaa $key: ${value.runtimeType}');

          });
        }
        print(professionals);
        for (Map professional in professionals) {
          print('ENTRANDO A CONVIVENCIAS MAP()');
          ProfessionalModel u = ProfessionalModel.fromJson(jsonEncode(professional));
          // SOLO QUE NO SEAN RESPONSABLES
          // cambiar por el nombre del cargo
          if (loginController.chargeUserLoggedIn == "Coordinador") {
            //puede modificar las reglas de todos
            if (u.charge_id == 'Barbero' ||
                u.charge_id == 'Tecnico' ||
                u.charge_id == 'Barbero y Encargado' ||
                u.charge_id == 'Encargado') {
              professionalList.add(u);
            }
          } else if (u.charge_id == 'Barbero' || u.charge_id == 'Tecnico') {
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

  Future<List<Estadist1Model>> fetchEstadist1(professional_id, branch_id, data, charge) async {
    //  esta es la que carga a los profesionales y a los tecnicos
    List<Estadist1Model> branchProf = [];

    try {
      var url =
          '${dotenv.env['API_ENDPOINT']}/professional-car-date?branch_id=$branch_id&professional_id=$professional_id&data=$data';
      if (charge == 'Tecnico') {
        url = '${dotenv.env['API_ENDPOINT']}/tecnico-car-date?branch_id=$branch_id&professional_id=$professional_id&data=$data';

      }

      String token = controllerLogin.tokenUserLoggedIn;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));
      print(' getBranchProfessionals url:$url');
      if (response.statusCode == 200) {

        // Parsear el body como una cadena JSON
        final jsonResponse = response.body['car'];
        for (int i = 0; i < jsonResponse.length; i++) {
          jsonResponse[i].forEach((key, value) {});
        }

        final List<dynamic> branchP = jsonResponse;

        for (int i = 0; i < branchP.length; i++) {
          final Map<String, dynamic> branch = branchP[i];

          // Crear una instancia de Estadist1Model
          Estadist1Model u = Estadist1Model.fromJson(branch);

          // Agregar la instancia a la lista branchProf
          branchProf.add(u);
        }


        return branchProf;
      } else {
        return branchProf;

      }
    } catch (e) {
      print(' Error1 :$e');
      return branchProf;
    }
  }



//METODO NUEVO CON 3 REINTENTOS
  int parseToInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      throw Exception('Invalid type for int conversion');
    }
  }

  Future<Map<String, dynamic>> fetchEstadistPagos(professional_id, branch_id, charge) async {
    List<PaymentModel> branchProf = [];
    int attempts = 0;


    try {
      var url =
          '${dotenv.env['API_ENDPOINT']}/professional-payment-show-apk?branch_id=$branch_id&professional_id=$professional_id&charge=$charge';
      String token = controllerLogin.tokenUserLoggedIn;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        attempts = 10;

        // Parsear el body como una cadena JSON
        // Obtén el cuerpo (body) como una cadena (String)

        final jsonResponse = response.body;



// Ejemplo: acceder a los pagos
        final List<dynamic> payments = response.body['payments'];

        final String pendiente = jsonResponse['pendiente'];
        final String pagado = jsonResponse['pagado'];
        final int clientAtended = parseToInt(jsonResponse['clientAtended']);
        final int servCant = parseToInt(jsonResponse['servCant']);
        final String amountGenerate = jsonResponse['amountGenerate'];
        final String propina80 = jsonResponse['propina80'];
        final int metaCant = parseToInt(jsonResponse['metaCant']);
        final String metaAmount = jsonResponse['metaAmount'];
        final String retention = jsonResponse['retention'];
        final String winnerRetention = jsonResponse['winnerRetention'];
        final String winnerAmount = jsonResponse['winnerAmount'];
        final String productCant = jsonResponse['productCant'];
        final String productAmount = jsonResponse['productAmount'];
        final int productBonoCant = parseToInt(jsonResponse['productBonoCant']);
        final String servAmount = jsonResponse['servAmount'];
        final int servBonoCant = parseToInt(jsonResponse['servBonoCant']);
        double sum_pyment = 0;
        for (int i = 0; i < payments.length; i++) {
          final Map<String, dynamic> branch = payments[i];


          // Crear una instancia de Estadist1Model
          PaymentModel u = PaymentModel.fromJson(branch);
          sum_pyment += u.amount;

          branchProf.add(u);

        }


        return {
          'branchProf': branchProf,
          'pendiente': pendiente,
          'pagado': sum_pyment,
          'clientAtended': clientAtended,
          'servCant': servCant,
          'amountGenerate': amountGenerate,
          'propina80': propina80,
          'metaCant': metaCant,
          'metaAmount': metaAmount,
          'retention': retention,
          'winnerRetention': winnerRetention,
          'winnerAmount': winnerAmount,
          'productCant': productCant,
          'productAmount': productAmount,
          'servAmount': servAmount,
          'productBonoCant': productBonoCant,
          'servBonoCant': servBonoCant,
          'retries': false, //es que td esta bien
        };
      } else {
        return {
          'branchProf': branchProf,
          'pendiente': '0',
          'pagado': '0',
          'clientAtended': '0',
          'servCant': '0',
          'amountGenerate': '0',
          'propina80': '0',
          'metaCant': '0',
          'metaAmount': '0',
          'retention': '0',
          'winnerRetention': '0',
          'winnerAmount': '0',
          'productCant': '0',
          'productAmount': '0',
          'servAmount': '0',
          'productBonoCant': '0',
          'servBonoCant': '0',
          'retries': true, //es que td esta bien
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'branchProf': branchProf,
        'pendiente': '0',
        'pagado': '0',
        'clientAtended': '0',
        'servCant': '0',
        'amountGenerate': '0',
        'propina80': '0',
        'metaCant': '0',
        'metaAmount': '0',
        'retention': '0',
        'winnerRetention': '0',
        'winnerAmount': '0',
        'productCant': '0',
        'productAmount': '0',
        'servAmount': '0',
        'productBonoCant': '0',
        'servBonoCant': '0',
        'retries': true, //es que td esta bien
      };
    }
  }


  Future<List<Estadist0Model>> fetchEstadist0(professional_id, branch_id, charge) async {
    //  esta es la que carga a los profesionales y a los tecnicos
    List<Estadist0Model> branchProf = [];

    try {
      var url = '${dotenv.env['API_ENDPOINT']}/professional-car?branch_id=$branch_id&professional_id=$professional_id';
      if (charge == 'Tecnico') //tecnico
      {
        url = '${dotenv.env['API_ENDPOINT']}/tecnico-car?branch_id=$branch_id&professional_id=$professional_id';
      }

      String token = controllerLogin.tokenUserLoggedIn;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {

        // Parsear el body como una cadena JSON
        final jsonResponse = response.body['car'];
         final List<dynamic> branchP = jsonResponse;

        for (int i = 0; i < branchP.length; i++) {
          final Map<String, dynamic> branch = branchP[i];

          // Crear una instancia de Estadist1Model
          Estadist0Model u = Estadist0Model.fromJson(branch);

          // Agregar la instancia a la lista branchProf
          branchProf.add(u);
        }

        return branchProf;
      } else {
        return branchProf;

      }
    } catch (e) {
      print(' Error3 :$e');
      return branchProf;
    }
  }


  Future getBranchProfessionals2(email, password) async {
    //  esta es la que carga a los profesionales y a los tecnicos
    List<BranchModel> branchProf = [];


    try {

      var url = '${dotenv.env['API_ENDPOINT']}/login-phone-get-branch?email=$email&password=$password';
      print(url);
      String token = controllerLogin.tokenUserLoggedIn;
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(Duration(seconds: 15));
      print('ya tengo la cola de la api es response.statusCode : ${response.statusCode}');
      if (response.statusCode == null || response.statusCode != 200) {
        return null;
      } else if (response.statusCode == 200) {
        final barnchP = response.body['branches'];
        for (int i = 0; i < barnchP.length; i++) {

          barnchP[i].forEach((key, value) {

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

}
