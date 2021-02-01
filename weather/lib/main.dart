import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      title: 'Weather Today!',
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String typedText;
  var place;
  var temp;
  var humidity;
  var high;
  var low;
  var local;

  Future getData(place) async {
    http.Response source = await http.get(
        'http://api.weatherstack.com/forecast?access_key=a3fd7937c2b651f30024b0cf5a7a3cfe&query=$place');

    var data = jsonDecode(source.body);

    if (data['success'] != false) {
      DateTime now = DateTime.now();
      now = DateTime(now.year, now.month, now.day - 1);
      String date = DateFormat('yyyy-MM-dd').format(now);

      //print(date);
      setState(() {
        temp = data['current']['temperature'];
        humidity = data['current']['humidity'];
        high = data['forecast']['$date']['maxtemp'];
        low = data['forecast']['$date']['mintemp'];
        local = data['location']['localtime'];
        place = place;
      });
    } else {
      setState(() {
        temp = null;
        humidity = null;
        high = null;
        low = null;
        local = null;
        place = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(50),
            tileColor: Colors.black,
            leading: Icon(
              Icons.search,
              color: Colors.blue,
              size: 22.0,
            ),
            title: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                //contentPadding: EdgeInsets.all(),
                hintText: 'Search place here',
              ),
              onChanged: (value) {
                typedText = value;
              },
            ),
            trailing: RaisedButton(
              onPressed: () {
                place = typedText.toUpperCase();
                getData(place);
              },
              color: Colors.blue,
              child: Text('search'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              color: Colors.grey[850],
            ),
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    place != null ? 'Currently in $place' : 'No place found!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    temp != null ? temp.toString() + ' \u2103' : '-',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: Colors.black,
                  leading: Icon(
                    Icons.invert_colors,
                    color: Colors.blue,
                    size: 18.0,
                  ),
                  title: Text(
                    'HUMIDITY',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  trailing: Text(
                    humidity != null ? humidity.toString() : '-',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: Colors.black,
                  leading: Icon(
                    Icons.call_made,
                    color: Colors.blue,
                    size: 18.0,
                  ),
                  title: Text(
                    'HIGH',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  trailing: Text(
                    high != null ? high.toString() + ' \u2103' : '-',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  height: 1,
                  thickness: 1,
                  //indent: 20,
                  //endIndent: 0,
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: Colors.black,
                  leading: Icon(
                    Icons.call_received,
                    color: Colors.blue,
                    size: 18.0,
                  ),
                  title: Text(
                    'LOW',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  trailing: Text(
                    low != null ? low.toString() + ' \u2103' : '-',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  height: 1,
                  thickness: 1,
                  //indent: 20,
                  //endIndent: 0,
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: Colors.black,
                  leading: Icon(
                    Icons.watch_later,
                    color: Colors.blue,
                    size: 18.0,
                  ),
                  title: Text(
                    'LOCAL TIME',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  trailing: Text(
                    local != null ? local.toString() : '-',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  height: 1,
                  thickness: 1,
                  //indent: 20,
                  //endIndent: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
