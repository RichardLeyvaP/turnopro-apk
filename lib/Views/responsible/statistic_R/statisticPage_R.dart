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

class StatisticPageRespon extends StatefulWidget {
  const StatisticPageRespon({super.key});

  @override
  State<StatisticPageRespon> createState() => _StatisticPageResponState();
}

class _StatisticPageResponState extends State<StatisticPageRespon>
    with SingleTickerProviderStateMixin {
  final double valuePadding = 12;
  late TabController _tabController;
  final PagesConfigResponController pagesConfigCont =
      Get.find<PagesConfigResponController>();
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
                      buttonRight: false,
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










































// // ignore_for_file: file_names, depend_on_referenced_packages

// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
// import 'package:turnopro_apk/Controllers/pages.configPorf.controller.dart';
// import 'package:turnopro_apk/Controllers/statistics.controller.dart';
// import 'package:turnopro_apk/Views/professional/statistic/estadistc0Page.dart';
// import 'package:turnopro_apk/Views/professional/statistic/estadistc1Page.dart';
// import 'package:turnopro_apk/Views/professional/statistic/stadisticaDiaPageNueva.dart';
// import 'package:turnopro_apk/Views/professional/statistic/stadisticaMensualPageNueva.dart';
// //import 'package:animate_do/animate_do.dart';
// import 'package:get/get.dart';
// //import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
// import 'package:turnopro_apk/Views/professional/statistic/stadisticaSemanalPageNueva.dart';

// class StatisticPageRespon extends StatefulWidget {
//   const StatisticPageRespon({super.key});

//   @override
//   State<StatisticPageRespon> createState() => _StatisticPageResponState();
// }

// class _StatisticPageResponState extends State<StatisticPageRespon>
//     with SingleTickerProviderStateMixin {
//   final StatisticController controllerStatistic =
//       Get.find<StatisticController>();
//   final CoexistenceController coexContro = Get.find<CoexistenceController>();
//   final PagesConfigController pagesConfigCont =
//       Get.find<PagesConfigController>();
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     Get.back();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //VARIABLE A UTILIZAR
//     BoxDecoration clickServicesDecoration = const BoxDecoration(
//       color: Color(0xFFFDAE2A),
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//     );
//     BoxDecoration decorationBackground = const BoxDecoration(
//       color: Color.fromARGB(155, 231, 232, 234),
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//     );
//     const backgroundColor = Color.fromARGB(255, 231, 232, 234);
//     // const cyclingColor = Color.fromARGB(255, 68, 135, 211);
//     // const quickWorkoutColor = Color(0xFFFDAE2A);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           backgroundColor:
//               Color.fromARGB(255, 231, 232, 234), // Color de fondo del AppBar
//           elevation: 0, // Sombra del AppBar
//           toolbarHeight: 120, // Altura del AppBar
//           // actions: [
//           //   IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
//           // ],

//           title: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               color: Colors.white,
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 10, left: 0, bottom: 8),
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(
//                                   Icons.arrow_back,
//                                   color: Color(0xFF2B3141),
//                                 ), // Icono que deseas mostrar
//                                 onPressed: () {
//                                   pagesConfigCont.back();
//                                   //Get.back();
//                                 }, // Evento onPress
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors
//                                         .white, // Color blanco para el borde
//                                     width:
//                                         1.0, // Ancho del borde (puedes ajustarlo según sea necesario)
//                                   ),
//                                   color: const Color(0xFF4470F3),
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(12)),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Icon(Icons.bar_chart_outlined,
//                                       size: 40, color: Colors.white),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 8,
//                               ),
//                               const Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Estadísticas',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 16,
//                                         color: Color.fromARGB(200, 0, 0, 0)),
//                                   ),
//                                   Text(
//                                     'Mis Estadísticas',
//                                     style: TextStyle(
//                                         fontSize: 11,
//                                         color: Color.fromARGB(180, 0, 0, 0)),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 62,
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             Get.dialog(
//                               const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Color(0xFFFDAE2A),
//                                 ),
//                               ),
//                               barrierDismissible: false,
//                             ); //Get.back();
//                             await coexContro.fetchEstadistPagos();
//                             Get.back();
//                             Get.toNamed('/Estadistc2Pagos');
//                           },
//                           style: ButtonStyle(
//                             padding:
//                                 MaterialStateProperty.all<EdgeInsetsGeometry>(
//                               const EdgeInsets.symmetric(
//                                 vertical: 0,
//                               ),
//                             ),
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Color(0xFF4470F3)),
//                           ),
//                           child: const Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'MIS PAGOS',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w800),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         //
//                       ],
//                     ),

//                     // const Text("          "),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(30), // Altura del TabBar
//             child: Container(
//               width: (MediaQuery.of(context).size.width * 0.935),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10)),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: (MediaQuery.of(context).size.width * 0.88),
//                     height: (MediaQuery.of(context).size.width * 0.09),
//                     decoration: decorationBackground,
//                     child: TabBar(
//                       // isScrollable: true,//rlp si son muchos tab para que tenga scroll entre los tab
//                       indicator: clickServicesDecoration,
//                       labelColor: Colors.white,
//                       unselectedLabelColor:
//                           const Color.fromARGB(155, 136, 135, 135),
//                       automaticIndicatorColorAdjustment: false,
//                       controller: _tabController,
//                       tabs: const [
//                         Tab(text: 'Día'),
//                         Tab(text: 'Rango'),
//                         Tab(text: 'Sem.'),
//                         Tab(text: 'Mens.'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: GetBuilder<StatisticController>(builder: (contStat) {
//           return TabBarView(
//             controller: _tabController,
//             children: [
//               const Estadistc0Page(),
//               const LineChartSample2(),
//               StadisticaSemanalPageNueva(),
//               //const LineChartSample5(),
//               StadisticaMensualPageNueva(),
//             ],
//           );
//         }), // Muestra el AlertDialog
//       ),
//     );
//   }
// }

// class CartOption extends StatelessWidget {
//   const CartOption({
//     super.key,
//     required this.color,
//     required this.icon,
//     required this.totalEarnings,
//     required this.averageEarnings,
//     required this.description,
//   });

//   final Color color;
//   final Icon icon;
//   final double totalEarnings;
//   final double? averageEarnings;
//   final List<String> description;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: (MediaQuery.of(context).size.width * 0.8),
//       height: 120, //(MediaQuery.of(context).size.height * 0.4),
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(16)),
//         color: color,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: (MediaQuery.of(context).size.width * 0.35),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   description[0],
//                   style: const TextStyle(
//                       fontSize: 14, color: Color.fromARGB(162, 0, 0, 0)),
//                 ),
//                 Text(
//                   totalEarnings.toStringAsFixed(2),
//                   style: const TextStyle(
//                       color: Color.fromARGB(245, 39, 141, 61),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: const Color.fromARGB(30, 0, 0, 0),
//             width: 0.6,
//             height: (MediaQuery.of(context).size.height * 0.128),
//           ),
//           SizedBox(
//             width: (MediaQuery.of(context).size.width * 0.35),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   description[1],
//                   style: const TextStyle(
//                       fontSize: 14, color: Color.fromARGB(162, 0, 0, 0)),
//                 ),
//                 Text(
//                   averageEarnings!.toStringAsFixed(2),
//                   style: const TextStyle(
//                       color: Color(0xFFFDAE2A),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BuildCalendar extends StatefulWidget {
//   final DateTime d;
//   final DateTime m;
//   final DateTime a;

