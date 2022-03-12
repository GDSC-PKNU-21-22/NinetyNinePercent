import 'package:flutter/cupertino.dart';
import 'package:my_app/location.dart';

class LocationModel extends ChangeNotifier {
  List<HosLocation> _list = [];

  List<HosLocation> get list => _list;

  set list(List<HosLocation> value) {
    _list = value;
    for (var o in _list) {
      print('$o');
    }
    notifyListeners();
  }
}

