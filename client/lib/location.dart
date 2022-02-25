class Location2 {
  double latitude;
  double longitude;

  Location2(this.latitude, this.longitude);

  Map<String, dynamic> ToJson() =>
      {
        'latitude': latitude,
        'longitude': longitude
      };
}