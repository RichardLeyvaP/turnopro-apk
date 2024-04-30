import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class StadisticaSemRespon extends StatefulWidget {
  const StadisticaSemRespon({super.key});

  @override
  State<StadisticaSemRespon> createState() => _StadisticaSemResponState();
}

final CoexistenceController coexCont = Get.find<CoexistenceController>();

class _StadisticaSemResponState extends State<StadisticaSemRespon> {
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
  @override
  Widget build(BuildContext context) {
    //ASIGNANDO LA FECHA ACTUAL
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateAct = formatter.format(now);
    String dateActual = '   $dateAct  -  $dateAct';
    print(dateActual);

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
                        onTap: () {
                          _showCalendarModal(context, textContDate);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.calendarBlank,
                                  color: const Color.fromARGB(130, 0, 0, 0),
                                ),
                                Text(
                                  controllerStat.dateRangeSem == ''
                                      ? '  seleccione una fecha'
                                      : dateActual ==
                                              controllerStat.dateRangeSem
                                          ? '   Seleccione una semana'
                                          : controllerStat.dateRangeSem,
                                  style: const TextStyle(
                                      color: Color.fromARGB(130, 0, 0, 0)),
                                ),
                              ],
                            ),
                            Icon(
                              MdiIcons.arrowDownThin,
                              color: const Color.fromARGB(130, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                controllerStat.statisticsGeneralRespon2.isEmpty
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
                            if (startDate1 != null && endDate1 != null) ...[
                              Text(
                                'No tiene Estadísticas en',
                              ),
                              Text(
                                '($startDate1 - $endDate1)',
                              ),
                            ] else ...[
                              Text(
                                'No tiene Estadísticas en',
                              ),
                              Text(
                                ' $dateAct',
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
                                      .statisticsGeneralRespon2.entries
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
  DateTime? startDate = DateTime(1990, 1,
      1); // Variable para almacenar la fecha de inicio del rango seleccionado
  var startDate1;
  var endDate1;
  DateTime? endDate;
  DateTime? auxDate;
  DateTime?
      _rangeAuxDay; // Variable para almacenar la fecha de fin del rango seleccionado
  final DateTime _startDate = DateTime(1990, 1, 1);
  final DateTime _endDate = DateTime.now();
  //
  //
  //
  // Define el año inicial y el año actual
  final int initialYear =
      1990; //aqui el año en que el se registro en la empresa
  int _selectedYear = DateTime.now().year;
  final int currentYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
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

  Widget _buildTextFieldCalendar(
      String labelText, TextEditingController tEcontroller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        readOnly: true,
        controller: tEcontroller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          _showCalendarModal(context, tEcontroller);
        },
      ),
    );
  }

  Future<void> _showCalendarModal(
      BuildContext context, TextEditingController tController) async {
    final StatisticController controllerStatistic =
        Get.find<StatisticController>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      onHeaderTapped: (focusedDay) {
                        print('_selectedMonth::$focusedDay');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Seleccione mes y/o año'),
                              content: Row(
                                children: [
                                  DropdownButton<int>(
                                    value: _selectedMonth,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        _selectedMonth = newValue!;
                                        var yearAct = DateTime.now().year;
                                        var monthAct = DateTime.now().month;
                                        print('rtrt yearAct:$yearAct');
                                        print('rtrt monthAct:$monthAct');
                                        print(
                                            'rtrt _selectedMonth:$_selectedMonth');
                                        if (_selectedYear >= yearAct) {
                                          if (_selectedMonth > monthAct) {
                                            showDialog(
                                              context:
                                                  context, // Necesitas pasar el contexto actual
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Mensaje'),
                                                  content: Text(
                                                      'La fecha seleccionada no puede ser mayor que la fecha actual.'),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Cierra el AlertDialog
                                                      },
                                                      child: Text('Aceptar'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            _focusedDay = DateTime(
                                                _selectedYear,
                                                _selectedMonth,
                                                1);
                                          }
                                        } else {
                                          _focusedDay = DateTime(
                                              _selectedYear, _selectedMonth, 1);
                                        }
                                      });
                                    },
                                    items: List<DropdownMenuItem<int>>.generate(
                                        12, (int index) {
                                      print('_selectedMonth:$index');
                                      return DropdownMenuItem<int>(
                                        value: index + 1,
                                        child: Text(_months[index]),
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  DropdownButton<int>(
                                    value: _selectedYear,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        _selectedYear = newValue!;
                                        _focusedDay =
                                            DateTime(_selectedYear, 1, 1);
                                      });
                                    },
                                    items: List<DropdownMenuItem<int>>.generate(
                                        currentYear - initialYear + 1,
                                        (int index) {
                                      return DropdownMenuItem<int>(
                                        value: initialYear + index,
                                        child: Center(
                                            child:
                                                Text('${initialYear + index}')),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onHeaderLongPressed: (focusedDay) {
                        // print('_selectedMonth::$focusedDay');
                      },
                      locale: 'es_ES',
                      calendarFormat: _calendarFormat,
                      focusedDay: _focusedDay,
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                      firstDay: DateTime(1900, 1,
                          1), //fecha de registro en la empresa del barbero
                      lastDay: DateTime.now(),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      rangeStartDay: startDate,
                      rangeEndDay: endDate,
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            color: const Color.fromARGB(255, 43, 44, 49),
                            fontSize: 12),
                        weekendStyle: TextStyle(
                            color: const Color.fromARGB(255, 43, 44, 49),
                            fontSize: 12),
                      ),
                      // availableCalendarFormats: const {
                      //   CalendarFormat.month: 'Mes',
                      // },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            const Color.fromARGB(255, 43, 44, 49),
                          )),
                          onPressed: () {
                            setState(() {
                              startDate = null;
                              endDate = null;
                              auxDate = null;
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            const Color.fromARGB(255, 43, 44, 49),
                          )),
                          onPressed: () async {
                            // Obtener el primer día de la semana
                            DateTime firstDayOfWeek = _focusedDay.subtract(
                                Duration(
                                    days:
                                        _focusedDay.weekday - DateTime.monday));
                            firstDayOfWeek =
                                firstDayOfWeek.subtract(Duration(days: 1));

                            // Obtener el último día de la semana
                            DateTime lastDayOfWeek = _focusedDay.add(Duration(
                                days: DateTime.daysPerWeek -
                                    _focusedDay.weekday));
                            lastDayOfWeek =
                                lastDayOfWeek.subtract(Duration(days: 1));

                            // Imprimir los resultados para verificar
                            print(
                                'rtrt Primer día de la semana: ${firstDayOfWeek}');
                            print(
                                'rtrt Último día de la semana: $lastDayOfWeek');

                            final formatterDate = DateFormat('yyyy-MM-dd');

                            startDate1 = formatterDate.format(firstDayOfWeek);
                            endDate1 = formatterDate.format(lastDayOfWeek);

                            int mes = -99;
                            int year = -99;

                            await controllerStatistic.getDataStatisticRespon(
                                2, startDate1, endDate1, 1, 7, mes, year);
                            Navigator.pop(context);

                            // Aquí puedes usar los valores firstDayOfWeek y lastDayOfWeek como desees
                          },
                          child: Text('Seleccionar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
