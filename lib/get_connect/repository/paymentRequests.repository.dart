import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/combinedDataResponse_model.dart';

class PaymentRequestsRepository extends GetConnect {
  final LoginController controllerLogin = Get.find<LoginController>();


  Future<CombinedDataResponse> getCombinedRequests({
    required String startDate,
    required String endDate,
  }) async {
    int professionalId = controllerLogin.idProfessionalLoggedIn!;
    int branchId = controllerLogin.branchIdLoggedIn!;
    final url =
        '${dotenv.env['API_ENDPOINT']}/get-combined-data?professional_id=$professionalId&branch_id=$branchId&startDate=$startDate&endDate=$endDate';

    String token = controllerLogin.tokenUserLoggedIn;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.body;

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return CombinedDataResponse.fromJson(jsonResponse);
        } else {
          throw Exception("Respuesta incorrecta: ${jsonResponse['message']}");
        }
      } else {
        throw Exception("ERROR 21 ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("ERROR 22 en CombinedRequestsRepository: $e");
      rethrow;
    }
  }


  Future<bool> createAdvanceRequest({

    required int amount,

  }) async {


    int professionalId= controllerLogin.idProfessionalLoggedIn!;
    int branchId= controllerLogin.branchIdLoggedIn!;
    var url = '${dotenv.env['API_ENDPOINT']}/advance';
    final Map<String, dynamic> body = {
      'branch_id': branchId,
      'professional_id': professionalId,
      'amount': amount,
    };

    String token = controllerLogin.tokenUserLoggedIn;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await post(headers: headers, url, body);

    print("Respuesta del Servidor: $response.statusCode");

    return response.statusCode == 201; //
  }


}
