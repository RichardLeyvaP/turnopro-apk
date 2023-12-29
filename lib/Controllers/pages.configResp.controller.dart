// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/responsible/coexistencePageResponsible.dart';
import 'package:turnopro_apk/Views/responsible/homeResponsibleBodyPage.dart';
import 'package:turnopro_apk/Views/responsible/statistic_R/statisticPage_R.dart';

class PagesConfigResponController extends GetxController {
//DECLARACION DE VARIABLES

  bool isLoading = true;
  int selectedIndexResp = 0;
  List<int> selectedIndexRespBackList = [];
  int selectedIndexRespBack = 0;
  PageController pageRespController = PageController();
  //
  //todo **************** CONFIGURACIONES PARA HOME-RESPONSABLE ************************
  //

  //todo List<Widget> _pages -> esta esta solo para inicializar pero no es la que funciona
  final List<Widget> pages = [
    HomeResponsibleBodyPages(), // Página 1//todo poner aqui
    Text('Aqui van la Agenda'), // Página 1//todo poner aqui
    const NotificationsPageNew(), // Pagina 2 okokokokok
    const StatisticPageRespon(), // Página 3 okkkkkkkk
    const CoexistencePageResponsible(), // Página 4 okkkkk
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
    if (selectedIndexResp != index) {
      selectedIndexRespBack = selectedIndexResp;
      selectedIndexResp = index;
      selectedIndexRespBackList.add(selectedIndexRespBack);
      print('selectedIndexRespBackList:$selectedIndexRespBackList');
      pageRespController.jumpToPage(index);
      //

      update();
    }
  }

  @override
  void onClose() {
    pageRespController.dispose();
    pageRespController.dispose();
    super.onClose();
  }

  //************************************************** */

  void back() {
    print('estoy haciendo un back()');
    if (selectedIndexRespBackList.isNotEmpty) {
      selectedIndexResp = getLastElement(selectedIndexRespBackList);
      pageRespController.jumpToPage(selectedIndexResp);
      print('si hay un historial en la cola:$selectedIndexResp');
      if (selectedIndexResp == 0) {
        clearList(selectedIndexRespBackList);
        print('eliminando la cola de selecciones');
      } else {
        deleteLastElement(selectedIndexRespBackList);
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
  //todo **************** FIN - CONFIGURACIONES PARA HOME-RESPONSABLE ************************
  //
}
