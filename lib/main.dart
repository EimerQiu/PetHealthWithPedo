import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trasense/trasense.dart';
import 'package:trasense_demo/widgets/exercise_goals_card.dart';

import 'models/pet.dart';
import 'models/pet_steps_hive.dart';
import 'models/activity.dart';
import 'widgets/pet_info_card.dart';
import 'widgets/activity_history_card.dart';
import 'widgets/nutrition_tracking_card.dart';
import 'widgets/hydration_monitoring_card.dart';
import 'widgets/hive_records_screen.dart';
import 'repositories/pet_steps_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final petStepsRepo = PetStepsRepository();

  runApp(MyApp(petStepsRepo: petStepsRepo));
}

class MyApp extends StatefulWidget {
  final PetStepsRepository petStepsRepo;

  const MyApp({Key? key, required this.petStepsRepo}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState(petStepsRepo: petStepsRepo);
}

class _MyAppState extends State<MyApp> {
  final PetStepsRepository petStepsRepo;

  _MyAppState({required this.petStepsRepo});

  final String _modelName = 'S6';

  final String _macAddress1 = 'D45B8D9572EB';
  final String _macAddress2 = 'C3E17417B4CD';
  final String _macAddress3 = 'CA6E5E7D70BA';

  TrasenseDevice? _device;

  String _deviceId = '';
  String _version = '';
  String _status = '';
  String _rawSignal = '';

  bool _connected1 = false;

  bool _gyroAccStreaming = false;

  Timer? _vitalTimer;
  StreamSubscription? _connectionStreamSubscription;
  StreamSubscription? _dataStreamSubscription;
  StreamSubscription? _rawSignalStreamSubscription;

  List<GyroDatum> _gyroData = [];
  List<AccDatum> _accData = [];

  Pipeline? pipeline;

  ChartSeriesController? _chartSeriesController;

  final Pet pet =
      Pet(name: 'Candy', sex: 'Female', age: 7, type: 'Labrador', weight: 30.0);

final List<Activity> activities = [
  Activity(
      date: DateTime.now().subtract(Duration(days: 1)),
      steps: 3000,
      activeTime: 8,
      sleepTime: 16,
      calories: 1102,
      weight: 30.0,
      hydration: 800),
  Activity(
      date: DateTime.now().subtract(Duration(days: 2)),
      steps: 3500,
      activeTime: 9,
      sleepTime: 15,
      calories: 1200,
      weight: 30.5,
      hydration: 896),
  Activity(
      date: DateTime.now().subtract(Duration(days: 3)),
      steps: 3000,
      activeTime: 7,
      sleepTime: 17,
      calories: 1349,
      weight: 30.0,
      hydration: 783),
  Activity(
      date: DateTime.now().subtract(Duration(days: 4)),
      steps: 3500,
      activeTime: 10,
      sleepTime: 14,
      calories: 1020,
      weight: 30.5,
      hydration: 1092),
  Activity(
      date: DateTime.now().subtract(Duration(days: 5)),
      steps: 3500,
      activeTime: 6,
      sleepTime: 18,
      calories: 1200,
      weight: 30.5,
      hydration: 901),
  Activity(
      date: DateTime.now().subtract(Duration(days: 6)),
      steps: 3500,
      activeTime: 10,
      sleepTime: 14,
      calories: 1350,
      weight: 30.5,
      hydration: 1036),
  Activity(
      date: DateTime.now().subtract(Duration(days: 7)),
      steps: 3500,
      activeTime: 8,
      sleepTime: 16,
      calories: 600,
      weight: 30.5,
      hydration: 849),
];

