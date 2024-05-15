import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:caller_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  State<PermissionRequestScreen> createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.phone,
      Permission.sms,
    ].request();

    bool permissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!permissionsGranted || !(await Permission.systemAlertWindow.isGranted)) {
      showPermissionDeniedDialog();
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
        return const HomeScreen();
      }));
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Some permissions were denied. The app will close.'),
        actions: [
          TextButton(
            onPressed: () => closeApp(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Closes the app on Android
    } else if (Platform.isIOS) {
      exit(0); // Use this cautiously on iOS
    }
  }

  void openSettings() {
    const intent = AndroidIntent(
      action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
      data: 'package:com.example.caller_app',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Request')),
      body: const Center(
        child: Text('Requesting permissions...'),
      ),
    );
  }
}