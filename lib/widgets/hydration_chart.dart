import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/activity.dart';

class HydrationChart extends StatelessWidget {
  final List<Activity> activities;

  HydrationChart({required this.activities});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 1200,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              if (value >= 0 && value < activities.length) {
                final weekday = activities[value.toInt()].date.weekday;
                switch (weekday) {
                  case DateTime.monday:
                    return 'Mon';
                  case DateTime.tuesday:
                    return 'Tue';
                  case DateTime.wednesday:
                    return 'Wed';
                  case DateTime.thursday:
                    return 'Thu';
                  case DateTime.friday:
                    return 'Fri';
                  case DateTime.saturday:
                    return 'Sat';
                  case DateTime.sunday:
                    return 'Sun';
                  default:
                    return '';
                }
              } else {
                return '';
              }
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              activities.length,
              (index) => FlSpot(
                index.toDouble(),
                activities[index].hydration.toDouble(),
              ),
            ),
            isCurved: false,
            colors: [Colors.blue],
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
