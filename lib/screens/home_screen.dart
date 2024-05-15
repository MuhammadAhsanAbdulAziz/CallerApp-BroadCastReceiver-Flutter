import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:caller_app/widgets/contact_setting_widget.dart';
import 'package:caller_app/data/data_storage.dart';
import 'package:caller_app/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int groupValue = 1;
  final dataStorageSP = DataStorageSP();

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.phone,
      Permission.sms,
    ].request();

    bool permissionsGranted =
        statuses.values.every((status) => status.isGranted);
    if (!(await Permission.systemAlertWindow.isGranted)) {
      openSettings();
    }
    if (!permissionsGranted ||
        !(await Permission.systemAlertWindow.isGranted)) {
      showPermissionDeniedDialog();
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content:
            const Text('Some permissions were denied. The app will close.'),
        actions: [
          TextButton(
            onPressed: () => closeApp(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void openSettings() {
    const intent = AndroidIntent(
      action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
      data: 'package:com.example.caller_app',
    );
    intent.launch();
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Closes the app on Android
    } else if (Platform.isIOS) {
      exit(0); // Use this cautiously on iOS
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: dataStorageSP.getData("saved"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == "accept") {
                          return Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                                dataStorageSP.saveData("accept", "saved");
                              });
                            },
                          );
                        } else {
                          return Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                                dataStorageSP.saveData("accept", "saved");
                              });
                            },
                          );
                        }
                      },
                    ),
                    const Text(
                      "Accept all",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: dataStorageSP.getData("saved"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == "contacts") {
                          return Radio(
                            value: 2,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              dataStorageSP.saveData("contacts", "saved");
                              });
                              
                            },
                          );
                        } else {
                          return Radio(
                            value: 2,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              dataStorageSP.saveData("contacts", "saved");
                              });
                            },
                          );
                        }
                      },
                    ),
                    const Text(
                      "Only my Contacts",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                ElevatedButton(onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ContactSettingWidget();
                      },
                    );
                }, child: Text("settings"))
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const HistoryScreen();
                }));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 107, 83, 171))),
              child: const Text(
                "Show History",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
