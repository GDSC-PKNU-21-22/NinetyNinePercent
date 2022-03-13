import 'package:flutter/cupertino.dart';
import 'package:my_app/location.dart';

class LocationModel extends ChangeNotifier {
  List<HosLocation> _list = [];

  List<HosLocation> get list => _list;

  set list(List<HosLocation> value) {
    _list = value;
    notifyListeners();
  }
}

class CurrentLocation extends ChangeNotifier {
  double _longitude = 0;
  double _latitude = 0;

  double get latitude => _latitude;

  double get longitude => _longitude;

  void setLocation(double long, double lat) {
    _longitude = long;
    _latitude = lat;
    notifyListeners();
  }
}