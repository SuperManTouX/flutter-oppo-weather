import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/routes/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '磨叽天气',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      initialRoute: RouteNames.weather,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
