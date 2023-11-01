// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Views/stadisticaDiaPageNueva.dart';
import 'package:turnopro_apk/Views/stadisticaMesPageNueva.dart';
import 'package:turnopro_apk/Views/stadisticaPageNueva.dart';
import 'package:turnopro_apk/Views/utilCalendar.dart';
//import 'package:turnopro_apk/Views/products-services/services/servicesBody.dart';
import '../../Components/BottomNavigationBar.dart';
//import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //final ServiceController controller = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    const pilateColor = Colors.white;
    List<String> description = ['Ganancia Total', 'Promedio Diario'];
    List<int> cant$ = [255000, 41000];
    // const cyclingColor = Color.fromARGB(255, 68, 135, 211);
    // const quickWorkoutColor = Color(0xFFF18254);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.012)),
          child: BottomNavigationBarNew(),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF18254), // Color de fondo del AppBar
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
                  Get.back();
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
                  labelColor: const Color(0xFFF18254),
                  unselectedLabelColor: Colors.white,
                  automaticIndicatorColorAdjustment: false,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Diario'),
                    Tab(text: 'Semananal'),
                    Tab(text: 'Mensual'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const LineChartSample2(),
            SingleChildScrollView(
              child: Column(
                children: [
                  const BarChartSample6(),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.8),
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
                                const Text(
                                  '16 oct - 22 oct',
                                  style: TextStyle(
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
                  SizedBox(
                    height: 135,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CartOption(
                              color: pilateColor,
                              icon: Icon(
                                MdiIcons.cash,
                              ),
                              number: cant$,
                              description: description),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const LineChartSample5(),
          ],
        ), // Muestra el AlertDialog
      ),
    );
  }
}

class CartOption extends StatelessWidget {
  const CartOption({
    super.key,
    required this.color,
    required this.icon,
    required this.number,
    required this.description,
  });

  final Color color;
  final Icon icon;
  final List<int> number;
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
                  '${number[0]}',
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
                  '${number[1]}',
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: const Text('Confirmación'),
      content: SizedBox(
        height: 150, // Ajusta la altura según tu necesidad
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Establece el tamaño mínimo
            children: [
              TableCalendar(
                rangeStartDay: DateTime(
                    2022), //todo aqui la fecha que el profesional empezo a trabajar

                /*  calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (DateTime date) {
                  // Deshabilita la selección de días individuales
                  return false;
                },*/
                // Asigna el controlador
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    weekdayStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
                ),
                locale: 'es',
                calendarStyle: const CalendarStyle(
                    // Ajusta el tamaño de fuente de los días de la semana
                    weekendTextStyle: TextStyle(
                        fontSize:
                            14), // Ajusta el tamaño de fuente de los fines de semana

                    todayTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight
                            .w700) // Ajusta el tamaño de fuente de días fuera del mes
                    ),
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                //todo con esto selecciona un dia esn es pecifico
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },

                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      print('eeeeeeeeeeeeeeeeeeeeeee');
                      print(_focusedDay);
                      print(_selectedDay);
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cerrar el AlertDialog
            Navigator.of(context).pop();
          },
          child: const Text('Aceptar'),
        ),
        TextButton(
          onPressed: () {
            // Cerrar el AlertDialog
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
