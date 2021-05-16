import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class ImageLocation {

  Position location;
  Address address;

  Future getAddress(Coordinates cords) async {
    var addressList = await Geocoder.local.findAddressesFromCoordinates(cords);
    address = addressList.first;
  }

  Future getLocation() async {
    location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await getAddress(Coordinates(location.latitude, location.longitude));
  }

}