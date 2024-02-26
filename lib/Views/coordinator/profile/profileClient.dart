// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
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

  int cantVisitas = 3;
  String imageDirection =
      '${Env.apiEndpoint}/images/professional/default_profile.jpg';

  String title = 'Servicios';
  Icon icon = Icon(
    MdiIcons.tag,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsCoordinatorController>(builder: (controllerCoord) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
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
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width:
                      72.0, // Ajusta el tamaño del círculo según sea necesario
                  height: 72.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(76, 224, 224,
                        224), // Puedes ajustar el tono del gris según tus preferencias
                  ),
                ),
              )
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 32, 32, 32),
                        width:
                            2, // Ajusta el ancho del borde según tus preferencias
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imageDirection),
                      radius: 40, // Ajusta el tamaño del círculo aquí
                    ),
                  ),
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
        ),
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //todo1 estructura de los cart
                    cardOptions(context, icon, 'Servicios', pagesConfigCont,
                        pagesConfigCont.pageController2, 2),
                    const SizedBox(
                      height: 10,
                    ),
                    cardOptions(context, icon, 'Productos', pagesConfigCont,
                        pagesConfigCont.pageController2, 3),
                    const SizedBox(
                      height: 10,
                    ),
                    cardOptions(
                        context,
                        Icon(
                          MdiIcons.camera,
                        ),
                        'Último look',
                        pagesConfigCont,
                        pagesConfigCont.pageController2,
                        null),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // Puedes agregar otras propiedades de estilo aquí si es necesario
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://www.calgaryhispano.com/wp-content/uploads/2020/05/barberos-en-alberta.jpg',
                          fit: BoxFit
                              .cover, // Puedes ajustar el modo de ajuste según sea necesario
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 60.0), // Ajusta el padding
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              // Añadir más propiedades de estilo aquí
                            ),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return GetBuilder<ClientsScheduledController>(
                                      builder: (_) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Eliminar',
                                          ),
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(
                                                    context, 'Cerrar');
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )))
                                        ],
                                      ),
                                      content: SizedBox(
                                        width: 110,
                                        height: 135,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                          commentController, // Asignar el controlador al TextFormField
                                                      maxLines: 4,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Escribe el motivo porque va a ser eliminado el cliente...',
                                                      ),
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
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                          ),
                                          onPressed: () async {
                                            // Lógica para enviar el comentario

                                            // Obtener el valor del campo de texto
                                            //   String commentText =  commentController.text;

                                            // Eliminar espacios en blanco al principio y al final
                                            String textWithoutSpaces =
                                                ''; //commentText.trim();

                                            // Verificar que el campo no esté vacío
                                            if (textWithoutSpaces.isNotEmpty) {
                                              // Cerrar el primer modal
                                              Navigator.pop(context);

                                              // Lógica para enviar el comentario
                                              // await controllClient
                                              //     .acceptOrRejectClient(
                                              //         reservationId, 2);
                                            } else {
                                              // El campo de texto está vacío, puedes mostrar un mensaje o realizar alguna acción
                                              print(
                                                  'El comentario no puede estar vacío');
                                            }
                                          },
                                          child:
                                              const Text('Enviar y Eliminar'),
                                        ),
                                      ],
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
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 60.0), // Ajusta el padding
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                    color: Colors.black,
                                    width:
                                        2.0), // Ajusta el grosor del borde según sea necesario
                              ),
                              // Añadir más propiedades de estilo aquí
                            ),
                            onPressed: () async {
                              pagesConfigCont.onTabTapped(1);
                            },
                            child: const Text(
                              'REASIGNAR',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            )),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      );
    });
  }

  InkWell cardOptions(
      BuildContext context,
      icon,
      title,
      PagesConfigController pagesConfigCont,
      PageController pageController2,
      page) {
    return InkWell(
      onTap: () async {
        print('estoy dando click');
        await pagesConfigCont.showAppBar(false);

        // pageController2.jumpToPage(1);
        if (page != null) {
          pagesConfigCont.goToPage(page, pageController2);
        }

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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          subtitle: null,
          trailing: Icon(
            Icons.navigate_next,
            color: Colors.black, // Cambia el color a negro
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
