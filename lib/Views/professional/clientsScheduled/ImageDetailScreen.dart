import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Utility/ExpandableText.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:get/get.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String description;

  ImageDetailScreen({required this.imageUrl, required this.description});

  final PagesConfigController pagesConfigCont = Get.find<PagesConfigController>();
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.cameraOutline;

  Icon icon = Icon(
    MdiIcons.camera,
    color: const Color.fromARGB(211, 0, 0, 0),
  );

  String title = 'Foto';
  String subTitle = 'Foto de último look';
  final colorCont = Colors.white;
  double panddCont = 8;
  double borderCont = 12;
  final colorIcon = const Color(0xFF19CF9E);
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        flex: 4,
        child: topPage(
          panddCont: panddCont,
          colorCont: colorCont,
          borderCont: borderCont,
          IconnsBack: IconnsBack,
          pagesConfigC: pagesConfigCont,
          isPagesConfig: false,
          IconnsP: IconnsP,
          title: title,
          subTitle: subTitle,
          colorIcon: colorIcon,
          buttonRight: false,
        ),
      ),
      Expanded(
          flex: 3, // 85% del espacio disponible para esta parte
          child: GestureDetector(
            onDoubleTap: () {
              Get.back();
            },
            child: /**último look */
                Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contenedor con icono
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
                    // Columna con título y texto expandible
                    Expanded(
                      // Asegura que el texto se ajuste y no se desborde
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Último Look',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.2),
                                  overflow: TextOverflow.ellipsis, // Añade truncamiento si es necesario
                                  maxLines: 1, // Limita el texto a una sola línea
                                ),
                              ],
                            ),
                            // Texto expandible
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: null,
                trailing: null,
              ),
            ),
          )),
      SizedBox(
        height: 10,
      ),
      Expanded(
          flex: 15, // 85% del espacio disponible para esta parte
          child: Center(
            child: GestureDetector(
              onDoubleTap: () {
                Get.back();
              },
              child: Column(
                children: [
                  InteractiveViewer(
                    minScale: 0.1,
                    maxScale: 7.0,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
              ),
            ),
          ))
    ]));
  }
}
