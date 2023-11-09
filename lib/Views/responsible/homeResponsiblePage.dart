// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
//import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';

class HomeResponsiblePages extends StatefulWidget {
  const HomeResponsiblePages({super.key});

  @override
  State<HomeResponsiblePages> createState() => _HomeResponsiblePagesState();
}

class _HomeResponsiblePagesState extends State<HomeResponsiblePages> {
  final ShoppingCartController controllerShoppingCart =
      Get.find<ShoppingCartController>();

  final List<Widget> _pages = [
    // homePageBody(borderRadiusValue, context, colorVariable, colorBottom,
    //     titleCart, descriptionTitleCart, iconCart), // Página 0
    const AgendaPage(), // Página 1
    const AgendaPage(), // Página 1
    const NotificationsPage(), // Página 2
    const StatisticsPage(), // Página 3
    const HomePage(), // Página 4
  ];

  @override
  void initState() {
    super.initState();
    controllerShoppingCart.loadOrderDeleteCar(13); //todo REVISAR valor fijo
    iniciarLlamadaCada10Segundos();
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
      controllerShoppingCart.loadOrderDeleteCar(13); //todo REVISAR valor fijo
    });
  }

//inicializando en 0 para que cargue de inicio la primera pagina
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    //CON ESTO GARANDIZO QUE SI DA EN EL MISMO TAB QUE NO VUELVA A DIBUJAR EL WIDGET,SOLO QUE DIBUJE CUANDO DE EN UNO DIFERENTE
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _pages[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double borderRadiusValue = 12;
    const Color colorVariable = Color(0xFF2B3141); //CARAGANDO COLOR HEXADECIMAL
    const Color colorBottom =
        Color.fromARGB(255, 231, 233, 233); // Define el color a través de una
    const iconCart = (Icons.perm_contact_calendar);
    String titleCart = 'Agenda';
    String descriptionTitleCart = 'Clientes Agendados';

    List<Widget> _pages = [
      homePageBody(borderRadiusValue, context, colorVariable, colorBottom,
          titleCart, descriptionTitleCart, iconCart), // Página 0
      const AgendaPage(), // Página 1
      const NotificationsPage(), // Página 2
      const StatisticsPage(), // Página 3
      const HomePage(), // Página 4
    ];

    return FadeIn(
      duration: const Duration(seconds: 2),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 232, 234),
        appBar: CustomAppBar(),
        body: _pages[_selectedIndex], // Muestra la página actual
        //body: homePageBody(borderRadiusValue, context, colorVariable, colorBottom, titleCart, descriptionTitleCart, iconCart),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.012)),
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
                  fixedColor: const Color.fromARGB(255, 241, 130, 84),
                  currentIndex: _selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: _navigateBottomBar,
                  items: [
                    BottomNavigationBarItem(
                        icon: Badge(
                          label: Text('$_selectedIndex'),
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
                          label: Text('$_selectedIndex'),
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
      ),
    );
  }

//ESTA ES LA PAGINA PRINCIPAL CON LOS CARDS
//VARIABLES A UTILIZAR
  final twoPi = 3.14 * 2;
  Column homePageBody(
      double borderRadiusValue,
      BuildContext context,
      Color colorVariable,
      Color colorBottom,
      String titleCart,
      String descriptionTitleCart,
      IconData iconCart) {
    return Column(
      children: [
        Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadiusValue)),
                  color: const Color(0xFF2B3141), //CARAGANDO COLOR HEXADECIMAL,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*todo texto arriba */ const Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Últimas Notificaciones',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    /*todo cart1 servicios*/ Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, top: 4, right: 8, bottom: 6),
                          child: FadeIn(
                            duration: const Duration(seconds: 2),
                            child: Column(
                              children: [
                                GetBuilder<ShoppingCartController>(
                                    builder: (contShopp) {
                                  if (contShopp.load_request == true) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return showRequestsDelete(
                                        context, contShopp);
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
            flex: 14, // 85% del espacio disponible para esta parte
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                child: Container(
                  color: const Color.fromARGB(255, 231, 232, 234),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: cartsHome(
                                    context,
                                    borderRadiusValue,
                                    colorVariable,
                                    colorBottom,
                                    titleCart,
                                    descriptionTitleCart,
                                    iconCart),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    '/NotificationsPageNew',
                                  );
                                },
                                child: cartsHome(
                                    context,
                                    borderRadiusValue,
                                    const Color.fromARGB(255, 81, 93, 117),
                                    colorBottom,
                                    'Notificaciones',
                                    'Tus Notificaciones',
                                    Icons.notifications),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * 0.01),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.snackbar(
                                    'Mensaje',
                                    'Aqui van las Estadisticas',
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    showProgressIndicator: true,
                                    progressIndicatorBackgroundColor:
                                        const Color.fromARGB(255, 81, 93, 117),
                                    progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color.fromARGB(255, 241, 130, 84)),
                                    overlayBlur: 3,
                                  );
                                },
                                child: cartsHome(
                                    context,
                                    borderRadiusValue,
                                    const Color.fromARGB(255, 177, 174, 174),
                                    colorBottom,
                                    'Estadisticas',
                                    'Revisa Tus Ingresos',
                                    Icons.bar_chart),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    '/CoexistencePage',
                                  );
                                },
                                child: cartsHome(
                                    context,
                                    borderRadiusValue,
                                    const Color.fromARGB(255, 241, 130, 84),
                                    colorBottom,
                                    'Convivencia',
                                    'Cumplimiento de Reglas',
                                    Icons.star),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

//ESTRUCTURA DE LOS CARTS
  Container cartsHome(
      BuildContext context,
      double borderRadiusValue,
      Color colorVariable,
      Color colorBottom,
      String titleCart,
      String descriptionTitleCart,
      iconCart) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.46), //Tamaño de los Cards
      height: (MediaQuery.of(context).size.height * 0.20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 20, // Tamaño del CircleAvatar
                backgroundColor: colorBottom, // Color de fondo del CircleAvatar
                child: Icon(
                  iconCart, // Icono que deseas mostrar
                  size: 30, // Tamaño del icono
                  color:
                      const Color.fromARGB(255, 26, 50, 82), // Color del icono
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleCart,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  descriptionTitleCart,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
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
                    fontSize: 18,
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
// Define tus páginas correspondientes aquí
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Perfil Page'));
  }
}

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Agenda Page'));
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notificaciones Page'));
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Estadisticas Page'));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}