//   const BuildCalendar(
//       {Key? key, required this.d, required this.m, required this.a})
//       : super(key: key);

//   @override
//   State<BuildCalendar> createState() => _BuildCalendarState();
// }

// class _BuildCalendarState extends State<BuildCalendar> {
//   // final DateRangePickerController _controller = DateRangePickerController();
//   final StatisticController controllerStatistic =
//       Get.find<StatisticController>();

//   late DateTime? _startDate;
//   late DateTime? _endDate;
//   int selectDate = 0;
//   DateTime? _minDate;
//   DateTime? _maxDate;
//   final formatterDate = DateFormat('yyyy-MM-dd');

//   void getFormatterDate() async {
//     final startDate = formatterDate.format(_startDate!);
//     final endDate = formatterDate.format(_endDate!);

//     int numberdayWeek = _startDate!.weekday;

//     Duration diferencia = _endDate!.difference(_startDate!);
//     int quantityDates = diferencia.inDays + 1;

//     //EN ESTA DEVUELVE LAS GANANCIAS EN ESE INTERVALO DE FECHAS
//     await controllerStatistic.getDataStatistic(startDate, endDate,
//         numberdayWeek, quantityDates); //todo LLAMANDO AL CONTROLADOR
//     // ignore: use_build_context_synchronously
//     Navigator.of(context).pop();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _startDate = DateTime.now();
//     _endDate = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DateTime initialDate = DateTime(2023, 1, 1);
//     return AlertDialog(
//       //title: const Text('Confirmación'),
//       actionsPadding: const EdgeInsets.only(right: 20),
//       actions: [
//         TextButton(
//           style: const ButtonStyle(
//               backgroundColor: MaterialStatePropertyAll(
//             Color.fromARGB(20, 0, 0, 0),
//           )),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Cancelar'),
//         ),
//         TextButton(
//           style: const ButtonStyle(
//               backgroundColor: MaterialStatePropertyAll(
//             Color.fromARGB(20, 0, 0, 0),
//           )),
//           onPressed: () {
//             setState(() {
//               selectDate = 0;
//             });
//           },
//           child: const Text('Seleccionar nuevamente'),
//         ),
//       ],
//       content:
//           Text('comentando todo lo referente a syncfusion_flutter_datepicker'),
//     );
//   }
// }
