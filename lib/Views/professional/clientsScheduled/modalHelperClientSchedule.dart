// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsScheduled.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/env.dart';

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
    String imageDirection =
        '${Env.apiEndpoint}/images/professional/ejemplo1.jpg';

    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return GetBuilder<ClientsScheduledController>(
    //         builder: (controllClient) {
    //       //VARIABLES PARA AJUSTAR EL DESPLEGABLE DE MOSTRAR LOS DETALLES DE RESERVA
    //       int item = (controllClient.serviceCustomerSelectedForm.length - 1);
    //       item > 4 ? item = 4 : null;

    //       return Container(
    //         decoration: const BoxDecoration(
    //           color: Colors.white,
    //         ),
    //         height: controllClient.statusClientTemporary != 1
    //             ? sizeExpandedService[item]
    //             : sizeExpandedService[item] + 52,
    //         padding: const EdgeInsets.all(12.0),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 controllClient.statusClientTemporary == 11 ||
    //                         controllClient.statusClientTemporary == 1 ||
    //                         controllClient.statusClientTemporary == 111
    //                     ? Row(
    //                         children: [
    //
    //
    //                           const SizedBox(
    //                             width: 10,
    //                           ),
    //
    //                         ],
    //                       )
    //                     : const Text(
    //                         'Descripción de Reserva',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w800,
    //                             color: Color(0xFFF18254),
    //                             fontSize: 18),
    //                       ),
    //                 InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context); // Cierra el modal
    //                     },
    //                     child: const CircleAvatar(
    //                         backgroundColor: Colors.black,
    //                         child: Icon(
    //                           Icons.close,
    //                           color: Colors.white,
    //                         ))),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 const Icon(Icons.person),
    //                 Text(
    //                   cliente,
    //                   style: const TextStyle(
    //                       fontWeight: FontWeight.w800, fontSize: 18),
    //                 ),
    //               ],
    //             ),
    //             Expanded(
    //               child: ListView.builder(
    //                 itemCount:
    //                     controllClient.serviceCustomerSelectedForm.length,
    //                 itemBuilder: (context, index) => Row(
    //                   children: [
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.only(left: 10),
    //                           child: Row(
    //                             children: [
    //                               const Icon(
    //                                 Icons.api_sharp,
    //                                 size: 12,
    //                               ),
    //                               const SizedBox(
    //                                 width: 5,
    //                               ),
    //                               Text(
    //                                 controllClient
    //                                     .serviceCustomerSelectedForm[index]
    //                                     .name,
    //                                 style: const TextStyle(
    //                                     fontWeight: FontWeight.w700),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.only(left: 30),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Text(
    //                                 'Precio: ${controllClient.serviceCustomerSelectedForm[index].price_service}',
    //                                 style: const TextStyle(
    //                                     fontWeight: FontWeight.w300,
    //                                     fontSize: 12),
    //                               ),
    //                               Text(
    //                                 'Duración: ${controllClient.serviceCustomerSelectedForm[index].duration_service}',
    //                                 style: const TextStyle(
    //                                     fontWeight: FontWeight.w300,
    //                                     fontSize: 12),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             controllClient.statusClientTemporary == 11 ||
    //                     controllClient.statusClientTemporary == 111
    //                 ? ElevatedButton(
    //                     style: ButtonStyle(
    //                       padding:
    //                           MaterialStateProperty.all<EdgeInsetsGeometry>(
    //                         const EdgeInsets.symmetric(
    //                             vertical: 10.0, horizontal: 30.0),
    //                       ),
    //                       backgroundColor: MaterialStateProperty.all<Color>(
    //                           const Color(0xFFF18254)),
    //                     ),
    //                     onPressed: () async {
    //                       await controllClient.watchModifyTime(reservationId);
    //                       // Cierra el modal primero
    //                       Navigator.pop(context);
    //                       //luego llamo a la pagina de servicios y productos
    //                       /*Get.toNamed(
    //                         '/servicesProductsPage',
    //                       );*/
    //                       pageController.nextPage(
    //                         duration: Duration(milliseconds: 300),
    //                         curve: Curves.ease,
    //                       );
    //                     },
    //                     child: const Text(
    //                       'Añadir servicios y productos',
    //                       style: TextStyle(
    //                           color: Colors.white, fontWeight: FontWeight.w700),
    //                     ),
    //                   )
    //                 : Text(''),
    //             controllClient.statusClientTemporary == 1
    //                 ? ElevatedButton(
    //                     style: ButtonStyle(
    //                       padding:
    //                           MaterialStateProperty.all<EdgeInsetsGeometry>(
    //                         const EdgeInsets.symmetric(
    //                             vertical: 10.0, horizontal: 30.0),
    //                       ),
    //                       backgroundColor: MaterialStateProperty.all<Color>(
    //                           const Color(0xFFF18254)),
    //                     ),
    //                     onPressed: () async {
    //                       await controllClient.watchModifyTime(reservationId);
    //                       // Cierra el modal primero
    //                       Navigator.pop(context);
    //                       //luego llamo a la pagina de servicios y productos
    //                       /*Get.toNamed(
    //                         '/servicesProductsPage',
    //                       );*/
    //                       pageController.nextPage(
    //                         duration: Duration(milliseconds: 300),
    //                         curve: Curves.ease,
    //                       );
    //                     },
    //                     child: const Text(
    //                       'Servicios y productos',
    //                       style: TextStyle(
    //                           color: Colors.white, fontWeight: FontWeight.w700),
    //                     ),
    //                   )
    //                 : Text(''),
    //           ],
    //         ),
    //       );
    //     });
    //   },
    // ).whenComplete(() async {
    //   final ClientsScheduledController controllClient =
    /*   Get.find<ClientsScheduledController>();
      controllClient
          .cleanselectCustomer(); //aqui le quito estilo de seleccionado
      controllClient.showingServiceClient(false);
      closedCompleter.complete();
    });*/
    //esta no se esta utilizando pero tambien puede ser
    //await closedCompleter.future; // Espera hasta que el modal se haya cerrado
    // Puedes hacer más cosas después de que el modal se haya cerrado
    // por ejemplo: _tuOtraVariable = 'Algo';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return GetBuilder<ClientsScheduledController>(
            builder: (controllClient) {
          return Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 130, 84),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '   Cliente',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context); // Cierra el modal
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          weight: VisualDensity.maximumDensity,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12, top: 12, left: 12, bottom: 20),
                child: Container(
                  height: (MediaQuery.of(context).size.height * 0.075),
                  width: (MediaQuery.of(context).size.width * 0.95),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 223, 221, 221),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(imageDirection),
                                radius: 28, // Ajusta el tamaño del círculo aquí
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controllClient.nameClientTemporary,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        80, // Ajusta la altura según sea necesario
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          167, 241, 131, 84),
                                      borderRadius: BorderRadius.circular(
                                          3), // La mitad de la altura para hacerlo circular
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'FRECUENTE',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Agrega un contenedor para alinear el icono al centro verticalmente

                              ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Ajusta el valor según sea necesario
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal:
                                              10.0), // Ajusta el padding
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    side: MaterialStateProperty.all<BorderSide>(
                                      const BorderSide(
                                          color:
                                              Color.fromARGB(167, 241, 131, 84),
                                          width:
                                              2.0), // Ajusta el grosor del borde según sea necesario
                                    ),
                                    // Añadir más propiedades de estilo aquí
                                  ),
                                  onPressed: () async {
                                    await controllClient
                                        .watchModifyTime(reservationId);
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
                                    'VER CARRITO',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Color.fromARGB(167, 241, 131, 84),
                                        fontWeight: FontWeight.w800),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      subtitle: null,
                    ),
                  ),
                ),
              ),
              controllClient.statusClientTemporary == 11 ||
                      controllClient.statusClientTemporary == 1 ||
                      controllClient.statusClientTemporary == 111
                  ? ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF2B3141)),
                          ),
                          onPressed: () async {
                            //llamo al ocntrolador y lo paso attended = 2 que significa que esta ya atendido
                            await controllClient.acceptOrRejectClient(
                                reservationId, 4);
                            Navigator.pop(context); // Cierra el modal
                          },
                          child: Row(
                            children: [
                              const Text(
                                'ENVIAR AL TÉCNICO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              Icon(
                                MdiIcons.sendCircleOutline,
                                color: Colors.white,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                        //
                        //
                        //
                        //
                        //
                        ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF2B3141)),
                          ),
                          onPressed: () async {
                            // llamo al ocntrolador y lo paso attended = 2 que significa que esta ya atendido
                            // //todo mandar estos valores para acabar servicio
                            // await controllClient.acceptOrRejectClient(
                            //     reservationId, 2);
                            // Navigator.pop(context); // Cierra el modal

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GetBuilder<ClientsScheduledController>(
                                    builder: (_) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ), //this right here
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 241, 130, 84),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 12),
                                                child: Text(
                                                  'Comentario',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height:
                                              (_.imagePath == null) ? 230 : 300,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                ),
                                                child: TextFormField(
                                                  controller: commentController,
                                                  maxLines: 5,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        'Escribe tu comentario aquí...',
                                                    hintStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          120, 241, 131, 84),
                                                    ), // Cambiar el color del hintText
                                                  ),
                                                ),
                                              ),
                                              //
                                              //
                                              //

                                              (_.imagePath == null)
                                                  ? const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons
                                                            .image_outlined),
                                                        Text(
                                                          'Cargar foto del cliente',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(
                                                      width:
                                                          70, // Establece el ancho deseado
                                                      height:
                                                          70, // Establece la altura deseada
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), // Establece el radio de borde deseado
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), // Asegúrate de que este radio sea igual al radio del borde del BoxDecoration
                                                        child: Image.file(
                                                          File(_.imagePath!),
                                                          fit: BoxFit
                                                              .cover, // Puedes ajustar el modo de ajuste según tus necesidades
                                                        ),
                                                      ),
                                                    ),

                                              //
                                              //
                                              //
                                              //
                                              ButtonBar(
                                                alignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: <Widget>[
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty.all<
                                                              EdgeInsetsGeometry>(
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 0,
                                                            horizontal: 26.0),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color(
                                                                  0xFF2B3141)),
                                                    ),
                                                    onPressed: () async {
                                                      final ImagePicker
                                                          _picker =
                                                          ImagePicker();
                                                      _.setPickedFile(
                                                          await _picker
                                                              .pickImage(
                                                        source:
                                                            ImageSource.camera,
                                                      ));

                                                      // Verifica si pickedFile no es nulo antes de acceder a su propiedad path
                                                      if (_.pickedFile !=
                                                          null) {
                                                        _.setImagePath(
                                                            _.pickedFile!.path);
                                                      }
                                                      print(
                                                          'DIRECCIONDELAIMAGEN : ${_.imagePath}');
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'FOTO',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Icon(
                                                          MdiIcons.camera,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty.all<
                                                              EdgeInsetsGeometry>(
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 0,
                                                            horizontal: 26.0),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color(
                                                                  0xFF2B3141)),
                                                    ),
                                                    onPressed: () async {
                                                      // Lógica para enviar el comentario
                                                      // Obtener el valor del campo de texto
                                                      String commentText =
                                                          commentController
                                                              .text;
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

                                                        if (_.pickedFile !=
                                                            null) {
                                                          dio.Dio dioClient =
                                                              dio.Dio();
                                                          String imag = _
                                                              .pickedFile!.path;

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
                                                                reservationId,
                                                                2);

                                                        print(
                                                            'Comentario enviado - $commentText ');
                                                      } else {
                                                        // El campo de texto está vacío, puedes mostrar un mensaje o realizar alguna acción
                                                        print(
                                                            'El comentario no puede estar vacío');
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'ENVIAR',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Icon(
                                                          MdiIcons.send,
                                                          color: Colors.white,
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
                            ).whenComplete(() async {
                              final ClientsScheduledController cliCont =
                                  Get.find<ClientsScheduledController>();
                              cliCont.setImagePath(null);
                              closedCompleter.complete();
                            });

                            //
                            //
                            //
                          },
                          child: Row(
                            children: [
                              const Text(
                                'CLIENTE ATENDIDO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              Icon(
                                MdiIcons.stopCircleOutline,
                                color: Colors.white,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          );
        });
      },
    );
  }
}
