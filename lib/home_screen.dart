import 'package:caller_app/contact_setting_widget.dart';
import 'package:caller_app/data_storage.dart';
import 'package:caller_app/history_screen.dart';
import 'package:caller_app/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int groupValue = 0;
  final dataStorageSP = DataStorageSP();

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
                            groupValue = 1;
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
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const ContactSettingWidget();
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AbsorbPointer(
                        absorbing: true,
                        child: FutureBuilder(
                          future: dataStorageSP.getData("saved"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data == "contacts") {
                              groupValue = 2;
                              return Radio(
                                value: 2,
                                groupValue: groupValue,
                                onChanged: (val) {},
                              );
                            } else {
                              return Radio(
                                value: 2,
                                groupValue: groupValue,
                                onChanged: (val) {},
                              );
                            }
                          },
                        ),
                      ),
                      const Text(
                        "Only my Contacts",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
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
                Navigator.push(context, MaterialPageRoute(builder: (ctx){
                  return HistoryScreen();
                }));
                
              },
              child: const Text(
                "Show History",
                style: TextStyle(color: Colors.white),
              ),
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 107, 83, 171))),
            ),
          ),
        ),
      ],
    ));
  }
}
