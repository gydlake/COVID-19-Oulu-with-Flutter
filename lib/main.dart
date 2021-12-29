// Show the 6 latest confirmed covid-19 in Pohjois-Pohjanmaa (Oulu).
//
// Guoyong Duan, Dec. 28, 2021, Oulu, Finland.

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_covid_oulu/help.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confirmed cases in Oulu',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'Confirmed corona virus in Pohjois-Pohjanmaa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List? data;
  int confirmedNum = 0;
  DateTime? getDate;
  String? latestDate;
  String? jsonText;
  List<String> date5 = List.filled(5, ''); // The 5 dates before latestDate.
  List<int> value5 = List.filled(5, 0); // The 5 values before latestDate.
  final List<int> colorCodes5 = <int>[500, 400, 300, 200, 100];

  Future<String> loadJsonData() async {
    // Load json file from a server.
    http.Response response = await http.get(
        "https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/processedThlData");

    if (response.statusCode == 200) {
      jsonText = response.body; //store response as string

      setState(() =>
      data = json.decode(jsonText!)['confirmed']['Pohjois-Pohjanmaa']);

      for (var i = data!.length - 1; i >= 0; i--) {
        confirmedNum = data![i]['value'];
        if (confirmedNum != 0) {
          getDate = DateTime.parse(data![i]['date']);
          latestDate = DateFormat('dd/MM/yyyy').format(getDate);

          for (var j = 0; j < 5; j++) {
            getDate = DateTime.parse(data![i - j - 1]['date']);
            date5[j] = DateFormat('dd/MM/yyyy').format(getDate);
            value5[j] = data![i - j - 1]['value'];
          }

          break;
        }
      }
      print('The latest date: $latestDate, confirmed number: $confirmedNum');
      return 'success';
    } else {
      print(response.statusCode);
      return 'failed';
    }
  }

  @override
  void initState() {
    super.initState();
    this.loadJsonData();
  }

  // Build the 5 text lines of confirmed numbers before the latest date.
  Widget _buildDate5Item(BuildContext context, int index) {
    return Card(
      child: Container(
        height: 50,
        color: Colors.amber[colorCodes5[index]],
        child: Center(child: Text('${date5[index]}: ${value5[index]}')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Confirmed COVID-19 in Oulu'),
        actions: <Widget>[
          Padding(
            // Information button at appBar.
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Help()),
                ),
                child: Icon(
                  Icons.info,
                  size: 40.0,
                  color: Colors.red,
                ),
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // Show latest date.
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(25.0),
              child: Text(
                "The latest update: $latestDate",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              // Show the confirmed number in latest date.
              child: Text(
                "$confirmedNum",
                style: Theme.of(context).textTheme.headline2,
              ),
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[200],
              ),
            ),
            Flexible(
              // Show 5 confirmed numbers before latest date.
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: value5.length,
                itemBuilder: _buildDate5Item,
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        // Refresh button.
        onPressed: () async {
          await this.loadJsonData();
        },
        tooltip: 'Reload data from the server.',
        child: const Icon(Icons.refresh_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
