import 'dart:async';

import 'package:caller_app/data/data_storage.dart';
import 'package:caller_app/screens/number_display_screen.dart';
import 'package:caller_app/screens/permission_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String number = "";
  static const callChannel = EventChannel("CALL_CHANNEL");
  late StreamSubscription _streamSubscription;
  final dataStorageSP = DataStorageSP();

  @override
  void dispose() {
    super.dispose();
    setState(() {
      number = "";
    });
  }

  @override
  void initState() {
    super.initState();
    onStreamCall();
    checkOptions();
  }

  checkOptions() async {
    if (await dataStorageSP.getData("saved") == "") {
      dataStorageSP.saveData("accept", "saved");
    }
  }

  onStreamCall() {
    _streamSubscription = callChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        number = event.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: number.isNotEmpty
          ? NumberDisplayScreen(
              number: number,
            )
          : const PermissionRequestScreen(),
    );
  }
}
