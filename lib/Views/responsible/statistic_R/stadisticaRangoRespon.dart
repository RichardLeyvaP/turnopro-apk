import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:turnopro_apk/Utility/textTruncate.dart';
import 'package:turnopro_apk/Utility/utils.dart';

class StadisticaRespon extends StatefulWidget {
  const StadisticaRespon({super.key});

  @override
  State<StadisticaRespon> createState() => _StadisticaResponState();
}

final CoexistenceController coexCont = Get.find<CoexistenceController>();

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
                                  controllerStat.dateRangeDia == ''
                                      ? '  seleccione una fecha'
                                      : dateActual ==
                                              controllerStat.dateRangeDia
                                          ? '   Fecha de Hoy- $dateAct'
                                          : controllerStat.dateRangeDia,
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

                controllerStat.statisticsGeneralRespon1.isEmpty
                    ? SizedBox(
                        height: 540,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            const Icon(
                              Icons.bar_chart_outlined,
                              size: 40,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (startDate1 != null && endDate1 != null) ...[
                              const Text(
                                'No tiene Estadísticas el',
                              ),
                              Text(
                                '($startDate1 - $endDate1)',
                              ),
                            ] else ...[
                              const Text(
                                'No tiene Estadísticas el',
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
                                      .statisticsGeneralRespon1.entries
                                      .map((entry) {
                                    i++;
                                    String productServ = entry.key.toString();
                                    String resultValue = entry.value.toString();

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
                                          (productServ ==
                                                      'Producto más Vendido' ||
                                                  productServ ==
                                                      'Servicio más Brindado')
                                              ? TruncatedText(
                                                  text: resultValue,
                                                  maxLength: 13,
                                                  styleText: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ))
                                              : Text(
                                                  entry.value == null
                                                      ? '0'
                                                      : formatNumber(entry.value
                                                          .toString()),
                                                  style: const TextStyle(
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
      isScrollControlled: true,
      //backgroundColor: Colors.transparent,
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
                                          1,
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
