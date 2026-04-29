import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../constants/country_cuisine_map.dart';

class LocationService {
  Future<String> getCuisineFromLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return CountryCuisineMap.fromCode('');

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return CountryCuisineMap.fromCode('');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return CountryCuisineMap.fromCode('');
      }


      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final isoCode = placemarks.first.isoCountryCode ?? '';
      return CountryCuisineMap.fromCode(isoCode);
    } catch (_) {
      return CountryCuisineMap.fromCode('');
    }
  }
}
