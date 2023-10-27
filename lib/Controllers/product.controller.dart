// ignore_for_file: depend_on_referenced_packages, unused_element

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';

class ProductController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  ProductController() {
    _initializeData();
  }
//DECLARACION DE VARIABLES
  ProductRepository repository = ProductRepository();
  int shoppingCart = 0;
  int idInicial = 0;
  int productListLength = 0;
  int categoryListLength = 0;
  List<ProductModel> product = []; // Lista de Notificaciones
  List<CategoryModel> category = []; // Lista de Notificaciones
  List<ProductModel> selectproduct = []; //Notificaciones seleccionados vacia
  bool isLoading = true;

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
    try {
      product = await repository.getProductCategoryList(index);
      // print(product);
      productListLength = product.length;
      update();
    } catch (e) {
      productListLength = -99;
      update();
    }
  }

  Future<void> _fetchcategoryList() async {
    //todo REVISAR
    // Obtén la lista de categorías
    try {
      category = await repository.getCategoryList();

      // Verifica que la lista de categorías no esté vacía antes de acceder a sus elementos
      if (category.isNotEmpty) {
        categoryListLength = category.length;
        idInicial = category[0].id;
        update();
      } else {
        // Manejo de caso en el que la lista de categorías está vacía
        //print('La lista de categorías está vacía.');
      }
    } catch (e) {
      // print('FALLO LA CONEXION: $e');
    }
  }

  Future<void> _initializeData() async {
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
