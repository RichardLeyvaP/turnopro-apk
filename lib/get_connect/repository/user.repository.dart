// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';

class UserRepository extends GetConnect {
  Future getUserLoggedIn(String email, String password) async {
    try {
      const url = 'http://10.0.2.2:8000/api/login';

      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      final response = await post(url, body);
      if (response.statusCode == 200) {
        final users = response.body;
        if (users != null) {
          return users;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      // print('Error:$e');
    }
  }

  Future userLogout(String token) async {
    try {
      const url = 'http://10.0.2.2:8000/api/logout';

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
      // Maneja cualquier excepción que pueda ocurrir durante la solicitud.
      // print('nooo ultimo en el error:$e');
      return e;
    }
  }
}
