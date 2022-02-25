import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:my_app/post.dart';
import 'package:geolocator/geolocator.dart';

import 'location.dart';

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
// Future fetchPost() async {
//   // print('fetch');
//   return await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
//
//   // print('${response.body}');
//   // if (response.statusCode==200){
//   //   print(response.body);
//   // }
// }

class Place {
  final bool isolated;
  final String hospitalName;
  final double latitude;
  final double longitude;

  const Place({
    required this.isolated,
    required this.hospitalName,
    required this.latitude,
    required this.longitude
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      isolated: json['isolated'],
      hospitalName: json['hospitalName'],
      latitude: json['latitude'],
      longitude: json['longitude']
    );
  }

}
// Future<List<Place>> fetchPlace() async {
//   final response = await http
//       .get(Uri.parse('http://127.0.0.1:8080/request'));
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     // return Album.fromJson(jsonDecode(response.body));
//     List list = jsonDecode(utf8.decode(response.bodyBytes));
//     var placeList = list.map((e) => Place.fromJson(e)).toList();
//     return placeList;
//     // return Place.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
//   } else {
//
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

Future<List<Place>> postPlace(dynamic data) async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
  }

  _permissionGranted = await location.hasPermission();
//권한 상태를 확인합니다.
  if (_permissionGranted == PermissionStatus.denied) {
    // 권한이 없으면 권한을 요청합니다.
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      // 권한이 없으면 위치정보를 사용할 수 없어 위치정보를 사용하려는 코드에서 에러가 나기때문에 종료합니다.
      // return;
    }
  }


  _locationData = await location.getLocation();
//_locationData에는 위도, 경도, 위치의 정확도, 고도, 속도, 방향 시간등의 정보가 담겨있습니다.

  print('${_locationData.latitude}');
  print('${_locationData.longitude}');
  // Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best);
  dynamic testBody = Location2(_locationData.latitude!, _locationData.longitude!).ToJson();
  // dynamic testBody = '{"latitude": 23.213, "longitude": 43.111}';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final response = await http.post(Uri.parse('http://127.0.0.1:8080/request'), body: json.encode(testBody), headers: headers);

  if (response.statusCode == 200) {
    List list = jsonDecode(utf8.decode(response.bodyBytes));
    var placeList = list.map((e)=>Place.fromJson(e)).toList();

    return placeList;
  } else {
    throw Exception('Failed to load locations');
  }
}
class _MyListPageState extends State<MyListPage> {
  // late Future<Album> futureAlbum;
  late Future<List<Place>> futurePlace;

  @override
  void initState() {
    super.initState();
    futurePlace = postPlace("data");
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
      appBar: AppBar(title: Text('99%'),),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              margin: EdgeInsets.only(bottom: 150),
              child: FutureBuilder<List<Place>>(
                future: futurePlace,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Place place = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text(place.hospitalName),
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
