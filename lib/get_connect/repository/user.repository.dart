// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/ClockModel.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';

class UserRepository extends GetConnect {
  Future generateQr(branchId, professionalId, token) async {
    try {
      var url = '${Env.apiEndpoint}/record';
      final Map<String, dynamic> body = {
        'branch_id': branchId,
        'professional_id': professionalId,
      };

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
      print(url);
      print(response.statusCode);
      if ((response.statusCode == 200)) {
        print('RETORNE-- TRUE A LA CREACION DEL Qr');
        return true;
      } else {
        print('RETORNE-- FALSE A LA CREACION DEL Qr');
        return false;
      }
    } catch (e) {
      print('RETORNE-- ERROR DE SERVIDOR A LA CREACION DEL Qr:$e');
    }
  }

  // Future repoShowClock(int differenceInMinutes, professionalId, token) async {
  //   int timeC1 = -999, timeC2 = -999, timeC3 = -999, timeC4 = -999;
  //   try {
  //     var url =
  //         '${Env.apiEndpoint}/show-clocks?professional_id=$professionalId';

  //     final headers = {
  //       "Authorization": "Bearer $token", // Agrega el token a los encabezados
  //     };
  //     final response =
  //         await get(url, headers: headers).timeout(Duration(seconds: 15));
  //     print(url);
  //     print(response.statusCode);
  //     print('RETORNE-- repoShowClock-.url:${response.statusCode}');
  //     print(
  //         'RETORNE-- repoShowClock-response.statusCode:${response.statusCode}');
  //     if ((response.statusCode == 200)) {
  //       print('RETORNE-- repoShowClock-repoShowClock:${response.body}');
  //       // Decodifica el JSON
  //       //Map<String, dynamic> jsonResponse = json.decode(response.body);

  //       // Mapea la respuesta JSON a una instancia de TailsResponse
  //       TailsResponse tailsResponse = TailsResponse.fromMap(response.body);
  //       print('RETORNE-- repoShowClock-repoShowClock2:${tailsResponse}');
  //       // Por ejemplo, puedes recorrer la lista de ClockModel
  //       // Verifica si la lista "tails" está vacía
  //       if (tailsResponse.tails.isEmpty) {
  //         print('RETORNE---ESTA VACIA');
  //       } else {
  //         tailsResponse.tails.forEach((clock) {
  //           print(
  //               'RETORNE---Clock: ${clock.clock}, TimeClock: ${clock.timeClock}, Detached: ${clock.detached}');
  //           if (clock.clock == 1) {
  //             int calculatedTime = clock.timeClock - differenceInMinutes;
  //             timeC1 = calculatedTime < 0 ? 0 : calculatedTime;
  //           } else if (clock.clock == 2) {
  //             int calculatedTime = clock.timeClock - differenceInMinutes;
  //             timeC2 = calculatedTime < 0 ? 0 : calculatedTime;
  //           } else if (clock.clock == 3) {
  //             int calculatedTime = clock.timeClock - differenceInMinutes;
  //             timeC3 = calculatedTime < 0 ? 0 : calculatedTime;
  //           } else if (clock.clock == 4) {
  //             int calculatedTime = clock.timeClock - differenceInMinutes;
  //             timeC4 = calculatedTime < 0 ? 0 : calculatedTime;
  //           }
  //         });
  //       }

  //       return {
  //         'timeC1': timeC1,
  //         'timeC2': timeC2,
  //         'timeC3': timeC3,
  //         'timeC4': timeC4,
  //       };
  //     } else {
  //       print('RETORNE-- repoShowClock-FALSE A LA CREACION DEL Qr');
  //       return false;
  //     }
  //   } catch (e) {
  //     print(
  //         'RETORNE-- repoShowClock-ERROR DE SERVIDOR A LA CREACION DEL Qr:$e');
  //     return -999;
  //   }
  // }

  Future exitHours(branchId, professionalId, token) async {
    try {
      var url = '${Env.apiEndpoint}/record';
      final Map<String, dynamic> body = {
        'branch_id': branchId,
        'professional_id': professionalId,
      };

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await put(headers: headers, url, body);
      print(url);
      print('NO sali - code :${response.statusCode}');
      if ((response.statusCode == 200)) {
        print('sali de la sucursal');
        return true;
      } else {
        print('NO sali de la sucursal');
        return false;
      }
    } catch (e) {
      print('NO sali de la sucursal error:$e');
    }
  }

