// ignore_for_file: depend_on_referenced_packages, unused_element

import 'package:get/get.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';

class ProductController extends GetxController {
  //LLAMANDO AL CONTROLADOR
  ProductController() {
    _initializeData();
    //_fetchcategoryList();
    // Llamar al método asincrónico en el constructor
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  ProductRepository repository = ProductRepository();
  RxInt shoppingCart = 0.obs;

  void updateAppBarValue(int newValue) {
    shoppingCart.value += newValue;
  }

  bool yaEntre = false;
  double getTotal = 20.0;
  int numero = 5;
  int idInicial = 0;
  int productListLength = 0;
  int categoryListLength = 0;

  List<ProductModel> product = []; // Lista de Notificaciones
  List<CategoryModel> category = []; // Lista de Notificaciones

  List<ProductModel> selectproduct =
      []; // Lista de Notificaciones seleccionados vacia
  int time = 30;
  bool isLoading = true;

  Future<void> fetchproductList(index) async {
    product = await repository.getProductCategoryList(index);
    productListLength = product.length;
    update();
  }

  Future<void> _fetchcategoryList() async {
    category = await repository.getCategoryList();
    categoryListLength = category.length;
    idInicial = category[0].id;
    update();
  }

  Future<void> _initializeData() async {
    await _fetchcategoryList(); // Espera a que se complete _fetchcategoryList
    fetchproductList(
        idInicial); // Llama a fetchproductList después de obtener idInicial
  }

  void calculateTime() {
    if (time > 60) {
      //controlando que el tiempo no sea mayor que 60 min
      time = 60;
    }
    if (time < 0) {
      //controlando que el tiempo no sea negativo
      time = 0;
    }
    update();
  }

  getList() {
    return product;
  }

  getCategoryList() {
    return category;
  }

  getTotalSum() {
    getTotal = getTotal + 5;

    // getTotal = product
    //     .map((product) => product.id)
    //     .fold(0.0, (sum, id) => sum + id)
    //     .toDouble();
    // print(getTotal);
    update();
  }

  //Future<List<UserModel>> userList() async => await repository.getUserList();

//***************************************************************
//*METODOS ELIMINAR

  //*ELIMINAR 1 ELEMENTO
  void deleteproduct(int index) {
    if (index >= 0 && index < product.length) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL

      if (selectproduct.contains(product[index])) {
        selectproduct.removeWhere((products) => products == product[index]);
        getTotal = getTotal - 5;
      }
    }
    product.removeAt(index);
    productListLength = product.length;

    update();
  }

  //*ELIMINAR  ELEMENTOS SELECCIONADOS
  void deleteMultipleproduct() {
    if (selectproduct.isNotEmpty) {
      //HACER LLAMADA A REPOSITORYY MANDAR A ELIMINAR EN LA BD
      //SI SE ELIMINA CORRECTAMENTE MADO HACER LO DE ABAJO,Q ES ELIMINAR EN LA PARTE VISUAL
      product.removeWhere((element) => selectproduct.contains(element));
      productListLength = product.length;
      selectproduct = [];
      getTotal = getTotal - 5;
      update();
    }
  }

  void deleteAll() {
    product = [];
    selectproduct = [];
    productListLength = product.length;
    getTotal = 0.0;
    update();
  }
}
