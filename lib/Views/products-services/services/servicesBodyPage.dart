// ignore_for_file: file_names, unused_local_variable, dead_code

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/env.dart';
//import 'package:turnopro_apk/Routes/index.dart';

class ServicesBodyPage extends StatefulWidget {
  const ServicesBodyPage({super.key});

  @override
  State<ServicesBodyPage> createState() => _ServicesBodyPageState();
}

class _ServicesBodyPageState extends State<ServicesBodyPage> {
  final double valuePadding = 12;

  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();

  final LoginController controllerLogin = Get.find<LoginController>();
  final ClientsScheduledController clientsController =
      Get.find<ClientsScheduledController>();

  //bool visibleButonEliminar = false;
  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 24;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }

    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return GetBuilder<ServiceController>(builder: (_) {
      return _.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFFFDAE2A),
            ))
          : _.serviceListLength > 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex:
                                    heightFlexBody, // 85% del espacio disponible para esta parte
                                child: ListView.builder(
                                    shrinkWrap:
                                        true, // Ajustar al tamaño de su contenido
                                    itemCount: _.serviceListLength,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.0006),
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.006)),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1),
                                                decoration: ((_.selectService
                                                                .contains(_.services[
                                                                    index])) ||
                                                            (controllerShoppingCart
                                                                .idServiceCart
                                                                .contains(_
                                                                    .services[
                                                                        index]
                                                                    .name))) ||
                                                        (_.selectServiceNew.contains(
                                                            _.services[index]))
                                                    ? const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    borderRadiusValue)),
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Colors.white,
                                                            Color(0xFFFDAE2A),
                                                          ],
                                                          stops: [0.0, 0.8],
                                                          begin:
                                                              FractionalOffset
                                                                  .centerRight,
                                                          end: FractionalOffset
                                                              .centerLeft,
                                                        ))
                                                    : const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 231, 232, 234),
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                borderRadiusValue)),
                                                      ),
                                                child: ListTile(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  onTap: () async {
                                                    if (controllerLogin
                                                            .codigoQrValid() ==
                                                        true) {
                                                      if (!_.selectService
                                                              .contains(
                                                                  _.services[
                                                                      index]) &&
                                                          !(controllerShoppingCart
                                                              .idServiceCart
                                                              .contains(_
                                                                  .services[
                                                                      index]
                                                                  .name))) {
                                                        _.getSelectServiceNew(
                                                            _.services[index]);

                                                        //MENSAJE DE CONFIRMACION SI DESEA REALMENTE AGREGAR UN SERVICIO
                                                        /* showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return GetBuilder<
                                                                    LoginController>(
                                                                builder: (cv) {
                                                              return Dialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ), //this right here
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xFFFDAE2A),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(8),
                                                                          topRight:
                                                                              Radius.circular(8),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <Widget>[
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 12),
                                                                            child:
                                                                                Text(
                                                                              'Confirmación',
                                                                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.close, color: Colors.white),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          150,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Padding(
                                                                              padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
                                                                              child: Text('Deseas agregar este servicio?')),
                                                                          //

                                                                          ButtonBar(
                                                                            alignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                                                    const EdgeInsets.symmetric(vertical: 0, horizontal: 26.0),
                                                                                  ),
                                                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFF6750)),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  // Lógica para enviar el comentario

                                                                                  // Cerrar el primer modal
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      MdiIcons.cancel,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    const Text(
                                                                                      'Cancelar',
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                                                    const EdgeInsets.symmetric(vertical: 0, horizontal: 26.0),
                                                                                  ),
                                                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF19CF9E)),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  int resulButton = 0;
                                                                                  //verificar que solo le de una sola vez
                                                                                  resulButton = controllerLogin.handleButtonClickService(_.services[index].id);
                                                                                  if (resulButton == 1) {
                                                                                    //todo aqui poner logica de seleccionar servicio
                                                                                    _.getSelectService(index); //guarda en la lista de los seleccionados
                                                                                    controllerShoppingCart.updateShoppingCartValueSer(
                                                                                        _.services[index].price_service, //aqui 0 porque este campo solo lo utilizo si fuera un producto
                                                                                        _.services[index].id,
                                                                                        controllerShoppingCart.carIdClienteSelect,
                                                                                        'service',
                                                                                        _.services[index].name);
                                                                                    //AQUI ESTOY MANDANDO EN SEGUNDO EL TIEMPO QUE HAY QUE AGREGARLE AL TIMER
                                                                                    //todo este codigo aqui esta sumando y sumando el tiempo al agregar servicio
                                                                                    print('tiempo a sumar = :${_.services[index].duration_service}');
                                                                                    clientsController.modifingTime((_.services[index].duration_service));

                                                                                    // Cerrar el primer modal
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      MdiIcons.checkCircleOutline,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    const Text(
                                                                                      '  Aceptar  ',
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        );
                                                     */
                                                      }
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
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromARGB(
                                                                          120,
                                                                          190,
                                                                          190,
                                                                          189),
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          '${Env.apiEndpoint}/images/${_.services[index].image_service}'),
                                                                  radius:
                                                                      20, // Ajusta el tamaño del círculo aquí
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          _.services[index]
                                                                              .name
                                                                              .toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                const Color(0xFF2B3141),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          _.services[index]
                                                                              .type_service
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: const Color(0xFF2B3141)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              _.services[index]
                                                                  .price_service
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: const Color(
                                                                      0xFF2B3141)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                return Container(
                                                                  height: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.008),
                                                                  width: constraints
                                                                      .maxWidth,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            231,
                                                                            232,
                                                                            234),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(borderRadiusValue)),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                          width:
                                                                              constraints.maxWidth * (_.services[index].duration_service / controllerLogin.serviceTime), //TODO AQUI CALCULA PARA QUE PINTE EL CONTAINER-RESPECTO-TIEMPO
                                                                          decoration: const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
                                                                              gradient: LinearGradient(
                                                                                colors: [
                                                                                  Colors.white,
                                                                                  Color(0xFFFDAE2A),
                                                                                ],
                                                                                stops: [
                                                                                  0.0,
                                                                                  0.8
                                                                                ],
                                                                                begin: FractionalOffset.centerLeft,
                                                                                end: FractionalOffset.centerRight,
                                                                              ))),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Icon(
                                                                    Icons.timer,
                                                                    color: Color(
                                                                        0xFFFDAE2A),
                                                                    size: (MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.016)),
                                                                Text(
                                                                  '${_.services[index].duration_service} Minutos',
                                                                  style: const TextStyle(
                                                                      height:
                                                                          1.0,
                                                                      fontSize:
                                                                          10,
                                                                      color: Color(
                                                                          0xFFFDAE2A),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              //todo este era el que decia abajo total a pagar
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: 2000,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GetBuilder<ShoppingCartController>(
                                    builder: (shpCont) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8.0),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color(0xFF4470F3),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Radio de los bordes
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      int resp = await shpCont
                                          .updateShoppingCartValueSerNew(
                                              _.selectServiceNew);
                                      if (resp == 1) {
                                        String s = '';
                                        if (_.selectServiceNew.length > 1) {
                                          s = 's';
                                        }
                                        print(
                                            'memsj perfecto agregado los servicios');
                                        Get.snackbar(
                                          'Mensaje',
                                          'Servicio$s agregado$s correctamente',
                                          duration: const Duration(
                                              milliseconds: 2500),
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
                                        _.clearSelectServiceNew();
                                      } else {
                                        print(
                                            'memsj problemas al agregar servicios');
                                      }
                                    },
                                    child: const Text(
                                      '     CONFIRMAR     ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ))
                    ],
                  ),
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
