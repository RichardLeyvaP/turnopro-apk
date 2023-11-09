// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:turnopro_apk/env.dart';

class UserRepository extends GetConnect {
  Future getUserLoggedIn(String email, String password) async {
    try {
      var url = '${Env.apiEndpoint}/login';

      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      final response = await post(url, body);
      if (response.statusCode == 200) {
        final users = response.body;
        print('dentro del code:200');
        if (users != null) {
          print('dentro del code:200 y tiene usuarios');
          return users;
        } else {
          print('dentro del code:200 pero retorno null');
          return null;
        }
      } else {
        print('No entro al code:200 este es el codigo:${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error estoy en el catch (e) y este es el error:$e');
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
}
