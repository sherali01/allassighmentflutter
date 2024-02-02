import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Models/prayers_models.dart';

class ApiPrayers extends StatefulWidget {
  const ApiPrayers({Key? key}) : super(key: key);

  @override
  State<ApiPrayers> createState() => _ApiPrayersState();
}

class _ApiPrayersState extends State<ApiPrayers> {
  late PrayerModel list;
  static String address = 'Sultanahmet';
  static String city = 'Istanbul';
  static String country = 'Turkey';
  static int method = 2;

  Future<PrayerModel> getPrayerApi() async {
    final response = await http.get(Uri.parse("http://api.aladhan.com/v1/hijriCalendarByAddress/1437/4?address=$address,%20$city,%20$country&method=$method"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      list = PrayerModel.fromJson(data);
      return list;
    } else {
      throw Exception('Failed to load prayer timings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Retry the API call
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getPrayerApi(),
        builder: (BuildContext context, AsyncSnapshot<PrayerModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Retry the API call
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No prayer timings available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (BuildContext context, int index) {
                Datum currentDatum = snapshot.data!.data[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Date: ${currentDatum.date.readable}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Fajr: ${currentDatum.timings.fajr}'),
                              Text('Dhuhr: ${currentDatum.timings.dhuhr}'),
                              Text('Asr: ${currentDatum.timings.asr}'),
                              Text('Maghrib: ${currentDatum.timings.maghrib}'),
                              Text('Isha: ${currentDatum.timings.isha}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
