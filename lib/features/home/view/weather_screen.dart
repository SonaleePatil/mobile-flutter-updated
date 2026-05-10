import 'dart:async';
import 'package:adcc/features/home/view/weather_card.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < 2) {
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
    return SizedBox(
      height: 105,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 0),
            child: switch (index) {
              0 => const WeatherCard(
                  city: 'Abu Dhabi',
                  time: '12:22 PM',
                  temperature: 20,
                  highTemp: 28,
                  lowTemp: 21,
                  weatherIcon: 'assets/images/weather_cloud.png',
                ),
              1 => const WeatherAlertCard(
                  city: 'Abu Dhabi',
                  time: '12:22 PM',
                  alertTitle: 'High UV Alert',
                  alertMessage:
                      'UV index very high today (11+). Avoid midday rides, bring water and sunscreen.',
                  alertType: WeatherAlertType.uv,
                ),
              _ => const WeatherAlertCard(
                  city: 'Abu Dhabi',
                  time: '12:22 PM',
                  alertTitle: 'Wind Advisory',
                  alertMessage:
                      'Strong winds expected this evening (25-30 km/h). Ride with caution.',
                  alertType: WeatherAlertType.wind,
                ),
            },
          );
        },
      ),
    );
  }
}
