// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
//import 'package:lottie/lottie.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/env.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> with WidgetsBindingObserver {
  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();
  final LoginController loginController = Get.find<LoginController>();
  final ClientsScheduledController clientController =
      Get.find<ClientsScheduledController>();
  final NotificationController notiCont = Get.find<NotificationController>();
  int carr = 199;

  @override
  void initState() {
    super.initState();
    // Agregar el observador del ciclo de vida
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Eliminar el observador del ciclo de vida al finalizar
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // La aplicación se está pausando (puede ir a segundo plano)
      print('La aplicación se está pausando (yendo a segundo plano)');
      await clientController.upadateVariablesValueTimers();
    } else if (state == AppLifecycleState.resumed) {
      // La aplicación se cierra completamente
      print('La aplicación se está Reaunudandose nuevamente');
      clientController.setCloseIesperado(false);
      // Agrega tu lógica para guardar en la base de datos aquí.
    } else if (state == AppLifecycleState.detached) {
      // La aplicación se cierra completamente
      print('La aplicación se está cerrando completamente');
      // Agrega tu lógica para guardar en la base de datos aquí.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 2),
      child:
          GetBuilder<PagesConfigController>(builder: (pagesConfigController) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 231, 232, 234),
          appBar: pagesConfigController.selectedIndex == 0
              ? CustomAppBar(
                  id: loginController
                      .idProfessionalLoggedIn) //aqui paso el id del profesional que es el nombre de la imagen
              : null,
          body: PageView(
            controller: pagesConfigController.pageHomeController,
            physics: const NeverScrollableScrollPhysics(),
            children: pagesConfigController.pages,
          ), // Muestra la página actual
          //body: homePageBody(borderRadiusValue, context, colorVariable, colorBottom, titleCart, descriptionTitleCart, iconCart),
          bottomNavigationBar: Padding(
            padding:
                EdgeInsets.all((MediaQuery.of(context).size.height * 0.012)),
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: GetBuilder<ClientsScheduledController>(
                    builder: (controClient) {
                  return BottomNavigationBar(
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      unselectedItemColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 43, 44, 49),
                      fixedColor: const Color(0xFFF18254),
                      currentIndex: pagesConfigController.selectedIndex,
                      type: BottomNavigationBarType.fixed,
                      onTap: (index) =>
                          pagesConfigController.onTabTapped(index),
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.home,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                            label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Badge(
                              label: Text(
                                  '${controClient.clientsScheduledListLength}'),
                              child: Icon(
                                Icons.perm_contact_calendar,
                                size: MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                            label: 'Agenda'),
                        BottomNavigationBarItem(
                            icon: Badge(
                              label: GetBuilder<NotificationController>(
                                  builder: (_notiCont) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  // Se ejecutará después de que se haya construido el widget
                                  //define que tipo de saludo dar dependiendo de la hora
                                  if (_notiCont.notificationListNewLength !=
                                      _notiCont.notificationListBack) {
                                    _notiCont.updateNotificationListBack(
                                        _notiCont.notificationListNewLength);
                                  }
                                });

                                if (_notiCont.notificationListNewLength !=
                                        _notiCont.notificationListBack &&
                                    _notiCont.notificationListNewLength != 0) {
                                  _notiCont.reproducirSound();
                                }
                                return Text(
                                    (_notiCont.notificationListNewLength)
                                        .toString());
                              }),
                              child: Icon(
                                Icons.notifications,
                                size: MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                            label: 'Notificaciones'),
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.bar_chart,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                            label: 'Estadistica'),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.star,
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                          label: 'Convivencia',
                        ),
                      ]);
                })),
          ),
        );
      }),
    );
  }
}

//DEFINIENDO EL AppBar
// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? id;
  const CustomAppBar({Key? key, required this.id}) : super(key: key);

  @override
  //Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize =>
      const Size.fromHeight(70); // Ajusta el tamaño del AppBar aquí

  // Utilizar una función o getter para obtener imageDirection
  String get imageDirection {
    if (id != null && id != -99) {
      return '${Env.apiEndpoint}/images/professional/$id.jpg';
    } else {
      // Si id es null o igual a -99, devuelve la ruta para la foto de perfil incógnito
      return '${Env.apiEndpoint}/images/professional/default_profile.jpg';
    }
  }

  @override //todo AppBar
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, //RLP Oculta la flecha de retroceso
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      title: GetBuilder<LoginController>(//todo
          builder: (logUser) {
        return Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 8), // Agrega un margen en la parte superior

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 32, 32, 32),
                  width: 2, // Ajusta el ancho del borde según tus preferencias
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageDirection),
                radius: 25, // Ajusta el tamaño del círculo aquí
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width *
                  0.02), //Espacio entre foto perfil y el saludo y el nombre
            ), // Espacio entre la imagen y el texto
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  logUser.greeting,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
                Text(
                  logUser.nameUserLoggedIn,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
      actions: [
        GetBuilder<LoginController>(builder: (_) {
          return InkWell(
            onTap: () {
              _.exit(_.tokenUserLoggedIn); //todo

              // _.exit();
              // Get.offAllNamed('/loginNewPage');
            },
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/QRViewExample',
                    );
                  },
                  child: CircleAvatar(
                    radius: 22, // Tamaño del CircleAvatar
                    backgroundColor: const Color(
                        0xFF2B3141), // Color de fondo del CircleAvatar
                    child: Icon(
                      MdiIcons.qrcodeScan,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: const Color.fromARGB(255, 231, 233, 233),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GetBuilder<ClientsScheduledController>(builder: (clCont) {
                  return InkWell(
                    onTap: () async {
                      await clCont.upadateVariablesValueTimers();
                      _.exit(_
                          .tokenUserLoggedIn); //todooooooooooooooooooooooooooooooooooooooooo
                      // Get.offAllNamed('/loginNewPage');
                    },
                    child: CircleAvatar(
                      radius: 22, // Tamaño del CircleAvatar
                      backgroundColor: const Color(
                          0xFF2B3141), // Color de fondo del CircleAvatar
                      child: Icon(
                        MdiIcons.exitToApp,
                        size: MediaQuery.of(context).size.width * 0.06,
                        color: const Color.fromARGB(255, 231, 233, 233),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  width: 18,
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}
