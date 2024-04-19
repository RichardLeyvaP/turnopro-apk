import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class StadisticaMensualPageNueva extends StatefulWidget {
  const StadisticaMensualPageNueva({super.key});

  @override
  State<StadisticaMensualPageNueva> createState() =>
      _StadisticaMensualPageNuevaState();
}

final StatisticController controllerStatistic = Get.find<StatisticController>();

class _StadisticaMensualPageNuevaState
    extends State<StadisticaMensualPageNueva> {
  List<String> direcc = [
    'assets/images/icons/montoGen.png',
    'assets/images/icons/propina.png',
    'assets/images/icons/80.png',
    'assets/images/icons/porcentageGan.png',
    'assets/images/icons/serviceRea.png',
    'assets/images/icons/serviceRegul.png',
    'assets/images/icons/serviceEsp.png',
    'assets/images/icons/montoEsp.png',
    'assets/images/icons/gananciaBar.png',
    'assets/images/icons/gananciaTot.png',
    'assets/images/icons/clientesAten.png',
    'assets/images/icons/seleccionado.png',
    'assets/images/icons/aleatorio.png',
  ];
  // Define el año inicial y el año actual
  final int initialYear = 2020;
  final int currentYear = DateTime.now().year;
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    final List<String> _months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    int i = 0;
    return GetBuilder<StatisticController>(builder: (controllerStat) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                //todo aqui comente el que estaba

                Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 12),
                  child: Container(
                    width: (MediaQuery.of(context).size.width * 0.95),
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(60, 196, 194, 194),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Dropdown para seleccionar el mes
                            // Dropdown para seleccionar el mes
                            DropdownButton<int>(
                              value: _selectedMonth,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedMonth = newValue!;
                                });
                              },
                              items: List<DropdownMenuItem<int>>.generate(12,
                                  (int index) {
                                print('_selectedMonth:$index');
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text(_months[index]),
                                );
                              }),
                            ),
                            //
                            //
                            //
                            // Dropdown para seleccionar el año
                            DropdownButton<int>(
                              value: _selectedYear,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedYear = newValue!;
                                });
                              },
                              items: List<DropdownMenuItem<int>>.generate(
                                  currentYear - initialYear + 1, (int index) {
                                return DropdownMenuItem<int>(
                                  value: initialYear + index,
                                  child: Text('${initialYear + index}'),
                                );
                              }),
                            ),

                            //
                            //
                            //
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();

                                  await controllerStatistic.getDataStatisticMen(
                                      _selectedMonth, _selectedYear);
                                  mesEscogido =
                                      '${_months[_selectedMonth - 1]} del $_selectedYear';
                                  Get.back();
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(horizontal: 30),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF4470F3)),
                                  // MaterialStateProperty.all<Color>(Color(0xFF4470F3)),
                                ),
                                child: const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        'VER',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                controllerStat.statisticsGeneralMen.isEmpty
                    ? SizedBox(
                        height: 540,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Icon(
                              Icons.bar_chart_outlined,
                              size: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (mesEscogido != null) ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'No tiene Estadísticas ',
                                    ),
                                    Text(
                                      'en el mes de  ($mesEscogido) ',
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'No tiene Estadísticas hasta el momento',
                                ),
                              )
                            ]
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 540,
                              width: (MediaQuery.of(context).size.width * 0.95),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 12, top: 4, left: 12, bottom: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: controllerStat
                                      .statisticsGeneralMen.entries
                                      .map((entry) {
                                    i++;

                                    print(i);

                                    return SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              0.035),
                                      width:
                                          (MediaQuery.of(context).size.width *
                                              0.95),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: Image(
                                                  image: AssetImage(
                                                    direcc[i < 13
                                                        ? i
                                                        : (i = 1) - 1],
                                                  ),
                                                  color:
                                                      const Color(0xFFFDAE2A),
                                                  width: 18,
                                                  height: 18,
                                                ),
                                              ),
                                              Text(entry.key,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ],
                                          ),
                                          Text(
                                            entry.value == null
                                                ? '0'
                                                : '${entry.value}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  int currentStep = 0;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController textContDate = TextEditingController();
  DateTime?
      startDate; // Variable para almacenar la fecha de inicio del rango seleccionado
  var startDate1;
  var mesEscogido;
  var endDate1;
  DateTime? endDate;
  DateTime? auxDate;
  DateTime?
      _rangeAuxDay; // Variable para almacenar la fecha de fin del rango seleccionado
  final DateTime _startDate = DateTime.now();
  final DateTime _endDate = DateTime.now();
}
