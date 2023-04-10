import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity.dart';

class NutritionTrackingCard extends StatelessWidget {
  final List<Activity> activities;

  NutritionTrackingCard({required this.activities});

  List<PieChartSectionData> _generateChartData() {
    final totalCalories =
        activities.fold<int>(0, (total, activity) => total + activity.calories);

    return activities.map((activity) {
      final percentage = (activity.calories / totalCalories) * 100;
      return PieChartSectionData(
        value: percentage,
        color: Colors
            .primaries[activities.indexOf(activity) % Colors.primaries.length],
        title: '${activity.calories} kcal',
        titleStyle: TextStyle(fontSize: 10),
      );
    }).toList();
  }

  double _getAverageWeight() {
    return activities.fold<double>(
            0, (total, activity) => total + activity.weight) /
        activities.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
                'Average Weight: ${_getAverageWeight().toStringAsFixed(2)} kg'),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generateChartData(),
                  sectionsSpace: 4,
                  centerSpaceRadius: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
