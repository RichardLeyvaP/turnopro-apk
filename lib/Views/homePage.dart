// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/product.controller.dart';
import 'package:turnopro_apk/Controllers/service.controller.dart';
import 'package:turnopro_apk/Controllers/shoppingCart.controller.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final List<Widget> _pages = [
    // homePageBody(borderRadiusValue, context, colorVariable, colorBottom,
    //     titleCart, descriptionTitleCart, iconCart), // Página 0
    const AgendaPage(), // Página 1
    const AgendaPage(), // Página 1
    const NotificationsPage(), // Página 2
    const StatisticsPage(), // Página 3
    HomePage(), // Página 4
  ];

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
    ServiceController controllerService = ServiceController();
    Get.put(controllerService);
    ProductController controllerProduct = ProductController();
    Get.put(controllerProduct);
    ShoppingCartController controllerShoppingCart = ShoppingCartController();
    Get.put(controllerShoppingCart);

    double borderRadiusValue = 12;
    const Color colorVariable = Color(0xFF2B3141); //CARAGANDO COLOR HEXADECIMAL
    const Color colorBottom =
        Color.fromARGB(255, 231, 233, 233); // Define el color a través de una
    const iconCart = (Icons.perm_contact_calendar);
    String titleCart = 'Agenda';
    String descriptionTitleCart = 'Clientes Agendados';

    List<Widget> _pages = [
      homePageBody(
          borderRadiusValue,
          context,
          colorVariable,
          colorBottom,
          titleCart,
          descriptionTitleCart,
          iconCart,
          controllerShoppingCart), // Página 0
      const AgendaPage(), // Página 1
      const NotificationsPage(), // Página 2
      const StatisticsPage(), // Página 3
      HomePage(), // Página 4
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
                  fixedColor: const Color(0xFFF18254),
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
      IconData iconCart,
      ShoppingCartController controllerShoppingCart) {
    //todo1
    int totalSeconds = 150; // Tiempo total en segundos
    int remainingSeconds = totalSeconds; // Inicialmente,
    String segundos = "";
    String mensaj = "";
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFF18254);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.02); //todo3
    final sizeClock = (MediaQuery.of(context).size.width * 0.3);

    return Column(
      //Cart anaranjado grande inicial que tiene el cronometro
      children: [
        Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadiusValue)),
                  color: const Color(0xFFF18254),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*todo texto arriba */ const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Cliente en espera',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                    ),
                    /*todo cronometro*/ Center(
                      child: TweenAnimationBuilder(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: totalSeconds),
                        builder: (context, value, _) {
                          remainingSeconds =
                              (totalSeconds - (totalSeconds * value))
                                  .ceil(); // Calcula los segundos restantes

                          int minutes = remainingSeconds ~/
                              60; // Calcula los minutos restantes
                          int seconds = remainingSeconds %
                              60; // Calcula los segundos restantes
                          if (seconds < 10) {
                            segundos = "0";
                          } else {
                            segundos = "";
                          }
                          if (minutes == 0 && seconds == 0) {
                            mensaj = 'FINALIZADO';
                            colorInicial = Colors.red;
                            colorInicialCirculo = Colors.white;
                            fontSizeText = 10;
                          } else {
                            mensaj = "";
                          }

                          return SizedBox(
                            width: sizeClock,
                            height: sizeClock,
                            child: Stack(
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return SweepGradient(
                                        startAngle: 0.0,
                                        endAngle: twoPi,
                                        stops: [value, value],
                                        // 0.0 , 0.5 , 0.5 , 1.0
                                        center: Alignment.center,
                                        colors: [
                                          Colors.white,
                                          Colors.grey.withAlpha(55)
                                        ]).createShader(rect);
                                  },
                                  child: Container(
                                    width: sizeClock,
                                    height: sizeClock,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: Image.asset(
                                                    "assets/images/radial_scale.png")
                                                .image)),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: sizeClock - 40,
                                    height: sizeClock - 40,
                                    decoration: BoxDecoration(
                                        color: colorInicialCirculo,
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$minutes :',
                                              style: TextStyle(
                                                  fontSize:
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05), //todo2
                                                  fontFamily:
                                                      GoogleFonts.orbitron()
                                                          .fontFamily,
                                                  color: colorInicial,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Text(
                                              "$segundos$seconds",
                                              style: TextStyle(
                                                  fontSize:
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                                  color: colorInicial,
                                                  fontFamily:
                                                      GoogleFonts.orbitron()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          mensaj,
                                          style: TextStyle(
                                              fontSize: fontSizeText,
                                              color: colorInicial,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    )),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    /*todo cart*/ Padding(
                      padding: const EdgeInsets.only(
                          left: 8, top: 8, right: 8, bottom: 6),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            //todo
                            children: [
                              Container(
                                height: (MediaQuery.of(context).size.height *
                                    0.115),
                                width:
                                    (MediaQuery.of(context).size.width * 0.20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors
                                        .white, // Color blanco para el borde
                                    width:
                                        1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                  ),
                                  color: const Color(0xFFF18254),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Get.snackbar(
                                      'Mensaje',
                                      'Cancelar',
                                      duration:
                                          const Duration(milliseconds: 2000),
                                    );
                                    //_.deletenotification(index);
                                  },
                                  icon: Icon(
                                    MdiIcons.thumbDown,
                                    color: Colors.white,
                                    size: (MediaQuery.of(context).size.height *
                                        0.04),
                                  ),
                                ),
                              ),
                              Container(
                                height: (MediaQuery.of(context).size.height *
                                    0.115),
                                width:
                                    (MediaQuery.of(context).size.width * 0.8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 22,
                                          ),
                                          Text(
                                            'William Miller',
                                            style: TextStyle(
                                                height: 1.0,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 2),
                                        child: Text('Masaje capilar',
                                            style: TextStyle(
                                              height: 1.0,
                                              fontSize: 17,
                                              color:
                                                  Color.fromARGB(180, 0, 0, 0),
                                            )),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 2),
                                        child: Text(
                                          'Corte de Cabello',
                                          style: TextStyle(
                                            height: 1.0,
                                            fontSize: 17,
                                            color: Color.fromARGB(180, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.timer,
                                              color: const Color.fromARGB(
                                                  180, 0, 0, 0),
                                              size: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.016)),
                                          const Text('15 Minutos',
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    180, 0, 0, 0),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: (MediaQuery.of(context).size.height *
                                    0.115),
                                width:
                                    (MediaQuery.of(context).size.width * 0.20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors
                                          .white, // Color blanco para el borde
                                      width:
                                          1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                    ),
                                    color:
                                        const Color.fromARGB(255, 32, 32, 32),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: IconButton(
                                  onPressed: () {
                                    Get.snackbar(
                                      'Mensaje',
                                      'Aceptar',
                                      duration:
                                          const Duration(milliseconds: 2000),
                                    );
                                    // _.deletenotification(index);
                                  },
                                  icon: Icon(
                                    MdiIcons.thumbUp,
                                    color: Colors.white,
                                    size: (MediaQuery.of(context).size.height *
                                        0.04),
                                  ),
                                ),
                              ),
                            ],
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
              child: Container(
                color: const Color.fromARGB(255, 231, 232, 234),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        GetBuilder<ServiceController>(builder: (_serv) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 241, 130, 84),
                                      ),
                                    ),
                                    barrierDismissible: true,
                                  );
                                  await controllerShoppingCart.loadCart();
                                  await _serv.loadListService();
                                  // Oculta el indicador de carga y navega a la página del carrito
                                  Get.back(); // Cierra el diálogo

                                  Get.toNamed(
                                    '/servicesProductsPage',
                                  );
                                },
                                child: const Text(
                                  '  Servicio y productos  ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  '/clients',
                                );
                              },
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
                                  '/NotificationsPageProf',
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
                                  duration: const Duration(milliseconds: 2500),
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
                                  const Color(0xFFF18254),
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

  String nameUser = 'Paula Rego';
  String imageDirection = 'assets/images/image_perfil.jpg';

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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Hola',
                  style: TextStyle(
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
                InkWell(
                  onTap: () {
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

/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}*/

class HomePage extends StatefulWidget {
  @override
  _YourPageViewScreenState createState() => _YourPageViewScreenState();
}

class _YourPageViewScreenState extends State<HomePage> {
  PageController _pageController = PageController();

  bool isPageViewEnabled =
      false; // Variable para habilitar/deshabilitar PageView.
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Probando PageView')),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPageViewEnabled = !isPageViewEnabled;
                  });
                },
                child:
                    Text(isPageViewEnabled ? 'Deshab Scroll' : 'Habili Scroll'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Cambiar a la siguiente página.
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Text('Siguiente Página'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cambiar a la siguiente página.
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                child: Text('Atras'),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: isPageViewEnabled
                  ? BouncingScrollPhysics() // Habilitar desplazamiento
                  : NeverScrollableScrollPhysics(), // Deshabilitar desplazamiento
              onPageChanged: (index) {
                // Almacena el índice de la página actual cuando cambia.

                setState(() {
                  currentPageIndex = index;
                });
              },
              children: [
                // Agrega tus páginas aquí
                Container(
                  color: Colors.red,
                  child: Center(
                    child: Text('Página 1'),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Página 2'),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text('Página 3'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//****************************************************************************** */
//****************************************************************************** */