  // Add the navigation method
  void _navigateToHiveRecordsScreen(BuildContext context) {
    debugPrint("_navigateToHiveRecordsScreen");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HiveRecordsScreen(),
      ),
    );
  }

  final _timerDuration = Duration(seconds: 10);
  int _todayTotalSteps = 0;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _vitalTimer?.cancel();
    _dataStreamSubscription?.cancel();
    _connectionStreamSubscription?.cancel();
    _rawSignalStreamSubscription?.cancel();

    _device = null;
  }

  Future<void> _initialize() async {
    _connected1 = false;

    _deviceId = '';
    _version = '';
    _status = '';
    _rawSignal = '';

    _gyroAccStreaming = false;

    _gyroData = [];
    _accData = [];

    _todayTotalSteps = await calculateTodayInitSteps();

    setState(() {});
  }

  void _listenToConnection() {
    debugPrint('_listenToConnection: connection stream set.......');

    _connectionStreamSubscription =
        _device?.connectionStream?.listen((event) async {
      Map<String, dynamic> result = Map.from(event);

      setState(() {
        _status = result['type'];
      });

      if (_status == 'Enabled') {
        debugPrint('_listenToConnection: $_modelName is enabled !!!!!!!!!!!!!');

        setState(() {
          _deviceId = result['macAddress'];
          _connected1 = true;
        });

        await _device?.getVersion().then((value) {
          setState(() {
            _version = value ?? 'N/A';
          });
        });

        if (!_gyroAccStreaming) {
          debugPrint(
              "_listenToConnection: stopRawSignalStreaming - startRawSignalStreaming....");
          await _device?.stopRawSignalStreaming();
          _listenToRawSignal();
          await _device
              ?.startRawSignalStreaming(DeviceStreamingFeature.gyroAccCombined);
          _gyroAccStreaming = true;
        }
      }
    });
  }

  void _cancelConnection() {
    _connectionStreamSubscription?.cancel();
    _rawSignalStreamSubscription?.cancel();
    _dataStreamSubscription?.cancel();
    _stopVitalsTimer();

    _initialize();
  }

  void _listenToRawSignal() {
    int countTimes = 0;
    debugPrint('raw signal stream set for $_macAddress1!');

    _rawSignalStreamSubscription = _device?.rawSignalStream?.listen((event) {
      TrasenseDatum? signal;

      if (event["type"] == DeviceStreamingFeature.gyroAccCombined.name) {
        try {
          signal = TrasenseGyroAccCombinedDatum.fromJson(event);

          setState(() {
            _gyroAccStreaming = true;
          });
        } catch (e) {
          // log('error: $e');
        }
      }

      if (signal != null && _device?.macAddress == signal.macAddress) {
        // log('signal type: ${signal.type}');
        if (signal.type == DeviceStreamingFeature.gyroAccCombined.name) {
          /// Gyro and Acc data
          _gyroData.add((signal as TrasenseGyroAccCombinedDatum).gyro);
          _accData.add(signal.acc);

          // debugPrint('acc: ${signal.acc}');

          if (_gyroData.length == 50) {
            // Removes the last index data of data source.
            _gyroData.removeAt(0);
            _accData.removeAt(0);

            // Here calling updateDataSource method with addedDataIndexes to
            // add data in last index and removedDataIndexes to remove data
            //from the last.
            _chartSeriesController?.updateDataSource(
                addedDataIndexes: <int>[_gyroData.length - 1],
                removedDataIndexes: <int>[0]);

            // save to Hive every 2 seconds
            countTimes++;
            debugPrint("_listenToRawSignal: countTimes = $countTimes");
            if (countTimes % 50 == 0) {
              saveStepsHive();
            }
          }
        }
      }

      _rawSignal = '${signal?.value.length}';

      setState(() {});
    });
  }

  void _cancelRawSignal() {
    _rawSignalStreamSubscription?.cancel();

    setState(() {
      _rawSignal = '';
    });
  }

  Future<int> calculateTodayInitSteps() async {
    int todaySteps = 0;

    try {
      List<PetStepsHive> records = await petStepsRepo.readStepsRecords();

      DateTime now = DateTime.now();
      DateTime todayStart = DateTime(now.year, now.month, now.day);

      for (PetStepsHive record in records) {
        DateTime recordTime =
            DateTime.fromMillisecondsSinceEpoch(record.timestamp);
        if (recordTime.isAfter(todayStart)) {
          todaySteps += record.steps;
        }
      }
    } catch (e) {
      debugPrint(
          'calculateTodayInitSteps: Error while calculating today steps: $e');
    }

    debugPrint("calculateTodayInitSteps done: $todaySteps");
    return todaySteps;
  }

  Future<void> saveStepsHive() async {
    try {
      String accDataString = stringSteps();
      int steps = await countPetSteps(accDataString);
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final petStepsRepo = PetStepsRepository();
      await petStepsRepo.saveRecord(steps, timestamp, accDataString);

      _todayTotalSteps += steps;

      debugPrint(
          "saveStepsHive ${steps} ${timestamp} done, _todayTotalSteps = $_todayTotalSteps");
    } catch (e) {
      debugPrint('saveStepsHive: Error while recording steps: $e');
    }
    setState(() {});
  }

  String stringSteps() {
    String accDataString = '';
    for (AccDatum accDatum in _accData) {
      accDataString += '${accDatum.x},${accDatum.y},${accDatum.z};';
    }
    return accDataString;
  }

  Future<int> countPetSteps(String accDataString) async {
    int petSteps = 0;

    debugPrint("countPetSteps from string $accDataString");

    final user = User(gender: 'female', height: 60, stride: 30);
    final trial = Trial(name: 'foobar1', rate: 100);
    final pipeline = Pipeline.run(accDataString, user, trial);

    petSteps = pipeline.analyzer!.steps!;
    debugPrint("countPetSteps done! return steps = $petSteps");

    return petSteps;
  }

  void _startVitalsTimer() {
    _vitalTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _device?.getVitalSigns();
    });
  }

  void _stopVitalsTimer() {
    _vitalTimer?.cancel();
  }

  Widget _buildGyroChart(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SfCartesianChart(
          title: ChartTitle(
              text: 'Gyro Realtime', textStyle: const TextStyle(fontSize: 12)),
          enableAxisAnimation: true,
          legend: Legend(
              isVisible: true,
              // toggleSeriesVisibility: true,
              position: LegendPosition.right),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          series: <SplineSeries<GyroDatum, DateTime>>[
            SplineSeries<GyroDatum, DateTime>(
              onRendererCreated: (controller) =>
                  _chartSeriesController = controller,
              name: 'x',
              color: Colors.blueGrey,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _gyroData,
              xValueMapper: (data, _) => data.timestamp,
              yValueMapper: (data, _) => data.x,
            ),
            SplineSeries<GyroDatum, DateTime>(
              onRendererCreated: (controller) =>
                  _chartSeriesController = controller,
              name: 'y',
              color: Colors.lightGreen,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _gyroData,
              xValueMapper: (data, _) => data.timestamp,
              yValueMapper: (data, _) => data.y,
            ),
            SplineSeries<GyroDatum, DateTime>(
              onRendererCreated: (controller) =>
                  _chartSeriesController = controller,
              name: 'z',
              color: Colors.amber,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _gyroData,
              xValueMapper: (data, _) => data.timestamp,
              yValueMapper: (data, _) => data.z,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccChart(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SfCartesianChart(
          title: ChartTitle(
              text: 'ACC Realtime', textStyle: const TextStyle(fontSize: 12)),
          legend: Legend(
              isVisible: true,
              // toggleSeriesVisibility: true,
              position: LegendPosition.right),
          enableAxisAnimation: true,
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          series: <SplineSeries<AccDatum, DateTime>>[
            SplineSeries<AccDatum, DateTime>(
              onRendererCreated: (controller) =>
                  _chartSeriesController = controller,
              name: 'x',
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _accData,
              xValueMapper: (data, _) => data.timestamp,
              yValueMapper: (data, _) => data.x,
            ),
            SplineSeries<AccDatum, DateTime>(
              onRendererCreated: (controller) =>
                  _chartSeriesController = controller,
              name: 'y',
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _accData,
              xValueMapper: (data, _) => data.timestamp,
              yValueMapper: (data, _) => data.y,
            ),
            SplineSeries<AccDatum, DateTime>(
              onRendererCreated: (controller) =>
                  _chartSeriesController = controller,
              name: 'z',
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: _accData,
              xValueMapper: (data, _) => data.timestamp,
              yValueMapper: (data, _) => data.z,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceButtons(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                if (_connected1) {
                  debugPrint("disconnect onPressed");
                  _cancelRawSignal();
                  _device?.stopRawSignalStreaming();
                  _device?.disconnect();
                  _cancelConnection();
                } else {
                  _device = TrasenseDevice(
                    modelName: _modelName,
                    macAddress: RegExp(r'.{2}')
                        .allMatches(_macAddress1)
                        .map((e) => e.group(0))
                        .join(':'),
                  );

                  _listenToConnection();
                  await _device?.connect();
                }
              },
              child: _connected1
                  ? const Text('Disonnect',
                      style: TextStyle(fontSize: 14, color: Colors.red))
                  : Text('${_macAddress1}',
                      style: const TextStyle(fontSize: 14))),
        ]);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetHealth Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Pet Health Dashboard 爱你的宠物',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  PetInfoCard(pet: pet),
                  ExerciseGoalsCard(
                      todayTotalSteps: _todayTotalSteps, goalSteps: 3000),
                  Card(
                    margin: EdgeInsets.all(5.0),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Connect Bluetooth'),
                                    _buildDeviceButtons(context),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Device: $_deviceId'),
                                    Text('Status: $_status'),
                                    Text('Version: $_version'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildGyroChart(context),
                          const SizedBox(height: 10),
                          _buildAccChart(context),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  ActivityHistoryCard(activities: activities),
                  NutritionTrackingCard(activities: activities),
                  HydrationMonitoringCard(activities: activities),
                  const SizedBox(height: 30),
                  const Text(
                      'This demo app is supported by the following party:'),
                  const Text('(C) 2023 Popular Health, LLC'),
                  const SizedBox(height: 30),
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: () => _navigateToHiveRecordsScreen(context),
                        child: Text('View Hive Records'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
