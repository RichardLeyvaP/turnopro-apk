// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/clientsCoordinatorController.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/coordinator/coexistencePageCoordinator.dart';
import 'package:turnopro_apk/Views/coordinator/homeCoordinator/homeCoordinatorBody.dart';
import 'package:turnopro_apk/Views/coordinator/statistic/statisticPageCordi.dart';
import 'package:turnopro_apk/Views/professional/home/homePageBody.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/clientsScheduled.dart';
import 'package:turnopro_apk/Views/tecnico/clientsScheduled/homePageViewTechnical.dart';
import 'package:turnopro_apk/Views/tecnico/coexistencePageTecnhical.dart';
import 'package:turnopro_apk/Views/tecnico/homeTecnico/homePageTecnicoBody.dart';

import '../Views/coordinator/assign/assignProfessional.dart';
import '../Views/coordinator/attending/attendingClient.dart';
import '../Views/coordinator/product/productClient.dart';
import '../Views/coordinator/profile/profileClient.dart';
import '../Views/coordinator/services/servicesClient.dart';

class PagesConfigController extends GetxController {
//DECLARACION DE VARIABLES
  NotificationController notiController = Get.find<NotificationController>();
  LoginController logController = Get.find<LoginController>();
  ClientsCoordinatorController clientsScheduledController =
      Get.find<ClientsCoordinatorController>();
  bool isLoading = true;
  bool loadedFirstTime = false;
  int selectedIndex = 0;
  List<int> selectedIndexBackList = [];
  int selectedIndexBack = 0;
  int pages31Index = 0;

  //
  //todo **************** CONFIGURACIONES PARA HOME-PROFESIONAL ************************
  //
  PageController pageController = PageController();
  PageController pageController2 = PageController();
  PageController pageHomeController = PageController();

  bool isPageViewEnabled =
      false; // Variable para habilitar/deshabilitar PageView.
  int currentPageIndex = 0;
  bool showappBar = true;

  @override
  void onInit() {
    super.onInit();
    pageHomeController = PageController(
        initialPage: selectedIndex); //ESTE CONTROLA EL TAB PRINCIPAL DE ABAJO
    pageController = PageController(initialPage: currentPageIndex);
    pageController2 = PageController(
        initialPage:
            pages31Index); //CON ESTE CONTROLO LA NAVEGACION DE LA COLA,AGREGAR SERVICIOS,EL CARRO
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void goToPage(int page, PageController pController) {
    pController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void goToPreviousPage() {
    pageController2.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
    );
  }

  void updateSelectedIndex() {
    selectedIndex = 10;
    update();
  }

  //
  //

  //todo List<Widget> _pages -> esta esta solo para inicializar pero no es la que funciona
  final List<Widget> pages = [
    const HomePageBody(), // Página 1
    const HomePageView(), // Página 1//todo poner aqui
    const NotificationsPageProf(), // Página 2
    const StatisticPage(), // Página 3
    const CoexistencePage(), // Página 4
  ];
  //todo List<Widget> _pages2 -> esta esta solo para inicializar pero no es la que funciona
  final List<Widget> pages2 = [
    const HomePageTecnicoBody(), // Página 1
    const HomePageViewTechnical(), // Página 1//todo poner aqui
    const NotificationsPageProf(), // Página 2
    const StatisticPage(), // Página 3
    const CoexistencePageTecnhical(), // Página 4
  ];

  //todo List<Widget> _pages3
  final List<Widget> pages3 = [
    const HomeCoordinatorBody(), // Página 1//todo ESTOY EN ESTA
    const AttendingClient(), // Página 2
    const NotificationsPageProf(), // Página 3
    const StatisticPageCordin(),
    // const StatisticPage(), // Página 4
    const CoexistencePageCoordinator(), // Página 5
  ]; //todo List<Widget> _pages31
  final List<Widget> pages31 = [
    const ProfileClient(), // Página 1
    const ServicesClient(), // Página 2//todo ESTOY EN ESTA
    const ProductClient(), // Página 3
    const AttendingClient(), // Página 4
    const CoexistencePageCoordinator(), // Página 5
    const AssignProfessional(), // Página 6
  ];

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

//todo nueva probando
//******************************************************* */
  Future<void> onTabTapped(int index) async {
    //CON ESTO GARANDIZO QUE SI DA EN EL MISMO TAB QUE NO VUELVA A DIBUJAR EL WIDGET,SOLO QUE DIBUJE CUANDO DE EN UNO DIFERENTE
    print('selectedIndex:$selectedIndex');
    print('index:$index');

    if (selectedIndex != index) {
      /*  if (index == 1 && logController.chargeUserLoggedIn == 'Cordinador') {
        await showAppBar(false);
        await clientsScheduledController
            .clientsAttendBranch(logController.branchIdLoggedIn);
        goToPage(4, pageController2);
        selectedIndexBack = selectedIndex;
        selectedIndex = index;
        selectedIndexBackList.add(selectedIndexBack);
        // pageHomeController.jumpToPage(index);
        //

        update();
      } else {*/
      if (index == 2) {
        print('llamar a notificACIONES-1');
        int idBranch = logController.branchIdLoggedIn!;
        int idProfess = logController.idProfessionalLoggedIn!;
        await notiController.fetchNotificationList(
            idBranch, idProfess); //3 es deyler
        print('llamar a notificACIONES-2 listo');
      }

      selectedIndexBack = selectedIndex;
      selectedIndex = index;
      selectedIndexBackList.add(selectedIndexBack);
      pageHomeController.jumpToPage(index);
      //

      update();
      //}
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    pageHomeController.dispose();
    super.onClose();
  }

  Future showAppBar(value) async {
    showappBar = value;
    update();
  }

  //************************************************** */

  void back() {
    print('estoy haciendo un back()');
    if (selectedIndexBackList.isNotEmpty) {
      selectedIndex = getLastElement(selectedIndexBackList);
      pageHomeController.jumpToPage(selectedIndex);
      print('si hay un historial en la cola:$selectedIndex');
      if (selectedIndex == 0) {
        clearList(selectedIndexBackList);
        print('eliminando la cola de selecciones');
      } else {
        deleteLastElement(selectedIndexBackList);
        print('eliminando al ultimo de la cola');
      }
      update();
    }
  }

  int getLastElement(List<int> lista) {
    if (lista.isNotEmpty) {
      return lista.last;
    } else {
      // Manejar el caso de una lista vacía según tus necesidades
      throw Exception("La lista está vacía");
    }
  }

  void deleteLastElement(List<int> lista) {
    if (lista.isNotEmpty) {
      lista.removeLast();
    }
  }

  void clearList(List<int> lista) {
    lista.clear();
  }

  //
  //todo **************** FIN - CONFIGURACIONES PARA HOME-PROFESIONAL ************************
  //
}