  Future solitColacion(branchId, professionalId, type, state, token) async {
    try {
      var url = '${Env.apiEndpoint}/request_location_professional';
      final Map<String, dynamic> body = {
        'branch_id': branchId,
        'professional_id': professionalId,
        'type': type,
        'state': state,
      };

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await put(headers: headers, url, body);
      print(url);
      print('NO sali - code :${response.statusCode}');
      if ((response.statusCode == 200)) {
        print('sali de la sucursal');
        return 1;
      } else {
        print('NO sali de la sucursal');
        return 2;
      }
    } catch (e) {
      print('NO sali de la sucursal error:$e');
    }
  }

  Future getUserLoggedBranch(String email, String password) async {
    try {
      String token = loginController.tokenUserLoggedIn;
      var url =
          '${Env.apiEndpoint}/login-phone-get-branch?email=$email&password=$password';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('devolviendo de url:$url');
      print(response.statusCode);
      if (response.statusCode == 200) {
        //print('addOrderCartList response:$response');
        final branchesLog = response.body['branches'];
        print(
            'devolviendo de getBranchLoggedIn(String email, String password) sii');
        print(branchesLog);
        return branchesLog;
      } else {
        print(
            'devolviendo de getBranchLoggedIn(String email, String password) NOO- ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('5Error estoy en el catch (e) y este es el error:$e');
    }
  }

  Future getUserLoggedIn(String email, String password, int idBranch) async {
    try {
      var url = '${Env.apiEndpoint}/login-phone';

      final Map<String, dynamic> body = {
        'branch_id': idBranch,
        'email': email,
        'password': password,
      };

      print('a..........$url');
      print('a..........$body');
      //esta no manda el token porque aqui es el login , aqui es donde se crea
      final response = await post(url, body);
      print(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final users = response.body;
        print('1dentro del code:200');
        print('final users:$users');
        if (users != null) {
          print('2dentro del code:200 y tiene usuarios-users:$users');
          print(users);
          return users;
        } else {
          print(
              '3dentro del code:200 pero retorno null es porque algo dio nul , la sucursal puede ser');
          return null;
        }
      } else {
        print('4No entro al code:200 este es el codigo:${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('5Error estoy en el catch (e) y este es el error:$e');
      return null;
    }
  }

  Future userLogoutNew(int professionalId, int branchId, String token) async {
    try {
      var url =
          '${Env.apiEndpoint}/logout-phone?professional_id=$professionalId&branch_id=$branchId';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };

      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15));
      //print(response.body);
      if (response.statusCode == 200) {
        final resp = response.body;
        if (resp != null) {
          return resp;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error de userLogoutNew:$e');
      return null;
    }
  }

  Future userLogout(String token) async {
    try {
      var url = '${Env.apiEndpoint}/logout';

      // Parámetros que deseas enviar en la solicitud POST
      /*   final Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };*/

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };

      final response =
          await get(url, headers: headers).timeout(Duration(seconds: 15));
      //print(response.body);
      if (response.statusCode == 200) {
        final resp = response.body;
        if (resp != null) {
          return resp;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error de userLogoutNew:$e');
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  Future<int> insertPuesto(
      professional_id, workplace_id, places, branch_id, token) async {
    try {
      var url = '${Env.apiEndpoint}/professionalworkplace';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'professional_id': professional_id,
        'workplace_id': workplace_id,
        'places': places,
        'branch_id': branch_id
      };

      // Realizar la solicitud POST
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
      if (response.statusCode == 200) {
        return 1;
      } else {
        return -99;
      }
    } catch (e) {
      return 0;
    }
  }

  // ignore: non_constant_identifier_names
  Future<int> insertHoraEntrada(professional_id, branch_id, token) async {
    try {
      var url = '${Env.apiEndpoint}/record';

      // Parámetros que deseas enviar en la solicitud POST
      final Map<String, dynamic> body = {
        'professional_id': professional_id,
        'branch_id': branch_id,
      };

      // Realizar la solicitud POST
      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await post(headers: headers, url, body);
      print('registrar hora d entrada-:ruta: $url');

      print(
          'registrar hora d entrada-:response.statusCode ${response.statusCode}');
      print(
          'registrar hora d entrada-:professional_id y branch_id $professional_id y $branch_id');
      if (response.statusCode == 200) {
        return 1;
      } else {
        return -99;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<bool> exitPostworking(int id, String type, int idProf) async {
    try {
      var url = '';
      String token = loginController.tokenUserLoggedIn;
      if (type == "Barbero") {
        url =
            '${Env.apiEndpoint}/update-state-prof-workplace?id=$id&busy=0&professional_id=$idProf';
      } else if (type == "Tecnico") {
        url =
            '${Env.apiEndpoint}/update-state-tec-workplace?id=$id&select=0&professional_id=$idProf';
      }
      print('este es el id del puesto url:$url');

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('este es el id del puesto url:${response.statusCode}');

      //print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error:$e');
      return false;
    }
  }

  Future getIdPuestoRepo(int idProfessional, String charge) async {
    try {
      String token = loginController.tokenUserLoggedIn;
      print('este es el id del puesto222-idProfessional:$idProfessional');
      var url =
          '${Env.apiEndpoint}/workplace-show-professional?professional_id=$idProfessional&charge=$charge';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('este es el id del puesto333-response:$response');
      print(
          'este es el id del puesto333-response.statusCode:${response.statusCode}');
      //print(response.body);
      if (response.statusCode == 200) {
        final intValue = int.parse(response.body);
        print('este es el id del puesto333-return response:$intValue');
        if (intValue == 0) {
          print('este es el id del puesto333-return intValue11:$intValue');
          return -99;
        } else {
          print('este es el id del puesto333-return intValue22:$intValue');
          return intValue;
        }
      } else {
        return -99;
      }
    } catch (e) {
      print('Error:$e');
      return -999;
    }
  }

  Future gettimeClokInitial(int idProfessional, int branch) async {
    try {
      String token = loginController.tokenUserLoggedIn;
      print('este es el id del puesto222-idProfessional:$idProfessional');
      var url =
          '${Env.apiEndpoint}/time-clock-reservation?professional_id=$idProfessional&branch_id=$branch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('este es el id del puesto333-response:$response');
      print(
          'este es el id del puesto333-response.statusCode de gettimeClokInitial:${response.statusCode}');
      //print(response.body);
      if (response.statusCode == 200) {
        final intValue = int.parse(response.body);

        return intValue;
      } else {
        return -99;
      }
    } catch (e) {
      print('Error:$e');
      return -999;
    }
  }

  Future<int> getEntradaPuestoRepo(int idProfessional, int idBanch) async {
    try {
      String token = loginController.tokenUserLoggedIn;
      print('este es el id del puesto222-idProfessional:$idProfessional');
      var url =
          '${Env.apiEndpoint}/record-show-professional?professional_id=$idProfessional&branch_id=$idBanch';

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('este es el id del puesto333-response:$response');
      print(
          'este es el id del puesto333-response.statusCode:${response.statusCode}');
      //print(response.body);
      if (response.statusCode == 200) {
        int intValue = int.parse(response.body);
        print('este es el id del puesto333-return response:$intValue');

        print('este es el id del puesto333-return intValue22:$intValue');
        return intValue;
      } else {
        return -99;
      }
    } catch (e) {
      print('Error:$e');
      return -999;
    }
  }

  Future<int> getStateProfessional(int idProfessional) async {
    try {
      String token = loginController.tokenUserLoggedIn;
      print('este es el id del puesto222-idProfessional:$idProfessional');
      var url = '${Env.apiEndpoint}/professional-show-apk?id=$idProfessional';
      print('este es el id del var url:$url');

      final headers = {
        "Authorization": "Bearer $token", // Agrega el token a los encabezados
      };
      final response = await get(url, headers: headers).timeout(
          Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
      print('este es el id del puesto333-response:$response');
      print(
          'este es el id del puesto333-response.statusCode:${response.statusCode}');
      //print(response.body);
      if (response.statusCode == 200) {
        final intValue = int.parse(response.body);
        print('este es el id del puesto333-return response:${response.body}');
        return intValue;
      } else {
        return -99;
      }
    } catch (e) {
      print('Error:$e');
      return -999;
    }
  }
}
