import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:turnopro_apk/Components/legend_widget.dart';

class BarChartSample6 extends StatelessWidget {
  const BarChartSample6({super.key});

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
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.w700);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'DOM';
        break;
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
      // case 8:
      //   text = 'SEP';
      //   break;
      // case 9:
      //   text = 'OCT';
      //   break;
      // case 10:
      //   text = 'NOV';
      //   break;
      // case 11:
      //   text = 'DEC';
      //   break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
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
                  generateGroupData(0, 20000, 10000, 5000),
                  generateGroupData(1, 8200, 12000, 5000),
                  generateGroupData(2, 15000, 10000, 12000),
                  generateGroupData(3, 12000, 10000, 16000),
                  generateGroupData(4, 13000, 5000, 11000),
                  generateGroupData(5, 11500, 2200, 9800),
                  generateGroupData(6, 4350, 9200, 18450),
                  // generateGroupData(7, 2.3, 3.2, 3),
                  // generateGroupData(8, 2, 4.8, 2.5),
                  // generateGroupData(9, 1.2, 3.2, 2.5),
                  // generateGroupData(10, 1, 4.8, 3),
                  // generateGroupData(11, 2, 4.4, 2.8),
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
