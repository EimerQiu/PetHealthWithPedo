import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity.dart';

class ActivityHistoryCard extends StatelessWidget {
  final List<Activity> activities;

  ActivityHistoryCard({required this.activities});

  List<BarChartGroupData> _generateChartData() {
    List<BarChartGroupData> chartData = [];

    // Iterate through activities in reverse order
    for (int i = activities.length - 1; i >= 0; i--) {
      chartData.add(
        BarChartGroupData(
          x: activities.length - 1 - i,
          barRods: [
            BarChartRodData(
                y: activities[i].activeTime.toDouble(), colors: [Colors.green]),
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
      color: Color.fromRGBO(0, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  Activity History 一周活动记录',
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
                        color: Colors.white, // Change text color to white,
                        fontSize: 14,
                      ),
                      getTitles: (value) {
                        int index = activities.length - 1 - value.toInt();
                        if (index >= 0 && index < activities.length) {
                          final weekday = activities[index].date.weekday;
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
                      margin: 8,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (BuildContext context, double value) =>
                          const TextStyle(
                        color: Colors.white, // Change text color to white
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
