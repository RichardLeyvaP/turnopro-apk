// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
//import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/env.dart';

class HomeResponsiblePages extends StatefulWidget {
  const HomeResponsiblePages({super.key});

  @override
  State<HomeResponsiblePages> createState() => _HomeResponsiblePagesState();
}

class _HomeResponsiblePagesState extends State<HomeResponsiblePages> {
  late final CoexistenceController coexistenceController;
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();
  final LoginController controllerLogin = Get.find<LoginController>();

  final PagesConfigResponController pagesConfigReC =
      Get.find<PagesConfigResponController>();

  @override
  void initState() {
    super.initState();
    coexistenceController = Get.put<CoexistenceController>(
        CoexistenceController(),
        permanent: true);
  }

  @override
  void dispose() {
    // Asegúrate de cancelar el temporizador al eliminar el widget

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 2),
      child:
          GetBuilder<PagesConfigResponController>(builder: (pagesConfigRespC) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 231, 232, 234),
          appBar: pagesConfigRespC.selectedIndexResp == 0
              ? const CustomAppBar()
              : null,
          body: PageView(
            controller: pagesConfigRespC.pageRespController,
            physics: const NeverScrollableScrollPhysics(),
            children: pagesConfigRespC.pages,
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
                child: GetBuilder<ClientsCoordinatorController>(
                    builder: (controClient) {
                  return BottomNavigationBar(
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      unselectedItemColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 43, 44, 49),
                      fixedColor: const Color(0xFFF18254),
                      currentIndex: pagesConfigRespC.selectedIndexResp,
                      type: BottomNavigationBarType.fixed,
                      onTap: (index) => pagesConfigRespC.onTabTapped(index),
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
                                  '${controClient.clientsScheduledListBranchLength}'),
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

//ESTA ES LA PAGINA PRINCIPAL CON LOS CARDS
//VARIABLES A UTILIZAR
}

//DEFINIENDO EL AppBar
// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  //Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize =>
      const Size.fromHeight(70); // Ajusta el tamaño del AppBar aquí

  @override
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
                  color: const Color.fromARGB(255, 43, 44, 49),
                  width: 2, // Ajusta el ancho del borde según tus preferencias
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${Env.apiEndpoint}/images/${logUser.imageUrlLoggedIn}'),
                radius: 25, // Ajusta el tamaño del círculo aquí
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width *
                  0.02), //Espacio entre foto perfil y el saludo y el nombre
            ), // Espacio entre la imagen y el texto
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Encargado',
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
                  if (_.usserPermissionQr == 1) {
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
                                    color: Color(0xFF2B3141),
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
              InkWell(
                onTap: () {
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
                                  color: const Color(0xFF2B3141),
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
                                    const Padding(
                                        padding: EdgeInsets.only(
                                            top: 30,
                                            left: 16,
                                            right: 16,
                                            bottom: 10),
                                        child: Text(
                                            'Deseas salir de la aplicación?                         ')),
                                    //

                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
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
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
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
                                            //todo falta llamar un metodo aqui
                                            //SACAR DEL PUESTO DE TRABAJO AL BARBERO

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
              ),
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

//****************************************************************************** */
//****************************************************************************** */
