import 'package:flutter/material.dart';

class ExerciseGoalsCard extends StatelessWidget {
  final int goalSteps;
  final int todayTotalSteps;

  ExerciseGoalsCard({
    required this.goalSteps,
    required this.todayTotalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = (todayTotalSteps / goalSteps) * 100;

    return Card(
      color: Color.fromRGBO(0, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise Goals 锻炼目标',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Today\'s Steps',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$todayTotalSteps',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Goal Steps',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$goalSteps',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Progress 完成情况: ${progressPercentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
