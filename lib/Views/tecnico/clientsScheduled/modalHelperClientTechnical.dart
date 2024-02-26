// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsTechnical.controller.dart';

class ModalHelperTecnical {
  static showModalTechnical(PageController pageController, BuildContext context,
      String cliente, int reservationId, int carId) async {
    Completer<void> closedCompleter = Completer<void>();
    List<double> sizeExpandedService = [170, 224, 280, 336, 392];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ClientsTechnicalController>(
            builder: (controllClient) {
          //VARIABLES PARA AJUSTAR EL DESPLEGABLE DE MOSTRAR LOS DETALLES DE RESERVA
          int item = (controllClient.serviceCustomerSelected.length - 1);
          item > 4 ? item = 4 : null;

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            height: controllClient.statusClientTemporary != 1
                ? sizeExpandedService[item]
                : sizeExpandedService[item] + 52,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controllClient.statusClientTemporary == 5
                        ? ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 10.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () async {
                              //llamo al ocntrolador y lo paso attended = 11 que significa que esta ya atendido y lo mando con el profesional
                              await controllClient.acceptClientTechnical(
                                  reservationId, 11);
                              Navigator.pop(context); // Cierra el modal
                            },
                            child: const Text(
                              'Cliente Atendido',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          )
                        : const Text(
                            'Descripción de Reserva',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFF18254),
                                fontSize: 18),
                          ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context); // Cierra el modal
                        },
                        child: const CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ))),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.person),
                    Text(
                      cliente,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controllClient.serviceCustomerSelected.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.api_sharp,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  controllClient
                                      .serviceCustomerSelected[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Text(
                              'Precio: ${controllClient.serviceCustomerSelected[index].price_service}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                            Text(
                              'Duración: ${controllClient.serviceCustomerSelected[index].duration_service}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).whenComplete(() {
      final ClientsTechnicalController controllClient =
          Get.find<ClientsTechnicalController>();
      controllClient
          .cleanselectCustomerTechnical(); //aqui le quito estilo de seleccionado
      controllClient.showingServiceClientTechnical(false);
      closedCompleter.complete();
    });
    //esta no se esta utilizando pero tambien puede ser
    //await closedCompleter.future; // Espera hasta que el modal se haya cerrado
    // Puedes hacer más cosas después de que el modal se haya cerrado
    // por ejemplo: _tuOtraVariable = 'Algo';
  }
}
