// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:get/get.dart';

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
                                              0.085),
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
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            onTap: () {
                                              _.getSelectCoexistence(index);
                                            },
                                            title: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 32, 32, 32),
                                                          width:
                                                              2, // Ajusta el ancho del borde según tus preferencias
                                                        ),
                                                      ),
                                                      child: Swing(
                                                        duration:
                                                            const Duration(
                                                                seconds: 4),
                                                        delay: const Duration(
                                                            seconds: 2),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  imageDirection),
                                                          radius:
                                                              25, // Ajusta el tamaño del círculo aquí
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _.coexistence[index]
                                                              .name
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                _.seleccStars();
                                                              },
                                                              child: Icon(
                                                                  Icons.star,
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      241,
                                                                      130,
                                                                      84),
                                                                  size: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.035)),
                                                            ),
                                                            Icon(Icons.star,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    241,
                                                                    130,
                                                                    84),
                                                                size: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.035)),
                                                            Icon(Icons.star,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    241,
                                                                    130,
                                                                    84),
                                                                size: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.035)),
                                                            Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    96,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                size: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.035)),
                                                            Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    96,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                size: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.035)),
                                                          ],
                                                        ),
                                                      ],
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
                                                    : const Icon(
                                                        Icons.star_half_sharp,
                                                        size: 55,
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ],
                  )
                : Center(
                    //*AQUI ESTA EL CODIGO DE CUANDO NO HAY NOTIFICACIONES
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_backpack_outlined),
                          Text('No hay Notificaciones'),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.snackbar(
                            'Mensaje',
                            'INSERTADO CORRECTAMENTE',
                            backgroundColor:
                                const Color.fromARGB(92, 11, 226, 22),
                            duration: const Duration(milliseconds: 2000),
                          );
                          _.addCoexistence();
                        },
                      ),
                    ],
                  ));
      }),
    );
  }
}
