import 'package:flutter/material.dart';
import 'hydration_chart.dart';
import '../models/activity.dart';

class HydrationMonitoringCard extends StatelessWidget {
  final List<Activity> activities;

  HydrationMonitoringCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(0, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hydration Monitoring 饮水监测',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: HydrationChart(activities: activities),
            ),
          ],
        ),
      ),
    );
  }
}
