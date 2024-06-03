// ignore_for_file: file_names, depend_on_referenced_packages, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Utility/utils.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';

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
        initialIndex: controllerProduct
            .pestana, // Índice del tab que se seleccionará inicialmente (en este caso, el tab 2)
        length: controllerProduct.categoryListLength,
        vsync: this);

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
    _tabController.addListener(() async {
      print('cambio de pestalla:${_tabController.index}');
      //todo Llama a la función cuando la pestaña cambia
      controllerProduct.updatePestana(_tabController.index);
      await controllerProduct.fetchproductList(tabsID[_tabController.index]);
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
    return GetBuilder<ProductController>(builder: (controllerP) {
      return controllerP.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFFFDAE2A),
            ))
          : Padding(
              padding: const EdgeInsets.only(right: 14, left: 14),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width),
                      height: (MediaQuery.of(context).size.width) * 0.09,
                      child: TabBar(
                        isScrollable: true,
                        labelColor: const Color.fromARGB(255, 43, 44, 49),
                        indicatorColor: const Color(0xFFFDAE2A),
                        controller: _tabController,
                        tabs: tabs2,
                      ),
                    ),
                    controllerP.productListLength != -99
                        ? controllerP.isLoadingCategory == true
                            ? const Padding(
                                padding: EdgeInsets.only(top: 340),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFDAE2A),
                                ),
                              )
                            : controllerP.productListLength == 0
                                ? const Center(
                                    child: Text(
                                    'No hay Productos',
                                  ))
                                : Expanded(
                                    child: TabBarView(
                                    controller: _tabController,
                                    children: List<Widget>.generate(
                                      tabs2.length,
                                      (index) {
                                        return ListView.builder(
                                          itemCount:
                                              controllerP.productListLength,
                                          itemBuilder: (context, itemIndex) {
                                            print(
                                                'direcciones de imagenes:${controllerP.product[itemIndex].image_product}');
                                            print(
                                                'direcciones de imagenes:cantidad de productos${controllerP.product[itemIndex].product_exit}');
                                            return Column(
                                              children: [
                                                controllerP.productListLength !=
                                                            0 &&
                                                        controllerP
                                                                .productListLength >
                                                            0
                                                    ? cartProduct(
                                                        controllerP
                                                            .product[itemIndex]
                                                            .image_product,
                                                        controllerP
                                                            .product[itemIndex]
                                                            .id,
                                                        controllerProduct
                                                            .product[itemIndex]
                                                            .name,
                                                        controllerP
                                                            .product[itemIndex]
                                                            .product_exit,
                                                        controllerP
                                                            .product[itemIndex]
                                                            .description,
                                                        controllerP
                                                            .product[itemIndex]
                                                            .sale_price,
                                                        context,
                                                        controllerShoppingCart,
                                                        controllerLogin,
                                                        controllerP,
                                                        itemIndex,
                                                      )
                                                    : controllerP
                                                                .productListLength ==
                                                            0
                                                        ? const Text(
                                                            'Poca conección a internet,inténtelo nuevamente.') //mandar a cargar nuevamente los datos
                                                        : const Text(
                                                            'Poca conección a internet,inténtelo nuevamente'),
                                                SizedBox(
                                                  height:
                                                      (MediaQuery.of(context)
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
                            'Revise su conección de Internet.Vuelva a intentarlo'),
                  ],
                ),
              ),
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
      ProductController controllerP,
      itemIndex) {
    //VARIABLES DE PROPIEDADES DEL WIDGET
    const double borderRadiusValue = 12; //container que carga la imagen
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
      child: GetBuilder<ProductController>(builder: (pCont) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.26,
                  width: MediaQuery.of(context).size.width * 0.36,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadiusValue)),
                    color: Colors.white, //color de fondo
                    border: Border.all(
                      color:
                          Color.fromARGB(255, 196, 197, 197), //color del borde
                      width: 2.0, // Puedes ajustar el grosor del borde aquí
                    ),
                  ),
                  //  color: Color.fromARGB(255, 231, 233, 233)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 1, // 50% del ancho del contenedor padre
                      heightFactor: 0.65, // 50% del alto del contenedor padre
                      child: CachedNetworkImage(
                        // maxHeightDiskCache: 120,
                        // maxWidthDiskCache: 160,
                        imageUrl: '${Env.apiEndpoint}/images/$addressProduct',
                        placeholder: (context, url) => const SizedBox(
                          width: 30,
                          height: 30,
                          child: Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    2, // Personaliza el ancho del indicador como desees
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(110, 253, 176, 42)),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/product-default.png',
                          cacheWidth: 30,
                          cacheHeight: 30,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.26),
                  width: (MediaQuery.of(context).size.width * 0.40),
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
                            TruncatedText(
                              text: propertiesName,
                              maxLength: 54,
                              styleText: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(148, 0, 0, 0)),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Cantidad Disp: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(148, 0, 0, 0),
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  pCont.product[itemIndex].product_exit
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
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
                            formatNumber(priceProduct.toString()),
                            style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.height *
                                    0.024),
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2, left: 15),
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
                                          horizontal:
                                              10.0), // Ajusta el padding
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF19CF9E)),
                                    // Añadir más propiedades de estilo aquí
                                  ),
                                  onPressed: () async {
                                    if (controllerLogin.codigoQrValid() ==
                                        true) {
                                      Get.dialog(
                                        const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFFDAE2A),
                                          ),
                                        ),
                                        barrierDismissible: false,
                                      ); //Get.back();
                                      // await controllerProduct
                                      //     .buyProduct(itemIndex);

                                      // ESTE ERA EL QUE ESTABA
                                      // controllerShoppingCart
                                      //     .updateShoppingCartValue(
                                      //         priceProduct,
                                      //         tabsID[_tabController
                                      //             .index], //le paso el id d ela categoria
                                      //         controllerShoppingCart
                                      //             .carIdClienteSelect,
                                      //         'product',
                                      //         id);
                                      int categoryId =
                                          tabsID[_tabController.index];
                                      int carId = controllerShoppingCart
                                          .carIdClienteSelect!;
                                      int branchId =
                                          loginController.branchIdLoggedIn!;
                                      await controllerShoppingCart.shopProduct(
                                          priceProduct, //precio del producto
                                          carId, //id del carro
                                          id, //id del producto
                                          categoryId, //le paso el id d ela categoria
                                          branchId); //id del branch
                                      Get.back();
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
                                                Color(0xFFFDAE2A)),
                                        overlayBlur: 3,
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Center(
                                        child: Text(
                                          '  AGREGAR',
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.03),
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
        );
      }),
    );
  }
}
