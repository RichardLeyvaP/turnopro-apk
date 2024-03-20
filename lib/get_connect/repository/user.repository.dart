// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/env.dart';

class UserRepository extends GetConnect {
  Future generateQr(branchId, professionalId) async {
    try {
      var url = '${Env.apiEndpoint}/record';
      final Map<String, dynamic> body = {
        'branch_id': branchId,
        'professional_id': professionalId,
      };

      final response = await post(url, body);
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

  Future getUserLoggedIn(String email, String password) async {
    try {
      var url = '${Env.apiEndpoint}/login';

      final Map<String, dynamic> body = {
        'branch_id': 1, //todo este valor esta estatico
        'email': email,
        'password': password,
      };
      final response = await post(url, body);
      print(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final users = response.body;
        print('1dentro del code:200');
        print('final users:$users');
        if (users != null) {
          print('2dentro del code:200 y tiene usuarios');
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

      final response = await get(url, headers: headers);
      //print(response.body);
      if (response.statusCode == 200) {
        final users = response.body;
        if (users != null) {
          return users;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error:$e');
      return e;
    }
  }

  Future<bool> exitPostworking(int id, String type) async {
    try {
      var url = '';
      if (type == "Professional") {
        url = '${Env.apiEndpoint}/update-state-prof-workplace?id=$id&busy=0';
      } else if (type == "Tecnico") {
        url = '${Env.apiEndpoint}/update-state-tec-workplace?id=$id&select=0';
      }
      print('este es el id del puesto url:$url');

      final response = await get(url);
      print('este es el id del puesto url:$response');

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

  Future getIdPuesto(int idProfessional) async {
    try {
      print('este es el id del puesto222-idProfessional:$idProfessional');
      var url =
          '${Env.apiEndpoint}/workplace-show-professional?professional_id=$idProfessional';

      final response = await get(url);
      print('este es el id del puesto333-response:$response');
      print(
          'este es el id del puesto333-response.statusCode:${response.statusCode}');
      //print(response.body);
      if (response.statusCode == 200) {
        final intValue = int.parse(response.body);
        print('este es el id del puesto333-return response:$intValue');
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
