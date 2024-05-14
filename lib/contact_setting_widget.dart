import 'package:caller_app/data_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContactSettingWidget extends StatefulWidget {
  const ContactSettingWidget({super.key});

  @override
  State<ContactSettingWidget> createState() => _ContactSettingWidgetState();
}

class _ContactSettingWidgetState extends State<ContactSettingWidget> {
  int groupValue = -1;
  bool smsChecked = false;
  final dataStorageSP = DataStorageSP();
  final smsController = TextEditingController();
  void saveChanges() {
    if(groupValue != -1){
      if(groupValue == 1){
        dataStorageSP.saveData("1 hour", "duration");
      }
      else if(groupValue == 2){
        dataStorageSP.saveData("3 hour", "duration");
      }
      else if(groupValue == 3){
        dataStorageSP.saveData("6 hour", "duration");
      }
      else if(groupValue == 4){
        dataStorageSP.saveData("24 hour", "duration");
      }
      else if(groupValue == 5){
        dataStorageSP.saveData("3 day", "duration");
      }
      else if(groupValue == 6){
        dataStorageSP.saveData("7 day", "duration");
      }
      else if(groupValue == 7){
        dataStorageSP.saveData("30 day", "duration");
      }
      dataStorageSP.saveDataBool(smsChecked, "SMS");
      dataStorageSP.saveData(smsController.text.toString(), "message");
      dataStorageSP.saveData("contacts", "saved");
      Navigator.pop(context);
    }
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
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 107, 83, 171))),
                    ),
                    ElevatedButton(
                      onPressed: saveChanges,
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 107, 83, 171))),
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
