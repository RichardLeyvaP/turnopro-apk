// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/env.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ServicesClient extends StatefulWidget {
  const ServicesClient({super.key});

  @override
  State<ServicesClient> createState() => _ServicesClientState();
}

class _ServicesClientState extends State<ServicesClient> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  int cantVisitas = 3;
  String imageProduct = '${Env.apiEndpoint}/images/product/cocacola.jpg';

  String description = 'Regular';
  String fecha = '10-01-2024';
  String name = 'Corte de Cabello';
  Icon icon = Icon(
    MdiIcons.tag,
  );
  int cant = 8;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsCoordinatorController>(builder: (controllerCORD) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          leading: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // pagesConfigCont.back();
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
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Color del borde blanco
                          width: 2.0, // Ancho del borde
                        ),
                      ),
                      child: Icon(
                        MdiIcons.server,
                        size: 50.0,
                        color: Colors.white, // Color del ícono
                      ),
                    ),
                  ),
                  const Text(
                    'SERVICIOS',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white),
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
        body: GetBuilder<NotificationController>(
          builder: (_) {
            return controllerCORD
                    .serviceCORD.isNotEmpty //todo si hay cargarlos aqui
                ? Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemCount: controllerCORD.serviceCORD.length,
                          itemBuilder: (context, index) {
                            // Utiliza la función cardOptions para construir cada Card
                            return cardOptions(
                              context,
                              // Pasa aquí los datos necesarios para cardOptions
                              controllerCORD.serviceCORD[index].name,
                              controllerCORD.serviceCORD[index].type_service,
                              controllerCORD.serviceCORD[index].cant,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text('No hay Servicios para mostrar'),
                  );
          },
        ),
      );
    });
  }

  Padding cardOptions(BuildContext context, name, description, cant) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 8, left: 10),
      child: Container(
        height: (MediaQuery.of(context).size.height * 0.1),
        width: (MediaQuery.of(context).size.width * 0.95),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Column(
            children: [
              const SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        description.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        fecha.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(167, 241, 131, 84),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        cant.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const Text(
                        'Cantidad',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //
              //
              const SizedBox(
                height: 5,
              ),
              //
              //
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: (MediaQuery.of(context).size.height * 0.008),
                    width: constraints.maxWidth,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 231, 232, 234),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: constraints.maxWidth *
                                (cant * 2 / 3) /
                                10, //TODO AQUI CALCULA PARA QUE PINTE EL CONTAINER-RESPECTO-TIEMPO
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 231, 232, 234),
                                    Color.fromARGB(255, 26, 50, 82),
                                  ],
                                  stops: [0.0, 0.8],
                                  begin: FractionalOffset.centerLeft,
                                  end: FractionalOffset.centerRight,
                                ))),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          subtitle: null,
        ),
      ),
    );
  }
}
