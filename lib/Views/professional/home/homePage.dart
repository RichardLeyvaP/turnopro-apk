// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
//import 'package:lottie/lottie.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Utility/utils.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/modalHelperClientSchedule.dart';
import 'package:turnopro_apk/env.dart';
import 'package:intl/intl.dart';

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
  final CoexistenceController coexistenceController =
      Get.find<CoexistenceController>();

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
    if (state == AppLifecycleState.paused) {
      LocalStorage.prefs.setBool('iAmActive', false);
      clientController.setCloseIesperado(true);
      loginController.getSegundoPlano(0);
      await LocalStorage.prefs.setBool('state_S_plano', true);
      // Guardar la marca de tiempo cuando la app va a segundo plano
      await LocalStorage.prefs
          .setString('background_time', DateTime.now().toIso8601String());
      print(
          'La aplicación se está pausando (yendo a segundo plano)-timer 1 = ${LocalStorage.prefs.getInt('timer1')}');
      print(
          'La aplicación se está pausando (yendo a segundo plano)-timer 2 = ${LocalStorage.prefs.getInt('timer2')}');
      print(
          'La aplicación se está pausando (yendo a segundo plano)-timer 3 = ${LocalStorage.prefs.getInt('timer3')}');
      print(
          'La aplicación se está pausando (yendo a segundo plano)-timer 4 = ${LocalStorage.prefs.getInt('timer4')}');
      //reinicio el servicio
      // await restartService();
    } else if (state == AppLifecycleState.resumed) {
      LocalStorage.prefs.setBool('iAmActive', true);
      clientController.setCloseIesperado(false);
      loginController.getSegundoPlano(3);
      print('mirando: Setting state_S_plano to false');
      bool result = await LocalStorage.prefs.setBool('state_S_plano', false);
      print('Set state_S_plano result: $result');
      print('La aplicación se está Reaunudandose nuevamente');
      print(
          'La aplicación se está LocalStorage.prefs.getBool(verificatePhoto):${LocalStorage.prefs.getBool('verificatePhoto')}');

      //hacer esto solamnete si esta ya con el qr leido
      if (loginController.usserPermissionQr == 1 &&
          LocalStorage.prefs.getBool('verificatePhoto') == false) {
        Get.dialog(
          const Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFFDAE2A),
                  ),
                  SizedBox(height: 16),
                  Text('Actualizando datos...',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        ); //Get.back();

        // Recuperar la marca de tiempo desde SharedPreferences
        String? backgroundTimeString =
            LocalStorage.prefs.getString('background_time');
        if (backgroundTimeString != null) {
          DateTime backgroundTime = DateTime.parse(backgroundTimeString);
          final difference = DateTime.now().difference(backgroundTime);
          // Convierte la diferencia a minutos
          final differenceInMinutes = difference.inSeconds;
          print(
              'La aplicación estuvo en segundo plano por ${difference.inSeconds} segundos.');
          //aqui mando el tiempo que estubo fuera
          //y ya ahi reinicio ese reloj
          await clientController.getShowClock(
              differenceInMinutes,
              loginController.idProfessionalLoggedIn,
              loginController.tokenUserLoggedIn);

          // await Future.delayed(Duration(seconds: 5));
          // loginController.setIsLoggingIn(true);

          // Aquí puedes manejar la lógica que necesites con el tiempo en segundo plano
        }
        Get.back();
      }
      await LocalStorage.prefs.setBool('verificatePhoto', false);
      //reinicio el servicio
      //  await restartService();
    } else if (state == AppLifecycleState.inactive) {
      LocalStorage.prefs.setBool('iAmActive', false);
      // La aplicación se cierra completamente
      print('La aplicación se está inactiva');
      // Agrega tu lógica para guardar en la base de datos aquí.
    } else if (state == AppLifecycleState.detached) {
      LocalStorage.prefs.setBool('iAmActive', false);
      // La aplicación se cierra completamente
      print('La aplicación se está cerrando completamente');
      // Agrega tu lógica para guardar en la base de datos aquí.
    }
  }

  @override
  Widget build(BuildContext context) {
    controllerLogin.getScreenResolution(context);
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
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
                      unselectedItemColor: Color.fromARGB(155, 177, 173, 173),
                      backgroundColor: Colors.white,
                      fixedColor: const Color(0xFFFDAE2A),
                      currentIndex: pagesConfigController.selectedIndex,
                      type: BottomNavigationBarType.fixed,
                      onTap: (index) async {
                        loginController.inTheClock(false);
                        print('mostrando el tap # :$index');
                        if (index == 4) //cargame las convivencias
                        {
                          //loginController.setIsLoadingFor(true);
                          Get.dialog(
                            const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFDAE2A),
                              ),
                            ),
                            barrierDismissible: false,
                          ); //Get.back();
                          await coexistenceController.fetchCoexistenceList();
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          Get.back();
                        } else if (index == 1) {
                          //loginController.setIsLoadingFor(true);
                          Get.dialog(
                            const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFDAE2A),
                              ),
                            ),
                            barrierDismissible: false,
                          ); //Get.back();
                          if (clientController.getWaitTime() == false) {
                            await clientController.fetchClientsScheduledNew(
                                loginController.idProfessionalLoggedIn,
                                loginController.branchIdLoggedIn,
                                'if (index == 1)',
                                loginController.tokenUserLoggedIn);
                          }
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          Get.back();
                        } else if (index == 2) {
                          Get.dialog(
                            const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFDAE2A),
                              ),
                            ),
                            barrierDismissible: false,
                          ); //Get.back();
                          String typeEnv = '';

                          if (loginController.chargeUserLoggedIn ==
                              'Barbero y Encargado') {
                            if (loginController.switchValue ==
                                false) //'Barbero'
                            {
                              typeEnv = 'Barbero';
                            } else {
                              typeEnv = 'Encargado';
                            }
                          } else {
                            typeEnv = loginController.chargeUserLoggedIn;
                          }
                          await notiCont.fetchNotificationList(
                              loginController.branchIdLoggedIn,
                              loginController.idProfessionalLoggedIn,
                              typeEnv,
                              'Barra de navegacion',
                              loginController.tokenUserLoggedIn);
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          Get.back();
                          /* await notiCont.fetchNotificationList(
                              loginController.branchIdLoggedIn,
                              loginController.idProfessionalLoggedIn);*/
                        } else if (index == 3) {
                          Get.dialog(
                            const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFDAE2A),
                              ),
                            ),
                            barrierDismissible: false,
                          );
                          await coexistenceController.fetchEstadist0();
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          Get.back();
                        }
                        pagesConfigController.onTabTapped(index);
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.home,
                              size: MediaQuery.of(context).size.width * 0.08,
                            ),
                            label: 'Home'),
                        controClient.clientsScheduledListLength > 0
                            ? BottomNavigationBarItem(
                                icon: Badge(
                                  backgroundColor: Color(0xFF19CF9E),
                                  label: Text(
                                      '${controClient.clientsScheduledListLength}'),
                                  child: Icon(
                                    Icons.perm_contact_calendar,
                                    size: MediaQuery.of(context).size.width *
                                        0.08,
                                  ),
                                ),
                                label: 'Agenda')
                            : BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.perm_contact_calendar,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                label: 'Agenda'),
                        notiCont.notificationListNewLength > 0
                            ? BottomNavigationBarItem(
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
                                            _notiCont
                                                .notificationListNewLength);
                                      }
                                    });

                                    if (_notiCont.notificationListNewLength !=
                                            _notiCont.notificationListBack &&
                                        _notiCont.notificationListNewLength !=
                                            0) {
                                      //  _notiCont.reproducirSound();
                                    }
                                    return Text(
                                        (_notiCont.notificationListNewLength)
                                            .toString());
                                  }),
                                  child: Icon(
                                    Icons.notifications,
                                    size: MediaQuery.of(context).size.width *
                                        0.08,
                                  ),
                                ),
                                label: 'Notificaciones')
                            : BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.notifications,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                label: 'Notificaciones'),
                        //
                        //
                        //
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
  NotificationController notiController = Get.find<NotificationController>();

  @override //todo AppBar
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, //RLP Oculta la flecha de retroceso
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      title: GetBuilder<LoginController>(//todo
          builder: (logUser) {
        return InkWell(
          onTap: () {
            loginController.addOpenSecretkey();
            print('llave secreta = ${loginController.getOpenSecretkey()}');
            if (loginController.userLoggedIn != '' &&
                loginController.getOpenSecretkey() == 5) {
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
                              color: Color(0xFFFDAE2A),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  icon: Icon(Icons.close, color: Colors.white),
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
                                    child: Text(
                                        'Deseas abrir la proxima vez con la huella digital, usuario:${loginController.userLoggedIn} ?                         ')),
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
                                                  horizontal: 18.0),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF4470F3))),
                                        onPressed: () async {
                                          //mostrar mensaje y guardar a true variable
                                          LocalStorage.prefs.setBool(
                                              'EntryFootprintOpen', true);
                                          Get.snackbar(
                                            'Mensaje',
                                            'Guardada correctamente su configuración',
                                            duration: const Duration(
                                                milliseconds: 2500),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    118, 255, 255, 255),
                                            showProgressIndicator: true,
                                            progressIndicatorBackgroundColor:
                                                const Color.fromARGB(
                                                    255, 203, 205, 209),
                                            progressIndicatorValueColor:
                                                const AlwaysStoppedAnimation(
                                                    Color(0xFF19CF9E)),
                                            overlayBlur: 3,
                                          );
                                          loginController.setOpenSecretkey(
                                              0); //vuelve a tomar el valor inicial (0)
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
                                              'SI    ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        )),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 18.0),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFFFF6750)),
                                      ),
                                      onPressed: () async {
                                        LocalStorage.prefs.setBool(
                                            'EntryFootprintOpen', false);
                                        loginController.setOpenSecretkey(
                                            0); //vuelve a tomar el valor inicial (0)
                                        // Cerrar el primer modal
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            MdiIcons.close,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'NO    ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
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
              loginController.setOpenSecretkey(0);
            }
          },
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 8), // Agrega un margen en la parte superior

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(
                  //   color: Colors.white,
                  //   width: 2, // Ajusta el ancho del borde según tus preferencias
                  // ),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white, //fondo de la imagen
                  child: ClipOval(
                    child: Image.network(
                      '${Env.apiEndpoint}/images/${logUser.imageUrlLoggedIn}',
                      fit: BoxFit
                          .cover, // Ajusta la imagen para cubrir completamente el área
                      width:
                          50, // Ancho deseado de la imagen dentro del círculo
                      height: 50,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Si la imagen se carga correctamente, mostramos la imagen
                          return child;
                        } else {
                          // Si la imagen aún se está cargando, mostramos un indicador de progreso
                          return const CircularProgressIndicator(
                            color: Color(0xFFFDAE2A),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        // Si la imagen no se puede cargar y estamos en modo de depuración, mostramos una imagen por defecto
                        if (kDebugMode) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors
                                .transparent, // Fondo transparente para que el borde sea visible
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/default_profile.jpg',
                                fit: BoxFit
                                    .cover, // Ajusta la imagen para cubrir completamente el área
                                width:
                                    50, // Ancho deseado de la imagen dentro del círculo
                                height:
                                    50, // Alto deseado de la imagen dentro del círculo
                              ),
                            ),
                          );
                        } else {
                          // Si no estamos en modo de depuración, mostramos un texto de error
                          return CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors
                                .transparent, // Fondo transparente para que el borde sea visible
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/default_profile.jpg',
                                fit: BoxFit
                                    .cover, // Ajusta la imagen para cubrir completamente el área
                                width:
                                    50, // Ancho deseado de la imagen dentro del círculo
                                height:
                                    50, // Alto deseado de la imagen dentro del círculo
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                /*  NetworkImage(
                      '${Env.apiEndpoint}/images23/${logUser.imageUrlLoggedIn}'),*/ //todo Modo de cargar la foto
                // radius: 25, // Ajusta el tamaño del círculo aquí
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
                  logUser.chargeUserLoggedIn == 'Barbero y Encargado'
                      ? TruncatedText(
                          text: logUser.nameUserLoggedIn,
                          maxLength: 13,
                          styleText: const TextStyle(
                            color: const Color.fromARGB(255, 43, 44, 49),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        )
                      : TruncatedText(
                          text: logUser.nameUserLoggedIn,
                          maxLength: 18,
                          styleText: const TextStyle(
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
          ),
        );
      }),
      actions: [
        GetBuilder<LoginController>(builder: (_) {
          return Row(
            children: [
              _.chargeUserLoggedIn == 'Barbero y Encargado'
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            Switch(
                              value: _.switchValue,
                              onChanged: (value) async {
                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFDAE2A),
                                    ),
                                  ),
                                  barrierDismissible: false,
                                ); //Get.back();
                                await Future.delayed(Duration(seconds: 1));
                                await _.setswitchValue();
                                Get.back();
                                // _.switchValue = value;
                              },
                              activeColor:
                                  Colors.blue, // Color cuando está activado
                              activeTrackColor: const Color.fromARGB(
                                  255,
                                  129,
                                  193,
                                  223), // Color de la pista cuando está activado
                              inactiveThumbColor: const Color(
                                  0xFF2B3141), // Color del pulgar cuando está desactivado
                              inactiveTrackColor: Color.fromARGB(255, 87, 90,
                                  99), // Color de la pista cuando está desactivado
                            ),
                            GetBuilder<NotificationController>(
                                builder: (_notiCont) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // Se ejecutará después de que se haya construido el widget
                                //define que tipo de saludo dar dependiendo de la hora
                                if (_notiCont.notificationListNewLengthEncarg !=
                                    _notiCont.notificationListBackEncarg) {
                                  _notiCont.updateNotificationListBackEncarg(
                                      _notiCont
                                          .notificationListNewLengthEncarg);
                                }
                              });

                              if (_notiCont.notificationListNewLengthEncarg !=
                                      _notiCont.notificationListBackEncarg &&
                                  _notiCont.notificationListNewLengthEncarg !=
                                      0) {
                                //  _notiCont.reproducirSound();
                              }
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Badge(
                                    backgroundColor: _notiCont
                                                .notificationListNewLengthEncarg ==
                                            0
                                        ? Color.fromARGB(255, 231, 232, 234)
                                        : null,
                                    alignment: AlignmentDirectional(1.45, 0.85),
                                    label: _notiCont
                                                .notificationListNewLengthEncarg >
                                            0
                                        ? Text(
                                            (_notiCont
                                                    .notificationListNewLengthEncarg)
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : null,
                                    child: Text(
                                      _.switchValue ? '  Barbero' : 'Encargado',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: const Color(0xFF2B3141),
                                          height: 1),
                                    ),
                                  )
                                  // Ajusta el espacio entre el texto y el Badge
                                ],
                              );
                            }),
                          ],
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(
                width: 14,
              ),
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
                                    color: Color(0xFFFDAE2A),
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
                                                    horizontal: 18.0),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF4470F3)),
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
                  } else if (_.usserPermissionQr == 2) {
                    Get.snackbar(
                      'Mensaje',
                      'Debe de esperar la respuesta a su solicitud',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor: const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                          const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                          const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
                      overlayBlur: 3,
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
                                    color: Color(0xFFFDAE2A),
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
                                                      horizontal: 18.0),
                                                ),
                                                backgroundColor: (clientCon
                                                            .verificateValueTimers() ==
                                                        true)
                                                    ? MaterialStateProperty.all<
                                                            Color>(
                                                        Color(0xFF4470F3))
                                                    : MaterialStateProperty.all<
                                                            Color>(
                                                        Color(0xFFFF6750))),
                                            onPressed: () async {
                                              // Lógica para enviar el comentario
                                              //LLAMAR AL ENPOINT PARA SACAR DEL PUESTO DE TRABAJO
                                              if (clientCon
                                                      .verificateValueTimers() ==
                                                  true) //aceptar
                                              {
                                                // Cerrar el primer modal
                                                Navigator.pop(context);
                                              } else {
                                                print(
                                                    'solicitud pidiendo ir a colación.');
                                                if (_.usserPermissionQr == 1) {
                                                  //todo esto cambiarlo
                                                  if (clientCon.getWaitTime() ==
                                                          true ||
                                                      (clientCon.getWaitTime() ==
                                                              false &&
                                                          clientCon
                                                                  .clientsScheSalon ==
                                                              0)) //es que esta en tiempo de pedir colación
                                                  {
                                                    int result = await _
                                                        .ColacionProfessional(
                                                            _.idProfessionalLoggedIn,
                                                            'Barbero',
                                                            3);
                                                    if (result ==
                                                        1) //codigo 200
                                                    {
                                                      //mando notificacion al barbero
                                                      //esta la manda la api
                                                      // notiController.storeNotification(
                                                      //     'Solicitud de Colación',
                                                      //     _.branchIdLoggedIn,
                                                      //     _.idProfessionalLoggedIn,
                                                      //     'EL Barbero ${_.nameUserLoggedIn} esta pidiendo solicitud de colación',
                                                      //     'Ambos'); //esto es para quele llegue a coordinador y encargado
                                                      //
                                                      _.setCodigoQrValid(
                                                          2); //quiere decir que el qr esta bloquedo hasta que acepten o rechacen
                                                      Get.snackbar(
                                                        '',
                                                        'Solicitud de colación pedida correctamente,espere un momento...',
                                                        colorText: const Color
                                                                .fromARGB(
                                                            255, 43, 44, 49),
                                                        titleText: const Text(
                                                            'Mensaje'),
                                                        duration:
                                                            const Duration(
                                                                seconds: 4),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color(
                                                                0xFF4470F3),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFFDAE2A)),
                                                        overlayBlur: 3,
                                                      );
                                                      print(
                                                          'solicitud enviada correctamente');
                                                    } else if (result ==
                                                        2) //codigo diferente de 200
                                                    {
                                                      Get.snackbar(
                                                        '',
                                                        'Inténtelo nuevamente,problemas de conexión',
                                                        colorText: const Color
                                                                .fromARGB(
                                                            255, 43, 44, 49),
                                                        titleText: const Text(
                                                            'Alerta'),
                                                        duration:
                                                            const Duration(
                                                                seconds: 4),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color(
                                                                0xFF4470F3),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFFDAE2A)),
                                                        overlayBlur: 3,
                                                      );
                                                      print(
                                                          'problema al enviar la solicitud');
                                                    } else if (result ==
                                                        3) //entro a la exepcion del catch
                                                    {
                                                      Get.snackbar(
                                                        '',
                                                        'Inténtelo nuevamente,problemas de conexión...',
                                                        colorText: const Color
                                                                .fromARGB(
                                                            255, 43, 44, 49),
                                                        titleText: const Text(
                                                            'Alerta'),
                                                        duration:
                                                            const Duration(
                                                                seconds: 4),
                                                        showProgressIndicator:
                                                            true,
                                                        progressIndicatorBackgroundColor:
                                                            const Color(
                                                                0xFF4470F3),
                                                        progressIndicatorValueColor:
                                                            const AlwaysStoppedAnimation(
                                                                Color(
                                                                    0xFFFDAE2A)),
                                                        overlayBlur: 3,
                                                      );
                                                      print(
                                                          'problema al enviar la solicitud2');
                                                    }
                                                    //manadar un mensaje si la solicitud se envio bien
                                                  } else {
                                                    Get.snackbar(
                                                      'Mensaje',
                                                      'No es posible pedir solicitud de Colación en este momento',
                                                      duration: const Duration(
                                                          milliseconds: 2500),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              118,
                                                              255,
                                                              255,
                                                              255),
                                                      showProgressIndicator:
                                                          true,
                                                      progressIndicatorBackgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              203,
                                                              205,
                                                              209),
                                                      progressIndicatorValueColor:
                                                          const AlwaysStoppedAnimation(
                                                              Color(
                                                                  0xFFFDAE2A)),
                                                      overlayBlur: 3,
                                                    );
                                                  }
                                                } else if (_
                                                        .usserPermissionQr ==
                                                    2) {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Debe de esperar la respuesta a su solicitud',
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            118, 255, 255, 255),
                                                    showProgressIndicator: true,
                                                    progressIndicatorBackgroundColor:
                                                        const Color.fromARGB(
                                                            255, 203, 205, 209),
                                                    progressIndicatorValueColor:
                                                        const AlwaysStoppedAnimation(
                                                            Color(0xFFFDAE2A)),
                                                    overlayBlur: 3,
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Aún no ha entrado a trabajar.',
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            118, 255, 255, 255),
                                                    showProgressIndicator: true,
                                                    progressIndicatorBackgroundColor:
                                                        const Color.fromARGB(
                                                            255, 203, 205, 209),
                                                    progressIndicatorValueColor:
                                                        const AlwaysStoppedAnimation(
                                                            Color(0xFFFDAE2A)),
                                                    overlayBlur: 3,
                                                  );
                                                }
                                                Navigator.pop(context);
                                                // Cerrar el primer modal
                                              }
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
                                                        'Colación',
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
                                                      horizontal: 18.0),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(const Color(
                                                            0xFF4470F3)),
                                              ),
                                              onPressed: () async {
                                                //todo falta llamar un metodo aqui
                                                //SACAR DEL PUESTO DE TRABAJO AL BARBERO
                                                //
                                                // Lógica para enviar el comentario

                                                //LLAMAR AL ENPOINT PARA SACAR DEL PUESTO DE TRABAJO
                                                if (_.usserPermissionQr == 1) {
                                                  //todo esto cambiarlo

                                                  int result = await _
                                                      .ColacionProfessional(
                                                          _.idProfessionalLoggedIn,
                                                          'Barbero',
                                                          4); //solicitud de salida
                                                  if (result == 1) //codigo 200
                                                  {
                                                    _.setCodigoQrValid(
                                                        2); //si el QR = 2 sacarlo de la app

                                                    //esta la manda la api
                                                    // notiController.storeNotification(
                                                    //     'Solicitud de Salida',
                                                    //     _.branchIdLoggedIn,
                                                    //     _.idProfessionalLoggedIn,
                                                    //     'EL Barbero ${_.nameUserLoggedIn} esta pidiendo solicitud de salida',
                                                    //     'Ambos'); //esto es para quele llegue a coordinador y encargado
                                                    Get.snackbar(
                                                      '',
                                                      'Solicitud de salida pedida correctamente,espere un momento...',
                                                      colorText:
                                                          const Color.fromARGB(
                                                              255, 43, 44, 49),
                                                      titleText:
                                                          const Text('Mensaje'),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      showProgressIndicator:
                                                          true,
                                                      progressIndicatorBackgroundColor:
                                                          const Color(
                                                              0xFF4470F3),
                                                      progressIndicatorValueColor:
                                                          const AlwaysStoppedAnimation(
                                                              Color(
                                                                  0xFFFDAE2A)),
                                                      overlayBlur: 3,
                                                    );
                                                    print(
                                                        'solicitud enviada correctamente');
                                                  } else if (result ==
                                                      2) //codigo diferente de 200
                                                  {
                                                    Get.snackbar(
                                                      '',
                                                      'Inténtelo nuevamente,problemas de conexión',
                                                      colorText:
                                                          const Color.fromARGB(
                                                              255, 43, 44, 49),
                                                      titleText:
                                                          const Text('Alerta'),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      showProgressIndicator:
                                                          true,
                                                      progressIndicatorBackgroundColor:
                                                          const Color(
                                                              0xFF4470F3),
                                                      progressIndicatorValueColor:
                                                          const AlwaysStoppedAnimation(
                                                              Color(
                                                                  0xFFFDAE2A)),
                                                      overlayBlur: 3,
                                                    );
                                                    print(
                                                        'problema al enviar la solicitud');
                                                  } else if (result ==
                                                      3) //entro a la exepcion del catch
                                                  {
                                                    Get.snackbar(
                                                      '',
                                                      'Inténtelo nuevamente,problemas de conexión...',
                                                      colorText:
                                                          const Color.fromARGB(
                                                              255, 43, 44, 49),
                                                      titleText:
                                                          const Text('Alerta'),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      showProgressIndicator:
                                                          true,
                                                      progressIndicatorBackgroundColor:
                                                          const Color(
                                                              0xFF4470F3),
                                                      progressIndicatorValueColor:
                                                          const AlwaysStoppedAnimation(
                                                              Color(
                                                                  0xFFFDAE2A)),
                                                      overlayBlur: 3,
                                                    );
                                                    print(
                                                        'problema al enviar la solicitud2');
                                                  }
                                                  //manadar un mensaje si la solicitud se envio bien

                                                  //
                                                  //
                                                  //
                                                  //
                                                  //
                                                } else if (_
                                                        .usserPermissionQr ==
                                                    2) {
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Debe de esperar la respuesta a su solicitud',
                                                    duration: const Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            118, 255, 255, 255),
                                                    showProgressIndicator: true,
                                                    progressIndicatorBackgroundColor:
                                                        const Color.fromARGB(
                                                            255, 203, 205, 209),
                                                    progressIndicatorValueColor:
                                                        const AlwaysStoppedAnimation(
                                                            Color(0xFFFDAE2A)),
                                                    overlayBlur: 3,
                                                  );
                                                } else if (_
                                                        .usserPermissionQr ==
                                                    null) {
                                                  _.exit(_.tokenUserLoggedIn);
                                                }

                                                // Cerrar el primer modal
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                children: [
                                                  _.usserPermissionQr == 1
                                                      ? SizedBox(
                                                          width: 0,
                                                        )
                                                      : SizedBox(
                                                          width: 16,
                                                        ),
                                                  Icon(
                                                    MdiIcons.exitToApp,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    _.usserPermissionQr == 1
                                                        ? 'Me retiro'
                                                        : 'Salir    ',
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
