import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = "kolkata";
  String apiKey =
      "2a4880c3445adc24c1e567b474b309f5"; // Replace with your OpenWeatherMap API key
  String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=";

  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final URL = Uri.parse('$apiUrl$city&appid=$apiKey&units=metric');
    final response = await http.get(URL);

    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: weatherData == null
            ? CircularProgressIndicator(
                strokeWidth: 5.0,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'City: ${weatherData?['name']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Temperature: ${weatherData!['main']['temp']} °C',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Weather: ${weatherData!['weather'][0]['description']}',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
      ),
    );
  }
}
