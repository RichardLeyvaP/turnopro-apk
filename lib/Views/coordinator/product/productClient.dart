// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/env.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductClient extends StatefulWidget {
  const ProductClient({super.key});

  @override
  State<ProductClient> createState() => _ProductClientState();
}

class _ProductClientState extends State<ProductClient> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  int cantVisitas = 3;

  Icon icon = Icon(
    MdiIcons.tag,
  );
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.tagOutline;

  String title = 'Productos';
  String subTitle = 'Productos';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = Color(0xFF4470F3);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
        toolbarHeight: 150,
        leading: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    //pagesConfigCont.back();
                    //pagesConfigCont.goToPreviousPage();
                    pagesConfigCont.goToPage(
                        1, pagesConfigCont.pageController2);

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
                      color: const Color.fromARGB(255, 43, 44, 49),
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
                      MdiIcons.tag,
                      size: 50.0,
                      color: Colors.white, // Color del ícono
                    ),
                  ),
                ),
                const Text(
                  'PRODUCTOS',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
      */
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<ClientsCoordinatorController>(
        builder: (controllerCORD) {
          return Column(
            children: [
              Expanded(
                flex: 4,
                child: topPage(
                  panddCont: panddCont,
                  colorCont: colorCont,
                  borderCont: borderCont,
                  IconnsBack: IconnsBack,
                  pagesConfigC: pagesConfigCont,
                  isPagesConfig: true,
                  IconnsP: IconnsP,
                  title: title,
                  subTitle: subTitle,
                  colorIcon: colorIcon,
                  buttonRight: false,
                  page: 'Coordinador',
                ),
              ),
              Expanded(
                flex: 18,
                child: controllerCORD
                        .productCORD.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets
                            .zero, // Elimina cualquier padding del ListView
                        itemCount: controllerCORD.productCORD.length,
                        itemBuilder: (context, index) {
                          print(
                              'images de products:${dotenv.env['API_ENDPOINT']}/images/${controllerCORD.productCORD[index].image_product}}');
                          print(
                              'images de products:${controllerCORD.productCORD[index].image_product}');
                          // Utiliza la función cardOptions para construir cada Card
                          return cardOptions(
                            context,
                            // Pasa aquí los datos necesarios para cardOptions
                            icon,
                            controllerCORD.productCORD[index].name,
                            controllerCORD.truncateText(
                                controllerCORD.productCORD[index].description,
                                30),
                            controllerCORD.productCORD[index].cant,
                            controllerCORD.productCORD[index].image_product,
                          );
                        },
                      )
                    : const Center(
                        child: Text('No ha comprado productos'),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Padding cardOptions(
      BuildContext context, icon, name, description, cant, imageProd) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(55, 124, 123, 123),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      margin: const EdgeInsets.only(right: 10),
                      width: 65,
                      height: 75,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white, //fondo de la imagen
                          child: CachedNetworkImage(
                            maxHeightDiskCache: 100,
                            maxWidthDiskCache: 100,
                            imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$imageProd',
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: Color(0xFFFDAE2A),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/product-default.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
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
                      // Text(
                      //   description.toString(),
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w600,
                      //     color: Color.fromARGB(167, 241, 131, 84),
                      //   ),
                      // ),
                    ],
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
          subtitle: null,
        ),
      ),
    );
  }
}
