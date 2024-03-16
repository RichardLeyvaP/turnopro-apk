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
  List<int> cantProduct = List<int>.filled(10000, 0); // Lista de Notificaciones
  List<CategoryModel> category = []; // Lista de Notificaciones
  List<ProductModel> selectproduct = []; //Notificaciones seleccionados vacia
  bool isLoading = true, isLoadingCategory = true;

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
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  void updateAppBarValue(int newValue) {
    shoppingCart += newValue;
    update();
  }

  void buyProduct(int index) {
    print('productooo cantProduct[index]:${cantProduct[index]}');
    print('productooo index:$index');
    cantProduct[index] = (cantProduct[index] - 1);
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
        print('Cantidad de productos -- -- -- $productListLength');
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
