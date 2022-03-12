class HosLocation {
  final String dutyName;
  final dynamic dutyAdd;
  final dynamic dutyTel;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic distance;

  const HosLocation(
      {required this.dutyName,
        required this.dutyAdd,
        required this.dutyTel,
        required this.latitude,
        required this.longitude,
        required this.distance});

  factory HosLocation.fromJson(Map<String, dynamic> json) {
    return HosLocation(
        dutyName: json['dutyName'],
        dutyAdd: json['dutyAdd'],
        dutyTel: json['dutyTel1'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        distance: json['distance']);
  }
}