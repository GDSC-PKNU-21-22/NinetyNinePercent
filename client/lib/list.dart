import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key, required this.title}) : super(key: key);

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

  const Location(
      {required this.dutyName,
      required this.dutyAdd,
      required this.dutyTel,
      required this.latitude,
      required this.longitude,
      required this.distance});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        dutyName: json['dutyName'],
        dutyAdd: json['dutyAdd'],
        dutyTel: json['dutyTel1'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        distance: json['distance']);
  }
}

Future<List<Location>> getLocation() async {
  var position = await _determinePosition();
  print(position);

  final response =
      await http.get(Uri.parse('http://127.0.0.1:9090/api/server/location'));
  List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['response']
      ['body']['items']['item'];
  print(data);
  List<Location> list = [];
  if (response.statusCode == 200) {
    list = data.map((e) => Location.fromJson(e)).toList();
  }
  return list;
}

Future<List<Location>> postLocation() async {
  var position = await _determinePosition();

  final response = await http.post(
      Uri.parse('http://127.0.0.1:9090/api/server/location2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'longitude': position.longitude,
        'latitude': position.latitude
      }));

  List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['response']
      ['body']['items']['item'];
  List<Location> list = [];
  if (response.statusCode == 200) {
    list = data.map((e) => Location.fromJson(e)).toList();
  }
  return list;
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class _MyListPageState extends State<MyListPage> {
  late Future<List<Location>> futurePlace;

  @override
  void initState() {
    super.initState();
    futurePlace = getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('99%'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
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
              return Text('로딩중');
            },
          )),
        ],
      ),
    );
  }
}
