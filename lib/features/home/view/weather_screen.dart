import 'dart:async';
import 'package:adcc/features/home/view/weather_card.dart';
import 'package:flutter/material.dart';

import 'package:adcc/l10n/app_localizations.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> weatherData = [
    {
      "city": "Abu Dhabi",
      "time": "12:22 PM",
      "temp": 20,
      "high": 28,
      "low": 21,
      "icon": "assets/images/weather_cloud.png"
    },
    {
      "city": "Dubai",
      "time": "01:10 PM",
      "temp": 25,
      "high": 30,
      "low": 22,
      "icon": "assets/images/weather_cloud.png"
    },
    {
      "city": "Sharjah",
      "time": "02:15 PM",
      "temp": 27,
      "high": 32,
      "low": 24,
      "icon": "assets/images/weather_cloud.png"
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {

      if (_currentPage < weatherData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );

    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 120,
      child: PageView.builder(
        controller: _pageController,
        itemCount: weatherData.length,
        itemBuilder: (context, index) {

          final data = weatherData[index];

          return WeatherCard(
            city: data["city"],
            time: data["time"],
            temperature: data["temp"],
            highTemp: data["high"],
            lowTemp: data["low"],
            weatherIcon: data["icon"],
          );
        },
      ),
    );
  }
}