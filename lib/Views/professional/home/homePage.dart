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
    clientController.loadData();
  }

  @override
  void dispose() {
    // Eliminar el observador del ciclo de vida al finalizar
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    //await clientController.upadateVariablesValueTimers();
    super.didChangeAppLifecycleState(state);
    print('La aplicación se está pausando (yendo a segundo plano111)');
    if (state == AppLifecycleState.paused) {
      clientController.setCloseIesperado(true);
      // La aplicación se está pausando (puede ir a segundo plano)
      clientController.getSegundoPlano(false);
      print('La aplicación se está pausando (yendo a segundo plano)');
    } else if (state == AppLifecycleState.resumed) {
      // La aplicación se cierra completamente
      print('La aplicación se está Reaunudandose nuevamente');
      clientController.setCloseIesperado(false);
      clientController.getSegundoPlano(true);
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
              ? CustomAppBar() //aqui paso el id del profesional que es el nombre de la imagen
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
                            label: 'Estadística'),
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
  CustomAppBar({Key? key}) : super(key: key);

  @override
  //Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize =>
      const Size.fromHeight(70); // Ajusta el tamaño del AppBar aquí
  final ClientsScheduledController clientCon =
      Get.find<ClientsScheduledController>();

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
                backgroundImage: NetworkImage(
                    '${Env.apiEndpoint}/images/${logUser.imageUrlLoggedIn}'), //todo Modo de cargar la foto
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
                SizedBox(
                  height: 5,
                ),
                Text(
                  logUser.nameUserLoggedIn,
                  style: const TextStyle(
                    color: const Color.fromARGB(255, 43, 44, 49),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const Text(
                  'Barbero',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 43, 44, 49),
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ],
        );
      }),
      actions: [
        GetBuilder<LoginController>(builder: (_) {
          return Row(
            children: [
              InkWell(
                onTap: () {
                  //verifico si esta atendiendo a alguien no puede leer un nuevo codigo
                  if (clientCon.verificateValueTimers() == true ||
                      _.usserPermissionQr == 1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GetBuilder<LoginController>(builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ), //this right here
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF18254),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Text(
                                          'Mensaje',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 166,
                                  child: Column(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 20,
                                              left: 16,
                                              right: 16,
                                              bottom: 10),
                                          child: Text(
                                              'No puede leer un nuevo código de entrada, debe salir de la aplicación primero')),
                                      //

                                      ButtonBar(
                                        alignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 26.0),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF2B3141)),
                                            ),
                                            onPressed: () async {
                                              // Lógica para enviar el comentario

                                              // Cerrar el primer modal
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.check,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                const Text(
                                                  'Aceptar',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                      },
                    );
                  } else {
                    Get.toNamed(
                      '/QRViewExample',
                    );
                  }
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
                    //verificar si no tiene servicios activos
                    //mostrar un mensaje si no pudiera salir
                    //Y de igual forma si pudiera preguntarle si realmente quiere salir

                    //ESTE ES PQARA CUANDO VA A SALIR SABER SI PUEDE O NO
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GetBuilder<LoginController>(builder: (_) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ), //this right here
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF18254),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Text(
                                          'Mensaje',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30,
                                              left: 16,
                                              right: 16,
                                              bottom: 10),
                                          child: clCont
                                                      .verificateValueTimers() ==
                                                  true
                                              ? Text(
                                                  'No puedes salir del sistema, tienes clientes atendiendo!')
                                              : Text(
                                                  'Deseas salir de la aplicación?                         ')),
                                      //

                                      ButtonBar(
                                        alignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 26.0),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF2B3141)),
                                            ),
                                            onPressed: () async {
                                              // Lógica para enviar el comentario

                                              // Cerrar el primer modal
                                              Navigator.pop(context);
                                            },
                                            child: (clientCon
                                                        .verificateValueTimers() ==
                                                    true)
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        MdiIcons.check,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      const Text(
                                                        'Aceptar',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Icon(
                                                        MdiIcons.cancel,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      const Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          if (!clCont.verificateValueTimers())
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsetsGeometry>(
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 26.0),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xFF2B3141)),
                                              ),
                                              onPressed: () async {
                                                //todo falta llamar un metodo aqui
                                                //SACAR DEL PUESTO DE TRABAJO AL BARBERO
                                                //
                                                // Lógica para enviar el comentario

                                                //LLAMAR AL ENPOINT PARA SACAR DEL PUESTO DE TRABAJO
                                                _.exitPostworking(
                                                    "Professional");

                                                _.exit(_.tokenUserLoggedIn);

                                                // Cerrar el primer modal
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    MdiIcons.exitToApp,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  const Text(
                                                    '  Salir  ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                      },
                    );

                    //todooooooooooooooooooooooooooooooooooooooooo
                    // Get.offAllNamed('/LoginFormPage');
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
          );
        }),
      ],
    );
  }
}
