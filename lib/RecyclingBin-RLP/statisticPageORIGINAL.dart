// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:turnopro_apk/Views/stadisticaDiaPageNueva.dart';
import 'package:turnopro_apk/Views/stadisticaMesPageNueva.dart';
import 'package:turnopro_apk/Views/stadisticaPageNueva.dart';
//import 'package:turnopro_apk/Views/products-services/services/servicesBody.dart';
import '../../Components/BottomNavigationBar.dart';
//import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';

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
    const pilateColor = Color.fromARGB(180, 76, 75, 75);
    const cyclingColor = Color.fromARGB(255, 68, 135, 211);
    const quickWorkoutColor = Color(0xFFF18254);
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
                  const Text('ESTADSTICAS',
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
                    Tab(text: 'Dia'),
                    Tab(text: 'Semana'),
                    Tab(text: 'Mes'),
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
            Column(
              children: [
                BarChartSample6(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 231, 232, 234),
                            Color.fromARGB(255, 243, 182, 138),
                          ],
                          stops: [0.0, 0.8],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                        )),
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
                              number: 12500,
                              description: '8:00am - 10am'),
                          CartOption(
                              color: quickWorkoutColor,
                              icon: Icon(MdiIcons.cashMultiple),
                              number: 25000,
                              description: '10:15am - 1:00pm'),
                          CartOption(
                              color: cyclingColor,
                              icon: Icon(MdiIcons.currencyUsd),
                              number: 45000,
                              description: '2:00pm - 5:00pm'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
  final int number;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text('$number'),
            ],
          ),
          Text(description),
        ],
      ),
    );
  }
}
