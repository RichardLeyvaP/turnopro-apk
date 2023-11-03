// ignore_for_file: file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:turnopro_apk/Components/legend_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:turnopro_apk/Controllers/statistic.controller.dart';

class BarChartSample6 extends StatelessWidget {
  BarChartSample6({super.key});

  final StatisticController controllerStatistic =
      Get.find<StatisticController>();

  final pilateColor = const Color.fromARGB(180, 76, 75, 75);
  final cyclingColor = const Color.fromARGB(255, 68, 135, 211);
  final quickWorkoutColor = const Color(0xFFF18254);
  final sexWorkoutColor = Colors.black;

  // final pilateColor = AppColors.contentColorPurple;
  // final cyclingColor = AppColors.contentColorCyan;
  // final quickWorkoutColor = AppColors.contentColorBlue;
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
    double quickWorkout,
    double cycling,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: pilateColor,
          width: 15,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: quickWorkoutColor,
          width: 15,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: cyclingColor,
          width: 15,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'LUN';
        break;
      case 2:
        text = 'MAR';
        break;
      case 3:
        text = 'MIE';
        break;
      case 4:
        text = 'JUE';
        break;
      case 5:
        text = 'VIE';
        break;
      case 6:
        text = 'SAB';
        break;
      case 7:
        text = 'DOM';
        break;
      case 8:
        text = 'LUN';
        break;
      case 9:
        text = 'MAR';
        break;
      case 10:
        text = 'MIE';
        break;
      case 11:
        text = 'JUE';
        break;
      case 12:
        text = 'VIE';
        break;
      case 13:
        text = 'SAB';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: InkWell(
          onTap: () {
            print(text); //todo aqui puedo mostrar la cantidad por dia
          },
          child: Container(
              width: 35,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(text, style: style)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxGanancia = 40000;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ganancias',
            style: TextStyle(
              color: sexWorkoutColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend('Bajo', pilateColor),
              Legend('Medio', quickWorkoutColor),
              Legend('Alto', cyclingColor),
            ],
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.3,
            child: BarChart(
              swapAnimationDuration: const Duration(seconds: 3),
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  // leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      //reservedSize: 5,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  if (controllerStatistic.numberdayWeek != -99099) ...[
                    for (int i = controllerStatistic.numberdayWeek;
                        i <
                            (controllerStatistic.quantityDates +
                                controllerStatistic.numberdayWeek);
                        i++) ...[
                      generateGroupData(
                          i,
                          350 + controllerStatistic.numberdayWeek * 1000,
                          controllerStatistic.numberdayWeek * 100 + 1250,
                          18450)
                    ]
                  ] else ...[
                    //AQUI CARGAR LA SEMANA ACTUAL EN LA QUE ESTA
                    generateGroupData(1, 9200, 10000, 6000),
                    generateGroupData(2, 15000, 10000, 12000),
                    generateGroupData(3, 10000, 11000, 14000),
                    generateGroupData(4, 13000, 8000, 9000),
                    generateGroupData(5, 11500, 2200, 9800),
                    generateGroupData(6, 4350, 9200, 18450),
                    generateGroupData(7, 20000, 10000, 5000),
                  ]

                  // generateGroupData(7, 4350, 9200, 18450),
                  // generateGroupData(8, 4350, 9200, 18450),
                  // generateGroupData(9, 4350, 9200, 18450),
                  // generateGroupData(10, 4350, 9200, 18450),
                ],
                maxY: maxGanancia,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 12500,
                      color: pilateColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: 25000,
                      color: quickWorkoutColor,
                      strokeWidth: 2,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: maxGanancia,
                      color: cyclingColor,
                      strokeWidth: 3,
                      dashArray: [20, 4],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
