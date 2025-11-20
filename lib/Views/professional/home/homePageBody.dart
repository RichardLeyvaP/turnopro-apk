import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Models/clientsScheduled_model.dart';
import 'package:turnopro_apk/Models/professional_model.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:turnopro_apk/Views/coordinator/services/localStorage.dart';

import 'package:intl/intl.dart';
import 'package:turnopro_apk/services/background_service.dart';
import 'package:turnopro_apk/services/background_task_service.dart';

import 'package:turnopro_apk/Views/professional/clientsScheduled/ImageDetailScreen.dart';

import '../../../Models/ServiceHistory_model.dart';
//import 'package:turnopro_apk/services/localNotification.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ClientsScheduledController clientsScheduledController =
      Get.find<ClientsScheduledController>();
  final ClientsCoordinatorController clientCord =
      Get.find<ClientsCoordinatorController>();

  final PagesConfigController pagesConfigC = Get.find<PagesConfigController>();

  final LoginController loginController = Get.find<LoginController>();

  final CoexistenceController coexistenceController =
      Get.put(CoexistenceController());
  NotificationController notiController = Get.find<NotificationController>();
  ServiceController serviceControll = Get.find<ServiceController>();
  ShoppingCartController chopCont = Get.find<ShoppingCartController>();
  CoexistenceController coexCont = Get.find<CoexistenceController>();
  final ProductController controllerProduct = Get.put(ProductController());

  String firstNameNext = '';
  String? urlImageClientNext = '';
  String? urlImageBarberNext = '';
  String? frecuenciaBarberNext = '';
  String? cantVisitBarberNext = '';
  String? UltimateBarberNext= '';
  List<ServiceHistoryModel> history_serviceNext = [];
  List<ServiceHistoryModel> history_service = [];
  String firstName = '';
  String? urlImageClient = '';
  String? urlImageBarber = '';
  String? frecuenciaBarber1 = '';
  String? cantVisitBarber1 = '';
  String? UltimateBarber1= '';


  @override
  bool get wantKeepAlive => true;

  bool _isMounted = true;
  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  void showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Future<void> saveData() async {
    int valueClock = getTimeRemaining();
    await LocalStorage.prefs.setInt('valueClockIni', valueClock);
    int hAs = obtenerHoraActualEnSegundos();
    LocalStorage.prefs.setInt('valueHoraAnt', hAs);

    print('--este es el value del clok... ->Value guardado:$valueClock');
  }

  int getTimeRemaining() {
    if (clientsScheduledController.animationControllerInitial != null) {
      return (clientsScheduledController.totalTimeInitial -
              (clientsScheduledController.animationControllerInitial!.value *
                  clientsScheduledController.totalTimeInitial))
          .round();
    } else {
      return 181;
    }
  }

  int obtenerHoraActualEnSegundos() {
    DateTime ahora = DateTime.now();
    int segundos = ahora.hour * 3600 + ahora.minute * 60 + ahora.second;
    return segundos;
  }

  reasigClient(int reservationId, int clientId) async {
    print('se hacompletado los 3 min-ESTOY EN reasigClient()');
    // int idProfDisp = await professionalDisp(reservationId);
    int idProfDisp = -99;
    if (idProfDisp != 0) {
      // entonces reasignoP
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
                // SizedBox(height: 16),
                // Text('Reasignando cliente...',
                //     style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      ); //Get.back();
      bool result = await clientCord.reasignedClient(
          reservationId,
          clientId,
          loginController.idProfessionalLoggedIn,
          loginController.tokenUserLoggedIn);
      if (result == true) {
        await clientsScheduledController.fetchClientsScheduledNew(
            loginController.idProfessionalLoggedIn,
            loginController.branchIdLoggedIn,
            'Home-reasignedClient',
            loginController.tokenUserLoggedIn);
        loginController.setCodigoQrValidAnt(1);

        print("Esta reasignando 200");
      } else {
        print("No esta reasignando 500");
        loginController.setCodigoQrValidAnt(1);
        Get.back();
      }
    } else //No hay barberos disponibles
    {
      //aqui mandar el cliente a verificar si es aleatori y cambiar el valor
      //y poner valor aleatore = 3 diciendo que puede ser llamado por alguien aunque este de primero
      loginController.setCodigoQrValidAnt(1);
      Get.back();
      print('Intentó reasignar pero :No hay barberos disponibles');
    }
  }

  Future<int> professionalDisp(int idReserv) async {
    //que sea diferente al barbero actual
    int idBarberAct = loginController.idProfessionalLoggedIn!;
    List<ProfessionalModel> profDisp;
    profDisp = await clientsScheduledController.getFirstProfessional(
        loginController.branchIdLoggedIn,
        idReserv,
        idBarberAct,
        loginController.tokenUserLoggedIn);
    if (profDisp.isNotEmpty) {
      print('hay profesional libre para reasignar');
      return profDisp[0].id;
    } else {
      print('No hay profesional libre para reasignar');
      return 0;
    }
  }

  reiniciateClock() {
    print('verificando si esta activo:Aqui reiniciateClock()');
    LocalStorage.prefs.setBool('convivenciaIncumplida', true);
    LocalStorage.prefs.setInt('valueClockIni', 180);
    clientsScheduledController.setTotalTimeInitial(180);
    LocalStorage.prefs.setBool('valueClockActiv', false);

    // Reiniciar la animación
    // Reiniciar y avanzar la animación existente
    clientsScheduledController.animationControllerInitial!
      ..duration = Duration(seconds: 180)
      ..reset()
      ..forward();
  }

  addClock10(value) {
    print('Tiempo restante12345:restando 10 segundos');

    // Reiniciar la animación
    // Reiniciar y avanzar la animación existente
    clientsScheduledController.animationControllerInitial!
      ..duration = Duration(seconds: value)
      ..reset()
      ..forward();
  }

  restartStopClock() {
    print(
        'verificando si esta activo:Aqui estoy párando el reloj reiniciateClock()');

    LocalStorage.prefs.setInt('valueClockIni', 180);
    clientsScheduledController.setTotalTimeInitial(180);
    LocalStorage.prefs.setBool('valueClockActiv', false);

    // Reiniciar la animación
    // Reiniciar y avanzar la animación existente
    if (clientsScheduledController.animationControllerInitial!.isAnimating) {
      clientsScheduledController.animationControllerInitial!
        ..duration = Duration(seconds: 180)
        ..reset()
        ..stop();
    }
  }

  verificateClockInit() async {
    if (LocalStorage.prefs.getBool('valueClockActiv') != null &&
        LocalStorage.prefs.getBool('valueClockActiv') == true) {
      print(
          'el tiempo devuelto inicial es-0:${LocalStorage.prefs.getBool('valueClockActiv')}');
    } else {
      int timeInit = await loginController.gettimeClokInitial(
          loginController.idProfessionalLoggedIn!,
          loginController.branchIdLoggedIn!,
          loginController.tokenUserLoggedIn);
      print('el tiempo devuelto inicial es-1:$timeInit');
      int tiempClock = 180;
      if (timeInit != -99 && timeInit != -999) {
        if (timeInit == 180) {
          tiempClock = 180;
        } else {
          print('el tiempo devuelto inicial es-2:ENTRE AL IF');
          timeInit += 20;
          tiempClock = 180 - timeInit;
          if (tiempClock < 0) {
            print('el tiempo devuelto inicial es-3-REASIGNANDO:$tiempClock');
            //reasigno y pongo el reloj en 180
            await clientCord.reasignedClientSegundoPlano(
                loginController.idProfessionalLoggedIn!,
                loginController.branchIdLoggedIn,
                loginController.tokenUserLoggedIn,
                0); //0 significa que es desde el login
            tiempClock = 180;
          }
        }
        //  await Future.delayed(
        //   Duration(milliseconds: 500));
        //se mantiene el valor
        print(
            'el tiempo devuelto inicial es-3-Inicializando clock inicial en:$tiempClock');
        clientsScheduledController.setTotalTimeInitial(tiempClock);
        //sino esta ativo el time de 3 min pues vemos si ya estaba trabajando en segundo plano
        //llamamos a la db
      } else {
        print('el tiempo devuelto inicial es-4-No entre al if');
        clientsScheduledController
            .setTotalTimeInitial(181); //solo para saber que algo dio mal
        print(
            'el tiempo inicial del reloj inicio en 181 segundos porque dio un error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    verificateClockInit();
    print('fff12 antes del channel.stream');

    print('cargando aqui-3');
    //initializeNotifications();
    //AQUI ME DEVUELVE A Q CLIENTE LE SIGUE Y ACUAL MOSTRAR EN LA COLA
    if (loginController.usserPermissionQr != null) {
      clientsScheduledController.filterShowNext();
    }

    timerConteo();

    llamadasTimer2();

//todo fin codigoanterior
    clientsScheduledController.animationControllerInitial = AnimationController(
      vsync: this,
      duration: Duration(seconds: clientsScheduledController.totalTimeInitial),
    );

    // Agregar listener solo una vez
    clientsScheduledController.animationControllerInitial!
        .addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('Se ha completado los 3-La animación se ha completado-SIIIII');

//ESTA CONDICIÓN E SPARA GARANTIZAR QUE SI HAY ALGÚN CLIENTE ATENDIENDOSE QUE NO HAGA NADA,POR SI ESTUVIERA EL RELOJ INITIAL TRABAJANDO
        if (clientsScheduledController.clientsAttended1 == null &&
            clientsScheduledController.clientsAttended2 == null &&
            clientsScheduledController.clientsAttended3 == null &&
            clientsScheduledController.clientsAttended4 == null) {
          String type = 'Tiempo';
          int estado = 0; //es que incumplió
          //CADA VEZ QUE ENTRE AQUI INCULPLIO CON EL TIEMPO DE LLAMAR AL CLIENTE ANTES DE 3MIN
          if (loginController.branchIdLoggedIn != null &&
              loginController.idProfessionalLoggedIn != null) {
            //acabaron los 3 minutos de espera
            clientsScheduledController.changeNoncomplianceP2(
                type,
                loginController.branchIdLoggedIn!,
                loginController.idProfessionalLoggedIn!,
                estado);
          }

          print('se ha completado los 3 min-ESTOY EN initState()-AFUERA');
          //AQUI SI HAY QUE REASIGNAR SE REASIGNA
          if (clientsScheduledController.clientsScheduledNextServ != null &&
              loginController.codigoQrValid() == true) {
            //es decir que tenga qr leido
            //   print('se hacompletado los 3 min-HAY CLIENTE POR ATENDER');
            print('se hacompletado los 3 min-ESTOY EN initState()');
            int reservationId = clientsScheduledController
                .clientsScheduledNextServ!.reservation_id!;
            int clientId =
                clientsScheduledController.clientsScheduledNextServ!.client_id!;
            reasigClient(reservationId, clientId);
          }

          // reasigClient(int reservationId, int clientId);
          if (loginController.chargeUserLoggedIn != "Barbero y Encargado") {
            if (clientsScheduledController
                        .noncomplianceProfessional['Tiempo'] !=
                    0 &&
                loginController.usserPermissionQr == 1 &&
                clientsScheduledController.clientsScheSalon > 0) {
              print('--este es el value del clok-FINALIZANDO*****22');
              print(
                  'inserto correctamente ********** .noncomplianceProfessional[]');

              clientsScheduledController.changeNoncomplianceP(
                  type,
                  loginController.branchIdLoggedIn!,
                  loginController.idProfessionalLoggedIn!,
                  estado);
              //aqui llamar e insertar en las notificacione sque incumplio esta convivencia
              notiController.storeNotification(
                  'Incumplimiento de convivencia',
                  loginController.branchIdLoggedIn!,
                  loginController.idProfessionalLoggedIn!,
                  'Tu tiempo de espera de 3 minutos para seleccionar al nuevo cliente en cola se ha agotado.',
                  'no',
                  'Barbero');
//todo notificate
            }
          } //FIN DEL IF DE BARBERO ENCARGADO
          reiniciateClock();
        }
      }
    });
    Future<void> saveUserDataMemory(
        int? permQr, int timerInitial, int salon) async {
      // Guardar cada dato por separado
      if (permQr != null) {
        await LocalStorage.prefs.setInt('var_PermissQr', permQr);
      } else {
        await LocalStorage.prefs
            .setInt('var_PermissQr', -999); //para saber que es null
      }
      await LocalStorage.prefs.setInt(
          'var_timerInitial', timerInitial); //si es 181 es que esta parado

      //veri si hay clietes en el salon
      await LocalStorage.prefs
          .setInt('var_clientsalon', salon); //para saber que es null
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('Se ha completado los 3-Renderizado de la pagina');

      _timer3 = Timer.periodic(Duration(seconds: 3), (timer) async {
        //todo aqui voy guardando tds las variables que necesito para el segundo plano
        //todo ********************************AQUI VER QUE SI FINALIZA NO CUARDE EN ESE MOMENTO***************************************
        //

        clientsScheduledController.upadateVariablesValueTimersPreferenc();
        saveUserDataMemory(loginController.usserPermissionQr,
            getTimeRemaining(), clientsScheduledController.clientsScheSalon);

        //todo aqui voy guardando tds las variables que necesito para el segundo plano
        //todo ***********************************************************************
        print('Se ha completado los 3 minutos-Timer-Chequeando');
        if (clientsScheduledController.animationControllerInitial != null &&
            clientsScheduledController
                .animationControllerInitial!.isAnimating) {
          // Aquí puedes realizar alguna acción periódica si es necesario
          print('Se ha completado los 3 minutos-esta activo el reloj');
        }
      });
      clientsScheduledController.animationControllerInitial!.forward();

      if (loginController.isLoggingInCharge == true) {
        print('cargando aqui-15');
        await loginController.setLoggingInCharge(false, 'buildComponent-1114');
      }
    });

    clientsScheduledController.animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    );
    clientsScheduledController.animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    clientsScheduledController.animationController4 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clientsScheduledController.setBoolControlVision(true);
      llamadasTimer1();
    });
  }

  Future<void> _initializeService() async {
    await initializeService();
  }

  @override
  void dispose() {
    clientsScheduledController.animationControllerInitial!.dispose();

    clientsScheduledController.animationController1!.dispose();
    clientsScheduledController.animationController2!.dispose();
    clientsScheduledController.animationController3!.dispose();
    clientsScheduledController.animationController4!.dispose();

    _isMounted = false;
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    _timer4?.cancel();

    super.dispose();
  }

  //optener la hora actual
  String getCurrentTime() {
    // Obtener la hora actual
    DateTime now = DateTime.now();

    // Formatear la hora
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return formattedTime;
  }

  //comparar 2 horas si h1>h2 devuelve true
  bool isTime1GreaterThanTime2(String h1, String h2) {
    DateFormat format = DateFormat('HH:mm:ss');

    // Convertir las cadenas a objetos DateTime
    DateTime time1 = format.parse(h1);
    DateTime time2 = format.parse(h2);

    // Comparar los tiempos
    return time1.isAfter(time2);
  }

  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  Timer? _timer4;
  int initialValue = 10;
  int aux = 0;

  timerConteo() {
    _timer4 = Timer.periodic(Duration(seconds: 1), (timer) async {
      print(
          'entrando funcion nueva a timerConteo():${clientsScheduledController.getwaitTimeCount()}');

      // clearAllNotifications();
      if (clientsScheduledController.getwaitTimeCount() <= 1) {
        clientsScheduledController.setwaitTimeCount(0);
        if (loginController.usserPermissionQr == 1) {
          _refresh();
        }
      } else if (clientsScheduledController.getWaitTime() ==
          true) //esta esperando los 30 segundos

      {
        clientsScheduledController.setwaitTimeCount(1);
      } else {
        clientsScheduledController.setwaitTimeCount(0);
      }
    });
  }

  int cont = 0;

  llamadasTimer2()
  {
    _timer2 = Timer.periodic(Duration(seconds: 5), (timer) async {
      print(
          'Esto se ejecuta 2 segundos después de renderizar el cuadro--nuevo');

      if (getTimeRemaining() < 3) {
        // aaqui cancelar hasta que vea si rasigna o no
        // comente esto aqui porque no esta funcionando bien
        //     loginController.setCodigoQrValidAnt(0); //10 es en espera
      }
      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          (loginController.chargeUserLoggedIn == "Barbero" ||
              (loginController.chargeUserLoggedIn == "Barbero y Encargado"))) {
        //  verifyingClockTimeActive();
      }
      if (loginController.segundoPlano == 3) {
        print('cargando aqui-11');
        print('..segundoPlano siii APAGANDO LLAMADA');
        loginController.getSegundoPlano(1);
      }
      //todo este no va hacer falta si lo implemento en ShopingCart.controller
      if (clientsScheduledController.activeModifyTime == true) {
        print('cargando aqui-12');
        //AQUI GARANTIZO QUE AUMENTE EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
        clientsScheduledController.setActiveModifyTime(false);
      }
      if (clientsScheduledController.activeModifyTimeRest == true) {
        print('cargando aqui-13');
        //AQUI GARANTIZO QUE disminuya EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
        clientsScheduledController.setActiveModifyTimeRest(false);
        clientsScheduledController.clearModifyTimeSpecificRest();
      }

      if (loginController.ejecutadoEvent == false) {
        print('cargando aqui-14');
        // Se ejecutará después de que se haya construido el widget
        //define que tipo de saludo dar dependiendo de la hora

        if (clientsScheduledController.closeIesperado == true) {
          print('-*-*-*-**>>>> si fui un sierre inesperado');
          if (clientsScheduledController.item.isNotEmpty) {
            loginController.setCodigoQrValid(1);
          } else if (loginController.usserPermissionQr == -99 &&
              loginController.usserPermissionQr == 0) {
            loginController.setCodigoQrValid(null);
            print('id de mi puesto de trabajo 1 no esta en ningun puesto:null');
          }
        } else {
          print('-*-*-*-**>>>> NOOO fui un sierre inesperado');
        }
        if (loginController.isLoggingInCharge == true) {
          await loginController.setLoggingInCharge(
              false, 'buildComponent-1103');
        }

        clientsScheduledController.setCloseIesperado(false);
        clientsScheduledController.clockChanges(false);
        loginController.ejecutado_(true);
        clientsScheduledController.modifingTimeClose();
      }
      clientsScheduledController.setCloseIesperadoLogin(false);

      clientsScheduledController.setCloseIesperado(false);
    });
  }

  llamadasTimer1() {
    _timer1 = //notificaciones
        Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      saveData();
      await loginController.checkConnection();

      print(
          'llamada timer en 10 segundos obtenerHoraActualEnSegundos:${loginController.chargeUserLoggedIn}');

      if (loginController.makeCall == true &&
          clientsScheduledController.getWaitTime() == false) {
        print('Error al obtener la lista de notificaciones:este:TIMER-TIMER');
        print(
            'Error al obtener la lista de notificaciones:este:clientsScheduledController.boolFilterShowNext:${clientsScheduledController.boolFilterShowNext}');
        print('llamada timer en 10 segundos obtenerHoraActualEnSegundos:');

        if (loginController.usserPermissionQr != null &&
            loginController.idProfessionalLoggedIn != null &&
            loginController.branchIdLoggedIn != null &&
            (loginController.chargeUserLoggedIn == "Barbero" ||
                (loginController.chargeUserLoggedIn ==
                    "Barbero y Encargado"))) {
          clientsScheduledController.filterShowNext();
          String teleClient = '';
          if (clientsScheduledController.clientsScheduledNextServ != null) {
            teleClient = clientsScheduledController
                .clientsScheduledNextServ!.telefone_client!;
            print(
                'EL telefono del que le sigue en la cola es:TELEFONO:$teleClient');
          }
          await Future.delayed(const Duration(milliseconds: 500));
          //pregunto si no tinee a nadie en cola
          //voy a ver si hay alguno para reasignarlo
          print(
              'Cliente reasignado correctamente ->ANTES DEL IF clientsScheduledListLengthTail:${clientsScheduledController.clientsScheduledListLength})');
          print(
              'Cliente reasignado correctamente ->ANTES DEL IF clientsScheduledController.item.isEmpty:${clientsScheduledController.item.isEmpty})');

          //Buscar notificaciones
          //variables
          int idBranch = loginController.branchIdLoggedIn!;
          int idProfe = loginController.idProfessionalLoggedIn!;
          String type = 'Barbero';
          String msj = 'llamadasTimer1';

          await notiController.professionalBranchNotifQueque(
              idBranch, idProfe, type, msj, loginController.tokenUserLoggedIn);
          print(
              'viendo si hay clientes esperando realmente::${clientsScheduledController.clientsScheSalon})');
          print(
              'viendo si hay clientes esperando realmente::errorHome:${clientsScheduledController.errorHome})');

          //esta era para llamar a un aleatorio si no tenia nadie en cola.ya eso lo hace la api
          if ((clientsScheduledController.clientsScheSalon == 0 &&
                  clientsScheduledController.errorHome != -99) ||
              loginController.usserPermissionQr == 2) {
            restartStopClock();
          }
          if (loginController.chargeUserLoggedIn == "Barbero y Encargado") {
            await Future.delayed(const Duration(milliseconds: 1000));
            await notiController.fetchNotificationList(
                loginController.branchIdLoggedIn,
                loginController.idProfessionalLoggedIn,
                'Encargado',
                'Cart homeEncargado',
                loginController.tokenUserLoggedIn);
          }

          //lo que llamaba el timer 2
          print('llamada timer 2 - 11segundos');
          if (loginController.idProfessionalLoggedIn != null &&
              loginController.branchIdLoggedIn != null &&
              (loginController.chargeUserLoggedIn == "Barbero" ||
                  (loginController.chargeUserLoggedIn ==
                      "Barbero y Encargado"))) {
            //guardar datos de los relojes en la db
            //comprobar que este en barbero
            if (loginController.switchValue ==
                false) //es porque está en barbero
            {
              await Future.delayed(const Duration(milliseconds: 500));
              //veridficar que el que tenga para finalizar no mande a modificar
              await clientsScheduledController.upadateVariablesValueTimers();
              //aqui en este actualiza los tiempos de los relojes
            }
            await Future.delayed(const Duration(milliseconds: 500));
            await clientsScheduledController.fetchClientsScheduledNew(
                loginController.idProfessionalLoggedIn,
                loginController.branchIdLoggedIn,
                'if (index == 1)',
                loginController.tokenUserLoggedIn);
          }
          //lo que llamaba el timer 2

          //ESTO ES LO QUE LLAMABA EL TIMER
          if (loginController.idProfessionalLoggedIn != null &&
              loginController.branchIdLoggedIn != null &&
              (loginController.chargeUserLoggedIn == "Barbero" ||
                  (loginController.chargeUserLoggedIn ==
                      "Barbero y Encargado"))) {
            //en este caso son 3 minutos que esta definido en el controlador
            //aqui verifico si se esta acabando algun servico para mandar una notificacion
          }

          //ESTO ES LO QUE LLAMABA EL TIMER 3
          if (loginController.idProfessionalLoggedIn != null &&
              loginController.branchIdLoggedIn != null &&
              (loginController.chargeUserLoggedIn == "Barbero" ||
                  (loginController.chargeUserLoggedIn ==
                      "Barbero y Encargado"))) {
            //en este caso son 3 minutos que esta definido en el controlador
            //aqui verifico si se esta acabando algun servico para mandar una notificacion

            if ((clientsScheduledController.varClientsWaiting == true) &&
                (loginController.usserPermissionQr == 1)) {
              print('esteeeeee se cumplio que puede atender ..aqui entrandoya');
              if (clientsScheduledController
                      .animationControllerInitial!.isAnimating &&
                  clientsScheduledController.cantClientWait !=
                      clientsScheduledController.clientsScheduledListLength) {
                // La animación está activa (en progreso)
                if (clientsScheduledController.contClientsWaiting == 10) {
                  print('esteeeeee varClientsWaiting Mande la notificacion ya');
                  //aqui llamar e insertar en las notificaciones
                  notiController.storeNotification(
                      'Clientes en cola',
                      loginController.branchIdLoggedIn,
                      loginController.idProfessionalLoggedIn,
                      'Recuerda que tienes clientes en cola.¡No los mantengas esperando por mucho tiempo!',
                      'no',
                      'Barbero');
                  //todo notificate
                  // scheduleNotification(
                  //     '!Alerta', 'Recuerda que tienes clientes en cola');
                  //para controlar que con este cliente solo le avise una vez
                  clientsScheduledController.setContClientsWaiting(20);
                  clientsScheduledController.setcantClientWait(
                      clientsScheduledController.clientsScheduledListLength);
                }
                if (clientsScheduledController.contClientsWaiting == 10) {
                  print(
                      'entando en 10 segundos aqui para insertar el tiempo si hubiera reloj activo');
                } else if (clientsScheduledController.contClientsWaiting ==
                    100) //si llega a 100 mando que sea 20 de nuevo para q no pase de los valores del entero y tener un control mejor de el
                {
                  clientsScheduledController.setContClientsWaiting(20);
                } else {
                  clientsScheduledController
                      .setContClientsWaiting(-91119); //sumo 1
                }
              } else {
                clientsScheduledController
                    .setContClientsWaiting(-90009); //inicializo nuevamente a 0
                // La animación está detenida
              }
            } else {
              clientsScheduledController
                  .setContClientsWaiting(-90009); //inicializo nuevamente a 0
            }
            //
          }
          //ESTO ES LO QUE LLAMABA EL TIMER 3
        } else if (loginController.usserPermissionQr == null) {
          //poner a false el cargando
          clientsScheduledController.setBoolControlVision(false);
        }
      }
      if (clientsScheduledController.getWaitTime() == true) {
        clientsScheduledController.animationControllerInitial!
          ..duration = Duration(seconds: 180)
          ..reset()
          ..stop();
        //solo llamar las notificaciones
        await notiController.fetchNotificationList(
            loginController.branchIdLoggedIn,
            loginController.idProfessionalLoggedIn,
            'Barbero',
            'Cart homeBarbero1',
            loginController.tokenUserLoggedIn);
        if (loginController.chargeUserLoggedIn == "Barbero y Encargado") {
          await Future.delayed(const Duration(milliseconds: 700));
          await notiController.fetchNotificationList(
              loginController.branchIdLoggedIn,
              loginController.idProfessionalLoggedIn,
              'Encargado',
              'Cart homeEncargado1',
              loginController.tokenUserLoggedIn);
        }
      }
    });
  }

  Future<void> _refresh() async {
    //aqui llamar actualizar la cola
    // await Future.delayed(Duration(seconds: 1));
    //pongo la variable de espera de 30 segundo a false
    if (loginController.usserPermissionQr == 1) {
      await clientsScheduledController.fetchClientsScheduledNew(
          loginController.idProfessionalLoggedIn,
          loginController.branchIdLoggedIn,
          'Text(ENVIAR)',
          loginController.tokenUserLoggedIn);
      clientsScheduledController.setWaitTime(
          false); //sigue el funcionamiento normal haciendo llamadas
      clientsScheduledController.setBoolControlVision(true);
      clientsScheduledController.setwaitTimeCount(0);
    }
  }

  // //
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
    //AQUI REVISO SI HAY ALGUNO POR ACTIVAR LO ACTIVO



    super.build(context);

    // todo URGENTE
    /*
    _timer2 = Timer.periodic(Duration(seconds: 5), (timer) async {
      print(
          'Esto se ejecuta 2 segundos después de renderizar el cuadro--nuevo');

      if (getTimeRemaining() < 3) {
        // aaqui cancelar hasta que vea si rasigna o no
        // comente esto aqui porque no esta funcionando bien
        //     loginController.setCodigoQrValidAnt(0); //10 es en espera
      }
      if (loginController.idProfessionalLoggedIn != null &&
          loginController.branchIdLoggedIn != null &&
          (loginController.chargeUserLoggedIn == "Barbero" ||
              (loginController.chargeUserLoggedIn == "Barbero y Encargado"))) {
        //  verifyingClockTimeActive();
      }
      if (loginController.segundoPlano == 3) {
        print('cargando aqui-11');
        print('..segundoPlano siii APAGANDO LLAMADA');
        loginController.getSegundoPlano(1);
      }
      //todo este no va hacer falta si lo implemento en ShopingCart.controller
      if (clientsScheduledController.activeModifyTime == true) {
        print('cargando aqui-12');
        //AQUI GARANTIZO QUE AUMENTE EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
        clientsScheduledController.setActiveModifyTime(false);
      }
      if (clientsScheduledController.activeModifyTimeRest == true) {
        print('cargando aqui-13');
        //AQUI GARANTIZO QUE disminuya EL VALOR DEL RELOJ UNA SOLA VEZ Y QUE INSERTE EN LA DB 1 SOLA VEZ
        clientsScheduledController.setActiveModifyTimeRest(false);
        clientsScheduledController.clearModifyTimeSpecificRest();
      }

      if (loginController.ejecutadoEvent == false) {
        print('cargando aqui-14');
        // Se ejecutará después de que se haya construido el widget
        //define que tipo de saludo dar dependiendo de la hora

        if (clientsScheduledController.closeIesperado == true) {
          print('-*-*-*-**>>>> si fui un sierre inesperado');
          if (clientsScheduledController.item.isNotEmpty) {
            loginController.setCodigoQrValid(1);
          } else if (loginController.usserPermissionQr == -99 &&
              loginController.usserPermissionQr == 0) {
            loginController.setCodigoQrValid(null);
            print('id de mi puesto de trabajo 1 no esta en ningun puesto:null');
          }
        } else {
          print('-*-*-*-**>>>> NOOO fui un sierre inesperado');
        }
        if (loginController.isLoggingInCharge == true) {
          await loginController.setLoggingInCharge(
              false, 'buildComponent-1103');
        }

        clientsScheduledController.setCloseIesperado(false);
        clientsScheduledController.clockChanges(false);
        loginController.ejecutado_(true);
        clientsScheduledController.modifingTimeClose();
      }
      clientsScheduledController.setCloseIesperadoLogin(false);

      clientsScheduledController.setCloseIesperado(false);
    });
*/


    return GetBuilder<ClientsScheduledController>(builder: (clientsScheduledController) {
      //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<ClientsScheduledModel?> clientsList = [
        clientsScheduledController.clientsAttended1,
        clientsScheduledController.clientsAttended2,
        clientsScheduledController.clientsAttended3,
        clientsScheduledController.clientsAttended4,
        // Agrega más listas según sea necesario
      ]; //CREANDO LISTAS PARA UTILIZARLO EN EL FOR
      List<AnimationController?> animationCont = [
        clientsScheduledController.animationController1,
        clientsScheduledController.animationController2,
        clientsScheduledController.animationController3,
        clientsScheduledController.animationController4,
        // Agrega más listas según sea necesario
      ];

      activeClock() {
        print('La aplicación se activeClock() {--111');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            animationCont[0]!.duration =
                Duration(seconds: animationCont[0]!.duration!.inSeconds);
            //ver si esta con el tecnico ponerlo parado sin descontar
            animationCont[0]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended1!.attended == 4 ||
                clientsScheduledController.clientsAttended1!.attended == 5 ||
                clientsScheduledController.clientsAttended1!.attended == 33) {
              animationCont[0]!.stop();
            }

            print(
                'La aplicación se activeClock() {--1 ${animationCont[0]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 1) {
            animationCont[1]!.duration =
                Duration(seconds: animationCont[1]!.duration!.inSeconds);
            animationCont[1]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended2!.attended == 4 ||
                clientsScheduledController.clientsAttended2!.attended == 5 ||
                clientsScheduledController.clientsAttended2!.attended == 33) {
              animationCont[1]!.stop();
            }
            print(
                'La aplicación se activeClock() {--2 ${animationCont[1]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 2) {
            animationCont[2]!.duration =
                Duration(seconds: animationCont[2]!.duration!.inSeconds);
            animationCont[2]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended3!.attended == 4 ||
                clientsScheduledController.clientsAttended3!.attended == 5 ||
                clientsScheduledController.clientsAttended3!.attended == 33) {
              animationCont[2]!.stop();
            }
            print(
                'La aplicación se activeClock() {--3 ${animationCont[2]!.duration!.inSeconds}');
          } else if (clientsScheduledController.item[i] == 3) {
            animationCont[3]!.duration =
                Duration(seconds: animationCont[3]!.duration!.inSeconds);
            animationCont[3]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended4!.attended == 4 ||
                clientsScheduledController.clientsAttended4!.attended == 5 ||
                clientsScheduledController.clientsAttended4!.attended == 33) {
              animationCont[3]!.stop();
            }
            print(
                'La aplicación se activeClock() {--4 ${animationCont[3]!.duration!.inSeconds}');
          }
        }
      }

      activeClockLogin() {
        print('La aplicación se activeClock() {--9');
        for (var i = 0; i < clientsScheduledController.item.length; i++) {
          if (clientsScheduledController.item[i] == 0) {
            print(
                'relojes activos: 1-clientsScheduledController.item[$i]:${clientsScheduledController.item[i]}');
            print(
                'relojes activos: 1-:${clientsScheduledController.clientsAttended1!.attended}');
            print(
                'relojes activos: 1-clientsScheduledController.timeClientsAttended1!${clientsScheduledController.timeClientsAttended1!}');
            animationCont[0]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended1!);

            animationCont[0]!.forward();
            //verificar si esta con el tecnico y detenerlo
            if (clientsScheduledController.clientsAttended1!.attended == 4 ||
                clientsScheduledController.clientsAttended1!.attended == 5 ||
                clientsScheduledController.clientsAttended1!.attended == 33) {
              animationCont[0]!.stop();
            }

            print(
                'La aplicación se activeClock() {--8 ${clientsScheduledController.timeClientsAttended1!}');
          } else if (clientsScheduledController.item[i] == 1) {
            print(
                'relojes activos: 2-${clientsScheduledController.clientsAttended2!.attended}');
            animationCont[1]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended2!);
            animationCont[1]!.forward();
            //verificar si esta con el tecnico y detenerlo

            if (clientsScheduledController.clientsAttended2!.attended == 4 ||
                clientsScheduledController.clientsAttended2!.attended == 5 ||
                clientsScheduledController.clientsAttended2!.attended == 33) {
              animationCont[1]!.stop();
            }
            print(
                'La aplicación se activeClock() {--7 ${clientsScheduledController.timeClientsAttended2!}');
          } else if (clientsScheduledController.item[i] == 2) {
            print(
                'relojes activos: 3-${clientsScheduledController.clientsAttended3!.attended}');
            animationCont[2]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended3!);
            animationCont[2]!.forward();
            if (clientsScheduledController.clientsAttended3!.attended == 4 ||
                clientsScheduledController.clientsAttended3!.attended == 5 ||
                clientsScheduledController.clientsAttended3!.attended == 33) {
              animationCont[2]!.stop();
            }
            print(
                'La aplicación se activeClock() {--6 ${clientsScheduledController.timeClientsAttended3!}');
          } else if (clientsScheduledController.item[i] == 3) {
            print(
                'relojes activos: 4-${clientsScheduledController.clientsAttended4!.attended}');
            animationCont[3]!.duration = Duration(
                seconds: clientsScheduledController.timeClientsAttended4!);
            animationCont[3]!.forward();
            if (clientsScheduledController.clientsAttended4!.attended == 4 ||
                clientsScheduledController.clientsAttended4!.attended == 5 ||
                clientsScheduledController.clientsAttended4!.attended == 33) {
              animationCont[3]!.stop();
            }
            print(
                'La aplicación se activeClock() {--5 ${clientsScheduledController.timeClientsAttended4!}');
          }
        }
        //llamar aqui y poner en false
      }

      if (loginController.isLoggingInCharge == true) {
        //solo va a entar si viene del login
        print(
            'Hubo un cierre inesperado y se estan activando los relojessiiiiii');

        activeClockLogin();
      }
      if (clientsScheduledController.closeIesperado == true &&
          loginController.isLoggingInCharge == false) {
        print(
            'Hubo un cierre inesperado y se estan activando los relojesDDDDDDDDDDDDDDDDDDDDD');
        activeClock();
      }

      if (clientsScheduledController.activeModifyTime == true) {
        //SI activeModifyTime =  TRUE SUMO TIEMPO
        print(
            'tiempo a sumar =  2 EL TIEMPO ACTUAL DEL RELOJ estoy entrando aqui');
        //aqui verifico qsi hay que agregarle el tiempo algun reloj
        print(
            'activeModifyTime SOY = ${clientsScheduledController.activeModifyTime} Y MANDE ESTE TIEMPO ${clientsScheduledController.modifyTime[clientsScheduledController.modifyTimeSpecific]}');
        int i = clientsScheduledController.modifyTimeSpecific;
        int value = clientsScheduledController
            .modifyTime[clientsScheduledController.modifyTimeSpecific];
        // Obtén la duración total del AnimationController
        Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
        double tiempoTranscurrido =
            animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
        double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;

        print(
            'EL TIEMPO ACTUAL DEL RELOJ Tiempo duracionTotal: $duracionTotal');
        print(
            'EL TIEMPO ACTUAL DEL RELOJ Tiempo tiempoTranscurrido: ${tiempoTranscurrido.truncate()}');
        print('EL TIEMPO ACTUAL DEL RELOJ Tiempo restante: $tiempoRestante');

        int valueMin = tiempoRestante.truncate() + value;
        Duration nuevaDuracion = Duration(
          seconds: valueMin, //todo cambiar123RLP
        );

        animationCont[i]!.duration = nuevaDuracion;
        print(
            'EL TIEMPO ACTUAL DEL RELOJ duracionSend YA sera valueMinuto :$valueMin');
        //aqui actualizar la variable
        //aqui es cuando agregan algun servicio
        //todo aqui poner el metodo
        loginController.getUpdateTime(valueMin, (i + 1),
            'build-homePage-i=${i + 1}'); //porque i comienza en 0

        animationCont[i]!.reset();
        animationCont[i]!.forward();
        print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');

        //preguntar que no venga del login
      }

      if (clientsScheduledController.activeModifyTimeRest == true) {
        if (clientsScheduledController.modifyTimeSpecificRest != -99) //reloj 1
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;
          print('modificar time de mm i = $i');
          print('modificar time de mm value = $value');
// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            seconds: valueMin, //todo cambiar123RLP
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
          //aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 1, 'build-homePage-1'); //debe ser el reloj 1
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        if (clientsScheduledController.modifyTimeSpecificRest1 != -99) //reloj 2
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest1 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest1;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME1;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            seconds: valueMin, //todo cambiar123RLP
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
          //aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 2, 'build-homePage-1'); //debe ser el reloj 2
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }
        if (clientsScheduledController.modifyTimeSpecificRest2 != -99) //reloj 3
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest2 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest2;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME2;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            seconds: valueMin, //todo cambiar123RLP
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
//aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 3, 'build-homePage-3'); //debe ser el reloj 3
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        if (clientsScheduledController.modifyTimeSpecificRest3 != -99) //reloj 4
        {
          print(
              'modificar time de mm 1 estoy aqui en el (clientsScheduledController.modifyTimeSpecificRest3 != -99)');
          int i = clientsScheduledController.modifyTimeSpecificRest3;
          int value = clientsScheduledController.modifyTimeSpecificRestTIME3;
          // Obtén la duración total del AnimationController
          Duration? duracionTotal = animationCont[i]!.duration;

// Obtén el tiempo transcurrido hasta ahora en minutos
          double tiempoTranscurrido =
              animationCont[i]!.value * duracionTotal!.inMinutes;

// Calcula el tiempo restante en minutos
          double tiempoRestante = duracionTotal.inMinutes - tiempoTranscurrido;
          int valueMin = tiempoRestante.truncate() - value;
          if (valueMin <= 0) {
            valueMin = 1;
          }
          Duration nuevaDuracion = Duration(
            seconds: valueMin, //todo cambiar123RLP
          );

          animationCont[i]!.duration = nuevaDuracion;
          print('EL TIEMPO ACTUAL DEL RELOJ duracionSend YA:$nuevaDuracion');
//aqui actualizar la variable
          //aqui es cuando eliminan algun servicio
          //todo aqui poner el metodo
          loginController.getUpdateTime(
              valueMin, 4, 'build-homePage-4'); //debe ser el reloj 4
          animationCont[i]!.reset();
          animationCont[i]!.forward();
          print('EL TIEMPO ACTUAL DEL RELOJ RESETEADO YA');
        }

        //preguntar que no venga del login
      }

      //AQUI ESCUCHANDO PARA SABER SI TENGO QUE DETENER O REAUNUDAR LOS TIMER
      if (clientsScheduledController.clockchanges == true) {
        //
        for (var i = 0;
            i < clientsScheduledController.pausResumeClock.length;
            i++) {
          int? value = clientsScheduledController.pausResumeClock[i];
          //
          if (value != -99) {
            if (value == 0) //hay que pausarlo
            {
              if (i == 0) {
                clientsScheduledController.animationController1!.stop();
                print('PAUSE EL RELOJ 1');
              }
              if (i == 1) {
                clientsScheduledController.animationController2!.stop();
                print('PAUSE EL RELOJ 2');
              }
              if (i == 2) {
                clientsScheduledController.animationController3!.stop();
                print('PAUSE EL RELOJ 3');
              }
              if (i == 3) {
                clientsScheduledController.animationController4!.stop();
                print('PAUSE EL RELOJ 4');
              }
            }
          }
        } //fin del for
      }


      // //todo AQUI DETENGO LOS TIMER QUE NO ESTAN VISIBLES

      if (clientsScheduledController.clientsScheduledNextServ != null) {

        String fullName = clientsScheduledController.clientsScheduledNextServ!.client_name!;







        //todo1                // Dividir el nombre completo por espacios
        List<String> partsName =
            fullName.split(" "); // Tomar los primeros dos nombres (si existen)

         String firtsName = partsName.length > 0 ? partsName[0] : "";
      }
      //todo IMPORTANTE ESTA FUNCION SE EJECUTA DESPUES QUE SE CREA EL WIDGET

      return RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        backgroundColor: const Color(0xFFFDAE2A),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // Esto permite que el scroll siempre esté disponible

          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.1),
            child: IntrinsicHeight(
              child: Column(
                //Cart anaranjado grande inicial que tiene el cronometro
                children: [
                  clientsScheduledController.getWaitTime() == true &&
                          loginController.usserPermissionQr == 1
                      ? Expanded(
                          flex: loginController.androidInfoDisplay! >=
                                  6.6 //propiedades de telefone
                              ? 12
                              : 13,
                          child: Center(
                              child: Text(
                                  'Espera de ${clientsScheduledController.getwaitTimeCount()} segundos',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 82, 81, 81),
                                  ))))
                      : Expanded(
                          flex: loginController.androidInfoDisplay! >=
                                  6.6 //propiedades de telefone
                              ? 12
                              : 13,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: clientsScheduledController
                                            .item.isEmpty &&
                                        (clientsScheduledController
                                                    .clientsScheduledNextServ ==
                                                null ||
                                            (clientsScheduledController
                                                        .boolFilterShowNext ==
                                                    false &&
                                                clientsScheduledController
                                                        .errorHome !=
                                                    -99)) &&
                                        loginController.usserPermissionQr == 1
                                    ? const SizedBox(
                                        height: 45,
                                      )
                                    : (clientsScheduledController
                                                        .clientsScheduledListLength >
                                                    0 ||
                                                clientsScheduledController
                                                        .errorHome ==
                                                    -99) &&
                                            loginController.usserPermissionQr ==
                                                1
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              color: Colors.white,
                                              //color: Color(0xFFFDAE2A),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                /*todo texto arriba */
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      clientsScheduledController
                                                              .item.isEmpty
                                                          ? 'Cliente en espera'
                                                          : 'Atendiendo ${clientsScheduledController.item.length} cliente(s)',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Color.fromARGB(
                                                            255, 82, 81, 81),
                                                      ),
                                                    ),
                                                  ),
                                                ),


                                                /*CRONOMETRO*/
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  //todo AQUI LA LOGICA AL MOSTRAR LOS TIMER
                                                  child: SingleChildScrollView(
                                                  /*  scrollDirection:
                                                        Axis.horizontal,*/
                                                    child: Column(
    /*   mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,*/
                                                        children: [
                                                          //AQUI MUESTRA LOS TIMER DE LOS CLIENTES QUE ESTE ATENDIENDO
                                                          if (clientsScheduledController
                                                              .item
                                                              .isNotEmpty) ...[
                                                            for (int i = 0;
                                                                i <
                                                                    clientsScheduledController
                                                                        .item
                                                                        .length;
                                                                i++) ...[
                                                              cardTimer(

                                                                clientsList[clientsScheduledController
                                                                        .item[i]]!
                                                                    .reservation_id!,
                                                                i,
                                                                clientsList[clientsScheduledController
                                                                        .item[i]]!
                                                                    .attended!,
                                                                clientsList[clientsScheduledController
                                                                        .item[i]]!
                                                                    .car_id!,
                                                                clientsList[clientsScheduledController
                                                                        .item[i]]!
                                                                    .client_image!,
                                                                UniqueKey(),
                                                                clientsList[clientsScheduledController
                                                                        .item[i]]!
                                                                    .client_name!,
                                                              clientsList[clientsScheduledController
                                                                  .item[i]]!
                                                                  .client_image,
                                                              clientsList[clientsScheduledController
                                                                  .item[i]]!
                                                                  .url_image_barber,
                                                              clientsList[clientsScheduledController
                                                                  .item[i]]!
                                                                  .frecuencia,
                                                              clientsList[clientsScheduledController
                                                                  .item[i]]!
                                                                  .cant_visit.toString(),

                                                              clientsList[clientsScheduledController
                                                                  .item[i]]!
                                                                  .professional_name,
                                                              clientsScheduledController,
                                                                animationCont[
                                                                    clientsScheduledController
                                                                            .item[
                                                                        i]]!,
                                                              ),
                                                            ],
                                                          ]
                                                          //SI NO ESTA ATENDIENDOA NADIE Y HAY GENTE EN LA COLA ESPERANDO CARGA EL TIMER INICIAL
                                                          else if (clientsScheduledController
                                                                  .clientsScheduledNextServ !=
                                                              null) ...[
                                                            //AQUI VERIFICO SI YA ESCANEO EL CODIGO QR
                                                            if (loginController
                                                                        .codigoQrValid() ==
                                                                    true &&
                                                                clientsScheduledController
                                                                    .item
                                                                    .isEmpty) ...[


                                                            ] else if (loginController
                                                                    .usserPermissionQr ==
                                                                2) ...[
                                                              const Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          35,
                                                                    ),
                                                                    Text(
                                                                      'Debe de esperar la respuesta',
                                                                      style: TextStyle(
                                                                          // color: Colors.white,
                                                                          color: Color.fromARGB(255, 39, 39, 39),
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      'a su solicitud',
                                                                      style: TextStyle(
                                                                          //color: Colors.white,
                                                                          color: Color.fromARGB(255, 39, 39, 39),
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          45,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ] else ...[
                                                              const Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          35,
                                                                    ),
                                                                    Text(
                                                                      'Debe de escanear el código Qr ',
                                                                      style: TextStyle(
                                                                          // color: Colors.white,
                                                                          color: Color.fromARGB(255, 39, 39, 39),
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      'para atender clientes',
                                                                      style: TextStyle(
                                                                          //color: Colors.white,
                                                                          color: Color.fromARGB(255, 39, 39, 39),
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          45,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]
                                                          ] else ...[
                                                            const SizedBox(
                                                              height: 45,
                                                            ),
                                                          ]
                                                        ]),
                                                  ),
                                                  //FIN CLIENTES QUE ESTAN EN COLA
                                                ),
                                                //todo CLIENTES QUE ESTAN EN COLA

                                                //FIN CLIENTES QUE ESTAN EN COLA
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: 80,
                                          ),
                              ),
                              clientsScheduledController.boolControlVision ==
                                          true &&
                                      loginController.usserPermissionQr == 1
                                  ? clientsScheduledController
                                                  .boolFilterShowNext ==
                                              true ||
                                          (clientsScheduledController.errorHome ==
                                                  -99 &&
                                              clientsScheduledController
                                                      .boolFilterShowNextAux ==
                                                  true) //saber si dio error y estaba para mostrar el siguiente en boolFilterShowNextAux
                                      ? cardClientTails(
                                          clientsScheduledController,
                                          context,

                                          animationCont)
                                      :

                                      //si hubiera algien en cola
                                      (clientsScheduledController
                                                      .clientsScheduledListLengthTail >
                                                  0) &&
                                              clientsScheduledController
                                                      .errorClientAcept ==
                                                  false
                                          ? const Column(
                                              children: [
                                                Text(
                                                  'Cliente atendiéndose',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 82, 81, 81),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  'Esperando para mostrar el siguiente',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 82, 81, 81),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          : clientsScheduledController
                                                      .errorClientAcept ==
                                                  false
                                              ? const Text(
                                                  'No hay clientes en cola.',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 82, 81, 81),
                                                  ))
                                              : Text('')
                                  : loginController.usserPermissionQr == 2
                                      ? const Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 35,
                                              ),
                                              Text(
                                                'Debe de esperar la respuesta',
                                                style: TextStyle(
                                                    // color: Colors.white,
                                                    color: Color.fromARGB(
                                                        255, 39, 39, 39),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                'a su solicitud',
                                                style: TextStyle(
                                                    //color: Colors.white,
                                                    color: Color.fromARGB(
                                                        255, 39, 39, 39),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 45,
                                              ),
                                            ],
                                          ),
                                        )
                                      : loginController.usserPermissionQr ==
                                              null
                                          ? Text('')
                                          : const Column(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Center(
                                                  child: SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFFFDAE2A),
                                                      strokeWidth: 3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                            ],
                          )),
                  Expanded(
                      flex: 13,
                      // 85% del espacio disponible para esta parte
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 1),
                        child: Container(
                          color: const Color.fromARGB(255, 231, 232, 234),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    loginController.setIsLoading == true
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFFDAE2A),
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Text(''),
                                    Text('                        '),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Get.dialog(
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xFFFDAE2A),
                                                ),
                                              ),
                                              barrierDismissible: false,
                                            ); //Get.back();
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));
                                            await coexCont.fetchEstadist0();

                                            pagesConfigC.onTabTapped(
                                                3); //index = 3 -> /StatisticPage
                                          },
                                          child: cartsHome(
                                              context,
                                              12,
                                              const Color(0xFF19CF9E),
                                              Color.fromARGB(
                                                  255, 231, 233, 233),
                                              'Estadísticas',
                                              'Revisa tus Ingresos',
                                              Icons.bar_chart),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            Get.dialog(
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xFFFDAE2A),
                                                ),
                                              ),
                                              barrierDismissible: false,
                                            ); //Get.back();
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));
                                            await coexCont.fetchEstadist0();

                                            pagesConfigC.onTabTapped(
                                                3); //index = 3 -> /StatisticPage
                                          },
                                          child: cartsHome(
                                              context,
                                              12,
                                              const Color(0xFF4470F3),
                                              Color.fromARGB(
                                                  255, 231, 233, 233),
                                              'Solicitudes',
                                              'Adelantos y Productos',
                                              Icons.bar_chart),
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
              ),
            ),
          ),
        ),
      );
    });
  }

  TableRow _histRow(String servicio, String fecha, String cantidad) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(servicio,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(fecha),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(cantidad),
      ),
    ]);
  }

  cardClientTails(
      ClientsScheduledController clientsScheduledController2,
      BuildContext context, List<AnimationController?> animationCont) {
    return GetBuilder<ClientsScheduledController>(
        builder: (clientsScheduledControllerE) {

      if(clientsScheduledControllerE.clientsScheduledNextServ !=
          null &&
          clientsScheduledControllerE.getWaitTime() == false)
        {
          print('Match: ${clientsScheduledControllerE.clientsScheduledNextServ?.toMap()}');
          print('Match: ${clientsScheduledControllerE.clientsScheduledList[0].toMap()}');

           firstName=clientsScheduledControllerE.clientsScheduledNextServ!.client_name!;
           urlImageClient= clientsScheduledControllerE.clientsScheduledNextServ!.client_image!;
           urlImageBarber=  clientsScheduledControllerE.clientsScheduledNextServ!.url_image_barber!;
           frecuenciaBarber1 = clientsScheduledControllerE.clientsScheduledNextServ!.frecuencia!;
           cantVisitBarber1= clientsScheduledControllerE.clientsScheduledNextServ!.cant_visit.toString();
           UltimateBarber1= clientsScheduledControllerE.clientsScheduledNextServ!.professional_name!;
           history_service = clientsScheduledControllerE.clientsScheduledNextServ?.history_service ?? [];



          if(clientsScheduledControllerE.clientsScheduledNextServ!.url_image_barber !=null && clientsScheduledControllerE.clientsScheduledNextServ!.url_image_barber !="")
          {
            print("Entró");
            firstNameNext = firstName;
            urlImageClientNext = urlImageClient;
            urlImageBarberNext = urlImageBarber;
            frecuenciaBarberNext = frecuenciaBarber1;
            cantVisitBarberNext = cantVisitBarber1;
            UltimateBarberNext= UltimateBarber1;

          }

        if(history_service.length>0 &&history_service!=null)
          {
            history_serviceNext = history_service;
          }


          print("Entra aca");
          //todo 710
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Cliente
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60, // Ajusta a tu necesidad
                              height: 60,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [

                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClientNext',
                                        width: 48,   // <- Igual a radius * 2
                                        height: 48,  // <- Igual a radius * 2
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.person, size: 24),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8, // mueve hacia abajo para que no lo tape el avatar

                                    left: -8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        frecuenciaBarberNext!,
                                        style: const TextStyle(fontSize: 9, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(firstNameNext.characters.length > 10
                                ? '${firstNameNext.characters.take(10)}...'
              : firstNameNext,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text("Visitas: $cantVisitBarberNext", style: const TextStyle(fontSize: 11)),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Barbero
                      Row(
                        children: [
                          //todo 711
                      CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                      child: CachedNetworkImage(
                      imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageBarberNext',
                      width: 48,   // <- Igual a radius * 2
                      height: 48,  // <- Igual a radius * 2
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                      child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.person, size: 24),
                      ),
                      ),
                      ),
                      //Profesional en espera
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(UltimateBarberNext!.characters.length > 10
          ? '${UltimateBarberNext!.characters.take(10)}...'
              : UltimateBarberNext!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const Text("Último Profesional", style: TextStyle(fontSize: 11)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),



                // FOTOS
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child:    Align(
                      alignment:
                      Alignment
                          .topLeft,
                      child: Row(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .center,
                        children: [

                          Column(
                            children: [
                              GestureDetector(
                                onTap:
                                    () {
                                  showZoomableImage(context,
                                      '${dotenv.env['API_ENDPOINT']}/images/$urlImageClientNext');
                                },
                                child:
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  child:
                                  CachedNetworkImage(
                                    imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClientNext',
                                    placeholder: (context, url) => Container(
                                      width: 130,
                                      height: 130,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(110, 253, 176, 42),
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      'assets/images/default_profile.jpg',
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                    fit: BoxFit.cover,
                                    width: 160,
                                    height: 130,
                                  ),
                                ),
                              ),
                              const Align(
                                  alignment:
                                  Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Último look',
                                      style: TextStyle(fontSize: 12, height: 1.3, color: Color(0xFFFDAE2A), fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            ],
                          ),

                          const SizedBox(
                            width: 20,
                          ),
                          Transform
                              .scale(
                            scale:
                            1.0,
                            child:
                            cardTimer2(
                              UniqueKey(),
                              'Esperando',
                              clientsScheduledController,
                              clientsScheduledController
                                  .animationControllerInitial!,
                            ),
                          ),

                        ],
                      ),
                    )
                ),

                const SizedBox(height: 16),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.history, color: Colors.black),
                          SizedBox(width: 8),
                          Text("Historial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Servicios", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Cantidad", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Aquí generamos dinámicamente las filas
                      ...history_serviceNext.map((service) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(service.name),
                            Text(service.cant.toString()),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),



                const SizedBox(height: 16),
/*
            Container(
              height: (MediaQuery.of(context).size.height * 0.115),
              width: (MediaQuery.of(context).size.width * 0.20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Color blanco para el borde
                  width:
                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                ),
                color: Color(0xFFFF6750),
                borderRadius:
                const BorderRadius.all(Radius.circular(18)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6750),
                  // Color de fondo en verde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  if (clientsScheduledController.errorHome != -99) {
                    if (loginController.codigoQrValid() == true &&
                        loginController.usserPermissionQrAntes ==
                            1) {
                      clientsScheduledControllerE
                          .setBoolFilterShowNext(false);
                      clientsScheduledControllerE
                          .setBoolControlVision(false);

                      int rest =
                      await clientsScheduledControllerE
                          .acceptOrRejectClient(
                          clientsScheduledControllerE
                              .clientsScheduledNextServ!
                              .reservation_id,
                          3,
                          loginController
                              .tokenUserLoggedIn);
                      if (rest == 1) {
                        LocalStorage.prefs
                            .setInt('valueClockIni', 180);
                        clientsScheduledController
                            .setTotalTimeInitial(180);
                        LocalStorage.prefs
                            .setBool('valueClockActiv', false);

                        clientsScheduledController
                            .animationControllerInitial!
                          ..duration = Duration(seconds: 180)
                          ..reset()
                          ..stop();
                        loginController.setCodigoQrValid(2);
                      } else {
                        loginController.setCodigoQrValid(1);
                      }
                    } else if (loginController.usserPermissionQr ==
                        2) {
                      Get.snackbar(
                        'Mensaje',
                        'Debe de esperar la respuesta a su solicitud',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                        'Debe de escanear el código Qr de entrada',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                  } else {
                    //mostrar mensaje de error de conexion
                    loginController.showConnectionError();
                    await Future.delayed(
                        Duration(milliseconds: 1000));
                    Get.snackbar(
                      'Mensaje',
                      'Vuelva a intentarlo, hubo problema de conexión.',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor:
                      const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                      const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                      const AlwaysStoppedAnimation(
                          Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                  }
                },
                child: Icon(
                  MdiIcons.thumbDownOutline,
                  color: Colors.white,
                  size: (MediaQuery.of(context).size.height * 0.04),
                ),
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
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.person,
                              color: const Color.fromARGB(
                                  255, 43, 44, 49),
                              size: 22,
                            ),
                            Text(
                              //todo 707 nombre
                              clientCord.truncateText(
                                  firstName, 13),
                              softWrap: true,
                              style: const TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            // todo 707 AQUI ESTA EL TIEMPO TOTAL DEL SERVICIO
                              (clientsScheduledControllerE
                                  .clientsScheduledNextServ!
                                  .total_time!),
                              style: const TextStyle(
                                height: 1.2,
                                fontSize: 16,
                                color: Color.fromARGB(180, 0, 0, 0),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .services!
                            .length >
                            2
                            ? 2
                            : clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .services!
                            .length,
                        // todo 707 aqui estan los servicios
                        itemBuilder: (context, index) => Row(
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      MdiIcons.viewList,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      clientsScheduledControllerE
                                          .clientsScheduledNextServ!
                                          .services![index]
                                          .name,
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height * 0.5),
              //   height: (MediaQuery.of(context).size.height * 0.115),
              width: (MediaQuery.of(context).size.width * 0.20),
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    Colors.white, // Color blanco para el borde
                    width:
                    1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                  ),
                  color: const Color(0xFF19CF9E),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(18))),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19CF9E),
                  // Color de fondo en verde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                  if (clientsScheduledController.errorHome != -99) {
                    if (loginController.codigoQrValid() == true &&
                        loginController.usserPermissionQrAntes ==
                            1 &&
                        clientsScheduledControllerE
                            .clientsScheduledNextServ !=
                            null &&
                        clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .reservation_id! >
                            0) {
                      loginController.setMakeCall(false);
                      clientsScheduledControllerE
                          .setBoolControlVision(false);
                      clientsScheduledControllerE
                          .setBoolFilterShowNext(false);
                      //aqui poner que muestre un cargando
                      clientsScheduledControllerE
                          .clientsScheduledNextServAux =
                      clientsScheduledControllerE
                          .clientsScheduledNextServ!;
                      clientsScheduledControllerE
                          .funtErrorClientAcept(true);

                      int resulButton = 0;
                      resulButton =
                          loginController.handleButtonClick(
                              clientsScheduledControllerE
                                  .clientsScheduledNextServ!
                                  .reservation_id!);
                      if (resulButton == 1) {
                        int timeClock = clientsScheduledControllerE
                            .convertTimeToSeconds(
                            clientsScheduledControllerE
                                .clientsScheduledNextServAux!
                                .total_time!);
                        int clock = clientsScheduledControllerE
                            .availability;
                        // (timeClock, clock,detached, reservationId, attended, token)
                        int aceptClient =
                        await clientsScheduledControllerE
                            .acceptClientClock(
                            clientsScheduledControllerE
                                .clientsScheduledNextServAux!,
                            timeClock,
                            //timeClock
                            clock,
                            //clock
                            1,
                            //detached
                            clientsScheduledControllerE
                                .clientsScheduledNextServ!
                                .reservation_id,
                            //reservationId
                            1,
                            //attended
                            loginController
                                .tokenUserLoggedIn); //token
                        if (aceptClient == 1) {
                          // detengo todos los timers que deben detenerse
                          for (int j = 0;
                          j <
                              clientsScheduledControllerE
                                  .itemDel.length;
                          j++) {
                            animationCont[
                            clientsScheduledControllerE
                                .itemDel[j]]!
                                .stop();
                            animationCont[
                            clientsScheduledControllerE
                                .itemDel[j]]!
                                .reset();
                          }
                          //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                          if (clientsScheduledControllerE
                              .busyClock ==
                              0) {
                            // Detenemos el controlador
                            if (animationCont[0]!.isAnimating) {
                              animationCont[0]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[0]!.reset();
                            animationCont[0]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended1!);
                            animationCont[0]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              1) {
                            if (animationCont[1]!.isAnimating) {
                              animationCont[1]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[1]!.reset();
                            animationCont[1]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended2!);
                            animationCont[1]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              2) {
                            if (animationCont[2]!.isAnimating) {
                              animationCont[2]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[2]!.reset();
                            animationCont[2]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended3!);
                            animationCont[2]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              3) {
                            if (animationCont[3]!.isAnimating) {
                              animationCont[3]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[3]!.reset();
                            animationCont[3]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended4!);
                            animationCont[3]!.forward();
                          }
                        } else {
                          //activo nuevamente que el boton para coger al cliente este disponible
                          loginController.handleButtonClickDelete(
                              clientsScheduledControllerE
                                  .clientsScheduledNextServAux!
                                  .reservation_id!);
                          //mostrar mensaje de error de
                          loginController.showConnectionError();
                          await Future.delayed(
                              Duration(milliseconds: 1500));
                          Get.snackbar(
                            'Mensaje',
                            'Vuelva a intentarlo, hubo problema de conexión..',
                            duration:
                            const Duration(milliseconds: 2500),
                            backgroundColor: const Color.fromARGB(
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
                          loginController.setMakeCall(true);
                          clientsScheduledControllerE
                              .setBoolFilterShowNext(true);
                          await _refresh();
                        }
                      }
                      loginController.setMakeCall(true);
                      // clientsScheduledControllerE
                      //     .setBoolControlVision(true);
                    } else if (loginController.usserPermissionQr ==
                        2) {
                      Get.snackbar(
                        'Mensaje',
                        'Debe de esperar la respuesta a su solicitud',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                        'Debe de escanear el código Qr de entrada',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                  } else {
                    //mostrar mensaje de error de conexion
                    loginController.showConnectionError();
                    await Future.delayed(
                        Duration(milliseconds: 1000));
                    Get.snackbar(
                      'Mensaje',
                      'Vuelva a intentarlo, hubo problema de conexión..',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor:
                      const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                      const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                      const AlwaysStoppedAnimation(
                          Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                  }
                  clientsScheduledControllerE
                      .funtErrorClientAcept(false);
                },
                child: Icon(
                  MdiIcons.thumbUpOutline,
                  color: Colors.white,
                  size: (MediaQuery.of(context).size.height * 0.04),
                ),
              ),
            ),
*/
                // BOTTOM FOOTER
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  child: Row(
                    children: [
                      // Botón izquierdo
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: (MediaQuery.of(context).size.height * 0.115),
                                width: (MediaQuery.of(context).size.width * 0.20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white, // Color blanco para el borde
                                    width:
                                    1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                  ),
                                  color: Color(0xFFFF6750),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6750),
                                    // Color de fondo en verde
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          16.0), // Ajusta el radio según tus necesidades
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (clientsScheduledController.errorHome != -99) {
                                      if (loginController.codigoQrValid() == true &&
                                          loginController.usserPermissionQrAntes ==
                                              1) {
                                        clientsScheduledControllerE
                                            .setBoolFilterShowNext(false);
                                        clientsScheduledControllerE
                                            .setBoolControlVision(false);

                                        int rest =
                                        await clientsScheduledControllerE
                                            .acceptOrRejectClient(
                                            clientsScheduledControllerE
                                                .clientsScheduledNextServ!
                                                .reservation_id,
                                            3,
                                            loginController
                                                .tokenUserLoggedIn);
                                        if (rest == 1) {
                                          LocalStorage.prefs
                                              .setInt('valueClockIni', 180);
                                          clientsScheduledController
                                              .setTotalTimeInitial(180);
                                          LocalStorage.prefs
                                              .setBool('valueClockActiv', false);

                                          clientsScheduledController
                                              .animationControllerInitial!
                                            ..duration = Duration(seconds: 180)
                                            ..reset()
                                            ..stop();
                                          loginController.setCodigoQrValid(2);
                                        } else {
                                          loginController.setCodigoQrValid(1);
                                        }
                                      } else if (loginController.usserPermissionQr ==
                                          2) {
                                        Get.snackbar(
                                          'Mensaje',
                                          'Debe de esperar la respuesta a su solicitud',
                                          duration:
                                          const Duration(milliseconds: 2500),
                                          backgroundColor: const Color.fromARGB(
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
                                          'Debe de escanear el código Qr de entrada',
                                          duration:
                                          const Duration(milliseconds: 2500),
                                          backgroundColor: const Color.fromARGB(
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
                                    } else {
                                      //mostrar mensaje de error de conexion
                                      loginController.showConnectionError();
                                      await Future.delayed(
                                          Duration(milliseconds: 1000));
                                      Get.snackbar(
                                        'Mensaje',
                                        'Vuelva a intentarlo, hubo problema de conexión.',
                                        duration: const Duration(milliseconds: 2500),
                                        backgroundColor:
                                        const Color.fromARGB(118, 255, 255, 255),
                                        showProgressIndicator: true,
                                        progressIndicatorBackgroundColor:
                                        const Color.fromARGB(255, 203, 205, 209),
                                        progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color(0xFFFDAE2A)),
                                        overlayBlur: 3,
                                      );
                                    }
                                  },
                                  child: Icon(
                                    MdiIcons.thumbDownOutline,
                                    color: Colors.white,
                                    size: (MediaQuery.of(context).size.height * 0.04),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              //todo 708
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${truncateText(
                                        clientsScheduledControllerE
                                            .clientsScheduledNextServ!
                                            .client_name!, 10)}     ${clientsScheduledControllerE
                                        .clientsScheduledNextServ!
                                        .total_time!}",

                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  ...List.generate(
                                    (clientsScheduledControllerE.clientsScheduledNextServ!.services!.length > 2)
                                        ? 2
                                        : clientsScheduledControllerE.clientsScheduledNextServ!.services!.length,
                                        (index) {
                                      final service = clientsScheduledControllerE
                                          .clientsScheduledNextServ!.services![index];
                                      return Text(
                                        service.name,


                                      );
                                    },
                                  ),
                                ],
                              ),

                              Spacer(),

                              // Botón derecho
                              Container(
                                height: (MediaQuery.of(context).size.height *  0.115),
                                //   height: (MediaQuery.of(context).size.height * 0.115),
                                width: (MediaQuery.of(context).size.width * 0.20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                      Colors.white, // Color blanco para el borde
                                      width:
                                      1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                    ),
                                    color: const Color(0xFF19CF9E),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(18))),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF19CF9E),
                                    // Color de fondo en verde
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          16.0), // Ajusta el radio según tus necesidades
                                    ),
                                  ),
                                  onPressed: () async {
                                    //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                                    if (clientsScheduledController.errorHome != -99) {
                                      if (loginController.codigoQrValid() == true &&
                                          loginController.usserPermissionQrAntes ==
                                              1 &&
                                          clientsScheduledControllerE
                                              .clientsScheduledNextServ !=
                                              null &&
                                          clientsScheduledControllerE
                                              .clientsScheduledNextServ!
                                              .reservation_id! >
                                              0) {
                                        loginController.setMakeCall(false);
                                        clientsScheduledControllerE
                                            .setBoolControlVision(false);
                                        clientsScheduledControllerE
                                            .setBoolFilterShowNext(false);
                                        //aqui poner que muestre un cargando
                                        clientsScheduledControllerE
                                            .clientsScheduledNextServAux =
                                        clientsScheduledControllerE
                                            .clientsScheduledNextServ!;
                                        clientsScheduledControllerE
                                            .funtErrorClientAcept(true);

                                        int resulButton = 0;
                                        resulButton =
                                            loginController.handleButtonClick(
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServ!
                                                    .reservation_id!);
                                        if (resulButton == 1) {
                                          int timeClock = clientsScheduledControllerE
                                              .convertTimeToSeconds(
                                              clientsScheduledControllerE
                                                  .clientsScheduledNextServAux!
                                                  .total_time!);
                                          int clock = clientsScheduledControllerE
                                              .availability;
                                          // (timeClock, clock,detached, reservationId, attended, token)
                                          int aceptClient =
                                          await clientsScheduledControllerE
                                              .acceptClientClock(
                                              clientsScheduledControllerE
                                                  .clientsScheduledNextServAux!,
                                              timeClock,
                                              //timeClock
                                              clock,
                                              //clock
                                              1,
                                              //detached
                                              clientsScheduledControllerE
                                                  .clientsScheduledNextServ!
                                                  .reservation_id,
                                              //reservationId
                                              1,
                                              //attended
                                              loginController
                                                  .tokenUserLoggedIn); //token
                                          if (aceptClient == 1) {
                                            // detengo todos los timers que deben detenerse
                                            for (int j = 0;
                                            j <
                                                clientsScheduledControllerE
                                                    .itemDel.length;
                                            j++) {
                                              animationCont[
                                              clientsScheduledControllerE
                                                  .itemDel[j]]!
                                                  .stop();
                                              animationCont[
                                              clientsScheduledControllerE
                                                  .itemDel[j]]!
                                                  .reset();
                                            }
                                            //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                                            if (clientsScheduledControllerE
                                                .busyClock ==
                                                0) {
                                              // Detenemos el controlador
                                              if (animationCont[0]!.isAnimating) {
                                                animationCont[0]!.stop();
                                              }

// Reseteamos el controlador a su estado inicial
                                              animationCont[0]!.reset();
                                              animationCont[0]!.duration = Duration(
                                                  seconds: clientsScheduledControllerE
                                                      .timeClientsAttended1!);
                                              animationCont[0]!.forward();
                                            } else if (clientsScheduledControllerE
                                                .busyClock ==
                                                1) {
                                              if (animationCont[1]!.isAnimating) {
                                                animationCont[1]!.stop();
                                              }

// Reseteamos el controlador a su estado inicial
                                              animationCont[1]!.reset();
                                              animationCont[1]!.duration = Duration(
                                                  seconds: clientsScheduledControllerE
                                                      .timeClientsAttended2!);
                                              animationCont[1]!.forward();
                                            } else if (clientsScheduledControllerE
                                                .busyClock ==
                                                2) {
                                              if (animationCont[2]!.isAnimating) {
                                                animationCont[2]!.stop();
                                              }

// Reseteamos el controlador a su estado inicial
                                              animationCont[2]!.reset();
                                              animationCont[2]!.duration = Duration(
                                                  seconds: clientsScheduledControllerE
                                                      .timeClientsAttended3!);
                                              animationCont[2]!.forward();
                                            } else if (clientsScheduledControllerE
                                                .busyClock ==
                                                3) {
                                              if (animationCont[3]!.isAnimating) {
                                                animationCont[3]!.stop();
                                              }

// Reseteamos el controlador a su estado inicial
                                              animationCont[3]!.reset();
                                              animationCont[3]!.duration = Duration(
                                                  seconds: clientsScheduledControllerE
                                                      .timeClientsAttended4!);
                                              animationCont[3]!.forward();
                                            }
                                          } else {
                                            //activo nuevamente que el boton para coger al cliente este disponible
                                            loginController.handleButtonClickDelete(
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServAux!
                                                    .reservation_id!);
                                            //mostrar mensaje de error de
                                            loginController.showConnectionError();
                                            await Future.delayed(
                                                Duration(milliseconds: 1500));
                                            Get.snackbar(
                                              'Mensaje',
                                              'Vuelva a intentarlo, hubo problema de conexión..',
                                              duration:
                                              const Duration(milliseconds: 2500),
                                              backgroundColor: const Color.fromARGB(
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
                                            loginController.setMakeCall(true);
                                            clientsScheduledControllerE
                                                .setBoolFilterShowNext(true);
                                            await _refresh();
                                          }
                                        }
                                        loginController.setMakeCall(true);
                                        // clientsScheduledControllerE
                                        //     .setBoolControlVision(true);
                                      } else if (loginController.usserPermissionQr ==
                                          2) {
                                        Get.snackbar(
                                          'Mensaje',
                                          'Debe de esperar la respuesta a su solicitud',
                                          duration:
                                          const Duration(milliseconds: 2500),
                                          backgroundColor: const Color.fromARGB(
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
                                          'Debe de escanear el código Qr de entrada',
                                          duration:
                                          const Duration(milliseconds: 2500),
                                          backgroundColor: const Color.fromARGB(
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
                                    } else {
                                      //mostrar mensaje de error de conexion
                                      loginController.showConnectionError();
                                      await Future.delayed(
                                          Duration(milliseconds: 1000));
                                      Get.snackbar(
                                        'Mensaje',
                                        'Vuelva a intentarlo, hubo problema de conexión..',
                                        duration: const Duration(milliseconds: 2500),
                                        backgroundColor:
                                        const Color.fromARGB(118, 255, 255, 255),
                                        showProgressIndicator: true,
                                        progressIndicatorBackgroundColor:
                                        const Color.fromARGB(255, 203, 205, 209),
                                        progressIndicatorValueColor:
                                        const AlwaysStoppedAnimation(
                                            Color(0xFFFDAE2A)),
                                        overlayBlur: 3,
                                      );
                                    }
                                    clientsScheduledControllerE
                                        .funtErrorClientAcept(false);
                                  },
                                  child: Icon(
                                    MdiIcons.thumbUpOutline,
                                    color: Colors.white,
                                    size: (MediaQuery.of(context).size.height * 0.04),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                )
              ],
            ),
          );
        }
      else
        {
          return Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: FittedBox(
                fit: BoxFit.contain,
                child: clientsScheduledControllerE.clientsScheduledNextServ !=
                    null &&
                    clientsScheduledControllerE.getWaitTime() == false
                //  ||
                //         LocalStorage.prefs.getBool('valueClockActiv') == false
                    ? Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    children: [
                      // HEADER
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Cliente
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 60, // Ajusta a tu necesidad
                                    height: 60,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [

                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.grey[200],
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                              width: 48,   // <- Igual a radius * 2
                                              height: 48,  // <- Igual a radius * 2
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.person, size: 24),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8, // mueve hacia abajo para que no lo tape el avatar

                                          left: -6,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              frecuenciaBarber1!,
                                              style: const TextStyle(fontSize: 9, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(firstName.characters.length > 10
                                          ? '${firstName.characters.take(10)}...'
                                          : firstName , style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text("Visitas: $cantVisitBarber1", style: const TextStyle(fontSize: 12)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // Barbero
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[200],
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageBarber',
                                      width: 48,   // <- Igual a radius * 2
                                      height: 48,  // <- Igual a radius * 2
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.person, size: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(UltimateBarber1!.characters.length > 10
                                        ? '${UltimateBarber1!.characters.take(10)}...'
                                        : UltimateBarber1!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    const Text("Último Profesional", style: TextStyle(fontSize: 12)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),



                      // FOTOS
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child:    Align(
                            alignment:
                            Alignment
                                .topLeft,
                            child: Row(
                              mainAxisSize:
                              MainAxisSize
                                  .min,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [

                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap:
                                          () {
                                        showZoomableImage(context,
                                            '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient');
                                      },
                                      child:
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                        child:
                                        CachedNetworkImage(
                                          imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                          placeholder: (context, url) => Container(
                                            width: 130,
                                            height: 130,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Color.fromARGB(110, 253, 176, 42),
                                                ),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            'assets/images/default_profile.jpg',
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          fit: BoxFit.cover,
                                          width: 160,
                                          height: 130,
                                        ),
                                      ),
                                    ),
                                    const Align(
                                        alignment:
                                        Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            'Último look',
                                            style: TextStyle(fontSize: 12, height: 1.3, color: Color(0xFFFDAE2A), fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                  ],
                                ),

                                const SizedBox(
                                  width: 20,
                                ),
                                Transform
                                    .scale(
                                  scale:
                                  1.0,
                                  child:
                                  cardTimer2(
                                    UniqueKey(),
                                    'Esperando',
                                    clientsScheduledController,
                                    clientsScheduledController
                                        .animationControllerInitial!,
                                  ),
                                ),

                              ],
                            ),
                          )
                      ),

                      const SizedBox(height: 16),

                      // HISTORIAL
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.history, color: Colors.black),
                                SizedBox(width: 8),
                                Text("Historial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Servicios", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Cantidad", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Corte de Cabello"),
                                Text("2"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Cejas"),
                                Text("3"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
/*
            Container(
              height: (MediaQuery.of(context).size.height * 0.115),
              width: (MediaQuery.of(context).size.width * 0.20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Color blanco para el borde
                  width:
                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                ),
                color: Color(0xFFFF6750),
                borderRadius:
                const BorderRadius.all(Radius.circular(18)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6750),
                  // Color de fondo en verde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  if (clientsScheduledController.errorHome != -99) {
                    if (loginController.codigoQrValid() == true &&
                        loginController.usserPermissionQrAntes ==
                            1) {
                      clientsScheduledControllerE
                          .setBoolFilterShowNext(false);
                      clientsScheduledControllerE
                          .setBoolControlVision(false);

                      int rest =
                      await clientsScheduledControllerE
                          .acceptOrRejectClient(
                          clientsScheduledControllerE
                              .clientsScheduledNextServ!
                              .reservation_id,
                          3,
                          loginController
                              .tokenUserLoggedIn);
                      if (rest == 1) {
                        LocalStorage.prefs
                            .setInt('valueClockIni', 180);
                        clientsScheduledController
                            .setTotalTimeInitial(180);
                        LocalStorage.prefs
                            .setBool('valueClockActiv', false);

                        clientsScheduledController
                            .animationControllerInitial!
                          ..duration = Duration(seconds: 180)
                          ..reset()
                          ..stop();
                        loginController.setCodigoQrValid(2);
                      } else {
                        loginController.setCodigoQrValid(1);
                      }
                    } else if (loginController.usserPermissionQr ==
                        2) {
                      Get.snackbar(
                        'Mensaje',
                        'Debe de esperar la respuesta a su solicitud',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                        'Debe de escanear el código Qr de entrada',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                  } else {
                    //mostrar mensaje de error de conexion
                    loginController.showConnectionError();
                    await Future.delayed(
                        Duration(milliseconds: 1000));
                    Get.snackbar(
                      'Mensaje',
                      'Vuelva a intentarlo, hubo problema de conexión.',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor:
                      const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                      const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                      const AlwaysStoppedAnimation(
                          Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                  }
                },
                child: Icon(
                  MdiIcons.thumbDownOutline,
                  color: Colors.white,
                  size: (MediaQuery.of(context).size.height * 0.04),
                ),
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
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.person,
                              color: const Color.fromARGB(
                                  255, 43, 44, 49),
                              size: 22,
                            ),
                            Text(
                              //todo 707 nombre
                              clientCord.truncateText(
                                  firstName, 13),
                              softWrap: true,
                              style: const TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            // todo 707 AQUI ESTA EL TIEMPO TOTAL DEL SERVICIO
                              (clientsScheduledControllerE
                                  .clientsScheduledNextServ!
                                  .total_time!),
                              style: const TextStyle(
                                height: 1.2,
                                fontSize: 16,
                                color: Color.fromARGB(180, 0, 0, 0),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .services!
                            .length >
                            2
                            ? 2
                            : clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .services!
                            .length,
                        // todo 707 aqui estan los servicios
                        itemBuilder: (context, index) => Row(
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      MdiIcons.viewList,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      clientsScheduledControllerE
                                          .clientsScheduledNextServ!
                                          .services![index]
                                          .name,
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height * 0.5),
              //   height: (MediaQuery.of(context).size.height * 0.115),
              width: (MediaQuery.of(context).size.width * 0.20),
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    Colors.white, // Color blanco para el borde
                    width:
                    1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                  ),
                  color: const Color(0xFF19CF9E),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(18))),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19CF9E),
                  // Color de fondo en verde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                  if (clientsScheduledController.errorHome != -99) {
                    if (loginController.codigoQrValid() == true &&
                        loginController.usserPermissionQrAntes ==
                            1 &&
                        clientsScheduledControllerE
                            .clientsScheduledNextServ !=
                            null &&
                        clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .reservation_id! >
                            0) {
                      loginController.setMakeCall(false);
                      clientsScheduledControllerE
                          .setBoolControlVision(false);
                      clientsScheduledControllerE
                          .setBoolFilterShowNext(false);
                      //aqui poner que muestre un cargando
                      clientsScheduledControllerE
                          .clientsScheduledNextServAux =
                      clientsScheduledControllerE
                          .clientsScheduledNextServ!;
                      clientsScheduledControllerE
                          .funtErrorClientAcept(true);

                      int resulButton = 0;
                      resulButton =
                          loginController.handleButtonClick(
                              clientsScheduledControllerE
                                  .clientsScheduledNextServ!
                                  .reservation_id!);
                      if (resulButton == 1) {
                        int timeClock = clientsScheduledControllerE
                            .convertTimeToSeconds(
                            clientsScheduledControllerE
                                .clientsScheduledNextServAux!
                                .total_time!);
                        int clock = clientsScheduledControllerE
                            .availability;
                        // (timeClock, clock,detached, reservationId, attended, token)
                        int aceptClient =
                        await clientsScheduledControllerE
                            .acceptClientClock(
                            clientsScheduledControllerE
                                .clientsScheduledNextServAux!,
                            timeClock,
                            //timeClock
                            clock,
                            //clock
                            1,
                            //detached
                            clientsScheduledControllerE
                                .clientsScheduledNextServ!
                                .reservation_id,
                            //reservationId
                            1,
                            //attended
                            loginController
                                .tokenUserLoggedIn); //token
                        if (aceptClient == 1) {
                          // detengo todos los timers que deben detenerse
                          for (int j = 0;
                          j <
                              clientsScheduledControllerE
                                  .itemDel.length;
                          j++) {
                            animationCont[
                            clientsScheduledControllerE
                                .itemDel[j]]!
                                .stop();
                            animationCont[
                            clientsScheduledControllerE
                                .itemDel[j]]!
                                .reset();
                          }
                          //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                          if (clientsScheduledControllerE
                              .busyClock ==
                              0) {
                            // Detenemos el controlador
                            if (animationCont[0]!.isAnimating) {
                              animationCont[0]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[0]!.reset();
                            animationCont[0]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended1!);
                            animationCont[0]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              1) {
                            if (animationCont[1]!.isAnimating) {
                              animationCont[1]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[1]!.reset();
                            animationCont[1]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended2!);
                            animationCont[1]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              2) {
                            if (animationCont[2]!.isAnimating) {
                              animationCont[2]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[2]!.reset();
                            animationCont[2]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended3!);
                            animationCont[2]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              3) {
                            if (animationCont[3]!.isAnimating) {
                              animationCont[3]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[3]!.reset();
                            animationCont[3]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended4!);
                            animationCont[3]!.forward();
                          }
                        } else {
                          //activo nuevamente que el boton para coger al cliente este disponible
                          loginController.handleButtonClickDelete(
                              clientsScheduledControllerE
                                  .clientsScheduledNextServAux!
                                  .reservation_id!);
                          //mostrar mensaje de error de
                          loginController.showConnectionError();
                          await Future.delayed(
                              Duration(milliseconds: 1500));
                          Get.snackbar(
                            'Mensaje',
                            'Vuelva a intentarlo, hubo problema de conexión..',
                            duration:
                            const Duration(milliseconds: 2500),
                            backgroundColor: const Color.fromARGB(
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
                          loginController.setMakeCall(true);
                          clientsScheduledControllerE
                              .setBoolFilterShowNext(true);
                          await _refresh();
                        }
                      }
                      loginController.setMakeCall(true);
                      // clientsScheduledControllerE
                      //     .setBoolControlVision(true);
                    } else if (loginController.usserPermissionQr ==
                        2) {
                      Get.snackbar(
                        'Mensaje',
                        'Debe de esperar la respuesta a su solicitud',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                        'Debe de escanear el código Qr de entrada',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                  } else {
                    //mostrar mensaje de error de conexion
                    loginController.showConnectionError();
                    await Future.delayed(
                        Duration(milliseconds: 1000));
                    Get.snackbar(
                      'Mensaje',
                      'Vuelva a intentarlo, hubo problema de conexión..',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor:
                      const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                      const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                      const AlwaysStoppedAnimation(
                          Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                  }
                  clientsScheduledControllerE
                      .funtErrorClientAcept(false);
                },
                child: Icon(
                  MdiIcons.thumbUpOutline,
                  color: Colors.white,
                  size: (MediaQuery.of(context).size.height * 0.04),
                ),
              ),
            ),
*/
                      // BOTTOM FOOTER
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                        child: Row(
                          children: [
                            // Botón izquierdo
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: (MediaQuery.of(context).size.height * 0.115),
                                      width: (MediaQuery.of(context).size.width * 0.20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white, // Color blanco para el borde
                                          width:
                                          1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                        ),
                                        color: Color(0xFFFF6750),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(18)),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFF6750),
                                          // Color de fondo en verde
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16.0), // Ajusta el radio según tus necesidades
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (clientsScheduledController.errorHome != -99) {
                                            if (loginController.codigoQrValid() == true &&
                                                loginController.usserPermissionQrAntes ==
                                                    1) {
                                              clientsScheduledControllerE
                                                  .setBoolFilterShowNext(false);
                                              clientsScheduledControllerE
                                                  .setBoolControlVision(false);

                                              int rest =
                                              await clientsScheduledControllerE
                                                  .acceptOrRejectClient(
                                                  clientsScheduledControllerE
                                                      .clientsScheduledNextServ!
                                                      .reservation_id,
                                                  3,
                                                  loginController
                                                      .tokenUserLoggedIn);
                                              if (rest == 1) {
                                                LocalStorage.prefs
                                                    .setInt('valueClockIni', 180);
                                                clientsScheduledController
                                                    .setTotalTimeInitial(180);
                                                LocalStorage.prefs
                                                    .setBool('valueClockActiv', false);

                                                clientsScheduledController
                                                    .animationControllerInitial!
                                                  ..duration = Duration(seconds: 180)
                                                  ..reset()
                                                  ..stop();
                                                loginController.setCodigoQrValid(2);
                                              } else {
                                                loginController.setCodigoQrValid(1);
                                              }
                                            } else if (loginController.usserPermissionQr ==
                                                2) {
                                              Get.snackbar(
                                                'Mensaje',
                                                'Debe de esperar la respuesta a su solicitud',
                                                duration:
                                                const Duration(milliseconds: 2500),
                                                backgroundColor: const Color.fromARGB(
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
                                                'Debe de escanear el código Qr de entrada',
                                                duration:
                                                const Duration(milliseconds: 2500),
                                                backgroundColor: const Color.fromARGB(
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
                                          } else {
                                            //mostrar mensaje de error de conexion
                                            loginController.showConnectionError();
                                            await Future.delayed(
                                                Duration(milliseconds: 1000));
                                            Get.snackbar(
                                              'Mensaje',
                                              'Vuelva a intentarlo, hubo problema de conexión.',
                                              duration: const Duration(milliseconds: 2500),
                                              backgroundColor:
                                              const Color.fromARGB(118, 255, 255, 255),
                                              showProgressIndicator: true,
                                              progressIndicatorBackgroundColor:
                                              const Color.fromARGB(255, 203, 205, 209),
                                              progressIndicatorValueColor:
                                              const AlwaysStoppedAnimation(
                                                  Color(0xFFFDAE2A)),
                                              overlayBlur: 3,
                                            );
                                          }
                                        },
                                        child: Icon(
                                          MdiIcons.thumbDownOutline,
                                          color: Colors.white,
                                          size: (MediaQuery.of(context).size.height * 0.04),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    //todo 708
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${truncateText(
                                              firstName, 10)}   ${clientsScheduledControllerE
                                              .clientsScheduledNextServ!
                                              .total_time!}",

                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        ...List.generate(
                                          (clientsScheduledControllerE.clientsScheduledNextServ!.services!.length > 2)
                                              ? 2
                                              : clientsScheduledControllerE.clientsScheduledNextServ!.services!.length,
                                              (index) {
                                            final service = clientsScheduledControllerE
                                                .clientsScheduledNextServ!.services![index];
                                            return Text(
                                              service.name,


                                            );
                                          },
                                        ),
                                      ],
                                    ),

                                    Spacer(),

                                    // Botón derecho
                                    Container(
                                      height: (MediaQuery.of(context).size.height *  0.115),
                                      //   height: (MediaQuery.of(context).size.height * 0.115),
                                      width: (MediaQuery.of(context).size.width * 0.20),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                            Colors.white, // Color blanco para el borde
                                            width:
                                            1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                          ),
                                          color: const Color(0xFF19CF9E),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(18))),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF19CF9E),
                                          // Color de fondo en verde
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16.0), // Ajusta el radio según tus necesidades
                                          ),
                                        ),
                                        onPressed: () async {
                                          //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                                          if (clientsScheduledController.errorHome != -99) {
                                            if (loginController.codigoQrValid() == true &&
                                                loginController.usserPermissionQrAntes ==
                                                    1 &&
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServ !=
                                                    null &&
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServ!
                                                    .reservation_id! >
                                                    0) {
                                              loginController.setMakeCall(false);
                                              clientsScheduledControllerE
                                                  .setBoolControlVision(false);
                                              clientsScheduledControllerE
                                                  .setBoolFilterShowNext(false);
                                              //aqui poner que muestre un cargando
                                              clientsScheduledControllerE
                                                  .clientsScheduledNextServAux =
                                              clientsScheduledControllerE
                                                  .clientsScheduledNextServ!;
                                              clientsScheduledControllerE
                                                  .funtErrorClientAcept(true);

                                              int resulButton = 0;
                                              resulButton =
                                                  loginController.handleButtonClick(
                                                      clientsScheduledControllerE
                                                          .clientsScheduledNextServ!
                                                          .reservation_id!);
                                              if (resulButton == 1) {
                                                int timeClock = clientsScheduledControllerE
                                                    .convertTimeToSeconds(
                                                    clientsScheduledControllerE
                                                        .clientsScheduledNextServAux!
                                                        .total_time!);
                                                int clock = clientsScheduledControllerE
                                                    .availability;
                                                // (timeClock, clock,detached, reservationId, attended, token)
                                                int aceptClient =
                                                await clientsScheduledControllerE
                                                    .acceptClientClock(
                                                    clientsScheduledControllerE
                                                        .clientsScheduledNextServAux!,
                                                    timeClock,
                                                    //timeClock
                                                    clock,
                                                    //clock
                                                    1,
                                                    //detached
                                                    clientsScheduledControllerE
                                                        .clientsScheduledNextServ!
                                                        .reservation_id,
                                                    //reservationId
                                                    1,
                                                    //attended
                                                    loginController
                                                        .tokenUserLoggedIn); //token
                                                if (aceptClient == 1) {
                                                  // detengo todos los timers que deben detenerse
                                                  for (int j = 0;
                                                  j <
                                                      clientsScheduledControllerE
                                                          .itemDel.length;
                                                  j++) {
                                                    animationCont[
                                                    clientsScheduledControllerE
                                                        .itemDel[j]]!
                                                        .stop();
                                                    animationCont[
                                                    clientsScheduledControllerE
                                                        .itemDel[j]]!
                                                        .reset();
                                                  }
                                                  //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                                                  if (clientsScheduledControllerE
                                                      .busyClock ==
                                                      0) {
                                                    // Detenemos el controlador
                                                    if (animationCont[0]!.isAnimating) {
                                                      animationCont[0]!.stop();
                                                    }

// Reseteamos el controlador a su estado inicial
                                                    animationCont[0]!.reset();
                                                    animationCont[0]!.duration = Duration(
                                                        seconds: clientsScheduledControllerE
                                                            .timeClientsAttended1!);
                                                    animationCont[0]!.forward();
                                                  } else if (clientsScheduledControllerE
                                                      .busyClock ==
                                                      1) {
                                                    if (animationCont[1]!.isAnimating) {
                                                      animationCont[1]!.stop();
                                                    }

// Reseteamos el controlador a su estado inicial
                                                    animationCont[1]!.reset();
                                                    animationCont[1]!.duration = Duration(
                                                        seconds: clientsScheduledControllerE
                                                            .timeClientsAttended2!);
                                                    animationCont[1]!.forward();
                                                  } else if (clientsScheduledControllerE
                                                      .busyClock ==
                                                      2) {
                                                    if (animationCont[2]!.isAnimating) {
                                                      animationCont[2]!.stop();
                                                    }

// Reseteamos el controlador a su estado inicial
                                                    animationCont[2]!.reset();
                                                    animationCont[2]!.duration = Duration(
                                                        seconds: clientsScheduledControllerE
                                                            .timeClientsAttended3!);
                                                    animationCont[2]!.forward();
                                                  } else if (clientsScheduledControllerE
                                                      .busyClock ==
                                                      3) {
                                                    if (animationCont[3]!.isAnimating) {
                                                      animationCont[3]!.stop();
                                                    }

// Reseteamos el controlador a su estado inicial
                                                    animationCont[3]!.reset();
                                                    animationCont[3]!.duration = Duration(
                                                        seconds: clientsScheduledControllerE
                                                            .timeClientsAttended4!);
                                                    animationCont[3]!.forward();
                                                  }
                                                } else {
                                                  //activo nuevamente que el boton para coger al cliente este disponible
                                                  loginController.handleButtonClickDelete(
                                                      clientsScheduledControllerE
                                                          .clientsScheduledNextServAux!
                                                          .reservation_id!);
                                                  //mostrar mensaje de error de
                                                  loginController.showConnectionError();
                                                  await Future.delayed(
                                                      Duration(milliseconds: 1500));
                                                  Get.snackbar(
                                                    'Mensaje',
                                                    'Vuelva a intentarlo, hubo problema de conexión..',
                                                    duration:
                                                    const Duration(milliseconds: 2500),
                                                    backgroundColor: const Color.fromARGB(
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
                                                  loginController.setMakeCall(true);
                                                  clientsScheduledControllerE
                                                      .setBoolFilterShowNext(true);
                                                  await _refresh();
                                                }
                                              }
                                              loginController.setMakeCall(true);
                                              // clientsScheduledControllerE
                                              //     .setBoolControlVision(true);
                                            } else if (loginController.usserPermissionQr ==
                                                2) {
                                              Get.snackbar(
                                                'Mensaje',
                                                'Debe de esperar la respuesta a su solicitud',
                                                duration:
                                                const Duration(milliseconds: 2500),
                                                backgroundColor: const Color.fromARGB(
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
                                                'Debe de escanear el código Qr de entrada',
                                                duration:
                                                const Duration(milliseconds: 2500),
                                                backgroundColor: const Color.fromARGB(
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
                                          } else {
                                            //mostrar mensaje de error de conexion
                                            loginController.showConnectionError();
                                            await Future.delayed(
                                                Duration(milliseconds: 1000));
                                            Get.snackbar(
                                              'Mensaje',
                                              'Vuelva a intentarlo, hubo problema de conexión..',
                                              duration: const Duration(milliseconds: 2500),
                                              backgroundColor:
                                              const Color.fromARGB(118, 255, 255, 255),
                                              showProgressIndicator: true,
                                              progressIndicatorBackgroundColor:
                                              const Color.fromARGB(255, 203, 205, 209),
                                              progressIndicatorValueColor:
                                              const AlwaysStoppedAnimation(
                                                  Color(0xFFFDAE2A)),
                                              overlayBlur: 3,
                                            );
                                          }
                                          clientsScheduledControllerE
                                              .funtErrorClientAcept(false);
                                        },
                                        child: Icon(
                                          MdiIcons.thumbUpOutline,
                                          color: Colors.white,
                                          size: (MediaQuery.of(context).size.height * 0.04),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      )
                    ],
                  ),
                )
                    : (clientsScheduledController.clientsScheSalon == 0) &&
                    clientsScheduledControllerE.clientsScheduledNextServ ==
                        null
                    ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text('No hay clientes en cola',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color.fromARGB(255, 82, 81, 81),
                        )),
                  ),
                )
                    : loginController.usserPermissionQr == 2
                    ? const Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'Debe de esperar la respuesta',
                        style: TextStyle(
                          // color: Colors.white,
                            color: Color.fromARGB(255, 39, 39, 39),
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'a su solicitud',
                        style: TextStyle(
                          //color: Colors.white,
                            color: Color.fromARGB(255, 39, 39, 39),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                    ],
                  ),
                )
                    : SizedBox(width: 100, height: 100, child: Text(''))),
          );
        }





      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Row(
          children: [
            Stack(children: [
              Container(
                child: CircleAvatar(
                  backgroundColor:
                  Colors.white, //fondo de la imagen
                  radius: 44,
                  child:
                  //
                  GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageDetailScreen(
                                  imageUrl:
                                  '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient'),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                        '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                        placeholder: (context, url) =>
                            Container(
                              width: 30,
                              height: 30,
                              child: const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth:
                                    2, // Personaliza el ancho del indicador como desees
                                    valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(
                                        Color.fromARGB(110,
                                            253, 176, 42)),
                                  ),
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) =>
                            Image.asset(
                              'assets/images/default_profile.jpg',
                              cacheWidth: 30,
                              cacheHeight: 30,
                              fit: BoxFit.cover,
                            ),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                //
              ),
              Positioned(
                top: 58,
                right: 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(5),
                      color: const Color(0xFFFDAE2A)
                    // Puedes agregar otras propiedades de estilo aquí si es necesario
                  ),
                  width: 82,
                  height: 20,
                  child: Center(
                    child: Text(
                      ' ${frecuenciaBarber1}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ]),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(firstName!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text("Visitas: " + cantVisitBarber1!,
                    style: const TextStyle(
                        fontSize: 12)),

              ],
            ),

            const SizedBox(width: 20),

            Stack(children: [
              Container(
                child: CircleAvatar(
                  backgroundColor:
                  Colors.white, //fondo de la imagen
                  radius: 24,
                  child:
                  //
                  GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageDetailScreen(
                                  imageUrl:
                                  '${dotenv.env['API_ENDPOINT']}/images/$urlImageBarber'),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                        '${dotenv.env['API_ENDPOINT']}/images/$urlImageBarber',
                        placeholder: (context, url) =>
                            Container(
                              width: 30,
                              height: 30,
                              child: const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth:
                                    2, // Personaliza el ancho del indicador como desees
                                    valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(
                                        Color.fromARGB(110,
                                            253, 176, 42)),
                                  ),
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) =>
                            Image.asset(
                              'assets/images/default_profile.jpg',
                              cacheWidth: 30,
                              cacheHeight: 30,
                              fit: BoxFit.cover,
                            ),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
                //
              ),

            ]),

            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Último Barbero",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text("Hola"!,
                    style: const TextStyle(
                        fontSize: 12)),

              ],
            ),        ],
        ),
      );



      return Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: FittedBox(
            fit: BoxFit.contain,
            child: clientsScheduledControllerE.clientsScheduledNextServ !=
                        null &&
                    clientsScheduledControllerE.getWaitTime() == false
                //  ||
                //         LocalStorage.prefs.getBool('valueClockActiv') == false
                ? Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Cliente
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60, // Ajusta a tu necesidad
                                height: 60,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                        '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8, // mueve hacia abajo para que no lo tape el avatar

                                      left: -6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          frecuenciaBarber1!,
                                          style: const TextStyle(fontSize: 9, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(firstName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text("Visitas: $cantVisitBarber1", style: const TextStyle(fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Barbero
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                '${dotenv.env['API_ENDPOINT']}/images/$urlImageBarber',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(UltimateBarber1!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const Text("Último Profesional", style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),



                  // FOTOS
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child:    Align(
                        alignment:
                        Alignment
                            .topLeft,
                        child: Row(
                          mainAxisSize:
                          MainAxisSize
                              .min,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .center,
                          children: [

                            Column(
                              children: [
                                GestureDetector(
                                  onTap:
                                      () {
                                    showZoomableImage(context,
                                        '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient');
                                  },
                                  child:
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    child:
                                    CachedNetworkImage(
                                      imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                      placeholder: (context, url) => Container(
                                        width: 130,
                                        height: 130,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Color.fromARGB(110, 253, 176, 42),
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        'assets/images/default_profile.jpg',
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                      width: 160,
                                      height: 130,
                                    ),
                                  ),
                                ),
                                const Align(
                                    alignment:
                                    Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Último look',
                                        style: TextStyle(fontSize: 12, height: 1.3, color: Color(0xFFFDAE2A), fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),

                            const SizedBox(
                              width: 20,
                            ),
                            Transform
                                .scale(
                              scale:
                              1.0,
                              child:
                              cardTimer2(
                                UniqueKey(),
                                'Esperando',
                                clientsScheduledController,
                                clientsScheduledController
                                    .animationControllerInitial!,
                              ),
                            ),

                          ],
                        ),
                      )
                  ),

                  const SizedBox(height: 16),

                  // HISTORIAL
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.history, color: Colors.black),
                            SizedBox(width: 8),
                            Text("Historial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Servicios", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Cantidad", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Corte de Cabello"),
                            Text("2"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Cejas"),
                            Text("3"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
/*
            Container(
              height: (MediaQuery.of(context).size.height * 0.115),
              width: (MediaQuery.of(context).size.width * 0.20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Color blanco para el borde
                  width:
                  1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                ),
                color: Color(0xFFFF6750),
                borderRadius:
                const BorderRadius.all(Radius.circular(18)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6750),
                  // Color de fondo en verde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  if (clientsScheduledController.errorHome != -99) {
                    if (loginController.codigoQrValid() == true &&
                        loginController.usserPermissionQrAntes ==
                            1) {
                      clientsScheduledControllerE
                          .setBoolFilterShowNext(false);
                      clientsScheduledControllerE
                          .setBoolControlVision(false);

                      int rest =
                      await clientsScheduledControllerE
                          .acceptOrRejectClient(
                          clientsScheduledControllerE
                              .clientsScheduledNextServ!
                              .reservation_id,
                          3,
                          loginController
                              .tokenUserLoggedIn);
                      if (rest == 1) {
                        LocalStorage.prefs
                            .setInt('valueClockIni', 180);
                        clientsScheduledController
                            .setTotalTimeInitial(180);
                        LocalStorage.prefs
                            .setBool('valueClockActiv', false);

                        clientsScheduledController
                            .animationControllerInitial!
                          ..duration = Duration(seconds: 180)
                          ..reset()
                          ..stop();
                        loginController.setCodigoQrValid(2);
                      } else {
                        loginController.setCodigoQrValid(1);
                      }
                    } else if (loginController.usserPermissionQr ==
                        2) {
                      Get.snackbar(
                        'Mensaje',
                        'Debe de esperar la respuesta a su solicitud',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                        'Debe de escanear el código Qr de entrada',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                  } else {
                    //mostrar mensaje de error de conexion
                    loginController.showConnectionError();
                    await Future.delayed(
                        Duration(milliseconds: 1000));
                    Get.snackbar(
                      'Mensaje',
                      'Vuelva a intentarlo, hubo problema de conexión.',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor:
                      const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                      const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                      const AlwaysStoppedAnimation(
                          Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                  }
                },
                child: Icon(
                  MdiIcons.thumbDownOutline,
                  color: Colors.white,
                  size: (MediaQuery.of(context).size.height * 0.04),
                ),
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
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.person,
                              color: const Color.fromARGB(
                                  255, 43, 44, 49),
                              size: 22,
                            ),
                            Text(
                              //todo 707 nombre
                              clientCord.truncateText(
                                  firstName, 13),
                              softWrap: true,
                              style: const TextStyle(
                                  height: 1.0,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            // todo 707 AQUI ESTA EL TIEMPO TOTAL DEL SERVICIO
                              (clientsScheduledControllerE
                                  .clientsScheduledNextServ!
                                  .total_time!),
                              style: const TextStyle(
                                height: 1.2,
                                fontSize: 16,
                                color: Color.fromARGB(180, 0, 0, 0),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .services!
                            .length >
                            2
                            ? 2
                            : clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .services!
                            .length,
                        // todo 707 aqui estan los servicios
                        itemBuilder: (context, index) => Row(
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      MdiIcons.viewList,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      clientsScheduledControllerE
                                          .clientsScheduledNextServ!
                                          .services![index]
                                          .name,
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height * 0.5),
              //   height: (MediaQuery.of(context).size.height * 0.115),
              width: (MediaQuery.of(context).size.width * 0.20),
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    Colors.white, // Color blanco para el borde
                    width:
                    1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                  ),
                  color: const Color(0xFF19CF9E),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(18))),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19CF9E),
                  // Color de fondo en verde
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16.0), // Ajusta el radio según tus necesidades
                  ),
                ),
                onPressed: () async {
                  //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                  if (clientsScheduledController.errorHome != -99) {
                    if (loginController.codigoQrValid() == true &&
                        loginController.usserPermissionQrAntes ==
                            1 &&
                        clientsScheduledControllerE
                            .clientsScheduledNextServ !=
                            null &&
                        clientsScheduledControllerE
                            .clientsScheduledNextServ!
                            .reservation_id! >
                            0) {
                      loginController.setMakeCall(false);
                      clientsScheduledControllerE
                          .setBoolControlVision(false);
                      clientsScheduledControllerE
                          .setBoolFilterShowNext(false);
                      //aqui poner que muestre un cargando
                      clientsScheduledControllerE
                          .clientsScheduledNextServAux =
                      clientsScheduledControllerE
                          .clientsScheduledNextServ!;
                      clientsScheduledControllerE
                          .funtErrorClientAcept(true);

                      int resulButton = 0;
                      resulButton =
                          loginController.handleButtonClick(
                              clientsScheduledControllerE
                                  .clientsScheduledNextServ!
                                  .reservation_id!);
                      if (resulButton == 1) {
                        int timeClock = clientsScheduledControllerE
                            .convertTimeToSeconds(
                            clientsScheduledControllerE
                                .clientsScheduledNextServAux!
                                .total_time!);
                        int clock = clientsScheduledControllerE
                            .availability;
                        // (timeClock, clock,detached, reservationId, attended, token)
                        int aceptClient =
                        await clientsScheduledControllerE
                            .acceptClientClock(
                            clientsScheduledControllerE
                                .clientsScheduledNextServAux!,
                            timeClock,
                            //timeClock
                            clock,
                            //clock
                            1,
                            //detached
                            clientsScheduledControllerE
                                .clientsScheduledNextServ!
                                .reservation_id,
                            //reservationId
                            1,
                            //attended
                            loginController
                                .tokenUserLoggedIn); //token
                        if (aceptClient == 1) {
                          // detengo todos los timers que deben detenerse
                          for (int j = 0;
                          j <
                              clientsScheduledControllerE
                                  .itemDel.length;
                          j++) {
                            animationCont[
                            clientsScheduledControllerE
                                .itemDel[j]]!
                                .stop();
                            animationCont[
                            clientsScheduledControllerE
                                .itemDel[j]]!
                                .reset();
                          }
                          //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                          if (clientsScheduledControllerE
                              .busyClock ==
                              0) {
                            // Detenemos el controlador
                            if (animationCont[0]!.isAnimating) {
                              animationCont[0]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[0]!.reset();
                            animationCont[0]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended1!);
                            animationCont[0]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              1) {
                            if (animationCont[1]!.isAnimating) {
                              animationCont[1]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[1]!.reset();
                            animationCont[1]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended2!);
                            animationCont[1]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              2) {
                            if (animationCont[2]!.isAnimating) {
                              animationCont[2]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[2]!.reset();
                            animationCont[2]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended3!);
                            animationCont[2]!.forward();
                          } else if (clientsScheduledControllerE
                              .busyClock ==
                              3) {
                            if (animationCont[3]!.isAnimating) {
                              animationCont[3]!.stop();
                            }

// Reseteamos el controlador a su estado inicial
                            animationCont[3]!.reset();
                            animationCont[3]!.duration = Duration(
                                seconds: clientsScheduledControllerE
                                    .timeClientsAttended4!);
                            animationCont[3]!.forward();
                          }
                        } else {
                          //activo nuevamente que el boton para coger al cliente este disponible
                          loginController.handleButtonClickDelete(
                              clientsScheduledControllerE
                                  .clientsScheduledNextServAux!
                                  .reservation_id!);
                          //mostrar mensaje de error de
                          loginController.showConnectionError();
                          await Future.delayed(
                              Duration(milliseconds: 1500));
                          Get.snackbar(
                            'Mensaje',
                            'Vuelva a intentarlo, hubo problema de conexión..',
                            duration:
                            const Duration(milliseconds: 2500),
                            backgroundColor: const Color.fromARGB(
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
                          loginController.setMakeCall(true);
                          clientsScheduledControllerE
                              .setBoolFilterShowNext(true);
                          await _refresh();
                        }
                      }
                      loginController.setMakeCall(true);
                      // clientsScheduledControllerE
                      //     .setBoolControlVision(true);
                    } else if (loginController.usserPermissionQr ==
                        2) {
                      Get.snackbar(
                        'Mensaje',
                        'Debe de esperar la respuesta a su solicitud',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                        'Debe de escanear el código Qr de entrada',
                        duration:
                        const Duration(milliseconds: 2500),
                        backgroundColor: const Color.fromARGB(
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
                  } else {
                    //mostrar mensaje de error de conexion
                    loginController.showConnectionError();
                    await Future.delayed(
                        Duration(milliseconds: 1000));
                    Get.snackbar(
                      'Mensaje',
                      'Vuelva a intentarlo, hubo problema de conexión..',
                      duration: const Duration(milliseconds: 2500),
                      backgroundColor:
                      const Color.fromARGB(118, 255, 255, 255),
                      showProgressIndicator: true,
                      progressIndicatorBackgroundColor:
                      const Color.fromARGB(255, 203, 205, 209),
                      progressIndicatorValueColor:
                      const AlwaysStoppedAnimation(
                          Color(0xFFFDAE2A)),
                      overlayBlur: 3,
                    );
                  }
                  clientsScheduledControllerE
                      .funtErrorClientAcept(false);
                },
                child: Icon(
                  MdiIcons.thumbUpOutline,
                  color: Colors.white,
                  size: (MediaQuery.of(context).size.height * 0.04),
                ),
              ),
            ),
*/
                  // BOTTOM FOOTER
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    child: Row(
                      children: [
                        // Botón izquierdo
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: (MediaQuery.of(context).size.height * 0.115),
                                  width: (MediaQuery.of(context).size.width * 0.20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white, // Color blanco para el borde
                                      width:
                                      1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                    ),
                                    color: Color(0xFFFF6750),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(18)),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF6750),
                                      // Color de fondo en verde
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            16.0), // Ajusta el radio según tus necesidades
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (clientsScheduledController.errorHome != -99) {
                                        if (loginController.codigoQrValid() == true &&
                                            loginController.usserPermissionQrAntes ==
                                                1) {
                                          clientsScheduledControllerE
                                              .setBoolFilterShowNext(false);
                                          clientsScheduledControllerE
                                              .setBoolControlVision(false);

                                          int rest =
                                          await clientsScheduledControllerE
                                              .acceptOrRejectClient(
                                              clientsScheduledControllerE
                                                  .clientsScheduledNextServ!
                                                  .reservation_id,
                                              3,
                                              loginController
                                                  .tokenUserLoggedIn);
                                          if (rest == 1) {
                                            LocalStorage.prefs
                                                .setInt('valueClockIni', 180);
                                            clientsScheduledController
                                                .setTotalTimeInitial(180);
                                            LocalStorage.prefs
                                                .setBool('valueClockActiv', false);

                                            clientsScheduledController
                                                .animationControllerInitial!
                                              ..duration = Duration(seconds: 180)
                                              ..reset()
                                              ..stop();
                                            loginController.setCodigoQrValid(2);
                                          } else {
                                            loginController.setCodigoQrValid(1);
                                          }
                                        } else if (loginController.usserPermissionQr ==
                                            2) {
                                          Get.snackbar(
                                            'Mensaje',
                                            'Debe de esperar la respuesta a su solicitud',
                                            duration:
                                            const Duration(milliseconds: 2500),
                                            backgroundColor: const Color.fromARGB(
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
                                            'Debe de escanear el código Qr de entrada',
                                            duration:
                                            const Duration(milliseconds: 2500),
                                            backgroundColor: const Color.fromARGB(
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
                                      } else {
                                        //mostrar mensaje de error de conexion
                                        loginController.showConnectionError();
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        Get.snackbar(
                                          'Mensaje',
                                          'Vuelva a intentarlo, hubo problema de conexión.',
                                          duration: const Duration(milliseconds: 2500),
                                          backgroundColor:
                                          const Color.fromARGB(118, 255, 255, 255),
                                          showProgressIndicator: true,
                                          progressIndicatorBackgroundColor:
                                          const Color.fromARGB(255, 203, 205, 209),
                                          progressIndicatorValueColor:
                                          const AlwaysStoppedAnimation(
                                              Color(0xFFFDAE2A)),
                                          overlayBlur: 3,
                                        );
                                      }
                                    },
                                    child: Icon(
                                      MdiIcons.thumbDownOutline,
                                      color: Colors.white,
                                      size: (MediaQuery.of(context).size.height * 0.04),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                //todo 708
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${truncateText(
                                          firstName, 10)}   ${clientsScheduledControllerE
                                          .clientsScheduledNextServ!
                                          .total_time!}",

                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    ...List.generate(
                                      (clientsScheduledControllerE.clientsScheduledNextServ!.services!.length > 2)
                                          ? 2
                                          : clientsScheduledControllerE.clientsScheduledNextServ!.services!.length,
                                          (index) {
                                        final service = clientsScheduledControllerE
                                            .clientsScheduledNextServ!.services![index];
                                        return Text(
                                          service.name,


                                        );
                                      },
                                    ),
                                  ],
                                ),

                                Spacer(),

                                // Botón derecho
                                Container(
                                  height: (MediaQuery.of(context).size.height *  0.115),
                                  //   height: (MediaQuery.of(context).size.height * 0.115),
                                  width: (MediaQuery.of(context).size.width * 0.20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                        Colors.white, // Color blanco para el borde
                                        width:
                                        1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
                                      ),
                                      color: const Color(0xFF19CF9E),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(18))),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF19CF9E),
                                      // Color de fondo en verde
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            16.0), // Ajusta el radio según tus necesidades
                                      ),
                                    ),
                                    onPressed: () async {
                                      //AQUI VEO SI YA ESCANEO EL CODIGO QR Y ESTA EN EL LOCAL
                                      if (clientsScheduledController.errorHome != -99) {
                                        if (loginController.codigoQrValid() == true &&
                                            loginController.usserPermissionQrAntes ==
                                                1 &&
                                            clientsScheduledControllerE
                                                .clientsScheduledNextServ !=
                                                null &&
                                            clientsScheduledControllerE
                                                .clientsScheduledNextServ!
                                                .reservation_id! >
                                                0) {
                                          loginController.setMakeCall(false);
                                          clientsScheduledControllerE
                                              .setBoolControlVision(false);
                                          clientsScheduledControllerE
                                              .setBoolFilterShowNext(false);
                                          //aqui poner que muestre un cargando
                                          clientsScheduledControllerE
                                              .clientsScheduledNextServAux =
                                          clientsScheduledControllerE
                                              .clientsScheduledNextServ!;
                                          clientsScheduledControllerE
                                              .funtErrorClientAcept(true);

                                          int resulButton = 0;
                                          resulButton =
                                              loginController.handleButtonClick(
                                                  clientsScheduledControllerE
                                                      .clientsScheduledNextServ!
                                                      .reservation_id!);
                                          if (resulButton == 1) {
                                            int timeClock = clientsScheduledControllerE
                                                .convertTimeToSeconds(
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServAux!
                                                    .total_time!);
                                            int clock = clientsScheduledControllerE
                                                .availability;
                                            // (timeClock, clock,detached, reservationId, attended, token)
                                            int aceptClient =
                                            await clientsScheduledControllerE
                                                .acceptClientClock(
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServAux!,
                                                timeClock,
                                                //timeClock
                                                clock,
                                                //clock
                                                1,
                                                //detached
                                                clientsScheduledControllerE
                                                    .clientsScheduledNextServ!
                                                    .reservation_id,
                                                //reservationId
                                                1,
                                                //attended
                                                loginController
                                                    .tokenUserLoggedIn); //token
                                            if (aceptClient == 1) {
                                              // detengo todos los timers que deben detenerse
                                              for (int j = 0;
                                              j <
                                                  clientsScheduledControllerE
                                                      .itemDel.length;
                                              j++) {
                                                animationCont[
                                                clientsScheduledControllerE
                                                    .itemDel[j]]!
                                                    .stop();
                                                animationCont[
                                                clientsScheduledControllerE
                                                    .itemDel[j]]!
                                                    .reset();
                                              }
                                              //HACE LAS VERIFICACIONES NECESARIAS PARA ACTIVAR LOS RELOJES QUE NECESITEN SER ACTIVADOS
                                              if (clientsScheduledControllerE
                                                  .busyClock ==
                                                  0) {
                                                // Detenemos el controlador
                                                if (animationCont[0]!.isAnimating) {
                                                  animationCont[0]!.stop();
                                                }

// Reseteamos el controlador a su estado inicial
                                                animationCont[0]!.reset();
                                                animationCont[0]!.duration = Duration(
                                                    seconds: clientsScheduledControllerE
                                                        .timeClientsAttended1!);
                                                animationCont[0]!.forward();
                                              } else if (clientsScheduledControllerE
                                                  .busyClock ==
                                                  1) {
                                                if (animationCont[1]!.isAnimating) {
                                                  animationCont[1]!.stop();
                                                }

// Reseteamos el controlador a su estado inicial
                                                animationCont[1]!.reset();
                                                animationCont[1]!.duration = Duration(
                                                    seconds: clientsScheduledControllerE
                                                        .timeClientsAttended2!);
                                                animationCont[1]!.forward();
                                              } else if (clientsScheduledControllerE
                                                  .busyClock ==
                                                  2) {
                                                if (animationCont[2]!.isAnimating) {
                                                  animationCont[2]!.stop();
                                                }

// Reseteamos el controlador a su estado inicial
                                                animationCont[2]!.reset();
                                                animationCont[2]!.duration = Duration(
                                                    seconds: clientsScheduledControllerE
                                                        .timeClientsAttended3!);
                                                animationCont[2]!.forward();
                                              } else if (clientsScheduledControllerE
                                                  .busyClock ==
                                                  3) {
                                                if (animationCont[3]!.isAnimating) {
                                                  animationCont[3]!.stop();
                                                }

// Reseteamos el controlador a su estado inicial
                                                animationCont[3]!.reset();
                                                animationCont[3]!.duration = Duration(
                                                    seconds: clientsScheduledControllerE
                                                        .timeClientsAttended4!);
                                                animationCont[3]!.forward();
                                              }
                                            } else {
                                              //activo nuevamente que el boton para coger al cliente este disponible
                                              loginController.handleButtonClickDelete(
                                                  clientsScheduledControllerE
                                                      .clientsScheduledNextServAux!
                                                      .reservation_id!);
                                              //mostrar mensaje de error de
                                              loginController.showConnectionError();
                                              await Future.delayed(
                                                  Duration(milliseconds: 1500));
                                              Get.snackbar(
                                                'Mensaje',
                                                'Vuelva a intentarlo, hubo problema de conexión..',
                                                duration:
                                                const Duration(milliseconds: 2500),
                                                backgroundColor: const Color.fromARGB(
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
                                              loginController.setMakeCall(true);
                                              clientsScheduledControllerE
                                                  .setBoolFilterShowNext(true);
                                              await _refresh();
                                            }
                                          }
                                          loginController.setMakeCall(true);
                                          // clientsScheduledControllerE
                                          //     .setBoolControlVision(true);
                                        } else if (loginController.usserPermissionQr ==
                                            2) {
                                          Get.snackbar(
                                            'Mensaje',
                                            'Debe de esperar la respuesta a su solicitud',
                                            duration:
                                            const Duration(milliseconds: 2500),
                                            backgroundColor: const Color.fromARGB(
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
                                            'Debe de escanear el código Qr de entrada',
                                            duration:
                                            const Duration(milliseconds: 2500),
                                            backgroundColor: const Color.fromARGB(
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
                                      } else {
                                        //mostrar mensaje de error de conexion
                                        loginController.showConnectionError();
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        Get.snackbar(
                                          'Mensaje',
                                          'Vuelva a intentarlo, hubo problema de conexión..',
                                          duration: const Duration(milliseconds: 2500),
                                          backgroundColor:
                                          const Color.fromARGB(118, 255, 255, 255),
                                          showProgressIndicator: true,
                                          progressIndicatorBackgroundColor:
                                          const Color.fromARGB(255, 203, 205, 209),
                                          progressIndicatorValueColor:
                                          const AlwaysStoppedAnimation(
                                              Color(0xFFFDAE2A)),
                                          overlayBlur: 3,
                                        );
                                      }
                                      clientsScheduledControllerE
                                          .funtErrorClientAcept(false);
                                    },
                                    child: Icon(
                                      MdiIcons.thumbUpOutline,
                                      color: Colors.white,
                                      size: (MediaQuery.of(context).size.height * 0.04),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  )
                ],
              ),
            )
                : (clientsScheduledController.clientsScheSalon == 0) &&
                        clientsScheduledControllerE.clientsScheduledNextServ ==
                            null
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text('707No hay clientes en cola',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color.fromARGB(255, 82, 81, 81),
                              )),
                        ),
                      )
                    : loginController.usserPermissionQr == 2
                        ? const Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  'Debe de esperar la respuesta',
                                  style: TextStyle(
                                      // color: Colors.white,
                                      color: Color.fromARGB(255, 39, 39, 39),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'a su solicitud',
                                  style: TextStyle(
                                      //color: Colors.white,
                                      color: Color.fromARGB(255, 39, 39, 39),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(width: 100, height: 100, child: Text(''))),
      );
    });
  }

  //todo9
  cardTimer(

    int idreservation,
    int index,
    int attend,
    int carrId,
    String imag,
    Key uniqueKey,
    String name,
    String? urlImageClient,
    String? urlImageBarber,
    String? frecuencia,
    String? cantVisitBarber1,
    String? UltimateBarber1,
    ClientsScheduledController clientsScheduledController,
    AnimationController _animationController,
  ) {
    print("clientsScheduledController102 CarID");
    print(carrId);
    print("clientsScheduledController102 CarID");
    print(clientsScheduledController.clientsScheduledList[0]);

    final match = clientsScheduledController.clientsScheduledList.firstWhere(
          (c) => c.car_id == carrId
    );
    print("clientsScheduledController102");

    final match_services = match.history_service ?? [];
    urlImageClient =imag;

    urlImageBarber = match.url_image_barber;
    frecuencia=match.frecuencia;



    if (attend == 4 || attend == 5) //esta con el tecnico
    {
      // aqui parar el reloj
    }
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    String secondName = partsName.length > 1 ? partsName[1] : "";
    int hoursN = 0;
    int minutesN = 0;
    String formattedMinutes = '00';

    return InkWell(
      onTap: () async {
        // Comprobar si la animación está en pausa

        if (clientsScheduledController.errorHome != -99) {
          bool isPaused = _animationController.isAnimating;
          // Comprobar si la animación ha completado su duración
          bool isCompleted = _animationController.isCompleted;
          print('este relojo esta en:$isPaused');

          // if (isPaused == true || isCompleted == true) {
          if (isPaused == true || isCompleted) {
            //aqui llamar un metodo que me diga que attend es, y verificar
            //VA A EJECUTARSE SI NO ESTA CON EL TECNICO
            int resulButton = 0;
            resulButton = loginController.handleButtonClickModal(idreservation);
            if (resulButton == 1) {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFDAE2A),
                  ),
                ),
                barrierDismissible: false,
              );
              //limpio la lista que controla que se de un solo click al seleccionar los servicios
              loginController.inTheClock(true);
              loginController.handleButtonClickServiceClear();
              serviceControll.clearSelectService();
              serviceControll.clearSelectServiceNew();
              chopCont.idServiceCart.clear();
              chopCont.requestDeleteOrder.clear();

              if (isPaused == true || isCompleted == true) {
                //aqui si el reloj esta detenido es que esta con el tecnico
                // aqui selecciono el cliente
                await clientsScheduledController.metodsClients(
                    index, carrId, idreservation, name, imag);
                print('ya páse por aqui-1');
                //todo FIN esto estaba en la pagina del modal al dar en Ver carrito

                //aqui devuelve en category_branch las categorias
                //aqui devuelve en category_products los productos por categorias
                await controllerProduct
                    .metdNewServiceProduct(loginController.branchIdLoggedIn,
                        loginController.idProfessionalLoggedIn, carrId)
                    .then((result1) async {
                  if (result1 == 1) {
                    print('ya páse por aqui-2');
                    loginController.setHandleButtonClickModal();
                    String clientName = name;
                    String urlImage = imag;
                    int reservationId = idreservation;
                    int carId = carrId;
                    //   _mostrarBottomSheet(          context);
                    //  showMyDialog(context);
                    print(
                        'LISTA2 _fetchServiceList Limpiando clientName:$clientName...reservationId:$reservationId....carId:$carId....urlImage:$urlImage');
                    await Future.delayed(const Duration(milliseconds: 500));
                    Get.back();
                    //Get.toNamed('/servicesProductsPage');
                    pagesConfigC.onTabTapped(1); //index = 1 -> /Clients
                  } else {
                    loginController.setHandleButtonClickModal();
                    Get.back();
                  }
                });
              } else {
                loginController.setHandleButtonClickModal();
                Get.back();
              }
            } //cierre del if de comprobacion que no lo llame vairas veces
          } else if (isPaused == false) {
            Get.snackbar(
              'Mensaje',
              'Este cliente está con el técnico, espere que regrese por favor...',
              duration: const Duration(milliseconds: 2500),
              backgroundColor: const Color.fromARGB(118, 255, 255, 255),
              showProgressIndicator: true,
              progressIndicatorBackgroundColor:
                  const Color.fromARGB(255, 203, 205, 209),
              progressIndicatorValueColor:
                  const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
              overlayBlur: 3,
            );
          }
        } else {
          //mostrar mensaje de error de conexion
          loginController.showConnectionError();
          await Future.delayed(Duration(milliseconds: 1000));
          Get.snackbar(
            'Mensaje',
            'Conexión inestable. Por favor, inténtelo de nuevo.',
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color.fromARGB(118, 255, 255, 255),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor:
                const Color.fromARGB(255, 203, 205, 209),
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation(Color(0xFFFDAE2A)),
            overlayBlur: 3,
          );
        }
      },

      //todo 710

      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Cliente
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60, // Ajusta a tu necesidad
                          height: 60,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [

                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[200],
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                    width: 48,   // <- Igual a radius * 2
                                    height: 48,  // <- Igual a radius * 2
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.person, size: 24),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8, // mueve hacia abajo para que no lo tape el avatar

                                left: -6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    match.frecuencia!,
                                    style: const TextStyle(fontSize: 9, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(  firstName.characters.length > 10
                            ? '${firstName.characters.take(10)}...'
          : firstName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Visitas: ${match.cant_visit}", style: const TextStyle(fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Barbero
                  Row(
                    children: [

                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: (match.url_image_barber != null && match.url_image_barber!.isNotEmpty)
                              ? CachedNetworkImage(
                            imageUrl: '${dotenv.env['API_ENDPOINT']}/images/${match.url_image_barber}',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.refresh, size: 24),
                          )
                              : Icon(Icons.person, size: 24), // Fallback si viene nulo
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(UltimateBarber1!.characters.length > 10
    ? '${UltimateBarber1.characters.take(10)}...'
        : UltimateBarber1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                           Text('Último Profesional', style: TextStyle(fontSize: 11)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),


            // FOTOS
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:    Align(
                  alignment:
                  Alignment
                      .topLeft,
                  child: Row(
                    mainAxisSize:
                    MainAxisSize
                        .min,
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .center,
                    children: [

                      Column(
                        children: [
                          GestureDetector(
                            onTap:
                                () {
                              showZoomableImage(context,
                                  '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient');
                            },
                            child:
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(16),
                              child:
                              CachedNetworkImage(
                                imageUrl: '${dotenv.env['API_ENDPOINT']}/images/$urlImageClient',
                                placeholder: (context, url) => Container(
                                  width: 130,
                                  height: 130,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromARGB(110, 253, 176, 42),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/default_profile.jpg',
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                                fit: BoxFit.cover,
                                width: 160,
                                height: 130,
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                      Transform
                          .scale(
                        scale:
                        1.0,
                        child:
                        Container(
                          width: (clientsScheduledController.boolFilterShowNext == false &&
                              clientsScheduledController
                                  .clientsScheduledListLengthTail >
                                  0) ||
                              (clientsScheduledController
                                  .clientsScheduledListLengthTail ==
                                  0)
                              ? 130
                              : 130,
                          height: (clientsScheduledController.boolFilterShowNext == false &&
                              clientsScheduledController
                                  .clientsScheduledListLengthTail >
                                  0) ||
                              (clientsScheduledController
                                  .clientsScheduledListLengthTail ==
                                  0)
                              ? 130
                              : 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            // border: Border.all(
                            //   color: Color.fromARGB(255, 75, 24, 2),
                            // ),
                            color: const Color(0xFFFDAE2A),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                              child: AnimatedBuilder(
                                key: uniqueKey,
                                animation: _animationController,
                                builder: (context, child) {
                                  final value = _animationController.value;
                                  // print('value del reloj actual = $value');
                                  final remainingSeconds =
                                  (_animationController.duration!.inSeconds -
                                      (_animationController.duration!.inSeconds *
                                          value))
                                      .ceil();
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
                                    firstName = 'Terminó';
                                    colorInicial = Colors.red;
                                    colorInicialCirculo = Colors.white;
                                    fontSizeText = 10;
                                  }
                                  // print('cambioReloj - minutes:$minutes');
                                  if (minutes > 59) {
                                    // División entera para obtener las horas
                                    hoursN = minutes ~/ 60;

                                    // Resto de la división para obtener los minutos
                                    minutesN = minutes % 60;

                                    // Para asegurar que siempre se muestren dos dígitos
                                    formattedMinutes = minutesN.toString().padLeft(2, '0');
                                  }

                                  return SizedBox(
                                    width: clientsScheduledController.sizeClock,
                                    height: clientsScheduledController.sizeClock,
                                    child: Stack(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (rect) {
                                            return SweepGradient(
                                                startAngle: 0.0,
                                                endAngle: 3.14 * 2,
                                                //twoPi
                                                stops: [value, value],
                                                // 0.0 , 0.5 , 0.5 , 1.0
                                                center: Alignment.center,
                                                colors: [
                                                  Colors.white,
                                                  Color.fromARGB(255, 92, 91, 91)
                                                      .withAlpha(100)
                                                ]).createShader(rect);
                                          },
                                          child: Container(
                                            width: clientsScheduledController.sizeClock,
                                            height: clientsScheduledController.sizeClock,
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
                                            width:
                                            (clientsScheduledController.sizeClock) - 50,
                                            height:
                                            (clientsScheduledController.sizeClock) - 50,
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
                                                        minutes > 59
                                                            ? minutesN > 9
                                                            ? Text(
                                                          '$hoursN:$minutesN:',
                                                          style: TextStyle(
                                                              fontSize:
                                                              (MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width *
                                                                  0.038), //todo2
                                                              fontFamily: GoogleFonts
                                                                  .orbitron()
                                                                  .fontFamily,
                                                              color: colorInicial,
                                                              fontWeight:
                                                              FontWeight.w900),
                                                        )
                                                            : Text(
                                                          '$hoursN : $formattedMinutes :',
                                                          style: TextStyle(
                                                              fontSize:
                                                              (MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width *
                                                                  0.038), //todo2
                                                              fontFamily: GoogleFonts
                                                                  .orbitron()
                                                                  .fontFamily,
                                                              color: colorInicial,
                                                              fontWeight:
                                                              FontWeight.w900),
                                                        )
                                                            : Text(
                                                          '$minutes :',
                                                          style: TextStyle(
                                                              fontSize:
                                                              (MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                                  0.038), //todo2
                                                              fontFamily:
                                                              GoogleFonts.orbitron()
                                                                  .fontFamily,
                                                              color: colorInicial,
                                                              fontWeight:
                                                              FontWeight.w900),
                                                        ),
                                                        Text(
                                                          "$segundos$seconds",
                                                          style: TextStyle(
                                                              fontSize: (MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                                  0.038),
                                                              color: colorInicial,
                                                              fontFamily: GoogleFonts.orbitron()
                                                                  .fontFamily,
                                                              fontWeight: FontWeight.w900),
                                                        ),
                                                      ],
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

                        ),

                      ),

                    ],
                  ),
                )
            ),



        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.history, color: Colors.black),
                  SizedBox(width: 8),
                  Text("Historial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Servicios", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Cantidad", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              // Generar dinámicamente las filas de servicios
              if (match.history_service != null) ...[
                ...match.history_service!.map((service) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(service.name),
                      Text(service.cant.toString()),
                    ],
                  );
                }).toList(),
              ]
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }

  //todo9
  cardTimer2(
    Key uniqueKey,
    String name,
    ClientsScheduledController clientsScheduledController,
    AnimationController _animationController,
  ) {
    String segundos = "";
    // Color colorInicial = Colors.white;
    Color colorInicial = Colors.white;
    Color colorInicialCirculo = const Color(0xFFFDAE2A);
    double fontSizeText = (MediaQuery.of(context).size.width * 0.030);
    // Dividir el nombre completo por espacios

    List<String> partsName =
        name.split(" "); // Tomar los primeros dos nombres (si existen)
    String firstName = partsName.isNotEmpty ? partsName[0] : "";
    // String secondName = partsName.length > 1 ? partsName[1] : "";
    LocalStorage.prefs.setBool('valueClockActiv', true);
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 6),
      child: Column(
        children: [
          Container(
            width: (clientsScheduledController.boolFilterShowNext == false &&
                        clientsScheduledController
                                .clientsScheduledListLengthTail >
                            0) ||
                    (clientsScheduledController
                            .clientsScheduledListLengthTail ==
                        0)
                ? 130
                : 130,
            height: (clientsScheduledController.boolFilterShowNext == false &&
                        clientsScheduledController
                                .clientsScheduledListLengthTail >
                            0) ||
                    (clientsScheduledController
                            .clientsScheduledListLengthTail ==
                        0)
                ? 130
                : 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // border: Border.all(
              //   color: Color.fromARGB(255, 75, 24, 2),
              // ),
              color: const Color(0xFFFDAE2A),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Center(
                child: AnimatedBuilder(
                  key: uniqueKey,
                  animation: _animationController,
                  builder: (context, child) {
                    final value = _animationController.value;
                    final remainingSeconds = (_animationController
                                .duration!.inSeconds -
                            (_animationController.duration!.inSeconds * value))
                        .ceil();
                    int minutes =
                        remainingSeconds ~/ 60; // Calcula los minutos restantes
                    int seconds =
                        remainingSeconds % 60; // Calcula los segundos restantes

                    if (seconds < 10) {
                      segundos = "0";
                    } else {
                      segundos = "";
                    }

                    if (minutes == 0 && seconds == 0) {
                      firstName = 'Terminó';
                      colorInicial = Colors.red;
                      colorInicialCirculo = Colors.white;
                      fontSizeText = 10;
                    }

                    return SizedBox(
                      width: clientsScheduledController.sizeClock,
                      height: clientsScheduledController.sizeClock,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: 3.14 * 2,
                                  //twoPi
                                  stops: [value, value],
                                  // 0.0 , 0.5 , 0.5 , 1.0
                                  center: Alignment.center,
                                  colors: [
                                    Colors.white,
                                    Color.fromARGB(255, 92, 91, 91)
                                        .withAlpha(100)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: clientsScheduledController.sizeClock,
                              height: clientsScheduledController.sizeClock,
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
                              width:
                                  (clientsScheduledController.sizeClock) - 50,
                              height:
                                  (clientsScheduledController.sizeClock) - 50,
                              decoration: BoxDecoration(
                                  color: colorInicialCirculo,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$minutes :',
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04), //todo2
                                            fontFamily: GoogleFonts.orbitron()
                                                .fontFamily,
                                            color: colorInicial,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        "$segundos$seconds",
                                        style: TextStyle(
                                            fontSize: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                            color: colorInicial,
                                            fontFamily: GoogleFonts.orbitron()
                                                .fontFamily,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
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
          ),
          Align(
              alignment: Alignment.center,
              child: firstName == 'Esperando'
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        '$firstName...',
                        style: const TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            color: Color(0xFFFDAE2A),
                            fontWeight: FontWeight.w900),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        firstName,
                        style: const TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            color: Color(0xFFFDAE2A),
                            fontWeight: FontWeight.w600),
                      ),
                    )),
        ],
      ),
    );
  }

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
      height:
          loginController.androidInfoWidth! >= 867.42 //propiedades de telefone
              ? (MediaQuery.of(context).size.height * 0.198)
              : (MediaQuery.of(context).size.height * 0.170),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
        color: colorVariable,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorVariable, // Color de fondo en verde
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadiusValue), // Ajusta el radio según tus necesidades
          ),
        ),
        onPressed: () async {
          if (titleCart == 'Agenda') {
            //todo optimización de codigo-cambio de ruta (anterior-fetchClientsScheduled)
            if (clientsScheduledController.errorHome == -99) {
              await Future.delayed(const Duration(milliseconds: 2000));
            }
            if (loginController.makeCall == true &&
                clientsScheduledController.getWaitTime() == false) {
              if (loginController.usserPermissionQr != null) {
                //verificar que no este pediendo colación
                Get.dialog(
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFDAE2A),
                    ),
                  ),
                  barrierDismissible: false,
                ); //Get.back();
                await clientsScheduledController.fetchClientsScheduledNew(
                    loginController.idProfessionalLoggedIn,
                    loginController.branchIdLoggedIn,
                    'Agenda-Card',
                    loginController.tokenUserLoggedIn);
              }
            }

            await Future.delayed(const Duration(milliseconds: 500));
            pagesConfigC.onTabTapped(1); //index = 4 -> /CoexistencePage
          }
          if (titleCart == 'Convivencia') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            );
            await coexistenceController.fetchCoexistenceList();

            pagesConfigC.onTabTapped(4); //index = 4 -> /CoexistencePage
          }
          if (titleCart == 'Solicitudes') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            );

            await Future.delayed(const Duration(milliseconds: 500));

            await coexCont.fetchEstadist0();

            Get.back(); // Cierra el dialog

            Get.toNamed(
                '/Estadistc2Pagos'); // Ir directamente a la vista que deseas
          }

          if (titleCart == 'Estadísticas') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            await Future.delayed(const Duration(milliseconds: 500));
            await coexCont.fetchEstadist0();

            pagesConfigC.onTabTapped(3); //index = 3 -> /StatisticPage
          }
          if (titleCart == 'Notificaciones') {
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDAE2A),
                ),
              ),
              barrierDismissible: false,
            ); //Get.back();
            String typeEnv = '';

            if (loginController.chargeUserLoggedIn == 'Barbero y Encargado') {
              if (loginController.switchValue == false) //'Barbero'
              {
                typeEnv = 'Barbero';
              } else {
                typeEnv = 'Encargado';
              }
            } else {
              typeEnv = 'Barbero';
            }

            await notiController.fetchNotificationList(
                loginController.branchIdLoggedIn,
                loginController.idProfessionalLoggedIn,
                typeEnv,
                'Cart homeCart',
                loginController.tokenUserLoggedIn);
            await Future.delayed(const Duration(milliseconds: 500));
            pagesConfigC.onTabTapped(2); //index = 2 -> /NotificationsPageProf
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 20,
                  // Tamaño del CircleAvatar
                  backgroundColor: colorBottom,
                  // Color de fondo del CircleAvatar
                  child: Icon(
                    iconCart, // Icono que deseas mostrar
                    size: 30, // Tamaño del icono
                    color: colorVariable, // Color del icono
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descriptionTitleCart,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.5,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
