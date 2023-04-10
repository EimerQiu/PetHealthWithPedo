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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
              'Progress: ${progressPercentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
