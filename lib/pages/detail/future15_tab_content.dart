import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';

class Future15TabContent extends StatelessWidget {
  final DisplayCity location;
  const Future15TabContent({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('我的内容'));
  }
}