// ignore_for_file: depend_on_referenced_packages, unused_element

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Models/category_model.dart';
import 'package:turnopro_apk/Models/product_model.dart';
import 'package:turnopro_apk/Models/services_model.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/get_connect/repository/product.repository.dart';

class ProductController extends GetxController {
//DECLARACION DE VARIABLES
  ProductRepository repository = ProductRepository();
  final ServiceController controllerServ = Get.find<ServiceController>();
  int shoppingCart = 0;
  int idInicial = 0;
  int productListLength = 0;
  int categoryListLength = 0;
  int pestana = 0;
  List<ProductModel> product = []; // Lista de Notificaciones
  // List<int> cantProduct = List<int>.filled(10000, 0); // Lista de Notificaciones
  List<CategoryModel> category = []; // Lista de Notificaciones
  List<ProductModel> selectproduct = []; //Notificaciones seleccionados vacia
  bool isLoading = false, isLoadingCategory = false;

  /************************************************************* */
  // Mapa para almacenar la información de productos por categoría
  RxMap<int, Map<int, int>> categoriasProductos = RxMap<int, Map<int, int>>();
  // Método para inicializar el mapa
  void inicializarMapa() {
    // Aquí podrías cargar los datos iniciales del mapa si es necesario
    categoriasProductos.value = {}; // Inicializamos con un mapa vacío
  }

  // Método para actualizar la cantidad de un producto en una categoría
  void actualizarCantidad(int categoriaId, int productoId, int nuevaCantidad) {
    if (categoriasProductos.containsKey(categoriaId)) {
      if (categoriasProductos[categoriaId]!.containsKey(productoId)) {
        categoriasProductos[categoriaId]![productoId] = nuevaCantidad;
        update(); // Actualiza el widget cuando cambia el estado
      }
    }
  }

  void updatePestana(value) {
    pestana = value;
    update();
  }

  void productActualizate(List<ProductModel> listProduct) {
    product = listProduct;
    productListLength = product.length;
    print('Cantidad de productos -- -- -- $productListLength');

    update();
  }

  // Método para agregar una nueva categoría
  void agregarCategoria(int categoriaId) {
    if (!categoriasProductos.containsKey(categoriaId)) {
      categoriasProductos[categoriaId] = {1: 2};
      print('categoriasProductos agregando id categorias bien');
      // Asignamos un nuevo mapa vacío para la nueva categoría
      update(); // Actualiza el widget cuando cambia el estado
    } else {
      print('categoriasProductos YAAAA esta agregando id categorias');
      print(
          'categoriasProductos YAAAA esta categoriasProductos[categoriaId] ${categoriasProductos[categoriaId]}');
    }
  }

  // Método para agregar un producto a una categoría
  void agregarProductoACategoria(
      int categoriaId, int productoId, int cantidad) {
    if (categoriasProductos.containsKey(categoriaId)) {
      categoriasProductos[categoriaId]![productoId] = cantidad;
      update(); // Actualiza el widget cuando cambia el estado
    } else {
      // Si la categoría no existe, podrías crearla automáticamente
      agregarCategoria(categoriaId);
      categoriasProductos[categoriaId]![productoId] = cantidad;
      update(); // Actualiza el widget cuando cambia el estado
    }
  }

  int obtenerCantidadProducto(int categoriaId, int productoId) {
    if (categoriasProductos.containsKey(categoriaId)) {
      Map<int, int>? productos = categoriasProductos[categoriaId];
      if (productos != null && productos.containsKey(productoId)) {
        return productos[productoId]!;
      }
    }
    // En caso de que la categoría o el producto no existan, retornamos 0 o un valor predeterminado
    return 0;
  }
//Forma de saber la cantidad
//int cantidad = obtenerCantidadProducto(34, 23);

  void modificarCantidadProducto(
      int categoriaId, int productoId, int nuevaCantidad) {
    if (categoriasProductos.containsKey(categoriaId)) {
      Map<int, int>? productos = categoriasProductos[categoriaId];
      if (productos != null && productos.containsKey(productoId)) {
        productos[productoId] = nuevaCantidad;
        update(); // Actualiza el widget cuando cambia el estado
      }
    }
  }
//FORMA de modificar la cantidad
//modificarCantidadProducto(34, 23, 150);
  /************************************************************************** */

  @override
  void onReady() {
    super.onReady();
    // Future.delayed(const Duration(seconds: 2), () {
    //isLoading = false;
    update();
    // });
  }

  void updateAppBarValue(int newValue) {
    shoppingCart += newValue;
    update();
  }

  /* Future<void> buyProduct(int index) async {
    print('productooo cantProduct[index]:${cantProduct[index]}');
    print('productooo index:$index');
    cantProduct[index] = (cantProduct[index] - 1);
    update();
  }*/

