// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/env.dart';

import '../../../Controllers/login.controller.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AttendingClient extends StatefulWidget {
  const AttendingClient({super.key});

  @override
  State<AttendingClient> createState() => _AttendingClientState();
}

class _AttendingClientState extends State<AttendingClient> {
  final double valuePadding = 12;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final LoginController loginController = Get.find<LoginController>();
  int cantVisitas = 3;
  String imag = '${Env.apiEndpoint}/images/coordinator/default_profile.jpg';

  String description = 'Coca Cola Classic 350 ml';
  String fecha = '10-01-2024';
  String name = 'Coca Cola';
  Icon icon = Icon(
    MdiIcons.tag,
  );
  int cant = 8;

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
                    pagesConfigCont.pageController2
                        .jumpToPage(0); //AQUI VA  AL HOME
                    pagesConfigCont.showAppBar(true);
                    // pagesConfigCont.back();
                    // pagesConfigCont.goToPreviousPage();
                    // pagesConfigCont.goToPage(
                    //     1, pagesConfigCont.pageController2);

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
                      MdiIcons.account,
                      size: 50.0,
                      color: Colors.white, // Color del ícono
                    ),
                  ),
                ),
                const Text(
                  'Clientes Atendiéndose',
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
      body: GetBuilder<ClientsCoordinatorController>(
        builder: (controllerCORD) {
          return controllerCORD
                  .productCORD.isNotEmpty //todo si hay cargarlos aqui
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemCount:
                              2, //aqui ver la long de clientAttenCORD y mostrar aqui los que esten
                          itemBuilder: (context, index) {
                            // Utiliza la función cardOptions para construir cada Card
                            return cardClientTails(
                                controllerCORD,
                                context,
                                index,
                                pagesConfigCont.pageController2,
                                pagesConfigCont,
                                imag);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text('No hay clientes atendiéndose en este momento'),
                );
        },
      ),
    );
  }

  FittedBox cardClientTails(
      ClientsCoordinatorController controllerclient,
      BuildContext context,
      index,
      PageController pageController2,
      PagesConfigController pagesConfigC,
      imageDirection) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                //AQUI CONTROLO SI HAY ALGUIEN EN COLA
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(imageDirection),
                        radius: 40, // Ajusta el tamaño del círculo aquí
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.115),
                      width: (MediaQuery.of(context).size.width * 0.8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  //CLIENTE
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    Text(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .client_name,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                Row(
                                  //HORARIO
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    Text(
                                      '${controllerclient.clientsScheduledListBranch[index].start_time} - ${controllerclient.clientsScheduledListBranch[index].final_hour}',
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  //PROFESIONAL
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    Text(
                                      controllerclient
                                          .clientsScheduledListBranch[index]
                                          .professional_name!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await pagesConfigC.showAppBar(false);
                        pageController2.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        height: (MediaQuery.of(context).size.height * 0.115),
                        width: (MediaQuery.of(context).size.width * 0.20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Color blanco para el borde
                              width:
                                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                            ),
                            color: const Color.fromARGB(255, 32, 32, 32),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    int idClient = controllerclient
                                        .clientsScheduledListBranch[index]
                                        .client_id;
                                    int idBranch =
                                        loginController.branchIdLoggedIn!;
                                    // aqui llamar a la db y pedir todos los datos del cliente
                                    await controllerclient.getClientHistory(
                                        idClient, idBranch);
                                    //pagesConfigC.updateSelectedIndex();
                                    await pagesConfigC.showAppBar(false);
                                    pageController2.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  },
                                  icon: Icon(
                                    MdiIcons.eye,
                                    color: Colors.white,
                                    size: (MediaQuery.of(context).size.height *
                                        0.05),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            const Text(
                              'VER MÁS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 12,
            )
          ],
        ));
  }
}
