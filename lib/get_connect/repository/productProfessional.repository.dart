import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import '../../Controllers/login.controller.dart';
import '../../Models/productProfesional_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductProfessionalRepository extends GetConnect {

  final LoginController controllerLogin = Get.find<LoginController>();

  ProductProfessionalRepository();

  Future<List<ProductProfessional>> fetchProducts() async {

    try {
    int branchId = controllerLogin.branchIdLoggedIn!;
    String token = controllerLogin.tokenUserLoggedIn;
    final url =
        '${dotenv.env['API_ENDPOINT']}/productstore-show-worker?branch_id=$branchId';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await get(url, headers: headers);
    if (response.statusCode == 200) {
      final responseData = response.body;
      final List<dynamic> productsJson = responseData['products'];

      return productsJson
          .map((json) => ProductProfessional.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  } catch (e) {
  print('fetchProducts error: $e');
  throw Exception('Error fetching products: $e');
  }


  }

  Future<bool> sendPurchaseRequest(List<ProductProfessional> selectedProducts) async {
    int professionalId = controllerLogin.idProfessionalLoggedIn!;
    int branchId = controllerLogin.branchIdLoggedIn!;

    var url = '${dotenv.env['API_ENDPOINT']}/worker-purchase-products';

    final body = {
      'branch_id': branchId,
      'professional_id': professionalId,
      'products': selectedProducts.map((product) => {
        'id': product.id,
        'cant': 1, // Asegúrate de que `quantity` es el nombre correcto
      }).toList(),
    };

    String token = controllerLogin.tokenUserLoggedIn;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await post(headers: headers, url, body);
    print("Respuesta del Servidor22: ${response.statusCode}");

    return response.statusCode == 201;
  }

}
