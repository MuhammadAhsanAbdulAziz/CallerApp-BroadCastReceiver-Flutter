import 'package:caller_app/contact_setting_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int groupValue = -1;
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
                    Radio(
                        value: 1, groupValue: groupValue, onChanged: (val) {
                          setState(() {
                            groupValue = val!;
                          });
                        }),
                    const Text(
                      "Accept all",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                InkWell(
                  onTap: (){
                    showDialog(context: context, builder: (context) {
                      return const ContactSettingWidget();
                    },);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: 2, groupValue: groupValue, onChanged: (val) {
                            setState(() {
                              groupValue = val!;
                            });
                          }),
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
                onPressed: () {},
                child: const Text(
                  "Show History",
                  style: TextStyle(color: Colors.white),
                ),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 107, 83, 171))),
              ),
            ))
      ],
    ));
  }
}
