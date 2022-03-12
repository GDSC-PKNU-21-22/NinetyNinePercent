import 'package:flutter/material.dart';
import 'package:my_app/list.dart';
import 'package:my_app/location.dart';
import 'package:provider/provider.dart';

import 'location_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LocationModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '99%',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '99%'),
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
  late Future<List<HosLocation>> futurePlace;

  void _fetchLocation(BuildContext context) async {
    futurePlace = postLocation();
    context.read<LocationModel>().list = await futurePlace;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 150),
              child: Text(
                '99%',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Container(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                textStyle: const TextStyle(fontSize: 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: () {
                _fetchLocation(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyListPage(
                              title: '99%',
                            )));
              },
              child: Text('Find'),
            ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
