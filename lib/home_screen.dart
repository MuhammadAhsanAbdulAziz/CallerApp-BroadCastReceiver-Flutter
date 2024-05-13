import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _streamSubscription;
  String Number = "";
  static const callChannel = EventChannel("CALL_CHANNEL");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onStreamCall();
  }

  onStreamCall() {
    _streamSubscription = callChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        Number = event.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Number,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
