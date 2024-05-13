import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberDisplayScreen extends StatefulWidget {
  const NumberDisplayScreen({super.key});

  @override
  State<NumberDisplayScreen> createState() => _NumberDisplayScreentate();
}

class _NumberDisplayScreentate extends State<NumberDisplayScreen> {
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
