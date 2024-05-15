import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberDisplayScreen extends StatefulWidget {
  const NumberDisplayScreen({super.key,required this.func,required this.number});

  final Function func;
  final String number;

  @override
  State<NumberDisplayScreen> createState() => _NumberDisplayScreenState();
}

class _NumberDisplayScreenState extends State<NumberDisplayScreen> {

  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), () {
      widget.func();
     SystemNavigator.pop();
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
