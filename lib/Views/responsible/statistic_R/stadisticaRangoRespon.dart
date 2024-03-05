import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class StadisticaRespon extends StatefulWidget {
  const StadisticaRespon({super.key});

  @override
  State<StadisticaRespon> createState() => _StadisticaResponState();
}

class _StadisticaResponState extends State<StadisticaRespon> {
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
                                    ? '   Fecha de Hoy- $dateAct'
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
                          Text(
                            'No tiene Estadísticas en ($startDate1 - $endDate1)',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ] else ...[
                          Text(
                            'No tiene Estadísticas en $dateAct',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController textContDate = TextEditingController();
  DateTime?
      startDate; // Variable para almacenar la fecha de inicio del rango seleccionado
  var startDate1;
  var endDate1;
  DateTime? endDate;
  DateTime? auxDate;
  DateTime?
      _rangeAuxDay; // Variable para almacenar la fecha de fin del rango seleccionado
  final DateTime _startDate = DateTime.now();
  final DateTime _endDate = DateTime.now();

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
              height: 435,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      locale: 'es_ES',
                      calendarFormat: _calendarFormat,
                      focusedDay: startDate == null ? _focusedDay : startDate!,
                      firstDay: DateTime(2023, 1, 1),
                      lastDay: DateTime(2025, 12, 31),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      rangeStartDay: startDate,
                      rangeEndDay: endDate,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          print('date-* startDate:$startDate');
                          print('date-* endDate:$endDate');

                          if (startDate == null) {
                            startDate = selectedDay;
                          } else if (endDate == null) {
                            if (selectedDay.isBefore(startDate!)) {
                              auxDate = startDate;
                              startDate = selectedDay;
                              endDate = auxDate;
                            } else {
                              endDate = selectedDay;
                            }
                          } else {
                            startDate = selectedDay;
                            endDate = null;
                          }
                          print('date-* ***************');
                          print('date-* 2 startDate:$startDate');
                          print('date-* 2 endDate:$endDate');
                        });
                      },
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle:
                            TextStyle(color: Colors.black, fontSize: 12),
                        weekendStyle:
                            TextStyle(color: Colors.black, fontSize: 12),
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
                        startDate != null && endDate != null
                            ? ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                  const Color.fromARGB(255, 43, 44, 49),
                                )),
                                onPressed: () async {
                                  /*  String formattedStartDate = DateFormat('yyyy-MM-dd')
                                .format(startDate ?? DateTime.now());
                            String formattedEndDate = DateFormat('yyyy-MM-dd')
                                .format(endDate ?? DateTime.now());
                            print(
                                'Fechas seleccionadas: $formattedStartDate - $formattedEndDate');*/
                                  final formatterDate =
                                      DateFormat('yyyy-MM-dd');

                                  startDate1 = formatterDate.format(startDate!);
                                  endDate1 = formatterDate.format(endDate!);
                                  int numberdayWeek = _startDate.weekday;

                                  Duration diferencia =
                                      _endDate.difference(_startDate);
                                  int quantityDates = diferencia.inDays + 1;

                                  //EN ESTA DEVUELVE LAS GANANCIAS EN ESE INTERVALO DE FECHAS
                                  print('intervalo-1 ----:$startDate1');
                                  print('intervalo-2 ----:$endDate1');
                                  print(
                                      'intervalo-quantityDates ----:$quantityDates');
                                  print(
                                      'intervalo-numberdayWeek ----:$numberdayWeek');
                                  int mes = -99;
                                  int year = -99;

                                  await controllerStatistic
                                      .getDataStatisticRespon(
                                          startDate1,
                                          endDate1,
                                          numberdayWeek,
                                          quantityDates,
                                          mes,
                                          year);
                                  Navigator.pop(context);
                                },
                                child: Text('Seleccionar'),
                              )
                            : ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(60, 0, 0, 0),
                                )),
                                onPressed: () => null,
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
