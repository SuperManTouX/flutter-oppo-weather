import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';

class AirQualityTabContent extends StatelessWidget {
  final DisplayCity location;
  const AirQualityTabContent({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('空气质量内容'));
  }
}