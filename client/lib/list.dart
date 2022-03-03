import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class Location {
  final String dutyName;
  final dynamic dutyAdd;
  final dynamic dutyTel;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic distance;

  const Location({
    required this.dutyName,
    required this.dutyAdd,
    required this.dutyTel,
    required this.latitude,
    required this.longitude,
    required this.distance
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      dutyName: json['dutyName'],
      dutyAdd : json['dutyAdd'],
      dutyTel : json['dutyTel1'],
      latitude : json['latitude'],
      longitude : json['longitude'],
      distance : json['distance']
    );
  }
}

Future<List<Location>> getLocation(dynamic data) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:9090/api/server/location'));
  List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['response']
      ['body']['items']['item'];
  List<Location> list = [];
  if (response.statusCode == 200) {
    list = data.map((e) => Location.fromJson(e)).toList();

  }
  return list;
}


class _MyListPageState extends State<MyListPage> {
  late Future<List<Location>> futurePlace;

  @override
  void initState() {
    super.initState();
    futurePlace = getLocation("data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('99%'),
      ),
      body: Column(
          children: <Widget>[
            Expanded (
                child: FutureBuilder<List<Location>>(
                  future: futurePlace,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Location location = snapshot.data![index];
                          return Card(
                            child: ListTile(
                              title: Text('${location.dutyName}'),
                              subtitle: Text('${location.dutyTel}'),
                            ),
                          );
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                )),
          ],
        ),
    );
  }
}
