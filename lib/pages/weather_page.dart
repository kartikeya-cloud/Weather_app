import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final WeatherService _weatherService = WeatherService(apiKey: '');

  Weather? _weather;

  // Fetch weather
  Future<void> _fetchWeather() async {
    // Get the current city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);

      if (!mounted) return;

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint('Error fetching weather: $e');
    }
  }

  // Initial state
  @override
  void initState() {
    super.initState();

    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(_weather?.city ?? 'Loading city...'),

            // Temperature
            Text('${_weather?.temperature.round()}°C'),
          ],
        ),
      ),
    );
  }
}
