import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pu_frontend/models/excercise.dart';

class ExcerciseHistoryChart extends StatefulWidget {
  const ExcerciseHistoryChart(this.logs, this.excerciseIsCardio, {super.key});
  final List<Log> logs;
  final bool excerciseIsCardio;

  @override
  State<ExcerciseHistoryChart> createState() => _ExcerciseHistoryChartState();
}

class _ExcerciseHistoryChartState extends State<ExcerciseHistoryChart> {
  final Map<String, MaterialColor> colors = {
    'contentColorCyan': Colors.cyan,
    'contentColorBlue': Colors.blue,
  };

  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      // Can be changed to add grid data, is however a pain in the A
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(
            widget.excerciseIsCardio ? 'Avg Speed km/h' : 'Weight Kg',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: _getInterval(),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: _getSpotsFromData().length.toDouble() - 1,
      minY: 0,
      maxY: _roundToNearestTen(
          _getPersonalBest(widget.logs, widget.excerciseIsCardio)!.toDouble() *
              1.2),
      lineBarsData: [
        LineChartBarData(
          spots: _getSpotsFromData(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpotsFromData() {
    if (widget.excerciseIsCardio) {
      final spots = <FlSpot>[];
      for (int i = 0; i < widget.logs.length; i++) {
        spots.add(FlSpot((widget.logs.length - 1 - i.toDouble()),
            (_getSpeed(widget.logs[i]))));
      }
      return spots;
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < widget.logs.length; i++) {
      spots.add(FlSpot((widget.logs.length - 1 - i.toDouble()),
          widget.logs[i].weight!.toDouble()));
    }
    return spots;
  }

  double _getSpeed(Log log) {
    if (log.distance == 0 || log.duration == 0) return 0;

    return log.distance! / log.duration! * 3600 / 60;
  }

  int? _getPersonalBest(List<Log> logs, bool excerciseIsCardio) {
    return excerciseIsCardio
        ? _getSpeed(logs.reduce((curr, next) =>
            _getSpeed(curr) > _getSpeed(next) ? curr : next)).toInt()
        : logs
            .reduce((curr, next) => curr.weight! > next.weight! ? curr : next)
            .weight;
  }

  double _roundToNearestTen(double number) {
    return (number / 10).round() * 10;
  }

  double _getInterval() {
    double pb = _roundToNearestTen(
        _getPersonalBest(widget.logs, widget.excerciseIsCardio)!.toDouble());

    if (pb == 0) {
      return 1;
    }

    return pb / 10;
  }
}
