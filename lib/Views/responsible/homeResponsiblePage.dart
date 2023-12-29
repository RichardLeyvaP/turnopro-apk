// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
//import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';

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
    if (controllerLogin.branchIdLoggedIn != null) {
      controllerShoppingCart
          .loadOrderDeleteCar(controllerLogin.branchIdLoggedIn!);
      iniciarLlamadaCada10Segundos();
    }
  }

  @override
  void dispose() {
    // Asegúrate de cancelar el temporizador al eliminar el widget
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;

  void iniciarLlamadaCada10Segundos() {
    // Cancela cualquier temporizador existente para evitar duplicaciones
    _timer?.cancel();

    // Establece un temporizador que llama a la función cada 20 segundos
    _timer = Timer.periodic(const Duration(seconds: 20), (Timer timer) {
      if (controllerLogin.branchIdLoggedIn != null) {
        controllerShoppingCart
            .loadOrderDeleteCar(controllerLogin.branchIdLoggedIn!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 2),
      child:
          GetBuilder<PagesConfigResponController>(builder: (pagesConfigRespC) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 231, 232, 234),
          appBar:
              pagesConfigRespC.selectedIndexResp == 0 ? CustomAppBar() : null,
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
                child: BottomNavigationBar(
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
                          icon: Badge(
                            label:
                                Text('${pagesConfigRespC.selectedIndexResp}'),
                            child: Icon(
                              Icons.person,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ),
                          label: 'Perfil'),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.storage,
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                          label: 'Agenda'),
                      BottomNavigationBarItem(
                          icon: Badge(
                            label:
                                Text('${pagesConfigRespC.selectedIndexResp}'),
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
                          Icons.insert_emoticon,
                          size: MediaQuery.of(context).size.width * 0.08,
                        ),
                        label: 'Home',
                      ),
                    ])),
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
  CustomAppBar({super.key});

  @override
  //Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize =>
      const Size.fromHeight(70); // Ajusta el tamaño del AppBar aquí

  String imageDirection = 'assets/images/Responsable.jpg';

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
                  color: const Color.fromARGB(255, 32, 32, 32),
                  width: 2, // Ajusta el ancho del borde según tus preferencias
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(imageDirection),
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
                const Text(
                  'Encargado del Local',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
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
              //_.exit();
              _.exit(_.tokenUserLoggedIn);
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
                InkWell(
                  onTap: () {
                    _.exit(_.tokenUserLoggedIn);
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
            ),
          );
        }),
      ],
    );
  }
}

//****************************************************************************** */
//****************************************************************************** */
