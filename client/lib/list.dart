import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:my_app/location.dart';
import 'package:provider/provider.dart';

import 'location_model.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyListPage> createState() => _MyListPageState();
}

Future<List<HosLocation>> getLocation() async {

  final response =
      await http.get(Uri.parse('http://127.0.0.1:9090/api/server/location'));
  List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['response']
      ['body']['items']['item'];

  List<HosLocation> list = [];
  if (response.statusCode == 200) {
    list = data.map((e) => HosLocation.fromJson(e)).toList();
  }
  return list;
}

Future<List<HosLocation>> postLocation(BuildContext context) async {
  var position = await _determinePosition();

  // print(position);
  context.read<CurrentLocation>().setLocation(position.longitude, position.latitude);

  final response = await http.post(
      Uri.parse('http://127.0.0.1:9090/api/server/location2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'longitude': position.longitude,
        'latitude': position.latitude
      }));

  var ss = response.body;
  print(ss);

  // List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['response']
  //     ['body']['items']['item'];

  List<HosLocation> list = [];

  list.add(const HosLocation(
    longitude: 127.11,
    latitude: 32.22,
    dutyTel: "052-265-1376",
    distance: 3,
    dutyAdd: "수영구 남천동",
    dutyName: '병원1',
  ));
  list.add(const HosLocation(
    longitude: 127.11,
    latitude: 32.22,
    dutyTel: "052-265-1376",
    distance: 3,
    dutyAdd: "수영구 남천동",
    dutyName: '병원2',
  ));
  list.add(const HosLocation(
    longitude: 127.11,
    latitude: 32.22,
    dutyTel: "052-265-1376",
    distance: 3,
    dutyAdd: "수영구 남천동",
    dutyName: '병원3',
  ));
  if (response.statusCode == 200) {
    // list = data.map((e) => HosLocation.fromJson(e)).toList();
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

// class _MyListPageState extends State<MyListPage> {
//   late Future<List<HosLocation>> futurePlace;
//
//   @override
//   void initState() {
//     super.initState();
//     futurePlace = postLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('99%'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//               child: FutureBuilder<List<HosLocation>>(
//             future: futurePlace,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     HosLocation location = snapshot.data![index];
//                     return Card(
//                       child: ListTile(
//                         title: Text('${location.dutyName}'),
//                         subtitle: Text('${location.dutyTel}'),
//                       ),
//                     );
//                   },
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                 );
//               } else if (snapshot.hasError) {
//                 return Text('${snapshot.error}');
//               }
//               return Text('로딩중');
//             },
//           )),
//         ],
//       ),
//     );
//   }
// }

class _MyListPageState extends State<MyListPage> {
  late List<HosLocation> locations;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _post(context);
  }
  void _post(BuildContext context) async {
    locations = await postLocation(context);
    context.read<LocationModel>().list = locations;
  }

  @override
  Widget build(BuildContext context) {
    var watch = context.watch<LocationModel>().list;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('99%'),
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: watch.length,
              itemBuilder: (context, index) {
                HosLocation location = watch[index];
                return Card(
                  child: ListTile(
                    title: Text('${location.dutyName}'),
                    subtitle: Text('${location.dutyTel}'),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
