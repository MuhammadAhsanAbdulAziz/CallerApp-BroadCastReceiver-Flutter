import 'dart:async';

import 'package:caller_app/data_storage.dart';
import 'package:caller_app/database_helper.dart';
import 'package:caller_app/home_screen.dart';
import 'package:caller_app/my_data_mode.dart';
import 'package:caller_app/notification_service.dart';
import 'package:caller_app/number_display_screen.dart';
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
    // TODO: implement dispose
    super.dispose();
    setState(() {
      number = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalNotificationManager.initialize();
    onStreamCall();
    if (dataStorageSP.getData("saved") == "") {
      dataStorageSP.saveData("accept", "saved");
    }
  }

  onStreamCall() {
    _streamSubscription = callChannel.receiveBroadcastStream().listen((event) {
      sendNotificaitons(event);
      setState(() {
        number = event.toString();
      });
    });
  }

  sendNotificaitons(dynamic event) async {
    MyDataModel data = await DatabaseHelper().getSingleData();
    if (event.toString() == "popup") {
      LocalNotificationManager.showNotification(
          id: 1,
          title: "Declined Phone Call",
          body: "${data.name}\n time: ${data.time}   date: ${data.date}\n SMS : Not Send",
          payload: "payload");
    }
    if (event.toString() == "popupSms") {
      LocalNotificationManager.showNotification(
          id: 1,
          title: "Declined Phone Call",
          body: "${data.name}\n time: ${data.time}   date: ${data.date}\n SMS : Sent",
          payload: "payload");
    }
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
          : const HomeScreen(),
    );
  }
}
