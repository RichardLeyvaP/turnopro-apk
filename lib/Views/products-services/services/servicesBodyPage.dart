// ignore_for_file: file_names, unused_local_variable, dead_code

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
//import 'package:turnopro_apk/Routes/index.dart';

class ServicesBodyPage extends StatelessWidget {
  final double valuePadding = 12;
  ServicesBodyPage({super.key});
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final LoginController controllerLogin = Get.find<LoginController>();

  //bool visibleButonEliminar = false;
  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }

    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return GetBuilder<ServiceController>(builder: (_) {
      return _.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 241, 130, 84),
            ))
          : _.serviceListLength > 0
              ? Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex:
                          heightFlexBody, // 85% del espacio disponible para esta parte
                      child: ListView.builder(
                          itemCount: _.serviceListLength,
                          itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.fromLTRB(
                                    (MediaQuery.of(context).size.height *
                                        0.013),
                                    (MediaQuery.of(context).size.height *
                                        0.006),
                                    (MediaQuery.of(context).size.height *
                                        0.013),
                                    (MediaQuery.of(context).size.height *
                                        0.006)),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: _.selectService
                                                .contains(_.services[index])
                                            ? (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.153)
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.132),
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                1),
                                        decoration: _.selectService
                                                .contains(_.services[index])
                                            ? const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        borderRadiusValue)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 231, 232, 234),
                                                    Color.fromARGB(
                                                        255, 243, 182, 138),
                                                  ],
                                                  stops: [0.0, 0.8],
                                                  begin: FractionalOffset
                                                      .centerRight,
                                                  end: FractionalOffset
                                                      .centerLeft,
                                                ))
                                            : const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        borderRadiusValue)),
                                              ),
                                        child: ListTile(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          onTap: () {
                                            if (!_.selectService
                                                .contains(_.services[index])) {
                                              _.getSelectService(index);
                                              controllerShoppingCart.updateShoppingCartValue(
                                                  index,
                                                  controllerLogin
                                                      .idProfessionalLoggedIn,
                                                  'service',
                                                  _.services[index].id);
                                            }
                                          },
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _.services[index].name
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                _.services[index].price_service
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _.services[index].type_service
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        148, 0, 0, 0)),
                                              ),
                                              SizedBox(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03),
                                              ),
                                              LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Container(
                                                    height:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.008),
                                                    width: constraints.maxWidth,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 231, 232, 234),
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              borderRadiusValue)),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                (_
                                                                        .services[
                                                                            index]
                                                                        .duration_service /
                                                                    6) /
                                                                10, //TODO AQUI CALCULA PARA QUE PINTE EL CONTAINER-RESPECTO-TIEMPO
                                                            decoration:
                                                                const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            borderRadiusValue)),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Color.fromARGB(
                                                                            255,
                                                                            231,
                                                                            232,
                                                                            234),
                                                                        Color.fromARGB(
                                                                            255,
                                                                            241,
                                                                            130,
                                                                            84),
                                                                      ],
                                                                      stops: [
                                                                        0.0,
                                                                        0.8
                                                                      ],
                                                                      begin: FractionalOffset
                                                                          .centerLeft,
                                                                      end: FractionalOffset
                                                                          .centerRight,
                                                                    ))),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(Icons.timer,
                                                      color: Colors.black,
                                                      size: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height *
                                                          0.016)),
                                                  Text(
                                                    '${_.services[index].duration_service} Minutos',
                                                    style: const TextStyle(
                                                      height: 1.0,
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          180, 0, 0, 0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _.selectService
                                            .contains(_.services[index]),
                                        child: Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.14),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.16),
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 241, 130, 84),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      borderRadiusValue))),
                                          child: IconButton(
                                            onPressed: () {
                                              Get.snackbar(
                                                'Mensaje',
                                                'Fue notificado al responsable,espere confirmación.',
                                                duration: const Duration(
                                                    milliseconds: 2500),
                                              );
                                              _.sentServiceDelet(index);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                    ),
                    Expanded(
                      //ESTE EXPANDED ES EL QUE TIENE EL TOTAL A PAGAR
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            valuePadding, 0, valuePadding, 0),
                        //const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total a pagar:',
                              style: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).size.height *
                                          0.02),
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              controllerShoppingCart.getTotalServices
                                  .toStringAsFixed(2),
                              /*esto garantiza 2 lugares despues de la coma */
                              style: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).size.height *
                                          0.031),
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_backpack_outlined),
                        Text('No hay servicios'),
                      ],
                    ),
                  ],
                ));
    });
  }
}
