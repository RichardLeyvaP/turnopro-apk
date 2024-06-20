// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/env.dart';

class ServiceRepository extends GetConnect {
  final LoginController loginCont = Get.find<LoginController>();
  Future<List<ServiceModel>> getServiceList(idProfessional, idBranch) async {
    List<ServiceModel> serviceList = [];
    int serviceTimeAux = 0;
    String token = loginCont.tokenUserLoggedIn;
    try {
      if (idProfessional != null) {
        var url =
            '${Env.apiEndpoint}/professional_services?professional_id=$idProfessional&branch_id=$idBranch';

        final headers = {
          "Authorization": "Bearer $token", // Agrega el token a los encabezados
        };
        final response = await get(url, headers: headers).timeout(
            Duration(seconds: 15)); // Aumenta el tiempo de espera a 15 segundos
        if (response.statusCode == 200) {
          final services = response.body['professional_services'];
          for (Map service in services) {
            print(
                '**************************************estoy aqui devolviendo los services - (Map service in services)');
            //print(jsonEncode(service));
            ServiceModel u = ServiceModel.fromJson(jsonEncode(service));
            serviceList.add(u);
            if (serviceTimeAux < u.duration_service) {
              serviceTimeAux = u
                  .duration_service; //aqui guardo el mayor tiempo de servicio para utilizarlo en la barra cuando muetra los servicios
            }
            loginCont.setServiceTime(serviceTimeAux);
          }
          print(
              'LISTA2 _fetchServiceList Limpiando MAYOR:${loginCont.serviceTime}');
          print(
              'ServiceRepository1 RETORNANDO LA LISTA DE SERVICIOS:${serviceList.length}');
          return serviceList;
        } else {
          print('ServiceRepository2 LISTA DE SERVICIOS EN BLANCO');
          return serviceList; //retornando lista vacia
        }
      }
      print('ServiceRepository3 LISTA DE SERVICIOS EN BLANCO');
      return serviceList; //retornando lista vacia
    } catch (e) {
      print('ERROR:$e');
      return serviceList;
    }
  }
}
