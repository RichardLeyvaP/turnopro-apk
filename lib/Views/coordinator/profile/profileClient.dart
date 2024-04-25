// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/env.dart';

import '../../../Controllers/clientsScheduled.controller.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileClient extends StatefulWidget {
  const ProfileClient({super.key});

  @override
  State<ProfileClient> createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  TextEditingController commentController = TextEditingController();
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final ClientsScheduledController clientSchedControl =
      Get.find<ClientsScheduledController>();
  final ClientsCoordinatorController clientCoordControl =
      Get.find<ClientsCoordinatorController>();
  final LoginController loginControl = Get.find<LoginController>();

  int cantVisitas = 3;

  String title = 'Servicios';
  Icon icon = Icon(
    MdiIcons.tag,
    color: const Color.fromARGB(211, 0, 0, 0),
  );
  Icon iconService = Icon(
    MdiIcons.server,
    color: const Color.fromARGB(211, 0, 0, 0),
  );

  get closedCompleter => null;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pagesConfigCont.showAppBar(false);
    });
  }

  final colorCont = Colors.white;
  double borderCont = 12;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsCoordinatorController>(builder: (controllerCoord) {
      return Scaffold(
        /* appBar: AppBar(
          toolbarHeight: (loginControl.androidInfoHeight! * 0.199),
          leading: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      // pagesConfigCont.back();
                      await pagesConfigCont.showAppBar(true);
                      pagesConfigCont.goToPreviousPage();

                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // Positioned(
              //   bottom: -20,
              //   left: -20,
              //   child: Container(
              //     width:
              //         72.0, // Ajusta el tamaño del círculo según sea necesario
              //     height: 72.0,
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Color.fromARGB(76, 224, 224,
              //           224), // Puedes ajustar el tono del gris según tus preferencias
              //     ),
              //   ),
              // )
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 240, 238, 238),
                              width:
                                  2, // Ajusta el ancho del borde según tus preferencias
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            child:
                                //
                                ClipOval(
                              child: Image.network(
                                '${Env.apiEndpoint}/images/${controllerCoord.imageLookCORD}',
                                fit: BoxFit
                                    .cover, // Ajusta la imagen para cubrir completamente el área
                                width:
                                    50, // Ancho deseado de la imagen dentro del círculo
                                height: 50,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    // Si la imagen se carga correctamente, mostramos la imagen
                                    return child;
                                  } else {
                                    // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                    return const CircularProgressIndicator(
                                      color: Color(0xFFFDAE2A),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                  if (kDebugMode) {
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors
                                          .transparent, // Fondo transparente para que el borde sea visible
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/default_profile.jpg',
                                          fit: BoxFit
                                              .cover, // Ajusta la imagen para cubrir completamente el área
                                          width:
                                              50, // Ancho deseado de la imagen dentro del círculo
                                          height:
                                              50, // Alto deseado de la imagen dentro del círculo
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Si no estamos en modo de depuración, mostramos un texto de error
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors
                                          .transparent, // Fondo transparente para que el borde sea visible
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/default_profile.jpg',
                                          fit: BoxFit
                                              .cover, // Ajusta la imagen para cubrir completamente el área
                                          width:
                                              50, // Ancho deseado de la imagen dentro del círculo
                                          height:
                                              50, // Alto deseado de la imagen dentro del círculo
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          //
                        ),
                        Positioned(
                          top: 68,
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFFFDAE2A)
                                // Puedes agregar otras propiedades de estilo aquí si es necesario
                                ),
                            width: 80,
                            height: 16,
                            child: Center(
                              child: Text(
                                controllerCoord.frecuenciaCORD,
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    controllerCoord.clientNameCORD,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  Text(
                    'Visitas : ${controllerCoord.cantVisitCORD}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
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
        ),*/
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 5, right: 10, left: 10),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(
                              0, 3), // Cambia el desplazamiento de la sombra
                        ),
                      ],
                      color: colorCont, //todo
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderCont)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () async {
                            // pagesConfigCont.back();
                            await pagesConfigCont.showAppBar(true);
                            pagesConfigCont.goToPreviousPage();

                            // Navigator.pop(context);
                          },
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                Stack(children: [
                                  Container(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 45,
                                      child:
                                          //
                                          ClipOval(
                                        child: Image.network(
                                          '${Env.apiEndpoint}/images/${controllerCoord.imageLookCORD}',
                                          fit: BoxFit
                                              .cover, // Ajusta la imagen para cubrir completamente el área

                                          width:
                                              65, // Ancho deseado de la imagen dentro del círculo
                                          height: 65,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              // Si la imagen se carga correctamente, mostramos la imagen
                                              return child;
                                            } else {
                                              // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                              return const CircularProgressIndicator(
                                                color: Color(0xFFFDAE2A),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                            if (kDebugMode) {
                                              return CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors
                                                    .transparent, // Fondo transparente para que el borde sea visible
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/images/default_profile.jpg',
                                                    fit: BoxFit
                                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                                    width:
                                                        50, // Ancho deseado de la imagen dentro del círculo
                                                    height:
                                                        50, // Alto deseado de la imagen dentro del círculo
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // Si no estamos en modo de depuración, mostramos un texto de error
                                              return CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors
                                                    .transparent, // Fondo transparente para que el borde sea visible
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/images/default_profile.jpg',
                                                    fit: BoxFit
                                                        .cover, // Ajusta la imagen para cubrir completamente el área
                                                    width:
                                                        50, // Ancho deseado de la imagen dentro del círculo
                                                    height:
                                                        50, // Alto deseado de la imagen dentro del círculo
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    //
                                  ),
                                  Positioned(
                                    top: 66,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xFFFDAE2A)
                                          // Puedes agregar otras propiedades de estilo aquí si es necesario
                                          ),
                                      width: 82,
                                      height: 20,
                                      child: Center(
                                        child: Text(
                                          controllerCoord.frecuenciaCORD,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            Text(
                              controllerCoord.clientNameCORD,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Text(
                              'Visitas : ${controllerCoord.cantVisitCORD}',
                              style: const TextStyle(
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 18,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //todo1 estructura de los cart
                        SizedBox(
                          height: 5,
                        ),

                        cardOptions(context, iconService, 'Servicios',
                            pagesConfigCont, 2),
                        const SizedBox(
                          height: 10,
                        ),
                        cardOptions(
                            context, icon, 'Productos', pagesConfigCont, 3),
                        const SizedBox(
                          height: 10,
                        ),
                        /* cardOptions(
                            context,
                            Icon(
                              MdiIcons.camera,
                            ),
                            'Último look',
                            pagesConfigCont,
                            pagesConfigCont.pageController2,
                            null),*/
                        const SizedBox(
                          height: 0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // Puedes agregar otras propiedades de estilo aquí si es necesario
                          ),
                          height: MediaQuery.of(context).size.height * 0.425,
                          child: Column(
                            children: [
                              cardOptionsImage(
                                context,
                                Icon(
                                  MdiIcons.camera,
                                  color: const Color.fromARGB(211, 0, 0, 0),
                                ),
                                'Último look',
                                pagesConfigCont,
                                pagesConfigCont.pageController2,
                                controllerCoord.endLookCORD,
                                controllerCoord.professionalNameCORD,
                                controllerCoord
                                    .imageUrlCORD, // 'CARGAR LA IMAGEN DEL BARBERO',
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Image.network(
                                  '${Env.apiEndpoint}/images/${controllerCoord.imageLookCORD}',
                                  fit: BoxFit
                                      .cover, // Puedes ajustar el modo de ajuste según sea necesario
                                  width: 360,

                                  height: (loginControl.androidInfoHeight! *
                                      0.275), //todo cambiadoNuevoValores
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Si la imagen se carga correctamente, mostramos la imagen
                                      return child;
                                    } else {
                                      // Si la imagen aún se está cargando, mostramos un indicador de progreso
                                      return const CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      );
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                                    if (kDebugMode) {
                                      return CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors
                                            .transparent, // Fondo transparente para que el borde sea visible
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/default_profile.jpg',
                                            fit: BoxFit
                                                .cover, // Ajusta la imagen para cubrir completamente el área
                                            width:
                                                50, // Ancho deseado de la imagen dentro del círculo
                                            height:
                                                50, // Alto deseado de la imagen dentro del círculo
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Si no estamos en modo de depuración, mostramos un texto de error
                                      return CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors
                                            .transparent, // Fondo transparente para que el borde sea visible
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/default_profile.jpg',
                                            fit: BoxFit
                                                .cover, // Ajusta la imagen para cubrir completamente el área
                                            width:
                                                50, // Ancho deseado de la imagen dentro del círculo
                                            height:
                                                50, // Alto deseado de la imagen dentro del círculo
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              //
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 52.0), // Ajusta el padding
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFFFF6750)),
                                  // Añadir más propiedades de estilo aquí
                                ),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GetBuilder<
                                              ClientsScheduledController>(
                                          builder: (_) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ), //this right here
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF19CF9E),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      child: Text(
                                                        'Motivo',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close,
                                                          color: Colors.white),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 240,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 16,
                                                        right: 16,
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            commentController,
                                                        maxLines: 5,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Escribe el motivo porque va a ser eliminado el cliente...',
                                                          hintStyle: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    137,
                                                                    43,
                                                                    49,
                                                                    65),
                                                          ), // Cambiar el color del hintText
                                                        ),
                                                      ),
                                                    ),
                                                    //

                                                    ButtonBar(
                                                      alignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                            padding:
                                                                MaterialStateProperty
                                                                    .all<
                                                                        EdgeInsetsGeometry>(
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 0,
                                                                  horizontal:
                                                                      26.0),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty.all<
                                                                        Color>(
                                                                    const Color(
                                                                        0xFFFF6750)),
                                                          ),
                                                          onPressed: () async {
                                                            // Lógica para enviar el comentario
                                                            // Obtener el valor del campo de texto
                                                            String commentText =
                                                                commentController
                                                                    .text;
                                                            // Eliminar espacios en blanco al principio y al final
                                                            String
                                                                textWithoutSpaces =
                                                                commentText
                                                                    .trim();

                                                            // Verificar que el campo no esté vacío
                                                            if (textWithoutSpaces
                                                                .isNotEmpty) {
                                                              print(
                                                                  'Cliente eliminado correctamente de la cola deleteReservationClient value = :1');
                                                              //todo falta poner un cargando
                                                              await _.deleteReservationClient(
                                                                  controllerCoord
                                                                      .idReservCORD,
                                                                  commentText);
                                                              //aqui actualizo la cola
                                                              await clientCoordControl
                                                                  .fetchClientsScheduledBranch(
                                                                      loginControl
                                                                          .branchIdLoggedIn);
                                                              clientCoordControl
                                                                  .setLoading(
                                                                      false);
                                                              Get.snackbar(
                                                                'Mensaje',
                                                                'Cliente eliminado de la cola',
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        3000),
                                                              );
                                                              //todo falta mandar mensaje al profesional que se le elimino tal cliente de la cola poruqe no habia llegado
                                                              print(
                                                                  'Cliente eliminado correctamente de la cola deleteReservationClient value = :2');
                                                              // Cerrar el primer modal
                                                              Navigator.pop(
                                                                  context);
                                                              await pagesConfigCont
                                                                  .showAppBar(
                                                                      true);
                                                              pagesConfigCont
                                                                  .goToPreviousPage();

                                                              print(
                                                                  'El comentario enviado - $commentText ');
                                                            } else {
                                                              // El campo de texto está vacío, puedes mostrar un mensaje o realizar alguna acción
                                                              print(
                                                                  'El comentario no puede estar vacío');
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                MdiIcons.send,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              const Text(
                                                                'ENVIAR y ELIMINAR',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
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
                                },
                                child: const Text(
                                  'ELIMINAR',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 52.0), // Ajusta el padding
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF4470F3)),

                                  // Añadir más propiedades de estilo aquí
                                ),
                                onPressed: () async {
                                  //llamar el ENPOINT professional-state
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();
                                  print(
                                      'mostrando id de reservaciones:${clientCoordControl.idReservCORD}');
                                  // await clientSchedControl.getProfessionalState(
                                  //     loginControl.branchIdLoggedIn);
                                  await clientSchedControl
                                      .getProfessionalState2(
                                          loginControl.branchIdLoggedIn,
                                          clientCoordControl.idReservCORD);

                                  await pagesConfigCont.showAppBar(false);
                                  pagesConfigCont.goToPage(
                                      6, pagesConfigCont.pageController2);
                                  Get.back();
                                },
                                child: const Text(
                                  'REASIGNAR',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 45,
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  InkWell cardOptions(BuildContext context, icon, title,
      PagesConfigController pagesConfigCont, page) {
    return InkWell(
      onTap: () async {
        print('estoy dando click');
        await pagesConfigCont.showAppBar(false);
        pagesConfigCont.goToPage(page, pagesConfigCont.pageController2);

        /*pageController2.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );*/
      },
      child: Container(
        height: (MediaQuery.of(context).size.height * 0.07),
        width: (MediaQuery.of(context).size.width * 0.95),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Agrega un contenedor para alinear el icono al centro verticalmente
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(55, 124, 123, 123),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                margin: const EdgeInsets.only(right: 10),
                width: 35,
                height: 35,
                child: icon,
              ),
              Text(
                title.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          subtitle: null,
          trailing: page != null
              ? Icon(
                  Icons.navigate_next,
                  color: const Color.fromARGB(
                      255, 43, 44, 49), // Cambia el color a negro
                  size: 30.0,
                )
              : null,
        ),
      ),
    );
  }

  InkWell cardOptionsImage(
      BuildContext context,
      icon,
      title,
      PagesConfigController pagesConfigCont,
      PageController pageController2,
      endLook,
      ultimateBarber,
      imageUltimateBarber) {
    return InkWell(
      onTap: () async {
        print('estoy dando click');
      },
      child: Column(
        children: [
          /**último look */ Container(
            height: (MediaQuery.of(context).size.height * 0.07),
            width: (MediaQuery.of(context).size.width * 0.95),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Agrega un contenedor para alinear el icono al centro verticalmente
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(55, 124, 123, 123),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    width: 35,
                    height: 35,
                    child: icon,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.2),
                      ),
                      Text(
                        endLook,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.2),
                      ),
                    ],
                  )
                ],
              ),
              subtitle: null,
              trailing: null,
            ),
          ),
          /**último professional */ Container(
            height: (MediaQuery.of(context).size.height * 0.07),
            width: (MediaQuery.of(context).size.width * 0.95),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Agrega un contenedor para alinear el icono al centro verticalmente
                  // Container(
                  //   decoration: const BoxDecoration(
                  //     color: Color.fromARGB(55, 124, 123, 123),
                  //     borderRadius: BorderRadius.all(Radius.circular(12)),
                  //   ),
                  //   margin: const EdgeInsets.only(right: 10),
                  //   width: 35,
                  //   height: 35,
                  //   child: Icon(
                  //     MdiIcons.accountTie,
                  //     color: const Color.fromARGB(255, 43, 44, 49),
                  //   ),
                  // ),
                  CircleAvatar(
                    radius: 18,
                    child: ClipOval(
                      child: Image.network(
                        '${Env.apiEndpoint}/images/$imageUltimateBarber',
                        fit: BoxFit
                            .cover, // Ajusta la imagen para cubrir completamente el área
                        width:
                            50, // Ancho deseado de la imagen dentro del círculo
                        height: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Si la imagen se carga correctamente, mostramos la imagen
                            return child;
                          } else {
                            // Si la imagen aún se está cargando, mostramos un indicador de progreso
                            return const CircularProgressIndicator(
                              color: Color(0xFFFDAE2A),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                          if (kDebugMode) {
                            return CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors
                                  .transparent, // Fondo transparente para que el borde sea visible
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/default_profile.jpg',
                                  fit: BoxFit
                                      .cover, // Ajusta la imagen para cubrir completamente el área
                                  width:
                                      50, // Ancho deseado de la imagen dentro del círculo
                                  height:
                                      50, // Alto deseado de la imagen dentro del círculo
                                ),
                              ),
                            );
                          } else {
                            // Si no estamos en modo de depuración, mostramos un texto de error
                            return CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors
                                  .transparent, // Fondo transparente para que el borde sea visible
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/default_profile.jpg',
                                  fit: BoxFit
                                      .cover, // Ajusta la imagen para cubrir completamente el área
                                  width:
                                      50, // Ancho deseado de la imagen dentro del círculo
                                  height:
                                      50, // Alto deseado de la imagen dentro del círculo
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Último barbero ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.2),
                          ),
                          /*  Text(
                            '(16/01/2024)',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.2),
                          ),*/
                        ],
                      ),
                      Text(
                        ultimateBarber,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.2),
                      ),
                    ],
                  )
                ],
              ),
              subtitle: null,
              trailing: null,
            ),
          ),
        ],
      ),
    );
  }
}
