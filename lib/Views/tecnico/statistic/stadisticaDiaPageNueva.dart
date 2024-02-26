import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:turnopro_apk/Controllers/statistics.controller.dart';
import 'package:intl/intl.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BuildCalendar(
                          d: DateTime.now(),
                          m: DateTime.now(),
                          a: DateTime.now(),
                          // totalPrice: controllerShoppingCart.totalPrice,
                        ); // Muestra el AlertDialog
                      },
                    );
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
            controllerStat.statisticsGeneral.isEmpty
                ? const Center(
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/imageGrafic.png'),
                        ),
                        Text(
                          'No tiene estadisticas en esta fecha',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
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
                                              fontSize: 18,
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
    print('intervalo-1 ----:$startDate');
    print('intervalo-2 ----:$endDate');
    await controllerStatistic.getDataStatisticDay(startDate, endDate,
        numberdayWeek, quantityDates); //todo LLAMANDO AL CONTROLADOR DEL DIA
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
          //  SizedBox(
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
