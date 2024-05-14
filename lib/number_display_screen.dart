import 'dart:async';
import 'dart:io';

import 'package:caller_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberDisplayScreen extends StatefulWidget {
  const NumberDisplayScreen({super.key, required this.number});

  final String number;

  @override
  State<NumberDisplayScreen> createState() => _NumberDisplayScreenState();
}

class _NumberDisplayScreenState extends State<NumberDisplayScreen> {
  var _androidAppRetain = MethodChannel("android_app_retain");

  @override
  void initState() {
    super.initState();
    
  }
  sendToBackground() async {
    if (Platform.isAndroid) {
      if (Navigator.of(context).canPop()) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
          return HomeScreen();
        }));
        return Future.value(true);
        
      } else {
        _androidAppRetain.invokeMethod("sendToBackground");
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), () {
      sendToBackground();
    });
    return Scaffold(
      body: Center(
        child: Text(
          widget.number,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
