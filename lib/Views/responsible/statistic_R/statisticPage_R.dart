// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/pages.configResp.controller.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
//import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:turnopro_apk/Views/responsible/statistic_R/stadistica_R.dart';

class StatisticPageRespon extends StatefulWidget {
  const StatisticPageRespon({super.key});

  @override
  State<StatisticPageRespon> createState() => _StatisticPageResponState();
}

class _StatisticPageResponState extends State<StatisticPageRespon>
    with SingleTickerProviderStateMixin {
  final StatisticController controllerStatistic =
      Get.find<StatisticController>();
  final PagesConfigResponController pagesConfigCont =
      Get.find<PagesConfigResponController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //VARIABLE A UTILIZAR
    BoxDecoration clickServicesDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    BoxDecoration decorationBackground = const BoxDecoration(
      color: Color.fromARGB(155, 231, 232, 234),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    const backgroundColor = Color.fromARGB(255, 231, 232, 234);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 26, 50, 82), // Color de fondo del AppBar
          elevation: 0, // Sombra del AppBar
          toolbarHeight: 120, // Altura del AppBar
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
          // ],

          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back), // Icono que deseas mostrar
                onPressed: () {
                  pagesConfigCont.back();
                  //Get.back();
                }, // Evento onPress
              ),
              Column(
                children: [
                  Icon(
                    MdiIcons.chartBarStacked,
                    size: (MediaQuery.of(context).size.width * 0.22),
                  ),
                  const Text('ESTADÍSTICAS',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back), // Icono que deseas mostrar
                color: Colors.transparent,
                onPressed: () {
                  Get.back();
                }, // Evento onPress
              ),

              // const Text("          "),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50), // Altura del TabBar
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                width: (MediaQuery.of(context).size.width * 0.8),
                height: (MediaQuery.of(context).size.width * 0.07),
                decoration: decorationBackground,
                child: TabBar(
                  // isScrollable: true,//rlp si son muchos tab para que tenga scroll entre los tab
                  indicator: clickServicesDecoration,
                  labelColor: const Color.fromARGB(255, 26, 50, 82),
                  unselectedLabelColor: Colors.white,
                  automaticIndicatorColorAdjustment: false,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Diario'),
                    Tab(text: 'Mensual'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: GetBuilder<StatisticController>(builder: (contStat) {
          return TabBarView(
            controller: _tabController,
            children: [
              const StadisticaRespon(),
              Text('AQUI UN SELECT PARA ESCOGER EL MES'),
            ],
          );
        }), // Muestra el AlertDialog
      ),
    );
  }
}

class CartOption extends StatelessWidget {
  const CartOption({
    super.key,
    required this.color,
    required this.icon,
    required this.totalEarnings,
    required this.averageEarnings,
    required this.description,
  });

  final Color color;
  final Icon icon;
  final double totalEarnings;
  final double? averageEarnings;
  final List<String> description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.8),
      height: 120, //(MediaQuery.of(context).size.height * 0.4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  description[0],
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(162, 0, 0, 0)),
                ),
                Text(
                  totalEarnings.toStringAsFixed(2),
                  style: const TextStyle(
                      color: Color.fromARGB(245, 39, 141, 61),
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(30, 0, 0, 0),
            width: 0.6,
            height: (MediaQuery.of(context).size.height * 0.128),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  description[1],
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(162, 0, 0, 0)),
                ),
                Text(
                  averageEarnings!.toStringAsFixed(2),
                  style: const TextStyle(
                      color: Color(0xFFF18254),
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildCalendar extends StatefulWidget {
  final DateTime d;
  final DateTime m;
  final DateTime a;

  const BuildCalendar(
      {Key? key, required this.d, required this.m, required this.a})
      : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  //final DateRangePickerController _controller = DateRangePickerController();
  final StatisticController controllerStatistic =
      Get.find<StatisticController>();

  late DateTime? _startDate;
  late DateTime? _endDate;
  int selectDate = 0;
  DateTime? _minDate;
  DateTime? _maxDate;
  final formatterDate = DateFormat('yyyy-MM-dd');

  void getFormatterDate() async {
    final startDate = formatterDate.format(_startDate!);
    final endDate = formatterDate.format(_endDate!);

    int numberdayWeek = _startDate!.weekday;

    Duration diferencia = _endDate!.difference(_startDate!);
    int quantityDates = diferencia.inDays + 1;

    //EN ESTA DEVUELVE LAS GANANCIAS EN ESE INTERVALO DE FECHAS
    await controllerStatistic.getDataStatistic(startDate, endDate,
        numberdayWeek, quantityDates); //todo LLAMANDO AL CONTROLADOR
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = null;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime initialDate = DateTime(2023, 1, 1);
    return AlertDialog(
      //title: const Text('Confirmación'),
      actionsPadding: const EdgeInsets.only(right: 20),
      actions: [
        TextButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
            Color.fromARGB(20, 0, 0, 0),
          )),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
            Color.fromARGB(20, 0, 0, 0),
          )),
          onPressed: () {
            setState(() {
              selectDate = 0;
            });
          },
          child: const Text('Seleccionar nuevamente'),
        ),
      ],
      content:
          // SizedBox(
          //   height: 255, // Ajusta la altura según tu necesidad
          //   width: 300,
          //   child: AspectRatio(
          //     aspectRatio: 1.0,
          //     child: SfDateRangePicker(
          //       controller: _controller,
          //       view: DateRangePickerView.month,
          //       initialDisplayDate: initialDate,
          //       minDate: selectDate == 0 ? null : _minDate,
          //       maxDate: selectDate == 0 ? null : _maxDate,
          //       selectionColor: const Color(0xFFF18254),
          //       startRangeSelectionColor: const Color(0xFFF18254),
          //       endRangeSelectionColor: const Color(0xFFF18254),
          //       selectionMode: DateRangePickerSelectionMode.range,
          //       showActionButtons: _endDate != null ? true : false,
          //       onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          //         if (args.value != null && args.value.startDate != null) {
          //           setState(() {
          //             selectDate = 1;
          //             if (_startDate != null) {
          //               _minDate = _startDate = args.value.startDate;
          //               _endDate = args.value.endDate;
          //               _maxDate = _startDate!.add(const Duration(days: 6));
          //               selectDate = 1;
          //             }
          //           });
          //         }
          //       },
          //       confirmText: 'Aceptar',
          //       cancelText: '',
          //       onSubmit: (dateRange) {
          //         getFormatterDate();
          //       },
          //     ),
          //   ),
          // ),
          Text('comentando todo lo referente a syncfusion_flutter_datepicker'),
    );
  }
}
