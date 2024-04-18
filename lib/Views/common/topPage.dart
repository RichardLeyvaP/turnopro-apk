import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';

class topPage extends StatelessWidget {
  const topPage({
    super.key,
    required this.panddCont,
    required this.colorCont,
    required this.borderCont,
    required this.IconnsBack,
    required this.pagesConfigC,
    required this.IconnsP,
    required this.title,
    required this.subTitle,
    required this.colorIcon,
  });

  final double panddCont;
  final Color colorCont;
  final double borderCont;
  final IconData IconnsBack;
  final PagesConfigController pagesConfigC;
  final IconData IconnsP;
  final String title;
  final String subTitle;
  final Color colorIcon;

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    IconnsBack,
                    color: Color.fromARGB(200, 0, 0, 0),
                  ),
                  onPressed: () {
                    print('estoy entrando aqui...');
                    pagesConfigC.back();
                    // Navigator.pop(context);
                  },
                ),
                // Ajusta el espacio según sea necesario
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Color blanco para el borde
                            width:
                                1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                          ),
                          color: colorIcon,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(IconnsP, size: 40, color: Colors.white),
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

                // Añade más widgets o ajusta según sea necesario
              ],
            ),
          ],
        ),
      ),
    );
  }
}
