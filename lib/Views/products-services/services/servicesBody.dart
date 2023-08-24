// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/servicesBody_Controller.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

class ServicesBody extends StatefulWidget {
  const ServicesBody({super.key});

  @override
  State<ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<ServicesBody> {
  final servicesBodyController controller = Get.put(servicesBodyController());
  double totalPay = 0.0;
  double valuePadding = 12;
  bool visibleButonEliminar = false;

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }

    return Column(
      children: [
        Expanded(
          flex: heightFlexBody, // 85% del espacio disponible para esta parte
          child: ListView.builder(
            itemCount: controller.containerDataList.length,
            itemBuilder: (BuildContext context, int index) {
              final data = controller.containerDataList[index];
              return Obx(() => InkWell(
                    onTap: () {
                      data.selectedProductDelete.value =
                          !data.selectedProductDelete.value;
                      // Actualizar el estado de selección al hacer clic

                      //SELECCIONAR DE LA LISTA
                    },
                    child: (
                      double valuePadding,
                      BuildContext context,
                      String titleService,
                      String descriptionService,
                      int price,
                      int time,
                      totalPay,
                    ) {
                      //DECLARANDO VARIABLES A UTILIZAR EN EL WIDGET
                      final isSelected = data
                          .selectedProductDelete.value; // Estado de selección
                      const double borderRadiusValue = 12;
                      double valueProgressBar = (time / 6) / 10;
                      //VALIDACION SI SELECCIONA QUE DEGRADE EL CONTAINER
                      BoxDecoration? decoration = isSelected
                          ? const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(borderRadiusValue)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 231, 232, 234),
                                  Color.fromARGB(255, 243, 182, 138),
                                ],
                                stops: [0.0, 0.8],
                                begin: FractionalOffset.centerRight,
                                end: FractionalOffset.centerLeft,
                              ))
                          : const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(borderRadiusValue)),
                            );

                      //VALIDACION PARA AUMENTARLE EL TAMAÑO AL CONTAINER E IGUALARLO A LOS DEMAS
                      double containerHeight = isSelected
                          ? (MediaQuery.of(context).size.height * 0.183)
                          : (MediaQuery.of(context).size.height * 0.16);
                      //VALIDACION PARA AUMENTARLE Padding TAMAÑO AL CONTAINER E IGUALARLO A LOS DEMAS
                      double containerPadding = isSelected
                          ? (MediaQuery.of(context).size.height * 0.013)
                          : (MediaQuery.of(context).size.height *
                              0.017); // Define los tamaños en función de la variable delete

                      //Creando estructura visual
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                            containerPadding,
                            (MediaQuery.of(context).size.height * 0.006),
                            containerPadding,
                            (MediaQuery.of(context).size.height * 0.006)),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            children: [
                              Container(
                                height: containerHeight,
                                width:
                                    (MediaQuery.of(context).size.width * 0.95),
                                decoration: decoration,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(valuePadding, 1,
                                      valuePadding, valuePadding - 4),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Corte Normal en Negrita
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            titleService,
                                            style: TextStyle(
                                                fontSize:
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.022),
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Text(
                                            '$price.000',
                                            style: TextStyle(
                                                fontSize:
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03),
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                      //Corte normal mas pequeño y al lado el precio
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            descriptionService,
                                            style: TextStyle(
                                                fontSize:
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.017)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.042),
                                      ),
                                      Container(
                                        height: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.008),
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                1),
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 231, 232, 234),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    borderRadiusValue))),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.topLeft,
                                          widthFactor:
                                              valueProgressBar, // La mitad del ancho del padre
                                          heightFactor:
                                              1.0, // Mismo alto que el padre
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          borderRadiusValue)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 231, 232, 234),
                                                      Color.fromARGB(
                                                          255, 241, 130, 84),
                                                    ],
                                                    stops: [0.0, 0.8],
                                                    begin: FractionalOffset
                                                        .centerLeft,
                                                    end: FractionalOffset
                                                        .centerRight,
                                                  ))),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.timer,
                                              color: Colors.black,
                                              size: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.016)),
                                          Text(
                                            '$time Minutos',
                                            style: TextStyle(
                                                fontSize:
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.014),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isSelected,
                                child: Container(
                                  height: containerHeight,
                                  width: (MediaQuery.of(context).size.width *
                                      0.16),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 241, 130, 84),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(borderRadiusValue))),
                                  child: IconButton(
                                    onPressed: () {
                                      Get.snackbar(
                                        'Mensaje',
                                        'Eliminando a $titleService',
                                        duration:
                                            const Duration(milliseconds: 2500),
                                        showProgressIndicator: true,
                                        progressIndicatorBackgroundColor:
                                            const Color.fromARGB(
                                                255, 81, 93, 117),
                                        progressIndicatorValueColor:
                                            const AlwaysStoppedAnimation(
                                                Color.fromARGB(
                                                    255, 241, 130, 84)),
                                        overlayBlur: 3,
                                      );
                                      // controller.containerDataList.removeAt(index);
                                      //containerDataList.removeAt(index);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size:
                                          (MediaQuery.of(context).size.height *
                                              0.04),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }(
                      12, // Tamaño del padding
                      context,
                      data.titleService,
                      data.descriptionService,
                      data.price,
                      data.time,
                      totalPay,
                    ),
                  ));
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(valuePadding, 0, valuePadding, 0),
            //const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a pagar:',
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.height * 0.02),
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  '${controller.getTotalSum()}' '00',
                  style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.height * 0.031),
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
