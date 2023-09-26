// ignore_for_file: file_names, depend_on_referenced_packages
//import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:get/get.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CoexistencePage extends StatelessWidget {
  const CoexistencePage({super.key});
  final double valuePadding = 12;
  final String imageDirection = 'assets/images/image_perfil.jpg';

  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    //DECLARACION DE VARIABLES
    const double borderRadiusValue = 12;

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.stars,
                  size: 50,
                ),
                Text(
                  'Convivencias',
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
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<CoexistenceController>(builder: (_) {
        return _.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color.fromARGB(255, 241, 130, 84),
              ))
            : _.coexistenceListLength > 0
                ? Column(
                    children: [
                      Expanded(
                        flex:
                            heightFlexBody, // 85% del espacio disponible para esta parte
                        child: ListView.builder(
                            itemCount: _.coexistenceListLength,
                            itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      (MediaQuery.of(context).size.height *
                                          0.013),
                                      (MediaQuery.of(context).size.height *
                                          0.006),
                                      (MediaQuery.of(context).size.height *
                                          0.013),
                                      (MediaQuery.of(context).size.height *
                                          0.006)),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.11),
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(-5,
                                                    5), // Ajusta los valores para personalizar la sombra
                                              ),
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                                        borderRadiusValue)),
                                          ),
                                          child: ListTile(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.77,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _
                                                                  .coexistence[
                                                                      index]
                                                                  .name
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            Text(
                                                              _
                                                                  .coexistence[
                                                                      index]
                                                                  .description
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          148,
                                                                          0,
                                                                          0,
                                                                          0)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  _.selectCoexistence.contains(
                                                          _.coexistence[index])
                                                      ? const Icon(
                                                          Icons.stars_outlined,
                                                          color: Colors.red,
                                                          size: 65,
                                                        )
                                                      : Icon(MdiIcons.abacus),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ],
                  )
                : const Center(
                    //*AQUI ESTA EL CODIGO DE CUANDO NO HAY NOTIFICACIONES
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_backpack_outlined),
                          Text('No hay Notificaciones'),
                        ],
                      ),
                    ],
                  ));
      }),
    );
  }
}
