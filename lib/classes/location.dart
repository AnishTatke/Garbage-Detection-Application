import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class ImageLocation {

  Position location;
  List<Address> addList;

  Future getAddress(Coordinates cords) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(cords);
    addList = addresses;
  }

  Future getLocation() async {
    location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    getAddress(Coordinates(location.latitude, location.longitude));
  }

}