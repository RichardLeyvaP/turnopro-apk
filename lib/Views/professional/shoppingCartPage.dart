// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/env.dart';
import 'package:http/http.dart' as http;

class ShoppingCartPage extends StatelessWidget {
  ShoppingCartPage({super.key});
  final double valuePadding = 12;
  final String imageDirection = 'assets/images/image_perfil.jpg';

  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();
  final ClientsScheduledController clientsController =
      Get.find<ClientsScheduledController>();
  final LoginController controllerLogin = Get.find<LoginController>();
  final ShoppingCartController shoppingCar = Get.find<ShoppingCartController>();
  void ejecutarCadaQuinceSegundos() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      // Lógica que quieres ejecutar cada 15 segundos
      print('Método ejecutado cada 15 segundos  shoppingCar.loadCart()');
      shoppingCar.loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      ejecutarCadaQuinceSegundos();
    });*/
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return Scaffold(
        appBar: AppBar(
          leading: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  pagesConfigC.previousPage();
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 50,
                  ),
                  Text(
                    'Carro de Compra',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.14),
              ),
            ],
          ),
          //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
          elevation: 0, // Quits the shadow
          //shadowColor: Colors.amber, // Removes visual elevation
        ),
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: Column(
          children: [
            controllerShoppingCart.serviceListLength > 0
                ? Text(
                    'Servicios Solicitados',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height * 0.02),
                        fontWeight: FontWeight.w900),
                  )
                : const Text(''),
            controllerShoppingCart.serviceListLength > 0
                ? Expanded(
                    flex:
                        heightFlexBody, // 85% del espacio disponible para esta parte
                    child: ListView.builder(
                        itemCount: controllerShoppingCart.serviceListLength,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                (MediaQuery.of(context).size.height * 0.013),
                                (MediaQuery.of(context).size.height * 0.006),
                                (MediaQuery.of(context).size.height * 0.013),
                                (MediaQuery.of(context).size.height * 0.006)),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                children: [
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height *
                                            0.08),
                                    width:
                                        (MediaQuery.of(context).size.width * 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(-5,
                                              5), // Ajusta los valores para personalizar la sombra
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(borderRadiusValue)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 7),
                                      child: ListTile(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        '${Env.apiEndpoint}/images/${controllerShoppingCart.selectserviceCart[index].image_service}'),
                                                    radius:
                                                        30, // Ajusta el tamaño del círculo aquí
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        controllerShoppingCart
                                                            .selectserviceCart[
                                                                index]
                                                            .nameService
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      Text(
                                                        controllerShoppingCart
                                                            .selectserviceCart[
                                                                index]
                                                            .price_service
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromARGB(
                                                                    148,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GetBuilder<
                                                          ShoppingCartController>(
                                                      builder: (_) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (controllerLogin
                                                                .codigoQrValid() ==
                                                            true) {
                                                          controllerShoppingCart
                                                              .requestDelete(
                                                                  controllerShoppingCart
                                                                      .selectserviceCart[
                                                                          index]
                                                                      .id,
                                                                  1);
                                                        } else {
                                                          Get.snackbar(
                                                            'Mensaje',
                                                            'Debe de escanear el código Qr de entrada',
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        2500),
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    118,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            showProgressIndicator:
                                                                true,
                                                            progressIndicatorBackgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    203,
                                                                    205,
                                                                    209),
                                                            progressIndicatorValueColor:
                                                                const AlwaysStoppedAnimation(
                                                                    Color(
                                                                        0xFFF18254)),
                                                            overlayBlur: 3,
                                                          );
                                                        }
                                                      },
                                                      child: _.requestDeleteOrder.contains(
                                                                  controllerShoppingCart
                                                                      .selectserviceCart[
                                                                          index]
                                                                      .id) ||
                                                              (_.idServiceCart.contains(controllerShoppingCart
                                                                      .selectserviceCart[
                                                                          index]
                                                                      .nameService) &&
                                                                  controllerShoppingCart
                                                                          .selectserviceCart[
                                                                              index]
                                                                          .request_delete ==
                                                                      1)
                                                          ? const Icon(
                                                              Icons.delete,
                                                              size: 35,
                                                              color: Color
                                                                  .fromARGB(
                                                                      105,
                                                                      139,
                                                                      137,
                                                                      136),
                                                            )
                                                          : const Icon(
                                                              Icons.delete,
                                                              size: 35,
                                                              color: Color(
                                                                  0xFFFDAE2A),
                                                            ),
                                                    );
                                                  }),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : const Text(''),
            controllerShoppingCart.productListLength > 0
                ? Text(
                    'Productos Solicitados',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height * 0.02),
                        fontWeight: FontWeight.w900),
                  )
                : const Text(''),
            controllerShoppingCart.productListLength > 0
                ? Expanded(
                    flex:
                        heightFlexBody, // 85% del espacio disponible para esta parte

                    child: ListView.builder(
                        //todo builder
                        itemCount: controllerShoppingCart.productListLength,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                (MediaQuery.of(context).size.height * 0.013),
                                (MediaQuery.of(context).size.height * 0.006),
                                (MediaQuery.of(context).size.height * 0.013),
                                (MediaQuery.of(context).size.height * 0.006)),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                children: [
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height *
                                            0.08),
                                    width:
                                        (MediaQuery.of(context).size.width * 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(-5,
                                              5), // Ajusta los valores para personalizar la sombra
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(borderRadiusValue)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 7),
                                      child: ListTile(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        '${Env.apiEndpoint}/images/${controllerShoppingCart.selectproduct[index].image_product}'),
                                                    radius:
                                                        30, // Ajusta el tamaño del círculo aquí
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        controllerShoppingCart
                                                            .selectproduct[
                                                                index]
                                                            .name
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      Text(
                                                        controllerShoppingCart
                                                            .selectproduct[
                                                                index]
                                                            .sale_price
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromARGB(
                                                                    148,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              GetBuilder<
                                                      ShoppingCartController>(
                                                  builder: (_) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (controllerLogin
                                                            .codigoQrValid() ==
                                                        true) {
                                                      controllerShoppingCart
                                                          .requestDelete(
                                                              controllerShoppingCart
                                                                  .selectproduct[
                                                                      index]
                                                                  .id,
                                                              1);
                                                    } else {
                                                      Get.snackbar(
                                                        'Mensaje',
                                                        'Debe de escanear el código Qr de entrada',
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2500),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                118,
                                                                255,
                                                                255,
                                                                255),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                205,
                                                                209),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFFDAE2A)),
                                                        overlayBlur: 3,
                                                      );
                                                    }
                                                  },
                                                  child: _.requestDeleteOrder
                                                          .contains(
                                                              controllerShoppingCart
                                                                  .selectproduct[
                                                                      index]
                                                                  .id)
                                                      ? const Icon(
                                                          Icons.delete,
                                                          size: 35,
                                                          color: Color.fromARGB(
                                                              105,
                                                              139,
                                                              137,
                                                              136),
                                                        )
                                                      : const Icon(
                                                          Icons.delete,
                                                          size: 35,
                                                          color:
                                                              Color(0xFFFDAE2A),
                                                        ),
                                                );
                                              })
                                            ],
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : const Text(''),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 3.0, bottom: 3),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.065),
                      width: (MediaQuery.of(context).size.width * 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(-5,
                                5), // Ajusta los valores para personalizar la sombra
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                            Radius.circular(borderRadiusValue)),
                      ),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        title: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total a pagar: ',
                                style: TextStyle(
                                    fontSize:
                                        (MediaQuery.of(context).size.height *
                                            0.025),
                                    fontWeight: FontWeight.w200),
                              ),
                              Text(
                                controllerShoppingCart.totalPrice
                                    .toStringAsFixed(2),
                                /*esto garantiza 2 lugares despues de la coma */
                                style: TextStyle(
                                    fontSize:
                                        (MediaQuery.of(context).size.height *
                                            0.035),
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
