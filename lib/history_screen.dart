import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'my_data_mode.dart'; // Import your DatabaseHelper class

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: FutureBuilder<List<MyDataModel>>(
        future: DatabaseHelper().getAllData(), // Fetch data from the database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item.name!),
                  subtitle: Text('Date: ${item.date}, Time: ${item.time}, State: ${item.state}'),
                  // Customize the ListTile according to your needs
                );
              },
            );
          }
        },
      ),
    );
  }
}
