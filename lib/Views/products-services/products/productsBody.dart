// ignore_for_file: file_names, depend_on_referenced_packages, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';

class ProductsBody extends StatefulWidget {
  const ProductsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Agregar la declaración de tabsID como variable de instancia
  var tabsID = [];
  List<String> tabValues = [];
  //*AQUI ASIGNO A tabs los nombres que tiene la lista de categorias de productos
  var tabs2 = <Widget>[];

  final ProductController controllerProduct = Get.find<ProductController>();
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final LoginController controllerLogin = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: controllerProduct.categoryListLength, vsync: this);

    // Asegúrate de llenar tabsID después de obtener sus valores en el método build
    for (int i = 0; i < controllerProduct.categoryListLength; i++) {
      tabValues.add(controllerProduct.category[i].name);
      tabsID.add(controllerProduct.category[i].id);
      print('tabsID : ${controllerProduct.category[i].id}');
    }

    for (int i = 0; i < controllerProduct.categoryListLength; i++) {
      tabs2.add(Text(tabValues[i]));
    }

    // Agrega un listener al controlador de pestañas
    _tabController.addListener(() {
      //todo Llama a la función cuando la pestaña cambia
      controllerProduct.fetchproductList(tabsID[_tabController.index]);
      //}
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controllerProduct) {
      return controllerProduct.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFFF18254),
            ))
          : Column(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.width) * 0.09,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: const Color.fromARGB(255, 43, 44, 49),
                    indicatorColor: const Color(0xFFF18254),
                    controller: _tabController,
                    tabs: tabs2,
                  ),
                ),
                controllerProduct.productListLength != -99
                    ? controllerProduct.isLoadingCategory == true
                        ? const Padding(
                            padding: EdgeInsets.only(top: 240),
                            child: CircularProgressIndicator(
                              color: Color(0xFFF18254),
                            ),
                          )
                        : controllerProduct.productListLength == 0
                            ? const Center(
                                child: Text(
                                'No hay Productos',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ))
                            : Expanded(
                                child: TabBarView(
                                controller: _tabController,
                                children: List<Widget>.generate(
                                  tabs2.length,
                                  (index) {
                                    return ListView.builder(
                                      itemCount:
                                          controllerProduct.productListLength,
                                      itemBuilder: (context, itemIndex) {
                                        if (controllerProduct
                                                    .productListLength !=
                                                0 &&
                                            controllerProduct
                                                    .productListLength >
                                                0) {
                                          controllerProduct
                                                  .cantProduct[itemIndex] =
                                              controllerProduct
                                                  .product[itemIndex]
                                                  .product_exit;
                                        }

                                        return Column(
                                          children: [
                                            controllerProduct
                                                            .productListLength !=
                                                        0 &&
                                                    controllerProduct
                                                            .productListLength >
                                                        0
                                                ? cartProduct(
                                                    'assets/images/pngegg.png',
                                                    controllerProduct
                                                        .product[itemIndex].id,
                                                    controllerProduct
                                                        .product[itemIndex]
                                                        .name,
                                                    controllerProduct
                                                            .cantProduct[
                                                        itemIndex], //este es una variable en el controlador
                                                    controllerProduct
                                                        .product[itemIndex]
                                                        .description,
                                                    controllerProduct
                                                        .product[itemIndex]
                                                        .sale_price,
                                                    context,
                                                    controllerShoppingCart,
                                                    controllerLogin,
                                                    controllerProduct,
                                                    itemIndex,
                                                  )
                                                : controllerProduct
                                                            .productListLength ==
                                                        0
                                                    ? const Text('')
                                                    : const Text(
                                                        'Fallo la carga de los datos, revise su coneccion a internet'),
                                            SizedBox(
                                              height: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ))
                    : const Text(
                        'Falló la conexion,revise su coneccion de Internet.'),
              ],
            );
    });
  }

  Padding cartProduct(
      String addressProduct,
      int id,
      String productName,
      int productExit,
      String propertiesName,
      double priceProduct,
      BuildContext context,
      ShoppingCartController controllerShoppingCart,
      LoginController controllerLogin,
      ProductController controllerProduct,
      itemIndex) {
    //VARIABLES DE PROPIEDADES DEL WIDGET
    const double borderRadiusValue = 12; //container que carga la imagen
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.26),
                width: (MediaQuery.of(context).size.width * 0.4),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadiusValue)),
                    color: Color(0xFFF18254)),
                child: FractionallySizedBox(
                  widthFactor: 0.6, // 50% del ancho del contenedor padre
                  heightFactor: 0.65, // 50% del alto del contenedor padre
                  child: Center(
                    child: Image.asset(addressProduct),
                  ),
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.26),
                width: (MediaQuery.of(context).size.width * 0.52),
                child: Column(
                  //AQUI ES LA PARTE DERECHA DE LOS DATOS DEL PRODUCTO
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      title: Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertiesName,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(148, 0, 0, 0)),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Cantidad Disponible: ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(148, 0, 0, 0)),
                              ),
                              Text(
                                '$productExit',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(148, 0, 0, 0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: Text(
                          priceProduct.toString(),
                          style: TextStyle(
                              fontSize:
                                  (MediaQuery.of(context).size.height * 0.03),
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        //vertical: 16.0,
                                        horizontal: 18.0), // Ajusta el padding
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(200, 43, 44, 49)),
                                  // Añadir más propiedades de estilo aquí
                                ),
                                onPressed: () {
                                  if (controllerLogin.codigoQrValid() == true) {
                                    controllerProduct.buyProduct(itemIndex);
                                    controllerShoppingCart
                                        .updateShoppingCartValue(
                                            priceProduct,
                                            tabsID[_tabController
                                                .index], //le paso el id d ela categoria
                                            controllerShoppingCart
                                                .carIdClienteSelect,
                                            'product',
                                            id);
                                  } else {
                                    Get.snackbar(
                                      'Mensaje',
                                      'Debe de escanear el código Qr de entrada',
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      backgroundColor: const Color.fromARGB(
                                          118, 255, 255, 255),
                                      showProgressIndicator: true,
                                      progressIndicatorBackgroundColor:
                                          const Color.fromARGB(
                                              255, 203, 205, 209),
                                      progressIndicatorValueColor:
                                          const AlwaysStoppedAnimation(
                                              Color(0xFFF18254)),
                                      overlayBlur: 3,
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: (MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.04), // Ajusta este valor según tu preferencia
                                      backgroundColor: const Color(0xFFF18254),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.03),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Center(
                                      child: Text(
                                        'AGREGAR',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
