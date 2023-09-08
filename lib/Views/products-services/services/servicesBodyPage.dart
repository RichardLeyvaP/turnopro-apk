// ignore_for_file: file_names, unused_local_variable, dead_code

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class ServicesBodyPage extends StatelessWidget {
  // final ServiceController controller = Get.put(ServiceController());

  final double valuePadding = 12;
  const ServicesBodyPage({super.key});

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
                    Visibility(
                        visible: /* _.selectService.length */ 1 == 1,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (_.selectService.isEmpty) {
                                      Get.snackbar(
                                        'Alerta!',
                                        'NO HAY SERVICIOS SELECCIONADOS',
                                        backgroundColor: const Color.fromARGB(
                                            61, 255, 238, 0),
                                        duration:
                                            const Duration(milliseconds: 2000),
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Mensaje',
                                        'ElIMINANDO CORRECTAMENTE',
                                        backgroundColor: const Color.fromARGB(
                                            95, 255, 17, 0),
                                        duration:
                                            const Duration(milliseconds: 2000),
                                      );
                                      _.deleteMultipleService();
                                    }
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'Eliminar Seleccionados',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    Get.snackbar(
                                      'Mensaje',
                                      'ELIMINADOS TODOS',
                                      backgroundColor:
                                          const Color.fromARGB(95, 255, 17, 0),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                    );
                                    _.deleteAll();
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'Eliminar Todos',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    Get.snackbar(
                                      'Mensaje',
                                      'INSERTADO CORRECTAMENTE',
                                      backgroundColor:
                                          const Color.fromARGB(92, 11, 226, 22),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                    );
                                    _.addService();
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        'Adicionar Servicio',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )),
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
                                            _.getSelectService(index);
                                          },
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_.services[index].name
                                                  .toString()),
                                              Text(
                                                '15.000',
                                                style: TextStyle(
                                                    fontSize:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(_.services[index].username
                                                  .toString()),
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
                                                                (_.time / 6) /
                                                                10, // Ocupa el 50% del ancho del contenedor padre
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
                                                    '15 Minutos',
                                                    style: TextStyle(
                                                        fontSize:
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.014),
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                                'ElIMINANDO CORRECTAMENTE',
                                                _.services[index].name
                                                    .toString(),
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                              );
                                              _.deleteService(index);
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
                              '${_.getTotal}' '00',
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
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_backpack_outlined),
                        Text('No hay servicios'),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Get.snackbar(
                            'Mensaje',
                            'INSERTADO CORRECTAMENTE',
                            backgroundColor:
                                const Color.fromARGB(92, 11, 226, 22),
                            duration: const Duration(milliseconds: 2000),
                          );
                          _.addService();
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            Text(
                              'Adicionar Servicio',
                              style: TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                  ],
                ));
    });
  }
}