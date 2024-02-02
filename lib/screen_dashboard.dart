import 'package:all_assighment/database/screendashboard.dart';
import 'package:flutter/material.dart';

import 'api/prayer.dart';
import 'hive/home_screen.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({Key? key}) : super(key: key);

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Assighment',
          style: TextStyle(fontFamily: 'YourCustomFont', fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const ApiPrayers()));
              },
              icon: Icon(Icons.api),
              label: Text('API Dashboard'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
                onPrimary: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const SQFSCREEN()));
              },
              icon: Icon(Icons.data_usage),
              label: Text('SQflite Dashboard'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
                onPrimary: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const HomeScreen()));
              },
              icon: Icon(Icons.storage),
              label: Text('HIVE Dashboard'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
