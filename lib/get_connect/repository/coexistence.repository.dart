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
import 'package:http/http.dart' as http;

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

  final client = http.Client();
  //todo nuevaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  Future getAnoStadist(idProfessional, idBranch, year) async {
    List<CoexistenceModel> coexistenceList = [];
    try {
      final response = await client.get(Uri.parse(
          '${Env.apiEndpoint}/professional-win-year?professional_id=$idProfessional&branch_id=$idBranch&year=$year'));
      // var url =
      //     '${Env.apiEndpoint}/professional-win-year?professional_id=$idProfessional&branch_id=$idBranch&year=$year';
      //  print('url de grafico:$url');

      // final response = await get(url);
      if (response.statusCode == 200) {
        // La respuesta fue exitosa
        final Map<String, dynamic> responseBody = json.decode(response.body);
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
          if (u.charge_id == 'Barbero' || u.charge_id == 'Tecnico') {
            //charge_id=1 es un BARBERO
            //charge_id=7 es un TECNICO
            professionalList.add(u);
          }
          //asi esra como estaba antes pero me devolvia a los Barberos responsables
          //  if ((u.charge_id == 'Barbero' ||
          //         u.charge_id == 'Tecnico' ||
          //         u.charge_id == 'Barbero y Encargado') &&
          //     (u.id != controllerLogin.idProfessionalLoggedIn)) {
          //   //charge_id=1 es un BARBERO
          //   //charge_id=7 es un TECNICO
          //   professionalList.add(u);
          // }
          //asi esra como estaba antes pero me devolvia a los Barberos responsables
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
      professional_id, branch_id, data, charge) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    List<Estadist1Model> branchProf = [];
    print('werya tengo repositorio11 estoy en getBranchProfessionals');
    try {
      var url =
          '${Env.apiEndpoint}/professional-car-date?branch_id=$branch_id&professional_id=$professional_id&data=$data';
      if (charge == 'Tecnico') {
        url =
            '${Env.apiEndpoint}/tecnico-car-date?branch_id=$branch_id&professional_id=$professional_id&data=$data';
        print('soy tecnico siii');
      }

      final response = await get(url).timeout(Duration(seconds: 10));
      print(
          'werya tengo repositorio22 estoy en getBranchProfessionals url:$url');
      if (response.statusCode == 200) {
        print(
            'werya tengo repositorio33 response.statusCode == 200 estoy en getBranchProfessionals');
        // Parsear el body como una cadena JSON
        final jsonResponse = response.body['car'];
        print(
            'response.statusCode == 200 estoy en getBranchProfessionals-charge:$charge');

        for (int i = 0; i < jsonResponse.length; i++) {
          print(
              'ya tengo la cola de la api es estaa Tipos de datos para el objeto ${i + 1}:');
          jsonResponse[i].forEach((key, value) {
            print(
                'ya tengo la cola de la api es estaa $key: ${value.runtimeType}');
          });
        }

        final List<dynamic> branchP = jsonResponse;

        for (int i = 0; i < branchP.length; i++) {
          final Map<String, dynamic> branch = branchP[i];
          print('ya tengo la cola de la api es estaa i: $i ');
          // Crear una instancia de Estadist1Model
          Estadist1Model u = Estadist1Model.fromJson(branch);
          print('ya tengo la cola de la api es estaa i: $i - ${u.clientName}');
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
//todo COMENTANDO ESTE METODO Y PROBANDO EL DE ABAJO QUE SI FALLA REINTENTA 3 VECES IR A LA DB A BUSCAR LA INFORMACIÓN
//   Future fetchEstadistPagos(professional_id, branch_id, charge) async {
//     // todo esta es la que carga a los profesionales y a los tecnicos
//     List<PaymentModel> branchProf = [];

//     try {
//       var url =
//           '${Env.apiEndpoint}/professional-payment-show-apk?branch_id=$branch_id&professional_id=$professional_id&charge=$charge';
//       // '${Env.apiEndpoint}/professional-payment-show?branch_id=$branch_id&professional_id=$professional_id';

//       final response = await get(url).timeout(Duration(seconds: 10));
//       print('werya tengo repositorio22 estoy en getBranchProfessionals');
//       if (response.statusCode == 200) {
//         print(
//             'werya tengo repositorio33 response.statusCode == 200 estoy en getBranchProfessionals');
//         // Parsear el body como una cadena JSON
//         // Obtén el cuerpo (body) como una cadena (String)

//         final jsonResponse = response.body;
//         print('werya tengo repositorio33 response.responseBody: $jsonResponse');

// // Ahora puedes trabajar con 'jsonResponse' como un mapa de Dart
// // Ejemplo: acceder a los pagos
//         final List<dynamic> payments = response.body['payments'];

// // Ejemplo: acceder a las demás variables
//         final int pendiente = jsonResponse['pendiente'];
//         final int pagado = jsonResponse['pagado'];
//         final int clientAtended = jsonResponse['clientAtended'];
//         final int servCant = jsonResponse['servCant'];
//         final int amountGenerate = jsonResponse['amountGenerate'];
//         final int propina80 = jsonResponse['propina80'];
//         final int metaCant = jsonResponse['metaCant'];
//         final int metaAmount = jsonResponse['metaAmount'];
//         final int retention = jsonResponse['retention'];
//         final int winnerRetention = jsonResponse['winnerRetention'];
//         final int winnerAmount = jsonResponse['winnerAmount'];
//         final int productCant = jsonResponse['productCant'];
//         final int productAmount = jsonResponse['productAmount'];
//         final int productBonoCant = jsonResponse['productBonoCant'];
//         final int servAmount = jsonResponse['servAmount'];
//         final int servBonoCant = jsonResponse['servBonoCant'];
//         for (int i = 0; i < payments.length; i++) {
//           final Map<String, dynamic> branch = payments[i];
//           print(
//               'werya tengo repositorio44 response.statusCode == 200 estoy 2345:${payments[i]}');

//           // Crear una instancia de Estadist1Model
//           PaymentModel u = PaymentModel.fromJson(branch);

//           // Agregar la instancia a la lista branchProf
//           branchProf.add(u);
//         }

//         print(
//             'werya tengo repositorio44 response.statusCode == 200 estoy en branchProf:${pendiente}');
//         return {
//           'branchProf': branchProf,
//           'pendiente': pendiente,
//           'pagado': pagado,
//           'clientAtended': clientAtended,
//           'servCant': servCant,
//           'amountGenerate': amountGenerate,
//           'propina80': propina80,
//           'metaCant': metaCant,
//           'metaAmount': metaAmount,
//           'retention': retention,
//           'winnerRetention': winnerRetention,
//           'winnerAmount': winnerAmount,
//           'productCant': productCant,
//           'productAmount': productAmount,
//           'servAmount': servAmount,
//           'productBonoCant': productBonoCant,
//           'servBonoCant': servBonoCant,
//         };
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//         return branchProf;
//         // Si ocurre algún error con la solicitud HTTP
//       }
//     } catch (e) {
//       print('werya tengo Error2 :$e');
//       return branchProf;
//     }
//   }

//TODO METODO NUEVO CON 3 REINTENTOS

  Future<Map<String, dynamic>> fetchEstadistPagos(
      professional_id, branch_id, charge) async {
    List<PaymentModel> branchProf = [];
    int attempts = 0;

    print('ENTRE AL NUEVO METODO ESTE NUMERO DE VECES:$attempts');
    try {
      var url =
          '${Env.apiEndpoint}/professional-payment-show-apk?branch_id=$branch_id&professional_id=$professional_id&charge=$charge';
      final response = await get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        attempts = 10;
        print(
            'werya tengo repositorio33 response.statusCode == 200 estoy en getBranchProfessionals');
        // Parsear el body como una cadena JSON
        // Obtén el cuerpo (body) como una cadena (String)

        final jsonResponse = response.body;
        print('werya tengo repositorio33 response.responseBody: $jsonResponse');

// Ahora puedes trabajar con 'jsonResponse' como un mapa de Dart
// Ejemplo: acceder a los pagos
        final List<dynamic> payments = response.body['payments'];

// Ejemplo: acceder a las demás variables
        final int pendiente = jsonResponse['pendiente'];
        final int pagado = jsonResponse['pagado'];
        final int clientAtended = jsonResponse['clientAtended'];
        final int servCant = jsonResponse['servCant'];
        final int amountGenerate = jsonResponse['amountGenerate'];
        final int propina80 = jsonResponse['propina80'];
        final int metaCant = jsonResponse['metaCant'];
        final int metaAmount = jsonResponse['metaAmount'];
        final int retention = jsonResponse['retention'];
        final int winnerRetention = jsonResponse['winnerRetention'];
        final int winnerAmount = jsonResponse['winnerAmount'];
        final int productCant = jsonResponse['productCant'];
        final int productAmount = jsonResponse['productAmount'];
        final int productBonoCant = jsonResponse['productBonoCant'];
        final int servAmount = jsonResponse['servAmount'];
        final int servBonoCant = jsonResponse['servBonoCant'];
        for (int i = 0; i < payments.length; i++) {
          final Map<String, dynamic> branch = payments[i];
          print(
              'werya tengo repositorio44 response.statusCode == 200 estoy 2345:${payments[i]}');

          // Crear una instancia de Estadist1Model
          PaymentModel u = PaymentModel.fromJson(branch);

          // Agregar la instancia a la lista branchProf
          if (u.type == 'Adelanto') {
            //solamnete mostrar que sea adelando(Pedido por el cliente)
            branchProf.add(u);
          }
        }

        print(
            'werya tengo repositorio44 response.statusCode == 200 estoy en branchProf:${pendiente}');
        return {
          'branchProf': branchProf,
          'pendiente': pendiente,
          'pagado': pagado,
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

//TODO METODO NUEVO CON 3 REINTENTOS
//
////
//
  Future<List<Estadist0Model>> fetchEstadist0(
      professional_id, branch_id, charge) async {
    // todo esta es la que carga a los profesionales y a los tecnicos
    List<Estadist0Model> branchProf = [];
    print('werya tengo repositorio11 estoy en getBranchProfessionals');
    try {
      var url =
          '${Env.apiEndpoint}/professional-car?branch_id=$branch_id&professional_id=$professional_id';
      if (charge == 'Tecnico') //tecnico
      {
        url =
            '${Env.apiEndpoint}/tecnico-car?branch_id=$branch_id&professional_id=$professional_id';
      }

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
      print(
          'ya tengo la cola de la api es response.statusCode : ${response.statusCode}');
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
