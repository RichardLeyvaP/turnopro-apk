import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class StadisticaSemCordi extends StatefulWidget {
  const StadisticaSemCordi({super.key});

  @override
  State<StadisticaSemCordi> createState() => _StadisticaSemCordiState();
}

class _StadisticaSemCordiState extends State<StadisticaSemCordi> {
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
                            controllerStat.dateRange == ''
                                ? '  seleccione una fecha'
                                : dateActual == controllerStat.dateRange
                                    ? '   Seleccione una semana'
                                    : controllerStat.dateRange,
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

            const SizedBox(
              height: 10,
            ),
            controllerStat.statisticsGeneralRespon.isEmpty
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
                        if (startDate1 != null && endDate1 != null) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No tiene Estadísticas en la semana seleccionada de  ($startDate1 - $endDate1)',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No tiene Estadísticas en la semana seleccionada de $dateAct',
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
                          children: controllerStat
                              .statisticsGeneralRespon.entries
                              .map((entry) {
                            i++;

                            print(i);

                            return Column(
                              children: [
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
                                  child: entry.key != 'Producto mas Vendido' &&
                                          entry.key != 'Servicio mas Brindado'
                                      ? listTitleRow(i, entry, context)
                                      : listTitleColumn(i, entry, context),
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

  ListTile listTitleRow(
      int i, MapEntry<String, dynamic> entry, BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Agrega un contenedor para alinear el icono al centro verticalmente
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage(
                  direcc[i < 13 ? i : (i = 1) - 1],
                ),
                color: const Color.fromARGB(255, 3, 44, 97),
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
          entry.value == null ? '0' : '${entry.value}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  ListTile listTitleColumn(
      int i, MapEntry<String, dynamic> entry, BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Agrega un contenedor para alinear el icono al centro verticalmente
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 30),
              child: Image(
                image: AssetImage(
                  direcc[i < 13 ? i : (i = 1) - 1],
                ),
                color: const Color.fromARGB(255, 3, 44, 97),
                width: 35,
                height: 35,
              ),
            ),
            Column(
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  entry.value == null ? '0' : '${entry.value}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      subtitle: null,
      trailing: null,
    );
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
                                      Navigator.of(context).pop();
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
                                      Navigator.of(context).pop();
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
                                startDate1, endDate1, 1, 7, mes, year);

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
