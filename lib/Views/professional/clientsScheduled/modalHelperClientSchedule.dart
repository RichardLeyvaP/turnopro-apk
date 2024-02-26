// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:turnopro_apk/Controllers/login.controller.dart';

final LoginController loginController = Get.find<LoginController>();

class ModalHelper {
  static showModal(PageController pageController, BuildContext context,
      String cliente, int reservationId, int carId) async {
    Completer<void> closedCompleter = Completer<void>();
    List<double> sizeExpandedService = [];
    if (loginController.androidInfoDisplay! >= 6.6) {
      sizeExpandedService = [170, 224, 280, 336, 392];
    } else {
      sizeExpandedService = [224, 280, 336, 392, 448];
    }

    // Declarar un controlador fuera del método
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ClientsScheduledController>(
            builder: (controllClient) {
          //VARIABLES PARA AJUSTAR EL DESPLEGABLE DE MOSTRAR LOS DETALLES DE RESERVA
          int item = (controllClient.serviceCustomerSelectedForm.length - 1);
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
                    controllClient.statusClientTemporary == 11 ||
                            controllClient.statusClientTemporary == 1 ||
                            controllClient.statusClientTemporary == 111
                        ? Row(
                            children: [
                              ElevatedButton(
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
                                  //todo mandar estos valores para acabar servicio
                                  // await controllClient.acceptOrRejectClient(
                                  //     reservationId, 2);
                                  // Navigator.pop(context); // Cierra el modal
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GetBuilder<
                                              ClientsScheduledController>(
                                          builder: (_) {
                                        return AlertDialog(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Comentario',
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context, 'Cerrar');
                                                  },
                                                  child: Icon(Icons.close))
                                            ],
                                          ),
                                          content: SizedBox(
                                            width: 110,
                                            height: 280,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: TextFormField(
                                                          controller:
                                                              commentController, // Asignar el controlador al TextFormField
                                                          maxLines: 4,
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Escribe tu comentario aquí...',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.camera),
                                                          Text(
                                                              'Foto al cliente...'),
                                                        ],
                                                      ),
                                                      (_.imagePath == null)
                                                          ? Container()
                                                          : SizedBox(
                                                              width:
                                                                  100, // Establece el ancho deseado
                                                              height:
                                                                  100, // Establece la altura deseada
                                                              child: Image.file(
                                                                File(_
                                                                    .imagePath!),
                                                                fit: BoxFit
                                                                    .cover, // Puedes ajustar el modo de ajuste según tus necesidades
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                          // Botón de aceptar
                                          actions: [
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     // Lógica para cancelar

                                            //     Navigator.pop(
                                            //         context, 'Cerrar');
                                            //     print('Comentario cancelado');
                                            //   },
                                            //   style: ElevatedButton.styleFrom(
                                            //       backgroundColor:
                                            //           Colors.black),
                                            //   child: const Text('Cancelar'),
                                            // ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final ImagePicker _picker =
                                                    ImagePicker();
                                                _.setPickedFile(
                                                    await _picker.pickImage(
                                                  source: ImageSource.camera,
                                                ));

                                                // Verifica si pickedFile no es nulo antes de acceder a su propiedad path
                                                if (_.pickedFile != null) {
                                                  _.setImagePath(
                                                      _.pickedFile!.path);
                                                }
                                                print(
                                                    'DIRECCIONDELAIMAGEN : ${_.imagePath}');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                              ),
                                              child: const Text(
                                                'Tomar Foto',
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                              ),
                                              onPressed: () async {
                                                // Lógica para enviar el comentario
                                                // Obtener el valor del campo de texto
                                                String commentText =
                                                    commentController.text;
                                                // Eliminar espacios en blanco al principio y al final
                                                String textWithoutSpaces =
                                                    commentText.trim();

                                                // Verificar que el campo no esté vacío
                                                if (textWithoutSpaces
                                                    .isNotEmpty) {
                                                  // Cerrar el primer modal
                                                  Navigator.pop(context);

                                                  // Cerrar el segundo modal (AlertDialog)
                                                  Navigator.pop(context);

                                                  if (_.pickedFile != null) {
                                                    dio.Dio dioClient =
                                                        dio.Dio();
                                                    String imag =
                                                        _.pickedFile!.path;

                                                    await controllClient
                                                        .storeByReservationId(
                                                            imag,
                                                            reservationId,
                                                            commentText,
                                                            dioClient);
                                                  }

                                                  // Lógica para enviar el comentario
                                                  await controllClient
                                                      .acceptOrRejectClient(
                                                          reservationId, 2);

                                                  print(
                                                      'Comentario enviado - $commentText ');
                                                } else {
                                                  // El campo de texto está vacío, puedes mostrar un mensaje o realizar alguna acción
                                                  print(
                                                      'El comentario no puede estar vacío');
                                                }
                                              },
                                              child: const Text('Subir'),
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                  );

                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                },
                                child: const Text(
                                  'Cliente Atendido',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
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
                                      reservationId, 4);
                                  Navigator.pop(context); // Cierra el modal
                                },
                                child: const Text(
                                  'Enviar al Técnico',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              )
                            ],
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
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        controllClient.serviceCustomerSelectedForm.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
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
                                        .serviceCustomerSelectedForm[index]
                                        .name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Precio: ${controllClient.serviceCustomerSelectedForm[index].price_service}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    'Duración: ${controllClient.serviceCustomerSelectedForm[index].duration_service}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                controllClient.statusClientTemporary == 11 ||
                        controllClient.statusClientTemporary == 111
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
                          await controllClient.watchModifyTime(reservationId);
                          // Cierra el modal primero
                          Navigator.pop(context);
                          //luego llamo a la pagina de servicios y productos
                          /*Get.toNamed(
                            '/servicesProductsPage',
                          );*/
                          pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text(
                          'Añadir servicios y productos',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      )
                    : Text(''),
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
                          await controllClient.watchModifyTime(reservationId);
                          // Cierra el modal primero
                          Navigator.pop(context);
                          //luego llamo a la pagina de servicios y productos
                          /*Get.toNamed(
                            '/servicesProductsPage',
                          );*/
                          pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text(
                          'Servicios y productos',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      )
                    : Text(''),
              ],
            ),
          );
        });
      },
    ).whenComplete(() async {
      final ClientsScheduledController controllClient =
          Get.find<ClientsScheduledController>();
      controllClient
          .cleanselectCustomer(); //aqui le quito estilo de seleccionado
      controllClient.showingServiceClient(false);
      closedCompleter.complete();
    });
    //esta no se esta utilizando pero tambien puede ser
    //await closedCompleter.future; // Espera hasta que el modal se haya cerrado
    // Puedes hacer más cosas después de que el modal se haya cerrado
    // por ejemplo: _tuOtraVariable = 'Algo';
  }
}
