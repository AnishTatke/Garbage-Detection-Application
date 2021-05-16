import 'package:geolocator/geolocator.dart';

class GarbageData{
  final String modelname;
  final String confidence;
  final String label;
  final double longitude;
  final double latitude;
  final DateTime timestamp;
  final String country;
  final String state;
  final String city;
  final String locality;
  final String postalCode;

  GarbageData({this.modelname, this.label, this.confidence, this.longitude, this.latitude, this.timestamp, this.country, this.state, this.city, this.locality, this.postalCode});
}