// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/professional/home/homePageBody.dart';

class PagesConfigController extends GetxController {
//DECLARACION DE VARIABLES

  bool isLoading = true;
  bool loadedFirstTime = false;
  int selectedIndex = 0;
  List<int> selectedIndexBackList = [];
  int selectedIndexBack = 0;

  //todo List<Widget> _pages -> esta esta solo para inicializar pero no es la que funciona
  final List<Widget> pages = [
    // homePageBody(borderRadiusValue, context, colorVariable, colorBottom,
    //     titleCart, descriptionTitleCart, iconCart), // Página 0
    const HomePageBody(), // Página 1
    const ClientsScheduled(), // Página 1//todo poner aqui
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

  void navigateBottomBar(int index) {
    print('estoy seleccionando navigateBottomBar(int index)');
    //CON ESTO GARANDIZO QUE SI DA EN EL MISMO TAB QUE NO VUELVA A DIBUJAR EL WIDGET,SOLO QUE DIBUJE CUANDO DE EN UNO DIFERENTE
    if (selectedIndex != index) {
      selectedIndexBack = selectedIndex;
      selectedIndex = index;
      selectedIndexBackList.add(selectedIndexBack);
      pages[index];
      update();
    }
  }

  void back() {
    print('estoy haciendo un back()');
    if (selectedIndexBackList.isNotEmpty) {
      selectedIndex = getLastElement(selectedIndexBackList);
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
}
