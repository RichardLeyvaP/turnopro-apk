import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/coexistence.controller.dart';
import 'package:turnopro_apk/Utility/utils.dart';

class StadisticaMensualPageNueva extends StatefulWidget {
  const StadisticaMensualPageNueva({Key? key}) : super(key: key);

  @override
  _StadisticaMensualPageNuevaState createState() =>
      _StadisticaMensualPageNuevaState();
}

class _StadisticaMensualPageNuevaState
    extends State<StadisticaMensualPageNueva> {
  _StadisticaMensualPageNuevaState();

  @override
  void dispose() {
    super.dispose();
  }

  final CoexistenceController cControll = Get.find<CoexistenceController>();

  Color buttonColor = const Color(0xFF4470F3); // Color inicial del botón

  void _changeColor() {
    setState(() {
      buttonColor = (buttonColor == const Color(0xFF4470F3))
          ? Colors.green
          : const Color(0xFF4470F3);
    });
  }

  /// Builds the widget that is the home page state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: GetBuilder<CoexistenceController>(builder: (_) {
            return Column(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.068),
                              width: MediaQuery.of(context).size.width * 0.48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDAE2A),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Promedio',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                    Text(_.averageEarnings,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.068),
                              width: MediaQuery.of(context).size.width * 0.48,
                              decoration: const BoxDecoration(
                                color: Color(0xFF19CF9E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    const Text('Total Pagado',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Colors.white)),
                                    Text(_.totalEarnings,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        // #### Core chart
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: chartToRun(_),
                        ), // verticalBarChart, lineChart
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: (MediaQuery.of(context).size.height * 0.067),
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: const BoxDecoration(
                        color: Colors.white, // Color de fondo
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.05),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor, // Color de fondo en verde
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Ajusta el radio según tus necesidades
                                  ),
                                ),
                                onPressed: () async {
                                  _changeColor();
                                  // llamar aqui la funcion de cargar la estadistica
                                  Get.dialog(
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFDAE2A),
                                      ),
                                    ),
                                    barrierDismissible: false,
                                  ); //Get.back();
                                  await cControll.getStadistAno(2024);

                                  Get.back();
                                },
                                child: const Center(
                                  child: Text('2024',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Widget chartToRun(CoexistenceController cControll) {


  List<List<double>> dataRows = [];
  double may = 0;

  // Llenar dataRows usando un bucle for
  dataRows.add([]);
  for (double value in cControll.meses) {
    if (value > may) {
      may = value;
    }
    dataRows[0].add(value);

  }


  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions(
    legendOptions: LegendOptions(isLegendContainerShown: false),
    yContainerOptions: YContainerOptions(isYGridlinesShown: true),
    lineChartOptions: LineChartOptions(
        hotspotOuterPaintColor: Color.fromARGB(255, 88, 87, 87),
        hotspotInnerPaintColor: Color(0xFFFDAE2A),
        lineStrokeWidth: 4,
        hotspotInnerRadius: 5,
        hotspotOuterRadius: 7),
    dataContainerOptions: DataContainerOptions(
      gridLinesColor: Color(0xFFFDAE2A),
    ),
  );

  /// Currently, setting [ChartDate.dataRows] requires to also set all of
  /// [chartData.xUserLabels], [chartData.dataRowsLegends], [chartData.dataRowsColors]
  // Fix was: Add default legend to ChartData constructor AND fix scaling util_dart.dart scaleValue.
  List<String> yUser = [
    '0',
    (may / 5).toString(),
    ((may / 5) + (may / 5)).toString(),
    ((may / 5) + (may / 5) + (may / 5)).toString(),
    ((may / 5) + (may / 5) + (may / 5) + (may / 5)).toString(),
    may.toString()
  ];

  chartData = ChartData(
    // yUserLabels: yUser,
    dataRows: dataRows,

    // Note: When ChartData is defined,
    //       ALL OF  xUserLabels,  dataRowsLegends, dataRowsColors
    //       must be set by client
    xUserLabels: const [
      'E',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
    ],

    dataRowsLegends: const [
      'GANACIA MENSUAL',
    ],

    dataRowsColors: const [
      Color(0xFF4470F3),
    ],
    chartOptions: chartOptions,
  );
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );
  return lineChart;
}