//****************************************************************************** */
//****************************************************************************** */
Column showRequestsDelete(context, ShoppingCartController contShopp) {
  List<Widget> widgets = [];
  String titulo = "";
  bool service = false;
  /* if (fin > 2) {
    fin = 2;
  }*/

  for (int i = 0; i < contShopp.orderDeleteCar.length; i++) {
    if (contShopp.orderDeleteCar[i].nameService == '') {
      titulo = 'Eliminación de Producto';
      service = false;
    } else {
      titulo = 'Eliminación de Servicio';
      service = true;
    }
    print(
        '---------------------------------------------************---------------------------------------');
    print(contShopp.orderDeleteCar[i].hora);
    print(contShopp.orderDeleteCar[i].id);
    print(contShopp.orderDeleteCar[i].is_product);
    widgets.add(
      FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height * 0.120),
                    width: (MediaQuery.of(context).size.width * 0.20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Color blanco para el borde
                        width:
                            1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                      ),
                      color: const Color.fromARGB(255, 241, 130, 84),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await contShopp.requestDelete(
                            contShopp.orderDeleteCar[i].id, 0);
                        await contShopp
                            .loadOrderDeleteCar(13); //todo REVISAR valor fijo
                        Get.snackbar(
                          'Mensaje',
                          'Rechazada la solicitud',
                          duration: const Duration(milliseconds: 1000),
                        );
                        //_.deletenotification(index);
                      },
                      icon: Icon(
                        MdiIcons.thumbDown,
                        color: Colors.white,
                        size: (MediaQuery.of(context).size.height * 0.04),
                      ),
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height * 0.120),
                    width: (MediaQuery.of(context).size.width * 0.8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                Text(
                                  titulo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AutofillHints.familyName,
                                      fontSize: 22),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      service
                                          ? contShopp
                                              .orderDeleteCar[i].nameService
                                              .toString()
                                          : contShopp
                                              .orderDeleteCar[i].nameProduct
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      contShopp.orderDeleteCar[i].hora
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(180, 0, 0, 0),
                                ),
                                Text(
                                  contShopp.orderDeleteCar[i].nameProfesional
                                      .toString(),
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.height *
                                              0.018),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(180, 0, 0, 0),
                                ),
                                Text(
                                  contShopp.orderDeleteCar[i].nameClient,
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.height *
                                              0.018),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height * 0.120),
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
                    child: IconButton(
                      onPressed: () async {
                        await contShopp
                            .orderDelete(contShopp.orderDeleteCar[i].id);
                        await contShopp
                            .loadOrderDeleteCar(13); //todo REVISAR valor fijo
                        Get.snackbar(
                          'Mensaje',
                          'Eliminando solicitud',
                          duration: const Duration(milliseconds: 1000),
                        );
                        // _.deletenotification(index);
                      },
                      icon: Icon(
                        MdiIcons.thumbUp,
                        color: Colors.white,
                        size: (MediaQuery.of(context).size.height * 0.04),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
  if (contShopp.orderDeleteCar.isEmpty) {
    widgets.add(const Center(
      child: Text(
        'No hay solicitudes a eliminar.',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ));
  }

  return Column(
    children: widgets,
  );
}
