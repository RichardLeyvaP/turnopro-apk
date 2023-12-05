// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';

class ModalHelper {
  static showModal(
      BuildContext context, String cliente, int reservationId) async {
    Completer<void> closedCompleter = Completer<void>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          height: 400,
          padding: const EdgeInsets.all(12.0),
          child: GetBuilder<ClientsScheduledController>(
            builder: (controllClient) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controllClient.statusClientTemporary == 1
                          ? ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 10.0),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () async {
                                //llamo al ocntrolador y lo paso attended = 2 que significa que esta ya atendido
                                await controllClient.acceptOrRejectClient(
                                    reservationId, 2);
                                Navigator.pop(context); // Cierra el modal
                              },
                              child: const Text(
                                'Cliente Atendido',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          : Text(''),
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
                  controllClient.statusClientTemporary == 1
                      ? ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 30.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFF18254)),
                          ),
                          onPressed: () async {
                            //llamo al ocntrolador y lo paso attended = 2 que significa que esta ya atendido
                            await controllClient.acceptOrRejectClient(
                                reservationId, 2);
                            Navigator.pop(context); // Cierra el modal
                          },
                          child: const Text(
                            'Añadir servicios y productos',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : Text(''),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      final ClientsScheduledController controllClient =
          Get.find<ClientsScheduledController>();
      controllClient
          .cleanselectCustomer(); //aqui le quito estilo de seleccionado
      closedCompleter.complete();
    });
    //esta no se esta utilizando pero tambien puede ser
    //await closedCompleter.future; // Espera hasta que el modal se haya cerrado
    // Puedes hacer más cosas después de que el modal se haya cerrado
    // por ejemplo: _tuOtraVariable = 'Algo';
  }
}
