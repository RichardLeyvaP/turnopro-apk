// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/env.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AssignProfessional extends StatefulWidget {
  const AssignProfessional({super.key});

  @override
  State<AssignProfessional> createState() => _AssignProfessionalState();
}

class _AssignProfessionalState extends State<AssignProfessional> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  int cantVisitas = 3;
  String imageDirection = '${Env.apiEndpoint}/images/professional/ejemplo1.jpg';
  List<String> direcc = [
    'assets/images/icons/montoGen.png',
    'assets/images/icons/propina.png',
    'assets/images/icons/80.png',
    'assets/images/icons/porcentageGan.png',
    'assets/images/icons/serviceRea.png',
    'assets/images/icons/serviceRegul.png',
    'assets/images/icons/serviceEsp.png',
    'assets/images/icons/montoEsp.png',
    'assets/images/icons/gananciaBar.png',
    'assets/images/icons/gananciaTot.png',
    'assets/images/icons/clientesAten.png',
    'assets/images/icons/seleccionado.png',
    'assets/images/icons/aleatorio.png',
  ];

  String title = 'Modulo 1';
  String name = 'John Rivera';
  Icon icon = Icon(
    MdiIcons.tag,
  );

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    pagesConfigCont.back();

                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 72.0, // Ajusta el tamaño del círculo según sea necesario
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
                const Text(
                  'Richard Leyva',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                const Text(
                  'Reasignar',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
          return 1 == 4 //todo saber si hay barberos disponibles
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 241, 130, 84),
                  ),
                )
              : 5 > 0 //todo si hay cargarlos aqui
                  ? Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              // Utiliza la función cardOptions para construir cada Card
                              return cardOptions(
                                context,
                                // Pasa aquí los datos necesarios para cardOptions
                                icon,
                                title,
                                name,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('No hay Barberos disponibles'),
                    );
        },
      ),
    );
  }

  Padding cardOptions(BuildContext context, icon, title, name) {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageDirection),
                    radius: 30, // Ajusta el tamaño del círculo aquí
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        name.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      Container(
                        width: 80, // Ajusta la altura según sea necesario
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(167, 241, 131, 84),
                          borderRadius: BorderRadius.circular(
                              6), // La mitad de la altura para hacerlo circular
                        ),
                        child: const Center(
                          child: Text(
                            'LIBRE',
                            style: TextStyle(
                              fontSize: 10,
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                14.0), // Ajusta el valor según sea necesario
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 26.0), // Ajusta el padding
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                              color: Color.fromARGB(167, 241, 131, 84),
                              width:
                                  2.0), // Ajusta el grosor del borde según sea necesario
                        ),
                        // Añadir más propiedades de estilo aquí
                      ),
                      onPressed: () async {
                        Get.snackbar(
                          'Mensaje',
                          'Aquí llamar a la DB y asignar a cliente',
                          duration: const Duration(milliseconds: 2500),
                          backgroundColor:
                              const Color.fromARGB(118, 255, 255, 255),
                          showProgressIndicator: true,
                          progressIndicatorBackgroundColor:
                              const Color.fromARGB(255, 203, 205, 209),
                          progressIndicatorValueColor:
                              const AlwaysStoppedAnimation(Color(0xFFF18254)),
                          overlayBlur: 3,
                        );
                      },
                      child: const Text(
                        'ASIGNAR',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(167, 241, 131, 84),
                            fontWeight: FontWeight.w800),
                      )),
                ],
              ),
            ],
          ),
          subtitle: null,
        ),
      ),
    );
  }
}
