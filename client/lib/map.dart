import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/location_model.dart';
import 'package:provider/provider.dart';


class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];


  @override
  void initState() {
    super.initState();

    var list = context.read<LocationModel>().list;
    for (int i = 0; i < list.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('$i'),
        onTap: () => print(list[i].dutyName),
        position: LatLng(list[i].latitude, list[i].longitude),
      ));
    }
  }

  // 초기 카메라 위치
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.488132562487905, 127.08515659273706),
    zoom: 14.4746,
  );

  // 호수 위치
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          // target: LatLng(37.488132562487905, 127.08515659273706),
          target: LatLng(context.read<CurrentLocation>().latitude, context.read<CurrentLocation>().longitude),
          zoom: 15.5,
        ), // 초기 카메라 위치
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(_markers),
      ),

      // floatingActionButton을 누르게 되면 _goToTheLake 실행된다.
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}