  Future<void> fetchproductList(index) async {
    print(
        'LISTA2 _fetchServiceList Limpiando ENTRE ACTUALIZAR LOS PRODUCTOS:$index');
    final LoginController controllerLogin = Get.find<LoginController>();
    try {
      List<ProductModel>? tempProduct;
      //isLoadingCategory = true;
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            // color: Color.fromARGB(255, 240, 17, 55),
            color: Color(0xFFFDAE2A),
          ),
        ),
        barrierDismissible: false,
      ); //Get.back();
      // update();

      tempProduct = await repository.getProductCategoryList(
          index, controllerLogin.branchIdLoggedIn);
      if (tempProduct != null) {
        product = tempProduct;
        productListLength = product.length;
        print('Cantidad de productos -- -- -- $productListLength');
        // isLoadingCategory = false;
      }
    } catch (e) {
      productListLength = -99;
    } finally {
      Get.back(); //esta aqui garantizando que si da error o no igual cierre el cargando
      update();
    }
  }

/*
  Future<void> fetchproductListIni(index) async {
    //este la unica diferencia es que no tiene el cargar
    print(
        'LISTA2 _fetchServiceList Limpiando ENTRE ACTUALIZAR LOS PRODUCTOS:$index');
    final LoginController controllerLogin = Get.find<LoginController>();
    try {
      List<ProductModel>? tempProduct;
      //isLoadingCategory = true;

      // update();
      Future.delayed(const Duration(milliseconds: 1000), () async {
        tempProduct = await repository.getProductCategoryList(
            index, controllerLogin.branchIdLoggedIn);
        if (tempProduct != null) {
          product = tempProduct!;
          productListLength = product.length;
          print('Cantidad de productos -- -- -- $productListLength');
          // isLoadingCategory = false;

          update();
        }
      });
    } catch (e) {
      productListLength = -99;
      update();
    }
  }
*/
  final ShoppingCartController shoppingCartController =
      Get.find<ShoppingCartController>();
  Future<void> metdNewServiceProduct(branch_id, professional_id, car_id) async {
    // Obtén la lista de categorías
    try {
      pestana = 0;
      List<ProductModel>? tempProduct;
      final result = await repository.metdNewServiceProductRepository(
          branch_id,
          professional_id,
          car_id); //todo aqui llama a pedir las categorias de los productos por almacen-branch ala que pertenece el profesional

      //aqui viendo si hay categorias de productos
      if (result.containsKey('categoryList')) {
        category = result['categoryList'];
        // Verifica que la lista de categorías no esté vacía antes de acceder a sus elementos
        if (category.isNotEmpty) {
          categoryListLength = category.length;
          idInicial = category[0].id;
          print(
              'La lista de categorías está categoriasProductos:idInicial:${idInicial}');
          //aqui gusrdo los id de las categorias
          for (int i = 0; i < categoryListLength; i++) {
            agregarCategoria(category[i].id);
          }
        } else {
          // Manejo de caso en el que la lista de categorías está vacía
          print('La lista de categorías está vacía.');
          categoryListLength = 0;
        }
      }

      //asignar los productos (en este caso la idea es crear la cantidad de objetos == long de categorias, es decir product1 va a tener tds los productos de l acategoria 1 y asi)
      if (result.containsKey('productCategory')) {
        product = result['productCategory'];
        print('category.length.new-ya---product:$product');
        productListLength = product.length;
      } else {
        print('NO tiene productos :$product');
      }

      //aqui asignar los servicios
      if (result.containsKey('servicesList')) {
        controllerServ.services = result['servicesList'];

        controllerServ.serviceListLength = controllerServ.services.length;
        controllerServ.selectService = result['selectServ'];
        //aqui tengo los servicios seleccionados
        //  int cantServSelect = controllerServ.selectService.length;
        shoppingCartController.shoppingCart = result['shoppingCart'];

        /* productListLength = selectproduct.length;
      serviceListLength = selectserviceCart.length;
      shoppingCart = productListLength + serviceListLength;*/

        print('category.length.new-ya---services:${controllerServ.services}');
        print(
            'category.length.new-ya---services-length:${controllerServ.serviceListLength}');
        //aqui la logica de los servicios
      }
      update();
    } catch (e) {
      print('FALLO LA CONEXION: $e');
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

          //aqui gusrdo los id de las categorias
          for (int i = 0; i < categoryListLength; i++) {
            agregarCategoria(category[i].id);
          }
          print(
              'La lista de categorías está categoriasProductos:${categoriasProductos.length}');
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
/*  Future<void> initializeData() async {
    updatePestana(0);
    //todo aqui primero espero por las categorias para despues por el id de categoria llamar a los productos
    await _fetchcategoryList(); // Espera a que se complete _fetchcategoryList
    await fetchproductListIni(
        idInicial); // Llama a fetchproductList después de obtener idInicial
  }
*/
  getList() {
    return product;
  }

  getCategoryList() {
    return category;
  }
}
