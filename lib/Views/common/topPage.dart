import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:get/get.dart';

class topPage extends StatelessWidget {
  const topPage({
    super.key,
    required this.panddCont,
    required this.colorCont,
    required this.borderCont,
    required this.IconnsBack,
    required this.pagesConfigC,
    required this.isPagesConfig,
    required this.IconnsP,
    required this.title,
    required this.subTitle,
    required this.colorIcon,
    required this.buttonRight,
    this.direccButton,
    this.textButton,
    this.colorButton,
    this.coexContro,
  });

  final double panddCont;
  final Color colorCont;
  final double borderCont;
  final IconData IconnsBack;
  final PagesConfigController pagesConfigC;
  final bool isPagesConfig;
  final IconData IconnsP;
  final String title;
  final String subTitle;
  final Color colorIcon;
  final bool buttonRight;
  final String? direccButton;
  final String? textButton;
  final Color? colorButton;
  final dynamic coexContro;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 47, right: 10, left: 10),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // Cambia el desplazamiento de la sombra
            ),
          ],
          color: colorCont, //todo
          borderRadius: BorderRadius.all(Radius.circular(borderCont)),
        ),
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        IconnsBack,
                        color: Color.fromARGB(200, 0, 0, 0),
                      ),
                      onPressed: () {
                        print('estoy entrando aqui...');
                        if (isPagesConfig == true) {
                          pagesConfigC.back();
                        } else {
                          Get.back();
                        }

                        // Navigator.pop(context);
                      },
                    ),
                    // Ajusta el espacio según sea necesario
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors
                                        .white, // Color blanco para el borde
                                    width:
                                        1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                  ),
                                  color: colorIcon,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(IconnsP,
                                      size: 40, color: Colors.white),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color.fromARGB(200, 0, 0, 0)),
                                ),
                                Text(
                                  subTitle,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Color.fromARGB(180, 0, 0, 0)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Añade más widgets o ajusta según sea necesario
                  ],
                ),
                buttonRight == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFDAE2A),
                                ),
                              ),
                              barrierDismissible: false,
                            ); //Get.back();s
                            if (textButton == 'MIS PAGOS') {
                              await coexContro.fetchEstadistPagos();
                            }
                            //AQUI PONER OTRAS CONDICIONES SI ES POSIBLE

                            Get.back();
                            Get.toNamed(direccButton!);
                            //Get.toNamed('/Estadistc2Pagos');
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(colorButton!),
                            // MaterialStateProperty.all<Color>(Color(0xFF4470F3)),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textButton!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
