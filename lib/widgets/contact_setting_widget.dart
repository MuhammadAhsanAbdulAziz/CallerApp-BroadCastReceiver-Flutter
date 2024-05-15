import 'dart:async';
import 'dart:isolate';

import 'package:caller_app/data/data_storage.dart';
import 'package:flutter/material.dart';

class ContactSettingWidget extends StatefulWidget {
  const ContactSettingWidget({super.key, required this.func});

  final Function func;

  @override
  State<ContactSettingWidget> createState() => _ContactSettingWidgetState();
}

class _ContactSettingWidgetState extends State<ContactSettingWidget> {
  int groupValue = -1;
  bool smsChecked = false;
  final dataStorageSP = DataStorageSP();
  final smsController = TextEditingController();
  late int _countdown;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  late SendPort _sendPort;
  void saveChanges() {
    if (groupValue != -1) {
      if (groupValue == 1) {
        dataStorageSP.saveData("1 hour", "duration");
        dataStorageSP.saveCountdown(3600, "countdown");
      } else if (groupValue == 2) {
        dataStorageSP.saveData("3 hour", "duration");
        dataStorageSP.saveCountdown(10800, "countdown");
      } else if (groupValue == 3) {
        dataStorageSP.saveData("6 hour", "duration");
        dataStorageSP.saveCountdown(21600, "countdown");
      } else if (groupValue == 4) {
        dataStorageSP.saveData("24 hour", "duration");
        dataStorageSP.saveCountdown(86400, "countdown");
      } else if (groupValue == 5) {
        dataStorageSP.saveData("3 day", "duration");
        dataStorageSP.saveCountdown(259200, "countdown");
      } else if (groupValue == 6) {
        dataStorageSP.saveData("7 day", "duration");
        dataStorageSP.saveCountdown(604800, "countdown");
      } else if (groupValue == 7) {
        dataStorageSP.saveData("30 day", "duration");
        dataStorageSP.saveCountdown(2592000, "countdown");
      }
      dataStorageSP.saveDataBool(smsChecked, "SMS");
      dataStorageSP.saveData(smsController.text.toString(), "message");
      dataStorageSP.saveData("contacts", "saved");
      Navigator.pop(context);
      _initializeCountdown();
      widget.func();
    }
  }

  getOptions() async {
    final sms = await dataStorageSP.getDataBool("SMS");
    final smsMessage = await dataStorageSP.getData("message");
    final duration = await dataStorageSP.getData("duration");

    setState(() {
      smsChecked = sms;
      smsController.text = smsMessage;
      if (duration == "1 hour") {
        groupValue = 1;
      } else if (duration == "3 hour") {
        groupValue = 2;
      } else if (duration == "6 hour") {
        groupValue = 3;
      } else if (duration == "24 hour") {
        groupValue = 4;
      } else if (duration == "3 day") {
        groupValue = 5;
      } else if (duration == "7 day") {
        groupValue = 6;
      } else if (duration == "30 day") {
        groupValue = 7;
      }
    });
  }

  void _initializeCountdown() async {
    _countdown =
        await dataStorageSP.getCountdown("countdown"); // Initial countdown time
    if (_countdown > 0) {
      _startCountdown();
    } else {
      // Perform action when countdown reaches zero
      _onCountdownZero();
    }
  }

  void _startCountdown() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_countdownTimer, _receivePort.sendPort);
    _receivePort.listen((message) {
      setState(() {
        _countdown = message as int;
        if (_countdown == 0) {
          // Perform action when countdown reaches zero
          _onCountdownZero();
        }
      });
    });

    // Get sendPort from receivePort
    _sendPort = await _receivePort.first;
    // Send initial countdown value to isolate
    _sendPort.send(_countdown);
  }

  static void _countdownTimer(SendPort sendPort) {
    late int countdown;
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort); // Send sendPort to main isolate

    receivePort.listen((message) {
      if (message is int) {
        countdown = message;
        Timer.periodic(Duration(seconds: 1), (timer) {
          countdown--;
          sendPort.send(countdown);
          if (countdown <= 0) {
            timer.cancel();
          }
        });
      }
    });
  }

  void _onCountdownZero() {
    dataStorageSP.saveData("", "duration");
    dataStorageSP.saveData("accept", "saved");
    dataStorageSP.saveCountdown(0, "countdown");
  }

  @override
  void initState() {
    super.initState();
    getOptions();
  }

  @override
  void dispose() {
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Card(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('1 hour'),
                        leading: Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('3 hour'),
                        leading: Radio(
                            value: 2,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('6 hour'),
                        leading: Radio(
                            value: 3,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('24 hour'),
                        leading: Radio(
                            value: 4,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('3 days'),
                        leading: Radio(
                            value: 5,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('7 days'),
                        leading: Radio(
                            value: 6,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('30 days'),
                        leading: Radio(
                            value: 7,
                            groupValue: groupValue,
                            onChanged: (val) {
                              setState(() {
                                groupValue = val!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                          title: const Text('Send SMS'),
                          leading: Checkbox(
                              value: smsChecked,
                              onChanged: (val) {
                                setState(() {
                                  smsChecked = !smsChecked;
                                });
                              })),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: smsController,
                    onChanged: (value) {
                      setState(() {
                        smsController.text = value;
                      });
                    },
                    cursorColor: Colors.black,
                    maxLines: 3,
                    maxLength: 120,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                      hintText: "Write SMS Message...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 71, 3, 102),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 107, 83, 171))),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: saveChanges,
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 107, 83, 171))),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
