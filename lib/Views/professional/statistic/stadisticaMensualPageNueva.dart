import 'package:get/get.dart';
import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:table_calendar/table_calendar.dart';

class StadisticaMensualPageNueva extends StatefulWidget {
  const StadisticaMensualPageNueva({super.key});

  @override
  State<StadisticaMensualPageNueva> createState() =>
      _StadisticaMensualPageNuevaState();
}

class _StadisticaMensualPageNuevaState
    extends State<StadisticaMensualPageNueva> {
  final StatisticController controllerStatistic =
      Get.find<StatisticController>();
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
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            //todo aqui comente el que estaba

            Container(
              width: (MediaQuery.of(context).size.width * 0.95),
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white,
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
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            const Color.fromARGB(255, 43, 44, 49),
                          )),
                          onPressed: () async {
                            await controllerStatistic.getDataStatisticMen(
                                _selectedMonth, _selectedYear);
                            mesEscogido =
                                '${_months[_selectedMonth - 1]} del $_selectedYear';
                          },
                          child: Text('Ver Estadística'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            controllerStat.statisticsGeneral.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        const Image(
                          image: AssetImage('assets/images/imageGrafic.png'),
                          width: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (mesEscogido != null) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No tiene Estadísticas en el mes de  ($mesEscogido)',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No tiene Estadísticas hasta el momento',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          )
                        ]
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controllerStat.statisticsGeneral.entries
                              .map((entry) {
                            i++;

                            print(i);

                            return Column(
                              children: [
                                //todo1 estructura de los cart
                                Container(
                                  height: (MediaQuery.of(context).size.height *
                                      0.09),
                                  width: (MediaQuery.of(context).size.width *
                                      0.95),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: ListTile(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Agrega un contenedor para alinear el icono al centro verticalmente
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: Image(
                                              image: AssetImage(
                                                direcc[
                                                    i < 13 ? i : (i = 1) - 1],
                                              ),
                                              color: const Color.fromARGB(
                                                  255, 228, 86, 26),
                                              width: 35,
                                              height: 35,
                                            ),
                                          ),
                                          Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: null,
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Text(
                                        '${entry.value}',
                                        style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0279),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
          ],
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
