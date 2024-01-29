// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/env.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileClient extends StatefulWidget {
  const ProfileClient({super.key});

  @override
  State<ProfileClient> createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  int cantVisitas = 3;
  String imageDirection =
      '${Env.apiEndpoint}/images/professional/default_profile.jpg';
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
  String title = 'Servicios';
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
                decoration: BoxDecoration(
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
                Text(
                  'Visitas : $cantVisitas',
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //todo1 estructura de los cart
            cardOptions(context, icon, title),
            const SizedBox(
              height: 10,
            ),
            cardOptions(context, icon, 'Productos'),
            const SizedBox(
              height: 10,
            ),
            cardOptions(
                context,
                Icon(
                  MdiIcons.camera,
                ),
                'Último look'),
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
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 60.0), // Ajusta el padding
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      // Añadir más propiedades de estilo aquí
                    ),
                    onPressed: () async {},
                    child: const Text(
                      'ELIMINAR',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 60.0), // Ajusta el padding
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                            color: Colors.black,
                            width:
                                2.0), // Ajusta el grosor del borde según sea necesario
                      ),
                      // Añadir más propiedades de estilo aquí
                    ),
                    onPressed: () async {},
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
    );
  }

  Container cardOptions(BuildContext context, icon, title) {
    return Container(
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
    );
  }
}
