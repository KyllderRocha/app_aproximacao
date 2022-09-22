import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOn = false;
  bool _isNear = false;
  String imagem =
      'https://static-wp-tor15-prd.torcedores.com/wp-content/uploads/2022/09/design-sem-nome-2022-09-08t122851-772-590x393.jpg';
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
      if (!isOn) {
        isOn = true;
        imagem =
            'https://static-wp-tor15-prd.torcedores.com/wp-content/uploads/2022/09/design-sem-nome-2022-09-08t122851-772-590x393.jpg';
        try {
          TorchLight.disableTorch();
        } on Exception catch (_) {
          print('error disabling torch light');
        }
      } else {
        isOn = false;
        Vibration.vibrate(duration: 1000, amplitude: 128);
        imagem = 'https://i.ytimg.com/vi/0AB332nmThs/hqdefault.jpg';
        try {
          TorchLight.enableTorch();
        } on Exception catch (_) {
          print('error enabling torch light');
        }
      }

      // _torchLight();
      // _vibrate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Proximity Sensor Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imagem,
              ),
              Text('Está próximo do sensor: $_isNear')
            ],
          ),
          // child: Text('proximity sensor, is near ?  $_isNear\n'),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           ElevatedButton(
  //             onPressed: _torchLight,
  //             child: const Text('Turn on/off light'),
  //           ),
  //           ElevatedButton(
  //             onPressed: _vibrate,
  //             child: const Text('Vibrate'),
  //           )
  //           //Text('Está próximo do sensor: $isNear')
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _torchLight() async {
    if (!isOn) {
      isOn = true;
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        print('error disabling torch light');
      }
    } else {
      isOn = false;
      try {
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        print('error enabling torch light');
      }
    }
  }

  Future<void> _vibrate() async {
    Vibration.vibrate(duration: 1000, amplitude: 128);
  }
}
