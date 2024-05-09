// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/notification.controller.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Routes/index.dart';
import 'package:turnopro_apk/Views/common/topPage.dart';
import 'package:turnopro_apk/Views/professional/statistic/estadistc0Page.dart';
import 'package:turnopro_apk/Views/professional/statistic/stadisticaDiaPageNueva.dart';
import 'package:turnopro_apk/Views/professional/statistic/stadisticaMensualPageNueva.dart';
import 'package:turnopro_apk/Views/professional/statistic/stadisticaSemanalPageNueva.dart';
import 'package:turnopro_apk/Views/responsible/statistic_R/stadisticaMenRespon.dart';
import 'package:turnopro_apk/Views/responsible/statistic_R/stadisticaRangoRespon.dart';
import 'package:turnopro_apk/Views/responsible/statistic_R/stadisticaSemRespon.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StatisticPageCordin extends StatefulWidget {
  const StatisticPageCordin({super.key});

  @override
  State<StatisticPageCordin> createState() => _StatisticPageCordinState();
}

class _StatisticPageCordinState extends State<StatisticPageCordin>
    with SingleTickerProviderStateMixin {
  final double valuePadding = 12;
  late TabController _tabController;
  final PagesConfigController pagesConfigCont =
      Get.find<PagesConfigController>();
  final NotificationController notifCont = Get.find<NotificationController>();
  final LoginController logCont = Get.find<LoginController>();
  final CoexistenceController coexCont = Get.find<CoexistenceController>();
  String typeEnv = '';

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();

    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.back();
    });
    final double heightScreen = MediaQuery.of(context).size.height;
    int heightFlexBody = 18;
    if (heightScreen <= 534.0) {
      heightFlexBody = 14;
    }
    BoxDecoration clickServicesDecoration = const BoxDecoration(
      color: Color(0xFFFDAE2A),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    BoxDecoration decorationBackground = const BoxDecoration(
      color: Color.fromARGB(155, 231, 232, 234),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */
    final IconnsBack = Icons.arrow_back;
    final IconnsP = Icons.bar_chart_outlined;
    String title = 'Estadística';
    String subTitle = 'Mis estadísticas';
    final colorCont = Colors.white;
    double panddCont = 8;
    double borderCont = 12;
    final colorIcon = Color(0xFF4470F3);
    /**VARIABLES NECESARIAS PARA EL CAR DE ARRIBA */

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 232, 234),
      body: GetBuilder<NotificationController>(builder: (_) {
        return _.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xFFFDAE2A),
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: topPage(
                      panddCont: panddCont,
                      colorCont: colorCont,
                      borderCont: borderCont,
                      IconnsBack: IconnsBack,
                      pagesConfigC: pagesConfigCont,
                      isPagesConfig: true,
                      IconnsP: IconnsP,
                      title: title,
                      subTitle: subTitle,
                      colorIcon: colorIcon,
                      buttonRight: true,
                      colorButton: Color(0xFF4470F3),
                      direccButton: '/Estadistc2Pagos',
                      textButton: 'MIS PAGOS',
                      coexContro: coexCont,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      width: (MediaQuery.of(context).size.width * 1),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 2),
                        child: Column(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width * 0.88),
                              height:
                                  (MediaQuery.of(context).size.width * 0.09),
                              decoration: decorationBackground,
                              child: TabBar(
                                // isScrollable: true,//rlp si son muchos tab para que tenga scroll entre los tab
                                indicator: clickServicesDecoration,
                                labelColor: Colors.white,
                                unselectedLabelColor:
                                    const Color.fromARGB(155, 136, 135, 135),
                                automaticIndicatorColorAdjustment: false,
                                controller: _tabController,
                                tabs: const [
                                  // Tab(text: 'Día'),
                                  Tab(text: 'Rango'),
                                  Tab(text: 'Sem.'),
                                  Tab(text: 'Mens.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex:
                        heightFlexBody, // 85% del espacio disponible para esta parte
                    child: GetBuilder<StatisticController>(builder: (contStat) {
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          //const Estadistc0Page(),
                          StadisticaRespon(),
                          StadisticaSemRespon(),
                          //  StadisticaMenRespon(),
                          // const LineChartSample2(),
                          /**sssss */ // StadisticaSemanalPageNueva(),
                          //const LineChartSample5(),
                          StadisticaMensualPageNueva(),
                        ],
                      );
                    }),
                  )
                ],
              );
      }),
    );
  }
}
