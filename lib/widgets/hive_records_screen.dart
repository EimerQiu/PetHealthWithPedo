// list the steps records storage in Hive

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet_steps_hive.dart'; // Import the DogStepsHive model

class HiveRecordsScreen extends StatefulWidget {
  @override
  _HiveRecordsScreenState createState() => _HiveRecordsScreenState();
}

class _HiveRecordsScreenState extends State<HiveRecordsScreen> {
  ValueListenable<Box<PetStepsHive>> dogStepsListenable() {
    return Hive.box<PetStepsHive>('dogStepsBox').listenable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Steps Records'),
      ),
      body: ValueListenableBuilder<Box<PetStepsHive>>(
        valueListenable: dogStepsListenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final int reversedIndex = box.length - 1 - index;
              final PetStepsHive? record = box.getAt(reversedIndex);

              if (record == null) {
                return ListTile(
                  title: Text('Error: Record not found'),
                );
              }

              final recordText =
                  'Steps: ${record.steps}, Timestamp: ${DateTime.fromMillisecondsSinceEpoch(record.timestamp)}, Raw Data: ${record.rawData}';
              log('Pet Steps Record ${reversedIndex + 1}: ${recordText}');

              return ListTile(
                title: Text('Pet Steps Record ${reversedIndex + 1}'),
                subtitle: SelectableText(recordText),
                onTap: () {
                  // Edit the record or navigate to another screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
