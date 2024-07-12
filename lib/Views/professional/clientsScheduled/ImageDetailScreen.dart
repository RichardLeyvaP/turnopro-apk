import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:get/get.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen({required this.imageUrl});

  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
  final IconnsBack = Icons.arrow_back;
  final IconnsP = MdiIcons.cameraOutline;

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
          flex: 18, // 85% del espacio disponible para esta parte
          child: Center(
            child: GestureDetector(
              onDoubleTap: () {
                Get.back();
              },
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 7.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ))
    ]));
  }
}
