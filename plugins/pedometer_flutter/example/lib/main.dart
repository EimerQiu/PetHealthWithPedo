import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:pedometer_flutter/pedometer_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// stream and variables for pedometer
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _pedometerStatus = '?';
  String _pedometerSteps = '?';

  /// stream and variables for sensors_plus
  List<double>? _accelerometerValue;
  List<double>? _userAccelerometerValue;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  /// temporary container for accelerometer data
  List<List<double>> _accelerometerSecondData = [];
  List<List<double>> _userAccelerometerSecondData = [];
  String _accelerometerRecordedData = '';
  String _userAccelerometerRecordedData = '';

  /// periodic timer to process accelerometer data
  Timer? _oneSecondTimer;

  /// variables for pedometer_flutter
  final user = User(gender: 'male', height: 170);
  final trial = Trial(name: 'foobar1');
  String _accStep = '?';

  File? accFile;
  File? userFile;

  @override
  void initState() {
    super.initState();

    /// initialize pedometor of the device
    _initPlatformState();

    /// initialize sensors listeners
    _initSensorListeners();

    initFile();

    _oneSecondTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_accelerometerSecondData.isNotEmpty) {
          // var pipeline = Pipeline.run(
          //     _processUserAccData(_accelerometerSecondData), user, trial);

          // log('total acc sampling rate: ${_accelerometerSecondData.length}, usr acc sampling rate: ${_userAccelerometerSecondData.length}');

          setState(() {
            // _accStep = pipeline.analyzer?.steps?.toString() ?? '?';

            if (_accelerometerSecondData.length == 5 &&
                _userAccelerometerSecondData.length == 5) {
              accFile!.writeAsStringSync(
                  '${_processUserAccData(_accelerometerSecondData)};',
                  mode: FileMode.append);
              userFile!.writeAsStringSync(
                  '${_processUserAccData(_userAccelerometerSecondData)};',
                  mode: FileMode.append);
            }

            _accelerometerSecondData = [];
            _userAccelerometerSecondData = [];
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _oneSecondTimer?.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void initFile() async {
    final directory = await getExternalStorageDirectory();

    final path = directory?.path;
    log('************** $path');

    accFile = File('$path/ACC.txt');
    userFile = File('$path/USER_ACC.txt');
  }

  void onStepCount(StepCount event) {
    log('step count event: ${event.steps}', name: 'example/main');
    setState(() {
      _pedometerSteps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    log('pedestrian status event: ${event.status}', name: 'example/main');
    setState(() {
      _pedometerStatus = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    log('onPedestrianStatusError: $error', name: 'example/main');
    setState(() {
      _pedometerStatus = 'Pedestrian Status not available';
    });
    log(_pedometerStatus);
  }

  void onStepCountError(error) {
    log('onStepCountError: $error', name: 'example/main');
    setState(() {
      _pedometerSteps = 'Step Count not available';
    });
  }

  void _initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void _initSensorListeners() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValue = <double>[event.x, event.y, event.z];
            // log('${DateTime.now().microsecondsSinceEpoch} ACC: $_accelerometerValue');
            _accelerometerSecondData.add(_accelerometerValue!);
            // log('${DateTime.now().microsecondsSinceEpoch} ACC: ${ _processUserAccData(_accelerometerSecondData)}');
            // var input = _simplify(_accelerometerValue!);
            // log('ACC String: $input');

            // var parser = Parser.run(input);
            // log('Calcs: ${parser.parsedData}');
          });
        },
      ),
    );

    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValue = <double>[event.x, event.y, event.z];
            _userAccelerometerSecondData.add(_userAccelerometerValue!);
            // log('${DateTime.now().microsecondsSinceEpoch} UACC: ${ _processUserAccData(_userAccelerometerSecondData)}');
          });
        },
      ),
    );
  }

  String _processUserAccData(List<List<double>> data) {
    return data.map((e) => e.join(',')).toList().join(';');
  }

  String _simplify(List<double> data) {
    return "${data.join(',')};";
  }

  @override
  Widget build(BuildContext context) {
    final userAccelerometer = _userAccelerometerValue
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    return MaterialApp(
      title: 'Pedometer Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xff003F6E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset(
                  "assets/pohealth_logo.png",
                  height: 80,
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Welcome to the demo of pedometer_flutter, developed by POPULAR HEALTH LLC.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Feel free to contact us at",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "frank@popular.health",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Steps (PD): $_pedometerSteps',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Status (PD): $_pedometerStatus',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'ACC (SP): ${userAccelerometer.toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Steps (SP): $_accStep',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),

                      //Container(height: 50),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
