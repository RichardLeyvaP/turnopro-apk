// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:turnopro_apk/Controllers/login.controller.dart';

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
    const HomePage(), // Página 4
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
    double borderRadiusValue = 12;
    const Color colorVariable = Color.fromARGB(255, 26, 50, 82);
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

    return Scaffold(
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
    );
  }

//ESTA ES LA PAGINA PRINCIPAL CON LOS CARDS
//VARIABLES A UTILIZAR
  final size = 160.0;
  final twoPi = 3.14 * 2;
  Column homePageBody(
      double borderRadiusValue,
      BuildContext context,
      Color colorVariable,
      Color colorBottom,
      String titleCart,
      String descriptionTitleCart,
      IconData iconCart) {
    int totalSeconds = 125; // Tiempo total en segundos
    int remainingSeconds = totalSeconds; // Inicialmente,
    String segundos = "";
    String mensaj = "Tiempo Restante";
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color.fromARGB(255, 241, 130, 84);
    double fontSizeText = 10;

    return Column(
      children: [
        Expanded(
            flex: 1, // 20% del espacio disponible para esta parte
            // child: bannerProfile(context),

            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadiusValue)),
                  color: const Color.fromARGB(255, 241, 130, 84),
                ),
                child: Center(
                  // This Tween Animation Builder is Just For Demonstration, Do not use this AS-IS in Projects
                  // Create and Animation Controller and Control the animation that way.
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(seconds: totalSeconds),
                    builder: (context, value, _) {
                      remainingSeconds = (totalSeconds - (totalSeconds * value))
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
                        fontSizeText = 14;
                      } else {
                        mensaj = "Tiempo Restante";
                      }

                      return SizedBox(
                        width: size,
                        height: size,
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
                                width: size,
                                height: size,
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
                                width: size - 40,
                                height: size - 40,
                                decoration: BoxDecoration(
                                    color: colorInicialCirculo,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$minutes :',
                                          style: TextStyle(
                                              fontSize: 45,
                                              color: colorInicial,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Text(
                                          "$segundos$seconds",
                                          style: TextStyle(
                                              fontSize: 45,
                                              color: colorInicial,
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
              ),
            )),
        Expanded(
            flex: 2, // 85% del espacio disponible para esta parte
            child: SingleChildScrollView(
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
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                '/clients',
                              );
                            },
                            child: const Text(
                              '     MIS CLIENTES',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                '/CodeQrPage',
                              );
                            },
                            child: const Text(
                              '     Codigo-Qr',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
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
                                    '/servicesProductsPage',
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
                                  // Get.toNamed(
                                  //   '/apiUsers',
                                  // );
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
                                        const Duration(milliseconds: 2500),
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
                                    Icons.star_border),
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
      height: (MediaQuery.of(context).size.height * 0.24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      fontSize: 17,
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: true, //RLP Oculta la flecha de retroceso
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      title: Row(
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
            child: Swing(
              duration: const Duration(seconds: 4),
              delay: const Duration(seconds: 2),
              child: CircleAvatar(
                backgroundImage: AssetImage(imageDirection),
                radius: 25, // Ajusta el tamaño del círculo aquí
              ),
            ),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width *
                0.02), //Espacio entre foto perfil y el saludo y el nombre
          ), // Espacio entre la imagen y el texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Pulse(
                duration: const Duration(seconds: 5),
                delay: const Duration(seconds: 2),
                infinite: true,
                child: const Text(
                  'Hola',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              BounceInUp(
                duration: const Duration(seconds: 2),
                delay: const Duration(seconds: 1),
                child: Text(
                  nameUser,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        GetBuilder<LoginController>(builder: (_) {
          return InkWell(
            onTap: () {
              _.exit();
              Get.offAllNamed('/login');
            },
            child: Lottie.network(
              "https://lottie.host/f12c9938-f79a-493a-9170-89962542aeca/SQhtYt7Ml2.json",
              height: 40,
              width: 40,
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
