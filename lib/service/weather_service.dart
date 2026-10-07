import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/weather_model.dart';

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;
  final Geocoding _geocoding = Geocoding();

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // Get permission for the user
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the city name
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
