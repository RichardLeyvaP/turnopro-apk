// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/professional/home/homePageBody.dart';
import 'package:turnopro_apk/Views/professional/clientsScheduled/clientsScheduled.dart';
import 'package:turnopro_apk/Views/tecnico/clientsScheduled/clientsTechnical.dart';
import 'package:turnopro_apk/Views/tecnico/homeTecnico/homePageTecnicoBody.dart';

class PagesConfigController extends GetxController {
//DECLARACION DE VARIABLES

  bool isLoading = true;
  bool loadedFirstTime = false;
  int selectedIndex = 0;
  List<int> selectedIndexBackList = [];
  int selectedIndexBack = 0;

  //
  //todo **************** CONFIGURACIONES PARA HOME-PROFESIONAL ************************
  //
  PageController pageController = PageController();
  PageController pageHomeController = PageController();

  bool isPageViewEnabled =
      false; // Variable para habilitar/deshabilitar PageView.
  int currentPageIndex = 0;

  @override
  void onInit() {
    super.onInit();
    pageHomeController = PageController(
        initialPage: selectedIndex); //ESTE CONTROLA EL TAB PRINCIPAL DE ABAJO
    pageController = PageController(
        initialPage:
            currentPageIndex); //CON ESTE CONTROLO LA NAVEGACION DE LA COLA,AGREGAR SERVICIOS,EL CARRO
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

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
    );
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
    const CoexistencePage(), // Página 4
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
  void onTabTapped(int index) {
    //CON ESTO GARANDIZO QUE SI DA EN EL MISMO TAB QUE NO VUELVA A DIBUJAR EL WIDGET,SOLO QUE DIBUJE CUANDO DE EN UNO DIFERENTE
    if (selectedIndex != index) {
      selectedIndexBack = selectedIndex;
      selectedIndex = index;
      selectedIndexBackList.add(selectedIndexBack);
      pageHomeController.jumpToPage(index);
      //

      update();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    pageHomeController.dispose();
    super.onClose();
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
