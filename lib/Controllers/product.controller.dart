// ignore_for_file: depend_on_referenced_packages, unused_element

import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';

class ProductController extends GetxController {
//DECLARACION DE VARIABLES
  ProductRepository repository = ProductRepository();
  int shoppingCart = 0;
  int idInicial = 0;
  int productListLength = 0;
  int categoryListLength = 0;
  List<ProductModel> product = []; // Lista de Notificaciones
  List<CategoryModel> category = []; // Lista de Notificaciones
  List<ProductModel> selectproduct = []; //Notificaciones seleccionados vacia
  bool isLoading = true, isLoadingCategory = true;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  void updateAppBarValue(int newValue) {
    shoppingCart += newValue;
    update();
  }

  Future<void> fetchproductList(index) async {
    final LoginController controllerLogin = Get.find<LoginController>();
    try {
      isLoadingCategory = true;
      update();
      Future.delayed(const Duration(milliseconds: 1000), () async {
        product = await repository.getProductCategoryList(
            index, controllerLogin.branchIdLoggedIn);
        productListLength = product.length;
        print('Cantidad de productos $productListLength');
        isLoadingCategory = false;
        update();
      });
    } catch (e) {
      productListLength = -99;
      update();
    }
  }

  Future<void> _fetchcategoryList() async {
    // Obtén la lista de categorías
    try {
      final LoginController controllerLogin = Get.find<LoginController>();
      if (controllerLogin.branchIdLoggedIn != null) {
        category = await repository.getCategoryList(controllerLogin
            .branchIdLoggedIn); //todo aqui llama a pedir las categorias de los productos por almacen-branch ala que pertenece el profesional

        // Verifica que la lista de categorías no esté vacía antes de acceder a sus elementos
        if (category.isNotEmpty) {
          categoryListLength = category.length;
          idInicial = category[0].id;
          print('categoryListLength es:$categoryListLength');
          print('idInicial es:$idInicial');
          update();
        } else {
          // Manejo de caso en el que la lista de categorías está vacía
          print('La lista de categorías está vacía.');
          categoryListLength = 0;
          update();
        }
      }
    } catch (e) {
      // print('FALLO LA CONEXION: $e');
    }
  }

//todo esta es la primera ves que carga los productos hace la llamada a  fetchproductList(idInicial);
  Future<void> initializeData() async {
    //todo aqui primero espero por las categorias para despues por el id de categoria llamar a los productos
    await _fetchcategoryList(); // Espera a que se complete _fetchcategoryList
    fetchproductList(
        idInicial); // Llama a fetchproductList después de obtener idInicial
  }

  getList() {
    return product;
  }

  getCategoryList() {
    return category;
  }
}
