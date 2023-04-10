import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity.dart';

class ActivityHistoryCard extends StatelessWidget {
  final List<Activity> activities;

  ActivityHistoryCard({required this.activities});

  List<BarChartGroupData> _generateChartData() {
    List<BarChartGroupData> chartData = [];

    for (int i = 0; i < activities.length; i++) {
      chartData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                y: activities[i].activeTime.toDouble(),
                colors: [Colors.green]),
            BarChartRodData(
                y: activities[i].sleepTime.toDouble(), colors: [Colors.blue]),
          ],
        ),
      );
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  Activity History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('  Green: Active Time, Blue: Sleep Time'),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _generateChartData(),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (BuildContext context, double value) =>
                          const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Mon';
                          case 1:
                            return 'Tue';
                          case 2:
                            return 'Wed';
                          case 3:
                            return 'Thu';
                          case 4:
                            return 'Fri';
                          case 5:
                            return 'Sat';
                          case 6:
                            return 'Sun';
                          default:
                            return '';
                        }
                      },
                      margin: 8,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (BuildContext context, double value) =>
                          const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      interval: 2,
                      reservedSize: 20,
                    ),
                  ),
                  gridData: FlGridData(
                      drawVerticalLine: false, drawHorizontalLine: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
